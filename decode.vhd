library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity decode is 
		port(
			i_instruction			: in std_logic_vector(31 downto 0);
			o_alu_mode				: out std_logic_vector(2 downto 0);
			o_rs1_addr		: out std_logic_vector(4 downto 0);
			o_rs2_addr		: out std_logic_vector(4 downto 0);
			o_rd_addr		: out std_logic_vector(4 downto 0)
		);
		
end decode;

architecture a_decode of decode is

	constant ALU_UNUSED : std_logic_vector(2 downto 0) := "000";
    constant ALU_AND    : std_logic_vector(2 downto 0) := "001";
    constant ALU_OR     : std_logic_vector(2 downto 0) := "010";
    constant ALU_XOR    : std_logic_vector(2 downto 0) := "011";
    constant ALU_ADD    : std_logic_vector(2 downto 0) := "100";
    constant ALU_SUB    : std_logic_vector(2 downto 0) := "101";

	signal opcode_0		: std_logic_vector(4 downto 0);
	signal opcode_1		: std_logic_vector(2 downto 0);
	signal opcode_2		: std_logic_vector(4 downto 0);
	
	signal immediate	: std_logic_vector(20 downto 0);
	signal rd		: std_logic_vector(4 downto 0);
	signal rs1		: std_logic_vector(4 downto 0);
	signal rs2		: std_logic_vector(4 downto 0);

begin

	decode_instruction: process(i_instruction) begin
		
		opcode_0 	<= i_instruction(6 downto 2);
		opcode_1 	<= i_instruction(14 downto 12);
		opcode_2 	<= i_instruction(31 downto 27);
		rd 			<= i_instruction(11 downto 7);
		immediate	<= i_instruction(31 downto 12);
		rs1			<= i_instruction(19 downto 15);
		rs2			<= i_instruction(24 downto 20);

		o_alu_mode <= ALU_UNUSED;
		o_rs1_addr <= rs1;
		o_rs2_addr <= rs2;
		o_rd_addr <= "00000";
		
		-- add 
		if opcode_0 = "01100" and opcode_1 = "000" and opcode_2 = "00000" then
			o_alu_mode <= ALU_ADD;
			o_rd_addr <= rd;

		-- sub
		elsif  opcode_0 = "01100" and opcode_1 = "000" and opcode_2 = "01000" then
			o_alu_mode <= ALU_SUB;
			o_rd_addr <= rd;

		-- sll
		elsif  opcode_0 = "01100" and opcode_1 = "001" and opcode_2 = "00000" then

		-- slt
		elsif  opcode_0 = "01100" and opcode_1 = "010" and opcode_2 = "00000" then

		-- sltu
		elsif  opcode_0 = "01100" and opcode_1 = "011" and opcode_2 = "00000" then

		-- xor
		elsif  opcode_0 = "01100" and opcode_1 = "100" and opcode_2 = "00000" then
			o_alu_mode <= ALU_XOR;
			o_rd_addr <= rd;

		-- sra
		elsif  opcode_0 = "01100" and opcode_1 = "101" and opcode_2 = "00000" then

		-- srl
		elsif  opcode_0 = "01100" and opcode_1 = "101" and opcode_2 = "01000" then

		-- or
		elsif  opcode_0 = "01100" and opcode_1 = "110" and opcode_2 = "00000" then
			o_alu_mode <= ALU_OR;
			o_rd_addr <= rd;

		-- and
		elsif  opcode_0 = "01100" and opcode_1 = "111" and opcode_2 = "00000" then
			o_alu_mode <= ALU_AND;
			o_rd_addr <= rd;
		end if;

	end process;
	
end a_decode;
