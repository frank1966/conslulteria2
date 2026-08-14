-- Ejecuta esto en Supabase: Dashboard → SQL Editor → New query → pega y corre "Run".

create table if not exists public.suscriptores (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  apellido text not null,
  telefono text not null,
  correo text not null,
  created_at timestamptz not null default now()
);

-- Evita duplicar el mismo correo en la lista.
create unique index if not exists suscriptores_correo_key on public.suscriptores (lower(correo));

-- Row Level Security: nadie puede leer, actualizar ni borrar desde el navegador.
-- Solo se permite insertar (registrar), que es lo único que hace el formulario público.
alter table public.suscriptores enable row level security;

create policy "Cualquiera puede registrarse en el newsletter"
  on public.suscriptores
  for insert
  to anon
  with check (true);

-- Desde 2026 Supabase ya no expone las tablas nuevas a la API pública por
-- defecto: la política de RLS de arriba no basta, también hace falta este
-- GRANT explícito (es una capa distinta: RLS decide qué filas, GRANT decide
-- si el rol puede tocar la tabla siquiera).
grant usage on schema public to anon;
grant insert on public.suscriptores to anon;

-- (Opcional) Si luego quieres ver los registros desde el dashboard de Supabase,
-- no necesitas una policy de SELECT: el dashboard usa la service_role key,
-- que se salta RLS. No la uses nunca en el frontend.
