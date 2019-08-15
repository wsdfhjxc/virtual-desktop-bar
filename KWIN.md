## Compatibility with KWin scripts
KWin doesn't have an API for moving virtual desktops or removing particular ones. This plasmoid poorly implements such features and it involves moving windows between existing desktops to achieve that. It's not possible for a KWin script to know that moving a bunch of windows from one desktop to another, and vice versa, should be interpreted as a virtual desktop swap. Moreover, most KWin scripts which track positions of windows, especially tiling scripts, are designed to work with static virtual desktops. Therefore, they may break badly because of using non-standard features related to dynamic virtual desktop management, such as removing a desktop or moving it to left or right. There is not much I can do about it at the plasmoid level.

However, as a KWin script developer, you can do the opposite and provide compatibility with Virtual Desktop Bar to your script. It turns out, it's possible to "talk" to a KWin script by invoking keyboard shortcuts that can be registered by it. Because this seems to be the only way to communicate with a KWin script, the applet hopefully expects some specifically named keyboard shortcuts to be available. It will try to invoke them, to notify the potential KWin script about some events.

### The poor man's API
The expected keyboard shortcuts are named like this:
* `VDB-Event-RemoveLastDesktop-Before`
* `VDB-Event-RemoveLastDesktop-After`
* `VDB-Event-RemoveCurrentDesktop-Before`
* `VDB-Event-RemoveCurrentDesktop-After`
* `VDB-Event-MoveCurrentDesktopToLeft-Before`
* `VDB-Event-MoveCurrentDesktopToLeft-After`
* `VDB-Event-MoveCurrentDesktopToRight-Before`
* `VDB-Event-MoveCurrentDesktopToRight-After`

They all have a common prefix, an action name and a suffix, being either `Before` or `After`. The `Before` suffix tells that the action is going to be performed very soon (in 100 ms), and the `After` suffix tells that the action has been actually performed. This should be enough to know what's going to happen, prepare the script and adjust something when a `Before` event is noticed, and do other things when an `After` event is noticed.

### Example of integration
In order to receive fake input of these keyboard shortcuts within a KWin script, the shortcuts have to be registered with usage of a `registerShortcut` function provided by KWin. If your script has support for keyboard shortcuts, you're already familiar with that. Anyway, there is no need to specify the actual key combination or anything else, except the shortcut name and a JavaScript callback function.

Here are some ideas about what you could do, to keep everything (more or less) functional:
```javascript
KWin.registerShortcut("VDB-Event-RemoveLastDesktop-Before", "", "", function() {
    var lastDesktop = workspace.desktops;
    // The last desktop is going to be removed.
    // All windows from that desktop will be moved to lastDesktop - 1.
    // Temporarily disable capturing KWin signals related to window desktop changes.
    // If you keep track of available windows, update your data structures.
    // If you have an array of desktops containing window objects, relocate them.
});

KWin.registerShortcut("VDB-Event-RemoveLastDesktop-After", "", "", function() {
    // The last desktop has been removed.
    // All windows from that desktop have been moved.
    // Restore previously disabled capturing of KWin signals.
});

KWin.registerShortcut("VDB-Event-RemoveCurrentDesktop-Before", "", "", function() {
    var currentDesktop = workspace.currentDesktop;
    // The first or non-last desktop is going to be removed.
    // All windows from that desktop will be moved to currentDesktop + 1.
    // Temporarily disable capturing KWin signals related to window desktop changes.
    // If you keep track of available windows, update your data structures.
    // If you have an array of desktops containing window objects, relocate them.
});

KWin.registerShortcut("VDB-Event-RemoveCurrentDesktop-After", "", "", function() {
    // One of the desktops has been removed.
    // All windows from that desktop have been moved.
    // Restore previously disabled capturing of KWin signals.
});

KWin.registerShortcut("VDB-Event-MoveCurrentDesktopToLeft-Before", "", "", function() {
    // The current desktop is going to be swapped with currentDesktop - 1.
    // All windows from currentDesktop will be moved to currentDesktop - 1.
    // All windows from currentDesktop - 1 will be moved to currentDesktop.

    // Temporarily ignore KWin signals related to window desktop changes.
    // If you have an array of desktops containing window objects, relocate them.
    // For a tiling script, if you keep track of tiling layouts, relocate them as well.

    // Basically, everything regarding your data structures that is tied to currentDesktop
    // should be now tied to currentDesktop - 1, and everything tied to currentDesktop - 1
    // should be now tied to currentDesktop.
});

KWin.registerShortcut("VDB-Event-MoveCurrentDesktopToLeft-After", "", "", function() {
    // The current desktop has been swapped with currentDesktop - 1.
    // All windows from these desktops have been moved.
    // Restore previously disabled capturing of KWin signals.
});

KWin.registerShortcut("VDB-Event-MoveCurrentDesktopToRight-Before", "", "", function() {
    // The current desktop is going to be swapped with currentDesktop + 1.
    // Similar as the left variant, just different direction.
});

registerShortcut("VDB-Event-MoveCurrentDesktopToRight-After", "", "", function() {
    // Similar as the left variant, just different direction.
});
```

That's all I could think of without diving into technical details, since they are script specific anyway, and it's up to you how windows and virtual desktops are managed by your script. Good luck and happy hacking.
