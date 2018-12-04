from bot import Bot
import numpy as np
import threading
from copy import deepcopy

def crossover_mix_nodes(bbot1, bbot2, offspring1, offspring2, rate):
    offspring1.weights = deepcopy(bbot1.weights)
    offspring2.weights = deepcopy(bbot2.weights)
    for j in range(bbot1.nlayers-1):
        for k in range(bbot1.size[j+1]):
            if np.random.rand() < rate:
                offspring1.weights[j][k,:] = deepcopy(bbot2.weights[j][k,:])
                offspring2.weights[j][k,:] = deepcopy(bbot1.weights[j][k,:])

class BotPool:
    def __init__(self, bbots, fitness):
        self.bbots = bbots
        # TODO Why do we keeps fitnesses seperately here and in the class?
        self.fitness = fitness

    def __len__(self):
        return len(self.bbots)

    @staticmethod
    def random(size, N):
        # creates a uniformly random bbotpool
        bbots = [Bot.random(size, id) for id in range(N)]
        fitness = np.empty(N)
        fitness.fill(np.nan)
        return BotPool(bbots, fitness)

    @staticmethod
    def zeros(N):
        # creates an empty bbotpool
        bbots = [Bot(0, id) for id in range(N)]
        fitness = np.empty(N)
        fitness.fill(np.nan)
        return BotPool(bbots, fitness)

    def __getitem__(self, key):
        bbots = self.bbots[key]
        fitness = self.fitness[key]
        if hasattr(bbots, "__iter__"):  # Check if we got a list or a single object
            for n in range(len(bbots)):
                bbots[n].id = n
            return BotPool(bbots, fitness)
        else:
            return bbots, fitness

    def __setitem__(self, key, pool):
        self.bbots[key] = pool.bbots
        self.fitness[key] = pool.fitness
        for n in range(len(self.bbots)):
            self.bbots[n].id = n

    def __add__(self, pool):
        bbots = self.bbots+pool.bbots
        fitness = np.concatenate((self.fitness,pool.fitness))
        for n in range(len(bbots)):
            bbots[n].id = n
        return BotPool(bbots, fitness)

    def compute_fitness(self, mode = 0):
        # computes the fitness of the pool
        if mode == "all":
            idx = range(len(self))
        else: # don't compute fitnesses we already know
            nofitness = np.isnan(self.fitness)
            idx = np.nonzero(nofitness)[0]
        chunks = list(range(0, len(idx), 50)) # maximal parallel threads
        chunks.append(len(idx))

        for j in range(len(chunks)-1):
            idx_chunk = [ idx[n] for n in range(chunks[j],chunks[j+1]) ]
            threads = [threading.Thread(target=bbot.compute_fitness) for bbot in [ self.bbots[j] for j in idx_chunk]]
            for t in threads:
                t.start()
            for t in threads:
                t.join()
            self.fitness[idx_chunk] = np.array([ bbot.fitness for bbot in [ self.bbots[j] for j in idx_chunk]])
        self.sort()

    def sort(self):
        idx = np.argsort(-self.fitness)
        self.bbots = [self.bbots[i] for i in idx]
        self.fitness = self.fitness[idx]

    def max2file(self):
        self.sort()
        self.bbots[0].write_lua('nn_max.lua')

    def crossover_roulette_wheel(self, N, p_crossover, rate):
        N = round(N/2)*2
        if np.sum(self.fitness) == 0:
            dist = np.arange(len(self))/len(self) # uniform wheel
        else:
            fbar = (self.fitness+1)
            dist = np.cumsum(fbar/np.sum(fbar))

        idx = []
        for x in np.random.rand(N):
            for n in range(len(self)):
                if x < dist[n]:
                    idx.append(n)
                    break

        offspring = BotPool.zeros(N)
        for n in range(int(N/2)):
            if np.random.rand() < p_crossover:
                crossover_mix_nodes(self.bbots[idx[2*n]], self.bbots[idx[2*n+1]], offspring.bbots[2*n], offspring.bbots[2*n+1], rate)
                offspring.fitness[2*n] = np.nan
                offspring.fitness[2*n+1] = np.nan
            else:
                offspring.bbots[2*n] = self.bbots[idx[2*n]]
                offspring.bbots[2*n+1] = self.bbots[idx[2*n+1]]
                offspring.fitness[2*n] = self.fitness[idx[2*n]]
                offspring.fitness[2*n+1] = self.fitness[idx[2*n+1]]

        return offspring

    def mutate_gaussian(self, p_mutation, rate, sigma):
        for n in range(len(self)):
            if np.random.rand() < p_mutation:
                self.bbots[n].mutate_gaussian(rate, sigma)
                self.fitness[n] = np.nan
