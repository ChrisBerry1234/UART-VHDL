# UART-VHDL

UART is a Asynchronous Parallel Communication protocol that allows the transfer of data between a transmitter and receiver with different crystal clocks but similar baud rates.

**Baud Rate(BR) is a common data rate between Tx and Rx and is 1/Tb(bit period). Bit period defining how long a bit occupies data line**
Common Baud Rates include 
- 9600 bps
- 192000 bps
- 38400 bps
- 57600 bps
- 115200 bps

  
Will design FSM with control signals and state machine 
- FSM will decide based on control signals when to load TXSHIFT from TXBUF
- When to start shifting data to RX
- When transmission is complete
- When flags should be asserted
-   -  inputs to FSM:
         - tx_start(BASED ON INTERRUPT FLAG OR INTERRUPT)(FOR PRACTICE WE CAN DO 
         - tx_buf_empty(UCTXIFG)
         - baud_tick
         - tx_shift_done(UCTXCPTIFG)
     - OUTPUTS TO FSM
     -   - load_txbuf — latch new data into TXBUF

load_txshift — copy TXBUF → TXSHIFT

shift_en — enable shifting on each baud_tick

tx_line — actual UART TX output

tx_busy — high while sending


When Framing the UART
- Framing describes the arrangement of bits within the UART transfar including adding specific bits of information to describe how bits are arranged in the bit sequence.

- When transmitter is pulled high for a period of time, receiver knows it will receive nothing(IDLE)
- First High to Low transition signifies the start of the frame. Keeps it low for a bit period to alert receiver. You will be receiving data soon.
- After the data sent, the channel returns to a HIGH for one Tb to signal end of data transmission.

- We will denote these by the states:
- IDLE (data high)
- START (draw low)
- DATA (transmit data)
- END (draw data high)
