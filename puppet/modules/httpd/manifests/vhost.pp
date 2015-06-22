define httpd::vhost(
  $docroot,
  $port = 80,
  $options = hiera(httpd::options),
  $owner = hiera(httpd::user),
  $group = hiera(httpd::group),
  $mode = 644,
) {

  exec { "makerootdir-p-${name}":
    command => "/usr/bin/mkdir -p $docroot"
  }->

  # Ensure that the documentroot exists with the correct permissions
  file { $docroot:
    ensure => directory,
    owner => $owner,
    group => $group,
    mode => 775,
    require => Package['httpd']
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
