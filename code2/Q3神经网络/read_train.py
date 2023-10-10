import numpy as np
import torch
import torch.nn.functional as F
import matplotlib.pyplot as plt
def read_train(path,start,end):
    train_data=np.loadtxt(path,delimiter=',')
    X = train_data[:, 2:]
    Y = train_data[:, :2]
    trainX=X[start:end,:]
    trainY=Y[start:end,:]
    testX=np.vstack((X[:start,:],X[end:,:]))
    testY=np.vstack((Y[:start,:],Y[end:,:]))
    return trainX,trainY,testX,testY


trainX,trainY,testX,testY=read_train('./train22.csv',0,216)
trainX = (trainX -np.mean(trainX))/np.std(trainX)
trainY = (trainY-np.mean(trainY))/np.std(trainY)
testY = (testX -np.mean(testX))/np.std(testX)
testY = (testY -np.mean(testY))/np.std(testY)


x = torch.from_numpy(trainX).type(torch.FloatTensor)
y = torch.from_numpy(trainY[:,1].reshape(-1,1)).type(torch.FloatTensor)
x1 = torch.from_numpy(testX).type(torch.FloatTensor)
y1 = torch.from_numpy(testY[:,1].reshape(-1,1)).type(torch.FloatTensor)
print(x.shape,y.shape)

# x,y = Variable(X_train),Variable(y_train)


net = torch.nn.Sequential(
    torch.nn.Linear(22, 5),
    torch.nn.ReLU(),
    torch.nn.Linear(5, 1)
)
optimizer = torch.optim.SGD(net.parameters(), lr=0.001)
loss_func = torch.nn.MSELoss()
losses = []
for t in range(200):
    prediction = net(x)
    loss = sum(sum((prediction-y)**2))/216
    optimizer.zero_grad()
    loss.backward()
    optimizer.step()
    if t % 1 == 0:
        losses.append(loss)


# plt.plot(losses)


print(testY[:,1])
prediction = net(x1)
print(prediction)
print(prediction.shape)
loss = sum(sum((prediction -y1)**2))/109
print(loss)
prediction = prediction.detach().numpy()
plt.plot(prediction)
plt.plot(testY[:,1])
plt.show()
