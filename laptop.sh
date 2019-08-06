#!/bin/sh

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

if command -v aws 2>/dev/null; then
  fancy_echo "AWS CLI already installed. Continuing…"
else
  curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o ~/Downloads/awscli-bundle.zip
  unzip ~/Downloads/awscli-bundle.zip -d ~/Downloads
  sudo ~/Downloads/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
fi

if command -v xcodebuild 2>/dev/null; then
  fancy_echo "Xcode already installed. Continuing…"
else
  fancy_echo "Install Xcode from the Mac App Store"
  fancy_echo "♻️♻️ Rerun the this script again! ♻️♻️"
  exit 0
fi

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
fi

if brew list | grep -Fq brew-cask; then
  fancy_echo "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

fancy_echo "Updating Homebrew formulae ..."
brew update
brew bundle --file=- <<EOF
tap "homebrew/services"

# Unix
brew "ctags"
brew "git"
brew "openssl"

# GitHub
brew "hub"

# Programming languages and package managers
brew "yarn"
brew "node"
brew "elixir"
brew "rebar"

brew "vault"
cask "graphiql"
brew "postgresql", restart_service: true
EOF

fancy_echo "Installing Elm…"
yarn global add elm --prefix /usr/local
yarn global add elm-format --prefix /usr/local
yarn global add elm-oracle --prefix /usr/local

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
