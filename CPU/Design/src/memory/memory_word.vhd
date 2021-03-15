-- A module which combines four 8bit wide memory blocks to a 32bit wide memory.
-- Author: Guillaume Fournier-Mayer

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.types.all;
entity memory_word is
  generic (
    -- The memory size in byte of the underlying 8Bit memory.
    -- Sums up to 65536 Bytes
    mem_size_in_bytes : integer := 16384;
    -- first memory init file
    init_filename_0 : string := "./src/memory/intel_mem_0.mif";
    -- second memory init file
    init_filename_1 : string := "./src/memory/intel_mem_1.mif";
    -- third memory init file
    init_filename_2 : string := "./src/memory/intel_mem_2.mif";
    -- fourth memory init file
    init_filename_3 : string := "./src/memory/intel_mem_3.mif"
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

  type T_MEMORY is record
    data_address : std_logic_vector(13 downto 0);
    data_input   : std_logic_vector(7 downto 0);
    data_result  : std_logic_vector(7 downto 0);
    inst_output  : std_logic_vector(7 downto 0);
    read_write   : T_MEM_DIR;
  end record;

  type T_MEMORIES is array (3 downto 0) of T_MEMORY;
  signal memories : T_MEMORIES;

  signal data_address_0    : std_logic_vector(13 downto 0);
  signal data_address_1    : std_logic_vector(13 downto 0);
  signal data_address_mask : std_logic_vector(1 downto 0);

  signal inst_address : std_logic_vector(13 downto 0);
begin

  data_address_0    <= i_data_address(15 downto 2);
  data_address_1    <= std_logic_vector(unsigned(data_address_0) + 1);
  data_address_mask <= i_data_address(1 downto 0);
  -- Instructions
  inst_address <= i_inst_address(15 downto 2);
  o_inst       <= memories(3).inst_output & memories(2).inst_output & memories(1).inst_output & memories(0).inst_output;

  -- 
  calc_address : process (i_data_address, data_address_mask, data_address_0, data_address_1, memories, i_data, i_data_store_mode, i_data_rw) begin

    -- default cases
    for i in 0 to 3 loop
      memories(i).data_address <= (others => '0');
      memories(i).data_input   <= (others => '0');
      memories(i).read_write   <= MEM_DIR_READ;
    end loop;
    o_data <= (others => '0');

    case data_address_mask is
      when "00" =>
        memories(0).data_address <= data_address_0;
        memories(1).data_address <= data_address_0;
        memories(2).data_address <= data_address_0;
        memories(3).data_address <= data_address_0;
        memories(0).data_input   <= i_data(7 downto 0);
        memories(1).data_input   <= i_data(15 downto 8);
        memories(2).data_input   <= i_data(23 downto 16);
        memories(3).data_input   <= i_data(31 downto 24);
        case i_data_store_mode is
          when STORE_B =>
            memories(0).read_write <= i_data_rw;
          when STORE_H =>
            memories(0).read_write <= i_data_rw;
            memories(1).read_write <= i_data_rw;
          when STORE_W =>
            memories(0).read_write <= i_data_rw;
            memories(1).read_write <= i_data_rw;
            memories(2).read_write <= i_data_rw;
            memories(3).read_write <= i_data_rw;
        end case;
        o_data <= memories(3).data_result & memories(2).data_result & memories(1).data_result & memories(0).data_result;
      when "01" =>
        memories(0).data_address <= data_address_1;
        memories(1).data_address <= data_address_0;
        memories(2).data_address <= data_address_0;
        memories(3).data_address <= data_address_0;
        memories(0).data_input   <= i_data(31 downto 24);
        memories(1).data_input   <= i_data(7 downto 0);
        memories(2).data_input   <= i_data(15 downto 8);
        memories(3).data_input   <= i_data(23 downto 16);
        case i_data_store_mode is
          when STORE_B =>
            memories(1).read_write <= i_data_rw;
          when STORE_H =>
            memories(1).read_write <= i_data_rw;
            memories(2).read_write <= i_data_rw;
          when STORE_W =>
            memories(0).read_write <= i_data_rw;
            memories(1).read_write <= i_data_rw;
            memories(2).read_write <= i_data_rw;
            memories(3).read_write <= i_data_rw;

        end case;
        o_data <= memories(0).data_result & memories(3).data_result & memories(2).data_result & memories(1).data_result;
      when "10" =>
        memories(0).data_address <= data_address_1;
        memories(1).data_address <= data_address_1;
        memories(2).data_address <= data_address_0;
        memories(3).data_address <= data_address_0;
        memories(0).data_input   <= i_data(23 downto 16);
        memories(1).data_input   <= i_data(31 downto 24);
        memories(2).data_input   <= i_data(7 downto 0);
        memories(3).data_input   <= i_data(15 downto 8);
        case i_data_store_mode is
          when STORE_B =>
            memories(2).read_write <= i_data_rw;
          when STORE_H =>
            memories(2).read_write <= i_data_rw;
            memories(3).read_write <= i_data_rw;
          when STORE_W =>
            memories(0).read_write <= i_data_rw;
            memories(1).read_write <= i_data_rw;
            memories(2).read_write <= i_data_rw;
            memories(3).read_write <= i_data_rw;
        end case;
        o_data <= memories(1).data_result & memories(0).data_result & memories(3).data_result & memories(2).data_result;
      when "11" =>
        memories(0).data_address <= data_address_1;
        memories(1).data_address <= data_address_1;
        memories(2).data_address <= data_address_1;
        memories(3).data_address <= data_address_0;
        memories(0).data_input   <= i_data(15 downto 8);
        memories(1).data_input   <= i_data(23 downto 16);
        memories(2).data_input   <= i_data(31 downto 24);
        memories(3).data_input   <= i_data(7 downto 0);
        case i_data_store_mode is
          when STORE_B =>
            memories(3).read_write <= i_data_rw;
          when STORE_H =>
            memories(3).read_write <= i_data_rw;
            memories(0).read_write <= i_data_rw;
          when STORE_W =>
            memories(0).read_write <= i_data_rw;
            memories(1).read_write <= i_data_rw;
            memories(2).read_write <= i_data_rw;
            memories(3).read_write <= i_data_rw;
        end case;
        o_data <= memories(2).data_result & memories(1).data_result & memories(0).data_result & memories(3).data_result;
      when others => null;
    end case;
  end process;

  -- Define Byte-Memory-Blocks
  -- The first memory block
  mem_1 : entity work.memory_byte(a_memory_byte)
    generic map(
      mem_size_in_bytes => mem_size_in_bytes,
      init_filename     => init_filename_0
    )
    port map(
      i_data_clock   => i_data_clock,
      i_data_address => memories(0).data_address,
      i_data         => memories(0).data_input,
      i_data_wren    => memories(0).read_write,
      o_data         => memories(0).data_result,

      i_inst_clock   => i_inst_clock,
      i_inst_address => inst_address,
      o_inst         => memories(0).inst_output
    );

  -- The second memory block
  mem_2 : entity work.memory_byte(a_memory_byte)
    generic map(
      mem_size_in_bytes => mem_size_in_bytes,
      init_filename     => init_filename_1
    )
    port map(
      i_data_clock   => i_data_clock,
      i_data_address => memories(1).data_address,
      i_data         => memories(1).data_input,
      i_data_wren    => memories(1).read_write,
      o_data         => memories(1).data_result,

      i_inst_clock   => i_inst_clock,
      i_inst_address => inst_address,
      o_inst         => memories(1).inst_output
    );

  -- The third memory block
  mem_3 : entity work.memory_byte(a_memory_byte)
    generic map(
      mem_size_in_bytes => mem_size_in_bytes,
      init_filename     => init_filename_2
    )
    port map(
      i_data_clock   => i_data_clock,
      i_data_address => memories(2).data_address,
      i_data         => memories(2).data_input,
      i_data_wren    => memories(2).read_write,
      o_data         => memories(2).data_result,

      i_inst_clock   => i_inst_clock,
      i_inst_address => inst_address,
      o_inst         => memories(2).inst_output
    );

  -- The fourth memory block
  mem_4 : entity work.memory_byte(a_memory_byte)
    generic map(
      mem_size_in_bytes => mem_size_in_bytes,
      init_filename     => init_filename_3
    )
    port map(
      i_data_clock   => i_data_clock,
      i_data_address => memories(3).data_address,
      i_data         => memories(3).data_input,
      i_data_wren    => memories(3).read_write,
      o_data         => memories(3).data_result,

      i_inst_clock   => i_inst_clock,
      i_inst_address => inst_address,
      o_inst         => memories(3).inst_output
    );

end a_memory_word;