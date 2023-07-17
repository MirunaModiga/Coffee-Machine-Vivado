library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity coffee_machine_tb is
end coffee_machine_tb;

architecture test of coffee_machine_tb is
    -- Component declaration for the coffee_machine
    component coffee_machine is
        Port ( 
            -- Inputs
            coin_in   : in  std_logic;  -- Signal for introducing coins
            drink_sel : in  std_logic_vector(2 downto 0);  -- Signal for selecting a drink
            reset_in  : in  std_logic;  -- Signal for resetting the balance
            clock     : in  std_logic; --clock signal
            -- Outputs
            anodes:inout std_logic_vector(7 downto 0);
            Segments : out std_logic_vector(7 downto 0);  -- BCD display for the balance and countdown timer
            led_idle        : out std_logic;  -- LED for idle state
            led_preparing   : out std_logic;  -- LED for preparing state
            led_insufficient : out std_logic   -- LED for insufficient balance state
        );
    end component;
    
    -- Input signals
    signal coin_in   : std_logic;
    signal drink_sel : std_logic_vector(2 downto 0);
    signal reset_in  : std_logic;
    signal clock     : std_logic;
    
    -- Output signals
    signal anodes:std_logic_vector(7 downto 0);
    signal Segments : std_logic_vector(7 downto 0);
    signal led_idle        : std_logic;
    signal led_preparing   : std_logic;
    signal led_insufficient : std_logic;
    
    -- Clock period for simulation
    constant clock_period : time := 50 ns;
begin
    -- Instantiate the coffee_machine
    uut: coffee_machine
        port map (
            coin_in   => coin_in,
            drink_sel => drink_sel,
            reset_in  => reset_in,
            clock     => clock,
            anodes    => anodes,
            Segments   => Segments,
            led_idle  => led_idle,
            led_preparing   => led_preparing,
            led_insufficient => led_insufficient
        );
        
    -- Clock process
    clk_process : process
    begin
        clock <= '0';
        wait for clock_period/2;
        clock <= '1';
        wait for clock_period/2;
    end process;
    
    -- Stimulus process
    stim_process : process
    begin
        -- Initial reset
        reset_in <= '1';
        wait for clock_period;
        reset_in <= '0';
        
        -- Insert a coin
        coin_in <= '1';
        wait for clock_period;
        coin_in <= '0';
        
        coin_in <= '1';
        wait for clock_period;
        coin_in <= '0';
        
        coin_in <= '1';
        wait for clock_period;
        coin_in <= '0';
        
        -- Insert another coin
        coin_in <= '1';
        wait for clock_period;
        coin_in <= '0';
        
        -- Select Tea
        drink_sel <= "011";
        wait for clock_period;
        
        -- Wait for countdown to finish
        while (led_preparing = '1') loop
            wait for clock_period;
        end loop;
        
        -- Reset the machine
        reset_in <= '1';
        wait for clock_period;
        reset_in <= '0';
        
        wait;
    end process;
end test;
