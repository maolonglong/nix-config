import assert from 'node:assert/strict';
import { mkdir, mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { fetchFeedback, MODEL, POLICY_VERSION, run, UPSTREAM_REPOSITORY } from './lib.mjs';
import { reviewCommit } from './review.mjs';

const projectDir = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const repositoryDir = resolve(projectDir, '../..');
const outputDir = resolve(process.argv[2] ?? join(tmpdir(), `upstream-watch-replay-${Date.now()}`));
const cases = JSON.parse(await readFile(join(projectDir, 'fixtures/replay.json'), 'utf8'));
if (!process.env.DEEPSEEK_API_KEY) throw new Error('DEEPSEEK_API_KEY is required');
await mkdir(outputDir, { recursive: true });
run('git', ['fetch', '--no-tags', `https://github.com/${UPSTREAM_REPOSITORY}.git`, '+refs/heads/main:refs/remotes/upstream-watch/main'], { cwd: repositoryDir });
const feedback = process.argv[3]
	? JSON.parse(await readFile(resolve(process.argv[3]), 'utf8'))
	: await fetchFeedback('maolonglong/nix-config');
await writeFile(join(outputDir, 'feedback.json'), JSON.stringify(feedback, null, 2));
const scratch = await mkdtemp(join(tmpdir(), 'upstream-watch-replay-'));
const report = {
	model: MODEL, policyVersion: POLICY_VERSION,
	command: `node scripts/replay.mjs ${outputDir} ${join(outputDir, 'feedback.json')}`,
	cases: [],
};

try {
	for (const fixture of cases) {
		// Import only historical ancestors: a worktree would expose future local
		// fixes through refs and the shared object database, leaking the answer.
		const worktree = join(scratch, `checkout-${report.cases.length}`);
		const caseDir = join(outputDir, fixture.name);
		await mkdir(caseDir, { recursive: true });
		await mkdir(worktree);
		run('git', ['init', '--quiet', worktree], { cwd: scratch });
		run('git', ['fetch', '--quiet', '--no-tags', repositoryDir, fixture.localSha], { cwd: worktree });
		run('git', ['checkout', '--quiet', '--detach', 'FETCH_HEAD'], { cwd: worktree });
		run('git', ['fetch', '--quiet', '--no-tags', repositoryDir, fixture.upstreamSha], { cwd: worktree });
		try {
			if (fixture.hiddenLocalSha) {
				assert.throws(() => run('git', ['cat-file', '-e', fixture.hiddenLocalSha], { cwd: worktree }), 'future fix must not be visible');
			}
			const selectedFeedback = feedback.filter((issue) => (fixture.feedbackIssues ?? []).includes(issue.number));
			assert.equal(selectedFeedback.length, (fixture.feedbackIssues ?? []).length, 'required feedback must exist');
			const outcome = await reviewCommit({ worktree, sha: fixture.upstreamSha, outputDir: caseDir, feedback: selectedFeedback });
			assert.equal(run('git', ['status', '--porcelain'], { cwd: worktree }), '', 'analysis must not modify the checkout');
			assert.ok(fixture.expected.includes(outcome.analysis.decision), `expected ${fixture.expected}, received ${outcome.analysis.decision}`);
			if (fixture.duplicateOf) assert.equal(outcome.analysis.duplicateOf, fixture.duplicateOf);
			if (fixture.evidenceFile) assert.ok(outcome.analysis.localFiles.includes(fixture.evidenceFile));
			const manifest = {
				repository: UPSTREAM_REPOSITORY, previousSha: run('git', ['rev-parse', `${fixture.upstreamSha}^`], { cwd: worktree }),
				head: fixture.upstreamSha, baseline: false, diverged: false, outcomes: [outcome],
			};
			await writeFile(join(caseDir, 'manifest.json'), JSON.stringify(manifest, null, 2));
			// No credentials and no executable search path: dry-run cannot invoke gh/git.
			const publication = run(process.execPath, [join(projectDir, 'scripts/publish.mjs')], {
				cwd: caseDir, env: { PATH: '', DRY_RUN: 'true', GITHUB_REPOSITORY: 'maolonglong/nix-config', UPSTREAM_WATCH_OUTPUT: caseDir },
			});
			await writeFile(join(caseDir, 'publish.txt'), publication);
			assert.match(publication, /Dry run: no issue or cursor was created/);
			assert.equal(publication.includes('## Suggested action'), outcome.analysis.decision === 'issue');
			report.cases.push({ ...fixture, passed: true, outcome });
			console.log(`PASS ${fixture.name}`);
		} catch (error) {
			report.cases.push({ ...fixture, passed: false, error: error.message });
			console.error(`FAIL ${fixture.name}: ${error.message}`);
		} finally {
			await rm(worktree, { recursive: true, force: true });
			await writeFile(join(outputDir, 'report.json'), JSON.stringify(report, null, 2));
		}
	}
} finally {
	await rm(scratch, { recursive: true, force: true });
}
const passed = report.cases.filter((result) => result.passed).length;
console.log(`${passed}/${cases.length} replay cases passed; report: ${join(outputDir, 'report.json')}`);
process.exitCode = passed === cases.length ? 0 : 1;
