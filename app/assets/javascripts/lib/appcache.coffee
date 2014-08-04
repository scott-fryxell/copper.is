appCache = window.applicationCache

switch (appCache.status)
  case appCache.UNCACHED: # UNCACHED == 0
    return 'UNCACHED'
    break
  case appCache.IDLE: # IDLE == 1
    return 'IDLE'
    break
  case appCache.CHECKING: # CHECKING == 2
    return 'CHECKING'
    break
  case appCache.DOWNLOADING: # DOWNLOADING == 3
    return 'DOWNLOADING'
    break
  case appCache.UPDATEREADY:  # UPDATEREADY == 4
    return 'UPDATEREADY'
    break
  case appCache.OBSOLETE: # OBSOLETE == 5
    return 'OBSOLETE'
    break
  default:
    return 'UKNOWN CACHE STATUS'
    break


# update cache
appCache.update() # Attempt to update the user's cache.

if appCache.status == appCache.UPDATEREADY
  appCache.swapCache()  # The fetch was successful, swap in the new cache.


# Check if a new cache is available on page load.
$ ->
  appCache.addEventListener 'updateready', ->
    if appCache.status == appCache.UPDATEREADY
      # Browser downloaded a new app cache.
      window.location.reload();



function handleCacheEvent(e) {
  appCache.swapCache()
}

function handleCacheError(e) {
  alert('Error: Cache failed to update!');
};

# Fired after the first cache of the manifest.
appCache.addEventListener('cached', handleCacheEvent, false);

# Checking for an update. Always the first event fired in the sequence.
appCache.addEventListener('checking', handleCacheEvent, false);

# An update was found. The browser is fetching resources.
appCache.addEventListener('downloading', handleCacheEvent, false);

# The manifest returns 404 or 410, the download failed,
# or the manifest changed while the download was in progress.
appCache.addEventListener('error', handleCacheError, false);

# Fired after the first download of the manifest.
appCache.addEventListener('noupdate', handleCacheEvent, false);

# Fired if the manifest file returns a 404 or 410.
# This results in the application cache being deleted.
appCache.addEventListener('obsolete', handleCacheEvent, false);

# Fired for each resource listed in the manifest as it is being fetched.
appCache.addEventListener('progress', handleCacheEvent, false);

# Fired when the manifest resources have been newly redownloaded.
appCache.addEventListener('updateready', handleCacheEvent, false);
