{
  pkgs,
  opts,
  vars,
  ...
}:
{
  home.packages = with pkgs; [
    rclone
  ];
  # From the copyparty admin connect page: https://<base url>/?hc
  # Mounting twice, once for windows and another for wsl, because it is the easiest way to have it available everywhere.
  opts.autostartScripts."rclone-sync" =
    let
      windows-rclone = "/mnt/c/Users/${vars.windows-user}/AppData/Local/Microsoft/WinGet/Packages/Rclone.Rclone_Microsoft.Winget.Source_*/rclone-*/rclone.exe";
      linux-rclone = "${pkgs.rclone}/bin/rclone";
    in
    ''
      ${windows-rclone} config create sync webdav url=${vars.rclone.url} vendor=owncloud pacer_min_sleep=0.01ms user=k pass=${vars.rclone.password}
      ${windows-rclone} mount --vfs-cache-mode writes --dir-cache-time 5s --network-mode sync: X: & disown

      ${linux-rclone} config create sync webdav url=${vars.rclone.url} vendor=owncloud pacer_min_sleep=0.01ms user=k pass=${vars.rclone.password}
      mkdir -p ~/sync
      ${linux-rclone} mount --vfs-cache-mode writes --dir-cache-time 5s --network-mode sync: ~/sync & disown
    '';
}
