-- Defines types for the modules
-- Author: Guillaume Fournier-Mayer
-- Date: 09.05.2021

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package types is

  -- The value to be added to the current program counter
  constant PC_ADD : integer := 4;

  -- The operation that the ALU should perform
  type T_ALU_MODE is (
    ALU_UNUSED,
    ALU_ADD,
    ALU_ADD_EVEN,
    ALU_SUB,
    ALU_SLL,
    ALU_SLT,
    ALU_SLTU,
    ALU_XOR,
    ALU_SRL,
    ALU_SRA,
    ALU_OR,
    ALU_AND
  );

  -- Specifies how the 32 bits are to be filled up
  type T_SEXT_MEM_MODE is (
    SEXT_MEM_S_8,
    SEXT_MEM_S_16,
    SEXT_MEM_U_8,
    SEXT_MEM_U_16,
    SEXT_MEM_32
  );

  -- The datawidth of the data that should be stored in memory
  type T_STORE_MODE is (
    STORE_B,
    STORE_H,
    STORE_W
  );

  -- The mode of the ALU multiplexer
  -- Decides which value is pushed into the ALU
  type T_MUX_ALU is (
    MUX_ALU_RS1_RS2,
    MUX_ALU_RS1_IMM,
    MUX_ALU_PC_IMM,
    MUX_ALU_PC_RS2
  );

  -- The mode of the register multiplexer
  -- Decides which value is pushed into the destination register (rd)
  type T_MUX_REG is (
    MUX_REG_ZERO,
    MUX_REG_ALU,
    MUX_REG_MEM,
    MUX_REG_PC
  );

  -- The source from which the program counter is added or set
  type T_PC_MODE is (
    PC_SRC_ADD,
    PC_SRC_COMP_ALU,
    PC_SRC_ALU
  );

  -- The operation that the comparator should perform
  type T_COMP_MODE is (
    COMP_EQUAL,
    COMP_NOT_EQUAL,
    COMP_LESS_THEN,
    COMP_GREATER_EQUAL,
    COMP_LESS_THEN_U,
    COMP_GREATER_EQUAL_U
  );

  -- Specifies whether the access to the ram should be read or write
  type T_MEM_DIR is (
    MEM_DIR_READ,
    MEM_DIR_WRITE
  );
end package;