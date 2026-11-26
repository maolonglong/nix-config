---
name: code-review
description: Review a change or PR in this nix-darwin and Home Manager repo for pitfalls that `nix eval` cannot see. Adds repo-specific checks to a generic review.
---

# Code review for this repo

`AGENTS.md` owns commands, the verification matrix, and secrets rules. This skill adds the pitfalls those lack, each pinned to the fix commit that proved it. Most fixes here were defects that a green eval had accepted.

## Steps

1. Read the change, plus the prior fixes in the touched paths: `git log --no-merges --format='%h %s' -- <path>`.
2. Map each changed file to an area below and apply that area's checks.
3. Verify every option and value against the pinned inputs in `flake.lock`, not memory. Read eval warnings in stderr, not just the exit code.
4. Label each finding with its **proof level**:
   - **eval**: `just eval <target>` shows it.
   - **build**: only `just b <target>` shows it.
   - **runtime**: only a live shell or app shows it. Agents do not activate, so report it as unverified and name what the user should observe after `just switch`.
5. Report **blocking** findings apart from **optional** ones. Keep optional ones inside the scope of the change.

Done when every changed file is mapped to an area and every finding carries a proof level.

## Nix contracts

- Home Manager tracks `master`, nix-darwin and nixpkgs track unstable, so options get renamed under you. `4b4277d2` moved ssh `matchBlocks` to `settings`; HM now renames `fileWidgetCommand` to `fileWidget.command`. Confirm each option exists in the pinned source.
- Input branches move together. `2f39abf8` fixed a nix-darwin branch that disagreed with nixpkgs. `agenix` is pinned to its `0.18.0` release tag while `nixpkgs-darwin`, `nix-darwin`, and `home-manager` track unstable/`master`, so flag unintended `ref` changes and any `stateVersion` bump (`system.stateVersion`, HM `stateVersion`).
- `home/base/git.nix` sets `programs.git.enable` with `lib.mkDefault` so `work-mbp` can disable it. A priority change there breaks the work host.

## Multi-host, shared base

- Users differ (`chensl`, `bytedance`, `dev`). Derive paths from `myvars.username`, `config.home.homeDirectory`, or `config.home.profileDirectory`; a literal path went stale in `da99b296`. Do not set `home.username` or `home.homeDirectory` in `home/` (Darwin derives them from `users.users`; Linux sets them in `mkLinuxHome`).
- `work-mbp` disables `programs.git` and `programs.ssh`, so a shared change to either lands on `personal-mba` and `linux-dev` only. Confirm that is intended.
- Per-host expectations (primary user, hostname, git/ssh management, `~/.gitconfig` backup hook scoping, user/home agreement, `mise` package ownership, Atuin/fzf Ctrl-R exclusion, and no `byted`/`bytebm` leak onto non-internal hosts) are asserted in `darwinHosts` / `linuxHomes` checks in `flake.nix` and run by `just c` / `just eval`. A diff that edits an expectation and its host module together needs a reason; one that edits only the assertion is suspect.
- Placement follows `docs/hosts.md` (`home/base/`, `home/darwin/`, `home/linux/`, `hosts/<name>/`); anything internal to the company in `home/` or Darwin-only in `home/base/` is a finding.
- After touching `programs.mise.globalConfig`, evaluate the merged result: `nix eval .#darwinConfigurations.work-mbp.config.home-manager.users.bytedance.programs.mise.globalConfig.tools --json`.

## Runtime-only behavior

- Init order decides who wins. Atuin/fzf Ctrl-R exclusion (`99a15775`) is asserted at eval time; other key bindings still need a manual conflict check (`home/base/zsh.nix` runs at 990 after fzf's 910 and before Atuin's 1000). `fpath` additions need an order below 570 (where HM runs `compinit`; `home/darwin/homebrew.nix` uses 550).
- Home Manager wraps `vim` with `-u <generated vimrc>`, so `~/.vimrc` is never read; Vim settings belong in `programs.vim.extraConfig`.
- Free-form strings pass eval however wrong: Ghostty keys and fonts (`621ecff7`), Starship settings. A named font must come from `modules/darwin/fonts.nix` or a system font.
- macOS defaults can have inverted meaning (`fa702000`, `spans-displays`). Check the semantics of each changed default against Apple's `defaults` behavior.
- `AddressFamily inet` on `github.com` in `hosts/personal-mba/home.nix` keeps VPN fake-IP6 from stalling git (`0518101e`).

## Fetched and derived inputs

- `fetchFromGitHub` pins (delta Catppuccin config, tmux, vimrc): `rev` and `hash` change together, and only a build proves the hash. After a tmux `rev` bump, the build shows whether `.tmux.conf.local.patch` still applies.
- mise keys are backend identifiers Nix never validates (`2f271456`: `npm:pnpm` became `pnpm`). Core runtimes (`node`, `bun`, `pnpm`) are major-pinned (`e2f87dac`); confirm new identifiers with `mise registry`.

## Homebrew

- `cleanup = "zap"` runs on every activation. Deleting or renaming a `brews` or `casks` entry uninstalls the app and its data. Call every removal out as destructive.
- `curl` comes from brew on purpose (comment in `modules/darwin/homebrew.nix`); keep it out of nixpkgs lists.

## Nix daemon and secrets

- `nix.extraOptions` uses `!include` on the agenix token path. `!include` tolerates a missing file, so broken wiring shows up as GitHub rate limits, not an error. The token is owned by the primary user with mode `0400`; nix clients read it as that user and the root daemon can too (`1a221d1c` closed a world-readable `0444`). Flag any loosening of `owner` or `mode`, and any change to `identityPaths` or the include path.
- A new substituter needs its `trusted-public-keys` entry in the same change; without it the cache is silently useless.

## Flake and hooks

- A `flake.lock` hunk inside a non-update change (`008a8231`, `383ee4b0`) is a finding. Lock updates ship alone as `chore(flake)`.
- Hooks live in `preCommitChecks` in `flake.nix`. `typos` runs with `write = true` and edits files in place, so read `git diff` after a failed commit; genuine identifiers go into `.typos.toml`. A hook `language` must match how the tool is installed (`a23b2dec`).
- `.pre-commit-config.yaml` and `result` are ignored symlinks; a staged one is a finding.
