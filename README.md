## Virtual Desktop Bar
This is an applet for KDE Plasma panel that lets you switch between virtual desktops and also invoke some actions to dynamically manage them in a convenient way. Those actions can be accessed through applet's context menu or user-defined global keyboard shortcuts. There is also support for some GNOME-like features.

The plasmoid displays virtual desktop entries as text labels with their numbers, names or both of them. That means there's no icons or window previews like in the Plasma's default pager applet. The intention is to keep it simple.

### Features
* switching to a virtual desktop
* switching to a recent virtual desktop
* creating a new virtual desktop
* removing last virtual desktop
* removing current virtual desktop
* moving current virtual desktop to left
* moving current virtual desktop to right
* renaming current virtual desktop

#### GNOME-like features
* always keeping at least one empty virtual desktop
* automatically removing redundant empty virtual desktops 

### Preview
![](preview.gif)

### Installation
Installing the applet directly from the Plasma Add-On Installer will not work. You have to either get the applet as a distro specific package, or follow some simple instructions and build it manually.

#### Distro packages
Arch Linux users can get the applet as an [AUR package](https://aur.archlinux.org/packages/plasma5-applets-virtual-desktop-bar-git) (thanks cupnoodles).

Currently, there are no preconfigured or prebuilt packages for other distributions.

#### Manual installation
First, you need to install some required dependencies.

For Kubuntu or KDE neon, run: `./install-ubuntu-deps.sh`

For Arch Linux or Manjaro, run: `./install-arch-deps.sh`

For openSUSE, run: `./install-opensuse-deps.sh`

Then, compile the source code and install the applet:

```
mkdir build
cd build
cmake ..
make
sudo make install
```

After that, you should be able to find Virtual Desktop Bar in the Widgets menu.

### Configuration
The plasmoid has some options regarding its behavior and visuals. You'll find them in the configuration dialog.

There are also global keyboard shortcuts, which you can define in the Global Shortcuts System Settings Module. They should be available under KWin, Plasma or Latte Dock component, depending on the shell's mood and where have you placed the applet. The shortcuts are named like this:
* Switch to Recent Desktop
* Add New Desktop
* Remove Last Desktop
* Remove Current Desktop
* Move Current Desktop to Left
* Move Current Desktop to Right
* Rename Current Desktop

### Compatibility with KWin scripts
If you want to use this applet with some KWin scripts, for example tiling scripts, they won't work correctly. This is related to some non-standard features that Virtual Desktop Bar provides. However, there is a chance they could work correctly, but that requires a little bit work from a KWin script developer. Please read [this document](KWIN.md) for more details.

#### Compatible KWin scripts
* [Patched faho's KWin tiling script](https://github.com/wsdfhjxc/kwin-tiling/tree/virtual-desktop-bar)
