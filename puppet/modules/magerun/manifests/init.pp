class magerun
{

  # Download magerun when it's not available yet
  exec { 'get-magerun':
    cwd => '/usr/bin',
    command => '/usr/bin/curl -sS http://files.magerun.net/n98-magerun-latest.phar -o magerun',
    unless => '/usr/bin/test -e /usr/bin/magerun'
  }->

  # Set filepermission so magerun is executable
  file { '/usr/bin/magerun':
    ensure => file,
    mode => 755
  }
}