class go-broadcast::linkbox {
  include go-broadcast

  file { "/etc/puppet/templates/go-broadcast.default":
    source => "puppet:///files/go-broadcast/go-broadcast.default.erb",
    require => User[boxdaemon]
  }
  file { "/etc/puppet/manifests/classes/go-broadcast.pp":
    source => "puppet:///files/go-broadcast/manifest.pp"
  }
  file { "/etc/default/go-broadcast":
    ensure => "/var/etc/default/go-broadcast"
  }
}
