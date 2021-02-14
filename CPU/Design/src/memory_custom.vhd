library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;
use work.utils.all;

entity memory_custom is
    port(
	    i_clock           : in	std_logic;
        i_reset           : in 	std_logic;
        
        i_store_mode	  : in T_STORE_MODE;
        i_read_write      : in  T_MEM_DIR;       
        i_data_address    : in  std_logic_vector(1 downto 0);
        i_write_data      : in std_logic_vector(31 downto 0);

        o_read_data       : out std_logic_vector(31 downto 0);

        o_leds            : out std_logic_vector(7 downto 0);
        i_rx              : in std_logic;
        o_tx              : out std_logic
    );
end memory_custom;


architecture a_memory_custom of memory_custom is
    type T_MEMORY is array(0 to 3) of std_logic_vector(31 downto 0);
    signal memory_table : T_MEMORY := (others => (others => '0'));

    signal address : integer := 0;

    signal uart_rx_data : std_logic_vector(7 downto 0);
    signal uart_tx_data : std_logic_vector(7 downto 0);
    signal uart_status : std_logic_vector(7 downto 0) := "00000000";
    signal uart_tx_enable : std_logic;
    signal rx_error : std_logic;
    signal uart_read_write : std_logic;

begin

    address <= to_integer(unsigned(i_data_address));
    o_read_data <= memory_table(address);

    -- LED-IO memory
    o_leds <= memory_table(0)(7 downto 0);

    -- UART memory
    uart_tx_data <= memory_table(2)(7 downto 0);
    uart_read_write <= '0' when i_read_write = MEM_DIR_READ else '0';
    uart_tx_enable <= uart_read_write when address = 2 else '0';
    
    
    process (i_clock, i_store_mode, i_write_data, i_reset) begin

        if i_reset = '0' then 
            memory_table <= (others => (others => '0'));
        elsif rising_edge(i_clock) then
            memory_table(1) <= "000000000000000000000000" & uart_rx_data;
            memory_table(3) <= "000000000000000000000000" & uart_status;

            if i_read_write = MEM_DIR_WRITE and address /= 1 and address /= 3 then
                -- memory_table(address) <= i_write_data;
                case i_store_mode is 
                    when STORE_B => memory_table(address) <= extend(i_write_data(7 downto 0), 32);
                    when STORE_H => memory_table(address) <= extend(i_write_data(15 downto 0), 32);
                    when STORE_W => memory_table(address) <= i_write_data;
                end case;
            end if;
        end if;
    end process;

    uart : entity work.UART(logic)
    generic map(
        clk_freq    => 12_000_000,
        --baud_rate   => 9600,
        baud_rate   => 19_200,
        os_rate     => 16,
        d_width     => 8,
        parity      => 0,
        parity_eo   => '0' 
    )
	port map(
        clk         => i_clock,
        reset_n     => i_reset,
        tx_ena      => uart_tx_enable,
        tx_data     => uart_tx_data,
        rx          => i_rx,
        rx_busy     => uart_status(1),
        rx_error    => uart_status(2),
        rx_data     => uart_rx_data,
        tx_busy     => uart_status(0),
        tx          => o_tx
    );
    
end a_memory_custom;