import matplotlib.pyplot as plt
import numpy as np


def plot(fig, fitness):
    gen = len(fitness)
    if gen == 1:
        return
    fig.clf()

    ax = plt.axes()
    ax.plot(np.arange(gen), np.mean(fitness, axis = 1), 'k')
    ax.plot(np.arange(gen), np.max(fitness, axis = 1), 'k')
    ax.plot(np.arange(gen), np.min(fitness, axis = 1), 'k')

    yres = 20
    y_grid = np.linspace(0, 1, yres)
    zi = [ [ np.sum(np.less_equal(y_grid[j],fitness[k])*np.less(fitness[k],y_grid[j+1])) for j in range(len(y_grid)-1)] for k in range(gen) ]

    zi = np.transpose(np.array(zi))
    zi = np.concatenate((zi, np.zeros([1,gen])))
    xi, yi = np.meshgrid(np.arange(0,gen)-0.5, y_grid)
    tmp = ax.pcolor(xi, yi, zi, cmap=plt.cm.Oranges)
    plt.colorbar(tmp)
    tmp.set_clim(vmin=0, vmax=20)

    ax.set_xlabel('generation')
    ax.set_ylabel('fitness')
    ax.set_xlim([0,gen-1.5])
    ax.set_ylim([0,1])

    plt.show(block=False)
    plt.pause(0.1)
