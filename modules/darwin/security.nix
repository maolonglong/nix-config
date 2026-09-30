{config, ...}: let
  homeDir = config.users.users.${config.system.primaryUser}.home;
in {
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    # Let Touch ID work inside tmux/zellij.
    reattach = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  launchd.user.agents.gnupg-agent.serviceConfig = {
    StandardErrorPath = "${homeDir}/Library/Logs/gnupg-agent.stderr.log";
    StandardOutPath = "${homeDir}/Library/Logs/gnupg-agent.stdout.log";
  };
}
