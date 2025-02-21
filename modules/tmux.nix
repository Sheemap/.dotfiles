{ pkgs, ... }:
let
  devEnvScript = pkgs.writeShellScriptBin "dev" ''
    session="dev"

    if tmux attach -t $session; then
        echo "attached to $session"
    else
        echo "creating session: $session"

        tmux new-session -d -s $session

        tmux rename-window -t $session:0 'Fish'

        #tmux new-window -t $session:1 -n 'Neovim'
        tmux new-window -t $session:1 -n 'Helix'

        #tmux send-keys -t $session:1 'nv' C-m
        tmux send-keys -t $session:1 'hx' C-m

        tmux attach -t $session
    fi
  '';

in
{
  home.packages = [ devEnvScript ];

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shell = "${pkgs.fish}/bin/fish";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
      {
        plugin = dracula;
        extraConfig = ''
          set-option -g status-position top

          set -g mouse on

          set -g @dracula-show-battery false
          set -g @dracula-show-powerline true
          set -g @dracula-refresh-rate 10

          # available plugins: battery, cpu-usage, git, gpu-usage, ram-usage, tmux-ram-usage, network, network-bandwidth, network-ping, ssh-session, attached-clients, network-vpn, weather, time, mpc, spotify-tui, playerctl, kubernetes-context, synchronize-panes
          set -g @dracula-plugins "ssh-session time"
        '';
      }
    ];
    extraConfig = ''
      # Smart pane switching with awareness of vim splits.

      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
       | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf|hx)(diff)?$'"

      # -n is shorthand for -T root
      bind-key -n 'C-q' if-shell "$is_vim" 'send-keys C-q' 'kill-pane'
      bind-key -n 'C-s' if-shell "$is_vim" 'send-keys C-s' 'split-window -v'
      bind-key -n 'C-x' split-window -v
      bind-key -n 'C-v' split-window -h

      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

      # Forwarding <C-\\> needs different syntax, depending on tmux version
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
       "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
       "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

      bind-key -T prefix 'C-y' resize-pane -L 10
      bind-key -T prefix 'C-u' resize-pane -D 10
      bind-key -T prefix 'C-i' resize-pane -U 10
      bind-key -T prefix 'C-o' resize-pane -R 10
    '';

  };
}
