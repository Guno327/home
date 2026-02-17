{pkgs, ...}: {
  imports = [
    ./kitty.nix
    ./minecraft.nix
    ./firefox.nix
    ./spotify.nix
    ./virt-manager.nix
    ./ghostty.nix
    ./ee2.nix
    ./poetrade.nix
    ./recording.nix
    ./foot.nix
    ./alacritty.nix
    ./mpv.nix
    ./zen.nix
    ./lg.nix
    ./eza.nix
    ./zoxide.nix
    ./ripgrep.nix
    ./bat.nix
    ./fish.nix
    ./fzf.nix
    ./git.nix
    ./ssh.nix
    ./devenv.nix
  ];

  home.packages = with pkgs; [
    wireshark
    freecad
    stable.gimp
    qFlipper
    audacity
    xclicker
    steam-tui
    steamcmd
    nvtopPackages.amd
    mattermost-desktop
    satisfactorymodmanager
  ];
}
