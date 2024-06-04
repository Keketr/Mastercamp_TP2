library ieee;
use ieee.std_logic_1164.all;

entity clk_man is
    port(
        clkin: in std_logic;
        clkout : out std_logic
    );
end entity;

architecture clk_man_arch of clk_man is
begin   
    process(clkin) is
        variable cnt : natural range 0 to 100000000;
    begin
        if rising_edge(clkin) then
            clkout <= '0';
            cnt := cnt + 1;
            
            if cnt = 100000000 then
                cnt := 0;
                clkout <= '1';
            end if;
            
        end if;
    end process;
end architecture;