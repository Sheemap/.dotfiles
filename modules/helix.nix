{ pkgs, ... }:
{
    home.file.".config/helix/config.toml".source = ../configs/helix.toml;
    home.file.".config/helix/languages.toml".source = ../configs/helix-lang.toml;

    home.packages = with pkgs; [
        helix
        # evil-helix

        lazygit
        clipboard-jh

        # LSPs
        basedpyright
        bash-language-server
        docker-compose-language-service
        dockerfile-language-server-nodejs
        eslint
        gleam
        gopls
        marksman
        nil
        ruff
        rust-analyzer
        terraform-ls
        typescript-language-server
        vscode-langservers-extracted
        yaml-language-server
    ];
}
