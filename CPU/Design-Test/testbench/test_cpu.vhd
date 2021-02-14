library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.test_utils.all;


entity test_cpu is
end entity;

architecture a_test_cpu of test_cpu is
    constant C_DELAY  : time := 10 ps;

    signal clock : std_logic;
    signal reset : std_logic;

    signal leds    : std_logic_vector(7 downto 0);
    signal uart_rx : std_logic;
    signal uart_tx : std_logic;

    signal alu_mode : T_ALU_MODE;
    signal left     : std_logic_vector(31 downto 0);
    signal right    : std_logic_vector(31 downto 0);
    signal result   : std_logic_vector(31 downto 0);

begin
    cpu : entity work.cpu(a_cpu) port map (
        i_clock => clock,
        i_reset => reset,
        leds    => leds,
        uart_rx => uart_rx,
        uart_tx => uart_tx
    );

    test : process
    begin
        reset <= '1';
        clock <= '0';
        wait for C_DELAY;
        reset <= '0';
        

        for i in 0 to 200 loop
            wait for C_DELAY;
            clock <= '1';
            wait for C_DELAY;
            clock <= '0';
        end loop;

        
        wait;
    end process;


end a_test_cpu;