import os

proc clean*(path: string): cstring =
  result = joinPath("src", "assets", path).cstring
