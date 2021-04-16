# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
		];

# Use the GRUB 2 boot loader.
	boot.loader.grub.enable = true;
	boot.loader.grub.version = 2;
# boot.loader.grub.efiSupport = true;
# boot.loader.grub.efiInstallAsRemovable = true;
# boot.loader.efi.efiSysMountPoint = "/boot/efi";
# Define on which hard drive you want to install Grub.
 boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
 boot.loader.grub.extraConfig = ''

 if keystatus --shift ; then
     set timeout=-1
 else
     set timeout=0
 fi
 '';

# networking.hostName = "nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Set your time zone.
# time.timeZone = "Europe/Amsterdam";

# The global useDHCP flag is deprecated, therefore explicitly set to false here.
# Per-interface useDHCP will be mandatory in the future, so this generated config
# replicates the default behaviour.
	networking.useDHCP = false;

	networking = {
		usePredictableInterfaceNames = false;

		interfaces.eth0.ipv4.addresses = [{
			address = "192.168.40.188";
			prefixLength = 24;
		}];
		interfaces.eth1.useDHCP = false;
		interfaces.eth2.useDHCP = false;
		defaultGateway = "192.168.40.254";
		nameservers = [ "192.168.40.254" ];
		firewall.enable = false;
	};


# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";
	console = {
		font = "Lat2-Terminus16";
		keyMap = "us";
	};


# Define a user account. Don't forget to set a password with ‘passwd’.
# users.users.jane = {
#   isNormalUser = true;
#   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
# };

#	List packages installed in system profile. To search, run:
#		$ nix search wget
		environment.systemPackages = with pkgs; [
		wget vim htop flashrom tcpdump
		];



	boot.kernelParams = [
		"console=tty1"
			"console=ttyS0,115200"
	];


# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
	programs.mtr.enable = true;
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
	};
# Enable SSH in the boot process.
	users.users.root.openssh.authorizedKeys.keys = [
		"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgV5zBJksytl9aTEIxPp/YNdRhVVroj/3oLdsScCIfo98yi/ymDkxILOq0iRCVkcgwvj+tcorptv5uqVn+/IughaZ8VFWiK2KpYessJcNPbGxl3Zfv3WE+OR+q2yWs4K/wMw4Vz54gHFgA59/RvNcXv6bhBhnfoHIxU1r0Htx7wyr34O1V13sl4w+sytWoEWtAspq6XRw3pkzHmChrEoMf+OjAVpcVs5fSEppTlvM73FqMgJvX2UGwtGiunVl+K4Xu6i6puvr+WsVYqmqhIBFGt2hF2QWF3cbt6k2N+BlwYNios/NBgi+Xctse9PbdvgTHHjbC7KH5JW8hcuFud61j novotny@plague"
	];
services.sshd.enable = true;

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
	systemd.services."serial-getty@ttyS0" = {
		enable = true;
		wantedBy = [ "getty.target" ]; # to start at boot
			serviceConfig.Restart = "always"; # restart when session is closed
	};
# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "21.05"; # Did you read the comment?

}

