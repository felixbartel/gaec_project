#!/bin/bash
import numpy as np
import matplotlib.pyplot as plt
import time
from copy import deepcopy
import threading
from genetic_operators import crossover_roulette_wheel, mutate_gaussian
from bot import Bot
import math
import pickle

def inverse_fitness_sort(pool):
    pool.sort(key=lambda bot: -bot.fitness)

def compute_fitness(pool, mode=None):
    # computes the fitness of the pool
    if mode == "all":
        subpool = pool
    else: # don't compute fitnesses we already know
        subpool = [bot for bot in pool if bot.fitness == -np.inf]
    thread_count = 100 # maximal parallel threads
    chunks = np.array_split(subpool, math.ceil(len(subpool)/thread_count))

    for chunk in chunks:
        threads = [threading.Thread(target=bot.compute_fitness, kwargs={'id':id}) for id, bot in enumerate(chunk)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()

def save_fitness(fitness):
    with open('fitness.pkl', 'wb') as f:
        pickle.dump(fitness, f)

def main():
    # because 7 is a lucky number, our household mathemathican said so
    np.random.seed(7)
    size = [6, 7, 2]        # size of the neuronal networks
    N = 100                 # population size
    maxgen = 200            # maximal number of generation
    n_offspring = 150
    crossover_p = 0.9       # crossove parameters
    crossover_rate = 0.3
    fbar = lambda x: (x+0.5)**3
    mutation_p = 0.9
    n_elitism = 2           # keep the best individuals

    pool = [Bot.random(size, 'self_adapt1') for _ in range(N)]
    compute_fitness(pool, 'all')
    inverse_fitness_sort(pool)
    fitness = [np.array([bot.fitness for bot in pool])]

    for gen in range(maxgen+1):
        gen_time = time.time()
        offspring = crossover_roulette_wheel(pool, n_offspring, crossover_p, crossover_rate, fbar)
        mutate_gaussian(offspring, mutation_p)
        pool = pool[0:n_elitism] + offspring
        fitness_time = time.time()
        if gen%5 == 0:
            compute_fitness(pool, 'all')
        else:
            compute_fitness(pool)
        fitness_time = time.time() - fitness_time
        inverse_fitness_sort(pool)
        pool[0].write_lua('nn_max.lua')
        pool = pool[0:N]
        fitness.append(np.array([bot.fitness for bot in pool]))

        print('Gen {}/{}; \ttime: {:1.4f}s/{:1.4f}s; \tmin = {:1.4f}; \tmean = {:1.4f}; \tmax = {:1.4f}'.format(
                gen, maxgen,
                fitness_time, time.time() - gen_time,
                np.min(fitness[gen]),
                np.mean(fitness[gen]),
                np.max(fitness[gen])))
        print(np.mean(np.array([bot.mutation_rate for bot in pool])))
        print(np.mean(np.array([bot.mutation_sigma for bot in pool])))
        save_fitness(fitness)

if __name__ == '__main__':
    main()
