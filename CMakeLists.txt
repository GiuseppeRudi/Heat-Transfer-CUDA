cmake_minimum_required(VERSION 3.18)

project(Heat_Transfer_CUDA LANGUAGES CXX CUDA)

# Standard C++ (per i .cpp)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Standard CUDA (for .cu) – if use recent CUDA toolkit use 20 instead of 17
# if work with very old cuda version try to insert 14
set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)

add_executable(Heat_Transfer_CUDA
    main.cu
    src/core/init.cpp
    src/utils/print.cpp
    src/cuda/global_kernel.cu
    src/core/swapCA.cpp
    src/cuda/run_kernels.cu
    src/cuda/tiled_kernel.cu
    src/cuda/tiledHalo_kernel.cu
)

target_include_directories(Heat_Transfer_CUDA PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

set_target_properties(Heat_Transfer_CUDA PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
)
