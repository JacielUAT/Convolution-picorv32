import os
import random
import string
from time import sleep


IPDUMMY_MEMIN_LEN = 64
IPDUMMY_MEMOUT_LEN = 64
IPDUMMY_CONFREG_LEN = 2

IPDUMMY_CONFIG_READ = ['MEMOUT', 'STATUS', 'IP_ID']
IPDUMMY_CONFIG_WRITE = ['CONFREG', 'MEMIN', 'PTRCONFREG', 'PTRMEMINWR', 'PTRMEMOUTRD', 'STATUS']

IPDUMMY_PTRMEM = {'CONFREG': '_ipDummy__ptrConfRegWR', 'MEMIN': '_ipDummy__ptrMemInWR', 'MEMOUT': '_ipDummy__ptrMemOutRD'}
IPDUMMY_ATTRIBUTES_RD = {'STATUS': '_ipDummy__status', 'IP_ID': '_ipDummy__ipID'}
IPDUMMY_ATTRIBUTES_WR = {'PTRCONFREG': '_ipDummy__ptrConfRegWR', 'PTRMEMINWR': '_ipDummy__ptrMemInWR', 'PTRMEMOUTRD': '_ipDummy__ptrMemOutRD' }

IPDUMMY_DELAY_ENABLE = '0A0A0A0A'


class ipDummy():
  def __init__(self):
    self.__status = '00000000'
    
    self.__ipID = '00001001'
    
    self.__ptrMemInWR = '00000000'
    
    self.__ptrMemOutRD = '00000000'
    
    self.__ptrConfRegWR = '00000000'
    
    self.__folderName = 'tmp/'
    
    self.__folderName = self.__folderName + ''.join(random.choice(string.ascii_letters + string.digits) for n in xrange(16))
    
    os.makedirs(self.__folderName)
    
    print "Files in", self.__folderName, "folder"
    
    # Init files
    dataTemp = []
    for i in range(IPDUMMY_CONFREG_LEN):
        dataTemp.append('00000000')
     
    self.__writeFile("CONFREG", dataTemp)
     
    dataTemp = []
    for i in range(IPDUMMY_MEMIN_LEN):
        dataTemp.append('00000000')
     
    self.__writeFile("MEMIN", dataTemp)
     
    dataTemp = []
    for i in range(IPDUMMY_MEMOUT_LEN):
        dataTemp.append('00000000')
     
    self.__writeFile("MEMOUT", dataTemp)

  def read(self, config):
    returnValue = ''
    
    if config in IPDUMMY_CONFIG_READ:
        if config in IPDUMMY_PTRMEM.keys():
            dataTemp = self.__readFile(config)
            ptr = eval("locals()['self'].%s" % IPDUMMY_PTRMEM[config])
            returnValue = dataTemp[int(ptr, 16)]
            self.__increasePtr(1, config)
        elif config in IPDUMMY_ATTRIBUTES_RD.keys():
            returnValue = eval("locals()['self'].%s" % IPDUMMY_ATTRIBUTES_RD[config])
        else:
            return 1
    
    return returnValue

  def write(self, config, data):
    if config in IPDUMMY_CONFIG_WRITE:
      if config in IPDUMMY_PTRMEM.keys():
        dataTemp = self.__readFile(config)
        ptr = eval("locals()['self'].%s" % IPDUMMY_PTRMEM[config])
        dataTemp[int(ptr, 16)] = data
        self.__writeFile(config, dataTemp)
        self.__increasePtr(1, config)
      elif config in IPDUMMY_ATTRIBUTES_WR.keys():
        ptr = "self.%s" % IPDUMMY_ATTRIBUTES_WR[config]
        exec(ptr + "= data")
    else:
      return 1
    
    return 0

  def start(self):
    # Set BUSY and clear DONE flag
    self.__status = format(int(self.__status, 16) & int('FFFFFEFF', 16), '08X')
    self.__status = format(int(self.__status, 16) | int('00000001', 16), '08X')
    
    dataTemp = self.__readFile('MEMIN')
    
    dataConf = self.__readFile('CONFREG')
    
    if dataConf[0] == IPDUMMY_DELAY_ENABLE:
      sleep(int(dataConf[1], 16) * 0.001)
    
    self.__writeFile('MEMOUT', dataTemp)
    
    # Set DONE and clear BUSY flags
    self.__status = format(int(self.__status, 16) & int('FFFFFFFE', 16), '08X')
    self.__status = format(int(self.__status, 16) | int('00000100', 16), '08X')
    
    return 0

  def __writeFile(self, file, data):
    if file == "CONFREG":
      fileOpen = open(self.__folderName + '/ConfReg.dat', 'w')
    elif file == "MEMIN":
      fileOpen = open(self.__folderName + '/MemIn.dat', 'w')
    elif file == "MEMOUT":
      fileOpen = open(self.__folderName + '/MemOut.dat', 'w')
    else:
      return 1
    
    for i in range(len(data)):
      fileOpen.write(data[i] + '\n')
    
    fileOpen.close()
    
    return 0

  def __readFile(self, file):
    if file == "CONFREG":
      fileOpen = open(self.__folderName + '/ConfReg.dat', 'r')
    elif file == "MEMIN":
      fileOpen = open(self.__folderName + '/MemIn.dat', 'r')
    elif file == "MEMOUT":
      fileOpen = open(self.__folderName + '/MemOut.dat', 'r')
    else:
      return 1
    
    data = fileOpen.readlines()
    
    fileOpen.close()
    
    for i in range(len(data)):
      data[i] = data[i].rstrip('\n')
    
    return data

  def __increasePtr(self, len, file):
    if file == 'CONFREG':
      if len > IPDUMMY_CONFREG_LEN:
        return 1
        
      currentSpace = IPDUMMY_CONFREG_LEN - int(self.__ptrConfRegWR, 16)
        
      if currentSpace <= len:
        self.__ptrConfRegWR = format(0, '08X')
        len = len - currentSpace
      
      if len > 0:
        self.__ptrConfRegWR = format(int(self.__ptrConfRegWR, 16) + len, '08X')

    elif file == 'MEMIN':
      if len > IPDUMMY_MEMIN_LEN:
        return 1
        
      currentSpace = IPDUMMY_MEMIN_LEN - int(self.__ptrMemInWR, 16)
        
      if currentSpace <= len:
        self.__ptrMemInWR = format(0, '08X')
        len = len - currentSpace
        
      if len > 0:
        self.__ptrMemInWR = format(int(self.__ptrMemInWR, 16) + len, '08X')

    elif file == 'MEMOUT':
      if len > IPDUMMY_MEMOUT_LEN:
        return 1
      
      currentSpace = IPDUMMY_MEMOUT_LEN - int(self.__ptrMemOutRD, 16)
      
      if currentSpace <= len:
        self.__ptrMemOutRD = format(0, '08X')
        len = len - currentSpace
      
      if len > 0:
        self.__ptrMemOutRD = format(int(self.__ptrMemOutRD, 16) + len, '08X')

    else:
        return 1
    
    return 0
