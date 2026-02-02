const CACHE_NAME = 'nutrit-v3';
const ASSETS_TO_CACHE = [
  './',
  'manifest.json',
  'assets/css/style.css',
  'assets/css/landing.css',
  'assets/icons/icon-192x192.png',
  'assets/icons/icon-512x512.png'
];

// Install event: cache core assets
self.addEventListener('install', (event) => {
  console.log('ServiceWorker: Install Event');
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('ServiceWorker: Caching core assets');
      return Promise.allSettled(
        ASSETS_TO_CACHE.map(asset => {
          return cache.add(asset).catch(err => {
            console.error('ServiceWorker: Failed to cache asset:', asset, err);
          });
        })
      );
    })
  );
});

// Fetch event: Network First for HTML, Cache First for others
self.addEventListener('fetch', (event) => {
  if (event.request.mode === 'navigate') {
    event.respondWith(
      fetch(event.request)
        .catch(() => {
          return caches.match(event.request);
        })
    );
  } else {
    event.respondWith(
      caches.match(event.request)
        .then((response) => {
          if (response) {
            return response;
          }
          return fetch(event.request);
        })
    );
  }
});

// Activate event: clean up old caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            return caches.delete(cacheName);
          }
        })
      );
    }).then(() => {
      return self.clients.claim();
    })
  );
});
