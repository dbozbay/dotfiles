alias v="nvim"
alias lg="lazygit"

alias ls='eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first'
alias ll='eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first -l --git -h'
alias la='eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first -a'
alias lla='eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first -a -l --git -h'

eval "$(zoxide init zsh)"

export PATH="/opt/homebrew/opt/node@24/bin:$PATH"
export PATH=$PATH:$HOME/.local/share/bob/nvim-bin
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="fishy"

source $ZSH/oh-my-zsh.sh
