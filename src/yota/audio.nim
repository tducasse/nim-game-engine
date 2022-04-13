import libs/miniaudio
import utils


var engine = newSeq[uint8](ma_engine_size())


proc init*(): bool =
  if MA_SUCCESS != ma_engine_init(nil, engine[0].addr):
    return false
  return true


proc uninit*() =
  ma_engine_uninit(engine[0].addr)


proc play*(path: string): bool =
  var sound = newSeq[uint8](ma_sound_size())
  var asset = path.clean
  if MA_SUCCESS != ma_sound_init_from_file(engine[0].addr, asset, 0, nil, nil,
      sound[0].addr):
    return false
  if MA_SUCCESS != ma_sound_start(sound[0].addr):
    return false
