class liquidsoap {

  # TODO don't install recommended icecast2
  package { liquidsoap: }

  file { "/var/lib/liquidsoap":
    ensure => directory
  }
  file { "/var/lib/liquidsoap/stream.liq":
    source => "$source_base/files/liquidsoap/stream.liq"
  }
  file { "/etc/liquidsoap":
    ensure => directory
  }
  file { "/etc/liquidsoap/stream.liq":
    ensure => "/var/lib/liquidsoap/stream.liq"
  }
  exec { "add-liquidsoap-user-to-audio-group":
    command => "adduser liquidsoap audio",
    unless => "grep '^audio:.*liquidsoap' /etc/group",
    require => Package[liquidsoap]
  }

}

class liquidsoap::readonly {
  include readonly::common
  include liquidsoap

  file { "/var/log.model/liquidsoap":
    ensure => directory,
    owner => liquidsoap,
    require => Package[liquidsoap]
  }
  file { "/etc/init.d/liquidsoap":
    mode => 755,
    source => "$source_base/files/liquidsoap/liquidsoap.initd",
    require => Package[liquidsoap]
  }

  file { "/etc/default/liquidsoap":
    ensure => "/var/etc/default/liquidsoap"
  }
}
