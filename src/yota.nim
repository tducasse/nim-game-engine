import sdl2
import tables
import sets

export sdl2.Scancode


type
  Game* = ref object
    renderer: RendererPtr
    update: proc(game: Game)
    draw: proc(game: Game)
    inputs: HashSet[string]
    inputMap: Table[Scancode, string]



when defined(web):
  proc emscripten_set_main_loop(fun: proc() {.cdecl.}, fps,
    simulate_infinite_loop: cint) {.header: "<emscripten.h>".}
  proc emscripten_cancel_main_loop() {.header: "<emscripten.h>".}


var window: WindowPtr
var renderer: RendererPtr
var lastTime = getTicks()
var fps = 60
var game*: Game = new Game


proc handleInput(game: Game) =
  var event = sdl2.defaultEvent
  while pollEvent(event):
    case event.kind
    of QuitEvent:
      game.inputs = game.inputs + toHashSet(["quit"])
    of KeyDown:
      game.inputs = game.inputs + toHashSet([
        game.inputMap[event.key.keysym.scancode]
      ])
    of KeyUp:
      game.inputs.excl(game.inputMap[event.key.keysym.scancode])
    else:
      discard


proc loop() {.cdecl.} =
  game.update(game)
  handleInput(game)
  var newTime = getTicks()
  if float(newTime - lastTime) < (1000 / fps):
    return
  lastTime = newTime
  when defined(web):
    if not game.inputs[Input.quit]:
      emscripten_cancel_main_loop()
  game.renderer.clear()
  game.draw(game)
  game.renderer.present()


proc run(game: Game, width: cint = 640, height: cint = 480,
    title: cstring = "Yota game") =
  discard sdl2.init(INIT_VIDEO or INIT_AUDIO or INIT_TIMER or INIT_JOYSTICK or
    INIT_GAMECONTROLLER or INIT_EVENTS)
  defer: sdl2.quit()

  window = createWindow(title, SDL_WINDOWPOS_CENTERED,
      SDL_WINDOWPOS_CENTERED, width, height, SDL_WINDOW_SHOWN or SDL_WINDOW_OPENGL)
  defer: window.destroy()

  renderer = createRenderer(window, -1, Renderer_Accelerated or
      Renderer_PresentVsync or Renderer_TargetTexture)
  game.renderer = renderer
  discard renderer.setLogicalSize(width, height)
  defer: renderer.destroy()

  when defined(web):
    emscripten_set_main_loop(loop, 0, 1)
  else:
    while "quit" notin game.inputs:
      loop()


proc start*(
   update: proc(game: Game),
   draw: proc(game: Game),
   inputMap: Table[Scancode, string],
   title: cstring) =
  game.update = update
  game.draw = draw
  game.inputMap = inputMap
  game.run(title = title)
