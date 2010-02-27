# Defaults

Exec { 
  path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin" 
}

File { 
  checksum => md5, owner => root, group => root
}

import "config.pp"

# Use tag boot for resources required at boot (network files, etc ..)

file { "/var/etc/network":
  ensure => directory,
  tag => boot
}

file { "/var/etc/network/interfaces":
  content => template("/etc/puppet/templates/interfaces"),
  notify => Exec["restart-networking"],
  tag => boot
}

file { "/etc/network/interfaces":
  ensure => "/var/etc/network/interfaces"
}

exec { "restart-networking": 
  command => "/sbin/ifdown eth0 && /sbin/ifup eth0",
  refreshonly => true
}

file { "/var/etc/linkstream":
  ensure => directory,
  tag => boot
}

file { "/var/etc/linkstream/linkstream.conf":
  content => template("/etc/puppet/templates/linkstream.conf"),
  notify => Service[linkstream],
  tag => boot
}

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

service { linkstream: }

file { "/var/etc/resolv.conf":
  ensure => present,
  tag => boot
}

file { "/var/log":
  ensure => directory,
  recurse => true,
  source => "/var/log.model",
  tag => boot
}
