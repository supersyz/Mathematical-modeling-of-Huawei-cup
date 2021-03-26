# 问题一：处理检验数据
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

def read_xlsx(path):
    df=pd.read_excel(path,sheet_name='Sheet1',header=0)
    return df

def read_csv(path):
    res = pd.read_csv(path,delimiter=',')
    return res

def Bessel(v):
    sum=np.sum(v**2)
    return np.sqrt(sum/(len(v)-1))

def less_err(x):
    mean_x=[np.mean(x) for i in x ]
    v=np.array(x)-np.array(mean_x)
    return np.abs(v)

def del_index(df,col):
    index=[]
    for c in col:
        v=less_err(df[c].values)
        delta=Bessel(v)
        d_list=np.array([delta for i in v])
        less=v-3*d_list
        res=np.where(less>0,1,0)
        tmp=[i for i,x in list(enumerate(res)) if x==1]
        index.append(tmp)
    return index

def draw(l,c):
    plt.plot(range(len(l.values)),l.values, '*:r', lw=3,label=c)
    # plt.plot(l.values)
    plt.bar(range(len(l.values)),l.values)
    plt.xlabel('Time')
    # plt.ylabel('')
    plt.legend()
    plt.show()
#
def change(l):
    for i,e in enumerate(l):
        if e=='':
            l[i+1]='-'+l[i+1]
    for e in l:
        if e=='':
            l.remove(e)
    return l
# 判断每一列数据是否在范围内，不在则置为nan
def range_compare(raw_data):
    col_range = read_xlsx('./data/raw_data/col_range.xlsx')
    for k,v in zip(col_range['col'].values,col_range['range'].values):
        raw=v.split('-')
        if len(raw)>2:
           raw= change(raw)
        res=list(map(lambda x:float(x),raw))
        raw_data[k] = np.where(raw_data[k]<res[0] ,np.nan,raw_data[k])
        raw_data[k] = np.where(raw_data[k]>res[1],np.nan,raw_data[k])
    raw_data.to_csv('./data2/325_range_compare.csv', header=True,index=False)

# 删除有nan值的行，并进行3delta检验
def delta3(raw_data,del_col):
    for c in del_col:
        raw_data=raw_data.drop(c,axis=1)
    # print(raw_data.isna().sum(axis=1))
    raw_data=raw_data.dropna(axis=0, how='any')
    print(raw_data)
    for c in del_col:
        col.remove(c)
    index=del_index(raw_data,col)
    print(raw_data)
    print(index)
    mean_res=[]
    for i,c in enumerate(col):
        if len(index[i])!=0:
            raw_data[c].drop(index[i],axis=0)
        mean_res.append(np.mean(raw_data[c].values))
    print(dict(zip(col,mean_res)))
    pd.Series(dict(zip(col,mean_res))).to_csv('./313mean.csv',header=False)

if __name__ == '__main__':
    col = list(read_csv('./data/raw_data/column.csv'))
    raw_data=read_csv('./data2/325_range_compare.csv')
    # nan_num=raw_data.isna().sum(axis=0)
    # print(nan_num[nan_num>0])
    del_col = ['S-ZORB.AT_5201.PV', 'S-ZORB.PDC_2502.PV', 'S-ZORB.SIS_LT_1001.PV', 'S-ZORB.AI_2903.PV',
               'S-ZORB.FT_1204.TOTAL']
    raw_data=range_compare(raw_data)
    delta3(raw_data, del_col)
# end

# python



