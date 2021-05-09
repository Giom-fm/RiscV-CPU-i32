-- A module which represents the registers
-- Author: Guillaume Fournier-Mayer
-- Date: 09.05.2021

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity registers is
  port (
    -- Clock
    i_clock : in std_logic;
    -- Reset
    i_reset : in std_logic;

    -- The read address of the target register (rs1)
    i_read_register_1_address : in std_logic_vector(4 downto 0);
    -- The data that are stored at the address at the target register (rs1)
    o_read_register_1_data : out std_logic_vector(31 downto 0);

    -- The read address of the target register (rs2)
    i_read_register_2_address : in std_logic_vector(4 downto 0);
    -- The data that are stored at the address at the target register (rs2)
    o_read_register_2_data : out std_logic_vector(31 downto 0);

    -- The write address of the target register (rd)
    i_write_register_address : in std_logic_vector(4 downto 0);
    -- The data to be written to the destination register
    i_write_register_data : in std_logic_vector(31 downto 0)
  );
end registers;
architecture a_registers of registers is

  -- The 32 registers with 32 bit each
  type t_register is array(0 to 31) of std_logic_vector(31 downto 0);
  signal register_table : t_register := (others => (others => '0'));

begin
  -- The values in the registers at the read addresses are always read,
  -- regardless of whether they are required or not.
  o_read_register_1_data <= register_table(to_integer(unsigned(i_read_register_1_address)));
  o_read_register_2_data <= register_table(to_integer(unsigned(i_read_register_2_address)));

  -- The registers can be reset via an asynchronous reset.
  -- New data is transferred for "i_write_register_data" to the register at
  -- "i_write_register_address" on rising edge.
  -- The register at address zero is locked for write accesses. 
  process (i_clock, i_reset) begin
    if i_reset = '0' then
      register_table <= (others => (others => '0'));
    elsif rising_edge(i_clock) then
      if i_write_register_address /= "00000" then
        register_table(to_integer(unsigned(i_write_register_address))) <= i_write_register_data;
      end if;
    end if;
  end process;
end a_registers;