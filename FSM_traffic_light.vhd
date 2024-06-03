library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Traffic_Controller is
    Port ( clk       : in  STD_LOGIC;
           reset     : in  STD_LOGIC;
           sensor1   : in  STD_LOGIC;  -- S1
           sensor2   : in  STD_LOGIC;  -- S2
           time_up   : in  STD_LOGIC;
           RYG1      : out STD_LOGIC_VECTOR(2 downto 0);
           RYG2      : out STD_LOGIC_VECTOR(2 downto 0));
end Traffic_Controller;

architecture Behavioral of Traffic_Controller is
    type state_type is (INIT, GREEN1, YELLOW1, RED1, GREEN2, YELLOW2, RED2, WAIT_SENSORS);
    signal current_state, next_state : state_type := INIT;

    -- Signals for sensor input processing
    signal sensor1, sensor2 : STD_LOGIC;
    signal timer_value : integer;  -- Assume this is managed externally

begin
    state_logic: process(current_state, sensor1, sensor2, time_up)
    begin
        case current_state is
            when INIT =>
                next_state <= GREEN1;

            when GREEN1 =>
                if time_up = '1' then
                    next_state <= YELLOW1;
                end if;

            when YELLOW1 =>
                if time_up = '1' then
                    next_state <= RED1;
                end if;

            when RED1 =>
                if time_up = '1' then
                    if sensor1 = '1' and sensor2 = '0' then
                        next_state <= GREEN1;
                    else
                        next_state <= WAIT_SENSORS;
                    end if;
                end if;

            when WAIT_SENSORS =>
                if sensor1 = '0' and sensor2 = '1' then
                    next_state <= GREEN2;
                elsif sensor1 = '1' and sensor2 = '0' then
                    next_state <= GREEN1;
                end if;

            when GREEN2 =>
                if time_up = '1' then
                    next_state <= YELLOW2;
                end if;

            when YELLOW2 =>
                if time_up = '1' then
                    next_state <= RED2;
                end if;

            when RED2 =>
                if time_up = '1' then
                    next_state <= GREEN1;
                end if;

            when others =>
                next_state <= INIT;
        end case;
    end process;

    state_update: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= INIT;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    -- Output logic for traffic lights
    output_logic: process(current_state)
    begin
        case current_state is
            when GREEN1 =>
                RYG1 <= "100";  -- Green
                RYG2 <= "001";  -- Red
            when YELLOW1 =>
                RYG1 <= "010";  -- Yellow
                RYG2 <= "001";  -- Red
            when RED1 =>
                RYG1 <= "001";  -- Red
                RYG2 <= "100";  -- Green
            when GREEN2 =>
                RYG1 <= "001";  -- Red
                RYG2 <= "100";  -- Green
            when YELLOW2 =>
                RYG1 <= "001";  -- Red
                RYG2 <= "010";  -- Yellow
            when RED2 =>
                RYG1 <= "100";  -- Green
                RYG2 <= "001";  -- Red
            when others =>
                RYG1 <= "001";  -- Default to Red
                RYG2 <= "001";  -- Default to Red
        end case;
    end process;

end Behavioral;

