import argparse
import matplotlib.pyplot as plt
import numpy as np
import pickle

parser = argparse.ArgumentParser()
parser.add_argument('filename', nargs = '?', default = 'fitness.pkl')
parser.add_argument('--gens')
args = parser.parse_args()

with open(args.filename, 'rb') as f:
    fitness = pickle.load(f)

if args.gens is None:
    gen = len(fitness)
else:
    gen = args.gens

fig = plt.figure(figsize=(10,6))
font = {'family' : 'normal',
        'size'   : 26}
plt.rc('font', **font)

ax = plt.axes()
ax.plot(np.arange(gen), np.mean(fitness, axis = 1), 'k')
ax.plot(np.arange(gen), np.max(fitness, axis = 1), 'k')
ax.plot(np.arange(gen), np.min(fitness, axis = 1), 'k')

yres = 23
y_grid = np.linspace(0, 1.0001, yres)
zi = [ [ np.sum(np.less_equal(y_grid[j],fitness[k])*np.less(fitness[k],y_grid[j+1])) for j in range(len(y_grid)-1)] for k in range(gen) ]

zi = np.transpose(np.array(zi))
zi = np.concatenate((zi, np.zeros([1,gen])))
xi, yi = np.meshgrid(np.arange(0,gen)-0.5, y_grid)
tmp = ax.pcolor(xi, yi, zi, cmap=plt.cm.BuGn)
cb = plt.colorbar(tmp)
cb.set_label('% of population')
tmp.set_clim(vmin=0, vmax=20)

ax.set_xlabel('generation')
ax.set_ylabel('fitness')
ax.set_xlim([0,gen-1.5])
ax.set_ylim([0,1])

plt.tight_layout()

plt.savefig(args.filename[0:-3] + 'png')
#plt.show()
