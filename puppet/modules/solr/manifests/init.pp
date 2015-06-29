class solr (
  $version = hiera('solr::version')
) {

  $java_home = hiera('java::default::home')
  # Install required packages
  package { ['java-1.7.0-openjdk-devel']:
    ensure => present
  }->

  # Set home dir for Java
  file { '/etc/environment':
    content => inline_template("JAVA_HOME=${java_home}")
  }->

  # Download SOLR
  exec { "download-solr-${version}":
    cwd => '/tmp',
    command => "/usr/bin/curl http://archive.apache.org/dist/lucene/solr/${version}/solr-${version}.tgz -o solr-${version}.tgz",
    timeout => 8000,
    unless => "/usr/bin/test -f /tmp/solr-${version}.tgz",
  }->

  # Extract SOLR
  exec { "unpack-solr-${version}":
    cwd => '/tmp',
    onlyif => "/usr/bin/test -f /tmp/solr-${version}.tgz",
    command => "/usr/bin/tar -zxvf solr-${version}.tgz",
    unless => '/usr/bin/test -d /opt/solr',
  }->

  # Install SOLR Service
  exec { "install-solr-${version}-service":
    command => "/tmp/solr-${version}/bin/install_solr_service.sh /tmp/solr-${version}.tgz",
    unless => '/usr/bin/test -d /opt/solr'
  }->

  # Set file and folder permissions
  file { '/var/solr':
    ensure => directory,
    owner => 'solr',
    group => 'solr'
  }->

  service { 'solr':

  }
}