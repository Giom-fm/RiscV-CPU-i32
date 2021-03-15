library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;


entity memory is
	port(
		i_clock           : in	std_logic;
		i_reset			  : in	std_logic;
		
		i_store_mode	  : in T_STORE_MODE;
        
        i_inst_address    : in std_logic_vector(31 downto 0);

        i_read_write      : in  T_MEM_DIR;       
        i_data_address    : in  std_logic_vector(31 downto 0);
        i_write_data      : in std_logic_vector(31 downto 0);

        o_inst_data       : out std_logic_vector(31 downto 0);
		o_read_data       : out std_logic_vector(31 downto 0);
		
		o_leds			  : out std_logic_vector(7 downto 0);
		i_rx              : in std_logic;
        o_tx              : out std_logic
    );

end memory;


architecture a_memory of memory is

	signal clock_invert : std_logic;
	
	signal m9k_rw			: T_MEM_DIR;       
	signal m9k_inst			: std_logic_vector(31 downto 0);
	signal m9k_data			: std_logic_vector(31 downto 0);
	
	signal ext_rw	: T_MEM_DIR;       
	-- signal ext_inst	: std_logic_vector(31 downto 0); --unused
	signal ext_data	: std_logic_vector(31 downto 0);
begin

	clock_invert <= not i_clock;
	o_inst_data <= m9k_inst;

	process(i_data_address, i_read_write, m9k_data, ext_data) begin
		m9k_rw <= MEM_DIR_READ;
		ext_rw <= MEM_DIR_READ;

		o_read_data <= (others => '0');
		if i_data_address <= x"0000FFFF" then
			o_read_data <= m9k_data;
			m9k_rw <= i_read_write;
		elsif i_data_address <= x"00010003" then
			o_read_data <= ext_data;
			ext_rw <= i_read_write;
		end if;

	end process;


	mem : entity work.memory_word(a_memory_word)
	port map(
		i_clock_inst      => i_clock,
		i_clock_data      => clock_invert,
		i_inst_address    => i_inst_address(15 downto 0),
		i_store_mode	  => i_store_mode,
		i_read_write      => m9k_rw,
        i_data_address    => i_data_address(15 downto 0),
        i_write_data      => i_write_data,
		o_inst_data       => m9k_inst,
        o_read_data       => m9k_data
	);

	mem_peripherie : entity work.peripherie(a_peripherie)
	port map(
		i_clock           => clock_invert,
		i_reset			  => i_reset,
		i_store_mode	  => i_store_mode,
		i_read_write      => ext_rw,
        i_data_address    => i_data_address(1 downto 0),
        i_write_data      => i_write_data,
		o_read_data       => ext_data,
		o_leds            => o_leds,
		i_rx              => i_rx,
        o_tx              => o_tx
	);
		
end a_memory;
