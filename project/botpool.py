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
    def __init__(self, bbots):
        self.bbots = bbots

    def __len__(self):
        return len(self.bbots)

    @staticmethod
    def random(size, N):
        # creates a uniformly random bbotpool
        bbots = [Bot.random(size, id) for id in range(N)]
        return BotPool(bbots)

    @staticmethod
    def zeros(N):
        # creates an empty bbotpool
        bbots = [Bot(0, id) for id in range(N)]
        return BotPool(bbots)

    def __getitem__(self, key):
        bbots = self.bbots[key]
        if hasattr(bbots, "__iter__"):  # Check if we got a list or a single object
            for n in range(len(bbots)):
                bbots[n].id = n
            return BotPool(bbots)
        else:
            return bbots

    def __setitem__(self, key, pool):
        self.bbots[key] = pool.bbots
        for n in range(len(self.bbots)):
            self.bbots[n].id = n

    def __add__(self, pool):
        bbots = self.bbots+pool.bbots
        for n in range(len(bbots)):
            bbots[n].id = n
        return BotPool(bbots)

    def compute_fitness(self, mode=None):
        # computes the fitness of the pool
        if mode == "all":
            bbots = self.bbots
        else: # don't compute fitnesses we already know
            bbots = [bot for bot in self.bbots if bot.fitness == -np.inf]
        thread_count = 50 # maximal parallel threads
        chunks = np.array_split(bbots, round(len(bbots)/thread_count))

        for chunk in chunks:
            threads = [threading.Thread(target=bot.compute_fitness, kwargs={'id':id}) for id, bot in enumerate(chunk)]
            for t in threads:
                t.start()
            for t in threads:
                t.join()
        self.sort()

    def sort(self):
        self.bbots.sort(key=lambda bot: -bot.fitness)

    def max2file(self):
        self.sort()
        self.bbots[0].write_lua('nn_max.lua')

    def crossover_roulette_wheel(self, N, p_crossover, rate):
        N = round(N/2)*2
        fitnesses = np.array([bot.fitness for bot in self.bbots])
        if np.sum(fitnesses) == 0:
            dist = np.arange(len(self))/len(self) # uniform wheel
        else:
            fbar = fitnesses + 1
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
                offspring.bbots[2*n].fitness = -np.inf
                offspring.bbots[2*n+1].fitness = -np.inf
            else:
                offspring.bbots[2*n] = self.bbots[idx[2*n]]
                offspring.bbots[2*n+1] = self.bbots[idx[2*n+1]]

        return offspring

    def mutate_gaussian(self, p_mutation, rate, sigma):
        for n in range(len(self)):
            if np.random.rand() < p_mutation:
                self.bbots[n].mutate_gaussian(rate, sigma)
