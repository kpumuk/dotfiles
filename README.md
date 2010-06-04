Dmytro Shteflyuk Dot Files
==========================

This package contains a set of my startup scripts, configuration
files to setup a system the way I like it.

Installation
------------

There are several pre-requisites needed before you install these
package:

1. You have to install [Homebrew](http://github.com/mxcl/homebrew),
   the missing package manager for OS X. I prefer to keep everything
   not directly installed with Max OS X in the `/opt` folder, so
   Homebrew should be installed to `/opt/homebrew`, or you will have
   to tune `bash/paths` script so the `$PATH` environment variable will
   point to the right folder.
2. Install bash and git from Homebrew. This is necessary because
   the bash version in Max OS X really outdated.

        brew install git bash bash-completion

Now you are ready to go:

    mkdir -p /opt/dotfiles
    curl -Lsf http://github.com/kpumuk/dotfiles/tarball/master | tar xvz -C/opt/dotfiles --strip 1
    (cd /opt/dotfiles && rake install)

That's all, it's time to start a new shell! To update scripts from
a repository use following command:

    dotfilesupdate

This command will bind you local checkout of dotfiles to a github
repository (if it isn't bound still), fetch latest version, and install
it. Any changes you made will not be touched (but there are could be
collisions, and you will have to resolve them manually).

Usage & Features
================

Bash
----

_in progress..._

Git
---

_in progress..._

Ruby & Ruby on Rails
--------------------

_in progress..._
