{
  modulesPath,
  lib,
  pkgs,
  ...
} @ args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;
  networking.hostname="newrouter" ;
  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.jablonka = { 
      isNormalUser = true;
      extraGroups = [ "networking" "wheel"];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJEAeeG/b5Lw5hOxT0O4NtjwydwvJyOIXzyqK0iQS3z novotny@marnov.cz" ];
  };
security.sudo.extraRules = [
  {
    users = ["jablonka"];
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