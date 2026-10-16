library ieee;
use ieee.std_logic_1164.all;

entity baud_generator is
    generic (
        CLK_FREQ_HZ : positive := 50_000_000;
        SMCLK_HZ    : positive := 1_000_000;
        ACLK_HZ     : positive := 32_768;
        BAUD_1      : positive := 9_600;
        BAUD_2      : positive := 19_200;
        BAUD_3      : positive := 57_600;
        BAUD_4      : positive := 115_200
    );
    port (
        i_SMCLK   : in  std_logic;
        i_ACLK    : in  std_logic;
        i_CLK     : in  std_logic;
        clk_sel   : in  std_logic_vector(1 downto 0);
        baud_sel  : in  std_logic_vector(1 downto 0);
        i_Reset   : in  std_logic;
        baud_tick : out std_logic
    );
end entity baud_generator;

architecture rtl of baud_generator is

    -- Declarations
    signal clk_select : std_logic;
    signal clk_freq   : positive;
    signal baud_rate  : positive;

    signal clocks_per_bit : positive;
    signal prescaler_count : natural := 0;
    signal baud_tick_reg   : std_logic := '0';

begin

    -- Clock selection
    clk_sel_proc : process(clk_sel, i_CLK, i_SMCLK, i_ACLK)
        begin
            case clk_sel is
                when "00" =>
                    clk_select <= i_CLK;
                when "01" =>
                    clk_select <= i_SMCLK;
                when "10" =>
                    clk_select <= i_ACLK;
                when others =>
                    clk_select <= i_CLK;
            end case;
    end process;

    -- Selected clock frequency
    clk_freq_proc : process(clk_sel)
        begin
            case clk_sel is
                when "00" =>
                    clk_freq <= CLK_FREQ_HZ;
                when "01" =>
                    clk_freq <= SMCLK_HZ;
                when "10" =>
                    clk_freq <= ACLK_HZ;
                when others =>
                    clk_freq <= CLK_FREQ_HZ;
            end case;
    end process;

    -- Baud-rate selection
    baud_sel_proc : process(baud_sel)
        begin
            case baud_sel is
                when "00" =>
                    baud_rate <= BAUD_1;
                when "01" =>
                    baud_rate <= BAUD_2;
                when "10" =>
                    baud_rate <= BAUD_3;
                when "11" =>
                    baud_rate <= BAUD_4;
            end case;
    end process;

    -- determine prescalar value
    clocks_per_bit <= clk_freq / baud_rate;

    --now that we have clocks_per_bit, we can count up to our prescalar value
    tick : process(clk_select, i_Reset, clocks_per_bit)
        begin 
            if i_reset = '1' then 
                baud_tick_reg <= '0';
                prescaler_count <= '0';
            elsif rising_edge(clk_select) then 
                --check prescalar count
                if (prescalar_count = clocks_per_bit -1 ) then 
                    baud_tick_reg <= '1'; --set baud_tick_reg indicating when bit period has passed/finished
                    prescalar_count <= '0' --reset prescalar count
                elsif (prescalar_count <= clocks_per_bit -1) then 
                    prescalar_count <= prescalar_count + 1;
                    baud_tick_reg <= 0;
                end if;
            end if;
    end process; 

    -- output baud
    baud_tick <= baud_tick_reg;
        
end architecture rtl;
```
