//
// Created by giu20 on 17/11/2025.
//

#include "../include/cuda/run_kernels.cuh"
#include "cuda/global_kernel.cuh"
#include "cuda/tiledHalo_kernel.cuh"
#include "cuda/tiled_kernel.cuh"

void runGlobal(double* d_curr, double* d_next, dim3 grid, dim3 block,
               unsigned int cols, unsigned int rows,
               unsigned int nHotBottomRows, unsigned int nHotTopRows)
{
    global_kernel<<<grid, block>>>(d_curr, d_next, cols, rows,
                                         nHotBottomRows, nHotTopRows);
}


void runTiled(double* d_curr, double* d_next, dim3 grid, dim3 block,
               unsigned int cols, unsigned int rows, unsigned int nHotBottomRows, unsigned int nHotTopRows)
{
    tiled_kernel<<<grid, block>>>(d_curr, d_next, cols, rows, nHotBottomRows, nHotTopRows);
}

void runTiledHalo(double* d_curr, double* d_next, dim3 grid, dim3 block,unsigned int cols, unsigned int rows,    unsigned int nHotBottomRows,unsigned int nHotTopRows)
{
    tiledHalo_kernel<<<grid, block>>>(d_curr, d_next, cols, rows, nHotBottomRows,nHotTopRows);
}
