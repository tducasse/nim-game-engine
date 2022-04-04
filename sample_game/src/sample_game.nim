import yota
import tables


proc update(game: Game) = discard


proc draw(game: Game) = discard


const inputMap = {
  SDL_SCANCODE_DOWN: "down",
  SDL_SCANCODE_UP: "up",
  SDL_SCANCODE_LEFT: "left",
  SDL_SCANCODE_RIGHT: "right",
  SDL_SCANCODE_SPACE: "jump"
}.toTable()


yota.start(
  draw = draw,
  inputMap = inputMap,
  update = update,
  title = "Sample game"
)
