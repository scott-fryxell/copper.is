/**
 * Installs the toolbar button with the given ID into the given
 * toolbar, if it is not already present in the document.
 *
 * @param {string} toolbarId The ID of the toolbar to install to.
 * @param {string} id The ID of the button to install.
 * @param {string} afterId The ID of the element to insert after. @optional
 */
function installButton(toolbarId, id, afterId) {
  if (!document.getElementById(id)) {
    var toolbar = document.getElementById(toolbarId);

    var before = toolbar.firstChild;
    if (afterId) {
      let elem = document.getElementById(afterId);
      if (elem && elem.parentNode == toolbar)
        before = elem.nextElementSibling;
    }

    toolbar.insertItem(id, before);
    toolbar.setAttribute("currentset", toolbar.currentSet);
    document.persist(toolbar.id, "currentset");

    if (toolbarId == "addon-bar")
      toolbar.collapsed = false;
  }
}

Application.getExtensions(function (extensions) {
    let extension = extensions.get("tip@dirtywhitecouch.com");

    if (extension.firstRun) {
      installButton("nav-bar", "custom-button-1", null);
    }
})