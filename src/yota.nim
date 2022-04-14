import sdl2
import sdl2/image
import yota/game
import yota/components/types
import tables
import sets


export sdl2.Scancode


when defined(web):
  proc emscripten_set_main_loop(fun: proc() {.cdecl.}, fps,
    simulate_infinite_loop: cint) {.header: "<emscripten.h>".}
  proc emscripten_cancel_main_loop() {.header: "<emscripten.h>".}


var window: WindowPtr
var renderer: RendererPtr
var lastTime = getTicks()
var fps = 60
var g: Game = newGame()


proc handleInput(game: Game) =
  var event = sdl2.defaultEvent
  while pollEvent(event):
    case event.kind
    of QuitEvent:
      g.inputs = g.inputs + toHashSet(["quit"])
    of KeyDown:
      var key = g.inputMap.getOrDefault(event.key.keysym.scancode, "")
      if key != "":
        g.inputs = g.inputs + toHashSet([key])
    of KeyUp:
      var key = g.inputMap.getOrDefault(event.key.keysym.scancode, "")
      if key != "":
        g.inputs.excl(key)
    else:
      discard


proc loop() {.cdecl.} =
  g.update()
  handleInput(g)
  var newTime = getTicks()
  if float(newTime - lastTime) < (1000 / fps):
    return
  lastTime = newTime
  when defined(web):
    if "quit" in g.inputs:
      emscripten_cancel_main_loop()
  g.renderer.clear()
  g.draw()
  g.renderer.present()


proc run(g: Game, width: cint = 640, height: cint = 480,
    title: cstring = "Yota game") =
  discard sdl2.init(INIT_VIDEO or INIT_AUDIO or INIT_TIMER or INIT_JOYSTICK or
    INIT_GAMECONTROLLER or INIT_EVENTS)
  discard image.init(IMG_INIT_PNG)
  defer:
    sdl2.quit()
    image.quit()

  window = createWindow(title, SDL_WINDOWPOS_CENTERED,
      SDL_WINDOWPOS_CENTERED, width, height, SDL_WINDOW_SHOWN or SDL_WINDOW_OPENGL)
  defer:
    window.destroy()

  renderer = createRenderer(window, -1, Renderer_Accelerated or
      Renderer_PresentVsync or Renderer_TargetTexture)
  g.renderer = renderer
  discard renderer.setLogicalSize(width, height)
  defer:
    renderer.destroy()

  g.init(g)

  when defined(web):
    emscripten_set_main_loop(loop, 0, 1)
  else:
    while "quit" notin g.inputs:
      loop()


proc start*(
   init: proc(g: Game),
   inputMap: Table[Scancode, string],
   title: cstring) =
  g.init = init
  g.inputMap = inputMap
  g.run(title = title)
