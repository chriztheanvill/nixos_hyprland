{ pkgs, lib, ... }:

{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
    # 1. Grafo global: rate por defecto 176400 (múltiplo de 44.1kHz)
    extraConfig.pipewire."10-dac-smsl-dl200" = {
      context.properties = {
        default.clock.rate = 176400;
        default.clock.allowed-rates = [ 44100 48000 88200 96000 176400 192000 352800 384000 ];
        default.clock.quantum = 2048;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 8192;
        resample.quality = 10;
      };
      stream.properties = {
        resample.quality = 10;
      };
    };

    # 2. Servidor Pulse: hereda rate del clock (no forzar nada)
    extraConfig.pipewire-pulse."20-pulse-properties" = {
      pulse.properties = {
        "pulse.min.req"       = "32/0";
        "pulse.default.req"   = "2048/0";
        "pulse.max.req"       = "8192/0";
        "pulse.min.quantum"   = "32/0";
        "pulse.max.quantum"   = "8192/0";
      };
    };

    wireplumber.extraConfig."51-alsa-dl200" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            { "node.name" = "~alsa_output.*smsl.*"; }
          ];
          actions = {
            update-props = {
              "audio.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 352800 384000 ];
              "audio.format" = "S32LE";
              "api.alsa.period-size" = 1024;
              "api.alsa.headroom" = 0;
              "session.suspend-timeout-seconds" = 0;
              "node.suspend-on-idle" = false;
              "resample.disable" = true;
              "priority.driver" = 9000;
            };
          };
        }
      ];
    };
  };

## old
  # ─────────────────────────────────────────────
  # Audio
  # ─────────────────────────────────────────────
  # services.pulseaudio.enable = false;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   jack.enable = true;
  # };
  # security.rtkit.enable = true;
  #
  # ## config dac
  #
  # # Configuración optimizada para DAC SMSL DL200
  # services.pipewire.extraConfig.pipewire = {
  #   "10-dac-smsl-dl200" = {
  #     context = {
  #       properties = {
  #         default.clock.rate = 176400;
  #         default.clock.allowed-rates = [ 44100 48000 88200 96000 176400 192000 352800 384000 ];
  #         default.clock.quantum = 2048;
  #         default.clock.min-quantum = 32;
  #         default.clock.max-quantum = 8192;
  #         ## default.clock.quantum-limit = 2048;
  #         resample.quality = 10;
  #       };
  #     };
  #     stream.properties = {
  #       resample.quality = 10;
  #     };
  #   };
  # };
  #
  # services.pipewire.extraConfig.pipewire-pulse = {
  #   "20-pulse-properties" = {
  #     pulse.properties = {
  #       pulse.min.req = "32/48000";
  #       pulse.default.req = "2048/48000";
  #       pulse.max.req = "8192/48000";
  #       pulse.min.quantum = "32/48000";
  #       pulse.max.quantum = "8192/48000";
  #     };
  #     pulse.rules = [
  #       {
  #         matches = [ { api.alsa.path = "hw:.*"; } ];
  #         actions = {
  #           update-props = {
  #             audio.format = "S32LE";
  #             ## audio.rate = 384000;
  #             api.alsa.period-size = 1024;
  #             resample.disable = true;
  #               node.suspend-on-idle = false;
  #               priority.driver = 9000;
  #               priority.session = 9000;
  #           };
  #         };
  #       }
  #     ];
  #   };
  # };

}
