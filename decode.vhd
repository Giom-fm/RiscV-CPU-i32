library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity decode is 
		port(
			i_instruction	: in std_logic_vector(31 downto 0);
			o_alu_mode		: out std_logic_vector(2 downto 0);
			o_rs1_addr		: out std_logic_vector(4 downto 0);
			o_rs2_addr		: out std_logic_vector(4 downto 0);
			o_rd_addr		: out std_logic_vector(4 downto 0);
			o_reg_mux		: out std_logic;
			o_reg_immediate	: out std_logic_vector(31 downto 0)
			
		);
		
end decode;

architecture a_decode of decode is

	constant REG_MUX_IMM	 : std_logic := '0';
	constant REG_MUX_ALU : std_logic := '1';

	constant ALU_UNUSED : std_logic_vector(2 downto 0) := "000";
    constant ALU_AND    : std_logic_vector(2 downto 0) := "001";
    constant ALU_OR     : std_logic_vector(2 downto 0) := "010";
    constant ALU_XOR    : std_logic_vector(2 downto 0) := "011";
    constant ALU_ADD    : std_logic_vector(2 downto 0) := "100";
    constant ALU_SUB    : std_logic_vector(2 downto 0) := "101";

	signal opcode		: std_logic_vector(4 downto 0);
	signal funct3		: std_logic_vector(2 downto 0);
	signal funct7		: std_logic_vector(4 downto 0);
	
	signal imm_u	: std_logic_vector(19 downto 0);
	signal rd		: std_logic_vector(4 downto 0);
	signal rs1		: std_logic_vector(4 downto 0);
	signal rs2		: std_logic_vector(4 downto 0);

begin

	decode_instruction: process(i_instruction) begin
		
		opcode 		<= i_instruction(6 downto 2);
		funct3	 	<= i_instruction(14 downto 12);
		funct7 		<= i_instruction(31 downto 27);
		rd 			<= i_instruction(11 downto 7);
		imm_u		<= i_instruction(31 downto 12);
		rs1			<= i_instruction(19 downto 15);
		rs2			<= i_instruction(24 downto 20);


		o_alu_mode <= ALU_UNUSED;
		o_rs1_addr <= rs1;
		o_rs2_addr <= rs2;
		o_rd_addr <= "00000";
		o_reg_immediate <= (others => '0');
		


		-- U-Format Opcodes
		
		if opcode = "01101" then
			o_reg_mux <= REG_MUX_IMM;
			o_rd_addr <= rd;
			o_reg_immediate <= "000000000000"& imm_u ;
		
		-- R-Format Opcodes ----------------------------------------------------
		-- add 
		elsif opcode = "01100" and funct3 = "000" and funct7 = "00000" then
			o_reg_mux <= REG_MUX_ALU;
			o_alu_mode <= ALU_ADD;
			o_rd_addr <= rd;

		-- sub
		elsif  opcode = "01100" and funct3 = "000" and funct7 = "01000" then
			o_reg_mux <= REG_MUX_ALU;
			o_alu_mode <= ALU_SUB;
			o_rd_addr <= rd;

		-- sll
		elsif  opcode = "01100" and funct3 = "001" and funct7 = "00000" then

		-- slt
		elsif  opcode = "01100" and funct3 = "010" and funct7 = "00000" then

		-- sltu
		elsif  opcode = "01100" and funct3 = "011" and funct7 = "00000" then

		-- xor
		elsif  opcode = "01100" and funct3 = "100" and funct7 = "00000" then
			o_reg_mux <= REG_MUX_ALU;
			o_alu_mode <= ALU_XOR;
			o_rd_addr <= rd;

		-- sra
		elsif  opcode = "01100" and funct3 = "101" and funct7 = "00000" then

		-- srl
		elsif  opcode = "01100" and funct3 = "101" and funct7 = "01000" then

		-- or
		elsif  opcode = "01100" and funct3 = "110" and funct7 = "00000" then
			o_reg_mux <= REG_MUX_ALU;
			o_alu_mode <= ALU_OR;
			o_rd_addr <= rd;

		-- and
		elsif  opcode = "01100" and funct3 = "111" and funct7 = "00000" then
			o_reg_mux <= REG_MUX_ALU;
			o_alu_mode <= ALU_AND;
			o_rd_addr <= rd;
			
		end if;

	end process;
	
end a_decode;
