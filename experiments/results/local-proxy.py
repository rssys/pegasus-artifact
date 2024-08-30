import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import sys
import json
from statistics import mean, median, stdev
import numpy as np

plt.rcParams.update({'font.size': 20, 'font.family': 'Times New Roman'})
fig, ax  = plt.subplots(1, 1, figsize=(5,4), constrained_layout=True)

ticks = list(range(0, 110, 10))

def load_txt(s, n, t):
    lines = open('../local-proxy/data/%s/%d-%s.txt' % (s, n, t)).readlines()
    avg = float(lines[3].split()[1][:-2])
    tail = float(lines[9].split()[1][:-2])
    reqs = float(lines[-2].split()[1]) / 1000
    return reqs, avg, tail
    

def load_data(s):
    a = []
    b = []
    c = []
    d = []
    e = []
    f = []
    for ti in ticks:
        x = []
        y = []
        z = []
        for n in range(1, 11):
            th, m, t = load_txt(s, n, ti)
            x.append(th)
            y.append(m)
            z.append(t)
        a.append(median(x))
        b.append(median(y))
        c.append(median(z))
        d.append(stdev(x))
        e.append(stdev(y))
        f.append(stdev(z))
    return np.array(a), np.array(b), np.array(c), np.array(d), np.array(e), np.array(f)

a1, b1, c1, d1, e1, f1 = load_data('baseline')
a2, b2, c2, d2, e2, f2 = load_data('pegasus')

name = 'Pegasus'

plotdata_throughput = pd.DataFrame({
    'Baseline': a1,
    name: a2,
}, index=ticks)

plotdata_latency = pd.DataFrame({
    'Baseline': b1,
    name: b2,
}, index=ticks)

plotdata_tail = pd.DataFrame({
    'Baseline': c1,
    name: c2,
}, index=ticks)

plotdata_throughput_err = pd.DataFrame({
    'Baseline': d1,
    name: d2,
}, index=ticks)

plotdata_latency_err = pd.DataFrame({
    'Baseline': e1,
    name: e2,
}, index=ticks)

plotdata_tail_err = pd.DataFrame({
    'Baseline': f1,
    name: f2,
}, index=ticks)

colors = ["#35618f", "#5ac4f8", "#6c218e"]
markers = ['o', 'x', 'D']

for x, m, c in zip(plotdata_throughput, markers, colors):
    plotdata_throughput[x].plot(kind='line', rot=0, legend=False, color=c, marker=m, ax=ax, yerr=plotdata_throughput_err)

ax.set_xlabel('Percentage of Proxied Requests')
ax.set_ylabel("Throughput (KQPS)")
ax.set_xlim(0, 100)
ax.set_ylim(0, 45)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax.yaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
plt.legend(loc='upper right', prop={'size': 16})
plt.savefig('fig-local-proxy.pdf')

