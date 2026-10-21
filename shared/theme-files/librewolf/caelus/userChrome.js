(function () {
  "use strict";

  const keysToDisable = [
    "cmd_quitApplication",
    "openFileKb",
    "key_savePage",
    "addBookmarkAsKb",
  ];

  function disableKeys(win) {
    for (const id of keysToDisable) {
      const key = win.document.getElementById(id);

      if (key) {
        key.remove();
        console.log("Disabled Firefox shortcut key:", id);
      }
    }

    // if (win.gBrowser?.tabbox) {
    //   win.gBrowser.tabbox.handleCtrlTab = false;
    // }
  }

  function initialize(win) {
    if (!win || win.closed || !win.gBrowser) {
      return;
    }

    // Apply immediately after startup.
    disableKeys(win);

    // Catch shortcut elements added later.
    if (!win._shortcutDisableObserver) {
      const observer = new win.MutationObserver(() => {
        disableKeys(win);
      });

      observer.observe(win.document.documentElement, {
        childList: true,
        subtree: true,
      });

      win._shortcutDisableObserver = observer;

      win.addEventListener(
        "unload",
        () => {
          observer.disconnect();
          delete win._shortcutDisableObserver;
        },
        { once: true },
      );
    }
  }

  function onStartup(subject, topic) {
    if (topic !== "browser-delayed-startup-finished") {
      return;
    }

    initialize(subject);
  }

  // Register before checking existing windows.
  Services.obs.addObserver(onStartup, "browser-delayed-startup-finished");

  // Handle a window whose startup already finished.
  const windows = Services.wm.getEnumerator("navigator:browser");

  while (windows.hasMoreElements()) {
    const win = windows.getNext();

    if (win.gBrowserInit?.delayedStartupFinished) {
      initialize(win);
    }
  }
})();
