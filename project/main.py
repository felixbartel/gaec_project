#!/bin/bash
from botpool import BotPool
from little_functions import plot
import numpy as np
import matplotlib.pyplot as plt
import time
from copy import deepcopy


np.random.seed(7)       # because 7 is a lucky number
size = [6, 7, 2]        # size of the neuronal networks
N = 100                 # population size
maxgen = 100            # maximal number of generation
N_offspring = 150
p_crossover = 0.9       # crossove parameters
crossover_rate = 0.5
p_mutation = 0.5
mutation_rate = 0.5     # mutation parameters
mutation_sigma = 0.01
n_elitism = 10          # keep the best individuals

fig = plt.figure(figsize=(10,5))
pool = BotPool.random(size, N)
pool.compute_fitness('all')
fitness = [pool.fitness]


for gen in range(maxgen):
    gen_time = time.time()
    offspring = pool.crossover_roulette_wheel(N_offspring, p_crossover, crossover_rate)
    offspring.mutate_gaussian(p_mutation, mutation_rate, mutation_sigma)
    pool = deepcopy(pool[0:n_elitism]+offspring)
    fitness_time = time.time()
    if gen%5 == 0:
        pool.compute_fitness('all')
    else:
        pool.compute_fitness()
    fitness_time = time.time() - fitness_time
    pool = pool[0:N]
    fitness.append(pool.fitness)

    print('Gen {}/{}; time: {:1.4f}s/{:1.4f}s'.format(
            gen, maxgen,
            fitness_time, time.time() - gen_time))
    plot(fig, fitness)
    pool.max2file()

plt.show()
