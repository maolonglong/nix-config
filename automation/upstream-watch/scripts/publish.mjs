import { readFile, writeFile } from 'node:fs/promises';
import { join, resolve } from 'node:path';
import {
	gitHubAuthArgs,
	inlineCode,
	markerFor,
	run,
	sanitizeText,
	sourceUrl,
	STATE_BRANCH,
	STATE_FILE,
	tryRun,
} from './lib.mjs';

const repositoryDir = resolve(process.env.GITHUB_WORKSPACE ?? '.');
const outputDir = resolve(process.env.UPSTREAM_WATCH_OUTPUT ?? join(repositoryDir, '.upstream-watch-output'));
const repository = process.env.GITHUB_REPOSITORY;
const dryRun = process.env.DRY_RUN === 'true';
if (!repository) throw new Error('GITHUB_REPOSITORY is required');

const manifest = JSON.parse(await readFile(join(outputDir, 'manifest.json'), 'utf8'));

if (dryRun) {
	console.log(JSON.stringify(manifest, null, 2));
	console.log('Dry run: no issue or cursor was created.');
	process.exit(0);
}

if (manifest.diverged) {
	const marker = `<!-- upstream-watch:cursor-diverged:${manifest.previousSha} -->`;
	if (!hasPublished(marker)) {
		await createIssue(
			'[upstream-watch] Cursor no longer exists in upstream history',
			[
				'The stored upstream cursor is no longer an ancestor of the current upstream branch.',
				'',
				`Stored cursor: ${inlineCode(manifest.previousSha)}`,
				`Current head: ${inlineCode(manifest.head)}`,
				'',
				'Update or recreate the state branch after reviewing the upstream history rewrite.',
				'',
				marker,
			].join('\n'),
		);
	}
	process.exit(0);
}

for (const outcome of manifest.outcomes) {
	const marker = markerFor(outcome.sha);
	if (outcome.analysis.decision === 'irrelevant' || hasPublished(marker)) continue;
	await createIssue(issueTitle(outcome), issueBody(outcome, marker));
}

await updateCursor(manifest.head);

function hasPublished(marker) {
	const result = tryRun('gh', [
		'api',
		'--paginate',
		`repos/${repository}/issues?state=all&per_page=100`,
		'--jq',
		`.[] | select((.body // "") | contains(${JSON.stringify(marker)})) | .number`,
	]);
	if (!result.ok) throw new Error(`failed to query existing issues: ${result.stderr}`);
	return Boolean(result.stdout);
}

async function createIssue(title, body) {
	const bodyFile = join(outputDir, 'issue-body.md');
	await writeFile(bodyFile, body);
	run('gh', ['issue', 'create', '--repo', repository, '--title', title, '--body-file', bodyFile], { stdio: 'inherit' });
}

function issueTitle(outcome) {
	return `[upstream] ${sanitizeText(outcome.subject)}`.replace(/\s+/g, ' ').slice(0, 240);
}

function issueBody(outcome, marker) {
	const uncertainty = outcome.analysis.uncertainty
		? `\n\n## Uncertainty\n\n${sanitizeText(outcome.analysis.uncertainty)}`
		: '';
	return `An upstream change appears relevant to this repository and needs review.

## Upstream change

- Source: ${sourceUrl(outcome.sha)}
- Commit: ${inlineCode(outcome.sha)}
- Subject: ${inlineCode(outcome.subject)}

## Analysis

${sanitizeText(outcome.analysis.summary)}

## Local evidence

${formatFiles(outcome.analysis.localFiles)}

Confidence: ${inlineCode(outcome.analysis.confidence)}${uncertainty}

${marker}
`;
}

function formatFiles(files) {
	return files.length ? files.map((file) => `- ${inlineCode(file)}`).join('\n') : '- No specific local file recorded.';
}

async function updateCursor(head) {
	run('git', ['config', 'user.name', 'github-actions[bot]'], { cwd: repositoryDir });
	run('git', ['config', 'user.email', '41898282+github-actions[bot]@users.noreply.github.com'], { cwd: repositoryDir });
	const state = `${JSON.stringify({
		repository: manifest.repository,
		lastSeenSha: head,
		updatedAt: new Date().toISOString(),
	}, null, 2)}\n`;
	const temporaryFile = join(outputDir, STATE_FILE);
	await writeFile(temporaryFile, state);
	const blob = run('git', ['hash-object', '-w', temporaryFile], { cwd: repositoryDir });
	const tree = run('git', ['mktree'], {
		cwd: repositoryDir,
		input: `100644 blob ${blob}\t${STATE_FILE}\n`,
	});
	const current = tryRun(
		'git',
		gitHubAuthArgs(['ls-remote', '--heads', 'origin', `refs/heads/${STATE_BRANCH}`]),
		{ cwd: repositoryDir },
	);
	if (!current.ok) throw new Error('failed to inspect the state branch');
	const parent = current.stdout.split(/\s+/)[0];
	if (parent) {
		run(
			'git',
			gitHubAuthArgs([
				'fetch',
				'--no-tags',
				'origin',
				`+refs/heads/${STATE_BRANCH}:refs/remotes/origin/${STATE_BRANCH}`,
			]),
			{ cwd: repositoryDir },
		);
	}
	const commitArgs = ['commit-tree', tree, '-m', `chore: update upstream cursor to ${head.slice(0, 12)}`];
	if (parent) commitArgs.push('-p', parent);
	const commit = run('git', commitArgs, { cwd: repositoryDir });
	const pushArgs = ['push'];
	if (parent) pushArgs.push(`--force-with-lease=refs/heads/${STATE_BRANCH}:${parent}`);
	pushArgs.push('origin', `${commit}:refs/heads/${STATE_BRANCH}`);
	run('git', gitHubAuthArgs(pushArgs), { cwd: repositoryDir, stdio: 'inherit' });
}
