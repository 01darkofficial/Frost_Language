@echo off
REM Batch file to build and run the project with debug or release configuration

REM Define project paths
set BUILD_DIR=build
set EXECUTABLE=frost
set LOG_FOLDER=logs
set LOG_FILE=%cd%\%LOG_FOLDER%\build_log.txt

:CHOOSE_MODE
REM Prompt the user to choose a build mode (Debug or Release)
set /p BUILD_MODE="Enter build mode (Debug/Release) [Default: Debug]: "

if /i "%BUILD_MODE%"=="" (
    set BUILD_MODE=Debug
) else if /i "%BUILD_MODE%" neq "Debug" if /i "%BUILD_MODE%" neq "Release" (
    echo Invalid build mode. Please enter Debug or Release.
    goto CHOOSE_MODE
)

REM Step 1: Create build directory if it doesn't exist
if not exist %BUILD_DIR% (
    mkdir %BUILD_DIR%
)

REM Step 1.5: Create logs directory if it doesn't exist
if not exist %LOG_FOLDER% (
    mkdir %LOG_FOLDER%
)

REM Step 2: Change to the build directory
cd %BUILD_DIR%

REM Step 3: Run CMake to configure the project with appropriate flags
echo Configuring the project with CMake in %BUILD_MODE% mode...
if /i "%BUILD_MODE%"=="Debug" (
    cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_VERBOSE_MAKEFILE=ON .. > "%LOG_FILE%" 2>&1
) else (
    cmake -DCMAKE_BUILD_TYPE=Release .. > "%LOG_FILE%" 2>&1
)

if %errorlevel% neq 0 (
    echo Failed to configure the project. Check %LOG_FILE% for details.
    exit /b %errorlevel%
)

REM Step 4: Build the project
echo Building the project in %BUILD_MODE% mode...
cmake --build . --config %BUILD_MODE% --verbose >> "%LOG_FILE%" 2>&1

if %errorlevel% neq 0 (
    echo Failed to build the project. Check %LOG_FILE% for details.
    exit /b %errorlevel%
)

REM Step 5: Run the executable
echo Running the application...
if exist %EXECUTABLE%.exe (
    .\%EXECUTABLE%.exe
) else (
    echo Executable not found: %EXECUTABLE%.exe
    exit /b 1
)

REM Step 6: Return to the root