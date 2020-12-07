import numpy as np
import scipy.optimize as opt
from tolsolvty import tolsolvty

A = np.loadtxt("data/A.txt")
inf_b = np.loadtxt("data/inf_b.txt", ndmin=2)
sup_b = np.loadtxt("data/sup_b.txt", ndmin=2)
[tolmax, argmax, envs, ccode] = tolsolvty(A, A, inf_b, sup_b)

print("max Tol = ", tolmax)

signs = opt.Bounds([-np.inf, -np.inf, -np.inf, 0, 0, 0],
                   [+np.inf, +np.inf, +np.inf, +np.inf, +np.inf, +np.inf])

diag_rad_b = np.diag(np.squeeze(np.asarray(0.5 * (sup_b - inf_b))))
C = np.block([[-A, -diag_rad_b],
              [A, -diag_rad_b]])

mid_b = 0.5 * (inf_b + sup_b)
r = np.concatenate([-mid_b, mid_b])
r = np.squeeze(np.asarray(r))

pos_sign = (0, None)
no_sign = (None, None)
methods_list = ['interior-point', 'simplex']
np.set_printoptions(precision=3, suppress=True)
for method in methods_list:
    print("Method: ", method)
    res = opt.linprog([0, 0, 0, 1, 1, 1],
                      A_ub=C,
                      b_ub=r,
                      bounds=[no_sign, no_sign, no_sign,
                              pos_sign, pos_sign, pos_sign],
                      method=method)
    print(res.x)
