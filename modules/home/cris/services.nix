{ config, pkgs, ... }:
{
  systemd.user.services = {
    # easyeffects = {
    #   Unit = {
    #     Description = "EasyEffects";
    #     After = [ "pipewire.service" "pipewire-pulse.service" "wireplumber.service" ];
    #     Requires = [ "pipewire.service" ];
    #     PartOf = [ "graphical-session.target" ];
    #   };
    #   Install.WantedBy = [ "graphical-session.target" ];
    #   Service = {
    #     ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
    #     Restart = "on-failure";
    #     RestartSec = 3;
    #   };
    # };

    qmmp = {
      Unit = {
        Description = "QMMP music player";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
        ExecStart = "${pkgs.qmmp}/bin/qmmp";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };

    strawberry = {
      Unit = {
        Description = "Strawberry music player";
        After = [ "graphical-session.target" "qmmp.service" ];
        PartOf = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
        ExecStart = "${pkgs.strawberry}/bin/strawberry";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
