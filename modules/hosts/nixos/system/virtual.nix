{ config, pkgs, ... }:

{
  # Libvirt + virt-manager (GUI recomendado)
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
    };
  };
  
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  
  # Firmware UEFI para VMs
  systemd.tmpfiles.rules = [ 
    "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" 
  ];
  
  # Paquetes útiles
  environment.systemPackages = with pkgs; [
    qemu
    qemu_kvm
    virt-manager
    virt-viewer
    spice-gtk  # para clipboard y display SPICE
    OVMF.fd       # firmware UEFI estandar (no-Xen) para QEMU
  ];
}
