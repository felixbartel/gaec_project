#!/bin/bash

for f in ../fitnesses/*.pkl; do
  python3 plot_fitness.py "$f"
done
