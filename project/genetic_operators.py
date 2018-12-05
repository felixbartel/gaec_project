from copy import deepcopy
from bot import Bot
import numpy as np

def crossover_mix_nodes(bbot1, bbot2, rate):
    offspring1 = deepcopy(bbot1)
    offspring2 = deepcopy(bbot2)
    offspring1.fitness = -np.inf
    offspring2.fitness = -np.inf
    if bbot1.mode == 'self_adapt1':
        [offspring1.mutation_rate, offspring1.mutation_sigma] = (1-rate)*np.array([bbot1.mutation_rate, bbot1.mutation_sigma])+rate*np.array([bbot2.mutation_rate, bbot2.mutation_sigma])
        [offspring2.mutation_rate, offspring2.mutation_sigma] = (1-rate)*np.array([bbot2.mutation_rate, bbot2.mutation_sigma])+rate*np.array([bbot1.mutation_rate, bbot1.mutation_sigma])
    if bbot1.mode == 'self_adapt2':
        offspring1.mutation_sigma = []
        offspring2.mutation_sigma = []
        for s1, s2 in zip(bbot1.mutation_sigma, bbot2.mutation_sigma):
            offspring1.mutation_sigma.append((1-rate)*s1+rate*s2)
            offspring2.mutation_sigma.append((1-rate)*s2+rate*s1)
    for j in range(bbot1.nlayers-1):
        for k in range(bbot1.size[j+1]):
            if np.random.rand() < rate:
                offspring1.weights[j][k,:] = deepcopy(bbot2.weights[j][k,:])
                offspring2.weights[j][k,:] = deepcopy(bbot1.weights[j][k,:])

    return offspring1, offspring2

def crossover_roulette_wheel(bots, N, crossover_p, rate, fbar):
    N = round(N/2)*2
    fitnesses = np.array([bot.fitness for bot in bots])
    if np.sum(fitnesses) == 0:
        dist = np.arange(len(bots))/len(bots) # uniform wheel
    else:
        dist = np.cumsum(fbar(fitnesses)/np.sum(fbar(fitnesses)))

    idx = []
    for x in np.random.rand(N):
        for n in range(len(bots)):
            if x < dist[n]:
                idx.append(n)
                break

    offsprings = []
    for n in range(int(N/2)):
        if np.random.rand() < crossover_p:
            offsprings.extend(crossover_mix_nodes(bots[idx[2*n]], bots[idx[2*n+1]], rate))
        else:
            offsprings.extend([deepcopy(bots[idx[2*n]]), deepcopy(bots[idx[2*n+1]])])

    return offsprings

def mutate_gaussian(bots, mutation_p, *args):
    if bots[0].mode == 'self_adapt1' or bots[0].mode == 'self_adapt2':
        for n in range(len(bots)):
            if np.random.rand() < mutation_p:
                bots[n].mutate_gaussian()
    else:
        rate = args[0]
        sigma = args[1]
        for n in range(len(bots)):
            if np.random.rand() < mutation_p:
                bots[n].mutate_gaussian(rate, sigma)
