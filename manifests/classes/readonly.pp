class readonly {

  define mount_tmpfs() {
    line { "fstab-with-tmfs-$name":
      file => "/etc/fstab",
      line => "tmpfs ${name} tmpfs defaults,noatime 0 0"
    }
  }

}

class readonly::common {
  include readonly

  file { "/var/etc":
    ensure => directory
  }

  readonly::mount_tmpfs { "/var/etc": }
  readonly::mount_tmpfs { "/var/lib/urandom": }

  file { "/var/log.model":
    ensure => directory
  }
  file { "/var/log.model/dmesg":
    ensure => present
  }

  # mount { ... } tries to (u)mount root fs ...
  line { "fstab-with-rootfs-ro":
    file => "/etc/fstab",
    line => "LABEL=root / ext3 defaults,ro 0 0"
  }
  file { "/etc/mtab":
    ensure => "/proc/mounts"
  }

}
