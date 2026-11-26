# Host differences

`personal-mba` and `work-mbp` share `modules/darwin/`, `home/base/`, and
`home/darwin/`: the same system packages, Homebrew formulae and casks, fonts,
macOS defaults, secrets, shell, editor and terminal setup. Generic Linux dev
servers (`linux-dev`) share `home/base/` plus `home/linux/` via standalone
Home Manager (`homeConfigurations`). Everything that differs lives in
`hosts/<name>/`.

| | `personal-mba` | `work-mbp` | `linux-dev` (`dev@x86_64-linux`, `dev@aarch64-linux`) |
| --- | --- | --- | --- |
| Platform | `aarch64-darwin` (`nix-darwin`) | `aarch64-darwin` (`nix-darwin`) | `x86_64-linux` / `aarch64-linux` (standalone HM) |
| User | `chensl` | `bytedance` | `dev` |
| Hostname | `chensl-mba`, also used as computer name and SMB name | `CRWQCPJC7G`, hostname only | Managed by the remote server |
| Git and SSH | Managed by Home Manager (`~/.config/git/local.gitconfig` optional). Signing key stored; commits are not signed unless `-S` is passed. GitHub goes over `ssh.github.com:443` | Not managed; the company setup owns them | Git managed by Home Manager (same optional `~/.config/git/local.gitconfig` include); SSH left to the server |
| Go | `programs.go` with `GOPRIVATE` and China `GOPROXY` mirrors | `go_1_27` as a plain package, `GOPATH` and `GOBIN` exported; `~/Library/Application Support/go/env` is left to the company | `go_1_27` as a plain package, `GOPATH` and `GOBIN` exported |
| mise | Brew-installed; shared tools only | Brew-installed; adds `NPM_CONFIG_REGISTRY` and extra npm CLIs | `pkgs.mise` from nixpkgs; shared tools only |
| `PATH` | Shared entries + Homebrew | Shared entries + Homebrew + `~/.bytebm/bin` | Shared entries + Nix profiles (`home/linux/default.nix`) |

User, hostname (Darwin), the Git/SSH split (including `~/.gitconfig` shadow
protection), `mise` package ownership (Homebrew on Darwin, nixpkgs on Linux),
Atuin/fzf Ctrl-R exclusion, and the absence of internal company references
(`byted`/`bytebm`) across session env/PATH, packages, `mise`, zsh, direnv, git,
and ssh on non-internal hosts (`personal-mba` and `linux-dev`) are asserted in
`flake.nix`, so `just c` or `just eval <target>` fails if they drift. The rest
of the table is kept by hand; `hosts/<name>/home.nix` is the source of truth.

## Where a setting goes

- Default to the shared directories:
  - `modules/darwin/` for macOS system settings
  - `home/base/` for cross-platform user settings
  - `home/darwin/` for macOS-only user modules (`ghostty`, `homebrew`, media packages)
  - `home/linux/` for Linux-only user modules (Nix profile PATH)
- Put it in `hosts/<name>/` only when one machine needs it or must not have
  it. For `work-mbp` that means anything the company owns or that names an
  internal registry, tool or path: nothing internal enters `home/`.
- A setting that is a value difference (`programs.mise.globalConfig`,
  `home.sessionPath`) is added from the host or platform module and merges with
  the shared one; do not copy the shared list into the host.
- Adding a host means a `hosts/<name>/` directory, an entry in `darwinHosts`
  or `linuxHomes` in `flake.nix`, and (for known Macs) a `default_host` mapping
  in `justfile`.
