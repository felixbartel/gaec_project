# TODO

* [ ] reprogram everything prperly
  * [ ] BlobbyVolley
    * [ ] hide the BlobbyVolley window or at least change it so that is does not need to be focused
    * [x] make it use another config directory than the home directory
  * [ ] python classes
    * [ ] one for one bot with
      * [ ] fitness evaluation returned as number
      * [ ] setting the Bot
      * [ ] random initilization
      * [ ] mutating
    * [ ] one for a pool/list of bots with
      * [ ] fitness evaluation returned as list
      * [ ] roulette wheel selection
      * [ ] mutating the whole list
      * [ ] crossover
      * [ ] random initilization
      * [ ] save/load the whole pool to/from a file
  * [ ] python mainscript
* [ ] try the left right movement with one output instead of two
* [ ] try tournament selection
* [ ] when two nodes are switched with their weights and bias the network stays the same -> find a better representation or take care of this in crossover

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
