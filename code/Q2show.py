import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from minepy import MINE

def MIC_matirx(data, mine):
    n = len(data[0, :])
    result = np.zeros([n, n])
    for i in range(n):
        for j in range(n):
            mine.compute_score(data[:, i], data[:, j])
            result[i, j] = mine.mic()
            result[j, i] = mine.mic()

    return np.array(result)

def MIC(data):
    mine = MINE(alpha=0.6, c=15)#alpha:网格分辨率限制，m*n<B,B=n^alpha
    data_mic = MIC_matirx(data, mine)
    return data_mic

data=np.loadtxt('./22.csv',delimiter=',')
res = MIC(data)
np.savetxt('./22mic.csv', res, delimiter=',')