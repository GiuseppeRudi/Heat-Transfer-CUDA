//
// Created by giu20 on 16/11/2025.
//

#include "../../include/core/swapCA.h"

#include <driver_types.h>

void swapCA(double** temperatureCurrent, double** temperatureNext)
{
    double* tempPtr = *temperatureCurrent;
    *temperatureCurrent = *temperatureNext;
    *temperatureNext = tempPtr;
}

