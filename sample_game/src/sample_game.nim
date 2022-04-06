import yota
import tables

proc init(game: Game) =
  game.newImage("src/assets/mushroom.png", 0, 0)
  game.newImage("src/assets/mushroom.png", 200, 200, 0.5, 0.5)


proc update(game: Game) = discard


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
  update = update,
  title = "Sample game"
)
