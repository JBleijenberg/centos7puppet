class php
{
  package { [
    'php',
    'php-cli',
    'php-common',
    'php-gd',
    'php-mysql',
    'php-mcrypt',
    'php-xml',
    'php-xmlrpc',
    'php-bcmath'
  ]:
    ensure => 'present',
    notify => Service['httpd']
  }
}