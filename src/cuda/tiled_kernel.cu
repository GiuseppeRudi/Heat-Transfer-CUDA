//
// Created by giu20 on 17/11/2025.
//

#include "../include/cuda/tiled_kernel.cuh"


#include "../include/cuda/kernel_config.cuh"

__global__
void tiled_kernel(
    double* temperatureCurrent,
    double* temperatureNext,
    unsigned int cols,
    unsigned int rows,
    unsigned int nHotBottomRows,
    unsigned int nHotTopRows)

    // CONVENTION
    // tx, ty → local thread index
    // bx, by → block index
    // i, j   → global matrix index

{
    // create a tile for each block of threads
    __shared__ double tile[TILE_Y][TILE_X];

    // THREAD INDEX
    // take a block index inside a determinate block
    unsigned int ty = threadIdx.y;
    unsigned int tx = threadIdx.x;

    // GLOBAL INDEX
    // rows of the matrix saved in register in each single threads
    unsigned int i = blockIdx.y * blockDim.y + threadIdx.y;
    // cols of the matrix
    unsigned int j = blockIdx.x * blockDim.x + threadIdx.x;


    // each thread inside a block copy one cell

    // check boundary conditions
    if ((i >= nHotTopRows && i< (rows - nHotBottomRows)) && (j >=1) && (j <  (cols -1)))
    tile[ty][tx] = temperatureCurrent[(i+2) * cols + j];


    __syncthreads();

    double c = tile[ty][tx];

    // Est (E)
    double e = (tx + 1 < TILE_X)
               ? tile[ty][tx + 1]
               : temperatureCurrent[i * cols + (j + 1)];

    // Ovest (W)
    double w = (tx > 0)
               ? tile[ty][tx - 1]
               : temperatureCurrent[i * cols + (j - 1)];

    // Sud (S)
    double s = (ty + 1 < TILE_Y)
               ? tile[ty + 1][tx]
               : temperatureCurrent[(i + 1) * cols + j];

    // Nord (N)
    double n = (ty > 0)
               ? tile[ty - 1][tx]
               : temperatureCurrent[(i - 1) * cols + j];

    // NE
    double ne = (tx + 1 < TILE_X && ty > 0)
                ? tile[ty - 1][tx + 1]
                : temperatureCurrent[(i - 1) * cols + (j + 1)];

    // NW
    double nw = (tx > 0 && ty > 0)
                ? tile[ty - 1][tx - 1]
                : temperatureCurrent[(i - 1) * cols + (j - 1)];

    // SE
    double se = (tx + 1 < TILE_X && ty + 1 < TILE_Y)
                ? tile[ty + 1][tx + 1]
                : temperatureCurrent[(i + 1) * cols + (j + 1)];

    // SW
    double sw = (tx > 0 && ty + 1 < TILE_Y)
                ? tile[ty + 1][tx - 1]
                : temperatureCurrent[(i + 1) * cols + (j - 1)];

    temperatureNext[i * cols + j] =
        (1.0/20.0) * (4*(e + w + n + s) + ne + nw + se + sw);

    __syncthreads();
}