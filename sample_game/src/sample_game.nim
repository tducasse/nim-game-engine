import yota
import yota/components/types
import tables
import sample_game/entities/player


proc init(g: Game) =
  discard g.newPlayer(20, 20)



const inputMap = {
  SDL_SCANCODE_DOWN: "down",
  SDL_SCANCODE_UP: "up",
  SDL_SCANCODE_LEFT: "left",
  SDL_SCANCODE_RIGHT: "right",
  SDL_SCANCODE_SPACE: "jump"
}.toTable()


yota.start(
  init = init,
  inputMap = inputMap,
  title = "Sample game"
)
