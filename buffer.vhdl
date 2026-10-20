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
    tx_shift_done: in std_logic
  );
end tx_buffer;

architecture rtl of tx_buffer is
  --declarations
  signal tx_buffer : std_logic_vector(7 downto 0);
  --signal to see if internal buffer is empty
  signal tx_empty_sig : std_logic; -- '0' is full, '1' is empty 

  -- Drive output port from our internal tracking register
  tx_buf_empty <= tx_empty_sig;

  BUFFER : process(clk, reset)
    begin 
      if (reset = '1') then 
        tx_buffer    <= (others => '0');
        data_out     <= (others => '0');
        tx_empty_sig <= '1'; --TX BUFFER IS EMPTY 
        
      elsif (rising_edge(clk)) then
       --check if buffer currently has data before trying to shift new data in 
        if(send_data = '1' and tx_empty_sig = '0' and tx_shift_done = '1') then
          data_out <= tx_buffer; 
          tx_empty_sig = '1';

          -- UART is asynchronous so while data is shifting out, new data can also be shifted in
          if (load_txbuf = '1') then
            tx_buffer <= data_in;
            tx_empty_sig = '0';
          end if; 

        --if buffer is empty and there is no data to shift out, load new data in on rising edge 
        elsif (load_txbuf = '1' and tx_empty_sig = '1') then 
        
          -- Immediate forward if shift register is ready to work 
          if (send_data = '1' and tx_shift_done = '1') then
            data_out <= tx_buffer;
            tx_empty_sig = '1';
          else 
            --just load buffer with new data
            tx_buffer <= data_in;
            tx_empty_sig <= '0';
          end if;
        end if;
      end if;
  end process; 
        
  
