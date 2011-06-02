class icecast2::linkbox inherits icecast2 {
  # FIXME use a 00 to load it before darkice.pp template
  file { "/etc/puppet/manifests/classes/00icecast-local.pp":
    source => "puppet:///files/icecast/manifest.pp"
  }
}
