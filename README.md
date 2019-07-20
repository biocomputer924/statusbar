# statusbar

## Requirements
* C++17 Compiler
* CMake >= 3.8
* Qt
* Qt WebKit

## Build
```
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF path/to/project/root
make
```

## Install
```
cmake -P cmake_install.cmake
```
You can select component.
```
cmake -P -DCOMPONENT=<component> cmake_install.cmake

where <component> is one of:
    bin, include, lib, share, src
```

## Usage
    statusbar
