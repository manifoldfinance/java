{ system ? builtins.currentSystem
, nixpkgs ? import ./nixpkgs.nix { inherit system; }
}:
let
  sources = import ./sources.nix;

  devshell = import sources.devshell { pkgs = nixpkgs; };
in
{
  inherit nixpkgs;

  # Docs: https://numtide.github.io/devshell/modules_schema.html
  env = devshell.mkShell {
    env = [
      # Configure nix to use nixpgks
      { name = "NIX_PATH"; value = "nixpkgs=${toString nixpkgs.path}"; }
    ];

    packages = [
      # Development tools
      nixpkgs.just
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

    commands = [
      { category = "dev"; name = "j"; command = ''${nixpkgs.just}/bin/just "$@"''; help = "just a command runner"; }
    ];
  };
}
