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


def compute_fitness(pool, mode=None, thread_count=200):
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


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--self_adapt_1', action='store_true')
    parser.add_argument('--self_adapt_2', action='store_true')
    parser.add_argument('--gens')
    args = parser.parse_args()

    # because 7 is a lucky number, our household mathemathican said so
    np.random.seed(7)
    size = [6, 7, 2]        # size of the neuronal networks
    N = 100                 # population size
    n_offspring = 150
    crossover_p = 0.9       # crossove parameters
    crossover_rate = 0.4
    mutation_p = 0.7        # mutation parameters

    gens = int(args.gens)

    if args.self_adapt_1:
        print('Using self adapt type 1')
        fname = 'self_adapt_1_self_training_2'
        bot_class = BotSelfAdapt1
        n_elitism = 1
        def fbar(x):
            return (x + 0.2)**3
    elif args.self_adapt_2:
        print('Using self adapt type 2')
        fname = 'self_adapt_2_self_training_2'
        bot_class = BotSelfAdapt2
        n_elitism = 1
        def fbar(x):
            return (x + 0.2)**3
    else:
        print('Using no self adaption')
        fname = 'standard_self_training_2'
        bot_class = Bot
        mutation_rate = 0.5
        mutation_sigma = 0.01
        n_elitism = 10
        def fbar(x):
            return (x + 1)**2


    pool1 = [bot_class.random(size, 'last_best') for _ in range(N)]
    pool1[0].write_lua('blobby-1.0_fast/data/.blobby/scripts/last_best.lua') # it is just a random one
    pool2 = [bot_class.random(size, 'last_best') for _ in range(N)]
    compute_fitness(pool2, 'all')
    inverse_fitness_sort(pool2)
    pool2[0].write_lua('blobby-1.0_fast/data/.blobby/scripts/last_best.lua') # this is really the current best
    compute_fitness(pool1, 'all')
    inverse_fitness_sort(pool1)
    fitness1 = [np.array([bot.fitness for bot in pool1])]
    fitness2 = [np.array([bot.fitness for bot in pool2])]


    for gen in range(gens):
        gen_time = time.time()
        if gen % 2 == 0:
            offspring = crossover_roulette_wheel(
                pool1, n_offspring, crossover_p, crossover_rate, fbar)
        else:
            offspring = crossover_roulette_wheel(
                pool2, n_offspring, crossover_p, crossover_rate, fbar)
        if args.self_adapt_1 or args.self_adapt_2:
            mutate_gaussian(offspring, mutation_p)
        else:
            mutate_gaussian(offspring, mutation_p, mutation_rate, mutation_sigma)
        fitness_time = time.time()
        if gen % 2 == 0:
            pool1 = pool1[0:n_elitism] + offspring
            compute_fitness(pool1, 'all')
        else:
            pool2 = pool2[0:n_elitism] + offspring
            compute_fitness(pool2, 'all')
        fitness_time = time.time() - fitness_time
        if gen % 2 == 0:
            inverse_fitness_sort(pool1)
            pool1 = pool1[0:N]
            pool1[0].write_lua('blobby-1.0_fast/data/.blobby/scripts/last_best.lua')
            fitness1.append(np.array([bot.fitness for bot in pool1]))
            print('Gen {}/{}; \ttime: {:2.4f}s/{:2.4f}s; \tmin = {:1.4f}; \tmean = {:1.4f}; \tmax = {:1.4f}'.format(
                gen, np.sum(gens),
                fitness_time, time.time() - gen_time,
                np.min(fitness1[-1]),
                np.mean(fitness1[-1]),
                np.max(fitness1[-1])))
        else:
            inverse_fitness_sort(pool2)
            pool2 = pool2[0:N]
            pool2[0].write_lua('blobby-1.0_fast/data/.blobby/scripts/last_best.lua')
            fitness2.append(np.array([bot.fitness for bot in pool2]))
            print('Gen {}/{}; \ttime: {:2.4f}s/{:2.4f}s; \tmin = {:1.4f}; \tmean = {:1.4f}; \tmax = {:1.4f}'.format(
                gen, np.sum(gens),
                fitness_time, time.time() - gen_time,
                np.min(fitness2[-1]),
                np.mean(fitness2[-1]),
                np.max(fitness2[-1])))

        if ~gen % 10:
            pool1[0].write_lua('../bots/' + fname + '_1.lua')
            pool2[0].write_lua('../bots/' + fname + '_2.lua')
            with open('../fitnesses/' + fname + '_1.pkl', 'wb') as f:
                pickle.dump(fitness1, f)
            with open('../fitnesses/' + fname + '_2.pkl', 'wb') as f:
                pickle.dump(fitness2, f)


if __name__ == '__main__':
    main()
