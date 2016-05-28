from numpy import *
from scipy.stats import mode
from progressbar import Percentage, Timer, ProgressBar, ETA
import numpy as np
cimport numpy as np
import sys
import time


DTYPE = np.float64
# "ctypedef" assigns a corresponding compile-time type to DTYPE_t. For
# every type in the numpy module there's a corresponding compile-time
# type with a _t-suffix.
ctypedef np.float64_t DTYPE_t


class KnnDtw:
    def __init__(self):
        self.bandwidth = 1

    def set_bandwidth(self, bandwidth):
        """Set the window width
            [0.0, 1.0]: 0% - 100%
        """
        self.bandwidth = bandwidth

    def fit(self, x, l):
        """Fit the model using x as training data and l as class labels
        """

        self.x = x
        self.l = l

    def _distance_points(self, double x, double y):
        """Returns the distance between two points.
        """
        cdef double r
        r = (x - y)**2
        return r

    def _dtw_distance(self,
                      np.ndarray[np.float64_t, ndim=1] timeseries_a,
                      np.ndarray[np.float64_t, ndim=1] timeseries_b):
        """Returns the DTW similarity distance between two 2-D
        timeseries numpy arrays.
        """

        # Create memory (mem) matrix via broadcasting with large int
        # timeseries_b = np.array(timeseries_b)
        cdef int row = len(timeseries_a)
        cdef int column = len(timeseries_b)

        cdef np.ndarray[np.float64_t, ndim=2] mem = sys.maxint * np.ones([row, column], dtype=DTYPE)

        # Initialize the first row and column
        mem[0, 0] = self._distance_points(timeseries_a[0], timeseries_b[0])
        cdef unsigned int i, j
        for i in xrange(1, row):
            mem[i, 0] = self._distance_points(timeseries_a[i], timeseries_b[0]) + mem[i - 1, 0]

        for j in xrange(1, column):
            mem[0, j] = self._distance_points(timeseries_a[0], timeseries_b[j]) + mem[0, j - 1]

        # cdef np.ndarray[numpy.float64_t, ndim=2] mem = mem
        cdef int limit
        limit = max(row, column)
        limit = limit * self.bandwidth
        limit = max(limit, abs(row - column))
        limit = int(limit)

        cdef int N = column
        cdef float choices
        cdef int iRef
        cdef int windows_inferior
        cdef int windows_superior
        # print limit
        # Memory Matrix
        for i in xrange(1, row):
            # print "*****"
            iRef = int(i)
            windows_inferior = max(1, iRef - limit)
            windows_superior = min(N, iRef + limit)
            for j in xrange(windows_inferior, windows_superior):
                # print i, j
                choices = min(mem[i - 1, j - 1], mem[i, j - 1], mem[i - 1, j])
                mem[i, j] = self._distance_points(timeseries_a[i], timeseries_b[j]) + choices

        # Return DTW distance
        return mem[row - 1, column - 1]

    def _dist_matrix(self, x, y):
        """Computes the M x N distance matrix between the training
        dataset and testing dataset (y) using the DTW distance measure
        """

        # Compute the distance matrix

        cdef int x_s = len(x)
        cdef int y_s = len(y)
        cdef np.ndarray[np.float64_t, ndim=2] dm = np.zeros([x_s, y_s], dtype=DTYPE)

        cdef int pbarValue = x_s * y_s
        print self.bandwidth
        widgets = ['', Percentage(), ' | ', Timer(), ' | ', ETA()]
        pbar = ProgressBar(
            widgets=widgets,
            maxval=pbarValue
        ).start()

        start_time = time.time()
        cdef int count = 0
        cdef np.ndarray[np.float64_t, ndim=1] xi
        cdef np.ndarray[np.float64_t, ndim=1] yj
        cdef unsigned int i, j
        for i in xrange(0, x_s):
            for j in xrange(0, y_s):
                xi = np.array(x[i], dtype=DTYPE)
                yj = np.array(y[j], dtype=DTYPE)
                dm[i, j] = self._dtw_distance(xi,
                                              yj)

                count += 1

                pbar.update(count)

        pbar.finish()

        elapsed_time = time.time() - start_time

        return dm, elapsed_time

    def predict(self, y):
        """ Predict the class labels or probability estimates for
        the provided data
        """
        dm, elapsed_time = self._dist_matrix(y, self.x)
        # print dm
        # Identify the k nearest neighbors
        knn_idx = dm.argsort()[:, :1]

        knn_labels = self.l[knn_idx]
        mode_data = mode(knn_labels, axis=1)
        mode_label = mode_data[0]
        # print mode_label
        return mode_label.ravel(), elapsed_time
