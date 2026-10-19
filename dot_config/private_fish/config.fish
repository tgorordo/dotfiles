if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
    set -x GPG_TTY (tty)
    set -x EDITOR hx
    #starship init fish | source
    direnv hook fish | source
    fzf --fish | source
    zoxide init fish | source
    alias cd=z
    alias ci=zi
    alias tree=tre
    alias yz=yazi
    alias pass=gopass
    alias ffetch=fastfetch

    set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    gpg-connect-agent updatestartuptty /bye >/dev/null

    alias ls=eza
end

set -gx NIX_DAEMON_SOCKET_PATH /var/nix/daemon-socket/socket

set PATH $PATH /home/tgorordo/.local/bin
