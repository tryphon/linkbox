class icecast2::linkbox inherits icecast2 {
  # FIXME use a 00 to load it before darkice.pp template
  file { "/etc/puppet/manifests/classes/00icecast-local.pp":
    source => "puppet:///files/icecast/manifest.pp"
  }

  package { pwgen: }

  link { "/etc/icecast2/link-outgoing-htpasswd":
    target => "/var/etc/icecast2/link-outgoing-htpasswd",
    require => Package[icecast2]
  }
  link { "/etc/icecast2/link-incoming-htpasswd":
    target => "/var/etc/icecast2/link-incoming-htpasswd",
    require => Package[icecast2]
  }
}

