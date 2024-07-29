{
description = "Santiago's nixos config";

inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  hyprland = {
    url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  hyprland-plugins = {
    url = "github:hyprwm/hyprland-plugins";
    inputs.hyprland.follows = "hyprland";
  }; 

  hyprwm-contrib = {
    url = "github:hyprwm/contrib";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};

outputs = inputs@{ self, nixpkgs, ... }: {
  nixosConfigurations = 
  let
    fullname = "Santiago";
    username = "tiago";
    editor = "vim";
    browser = "brave";
    hostname = "void";
    systemArch = "x86_64-linux";

    # Don't change the stateVesrsion
    stateVersion = "23.11";
  in 
  {
    ${hostname} = nixpkgs.lib.nixosSystem rec {
      system = "${systemArch}";

      specialArgs = {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs;
        inherit system;
        inherit username fullname hostname;
        inherit editor browser;
        inherit stateVersion;
      };

      modules = [
        ./hosts/${hostname}/default.nix
        inputs.home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            users.${username} = import ./hosts/${hostname}/home.nix;
            extraSpecialArgs = {
              inherit username;
              inherit hostname;
              inherit inputs;
              inherit system;
              inherit stateVersion;
            };
          };
        }
      ];
    };
  };
};
}
