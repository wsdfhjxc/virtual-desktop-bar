## Virtual Desktop Bar

This is an applet for KDE Plasma panel that lets you switch between virtual desktops and also invoke some actions to dynamically manage them in a convenient way. Those actions can be accessed through applet's context menu or user-defined global keyboard shortcuts. There are also some automated features.

The plasmoid displays virtual desktops as text labels (numbers, names, both) with indicators (various styles). That means there's no icons or window previews like in the Plasma's default Pager applet. The intention is to keep it simple.

### Features

* switching to a desktop
* switching to a recent desktop
* adding a new desktop
* removing last desktop
* removing current desktop
* moving current desktop to left
* moving current desktop to right
* renaming current desktop

#### Automated features

* keeping at least one empty desktop
* removing redundant empty desktops 
* renaming desktops once they become empty
* switching to a manually added desktop
* prompting to rename a manually added desktop
* executing a command after manually adding a desktop

### Preview

Adding, renaming, moving, removing a desktop.

![](preview1.gif)

Three desktop label styles.

![](preview2.gif)

Various desktop indicator styles.

![](preview3.gif)

### Installation

Installing the applet directly from the Plasma Add-On Installer will not work. To install it, either get the applet as a distro specific package, or follow some simple instructions and build it from source by yourself.

#### Packages

Arch Linux users can get the applet as an [AUR package](https://aur.archlinux.org/packages/plasma5-applets-virtual-desktop-bar-git) (thanks cupnoodles).

Currently, there are no preconfigured or prebuilt packages for other distributions.

#### From source

First, you need to install some required dependencies.

For Kubuntu or KDE neon, run: `./install-ubuntu-deps.sh`

For Arch Linux or Manjaro, run: `./install-arch-deps.sh`

For openSUSE, run: `./install-opensuse-deps.sh`

For Fedora, CentOS, or RHEL, run `./install-redhat-deps.sh`

Then, compile the source code and install the applet:

```
mkdir build
cd build
cmake ..
make
sudo make install
```

After that, you should be able to find Virtual Desktop Bar in the Widgets menu.

If you want to remove the applet, `sudo make uninstall` will do.

### Configuration

The applet has some options regarding its behavior and visuals. You'll find them in the configuration dialog.

Don't get fooled by an empty Keyboard Shortcuts section though. It's an imposed thing, common for all plasmoids.

There are global keyboard shortcuts, but you have to define them in the Global Shortcuts System Settings Module. They should be available under KWin, Plasma or Latte Dock component, depending on the shell's mood and where have you placed the applet. The shortcuts are named like this:
* Switch to Recent Desktop
* Add New Desktop
* Remove Last Desktop
* Remove Current Desktop
* Move Current Desktop to Left
* Move Current Desktop to Right
* Rename Current Desktop

### Known issues

* Multi monitor behavior is in unknown state (untested)
* Virtual desktops are shared by all monitors (KWin's limitation)
* Support for Plasma Wayland session isn't there yet (maybe some day)
* The code behind this applet is a hot mess that begs for a sensible rewrite
* There are some occasional glitches with applet layout on Kubuntu 18.04 (Qt 5.9.5)
* Dynamic virtual desktop management doesn't play nice with KWin tiling scripts (see below)

#### Compatibility with KWin tiling scripts

If you want to use this applet with some KWin tiling scripts, they may not work correctly. However, this is only related to some non-standard features that Virtual Desktop Bar provides. I recommend reading [this document](KWIN.md) for more details and tips for KWin script developers which are interested in providing support for the plasmoid.

#### Compatible KWin tiling scripts

* [Patched faho's KWin tiling script](https://github.com/wsdfhjxc/kwin-tiling/tree/virtual-desktop-bar)

To get them working, you also have to tick a checkbox in the Advanced section of the configuration dialog.
