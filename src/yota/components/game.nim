import types
import sprite
import tables


proc newGame*(): Game =
  new result
  result.components["Sprite"] = @[]


proc draw*(g: Game) =
  for sprite in g.components["Sprite"]:
    Sprite(sprite).draw(g)
