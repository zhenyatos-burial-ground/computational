import numpy as np
import scipy.optimize as opt
from tolsolvty import tolsolvty

A = np.loadtxt("data/A.txt")
inf_b = np.loadtxt("data/inf_b.txt", ndmin=2)
sup_b = np.loadtxt("data/sup_b.txt", ndmin=2)
[tolmax, argmax, envs, ccode] = tolsolvty(A, A, inf_b, sup_b)

print("max Tol = ", tolmax)