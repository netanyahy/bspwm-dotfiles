# aliases comand
alias cls="clear"
alias g="git"
alias n="nvim"
alias m="micro"
alias feh="feh --scale-down"
alias vsc="vscode"
alias celar='clear'
alias ff='firefox'

set -U fish_greeting
set -gx EDITOR micro
set -gx VISUAL micro
set -gx BROWSER /usr/bin/firefox-bin
set -U fish_color_user white

# Цвета текста: весь ввод белый, подсказка (автодополнение) серая
set -g fish_color_command white
set -g fish_color_param white
set -g fish_color_keyword white
set -g fish_color_quote white
set -g fish_color_redirection white
set -g fish_color_end white
set -g fish_color_error white
set -g fish_color_operator white
set -g fish_color_escape white
set -g fish_color_autosuggestion 555 brblack
set -g fish_color_cwd white

function prompt_login
    set_color --bold white
    echo -n "$USER@$hostname"
    set_color normal
end

if status is-interactive
    # this command run fastfetch in automatical run fish
    fastfetch
end
