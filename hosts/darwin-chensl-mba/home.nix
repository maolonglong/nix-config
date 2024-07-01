{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
          Hostname ssh.github.com
          Port 443
          User git

      Host git-ssh.chensl.me
          ProxyCommand cloudflared access ssh --hostname %h
    '';
  };
}
