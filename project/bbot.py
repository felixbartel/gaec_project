import os
import glob
import subprocess
import numpy as np
from copy import copy, deepcopy


test = False # replace fitness function

# Get a templates once at import
with open('blobby-1.0_fast/data/.blobby/config.xml','r') as f:
    config_template = f.read()

with open('nn_template.lua','r') as f:
    nn_template = f.read()

# Clean old .xml files
for f in glob.glob("blobby-1.0_fast/data/.blobby/config_*.xml"):
    os.remove(f)


def crossover_mix_nodes(bbot1, bbot2, offspring1, offspring2, rate):
    offspring1.weights = deepcopy(bbot1.weights)
    offspring2.weights = deepcopy(bbot2.weights)
    for j in range(bbot1.nlayers-1):
        for k in range(bbot1.size[j+1]):
            if np.random.rand() < rate:
                offspring1.weights[j][k,:] = deepcopy(bbot2.weights[j][k,:])
                offspring2.weights[j][k,:] = deepcopy(bbot1.weights[j][k,:])


class Bot:
    def __init__(self, weights, id):
        self.weights = deepcopy(weights)
        self.id = id
        self.fitness = np.nan

    @property
    def id(self):
        return self._id

    @id.setter
    def id(self, id):
        self._id = id
        self.config_fname = 'config_{:04d}.xml'.format(id)
        self.config_path = 'blobby-1.0_fast/data/.blobby/' + self.config_fname
        self.nn_path = 'blobby-1.0_fast/data/.blobby/scripts/nn_{:04d}.lua'.format(id)
        self.config_string = config_template.replace('<var name="left_script_name" value="nn"/>',
                                                     '<var name="left_script_name" value="nn_{:04d}"/>'.format(self.id))
        if not os.path.isfile(self.config_path):
            with open(self.config_path, 'w') as f:
                f.write(self.config_string)

    @property
    def size(self):
        # returns the size of the neuronal network
        size = []
        for w in self.weights:
            size.append(np.shape(w)[1]-1)
        size.append(np.shape(self.weights[-1])[0])
        return size

    @property
    def nlayers(self):
        # return the number of layers
        return len(self.size)

    @staticmethod
    def random(size, id):
        # creates a uniformly randon bbot
        weights = []
        for j in range(len(size)-1):
            weights.append(np.random.rand(size[j+1], size[j]+1)-0.5)
        return Bot(weights, id)

    def mutate_gaussian(self, rate, sigma):
        # adds Gaussian noise with deviation sigma to rate weights (0.5 for half of them)
        for j in range(self.nlayers-1):
            mask = np.less(np.random.random_sample(self.weights[j].shape), rate)
            self.weights[j] += sigma*mask*np.random.randn(self.weights[j].shape[0],self.weights[j].shape[1])

    def compute_fitness(self):
        if test:
            # sum over squared frobenius norms of the weight matrices
            frob = 0
            for w in self.weights:
                frob += np.sum(w**2)
            self.fitness = 1/(1+frob)
        else:
            self.set_bot()

            score = subprocess.run(['./src/blobby', self.config_fname],
                                   stdout=subprocess.PIPE,
                                   cwd='blobby-1.0_fast')

            score = score.stdout.decode('utf-8').split('\n')
            score = score[len(score)-2].split(':')
            score_left = int(score[1])
            score_right = int(score[2])
            self.fitness = score_left/(score_left+score_right)

    def set_bot(self, path = 0):
        if path == 0:
            path = self.nn_path
        W_str = ''
        W_str += 'W = {'
        for i in range(self.nlayers-1):
            W_str += '{'
            for j in range(self.size[i+1]):
                W_str += '{'
                for k in range(self.size[i]):
                    W_str += str(self.weights[i][j,k])
                    if k < self.size[i]-1:
                        W_str += ','
                W_str += '}'
                if j < self.size[i+1]:
                    W_str += ','
            W_str += '}'
            if i < self.nlayers-1:
                W_str += ',\n'
        W_str += '}\n'

        with open(path,'w') as f:
            f.write(W_str + nn_template)
