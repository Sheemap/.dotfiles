{ config, pkgs, nixvim, ... }:
{
  programs.nixvim = {
    enable = true;

    colorschemes.ayu.enable = true;
    colorschemes.catppuccin.enable = true;

    globals.mapleader = " ";

    options = {
      number = true;
      relativenumber = true;

      shiftwidth = 4;

      scrolloff = 8;
    };

    extraConfigVim = ''
	let g:clipboard = {
	    \	'name': 'copyq',
	    \	'copy': {
	    \		'+': ['copyq', 'tab', '&clipboard', 'copy', '-'],
	    \		'*': ['copyq', 'tab', '&clipboard', 'copy', '-'],
	    \	},
	    \	'paste': {
	    \		'+': ['copyq', 'tab', '&clipboard', 'read'],
	    \		'*': ['copyq', 'tab', '&clipboard', 'read'],
	    \	},
	    \	'cache_enabled': 1
	    \ }
    '';

    plugins = {
      fugitive.enable = false;
      neogit.enable = true;
      lualine.enable = true;
      undotree.enable = true;
      todo-comments.enable = true;
      friendly-snippets.enable = true;
      fidget.enable = true;
      multicursors.enable = true;
      luasnip.enable = true;
      commentary.enable = true;
      auto-save.enable = true;

      # Figure these out eventually c:
      #conform-nvim.enable = true;
      #committia.enable = true;

      oil = {
	enable = false;
	keymaps = {
	    # How to disable the preview action?
	    # It's overriding my <C-p> telescope binding
	    # "actions.preview" = false;
	};
      };

      treesitter = {
	enable = true;
      };

      copilot-vim.enable = false;
      copilot-lua = {
	enable = false;
	panel = {
	    enabled = false;
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
		{ name = "buffer"; }
		{ name = "conventionalcommits"; }
		{ name = "git"; }
		{ name = "path"; }
		{ name = "nvim_lsp"; }
		{ name = "nvim_lsp_document_symbol"; }
		{ name = "nvim_lsp_signature_help"; }
		{ name = "treesitter"; }
		{ name = "luasnip"; }
	    ];
	};
      };

      lsp = {
	enable = true;
	servers = {
	    bashls.enable = true;
	    cssls.enable = true;
	    dockerls.enable = true;
	    eslint.enable = true;
	    gopls.enable = true;
	    graphql.enable = true;
	    html.enable = true;
	    jsonls.enable = true;
	    lua-ls.enable = true;
	    nixd.enable = true;
	    pyright.enable = true;

	    rust-analyzer = {
		enable = true;
		installCargo = true;
		installRustc = true;
	    };

	    svelte.enable = true;
	    tailwindcss.enable = true;
	    terraformls.enable = true;
	    tsserver.enable = true;
	    typos-lsp.enable = true;
	    vuels.enable = true;
	    yamlls.enable = true;

	};

	keymaps  = {
	    diagnostic = {
		"<leader>q" = "open_float";
		"<leader>e" = "setloclist";
		"[d" = "goto_prev";
		"]d" = "goto_next";
	    };

	    lspBuf = {
		"gD" = "declaration";
		"gd" = "definition";
		"gi" = "implementation";
		"gr" = "references";
		"K" = "hover";
		"<C-k>" = "signature_help";
		"<leader>r" = "rename";
		"<leader>f" = "format";
	    };
	};
      };

      telescope = {
	enable = true;

	keymaps = {
	    "<leader>pf" = "find_files";
	    "<C-p>" = "git_files";
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
	action = "<cmd>Neogit<CR>";
      }
      {
	key = "<leader>gp";
	action = "<cmd>Neogit pull<CR>";
      }
      {
	key = "<leader>gP";
	action = "<cmd>Neogit push<CR>";
      }
      {
	key = "<leader>u";
	action = "<cmd>UndotreeToggle<CR>";
      }
      {
	key = "<leader>pv";
	#action = "<cmd>Oil<CR>";

	# Default, non-oil, forgot the file manager name T~T
	action = "<cmd>Ex<CR>";
      }
      {
	key = "<C-O>";
	action = "<cmd>''<CR>";
      }
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
	key = "<C-/>";
	action = "<cmd>Commentary<CR>";
      }
    ];
  };
}
