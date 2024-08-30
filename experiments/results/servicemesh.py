import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import sys
import json
from statistics import mean, median, stdev
import numpy as np

plt.rcParams.update({'font.size': 20, 'font.family': 'Times New Roman'})
fig, ax = plt.subplots(1, 1, figsize=(5,4), constrained_layout=True)

ticks = [2,4,6,8,10,20,40,60,80,100,120,140,160,180,200]

def load_json(s, n, t):
    data = json.loads(open('../servicemesh/data/%s/%d-%s.json' % (s, n, t)).read())['result']
    return data['rps']['mean'] / 1000, data['latency']['mean'] / 1000, data['latency']['percentiles']['99'] / 1000

def load_data(s):
    data = []
    for ti in ticks:
        a = []
        b = []
        c = []
        for i in range(1, 11):
            th, m, t = load_json(s, i, ti)
            a.append(th)
            b.append(m)
            c.append(t)
        data.append((median(a), median(b), median(c), stdev(a), stdev(b), stdev(c)))
    return [[x[d] for x in data] for d in range(6)]

a1, b1, c1, d1, e1, f1 = load_data('baseline')
a2, b2, c2, d2, e2, f2 = load_data('pegasus')

name = 'Pegasus'

plotdata_throughput = {
    'Baseline': a1,
    name: a2,
}

plotdata_latency = {
    'Baseline': b1,
    name: b2,
}

plotdata_tail = {
    'Baseline': c1,
    name: c2,
}

err_throughput = {
    'Baseline': d1,
    name: d2,
}

err_latency = {
    'Baseline': e1,
    name: e2,
}

err_tail = {
    'Baseline': f1,
    name: f2,
}

colors = ["#35618f", "#5ac4f8"]
markers = ['o', 'D']

for x, m, c in zip(plotdata_throughput, markers, colors):
    data = pd.DataFrame({
        x: plotdata_latency[x]
    }, index = plotdata_throughput[x])
    data.plot(kind='line', rot=0, legend=False, color=c, marker=m, ax=ax,
        xerr=err_throughput[x], yerr=err_latency[x])

ax.set_xlabel("Throughput (KQPS)")
ax.set_ylabel("Avereage Latency (ms)")
ax.set_xlim(0, 40)
ax.set_ylim(0, 8)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax.yaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax.legend(loc='upper left', prop={'size': 16})
plt.savefig('fig-servicemesh.pdf')

