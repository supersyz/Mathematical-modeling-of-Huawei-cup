#-*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import UnivariateSpline
from scipy import interpolate
from matplotlib.font_manager import FontProperties
from pylab import *
mpl.rcParams['font.sans-serif'] = ['SimHei']

alpha=np.loadtxt('alpha.csv',delimiter=',')
b=np.loadtxt('b.csv',delimiter=',')
a_xin=alpha[0,:]
a_s=alpha[1,:]
b_xin=b[0]
b_s=b[1]

info=np.loadtxt('./133data2.csv',delimiter=',')
end=info[0,:]
delta=info[1,:]
below=info[2,:]
upper=info[3,:]
start=info[4,:]

name=['氢油比',	'反应过滤器压差'	,'反应器上部温度'	,'反应器顶部压力',
    '反吹氢气温度',	'稳定塔顶压力','稳定塔下部温度','稳定塔液位',
     '干气出装置温度','精制汽油出装置温度','精制汽油出装置流量',
     '蒸汽进装置压力',	'蒸汽进装置流量',''
    ]
num=list(range(8,22))
num_name=dict(zip(num,name))


# 8-21
xin_list = []
s_list = []
st=[21,17,13,10,12,15,22,14,18,11,20,9,19,16]
st=np.array(st)-1
for step_num in st:
    step=end-start
    step=list(map(lambda x:1 if x>0 else x,step))
    step=list(map(lambda x:-1 if x<0 else x,step))
    temp=step[step_num]
    step=list(map(lambda x: 0,step))
    step[step_num]=temp
    step=np.array(step)/10

    # xin=a_xin.dot(end)+b_xin
    # s=a_s.dot(end)+b_s
    # print(s)

    while np.sum(np.abs(step))!=0:
        direct=np.multiply(step,delta)
        for i,s in enumerate(step):
            if s<0 and start[i]<=end[i]:
                step[i]=0
            if s>0 and start[i]>=end[i]:
                step[i]=0
        xin=a_xin.dot(start)+b_xin
        s=a_s.dot(start)+b_s

        xin_list.append(xin)
        s_list.append(s)
        start+=direct
func=UnivariateSpline(range(len(xin_list)), xin_list)
xnew = np.arange(0, len(xin_list)-1, 0.1)
ynew = func(xnew)
plt.plot(xnew,ynew,'*b-',label='RON')
# plt.plot(range(len(xin_list)), xin_list,'*b-',label=num_name[step_num])
# plt.xlim(0,300)
plt.xlabel('迭代次数')
plt.ylabel('辛烷值(RON)')
# func=UnivariateSpline(range(len(s_list)), s_list)
# xnew = np.arange(0, len(s_list)-1, 10)
# ynew = func(xnew)
# plt.plot(xnew,ynew,'*y-',label='硫含量')
# plt.xlim(0,300)
# plt.xlabel('迭代次数')
# plt.ylabel('硫含量(ug/g)')
plt.legend()
plt.show()
print(start)
print(end)



