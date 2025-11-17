//
// Created by giu20 on 17/11/2025.
//
#pragma once

__global__
void tile_kernel(
    double* temperatureCurrent,
    double* temperatureNext,
    unsigned int cols,
    unsigned int rows);