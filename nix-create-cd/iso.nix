# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

   boot.kernelParams = [
    "console=tty1"
    "console=ttyS0,115200"
  ];

    # Enable SSH in the boot process.
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgV5zBJksytl9aTEIxPp/YNdRhVVroj/3oLdsScCIfo98yi/ymDkxILOq0iRCVkcgwvj+tcorptv5uqVn+/IughaZ8VFWiK2KpYessJcNPbGxl3Zfv3WE+OR+q2yWs4K/wMw4Vz54gHFgA59/RvNcXv6bhBhnfoHIxU1r0Htx7wyr34O1V13sl4w+sytWoEWtAspq6XRw3pkzHmChrEoMf+OjAVpcVs5fSEppTlvM73FqMgJvX2UGwtGiunVl+K4Xu6i6puvr+WsVYqmqhIBFGt2hF2QWF3cbt6k2N+BlwYNios/NBgi+Xctse9PbdvgTHHjbC7KH5JW8hcuFud61j novotny@plague"
  ];
  networking = {
    usePredictableInterfaceNames = false;
    interfaces.eth0.ipv4.addresses = [{
      address = "192.168.40.188";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.40.254";
    nameservers = [ "192.168.40.254" ];
  };
    systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = [ "getty.target" ]; # to start at boot
    serviceConfig.Restart = "always"; # restart when session is closed
  };


}
