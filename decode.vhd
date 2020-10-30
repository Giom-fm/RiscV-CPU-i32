library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity decode is 
		port(
		i_clk : 				in		std_logic;
		i_rst	: 				in		std_logic;
		i_instruction : 	in		std_logic_vector(31 downto 0));
		
end decode;

architecture a_decode of decode is

	signal opcode_0		: std_logic_vector(4 downto 0);
	signal opcode_1		: std_logic_vector(2 downto 0);
	signal opcode_2		: std_logic_vector(4 downto 0);
	
	signal reg_dest		: std_logic_vector(4 downto 0);
	signal immediate	: std_logic_vector(20 downto 0);
	signal reg_s1		: std_logic_vector(20 downto 0);
	signal reg_s2		: std_logic_vector(20 downto 0);

begin

	decode_instruction: process(opcode_0, opcode_1, opcode_2, reg_dest, immediate, reg_s1, reg_s2) begin
		
		opcode_0 	<= i_instruction(6 downto 2);
		opcode_1 	<= i_instruction(14 downto 12);
		opcode_2 	<= i_instruction(31 downto 27);
		reg_dest 	<= i_instruction(11 downto 7);
		immediate	<= i_instruction(31 downto 12);
		reg_s1		<= i_instruction(19 downto 15);
		reg_s2		<= i_instruction(24 downto 20);
		
		-- add 
		if opcode_0 = "01100" and opcode_1 = "000" and opcode_2 = "00000" then

		-- sub
		elsif  opcode_0 = "01100" and opcode_1 = "000" and opcode_2 = "01000" then

		-- sll
		elsif  opcode_0 = "01100" and opcode_1 = "001" and opcode_2 = "00000" then

		-- slt
		elsif  opcode_0 = "01100" and opcode_1 = "010" and opcode_2 = "00000" then

		-- sltu
		elsif  opcode_0 = "01100" and opcode_1 = "011" and opcode_2 = "00000" then

		-- xor
		elsif  opcode_0 = "01100" and opcode_1 = "100" and opcode_2 = "00000" then

		-- sra
		elsif  opcode_0 = "01100" and opcode_1 = "101" and opcode_2 = "00000" then

		-- srl
		elsif  opcode_0 = "01100" and opcode_1 = "101" and opcode_2 = "01000" then

		-- or
		elsif  opcode_0 = "01100" and opcode_1 = "110" and opcode_2 = "00000" then

		-- and
		elsif  opcode_0 = "01100" and opcode_1 = "111" and opcode_2 = "00000" then

		end if;

	end process;
	
end a_decode;
