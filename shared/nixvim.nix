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
  gutentags = pkgs.vimUtils.buildVimPlugin {
    name = "gutentags";
    src = pkgs.fetchFromGitHub {
      owner = "ludovicchabant";
      repo = "vim-gutentags";
      rev = "aa47c5e29c37c52176c44e61c780032dfacef3dd";
      hash = "sha256-Y+CFG55h0APxuFwHgUE+o3LJNprBWFyuuZCPrKNgzb4=";
    };
  };
  pi = pkgs.vimUtils.buildVimPlugin {
    name = "pi";
    src = pkgs.fetchFromGitHub {
      owner = "pablopunk";
      repo = "pi.nvim";
      rev = "9b619b4f9fb96fa4dc1a6a7776a651980cd819a0";
      hash = "sha256-xtA3Ylu6kB5QF3KJ+4eDDO1PJhcTZVZyS3ei96Hs4bM=";
    };
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
      ignorecase = true;
      smartcase = true;
      wrap = false;
      sidescrolloff = 36;
    };
    diagnostic.settings = {
      virtual_text = false;
      virtual_lines = true;
      underline = true;
      severity_sort = true;
    };

    globals = {
      gutentags_ctags_extra_args = [
        "--exclude=target"
      ];
      mapleader = ",";
    };

    extraPackages = with pkgs; [
      prettierd
      rustfmt
      nixfmt
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
          "fp" = {
            action = "grep_string";
          };
          "fe" = {
            action = "treesitter";
          };
          "fr" = {
            action = "lsp_references";
          };
          "fq" = {
            action = "builtin";
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
          ts_ls = {
            enable = true;
          };
          texlab = {
            enable = true;
          };
          pylsp = {
            enable = true;
          };
          dartls = {
            enable = true;
          };
        };
      };

      treesitter = {
        enable = true;
        # highlight.enable = true;
      };

      gitsigns = {
        enable = true;
      };

      vimtex = {
        enable = true;
        texlivePackage = pkgs.texliveFull;
        settings = {
          # compiler_method = "xetex";
          view_method = "zathura";
        };
      };

    };

    extraPlugins = [
      citruszest
      neominimap
      gutentags
      pi
    ];

    extraConfigLua = ''
              vim.cmd.colorscheme("citruszest")

              init = function()

      				vim.g.neominimap = {
      					auto_enable = true,
      				}
      				end

      				require("pi").setup({
      				binary = "~/.local/bin/pi", 
      				provider = "ollama",
      				model = "qwen3:8b",
      				thinking = "off", -- be careful, thinking is time-consuming, it's not a great experience if you want simplicity
      				system_prompt = "You are a helpful assistant.",
      				append_system_prompt = "Always respond concisely.",
      				context = {
      					max_bytes = 24000,
      					ask = {
      						surrounding_lines = 80,
      					},
      					selection = {
      						surrounding_lines = 40,
      					},
      					diagnostics = {
      						enabled = false,
      					},
      				},
      				skills = true,
      				extensions = true,
      			})
    '';
  };
}
