//
// Created by giu20 on 19/11/2025.
//
#pragma once

// Dimensioni tile standard
constexpr int TILE_X = 16;
constexpr int TILE_Y = 16;

// Per il kernel con ghost/halo
constexpr int HALO = 1;

// Dimensioni tile con halo
constexpr int TILE_X_HALO = TILE_X + 2*HALO;
constexpr int TILE_Y_HALO = TILE_Y + 2*HALO;
