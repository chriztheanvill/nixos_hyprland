{ config, pkgs, ... }:

{

  fileSystems."/media/cris/Bomb" = {
    device = "/dev/disk/by-uuid/c50b355f-774f-498f-abf5-fdc20939fdfa";
    fsType = "ext4";
    options = ["rw" "noatime" "discard"];
  };

  fileSystems."/media/cris/Games" = {
    device = "/dev/disk/by-uuid/2aef2238-cf6a-495a-b0a2-4217e48748bf";
    fsType = "ext4";
    options = ["defaults" "noatime" "discard" "commit=60"];
  };

  fileSystems."/media/cris/Jazz" = {
    device = "/dev/disk/by-uuid/04cb1a6f-a47e-4b91-94dc-d75867a9c1ed";
    fsType = "ext4";
    options = ["defaults" "discard"];
  };

  fileSystems."/media/cris/Metal" = {
    device = "/dev/disk/by-uuid/a7a7e698-96ed-4aa7-9077-42ab1b24d57c";
    fsType = "ext4";
    options = ["defaults" "discard"];
  };

  fileSystems."/media/cris/Tank" = {
    device = "/dev/disk/by-uuid/184634004633DCE6";
    fsType = "ntfs-3g";
    options = ["defaults" "uid=1000" "gid=1000" "noatime" "big_writes" "nofail"];
  };

}

