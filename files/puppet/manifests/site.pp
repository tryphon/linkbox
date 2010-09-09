# Defaults

Exec { 
  path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin" 
}

File { 
  checksum => md5, owner => root, group => root
}

import "config.pp"

$enable_http=$linkstream_http_port ? {
  '' => false,
  default => true
}
$enable_alsa=!$enable_http

$enable_capture=$linkstream_alsa_capture ? {
  "true" => true,
  default => false
}
$enable_playback=$linkstream_alsa_playback ? {
  "true" => true,
  default => false
}

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

service { linkstream: 
  ensure => running,
  require => [Service[darkice], Service[ogg-123-daemon]]
}

$enable_darkice=$enable_http and $enable_capture
service { darkice:
  ensure => $enable_darkice
}

file { "/var/etc/default":
  ensure => directory,
  tag => boot
}

file { "/var/etc/default/darkice":
  content => template("/etc/puppet/templates/darkice.default"),
  tag => boot
}

$enable_ogg123=$enable_http and $enable_playback
service { ogg-123-daemon:
  ensure => $enable_ogg123
}

file { "/var/etc/default/ogg-123-daemon":
  content => template("/etc/puppet/templates/ogg-123-daemon.default"),
  tag => boot
}

exec { "amixerconf":
  command => "/usr/local/bin/amixerconf duplex"
}

file { "/var/etc/resolv.conf":
  ensure => present,
  tag => boot
}

exec { "copy-var-model":
  creates => "/var/log/dmesg",
  command => "cp -a /var/log.model/* /var/log/",
  tag => boot
}
