# Host differences

`personal-mba` and `work-mbp` share `modules/darwin/` and `home/`: the same
system packages, Homebrew formulae and casks, fonts, macOS defaults, secrets,
shell, editor and terminal setup. Everything that differs lives in
`hosts/<name>/`.

| | `personal-mba` | `work-mbp` |
| --- | --- | --- |
| User | `chensl` | `bytedance` |
| Hostname | `chensl-mba`, also used as computer name and SMB name | `QNR3WWC3PW`, hostname only |
| Git and SSH | Managed by Home Manager: signing key, and GitHub over `ssh.github.com:443` | Not managed; the company setup owns them |
| Go | `programs.go` with `GOPRIVATE` and China `GOPROXY` mirrors | `go_1_25` as a plain package, `GOPATH` and `GOBIN` exported; `~/Library/Application Support/go/env` is left to the company |
| mise | Shared tools only | Adds `NPM_CONFIG_REGISTRY=http://bnpm.byted.org` and six extra npm CLIs |
| `PATH` | Shared entries | Also `~/.bytebm/bin` |

Hostname and the Git/SSH split are asserted per host in `flake.nix`, so
`just c` or `just eval <host>` fails if they drift. The rest of the table is
kept by hand; `hosts/<name>/home.nix` is the source of truth.
