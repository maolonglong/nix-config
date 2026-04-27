{pkgs, ...}: {
  home.packages = with pkgs; [
    mutagen
    docker-client
    docker-credential-helpers
    cloudflared
  ];
}
