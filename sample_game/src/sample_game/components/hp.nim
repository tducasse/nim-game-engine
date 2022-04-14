import nimgameengine/components/[types, sprite, position]

type HP* = ref object of Component
  hp*: int
  sprite*: Sprite

proc newHp*(g: Game, this: Entity, val: int): HP =
  new result
  result.hp = val
  result.sprite = g.newSprite(this, "mushroom.png", g.newPosition(this, 50, 50))


method draw*(h: HP, e: Entity, g: Game) {.base.} =
  h.sprite.draw(g)
