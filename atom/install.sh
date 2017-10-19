#!/bin/sh

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

print_oracle() {
  local oracle=`which elm-oracle`
  fancy_echo "In Atom, open Settings ➡️ Packages ➡️ language-elm ➡️ Settings and update elm-oracle path to $oracle"
}

if command -v apm 2>/dev/null; then
  fancy_echo "Atom already installed. Continuing…"
else
  fancy_echo "Missing Atom. Installing…"
  curl -Lo ~/Downloads/atom.zip https://atom.io/download/mac
  unzip ~/Downloads/atom.zip -d /Applications
  open /Applications/Atom.app
  fancy_echo "Once Atom has launched, rerun this script"
  exit 0
fi

fancy_echo "Installing Atom packages…"
apm install busy-signal
apm install intentions
apm install language-elm
apm install language-elixir
apm install language-docker
apm install autocomplete-elixir
apm install elm-format
apm install linter
apm install linter-elixirc
apm install linter-elm-make
apm install linter-docker


fancy_echo "🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥"
fancy_echo "In Atom, open Settings ➡️ Core and append 'node_modules, elm-stuff, deps' to the end of Ignored Names"
print_oracle
fancy_echo "🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥"