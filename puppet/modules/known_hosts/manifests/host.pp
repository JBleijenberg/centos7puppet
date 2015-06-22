define known_hosts::host{

# Ensure known_hosts exists
  file { '/root/.ssh/know_hosts':
    ensure => file,
    mode => 644
  }->

  # Ensure that the script exist where we can add hosts with
  file { '/tmp/add_known_host.sh':
    ensure => file,
    mode => 0755,
    content => template('known_hosts/add_known_hosts.erb')
  }->

  # Add known host
  exec { "add-known-host-${name}":
    cwd => '/tmp',
    command => '/tmp/add_known_host.sh'
  }
}