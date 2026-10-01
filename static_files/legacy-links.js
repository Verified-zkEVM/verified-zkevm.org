// Preserve bookmarks to sections of the original single-page website.
(() => {
  const destinations = {
    "#overview": "project/",
    "#tracks": "project/",
    "#documentation": "resources/",
    "#activity": "resources/",
    "#grants": "grants/",
    "#contact": "contact/",
  };

  const redirect = () => {
    const target = destinations[window.location.hash];
    if (target) {
      window.location.replace(new URL(target, document.baseURI).href);
    }
  };

  redirect();
  window.addEventListener("hashchange", redirect);
})();
