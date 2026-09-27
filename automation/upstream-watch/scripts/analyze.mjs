import { mkdir, rm, writeFile } from 'node:fs/promises';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import {
	fetchFeedback,
	MODEL,
	POLICY_VERSION,
	run,
	STATE_BRANCH,
	STATE_FILE,
	tryRun,
	UPSTREAM_REPOSITORY,
} from './lib.mjs';
import { reviewCommit } from './review.mjs';

const scriptDir = dirname(fileURLToPath(import.meta.url));
const projectDir = resolve(scriptDir, '..');
const repositoryDir = resolve(process.env.GITHUB_WORKSPACE ?? resolve(projectDir, '../..'));
const outputDir = resolve(process.env.UPSTREAM_WATCH_OUTPUT ?? join(repositoryDir, '.upstream-watch-output'));
const upstreamRef = 'refs/remotes/upstream-watch/main';
const stateRef = `refs/remotes/origin/${STATE_BRANCH}`;
const stateRemote = process.env.GITHUB_REPOSITORY
	? `https://github.com/${process.env.GITHUB_REPOSITORY}.git`
	: 'origin';

await rm(outputDir, { recursive: true, force: true });
await mkdir(join(outputDir, 'results'), { recursive: true });

run('git', ['fetch', '--no-tags', 'https://github.com/ryan4yin/nix-config.git', `+refs/heads/main:${upstreamRef}`], { cwd: repositoryDir });
const head = run('git', ['rev-parse', upstreamRef], { cwd: repositoryDir });
const remoteState = tryRun(
	'git',
	['ls-remote', '--heads', stateRemote, `refs/heads/${STATE_BRANCH}`],
	{ cwd: repositoryDir },
);
if (!remoteState.ok) throw new Error(`failed to inspect the state branch: ${remoteState.stderr}`);

let state;
if (remoteState.stdout) {
	run(
		'git',
		['fetch', '--no-tags', stateRemote, `+refs/heads/${STATE_BRANCH}:${stateRef}`],
		{ cwd: repositoryDir },
	);
	const rawState = run('git', ['show', `${stateRef}:${STATE_FILE}`], { cwd: repositoryDir });
	state = JSON.parse(rawState);
}

const manifest = {
	repository: UPSTREAM_REPOSITORY,
	localSha: run('git', ['rev-parse', 'HEAD'], { cwd: repositoryDir }),
	model: MODEL,
	policyVersion: POLICY_VERSION,
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

if (!commits.length) {
	await writeManifest(manifest);
	console.log('No new upstream commits.');
	process.exit(0);
}

const feedback = await fetchFeedback(process.env.GITHUB_REPOSITORY ?? 'maolonglong/nix-config');
await writeFile(join(outputDir, 'feedback.json'), JSON.stringify(feedback, null, 2));
const worktree = join(outputDir, 'worktree');
run('git', ['worktree', 'add', '--detach', worktree, 'HEAD'], { cwd: repositoryDir });

try {
	for (const sha of commits) {
		manifest.outcomes.push(await reviewCommit({
			worktree, sha, outputDir: join(outputDir, 'results'), feedback,
			earlier: manifest.outcomes.map(({ sha, analysis }) => ({ sha, analysis })),
		}));
	}
} finally {
	tryRun('git', ['worktree', 'remove', '--force', worktree], { cwd: repositoryDir });
}

await writeManifest(manifest);
console.log(`Analyzed ${manifest.outcomes.length} upstream commit(s).`);

async function writeManifest(value) {
	await writeFile(join(outputDir, 'manifest.json'), `${JSON.stringify(value, null, 2)}\n`);
}
