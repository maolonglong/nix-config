{inputs, ...}: (_: prev: let
  inherit (inputs) nur maolonglong-nur;
in {
  nur = import nur {
    nurpkgs = prev;
    pkgs = prev;
    repoOverrides = {
      maolonglong = import maolonglong-nur {pkgs = prev;};
    };
  };
})
