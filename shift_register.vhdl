library ieee;
use iee.std_logic_1164.all;

entity tx_shift_register is
  port (
    clk          : in std_logic;
    tx_data_out  : out std_logic_vector(7 downto 0);
    reset        : in std_logic;
    baud_tick    : in std_logic; 
    shift_en     : in std_logic; 
    tx_busy      : out std_logic; 
    tx_shift_done: out std_logic;
  )
end tx_shift_register;

--BUFFER HAS ALREADY LOADED DATA INTO SHIFT REGISTER, WE ARE FOCUSED NOW ON SHIFTING IT OUT
architecture rtl of tx_shift_register is 
  --declarations
  --shift include 8 dffs
  signal tx_shift_register : std_logic_vector(7 downto 0);
  --bit counter will not include any other 
  signal bit_counter : integer range 0 to 10 := 0;

  SHIFT : process(clk, reset)
    begin 
      if reset = '1' then 
        r_shift_reg <= (others => '1');
        bit_counter <= '0';
        tx_shift_done <= '0';
        
      elsif rising_edge(clk) then 
        if (shift_en = '1' and baud_tick = '1') then
          --Load data with start bit 0 and stop bit 1
          tx_shift_register <= '1' & data_in & '0';
          if bit_counter = 9 then 
            
          
          
        
        
