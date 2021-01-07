library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity registers is
    port(
        i_clock                           :	in	std_logic;
		i_reset	                          : in	std_logic;                      
        i_read_register_1_address         : in  std_logic_vector(4 downto 0);
        o_read_register_1_data            : out std_logic_vector(31 downto 0);

        i_read_register_2_address         : in  std_logic_vector(4 downto 0);
        o_read_register_2_data            : out std_logic_vector(31 downto 0);

        i_write_register_address        : in  std_logic_vector(4 downto 0);
        i_write_register_data           : in  std_logic_vector(31 downto 0);

        --
        o_debug                         : out std_logic_vector(7 downto 0)
    );
end registers;


architecture a_registers of registers is

    type t_register is array(0 to 31) of std_logic_vector(31 downto 0);
    signal register_table : t_register := (others => (others => '0'));

    begin
        o_read_register_1_data <= register_table(to_integer(unsigned(i_read_register_1_address)));
        o_read_register_2_data <= register_table(to_integer(unsigned(i_read_register_2_address)));
        o_debug <= register_table(14)(7 downto 0);
      

        process (i_clock, i_reset) begin
					if i_reset = '1' then 
							register_table <= (others => (others => '0'));
					elsif rising_edge(i_clock) then
							if i_write_register_address /= "00000" then
								register_table(to_integer(unsigned(i_write_register_address))) <=	i_write_register_data;
							end if;
					end if;
        end process;
end a_registers;