import "defaults"
import "classes/*.pp"

import "box"

$source_base="/tmp/puppet"

$box_name="linkbox"

include network
include network::interfaces

include linux::kernel-2-6-30
include syslog
include smtp
include nano
include ssh

include apt
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
