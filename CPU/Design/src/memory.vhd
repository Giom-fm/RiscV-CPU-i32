library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;
use std.textio.all;


entity memory is
    GENERIC(
		size_in_words   : integer   := 1024;
		init_filename	: string := ""
    );   
    port(
      i_clock           : in	std_logic;
	  i_reset	        : in	std_logic;
	  -- Data bus
      i_read_write      : in  T_MEM_DIR;       
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
	--signal memory_table : T_MEMORY := (others => (others => '0'));
	

	--function init_ram(file_name: string) return T_MEMORY is
	--	file fptr				: text;
	--	variable file_line     	: line;
	--	variable open_status 	: FILE_OPEN_STATUS;
	--	variable opcode			: bit_vector(31 downto 0);
	--	variable memory :  T_MEMORY := (others => (others => '0'));
	--  begin
	--	file_open(open_status, fptr, file_name, read_mode);
	--	assert open_status /= open_ok;
	--	--while (not endfile(fptr) and i < 1000) loop
	--	for i in 0 to memory'length - 1 loop
	--		exit when not endfile(fptr);
	--		readline(fptr, file_line);
	--		read(file_line, opcode);
	--		memory(i) := To_StdLogicVector(opcode);
	--		
	--	end loop;
	--	file_close(fptr);
	--	return memory;
	--end function;
	--signal memory_table : T_MEMORY := init_ram("memory.hex");
	
	signal memory_table : T_MEMORY;
	attribute ram_init_file : string;
	attribute ram_init_file of memory_table : signal is "memory.mif";
	
	begin
		
		o_read_data <= memory_table(to_integer(unsigned(i_address)));
		o_inst_data <= memory_table(to_integer(unsigned(i_inst_address)));

		process (i_clock, i_reset) begin
			if i_reset = '1' then 
				memory_table <= (others => (others => '0'));
			elsif rising_edge(i_clock) then
				if i_read_write = MEM_DIR_WRITE then
					memory_table(to_integer(unsigned(i_address))) <= i_write_data;
				end if;
			end if;
		end process;
end a_memory;
