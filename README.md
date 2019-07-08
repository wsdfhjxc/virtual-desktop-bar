## Virtual Desktop Bar
This is an applet, a.k.a. plasmoid, for KDE Plasma panel which lets you switch between virtual desktops and also invoke some common actions to dynamically manage them in a convenient way. Those actions can be accessed through applet's context menu or user-defined global keyboard shortcuts.

The plasmoid displays virtual desktop entries as text labels with their names and optionally prepended numbers. That means there's no icons or window previews like in the Plasma's default pager applet. The intention is to keep it simple.

### Features
* switching to a virtual desktop
* switching to a recent virtual desktop
* creating a new virtual desktop
* removing last virtual desktop
* removing current virtual desktop
* moving current virtual desktop to left
* moving current virtual desktop to right
* renaming current virtual desktop

### Preview
![](preview.gif)

### Installation
To install the applet you have to build it.

First, you need to install some required dependencies.

If you are on Kubuntu or KDE neon, it's:
```
sudo apt install cmake extra-cmake-modules g++ qtbase5-dev qtdeclarative5-dev libqt5x11extras5-dev libkf5plasma-dev libkf5globalaccel-dev libkf5xmlgui-dev
```

If you are on openSUSE, it's:
```
sudo zypper in cmake extra-cmake-modules gcc-c++ libqt5-qtbase-devel libqt5-qtdeclarative-devel libqt5-qtx11extras-devel plasma-framework-devel kglobalaccel-devel kxmlgui-devel
```

Then, compile the source code and install the applet:

```
mkdir build
cd build
cmake ..
make
sudo make install
```

After that, you should be able to find Virtual Desktop Bar in the Widgets menu.

### KWin scripts compatibility
If you want to use this applet with some KWin scripts (tiling scripts or the like), please read [this](KWIN.md) before.
