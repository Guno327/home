{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.git;
in {
  options.modules.programs.git.enable = mkEnableOption "enable extended git configuration";

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        commit.gpgsign = true;
        gpg.program = "${pkgs.gnupg}/bin/gpg";
        user = {
          name = "guno327";
          email = "accounts@ghov.net";
          signingKey = "BF48B4E0C22B5C18";
        };
      };

      extraConfig = {
        user.name = "${config.home.username}";
        user.email = "accounts@ghov.net";
        init.defaultBranch = "main";
        pull.rebase = true;
        push.default = "simple";
        push.followTags = true;
        fetch.prune = true;
        submodule.recurse = true;
      };
    };
  };
}
