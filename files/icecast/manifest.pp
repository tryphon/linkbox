$icecast_clients=50

$icecast_source_password = $link_outgoing_password ? {
  "" => "maiy4Zeedur4eange3maPhohs7aix3", # TODO generate an uniq one
  default => $link_outgoing_password
}
