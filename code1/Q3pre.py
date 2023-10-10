import numpy as np
import pandas as pd
pr_mat=pd.read_csv('data3/pr.csv',index_col=0)
index=[]
for i,r in pr_mat.iterrows():
    if r.values[0]>0.05 and r.values[1]>0.05:
        pr_mat=pr_mat.drop(i)
        index.append(i)
print(index)
print(len(index))
pr_mat.to_csv('./dropData.csv')
