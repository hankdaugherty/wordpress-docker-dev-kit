# WordPress Docker Development Environment

A streamlined WordPress development environment using Docker, with automated SMTP configuration for email testing via MailHog, a curated set of pre-installed plugins, and a default child theme based on a parent theme (default is Neve).  
*Based on the excellent [wordpress-docker-compose](https://github.com/nezhar/wordpress-docker-compose) by [nezhar](https://github.com/nezhar).*

---

## Table of Contents

- [Using This Template](#using-this-template)
- [Features](#features)
- [Access Your Development Environment](#access-your-development-environment)
- [Customizing Your Environment](#customizing-your-environment)
  - [Changing the Theme](#changing-the-theme)
  - [Adding or Removing Pre-installed Plugins](#adding-or-removing-pre-installed-plugins)
  - [How MailHog Works](#how-mailhog-works)
- [Directory Structure](#directory-structure)
- [Plugin & Theme Development](#plugin--theme-development)
  - [Plugin Development](#plugin-development)
  - [Theme Development](#theme-development)
- [Cleanup](#cleanup)
- [WSL2 and Other Users](#wsl2-and-other-users)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

---

## Using This Template

This is a template repository. To start a new project:
1. Click the "Use this template" button at the top of this repository.
2. Name your new project and create your repository.
3. Clone your new repository into a directory of your choice:
   ```bash
   git clone https://github.com/hankdaugherty/wordpress-docker-template.git my-project
   cd my-project
   ```
4. Review and edit `env.example` if you want to change any defaults (for example, WordPress admin email, username, or preferred theme).
5. Run the setup script:
   ```bash
   chmod +x scripts/setup.sh
   ./scripts/setup.sh
   ```
   **Note:** The setup script automatically creates a `.env` file from `env.example` (including secure, random passwords), so you do not have to create one manually.

---

## Features

- **WordPress with Apache:** Runs the latest WordPress with Apache and PHP settings from `config/wp_php.ini`.
- **Database:** MySQL 5.7 with persistent data stored in `wp-data/`.
- **phpMyAdmin:** Accessible at [http://localhost:8080](http://localhost:8080) for database administration.
- **WP-CLI:** Automates tasks like installing WordPress core, themes, and plugins.
- **MailHog:** Captures all outgoing emails for testing (access via [http://localhost:8025](http://localhost:8025)).
- **Pre-installed Plugins:** A curated set of plugins (Advanced Custom Fields, WPForms Lite, Redirection, Google Site Kit, Query Monitor, WP-Optimize, Duplicate Post, and WP Mail SMTP configured for MailHog) installed automatically.
- **Themes:** Neve is the default parent theme (configurable via the `env.example` file) with a pre-configured child theme located in the `child-theme/` directory. You can substitute any theme you wish.
- **Helper Scripts:** 
  - `scripts/setup.sh` initializes the environment, generates the `.env` file, and creates required directories.
  - `scripts/teardown.sh` stops containers and removes persistent data from `wp-app/` and `wp-data/`.

---

## Access Your Development Environment

- **WordPress Site:** [http://localhost:8000](http://localhost:8000)
- **WordPress Admin:** [http://localhost:8000/wp-admin](http://localhost:8000/wp-admin)
- **phpMyAdmin:** [http://localhost:8080](http://localhost:8080)
- **MailHog (Email Testing):** [http://localhost:8025](http://localhost:8025)

---

## Customizing Your Environment

### Changing the Theme

- **Default Setting:** Neve is the default parent theme (set via the `WORDPRESS_PARENT_THEME` variable in `env.example`).
- **To Use a Different Theme:**  
  1. Edit `env.example` and update the `WORDPRESS_PARENT_THEME` value to your preferred theme's slug.
  2. Update the `child-theme/style.css` file's `Template:` field if you wish to maintain a child theme.
  3. Re-run `scripts/setup.sh` so the new settings (including the parent theme) are applied.

### Adding or Removing Pre-installed Plugins

The pre-installed plugins are automatically installed via the `wpcli` service's command in `docker-compose.yml`. To modify the list:
1. Open `docker-compose.yml` and locate the command block in the `wpcli` service that installs plugins.
2. You'll see a command like:
   ```bash
   wp plugin install advanced-custom-fields wpforms-lite redirection google-site-kit query-monitor wp-optimize duplicate-post wp-mail-smtp --activate --allow-root;
   ```
3. **To remove a plugin,** delete its slug from the list.
4. **To add a plugin,** insert its slug into the list (ensure it matches the plugin's wordpress.org slug).
5. Save your changes and re-run the containers (or run the updated WP-CLI commands manually).

### How MailHog Works

MailHog is set as your SMTP server. All outgoing emails from WordPress are intercepted and captured by MailHog, so you can test email functionality without sending real emails. View captured emails at:
- [http://localhost:8025](http://localhost:8025)

---

## Directory Structure

- **`wp-app/`** – Generated WordPress core files (populated on the first run)
- **`wp-data/`** – MySQL data and related storage
- **`config/`** – Configuration files:
  - `mu-plugins/` – Must-use plugins
  - `wp-cli.yml` – WP-CLI configuration
  - `mysql.cnf` – MySQL server configuration
  - `apache_servername.conf` – Apache configuration for setting ServerName
- **`child-theme/`** – The pre-configured child theme directory
- **`scripts/`** – Utility scripts:
  - `setup.sh` – Initializes the environment (creates `.env`, sets up directories, starts Docker)
  - `teardown.sh` – Stops Docker containers and removes persistent data (`wp-app/` and `wp-data/`)

---

## Plugin & Theme Development

### Plugin Development

To develop a plugin, mount your plugin's directory in the `docker-compose.yml` file. For example:
```yaml
volumes:
  - ./plugin-name/trunk/:/var/www/html/wp-content/plugins/plugin-name
```
Any changes you make locally will be instantly reflected in the container.

### Theme Development

- Edit files in the `child-theme/` directory.
- The child theme is mounted automatically, so changes are reflected immediately.
- Use the WordPress Customizer to preview and adjust theme settings.

---

## Cleanup

To fully remove all Docker containers and delete generated files, run:
```bash
chmod +x scripts/teardown.sh
./scripts/teardown.sh
```
Alternatively, you can use:
```bash
docker-compose down -v
```
**Note:** The teardown script also removes the `wp-app/` and `wp-data/` directories.

---

## WSL2 and Other Users

- **WSL2 Users:** No special configuration is required; file permissions are automatically handled.
- **Other Users:** If you encounter file permission issues, manually adjust permissions as needed.

---

## Contributing

Feel free to open issues or submit pull requests with your improvements.

---

## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- Original repository by [nezhar](https://github.com/nezhar/wordpress-docker-compose)
- [WordPress](https://wordpress.org/)
- [Docker](https://www.docker.com/)
- [MailHog](https://github.com/mailhog/MailHog)
- [Neve Theme](https://themeisle.com/themes/neve/)
