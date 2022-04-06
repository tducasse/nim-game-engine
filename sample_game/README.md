# sample_game
## Prerequisites
- on Windows, or to cross compile for windows, you will need mingw64
- make sure you have `python 3`, which is required by `emsdk`

## Usage on WSL
First, setup the project with:
```sh
nimble setup
```
Run the web version with:
```sh
nimble serve
```
Run the desktop version with:
```sh
nimble play
```

## Usage on Windows
Install the deps:
```sh
nimble install
```
Install sdl:
```sh
nimble sdlSetup
```
Install emscripten:
```sh
nimble emsdkDownload
cd externals/emsdk
./emsdk install latest
./emsdk activate latest
```
Before compiling for web, you'll have to reactivate the env (once per terminal):
```sh
cd externals/emsdk
./emsdk_env.bat
cd ../..
```
Compile for web:
```sh
nim c -d:web src/sample_game
```
Run the web version:
```sh
nimhttpd build/web -p:8000
```
Run the windows version:
```sh
nimble windows
```