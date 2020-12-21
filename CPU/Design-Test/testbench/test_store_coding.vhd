library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.test_utils.all;


entity test_store_coding is
end entity;

architecture a_test_store_coding of test_store_coding is
    constant C_DELAY : time := 10 ps;

    signal mode     : T_STORE_MODE;
    signal data_old : std_logic_vector(31 downto 0);
    signal data_new : std_logic_vector(31 downto 0);
    signal data     : std_logic_vector(31 downto 0);
        
begin

    store_coding_test : entity work.store_coding(a_store_coding) port map (
        i_mode      => mode,
        i_data_old  => data_old,
        i_data_new  => data_new,
        o_data      => data
        );
    
    test : process
    begin

        -- Test: STORE_B
        mode        <= STORE_B;
        data_old    <= "11110000000000000000000000000000";
        data_new    <= "00000000111111111111111111111111";
        compare_assert(data, "11110000000000000000000011111111", "STORE_B", C_DELAY);

        -- Test: STORE_H
        mode        <= STORE_H;
        data_old    <= "11110000000000000000000000000000";
        data_new    <= "00000000111111111111111111111111";
        compare_assert(data, "11110000000000001111111111111111", "STORE_H", C_DELAY);

        -- Test: STORE_W
        mode        <= STORE_W;
        data_old    <= "11110000000000000000000000000000";
        data_new    <= "00000000111111111111111111111111";
        compare_assert(data, "00000000111111111111111111111111", "STORE_W", C_DELAY);

        wait;
    end process;


end a_test_store_coding;