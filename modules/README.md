# modules/

本目录存放系统级模块：

- darwin/: 针对 macOS 的 nix-darwin 模块（apps/fonts/nix-core/system/security/users 等）。
- nixos/: 针对 NixOS 的系统模块（nix/i18n 等）。
- base.nix: 平台通用基础设置（镜像、缓存、通用选项），被 darwin/nixos 汇入。

约定与集成：

- flake.nix 通过 lib.scanPaths 自动导入子模块；将新 .nix 文件放入相应文件夹即可。
- specialArgs 可用：inputs、mylib、myvars、pkgs-unstable（需新包时用它）。

开发提示：

- 将平台无关逻辑放在 modules/base/；平台差异放在 darwin/ 或 nixos/ 下。
- 变更后在 macOS 上使用 `darwin-rebuild switch --flake .#work` 或 `.#chensl-mba`，NixOS 用 `nixos-rebuild switch --flake .#nixos` 应用。
- 涉及密钥/agenix 的模块需确保目标机有 /etc/ssh/ssh_host_ed25519_key 与私库密文。
