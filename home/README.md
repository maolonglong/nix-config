# home/

Home Manager 配置集合：

- base/: OS 无关模块；按层次拆分 core/gui/tui。
- darwin/: macOS 相关 HM 模块（如 homebrew/、ghostty/、alacritty/ 等）。
- linux/: Linux 平台特定 HM 模块。

约定与实践：

- 顶层与各层级 default.nix 多使用 mylib.scanPaths 自动导入；新增功能只需放置 .nix 文件。
- 如需较新软件，模块入参可使用 pkgs-unstable（由 specialArgs 注入）。
- 主机特定覆盖在 hosts/*/home.nix 里完成，避免在 base/ 中写死主机差异。
- 应用：`darwin-rebuild switch --flake .#work` 或 `.#chensl-mba`；Linux/NixOS 使用 `nixos-rebuild switch --flake .#nixos`。
- 涉及 secrets/ 与 agenix 的条目需确保目标机密钥就绪；不要全局启用被某些主机刻意禁用的模块。
