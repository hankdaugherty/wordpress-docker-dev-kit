<?php
/**
 * Plugin Name: WP Mail SMTP Mailhog Setup
 * Description: Automatically configures the WP Mail SMTP plugin for Mailhog and prevents automatic redirect to the WP Mail SMTP setup wizard
 * Version: 1.0
 */

// Disable the setup wizard redirect
add_filter('wp_mail_smtp_admin_setup_wizard_redirect_allowed', '__return_false');

// Pre-configure the SMTP settings
add_action('plugins_loaded', function() {
    // Wait for database tables to be ready
    if (!function_exists('get_option') || !function_exists('update_option')) {
        return;
    }

    // Make sure wp_mail_smtp plugin is active
    if (!function_exists('wp_mail_smtp')) {
        return;
    }

    $desired_config = array(
        'mail'    => array(
            'mailer'       => 'smtp',
            'from_email'   => 'no-reply@example.test',
            'from_name'    => 'Local Dev',
        ),
        'smtp'    => array(
            'host'           => 'mailhog',
            'port'          => 1025,
            'encryption'    => 'none',
            'auth'          => false,
            'autotls'       => false,
            'user'          => '',
            'pass'          => '',
        ),
        'general' => array(
            'summary_report_email_disabled' => true,
        ),
        'setup_wizard_completed' => true
    );

    // Update the main SMTP settings
    if (get_option('wp_mail_smtp') !== $desired_config) {
        update_option('wp_mail_smtp', $desired_config);
    }

    // Mark the setup wizard as completed
    update_option('wp_mail_smtp_setup_wizard_completed', true);
    update_option('wp_mail_smtp_activation_prevent_redirect', true);
    update_option('wp_mail_smtp_activation', true);
}, 20); // Higher priority number to run after other plugins are loaded 