import sdl2
import tables
import sets


type
  Game* = ref object
    renderer*: RendererPtr
    update*: proc(game: Game)
    init*: proc(game: Game)
    inputs*: HashSet[string]
    inputMap*: Table[Scancode, string]
    components*: Table[string, seq[Component]]

  Component* = ref object of RootObj

  Sprite* = ref object of Component
    image*: TexturePtr
    dest*: Rect



