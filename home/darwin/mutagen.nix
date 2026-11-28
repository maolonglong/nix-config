{pkgs, ...}: {
  launchd.agents.mutagen = {
    enable = true;
    config = {
      Label = "org.nix-community.home.mutagen";
      ProgramArguments = [
        "${pkgs.mutagen}/bin/mutagen"
        "daemon"
        "run"
      ];
      EnvironmentVariables = {
        PATH = "/usr/bin:/bin:/usr/sbin:/sbin";
      };
      RunAtLoad = true;
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
      ProcessType = "Background";
    };
  };
}
