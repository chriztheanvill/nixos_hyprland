{ config, pkgs, ... }:

{
  # AMD RX 6600 + Radeon Graphics 5700G (hardware real)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

     # 2. Controladores de Video y decodificación por hardware (VA-API / VDPAU)
    extraPackages = with pkgs; [
      
      libva-vdpau-driver
      libvdpau-va-gl         # Traductor de VDPAU a OpenGL
      # rocmPackages.clr       # Soporte de OpenCL moderno (ROCm)
      libva
      libva-utils
    ];
  };

	nixpkgs.config.rocmSupport = true;
  hardware.amdgpu.opencl.enable = true;
}

