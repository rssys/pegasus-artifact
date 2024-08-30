import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import pandas as pd
import numpy as np
from statistics import median

data = open('../tcp/data/pegasus-trace/analyze.txt').readlines()[1]
data = np.array([float(x) / 1000 for x in data.split()])
data1 = [
    ('Mode Switch', data[0] + data[5]),
    ('Waiting for Peer', data[1]),
    ('Network Stack', data[2] + data[4]),
    ('Notification', data[3]),
]

data2 = [
    ('Mode Switch', data[6] + data[9]),
    ('Network Stack', data[7] + data[8]),
]

plt.rcParams.update({
    'font.size': 20, 'font.family': 'Times New Roman',
    'figure.figsize': (10,3)
})

colors = ["#35618f", "#5ac4f8", "#f24219", "#63ef85"]
hatches = ['///', '+', 'X', '\\\\']

df =  pd.DataFrame(
    {
        'Mode Switch': [data[0] + data[5], data[6] + data[9]],
        'Network Stack': [data[2] + data[4], data[7] + data[8]],
        'Scheduler': [data[3], 0],
        'NIC+Peer': [data[1], 0]
    }, index = ['read', 'write']
)
ax = df.plot(kind='barh', stacked=True, width=0.25, color=colors)

for i, bar in enumerate(ax.patches):
    bar.set_hatch(hatches[i // 2])
    bar.set_alpha(0.99)

ax.legend(ncol=2, handles=[
    mpatches.Patch(facecolor=colors[i],hatch=hatches[i],label=df.columns[i],alpha=0.99)
    for i in range(len(colors))
])

ax.set_xlabel('Latency (us)')
plt.tight_layout()
plt.savefig('fig-latency.pdf')

latency = {}
systems = ['baseline','demikernel', 'f-stack', 'junction', 'pegasus']
for s in systems:
    x = []
    for i in range(1, 11):
        lines = open('../tcp/data/%s/%d.txt' % (s, i)).readlines()
        for line in lines:
            if 'time: 'in line:
                x.append(float(line.split('time: ')[1]))
                break
    latency[s] = median(x) / 1000

with open('tab-latency.csv', 'w') as f:
    f.write("Linux,Demikernel,F-Stack,Junction,Pegasus\n")
    f.write(','.join(['%.02f' % latency[s] for s in systems]) + '\n')
