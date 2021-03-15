-- A module representing an 8 bit memory block.
-- The module serves as wrapper around the megafunction generated memory block.
-- Author: Guillaume Fournier-Mayer

library ieee;
use ieee.std_logic_1164.all;
use work.types.all;
library altera_mf;
use altera_mf.altera_mf_components.all;

entity memory_byte is
  -- Generic values that are overwritten by the parent instance
  generic (
    mem_size_in_bytes : integer := 16384;
    init_filename     : string  := "./src/memory.mif"
  );
  port (
    -- The data clock
    i_data_clock : in std_logic := '1';
    -- The data address
    i_data_address : in std_logic_vector (13 downto 0);
    -- The data to be written to the address
    i_data : in std_logic_vector (7 downto 0);
    -- Read or write
    i_data_wren : in T_MEM_DIR;
    -- The data that were read at the address
    o_data : out std_logic_vector (7 downto 0);

    -- The instruction clock
    i_inst_clock : in std_logic := '1';
    -- The instruction address
    i_inst_address : in std_logic_vector (13 downto 0);
    -- The instruction that were read at the address
    o_inst : out std_logic_vector (7 downto 0)

  );
end memory_byte;
architecture a_memory_byte of memory_byte is

  signal wren_data : std_logic := '0';

begin

  wren_data <= '0' when i_data_wren = MEM_DIR_READ else '1';

  altsyncram_component : altsyncram
  generic map(
    address_reg_b                      => "CLOCK1",
    clock_enable_input_a               => "BYPASS",
    clock_enable_input_b               => "BYPASS",
    clock_enable_output_a              => "BYPASS",
    clock_enable_output_b              => "BYPASS",
    indata_reg_b                       => "CLOCK1",
    init_file                          => init_filename,
    intended_device_family             => "Cyclone 10 LP",
    lpm_type                           => "altsyncram",
    numwords_a                         => mem_size_in_bytes,
    numwords_b                         => mem_size_in_bytes,
    operation_mode                     => "BIDIR_DUAL_PORT",
    outdata_aclr_a                     => "NONE",
    outdata_aclr_b                     => "NONE",
    outdata_reg_a                      => "UNREGISTERED",
    outdata_reg_b                      => "UNREGISTERED",
    power_up_uninitialized             => "FALSE",
    ram_block_type                     => "M9K",
    read_during_write_mode_mixed_ports => "OLD_DATA",
    read_during_write_mode_port_a      => "OLD_DATA",
    read_during_write_mode_port_b      => "OLD_DATA",
    widthad_a                          => 14,
    widthad_b                          => 14,
    width_a                            => 8,
    width_b                            => 8,
    width_byteena_a                    => 1,
    width_byteena_b                    => 1,
    wrcontrol_wraddress_reg_b          => "CLOCK1"
  )
  port map(
    address_a => i_data_address,
    address_b => i_inst_address,
    clock0    => i_data_clock,
    clock1    => i_inst_clock,
    data_a    => i_data,
    data_b    => "00000000",
    wren_a    => wren_data,
    wren_b    => '0',
    q_a       => o_data,
    q_b       => o_inst
  );

end a_memory_byte;