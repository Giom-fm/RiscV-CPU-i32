-- A module which is responsible for selecting the left operand for the ALU.
-- Author: Guillaume Fournier-Mayer (tinf101922)
-- Date: 09.05.2021

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.types.all;

entity mux_alu_left is
  port (
    -- The required signals
    i_mode : in T_MUX_ALU;
    -- Register rs1
    i_rs1 : in std_logic_vector(31 downto 0);
    -- Programm counter
    i_pc : in std_logic_vector(31 downto 0);
    -- The signal which is used as right ALU operand
    o_data : out std_logic_vector(31 downto 0)
  );

end mux_alu_left;

architecture a_mux_alu_left of mux_alu_left is

begin
  process (i_mode, i_rs1, i_pc) begin
    case i_mode is
        -- RS1 and RS2 are required -> rs1 is tunneled through
      when MUX_ALU_RS1_RS2 => o_data <= i_rs1;
        -- RS1 and immediate are required -> rs1 is tunneled through
      when MUX_ALU_RS1_IMM => o_data <= i_rs1;
        -- Programm counter and Immediate are required -> PC is tunneled through
      when MUX_ALU_PC_IMM => o_data <= i_pc;
        -- Programm counter and RS2 are required -> PC is tunneled through
      when MUX_ALU_PC_RS2 => o_data <= i_pc;
    end case;
  end process;
end architecture;