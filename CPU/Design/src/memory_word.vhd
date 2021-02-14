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
        i_clock_inst      : in	std_logic;
        i_clock_data      : in	std_logic;

        i_inst_address    : in std_logic_vector(15 downto 0);

        i_store_mode	  : in T_STORE_MODE;
        i_read_write      : in T_MEM_DIR;       
        i_data_address    : in std_logic_vector(15 downto 0);
        i_write_data      : in std_logic_vector(31 downto 0);

        o_inst_data       : out std_logic_vector(31 downto 0);
        o_read_data       : out std_logic_vector(31 downto 0)
    );

end memory_word;

architecture a_memory_word of memory_word is

    signal mem_1_address_data : std_logic_vector(13 downto 0);
    signal mem_1_address_inst : std_logic_vector(13 downto 0);
    signal mem_1_input_data : std_logic_vector(7 downto 0);
    signal mem_1_result_data : std_logic_vector(7 downto 0);
    signal mem_1_result_inst : std_logic_vector(7 downto 0);
    signal mem_1_write_enable : T_MEM_DIR;

    signal mem_2_address_data : std_logic_vector(13 downto 0);
    signal mem_2_address_inst : std_logic_vector(13 downto 0);
    signal mem_2_input_data : std_logic_vector(7 downto 0);
    signal mem_2_result_data : std_logic_vector(7 downto 0);
    signal mem_2_result_inst : std_logic_vector(7 downto 0);
    signal mem_2_write_enable : T_MEM_DIR;

    signal mem_3_address_data : std_logic_vector(13 downto 0);
    signal mem_3_address_inst : std_logic_vector(13 downto 0);
    signal mem_3_input_data : std_logic_vector(7 downto 0);
    signal mem_3_result_data : std_logic_vector(7 downto 0);
    signal mem_3_result_inst : std_logic_vector(7 downto 0);
    signal mem_3_write_enable : T_MEM_DIR;

    signal mem_4_address_data : std_logic_vector(13 downto 0);
    signal mem_4_address_inst : std_logic_vector(13 downto 0);
    signal mem_4_input_data : std_logic_vector(7 downto 0);
    signal mem_4_result_data : std_logic_vector(7 downto 0);
    signal mem_4_result_inst : std_logic_vector(7 downto 0);
    signal mem_4_write_enable : T_MEM_DIR;

    signal data_address_0 : std_logic_vector(13 downto 0);
    signal data_address_1 : std_logic_vector(13 downto 0);
    signal data_address_mask : std_logic_vector(1 downto 0);

    signal inst_address_0 : std_logic_vector(13 downto 0);
    signal inst_address_1 : std_logic_vector(13 downto 0);
    signal inst_address_mask : std_logic_vector(1 downto 0);

begin

    data_address_0 <= i_data_address(15 downto 2);
    data_address_1 <= std_logic_vector(unsigned(data_address_0) + 1);
    data_address_mask <= i_data_address(1 downto 0);

    calc_address : process(i_data_address, data_address_mask, data_address_0, data_address_1, mem_1_result_data, mem_2_result_data, mem_3_result_data, mem_4_result_data, i_write_data, i_store_mode, i_read_write) begin
        mem_1_address_data  <= (others => '0');
        mem_2_address_data  <= (others => '0');
        mem_3_address_data  <= (others => '0');
        mem_4_address_data  <= (others => '0');
        o_read_data         <= (others => '0');

        mem_1_input_data    <= (others => '0');
        mem_2_input_data    <= (others => '0');
        mem_3_input_data    <= (others => '0');
        mem_4_input_data    <= (others => '0');

        mem_1_write_enable  <= MEM_DIR_READ;
        mem_2_write_enable  <= MEM_DIR_READ;
        mem_3_write_enable  <= MEM_DIR_READ;
        mem_4_write_enable  <= MEM_DIR_READ;

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
                case i_store_mode is
                    when STORE_B =>
                        mem_1_write_enable <= i_read_write;
                    when STORE_H =>
                        mem_1_write_enable <= i_read_write;
                        mem_2_write_enable <= i_read_write;
                    when STORE_W =>
                        mem_1_write_enable <= i_read_write;
                        mem_2_write_enable <= i_read_write;
                        mem_3_write_enable <= i_read_write;
                        mem_4_write_enable <= i_read_write;
                end case;
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
                case i_store_mode is
                    when STORE_B =>
                        mem_2_write_enable <= i_read_write;
                    when STORE_H =>
                        mem_2_write_enable <= i_read_write;
                        mem_3_write_enable <= i_read_write;
                    when STORE_W =>
                        mem_2_write_enable <= i_read_write;
                        mem_3_write_enable <= i_read_write;
                        mem_4_write_enable <= i_read_write;
                        mem_1_write_enable <= i_read_write;
                end case;
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
                case i_store_mode is
                    when STORE_B =>
                        mem_3_write_enable <= i_read_write;
                    when STORE_H =>
                        mem_3_write_enable <= i_read_write;
                        mem_4_write_enable <= i_read_write;
                    when STORE_W =>
                        mem_3_write_enable <= i_read_write;
                        mem_4_write_enable <= i_read_write;
                        mem_1_write_enable <= i_read_write;
                        mem_2_write_enable <= i_read_write;
                end case;
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
                case i_store_mode is
                    when STORE_B =>
                        mem_4_write_enable <= i_read_write;
                    when STORE_H =>
                        mem_4_write_enable <= i_read_write;
                        mem_1_write_enable <= i_read_write;
                    when STORE_W =>
                        mem_4_write_enable <= i_read_write;
                        mem_1_write_enable <= i_read_write;
                        mem_2_write_enable <= i_read_write;
                        mem_3_write_enable <= i_read_write;
                end case;
                o_read_data <= mem_3_result_data & mem_2_result_data & mem_1_result_data & mem_4_result_data;
                when others => null;
        end case;
   end process;

    inst_address_0 <= i_inst_address(15 downto 2);
    inst_address_1 <= std_logic_vector(unsigned(inst_address_0) + 1);
    inst_address_mask <= i_inst_address(1 downto 0);

    calc_inst : process(inst_address_mask, inst_address_0, inst_address_1, mem_1_result_inst, mem_2_result_inst, mem_3_result_inst, mem_4_result_inst) begin
        mem_1_address_inst  <= (others => '0');
        mem_2_address_inst  <= (others => '0');
        mem_3_address_inst  <= (others => '0');
        mem_4_address_inst  <= (others => '0');
        o_inst_data         <= (others => '0');

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
            when others => null;
        end case;
    end process;


    -- Define Byte-Memory-Blocks

    mem_1 : entity work.memory_byte(a_memory_byte)
    generic map(
        size_in_bytes   => size_in_words,
		init_filename	=> init_filename_1
    )
    port map(
        i_address_data	=> mem_1_address_data,
		i_address_inst	=> mem_1_address_inst,
		i_clock_inst		=> i_clock_inst,
		i_clock_data		=> i_clock_data,
		i_input_data		=> mem_1_input_data,
		i_wren_data		=> mem_1_write_enable,
		o_res_data		=> mem_1_result_data,
		o_res_inst		=> mem_1_result_inst
    );

    mem_2 : entity work.memory_byte(a_memory_byte)
    generic map(
        size_in_bytes   => size_in_words,
		init_filename	=> init_filename_2
    )
    port map(
        i_address_data	=> mem_2_address_data,
		i_address_inst	=> mem_2_address_inst,
		i_clock_inst		=> i_clock_inst,
		i_clock_data		=> i_clock_data,
		i_input_data		=> mem_2_input_data,
		i_wren_data		=> mem_2_write_enable,
		o_res_data		=> mem_2_result_data,
		o_res_inst		=> mem_2_result_inst
    );

    mem_3 : entity work.memory_byte(a_memory_byte)
    generic map(
        size_in_bytes   => size_in_words,
		init_filename	=> init_filename_3
    )
    port map(
        i_address_data	=> mem_3_address_data,
		i_address_inst	=> mem_3_address_inst,
		i_clock_inst		=> i_clock_inst,
		i_clock_data		=> i_clock_data,
		i_input_data		=> mem_3_input_data,
		i_wren_data		=> mem_3_write_enable,
		o_res_data		=> mem_3_result_data,
		o_res_inst		=> mem_3_result_inst
    );

    mem_4 : entity work.memory_byte(a_memory_byte)
    generic map(
        size_in_bytes   => size_in_words,
		init_filename	=> init_filename_4
    )
    port map(
        i_address_data	=> mem_4_address_data,
		i_address_inst	=> mem_4_address_inst,
		i_clock_inst		=> i_clock_inst,
		i_clock_data		=> i_clock_data,
		i_input_data		=> mem_4_input_data,
		i_wren_data		=> mem_4_write_enable,
		o_res_data		=> mem_4_result_data,
		o_res_inst		=> mem_4_result_inst
    );

end a_memory_word;