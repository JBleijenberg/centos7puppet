node default {
  hiera_include('classes')

  if  defined(Class['httpd']) {
    create_resources(httpd::vhost, hiera('vhosts'))
  }

  if defined(Class['mariadb']) {
    create_resources(mariadb::database, hiera('databases'))
  }

  if hiera('firewall') {
    firewall { '100 allow access':
      port   => hiera('firewall'),
      proto  => tcp,
      action => accept,
    }
  }

  if defined(Class['solr']) {
    create_resources(solr::core, hiera('solr-cores'))
  }
}