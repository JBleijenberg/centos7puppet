class solr (
  $version = '4.8.1'
) {
  # Install Java
  package { 'java-1.8.0-openjdk':
    ensure => latest
  }->

  # Install tomcat
  package { [
    'tomcat',
    'tomcat-admin-webapps',
    'tomcat-docs-webapp',
    'tomcat-webapps'
  ]:
    ensure => latest
  }->

  # Download solr
  exec { "download-solr-${version}":
    cwd => '/tmp',
    command => "/usr/bin/curl -sS http://archive.apache.org/dist/lucene/solr/${version}/solr-${version}.tgz -o solr-${version}.tgz",
    timeout => 8000,
    unless => "/usr/bin/test -f /tmp/solr-${version}.tgz",
    logoutput => true
  }->

  # Create solr directory
  file { '/opt/solr':
    ensure => directory
  }->

  # Unpack and install solr
  exec { "unpack-solr-${version}":
    cwd => '/tmp',
    onlyif => "/usr/bin/test -f /tmp/solr-${version}.tgz",
    command => "/usr/bin/tar -zxvf solr-${version}.tgz --strip 1 -C /opt/solr/",
  }->

  # Create example core
  exec { 'create-example-core':
    command => '/usr/bin/mv /opt/solr/example /opt/solr/core',
    unless => '/usr/bin/test -d /opt/solr/example'
  }->

  # Create bash script
  file { '/etc/init.d/solr':
    ensure => file,
    mode => 0755,
    content => template('solr/bash.erb')
  }->

  # Open firewall
  firewall { '100 allow tomcat access':
    port   => 8080,
    proto  => tcp,
    action => accept,
  }->

  # Enable tomcat
  service { 'tomcat':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true
  }

  # Enable solr
  # Enable tomcat
  service { 'solr':
    ensure     => running,
    require => File['/etc/init.d/solr']
  }
}