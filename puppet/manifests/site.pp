node "example.com" {
  hiera_include('classes')

  if  defined(Class['httpd']) {
    create_resources(httpd::vhost, hiera('vhosts'))
  }

  if defined(Class['mariadb']) {
    create_resources(mariadb::database, hiera('databases'))
  }
}