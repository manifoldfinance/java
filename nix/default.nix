{ system ? builtins.currentSystem
, nixpkgs ? import ./nixpkgs.nix { inherit system; }
}:
let
  just = nixpkgs.just;
  just-alias = nixpkgs.writeShellScriptBin "j" ''
    exec ${nixpkgs.just}/bin/just "$@"
  '';

  mkEnv = nixpkgs.callPackage ./mkEnv.nix { };
in
rec {
  inherit nixpkgs;

  env = mkEnv {
    env = {
      # Configure nix to use nixpgks
      NIX_PATH = "nixpkgs=${toString nixpkgs.path}";
    };

    paths = [
      # Development tools
      just
      just-alias
      nixpkgs.niv
      nixpkgs.hadolint

      # Code formatting
      nixpkgs.treefmt
      nixpkgs.nixpkgs-fmt
      nixpkgs.shfmt

      # Used by repository
      nixpkgs.yarn
      nixpkgs.nodejs-16_x
      nixpkgs.nodePackages.prettier
    ];
  };
}
