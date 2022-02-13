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
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (self: super: rec {
            python3 = super.python3.override {
              packageOverrides = self1: super1: {
                matplotlib = super1.matplotlib.override { enableQt = true; };
                dasbus = super1.buildPythonPackage rec {
                  pname = "dasbus";
                  version = "1.6";

                  src = super1.fetchPypi {
                    inherit pname version;
                    sha256 = "sha256-FJrY/Iw9KYMhq1AVm1R6soNImaieR+IcbULyyS5W6U0=";
                  };

                  setuptoolsCheckPhase = "true";

                  propagatedBuildInputs = with super1; [ pygobject3 ];
                };
              };
            };
            python3Packages = python3.pkgs;
          })
        ];
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
          dasbus

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
          qt5.qtwayland # For matplotlib
        ];

        # For matplotlib: https://github.com/NixOS/nixpkgs/issues/80147#issuecomment-784857897
        QT_PLUGIN_PATH = with pkgs.qt5; "${qtbase}/${qtbase.qtPluginPrefix}:${qtwayland}";

        shellHook = ''
          cd env || (bash setup_env.sh && cd env)

          export SHELL="$(readlink $(which zsh))"
        '';
      };
    }
    );
  }
