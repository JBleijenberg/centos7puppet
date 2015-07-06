class ntp {
  package {[
    'ntp',
    'ntpdate',
    'ntp-doc'
  ]:
  ensure => present}

  $timezone = hiera('ntp::timezone')

  service { 'ntpdate':
    ensure => running,
    require => Package['ntpdate']
  }

  exec { 'add-ntpdate-pool':
    command => '/usr/sbin/ntpdate pool.ntp.org',
    require => Package['ntpdate'],
    notify => Service['ntpdate']
  }

  exec { "set-timezone-${timezone}":
    command => "/usr/bin/timedatectl set-timezone ${timezone}",
    require => Service['ntpdate']
  }
}