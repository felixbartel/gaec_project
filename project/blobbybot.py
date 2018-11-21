import os
import glob
import subprocess
import numpy as np

# Get a template once at import
with open('blobby-1.0_fast/data/.blobby/config.xml','r') as f:
    config_template = f.read()

with open('nn_template.lua','r') as f:
    nn_template = f.read()

# Clean old .xml files
for f in glob.glob("blobby-1.0_fast/data/.blobby/config_*.xml"):
    os.remove(f)

class BB:
    def __init__(self, W, b, id):
        self.id = id
        self.config_fname = 'config_{:04d}.xml'.format(id)
        self.config_path = 'blobby-1.0_fast/data/.blobby/' + self.config_fname
        self.nn_path = 'blobby-1.0_fast/data/.blobby/scripts/nn_{:04d}.lua'.format(id)
        self.W = W
        self.b = b
        self.fitness = np.nan

        self.config_string = config_template.replace('<var name="left_script_name" value="nn"/>',
                                                     '<var name="left_script_name" value="nn_{:04d}"/>'.format(self.id))
        if not os.path.isfile(self.config_path):
            with open(self.config_path, 'w') as f:
                f.write(self.config_string)

    def l(self):
        l = []
        for W in self.W:
            l.append(np.shape(W)[1])
        l.append(np.shape(self.W[-1])[0])
        return l

    def compute_fitness(self):
        self.set_bot()

        score = subprocess.run(['./src/blobby', self.config_fname],
                               stdout=subprocess.PIPE,
                               cwd='blobby-1.0_fast')

        score = score.stdout.decode('utf-8').split('\n')
        score = score[len(score)-2].split(':')
        score_left = int(score[1])
        score_right = int(score[2])
        self.fitness = score_left/(score_left+score_right)

    def set_bot(self):
        W_str = ''
        W_str += 'W = {'
        for i in range(len(self.W)):
            W_str += '{'
            for j in range(self.W[i].shape[0]):
                W_str += '{'
                for k in range(self.W[i].shape[1]):
                    W_str += str(self.W[i][j,k])
                    if k < self.W[i].shape[1]-1:
                        W_str += ','
                W_str += '}'
                if j < self.W[i].shape[0]-1:
                    W_str += ','
            W_str += '}'
            if i < len(self.W)-1:
                W_str += ',\n'
        W_str += '}\n'

        b_str = ''
        b_str += 'b = {'
        for i in range(len(self.b)):
            b_str += '{'
            for j in range(self.b[i].shape[0]):
                b_str += str(self.b[i][j][0])
                if j < self.b[i].shape[0]-1:
                    b_str += ','
            b_str += '}'
            if i < len(self.b)-1:
                b_str += ','
        b_str += '}\n'

        with open(self.nn_path,'w') as f:
            f.write(W_str + b_str + nn_template)

    def set_bot2(self):
        W_str = ''
        W_str += 'W = {'
        for i in range(len(self.W)):
            W_str += '{'
            for j in range(self.W[i].shape[0]):
                W_str += '{'
                for k in range(self.W[i].shape[1]):
                    W_str += str(self.W[i][j,k])
                    if k < self.W[i].shape[1]-1:
                        W_str += ','
                W_str += '}'
                if j < self.W[i].shape[0]-1:
                    W_str += ','
            W_str += '}'
            if i < len(self.W)-1:
                W_str += ',\n'
        W_str += '}\n'

        b_str = ''
        b_str += 'b = {'
        for i in range(len(self.b)):
            b_str += '{'
            for j in range(self.b[i].shape[0]):
                b_str += str(self.b[i][j][0])
                if j < self.b[i].shape[0]-1:
                    b_str += ','
            b_str += '}'
            if i < len(self.b)-1:
                b_str += ','
        b_str += '}\n'

        with open('blobby-1.0_fast/data/.blobby/scripts/nn_max.lua','w') as f:
            f.write(W_str + b_str + nn_template)

    @staticmethod
    def random(l, id):
        W = []
        b = []
        for i in range(len(l)-1):
            W.append(np.random.rand(l[i+1],l[i])-0.5)
            b.append(np.random.rand(l[i+1],1)-0.5)
        return BB(W, b, id)
