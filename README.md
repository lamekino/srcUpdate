srcUpdate
---------

A simple tool for rebuilding local source code.

## Configuration:
The grammar for the config can be defined as:
```
# <full path to source code directory>
<build instruction 1>
<build instruction 2>
<...>
<build instruction N>

# <next path>
<...>
<EOF>
```
Note that currently the new line between build paths is enforced.

## Example:
```
# /usr/local/src/neovim
git pull
make CMAKE_BUILD_TYPE=RelWithDebInfo
cd build
cpack -G DEB
sudo dpkg -i nvim-linux64.deb

# /usr/local/src/xfce4-docklike-plugin
git pull
make
sudo make install
```

## Goals:
- [x] Simple parser that allows for copying pasting build instructions.
- [x] Specify a build list using CLI arguments.
- [ ] Having a default config file in `$XDG_CONFIG_HOME`.
- [ ] Automatic git pull (don't build when no changes are pulled).
- [ ] Being able to set variables in config, ie:
    - [ ] The branch to pull from.
    - [ ] Default `make` flags.
- [ ] Setting branch for source code pull, being able to set variables in general.

## Non-Goals:
- Being a [ports](https://en.wikipedia.org/wiki/Ports_collection) clone.
- Being production worthy software.
