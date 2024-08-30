import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import sys
import json
from statistics import mean, median, stdev
import numpy as np

plt.rcParams.update({'font.size': 20, 'font.family': 'Times New Roman', 'figure.autolayout': True})
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10,5), constrained_layout=True)

ticks = [1,2,4,8,16,24,32,40,48]

def load_json(s, n, t):
    data = json.loads(open('../proxy/data/%s/%d-%s.json' % (s, n, t)).read())['result']
    return data['rps']['mean'] / 1000, data['latency']['mean'] / 1000, data['latency']['percentiles']['99'] / 1000

def load_data(s):
    data = []
    for ti in ticks:
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
a2, b2, c2, d2, e2, f2 = load_data('pegasus-allopt')
a3, b3, c3, d3, e3, f3 = load_data('pegasus-nodpdk')
a4, b4, c4, d4, e4, f4 = load_data('pegasus-novtcp')

name1 = 'Pegasus'
name2 = 'Pegasus w/o\nRemote Opt.'
name3 = 'Pegasus w/o\nLocal Opt.'

plotdata_throughput = {
    'Baseline': a1,
    name1: a2,
    name2: a3,
    name3: a4,
}

plotdata_latency = {
    'Baseline': b1,
    name1: b2,
    name2: b3,
    name3: b4,
}

plotdata_tail = {
    'Baseline': c1,
    name1: c2,
    name2: c3,
    name3: c4,
}

err_throughput = {
    'Baseline': d1,
    name1: d2,
    name2: d3,
    name3: d4,
}

err_latency = {
    'Baseline': e1,
    name1: e2,
    name2: e3,
    name3: e4,
}

err_tail = {
    'Baseline': f1,
    name1: f2,
    name2: f3,
    name3: f4,
}

colors = ["#35618f", "#5ac4f8", "#6c218e", "#63ef85", "#0b522e", "#f24219"]
markers = ['o', 'X', '.', 'D', 'v']

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
ax1.set_xlim(0, 50)
ax1.set_ylim(0, 3)
ax1.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax1.yaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax1.legend(loc='upper right', prop={'size': 16})
ax2.set_xlabel("Throughput (KQPS)")
ax2.set_xlim(0, 50)
ax2.set_ylim(0, 3)
ax2.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax2.yaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax2.set_ylabel("99% Tail Latency (ms)")
#ax1.legend(prop={'size': 16})
plt.savefig('fig-proxy.pdf', bbox_inches='tight')

