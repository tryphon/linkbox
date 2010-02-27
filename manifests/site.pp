import "defaults"
import "defines/*.pp"
import "classes/*.pp"

$source_base="/tmp/puppet"

include network::base
include network::dhcp::readonly
include network::ifplugd
include network::hostname
include network::interfaces

include kernel
include syslog
include smtp
include nano
include ssh

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
