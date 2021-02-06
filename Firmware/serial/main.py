
import serial


if __name__ == '__main__':
    ser = serial.Serial(
        port='COM4',
        baudrate=19200,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        bytesize=serial.EIGHTBITS,
        timeout=0)
    res = ""
    i = 0
    mem = 0
    while True:

        for c in ser.read():
            res = '{m:0>2X}'.format(m=c) + res
            i += 1
            # print('{m:0>2X}'.format(m = c))

        if i == 4:
            i = 0
            print('0x{address:0>8x} 0x{val}'.format(address=mem, val=res))
            mem += 4
            res = ""
