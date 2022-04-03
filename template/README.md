# template
## Prerequisites
- on Windows, or to cross compile for windows, you will need mingw64
- make sure you have `python 3`, which is required by `emsdk`

## Usage
First, setup the project with:
```sh
# WSL
nimble setup
# windows
nimble -d:win setup
```
Run the web version with:
```sh
nimble serve
```
Run the desktop version with:
```sh
# WSL
nimble play
# windows
nimble -d:win play
```