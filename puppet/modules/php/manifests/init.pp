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
    'php-bcmath',
    'php-mbstring'
  ]:
    ensure => 'present',
    notify => Service['httpd']
  }
}