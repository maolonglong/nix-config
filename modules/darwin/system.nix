{
  inputs,
  myvars,
  ...
}: {
  system = {
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    defaults = {
      menuExtraClock.Show24Hour = true;

      dock = {
        "mru-spaces" = true;
        "autohide-time-modifier" = 0.2;
        "autohide-delay" = 0.0;
      };

      finder = {
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXDefaultSearchScope = "SCcf"; # search the current folder
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true;
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowPathbar = true;
        ShowRemovableMediaOnDesktop = true;
        ShowStatusBar = true;
      };

      screencapture = {
        location = "~/Desktop";
        type = "png";
      };

      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 0;
      };

      spaces."spans-displays" = false;

      WindowManager = {
        EnableStandardClickToShowDesktop = false;
        StandardHideDesktopIcons = false;
        HideDesktop = false;
        StageManagerHideWidgets = false;
        StandardHideWidgets = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };

      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = true;
        "com.apple.sound.beep.feedback" = 0;
        ApplePressAndHoldEnabled = false;
        AppleSpacesSwitchOnActivate = true;
        # Region-derived units. Typed options; locale alone does not always rewrite them.
        AppleMeasurementUnits = "Inches";
        AppleMetricUnits = 0;
        AppleTemperatureUnit = "Fahrenheit";
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
      };

      # Keys without a typed nix-darwin option.
      CustomUserPreferences = {
        NSGlobalDomain = {
          WebKitDeveloperExtras = true;
          # Preferred languages. Use zh-Hans, not zh-Hans-CN: the region suffix shows China.
          AppleLanguages = ["en-US" "zh-Hans"];
          # Region: United States. Locale IDs use an underscore, unlike AppleLanguages.
          AppleLocale = "en_US";
          AKLastLocale = "en_US";
        };
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
        "com.apple.ImageCapture".disableHotPlug = true;
      };

      loginwindow = {
        GuestEnabled = false;
        SHOWFULLNAME = true;
      };
    };
  };

  # systemsetup -settimezone only. It does not clear location-based automatic time zone.
  time.timeZone = "America/New_York";

  environment.variables.EDITOR = "vim";
}
