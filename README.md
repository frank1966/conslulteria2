# Nexo AI — Landing page

Landing page estática (HTML/CSS/JS puro, sin build) para la consultoría de
automatización con IA, con formulario de newsletter conectado a Supabase.

## Estructura

```
├── index.html            → toda la página (secciones + estilos + lógica)
├── vendor-supabase.js      → librería de Supabase incluida localmente (no depende de un CDN externo)
├── config.js               → credenciales de Supabase (NO se sube al repo)
├── config.example.js      → plantilla para crear tu config.js
├── vercel.json             → configuración mínima de despliegue
├── .gitignore
└── supabase/
    └── schema.sql          → crea la tabla "suscriptores" con RLS y permisos
```

---

## 1. Subirlo a GitHub

```bash
cd nexo-ai-landing
git init
git add .
git commit -m "Landing page inicial"
git branch -M main
git remote add origin https://github.com/TU-USUARIO/nexo-ai-landing.git
git push -u origin main
```

`config.js` está en `.gitignore`, así que tus credenciales reales de Supabase
nunca se suben al repositorio (solo `config.example.js`, que es la plantilla).

---

## 2. Crear el proyecto en Supabase

1. Entra a [supabase.com](https://supabase.com) → **New project**.
2. Cuando esté listo, ve a **SQL Editor → New query**, pega el contenido de
   `supabase/schema.sql` y dale **Run**. Esto crea la tabla `suscriptores`
   (nombre, apellido, telefono, correo) con seguridad a nivel de fila (RLS):
   el formulario público solo puede **insertar** registros, nunca leerlos,
   editarlos ni borrarlos.
3. Ve a **Project Settings → API** y copia:
   - **Project URL**
   - **anon public key**
4. En tu copia local del proyecto, duplica `config.example.js` como `config.js`
   y pega ahí esos dos valores:

   ```js
   window.SUPABASE_URL = "https://tuproyecto.supabase.co";
   window.SUPABASE_ANON_KEY = "eyJhbGciOi...";
   ```

Para revisar los registros que lleguen, ve a **Table Editor → suscriptores**
dentro del dashboard de Supabase (el dashboard usa una llave con permisos de
administrador, distinta a la `anon key`, así que sí puede leerlos).

---

## 3. Desplegar en Vercel

1. Entra a [vercel.com](https://vercel.com) → **Add New → Project** → importa
   el repo de GitHub que acabas de crear.
2. Vercel detecta el sitio como estático automáticamente (no necesita build
   command ni output directory: es HTML plano en la raíz).
3. Antes de darle **Deploy**, agrega dos **Environment Variables** — aunque
   este sitio no tiene build step y no las lee automáticamente, es el lugar
   recomendado para guardarlas como referencia del equipo:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
4. Como `config.js` no se sube a GitHub, súbelo directamente desde el
   dashboard de Vercel: **Project → Settings → Environment Variables** no
   sirve para archivos estáticos, así que la forma más simple es:
   - Opción A (rápida): quita `config.js` de `.gitignore` en tu propio fork
     privado y súbelo con tus llaves (la `anon key` está diseñada para ser
     pública, así que esto es seguro siempre que la política de RLS de
     `schema.sql` siga activa).
   - Opción B (recomendada para equipos): usa Vercel CLI (`vercel env pull`)
     o un paso de build simple que genere `config.js` a partir de variables
     de entorno antes del deploy.
5. Deploy. Tu landing quedará en `https://tu-proyecto.vercel.app`.

---

## Probar en local

No necesitas servidor especial, pero `fetch`/módulos a veces fallan abriendo
el archivo directo (`file://`). Lo más simple:

```bash
npx serve .
```

y abre la URL que te muestre en terminal.

---

## Notas

- Sin configurar `config.js`, el formulario sigue funcionando en **modo
  demo**: valida los campos y muestra el mensaje de éxito, pero no guarda
  nada (verás un aviso en la consola del navegador).
- La tabla `suscriptores` bloquea correos duplicados (índice único por
  correo en minúsculas).
- Si más adelante quieres enviar los correos automáticamente a un servicio
  de email marketing, lo más sencillo es crear una Supabase Edge Function
  o un Zapier/Make conectado a la tabla `suscriptores`.
