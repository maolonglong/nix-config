{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.jump;
  jumpCmd = "${config.home.profileDirectory}/bin/jump";
in {
  options.programs.jump = {
    enable = mkEnableOption "jump";

    package = mkOption {
      type = types.package;
      default = pkgs.jump;
      defaultText = literalExpression "pkgs.jump";
      description = "The package to use for the jump binary.";
    };

    bind = mkOption {
      type = types.str;
      default = "j";
      description = ''
        Bind jump to custom name
      '';
      example = "z";
    };

    enableZshIntegration =
      mkEnableOption "Zsh integration"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    programs.zsh.initExtra = mkIf cfg.enableZshIntegration ''
      eval "$(jump shell --bind=${cfg.bind})"
    '';
  };
}
