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
    
    load_txbuf    : out std_logic;  --load new data into TXBUF
    send_data     : out std_logic;  --load data from TXBUF to TXSHIFT
    shift_en      : out std_logic;  --enable shifting on each baud_tick
    tx_line       : out std_logic;  --UART TX output
    tx_busy       : out std_logic  --high while sending
  );
end tx_state_machine;

architecture rtl of tx_state_machine is 
  --declarations
  type state_type is (IDLE, START, DATA, END);
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

    NEXT_STATE_LOGIC : process(current_state, tx_start, tx_buf_empty, tx_shift_done, baud_tick)
              begin
              --FSM Traversal, must know what state we are currently in
              case(current_state) is
                when(IDLE) =>
                  if 
                when(START) =>
                when(DATA) =>
                when(END) =>
              end case;
    end process

