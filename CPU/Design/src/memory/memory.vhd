-- A module which maps the program memory and the IO memory
-- Author: Guillaume Fournier-Mayer

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.types.all;
entity memory is
  port (
    i_clock : in std_logic;
    i_reset : in std_logic;

    -- Programm memory
    -- The instruction address
    i_inst_address : in std_logic_vector(31 downto 0);
    -- The instruction that were read at the address
    o_inst : out std_logic_vector(31 downto 0);

    -- The data address
    i_data_address : in std_logic_vector(31 downto 0);
    -- The data to be written to the address
    i_data : in std_logic_vector(31 downto 0);
    -- Read or write
    i_data_read_write : in T_MEM_DIR;
    -- The data store mode
    i_data_store_mode : in T_STORE_MODE;
    -- The data that were read at the address
    o_data : out std_logic_vector(31 downto 0);

    -- Extended memory (IO)
    o_leds : out std_logic_vector(7 downto 0);
    i_rx   : in std_logic;
    o_tx   : out std_logic
  );

end memory;

architecture a_memory of memory is
  signal clock_invert : std_logic;

  signal ram_read_write : T_MEM_DIR;
  signal ram_inst       : std_logic_vector(31 downto 0);
  signal ram_data       : std_logic_vector(31 downto 0);

  signal ext_read_write : T_MEM_DIR;
  signal ext_data       : std_logic_vector(31 downto 0);
begin

  -- Invert the clock to generate two edges.
  -- This allows data and instructions to be read out simultaneously in one cycle.
  clock_invert <= not i_clock;
  -- The instruction that were read at the address
  o_inst <= ram_inst;
  -- Decides whether the specified address is in
  -- RAM or in the extended area and sets the corresponding data. 
  ram_or_ext : process (i_data_address, i_data_read_write, ram_data, ext_data) begin
    ram_read_write <= MEM_DIR_READ;
    ext_read_write <= MEM_DIR_READ;
    o_data         <= (others => '0');

    -- Address is in RAM section
    if i_data_address <= x"0000FFFF" then
      o_data            <= ram_data;
      ram_read_write    <= i_data_read_write;
      -- Address is in extendet Section
    elsif i_data_address <= x"00010003" then
      o_data               <= ext_data;
      ext_read_write       <= i_data_read_write;
    end if;
  end process;
  -- The area that represents the RAM
  ram : entity work.memory_word(a_memory_word)
    port map(
      i_inst_clock   => i_clock,
      i_inst_address => i_inst_address(15 downto 0),
      o_inst         => ram_inst,

      i_data_clock      => clock_invert,
      i_data_address    => i_data_address(15 downto 0),
      i_data            => i_data,
      i_data_rw         => ram_read_write,
      i_data_store_mode => i_data_store_mode,
      o_data            => ram_data
    );
  -- The area that represents the extended area (IO)
  extended : entity work.peripherie(a_peripherie)
    port map(
      i_clock           => clock_invert,
      i_reset           => i_reset,

      i_data_address    => i_data_address(1 downto 0),
      i_data            => i_data,
      i_data_store_mode => i_data_store_mode,
      i_data_read_write => ext_read_write,
      o_data            => ext_data,
      
      o_leds            => o_leds,
      i_rx              => i_rx,
      o_tx              => o_tx
    );

end a_memory;