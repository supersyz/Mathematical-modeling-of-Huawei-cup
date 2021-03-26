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

info=np.loadtxt('./data5/133data.csv',delimiter=',')
end=info[0,:]
delta=info[1,:]
below=info[2,:]
upper=info[3,:]
start=info[4,:]
step=end-start
step=list(map(lambda x:1 if x>0 else x,step))
step=list(map(lambda x:-1 if x<0 else x,step))
step=np.array(step)/10

exin=a_xin.dot(end)+b_xin
s=a_s.dot(end)+b_s
print(s)
xin_list=[]
s_list=[]
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
print(exin)
func=UnivariateSpline(range(len(xin_list)), xin_list)
xnew = np.arange(0, len(xin_list)-1, 10)
ynew = func(xnew)
plt.plot(xnew,ynew,'*b-',label='RON')
plt.xlim(0,300)
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
plt.savefig('./RON.jpg', dpi=300)
# print(start)
# print(end)



