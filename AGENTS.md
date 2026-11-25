# Repository Guidelines

## Project Map

- `flake.nix` exports `darwinConfigurations` (with integrated Home Manager) for macOS hosts and standalone `homeConfigurations` (`dev@x86_64-linux`, `dev@aarch64-linux`) for generic Linux dev servers.
- `hosts/<name>/`: `vars.nix` for identity (`username`, `userfullname`, `useremail`), `default.nix` for Darwin system overrides, `home.nix` for user overrides. `mkDarwin` and `mkLinuxHome` in `flake.nix` assemble hosts from the `darwinHosts` and `linuxHomes` tables.
- Shared modules: `modules/darwin/` for macOS system settings; `home/base/` for cross-platform user settings; `home/darwin/` for macOS-only user modules (`ghostty`, `homebrew`, media packages); `home/linux/` for Linux-only user modules (Nix profile PATH).
- Hosts: `docs/hosts.md` lists how `personal-mba`, `work-mbp`, and `linux-dev` differ and where a setting belongs. Read it before adding a host-specific setting or moving one between `home/` and `hosts/`.

## Commands and Verification

- `just eval <target>` evaluates a target without building or activating it (`personal-mba`, `work-mbp`, `linux-dev-x86_64-linux`, `linux-dev-aarch64-linux`). Defaults by hostname on known Macs (`chensl-mba` -> `personal-mba`, `CRWQCPJC7G` -> `work-mbp`) and to `linux-dev-<arch>-linux` on Linux; unknown Macs require an explicit target.
- `just c` runs `nix flake check --show-trace`: evaluation checks for all Darwin and Linux targets plus pre-commit hooks for Alejandra, deadnix, statix, typos, Taplo, and gitleaks.
- `just b <target>` builds without activation (`darwin-rebuild build` on macOS, `home-manager build` on Linux).
- `just diff <host>` (macOS) builds, then lists package changes against the running system; `just fmt` formats with Alejandra; `just brew-up` (macOS) updates Homebrew explicitly (activation skips `brew update`).
- `nix develop` provides Alejandra, deadnix, nil, statix, Taplo, typos, and installs pre-commit hooks on `aarch64-darwin`, `x86_64-linux`, and `aarch64-linux`.

The flake exports checks, formatter, and dev shell for `aarch64-darwin`, `x86_64-linux`, and `aarch64-linux`. Evaluation requires access to the private `mysecrets` input; report unavailable checks rather than changing inputs to bypass access failures.

- Host-specific Nix changes: evaluate the affected target(s). Shared Nix or flake changes: run `just c` (which evaluates all Darwin hosts, both Linux `homeConfigurations`, and pre-commit hooks); build affected targets when evaluation alone cannot validate the change.
- Documentation-only changes: check the diff and any changed paths or commands; no Nix evaluation or build is required.

## Nix Conventions and Boundaries

- Format Nix with Alejandra (`alejandra` or `nix fmt`); use kebab-case module names and explicit `imports` lists rather than auto-discovery.
- When adding or changing options, verify their contracts against the input sources pinned by `flake.lock`. Consult online documentation as needed; pinned sources take precedence.
- Use the standard `pkgs` argument, supplied by the `nixpkgs-darwin` unstable input.
- Do not update `flake.lock` unless explicitly requested.
- Do not run `darwin-rebuild switch`, `home-manager switch`, or activation commands unless explicitly requested.

## Commit & Pull Request Guidelines

- Use Conventional Commits: `<type>(<scope>): <summary>` — imperative, <= 72 chars, no trailing period. Keep scope identifiers short (`darwin`, `starship`, `flake`).
- **Always write a commit body** explaining the *why* (bullets welcome), not just the *what*.
- Each pull request should describe the host or module touched, list tested commands, and mention any secrets or follow-up actions. Link related issues when available, and add screenshots only for UI-facing tooling changes (e.g., terminal themes).

## Security & Secrets

Never commit raw credentials. Store secrets as agenix `.age` files in the separate `nix-secrets` repository (`mysecrets` input) and wire them through `modules/darwin/secrets.nix`. When changing encrypted secrets, confirm the required keys are available and document recipient or key-distribution follow-up in the PR.

Agents must not read or output decrypted secret files, even when their permissions allow access. Inspect Nix declarations and file metadata instead of following decrypted paths such as `config.age.secrets.*.path` or Nix `!include` targets.

## Cursor Cloud specific instructions

Cloud Agents run on Linux. Nix is installed single-user (this image has no systemd), with flakes enabled. `alejandra`, `nil`, `taplo`, `typos`, `just`, and `gitleaks` are on `PATH`, taken from the `nixpkgs-darwin` revision in `flake.lock`.

`just c`, `just eval <target>`, `just fmt`, and `nix develop` all support `x86_64-linux` and `aarch64-linux` once the private `mysecrets` input is accessible; do not override `mysecrets` to bypass access failures. If `mysecrets` is unavailable in the environment, run the pre-commit tools directly:

- `alejandra --check .`
- `deadnix --fail`
- `statix check`
- `typos`
- `taplo fmt --check`
- `gitleaks detect --source . --redact --no-banner`
