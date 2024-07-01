{pkgs, ...}: {
  home.packages = with pkgs; [
    qemu
    lima
    mutagen
    docker-client
    docker-credential-helpers
    cloudflared
  ];
}
