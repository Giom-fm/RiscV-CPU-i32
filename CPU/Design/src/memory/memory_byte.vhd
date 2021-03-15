
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.types.all;


LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY memory_byte IS
	GENERIC(
		size_in_bytes   : integer   := 16384;
		init_filename	: string := "./src/memory.mif"
	);   
	PORT
	(
		i_address_data	: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		i_address_inst	: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		i_clock_inst		: IN STD_LOGIC  := '1';
		i_clock_data		: IN STD_LOGIC  := '1';

		i_input_data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		i_wren_data		: IN T_MEM_DIR;

		o_res_data		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		o_res_inst		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END memory_byte;


ARCHITECTURE a_memory_byte OF memory_byte IS

	signal wren_data : std_logic := '0';

BEGIN

	wren_data <= '0' when i_wren_data = MEM_DIR_READ else '1';

	altsyncram_component : altsyncram
	GENERIC MAP (
		address_reg_b => "CLOCK1",
		clock_enable_input_a => "BYPASS",
		clock_enable_input_b => "BYPASS",
		clock_enable_output_a => "BYPASS",
		clock_enable_output_b => "BYPASS",
		indata_reg_b => "CLOCK1",
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
		read_during_write_mode_mixed_ports => "OLD_DATA",
		read_during_write_mode_port_a => "OLD_DATA",
		read_during_write_mode_port_b => "OLD_DATA",
		widthad_a => 14,
		widthad_b => 14,
		width_a => 8,
		width_b => 8,
		width_byteena_a => 1,
		width_byteena_b => 1,
		wrcontrol_wraddress_reg_b => "CLOCK1"
	)
	PORT MAP (
		address_a => i_address_data,
		address_b => i_address_inst,
		clock0 => i_clock_data,
		clock1 => i_clock_inst,
		data_a => i_input_data,
		data_b => "00000000",
		wren_a => wren_data,
		--wren_a => '0',
		wren_b => '0',
		q_a => o_res_data,
		q_b => o_res_inst
	);

END a_memory_byte;
