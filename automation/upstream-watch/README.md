# Upstream watch

A [Flue](https://flueframework.com) agent that reviews new commits from
`ryan4yin/nix-config` for relevance to this repository.

## Setup

```sh
pnpm install --frozen-lockfile
```

Export `DEEPSEEK_API_KEY` for local runs. Alternatively, use Node's
`--env-file=.env` option when running the scripts. GitHub Actions reads the
same name from an Actions secret. The model is DeepSeek V4.1 Flash through the
official `deepseek-flash` API ID. Flue's pinned Pi catalog predates that ID,
so the agent registers it using the supported provider API.

## Commands

```sh
pnpm run check:types
pnpm test
```

The daily workflow runs `scripts/analyze.mjs` in a read-only GitHub job and
`scripts/publish.mjs` in a separate job that can create issues and update the
cursor branch. The agent returns a validated JSON decision; it never creates
patches, pull requests, or GitHub issues. Manual runs are dry-run by default.

Only high-confidence findings with concrete local impact, an action, and
existing local file evidence may create issues. No-ops, inactive integrations,
personal preferences, and upstream tool-roster changes do not qualify. Removing
competing ownership or initialization-order dependencies can still be worthwhile
without a reproduced failure. Missing evidence produces `defer`, retained without an
issue; a successful scan still advances the cursor and does not automatically
retry deferred commits.

The deterministic scanner fetches public watch issues anonymously, including
closed issues and their closure reasons. The agent uses this untrusted history
and earlier decisions in the same batch to avoid repeating the same action
across commits. A `not_planned` closure is a preference signal, not a permanent
ban on reporting a new defect. Semantic deduplication is model-assisted; exact
commit retries remain deduplicated deterministically by their SHA marker.

Each analysis has a five-minute cooperative model deadline and a six-minute
process timeout. GitHub Actions retains results, input snapshots, logs, model
and policy versions, elapsed time, and token usage for 14 days, even on failure.
Reported costs use peak catalog rates and are estimates, not billing receipts.

## Live historical replay

From this directory, with the API key exported and full local Git history:

```sh
node scripts/replay.mjs /tmp/upstream-watch-replay
```

This spends model tokens. It fetches public upstream Git objects and issue
feedback, checks out the local revisions in `fixtures/replay.json` into
independent disposable checkouts containing only their historical ancestors,
and runs the same reviewer as the daily scan. Future fixes and expectations
are not supplied to the model. The fixtures cover a useful change before/after
its fix, historical noise, inactive integrations, and declined follow-ups.
Feedback is intentionally absent in classification cases to avoid leaking their
own previously published verdicts; the feedback case supplies only issue 9.

The output contains `report.json`, exact input snapshots, analysis, usage, logs,
and dry-run issue previews. Publishing runs without credentials or `gh`/`git`
on PATH. No issues or remote cursor are changed. A nonzero exit means at least
one expectation or execution failed; inspect the report rather than counting
every non-issue as success. Model results can vary between runs.

To repeat with the same issue feedback instead of fetching its current state:

```sh
node scripts/replay.mjs /tmp/upstream-watch-repeat /tmp/upstream-watch-replay/feedback.json
```

## Required repository settings

- Add the `DEEPSEEK_API_KEY` Actions secret.

Run the workflow once with `dry_run` disabled to establish the current upstream
HEAD as the baseline. The first publishing run does not backfill older commits.
