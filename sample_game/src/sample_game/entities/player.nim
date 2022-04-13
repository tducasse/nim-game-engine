import yota/components/[sprite, types, position, scale]
import yota/game
import tables
import "../components/hp"
import yota/audio
import sets
import times

var jumping = false
var jumpTime: float

proc update(e: Entity, g: Game) =
  if "jump" in g.inputs and not jumping:
    jumping = true
    jumpTime = cpuTime()
    discard play("tests_xylophone-sweep.ogg")

  if jumping:
    if (cpuTime() - jumpTime) > 0.5:
      jumping = false
      jumpTime = 0


proc draw(e: Entity, g: Game) =
  HP(e.components["hp"]).draw(e, g)


proc newPlayer*(g: Game, x, y: int): Entity =
  new result
  result.name = "player"
  result.update = update
  result.draw = draw
  var pos = g.newPosition(result, x, y)
  var scale = g.newScale(result, 0.2, 0.2)
  result.components["position"] = pos
  result.components["scale"] = scale
  result.components["sprite"] = g.newSprite(result, "mushroom.png", pos, scale)
  result.components["hp"] = g.newHp(result, 2)
  g.register(result)
