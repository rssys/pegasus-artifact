import sys
import yaml

filename = sys.argv[1]
files = list(yaml.safe_load_all(open(filename).read()))

#def modify_spec_runc(spec):
#    for c in spec['containers']:
#        if 'resources' in c:
#            del c['resources']

def modify_spec(spec):
    #if 'runtimeClassName' not in spec or spec['runtimeClassName'] != 'uvisor':
    #    modify_spec_runc(spec)
    #    return
    for init in spec['initContainers']:
        if init['name'] == 'istio-init':
            init['image'] = 'pdlan/pegasus-artifact-proxyv2'
            init['env'] = [
                {
                    'name': 'RUNUC_PASS_TO',
                    'value': 'runc',
                }
            ]
    for c in spec['containers']:
        #if 'resources' in c:
        #    del c['resources']
        if c['name'] == 'istio-proxy':
            c['image'] = 'pdlan/pegasus-artifact-proxyv2'

def modify_pod(pod):
    modify_spec(pod['spec'])

def modify_deployment(file):
    modify_pod(file['spec']['template'])

output = []

for file in files:
    if file is None or 'kind' not in file:
        continue
    if file['kind'] == 'Deployment':
        modify_deployment(file)
    elif file['kind'] == 'Pod':
        modify_pod(file)
    output.append(file)
print(yaml.dump_all(output))
print('---')

