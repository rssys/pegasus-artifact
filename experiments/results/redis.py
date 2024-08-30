import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import sys
import json
from statistics import mean, median, stdev
import numpy as np

plt.rcParams.update({'font.size': 20, 'font.family': 'Times New Roman'})
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10,5), constrained_layout=True)

def load_json(s, n, t):
    data = json.loads(open('../redis/data/%s/%d-%s.json' % (s, n, t)).read())['ALL STATS']['Totals']
    return data['Ops/sec'] / 1000, data['Average Latency'] * 1000, data['Percentile Latencies']['p99.00'] * 1000

def load_data(s):
    data = []
    if s == 'demikernel':
        ticks = list(range(0, 7))
    else:
        ticks = list(range(0, 12))
    for ti in ticks:
        a = []
        b = []
        c = []
        for i in range(1, 11):
            try:
                th, m, t = load_json(s, i, ti)
            except:
                continue
            a.append(th)
            b.append(m)
            c.append(t)
        data.append((median(a), median(b), median(c), stdev(a), stdev(b), stdev(c)))
    return [[x[d] for x in data] for d in range(6)]

a1, b1, c1, d1, e1, f1 = load_data('baseline')
a2, b2, c2, d2, e2, f2 = load_data('pegasus')
a3, b3, c3, d3, e3, f3 = load_data('f-stack')
a4, b4, c4, d4, e4, f4 = load_data('demikernel')
a5, b5, c5, d5, e5, f5 = load_data('junction')

name = 'Pegasus'

plotdata_throughput = {
    'Baseline': a1,
    name: a2,
    'F-stack': a3,
    'Demikernel': a4,
    'Junction': a5
}

plotdata_latency = {
    'Baseline': b1,
    name: b2,
    'F-stack': b3,
    'Demikernel': b4,
    'Junction': b5
}

plotdata_tail = {
    'Baseline': c1,
    name: c2,
    'F-stack': c3,
    'Demikernel': c4,
    'Junction': c5
}


err_throughput = {
    'Baseline': d1,
    name: d2,
    'F-stack': d3,
    'Demikernel': d4,
    'Junction': d5
}

err_latency = {
    'Baseline': e1,
    name: e2,
    'F-stack': e3,
    'Demikernel': e4,
    'Junction': e5
}

err_tail = {
    'Baseline': f1,
    name: f2,
    'F-stack': f3,
    'Demikernel': f4,
    'Junction': f5
}

colors = ["#35618f", "#5ac4f8", "#6c218e", "#63ef85", "#0b522e"]
markers = ['o', 'X', 'D', '.', 'v']

for x, m, c in zip(plotdata_throughput, markers, colors):
    data = pd.DataFrame({
        x: plotdata_latency[x]
    }, index = plotdata_throughput[x])
    data.plot(kind='line', rot=0, legend=False, color=c, marker=m, ax=ax1,
        xerr=err_throughput[x], yerr=err_latency[x])

for x, m, c in zip(plotdata_throughput, markers, colors):
    data = pd.DataFrame({
        x: plotdata_tail[x]
    }, index = plotdata_throughput[x])
    data.plot(kind='line', rot=0, legend=False, color=c, marker=m, ax=ax2,
        xerr=err_throughput[x], yerr=err_tail[x])

ax1.set_xlabel("Throughput (KQPS)")
ax1.set_ylabel("Avereage Latency (us)")
ax1.set_xlim(0, 900)
ax1.set_ylim(0, 150)
ax1.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax1.yaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax1.legend(loc='upper right', prop={'size': 16})
ax2.set_xlabel("Throughput (KQPS)")
ax2.set_xlim(0, 900)
ax2.set_ylim(0, 150)
ax2.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax2.yaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax2.set_ylabel("99% Tail Latency (us)")
plt.savefig('fig-redis.pdf')
