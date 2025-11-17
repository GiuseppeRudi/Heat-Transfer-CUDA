//
// Created by giu20 on 17/11/2025.
//

#pragma once

#include "cuda_runtime.h"

void runGlobal(double* d_curr ,
    double* d_next ,
    dim3 blockSize ,
    dim3 numBlock,
    unsigned int cols,
    unsigned int rows,
    unsigned int nHotBottomRows,
    unsigned int nHotTopRows);



void runTiled(double* d_curr ,
    double* d_next ,
    dim3 blockSize ,
    dim3 numBlock,
    unsigned int cols,
    unsigned int rows);



void runTiledHalo(double* d_curr ,
    double* d_next ,
    dim3 blockSize ,
    dim3 numBlock,
    unsigned int cols,
    unsigned int rows);