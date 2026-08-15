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
	if (!['irrelevant', 'issue', 'pull_request'].includes(value.decision)) {
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

export function evaluatePullRequest({ confidence, nameStatus, numstat, summary }) {
	if (confidence !== 'high') return { ok: false, reason: 'model confidence is not high' };

	const files = nameStatus.filter(Boolean).map((line) => line.split('\t'));
	if (files.length !== 1) return { ok: false, reason: 'patch must modify exactly one file' };
	const [status, file, extra] = files[0];
	if (status !== 'M' || !file || extra) return { ok: false, reason: 'file operations are not allowed' };
	if (!file.endsWith('.nix')) return { ok: false, reason: 'changed file is not a Nix file' };
	if (!(file.startsWith('home/') || file.startsWith('modules/darwin/'))) {
		return { ok: false, reason: 'changed file is outside the allowed directories' };
	}
	if (
		file === 'modules/darwin/secrets.nix' ||
		file === 'flake.nix' ||
		file === 'flake.lock' ||
		file.startsWith('hosts/') ||
		file.startsWith('.github/') ||
		file.startsWith('.agents/') ||
		file.startsWith('automation/')
	) {
		return { ok: false, reason: 'changed file is protected' };
	}

	const stats = numstat.filter(Boolean).map((line) => line.split('\t'));
	if (stats.length !== 1 || stats[0][2] !== file) return { ok: false, reason: 'patch statistics are inconsistent' };
	const additions = Number(stats[0][0]);
	const deletions = Number(stats[0][1]);
	if (!Number.isInteger(additions) || !Number.isInteger(deletions)) {
		return { ok: false, reason: 'binary changes are not allowed' };
	}
	if (additions + deletions > 2) return { ok: false, reason: 'patch changes more than two lines' };
	if (summary.trim()) return { ok: false, reason: 'mode changes are not allowed' };

	return { ok: true, file };
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
