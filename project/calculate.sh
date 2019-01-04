#!/bin/bash

gens=1000
bots=('reduced' 'com_11' 'gintonicV9' 'hyp014' 'Union' 'trainer')

# standard
for bot in ${bots[*]}; do
  python3 main.py --gens $gens --bots $bot
  python3 main.py --gens $gens --bots ${bot}_5t
done

# self_adapt_1
for bot in ${bots[*]}; do
  python3 main.py --self_adapt_1 --gens $gens --bots $bot
  python3 main.py --self_adapt_1 --gens $gens --bots ${bot}_5t
done

# self_adapt_2
for bot in ${bots[*]}; do
  python3 main.py --self_adapt_2 --gens $gens --bots $bot
  python3 main.py --self_adapt_2 --gens $gens --bots ${bot}_5t
done

#gens=5000
#
## self training 1
#python3 main.py --gens $gens --bots 'last_best'
#python3 main.py --self_adapt_1 --gens $gens --bots 'last_best'
#
### self training 2
#python3 self_training_2.py --gens $gens
#python3 self_training_2.py --self_adapt_1 --gens $gens
