class liquidsoap::linkbox {
  include liquidsoap
  include liquidsoap::readonly

  file { "/etc/puppet/templates/link.liq":
    source => "puppet:///files/liquidsoap/link.liq"
  }
  file { "/etc/puppet/manifests/classes/liquidsoap.pp":
    source => "puppet:///files/liquidsoap/manifest.pp"
  }

  readonly::mount_tmpfs { "/var/lib/liquidsoap": }
  file { "/var/lib/liquidsoap":
    ensure => directory
  }

  file { "/etc/liquidsoap/link.liq":
    ensure => "/var/lib/liquidsoap/link.liq",
    require => Package[liquidsoap]
  }

}
