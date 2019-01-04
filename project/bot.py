import glob
import os
import subprocess
from copy import copy, deepcopy

import numpy as np

test = False  # replace fitness function

# Get templates once at import
with open('blobby-1.0_fast/data/.blobby/config.xml', 'r') as f:
    config_template = f.read()

with open('nn_template.lua', 'r') as f:
    nn_template = f.read()

# Clean old .xml files
for f in glob.glob("blobby-1.0_fast/data/.blobby/config_*.xml"):
    os.remove(f)


class Bot:
    def __init__(self, weights, trainer = "trainer"):
        self.weights = deepcopy(weights)
        self.fitness = -np.inf
        self.trainer = trainer

    @property
    def size(self):
        # returns the size of the neural network
        size = []
        for w in self.weights:
            size.append(np.shape(w)[1] - 1)
        size.append(np.shape(self.weights[-1])[0])
        return size
        bbot.mode = mode

    @property
    def nlayers(self):
        # return the number of layers
        return len(self.size)

    @classmethod
    def random(cls, size, trainer = 'trainer'):
        # creates a uniformly random bbot
        weights = []
        for j in range(len(size) - 1):
            weights.append(np.random.rand(size[j + 1], size[j] + 1) - 0.5)
        bbot = cls(weights, trainer)

        return bbot

    def mutate_gaussian(self, rate, sigma):
        self.fitness = -np.inf
        # adds Gaussian noise with deviation sigma to rate weights (0.5 for half of them)
        for j in range(self.nlayers - 1):
            mask = np.less(np.random.random_sample(
                self.weights[j].shape), rate)
            self.weights[j] += sigma * mask * \
                np.random.randn(self.size[j + 1], self.size[j] + 1)

    def compute_fitness(self, id):
        if test:
            # sum over squared frobenius norms of the weight matrices
            frob = 0
            for w in self.weights:
                frob += np.sum(w**2)
            self.fitness = 1 / (1 + frob)
        else:
            self.write_config(id)
            self.write_lua()

            score = subprocess.run(['./src/blobby', self.config_fname],
                                   stdout=subprocess.PIPE,
                                   cwd='blobby-1.0_fast')

            score = score.stdout.decode('utf-8').split('\n')
            score = score[len(score) - 2].split(':')
            score_left = int(score[1])
            score_right = int(score[2])
            self.fitness = score_left / (score_left + score_right)

    def write_config(self, id):
        self.config_fname = 'config_{:04d}.xml'.format(id)
        self.config_path = 'blobby-1.0_fast/data/.blobby/' + self.config_fname
        self.nn_path = 'blobby-1.0_fast/data/.blobby/scripts/nn_{:04d}.lua'.format(
            id)
        self.config_string = config_template.replace('<var name="left_script_name" value=""/>',
                                                     '<var name="left_script_name" value="nn_{:04d}"/>'.format(id))
        self.config_string = self.config_string.replace('<var name="right_script_name" value=""/>',
                                                     '<var name="right_script_name" value="{:s}"/>'.format(self.trainer))
        with open(self.config_path, 'w') as f:
            f.write(self.config_string)

    def write_lua(self, path=None):
        if not path:  # Works for empty sting, empty list...
            path = self.nn_path
        W_str = 'W = {'
        for i in range(self.nlayers - 1):
            W_str += '{'
            for j in range(self.size[i + 1]):
                W_str += '{'
                for k in range(self.size[i]):
                    W_str += str(self.weights[i][j, k])
                    if k < self.size[i] - 1:
                        W_str += ','
                W_str += '}'
                if j < self.size[i + 1]:
                    W_str += ','
            W_str += '}'
            if i < self.nlayers - 1:
                W_str += ',\n'
        W_str += '}\n'

        with open(path, 'w') as f:
            f.write(W_str + nn_template)


class BotSelfAdapt1(Bot):
    def __init__(self, weights, trainer = 'trainer'):
        super().__init__(weights, trainer)
        self.mutation_rate = .0
        self.mutation_sigma = .0

    @classmethod
    def random(cls, size, trainer = 'trainer'):
        # creates a uniformly random bbot
        bbot = super().random(size, trainer)

        bbot.mutation_rate = np.random.rand() / 2 + 0.25
        bbot.mutation_sigma = 0.03 * np.random.rand()

        return bbot

    def mutate_gaussian(self):
        self.fitness = -np.inf
        self.mutation_sigma *= np.exp(0.4 * np.random.randn())
        self.mutation_rate *= np.exp(0.4 * np.random.randn())
        for j in range(self.nlayers - 1):
            mask = np.less(np.random.random_sample(
                self.weights[j].shape), self.mutation_rate)
            self.weights[j] += self.mutation_sigma * mask * \
                np.random.randn(self.size[j + 1], self.size[j] + 1)


class BotSelfAdapt2(Bot):
    def __init__(self, weights, trainer = 'trainer'):
        super().__init__(weights, trainer)
        self.mutation_sigma = []

    @classmethod
    def random(cls, size, trainer = 'trainer'):
        bbot = super().random(size, trainer)

        bbot.mutation_sigma = [
            0.02 * np.random.rand(size[j + 1], size[j] + 1) for j in range(len(size) - 1)]

        return bbot

    def mutate_gaussian(self):
        self.fitness = -np.inf
        for j in range(self.nlayers - 1):
            self.mutation_sigma[j] *= np.exp(
                0.2 * np.random.randn(self.size[j + 1], self.size[j] + 1))
            self.weights[j] += self.mutation_sigma[j] * \
                np.random.randn(self.size[j + 1], self.size[j] + 1)
