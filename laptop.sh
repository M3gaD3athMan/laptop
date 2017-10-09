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

if [ -d "$HOMEBREW_PREFIX" ]; then
  sudo chown -R "$LOGNAME:admin" /usr/local
else
  sudo mkdir "$HOMEBREW_PREFIX"
  sudo chflags norestricted "$HOMEBREW_PREFIX"
  sudo chown -R "$LOGNAME:admin" "$HOMEBREW_PREFIX"
fi

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

# VM
cask "virtualbox"
cask "vagrant"

# GitHub
brew "hub"

# Programming languages and package managers
brew "node"
brew "elixir"
brew "rbenv"
brew "go"

# GraphiQL
cask "graphiql"

# Databases
brew "postgresql", restart_service: true
EOF

# Need to wait for postgres to finish starting up before running this
# create_postgres_user

if rbenv versions | grep 2.2.1 2>/dev/null; then
  fancy_echo "Ruby 2.2.1 already installed. Continuing…"
else
  rbenv install 2.2.1
fi

fancy_echo "Installing Elm…"
npm install -g elm
npm install -g elm-format
npm install -g elm-oracle
npm install -g yarn


if command -v vault 2>/dev/null; then
  fancy_echo "Vault already installed. Continuing…"
else
  # Vault's homebrew version is built using go's pure go DNS resolver
  # This causes big problems on macOS. See https://github.com/hashicorp/vault/issues/712
  # Building from source allows us to force the cgo DNS resolver
  fancy_echo "Installing Vault (secrets manager)"
  mkdir -p ~/.golang/src/github.com/hashicorp
  if [ -z $GOPATH ]; then
    echo "export GOPATH=~/.golang" >> ~/.bash_profile
    echo "export PATH=$GOPATH/bin:\$PATH"  >> ~/.bash_profile
    source ~/.bash_profile
  fi
  git clone https://github.com/hashicorp/vault.git ~/.golang/src/github.com/hashicorp/vault
  WD=`pwd`
  cd ~/.golang/src/github.com/hashicorp/vault
  make bootstrap && make dev-dynamic
  cd $WD
fi


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


if [ -f "$HOME/.laptop.local" ]; then
  fancy_echo "Running your customizations from ~/.laptop.local ..."
  # shellcheck disable=SC1090
  . "$HOME/.laptop.local"
fi

fancy_echo "🔥🔥 Success! 🔥🔥"
