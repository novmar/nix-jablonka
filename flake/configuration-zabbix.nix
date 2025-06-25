{
  modulesPath,
  lib,
  pkgs,
  ...
} @ args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disk-config-biosboot.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    enable = true;
    device = "/dev/sda";
    efiSupport = false;

  };
  services.openssh.enable = true;
  networking = { 
  hostName="zabbix.marnov.cz" ;
    interfaces.ens18 = {
    ipv4.addresses = [{
      address = "10.33.72.29";
      prefixLength = 24;
    }];
  };
  defaultGateway = {
      address = "10.33.72.3";
    interface = "ens3";
  };
  
  };
  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.novotny = { 
      isNormalUser = true;
      extraGroups = [ "wheel"];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJEAeeG/b5Lw5hOxT0O4NtjwydwvJyOIXzyqK0iQS3z novotny@marnov.cz" ];
  };
  users.users.deployer = { 
      isNormalUser = true;
      extraGroups = [ "networking" "wheel"];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJEAeeG/b5Lw5hOxT0O4NtjwydwvJyOIXzyqK0iQS3z novotny@marnov.cz" ];
  };
security.sudo.extraRules = [
  {
    users = ["deployer"];
    commands = [ 
      { command = "ALL"; 
        options = ["NOPASSWD"] ; 
      }
    ];
  }
];
  users.users.root.openssh.authorizedKeys.keys =
  [
    # change this to your ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJEAeeG/b5Lw5hOxT0O4NtjwydwvJyOIXzyqK0iQS3z novotny@marnov.cz"
  ] ++ (args.extraPublicKeys or []); # this is used for unit-testing this module and can be removed if not needed

  system.stateVersion = "25.05";
}