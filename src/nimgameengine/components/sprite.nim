import types
import sdl2
import sdl2/image
import "../utils"


proc newSprite*(
  g: Game,
  this: Entity,
  path: string,
  pos: Position,
  scale: Scale = Scale(x: 1, y: 1)): Sprite =
  var texture = g.renderer.loadTexture(path.clean)
  if (texture == nil):
    echo sdl2.getError()
  new result
  result.image = texture
  result.scale = scale
  result.position = pos


method draw*(
  sprite: Sprite,
  g: Game,
) {.base.} =
  var w: cint
  var h: cint
  sprite.image.queryTexture(nil, nil, addr(w), addr(h))
  var area = rect(
    sprite.position.x.cint,
    sprite.position.y.cint,
    (w.cfloat * sprite.scale.x.cfloat).cint,
    (h.cfloat * sprite.scale.y.cfloat).cint)
  g.renderer.copy(sprite.image, nil, addr(area))
