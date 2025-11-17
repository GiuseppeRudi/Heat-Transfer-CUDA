cmake_minimum_required(VERSION 4.0)
project(Heat_Transfer_CUDA LANGUAGES CXX CUDA)

set(CMAKE_CUDA_STANDARD 20)

add_executable(Heat_Transfer_CUDA
        main.cu
        src/core/init.cpp
        include/init.h
        src/utils/print.cpp
        include/print.h
        src/cuda/globalMemoryVersion/globalMemory_kernel.cu
        include/cuda/globalMemory_kernel.cuh
        src/core/swapCA.cpp
        include/swapCA.h)


target_include_directories(Heat_Transfer_CUDA PRIVATE
        include
        ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}
)

set_target_properties(Heat_Transfer_CUDA PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)
