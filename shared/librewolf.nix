{
  lib,
  config,
  pkgs,
  nur,
  ...
}:

let
  # userChrome.js loader. Two pieces are needed:
  #   program/config.js          -> appended to the generated mozilla.cfg (below)
  #   profile/chrome/utils/*     -> the actual loader, goes into the profile (home.file)
  fxAutoconfig = pkgs.fetchFromGitHub {
    owner = "MrOtherGuy";
    repo = "fx-autoconfig";
    rev = "master"; # TODO pin to a commit once it builds
    hash = "sha256-bpOt/fD8zZiKbb2sRQHl7eobuGklY9c2QI/jmYi9WE4=";
  };

  addons = pkgs.nur.repos.rycee.firefox-addons;

  sidebery = addons.sidebery.overrideAttrs (old: {
    src = pkgs.fetchurl {
      url = "https://github.com/DogeTheBeast/sidebery/raw/refs/heads/custom-release-ci/releases/sidebery.xpi";
      hash = "sha256-zFotS7ORIzV4DXZ75YvD/+9Kn/bTf0vhDJ8fpw75BVM=";
    };
  });

  profileName = "dogeLibreWolf";
  chromeDir = ".librewolf/${profileName}/chrome";
in
{
  programs.librewolf = {
    enable = true;
    # NOTE: `extraPrefs` is *appended* to the generated mozilla.cfg.
    # `extraPrefsFiles` would *replace* librewolf's own settings/librewolf.cfg
    # (i.e. silently drop every LibreWolf hardening pref).
    package =
      (pkgs.librewolf.override {
        extraPrefs = builtins.readFile "${fxAutoconfig}/program/config.js";
      }).overrideAttrs
        (old: {
          # Autoconfig runs sandboxed, and the sandbox hides Cc/ChromeUtils, which
          # fx-autoconfig's config.js uses. This pref can only be set in the
          # install dir's defaults/pref, not in user.js/mozilla.cfg.
          buildCommand = old.buildCommand + ''
            echo 'pref("general.config.sandbox_enabled", false);' \
              >> $out/lib/librewolf/defaults/pref/autoconfig.js
          '';
        });
    policies = {
      HttpAllowlist = [
        "http://100.96.166.98:8081"
        "http://100.96.166.98:4433"
        "http://100.120.67.80:25600"
        "http://100.120.67.80:5030"
        "http://100.120.67.80:9283"
        "http://100.120.67.80:9091"
      ];
    };
    profiles.dogeLibreWolf = {
      search = {
        force = true;
        engines = {
          searxng = {
            name = "Searxng";
            urls = [ { template = "http://100.96.166.98:8081/search?q={searchTerms}"; } ];
            definedAliases = [ "@sx" ];
          };
          nix-packages = {
            name = "Nix Packages";
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "@np" ];
          };
          nix-options = {
            name = "Nix Options";
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "@no" ];
          };
          home-manager-options = {
            name = "Home Manager Options";
            urls = [
              {
                template = "https://home-manager-options.extranix.com/";
                params = [
                  # { name = "type"; value = "packages"; }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "@ho" ];
          };
        };
        default = "searxng";
      };
      settings = {
        # belt & braces for the autoconfig sandbox (see the package override)
        "general.config.sandbox_enabled" = false;
        "apz.fling_friction" = 0.9;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "ui.context_menus.after_mouseup" = true;
        "dom.worker.remoteDebugger.enabled" = true;
      };
      extensions = {
        packages = with addons; [
          keepassxc-browser
          gesturefy
          darkreader
          block-website
          tridactyl
          new-tab-override
          stylus
          sidebery
        ];
      };
      userChrome = ./theme-files/librewolf/caelus/userChrome.css;
      userContent = ./theme-files/librewolf/caelus/userContent.css;
    };
  };

  # fx-autoconfig loader + the userChrome.js scripts, inside the profile.
  home.file = {
    "${chromeDir}/utils".source = "${fxAutoconfig}/profile/chrome/utils";
    "${chromeDir}/JS/disable-shortcuts.uc.js".source = ./theme-files/librewolf/caelus/userChrome.js;
  };
}
