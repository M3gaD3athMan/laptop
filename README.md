# Laptop

## Running

```sh
$ git clone git@github.com:corvusinsurance/laptop.git
$ cd laptop
$ ./laptop
# If necessary: `chmod u+x laptop`
```

Optional: Visual Studio Code Editor

```sh
$ sh vs-code/install
# If you update your settings and want to push them
$ sh vs-code/updateConfig
$ git status
```

## Result

Script will install:

* [Atom](https://atom.io) editor
* [Homebrew](https://brew.sh) package manager
* [Elm](http://elm-lang.org) language
* [Elixir](https://elixir-lang.org) language
* [Node](https://nodejs.org/en/) and NPM
* Atom packages for Elm and Elixir
* AWS CLI


## Warnings

If you aren't using bash as your default shell then you might have issues with Vault.
 - It saves the gopath into your bash_profile by default, just add it to whatever rc file you are using ie. zshrc 

