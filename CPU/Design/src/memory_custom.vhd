library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;

entity memory_custom is
    port(
	    i_clock           : in	std_logic;
        
        i_inst_address    : in std_logic_vector(3 downto 0);

        i_read_write      : in  T_MEM_DIR;       
        i_data_address    : in  std_logic_vector(3 downto 0);
        i_write_data      : in std_logic_vector(31 downto 0);

        o_inst_data       : out std_logic_vector(31 downto 0);
        o_read_data       : out std_logic_vector(31 downto 0);

        o_leds            : out std_logic_vector(7 downto 0)
    );
end memory_custom;


architecture a_memory_custom of memory_custom is
    type T_MEMORY is array(0 to 15) of std_logic_vector(7 downto 0);
    signal memory_table : T_MEMORY := (others => (others => '0'));

begin

    o_leds <= memory_table(0);
    
    o_read_data <= memory_table(to_integer(unsigned(i_data_address) + "11"))
                 & memory_table(to_integer(unsigned(i_data_address) + "10"))
                 & memory_table(to_integer(unsigned(i_data_address) + "01"))
                 & memory_table(to_integer(unsigned(i_data_address) + "00"));

    o_inst_data <= memory_table(to_integer(unsigned(i_inst_address) + "11"))
                 & memory_table(to_integer(unsigned(i_inst_address) + "10"))
                 & memory_table(to_integer(unsigned(i_inst_address) + "01"))
                 & memory_table(to_integer(unsigned(i_inst_address) + "00"));

    process (i_clock) begin
        if rising_edge(i_clock) then
            if i_read_write = MEM_DIR_WRITE then
                memory_table(to_integer(unsigned(i_data_address) + "11")) <= i_write_data(31 downto 24);
                memory_table(to_integer(unsigned(i_data_address) + "10")) <= i_write_data(23 downto 16);
                memory_table(to_integer(unsigned(i_data_address) + "01")) <= i_write_data(15 downto  8);
                memory_table(to_integer(unsigned(i_data_address) + "00")) <= i_write_data( 7 downto  0);
            end if;
        end if;
    end process;
end a_memory_custom;