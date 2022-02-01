{
  description = "newm and pywm - dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system}; 
      dasbuspkg = {
        dasbus = pkgs.python3.pkgs.buildPythonPackage rec {
          pname = "dasbus";
          version = "1.6";

          src = pkgs.python3.pkgs.fetchPypi {
            inherit pname version;
            sha256 = "sha256-FJrY/Iw9KYMhq1AVm1R6soNImaieR+IcbULyyS5W6U0=";
          };

          setuptoolsCheckPhase = "true";

          propagatedBuildInputs = with pkgs.python3Packages; [ pygobject3 ];
        };

      };
    in
    {
      devShell = let
        my-python = pkgs.python3;
        python-with-my-packages = my-python.withPackages (p: with p; [
          # newm
          pycairo
          psutil
          websockets
          python-pam
          pyfiglet
          fuzzywuzzy
          dasbuspkg.dasbus

          # pywm
          imageio
          numpy
          pycairo
          evdev
          matplotlib

          # dev
          python-lsp-server
          pylsp-mypy
          mypy
          yappi
        ]);
      in
      with pkgs;
      mkShell {
        nativeBuildInputs = [
          meson
          ninja
          pkg-config
          wayland-scanner
          glslang
          python3
        ];

        buildInputs = [
          libGL
          wayland
          wayland-protocols
          libinput
          libxkbcommon
          pixman
          xorg.xcbutilwm
          xorg.xcbutilrenderutil
          xorg.xcbutilerrors
          xorg.xcbutilimage
          xorg.libX11
          seatd
          xwayland
          vulkan-loader
          mesa

          libpng
          ffmpeg
          libcap

          python-with-my-packages

          # dev
          gdb
          valgrind
        ];

        shellHook = ''
          bash setup_env.sh
          cd env

          export SHELL="$(readlink $(which zsh))"
        '';
      };
    }
    );
  }
