define httpd::vhost(
  $docroot,
  $port = 80,
  $options = hiera(httpd::options),
  $owner = hiera(httpd::user),
  $group = hiera(httpd::group),
  $mode = 644,
) {

# Ensure that the documentroot exists
  file { $docroot:
    ensure => directory,
    owner => $owner,
    group => $group,
    mode => 775,
    require => Package['httpd'],
    subscribe => Exec['makerootdir-p']
  }

  exec { 'makerootdir-p':
    command => "/usr/bin/mkdir -p $docroot"
  }

# Create vhost configuration before creating the symbolic link which enables the vhosts
  file { "/etc/httpd/conf.d/${name}.conf":
    ensure => file,
    owner => 'root',
    group => 'root',
    require => Package['httpd'],
    content => template('httpd/vhost.erb'),
    notify => Service['httpd'],
  }
}
