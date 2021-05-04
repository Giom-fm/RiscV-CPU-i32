-- Tests for memory
-- Author : Guillaume Fournier-Mayer (tinf101922)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.test_utils.all;


entity test_memory is
end entity;

architecture a_test_memory of test_memory is
    constant C_DELAY  : time := 10 ps;
    signal clock        : std_logic;
    signal reset        : std_logic;
    signal store_mode   : T_STORE_MODE;
    signal inst_address : std_logic_vector(31 downto 0) := (others => '0');
    signal read_write   : T_MEM_DIR;       
    signal data_address : std_logic_vector(31 downto 0) := (others => '0');
    signal write_data   : std_logic_vector(31 downto 0);
    signal inst_data    : std_logic_vector(31 downto 0);
    signal read_data    : std_logic_vector(31 downto 0);
    signal leds		    : std_logic_vector(7 downto 0);
    signal rx           : std_logic;
    signal tx           : std_logic;
        
begin

    test : process
    begin
        clock <= '0';
        reset <= '1';
        store_mode <= STORE_W;
        read_write <= MEM_DIR_READ;
        inst_address <= "00000000000000000000000000000000";
        data_address <= "00000000000000000000000000000000";
        write_data <= "00000000000000000000000000000001";
        rx <= '1';

        wait for C_DELAY; clock <= '0'; wait for C_DELAY; clock <= '1';
        wait for C_DELAY; clock <= '0'; wait for C_DELAY; clock <= '1';
        data_address <= "00000000000000000000000000000100";
        wait for C_DELAY; clock <= '0'; wait for C_DELAY; clock <= '1';
        data_address <= "00000000000000000000000000001000";
        wait for C_DELAY; clock <= '0'; wait for C_DELAY; clock <= '1';
        data_address <= "00000000000000000000000000001100";
        wait for C_DELAY; clock <= '0'; wait for C_DELAY; clock <= '1';
        data_address <= "00000000000000000000000000000000";
        wait for C_DELAY; clock <= '0'; wait for C_DELAY; clock <= '1';
        data_address <= "00000000000000000000000000000001";
        wait for C_DELAY; clock <= '0'; wait for C_DELAY; clock <= '1';
        data_address <= "00000000000000000000000000000010";
        wait for C_DELAY; clock <= '0'; wait for C_DELAY; clock <= '1';
        data_address <= "00000000000000000000000000000011";
        wait for C_DELAY; clock <= '0'; wait for C_DELAY; clock <= '1';
        wait for C_DELAY; clock <= '0'; wait for C_DELAY; clock <= '1';
        wait;
    end process;

    memory_test : entity work.memory(a_memory) port map (
        i_clock             => clock,
        i_reset             => reset,
	    i_data_store_mode   => store_mode,
        i_inst_address      => inst_address,
        i_data_read_write   => read_write,
        i_data_address      => data_address,
        i_data              => write_data,
        o_inst              => inst_data,
	    o_data              => read_data,
	    o_leds			    => leds,
	    i_rx                => rx,
        o_tx                => tx
        );


end a_test_memory;