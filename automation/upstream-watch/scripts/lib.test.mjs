import assert from 'node:assert/strict';
import test from 'node:test';
import { evaluatePullRequest, gitHubAuthArgs, markerFor, parseAnalysis, sanitizeText, sourceUrl } from './lib.mjs';

const validAnalysis = {
	decision: 'issue',
	summary: 'Relevant package configuration changed.',
	localFiles: ['home/base/packages.nix'],
	confidence: 'medium',
};

test('parseAnalysis accepts each decision', () => {
	for (const decision of ['irrelevant', 'issue', 'pull_request']) {
		assert.equal(parseAnalysis({ ...validAnalysis, decision }).decision, decision);
	}
});

test('parseAnalysis rejects malformed output', () => {
	assert.throws(() => parseAnalysis({ ...validAnalysis, confidence: 'certain' }));
	assert.throws(() => parseAnalysis({ ...validAnalysis, localFiles: 'home/base/packages.nix' }));
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

test('PR gate accepts one high-confidence two-line Nix modification', () => {
	assert.deepEqual(
		evaluatePullRequest({
			confidence: 'high',
			nameStatus: ['M\thome/base/packages.nix'],
			numstat: ['1\t1\thome/base/packages.nix'],
			summary: '',
		}),
		{ ok: true, file: 'home/base/packages.nix' },
	);
});

test('PR gate rejects risky patches', () => {
	const base = {
		confidence: 'high',
		nameStatus: ['M\thome/base/packages.nix'],
		numstat: ['1\t1\thome/base/packages.nix'],
		summary: '',
	};
	assert.equal(evaluatePullRequest({ ...base, confidence: 'medium' }).ok, false);
	assert.equal(evaluatePullRequest({ ...base, nameStatus: ['A\thome/base/new.nix'] }).ok, false);
	assert.equal(evaluatePullRequest({ ...base, nameStatus: ['M\tflake.nix'], numstat: ['1\t1\tflake.nix'] }).ok, false);
	assert.equal(evaluatePullRequest({ ...base, numstat: ['2\t1\thome/base/packages.nix'] }).ok, false);
	assert.equal(evaluatePullRequest({ ...base, numstat: ['-\t-\thome/base/packages.nix'] }).ok, false);
	assert.equal(
		evaluatePullRequest({
			...base,
			nameStatus: ['M\thome/base/packages.nix', 'M\thome/base/shell.nix'],
		}).ok,
		false,
	);
});

test('rendered text avoids mentions, references, and direct GitHub URLs', () => {
	assert.equal(sanitizeText('@owner fixed #123 at https://github.com/a/b'), '@​owner fixed #​123 at github[.]com/a/b');
	assert.equal(sanitizeText('<script>&'), '&lt;script&gt;&amp;');
	const sha = 'a'.repeat(40);
	assert.equal(markerFor(sha), `<!-- upstream-watch:${sha} -->`);
	assert.equal(sourceUrl(sha), `https://redirect.github.com/ryan4yin/nix-config/commit/${sha}`);
});
