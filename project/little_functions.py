import matplotlib.pyplot as plt
import numpy as np


def plot(fig, fitness):
    gen = len(fitness)
    if gen == 1:
        return
    fig.clf()

    ax = plt.axes()
    ax.plot(np.arange(gen),np.mean(fitness,axis=1),'k')
    for x in np.arange(0,0.25,0.01):
        top = np.array([f[int(x*len(f))] for f in fitness])
        bot = np.array([f[int((1-x)*len(f)-1)] for f in fitness])
        ax.fill_between(np.arange(gen),bot-0.01,top+0.01,facecolor='blue',alpha=0.04)

    ax.set_xlabel('generation')
    ax.set_ylabel('fitness')
    ax.set_xlim([0,gen-1])
    ax.set_ylim([0,1])

    plt.show(block=False)
    plt.pause(0.1)
