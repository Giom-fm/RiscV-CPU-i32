-- Module for programm counter
-- Author : Guillaume Fournier - Mayer (tinf101922)
-- Date: 09.05.2021

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;
use work.utils.all;

entity pc is
    port(
        -- Clock
        i_clock 	: in std_logic;
        -- Reset
        i_reset 	: in std_logic;
        -- Programm counter mode
        i_mode  	: in T_PC_MODE;
        -- Comparator result
        i_comp      : in std_logic;
        -- PC value from ALU
        i_src_alu   : in std_logic_vector(31 downto 0);
        -- PC value from current + 4
        i_src_next  : in std_logic_vector(31 downto 0);
        -- Current PC
        o_current   : out std_logic_vector(31 downto 0);
        -- PC value from current + 4
        o_next      : out std_logic_vector(31 downto 0);
        -- Instruction memory adress
        o_mem_addr  : out std_logic_vector(31 downto 0)

    );
end pc;


architecture a_pc of pc is

    signal pc_register : std_logic_vector(31 downto 0) := "11111111111111111111111111111100";
    signal s_next : std_logic_vector(31 downto 0);

    begin
        s_next <= std_logic_vector(unsigned(pc_register) + PC_ADD);
        o_current <= pc_register;
        o_next <= s_next;

        o_mem_addr <= i_src_alu when i_mode = PC_SRC_ALU or (i_mode = PC_SRC_COMP_ALU and i_comp = '1') else s_next;  
        process (i_clock, i_reset, i_mode) begin
            if i_reset = '0' then 
                pc_register <= "11111111111111111111111111111100";
            elsif rising_edge(i_clock) then
                if i_mode = PC_SRC_ALU or (i_mode = PC_SRC_COMP_ALU and i_comp = '1') then
                    pc_register <= i_src_alu;
                else
                    pc_register <= i_src_next;
                end if;
            end if;
        end process;
end a_pc;

