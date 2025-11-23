//
// Created by giu20 on 17/11/2025.
//

#include "../include/cuda/tiledHalo_kernel.cuh"

#include "../include/cuda/kernel_config.cuh"
__global__
void tiledHalo_kernel(
    double* temperatureCurrent,
    double* temperatureNext,
    unsigned int rows,
    unsigned int cols,
    unsigned int nHotBottomRows,
    unsigned int nHotTopRows)
{
    {
    // create a tile for each block of threads
    __shared__ double tile[TILE_Y_HALO][TILE_X_HALO];

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
    tile[ty+1][tx+1] = temperatureCurrent[(i+2) * cols + j];

    if (ty==1)
    {
        if ((i-1 > 0 ))
        {
            tile[ty-1][tx] = temperatureCurrent[(i-1)*cols +j];

        }
        else tile[ty-1][tx] = 0;
    }
    if (ty==(TILE_Y_HALO-1))
    {
        if ((i+1 < rows ))
        {
            tile[ty+1][tx] = temperatureCurrent[(i+1)*cols +1];
        }
        else tile[ty+1][tx] = 0;
    }
    if (tx==1)
    {
        if ((j-1 > 0 ))
        {
             tile[ty][tx-1] = temperatureCurrent[i*cols +(j-1)];
        }
        else tile[ty][tx-1] = 0;
    }
    if (tx==(TILE_X_HALO-1))
    {

        if ((j+1 < cols ))
        {
            tile[ty][tx+1] = temperatureCurrent[i*cols +(j+1)];
        }
        else tile[ty][tx+1] = 0;

    }

    if (tx==1 && ty == 1)
    {

        if ((i-1) > 0 && (j-1)>0)
        {
            tile[ty-1][tx-1] = temperatureCurrent[(i-1)*cols +(j-1)];
        }
        else tile[ty-1][tx-1] = 0;

    }

    if (tx==TILE_X_HALO-1 && ty == TILE_Y_HALO-1)
    {
        if ((i+1) < rows  && (j+1) < cols)
        {
            tile[ty+1 ][tx+1] = temperatureCurrent[(i+1)*cols +(j+1)];
        }
        else  tile[ty+1][tx+1] = 0;

    }
    if (tx==1 && ty == TILE_Y_HALO-1)
    {

        if ((i+1)< rows && (j-1) > 0)
        {
            tile[ty + 1 ][tx-1] = temperatureCurrent[(i+1)*cols +(j-1)];
        }
        else tile[ty + 1 ][tx-1]  = 0;
    }

    if (tx==TILE_X_HALO-1 && ty == 1)
    {
        if ((i+1) < rows  && (j-1) > 0)
        {
            tile[ty -1 ][tx-+1] = temperatureCurrent[(i+1)*cols +(j-1)];
        }
        else tile[ty -1 ][tx-+1]  = 0;
    }


    __syncthreads();

    double c = tile[ty][tx];

    // Est (E)
    double e = tile[ty][tx + 1];
    // Ovest (W)
    double w = tile[ty][tx - 1];
    // Sud (S)
    double s = tile[ty + 1][tx];
    // Nord (N)
    double n = tile[ty - 1][tx];
    // NE
    double ne = tile[ty - 1][tx + 1];
    // NW
    double nw =  tile[ty - 1][tx - 1];
    // SE
    double se = tile[ty + 1][tx + 1];
    // SW
    double sw =  tile[ty + 1][tx - 1];

    temperatureNext[i * cols + j] =
        (1.0/20.0) * (4*(e + w + n + s) + ne + nw + se + sw);

    __syncthreads();
}
}