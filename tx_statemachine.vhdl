library ieee;
use ieee.std_logic_1164.all

entity tx_state_machine is 
  port (
    tx_start      : in std_logic;    
    tx_buf_empty  : in std_logic;   --interrupt for when buffers empty and can load new data
    tx_shift_done : in std_logic;   --interrupt for when data has been shifted out and we can load new data into buffer
    baud_tick     : in std_logic; 
    clock         : in std_logic;
    reset         : in std_logic; 
    tx_data_in    : in std_logic_vector(7 downto 0);  
    
    load_txbuf    : out std_logic := 0;  --load new data into TXBUF
    send_data     : out std_logic := 0;  --load data from TXBUF to TXSHIFT
    shift_en      : out std_logic := 0;  --enable shifting on each baud_tick
    tx_line       : out std_logic := 0;  --UART TX output
    tx_busy       : out std_logic := 0   --high while sending
  );
end tx_state_machine;

architecture rtl of tx_state_machine is 
  --declarations
  type state_type is (IDLE, START, DATA, STOP);
  signal next_state, current_state : state_type;

  begin 

    STATE_MEMORY: process(Clock, Reset)
            begin 
                if (Reset = '1')
                    current_state <= S_FETCH_0;
                elsif (rising_edge(Clock))
                    current_state <= next_state; 
                end if;
    end process;

    NEXT_STATE_LOGIC : process(current_state, tx_start, tx_shift_done, baud_tick)
              begin
              --FSM Traversal, must know what state we are currently in
              case(current_state) is
                when(IDLE) =>
                  if tx_start = '1' and tx_buf_empty = '0' then 
                    -- Wait for the baud tick to signify the end of the start bit period
                    next_state <= START;
                  else 
                    next_state <= IDLE; 
                when(START) =>
                  if baud_tick = '1' then
                    next_state <= DATA;
                  else 
                    next_state <= START;
                when(DATA) =>
                  if tx_shift_done = '1' then
                    next_state <= STOP; 
                  else 
                    next_state <= DATA;
                when(STOP) =>
                  -- Wait for the stop bit period to complete via the baud tick
                  if baud_tick = '1' then
                    next_state <= IDLE; -- transmission is complete
                  else 
                    next_state <= STOP;                    
                when(other) =>
                    next_state <= IDLE; 
              end case;
    end process


  OUTPUT_LOGIC: process(current_state)
            begin
              case(current_state) is 
                when (IDLE) =>
                  send_data <= '0';
                  shift_en <= '0';
                  tx_busy  <= '0';
                  tx_line <= '1'; 
                  tx_busy <= '0';
                  load_txbuf <= '1'
                when (START) => 
                    send_data <= '0';
                    shift_en <= '0';
                    tx_busy  <= '1';
                    tx_line <= '0'; -- Draw Start Bit Low Receiver knows to expect data
                    load_txbuf <= '0';
                  end if;
                when (DATA) =>
                  send_data <= '1';
                  shift_en <= baud_tick; -- to avoid shifting whenever, we only want data sent on baud tick so
                  tx_busy  <= '1';
                  tx_line <= data_in; 
                  load_txbuf <= '0';
                  --txline needs to shift out data
                when (END) =>
                  tx_busy <= '0';
                  send_data <= '0';
                  shift_en <= '0';
                  load_txbuf <= '0';
                  tx_line <= '1';
              end case;
end process;
end architecture;
                  
                  
                
                  
                
                  
                
                

