library ieee;
use ieee.std_logic_1164.all;

entity tx_data_path is 
  port (
    clk           : in std_logic;
    reset         : in std_logic; 
    data_in       : in std_logic_vector(7 downto 0);
    send_data     : in std_logic; 
    shift_en      : in std_logic;
    tx_data_out   : out std_logic_vector(7 downto 0);
    tx_busy       : out std_logic; 
    tx_shift_done : out std_logic; 
    baud_tick     : in std_logic;
    tx_buf_empty  : in std_logic;
    load_txbuf    : in std_logic
  );
end tx_data_path;

architecture rtl of tx_data_path is 
  --declarations
  signal tx_buffer_to_shift : std_logic_vector(9 downto 0);

  begin 
    TX_BUFFER : entity work.tx_buffer 
      port map (
        clk             => clk,
        reset           => reset, 
        data_out        => tx_buffer_to_shift,
        data_in         => data_in,
        tx_buf_empty    => tx_buf_empty,
        load_txbuf      => load_txbuf
      );
      
    SHIFT_REGISTER : entity work.tx_shift_register
      port map (
          clk           => clk,
          tx_data_out   => tx_data_out,
          reset         => reset,
          baud_tick     => baud_tick,
          data_in       => tx_buffer_to_shift,
          send_data     => send_data, 
          shift_en      => shift_en, 
          tx_busy       => tx_busy, 
          tx_shift_done => tx_shift_done, 
          tx_data_out   => tx_data_out
      );
      
end architecture;
