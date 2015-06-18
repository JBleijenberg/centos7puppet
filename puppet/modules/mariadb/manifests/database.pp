define mariadb::database (
  $user,
  $passwd,
  $host = hiera(mariadb::default::host),
  $grant = hiera(mariadb::default::grant)
) {

  $rootuser = hiera(mariadb::root::user)
  $rootpasswd = hiera(mariadb::root::passwd)

  if $passwd == '' {
    fail("Password is required for creating a MySQL user")
  }

  # Create a new database if it doesn't exist yet.
  exec { "create-database-${name}":
    command => "/usr/bin/mysql -u${rootuser} -p${rootpasswd} -e \"CREATE DATABASE ${name};\"",
    before => Exec["set-privileges-${name}"],
    unless => "/opt/scripts/rundbquery ${rootpasswd} \"SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '${name}'\""
  }

  # After creating the user, grant their privileges on the database
  exec { "set-privileges-${name}":
    command => "/usr/bin/mysql -u${rootuser} -p${rootpasswd} -e \"GRANT ${grant} ON ${name}.* TO '${user}'@'${host}' IDENTIFIED BY '${passwd}';\"",
    unless => "/opt/scripts/rundbquery ${rootpasswd} \"SELECT * FROM mysql.user WHERE user = '${user}'\""
  }

  # Flush privileges
  exec { 'flush-privileges':
    refreshonly => true,
    command => "/usr/bin/mysql -u${rootuser} -p${rootpasswd} -e \"FLUSH PRIVILEGES;\"",
    subscribe => Exec["set-privileges-${name}"]
  }
}