
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity coffee_machine is
  Port ( 
        coin_in   : in  std_logic;  
        drink_sel : in  std_logic_vector(2 downto 0);  
        reset_in  : in  std_logic;  
        clock     : in  std_logic; 
       
        Segments:out std_logic_vector(7 downto 0);
        anodes:inout std_logic_vector(7 downto 0); -- BCD display for the balance and countdown timer
        led_idle        : out std_logic;  
        led_preparing   : out std_logic;  
        led_insufficient : out std_logic   
    
  );
end coffee_machine;

architecture Behavioral of coffee_machine is
    constant americano_cost   : integer := 3;
    constant americano_time    : integer := 5;
    constant cappucino_cost   : integer := 4;
    constant cappucino_time    : integer := 7;
    constant tea_cost         : integer := 2;
    constant tea_time          : integer := 4;
    
    signal balance          : integer := 0;  
    signal preparing        : std_logic:='0';     
    signal insufficient     : std_logic:='0';     
    --signal insufficient_led_control : std_logic;
    signal insufficient_countdown_timer : integer:=5; 
    signal countdown_active : std_logic:='0';     
    signal countdown_value  : integer:=0;       
    signal display : std_logic_vector(3 downto 0):="0000";
    
    signal slowClk: std_logic:='0';
    signal careBCD: integer:= 0;
    signal count: integer:=0;
begin
generareSlowClk:process(clock)
    begin
        if rising_edge(clock) then
            count<=count+1;
            if count > 150000 then
                count<=0;
                slowClk<= not slowClk;
            end if;
        end if;
    end process;

-- Process for handling the introduction of coins
    process (slowClk,drink_sel,coin_in, reset_in)
        variable lastValCoinIn: std_logic:='0';
        variable nrCountdown: integer:=0;
    begin
    if(rising_edge(slowClk)) then
        if (reset_in = '1') then
            preparing<='0';
            balance <= 0;
            countdown_active<='0';
            insufficient<='0';
        elsif (coin_in = '1' and lastValCoinIn ='0') then
            balance <= balance + 1;
        end if; 
        if coin_in = '1' then
            lastValCoinIn:= '1';
        else
            lastValCoinIn := '0';
        end if;
       if(preparing/='1' and insufficient/='1' and countdown_active/='1') then
        case drink_sel is
            when "000" =>  -- No drink selected
                null;
            when "001" =>  -- Americano selected
                if (balance >= americano_cost) then
                    balance <= balance - americano_cost;
                    countdown_value <= americano_time;
                    countdown_active <= '1';
                    preparing <= '1';
                    nrCountdown:= 0;
                else
                    insufficient <= '1';
                end if;
            when "010" =>  -- Cappucino selected
                if (balance >= cappucino_cost) then
                    balance <= balance - cappucino_cost;
                    countdown_value <= cappucino_time;
                    countdown_active <= '1';
                    preparing <= '1';
                    nrCountdown:= 0;
                else
                    insufficient <= '1';
                end if;
            when "100" =>  -- Tea selected
                if (balance >= tea_cost) then
                    balance <= balance - tea_cost;
                    countdown_value <= tea_time;
                    countdown_active <= '1';
                    preparing <= '1';
                    nrCountdown:= 0;
                else
                    insufficient <= '1';
                end if;
            when others =>  -- Invalid selection
                null;
        end case;
        end if;
        if (countdown_active = '1' and countdown_value > 0) then
            nrCountdown:=nrCountdown+1;
            if nrCountdown = 50000000/150000 then
                countdown_value <= countdown_value - 1;
                nrCountdown:= 0;
            end if;
        elsif (countdown_active = '1' and countdown_value = 0) then
            preparing<='0';
            balance <= 0;
            countdown_active<='0';
            insufficient<='0';
        end if;
      if (insufficient= '1' and insufficient_countdown_timer > 0) then
            nrCountdown:=nrCountdown+1;
            if nrCountdown = 50000000/150000 then
                insufficient_countdown_timer <= insufficient_countdown_timer - 1;
                nrCountdown:= 0;
            end if;
      elsif(insufficient = '1' and insufficient_countdown_timer = 0) then
           insufficient<='0';
           preparing<='0';
           insufficient_countdown_timer <= 5;
      end if;
      
      if (careBcd = 0) then
                anodes <= "01111111";
                display <= std_logic_vector(to_unsigned(balance, display'length));
                careBcd <= 1;
            else
                anodes <= "11111110";
                if insufficient = '0' then
                    display <= std_logic_vector(to_unsigned(countdown_value, display'length));
                else 
                    display <= std_logic_vector(to_unsigned(insufficient_countdown_timer, display'length));
                end if;
                careBcd <= 0;
            end if;
    end if;
    end process;

process(clock,coin_in,reset_in)
begin
if(rising_edge(clock)) then
            case display is
                When "0000" =>
                    Segments<="00000010";
                When "0001" =>
                    Segments<="10011111";
                When "0010" =>
                    Segments<="00100100";
                When "0011" =>
                    Segments<="00001101";
                When "0100" =>
                    Segments<="10011000";
                When "0101" =>
                    Segments<="01001001";
                When "0110" =>
                    Segments<="01000000";
                When "0111" =>
                    Segments<="00011111";
                When "1000" =>
                    Segments<="00000001";
                When "1001" =>
                    Segments<="00001000";
                When others =>
                    Segments<="11111110";
            end case;
end if;
end process;

  led_idle <= '1' when (preparing = '0' and insufficient = '0' and countdown_active = '0') else '0';
  led_preparing <= preparing;
  led_insufficient <= insufficient;

end Behavioral;

