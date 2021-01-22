library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;


entity memory is
	port(
	    i_clock           : in	std_logic;
        
        i_inst_address    : in std_logic_vector(31 downto 0);

        i_read_write      : in  T_MEM_DIR;       
        i_data_address    : in  std_logic_vector(31 downto 0);
        i_write_data      : in std_logic_vector(31 downto 0);

        o_inst_data       : out std_logic_vector(31 downto 0);
		o_read_data       : out std_logic_vector(31 downto 0);
		
		o_leds			  : out std_logic_vector(7 downto 0)
    );

end memory;


architecture a_memory of memory is
	
	signal mem_i_read_write			: T_MEM_DIR;       
	signal mem_o_inst_data			: std_logic_vector(31 downto 0);
	signal mem_o_read_data			: std_logic_vector(31 downto 0);
	
	signal mem_custom_i_read_write	: T_MEM_DIR;       
	signal mem_custom_o_inst_data	: std_logic_vector(31 downto 0);
	signal mem_custom_o_read_data	: std_logic_vector(31 downto 0);
begin

	process(i_inst_address, mem_o_inst_data) begin

		o_inst_data <= (others => '0');
		if i_inst_address <= x"FFFF" then
			o_inst_data <= mem_o_inst_data;
		end if;

	end process;


	process(i_data_address, i_read_write, mem_o_read_data, mem_custom_o_read_data) begin
		mem_i_read_write		<= MEM_DIR_READ;
		mem_custom_i_read_write	<= MEM_DIR_READ;

		o_read_data <= (others => '0');
		if i_data_address <= x"0000FFFF" then
			o_read_data <= mem_o_read_data;
			mem_i_read_write <= i_read_write;
		elsif i_data_address <= x"0001000F" then
			o_read_data <= mem_custom_o_read_data;
			mem_custom_i_read_write <= i_read_write;
		end if;

	end process;


	mem : entity work.memory_word(a_memory_word)
	port map(
		i_clock           => i_clock,
        i_inst_address    => i_inst_address(15 downto 0),
		i_read_write      => mem_i_read_write,
        i_data_address    => i_data_address(15 downto 0),
        i_write_data      => i_write_data,
		o_inst_data       => mem_o_inst_data,
        o_read_data       => mem_o_read_data
	);

	mem_custom : entity work.memory_custom(a_memory_custom)
	port map(
		i_clock           => i_clock,
        i_inst_address    => i_inst_address(3 downto 0),
		i_read_write      => mem_custom_i_read_write,
        i_data_address    => i_data_address(3 downto 0),
        i_write_data      => i_write_data,
		o_inst_data       => mem_custom_o_inst_data,
		o_read_data       => mem_custom_o_read_data,
		o_leds            => o_leds
	);
		
		
end a_memory;
