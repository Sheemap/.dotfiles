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
	    mappings = {
	      "<C-u>" = "cmp.mapping.scroll_docs(-4)";
	      "<C-d>" = "cmp.mapping.scroll_docs(4)";
	      "<C-Space>" = "cmp.mapping.complete()";
	      #"<CR>" = "cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true }";
	      "<CR>" = ''
		cmp.mapping(function(fallback)
		  if cmp.visible() then
		    cmp.mapping.confir({ behavior = cmp.ConfirmBehavior.Replace, select = true })
		  elseif luasnip.expand_or_jumpable() then
		    luasnip.expand_or_jump()
		  else
		    fallback()
		  end
		end, { 'i', 's' }),
	      '';
	      "<Downnnn>" = ''
		cmp.mapping(function(fallback)
		  if cmp.visible() then
		    cmp.select_prev_item()
		  elseif luasnip.jumpable(-1) then
		    luasnip.jump(-1)
		  else
		    fallback()
		  end
		end, { 'i', 's' }),
	      '';
	    };
	};
      };
      cmp-buffer.enable = true;
      cmp-conventionalcommits.enable = true;
      cmp-git.enable = true;
      cmp-path.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-document-symbol.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp-treesitter.enable = true;

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
	key = "<C-/>";
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
	action = "(cmp.visible() and cmp.mapping.scroll_docs(-4) or '')";
	lua = true;
	mode = [ "i" "s" ];
      }
      {
	key = "<Downnn>";
	action = "(cmp.visible() and cmp.mapping.scroll_docs(4) or '')";
	lua = true;
	mode = [ "i" "s" ];
      }
      {
	key = "<Downnn>";
	action = "(cmp.visible() and cmp.select_next_item() or '')";
	lua = true;
	mode = [ "i" "s" ];
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

      #{
#	key = "<CR>";
#
#	action = "cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true }";
#	lua = true;
#	mode = [ "i" "s" ];
#      } 
#      {
#	key = "<Tab>";
#	action = ''
#	    cmp.mapping(function(fallback)
#	      if cmp.visible() then
#		cmp.select_next_item()
#	      elseif luasnip.expand_or_jumpable() then
#		luasnip.expand_or_jump()
#	      else
#		fallback()
#	      end
#	    end
#	  '';
#	  lua = true;
#	  mode = [ "i" "s" ];
#      }
#      {
#	key = "<S-Tab>";
#	action = ''
#	    cmp.mapping(function(fallback)
#	      if cmp.visible() then
#		cmp.select_prev_item()
#	      elseif luasnip.jumpable(-1) then
#		luasnip.jump(-1)
#	      else
#		fallback()
#	      end
#	    end
#	  '';
#	  lua = true;
#	  mode = [ "i" "s" ];
      #}
    ];
  };
}
