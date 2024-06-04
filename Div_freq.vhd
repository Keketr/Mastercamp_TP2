library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Frequency_Divider is
    Port ( clk_in  : in  STD_LOGIC;
           reset   : in  STD_LOGIC;
           clk_out : out STD_LOGIC);
end Frequency_Divider;

architecture Behavioral of Frequency_Divider is
    constant DIVISOR : integer := 50000000;  
    signal count : integer range 0 to DIVISOR-1 := 0;
begin
    process(clk_in, reset)
    begin
        if reset = '1' then
            count <= 0;
            clk_out <= '0';
        elsif rising_edge(clk_in) then
            if count = DIVISOR-1 then
                count <= 0;
                clk_out <= not clk_out;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
end Behavioral;
