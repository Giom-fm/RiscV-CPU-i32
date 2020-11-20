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

	subtype T_WRITE_REG_MUX is std_logic_vector(1 downto 0);
	constant WRITE_REG_ZERO : T_STORE_MODE := "00";
	constant WRITE_REG_ALU 	: T_STORE_MODE := "01";
	constant WRITE_REG_IMM 	: T_STORE_MODE := "10";
	constant WRITE_REG_MEM 	: T_STORE_MODE := "11";

	constant ZERO_W : std_logic_vector(31 downto 0) := (others => '0');
	
end package;