// vector_add.ispc

export void vector_add(
    uniform const float a[], 
    uniform const float b[], 
    uniform float result[], 
    uniform int count
) {
    // foreach automatically splits iterations across the hardware's SIMD lanes
    foreach (i = 0 ... count) {
        result[i] = a[i] + b[i];
    }
}
