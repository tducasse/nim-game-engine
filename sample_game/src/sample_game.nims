if defined(web):
  # This path will only run if -d:web is passed to nim.

  --nimcache: nimcache # Store intermediate files close by in the ./tmp dir.

  --os: linux # Emscripten pretends to be linux.
  --cpu: wasm32 # Emscripten is 32bits.
  --cc: clang # Emscripten is very close to clang, so we ill replace it.
  when defined(windows):
    --clang.exe: "externals/emsdk/upstream/emscripten/emcc.bat"
    --clang.linkerexe: "externals/emsdk/upstream/emscripten/emcc.bat"
    --clang.cpp.exe: "externals/emsdk/upstream/emscripten/emcc.bat"
    --clang.cpp.linkerexe: "externals/emsdk/upstream/emscripten/emcc.bat"
  else:
    --clang.exe: emcc # Replace C
    --clang.linkerexe: emcc # Replace C linker
    --clang.cpp.exe: emcc # Replace C++
    --clang.cpp.linkerexe: emcc # Replace C++ linker.
  --listCmd # List what commands we are running so that we can debug them.

  --gc: arc # GC:arc is friendlier with crazy platforms.
  --exceptions: goto # Goto exceptions are friendlier with crazy platforms.
  --define: noSignalHandler # Emscripten doesn't support signal handlers.

  --dynlibOverride: SDL2

  # Pass this to Emscripten linker to generate html file scaffold for us.
  switch("passL", "-o build/web/index.html --shell-file public/index.html -s USE_SDL=2 --preload-file src/assets@/assets")
