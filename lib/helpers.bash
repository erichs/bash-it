# Helper function loading various enable-able files
function _load_bash_it_files() {
  file_type="$1"
  if [ ! -d "${BASH_IT}/${file_type}/enabled" ]
  then
    continue
  fi
  FILES="${BASH_IT}/${file_type}/enabled/*.bash"
  for config_file in $FILES
  do
    if [ -e "${config_file}" ]; then
      source $config_file
    fi
  done
}

# Function for reloading aliases
function reload_aliases() {
  _load_bash_it_files "aliases"
}

# Function for reloading auto-completion
function reload_completion() {
  _load_bash_it_files "completion"
}

# Function for reloading plugins
function reload_plugins() {
  _load_bash_it_files "plugins"
}

alias-help ()
{
    about 'shows help for all aliases, or a specific alias group'
    param '1: optional alias group'
    example '$ alias-help'
    example '$ alias-help git'
    group 'lib'

    if [ -n "$1" ]; then
        cat $BASH_IT/aliases/enabled/$1.aliases.bash | metafor alias | sed "s/$/'/"
    else
        typeset f
        for f in $BASH_IT/aliases/enabled/*
        do
            typeset file=$(basename $f)
            printf '\n\n%s:\n' "${file%%.*}"
            # metafor() strips trailing quotes, restore them with sed..
            cat $f | metafor alias | sed "s/$/'/"
        done
    fi
}

bash-it-aliases ()
{
    about 'summarizes available bash_it aliases'
    group 'lib'

    typeset f
    typeset enabled
    printf "%-20s%-10s%s\n" 'Alias' 'Enabled?' 'Description'
    for f in $BASH_IT/aliases/available/*.bash
    do
        if [ -e $BASH_IT/aliases/enabled/$(basename $f) ]; then
            enabled='x'
        else
            enabled=' '
        fi
        printf "%-20s%-10s%s\n" "$(basename $f | cut -d'.' -f1)" "  [$enabled]" "$(cat $f | metafor about-aliases)"
    done
    printf '\n%s\n' 'to enable an alias group, do:'
    printf '%s\n' '$ enable-alias  <alias group> -or- $ enable-alias all'
    printf '\n%s\n' 'to disable an alias group, do:'
    printf '%s\n' '$ disable-alias <alias group> -or- $ disable-alias all'
}
