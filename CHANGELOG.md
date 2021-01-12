# Changelog

## Git

### Changes

* Added an option to specify the thickness of lines used as indicators
* Fixed broken window detection (e.g. Steam or Spotify were affected by this)
* Fixed an issue of not being able to select the Number style under certain conditions
* Updated some configuration dialog elements to be scalable on HiDPI screens

## 1.4

### Changes

* Fixed broken Add Desktop context menu option
* Fixed some issues with hidden or squashed desktop buttons
* Fixed annoying button jumping when only one desktop button is visible

## 1.3

### Changes

* Fixed some issues with window names handling again
* Fixed visibility of buttons when both options are checked
* Fixed some issues on Kubuntu 18.04 and distros with older Qt version

## 1.2

### Changes

* Improved handling of window names (no more ugly class names)
* Fixed broken fade-out animation when removing a non-last desktop
* Fixed black always being the initial color in color picker dialogs
* Added an option to change corner radius for the Block indicator style
* Changed the default length limit for desktop labels to 25 characters

## 1.1

### Changes

* Restored the ability to work with window managers other than KWin

## 1.0

This is a release that introduces breaking changes.

IMPORTANT: User settings from previous versions are ignored.

If you decide to update the plasmoid, be prepared for reconfiguration.

### Changes

* Rewritten some parts of the applet for easier maintenance (and failed)
* Removed the shortcut-based API for KWin scripts (it was pretty much useless)
* Merged options related to keeping/removing empty desktops into "dynamic desktops" feature
* Updated configuration dialogs and rearranged some options and sections
* Added configuration dialog hints, e.g. explaining mutually exclusive options and more
* Added an option to only display desktops containing windows
* Added a feature to move desktops by dragging them with the mouse
* Added an option to remove desktops with the mouse wheel click (enabled by default)
* Removed all context menu actions related to the current desktop
* Added per desktop context menu actions (Rename Desktop, Remove Desktop)
* Changed naming of the desktop shortcuts to include a prefix for easier recognition
* Added an option to set common size for all desktop buttons, based on the largest button
* Added an option to filter occupied desktops by monitor (enabled by default)
* Added appearance settings for desktops containing windows needing attention
* Removed some of the existing desktop label styles (they can be recreated)
* Added a desktop label style displaying the name of the active window on a desktop
* Added a custom desktop label style that can be formatted with some variables
* Added options to limit length of desktop labels, and to display them as UPPERCASED
* Fixed some bugs related to distincting and coloring desktop indicators and labels
* Added hover tooltips containing brief information about windows present on a given desktop

## ...
