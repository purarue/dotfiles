# lazy load shell tools that otherwise
# cause a bunch of lag on start up

# https://github.com/ScoreUnder/scripts-and-dotfiles/commit/5441fedb3770ca5e62746e094411057ec9000023
_lazy_opam_aliases=(
	ocaml{,{c,opt}{,p},lex,mktop,mklib,dep,objinfo,prof,doc}{,.opt,.byte}
	ocamlbuild{,.byte,.native}
	ocaml{find{,_opt},debug,format,yacc,run{,i,d},lsp,merlin{,-server},-language-server}
	dune
	utop
	opam
)
_ensure_opam_env() {
	if [ -z "$OPAM_SWITCH_PREFIX" ]; then
		unalias opam
		eval "$(opam env)"
		unalias "${_lazy_opam_aliases[@]}"
	fi >/dev/null 2>&1
	"$@"
}
for _raw_ocaml_command in "${_lazy_opam_aliases[@]}"; do
	alias "$_raw_ocaml_command=_ensure_opam_env $_raw_ocaml_command"
done
