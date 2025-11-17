//
// Created by giu20 on 15/11/2025.
//

#include <functional>

#include "cuda_runtime.h"
#include "malloc.h"
#include <iostream>
#include <stdio.h>

#include "include/cuda/global_kernel.cuh"
#include "print.h"
#include "include/core/swapCA.h"
#include "include/core/init.h"
#include "include/cuda/run_kernels.cuh"
#include "include/core/kernelMode.h"

int main()
{
    KernelMode mode = KernelMode::GLOBAL;   // o TILED o TILED_HALO



    // unsigned => only 0 or positive values
    const unsigned int nSteps = 10000;
    int unsigned currentStep = 0;

    const unsigned int rows = 200;
    const unsigned int cols = 200;

    const unsigned int nHotTopRows = 2;
    const unsigned int nHotBottomRows = 2;

    const int temperature = 20;

    /*
        Difference to float and double is the precision :
        - float use about 7 significant digits
        - double use about 16 significant digits
        In GPU, of course, the float point use half memory and are much faster than double
        But in scientific context, when we would much precision, use double floating-point type
    */

    double* temperatureCurrent = (double*)malloc(rows * cols * sizeof(double));
    if (temperatureCurrent == NULL) {
        printf("Memory allocation failed \n");
        return 1;
    }

    double* temperatureNext = (double*)malloc(rows * cols * sizeof(double));
    if (temperatureNext == NULL) {
        printf("Memory allocation failed \n");
        return 1;
    }

    unsigned int fieldWidth{ 5 };
    std::string outfilePrefix{ "temperature" };
    std::string outfileExtension{ ".dat" };

    inizializeMatrix(temperatureCurrent, rows, cols, nHotBottomRows, nHotTopRows, temperature);
    inizializeMatrix(temperatureNext, rows, cols, nHotBottomRows, nHotTopRows, temperature);

    std::cout << "Saving initial configuration... " << std::endl;
    saveTemperature(outfilePrefix, outfileExtension, currentStep, temperatureCurrent, rows, cols, fieldWidth);
    std::cout << "Done" << std::endl;

    // create a device pointer memory
    double* d_temperatureCurrent;
    double* d_temperatureNext;


    unsigned int size = rows * cols * sizeof(double);

    // allocate device memory
    cudaMalloc((void**)&d_temperatureCurrent,size);
    cudaMalloc((void**)&d_temperatureNext, size);

    /*
     Decide to create a grid for threads that are much smaller than the temperature matrix,
     because we don't want to compute the first and last two rows.
     These four rows in total must be fixed.
    */

    dim3 blockSize(16, 16);
    dim3 numBlocks(((cols-2) + blockSize.x - 1) / blockSize.x,((rows-4) + blockSize.y - 1) / blockSize.y);

    for (unsigned int t=1 ; t < nSteps; t++)
    {
        // transfer the due matrix values from the host memory to device memory with the previous pointers
        cudaMemcpy(d_temperatureCurrent, temperatureCurrent,size, cudaMemcpyHostToDevice);
        cudaMemcpy(d_temperatureNext, temperatureNext , size, cudaMemcpyHostToDevice);


        switch(mode)
        {
        case KernelMode::GLOBAL:
            runGlobal(d_temperatureCurrent, d_temperatureNext, numBlocks,
                      blockSize, cols, rows, nHotBottomRows, nHotTopRows);
            break;

        case KernelMode::TILED:
            runTiled(d_temperatureCurrent, d_temperatureNext, numBlocks,
                     blockSize, cols, rows);
            break;

        case KernelMode::TILED_HALO:
            runTiledHalo(d_temperatureCurrent, d_temperatureNext, numBlocks,
                         blockSize, cols, rows);
            break;
        }

        // use the cuda kernel to perform the calculations
        global_kernel<<<numBlocks,blockSize>>>(d_temperatureCurrent,d_temperatureNext, cols, rows , nHotBottomRows, nHotTopRows);

        cudaMemcpy(temperatureCurrent, d_temperatureCurrent,size, cudaMemcpyDeviceToHost);
        cudaMemcpy(temperatureNext, d_temperatureNext, size, cudaMemcpyDeviceToHost);

        // when all threads finished it operations , perform the swap in Host side
        swapCA(&temperatureCurrent , &temperatureNext);

    }

    std::cout << "Saving final configuration... " << std::endl;
    saveTemperature(outfilePrefix, outfileExtension, nSteps, temperatureCurrent, rows, cols, fieldWidth);
    std::cout << "Done" << std::endl;

    //// Add vectors in parallel.
    //cudaError_t cudaStatus = addWithCuda(c, a, b, arraySize);
    //if (cudaStatus != cudaSuccess) {
    //    fprintf(stderr, "addWithCuda failed!");
    //    return 1;
    //}

    //printf("{1,2,3,4,5} + {10,20,30,40,50} = {%d,%d,%d,%d,%d}\n",
    //    c[0], c[1], c[2], c[3], c[4]);

    //// cudaDeviceReset must be called before exiting in order for profiling and
    //// tracing tools such as Nsight and Visual Profiler to show complete traces.
    //cudaStatus = cudaDeviceReset();
    //if (cudaStatus != cudaSuccess) {
    //    fprintf(stderr, "cudaDeviceReset failed!");
    //    return 1;
    //}

    return 0;
}
