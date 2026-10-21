{config, ...}: let
  homeDir = config.users.users.${config.system.primaryUser}.home;
in {
  # Distrust the roots that signed the compromised eMudhra intermediates.
  # nixpkgs only blacklists them in the NixOS module (NixOS/nixpkgs#576390);
  # nix-darwin's default is empty, so the Nix CA bundle on these Macs still
  # trusts them. Drop once nix-darwin or cacert distrusts them by default.
  # Names are the CA labels in Mozilla's certdata, as cacert expects.
  security.pki.caCertificateBlacklist = [
    "Comodo AAA Services root"
    "emSign ECC Root CA - G3"
    "emSign Root CA - C1"
    "emSign ECC Root CA - C3"
  ];

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
