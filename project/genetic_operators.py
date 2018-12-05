from copy import deepcopy
from bot import Bot
import numpy as np

def crossover_mix_nodes(bbot1, bbot2, offspring1, offspring2, rate):
    offspring1.weights = deepcopy(bbot1.weights)
    offspring2.weights = deepcopy(bbot2.weights)
    for j in range(bbot1.nlayers-1):
        for k in range(bbot1.size[j+1]):
            if np.random.rand() < rate:
                offspring1.weights[j][k,:] = deepcopy(bbot2.weights[j][k,:])
                offspring2.weights[j][k,:] = deepcopy(bbot1.weights[j][k,:])

def crossover_roulette_wheel(bots, N, p_crossover, rate):
    N = round(N/2)*2
    fitnesses = np.array([bot.fitness for bot in bots])
    if np.sum(fitnesses) == 0:
        dist = np.arange(len(bots))/len(bots) # uniform wheel
    else:
        fbar = fitnesses + 1
        dist = np.cumsum(fbar/np.sum(fbar))

    idx = []
    for x in np.random.rand(N):
        for n in range(len(bots)):
            if x < dist[n]:
                idx.append(n)
                break

    offsprings = []

    for n in range(int(N/2)):
        if np.random.rand() < p_crossover:
            offsprings.extend([Bot(None), Bot(None)])
            crossover_mix_nodes(bots[idx[2*n]], bots[idx[2*n+1]], offsprings[-2], offsprings[-1], rate)
        else:
            offsprings.extend([deepcopy(bots[idx[2*n]]), deepcopy(bots[idx[2*n+1]])])

    return offsprings

def mutate_gaussian(bots, p_mutation, rate, sigma):
    for n in range(len(bots)):
        if np.random.rand() < p_mutation:
            bots[n].mutate_gaussian(rate, sigma)
