import assert from 'node:assert/strict';
import test from 'node:test';
import { gitHubAuthArgs, markerFor, parseAnalysis, parseManifest, selectFeedback, sanitizeText, sourceUrl } from './lib.mjs';

const validAnalysis = {
	decision: 'issue',
	summary: 'Relevant package configuration changed.',
	localFiles: ['home/base/packages.nix'],
	confidence: 'high',
	impact: 'The enabled history widgets compete for Ctrl-R.',
	action: 'Disable the fzf history widget while keeping Atuin enabled.',
};

test('parseAnalysis accepts each decision', () => {
	for (const decision of ['irrelevant', 'defer', 'issue']) {
		assert.equal(parseAnalysis({ ...validAnalysis, decision }).decision, decision);
	}
});

test('parseAnalysis rejects malformed output', () => {
	assert.throws(() => parseAnalysis({ ...validAnalysis, confidence: 'certain' }));
	assert.throws(() => parseAnalysis({ ...validAnalysis, localFiles: 'home/base/packages.nix' }));
	assert.throws(() => parseAnalysis({ ...validAnalysis, decision: 'pull_request' }));
	assert.throws(() => parseAnalysis({ ...validAnalysis, summary: '' }));
	assert.throws(() => parseAnalysis({ ...validAnalysis, localFiles: Array(13).fill('file.nix') }));
});

test('only supported actionable results can become issues', () => {
	for (const change of [
		{ impact: undefined }, { action: '' }, { localFiles: [] },
		{ confidence: 'low' }, { duplicateOf: 9 },
		{ localFiles: ['../private/secret'] }, { localFiles: ['/etc/passwd'] },
	]) {
		assert.throws(() => parseAnalysis({ ...validAnalysis, ...change }));
	}
	assert.equal(parseAnalysis({ ...validAnalysis, decision: 'defer', confidence: 'low' }).decision, 'defer');
	assert.equal(parseAnalysis({ ...validAnalysis, decision: 'irrelevant', duplicateOf: 9 }).duplicateOf, 9);
});

test('feedback includes closed watch issues but excludes PRs and unrelated issues', () => {
	const issue = { number: 9, title: 'Privacy policy', body: `Old analysis\n${markerFor('a'.repeat(40))}`, state: 'closed', state_reason: 'not_planned' };
	assert.deepEqual(selectFeedback([
		issue,
		{ ...issue, number: 10, pull_request: {} },
		{ ...issue, number: 11, body: 'Unrelated' },
	]), [{ number: 9, title: issue.title, body: issue.body, state: 'closed', stateReason: 'not_planned' }]);
});

test('publisher rejects malformed or inconsistent manifests before side effects', () => {
	const manifest = {
		repository: 'ryan4yin/nix-config', previousSha: 'a'.repeat(40), head: 'b'.repeat(40),
		baseline: false, diverged: false,
		outcomes: [{ sha: 'b'.repeat(40), subject: 'Fix history', analysis: validAnalysis }],
	};
	assert.deepEqual(parseManifest(manifest), manifest);
	for (const change of [
		{ repository: 'other/repo' }, { head: '--help' }, { baseline: true },
		{ diverged: true }, { outcomes: [...manifest.outcomes, ...manifest.outcomes] },
		{ outcomes: [{ ...manifest.outcomes[0], analysis: { ...validAnalysis, action: undefined } }] },
	]) assert.throws(() => parseManifest({ ...manifest, ...change }));
});

test('gitHubAuthArgs adds ephemeral HTTPS authentication only when configured', () => {
	assert.deepEqual(gitHubAuthArgs(['fetch'], ''), ['fetch']);
	const args = gitHubAuthArgs(['fetch'], 'test-token');
	assert.deepEqual(args.slice(0, 2), [
		'-c',
		`http.https://github.com/.extraheader=AUTHORIZATION: basic ${Buffer.from('x-access-token:test-token').toString('base64')}`,
	]);
	assert.deepEqual(args.slice(2), ['fetch']);
});

test('rendered text avoids mentions, references, and direct GitHub URLs', () => {
	assert.equal(sanitizeText('@owner fixed #123 at https://github.com/a/b'), '@​owner fixed #​123 at github[.]com/a/b');
	assert.equal(sanitizeText('<script>&'), '&lt;script&gt;&amp;');
	const sha = 'a'.repeat(40);
	assert.equal(markerFor(sha), `<!-- upstream-watch:${sha} -->`);
	assert.equal(sourceUrl(sha), `https://redirect.github.com/ryan4yin/nix-config/commit/${sha}`);
});
