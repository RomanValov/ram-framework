NL='
'

_ram_index_list() {
	local namepath="$cur"
	local nameroot="$(echo "${namepath}" | grep -o "^.*\.")"

	local suggests="$(ram index ${nameroot} 2>/dev/null | cut -f1 -d' ' | grep "^${namepath}")"

	if ! [[ "$suggests" == *$NL* ]] && [ -n "$(ram index "${suggests}")" ]; then
		COMPREPLY=( $(compgen -W "${suggests}." -- ${cur}) )
		type compopt &>/dev/null && compopt -o nospace
	else
		COMPREPLY=( $(compgen -W "${suggests}" -- ${cur}) )
	fi
}

_ram_index() {
	if [[ ${COMP_CWORD} == 2 ]]; then
		_ram_index_list
	fi
}

_ram_tweak() {
	if [[ ${COMP_CWORD} == 2 ]]; then
		COMPREPLY=( $(compgen -W "$(ram tweak 2>/dev/null | cut -f1 -d'=')" -- ${cur}) )
	elif [[ ${COMP_CWORD} == 3 ]]; then
		COMPREPLY=( $(compgen -W "yes no on off true false" -- ${cur}) )
	fi
}

_ram_paths() {
	if [[ ${COMP_CWORD} == 2 ]]; then
		COMPREPLY=( $(compgen -W "assign insert remove" -- ${cur}) )
	else
		case ${COMP_WORDS[2]} in
			assign)
				type compopt &>/dev/null && compopt -o bashdefault -o default
				;;
			insert)
				type compopt &>/dev/null && compopt -o bashdefault -o default
				;;
			remove)
				COMPREPLY=( $(compgen -W "$(ram paths 2>/dev/null)" -- ${cur}) )
				;;
		esac
	fi
}

_ram_usage() {
	if [[ ${COMP_CWORD} == 2 ]]; then
		COMPREPLY=( $(compgen -W "$(ram proto 2>/dev/null | cut -f1 -d' ')" -- ${cur}) )
	fi
}

_ram_print() {
	if [[ ${COMP_CWORD} > 2 ]]; then
		COMPREPLY=( $(compgen -W "$(ram query $namepath 2>/dev/null | grep -o "^${cur}[^\.=]*")" -- ${cur}) )
		type compopt &>/dev/null && compopt -o nospace
	fi
}

_ram_input() {
	if [[ ${COMP_CWORD} > 2 ]]; then
		if ! [[ "${cur}" == *=* ]]; then
			COMPREPLY=( $(compgen -W "$(ram param $namepath 2>/dev/null)" -- ${cur}) )
			type compopt &>/dev/null && compopt -o nospace
		else
			type compopt &>/dev/null && compopt -o bashdefault -o default
		fi
	fi
}

_ram_which() {
	if [[ ${COMP_CWORD} > 2 ]]; then
		COMPREPLY=( $(compgen -W "$(ram which $namepath 2>/dev/null | xargs -n1 basename)" -- ${cur}) )
	fi
}

_ram_other() {
	if [[ ${COMP_CWORD} == 2 ]]; then
		_ram_index_list
	else
		declare namepath=${COMP_WORDS[2]}

		case ${COMP_WORDS[1]} in
			input|setup)
				_ram_input
				;;
			query|print|value)
				_ram_print
				;;
			which)
				_ram_which
		;;
		esac
	fi
}

_ram() {
	COMPREPLY=()

	declare cur prev
	_get_comp_words_by_ref -n:= cur prev

	if [[ ${COMP_CWORD} == 1 ]]; then
		COMPREPLY=( $(compgen -W "$(ram proto 2>/dev/null | cut -f1 -d' ')" -- ${cur}) )
		return 0
	else
		case ${COMP_WORDS[1]} in
			index)
				_ram_index
				;;
			tweak)
				_ram_tweak
				;;
			paths)
				_ram_paths
				;;
			usage)
				_ram_usage
				;;
			*)
				_ram_other
				;;
		esac
	fi

	unset cur prev

	return 0;
}

complete -F _ram ram
