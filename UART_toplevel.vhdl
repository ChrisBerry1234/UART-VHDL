library ieee;
use ieee.std_logic_1164.all;

entity UART_TOP_LEVEL is 
  port(
    clk           : in std_logic;
    reset         : in std_logic; 
    
    data_in       : in std_logic_vector(7 downto 0);
    tx_data_out   : out std_logic_vector(7 downto 0);
    
    --Control Signals
    send_data     : in std_logic; 
    shift_en      : in std_logic;
    load_txbuf    : in std_logic;
    
    -- Status Signals 
    tx_busy       : out std_logic; 
    tx_shift_done : out std_logic; 
    tx_buf_empty  : in std_logic;

  );
end entity;

architecture rtl of UART_TOP_LEVEL is
  --declarations

  begin 

  TX_DATA_TRANSMIT : entity work.tx_data_path
    port map (
      clk           
      reset        
      data_in       
      send_data     
      shift_en      
      tx_data_out   
      tx_busy       
      tx_shift_done 
      baud_tick     
      tx_buf_empty  
      load_txbuf    
    )
