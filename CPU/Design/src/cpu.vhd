library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.types.all;
use work.utils.all;

entity cpu is
  port (
    i_clock : in std_logic;
    --i_reset : in std_logic;

    leds    : out std_logic_vector(7 downto 0);
    uart_rx : in std_logic;
    uart_tx : out std_logic
  );
end cpu;

architecture a_cpu of cpu is
  signal i_reset : std_logic := '1';
  -- DECODE
  signal decode_alu_mode           : T_ALU_MODE;
  signal decode_mux_alu_mode       : T_MUX_ALU;
  signal decode_imm                : std_logic_vector(31 downto 0);
  signal decode_comparator_mode    : T_COMP_MODE;
  signal decode_rs1_address        : std_logic_vector(4 downto 0);
  signal decode_rs2_address        : std_logic_vector(4 downto 0);
  signal decode_rd_address         : std_logic_vector(4 downto 0);
  signal decode_mux_register_mode  : T_MUX_REG;
  signal decode_sign_extender_mode : T_SEXT_MEM_MODE;
  signal decode_store_mode         : T_STORE_MODE;
  signal decode_mem_read_write     : T_MEM_DIR;
  signal decode_pc_mode            : T_PC_MODE;

  -- ALU    
  signal alu_result : std_logic_vector(31 downto 0);

  -- REGISTER
  signal register_rs1 : std_logic_vector(31 downto 0);
  signal register_rs2 : std_logic_vector(31 downto 0);

  -- PC
  signal pc_current  : std_logic_vector(31 downto 0);
  signal pc_next     : std_logic_vector(31 downto 0);
  signal pc_mem_inst : std_logic_vector(31 downto 0);

  -- MUX_ALU_LEFT
  signal mux_alu_left_data : std_logic_vector(31 downto 0);

  -- MUX_ALU_RIGHT
  signal mux_alu_right_data : std_logic_vector(31 downto 0);

  -- COMPARATOR
  signal comparator_result : std_logic;

  -- MUX_REGISTER
  signal mux_register_rd_data : std_logic_vector(31 downto 0);

  -- SIGN_EXTENDER_MEM
  signal sign_extender_mem_data : std_logic_vector(31 downto 0);

  -- MEMORY
  signal memory_data : std_logic_vector(31 downto 0);
  signal memory_inst : std_logic_vector(31 downto 0);

begin

  --leds <= memory_inst(7 downto 0);
  alu : entity work.alu(a_alu) port map (
    i_alu_mode => decode_alu_mode,
    i_left     => mux_alu_left_data,
    i_right    => mux_alu_right_data,
    o_result   => alu_result
    );

  mux_alu_left : entity work.mux_alu_left(a_mux_alu_left) port map (
    i_mode => decode_mux_alu_mode,
    i_rs1  => register_rs1,
    i_pc   => pc_current,
    o_data => mux_alu_left_data
    );

  mux_alu_right : entity work.mux_alu_right(a_mux_alu_right) port map (
    i_mode => decode_mux_alu_mode,
    i_rs2  => register_rs2,
    i_imm  => decode_imm,
    o_data => mux_alu_right_data
    );

  comparator : entity work.comparator(a_comparator) port map (
    i_comparator_mode => decode_comparator_mode,
    i_left            => register_rs1,
    i_right           => register_rs2,
    o_result          => comparator_result
    );

  registers : entity work.registers(a_registers) port map (
    i_clock                   => i_clock,
    i_reset                   => i_reset,
    i_read_register_1_address => decode_rs1_address,
    o_read_register_1_data    => register_rs1,
    i_read_register_2_address => decode_rs2_address,
    o_read_register_2_data    => register_rs2,
    i_write_register_address  => decode_rd_address,
    i_write_register_data     => mux_register_rd_data
    );

  mux_register : entity work.mux_register(a_mux_register) port map (
    i_mode => decode_mux_register_mode,
    i_alu  => alu_result,
    i_mem  => sign_extender_mem_data,
    i_pc   => pc_next,
    o_data => mux_register_rd_data
    );

  sign_extender_mem : entity work.sign_extender_mem(a_sign_extender_mem) port map (
    i_mode => decode_sign_extender_mode,
    i_data => memory_data,
    o_data => sign_extender_mem_data
    );

  memory : entity work.memory(a_memory) port map (
    i_clock => i_clock,
    i_reset => i_reset,

    i_inst_address    => pc_mem_inst,
    o_inst            => memory_inst,
    i_data_address    => alu_result,
    i_data            => register_rs2,
    i_data_read_write => decode_mem_read_write,
    i_data_store_mode => decode_store_mode,
    o_data            => memory_data,

    o_leds => leds,
    i_rx   => uart_rx,
    o_tx   => uart_tx
    );

  pc : entity work.pc(a_pc) port map (
    i_clock    => i_clock,
    i_reset    => i_reset,
    i_mode     => decode_pc_mode,
    i_comp     => comparator_result,
    i_src_alu  => alu_result,
    i_src_next => pc_next,
    o_current  => pc_current,
    o_next     => pc_next,
    o_mem_addr => pc_mem_inst
    );

  decode : entity work.decode(a_decode) port map (
    i_instruction   => memory_inst,
    o_comp_mode     => decode_comparator_mode,
    o_alu_mode      => decode_alu_mode,
    o_mux_alu       => decode_mux_alu_mode,
    o_immediate     => decode_imm,
    o_rs1_addr      => decode_rs1_address,
    o_rs2_addr      => decode_rs2_address,
    o_rd_addr       => decode_rd_address,
    o_mux_reg       => decode_mux_register_mode,
    o_sext_mem_mode => decode_sign_extender_mode,
    o_mem_dir       => decode_mem_read_write,
    o_store_mode    => decode_store_mode,
    o_pc_mode       => decode_pc_mode
    );

end architecture;