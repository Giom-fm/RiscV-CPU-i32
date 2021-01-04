library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;
use work.utils.all;

entity pc is
    port(
        i_clock 	: in std_logic;
        i_reset 	: in std_logic;
        i_mode  	: in T_PC_Mode;
        i_comp      : in std_logic;
        i_src_alu   : in std_logic_vector(31 downto 0);
        i_src_next  : in std_logic_vector(31 downto 0);
        o_current   : out std_logic_vector(31 downto 0);
        o_next      : out std_logic_vector(31 downto 0)
    );
end pc;


architecture a_pc of pc is

    signal pc_register : std_logic_vector(31 downto 0) := (others => '0');

    begin
        o_current <= pc_register;
        o_next <= std_logic_vector(unsigned(pc_register) + PC_ADD);

        process (i_clock, i_reset) begin
            if i_reset = '1' then 
                pc_register <= (others => '0');
            elsif rising_edge(i_clock) then
                if i_mode = PC_SRC_ALU
                    or (i_mode = PC_SRC_COMP_ALU and i_comp = '1') then
                    pc_register <= i_src_alu;
                else
                    pc_register <= i_src_next;
                end if;
            end if;
        end process;
end a_pc;

