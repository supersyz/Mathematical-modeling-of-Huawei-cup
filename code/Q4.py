import numpy as np
from scipy.optimize import linprog

def standardization(x):
    mu = np.mean(x, axis=0)
    sigma = np.std(x, axis=0)
    return (x - mu) / sigma

train_data=np.loadtxt('./data3/train22.csv',delimiter=',')
X=train_data[:,2:]
Y=train_data[:,:2]

X=standardization(X)
print(X.shape)
alpha=np.loadtxt('./alpha.csv',delimiter=',')
b=np.loadtxt('./b.csv',delimiter=',')

mu = np.mean(X, axis=0)
sigma = np.std(X, axis=0)

x=X[132,:]
x=(x-mu)/sigma
y=Y[132,0]
alpha1=alpha[:,0]
alpha2=alpha[:,1]

b1=b[0]
b2=b[1]
# prd_y=np.dot(x,alpha1)+np.array(b1)
# print(alpha1.shape)
# print(y.shape)

c = alpha1
a_ub = alpha2
b_ub = np.array([5-b2])
a_ed = np.array([])
b_ed = np.array([])
res=linprog(c, a_ub, b_ub, a_ed, b_ed, bounds=([None, None], [-3, None],[None, None],[None, None],
                                            [None, None], [-3, None],[None, None],[None, None],
                                            [-3, None],[None, None],[None, None],[None, None],
                                           [-3, None], [None, None], [None, None], [None, None],
                                           [-3, None], [None, None], [None, None], [None, None],
                                           [-3, None], [None, None]
                                           ))
print(res)


