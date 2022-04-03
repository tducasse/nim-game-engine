# Package

version       = "0.1.0"
author        = "Thibaud Ducasse"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"


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
    when defined(win):
        if not fileExists("build/desktop/windows/SDL2.dll"):
            if not fileExists("SDL2_x64.zip"):
                exec "curl -L -o SDL2_x64.zip https://www.libsdl.org/release/SDL2-2.0.20-win32-x64.zip"
            if defined(windows) and findExe("tar") != "":
                exec "tar -C build/desktop/windows -xf SDL2_x64.zip SDL2.dll"
            else:
                exec "unzip SDL2_x64.zip SDL2.dll -d build/desktop/windows"
            if fileExists("SDL2_x64.zip"):
                rmFile("SDL2_x64.zip")
    else:
        exec "sudo apt install libsdl2-dev -y"

task setup, "Fetch dependencies":
  when defined(win):
    exec "nimble -d:win sdlSetup"
  else:
    exec "nimble sdlSetup"
  emsdkSetupTask()
  exec "nimble install -y"

task web, "Build for web":
  when defined(win):
    exec "cd externals/emsdk && ./emsdk_env.bat"
  else:
    exec "cd externals/emsdk && . ./emsdk_env.sh"
  exec "nim c -d:web src/template"

task desktop, "Build for desktop":
  when defined(win):
      if not fileExists("build/desktop/windows/SDL2.dll"):
        exec "nimble -d:win sdlSetup"
      exec "nim c -o:build/desktop/windows/template.exe --gcc.exe:x86_64-w64-mingw32-gcc --gcc.linkerexe:x86_64-w64-mingw32-gcc --cpu:amd64 --os:windows src/template"
  else:
      exec "nim c -o:build/desktop/linux/template src/template"

before play:
  when defined(win):
    exec "nimble -d:win desktop"
  else:
    exec "nimble desktop"
task play, "Run the game":
  when defined(win):
    exec "build/desktop/windows/template.exe"
  else:
    exec "build/desktop/linux/template"

before serve:
  exec "nimble web"
task serve, "Serve the wasm version of the game":
  exec "nimhttpd build/web -p:8000"
