class linkstream {
  include apt::tryphon

  package { linkstream: require => Apt::Source[tryphon] }

  user { link:
    groups => [audio]
  }

  file { "/etc/default/linkstream":
    source => "$source_base/files/linkstream/linkstream.default",
    require => Package[linkstream]
  }

  file { "/usr/lib/libogg.so":
    ensure => "/usr/lib/libogg.so.0"
  }

  file { "/etc/linkstream/linkstream.conf":
    ensure => "/var/etc/linkstream/linkstream.conf"
  }

}
