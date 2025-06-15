{
  description = "Minimal NixOS installation media";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      exampleIso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, modulesPath, ... }: {
            imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
  networking = {
    useDHCP = false;
    interfaces = {
      # dummy0 bude mít statickou IP
      dummy0 = {
        ipv4.addresses = [{
          address = "192.168.40.199";
          prefixLength = 24;
        }];
      };
    };
  };

  # DHCP klient na všech fyzických rozhraních (včetně eth0, wlan0 atd.)
  services.dhcpcd.enable = true;

  # Aktivace dummy zařízení
  boot.extraModprobeConfig = ''
    options dummy numdummies=1
  '';
  boot.kernelModules = [ "dummy" ];

  users.users.jablonka = {
    isNormalUser = true;
    password = "jablonka"; # hash není nutný pro ISO (pro testing OK)
    extraGroups = [ "wheel" ]; # sudo přístup
  };

  # Odstraníme heslo prompt pro root (volitelné)
  users.users.root.password = "";

  # TTY login jako root pro pohodlí
  services.getty.autologin = {
    enable = true;
    user = "root";
  };

#            users.users.jablonka.openssh.authorizedKeys.keys = [""];
          })
        ];
      };
    };
  };
}
