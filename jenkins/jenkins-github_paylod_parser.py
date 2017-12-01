import os
import json

payload =  os.environ['payload']
prop = os.environ['prop_file']

json_ob = json.loads(payload)
sender =  json_ob['sender']['login']
branch = json_ob['pull_request']['head']['ref']
statuses_url = json_ob['statuses_url']

#delete old prop file if exists
try:
    os.remove(prop)
except OSError:
    pass

#print parameters to prop file
with open(prop, "a") as myfile:
    myfile.write('git_user='+sender)
    myfile.write('\ngit_branch='+branch)
    myfile.write('\nstatuses_url='+statuses_url)