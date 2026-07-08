{
  lib,
  config,
  pkgs,
  ...
}:
let
  citruszest = pkgs.vimUtils.buildVimPlugin {
    name = "citruszest";
    src = pkgs.fetchFromGitHub {
      owner = "zootedb0t";
      repo = "citruszest.nvim";
      rev = "e6fed9ec3d0ac190b1387379c138ba5e23a1f4f9";
      hash = "sha256-3MEAVKAblGysBhlrCf8j7Pf79tmylkjTnQkg6cvKMjg=";
    };
  };
  neominimap = pkgs.vimUtils.buildVimPlugin {
    name = "neominimap";
    src = pkgs.fetchFromGitHub {
      owner = "Isrothy";
      repo = "neominimap.nvim";
      rev = "0676085d898019f06044923934e38663f5efa290";
      hash = "sha256-EcV/mdleyopQsJ/t/Whl6Yf/2ORb9rnhHuc2Ue1E1Bw=";
    };
  };
  opencode-experimental = pkgs.vimUtils.buildVimPlugin {
    name = "opencode";
    src = pkgs.fetchFromGitHub {
      owner = "sudo-tee";
      repo = "opencode.nvim";
      rev = "99f26ffaf28e95a9f94426deaecf81af88ec1e0b";
      hash = "sha256-8IR/Nn4kKE832ADnHwsO3gd+QBCG8YomMhwFS61hM5I=";
    };
    dependencies = with pkgs.vimPlugins; [
      plenary-nvim
      render-markdown-nvim
    ];
  };
in
{
  programs.nixvim = {
    enable = true;
    opts = {
      cursorline = true;
      relativenumber = true;
      number = true;
      expandtab = false;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      clipboard = "unnamedplus";
    };
    diagnostic.settings = {
      virtual_text = false;
      virtual_lines = true;
      underline = true;
      severity_sort = true;
    };

    globals.mapleader = ",";

    extraPackages = with pkgs; [
      prettierd
      rustfmt
      nixfmt
    ];

    keymaps = [
      #      {
      #        action = "";
      # key = "";
      # mode = "n";
      # options = {
      #   desc = "";
      # };
      #      }
    ];

    plugins = {
      telescope = {
        enable = true;
        keymaps = {
          "ff" = {
            action = "find_files";
          };
          "fg" = {
            action = "live_grep";
          };
        };
      };

      lualine = {
        enable = true;
        settings = {
          options.theme = "codedark";
          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [
              "branch"
              "diff"
              "diagnostics"
            ];
            lualine_c = [
              {
                __unkeyed-1 = "filename";
                path = 1;
              }
            ];
            lualine_x = [
              {
                __unkeyed-1 = "encoding";
                __unkeyed-2 = "filetype";
              }
            ];
            lualine_y = [ "progress" ];
            lualine_z = [ "location" ];
          };
        };
      };

      comment = {
        enable = true;
      };

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            lspFallback = true;
            timeout = 500;
          };
          formatters_by_ft = {
            html = [ "prettierd" ];
            css = [ "prettierd" ];
            javascript = {
              __unkeyed-1 = "prettierd";
              stop_after_first = true;
            };
            javascriptreact = [ "prettierd" ];
            rust = [ "rustfmt" ];
            nix = [ "nixfmt" ];
          };
          log_level = "trace";
        };
      };

      blink-cmp = {
        enable = true;
        settings = {
          appearance = {
            nerd_font_variant = "mono";
          };
          keymap.preset = "super-tab";
        };
      };

      lsp = {
        enable = true;
        servers = {
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
        };
      };

      treesitter = {
        enable = true;
        # highlight.enable = true;
      };

    };

    extraPlugins = [
      citruszest
      neominimap
      opencode-experimental
    ];

    extraConfigLua = ''
        vim.cmd.colorscheme("citruszest")

        require("opencode").setup({
          preferred_picker = "snacks",
          preferred_completion = "blink",
        })
        init = function()
      vim.opt.wrap = false
      vim.opt.sidescrolloff = 36 -- Set a large value

      vim.g.neominimap = {
        auto_enable = true,
      }
      end
    '';
  };
}
