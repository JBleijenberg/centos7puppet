node default {
  hiera_include('classes')

  if  defined(Class['httpd']) {
    create_resources(httpd::vhost, hiera('vhosts'))
  }

  if defined(Class['mariadb']) {
    create_resources(mariadb::database, hiera('databases'))
  }

  if defined(Class['solr']) {
    create_resources(solr::core, hiera('solr-cores'))
  }

  if (hiera('known_hosts')) {
    $hosts = hiera('known_hosts')

    known_hosts::host{ $hosts: }
  }
}