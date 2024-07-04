
import logging, time
from ipdi.ip.pyaip import pyaip, pyaip_init

DEBUG_DELAY = True

## IP Dummy driver class
class dummy:
    ## Class constructor of IP Dummy driver
    #
    # @param self Object pointer
    # @param targetConn Middleware object
    # @param config Dictionary with IP Dummy configs
    # @param addrs Network address IP
    def __init__(self, vcom, configFile, addr=1, port=0):
        self.__pyaip = pyaip_init(vcom, addr, port, configFile)
        
        if self.__pyaip is None:
            logging.debug(error)

        ## Array of strings with information read
        self.dataRX = []

        ## IP Dummy IP-ID
        self.IPID = 0

        self.__getID()

        self.__clearStatus()

        logging.debug(f"IP Dummy controller created with IP ID {self.IPID:08x}")

    ## Write data in the IP Dummy input memory
    #
    # @param self Object pointer
    # @param data String array with the data to write
    def writeData(self, data):
        self.__pyaip.writeMem('MDATAIN', data, len(data), 0)

        logging.debug("Data captured in Mem Data In")

    ## Read data from the IP Dummy output memory
    #
    # @param self Object pointer
    # @param size Amount of data to read
    def readData(self, size):
        data = self.__pyaip.readMem('MDATAOUT', size, 0)

        logging.debug("Data obtained from Mem Data Out")

        return data

    ## Start processing in IP Dummy
    #
    # @param self Object pointer
    def startIP(self):
        self.__pyaip.start()

        logging.debug("Start sent")

    ## Set and enable delay in IP Dummy processing
    #
    # @param self Object pointer
    # @param msec Delay in millisecond
    def enableDelay(self, msec):
        timeDelay = []

        timeDelay.append((msec*2)+1)

        self.__pyaip.writeConfReg('CDELAY', timeDelay, 1, 0)

        logging.debug(f"Delay setted to {msec} ms")

    ## Disable delay in IP Dummy processing
    #
    # @param self Object pointer
    def disableDelay(self):
        timeDelay = [0]
        self.__pyaip.writeConfReg('CDELAY', timeDelay, 1, 0)
        
        logging.debug("Delay disabled")

#    ## Enbale IP Dummy interruptions
#    #
#    # @param self Object pointer
#    def enableINT(self):
#        self.__pyaip.enableINT(0)
#
#        logging.debug("Int enabled")

#    ## Disable IP Dummy interruptions
#    #
#    # @param self Object pointer
#    def disableINT(self):
#        self.__pyaip.disableINT(0)
#
#        logging.debug("Int disabled")
    
    ## Show IP Dummy status
    #
    # @param self Object pointer
    def getStatus(self):
        status = self.__pyaip.getStatus()
        
        logging.debug(f"Status {status:08x}")

        return status
        
    ## Wait for the completion of the process
    #
    # @param self Object pointer
    def waitDone(self):
        waiting = True
        
        while waiting:
            status = self.__pyaip.getStatus()

            logging.debug(f"status {status:08x}")
            
            if status & 0x1:
                waiting = False
            
            time.sleep(0.5)
    
    def finish(self):
        self.__pyaip.finish()

    ## Get IP ID
    #
    # @param self Object pointer
    def __getID(self):
        self.IPID = self.__pyaip.getID()

    ## Clear status register of IP Dummy
    #
    # @param self Object pointer
    def __clearStatus(self):
        for i in range(8):
            self.__pyaip.clearINT(i)

if __name__=="__main__":
    import sys, random, time, os
    logging.basicConfig(level=logging.DEBUG)
    
    port = '/dev/ttyUSB1'
    
    try:
        dmy = dummy(port, '../../config/ID00001001_config.csv')
        logging.info("Test Dummy: Driver creado")
    except:
        logging.error("Test Dummy: Driver NO creado")
        sys.exit()

    random.seed(1)

    dmy.disableDelay()

    dmy.getStatus()

    WR = [random.randrange(2**32) for i in range(0, 64)]

    dmy.writeData(WR)
    logging.info(f"Data generated with {len(WR):d}")
    logging.info(f'TX Data {[f"{x:08X}" for x in WR]}')

    if DEBUG_DELAY:
        dmy.enableDelay(3000)
    
    dmy.startIP()

    dmy.waitDone()

    RD = dmy.readData(64)
    logging.info(f'RX Data {[f"{x:08X}" for x in RD]}')

    for x,y in zip(WR, RD):
        logging.info(f"TX: {x:08x} | RX: {y:08x} | {'TRUE' if x==y else 'FALSE'}")
    
    if DEBUG_DELAY:
        dmy.disableDelay()

    dmy.finish()
    
    logging.info("The End")