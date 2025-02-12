<?php
/**
 * Plugin Name: Plugin Template
 * Plugin URI: https://example.com/plugin-template
 * Description: A starter template for WordPress plugins
 * Version: 1.0.0
 * Author: Your Name
 * Author URI: https://example.com
 * Text Domain: plugin-template
 * Domain Path: /languages
 * License: GPL v2 or later
 * License URI: http://www.gnu.org/licenses/gpl-2.0.txt
 */

// If this file is called directly, abort.
if (!defined('WPINC')) {
    die;
}

// Define plugin constants
define('PLUGIN_TEMPLATE_VERSION', '1.0.0');
define('PLUGIN_TEMPLATE_PATH', plugin_dir_path(__FILE__));
define('PLUGIN_TEMPLATE_URL', plugin_dir_url(__FILE__));

// Include core plugin class
require_once PLUGIN_TEMPLATE_PATH . 'includes/class-plugin-template.php';

// Initialize the plugin
function run_plugin_template() {
    $plugin = new Plugin_Template();
    $plugin->run();
}
run_plugin_template(); 