# run as sudo /home/hassna/.pyenv/shims/python ATI_force.py


import pysoem
import time
import struct
import time

out_file = open("/home/hassna/Documents/Codes/Pituitary_study_force_sensor/measurments_test_14_12_2023/FT_test_new_board.txt", "w") # a: append, w: overwrite

out_file.write(f"Start time: {str(time.ctime())}")
out_file.write("\n")

out_file.write("t Fx Fy Fz Tx Ty Tz")
out_file.write("\n")

FT = [0, 0, 0, 0, 0, 0]

master = pysoem.Master()
master.open('enp0s31f6') # 'Your network adapters ID', use find_adapters.py to find the lan adapter ID

SLEEP_TIME = 0.001
time_init = time.time()

print(master.config_init())

if master.config_init() > 0:
    device = master.slaves[0]
    device_name = device.name
    print(f"device name: {device_name}" )
    print(f"\n vendor ID: {hex(device.man)}") # vendor ID
    print(f"\n product ID: {hex(device.id)}") # product code

    while True:
        try:

            device.state = pysoem.OP_STATE
            time.sleep(SLEEP_TIME)
            # device.sdo_write(0x6040, 0, struct.pack('H', 0x0006)) # control word
            # time.sleep(SLEEP_TIME)
            time_now = time.time() - time_init
            FT[0] = struct.unpack('i', device.sdo_read(0x6000, 0x01))[0] # Fx
            time.sleep(SLEEP_TIME)
            FT[1] = struct.unpack('i', device.sdo_read(0x6000, 0x02))[0] # Fy
            time.sleep(SLEEP_TIME)
            FT[2] = struct.unpack('i', device.sdo_read(0x6000, 0x03))[0] # Fz
            time.sleep(SLEEP_TIME)
            FT[3] = struct.unpack('i', device.sdo_read(0x6000, 0x04))[0] # Tx
            time.sleep(SLEEP_TIME)
            FT[4] = struct.unpack('i', device.sdo_read(0x6000, 0x05))[0] # Ty
            time.sleep(SLEEP_TIME)
            FT[5] = struct.unpack('i', device.sdo_read(0x6000, 0x06))[0] # Tz
            time.sleep(SLEEP_TIME)
            out_str = str(time_now) + ' ' + str(FT[0]) + ' ' + str(FT[1]) + ' ' + str(FT[2]) + ' ' + str(FT[3]) + ' ' + str(FT[4]) + ' ' + str(FT[5])
            print(out_str)
            out_file.write(out_str + "\n")

        except Exception as e:

            print(f"Device had this error: {e} and it read this: {device.sdo_read(0x6000, 0x06)}")

else:
    print('no device found')

out_file.write("\n")
out_file.write(f"Finish time: {str(time.ctime())}")
master.close()
out_file.close()


# add end time when an input is given from the keyboard
# add sampling time