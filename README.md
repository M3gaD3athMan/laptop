# Laptop

Corvus version of the thoughtbot laptop script

## Running

Clone the repo:

```zsh
$ git clone git@github.com:corvusinsurance/laptop.git
$ cd laptop
```

Run `laptop.zsh`:

```zsh
$ ./laptop.zsh
# If necessary: `chmod u+x laptop`
```

Optional: Visual Studio Code Editor

```zsh
$ zsh ./vs-code/install
# If you update your settings and want to push them
$ zsh vs-code/updateConfig
```

Optional: Atom Editor
```zsh
$ zsh ./atom/install.zsh
```

## Result

`laptop.zsh` will install:
* [Docker](https://www.docker.com/) container manager
* [Elm](http://elm-lang.org) language
* [Homebrew](https://brew.sh) package manager
* [Node](https://nodejs.org/en/) and NPM
* [PSQL](https://www.postgresql.org/)
* [Yarn](https://yarnpkg.com/)
* [AWS CLI](https://aws.amazon.com/cli/)
* [Vault]([Vault](https://www.vaultproject.io).)


## Warnings

If you aren't using zsh as your default shell then you might have issues with the install scripts.
 - It saves the gopath into your zshrc by default, just add it to whatever rc file you are using ie. bash_profile
