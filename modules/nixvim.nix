{ pkgs, ... }:
{

  home.packages = with pkgs; [
    isort
    black
    nodePackages.prettier
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    extraPlugins = with pkgs.vimPlugins; [
      outline-nvim
      csv-vim
    ];

    extraPackages = with pkgs; [
      codespell
      ruff
    ];

    colorschemes.ayu.enable = true;
    colorschemes.catppuccin.enable = false;
    colorschemes.rose-pine.enable = false;
    colorschemes.dracula.enable = true;

    colorschemes.everforest = {
      enable = false;
      settings = {
        background = "hard";
        dim_inactive_windows = 1;
      };
    };

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      expandtab = true;

      shiftwidth = 4;

      scrolloff = 8;

      foldenable = true;
      foldminlines = 10;
      foldlevel = 9001;
      #foldmethod = "expr";
      #foldexpr = "nvim_treesitter#foldexpr()";
    };

    plugins = {

      none-ls.enable = true;
      none-ls.sources.diagnostics = {
        # Spectral is not packaged in nixpkgs rn
        spectral.enable = false;
        spectral.package = null;

        terraform_validate.enable = true;
        sqlfluff.enable = true;
        yamllint.enable = true;
      };

      markdown-preview = {
        enable = true;
        settings = {
          auto_start = true;
          browser = "firefox";
          echo_preview_url = true;
          page_title = "「\${name}」";
          port = "8080";
          preview_options = {
            disable_filename = true;
            disable_sync_scroll = true;
            sync_scroll_type = "middle";
          };
          theme = "dark";
        };
      };

      dashboard = {
        enable = true;
        settings = {
          change_to_vcs_root = true;

          config = {
            week_header = {
              enable = true;
            };
            shortcut = [
              {
                icon = " ";
                icon_hl = "@variable";
                desc = "Files";
                group = "Label";
                action = "Telescope find_files";
                key = "f";
              }
              {
                desc = " dotfiles";
                group = "Number";
                action = "Telescope dotfiles";
                key = "d";
              }
              {
                icon = " ";
                icon_hl = "@variable";
                desc = "Git Files";
                group = "Label";
                action = "Telescope git_files";
                key = "p";
              }
            ];
          };
        };
      };

      fugitive.enable = true;
      neogit.enable = true;
      lualine.enable = true;
      undotree.enable = true;
      todo-comments.enable = true;
      friendly-snippets.enable = true;
      fidget.enable = true;
      multicursors.enable = false;
      luasnip.enable = true;
      commentary.enable = true;
      auto-save.enable = true;
      tmux-navigator.enable = true;
      ts-autotag.enable = true;

      treesitter = {
        enable = true;
        folding = true;
        settings = {
          auto_install = true;
          highlight.enable = true;
        };
      };
      treesitter-context.enable = true;
      treesitter-refactor = {
        enable = true;
        highlightCurrentScope.enable = false;
        highlightDefinitions.enable = true;
        navigation = {
          enable = false;
          keymaps = {
            gotoDefinition = "gd";
          };
        };
        smartRename = {
          enable = false;
          keymaps = {
            smartRename = "<leader>r";
          };
        };
      };

      trouble = {
        enable = true;
        settings = {
          win.position = "right";
          modes.diagnostics = {
            auto_open = false;
            auto_close = false;
          };
        };
      };

      conform-nvim = {

        enable = true;
        formattersByFt = {
          lua = [ "stylua" ];
          # Conform will run multiple formatters sequentially
          python = [ "ruff_format" ];
          # Use a sub-list to run only the first available formatter
          javascript = [
            [
              "prettierd"
              "prettier"
            ]
          ];
          # Use the "*" filetype to run formatters on all filetypes.
          "*" = [ "codespell" ];
          # Use the "_" filetype to run formatters on filetypes that don't
          # have other formatters configured.
          "_" = [ "trim_whitespace" ];
        };

        formatOnSave = {
          timeoutMs = 500;
        };
      };

      oil.enable = true;
      yazi = {
        enable = false;
        settings = {
          open_for_directories = false;
        };
      };

      copilot-vim.enable = false;
      copilot-lua = {
        enable = false;
        panel = {
          enabled = true;
          keymap = {
            open = "<C-CR>";
          };
        };
        suggestion = {
          enabled = false;
          autoTrigger = true;
          keymap = {
            accept = "<C-j>";
          };
        };
      };

      cmp = {
        enable = true;
        settings = {
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
          sources = [
            #{ name = "copilot"; }
            #{ name = "conventionalcommits"; }
            #{ name = "git"; }
            #{ name = "treesitter"; }
            { name = "nvim_lsp"; }
            { name = "buffer"; }
            { name = "path"; }
            { name = "luasnip"; }
          ];
        };
      };

      lsp = {
        enable = true;
        #postConfig = "vim.lsp.set_log_level('debug')";
        servers = {

          bashls.enable = true;
          cssls.enable = true;
          dockerls.enable = true;
          eslint.enable = false;
          gopls.enable = true;
          graphql.enable = true;
          html.enable = true;
          jsonls.enable = true;
          lua-ls.enable = true;
          nixd.enable = true;
          pyright.enable = true;
          gleam.enable = true;

          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };

          svelte.enable = true;
          tailwindcss.enable = true;
          tsserver.enable = true;
          typos-lsp.enable = true;
          vuels.enable = true;

          # Gives so many errors :(
          yamlls.enable = false;
          terraformls.enable = false;

        };

        keymaps = {
          diagnostic = {
            "<leader>q" = "open_float";
            "<leader>e" = "setloclist";
            "[d" = "goto_prev";
            "]d" = "goto_next";
            "<leader>d" = "goto_prev";
            "<leader>f" = "goto_next";
          };

          lspBuf = {
            "gD" = "declaration";
            "gd" = "definition";
            "gi" = "implementation";
            "gr" = "references";
            "<leader>r" = "rename";
            "<leader>f" = "format";
            "<leader>k" = "hover";
            "<leader>j" = "signature_help";
          };
        };
      };

      telescope = {
        enable = true;

        keymaps = {
          "<C-p>" = "git_files";
          "<leader>f" = "git_files";
          "<leader>pf" = "find_files";
          "<leader>ps" = "live_grep";
        };
      };
    };

    keymaps = [
      {
        key = "<Esc>";
        action = "<cmd>noh<CR>";
        mode = [ "n" ];
      }
      {
        key = "<leader>gs";
        action = "<cmd>Git<CR>";
      }
      {
        key = "<leader>gp";
        action = "<cmd>Git pull<CR>";
      }
      {
        key = "<leader>gP";
        action = "<cmd>Git push<CR>";
      }
      {
        key = "<leader>gf";
        action = "<cmd>Git fetch<CR>";
      }
      {
        key = "<leader>gr";
        action = "<cmd>Git pull --rebase origin main<CR>";
      }
      {
        key = "<leader>gb";
        action = "<cmd>Git blame<CR>";
      }
      {
        key = "<leader>u";
        action = "<cmd>UndotreeToggle<CR>";
      }
      #{
      #  key = "<leader>pv";
      #  action = "<cmd>Ex<CR>";
      #}
      {
        key = "<leader>pv";
        action = "<cmd>Oil<CR>";
      }
      {
        key = "-";
        action = "<cmd>Oil<CR>";
      }
      # {
      # key = "<leader>pv";
      # action.__raw = ''
      #   function()
      #       require('yazi').yazi()
      #   end
      # '';
      # }
      {
        key = "<leader>f";
        action = "<cmd>lua vim.lsp.buf.format()<CR>";
      }
      {
        # Clipboard
        key = "<leader>y";
        action = "\"*y";
      }
      {
        key = "<C-s>";
        action = "<cmd>wincmd s<CR>";
      }
      {
        key = "<C-v>";
        action = "<cmd>wincmd v<CR>";
      }
      {
        key = "<C-h>";
        action = "<cmd>wincmd h<CR>";
      }
      {
        key = "<C-j>";
        action = "<cmd>wincmd j<CR>";
      }
      {
        key = "<C-k>";
        action = "<cmd>wincmd k<CR>";
      }
      {
        key = "<C-l>";
        action = "<cmd>wincmd l<CR>";
      }
      {
        key = "<C-q>";
        action = "<cmd>q<CR>";
      }
      {
        key = "<leader>o";
        action = "<cmd>Outline<CR>";
      }
    ];

    extraConfigVim = ''
      set undofile
    '';

    extraConfigLua = ''
      require("outline").setup({})
    '';
  };
}
