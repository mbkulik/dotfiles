# Local variables:
# mode: Shell-script
# End:

alias em="emacsclient -n"
alias histo="java -jar ~/lib/MrHistogram.jar"
alias weather="curl wttr.in/$1?0qn"
alias open='xdg-open'

alias mupdf='mupdf_wrap() { mupdf "$@" > /dev/null 2>&1 ; \
unset -f mupdf_wrap; }; mupdf_wrap'

alias md2pdf='md2pdf_wrap() { pandoc -f markdown_github -t latex \
-s --self-contained -V colorlinks "$1" -o "${1%.md}.pdf" ; \
unset -f md2pdf_wrap; }; md2pdf_wrap'

alias md2html='md2html_wrap() { pandoc -f markdown_github -t html5 \
-s --css ~/lib/pandoc.css --self-contained "$1" -o "${1%.md}.html" ; \
unset -f md2html_wrap; }; md2html_wrap'
