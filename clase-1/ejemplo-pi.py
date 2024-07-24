import numpy as np
import numba


def estimate_pi(n):
    n_circle = 0
    for i in range(n):
        x = 2*np.random.random() - 1
        y = 2*np.random.random() - 1
        if np.sqrt(x**2 + y**2) <= 1:
           n_circle += 1
    return 4*n_circle/n


def estimate_pi_numpy(n):
    xy = 2*np.random.random((n, 2)) - 1
    n_circle = (np.sqrt((xy**2).sum(axis = 1)) <= 1).sum()
    return 4*n_circle/n


@numba.jit()
def estimate_pi_numba(n):
    n_circle = 0
    for i in range(n):
        x = 2*np.random.random() - 1
        y = 2*np.random.random() - 1
        if np.sqrt(x**2 + y**2) <= 1:
           n_circle += 1
    return 4*n_circle/n