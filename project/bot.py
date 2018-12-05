import os
import glob
import subprocess
import numpy as np
from copy import copy, deepcopy


test = False # replace fitness function

# Get templates once at import
with open('blobby-1.0_fast/data/.blobby/config.xml','r') as f:
    config_template = f.read()

with open('nn_template.lua','r') as f:
    nn_template = f.read()

# Clean old .xml files
for f in glob.glob("blobby-1.0_fast/data/.blobby/config_*.xml"):
    os.remove(f)

class Bot:
    def __init__(self, weights, mutation_p, mutation_rate, mutation_sigma):
        self.weights        = deepcopy(weights)
        self.fitness        = -np.inf
        self.mutation_p     = mutation_p
        self.mutation_rate  = mutation_rate
        self.mutation_sigma = mutation_sigma

    @property
    def size(self):
        # returns the size of the neural network
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
    def random(size):
        # creates a uniformly random bbot
        weights = []
        for j in range(len(size)-1):
            weights.append(np.random.rand(size[j+1], size[j]+1)-0.5)
        mutation_p = np.random.rand()
        mutation_rate = np.random.rand()
        mutation_sigma = 0.05*np.random.rand()
        return Bot(weights, mutation_p, mutation_rate, mutation_sigma)

    def mutate_gaussian(self, *args):
        self.fitness = -np.inf
        # adds Gaussian noise with deviation sigma to rate weights (0.5 for half of them)
        if args[0] == 'self_adapt':
            self.mutation_p += 0.1*np.random.randn()
            self.mutation_rate += 0.1*np.random.randn()
            self.mutation_sigma += 0.01*np.random.randn()
            rate = self.mutation_rate
            sigma = self.mutation_rate
        else:
            rate = args[0]
            sigma = args[1]

        for j in range(self.nlayers-1):
            mask = np.less(np.random.random_sample(self.weights[j].shape), rate)
            self.weights[j] += sigma*mask*np.random.randn(self.size[j+1],self.size[j]+1)

    def compute_fitness(self, id):
        if test:
            # sum over squared frobenius norms of the weight matrices
            frob = 0
            for w in self.weights:
                frob += np.sum(w**2)
            self.fitness = 1/(1+frob)
        else:
            self.write_config(id)
            self.write_lua()

            score = subprocess.run(['./src/blobby', self.config_fname],
                                   stdout=subprocess.PIPE,
                                   cwd='blobby-1.0_fast')

            score = score.stdout.decode('utf-8').split('\n')
            score = score[len(score)-2].split(':')
            score_left = int(score[1])
            score_right = int(score[2])
            self.fitness = score_left/(score_left+score_right)

    def write_config(self, id):
        self.config_fname = 'config_{:04d}.xml'.format(id)
        self.config_path = 'blobby-1.0_fast/data/.blobby/' + self.config_fname
        self.nn_path = 'blobby-1.0_fast/data/.blobby/scripts/nn_{:04d}.lua'.format(id)
        self.config_string = config_template.replace('<var name="left_script_name" value="nn"/>',
                                                     '<var name="left_script_name" value="nn_{:04d}"/>'.format(id))
        if not os.path.isfile(self.config_path):
            with open(self.config_path, 'w') as f:
                f.write(self.config_string)

    def write_lua(self, path = None):
        if not path: # Works for empty sting, empty list...
            path = self.nn_path
        W_str = 'W = {'
        for i in range(self.nlayers - 1):
            W_str += '{'
            for j in range(self.size[i+1]):
                W_str += '{'
                for k in range(self.size[i]):
                    W_str += str(self.weights[i][j, k])
                    if k < self.size[i]-1:
                        W_str += ','
                W_str += '}'
                if j < self.size[i+1]:
                    W_str += ','
            W_str += '}'
            if i < self.nlayers - 1:
                W_str += ',\n'
        W_str += '}\n'

        with open(path, 'w') as f:
            f.write(W_str + nn_template)
