from bbot import *
import numpy as np
import threading


class BBOTPOOL:
    def __init__(self, bbots, fitness):
        self.bbots = bbots
        self.fitness = fitness

    def __len__(self):
        return len(self.bbots)

    @staticmethod
    def random(size, N):
        # creates a uniformly randon bbotpool
        bbots = [BBOT.random(size, id) for id in range(N)]
        fitness = np.empty(N)
        fitness.fill(np.nan)
        return BBOTPOOL(bbots, fitness)

    def __getitem__(self, key):
        bbots = self.bbots[key]
        fitness = self.fitness[key]
        for n in range(len(bbots)):
            bbots[n].id = n
        return BBOTPOOL(bbots, fitness);

    def __setitem__(self, key, pool):
        self.bbots[key] = pool.bbots[key]
        self.fitness[key] = pool.fitness[key]
        for n in range(len(self.bbots)):
            self.bbots[n].id = n

    def __add__(self, pool):
        bbots = self.bbots+pool.bbots
        fitness = np.concatenate((self.fitness,pool.fitness))
        for n in range(len(bbots)):
            bbots[n].id = n
        return BBOTPOOL(bbots, fitness);

    def compute_fitness(self, mode = 0):
        # computes the fitness of the pool
        if mode == "all":
            idx = range(len(self))
        else: # don't compute fitnesses we already know
            nofitness = np.isnan(self.fitness)
            idx = np.nonzero(nofitness)[0]
        threads = [threading.Thread(target=bbot.compute_fitness) for bbot in [ self.bbots[j] for j in idx]]
        for t in threads:
            t.start()
        for t in threads:
            t.join()
        self.fitness[idx] = np.array([ bbot.fitness for bbot in [ self.bbots[j] for j in idx]])
        self.sort()

    def sort(self):
        idx = np.argsort(-self.fitness)
        bbots_tmp = [self.bbots[j] for j in idx]
        fitness_tmp = self.fitness[idx]
        self.bbots = bbots_tmp
        self.fitness = fitness_tmp

    def max2file(self):
        self.sort()
        self.bbots[0].set_bot('nn_max.lua')

    def crossover_rouletta_wheel(self, p_crossover, rate):
        offspring = deepcopy(self)
        if np.sum(self.fitness) == 0:
            dist = np.arange(len(self))/len(self) # uniform wheel
        else:
            fbar = (self.fitness+1)**3
            dist = np.cumsum(fbar/np.sum(fbar))
        for n in range(int(len(self)/2)):
            r = np.random.rand(2);
            for n1 in range(len(self)):
                if r[0] < dist[n1]:
                    break
            for n2 in range(len(self)):
                if r[1] < dist[n2]:
                    break
            if np.random.rand() < p_crossover:
                crossover_mix_nodes(self.bbots[n1], self.bbots[n2], offspring.bbots[2*n], offspring.bbots[2*n+1], rate)
                offspring.fitness[2*n] = np.nan
                offspring.fitness[2*n+1] = np.nan
        return offspring

    def mutate_gaussian(self, p_mutation, rate, sigma):
        for n in range(len(self)):
            if np.random.rand() < p_mutation:
                self.bbots[n].mutate_gaussian(rate, sigma)
                self.fitness[n] = np.nan
