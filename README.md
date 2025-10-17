# Frost Language

A small, bytecode-interpreted programming language. Inspired by Lox and other minimalist scripting languages.

## Features
- Bytecode VM written in C
- REPL and file execution support
- Custom memory management
- Automated test runner

## Building
```sh
# Using CMake
mkdir build
cd build
cmake ..
cmake --build .
```

## Running
```sh
# Start REPL
./frost

# Run script
./frost myscript.ft
```

## Testing
```sh
python tests/test.py
```

## Project Structure
- `src/`: Core source code (VM, compiler, memory, etc.)
- `tests/`: Python-based automated tests
- `build_and_run.bat`: Windows build helper

## Contributing
PRs welcome! Please run tests before submitting.

## License
MIT
