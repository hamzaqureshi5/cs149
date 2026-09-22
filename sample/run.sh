# 1. Compile the ISPC file to an object file and generate the header
ispc vector_add.ispc -o vector_add.o -h vector_add_ispc.h --target=avx2-i32x8

# 2. Compile the C++ program and link it with the ISPC object file
g++ main.cpp vector_add.o -o vector_add_app

# 3. Run the binary
./vector_add_app
