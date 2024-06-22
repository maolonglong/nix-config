_: (final: _: {
  fetchFromGitHubWithPatches = {
    owner,
    repo,
    rev,
    hash,
    patches,
  }:
    final.stdenv.mkDerivation {
      pname = repo;
      version = rev;
      src = final.fetchFromGitHub {
        inherit owner repo rev hash;
      };
      inherit patches;
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -R . $out/
        runHook postInstall
      '';
    };
})
