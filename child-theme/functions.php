<?php
/**
 * Child Theme Functions
 */

if (!defined('ABSPATH')) {
    exit; // Exit if accessed directly
}

/**
 * Enqueue parent theme style
 */
function child_theme_enqueue_styles() {
    $parent_style = 'parent-style';
    
    wp_enqueue_style($parent_style, 
        get_template_directory_uri() . '/style.css'
    );
    
    wp_enqueue_style('child-style',
        get_stylesheet_directory_uri() . '/style.css',
        array($parent_style),
        wp_get_theme()->get('Version')
    );
}
add_action('wp_enqueue_scripts', 'child_theme_enqueue_styles');

/**
 * Add your custom functions below
 */ 