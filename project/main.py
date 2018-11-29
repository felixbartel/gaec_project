#!/bin/python
import numpy as np
import matplotlib.pyplot as plt
from blobbybot import BB
import time
from copy import copy
import threading

l = [6,6,2] # neuronal network size
N = 250     # population size
maxgen = 1000
np.random.seed(7) # because 7 is a lucky number
p_crossover = 0.8;
crossover_rate = 0.5
p_mutation = 0.03;
mutation_rate = 0.1;
n_elitism = 3;

bots = [None]*N
offspring = [BB.random(l, id) for id in range(N)]
fitness = np.zeros([N,maxgen])

gen_time = time.time()
fig = plt.figure(figsize=(10,5))

for gen in range(maxgen):
    if gen > 0: # no mutation or crossover for the first gen
        print('generation time: {:1.4f}s/{:1.4f}s'.format(
                fitness_time, time.time() - gen_time))
        gen_time = time.time()


# crossover using rouletta wheel
        if np.sum(fitness[:,gen-1]) == 0:
            dist = np.arange(N)/N
        else:
            fbar = (fitness[:,gen-1]+0.5)**2
            dist = np.cumsum(fbar/np.sum(fbar))

        for n in range(int(N/2)):
            r = np.random.rand(2);
            for n1 in range(N):
                if r[0] < dist[n1]:
                    break
            for n2 in range(N):
                if r[1] < dist[n2]:
                    break
            offspring[2*n] = BB(bots[n1].W, bots[n1].b, 2*n)
            offspring[2*n+1] = BB(bots[n2].W, bots[n2].b, 2*n+1)
            if np.random.rand() < p_crossover:
                for i in range(len(bots[n].W)):
                    for j in range(l[i+1]):
                        if np.random.rand() < crossover_rate:
                            offspring[2*n].W[i][j,:] = bots[n2].W[i][j,:]
                            offspring[2*n].b[i][j] = bots[n2].b[i][j]
                            offspring[2*n+1].W[i][j,:] = bots[n1].W[i][j,:]
                            offspring[2*n+1].b[i][j] = bots[n1].b[i][j]

# mutation
        for n in range(N):
            for i in range(len(offspring[n].W)):
                mask = np.less(np.random.random_sample(offspring[n].W[i].shape),p_mutation)
                offspring[n].W[i] = offspring[n].W[i]+mutation_rate*mask*np.random.randn(l[i+1],l[i])

                mask = np.less(np.random.random_sample(offspring[n].b[i].shape),p_mutation)
                offspring[n].b[i] = offspring[n].b[i]+mutation_rate*mask*np.random.randn(l[i+1],1)

# choose pool
    if gen > 0: # keep the best n_elitism of the last generation
        pool = [None]*(N+n_elitism)
        for n in range(N+n_elitism):
            if n < 2:
                pool[n] = BB(bots[n].W, bots[n].b, n)
                pool[n].fitness = bots[n].fitness
            else:
                pool[n] = BB(offspring[n-n_elitism].W, offspring[n-n_elitism].b, n)
                pool[n].fitness = offspring[n-n_elitism].fitness
    else:
        pool = offspring # generational algorithm

# compute fitness
    fitness_time = time.time()

    threads = [threading.Thread(target=o.compute_fitness) for o in pool]

    for t in threads:
        t.start()
    for t in threads:
        t.join()
    fitness_time = time.time() - fitness_time

# keep N fittest
    tmp = np.array([p.fitness for p in pool])
    idx = np.argsort(-tmp)
    for n in range(N):
        bots[n] = BB(pool[idx[n]].W, pool[idx[n]].b, n)
        bots[n].fitness = tmp[idx[n]]
        fitness[n,gen] = tmp[idx[n]]

# set the current best as nn_max.lua
    bots[0].set_bot2()

# plotting
    fig.clf()
    ax = plt.axes()
    ax.plot(np.arange(gen+1),np.mean(fitness[:,0:gen+1],axis=0),'k')
    for x in [0,0.1,0.25]:
        ax.fill_between(np.arange(gen+1),fitness[int(x*N),0:gen+1]+0.01,fitness[int((1-x)*N-1),0:gen+1]-0.01,facecolor='blue',alpha=0.2)
    ax.scatter(np.ones([N,1])*np.arange(gen+1),fitness[:,0:gen+1],facecolors='k',edgecolors='k')


    plt.show(block=False)
    plt.pause(0.1)

plt.show()
