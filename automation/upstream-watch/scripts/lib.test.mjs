import assert from 'node:assert/strict';
import test from 'node:test';
import { gitHubAuthArgs, markerFor, parseAnalysis, sanitizeText, sourceUrl } from './lib.mjs';

const validAnalysis = {
	decision: 'issue',
	summary: 'Relevant package configuration changed.',
	localFiles: ['home/base/packages.nix'],
	confidence: 'medium',
};

test('parseAnalysis accepts each decision', () => {
	for (const decision of ['irrelevant', 'issue']) {
		assert.equal(parseAnalysis({ ...validAnalysis, decision }).decision, decision);
	}
});

test('parseAnalysis rejects malformed output', () => {
	assert.throws(() => parseAnalysis({ ...validAnalysis, confidence: 'certain' }));
	assert.throws(() => parseAnalysis({ ...validAnalysis, localFiles: 'home/base/packages.nix' }));
	assert.throws(() => parseAnalysis({ ...validAnalysis, decision: 'pull_request' }));
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
