//
// Created by giu20 on 15/11/2025.
//
#pragma once

#include <fstream>
#include <string>


void streamTemperature(std::ostream& file,
                        unsigned int step,
                        double* gridTemperature,
                        unsigned int nRows,
                        unsigned int nCols,
                        unsigned int fieldW);

void printTemperature(unsigned int step,
                    double* gridTemperature,
                    unsigned int nRows,
                    unsigned int nCols,
                    unsigned int fieldW);

void saveTemperature(std::string file_base_name,
                    std::string file_extension,
                    unsigned int step,
                    double* gridTemperature,
                    unsigned int nRows,
                    unsigned int nCols,
                    unsigned int fieldW);
