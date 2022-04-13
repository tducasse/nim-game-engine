#define STB_VORBIS_HEADER_ONLY
#include "stb_vorbis.c"

#define MINIAUDIO_IMPLEMENTATION
#include "miniaudio.h"

size_t ma_engine_size() {
  return sizeof(ma_engine);
}

size_t ma_decoder_size() {
  return sizeof(ma_decoder);
}

size_t ma_sound_size() {
  return sizeof(ma_sound);
}

#undef STB_VORBIS_HEADER_ONLY
#include "stb_vorbis.c"