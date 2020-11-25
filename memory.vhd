library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity memory is
    GENERIC(
	    size_in_words       : integer   := 1024     
    );   
    port(
      i_clock           : in	std_logic;
	  i_reset	        : in	std_logic;
	  -- Data bus
      i_read_write      : in  std_logic;       
      i_address         : in  std_logic_vector(31 downto 0);
      o_read_data       : out std_logic_vector(31 downto 0);
	  i_write_data      : in std_logic_vector(31 downto 0);
	  -- Instruction bus
	  i_inst_address    : in std_logic_vector(31 downto 0);
	  o_inst_data       : out std_logic_vector(31 downto 0)
    );

end memory;


architecture a_memory of memory is

	type T_MEMORY is array(0 to size_in_words) of std_logic_vector(31 downto 0);
	signal memory_table : T_MEMORY := (others => (others => '0'));
	
	begin
		o_read_data <= memory_table(to_integer(unsigned(i_address)));
		o_inst_data <= memory_table(to_integer(unsigned(i_inst_address)));

		process (i_clock, i_reset) begin
			if i_reset = '1' then 
				memory_table <= (others => (others => '0'));
			elsif rising_edge(i_clock) then
				if i_read_write = '1' then
					memory_table(to_integer(unsigned(i_address))) <= i_write_data;
				end if;
			end if;
		end process;
end a_memory;
