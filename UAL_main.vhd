library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top_Level is
    Port ( clk_100MHz : in STD_LOGIC;
           reset       : in STD_LOGIC;
           sensor1     : in STD_LOGIC;
           sensor2     : in STD_LOGIC;
           RYG1        : out STD_LOGIC_VECTOR(2 downto 0);
           RYG2        : out STD_LOGIC_VECTOR(2 downto 0));
end Top_Level;

architecture Structural of Top_Level is
    -- Instantiation of internal signals
    signal slow_clk, time_up : STD_LOGIC;
    signal set_time : INTEGER;
    signal load_time : STD_LOGIC;

    component Frequency_Divider
        Port ( clk_in  : in  STD_LOGIC;
               reset   : in  STD_LOGIC;
               clk_out : out STD_LOGIC);
    end component;

    component Timer
        Port ( clk         : in  STD_LOGIC;
               reset       : in  STD_LOGIC;
               set_time    : in  INTEGER;
               load        : in  STD_LOGIC;
               time_up     : out STD_LOGIC);
    end component;

    component Traffic_Controller
        Port ( clk       : in  STD_LOGIC;
               reset     : in  STD_LOGIC;
               sensor1   : in  STD_LOGIC;
               sensor2   : in  STD_LOGIC;
               time_up   : in  STD_LOGIC;
               RYG1      : out STD_LOGIC_VECTOR(2 downto 0);
               RYG2      : out STD_LOGIC_VECTOR(2 downto 0));
    end component;

    -- Instances of components
    Clk_Div: Frequency_Divider Port Map (
        clk_in => clk_100MHz,
        reset => reset,
        clk_out => slow_clk
    );

    Timer_Instance: Timer Port Map (
        clk => slow_clk,
        reset => reset,
        set_time => set_time,
        load => load_time,
        time_up => time_up
    );

    Controller: Traffic_Controller Port Map (
        clk => slow_clk,
        reset => reset,
        sensor1 => sensor1,
        sensor2 => sensor2,
        time_up => time_up,
        RYG1 => RYG1,
        RYG2 => RYG2
    );

begin
    -- Logique pour déterminer les valeurs du minuteur
    process(slow_clk, reset)
    begin
        if rising_edge(slow_clk) then
            if reset = '1' then
                set_time <= 30; -- Default value
                load_time <= '1'; -- Load on reset
            else
               
                if (current_state = GREEN1) then
                    if (sensor1 = '1' and sensor2 = '0') then
                        set_time <= 40; -- Traffic heavy on sensor1
                    else
                        set_time <= 30;
                    end if;
                    load_time <= '1';
                elsif (current_state = RED1) then
                    set_time <= 25; -- Example timing for RED state
                    load_time <= '1';
                else
                    load_time <= '0';
                end if;
            end if;
        end if;
    end process;
end Structural;
