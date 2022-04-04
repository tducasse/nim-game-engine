# Package

version = "0.1.0"
author = "Thibaud Ducasse"
description = "A new awesome nimble package"
license = "MIT"
srcDir = "src"


# Dependencies

requires "nim >= 1.6.4"
requires "yota"
requires "nimhttpd >= 1.2.0"


# Tasks

task emsdkSetup, "Download Emsdk":
  if not dirExists("externals/emsdk"):
    exec "git clone https://github.com/emscripten-core/emsdk.git externals/emsdk"
  exec "cd externals/emsdk && ./emsdk install latest && ./emsdk activate latest"

task sdlSetup, "Install SDL2":
  if not fileExists("build/desktop/SDL2.dll"):
    if not fileExists("SDL2_x64.zip"):
      exec "curl -L -o SDL2_x64.zip https://www.libsdl.org/release/SDL2-2.0.20-win32-x64.zip"
    if defined(windows) and findExe("tar") != "":
      exec "tar -C build/desktop -xf SDL2_x64.zip SDL2.dll"
    else:
      exec "unzip SDL2_x64.zip SDL2.dll -d build/desktop"
    if fileExists("SDL2_x64.zip"):
      rmFile("SDL2_x64.zip")

task setup, "Fetch dependencies":
  exec "nimble sdlSetup"
  emsdkSetupTask()
  exec "nimble install -y"

task web, "Build for web":
  when defined(windows):
    exec "cd externals/emsdk && ./emsdk_env.bat && cd ../.. && nim c -d:web src/sample_game"
  else:
    exec "cd externals/emsdk && . ./emsdk_env.sh && cd ../.. && nim c -d:web src/sample_game"

task desktop, "Build for desktop":
  if not fileExists("build/desktop/SDL2.dll"):
    exec "nimble sdlSetup"
  exec "nim c -o:build/desktop/sample_game.exe --gcc.exe:x86_64-w64-mingw32-gcc --gcc.linkerexe:x86_64-w64-mingw32-gcc --cpu:amd64 --os:windows src/sample_game"

before play:
  exec "nimble desktop"
task play, "Run the game":
  exec "build/desktop/sample_game.exe"

before serve:
  exec "nimble web"
task serve, "Serve the wasm version of the game":
  exec "nimhttpd build/web -p:8000"
