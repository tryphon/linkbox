file { "/var/lib/liquidsoap/link.liq":
  content => template("link.liq"),
  tag => boot,
  notify => Service[liquidsoap]
}

service { liquidsoap:
  ensure => running,
  hasrestart => true
}
