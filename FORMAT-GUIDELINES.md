# Format guidelines

Rules for composing and maintaining stacks in this repo. Use these rules in future prompts when adding, changing, or reviewing compose files and env samples.

---

## 1. Directory and file layout

- **One stack per directory.** Each directory contains a `compose.yml` (or `compose.yaml`).
- No other compose filename unless there is a clear reason (e.g. a second variant in the same folder).

---

## 2. Compose file

### 2.1 No version field

- **Do not include a `version:` key** in any compose file. The Compose Specification has deprecated it; omit it for compatibility.

### 2.2 File header (every compose)

At the top of every `compose.yml`, include a **title**, **short description**, and **links** in this style:

```yaml

################################
# 📦 STACK-NAME COMPOSE #
################################
# One-line description of what the stack does.
# 🔗 Primary URL for the project
# 🔗 Git repository (if different from primary)
# 🔗 Documentation
################################
```

**Links to provide (when available):**

1. **Primary URL** – main website or product home.
2. **Git link** – GitHub/GitLab etc., only if different from the main site.
3. **Documentation** – official docs (install, config, env vars).

Example (single-service):

```yaml

################################
# 📦 JELLYFIN COMPOSE #
################################
# Media server; stream movies, TV, and music to clients.
# 🔗 https://jellyfin.org/
# 🔗 https://jellyfin.org/docs/general/administration/configuration/
################################
```

Another (with Git separate from main site):

```yaml

################################
# 📦 IMMICH COMPOSE #
################################
# Self-hosted photo and video backup; mobile app sync and web gallery.
# 🔗 https://immich.app/
# 🔗 https://immich.app/docs/install/environment-variables/
################################
```

Keep formatting consistent: same `#` bar length, one line per link, blank line above the block.

### 2.3 Multi-service stacks

If the compose file defines **multiple services**:

- **Main header**: describe the **whole stack** (what the compose is), then the three link types for the stack or primary app.
- **Per service**: above or beside each logical service, add a **small block** with:
  - Title (e.g. `# 🔹🔹 LIDARR  🔹🔹`)
  - Short description
  - Same link types (primary, Git, docs) for that service

Example:

```yaml

################################
# 📦 DOWNLOAD-STACK COMPOSE #
################################
# Multiple services: gluetun (VPN), prowlarr, radarr, lidarr, sonarr,
# readarr, bazarr, qbittorrent, jellyseerr, unpackerr, pinchflat, proxy.
# Primary (gluetun):
################################

services:
  # ...
  # 📦 LIDARR  📦
  # Music collection manager for Usenet and BitTorrent.
  # 🔗 https://wiki.servarr.com/lidarr
  # 🔗 https://github.com/Lidarr/Lidarr
  lidarr:
    # ...
```

Apply the same structure to every service in the file so formatting is consistent.

### 2.4 Passwords, secrets, and environment variables

- **Reference passwords and secrets from outside the compose file** (e.g. `.env`). Do not hardcode them in `compose.yml`. Use variable substitution:

  ```yaml
  - MYSQL_PASSWORD=${MYSQL_PASSWORD}
  ```

- **Avoid repeating the same secret under different names** when a stack has both a DB service and an app that connect to it. Use a **single common variable** in `.env` and reference it in both places:

  **Avoid:** two separate vars for the same secret:
  ```yaml
  # DB service
  - MYSQL_PASSWORD=${MYSQL_PASSWORD}
  # App service
  - DB_PASSWORD=${DB_PASSWORD}
  ```

  **Prefer:** one shared variable (e.g. `DB_PASS` in `.env`):
  ```yaml
  # DB service
  - MYSQL_PASSWORD=${DB_PASS}
  # App service
  - DB_PASSWORD=${DB_PASS}
  ```

  Document the single variable (e.g. `DB_PASS`) in `env.sample`.

- **Prefer explicit env reference** for clarity. A bare variable name (e.g. `- TRUSTED_PROXIES`) still reads from `.env`, but the explicit form makes the external reference obvious:

  **Preferred:**
  ```yaml
  - TRUSTED_PROXIES=${TRUSTED_PROXIES}
  ```

  **Acceptable but less explicit:** `- TRUSTED_PROXIES`

- **Fallback defaults are acceptable** when you want a default value if the variable is unset:

  ```yaml
  image: ${AUTHENTIK_IMAGE:-ghcr.io/goauthentik/server}:${AUTHENTIK_TAG:-2026.2.0}
  ```

  Document any such variables and their defaults in `env.sample`.

---

## 3. Env sample (`env.sample`)

### 3.1 When to add it

- Provide an `env.sample` (or equivalent) **where applicable** when the stack uses environment variables (especially required or security-sensitive ones).
- Name the file `env.sample`. Users copy or rename it to `.env` and adjust.

### 3.2 File header

Start with a short intro and a “See” link to official env/docs:

```text
# App Name - Sample .env file
# Copy or rename this file to `.env` and adjust values as needed
# See: https://example.com/docs/env
```

### 3.3 Section headers

Group variables into **sections with clear headers**. Use a consistent separator and title style, e.g.:

```text
# -----------------------------------------------------------------------------
# Section name (required / optional)
# -----------------------------------------------------------------------------
VAR_NAME=value
ANOTHER_VAR=value
```

Example for a required application URL:

```text
# -----------------------------------------------------------------------------
# Application URL (required)
# -----------------------------------------------------------------------------
# Base URL where the app is reached (e.g. https://app.example.com)
APP_BASE_URL=https://app.example.com
```

Use **(required)** or **(optional)** in the section header where it helps. Keep formatting consistent across all stacks.

### 3.4 SSO / Authentik tip

For applications that support **SSO** (e.g. OIDC/SAML), add a short tip at the end of `env.sample` (or in the relevant section) with a link to the Authentik configuration guide when one exists:

```text
# Tip: If you are using authentik follow this guide for SSO.
# https://integrations.goauthentik.io/...
```

Adjust the URL to the correct Authentik integration page for that app.

---

## 4. General formatting

- **Presentable and consistent**: same style for comments, spacing, and section breaks across compose files and env samples.
- **Clean**: avoid redundant or noisy comments; keep link blocks and section headers easy to scan.
- **Traefik / networks / volumes**: follow existing patterns in the repo (e.g. `proxy` network, `DEFAULT_DOMAIN`, `PATH_CONFIG` / `PATH_DATA`) so new stacks fit the rest of the collection.

---

## 5. README maintenance

- **After adding or removing a stack (or a service within a multi-service stack), update `README.md`** so it reflects the current set of stacks and services.
- Keep the same structure: categories, tables, and link style (e.g. `[Stack](path/)`, service links where used).
- Ensure the new or changed stack is listed in the right section and has a short, accurate description.

---

## Quick reference

| Item | Rule |
|------|------|
| Compose version | Omit `version:` |
| Compose header | Title + description + primary URL + Git (if different) + docs |
| Multi-service | Main header for stack; per-service block (title, description, links) |
| `env.sample` | Header + “Copy to .env” + “See” link; section headers for variable groups |
| SSO apps | Add Authentik integration link as a tip in `env.sample` |
| Passwords/secrets | Reference from outside compose (e.g. `${MYSQL_PASSWORD}`); never hardcode |
| Shared DB secret | Use one common var (e.g. `DB_PASS`) for both DB and app; document in `env.sample` |
| Env vars | Prefer explicit `${VAR}` form; fallback defaults `${VAR:-default}` are acceptable |
| README | Update when adding/removing stacks or services |

These guidelines are the source of truth for future edits and new stacks in this repository.
