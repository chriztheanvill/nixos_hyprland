{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
        desiredgov = "performance";
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 1; ## usar gpu externa
        amd_performance_level = "auto"; ## por default, si se requiere mas potencia en gpu, usar high
        # amd_performance_level = "high"; ## incrementa el uso de GPU
      };
    };
  };

  programs.gamescope = {
    enable = true;
    args = [ "--rt" "--adaptive-sync" ]; ## mejor usar variables de entorno
    # args = [ "--rt" "--prefer-vk-device" "--adaptive-sync" ];
  };
}
