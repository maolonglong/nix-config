import { execFileSync, spawnSync } from 'node:child_process';

export const UPSTREAM_REPOSITORY = 'ryan4yin/nix-config';
export const STATE_BRANCH = 'automation/upstream-watch-state';
export const STATE_FILE = '.upstream-watch-state.json';
export const MODEL = 'deepseek/deepseek-flash';
export const POLICY_VERSION = 3;

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
	if (!['irrelevant', 'defer', 'issue'].includes(value.decision)) {
		throw new Error('analysis has an invalid decision');
	}
	if (typeof value.summary !== 'string' || value.summary.length === 0 || value.summary.length > 1200) {
		throw new Error('analysis has an invalid summary');
	}
	if (!Array.isArray(value.localFiles) || value.localFiles.length > 12 || value.localFiles.some((file) =>
		typeof file !== 'string' || !file || file.startsWith('/') || file.includes('\\') || file.split('/').includes('..'))) {
		throw new Error('analysis has invalid localFiles');
	}
	if (!['low', 'medium', 'high'].includes(value.confidence)) {
		throw new Error('analysis has an invalid confidence');
	}
	if (value.uncertainty !== undefined && (typeof value.uncertainty !== 'string' || value.uncertainty.length > 800)) {
		throw new Error('analysis has an invalid uncertainty');
	}
	for (const field of ['impact', 'action']) {
		if (value[field] !== undefined && (typeof value[field] !== 'string' || !value[field].trim() || value[field].length > 800)) {
			throw new Error(`analysis has an invalid ${field}`);
		}
	}
	if (value.duplicateOf !== undefined && (!Number.isSafeInteger(value.duplicateOf) || value.duplicateOf < 1 || value.decision !== 'irrelevant')) {
		throw new Error('duplicateOf must reference an existing issue on an irrelevant result');
	}
	if (value.decision === 'issue' && (value.confidence !== 'high' || !value.localFiles.length || !value.impact || !value.action)) {
		throw new Error('issue requires high confidence, local evidence, impact, and action');
	}
	return value;
}

export function validateEvidence(analysis, cwd, feedback) {
	if (analysis.duplicateOf && !feedback.some((issue) => issue.number === analysis.duplicateOf)) {
		throw new Error('analysis references an unknown issue');
	}
	for (const file of analysis.localFiles) {
		if (!tryRun('git', ['cat-file', '-e', `HEAD:${file}`], { cwd }).ok) {
			throw new Error(`analysis references a missing local file: ${file}`);
		}
	}
}

export function parseManifest(value) {
	const sha = (s) => typeof s === 'string' && /^[0-9a-f]{40}$/.test(s);
	if (!value || value.repository !== UPSTREAM_REPOSITORY || !sha(value.head)
		|| !(value.previousSha === null || sha(value.previousSha))
		|| typeof value.baseline !== 'boolean' || typeof value.diverged !== 'boolean'
		|| value.baseline !== (value.previousSha === null) || !Array.isArray(value.outcomes)
		|| (value.baseline && value.diverged)
		|| ((value.baseline || value.diverged) && value.outcomes.length)) {
		throw new Error('invalid analysis manifest');
	}
	const seen = new Set();
	for (const outcome of value.outcomes) {
		if (!outcome || !sha(outcome.sha) || seen.has(outcome.sha) || typeof outcome.subject !== 'string' || !outcome.subject.trim()) {
			throw new Error('invalid or duplicate manifest outcome');
		}
		seen.add(outcome.sha);
		parseAnalysis(outcome.analysis);
	}
	return value;
}

export function selectFeedback(issues) {
	return issues.filter((issue) => !issue.pull_request && /<!-- upstream-watch:[0-9a-f]{40} -->/.test(issue.body ?? ''))
		.map(({ number, title, body, state, state_reason }) => ({ number, title, body, state, stateReason: state_reason }));
}

export async function fetchFeedback(repository) {
	if (!/^[\w.-]+\/[\w.-]+$/.test(repository)) throw new Error('invalid local repository');
	const issues = [];
	for (let page = 1; ; page++) {
		const response = await fetch(`https://api.github.com/repos/${repository}/issues?state=all&per_page=100&page=${page}`, {
			headers: { Accept: 'application/vnd.github+json' },
			signal: AbortSignal.timeout(30_000),
		});
		if (!response.ok) throw new Error(`failed to load issue feedback: HTTP ${response.status}`);
		const batch = await response.json();
		issues.push(...selectFeedback(batch));
		if (batch.length < 100) return issues;
	}
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
