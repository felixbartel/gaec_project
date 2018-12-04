#!/bin/bash
from little_functions import plot
import numpy as np
import matplotlib.pyplot as plt
import time
from copy import deepcopy
import threading
from genetic_operators import crossover_roulette_wheel, mutate_gaussian
from bot import Bot
import math

def inverse_fitness_sort(pool):
    pool.sort(key=lambda bot: -bot.fitness)

def compute_fitness(pool, mode=None):
    # computes the fitness of the pool
    if mode == "all":
        subpool = pool
    else: # don't compute fitnesses we already know
        subpool = [bot for bot in pool if bot.fitness == -np.inf]
    thread_count = 50 # maximal parallel threads
    chunks = np.array_split(subpool, math.ceil(len(subpool)/thread_count))

    for chunk in chunks:
        threads = [threading.Thread(target=bot.compute_fitness, kwargs={'id':id}) for id, bot in enumerate(chunk)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()

def main():
    # because 7 is a lucky number, our household mathemathican said so
    np.random.seed(7)
    size = [6, 7, 2]        # size of the neuronal networks
    N = 100                 # population size
    maxgen = 100            # maximal number of generation
    n_offspring = 150
    p_crossover = 0.9       # crossove parameters
    crossover_rate = 0.5
    p_mutation = 0.5
    mutation_rate = 0.5     # mutation parameters
    mutation_sigma = 0.01
    n_elitism = 10          # keep the best individuals

    fig = plt.figure(figsize=(10,6))
    pool = [Bot.random(size) for _ in range(N)]
    compute_fitness(pool, 'all')
    fitness = [np.array([bot.fitness for bot in pool])]

    for gen in range(maxgen):
        gen_time = time.time()
        offspring = crossover_roulette_wheel(pool, n_offspring, p_crossover, crossover_rate)
        mutate_gaussian(offspring, p_mutation, mutation_rate, mutation_sigma)
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

        print('Gen {}/{}; time: {:1.4f}s/{:1.4f}s'.format(
                gen, maxgen,
                fitness_time, time.time() - gen_time))
        plot(fig, fitness)

    plt.show()

if __name__ == '__main__':
    main()
