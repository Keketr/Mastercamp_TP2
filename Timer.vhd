library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Timer is
    Port ( clk         : in  STD_LOGIC;
           reset       : in  STD_LOGIC;
           set_time    : in  INTEGER;
           load        : in  STD_LOGIC;
           time_up     : out STD_LOGIC);
end Timer;

architecture Behavioral of Timer is
    signal timer_val : INTEGER := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            timer_val <= 0;
            time_up <= '0';
        elsif rising_edge(clk) then
            if load = '1' then
                timer_val <= set_time;
                time_up <= '0';
            elsif timer_val > 0 then
                timer_val <= timer_val - 1;
                time_up <= '0';
            elsif timer_val = 0 then
                time_up <= '1';
            end if;
        end if;
    end process;
end Behavioral;
