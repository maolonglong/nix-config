import { execFileSync, spawnSync } from 'node:child_process';

export const UPSTREAM_REPOSITORY = 'ryan4yin/nix-config';
export const STATE_BRANCH = 'automation/upstream-watch-state';
export const STATE_FILE = '.upstream-watch-state.json';

export function gitHubAuthArgs(args, token = process.env.GH_TOKEN) {
	if (!token) return args;
	const credential = Buffer.from(`x-access-token:${token}`).toString('base64');
	return ['-c', `http.https://github.com/.extraheader=AUTHORIZATION: basic ${credential}`, ...args];
}

export function runRaw(command, args, options = {}) {
	const output = execFileSync(command, args, {
		encoding: 'utf8',
		stdio: ['pipe', 'pipe', 'pipe'],
		...options,
	});
	return typeof output === 'string' ? output : '';
}

export function run(command, args, options = {}) {
	return runRaw(command, args, options).trim();
}

export function tryRun(command, args, options = {}) {
	const result = spawnSync(command, args, {
		encoding: 'utf8',
		stdio: ['ignore', 'pipe', 'pipe'],
		...options,
	});
	return {
		ok: result.status === 0,
		status: result.status,
		stdout: result.stdout?.trim() ?? '',
		stderr: result.stderr?.trim() ?? '',
	};
}

export function parseAnalysis(value) {
	if (!value || typeof value !== 'object' || Array.isArray(value)) {
		throw new Error('analysis must be an object');
	}
	if (!['irrelevant', 'issue'].includes(value.decision)) {
		throw new Error('analysis has an invalid decision');
	}
	if (typeof value.summary !== 'string' || value.summary.length === 0 || value.summary.length > 1200) {
		throw new Error('analysis has an invalid summary');
	}
	if (!Array.isArray(value.localFiles) || value.localFiles.length > 12 || value.localFiles.some((file) => typeof file !== 'string')) {
		throw new Error('analysis has invalid localFiles');
	}
	if (!['low', 'medium', 'high'].includes(value.confidence)) {
		throw new Error('analysis has an invalid confidence');
	}
	if (value.uncertainty !== undefined && (typeof value.uncertainty !== 'string' || value.uncertainty.length > 800)) {
		throw new Error('analysis has an invalid uncertainty');
	}
	return value;
}

export function sanitizeText(value) {
	return String(value)
		.replaceAll('&', '&amp;')
		.replaceAll('<', '&lt;')
		.replaceAll('>', '&gt;')
		.replaceAll('@', '@\u200b')
		.replace(/#(?=\d)/g, '#\u200b')
		.replace(/https?:\/\/github\.com\//gi, 'github[.]com/');
}

export function inlineCode(value) {
	return `\`${sanitizeText(value).replaceAll('`', 'ˋ').replace(/\s+/g, ' ')}\``;
}

export function markerFor(sha) {
	if (!/^[0-9a-f]{40}$/.test(sha)) throw new Error(`invalid commit SHA: ${sha}`);
	return `<!-- upstream-watch:${sha} -->`;
}

export function sourceUrl(sha) {
	if (!/^[0-9a-f]{40}$/.test(sha)) throw new Error(`invalid commit SHA: ${sha}`);
	return `https://redirect.github.com/${UPSTREAM_REPOSITORY}/commit/${sha}`;
}
