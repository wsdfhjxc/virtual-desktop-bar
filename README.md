# Virtual Desktop Bar

This is an applet for KDE Plasma panel (or Latte Dock) that lets you switch between virtual desktops and also invoke some actions to dynamically manage them in a convenient way. In order to do it, you can use the mouse, the context menu or user-defined keyboard shortcuts. There are also some extra features related to virtual desktops and more.

The plasmoid displays virtual desktops as text labels with indicators in various styles. That means there's no graphical icons and window previews like in the Plasma's default Pager applet. Although the intention is to keep it simple, the applet has several configuration options regarding its behavior and visuals, which should be more than enough for desktop customization enthusiasts and folks at [/r/unixporn](https://reddit.com/r/unixporn) who want to make their panels aesthetic.

## Features

* Switching, adding, removing, renaming, moving desktops
* Mouse dragging, clicking, scrolling support, context menu, keyboard shortcuts
* Automation: switching, renaming desktops, executing commands, dynamic desktops
* Customizable size, spacing, font, color and style of desktop buttons and labels
* Showing a desktop button only for the current desktop or only for occupied desktops
* Formatting the desktop label's style (name, number, Roman number, window's name, etc.)
* Limiting the maximum length of desktop labels, displaying them as UPPERCASED
* Customizable style and colors of desktop indicators in different states (idle, current, occupied etc.)

and a few more not mentioned options...

## Screenshots

Adding, renaming, moving, removing a desktop:

![](screenshots/1.gif)

Various desktop label styles:

![](screenshots/2.gif)

Various desktop indicator styles:

![](screenshots/3.gif)

Partial support also for vertical panels:

![](screenshots/4.png)

## Installation

To install the applet, either get it as a distro-specific package, or build it from source by yourself.

### Packages

* Arch Linux users can get the applet as an [AUR package](https://aur.archlinux.org/packages/plasma5-applets-virtual-desktop-bar-git) (thanks @nwwdles)
* Fedora and openSUSE users can get the applet from an [OBS repository](https://software.opensuse.org//download.html?project=home%3Asputnik%3Alook-and-feel&package=virtual-desktop-bar) (thanks @sputnik-devops)

Note: Make sure to check if the packages are up to date, for example by looking at the date contained in the filename of a package listed in the OBS repository. If they are not, you can always resort to building the plasmoid from source.

### From source

First, you need to install some required dependencies:

* On Fedora run: `./scripts/install-dependencies-fedora.sh`
* On openSUSE run: `./scripts/install-dependencies-opensuse.sh`
* On Arch Linux or Manjaro run: `./scripts/install-dependencies-arch.sh`
* On Kubuntu or KDE neon run: `./scripts/install-dependencies-ubuntu.sh`

Then, to compile the source code and install the applet run: `./scripts/install-applet.sh`

Note: This also applies if you want to upgrade to a newer version.

Note: If you want to remove the applet, run: `./scripts/uninstall-applet.sh`

After that, you should be able to find Virtual Desktop Bar in the Add Widgets menu.

## Configuration

The applet has some options regarding its behavior and visuals. You'll find them in the configuration dialog.

Don't get fooled by an empty Keyboard Shortcuts section though. It's an imposed thing, common for all plasmoids.

There are global keyboard shortcuts, but you have to configure them in the Global Shortcuts System Settings Module. They should be available under KWin, Plasma or Latte Dock component, depending on the Plasma's mood and where have you placed the applet. All of the shortcuts have the `Virtual Desktop Bar` prefix for easier recognition.

## Known issues

* "Error loading QML file" (see [here](https://github.com/wsdfhjxc/virtual-desktop-bar/issues/25#issuecomment-605633423) for a possible solution)
* Virtual desktops are shared by all monitors (KWin's limitation)
* Support for Plasma Wayland session isn't there yet (this is a long-term goal)
* The code behind this applet is a mess that doesn't follow the proper way of writing plasmoids
* Dynamic virtual desktop management doesn't play nice with KWin scripts (see the explanation below)

## Compatibility with KWin scripts

The plasmoid does some things which results of are not exposed through the KWin scripting API. This is related to dynamic desktops, moving desktops, removing desktops other than the last one. These are non-native features. Because of that, KWin scripts tracking desktops or windows (for example tiling scripts) in most cases will be confused and will not react properly to performed actions (maybe except the dynamic desktops feature, depends on the script).

Nothing can be done about it, as long as KWin scripting API does not support signals like:

 * `desktopRemoved(QString id)`
 * `desktopsReplaced(QString id1, QString id2)`

To avoid issues while using KWin scripts, do not use the features mentioned above.
