#!/bin/bash
from bbotpool import *
from little_functions import *
import numpy as np
import matplotlib.pyplot as plt
import time


np.random.seed(7)       # because 7 is a lucky number
size = [6,6,2]        # size of the neuronal networks
N = 100                 # population size
maxgen = 100            # maximal number of generation
p_crossover = 0.9       # crossove parameters
crossover_rate = 0.5    
p_mutation = 0.7
mutation_rate = 0.05    #mutation parameters
mutation_sigma = 0.1    
n_elitism = 5           # keep the best individuals

fig = plt.figure(figsize=(10,5))
pool = BBOTPOOL.random(size, N)
pool.compute_fitness()
fitness = [pool.fitness]


for gen in range(maxgen):
    gen_time = time.time()
    offspring = pool.crossover_rouletta_wheel(p_crossover, crossover_rate)
    offspring.mutate_gaussian(p_mutation, mutation_rate, mutation_sigma)
    pool = deepcopy(pool[0:n_elitism]+offspring)
    fitness_time = time.time()
    pool.compute_fitness('all')
    fitness_time = time.time() - fitness_time
    pool = pool[0:N]
    pool.max2file()
    fitness.append(list(pool.fitness))

    print('generation time: {:1.4f}s/{:1.4f}s'.format(
            fitness_time, time.time() - gen_time))
    plot(fig, fitness)

plt.show()
