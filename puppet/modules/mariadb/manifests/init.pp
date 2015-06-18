class mariadb (
  $root_passwd = hiera(mariadb::root::passwd),
  $host = hiera(mariadb::default::host),
) {
  package { ['MySQL-python','mariadb-server']:
    ensure => 'latest',
  }->

  # Create a bash script where we can check if a sql query has result or not
  file { '/opt/scripts':
    ensure => directory
  }->
  file { '/opt/scripts/rundbquery':
    ensure => file,
    mode => 755,
    owner => 'root',
    group => 'root',
    content => template('mariadb/rundbquery.erb')
  }->

  # Enable mariaDB
  service { 'mariadb':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }->

  # Change/add root password
  exec { 'change-root-passwd':
    command => "/usr/bin/mysql -uroot -e \"SET PASSWORD FOR 'root'@'${host}' = PASSWORD('${root_passwd}');\"",
    unless => "/usr/bin/mysql -uroot -p${root_passwd}"
  }
}
