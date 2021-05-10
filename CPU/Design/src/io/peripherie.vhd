-- Module for IO operations like LEDs and UART
-- Author : Guillaume Fournier - Mayer (tinf101922)
-- Date: 09.05.2021

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.types.all;
use work.utils.all;

entity peripherie is
  port (
    -- Clock
    i_clock : in std_logic;
    -- Reset
    i_reset : in std_logic;

    -- Data adress
    i_data_address    : in std_logic_vector(1 downto 0);
    -- Data input
    i_data            : in std_logic_vector(31 downto 0);
    -- Data store mode
    i_data_store_mode : in T_STORE_MODE;
    -- Data direction (read/write)
    i_data_read_write : in T_MEM_DIR;
    -- Data output
    o_data            : out std_logic_vector(31 downto 0);

    -- Led output
    o_leds : out std_logic_vector(7 downto 0);
    -- UART RX
    i_rx   : in std_logic;
    -- UART TX
    o_tx   : out std_logic
  );
end peripherie;
architecture a_peripherie of peripherie is
  signal address         : integer := 0;
  constant C_LEDS        : integer := 0;
  constant C_UART_RX     : integer := 1;
  constant C_UART_TX     : integer := 2;
  constant C_UART_STATUS : integer := 3;

  signal io_register : std_logic_vector(7 downto 0);

  signal uart_rx_data   : std_logic_vector(7 downto 0);
  signal uart_tx_data   : std_logic_vector(7 downto 0);
  signal uart_status    : std_logic_vector(7 downto 0) := "00000000";
  signal uart_tx_enable : std_logic;

begin

  address <= to_integer(unsigned(i_data_address));
  read: process (address, io_register, uart_rx_data, uart_status) begin
    case(address) is
      when C_LEDS             => o_data <= extend(io_register, 32);
      when C_UART_RX          => o_data <= extend(uart_rx_data, 32);
      when C_UART_STATUS      => o_data <= extend(uart_status, 32);
      when others => o_data   <= (others => '0');
    end case;
  end process;


   -- LED-IO memory
   o_leds <= io_register;
   -- UART memory
   uart_tx_data   <= i_data(7 downto 0);
   uart_tx_enable <= '1' when address = C_UART_TX and i_data_read_write = MEM_DIR_WRITE else '0';
  write: process (i_clock, i_data_store_mode, i_data, i_reset) begin
    if i_reset = '0' then
      io_register <= (others => '0');
    elsif rising_edge(i_clock) then
      if i_data_read_write = MEM_DIR_WRITE and address = C_LEDS then
        io_register <= i_data(7 downto 0);
      end if;
    end if;
  end process;

  uart : entity work.UART(logic)
    generic map(
      clk_freq => 12_000_000,
      baud_rate => 19_200,
      os_rate   => 16,
      d_width   => 8,
      parity    => 0,
      parity_eo => '0'
    )
    port map(
      clk      => i_clock,
      reset_n  => i_reset,
      tx_ena   => uart_tx_enable,
      tx_data  => uart_tx_data,
      rx       => i_rx,
      rx_busy  => uart_status(1),
      rx_error => uart_status(2),
      rx_data  => uart_rx_data,
      tx_busy  => uart_status(0),
      tx       => o_tx
    );

end a_peripherie;