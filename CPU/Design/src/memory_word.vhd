library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;


entity memory_word is
    GENERIC(
		size_in_words   : integer   := 16384;
		init_filename_1	: string := "./src/memory_1.mif";
		init_filename_2	: string := "./src/memory_2.mif";
		init_filename_3	: string := "./src/memory_3.mif";
		init_filename_4	: string := "./src/memory_4.mif"
    );   
    port(
        i_clock           : in	std_logic;
        
        i_inst_address    : in std_logic_vector(31 downto 0);

        i_read_write      : in  T_MEM_DIR;       
        i_data_address    : in  std_logic_vector(31 downto 0);
        i_write_data      : in std_logic_vector(31 downto 0);

        o_inst_data       : out std_logic_vector(31 downto 0);
        o_read_data       : out std_logic_vector(31 downto 0);

        o_debug           : out std_logic_vector(7 downto 0)
    );

end memory_word;

architecture a_memory_word of memory_word is

    signal mem_1_address_data : std_logic_vector(31 downto 0);
    signal mem_1_address_inst : std_logic_vector(31 downto 0);
    signal mem_1_input_data : std_logic_vector(7 downto 0);
    signal mem_1_result_data : std_logic_vector(7 downto 0);
    signal mem_1_result_inst : std_logic_vector(7 downto 0);

    signal mem_2_address_data : std_logic_vector(31 downto 0);
    signal mem_2_address_inst : std_logic_vector(31 downto 0);
    signal mem_2_input_data : std_logic_vector(7 downto 0);
    signal mem_2_result_data : std_logic_vector(7 downto 0);
    signal mem_2_result_inst : std_logic_vector(7 downto 0);

    signal mem_3_address_data : std_logic_vector(31 downto 0);
    signal mem_3_address_inst : std_logic_vector(31 downto 0);
    signal mem_3_input_data : std_logic_vector(7 downto 0);
    signal mem_3_result_data : std_logic_vector(7 downto 0);
    signal mem_3_result_inst : std_logic_vector(7 downto 0);

    signal mem_4_address_data : std_logic_vector(31 downto 0);
    signal mem_4_address_inst : std_logic_vector(31 downto 0);
    signal mem_4_input_data : std_logic_vector(7 downto 0);
    signal mem_4_result_data : std_logic_vector(7 downto 0);
    signal mem_4_result_inst : std_logic_vector(7 downto 0);

    signal data_address_0 : std_logic_vector(31 downto 0);
    signal data_address_1 : std_logic_vector(31 downto 0);
    signal data_address_mask : std_logic_vector(1 downto 0);

    signal inst_address_0 : std_logic_vector(31 downto 0);
    signal inst_address_1 : std_logic_vector(31 downto 0);
    signal inst_address_mask : std_logic_vector(1 downto 0);

    signal debug_register : std_logic_vector(31 downto 0);

begin

    o_debug <= debug_register(7 downto 0);

    process(i_clock, i_write_data, debug_register) begin
        if rising_edge(i_clock) and i_data_address = "11111111111111111111111111111111" and i_read_write = MEM_DIR_WRITE then
            debug_register <= i_write_data;
        else
            debug_register <= debug_register;
        end if;
    end process;

    data_address_0 <= "00" & i_data_address(31 downto 2);
    data_address_1 <= std_logic_vector(unsigned(data_address_0) + 1);
    data_address_mask <= i_data_address(1 downto 0);

    calc_address : process(i_data_address, data_address_mask, data_address_0, data_address_1, mem_1_result_data, mem_2_result_data, mem_3_result_data, mem_4_result_data, i_write_data) begin
        mem_1_address_data  <= "00000000000000000000000000000000";
        mem_2_address_data  <= "00000000000000000000000000000000";
        mem_3_address_data  <= "00000000000000000000000000000000";
        mem_4_address_data  <= "00000000000000000000000000000000";
        o_read_data         <= "00000000000000000000000000000000";

        mem_1_input_data    <= "00000000";
        mem_2_input_data    <= "00000000";
        mem_3_input_data    <= "00000000";
        mem_4_input_data    <= "00000000";

        if i_data_address = "11111111111111111111111111111111" then
        o_read_data <= debug_register;
        else
            case data_address_mask is
                when "00" =>
                    mem_1_address_data <= data_address_0;
                    mem_2_address_data <= data_address_0;
                    mem_3_address_data <= data_address_0;
                    mem_4_address_data <= data_address_0;
                    mem_1_input_data   <= i_write_data(7 downto 0);
                    mem_2_input_data   <= i_write_data(15 downto 8);
                    mem_3_input_data   <= i_write_data(23 downto 16);
                    mem_4_input_data   <= i_write_data(31 downto 24);
                    o_read_data <= mem_4_result_data & mem_3_result_data & mem_2_result_data & mem_1_result_data;
                when "01" =>
                    mem_1_address_data <= data_address_1;
                    mem_2_address_data <= data_address_0;
                    mem_3_address_data <= data_address_0;
                    mem_4_address_data <= data_address_0;
                    mem_1_input_data   <= i_write_data(31 downto 24);
                    mem_2_input_data   <= i_write_data(7 downto 0);
                    mem_3_input_data   <= i_write_data(15 downto 8);
                    mem_4_input_data   <= i_write_data(23 downto 16);
                    o_read_data <= mem_1_result_data & mem_4_result_data & mem_3_result_data & mem_2_result_data;
                when "10" =>
                    mem_1_address_data <= data_address_1;
                    mem_2_address_data <= data_address_1;
                    mem_3_address_data <= data_address_0;
                    mem_4_address_data <= data_address_0;
                    mem_1_input_data   <= i_write_data(23 downto 16);
                    mem_2_input_data   <= i_write_data(31 downto 24);
                    mem_3_input_data   <= i_write_data(7 downto 0);
                    mem_4_input_data   <= i_write_data(15 downto 8);
                    o_read_data <= mem_2_result_data & mem_1_result_data & mem_4_result_data & mem_3_result_data;
                when "11" =>
                    mem_1_address_data <= data_address_1;
                    mem_2_address_data <= data_address_1;
                    mem_3_address_data <= data_address_1;
                    mem_4_address_data <= data_address_0;
                    mem_1_input_data   <= i_write_data(15 downto 8);
                    mem_2_input_data   <= i_write_data(23 downto 16);
                    mem_3_input_data   <= i_write_data(31 downto 24);
                    mem_4_input_data   <= i_write_data(7 downto 0);
                    o_read_data <= mem_3_result_data & mem_2_result_data & mem_1_result_data & mem_4_result_data;
            end case;
        end if;
   end process;

    inst_address_0 <= "00" & i_inst_address(31 downto 2);
    inst_address_1 <= std_logic_vector(unsigned(inst_address_0) + 1);
    inst_address_mask <= i_inst_address(1 downto 0);

    calc_inst : process(inst_address_mask, inst_address_0, inst_address_1, mem_1_result_inst, mem_2_result_inst, mem_3_result_inst, mem_4_result_inst) begin
        mem_1_address_inst  <= "00000000000000000000000000000000";
        mem_2_address_inst  <= "00000000000000000000000000000000";
        mem_3_address_inst  <= "00000000000000000000000000000000";
        mem_4_address_inst  <= "00000000000000000000000000000000";
        o_inst_data         <= "00000000000000000000000000000000";

        case inst_address_mask is
            when "00" =>
                mem_1_address_inst <= inst_address_0;
                mem_2_address_inst <= inst_address_0;
                mem_3_address_inst <= inst_address_0;
                mem_4_address_inst <= inst_address_0;
                o_inst_data <= mem_4_result_inst & mem_3_result_inst & mem_2_result_inst & mem_1_result_inst;
            when "01" =>
                mem_1_address_inst <= inst_address_1;
                mem_2_address_inst <= inst_address_0;
                mem_3_address_inst <= inst_address_0;
                mem_4_address_inst <= inst_address_0;
                o_inst_data <= mem_1_result_inst & mem_4_result_inst & mem_3_result_inst & mem_2_result_inst;
            when "10" =>
                mem_1_address_inst <= inst_address_1;
                mem_2_address_inst <= inst_address_1;
                mem_3_address_inst <= inst_address_0;
                mem_4_address_inst <= inst_address_0;
                o_inst_data <= mem_2_result_inst & mem_1_result_inst & mem_4_result_inst & mem_3_result_inst;
            when "11" =>
                mem_1_address_inst <= inst_address_1;
                mem_2_address_inst <= inst_address_1;
                mem_3_address_inst <= inst_address_1;
                mem_4_address_inst <= inst_address_0;
                o_inst_data <= mem_3_result_inst & mem_2_result_inst & mem_1_result_inst & mem_4_result_inst;
        end case;
    end process;


    -- Define Byte-Memory-Blocks

    mem_1 : entity work.memory_byte(a_memory_byte)
    generic map(
        size_in_bytes   => size_in_words,
		init_filename	=> init_filename_1
    )
    port map(
        address_data	=> mem_1_address_data,
		address_inst	=> mem_1_address_inst,
		clock			=> i_clock,
		input_data		=> mem_1_input_data,
		wren_data		=> i_read_write,
		res_data		=> mem_1_result_data,
		res_inst		=> mem_1_result_inst
    );

    mem_2 : entity work.memory_byte(a_memory_byte)
    generic map(
        size_in_bytes   => size_in_words,
		init_filename	=> init_filename_2
    )
    port map(
        address_data	=> mem_2_address_data,
		address_inst	=> mem_2_address_inst,
		clock			=> i_clock,
		input_data		=> mem_2_input_data,
		wren_data		=> i_read_write,
		res_data		=> mem_2_result_data,
		res_inst		=> mem_2_result_inst
    );

    mem_3 : entity work.memory_byte(a_memory_byte)
    generic map(
        size_in_bytes   => size_in_words,
		init_filename	=> init_filename_3
    )
    port map(
        address_data	=> mem_3_address_data,
		address_inst	=> mem_3_address_inst,
		clock			=> i_clock,
		input_data		=> mem_3_input_data,
		wren_data		=> i_read_write,
		res_data		=> mem_3_result_data,
		res_inst		=> mem_3_result_inst
    );

    mem_4 : entity work.memory_byte(a_memory_byte)
    generic map(
        size_in_bytes   => size_in_words,
		init_filename	=> init_filename_4
    )
    port map(
        address_data	=> mem_4_address_data,
		address_inst	=> mem_4_address_inst,
		clock			=> i_clock,
		input_data		=> mem_4_input_data,
		wren_data		=> i_read_write,
		res_data		=> mem_4_result_data,
		res_inst		=> mem_4_result_inst
    );

end a_memory_word;