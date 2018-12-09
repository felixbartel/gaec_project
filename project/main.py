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
    n_offspring = 150
    crossover_p = 0.9       # crossove parameters
    crossover_rate = 0.5
    mutation_p = 0.7        # mutation parameters

#    trainers = ['trainer_5t']; gens = [200]
#    trainers = ['trainer'];    gens = [200]
#    trainers = ['reduced_5t']; gens = [200]

    trainers = ['trainer_5t'] # warmup
    gens = [20]
    trainers.extend(['reduced_5t', 'reduced', 'trainer', 'reduced']*4)
    gens.extend([15, 30, 15, 30]*4)
    trainers.append('reduced')
    gens.append(50)

    if args.self_adapt_1:
        print('Using self adapt type 1')
        bot_class = BotSelfAdapt1
        n_elitism = 1
        def fbar(x):
            return (x + 0.2)**3
    elif args.self_adapt_2:
        print('Using self adapt type 2')
        bot_class = BotSelfAdapt2
        n_elitism = 1
        def fbar(x):
            return (x + 0.2)**3
    else:
        print('Using no self adaption')
        bot_class = Bot
        mutation_rate = 0.5
        mutation_sigma = 0.01
        n_elitism = 10
        def fbar(x):
            return (x + 1)**2


    pool = [bot_class.random(size) for _ in range(N)]
    compute_fitness(pool, 'all')
    inverse_fitness_sort(pool)
    fitness = [np.array([bot.fitness for bot in pool])]

    gen = 1;
    for maxgen, trainer in zip(gens, trainers):
        print('trainer "{:s}"for {:d} generations'.format(trainer, maxgen))
        for bot in pool:
            bot.trainer = trainer
        for tr_gen in range(maxgen):
            gen_time = time.time()
            offspring = crossover_roulette_wheel(
                pool, n_offspring, crossover_p, crossover_rate, fbar)
            if args.self_adapt_1 or args.self_adapt_2:
                mutate_gaussian(offspring, mutation_p)
            else:
                mutate_gaussian(offspring, mutation_p, mutation_rate, mutation_sigma)
            pool = pool[0:n_elitism] + offspring
            fitness_time = time.time()
            if tr_gen % 5 == 0:
                compute_fitness(pool, 'all')
            else:
                compute_fitness(pool)
            fitness_time = time.time() - fitness_time
            inverse_fitness_sort(pool)
            pool[0].write_lua('nn_max.lua')
            pool = pool[0:N]
            fitness.append(np.array([bot.fitness for bot in pool]))

            print('Gen {}/{}; \ttime: {:2.4f}s/{:2.4f}s; \tmin = {:1.4f}; \tmean = {:1.4f}; \tmax = {:1.4f}'.format(
                gen, np.sum(gens),
                fitness_time, time.time() - gen_time,
                np.min(fitness[-1]),
                np.mean(fitness[-1]),
                np.max(fitness[-1])))
            save_fitness(fitness)
            gen += 1


if __name__ == '__main__':
    main()
