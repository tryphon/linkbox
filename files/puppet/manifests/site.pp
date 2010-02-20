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
  notify => Service[networking],
  tag => boot
}

service { networking: }

file { "/var/etc/linkstream":
  ensure => directory,
  tag => boot
}

file { "/var/etc/linkstream/linkstream.conf":
  content => template("/etc/puppet/templates/linkstream.conf"),
  notify => Service[linkstream],
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
