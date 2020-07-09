#!/usr/bin/python3

import base64, sys, subprocess
import hashlib
import hmac
import json
import requests
from urllib.request import urlopen
from urllib.parse import quote, urlencode


API_KEY = ""
API_SECRET= ""

COMPUTE_ENDPOINT = "https://api.exoscale.ch/compute"
search_list = ['id', 'displayname', 'templatename']
instance_data =  { "billing_tag": "sles"}

def parse_dict(mydict, search_list):
    result = {}
    if isinstance(mydict, dict):      
        num = mydict['listvirtualmachinesresponse']['count']
        for i in range(num):
            h = str(i)
            h = {}
            for b in search_list:
                value = mydict['listvirtualmachinesresponse']['virtualmachine'][i][b]
                h.update({ b : value })
                #print(b, value)
            result.update({ i : h })
            
    else:
        sys.exit(2)
    return result

def get_uuid():
    dmidecode = subprocess.Popen(['/usr/sbin/dmidecode'],
                                      stdout=subprocess.PIPE,
                                      bufsize=1,
                                      universal_newlines=True
                                      )

    while True:
        line = dmidecode.stdout.readline()
        if "UUID:" in str(line):
            uuid = str(line).split("UUID:", 1)[1].split()[0]
            uuid = uuid.lower()
            return uuid
        if not line:
            break

def match_value(input_dict, find_key, find_val):
    isFound = ""
    if isinstance(input_dict, dict):
        for k, v in input_dict.items():
            if isinstance(v, dict):
                for x, y in v.items():
                    if x == find_key and y == find_val:
                        isFound = "found"
                        return isFound, v
            else:
                if k == find_key and v == find_val:
                    isFound = "found"
                    return isFound, input_dict
    else:
        print("no dict given")
        

def sign(command, secret):
  """Adds the signature bit to a command expressed as a dict"""
  # order matters
  arguments = sorted(command.items())

  # urllib.parse.urlencode is not good enough here.
  # key contains should only contain safe content already.
  # safe="*" is required when producing the signature.
  query_string = "&".join("=".join((key, quote(value, safe="*")))
                          for key, value in arguments)

  # Signing using HMAC-SHA1
  digest = hmac.new(
      secret.encode("utf-8"),
      msg=query_string.lower().encode("utf-8"),
      digestmod=hashlib.sha1).digest()

  signature = base64.b64encode(digest).decode("utf-8")

  return dict(command, signature=signature)


# The command contains the apikey and the parameters
command = {
  "command":           "listVirtualMachines",
  "apikey":            API_KEY,
}

# Signing the request and URL encoding it
params = sign(command, API_SECRET)
query_string = urlencode(params)
endurl = COMPUTE_ENDPOINT + "?" + query_string
# As GET
response = requests.get(endurl)
json_response = response.json()
found = parse_dict(json_response, search_list)

my_uuid = get_uuid()
find_key = 'id'

result, result_dict = match_value(found, find_key, my_uuid)
#print(result, result_dict)
if result is 'found':
    final = ""
    #print("matching uuid found: %s" % my_uuid)
    instance_data.update( {'instance-id' : my_uuid} )
    for k, v in result_dict.items():
        final += k + ": " + v + ", "
    print(final)
