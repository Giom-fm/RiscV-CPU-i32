library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.test_utils.all;


entity test_pc_mem is
end entity;


architecture a_test_pc_mem of test_pc_mem is

    constant C_DELAY : time := 10 ps;

    signal clock        : std_logic;
    signal pc_reset     : std_logic;
    signal pc_mode      : T_PC_MODE;
    signal pc_comp      : std_logic;
    signal src_alu   : std_logic_vector(31 downto 0);
    signal src_next  : std_logic_vector(31 downto 0);
    signal pc_current   : std_logic_vector(31 downto 0);
    signal pc_next      : std_logic_vector(31 downto 0);
    signal pc_mem_addr  : std_logic_vector(31 downto 0);


    signal store_mode   : T_STORE_MODE;
    --signal inst_address : std_logic_vector(31 downto 0) := (others => '0');
    --signal read_write   : T_MEM_DIR;       
    signal data_address : std_logic_vector(31 downto 0) := (others => '0');
    --signal write_data   : std_logic_vector(31 downto 0);
    signal inst_data    : std_logic_vector(31 downto 0);
    signal read_data    : std_logic_vector(31 downto 0);
    signal leds		    : std_logic_vector(7 downto 0);
    signal rx           : std_logic;
    signal tx           : std_logic;

begin

    pc : entity work.pc(a_pc) port map (
        i_clock 	=> clock,
        i_reset 	=> pc_reset,
        i_mode  	=> pc_mode,
        i_comp      => pc_comp,
        i_src_alu   => src_alu,
        i_src_next  => src_next,
        o_current   => pc_current,
        o_next      => pc_next,
        o_mem_addr  => pc_mem_addr
        );

    
    mem : entity work.memory(a_memory) port map (
        i_clock           => clock,
        i_store_mode	  => store_mode,
        i_inst_address    => pc_mem_addr,
        i_read_write      => '0',
        i_data_address    => data_address,
        i_write_data      => (others => '0'),
        o_inst_data       => inst_data,
        o_read_data       => read_data,
        o_leds			  => leds,
        i_rx              => rx,
        o_tx              => tx
        );

    process
    begin
        -- Init Test
        pc_reset <= '1';
        pc_mode <= PC_SRC_ADD;
        pc_comp <= '0';
        clock       <= '0';
        src_alu     <= to_stdlogicvector(x"00000014");
        src_next    <= to_stdlogicvector(x"00000000");
        store_mode <= STORE_W;
        data_address <= to_stdlogicvector(x"00000000");

        wait for C_DELAY;
        pc_reset <= '0';

        wait for C_DELAY;
        clock <= '1';
        src_next    <= to_stdlogicvector(x"00000004");

        data_address <= to_stdlogicvector(x"00000001");

        wait for C_DELAY;
        clock <= '0';

        wait for C_DELAY;
        clock <= '1';
        src_next    <= to_stdlogicvector(x"00000008");

        wait for C_DELAY;
        clock <= '0';

        wait for C_DELAY;
        clock <= '1';
        src_next    <= to_stdlogicvector(x"0000000B");
        pc_mode <= PC_SRC_ALU;

        wait for C_DELAY;
        clock <= '0';

        wait for C_DELAY;
        clock <= '1';
        src_next    <= to_stdlogicvector(x"00000018");

        wait for C_DELAY;
        clock <= '0';

        wait;
    end process;

    

end architecture;




