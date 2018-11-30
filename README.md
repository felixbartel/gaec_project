# TODO

* [ ] reprogram everything prperly
  * [x] BlobbyVolley
    * [x] hide the BlobbyVolley window or at least change it so that is does not need to be focused
    * [x] make it use another config directory than the home directory
  * [ ] python classes
    * [x] one for one bot with
      * [x] fitness evaluation returned as number
      * [x] setting the Bot
      * [x] random initilization
      * [x] mutating
    * [ ] one for a pool/list of bots with
      * [x] fitness evaluation returned as list
      * [x] roulette wheel selection
      * [x] mutating the whole list
      * [x] crossover
      * [x] random initilization
      * [ ] save/load the whole pool to/from a file
  * [x] python mainscript
* [x] try the left right movement with one output instead of two
* [ ] improve the threading while preserving a maximal number of them
* [ ] try tournament selection
* [ ] when two nodes are switched with their weights and bias the network stays the same -> find a better representation or take care of this in crossover
* [ ] try the stuff Sims proposed in his creatures paper

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
