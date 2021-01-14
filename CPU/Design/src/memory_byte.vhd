
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY memory_byte IS
	GENERIC(
		size_in_bytes   : integer   := 16384;
		init_filename	: string := "./src/memory.mif"
	);   
	PORT
	(
		address_data	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		address_inst	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		clock			: IN STD_LOGIC  := '1';

		input_data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren_data		: IN STD_LOGIC  := '0';

		res_data		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		res_inst		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END memory_byte;


ARCHITECTURE a_memory_byte OF memory_byte IS

BEGIN

	altsyncram_component : altsyncram
	GENERIC MAP (
		address_reg_b => "CLOCK0",
		clock_enable_input_a => "NORMAL",
		clock_enable_input_b => "NORMAL",
		clock_enable_output_a => "BYPASS",
		clock_enable_output_b => "BYPASS",
		indata_reg_b => "CLOCK0",
		init_file => init_filename,
		intended_device_family => "Cyclone 10 LP",
		lpm_type => "altsyncram",
		numwords_a => size_in_bytes,
		numwords_b => size_in_bytes,
		operation_mode => "BIDIR_DUAL_PORT",
		outdata_aclr_a => "NONE",
		outdata_aclr_b => "NONE",
		outdata_reg_a => "UNREGISTERED",
		outdata_reg_b => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		ram_block_type => "M9K",
		read_during_write_mode_mixed_ports => "DONT_CARE",
		read_during_write_mode_port_a => "DONT_CARE",
		read_during_write_mode_port_b => "DONT_CARE",
		widthad_a => 14,
		widthad_b => 14,
		width_a => 8,
		width_b => 8,
		width_byteena_a => 1,
		width_byteena_b => 1,
		wrcontrol_wraddress_reg_b => "CLOCK0"
	)
	PORT MAP (
		address_a => address_data(13 downto 0),
		address_b => address_inst(13 downto 0),
		clock0 => clock,
		data_a => input_data,
		data_b => "00000000",
		wren_a => wren_data,
		wren_b => '0',
		q_a => res_data,
		q_b => res_inst
	);

END a_memory_byte;
