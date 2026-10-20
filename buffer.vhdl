library IEEE;
use IEEE.std_logic_1164.all;

entity tx_buffer is 
  port (
    load_txbuf   : in std_logic; --load new data into TXBUF
    send_data    : in std_logic; --load data from TXBUF to TXSHIFT through signal data_out
    clk          : in std_logic;
    reset        : in std_logic; 
    data_in      : in std_logic_vector(7 downto 0);
    data_out     : out std_logic_vector(7 downto 0); --OUTPUT DATA THAT WILL BE FED INTO SHIFT REGISTER
    tx_buf_empty : out std_logic; --SIGNAL CONTROL SIGNAL THAT BUFFER IS EMPTY
    tx_shift_done      : in std_logic
  );
end tx_buffer;

architecture rtl of tx_buffer is
  --declarations
  signal tx_buffer : std_logic_vector(7 downto 0);

  BUFFER : process(clk, reset)
    begin 
      if (reset = '1') then 
        tx_buffer    <= (others => '0');
        tx_buf_empty <= '1'; --TX BUFFER IS EMPTY
        
      if (rising_edge(clk) then
          
       --check if buffer currently has data
        if(send_data = '1' and tx_buf_empty <= '0') then
          data_out <= tx_buffer; 
          tx_buf_empty = '1';
          -- UART is asynchronous so while data is shifting out, new data can also be shifted in
          if load_txbuf = '1' then
            tx_buffer <= data_in;
            tx_buf_empty = '0';
          else 
            tx_buf_empty = '1'; 
        elsif (load_txbuf = '1' and tx_buf_empty = '1') then 
          tx_buffer <= data_in;
          tx_buf_empty <= '0';
          if (send_data = '1' and tx_shift_done) then
            data_out <= tx_buffer;
            tx_buf_empty <= '1';
          end if;
        end if;
      end if;
  end process; 
        
  
