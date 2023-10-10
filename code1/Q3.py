# 问题3 PLS预测
from sklearn.cross_decomposition import PLSRegression
import numpy as np
import pandas as pd
import statsmodels.api as sm
from pylab import *
import matplotlib.pyplot as plt
from scipy.interpolate import UnivariateSpline
from scipy import interpolate
mpl.rcParams['font.sans-serif'] = ['SimHei']
q=1

l=[]
train_data=np.loadtxt('./data3/train22.csv',delimiter=',')
X=train_data[:,2:]
Y=train_data[:,:2]
testX=X[:228,:]
testY=Y[:228,:]
trainX=X[228:,:]
trainY=Y[228:,:]

pls2=PLSRegression(copy=True, max_iter=500, n_components=8, scale=True,tol=1e-06)
pls2.fit(testX, testY)


Y_pred = pls2.predict(trainX)
err2=np.abs(Y_pred-trainY)/trainY
err=err2[:,0]
nn_err=np.loadtxt('./NNerr.csv',delimiter=',')
nn_err=np.abs(nn_err)
print(np.mean(err))
print(np.max(err))
print(np.min(err))
print(np.mean(nn_err))
print(np.max(nn_err))
print(np.min(nn_err))
plt.plot(Y_pred[:,0],label='PLS预测辛烷值')
plt.plot(trainY[:,0],label='实际辛烷值')

ecdf = sm.distributions.ECDF(err)
x = np.linspace(min(err), max(err))
y = ecdf(x)
func=UnivariateSpline(x, y)
xnew = np.arange(min(err), max(err), 0.000001)
ynew = func(xnew)**q
plt.plot(xnew,ynew,'b-',label='PLS')

ecdf = sm.distributions.ECDF(nn_err)
x = np.linspace(min(nn_err), max(nn_err))
y = ecdf(x)
func=UnivariateSpline(x, y)
xnew = np.arange(min(err), max(err), 0.000001)
ynew = func(xnew)**q
plt.plot(xnew,ynew,'r-',label='BP')

plt.xlabel('相对误差')
plt.ylabel('累积概率')
plt.title('CDF')
plt.legend()
plt.savefig('./q32.jpg', dpi=300)
# 问题5 操作变量可视化
