import numpy as np

data = np.loadtxt("YearPredictionMSD.txt", delimiter=',')
b  = data[:,0]
A = data[:,1:data.shape[1]+1]
new_data = np.column_stack((A,b))
np.savetxt("YearPredictionsMSD.csv", new_data)
