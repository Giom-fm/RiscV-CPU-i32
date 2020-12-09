library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.types.all;
use work.utils.all;

entity decode is 
		port(
			i_instruction			: in std_logic_vector(31 downto 0);
			o_alu_mode				: out T_ALU_MODE;
			o_mux_control			: out T_MUX_CONTROL;
			o_rs1_addr				: out std_logic_vector(4 downto 0);
			o_rs2_addr				: out std_logic_vector(4 downto 0);
			o_rd_addr				: out std_logic_vector(4 downto 0);
			o_offset_imm			: out std_logic_vector(31 downto 0);
			o_sext_mem_mode 		: out T_SEXT_MEM_MODE;
			o_sext_offset_imm_mode 	: out T_SEXT_OFFSET_IMM_MODE;
			o_mem_dir				: out T_MEM_DIR;
			o_store_mode			: out T_STORE_MODE;
			o_comp_mode				: out T_COMP_MODE
		);
		
end decode;

architecture a_decode of decode is

	signal opcode			: std_logic_vector(4 downto 0);
	signal u_funct			: std_logic_vector(2 downto 0);
	signal s_funct			: std_logic_vector(2 downto 0);
	signal j_funct			: std_logic_vector(2 downto 0);
	signal r_funct			: std_logic_vector(9 downto 0);
	signal offset_i			: std_logic_vector(11 downto 0);
	signal offset_s			: std_logic_vector(11 downto 0);
	signal offset_j			: std_logic_vector(11 downto 0);
	signal offset_j_imm		: std_logic_vector(19 downto 0);
	signal imm_u			: std_logic_vector(19 downto 0);
	signal rd				: std_logic_vector(4 downto 0);
	signal rs1				: std_logic_vector(4 downto 0);
	signal rs2				: std_logic_vector(4 downto 0);
	

begin

	decode_instruction: process(i_instruction) begin
		
		opcode 		<= i_instruction(6 downto 2);
		-- funct7 & funct3
		r_funct 	<= i_instruction(31 downto 25) & i_instruction(14 downto 12);
		-- funct3
		u_funct   	<= i_instruction(14 downto 12);
		s_funct   	<= i_instruction(14 downto 12);
		j_funct		<= i_instruction(14 downto 12);

		

		rd 			<= i_instruction(11 downto 7);
		imm_u		<= i_instruction(31 downto 12);
		offset_i	<= i_instruction(31 downto 20);
		rs1			<= i_instruction(19 downto 15);
		rs2			<= i_instruction(24 downto 20);

		offset_s	<= i_instruction(31 downto 25) & i_instruction(11 downto 7);
		offset_j	<= i_instruction(31) &
						i_instruction(7) &
						i_instruction(30 downto 25) &
						i_instruction(11 downto 8);

		offset_j_imm	<= i_instruction(31) &
						i_instruction(19 downto 12) &
						i_instruction(20) &
						i_instruction(30 downto 21);


		-- Default case
		o_mux_control <= MUX_CONTROL_STORE;
		o_alu_mode <= ALU_UNUSED;
		o_rs1_addr <= rs1;
		o_rs2_addr <= rs2;
		o_rd_addr <= "00000";
		o_sext_mem_mode <= SEXT_MEM_32;
		o_mem_dir <= MEM_DIR_READ;
		o_store_mode <= STORE_W;
		o_offset_imm <= (others => '0');
		o_comp_mode <= COMP_ALWAYS_ADD;

		
		
		-- U-Format Opcodes ----------------------------------------------------
		-- lui
		if opcode = "01101" then

			o_mux_control <= MUX_CONTROL_ALU_REG;
			o_rd_addr <= rd;
			o_rs1_addr <= (others => '0');
			o_offset_imm <= fill_w_zeros(imm_u);

		-- auipc
		elsif opcode = "01101" then

		-- I-Format Opcodes ----------------------------------------------------
		-- Loads
		elsif opcode = "00000"  then
		
			o_mux_control <= MUX_CONTROL_LOAD;
			o_offset_imm <= fill_w_zeros(offset_i);
			o_alu_mode <= ALU_ADD;

			case u_funct is
				-- lb
				when "000" =>
					o_sext_mem_mode <= SEXT_MEM_S_8;
				-- lbu
				when "100" =>
					o_sext_mem_mode <= SEXT_MEM_U_8;
				-- lh
				when "001" =>
					o_sext_mem_mode <= SEXT_MEM_S_16;
				-- lhu
				when "101" =>
					o_sext_mem_mode <= SEXT_MEM_U_16;
				-- lw
				when "010" =>
					o_sext_mem_mode <= SEXT_MEM_32;
				-- lwu
				when "110" =>
					o_sext_mem_mode <= SEXT_MEM_32;
				when others => NULL;
			end case;

		-- S-Format Opcodes ----------------------------------------------------
		
		elsif opcode = "01000" then

			o_mux_control <= MUX_CONTROL_STORE;
			o_mem_dir <= MEM_DIR_WRITE;
			o_offset_imm <= fill_w_zeros(offset_s);
			o_alu_mode <= ALU_ADD;

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
			o_mux_control <= MUX_CONTROL_ALU_REG;
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

		-- J-Format Opcodes ----------------------------------------------------
		elsif opcode = "11000" then

			o_offset_imm <= fill_w_zeros(offset_j);
			o_alu_mode <= ALU_ADD_S;
			o_mux_control <= MUX_CONTROL_BRANCH;

			case j_funct is
				-- beq
				when "000" =>
					o_comp_mode <= COMP_EQUAL;					
				-- bne
				when "001" =>
					o_comp_mode <= COMP_NOT_EQUAL;
				-- blt
				when "100" => 
					o_comp_mode <= COMP_LESS_THEN;
				-- bge
				when "101" =>
					o_comp_mode <= COMP_GREATER_EQUAL;
				-- bltu
				when "110" =>
					o_comp_mode <= COMP_LESS_THEN_U;	
				-- bgeu
				when "111" =>
					o_comp_mode <= COMP_GREATER_EQUAL_U;
				when others => NULL;
			end case;

		-- JAL
		elsif opcode = "11011" then

			o_offset_imm <= fill_w_zeros(offset_j_imm);
			o_comp_mode <= COMP_ALWAYS_ALU;
			o_rd_addr <= rd;
			o_mux_control <= MUX_CONTROL_JUMP_REL;
			o_alu_mode <= ALU_ADD_S;

		-- JALR
		elsif opcode = "11001" then

			o_offset_imm <= fill_w_zeros(offset_i);
			o_comp_mode <= COMP_ALWAYS_ALU;
			o_rd_addr <= rd;
			o_alu_mode <= ALU_ADD_S_E;
			o_mux_control <= MUX_CONTROL_JUMP_ABS;
	
		end if;
	end process;
	
end a_decode;
