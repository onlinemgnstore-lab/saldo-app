// Saldo — service worker
//
// Objetivo simples: deixar o app abrir rápido e funcionar offline para telas
// já visitadas (o ícone na tela inicial, sem precisar de internet pra abrir).
// Os dados financeiros em si (lançamentos, contas fixas) sempre vêm do
// Supabase ao vivo — este arquivo nunca guarda nem decide sobre eles.
//
// Se precisar forçar todo mundo a buscar a versão mais nova do app, basta
// mudar o texto de CACHE_NAME (ex.: "saldo-v2") e publicar de novo.

const CACHE_NAME = "saldo-v1";
const CORE_ASSETS = [
  "./",
  "./index.html",
  "./manifest.json",
  "./icon-192.png",
  "./icon-512.png",
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => cache.addAll(CORE_ASSETS))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys()
      .then((names) => Promise.all(
        names.filter((n) => n !== CACHE_NAME).map((n) => caches.delete(n))
      ))
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", (event) => {
  const req = event.request;

  // Só cuida de pedidos GET do próprio site (HTML, manifest, ícones).
  // Chamadas ao Supabase (auth/dados) e ao CDN do supabase-js passam direto
  // pela rede, sem passar por aqui — são sempre dados ao vivo.
  if (req.method !== "GET" || new URL(req.url).origin !== self.location.origin) {
    return;
  }

  event.respondWith(
    fetch(req)
      .then((res) => {
        const copy = res.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(req, copy));
        return res;
      })
      .catch(() => caches.match(req).then((cached) => cached || caches.match("./index.html")))
  );
});
