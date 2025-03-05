cmake_minimum_required(VERSION 3.10)
project(Frost LANGUAGES C)

# Set the C++ standard
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED True)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
    add_compile_definitions(RELEASE_BUILD)
endif()


# Add source files
add_executable(frost
    src/main.c
    src/f_chunk.h
    src/f_chunk.c
    src/f_common.h
    src/f_memory.h
    src/f_memory.c
    src/f_debug.h
    src/f_debug.c
    src/f_value.h
    src/f_value.c
    src/f_vm.h
    src/f_vm.c
    src/f_compiler.h
    src/f_compiler.c
    src/f_scanner.h
    src/f_scanner.c
    src/f_object.h
    src/f_object.c
    src/f_table.h
    src/f_table.c
)