import os
import subprocess
import numpy as np

class BB:
    def __init__(self,W,b):
        self.W = W
        self.b = b
        self.fitness = np.nan


    def l(self):
        l = []
        for W in self.W:
            l.append(np.shape(W)[1])
        l.append(np.shape(self.W[-1])[0])
        return l


    def compute_fitness(self):
        self.set_bot()
        subprocess.run('sed -i \'s/<var name="gamefps" value=".*/<var name="gamefps" value="7500"\/>/\' blobby-1.0_fast/data/config.xml', shell=True)
        working_dir = os.getcwd()
        os.chdir('blobby-1.0_fast')
        score = subprocess.run('./src/blobby', stdout=subprocess.PIPE)

        score = score.stdout.decode('utf-8').split('\n')
        score = score[len(score)-2].split(':')
        score_left = int(score[1])
        score_right = int(score[2])
        self.fitness = (score_left-score_right+25)/50

        subprocess.run('sed -i \'s/<var name="gamefps" value=".*/<var name="gamefps" value="75"\/>/\' blobby-1.0_fast/data/config.xml', shell=True)
        os.chdir(working_dir)

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

        f_template = open('nn_template.lua','r')
        f = open('blobby-1.0_fast/data/.blobby/scripts/nn.lua','w')
        f.write(W_str + b_str + f_template.read())
        f.close()
        f_template.close()

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

        f_template = open('nn_template.lua','r')
        f = open('blobby-1.0_fast/data/.blobby/scripts/nn_max.lua','w')
        f.write(W_str + b_str + f_template.read())
        f.close()
        f_template.close()

    def copy(self):
        W = []
        b = []
        for i in range(len(self.W)):
            W.append(self.W[i])
            b.append(self.b[i])
        bb = BB(W,b)
        bb.fitness = self.fitness
        return bb


    @classmethod
    def random(cls,l):
        W = []
        b = []
        for i in range(len(l)-1):
            W.append(np.random.rand(l[i+1],l[i])-0.5)
            b.append(np.random.rand(l[i+1],1)-0.5)
        return BB(W,b)
