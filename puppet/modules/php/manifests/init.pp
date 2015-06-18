class php
{
  package { ['php', 'php-cli', 'php-common', 'php-gd', 'php-mysql', 'php-mcrypt']:
    ensure => 'present',
    notify => Service['httpd']
  }
}