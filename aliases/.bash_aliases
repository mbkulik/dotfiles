# Local variables:
# mode: Shell-script
# End:

alias em="emacsclient -n"
alias histo="java -jar ~/lib/MrHistogram.jar"
alias weather="curl wttr.in/$1?0qn"

mupdf_wrapper() { (mupdf "$@" > /dev/null 2>&1 &) }
alias mupdf=mupdf_wrapper

md2pdf_wrapper() {
    (pandoc -f markdown_github -t latex -s --self-contained -V colorlinks "$1" -o "${1%.md}.pdf" )
}
alias md2pdf=md2pdf_wrapper

md2html_wrapper() {
    (pandoc -f markdown_github -t html5 -s --css ~/lib/pandoc.css --self-contained "$1" -o "${1%.md}.html" )
}
alias md2html=md2html_wrapper
