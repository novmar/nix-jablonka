{ modulesPath, lib, pkgs, ... } @ args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys =
  [
    # change this to your ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJEAeeG/b5Lw5hOxT0O4NtjwydwvJyOIXzyqK0iQS3z novotny@marnov.cz "
  ] ++ (args.extraPublicKeys or []); # this is used for unit-testing this module and can be removed if not needed

  system.stateVersion = "25.05";

  networking = {
    useDHCP = true;
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
}
