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
    parser.add_argument('--bots', nargs='+')
    parser.add_argument('--gens', nargs='+')
    args = parser.parse_args()

    # because 7 is a lucky number, our household mathemathican said so
    np.random.seed(7)
    size = [6, 7, 2]        # size of the neuronal networks
    N = 100                 # population size
    n_offspring = 150
    crossover_p = 0.9       # crossove parameters
    crossover_rate = 0.5
    mutation_p = 0.7        # mutation parameters

    trainers = args.bots
    gens = [ int(gen) for gen in args.gens ]

#    trainers = ['trainer_5t'] # warmup
#    gens = [20]
#    trainers.extend(['com_11_5t', 'gintonicV9_5t', 'hyp014_5t', 'Union_5t', 'reduced_5t'])
#    gens.extend([15]*5)


    if args.self_adapt_1:
        print('Using self adapt type 1')
        fname = 'self_adapt_1'
        bot_class = BotSelfAdapt1
        n_elitism = 1
        def fbar(x):
            return (x + 0.2)**3
    elif args.self_adapt_2:
        print('Using self adapt type 2')
        fname = 'self_adapt_2'
        bot_class = BotSelfAdapt2
        n_elitism = 1
        def fbar(x):
            return (x + 0.2)**3
    else:
        print('Using no self adaption')
        fname = 'standard'
        bot_class = Bot
        mutation_rate = 0.5
        mutation_sigma = 0.01
        n_elitism = 10
        def fbar(x):
            return (x + 1)**2

    for trainer in trainers:
        fname += '_' + trainer


    pool = [bot_class.random(size, trainers[0]) for _ in range(N)]
    pool[0].write_lua('blobby-1.0_fast/data/.blobby/scripts/last_best.lua') # it is just a random one (important if we do self training)
    compute_fitness(pool, 'all')
    inverse_fitness_sort(pool)
    fitness = [np.array([bot.fitness for bot in pool])]
    pool[0].write_lua('blobby-1.0_fast/data/.blobby/scripts/last_best.lua') # this is really the current best


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
            compute_fitness(pool, 'all')
            fitness_time = time.time() - fitness_time
            inverse_fitness_sort(pool)
            pool = pool[0:N]
            fitness.append(np.array([bot.fitness for bot in pool]))
            pool[0].write_lua('blobby-1.0_fast/data/.blobby/scripts/last_best.lua')

            print('Gen {}/{}; \ttime: {:2.4f}s/{:2.4f}s; \tmin = {:1.4f}; \tmean = {:1.4f}; \tmax = {:1.4f}'.format(
                gen, np.sum(gens),
                fitness_time, time.time() - gen_time,
                np.min(fitness[-1]),
                np.mean(fitness[-1]),
                np.max(fitness[-1])))
            if ~gen%10:
                pool[0].write_lua('../bots/' + fname + '.lua')
                with open('../fitnesses/' + fname + '.pkl', 'wb') as f:
                    pickle.dump(fitness, f)

            gen += 1


if __name__ == '__main__':
    main()
