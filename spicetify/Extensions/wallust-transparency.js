(function wallustTransparency() {
    const style = document.createElement('style');
    style.innerHTML = `
        /* 1. Main Background Tint (Darker/Glass look) */
        .Root__top-container,
        .Root__main-view,
        .Root__nav-bar,
        .Root__now-playing-bar,
        .main-view-container,
        .main-view-container__scroll-node-child,
        .main-nowPlayingBar-container,
        .Root__right-sidebar,
        .main-topBar-background,
        .main-topBar-overlay,
        .main-entityHeader-backgroundColor,
        .main-actionBarBackground-gradient {
            background-color: rgba(0, 0, 0, 0.4) !important; /* Adjust 0.4 for more/less tint */
        }

        body {
            background-color: transparent !important;
        }

        /* 2. Pop-up Menus & Dropdowns (Solid/Less Transparent for readability) */
        div[id*="context-menu"],
        ul[role="menu"],
        .main-contextMenu-menu,
        .main-type-menu,
        .main-dropDown-menu,
        .main-contextMenu-container,
        .encore-dark-theme .encore-announcement-set {
            background-color: #181818 !important; /* Solid dark background */
            border: 1px solid var(--spice-border-inactive) !important;
            opacity: 1 !important;
        }

        /* Ensure menu text is bright */
        .main-contextMenu-menuItemButton,
        .main-contextMenu-menuItem {
            color: #FFFFFF !important;
        }

        .main-contextMenu-menuItemButton:hover {
            background-color: var(--spice-highlight) !important;
        }

        /* Ensure main view doesn't have double-tinting */
        .main-view-container__scroll-node {
            background: transparent !important;
        }
    `;
    document.head.appendChild(style);
})();
