library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.types.all;

entity decode is 
		port(
			i_instruction	: in std_logic_vector(31 downto 0);
			o_alu_mode		: out T_ALU_MODE;
			o_mux_control	: out T_WRITE_REG_MUX;
			o_rs1_addr		: out std_logic_vector(4 downto 0);
			o_rs2_addr		: out std_logic_vector(4 downto 0);
			o_rd_addr		: out std_logic_vector(4 downto 0);
			o_reg_immediate	: out std_logic_vector(31 downto 0);
			o_offset		: out std_logic_vector(31 downto 0);
			o_sign_extender_mode : out T_SIGN_EXTENDER_MODE;
			o_mem_dir		: out std_logic;
			o_store_mode	: out T_STORE_MODE
		);
		
end decode;

architecture a_decode of decode is

	constant REG_MUX_IMM	: std_logic := '0';
	constant REG_MUX_ALU 	: std_logic := '1';

	constant REG_MUX_REG	: std_logic := '0';
	constant REG_MUX_OFFSET : std_logic := '1';

	constant MEM_DIR_READ	: std_logic := '0';
	constant MEM_DIR_WRITE 	: std_logic := '1';


	signal opcode		: std_logic_vector(4 downto 0);
	signal u_funct		: std_logic_vector(2 downto 0);
	signal s_funct		: std_logic_vector(2 downto 0);
	signal r_funct		: std_logic_vector(9 downto 0);
	
	signal offset_i		: std_logic_vector(11 downto 0);
	signal offset_s		: std_logic_vector(11 downto 0);
	signal imm_u		: std_logic_vector(19 downto 0);
	signal rd			: std_logic_vector(4 downto 0);
	signal rs1			: std_logic_vector(4 downto 0);
	signal rs2			: std_logic_vector(4 downto 0);
	

begin

	decode_instruction: process(i_instruction) begin
		
		opcode 		<= i_instruction(6 downto 2);
		-- funct7 & funct3
		r_funct 	<= i_instruction(31 downto 25) & i_instruction(14 downto 12);
		-- funct3
		u_funct   	<= i_instruction(14 downto 12);
		s_funct   	<= i_instruction(14 downto 12);

		rd 			<= i_instruction(11 downto 7);
		imm_u		<= i_instruction(31 downto 12);
		offset_i	<= i_instruction(31 downto 20);
		rs1			<= i_instruction(19 downto 15);
		rs2			<= i_instruction(24 downto 20);
		offset_s	<= i_instruction(31 downto 25) & i_instruction(11 downto 7);


		-- Default case
		o_mux_control <= WRITE_REG_ZERO;
		o_alu_mode <= ALU_UNUSED;
		o_rs1_addr <= rs1;
		o_rs2_addr <= rs2;
		o_rd_addr <= rd;
		o_rd_addr <= "00000";
		o_reg_immediate <= (others => '0');
		o_sign_extender_mode <= SIGN_EXTENDER_32;
		o_mem_dir <= MEM_DIR_READ;
		o_store_mode <= STORE_W;

		
		
		-- U-Format Opcodes ----------------------------------------------------
		-- lui
		if opcode = "01101" then

			o_mux_control <= WRITE_REG_IMM;
			o_rd_addr <= rd;
			o_reg_immediate <= "000000000000" & imm_u;


		-- I-Format Opcodes ----------------------------------------------------
		-- Loads
		elsif opcode = "00000"  then
		
			o_mux_control <= WRITE_REG_MEM;
			o_offset <= "00000000000000000000" & offset_i;
			o_alu_mode <= ALU_ADD;

			case u_funct is
				-- lb
				when "000" =>
					o_sign_extender_mode <= SIGN_EXTENDER_S_8;
				-- lbu
				when "100" =>
				o_sign_extender_mode <= SIGN_EXTENDER_U_8;
				-- lh
				when "001" =>
					o_sign_extender_mode <= SIGN_EXTENDER_S_16;
				-- lhu
				when "101" =>
					o_sign_extender_mode <= SIGN_EXTENDER_U_16;
				-- lw
				when "010" =>
					o_sign_extender_mode <= SIGN_EXTENDER_32;
				-- lwu
				when "110" =>
					o_sign_extender_mode <= SIGN_EXTENDER_32;
				when others => NULL;
			end case;

		-- S-Format Opcodes ----------------------------------------------------
		
		elsif opcode = "01000" then

			o_mux_control <= WRITE_REG_ZERO;
			o_mem_dir <= MEM_DIR_WRITE;
			o_offset <= "00000000000000000000" & offset_s;
			o_alu_mode <= ALU_ADD;
			rd <= "00000";

			case s_funct is
				-- sb
				when "000" =>
					o_store_mode <= STORE_B;
				-- sh
				when "001" =>
					o_store_mode <= STORE_H;
				-- sw
				when "010" =>
					o_store_mode <= STORE_W;
				when others => NULL;
			end case;

		-- R-Format Opcodes ----------------------------------------------------
		-- add 
		elsif opcode = "01100" then
			o_mux_control <= WRITE_REG_ALU;
			o_rd_addr <= rd;

			case r_funct is 
				when "0000000000" => 
					o_alu_mode <= ALU_ADD;
				when "0100000000" => 
					o_alu_mode <= ALU_SUB;
				when "0000000001" => 
					o_alu_mode <= ALU_SLL;
				when "0000000010" => 
					o_alu_mode <= ALU_SLT;
				when "0000000011" => 
					o_alu_mode <= ALU_SLTU;
				when "0000000100" => 
					o_alu_mode <= ALU_XOR;
				when "0000000101" => 
					o_alu_mode <= ALU_SRL;
				when "0100000101" => 
					o_alu_mode <= ALU_SRA;
				when "0000000110" => 
					o_alu_mode <= ALU_OR;
				when "0000000111" => 
					o_alu_mode <= ALU_AND;
				when others => NULL;
			end case;
		end if;

	end process;
	
end a_decode;
