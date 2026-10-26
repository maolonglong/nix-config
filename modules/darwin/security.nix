{config, ...}: let
  homeDir = config.users.users.${config.system.primaryUser}.home;
in {
  # Distrust the root that signed a compromised eMudhra intermediate.
  # cacert 3.131.1 removed the three emSign roots from certdata.txt, leaving
  # only Comodo AAA Services root (still trusted for emailProtection).
  # nixpkgs blacklists it in the NixOS module (NixOS/nixpkgs#576390, #576347);
  # nix-darwin's default is empty, so the Nix CA bundle on these Macs still
  # trusts it. Drop once nix-darwin or cacert distrusts it by default.
  # Name is the CA label in Mozilla's certdata, as cacert expects.
  security.pki.caCertificateBlacklist = [
    "Comodo AAA Services root"
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
