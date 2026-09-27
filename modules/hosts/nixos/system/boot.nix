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

	# zRAM
	## systemd.targets.swap.enable = false;

  zramSwap = {
    enable = true;
    algorithm = "zstd"; # El algoritmo más eficiente en compresión/velocidad
    memoryPercent = 50; # Reserva hasta el 50% de tu RAM física (16GB de zRAM virtuales)
  };

	# Optimizar el comportamiento del Kernel (Opcional pero recomendado)
  boot.kernel.sysctl = {
    # Controla qué tan agresivo es el sistema para mandar datos a la swap.
    # Con zRAM, un valor de 100-150 es ideal porque prefieres comprimir en RAM
    # antes de desalojar la caché del sistema de archivos (pagecache).
    "vm.swappiness" = 100;
  };

  ## discos duros externos y soporte
  boot.supportedFilesystems = [ "ntfs" "exfat" ];

  ## aun no lo he probado
  # USB autosuspend off para el DAC SMSL DL200 (hardware real)
  # boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  ## monitor
  hardware.i2c.enable = true;

}

