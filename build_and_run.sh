#!/bin/bash
# ========================================
# 🧊 Frost Project Build Script (Colorful)
# ========================================

# ANSI color codes
RESET="\033[0m"
BOLD="\033[1m"
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
MAGENTA="\033[0;35m"

# Define project paths
BUILD_DIR="build"
EXECUTABLE="frost"
LOG_FOLDER="logs"
LOG_FILE="$(pwd)/${LOG_FOLDER}/build_log.txt"

# Step 0: Ask for build mode (default = Debug)
echo -e "${CYAN}⚙️  Enter build mode (Debug/Release) [Default: Debug]:${RESET} "
read -r BUILD_MODE
BUILD_MODE=${BUILD_MODE:-Debug}

# Validate build mode
if [[ "$BUILD_MODE" != "Debug" && "$BUILD_MODE" != "Release" ]]; then
    echo -e "${RED}❌ Invalid build mode. Please enter Debug or Release.${RESET}"
    exit 1
fi

# Step 1: Optionally clean the build directory
echo -ne "${YELLOW}🧹 Do you want to clean the build directory before building? (y/N): ${RESET}"
read -r CLEAN_BUILD
if [[ "$CLEAN_BUILD" =~ ^[Yy]$ ]]; then
    echo -e "${MAGENTA}🧽 Cleaning build directory...${RESET}"
    rm -rf "$BUILD_DIR"
fi

# Step 2: Create necessary directories
mkdir -p "$BUILD_DIR" "$LOG_FOLDER"

# Step 3: Detect compiler
if command -v clang >/dev/null 2>&1; then
    COMPILER="clang"
    echo -e "${GREEN}🧠 Detected compiler: ${BOLD}Clang${RESET} ${YELLOW}($(clang --version | head -n 1))${RESET}"
elif command -v gcc >/dev/null 2>&1; then
    COMPILER="gcc"
    echo -e "${GREEN}🧠 Detected compiler: ${BOLD}GCC${RESET} ${YELLOW}($(gcc --version | head -n 1))${RESET}"
else
    echo -e "${RED}❌ No C compiler found! Please install Clang or GCC.${RESET}"
    exit 1
fi

# Step 4: Run CMake configuration
echo -e "${BLUE}⚙️  Configuring project with CMake (${BOLD}${BUILD_MODE}${RESET}${BLUE} mode)...${RESET}"
cd "$BUILD_DIR" || exit 1

cmake -DCMAKE_C_COMPILER="$COMPILER" -DCMAKE_BUILD_TYPE="$BUILD_MODE" -DCMAKE_VERBOSE_MAKEFILE=ON .. > "$LOG_FILE" 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to configure the project. Check ${BOLD}$LOG_FILE${RESET}${RED} for details.${RESET}"
    exit 1
fi

# Step 5: Build the project
echo -e "${CYAN}🔨 Building project (${BOLD}${BUILD_MODE}${RESET}${CYAN})...${RESET}"
cmake --build . --config "$BUILD_MODE" --verbose >> "$LOG_FILE" 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed. Check ${BOLD}$LOG_FILE${RESET}${RED} for details.${RESET}"
    exit 1
fi

echo -e "${GREEN}✅ Build successful!${RESET}"

# Step 6: Run the executable
echo -e "${MAGENTA}▶️  Running application...${RESET}"
if [ -f "./$EXECUTABLE" ]; then
    echo -e "${YELLOW}---------------------------------------${RESET}"
    "./$EXECUTABLE"
    echo -e "${YELLOW}---------------------------------------${RESET}"
else
    echo -e "${RED}❌ Executable not found: ${BOLD}$EXECUTABLE${RESET}"
    exit 1
fi

# Step 7: Return to project root
cd ..

echo -e "${GREEN}🎉 ${BOLD}Build and run complete.${RESET}"
