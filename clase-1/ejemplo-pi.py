import numpy as np
import numba


def estimate_pi(N):
    n = 0
    for i in range(N):
        x = 2*np.random.random() - 1
        y = 2*np.random.random() - 1
        if x**2 + y**2 <= 1:
           n = n + 1
    return 4*n/N


def estimate_pi_numpy(N):
    xy = 2*np.random.random((N, 2)) - 1
    n = (np.sqrt((xy**2).sum(axis = 1)) <= 1).sum()
    return 4*n/N


@numba.jit()
def estimate_pi_numba(N):
    n = 0
    for i in range(N):
        x = 2*np.random.random() - 1
        y = 2*np.random.random() - 1
        if x**2 + y**2 <= 1:
           n = n + 1
    return 4*n/N
