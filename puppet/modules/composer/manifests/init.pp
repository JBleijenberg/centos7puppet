class composer
{

  # Download composer and install it to /usr/bin so it can be used systemwide by calling composer
  # This is only done when composer isn't present at /usr/bin
  exec { 'install-composer':
    cwd => '/tmp',
    command => '/usr/bin/curl -sS https://getcomposer.org/installer | /usr/bin/php -- --install-dir="/usr/bin" -- --filename=composer',
    require => Package['php'],
    unless => '/usr/bin/test -e /usr/bin/composer'
  }->

  # Set composer file permissions to make it executable
  file { '/usr/bin/composer':
    ensure => file,
    mode => 755
  }
}