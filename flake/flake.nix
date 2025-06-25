{
  description = "Manage NixOS server remotely";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    colmena.url = "github:zhaofengli/colmena";
    disko ={
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, disko, colmena, ... }:
    {
      nixosConfigurations.demo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./configuration.nix
        ];
      };
      colmenaHive = colmena.lib.makeHive {
        meta = {
          nixpkgs = nixpkgs.legacyPackages.x86_64-linux;
        };

        defaults = { pkgs, ... }: {
          environment.systemPackages = [
            pkgs.curl
          ];
        };

        zabbix = { pkgs, ... }: {
          deployment = {
            targetHost = "10.33.72.29";
            targetPort = 22;
            targetUser = "deployer";
            buildOnTarget = false;
            tags = [ "jablonka" ];
          };
          nixpkgs.system = "x86_64-linux";
          imports = [
            disko.nixosModules.disko
            ./configuration-zabbix.nix
          ];
          time.timeZone = "Europe/Prague";
        };

        demo = { pkgs, ... }: {
          deployment = {
            targetHost = "192.168.40.148";
            targetPort = 22;
            targetUser = "jablonka";
            buildOnTarget = false;
            tags = [ "homelab" ];
          };
          nixpkgs.system = "x86_64-linux";
          imports = [
            disko.nixosModules.disko
            ./configuration.nix
          ];
          time.timeZone = "Europe/Prague";
        };
      };
    };
}
