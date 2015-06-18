class redis (
  $runasdeamon = hiera(redis::default::runasdeamon),
  $port = hiera(redis::default::port),
  $bind = hiera(redis::default::bind),
  $databases = hiera(redis::default::databases)
) {

  # Install redis
  package { 'redis':
    ensure => 'latest'
  }->

  # Set redis configuration
  file { '/etc/redis.conf':
    ensure => file,
    content => template('redis/conf.erb')
  }->

  # Ensure redis is enabled and running
  service { 'redis':
    ensure => running,
    enable => true
  }
}