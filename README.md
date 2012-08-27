# local_bin

Often, in order to improve my performance, I create custom aliases or commands in Bash. Most of the commands are local-only, what means that I don't need them outside of certain directory. Server connection scripts, deployment strategies, shortcuts for project-specific commands. I could keep them in project repository, but often these are my custom improvements, which could be not appreciated by my team mates. That's why local_bin was born. It allows to create directory-specific commands *living outside of the directory*.

## Usage

### TL;DR

```
$ cd projects/whoah
$ localbin edit suite

#!/bin/bash
. ~/.bashrc &>/dev/null
rvm use $(rvm current) &>/dev/null
rake db:migrate db:test:prepare && \
bundle exec rspec spec && \
bundle exec cucumber

$ suite

# stuff gets done

$ cd ..
$ suite
-bash: suite: command not found

```

Let's assume that in order to run full test suite of your app, you need to perform few steps, specific to your local machine only, and after that type a long command. You could automate this and squash into one script living somewhere and an alias in your `.bashrc`. But you can do better:

```
cd your/project/dir
localbin edit testall
```

It will open your default editor with empty file. Type your script there.

It might happen that some commands you want to execute, require your `.bashrc`. Don't bother to type `. ~/.bashrc &>/dev/null` at the beginning of your script.

When you save the script, it will appear immediately available in your console, but only for directory, which `localbin edit` was called from.

And this is basically it. You could also see all available commands for current working directory:

```
localbin edit
```

## Installation

installation is pretty easy, you just need to clone the repo:

```
git clone git://github.com/sevos/local_bin.git ~/.local_bin
```

After that, include local_bin at end of your `.bashrc`:

```
. ~/.local_bin/local_bin.sh
```

Once you've done that, quit your terminal and run it again. Done!

It is important to include local_bin after your prompt customizations, because it overrides `$PROMPT_COMMAND` environment variable and needs to know, whether you use it as well to call your prompt command as well.

## Configuration

By default local bin stores all custom commands under directory structure laying at ~/.local_bin. You can override it, by exporting `$LOCAL_BIN_DIR` variable before including local_bin in your `.bashrc`:

```
export LOCAL_BIN_DIR=~/.dotfiles/local_bin
. ~/.local_bin/local_bin.sh
```

### Recursive bins

You can set environment variable `LOCAL_BIN_RECURSIVE=1`, and in your path will
land all commands available for upper directories. It means that in `/home/projects/abc`
directory you'll have available commands defined for:

* `/home/projects/abc`
* `/home/projects`
* `/home`
* `/`

Commands defined in deeper directory override commands defined in higher directory.

When this option is turned on, you can define commands in `/` as global aliases
for your shell!

# Contribution

Pull requests and feature requests are welcome!

# License

[MIT license](http://sevos.mit-license.org)
