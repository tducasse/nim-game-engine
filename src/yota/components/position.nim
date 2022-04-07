import types


proc newPosition*(g: Game, this: Entity, x, y: int): Position =
  new result
  result.x = x
  result.y = y
