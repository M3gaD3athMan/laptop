# asdf Version Manager

Allows easy version management (install/change) for the languages we use.
Provides a way to share and specify exactly which language versions we need

## Install

```
<!-- run from this directory (laptop/asdf) -->
zsh ./install.zsh

# Open a new terminal
zsh ./plugins.zsh

export KERL_CONFIGURE_OPTIONS="--without-javac"
asdf install

<!-- Sets these versions as the global defaults -->
cat .tool-versions | xargs -L1 asdf global

asdf current

# Install elm
zsh ./elm.zsh
```

## Update

When we want to upgrade a version run this command in this directory. It will update `.tool-versions` and we can push.

```
asdf local <language> <version>
```


## Details: asdf

More detailed description on their website : [asdf homepage - setup](https://asdf-vm.com/#/core-manage-asdf-vm)

Install it, add to your shell (if you're not sure, it's probably `~/.zshrc`), update `homebrew`



## Details: Language Setup

Each language has a "plugin", and some have additional dependencies.
For example, erlang needs another homebrew package, etc.

These steps are all taken care of in the `plugins.zsh` script

### Erlang
* https://github.com/asdf-vm/asdf-erlang
* Step by step guide: https://dev.to/drebits/how-to-install-erlang-on-macos-with-asdf-3p1c
* Possible errors and solutions: https://github.com/asdf-vm/asdf-erlang/issues/157
* Requires an extra homebrew package `wxmac`
* May prompt that you need java (it's optional, so ignoring is 👌)

### Elixir
* https://github.com/asdf-vm/asdf-elixir


### Node
* https://github.com/asdf-vm/asdf-nodejs
* Requires an extra homebrew package - `gpg` for signature validation
* Versions: `asdf list-all nodejs`
* `asdf global nodejs 10.17.0`


### Yarn
* https://github.com/twuni/asdf-yarn


### Elm
* https://github.com/asdf-community/asdf-elm
* Versions: `asdf list-all elm`
* `asdf global elm 0.19.1`


### Rust
* https://github.com/asdf-community/asdf-rust
* Versions: `asdf list-all rust`
* `asdf global rust 1.39.0`


### Python
* https://github.com/danhper/asdf-python
* Python is a little harder than the others because we have 2 versions available at once: 2 and 3
  * _warning_: Didn't need this but possibly will `asdf reshim python` if binary packages aren't working
* `asdf plugin-add python`
  * Versions: `asdf list-all python`
  * _warning_: This produces a lot of output
* `asdf install python 2.7.16`
* `asdf install python 3.7.3`
* `asdf global python 3.7.3 2.7.16`
* `python3 -V`
* `python2 -V`
* `python -V`
