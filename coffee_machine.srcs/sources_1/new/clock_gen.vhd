library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_gen is
    Port ( Clk : in STD_LOGIC;
           En : in STD_LOGIC;
           Rst: in STD_LOGIC);
end clock_gen;

architecture Behavioral of clock_gen is
    signal slowClk:STD_LOGIC:='1';
    signal count: integer:=0;
begin
generateSlowClk:process(Clk,Rst)
    begin
        if rising_edge(Clk) and En='1' then
            count<=count+1;
            if count>50000000 then
                count<=0;
                slowClk<=not slowClk;
            end if;
        end if;
        if Rst='1' then
            count<=0;
            slowClk<='1';
        end if;
    end process;
end Behavioral;
