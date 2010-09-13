class vorbis-tools {
  package { vorbis-tools: }
}

class ogg123-daemon {
  include vorbis-tools

  file { "/etc/init.d/ogg-123-daemon":
    source => "$source_base/files/vorbis-tools/ogg-123-daemon.init",
    require => File["/etc/default/ogg-123-daemon"],
    mode => 775
  }    
  exec { "update-rc.d ogg-123-daemon defaults":
    require => File["/etc/init.d/ogg-123-daemon"],
    creates => "/etc/rc0.d/K20ogg-123-daemon"
  }

  file { "/etc/default/ogg-123-daemon":
    ensure => "/var/etc/default/ogg-123-daemon"
  }

  file { "/usr/local/bin/ogg-123-daemon":
    source => "$source_base/files/vorbis-tools/ogg-123-daemon.sh",
    require => Package[vorbis-tools],
    mode => 775
  }    

}
