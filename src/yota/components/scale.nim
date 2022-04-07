import types


proc newScale*(g: Game, this: Entity, x, y: float): Scale =
  new result
  result.x = x
  result.y = y
