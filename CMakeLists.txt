cmake_minimum_required(VERSION 3.10)
project(Frost LANGUAGES C)

# Set the C standard
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Default to Debug build if not specified
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type" FORCE)
endif()

# Detect and display compiler info
message(STATUS "---------------------------------------------")
message(STATUS "Configuring project: ${PROJECT_NAME}")
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

if (CMAKE_C_COMPILER_ID STREQUAL "Clang")
    message(STATUS "Compiler detected: Clang (${CMAKE_C_COMPILER})")
elseif (CMAKE_C_COMPILER_ID STREQUAL "GNU")
    message(STATUS "Compiler detected: GCC (${CMAKE_C_COMPILER})")
elseif (CMAKE_C_COMPILER_ID STREQUAL "MSVC")
    message(STATUS "Compiler detected: MSVC (${CMAKE_C_COMPILER})")
else()
    message(WARNING "Unknown compiler: ${CMAKE_C_COMPILER_ID} (${CMAKE_C_COMPILER})")
endif()
message(STATUS "---------------------------------------------")

# Define release macro if in Release mode
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

# Enable strict warnings for all compilers
if (MSVC)
    target_compile_options(frost PRIVATE /W4)
else()
    target_compile_options(frost PRIVATE -Wall -Wextra -Wpedantic)
endif()
