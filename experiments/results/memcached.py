import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import sys
import json
from statistics import mean, median, stdev
import numpy as np

plt.rcParams.update({'font.size': 20, 'font.family': 'Times New Roman'})
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10,5), constrained_layout=True)

ticks = list(range(0, 11))

def load_json(s, n, t):
    data = json.loads(open('../memcached/data/%s/%d-%s.json' % (s, n, t)).read())['ALL STATS']['Totals']
    return data['Ops/sec'] / 1000, data['Average Latency'] * 1000, data['Percentile Latencies']['p99.00'] * 1000

def load_data(s):
    data = []
    if s == 'baseline':
        tic = list(range(0, 11))
    else:
        tic = ticks
    for ti in tic:
        a = []
        b = []
        c = []
        for i in range(1, 11):
            try:
                th, m, t = load_json(s, i, ti)
            except:
                continue
            if th == 0:
                print(s, ti, i)
                continue
            a.append(th)
            b.append(m)
            c.append(t)
        data.append((median(a), median(b), median(c), stdev(a), stdev(b), stdev(c)))
    return [[x[d] for x in data] for d in range(6)]

a1, b1, c1, d1, e1, f1 = load_data('baseline')
a2, b2, c2, d2, e2, f2 = load_data('pegasus')
a5, b5, c5, d5, e5, f5 = load_data('junction')

name = 'Pegasus'

plotdata_throughput = {
    'Baseline': a1,
    name: a2,
    'Junction': a5
}

plotdata_latency = {
    'Baseline': b1,
    name: b2,
    'Junction': b5
}

plotdata_tail = {
    'Baseline': c1,
    name: c2,
    'Junction': c5
}


err_throughput = {
    'Baseline': d1,
    name: d2,
    'Junction': d5
}

err_latency = {
    'Baseline': e1,
    name: e2,
    'Junction': e5
}

err_tail = {
    'Baseline': f1,
    name: f2,
    'Junction': f5
}

colors = ["#35618f", "#5ac4f8", "#0b522e"]
markers = ['o', 'X', 'v']

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
ax1.set_xlim(0, 1100)
ax1.set_ylim(0, 100)
ax1.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax1.yaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax1.legend(loc='upper right', prop={'size': 16})
ax2.set_xlabel("Throughput (KQPS)")
ax2.set_xlim(0, 1100)
ax2.set_ylim(0, 100)
ax2.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax2.yaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax2.set_ylabel("99% Tail Latency (us)")
plt.savefig('fig-memcached.pdf')
