## Virtual Desktop Bar
This is an applet, a.k.a. plasmoid, for KDE Plasma panel, which lets you switch between virtual desktops and also invoke some common actions to dynamically manage them in a convenient way. Those actions can be accessed through applet's context menu or user-defined global keyboard shortcuts. There is also support for some GNOME-like features.

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

### GNOME-like features
* always keeping at least one empty virtual desktop
* automatically removing redundant empty virtual desktops 

### Preview
![](preview.gif)

### Installation
To install the applet you have to build it.

First, you need to install some required dependencies.

For Kubuntu or KDE neon, run: `./install-ubuntu-deps.sh`

For Arch or Manjaro, run: `./install-arch-deps.sh`

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
If you want to use this applet with some KWin scripts (tiling scripts or the like), please read [this](KWIN.md) before.
