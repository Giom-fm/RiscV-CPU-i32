library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.types.all;
use work.utils.all;

entity decode is 
		port(
			i_instruction			: in std_logic_vector(31 downto 0);
			o_alu_mode				: out T_ALU_MODE;
			o_mux_alu				: out T_MUX_ALU;
			o_mux_reg				: out T_MUX_REG;
			o_rs1_addr				: out std_logic_vector(4 downto 0);
			o_rs2_addr				: out std_logic_vector(4 downto 0);
			o_rd_addr				: out std_logic_vector(4 downto 0);
			o_immediate				: out std_logic_vector(31 downto 0);
			o_sext_mem_mode 		: out T_SEXT_MEM_MODE;
			o_mem_dir				: out T_MEM_DIR;
			o_store_mode			: out T_STORE_MODE;
			o_comp_mode				: out T_COMP_MODE
		);
		
end decode;

architecture a_decode of decode is

	signal opcode			: std_logic_vector(6 downto 0);
	signal funct_7			: std_logic_vector(6 downto 0);
	signal funct_3			: std_logic_vector(2 downto 0);
	signal rd				: std_logic_vector(4 downto 0);
	signal rs1				: std_logic_vector(4 downto 0);
	signal rs2				: std_logic_vector(4 downto 0);

	signal immediate_I		: std_logic_vector(31 downto 0);
	signal immediate_S		: std_logic_vector(31 downto 0);
	signal immediate_B		: std_logic_vector(31 downto 0);
	signal immediate_U		: std_logic_vector(31 downto 0);
	signal immediate_J		: std_logic_vector(31 downto 0);
	
begin

	decode_instruction: process(i_instruction) begin
		
		opcode 		<= i_instruction(6 downto 0);

		rd 			<= i_instruction(11 downto 7);
		rs1			<= i_instruction(19 downto 15);
		rs2			<= i_instruction(24 downto 20);
		funct_3   	<= i_instruction(14 downto 12);
		funct_7 	<= i_instruction(31 downto 25);

		immediate_I <= extend_signed(i_instruction(31 downto 20), immediate_I'length);
		immediate_S <= extend_signed(i_instruction(30 downto 25) & i_instruction(11 downto 7), immediate_S'length);
		immediate_B <= extend_signed(i_instruction(7) & i_instruction(30 downto 25) & i_instruction(11 downto 8) & '0', immediate_B'length);
		immediate_U <= i_instruction(31 downto 12) & extend("0", immediate_U'length - i_instruction(31 downto 12)'length);
		immediate_J <= extend_signed(i_instruction(19 downto 12) & i_instruction(20) & i_instruction(30 downto 21) & '0', immediate_J'length);  

		-- Default case
		o_mux_alu <= MUX_ALU_RS1_RS2;
		o_mux_reg <= MUX_REG_ZERO;

		o_alu_mode <= ALU_UNUSED;
		o_rs1_addr <= rs1;
		o_rs2_addr <= rs2;
		o_rd_addr <= (others => '0');
		o_sext_mem_mode <= SEXT_MEM_32;
		o_mem_dir <= MEM_DIR_READ;
		o_store_mode <= STORE_W;
		o_immediate <= (others => '0');
		o_comp_mode <= COMP_ALWAYS_ADD;

		
		
		-- U-Format Opcodes ----------------------------------------------------
		-- lui
		if opcode = "0110111" then

			o_immediate <= immediate_U;
			-- NOP
			o_alu_mode <= ALU_ADD;
			o_rs1_addr <= (others => '0');

			o_mux_alu <= MUX_ALU_RS1_IMM;
			o_mux_reg <= MUX_REG_ALU;

			o_rd_addr <= rd;
			
		-- auipc
		elsif opcode = "0110111" then

			o_immediate <= immediate_U;
			o_alu_mode <= ALU_ADD;

			o_mux_alu <= MUX_ALU_PC_IMM;
			o_mux_reg <= MUX_REG_ALU;

			o_rd_addr <= rd;

		
		
		-- I-Format Opcodes ----------------------------------------------------
		-- Loads
		elsif opcode = "0000011"  then

			o_mux_alu <= MUX_ALU_RS1_IMM;
			o_mux_reg <= MUX_REG_MEM;

			o_immediate <= immediate_I;
			o_mem_dir <= MEM_DIR_READ;
			o_alu_mode <= ALU_ADD;

			case funct_3 is
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
				when others => NULL;
			end case;

		-- JALR
		elsif opcode = "1100111" then
			o_immediate <= immediate_I;
			o_comp_mode <= COMP_ALWAYS_ALU;
			o_rd_addr <= rd;
			o_alu_mode <= ALU_ADD_S_E;

			o_mux_alu <= MUX_ALU_RS1_IMM;
			o_mux_reg <= MUX_REG_PC;

		-- Arithmetic Immediate
		elsif opcode = "0010011" then
			o_immediate <= immediate_I;
			o_rd_addr <= rd;
			
			o_mux_alu <= MUX_ALU_RS1_IMM;
			o_mux_reg <= MUX_REG_ALU;

			case funct_3 is 
				-- Addi
				when "000" => 
					o_alu_mode <= ALU_ADD;
				-- SLTI
				when "010" => 
					o_alu_mode <= ALU_SLT;
				-- SLTIU
				when "011" => 
					o_alu_mode <= ALU_SLTU;
				-- XORI
				when "100" => 
					o_alu_mode <= ALU_XOR;
				-- ORI
				when "110" => 
					o_alu_mode <= ALU_OR;
				-- ANDI
				when "111" => 
					o_alu_mode <= ALU_AND;
				when others => NULL;
			end case;
		-- S-Format Opcodes ----------------------------------------------------
		-- Store
		elsif opcode = "0100011" then

			o_mux_alu <= MUX_ALU_RS1_IMM;
			o_mux_reg <= MUX_REG_ZERO;

			o_mem_dir <= MEM_DIR_WRITE;
			o_immediate <= immediate_S;
			o_alu_mode <= ALU_ADD;

			case funct_3 is
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
		-- Arithmetic 
		elsif opcode = "0110011" then

			o_mux_alu <= MUX_ALU_RS1_RS2;
			o_mux_reg <= MUX_REG_ALU;

			o_rd_addr <= rd;

			case funct_7 & funct_3 is 
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

		-- B-Format Opcodes ----------------------------------------------------
		elsif opcode = "1100011" then

			o_immediate <= immediate_B;
			o_alu_mode <= ALU_ADD;

			o_mux_alu <= MUX_ALU_RS1_RS2;
			o_mux_reg <= MUX_REG_ZERO;

			case funct_3 is
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

		-- J-Format Opcodes ----------------------------------------------------
		-- JAL
		elsif opcode = "1101111" then

			o_immediate <= immediate_J;
			o_comp_mode <= COMP_ALWAYS_ALU;

			o_mux_alu <= MUX_ALU_RS1_IMM;
			o_mux_reg <= MUX_REG_PC;

			o_rd_addr <= rd;
			o_alu_mode <= ALU_ADD;
		end if;
	end process;
	
end a_decode;
