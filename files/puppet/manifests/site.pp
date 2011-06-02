# Defaults

Exec { 
  path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin" 
}

File { 
  checksum => md5, owner => root, group => root
}

import "config.pp"
import "classes/*.pp"

file { "/var/lib/linkcontrol/db":
  ensure => directory,
  owner => www-data,
  tag => boot
}

exec { "create-linkcontrol-db": 
  command => "cp /usr/share/linkcontrol/db/production.sqlite3 /var/lib/linkcontrol/db && chown www-data /var/lib/linkcontrol/db/production.sqlite3",
  creates => "/var/lib/linkcontrol/db/production.sqlite3",
  require => File["/var/lib/linkcontrol/db"],
  tag => boot
}
