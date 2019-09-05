## Compatibility with KWin tiling scripts
KWin doesn't have an API for moving virtual desktops or removing particular ones. This plasmoid implements such features, and it involves moving windows between existing desktops to achieve that. It's not possible for a KWin script to know that moving a bunch of windows from one desktop to another, and vice versa, should be interpreted as a virtual desktop swap. Moreover, most KWin scripts which track positions of windows, especially tiling scripts, are designed to work with static virtual desktops. So, they may break badly because of using non-standard features related to dynamic virtual desktop management, such as removing a desktop or moving it to left or right.

If you just want an alternative for the Pager applet and don't care about those features, you shouldn't have any problems. Just keep in mind, that once you try to remove a desktop (other than the last one), or move current desktop to left or right, the tiling script you are using will most likely misbehave. That can mean anything, from nothing happening, to even causing a KWin crash. That's how it is, as long as said features aren't supported in Plasma natively.

However, as a KWin script developer, you can try to provide compatibility with Virtual Desktop Bar to your script. It turns out, it's possible to "talk" to a KWin script by invoking keyboard shortcuts that can be registered by it. Because this seems to be the only way to communicate with a KWin script, the applet hopefully expects some specifically named keyboard shortcuts to be available. It will try to invoke them, to notify the potential KWin script about some events.

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
* `VDB-Event-RemoveEmptyDesktops-Before`
* `VDB-Event-RemoveEmptyDesktops-After`

They all have a common prefix, an action name and a suffix, being either `Before` or `After`. The `Before` suffix tells that the action is going to be performed very soon (in 100 ms), and the `After` suffix tells that the action has been actually performed. This should be enough to know what's going to happen, prepare the script and adjust something when a `Before` event is noticed, and do other things when an `After` event is noticed.

Because you might ask yourself "What am I supposed to do with this bullshit?", particular events have been briefly explained in the next section. The code snippet contains some comments that can give you inspiration.

### Example of integration
In order to receive fake input of these keyboard shortcuts within a KWin script, the shortcuts have to be registered with usage of a `registerShortcut` function provided by KWin. If your script has support for keyboard shortcuts, you're already familiar with that. Anyway, there is no need to specify the actual key combination or anything else, except the shortcut name and a JavaScript callback function.

Here are some ideas about what you could do, to keep everything (more or less) functional:
```javascript
KWin.registerShortcut("VDB-Event-RemoveLastDesktop-Before", "", "", function() {
    var lastDesktop = workspace.desktops;

    // The last desktop is going to be removed.
    // All windows from that desktop will be moved to lastDesktop - 1.
    // Total number of desktops will be reduced by one.

    // If your script supports variable number of desktops and can process KWin
    // signals related to window desktop changes, you can totally skip this event.
});

KWin.registerShortcut("VDB-Event-RemoveLastDesktop-After", "", "", function() {
    // The last desktop has been removed.
    // All windows from that desktop have been moved.
});

KWin.registerShortcut("VDB-Event-RemoveCurrentDesktop-Before", "", "", function() {
    var currentDesktop = workspace.currentDesktop;
    var lastDesktop = workspace.desktops;

    // The first or an intermediate, non-last desktop is going to be removed.
    // All windows from currentDesktop + 1 up to lastDesktop will be moved one desktop back.
    // Total number of desktops will be reduced by one.
    
    // This event is not so simple as the last desktop removal.
    // Stop processing KWin signals related to window desktop changes.
    // If you keep track of available windows, update your data structures.
    // If you have an array of desktops containing window objects, relocate them.
    // For a tiling script, if you keep track of tiling layouts, relocate them as well.
    // Basically, everything regarding your data structures past currentDesktop that is
    // tied to desktop x should be now tied to desktop x - 1.
});

KWin.registerShortcut("VDB-Event-RemoveCurrentDesktop-After", "", "", function() {
    // One of the desktops has been removed.
    // All windows past that desktop have been moved.

    // Refresh all things affected by latest adjustments.
    // Restore previously stopped processing of KWin signals.
});

KWin.registerShortcut("VDB-Event-MoveCurrentDesktopToLeft-Before", "", "", function() {
    // The current desktop is going to be swapped with currentDesktop - 1.
    // All windows from currentDesktop will be moved to currentDesktop - 1.
    // All windows from currentDesktop - 1 will be moved to currentDesktop.

    // Stop processing KWin signals related to window desktop changes.
    // If you keep track of available windows, update your data structures.
    // If you have an array of desktops containing window objects, relocate them.
    // For a tiling script, if you keep track of tiling layouts, relocate them as well.
    // Basically, everything regarding your data structures that is tied to currentDesktop
    // should be now tied to currentDesktop - 1, and vice versa, that is, everything tied
    // to currentDesktop - 1 should be now tied to currentDesktop.
});

KWin.registerShortcut("VDB-Event-MoveCurrentDesktopToLeft-After", "", "", function() {
    // The current desktop has been swapped with currentDesktop - 1.
    // All windows from these desktops have been moved.

    // Refresh all things affected by latest adjustments.
    // Restore previously stopped processing of KWin signals.
});

KWin.registerShortcut("VDB-Event-MoveCurrentDesktopToRight-Before", "", "", function() {
    // The current desktop is going to be swapped with currentDesktop + 1.
    // Similar to the left variant, just different direction.
});

Kwin.registerShortcut("VDB-Event-MoveCurrentDesktopToRight-After", "", "", function() {
    // Similar to the left variant, just different direction.
});

KWin.registerShortcut("VDB-Event-RemoveEmptyDesktops-Before", "", "", function() {
    // All empty desktops, except one, are going to be removed.
    // Empty desktop with the lowest number is the one to be spared.
    // Windows from desktops past that one desktop will be moved back.
    // Total number of desktops will be reduced by number of empty desktops - 1.

    // This event is quite similar to the current desktop removal.
    // Stop processing KWin signals related to window desktop changes.
    // Find and identify the empty desktop with the lowest number.
    // Find and identify the remaining empty desktops, put them in an array.
    // For each desktop in the array, update your data structures and adjust
    // everything that is tied to a particular desktop number, similarly
    // to what you did in the RemoveCurrentDesktop-Before event.
});

KWin.registerShortcut("VDB-Event-RemoveEmptyDesktops-After", "", "", function() {
    // All empty desktops, except one, have been removed.
    // Windows from desktops past that one desktop have been moved.

    // Refresh all things affected by latest adjustments.
    // Restore previously stopped processing of KWin signals.
});
```

That's all I could think of without diving into technical details, since they are script specific anyway, and it's up to you how windows and virtual desktops are managed by your script. Good luck and happy hacking.
