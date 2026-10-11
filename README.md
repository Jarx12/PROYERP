# PROYERP

PROYERP is a self-hosted ERP web application built with Ruby on Rails. It centralizes a company's daily operations — inventory, human resources, documents, finances and vehicle fleet — behind a single dashboard with per-module user permissions.

## Features

| Module | Description |
| --- | --- |
| 🏠 Inicio (Dashboard) | Overview / home panel. Always accessible. |
| 📦 Inventario | Products, stock movements, warehouses and categories. |
| 👨‍💼 Empleados | Employee records, positions and bulk payroll. |
| 📁 Documentos | Document management with Active Storage attachments. |
| 📊 Finanzas | Bank accounts, transaction categories and financial transactions (with bulk import). |
| 🚗 Vehículos | Vehicle fleet, vehicle categories and assignments. |
| ⚙️ Configuración | Positions, categories, warehouses, transaction categories, bank accounts and projects. |
| 🔐 Usuarios | User accounts with superuser flag and per-module read/write permissions. |

Additional capabilities:

- **Authentication** with `has_secure_password` (bcrypt); users can sign in with username or email.
- **Authorization** via module-level permissions (read/write) defined in `ErpModule`; superusers bypass all checks.
- **Soft delete** for employees (`discard` gem) with restore support.
- **Pagination** with Kaminari.
- **Public marketing pages** (home, about, solutions, projects, contact).
- **PWA support** and health check at `/up`.

## Tech stack

- Ruby 3.4.5 / Rails 8.1
- SQLite 3 (with Solid Cache, Solid Queue and Solid Cable for production)
- Hotwire (Turbo + Stimulus) with importmap-rails and Propshaft
- Puma web server

## Requirements

- Ruby 3.4.5 (see `.ruby-version`)
- Bundler

## Getting started

```bash
# Clone the repository
git clone https://github.com/Jarx12/PROYERP.git
cd PROYERP

# Install dependencies and prepare the database
bin/setup
```

`bin/setup` installs gems, runs `bin/rails db:prepare`, clears logs/tmp and starts the dev server. To skip starting the server:

```bash
bin/setup --skip-server
```

Then start the app manually:

```bash
bin/dev   # starts bin/rails server
```

## Project structure

```
app/
  controllers/   # RESTful controllers per ERP module
  models/        # Domain models + ErpModule/Permission authorization
  views/         # ERB templates (dashboard, modules, public pages)
  javascript/    # Stimulus controllers
db/migrate/      # ActiveRecord migrations
test/            # Minitest: models, controllers, integration, system
config/          # Routes, database, Kamal deploy config
```

