import "defaults"
import "classes/*.pp"
import "config"

import "box"

$source_base="/tmp/puppet"

$box_name="linkbox"

include box
$amixerconf_mode="duplex"
include box::audio

include linkcontrol
include darkice
include icecast2::linkbox
include liquidsoap::linkbox
