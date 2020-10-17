
#Gaussian Filter Program

import numpy as np
import math
import random
import time

############# Input Data
input_with_noise_data_file = open('withnoise.dat','r')
input_with_noise_data = []
for x in input_with_noise_data_file:
    input_with_noise_data.append(float(x))

input_with_noise_data_file.close()

input_with_noise_data_np = np.array(input_with_noise_data) # convert to np for calculations


m = 7 # define the fraction bits
print("m choosed is: " +str(m))
######### scale noise data to fix point
m_input_with_noise_data = np.empty(42028)
m_input_with_noise_data[0:] = input_with_noise_data_np[0:] * pow(2,m)

######## round the m scaled noise data
round_m_input_with_noise_data = np.empty(42028)
round_m_input_with_noise_data[0:] = np.round(m_input_with_noise_data[0:],0)

######## unscale the round noise data
round_input_with_noise_data = np.empty(42028)
round_input_with_noise_data[0:] = m_input_with_noise_data[0:] / pow(2,m)

######### scaling tap values
taps = np.empty(11)
m_taps = np.empty(11)
taps[0:] = [0.035822,0.05879,0.086425,0.113806,0.13424,0.141836,0.13424,0.113806,0.086425,0.05879,0.035822]
m_taps[0:] = np.round(taps[0:] * pow(2,m),0)
print("Fixed point scaled values for taps are\n " + str(m_taps))

######### Apply 11 tap filter
m_filter_out = np.empty(42028)
m_filter_out[0:5]=round_input_with_noise_data[0:5] # set the five start to same
m_filter_out[42027-4:]=round_input_with_noise_data[42027-4:] # set the five start to same
for i in range(0,42028-11):
    temp = float(0)
    for j in range(0,11):
        temp = temp + (round_m_input_with_noise_data[i+j] * m_taps[10-j])
        #print(temp)
    m_filter_out[i+5] = temp
#print(np.min(m_filter_out[5:42028-11]))
########### unscale the filtered data
filter_out = np.empty(42028)
filter_out[5:42027-4] = m_filter_out[5:42027-4] / pow(2,2*m)
filter_out[0:5]=m_filter_out[0:5] # set the five start to same
filter_out[42027-4:]=m_filter_out[42027-4:] # set the five start to same

########## Create output files
round_m_input_with_noise_data_file = open("Python_Input_Scaled_By_M.dat",'w')
for i in round_m_input_with_noise_data:
    round_m_input_with_noise_data_file.write(str(int(i))+"\n")
round_m_input_with_noise_data_file.close()

filter_out_file = open("Python_Simulated_Filtered_Result",'w')
for i in filter_out:
    filter_out_file.write(str(i)+"\n")
filter_out_file.close()


# See PyCharm help at https://www.jetbrains.com/help/pycharm/
