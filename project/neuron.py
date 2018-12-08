import operator
from copy import copy, deepcopy
from itertools import repeat

import numpy


class Neuron:
    def __init__(self, downstream=None):
        if downstream:
            self.downstream = downstream
        else:
            self.downstream = {}

    def connect(neurons, weights=1.0):
        """ Adds neurons downstream of this neuron"""
        if type(neuron) == list:
            if len(neuron) != len(weights):
                assert len(weights) == 1
            for n, l in zip(neurons, weights):
                self.downstream[n] = l
        else:
            assert type(neurons) == Neuron
            self.downstream[neurons] = float(weights)

    @staticmethod
    def _match_and_execute(neuron, values, op):
        assert len(neuron.downstream) == len(values) or len(values) == 1
        for key, v in zip(neuron.downstream, repeat(values)):
            neuron.downstream[key] = op(neuron.downstream[key], v)
        return neuron

    # These are dangerous because upstream won't point to the new neurons
    # but if you need them just uncomment
    #
    # def __add__(self, values):
    #     return _match_and_execute(copy(self), values, operator.add)
    #
    # def __mul__(self, other):
    #     return _match_and_execute(copy(self), values, operator.mul)
    #
    # def __sub__(self, other):
    #     return _match_and_execute(copy(self), values, operator.sub)
    #
    # def __truediv__(self, other):
    #     return _match_and_execute(copy(self), values, operator.truediv)

    def __iadd__(self, values):
        return _match_and_execute(self, values, operator.add)

    def __imul__(self, other):
        return _match_and_execute(self, values, operator.mul)

    def __isub__(self, other):
        return _match_and_execute(self, values, operator.sub)

    def __itruediv__(self, other):
        return _match_and_execute(self, values, operator.truediv)
