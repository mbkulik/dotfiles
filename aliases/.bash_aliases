# Local variables:
# mode: Shell-script
# End:

export CS410c=$HOME/School/cs410c/
export CS416=$HOME/School/cs416/
export CS420=$HOME/School/cs420/
export CS515=$HOME/School/cs515/

alias open='xdg-open 2> /dev/null'
alias valgrind='valgrind --read-inline-info=no'
alias e='emacsclient -n -r'
alias et='emacsclient -nw'
alias re='systemctl --user restart emacs.service'
alias pdflatex='podman run --rm -v `pwd`:/docs:Z latex:latest'
alias which='command -v'
alias ipinfo='curl ipinfo.io'

alias cs410c='cd $CS410c'
alias cs416='cd $CS416'
alias cs420='cd $CS420'
alias cs515='cd $CS515'
