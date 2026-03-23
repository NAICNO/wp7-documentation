// Clear browser cache
//
//
function clearCache() {
  if (typeof window !== 'undefined' && 'caches' in window) {
    // Clearing cache for modern browsers
    caches.keys().then(function(cacheNames) {
      cacheNames.forEach(function(cacheName) {
        caches.delete(cacheName);
      });
    });
  }

  // Clearing cache for older browsers
  if (typeof window !== 'undefined' && 'localStorage' in window) {
    window.localStorage.clear();
  }

  // Reload the page to ensure the cache is cleared
  window.location.reload(true);
}
