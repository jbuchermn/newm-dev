{
  description = "pywm-grid";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    pywm.url = "github:jbuchermn/pywm";
    pywm.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, pywm, flake-utils }:
  flake-utils.lib.eachDefaultSystem (
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system}; 
      pywmpkg = pywm.packages.${system};
    in
    {
      packages.pywm-grid =
        pkgs.python3.pkgs.buildPythonApplication rec {
          pname = "pywm-grid";
          version = "0.1";

          src = ./.;

          propagatedBuildInputs = with pkgs.python3Packages; [
            pywmpkg.pywm
          ];

          setuptoolsCheckPhase = "true";
        };

      devShell = let
        my-python = pkgs.python3;
        python-with-my-packages = my-python.withPackages (ps: with ps; [
          pywmpkg.pywm

          python-lsp-server
          pylsp-mypy
          mypy
        ]);
      in
        pkgs.mkShell {
          buildInputs = [ python-with-my-packages ];
        };
    }
  );
}
