-- A module which combines four 8bit wide memory blocks to a 32bit wide memory.
-- Author: Guillaume Fournier-Mayer

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.types.all;
entity memory_word is
  generic (
    -- The memory size in byte of the underlying 8Bit memory.
    -- Sums up to 65536 Bits
    mem_size_in_bytes : integer := 16384;
    -- first memory init file
    init_filename_1 : string := "./src/memory/intel_mem_3.mif";
    -- second memory init file
    init_filename_2 : string := "./src/memory/intel_mem_2.mif";
    -- third memory init file
    init_filename_3 : string := "./src/memory/intel_mem_1.mif";
    -- fourth memory init file
    init_filename_4 : string := "./src/memory/intel_mem_0.mif"
  );
  port (
    -- The instruction clock
    i_inst_clock : in std_logic;
    -- The instruction address
    i_inst_address : in std_logic_vector(15 downto 0);
    -- The instruction that were read at the address
    o_inst : out std_logic_vector(31 downto 0);

    -- The data clock
    i_data_clock : in std_logic;
    -- The data address
    i_data_address : in std_logic_vector(15 downto 0);
    -- The data to be written to the address
    i_data : in std_logic_vector(31 downto 0);
    -- Read or write
    i_data_rw : in T_MEM_DIR;
    -- The data store mode
    i_data_store_mode : in T_STORE_MODE;
    -- The data that were read at the address
    o_data : out std_logic_vector(31 downto 0)
  );

end memory_word;

architecture a_memory_word of memory_word is

  signal mem_1_data_address : std_logic_vector(13 downto 0);
  signal mem_1_data_input   : std_logic_vector(7 downto 0);
  signal mem_1_data_result  : std_logic_vector(7 downto 0);
  signal mem_1_inst_output  : std_logic_vector(7 downto 0);
  signal mem_1_read_write   : T_MEM_DIR;

  signal mem_2_data_address : std_logic_vector(13 downto 0);
  signal mem_2_data_input   : std_logic_vector(7 downto 0);
  signal mem_2_data_result  : std_logic_vector(7 downto 0);
  signal mem_2_inst_output  : std_logic_vector(7 downto 0);
  signal mem_2_read_write   : T_MEM_DIR;

  signal mem_3_data_address : std_logic_vector(13 downto 0);
  signal mem_3_data_input   : std_logic_vector(7 downto 0);
  signal mem_3_data_result  : std_logic_vector(7 downto 0);
  signal mem_3_inst_output  : std_logic_vector(7 downto 0);
  signal mem_3_read_write   : T_MEM_DIR;

  signal mem_4_data_address : std_logic_vector(13 downto 0);
  signal mem_4_data_input   : std_logic_vector(7 downto 0);
  signal mem_4_data_result  : std_logic_vector(7 downto 0);
  signal mem_4_inst_output  : std_logic_vector(7 downto 0);
  signal mem_4_read_write   : T_MEM_DIR;

  signal data_address_0    : std_logic_vector(13 downto 0);
  signal data_address_1    : std_logic_vector(13 downto 0);
  signal data_address_mask : std_logic_vector(1 downto 0);

  signal inst_address : std_logic_vector(13 downto 0);
begin

  data_address_0    <= i_data_address(15 downto 2);
  data_address_1    <= std_logic_vector(unsigned(data_address_0) + 1);
  data_address_mask <= i_data_address(1 downto 0);

  calc_address : process (i_data_address, data_address_mask, data_address_0, data_address_1, mem_1_data_result, mem_2_data_result, mem_3_data_result, mem_4_data_result, i_data, i_data_store_mode, i_data_rw) begin
    mem_1_data_address <= (others => '0');
    mem_2_data_address <= (others => '0');
    mem_3_data_address <= (others => '0');
    mem_4_data_address <= (others => '0');
    o_data             <= (others => '0');

    mem_1_data_input <= (others => '0');
    mem_2_data_input <= (others => '0');
    mem_3_data_input <= (others => '0');
    mem_4_data_input <= (others => '0');

    mem_1_read_write <= MEM_DIR_READ;
    mem_2_read_write <= MEM_DIR_READ;
    mem_3_read_write <= MEM_DIR_READ;
    mem_4_read_write <= MEM_DIR_READ;

    case data_address_mask is
      when "00" =>
        mem_1_data_address <= data_address_0;
        mem_2_data_address <= data_address_0;
        mem_3_data_address <= data_address_0;
        mem_4_data_address <= data_address_0;
        mem_1_data_input   <= i_data(7 downto 0);
        mem_2_data_input   <= i_data(15 downto 8);
        mem_3_data_input   <= i_data(23 downto 16);
        mem_4_data_input   <= i_data(31 downto 24);
        case i_data_store_mode is
          when STORE_B =>
            mem_1_read_write <= i_data_rw;
          when STORE_H =>
            mem_1_read_write <= i_data_rw;
            mem_2_read_write <= i_data_rw;
          when STORE_W =>
            mem_1_read_write <= i_data_rw;
            mem_2_read_write <= i_data_rw;
            mem_3_read_write <= i_data_rw;
            mem_4_read_write <= i_data_rw;
        end case;
        o_data <= mem_4_data_result & mem_3_data_result & mem_2_data_result & mem_1_data_result;
      when "01" =>
        mem_1_data_address <= data_address_1;
        mem_2_data_address <= data_address_0;
        mem_3_data_address <= data_address_0;
        mem_4_data_address <= data_address_0;
        mem_1_data_input   <= i_data(31 downto 24);
        mem_2_data_input   <= i_data(7 downto 0);
        mem_3_data_input   <= i_data(15 downto 8);
        mem_4_data_input   <= i_data(23 downto 16);
        case i_data_store_mode is
          when STORE_B =>
            mem_2_read_write <= i_data_rw;
          when STORE_H =>
            mem_2_read_write <= i_data_rw;
            mem_3_read_write <= i_data_rw;
          when STORE_W =>
            mem_2_read_write <= i_data_rw;
            mem_3_read_write <= i_data_rw;
            mem_4_read_write <= i_data_rw;
            mem_1_read_write <= i_data_rw;
        end case;
        o_data <= mem_1_data_result & mem_4_data_result & mem_3_data_result & mem_2_data_result;
      when "10" =>
        mem_1_data_address <= data_address_1;
        mem_2_data_address <= data_address_1;
        mem_3_data_address <= data_address_0;
        mem_4_data_address <= data_address_0;
        mem_1_data_input   <= i_data(23 downto 16);
        mem_2_data_input   <= i_data(31 downto 24);
        mem_3_data_input   <= i_data(7 downto 0);
        mem_4_data_input   <= i_data(15 downto 8);
        case i_data_store_mode is
          when STORE_B =>
            mem_3_read_write <= i_data_rw;
          when STORE_H =>
            mem_3_read_write <= i_data_rw;
            mem_4_read_write <= i_data_rw;
          when STORE_W =>
            mem_3_read_write <= i_data_rw;
            mem_4_read_write <= i_data_rw;
            mem_1_read_write <= i_data_rw;
            mem_2_read_write <= i_data_rw;
        end case;
        o_data <= mem_2_data_result & mem_1_data_result & mem_4_data_result & mem_3_data_result;
      when "11" =>
        mem_1_data_address <= data_address_1;
        mem_2_data_address <= data_address_1;
        mem_3_data_address <= data_address_1;
        mem_4_data_address <= data_address_0;
        mem_1_data_input   <= i_data(15 downto 8);
        mem_2_data_input   <= i_data(23 downto 16);
        mem_3_data_input   <= i_data(31 downto 24);
        mem_4_data_input   <= i_data(7 downto 0);
        case i_data_store_mode is
          when STORE_B =>
            mem_4_read_write <= i_data_rw;
          when STORE_H =>
            mem_4_read_write <= i_data_rw;
            mem_1_read_write <= i_data_rw;
          when STORE_W =>
            mem_4_read_write <= i_data_rw;
            mem_1_read_write <= i_data_rw;
            mem_2_read_write <= i_data_rw;
            mem_3_read_write <= i_data_rw;
        end case;
        o_data <= mem_3_data_result & mem_2_data_result & mem_1_data_result & mem_4_data_result;
      when others => null;
    end case;
  end process;
  -- Instructions
  inst_address <= i_inst_address(15 downto 2);
  o_inst       <= mem_4_inst_output & mem_3_inst_output & mem_2_inst_output & mem_1_inst_output;
  -- Define Byte-Memory-Blocks
  mem_1 : entity work.memory_byte(a_memory_byte)
    generic map(
      mem_size_in_bytes => mem_size_in_bytes,
      init_filename     => init_filename_1
    )
    port map(
      i_data_clock   => i_data_clock,
      i_data_address => mem_1_data_address,
      i_data         => mem_1_data_input,
      i_data_wren    => mem_1_read_write,
      o_data         => mem_1_data_result,

      i_inst_clock   => i_inst_clock,
      i_inst_address => inst_address,
      o_inst         => mem_1_inst_output
    );

  mem_2 : entity work.memory_byte(a_memory_byte)
    generic map(
      mem_size_in_bytes => mem_size_in_bytes,
      init_filename     => init_filename_2
    )
    port map(
      i_data_clock   => i_data_clock,
      i_data_address => mem_2_data_address,
      i_data         => mem_2_data_input,
      i_data_wren    => mem_2_read_write,
      o_data         => mem_2_data_result,

      i_inst_clock   => i_inst_clock,
      i_inst_address => inst_address,
      o_inst         => mem_2_inst_output
    );

  mem_3 : entity work.memory_byte(a_memory_byte)
    generic map(
      mem_size_in_bytes => mem_size_in_bytes,
      init_filename     => init_filename_3
    )
    port map(
      i_data_clock   => i_data_clock,
      i_data_address => mem_3_data_address,
      i_data         => mem_3_data_input,
      i_data_wren    => mem_3_read_write,
      o_data         => mem_3_data_result,

      i_inst_clock   => i_inst_clock,
      i_inst_address => inst_address,
      o_inst         => mem_3_inst_output
    );

  mem_4 : entity work.memory_byte(a_memory_byte)
    generic map(
      mem_size_in_bytes => mem_size_in_bytes,
      init_filename     => init_filename_4
    )
    port map(
      i_data_clock   => i_data_clock,
      i_data_address => mem_4_data_address,
      i_data         => mem_4_data_input,
      i_data_wren    => mem_4_read_write,
      o_data         => mem_4_data_result,

      i_inst_clock   => i_inst_clock,
      i_inst_address => inst_address,
      o_inst         => mem_4_inst_output
    );

end a_memory_word;