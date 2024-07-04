{
  config,
  myvars,
  ...
}: let
  inherit (myvars) homeDirectory;
in {
  # https://github.com/LnL7/nix-darwin/blob/master/modules/programs/gnupg.nix
  # try `pkill gpg-agent` if you have issues(such as `no pinentry`)
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  # enable logs for debugging
  launchd.user.agents.gnupg-agent.serviceConfig = {
    StandardErrorPath = "${homeDirectory}/Library/Logs/gnupg-agent.stderr.log";
    StandardOutPath = "${homeDirectory}/Library/Logs/gnupg-agent.stdout.log";
  };

  nix.extraOptions = ''
    !include ${config.age.secrets.nix-access-tokens.path}
  '';
}
