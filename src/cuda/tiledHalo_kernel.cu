//
// Created by giu20 on 17/11/2025.
//

#include "../include/cuda/tiledHalo_kernel.cuh"

__global__
void tileHalo_kernel(
    double* temperatureCurrent,
    double* temperatureNext,
    unsigned int cols,
    unsigned int rows)
{
    // rows of the matrix saved in register in each single threads
    unsigned int i = blockIdx.y * blockDim.y + threadIdx.y;

    // cols of the matrix
    unsigned int j = blockIdx.x * blockDim.x + threadIdx.x;

    // check the out of bound
    // if ((i >= nHotTopRows && i< (rows - nHotBottomRows)) && (j >=1) && (j <  (cols -1)) )
    // {
    //     temperatureNext[i * cols + j] = (1.0) / (20.0) * ((4 * (temperatureCurrent[i * cols + (j + 1)] + \
    //                                                        temperatureCurrent[i * cols + (j - 1)] + \
    //                                                        temperatureCurrent[(i -1 ) * cols + j] + \
    //                                                        temperatureCurrent[(i + 1) * cols + j] ) ) + \
    //                                                       temperatureCurrent[(i + 1) * cols + (j+1)] + \
    //                                                       temperatureCurrent[(i + 1) * cols + (j-1)] + \
    //                                                       temperatureCurrent[(i - 1) * cols + (j+1)] + \
    //                                                       temperatureCurrent[(i - 1) * cols + (j-1)]);
    // }

    __syncthreads();
}