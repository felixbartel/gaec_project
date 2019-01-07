## Install instructions
### Building blobby
Requirements: SDL2, PhysFS, boost, OpenGL.

Example installation for debian-based distros:
```bash
sudo apt install libsdl2-dev, libphysfs-dev, libboost-dev, freeglut3-dev
```

Build:
```bash
cd project/blobby-1.0_fast
cmake .
make
```

# TODO

* [x] refactor everything prperly
* [ ] refactor even more stuff properly
* [x] add comments
* [ ] add even more comments
* [x] try the left right movement with one output instead of two
* [x] improve the threading while preserving a maximal number of them
* [ ] try tournament selection
* [ ] when two nodes are switched with their weights and bias the network stays the same -> find a better representation or take care of this in crossover
* [x] try the stuff Sims proposed in his creatures paper
