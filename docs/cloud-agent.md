# Cloud Agent Environment

Applies when running in Cursor Cloud (Linux) or any environment without SSH access to the private `mysecrets` input.

## Environment

- Nix is installed single-user (no systemd) with flakes enabled.
- `alejandra`, `nil`, `taplo`, `typos`, `just`, and `gitleaks` are pre-installed on `PATH` from the `nixpkgs-darwin` revision in `flake.lock`.
- Once `mysecrets` is accessible, `just c`, `just eval <target>`, `just fmt`, and `nix develop` all work on `x86_64-linux` and `aarch64-linux`.

## Fallback Checks Without `mysecrets`

Report that Nix evaluation checks are unavailable instead of overriding or stripping `mysecrets`. Run the pre-commit linters directly (and `deadnix` / `statix` when installed):

```sh
alejandra --check .
deadnix --fail
statix check
typos
taplo fmt --check
gitleaks detect --source . --redact --no-banner
```
