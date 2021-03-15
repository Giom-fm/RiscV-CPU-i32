/*
  A module which is responsible for selecting the right operand for the ALU.
  Author: Guillaume Fournier-Mayer (tinf101922)
*/

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.types.all;

entity mux_alu_right is
  port (
    -- The required signals
    i_mode : in T_MUX_ALU;
    -- Register RS2
    i_rs2 : in std_logic_vector(31 downto 0);
    -- Immediate from decode
    i_imm : in std_logic_vector(31 downto 0);
    -- The signal which is used as left ALU operand 
    o_data : out std_logic_vector(31 downto 0)
  );

end mux_alu_right;

architecture a_mux_alu_right of mux_alu_right is

begin
  process (i_mode, i_rs2, i_imm) begin
    case i_mode is
        -- RS1 and RS2 are required -> RS2 is tunneled through
      when MUX_ALU_RS1_RS2 => o_data <= i_rs2;
        -- Programm counter and RS2 are required -> RS2 is tunneled through
      when MUX_ALU_PC_RS2  => o_data  <= i_rs2;
        -- RS1 and immediate are required -> Immediate is tunneled through
      when MUX_ALU_RS1_IMM => o_data <= i_imm;
        -- Programm counter and immediate are required -> Immediate is tunneled through
      when MUX_ALU_PC_IMM  => o_data  <= i_imm;
    end case;
  end process;
end architecture;