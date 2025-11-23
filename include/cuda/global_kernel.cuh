//
// Created by giu20 on 15/11/2025.
//

#pragma once

__global__
void global_kernel(
    double* temperatureCurrent,
    double* temperatureNext,
    unsigned int cols,
    unsigned int rows,
    unsigned int nHotBottomRows,
    unsigned int nHotTopRows);