## Virtual Desktop Bar
This is an applet, a.k.a. plasmoid, for KDE Plasma panel which lets you switch between virtual desktops and also invoke some common actions to dynamically manage them in a convenient way. Those actions can be accessed through applet's context menu or user-defined global keyboard shortcuts.

The plasmoid displays virtual desktop entries as text labels with their names and optionally prepended numbers. That means there's no icons or window previews like in the Plasma's default pager applet. The intention is to keep it simple (and visually configurable in the future).

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
In order to install this applet you have to compile it, following the steps below.

#### Get the source code and create a build directory
```
git clone https://github.com/wsdfhjxc/virtual-desktop-bar
cd virtual-desktop-bar
mkdir build
cd build
```

#### Prepare the build environment on Kubuntu or KDE neon
```
sudo apt install cmake extra-cmake-modules g++ qtbase5-dev qtdeclarative5-dev libqt5x11extras5-dev libkf5plasma-dev libkf5globalaccel-dev libkf5xmlgui-dev
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release ..
```
#### Prepare the build environment on openSUSE
```
sudo zypper in cmake extra-cmake-modules gcc-c++ libqt5-qtbase-devel libqt5-qtdeclarative-devel libqt5-qtx11extras-devel plasma-framework-devel kglobalaccel-devel kxmlgui-devel
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DQML_INSTALL_DIR:PATH=/usr/lib64/qt5/qml ..
```

#### Compile and install the applet
```
make
sudo make install
```

If build succeeds, you should be able to find Virtual Desktop Bar in the Widgets menu.

### KWin scripts compatibility
KWin doesn't have an API for moving virtual desktops or removing particular ones. This plasmoid poorly implements such features by moving windows between existing desktops. It's not possible for a KWin script to know that moving a bunch of windows should be treated as a virtual desktop swap. Therefore, KWin scripts which track positions of windows, especially tiling scripts, may break badly because of a user using these non-standard features.

However, it's possible to "talk" to a KWin script by invoking a couple of keyboard shortcuts which can be registered by it. There are two potential shortcuts named `notifyBeforeMovingWindows` and `notifyAfterMovingWindows`. As their names suggest, they are invoked by the applet before starting moving windows and after it's finished. For example, a misbehaving script could prepare itself after receiving the first notification and refresh itself after receiving the second one, at least in theory.

In order to receive these so-called notifications within a KWin script, the shortcuts have to be registered with usage of an API provided `registerShortcut` function. There is no need to specify the actual key combination or anything except the shortcut name and a callback function. That's how you can do it:
```javascript
registerShortcut("notifyBeforeMovingWindows", "", "", func1);
registerShortcut("notifyAfterMovingWindows", "", "", func2);
``` 
