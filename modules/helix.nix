{ pkgs, ... }:
{
    home.file.".config/helix/config.toml".source = ../configs/helix.toml;
    home.file.".config/helix/languages.toml".source = ../configs/helix-lang.toml;

    home.packages = with pkgs; [
        helix
        # evil-helix

        basedpyright
        bash-language-server
        eslint
        gleam
        gopls
        ruff
        rust-analyzer
        terraform-ls
        typescript-language-server
        vscode-langservers-extracted
    ];
}
