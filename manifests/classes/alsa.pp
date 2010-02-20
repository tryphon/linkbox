class alsa::common {

  package { alsa-utils: }

}

class alsa::oss {
  include linux
  linux::module { snd-pcm-oss: }
}
