# WordPress Docker Development Environment

A streamlined WordPress development environment using Docker, with automated SMTP configuration for email testing.

*Based on the excellent [wordpress-docker-compose](https://github.com/nezhar/wordpress-docker-compose) by [nezhar](https://github.com/nezhar).*

## Features

- WordPress with Apache
- MySQL 5.7
- phpMyAdmin
- WP-CLI
- MailHog for email testing
- Automated SMTP configuration
- Pre-installed theme and plugins
- Child theme template

## Quick Start

1. Clone this repository
2. Run the setup script:
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

## Access Your Development Environment

- WordPress: http://localhost:8000
- WordPress Admin: http://localhost:8000/wp-admin
- phpMyAdmin: http://localhost:8080
- MailHog (Email Testing): http://localhost:8025

## Email Testing

This environment comes with MailHog pre-configured for email testing. All emails sent from WordPress will be automatically captured by MailHog and can be viewed at http://localhost:8025.

## Pre-installed Components

### Theme
- Neve (with child theme template)

### Plugins
- Advanced Custom Fields
- WPForms Lite
- Redirection
- Google Site Kit
- Query Monitor
- WP-Optimize
- Duplicate Post
- WP Mail SMTP (pre-configured for MailHog)

## Directory Structure

- `wp-app/` - WordPress core files (generated)
- `wp-data/` - MySQL data
- `config/` - Configuration files
  - `mu-plugins/` - Must-use plugins
  - `wp-cli.yml` - WP-CLI configuration
  - `mysql.cnf` - MySQL configuration
  - `apache_servername.conf` - Apache configuration
- `neve-child/` - Child theme template

## Plugin Development

To develop a plugin, mount your plugin directory in docker-compose.yml:
```yaml
volumes:
  - ./plugin-name/trunk/:/var/www/html/wp-content/plugins/plugin-name
```

## Theme Development

This environment comes with the Neve theme and a child theme template pre-configured. The child theme is located in `neve-child/` and is automatically mounted in the WordPress container.

To make changes to the child theme:
1. Edit files in the `neve-child` directory
2. Changes will be immediately reflected in your WordPress environment
3. Use the WordPress Customizer for theme settings

## Clean Up

To remove all containers and generated files:
```bash
chmod +x scripts/teardown.sh
./scripts/teardown.sh
```

## WSL2 Users

No special configuration needed! File permissions are handled automatically.

## Other Users

```bash
docker-compose up -d
```

Note: Non-WSL2 users may need to manage file permissions manually if encountering permission issues.

## Contributing

Feel free to open issues or submit pull requests!

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Original repository by [nezhar](https://github.com/nezhar/wordpress-docker-compose)
- [WordPress](https://wordpress.org/)
- [Docker](https://www.docker.com/)
- [MailHog](https://github.com/mailhog/MailHog)

## Development Templates

This repository includes a starter template for WordPress plugin development:

### Plugin Template
Located in `/templates/plugin-template/`, includes:
- Standard WordPress.org plugin structure
- Internationalization support
- Admin hooks setup
- Public hooks setup
- Basic plugin class architecture

To use:
```bash
cp -r templates/plugin-template my-new-plugin
```

### Mounting Your Plugin
Add to docker-compose.yml:
```yaml
volumes:
  - ./my-new-plugin/trunk/:/var/www/html/wp-content/plugins/my-new-plugin
```

## Theme Development

This environment comes with the Neve theme and a child theme template pre-configured. The child theme is located in `neve-child/` and is automatically mounted in the WordPress container.

To make changes to the child theme:
1. Edit files in the `neve-child` directory
2. Changes will be immediately reflected in your WordPress environment
3. Use the WordPress Customizer for theme settings

