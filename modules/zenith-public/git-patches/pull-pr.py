######
# pulls a PR from github as a patch file
######

import os
import codecs
import requests
import sys
try:
    prNum = sys.argv[1]
    filePrefix = '000-PR{}'.format(prNum)
    dirList = os.listdir('.')
    fileName = ''
    for file in dirList:
        if file.startswith(filePrefix):
            fileName = file
            break
    if fileName == '':
        prDesc = sys.argv[2]
        fileName = "{}-{}.patch".format(filePrefix, prDesc)

    r = requests.get('https://patch-diff.githubusercontent.com/raw/LandSandBoat/server/pull/{}.patch'.format(prNum))

    if r.status_code == 200:
        with codecs.open(fileName, "w", "utf-8") as temp:
            temp.write(r.text)
        print("Saved file {}".format(fileName))
    else:
        print('Error: {}'.format(r.status_code))
except Exception as e:
    print('Error: {}'.format(e))
