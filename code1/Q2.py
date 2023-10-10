# 根据相关系数约简操作变量
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from minepy import MINE
from pylab import *
mpl.rcParams['font.sans-serif'] = ['SimHei']

def standardization(x):
    mu = np.mean(x, axis=0)
    sigma = np.std(x, axis=0)
    return (x - mu) / sigma

def read_xlsx(path):
    df=pd.read_excel(path,sheet_name='Sheet1',header=0)
    return df

def read_csv(path):
    df = pd.read_csv(path,delimiter=',')
    return df

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
    print(data_mic)
    return data_mic

def column_map(l,map_zip):
    res_index = []
    for i in l:
        res_index.append(map_zip[i])
    return res_index

def reduce_dim(index,p_mat,r_mat):
    for i in index:
        for j in range(i+1,len(p_mat)):
            if p_mat[i][j]<p_threshold and np.abs(r_mat[i][j])>r_threshold:
                if j in index:
                    index.remove(j)
    return index

def reduce_dim2(index,r_mat):
    for i in index:
        for j in range(i+1,len(r_mat)):
            if np.abs(r_mat[i][j])>m_threshold:
                if j in index:
                    index.remove(j)
    return index

def reduBySpr():
    p_mat=np.loadtxt('./data2/317p.csv',delimiter=',')
    r_mat=np.loadtxt('./data2/317r.csv',delimiter=',')
    col_map=np.loadtxt('./data2/246map.csv',delimiter=',',dtype=np.int)
    index = list(range(len(p_mat)))
    map_zip=dict(zip(index,col_map))
    index=reduce_dim(index,p_mat,r_mat)
    print(index)
    print(len(index))
    index=column_map(index,map_zip)
    print(index)
    print(len(index))
    df=read_xlsx('./data2/raw_data2.xlsx')
    newDf = pd.DataFrame(df, columns=index)
    print(newDf)
    newDf.to_csv('./reduBySpr.csv')

def reduByMIC():

    df = read_csv('./reduBySpr.csv')
    data = df.values[2:, 1:]
    col=df.columns.values[1:]
    col_map=list(map(lambda x:int(x),col))
    # 标准化
    data=standardization(data)
    res = MIC(data)

    np.savetxt('./data2/micR.csv', res, delimiter=',')
    m_mat = np.loadtxt('./data2/micR.csv', delimiter=',')

    index = list(range(len(m_mat)))
    index = reduce_dim2(index, m_mat)
    print(index)
    map_zip = dict(zip(index, col_map))

    index = column_map(index, map_zip)
    print(index)
    print(len(index))
    df = read_xlsx('./data2/raw_data2.xlsx')
    newDf = pd.DataFrame(df, columns=index)
    print(newDf)
    newDf.to_csv('./reduByMIC.csv')


if __name__ == '__main__':
    p_threshold=0.05
    r_threshold=0.6
    m_threshold=0.6
    # m=[0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6]
    # dim=[6,14,22,33,44,59,65,69,73]
    # plt.plot(m,dim,marker='o',c='b',ls='-')
    # plt.xlabel('MIC阈值')
    # plt.ylabel('剩余变量')
    # for t in zip(m,dim):
    #     plt.text(t[0],t[1]+1,str(t[1]))
    # plt.savefig('q2.jpg', dpi=300)
    reduBySpr()
    reduByMIC()
# 问题2 end

