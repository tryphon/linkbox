$icecast_clients=50
$icecast_source_password="maiy4Zeedur4eange3maPhohs7aix3" # TODO generate $icecast_source_password

define icecast2::htpasswd($password) {
  $filename="/var/etc/icecast2/$name"
  if $password {
    file { $filename:
      content => inline_template("linkbox:<%= Digest::MD5.hexdigest('$password') %>"),
      tag => boot
    }
  } else {
    file { $filename:
      content => ""
    }
  }
}

icecast2::htpasswd { "link-outgoing-htpasswd":
  password => "$link_outgoing_password"
}
icecast2::htpasswd { "link-incoming-htpasswd":
  password => "$link_incoming_password"
}

