class linkcontrol {
  include apache
  include apache::dnssd
  include apache::passenger

  include ruby::bundler

  file { "/etc/linkcontrol/database.yml":
    source => "$source_base/files/linkcontrol/database.yml",
    require => Package[linkcontrol]
  }
  file { "/etc/linkcontrol/production.rb":
    source => "$source_base/files/linkcontrol/production.rb",
    require => Package[linkcontrol]
  }
  package { linkcontrol:
    ensure => "0.8-1",
    require => [Apt::Source[tryphon], Package[libapache2-mod-passenger]]
  }

  # Not used for the moment
  readonly::mount_tmpfs { "/var/lib/linkcontrol": }

}
