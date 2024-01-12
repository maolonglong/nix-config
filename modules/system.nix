{...}: {
  system = {
    defaults = {
      NSGlobalDomain = {
        # https://github.com/VSCodeVim/Vim#mac
        ApplePressAndHoldEnabled = false;
      };
    };
  };

  security.pam.enableSudoTouchIdAuth = true;
}
