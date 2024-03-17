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
      fugitive.enable = true;
      lualine.enable = true;
      undotree.enable = true;
      todo-comments.enable = true;
      friendly-snippets.enable = true;
      fidget.enable = true;
      multicursors.enable = true;

      treesitter = {
	enable = true;
      };

      cmp = {
	enable = true;
	settings = {
	    sources = [
		{ name = "buffer"; }
		{ name = "conventionalcommits"; }
		{ name = "git"; }
		{ name = "path"; }
		{ name = "nvim_lsp"; }
		{ name = "nvim_lsp_document_symbol"; }
		{ name = "nvim_lsp_signature_help"; }
		{ name = "treesitter"; }
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
	action = "<cmd>noh<CR>";
	key = "<Esc>";
	mode = [ "n" ];
      }
      {
	action = "<cmd>Git<CR>";
	key = "<leader>gs";
      }
      {
	action = "<cmd>Git push<CR>";
	key = "<leader>gp";
      }
      {
	action = "<cmd>UndotreeToggle<CR>";
	key = "<leader>u";
      }
      {
	action = "<cmd>Ex<CR>";
	key = "<leader>pv";
      }
      {
	action = "<cmd>''<CR>";
	key = "<C-O>";
      }
      {
	key = "<Up>";
	#action = "(cmp.visible() and print('hoi') or print('hoh'))";
	action = "<Cmd>lua require('cmp').scroll_docs(4)<CR>";
	mode = [ "i" "s" ];
      }
      {
	key = "<Down>";
	#action = "(cmp.visible() and print('hoi') or print('hoh'))";
	action = "<Cmd>lua require('cmp').select_next_item()<CR>";
	mode = [ "i" "s" ];
      }
      {
	key = "<C-Space>";
	action = "cmp.mapping.complete()";
	lua = true;
	mode = [ "i" "s" ];

      }
      {
	key = "<CR>";
	action = "cmp.mapping.complete()";
	lua = true;
	mode = [ "v" ];
      }
      {
	# Clipboard
	key = "<leader>y";
	action = "\"*y";
      }
    ];
  };
}
