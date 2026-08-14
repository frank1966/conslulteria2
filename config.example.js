// 1. Copia este archivo y renómbralo a "config.js" (ese sí queda ignorado por git).
// 2. Reemplaza los valores con los de tu proyecto de Supabase:
//    Project Settings → API → Project URL / anon public key.
// 3. La "anon key" es pública por diseño (se usa en el navegador); la seguridad real
//    la da la política de RLS definida en supabase/schema.sql (solo permite INSERT).

window.SUPABASE_URL = "https://tuproyecto.supabase.co";
window.SUPABASE_ANON_KEY = "eyJhbGciOi...";