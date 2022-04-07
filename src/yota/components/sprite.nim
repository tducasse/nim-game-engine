import types
import sdl2
import sdl2/image
import os
import tables


proc clean(path: string): cstring =
  result = joinPath("src", "assets", path).cstring


proc newSprite*(g: Game, path: string, x, y: cint, scaleX: cfloat = 1,
    scaleY: cfloat = 1): Sprite =
  var texture = g.renderer.loadTexture(path.clean)
  if (texture == nil):
    echo sdl2.getError()
  var w: cint
  var h: cint
  texture.queryTexture(nil, nil, addr(w), addr(h))
  var area = rect(x, y, (w.cfloat * scaleX).cint, (h.cfloat * scaleY).cint)
  var sprite = new Sprite
  sprite.dest = area
  sprite.image = texture
  g.components["Sprite"].add(sprite)
  return sprite


method draw*(sprite: Sprite, g: Game) {.base.} =
  g.renderer.copy(sprite.image, nil, addr(sprite.dest))
