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

  include munin::ruby
  package { logtail: }
  
  munin::plugin { ["go_broadcast_buffer_size", "go_broadcast_adjustment"]:
    source => "puppet:///files/go-broadcast/munin/go-broadcast-buffer.rb",
    # user munin to write offset file in /var/run/munin/
    # group adm to read syslog file
    config => "user munin\ngroup adm"
  }
}
