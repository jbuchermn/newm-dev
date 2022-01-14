{
  description = "newm and pywm - dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    dasbus.url = "path:/home/jonas/newm-dev/newm/dist/nixos/dasbus";
    dasbus.inputs.nixpkgs.follows = "nixpkgs";
    dasbus.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, dasbus }:
  flake-utils.lib.eachDefaultSystem (
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system}; 
      dasbuspkg = dasbus.packages.${system};
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
          mypy
        ]);
      in
      with pkgs;
      mkShell {
        nativeBuildInputs = [
          meson_0_60
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
        ];

        shellHook = ''
          bash setup_env.sh
          cd env
        '';
      };
    }
    );
  }
