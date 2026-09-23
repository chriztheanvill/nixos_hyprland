{ config, pkgs, ... }:

{
## por si acaso
  # hardware.amdgpu.initrd.enable = true; # sets boot.initrd.kernelModules = ["amdgpu"];
  # boot.initrd.kernelModules = ["amdgpu" ];
  # boot.kernelModules = [ "kvm-amd" "amdgpu" ];
  # boot.extraModulePackages = [ ];
  # boot.kernelParams = [ "amdgpu.backlight=1" "acpi_backlight=video" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  ## discos duros externos y soporte
  boot.supportedFilesystems = [ "ntfs" "exfat" ];

  ## aun no lo he probado
  # USB autosuspend off para el DAC SMSL DL200 (hardware real)
  # boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  ## monitor
  hardware.i2c.enable = true;

}

