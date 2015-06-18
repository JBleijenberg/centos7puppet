class httpd (
  $user = hiera(httpd::user),
  $group = hiera(httpd::group)
) {
  include firewall

  package { 'httpd':
    ensure => 'latest',
    before => File['/etc/httpd/conf/httpd.conf']
  }

  file { '/etc/httpd/conf/httpd.conf':
    ensure => file,
    owner => 'root',
    group => 'root',
    content => template('httpd/httpd.conf.erb'),
    before => Service['httpd']
  }

  class { selinux :
    mode => 'disabled',
    before => Service['httpd']
  }

  service {'httpd':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }

  firewall { '100 allow http and https access':
    port   => [80, 443],
    proto  => tcp,
    action => accept,
  }
}