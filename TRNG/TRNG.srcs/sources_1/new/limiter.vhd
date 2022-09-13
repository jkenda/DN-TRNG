-- Avtor: Jakob Kenda

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity number_handler is
    Port (
        clk, rst : in STD_LOGIC;
        BTNC     : in  STD_LOGIC;
        SW       : in  STD_LOGIC_VECTOR (5 downto 0);
        LED      : out STD_LOGIC_VECTOR (5 downto 0);
        byte     : in STD_LOGIC_VECTOR (7 downto 0);
        number   : out STD_LOGIC_VECTOR (31 downto 0) := (others => '0')
    );
end number_handler;

architecture Behavioral of number_handler is

    signal enable : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal index : STD_LOGIC_VECTOR (1 downto 0) := "00";

    signal BTNC_prev : STD_LOGIC;
    
begin

    LED <= SW when rst='0' else "000000";
    
    -- omeji velikost števila
    enable_proc : process(SW)
    begin
        gen_enable: for i in 0 to 31 loop
            enable(i) <= '1' when SW > i else '0';
        end loop;
    end process;
    
    -- prikaži 4 byte na 7-segmentnem prikazovalniku
    synchronous : process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                number <= (others => '0');
            elsif (BTNC = '1' and BTNC_prev = '0') or (index /= "00") then
                case conv_integer(index) is
                    when 3 => number(31 downto 24) <= byte and enable(31 downto 24);
                    when 2 => number(23 downto 16) <= byte and enable(23 downto 16);
                    when 1 => number(15 downto  8) <= byte and enable(15 downto  8);
                    when 0 => number( 7 downto  0) <= byte and enable( 7 downto  0);
                end case;
                index <= index + 1;
            end if;
            
            BTNC_prev <= BTNC;
        end if;
    end process;
    

end Behavioral;
