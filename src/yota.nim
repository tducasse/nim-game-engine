import sdl2

when defined(web):
  proc emscripten_set_main_loop(fun: proc() {.cdecl.}, fps,
    simulate_infinite_loop: cint) {.header: "<emscripten.h>".}
  proc emscripten_cancel_main_loop() {.header: "<emscripten.h>".}


var window: WindowPtr
var render: RendererPtr
var runGame = true
var lastTime = getTicks()
var fps = 60
var update: proc()
var draw: proc()


proc process_input() =
  var evt = sdl2.defaultEvent
  while pollEvent(evt):
    if evt.kind == QuitEvent:
      runGame = false
      break


proc loop() {.cdecl.} =
  update()
  process_input()
  var newTime = getTicks()
  if float(newTime - lastTime) < (1000 / fps):
    return
  lastTime = newTime
  when defined(web):
    if not runGame:
      emscripten_cancel_main_loop()
  draw()


proc setup() =
  discard sdl2.init(INIT_VIDEO or INIT_AUDIO or INIT_TIMER or INIT_JOYSTICK or
    INIT_GAMECONTROLLER or INIT_EVENTS)
  window = createWindow("SDL Skeleton", SDL_WINDOWPOS_CENTERED,
      SDL_WINDOWPOS_CENTERED, 640, 480, SDL_WINDOW_SHOWN or SDL_WINDOW_OPENGL)
  render = createRenderer(window, -1, Renderer_Accelerated or
      Renderer_PresentVsync or Renderer_TargetTexture)
  discard render.setLogicalSize(640, 480)

  when defined(web):
    emscripten_set_main_loop(loop, 0, 1)
  else:
    while runGame:
      loop()

  destroy render
  destroy window


proc run*(updateFunc: proc, drawFunc: proc) =
  update = updateFunc
  draw = drawFunc
  setup()
