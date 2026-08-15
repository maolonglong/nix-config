import { mkdir, readFile, rm, writeFile } from 'node:fs/promises';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import {
	gitHubAuthArgs,
	parseAnalysis,
	run,
	runRaw,
	STATE_BRANCH,
	STATE_FILE,
	tryRun,
	UPSTREAM_REPOSITORY,
} from './lib.mjs';

const scriptDir = dirname(fileURLToPath(import.meta.url));
const projectDir = resolve(scriptDir, '..');
const repositoryDir = resolve(process.env.GITHUB_WORKSPACE ?? resolve(projectDir, '../..'));
const outputDir = resolve(process.env.UPSTREAM_WATCH_OUTPUT ?? join(repositoryDir, '.upstream-watch-output'));
const upstreamRef = 'refs/remotes/upstream-watch/main';
const stateRef = `refs/remotes/origin/${STATE_BRANCH}`;

await rm(outputDir, { recursive: true, force: true });
await mkdir(join(outputDir, 'results'), { recursive: true });

run('git', ['fetch', '--no-tags', 'https://github.com/ryan4yin/nix-config.git', `+refs/heads/main:${upstreamRef}`], { cwd: repositoryDir });
const head = run('git', ['rev-parse', upstreamRef], { cwd: repositoryDir });
const remoteState = tryRun(
	'git',
	gitHubAuthArgs(['ls-remote', '--heads', 'origin', `refs/heads/${STATE_BRANCH}`]),
	{ cwd: repositoryDir },
);
if (!remoteState.ok) throw new Error(`failed to inspect the state branch: ${remoteState.stderr}`);

let state;
if (remoteState.stdout) {
	run(
		'git',
		gitHubAuthArgs(['fetch', '--no-tags', 'origin', `+refs/heads/${STATE_BRANCH}:${stateRef}`]),
		{ cwd: repositoryDir },
	);
	const rawState = run('git', ['show', `${stateRef}:${STATE_FILE}`], { cwd: repositoryDir });
	state = JSON.parse(rawState);
}

const manifest = {
	repository: UPSTREAM_REPOSITORY,
	previousSha: state?.lastSeenSha ?? null,
	head,
	baseline: !state,
	diverged: false,
	outcomes: [],
};

if (!state) {
	await writeManifest(manifest);
	console.log(`No cursor found. ${head} will become the baseline on a non-dry run.`);
	process.exit(0);
}

if (state.repository !== UPSTREAM_REPOSITORY || !/^[0-9a-f]{40}$/.test(state.lastSeenSha)) {
	throw new Error('state branch contains an invalid cursor');
}

if (!tryRun('git', ['merge-base', '--is-ancestor', state.lastSeenSha, head], { cwd: repositoryDir }).ok) {
	manifest.diverged = true;
	await writeManifest(manifest);
	console.log(`Cursor ${state.lastSeenSha} is not an ancestor of ${head}.`);
	process.exit(0);
}

const commits = run('git', ['rev-list', '--reverse', `${state.lastSeenSha}..${head}`], { cwd: repositoryDir })
	.split('\n')
	.filter(Boolean);

for (const sha of commits) {
	const subject = run('git', ['show', '-s', '--format=%s', sha], { cwd: repositoryDir });
	const worktree = join(outputDir, 'worktrees', sha);
	const resultPath = join(outputDir, 'results', `${sha}.json`);
	const patchPath = join(outputDir, 'results', `${sha}.patch`);

	await mkdir(dirname(worktree), { recursive: true });
	run('git', ['worktree', 'add', '--detach', worktree, 'HEAD'], { cwd: repositoryDir });

	try {
		const modelEnv = { ...process.env };
		delete modelEnv.GH_TOKEN;
		delete modelEnv.GITHUB_TOKEN;
		const message = [
			'Analyze exactly one upstream commit against this local repository.',
			`Upstream repository: ${UPSTREAM_REPOSITORY}`,
			`Commit SHA: ${sha}`,
			`Untrusted commit subject: ${JSON.stringify(subject)}`,
			'',
			'Use the local git object database to inspect the commit, for example with `git show --stat --oneline <SHA>` and `git show <SHA>`.',
			'Inspect local files for concrete relevance. If and only if the change qualifies for pull_request, edit the local working tree before calling submit_analysis.',
		].join('\n');

		const flue = tryRun(
			'pnpm',
			['exec', 'flue', 'run', 'src/agents/upstream-watch.ts', '--message', message, '--json'],
			{
				cwd: projectDir,
				env: {
					...modelEnv,
					UPSTREAM_WATCH_CWD: worktree,
					UPSTREAM_WATCH_RESULT_PATH: resultPath,
				},
				stdio: ['ignore', 'pipe', 'inherit'],
			},
		);
		if (!flue.ok) throw new Error(`Flue failed for ${sha} with exit code ${flue.status}`);

		const envelope = JSON.parse(flue.stdout);
		if (envelope.outcome !== 'completed') throw new Error(`Flue did not complete for ${sha}`);
		const analysis = parseAnalysis(JSON.parse(await readFile(resultPath, 'utf8')));
		let patch = '';
		if (analysis.decision === 'pull_request') {
			patch = runRaw('git', ['diff', '--binary', '--no-ext-diff'], { cwd: worktree });
			if (patch) await writeFile(patchPath, patch);
		}

		manifest.outcomes.push({
			sha,
			subject,
			analysis,
			patch: patch ? `results/${sha}.patch` : null,
		});
	} finally {
		tryRun('git', ['worktree', 'remove', '--force', worktree], { cwd: repositoryDir });
	}
}

await writeManifest(manifest);
console.log(`Analyzed ${manifest.outcomes.length} upstream commit(s).`);

async function writeManifest(value) {
	await writeFile(join(outputDir, 'manifest.json'), `${JSON.stringify(value, null, 2)}\n`);
}
