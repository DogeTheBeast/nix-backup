{ lib, config, pkgs, ... }:
{
  programs.librewolf = {
    enable = true;
    policies = {
      HttpAllowlist = [ "http://100.96.166.98:8081" ];
    };
    profiles.dogeLibreWolf = {
      search = {
        force = true;
        engines = {
	  searxng = {
	    name = "Searxng";
	    urls = [ { template = "http://100.96.166.98:8081/search?q={searchTerms}"; }];
	    definedAliases = [ "@sx" ];
	  };
	  nix-packages = {
	    name = "Nix Packages";
	    urls = [ { 
	      template = "https://search.nixos.org/packages";
	      params = [
	        { name = "type"; value = "packages"; }
	        { name = "query"; value = "{searchTerms}"; }
	      ];
	    }];
	    definedAliases = [ "@np" ];
	  };
	  nix-options = {
	    name = "Nix Options";
	    urls = [ { 
	      template = "https://search.nixos.org/options";
	      params = [
	        { name = "type"; value = "packages"; }
	        { name = "query"; value = "{searchTerms}"; }
	      ];
	    }];
	    definedAliases = [ "@no" ];
	  };
	  home-manager-options = {
	    name = "Home Manager Options";
	    urls = [ { 
	      template = "https://home-manager-options.extranix.com/";
	      params = [
	        # { name = "type"; value = "packages"; }
	        { name = "query"; value = "{searchTerms}"; }
	      ];
	    }];
	    definedAliases = [ "@ho" ];
	  };
	};
	default = "searxng";
      };
      settings = {
        "apz.fling_friction" = 0.9;
				"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
					keepassxc-browser
					gesturefy
					darkreader
				];
      };
      userChrome = ./theme-files/librewolf/userChrome.css;
    };
  };   
}
