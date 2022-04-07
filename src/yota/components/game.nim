import types
import sprite
import tables


proc newGame*(): Game =
  new result


proc getComponent(e: Entity, component: string): Component =
  return e.components.getOrDefault(component, nil)


proc draw*(g: Game) =
  for entity in g.entities:
    var sprite = entity.getComponent("sprite")
    if(sprite != nil):
      Sprite(sprite).draw(g)
    if(entity.draw != nil):
      entity.draw(entity, g)


proc update*(g: Game) =
  for entity in g.entities:
    if (entity.update != nil):
      entity.update(entity, g)


proc register*(g: Game, e: Entity) =
  g.entities.add(e)
