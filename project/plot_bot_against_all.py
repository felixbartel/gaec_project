import numpy as np
import matplotlib.pyplot as plt
import glob
import subprocess
import os

# Get templates once at import
with open('blobby-1.0_fast/data/.blobby/config.xml', 'r') as f:
    config_template = f.read()


bots_x =  glob.glob("../bots/*")
bots_x = [ os.path.basename(bot) for bot in bots_x ]
bots_x = [ bot[0:-4] for bot in bots_x ]
bots_x.sort()
bots_y = [ 'trainer', 'Union', 'hyp014', 'com_11', 'gintonicV9', 'reduced', 'trainer_5t', 'Union_5t', 'hyp014_5t', 'com_11_5t', 'gintonicV9_5t', 'reduced_5t' ]

fitnesses = []
for bot in bots_x:
    fitnesses.append([])
    with open('../bots/' + bot + '.lua', 'r') as src, open('blobby-1.0_fast/data/.blobby/scripts/' + bot + '.lua', 'w') as dst: dst.write(src.read())
    for opponent in bots_y:
        config_fname = 'config_plot.xml'
        config_path = 'blobby-1.0_fast/data/.blobby/' + config_fname
        config_string = config_template.replace('<var name="left_script_name" value=""/>',
                                                     '<var name="left_script_name" value="{:s}"/>'.format(bot))
        config_string = config_string.replace('<var name="right_script_name" value=""/>',
                                                     '<var name="right_script_name" value="{:s}"/>'.format(opponent))
        with open(config_path, 'w') as f:
            f.write(config_string)

        score = subprocess.run(['./src/blobby', config_fname],
                               stdout=subprocess.PIPE,
                               cwd='blobby-1.0_fast')

        score = score.stdout.decode('utf-8').split('\n')
        score = score[len(score) - 2].split(':')
        score_left = int(score[1])
        score_right = int(score[2])

        fitnesses[-1].append(score_left / (score_left + score_right))
    os.remove('blobby-1.0_fast/data/.blobby/scripts/' + bot + '.lua')


p = []
for j in range(len(bots_y)):
    bottom = [ sum(s[0:j]) for s in fitnesses ]
    cur = [ s[j] for s in fitnesses ]
    p.append(plt.bar(range(len(bots_x)), cur, 0.5, bottom))

plt.ylabel('sum over fitness')
plt.title('fitnesses')
plt.xticks(rotation=90)
plt.xticks(range(len(bots_x)), bots_x)
plt.subplots_adjust(bottom=0.5)
plt.legend(p, bots_y)

plt.show()
