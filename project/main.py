#!/bin/python
import numpy as np
import matplotlib.pyplot as plt
from blobbybot import BB

l = [7,9,3] # neuronal network size
N = 100;      # population size
maxgen = 1000;
sigma = 0.01;

bots = [BB]*N
offspring = [BB]*N
fitness = np.zeros([N,maxgen])
gen = 0

for n in range(N):
    offspring[n] = BB.random(l)
    offspring[n].compute_fitness()
    print(n,'/',N,', fitness: ',offspring[n].fitness)

pool = offspring
tmp = np.zeros(len(pool))
for n in range(len(pool)):
    tmp[n] = pool[n].fitness
idx = np.argsort(-tmp)
for n in range(N):
    bots[n] = pool[idx[n]].copy()
    fitness[n,gen] = tmp[idx[n]]


for gen in range(1,maxgen):
    if np.sum(fitness[:,gen-1]) == 0:
        dist = np.arange(N)/N
    else:
        fbar = (fitness[:,gen-1]+0.05)**2
        dist = np.cumsum(fbar/np.sum(fbar))
    
    indicator = (fitness[int(0.1*N),gen-1]-fitness[int(0.9*N),gen-1])/(fitness[0,gen-1]-fitness[N-1,gen-1])
    print('indicator: ',indicator)
    if gen > 4:
        print(sigma)
        if indicator <= 0.2:
            sigma = sigma+0.01
        elif indicator > 0.3:
            sigma = sigma-0.01
        if sigma < 0.01:
            sigma = 0.01
        if sigma > 0.05:
            sigma = 0.05
        print(sigma)


    for n in range(int(N/2)): # crossover
        r = np.random.rand(2);
        for n1 in range(N):
            if r[0] < dist[n1]:
                break
        for n2 in range(N):
            if r[1] < dist[n2]:
                break
#        for i in range(len(bots[n].W)):
#            offspring[2*n].W[i] = 0.2*bots[n1].W[i]+0.8*bots[n2].W[i]
#            offspring[2*n].b[i] = 0.2*bots[n1].b[i]+0.8*bots[n2].b[i]
#            offspring[2*n+1].W[i] = 0.8*bots[n1].W[i]+0.2*bots[n2].W[i]
#            offspring[2*n+1].b[i] = 0.8*bots[n1].b[i]+0.2*bots[n2].b[i]
        offspring[2*n] = bots[n1].copy()
        offspring[2*n+1] = bots[n2].copy()
        for i in range(len(bots[n].W)):
            for j in range(l[i+1]):
                if np.random.rand() < 0.3:
                    offspring[2*n].W[i][j,:] = bots[n2].W[i][j,:]
                    offspring[2*n].b[i][j] = bots[n2].b[i][j]
                    offspring[2*n+1].W[i][j,:] = bots[n1].W[i][j,:]
                    offspring[2*n+1].b[i][j] = bots[n1].b[i][j]

    for n in range(N): # mutation
        for i in range(len(offspring[n].W)):
            mask = np.less(np.random.rand(*((offspring[n].W[i]).shape)),sigma)
            offspring[n].W[i] = offspring[n].W[i]+sigma*mask*np.random.randn(l[i+1],l[i])
            mask = np.less(np.random.rand(*((offspring[n].b[i]).shape)),sigma)
            offspring[n].b[i] = offspring[n].b[i]+sigma*mask*np.random.randn(l[i+1],1)
        offspring[n].compute_fitness()
        print(n,'/',N,', fitness: ',offspring[n].fitness)

#    pool = bots+offspring # has to have at least N individuals
    pool = offspring # generational algorithm
    tmp = np.zeros(len(pool))
    for n in range(len(pool)):
        tmp[n] = pool[n].fitness
    idx = np.argsort(-tmp)
    for n in range(N):
        bots[n] = pool[idx[n]].copy()
        fitness[n,gen] = tmp[idx[n]]

    bots[0].set_bot2()

    plt.clf()
    plt.plot(np.ones([N,1])*np.arange(gen+1),fitness[:,0:gen+1],'ko')
    plt.plot(np.arange(gen+1),np.mean(fitness[:,0:gen+1],axis=0),'b')
    for x in np.round([0,0.1*N,0.9*N,-1]):
        plt.plot(np.arange(gen+1),fitness[int(x),0:gen+1],'k')
    plt.show(block=False)
    plt.pause(0.1)

plt.show()
