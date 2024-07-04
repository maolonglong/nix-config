{pkgs, ...}:
###################################################################################
#
#  macOS's System configuration
#
#  All the configuration options are documented here:
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#  Incomplete list of macOS `defaults` commands :
#    https://github.com/yannbertrand/macos-defaults
#
#
# NOTE: Some options are not supported by nix-darwin directly, manually set them:
#   1. To avoid conflicts with neovim, disable ctrl + up/down/left/right to switch spaces in:
#     [System Preferences] -> [Keyboard] -> [Keyboard Shortcuts] -> [Mission Control]
#   2. Disable use Caps Lock as 中/英 switch in:
#     [System Preferences] -> [Keyboard] -> [Input Sources] -> [Edit] -> [Use 中/英 key to switch ] -> [Disable]
###################################################################################
{
  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  time.timeZone = "Asia/Shanghai";

  system = {
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      menuExtraClock.Show24Hour = true; # show 24 hour clock

      # customize dock
      # dock = {
      #   autohide = true; # automatically hide and show the dock
      #   show-recents = false; # do not show recent apps in dock
      #   # do not automatically rearrange spaces based on most recent use.
      #   mru-spaces = false;

      #   # customize Hot Corners(触发角, 鼠标移动到屏幕角落时触发的动作)
      #   wvous-tl-corner = 2; # top-left - Mission Control
      #   wvous-tr-corner = 4; # top-right - Desktop
      #   wvous-bl-corner = 3; # bottom-left - Application Windows
      #   wvous-br-corner = 13; # bottom-right - Lock Screen
      # };

      # customize finder
      finder = {
        # _FXShowPosixPathInTitle = true; # show full path in finder title
        AppleShowAllExtensions = true; # show all file extensions
        FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
        # QuitMenuItem = true; # enable quit menu item
        ShowPathbar = true; # show path bar
        # ShowStatusBar = true; # show status bar
      };

      # customize trackpad
      trackpad = {
        # tap - 轻触触摸板, click - 点击触摸板
        Clicking = true; # enable tap to click(轻触触摸板相当于点击)
        TrackpadRightClick = true; # enable two finger right click
        TrackpadThreeFingerDrag = true; # enable three finger drag
      };

      # customize macOS
      NSGlobalDomain = {
        ApplePressAndHoldEnabled = true; # enable press and hold
      };

      # customize settings that not supported by nix-darwin directly
      # Incomplete list of macOS `defaults` commands :
      #   https://github.com/yannbertrand/macos-defaults
      CustomUserPreferences = {
        # ".GlobalPreferences" = {
        #   # automatically switch to a new space when switching to the application
        #   AppleSpacesSwitchOnActivate = true;
        # };
        # NSGlobalDomain = {
        #   # Add a context menu item for showing the Web Inspector in web views
        #   WebKitDeveloperExtras = true;
        # };
        "com.apple.finder" = {
          # AppleShowAllFiles = true;
          # ShowExternalHardDrivesOnDesktop = true;
          # ShowHardDrivesOnDesktop = true;
          # ShowMountedServersOnDesktop = true;
          # ShowRemovableMediaOnDesktop = true;
          # _FXSortFoldersFirst = true;
          # When performing a search, search the current folder by default
          FXDefaultSearchScope = "SCcf";
        };
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        # "com.apple.spaces" = {
        #   "spans-displays" = 0; # Display have separate spaces
        # };
        # "com.apple.WindowManager" = {
        #   EnableStandardClickToShowDesktop = 0; # Click wallpaper to reveal desktop
        #   StandardHideDesktopIcons = 0; # Show items on desktop
        #   HideDesktop = 0; # Do not hide items on desktop & stage manager
        #   StageManagerHideWidgets = 0;
        #   StandardHideWidgets = 0;
        # };
        # "com.apple.screensaver" = {
        #   # Require password immediately after sleep or screen saver begins
        #   askForPassword = 1;
        #   askForPasswordDelay = 0;
        # };
        # "com.apple.screencapture" = {
        #   location = "~/Desktop";
        #   type = "png";
        # };
        # "com.apple.AdLib" = {
        #   allowApplePersonalizedAdvertising = false;
        # };
        # Prevent Photos from opening automatically when devices are plugged in
        # "com.apple.ImageCapture".disableHotPlug = true;
      };
    };
  };
}
