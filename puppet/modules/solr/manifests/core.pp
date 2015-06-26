define solr::core (
  $schema = hiera('solr::core::schema'),
  $currency = hiera('solr::core::currency'),
  $elevate = hiera('solr::core::elevate'),
  $protwords = hiera('solr::core::protwords'),
  $stopwords = hiera('solr::core::stopwords'),
  $synonyms = hiera('solr::core::synonyms'),
  $extras = {},
) {

  $coredir = "/var/solr/data/${name}"

  # Create core with default values
  exec { "create-core-${name}":
    user => 'solr',
    command => "/opt/solr/bin/solr create_core -c ${name}",
    unless => "/usr/bin/test -d /var/solr/data/${name}",
    require => [Class['solr'], Service['solr']]
  }->

  # Set schema file
  file { "${coredir}/conf/schema.xml":
    ensure => file,
    owner => 'solr',
    group => 'solr',
    content => template($schema)
  }->

  # Set currency file
  file { "${coredir}/conf/currency.xml":
    ensure => file,
    owner => 'solr',
    group => 'solr',
    content => template($currency)
  }->

  # Set elevate file
  file { "${coredir}/conf/elevate.xml":
    ensure => file,
    owner => 'solr',
    group => 'solr',
    content => template($elevate)
  }->

  # Set protwords file
  file { "${coredir}/conf/protwords.txt":
    ensure => file,
    owner => 'solr',
    group => 'solr',
    content => template($protwords)
  }->

  # Set stopwords file
  file { "${coredir}/conf/stopwords.txt":
    ensure => file,
    owner => 'solr',
    group => 'solr',
    content => template($stopwords)
  }->

  # Set synonyms file
  file { "${coredir}/conf/synonyms.txt":
    ensure => file,
    owner => 'solr',
    group => 'solr',
    content => template($synonyms)
  }->

  file { "${coredir}/conf/managed-schema":
    ensure => absent,
    notify => Service['solr']
  }

  if empty($extra) == false {
    notice('not empty')
  } else {
    notice('empty')
  }

}