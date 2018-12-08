#!/bin/bash
import argparse
import math
import pickle
import threading
import time
from copy import deepcopy

import matplotlib.pyplot as plt
import numpy as np

from bot import Bot, BotSelfAdapt1, BotSelfAdapt2
from genetic_operators import crossover_roulette_wheel, mutate_gaussian


def inverse_fitness_sort(pool):
    pool.sort(key=lambda bot: -bot.fitness)


def compute_fitness(pool, mode=None, thread_count=100):
    # computes the fitness of the pool
    if mode == "all":
        subpool = pool
    else:  # don't compute fitnesses we already know
        subpool = [bot for bot in pool if bot.fitness == -np.inf]
    chunks = np.array_split(subpool, math.ceil(len(subpool) / thread_count))

    for chunk in chunks:
        threads = [threading.Thread(target=bot.compute_fitness, kwargs={
                                    'id': id}) for id, bot in enumerate(chunk)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()


def save_fitness(fitness):
    with open('fitness.pkl', 'wb') as f:
        pickle.dump(fitness, f)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--self_adapt_1', action='store_true')
    parser.add_argument('--self_adapt_2', action='store_true')
    args = parser.parse_args()

    # because 7 is a lucky number, our household mathemathican said so
    np.random.seed(7)
    size = [6, 7, 2]        # size of the neuronal networks
    N = 100                 # population size
    maxgen = 100            # maximal number of generation
    n_offspring = 150
    crossover_p = 0.9       # crossove parameters
    crossover_rate = 0.5
    mutation_p = 0.5        # mutation parameters
    mutation_rate = 0.5
    mutation_sigma = 0.01
    n_elitism = 10          # keep the best individuals

    if args.self_adapt_1:
        bot_class = BotSelfAdapt1
        print('Using self adapt type 1')
    elif args.self_adapt_2:
        bot_class = BotSelfAdapt2
        print('Using self adapt type 2')
    else:
        bot_class = Bot
        print('Using no self adaption')

    def fbar(x):
        return (x + 1)**2

    pool = [bot_class.random(size) for _ in range(N)]
    compute_fitness(pool, 'all')
    inverse_fitness_sort(pool)
    fitness = [np.array([bot.fitness for bot in pool])]

    for gen in range(maxgen + 1):
        gen_time = time.time()
        offspring = crossover_roulette_wheel(
            pool, n_offspring, crossover_p, crossover_rate, fbar)
        mutate_gaussian(offspring, mutation_p, mutation_rate, mutation_sigma)
        pool = pool[0:n_elitism] + offspring
        fitness_time = time.time()
        if gen % 5 == 0:
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
        save_fitness(fitness)


if __name__ == '__main__':
    main()
