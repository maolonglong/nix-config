{myvars, ...}: let
  inherit (myvars) username;
in "/Users/${username}"
