{
  perSystem = { pkgs, ... }:
    let
      storePaths = builtins.filter (s: s != "")
        (builtins.split "\n" (builtins.readFile ./store-paths.txt));
      nixFromDockerHub = (pkgs.dockerTools.pullImage {
        imageName = "nixos/nix";
        imageDigest = "sha256:321bc7ebbbe17b68fd21ed162d096c058f55e209359286330f6e793cafab228e";
        hash = "sha256-9BBCy6rxhn/eZ8nCKnHurKjjeW+kimKKnvbtmpLKqXI=";
        finalImageTag = "2.32.1";
        finalImageName = "nix";
      }).overrideAttrs {
        __structuredAttrs = true;
        unsafeDiscardReferences.out = true;
      };
      nixpline = pkgs.dockerTools.pullImage {
          imageName = "ghcr.io/redoracle/nixos";
          imageDigest = "sha256:92e2b4144ae5feec571849752cc631983ec1d8cee2d1f57f182c498a96f1d2a4";
          hash = "sha256-/aXifT4+3Sfou67EwSWJA2/brq2qGr1wID2OHJvtoL8=";
          finalImageTag = "2.30.2";
          finalImageName = "nixos";
      };

      ubuntu = pkgs.dockerTools.pullImage {
          imageName = "mcr.microsoft.com/devcontainers/base";
          imageDigest = "sha256:d94c97dd9cacf183d0a6fd12a8e87b526e9e928307674ae9c94139139c0c6eae";
          finalImageTag = "2.0.5-jammy";
          hash = "sha256-r5PNloyA3vzPns1UMxC1Z2D3l3i1GkTJ5QSKYyss6tQ=";
      };
    in
    {
      packages.container = pkgs.dockerTools.buildLayeredImage
        {
          name = "ihp-dev-prebuilt";
          tag = "latest";

          fromImage = ubuntu; # Base image

          # ✅ preload all devenv packages into /nix/store
          # contents = pkgs.buildEnv {
          #   name = "ihp-dev-root";
          #   paths = storePaths ++ [
          #     pkgs.devenv
          #     pkgs.direnv
          #     pkgs.cachix
          #   ];
          #   pathsToLink = [ "/bin" "/lib" "/share" ];
          #   ignoreCollisions = true;
          #   ignoreSingleFileOutputs = true;
          # };

          # fakeRootCommands = ''
          #   ${pkgs.dockerTools.shadowSetup}
          #   groupadd -r vscode
          #   useradd -m -r -g vscode vscode
          #   mkdir -p /home/vscode
          #   chown -R vscode:vscode /home/vscode
          # '';
          # enableFakechroot = true;

          # config = {
          #   Cmd = [ "${pkgs.bashInteractive}/bin/bash" ];
          #   Env = [
          #     "USER=vscode"
          #     "HOME=/home/vscode"
          #     "NIX_REMOTE=daemon"
          #     "NIX_CONF_DIR=/etc/nix"
          #     "PATH=/bin"
          #   ];
          #   WorkingDir = "/home/vscode";
          #   User = "vscode";
          # };

        };
    };
}




