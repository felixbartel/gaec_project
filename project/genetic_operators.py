from copy import deepcopy
from bot import Bot
import numpy as np

def crossover_mix_nodes(bbot1, bbot2, rate):
    offspring1 = deepcopy(bbot1)
    offspring2 = deepcopy(bbot2)
    offspring1.mutation_p = (1-rate)*bbot1.mutation_p+rate*bbot2.mutation_p
    offspring1.mutation_rate = (1-rate)*bbot1.mutation_p+rate*bbot2.mutation_p
    offspring1.mutation_sigma = (1-rate)*bbot1.mutation_p+rate*bbot2.mutation_p
    offspring2.mutation_p = (1-rate)*bbot2.mutation_p+rate*bbot1.mutation_p
    offspring2.mutation_rate = (1-rate)*bbot2.mutation_p+rate*bbot1.mutation_p
    offspring2.mutation_sigma = (1-rate)*bbot2.mutation_p+rate*bbot1.mutation_p
    for j in range(bbot1.nlayers-1):
        for k in range(bbot1.size[j+1]):
            if np.random.rand() < rate:
                offspring1.weights[j][k,:] = deepcopy(bbot2.weights[j][k,:])
                offspring2.weights[j][k,:] = deepcopy(bbot1.weights[j][k,:])

    return offspring1, offspring2

def crossover_roulette_wheel(bots, N, crossover_p, rate):
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
        if np.random.rand() < crossover_p:
            offsprings.extend(crossover_mix_nodes(bots[idx[2*n]], bots[idx[2*n+1]], rate))
        else:
            offsprings.extend([deepcopy(bots[idx[2*n]]), deepcopy(bots[idx[2*n+1]])])

    return offsprings

def mutate_gaussian(bots, *args):
    if args[0] == 'self_adapt':
        for n in range(len(bots)):
            if np.random.rand() < bots[n].mutation_p:
                bots[n].mutate_gaussian('self_adapt')
    else:
        mutation_p = args[0]
        rate = args[1]
        sigma = args[2]
        for n in range(len(bots)):
            if np.random.rand() < mutation_p:
                bots[n].mutate_gaussian(rate, sigma)
