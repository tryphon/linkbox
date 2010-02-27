import "defaults"
import "defines/*.pp"
import "classes/*.pp"

$source_base="/tmp/puppet"

file { "/etc/network/interfaces": 
   content => "auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
"
}

include network::base
include network::dhcp::readonly
include network::ifplugd
include network::hostname

include kernel
include syslog
include smtp
include nano

include apt::local
include apt::tryphon
include puppet
include sudo

include alsa::common
include alsa::oss # troubles with alsa & darkice 

include liquidsoap::readonly
include darkice
include linkstream
include apache
include linkcontrol
