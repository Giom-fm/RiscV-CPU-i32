-- A module representing a multiplexer connected in front of the registers
-- and determining the input data of the destination register (rd).
-- Author: Guillaume Fournier-Mayer
-- Date: 09.05.2021

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.types.all;

entity mux_register is
  port (
    -- The mode that determines which data should be written to the register (rd)
    i_mode : in T_MUX_REG;
    -- Data from memory
    i_mem : in std_logic_vector(31 downto 0);
    -- The program counter +4 (pc_next)
    i_pc : in std_logic_vector(31 downto 0);
    -- The result from ALU
    i_alu : in std_logic_vector(31 downto 0);
    -- The data to be written to the register (rd)
    o_data : out std_logic_vector(31 downto 0)
  );

end mux_register;

architecture a_mux_register of mux_register is

begin
  process (i_mode, i_alu, i_mem, i_pc) begin
    case i_mode is
        -- Write ALU to register
      when MUX_REG_ALU => o_data <= i_alu;
        -- Write memory content to register
      when MUX_REG_MEM => o_data <= i_mem;
        -- Write programm counter +4 to register
      when MUX_REG_PC => o_data <= i_pc;
        -- Do nothing
      when MUX_REG_ZERO => o_data <= (others => '0');
    end case;
  end process;
end architecture;