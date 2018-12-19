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
