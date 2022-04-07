import yota/components/sprite
import yota/components/types


type Player* = ref object
  sprite: Sprite


proc newPlayer*(g: Game, x, y: cint): Player =
  new result
  result.sprite = newSprite(g, "mushroom.png", x, y, 0.2, 0.2)
