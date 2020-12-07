#!/bin/zsh

# Welcome to the Corvus laptop script!
# Be prepared to turn your laptop (or desktop, no haters here)
# into an awesome development machine.

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

create_postgres_user() {
  local c=`psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='postgres'"`
  if [ "$c" -eq "1" ]; then
    fancy_echo "Postgres user already exists. Continuing…"
  else
    /usr/local/bin/createuser -s postgres
  fi
}

# shellcheck disable=SC2154
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

if [ ! -d "$HOME/.bin/" ]; then
  mkdir "$HOME/.bin"
fi

HOMEBREW_PREFIX="/usr/local"

mkdir -p $HOMEBREW_PREFIX

if command -v xcodebuild 2>/dev/null; then
  fancy_echo "Xcode already installed. Continuing…"
else
  fancy_echo "Install Xcode by running 'xcode-select --install'"
  fancy_echo "♻️♻️ Rerun the this script again! ♻️♻️"
  exit 0
fi

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if brew list --formula | grep -Fq brew-cask; then
  fancy_echo "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

fancy_echo "Updating Homebrew formulae ..."
brew update
brew bundle --file=- <<EOF
tap "homebrew/services"
tap "hashicorp/tap"

# Unix
brew "ctags"
brew "git"
brew "openssl"
brew "awscli"
brew "pre-commit"

# GitHub
brew "gh"

# Programming languages and package managers
# brew "node"
# brew "yarn"
# brew "rebar"

brew "hashicorp/tap/vault"
cask "graphiql"
brew "postgresql", restart_service: true
EOF
brew link vault

fancy_echo "Installing Elm…"
# yarn global add elm --prefix /usr/local
# yarn global add elm-format --prefix /usr/local
# yarn global add elm-oracle --prefix /usr/local

if hash docker 2>/dev/null; then
  fancy_echo "🐋 Docker already Installed. Continuing…"
else
  fancy_echo "🐋 Getting Docker CE"
  curl "https://download.docker.com/mac/stable/Docker.dmg" -o ~/Downloads/Docker.dmg

  hdiutil attach ~/Downloads/Docker.dmg

  cp -ir /Volumes/Docker/Docker.app /Applications

  sudo hdiutil unmount /Volumes/Docker

  fancy_echo "🐋 Docker successfully installed"
fi

# Need to wait for postgres to finish starting up before running this
create_postgres_user

if [ -f "$HOME/.laptop.local" ]; then
  fancy_echo "Running your customizations from ~/.laptop.local ..."
  # shellcheck disable=SC1090
  . "$HOME/.laptop.local"
fi

fancy_echo "🔥🔥 Success! 🔥🔥"

fancy_echo "Next cd into the asdf directory and follow the installation instructions there"
