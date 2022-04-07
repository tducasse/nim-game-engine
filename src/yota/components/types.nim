import sdl2
import tables
import sets


type
  Game* = ref object
    renderer*: RendererPtr
    init*: proc(game: Game)
    inputs*: HashSet[string]
    inputMap*: Table[Scancode, string]
    entities*: seq[Entity]

  Component* = ref object of RootObj

  Sprite* = ref object of Component
    image*: TexturePtr
    position*: Position
    scale*: Scale

  Position* = ref object of Component
    x*: int
    y*: int

  Scale* = ref object of Component
    x*: float
    y*: float

  Entity* = ref object of RootObj
    name*: string
    update*: proc(this: Entity, g: Game)
    draw*: proc(this: Entity, g: Game)
    components*: Table[string, Component]
