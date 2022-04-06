import sdl2
import sdl2/image
import tables
import sets

import os

export sdl2.Scancode


type
  Game* = ref object
    renderer*: RendererPtr
    update: proc(game: Game)
    init: proc(game: Game)
    inputs: HashSet[string]
    inputMap: Table[Scancode, string]
    images: seq[Image]

  Image = ref object
    texture: TexturePtr
    dest: Rect


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
      var key = game.inputMap.getOrDefault(event.key.keysym.scancode, "")
      if key != "":
        game.inputs = game.inputs + toHashSet([key])
    of KeyUp:
      var key = game.inputMap.getOrDefault(event.key.keysym.scancode, "")
      if key != "":
        game.inputs.excl(key)
    else:
      discard


proc newImage*(game: Game, path: cstring, x, y: cint, scaleX: cfloat = 1,
    scaleY: cfloat = 1) =
  var texture = renderer.loadTexture(path)
  if (texture == nil):
    echo sdl2.getError()
  var w: cint
  var h: cint
  texture.queryTexture(nil, nil, addr(w), addr(h))
  var area = rect(x, y, (w.cfloat * scaleX).cint, (h.cfloat * scaleY).cint)
  game.images.add(Image(texture: texture, dest: area))


proc drawImage(img: Image, game: Game) =
  game.renderer.copy(img.texture, nil, addr(img.dest))


proc draw(game: Game) =
  for img in game.images:
    img.drawImage(game)


proc loop() {.cdecl.} =
  game.update(game)
  handleInput(game)
  var newTime = getTicks()
  if float(newTime - lastTime) < (1000 / fps):
    return
  lastTime = newTime
  when defined(web):
    if "quit" notin game.inputs:
      emscripten_cancel_main_loop()
  game.renderer.clear()
  game.draw()
  game.renderer.present()


proc run(game: Game, width: cint = 640, height: cint = 480,
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
  game.renderer = renderer
  discard renderer.setLogicalSize(width, height)
  defer:
    renderer.destroy()

  game.init(game)

  when defined(web):
    emscripten_set_main_loop(loop, 0, 1)
  else:
    while "quit" notin game.inputs:
      loop()


proc start*(
   update: proc(game: Game),
   init: proc(game: Game),
   inputMap: Table[Scancode, string],
   title: cstring) =
  game.update = update
  game.init = init
  game.inputMap = inputMap
  game.run(title = title)
