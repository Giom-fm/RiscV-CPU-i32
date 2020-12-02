library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package types is
	subtype T_ALU_MODE is std_logic_vector(3 downto 0);
	constant ALU_UNUSED : T_ALU_MODE := "0000";
	constant ALU_ADD 	: T_ALU_MODE := "0001";
	constant ALU_SUB 	: T_ALU_MODE := "0010";
	constant ALU_SLL 	: T_ALU_MODE := "0011";
	constant ALU_SLT 	: T_ALU_MODE := "0100";
	constant ALU_SLU 	: T_ALU_MODE := "0101";
	constant ALU_SLTU 	: T_ALU_MODE := "0110";
	constant ALU_XOR 	: T_ALU_MODE := "0111";
	constant ALU_SRL 	: T_ALU_MODE := "1000";
	constant ALU_SRA 	: T_ALU_MODE := "1001";
	constant ALU_OR 	: T_ALU_MODE := "1010";
	constant ALU_AND 	: T_ALU_MODE := "1011";



	subtype T_SIGN_EXTENDER_MODE is std_logic_vector(2 downto 0);
	constant SIGN_EXTENDER_S_8  : T_SIGN_EXTENDER_MODE:= "000";
    constant SIGN_EXTENDER_S_16 : T_SIGN_EXTENDER_MODE := "001";
	constant SIGN_EXTENDER_U_8  : T_SIGN_EXTENDER_MODE := "100";
    constant SIGN_EXTENDER_U_16 : T_SIGN_EXTENDER_MODE := "101";
	constant SIGN_EXTENDER_32 : T_SIGN_EXTENDER_MODE := "111";
	
	subtype T_STORE_MODE is std_logic_vector(1 downto 0);
	constant STORE_B : T_STORE_MODE := "00";
	constant STORE_H : T_STORE_MODE := "01";
	constant STORE_W : T_STORE_MODE := "10";

	subtype T_MUX_CONTROL is std_logic_vector(2 downto 0);
	constant MUX_CONTROL_STORE 	: T_MUX_CONTROL := "000";
	constant MUX_CONTROL_ALU 		: T_MUX_CONTROL := "001";
	constant MUX_CONTROL_IMM 		: T_MUX_CONTROL := "010";
	constant MUX_CONTROL_LOAD 		: T_MUX_CONTROL := "011";
	constant MUX_CONTROL_BRANCH		: T_MUX_CONTROL := "100";
	constant MUX_CONTROL_JUMP		: T_MUX_CONTROL := "101";
	

	subtype T_PC_SRC is std_logic;
	constant PC_SRC_ADD : T_PC_SRC := '0';
	constant PC_SRC_ALU : T_PC_SRC := '1';
	constant PC_ADD : integer := 1;

	subtype T_COMP_MODE is std_logic_vector(2 downto 0);
	constant COMP_EQUAL 			: T_COMP_MODE := "000";
	constant COMP_NOT_EQUAL 		: T_COMP_MODE := "001";
	constant COMP_LESS_THEN 		: T_COMP_MODE := "010";
	constant COMP_GREATER_EQUAL 	: T_COMP_MODE := "011";
	constant COMP_LESS_THEN_U 		: T_COMP_MODE := "100";
	constant COMP_GREATER_EQUAL_U 	: T_COMP_MODE := "101";
	

	subtype T_MEM_DIR is std_logic;
	constant MEM_DIR_READ	: T_MEM_DIR := '0'; 
	constant MEM_DIR_WRITE	: T_MEM_DIR := '1';
	 
end package;