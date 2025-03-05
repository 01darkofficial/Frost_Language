#pragma once

#include "f_chunk.h"
#include "f_value.h"

void disassembleChunk(Chunk *chunk, const char *name);

int disassembleInstruction(Chunk *chunk, int offset);