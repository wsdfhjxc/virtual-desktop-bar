### Compatibility with KWin scripts
KWin doesn't have an API for moving virtual desktops or removing particular ones. This plasmoid poorly implements such features by moving windows between existing desktops. It's not possible for a KWin script to know that moving a bunch of windows should be treated as a virtual desktop swap. Therefore, KWin scripts which track positions of windows, especially tiling scripts, may break badly because of a user using these non-standard features.

However, as a KWin script developer, you can at least try to mitigate the breakage, if you want to. It's possible to "talk" to a KWin script by invoking a couple of keyboard shortcuts which can be registered by it. There are two potential shortcuts which are invoked by the applet to notify about starting moving a bunch of windows and after it's finished. For example, a script could prepare itself after receiving the first notification and refresh itself after receiving the second one.

In order to receive these so-called notifications within a KWin script, the shortcuts have to be registered with usage of an API provided `registerShortcut` function. There is no need to specify the actual key combination or anything except the proper shortcut name and a callback function. That's how you can do it:
```javascript
registerShortcut("notifyBeforeMovingWindows", "", "", func1);
registerShortcut("notifyAfterMovingWindows", "", "", func2);
``` 

For example, the code within `func1` could temporarily disable the tiling mechanism and ignore window movement changes announced by the `desktopPresenceChanged` signal provided by the KWin's API. Then, the code within `func2` could reload the tiling mechanism and refresh its window data structures, to keep everything more or less functional.
