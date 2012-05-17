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
