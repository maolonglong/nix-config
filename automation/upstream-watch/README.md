# Upstream watch

A [Flue](https://flueframework.com) agent that reviews new commits from
`ryan4yin/nix-config` for relevance to this repository.

## Setup

```sh
pnpm install --frozen-lockfile
```

Add `DEEPSEEK_API_KEY` to `.env` for local agent runs. GitHub Actions reads the
same name from an Actions secret.

## Commands

```sh
pnpm run check:types
pnpm test
```

The daily workflow runs `scripts/analyze.mjs` in a read-only GitHub job and
`scripts/publish.mjs` in a separate job that can create issues and update the
cursor branch. The agent returns a validated JSON decision; it never creates
patches, pull requests, or GitHub issues. Manual runs are dry-run by default.

## Required repository settings

- Add the `DEEPSEEK_API_KEY` Actions secret.

Run the workflow once with `dry_run` disabled to establish the current upstream
HEAD as the baseline. The first publishing run does not backfill older commits.
