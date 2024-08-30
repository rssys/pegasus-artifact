from statistics import median

data = {
   "baseline": [],
   "pegasus": []
}

names = ['Futex Wake Up', 'Condition Variable Wake Up', 'TCP Echo', 'Redis Set', 'Memcached Set', 'HTTP Echo']

def load_data(n, s, l):
    return median([float(open('%s/data/%s/%d.txt' % (n, s, i)).readlines()[l]) / 1000 for i in range(1, 11)])

digits = [2,2,1,1,1,1]

for s in ['baseline', 'pegasus']:
    data[s].append(load_data('cv', s, 1))
    data[s].append(load_data('cv', s, 0))
    data[s].append(load_data('tcp', s, 0))
    data[s].append(load_data('redis', s, 0))
    data[s].append(load_data('memcached', s, 0))
    data[s].append(load_data('http', s, 0))

print('Operation,Baseline,Pegasus,Reduction')
for i, n in enumerate(names):
    d = digits[i]
    d1 = round(data['baseline'][i], d)
    d2 = round(data['pegasus'][i], d)
    reduction = round((d1 - d2) / d1 * 100)
    f = '%s,%.0' + str(d) + 'f,%.0' + str(d) + 'f,%s%%'
    print(f % (n, d1, d2, reduction))

