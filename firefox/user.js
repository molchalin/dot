// Don't warn about making changes in about:config
user_pref("browser.aboutConfig.showWarning", false);

// Load userChrome.css at startup
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Never show bookmarks
user_pref("browser.toolbars.bookmarks.visibility", "never");

// Resume previous session on open
user_pref("browser.startup.page", 3);

// Disable pinned tabs under the search bar.
user_pref("browser.newtabpage.activity-stream.topSitesRows", 0);

// Do not suggest to save password into Firefox Password Manager
user_pref("signon.rememberSignons", false);

user_pref("browser.translations.automaticallyPopup", false);

user_pref("extensions.formautofill.creditCards.enabled", false);

// light theme
user_pref("layout.css.prefers-color-scheme.content-override", 1);
