-- Avtor: Jakob Kenda

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity number_handler is
    Port (
        clk, rst : in STD_LOGIC;
        BTNC     : in  STD_LOGIC;
        SW       : in  STD_LOGIC_VECTOR (5 downto 0);
        byte     : in STD_LOGIC_VECTOR (7 downto 0);
        output   : out STD_LOGIC_VECTOR (31 downto 0) := (others => '0')
    );
end number_handler;

architecture Behavioral of number_handler is

    signal enable_word : STD_LOGIC_VECTOR(31 downto 0);
    signal enable_byte : STD_LOGIC_VECTOR( 7 downto 0);
    signal index  : STD_LOGIC_VECTOR(1 downto 0) := "00";

    signal BTNC_prev : STD_LOGIC;
    
begin

    -- omeji velikost števila
    enable_word <= std_logic_vector((to_unsigned(1, 32) sll conv_integer(SW)) - 1);
    
    with conv_integer(index) select
        enable_byte <= enable_word(31 downto 24) when 3,
                       enable_word(23 downto 16) when 2,
                       enable_word(15 downto  8) when 1,
                       enable_word( 7 downto  0) when 0;
    
    -- prikaži 4 byte na 7-segmentnem prikazovalniku
    synchronous : process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                output <= (others => '0');
            elsif (BTNC = '1' and BTNC_prev = '0') or (index /= "00") then
                case conv_integer(index) is
                    when 3 => output(31 downto 24) <= byte and enable_byte;
                    when 2 => output(23 downto 16) <= byte and enable_byte;
                    when 1 => output(15 downto  8) <= byte and enable_byte;
                    when 0 => output( 7 downto  0) <= byte and enable_byte;
                end case;
                index <= index + 1;
            end if;
            
            BTNC_prev <= BTNC;
        end if;
    end process;
    

end Behavioral;
