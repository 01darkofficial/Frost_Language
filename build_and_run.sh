#!/bin/bash
# Shell script to build and run the project with Debug or Release configuration

# Define project paths
BUILD_DIR="build"
EXECUTABLE="frost"
LOG_FOLDER="logs"
LOG_FILE="$(pwd)/${LOG_FOLDER}/build_log.txt"

# Prompt the user for build mode (default: Debug)
read -p "Enter build mode (Debug/Release) [Default: Debug]: " BUILD_MODE
BUILD_MODE=${BUILD_MODE:-Debug}

# Validate build mode
if [[ "$BUILD_MODE" != "Debug" && "$BUILD_MODE" != "Release" ]]; then
    echo "Invalid build mode. Please enter Debug or Release."
    exit 1
fi

# Step 1: Create build directory if it doesn't exist
mkdir -p "$BUILD_DIR"

# Step 1.5: Create logs directory if it doesn't exist
mkdir -p "$LOG_FOLDER"

# Step 2: Move into build directory
cd "$BUILD_DIR" || exit 1

# Step 3: Run CMake to configure
echo "Configuring the project with CMake in $BUILD_MODE mode..."
if [ "$BUILD_MODE" = "Debug" ]; then
    cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_VERBOSE_MAKEFILE=ON .. > "$LOG_FILE" 2>&1
else
    cmake -DCMAKE_BUILD_TYPE=Release .. > "$LOG_FILE" 2>&1
fi

if [ $? -ne 0 ]; then
    echo "❌ Failed to configure the project. Check $LOG_FILE for details."
    exit 1
fi

# Step 4: Build
echo "Building the project in $BUILD_MODE mode..."
cmake --build . --config "$BUILD_MODE" --verbose >> "$LOG_FILE" 2>&1

if [ $? -ne 0 ]; then
    echo "❌ Failed to build the project. Check $LOG_FILE for details."
    exit 1
fi

# Step 5: Run the executable
echo "Running the application..."
if [ -f "./$EXECUTABLE" ]; then
    echo "---------------------------------------"
    "./$EXECUTABLE"
    echo "---------------------------------------"
else
    echo "❌ Executable not found: $EXECUTABLE"
    exit 1
fi

# Step 6: Return to project root
cd ..

echo "✅ Build and run complete."
