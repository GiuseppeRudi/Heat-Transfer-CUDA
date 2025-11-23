//
// Created by giu20 on 15/11/2025.
//

#include "../../include/core/init.h"

void inizializeMatrix(double* temperatureMatrix,
                      unsigned int rows,
                      unsigned int cols,
                      unsigned int nHotBottomRows,
                      unsigned int nHotUpRows,
                      int temperature)
{
    for (unsigned int i = 0; i < nHotUpRows; i++) {
        for (unsigned int j = 0; j < cols; j++) {
            temperatureMatrix[i * cols + j] = temperature;
        }
    }

    for (unsigned int i = nHotUpRows; i < (rows - nHotBottomRows); i++) {
        for (unsigned int j = 0; j < cols; j++) {
            temperatureMatrix[i * cols + j] = 0;
        }
    }

    for (unsigned int i = rows - nHotUpRows; i < rows; i++) {
        for (unsigned int j = 0; j < cols; j++) {
            temperatureMatrix[i * cols + j] = 20;
        }
    }

}
