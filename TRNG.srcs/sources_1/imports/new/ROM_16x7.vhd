----------------------------------------------------------------------------------
-- ROM 16x7 (16 7-bitnih besed)
-- Primer: Dekodirnik za 7-segmentni prikazovalnik
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ROM_16x7 is
    generic(
        addr_width : integer := 4; -- number of bits in the address
        data_width : integer := 7   -- number of bits in data
    );
    port (
        addr : in std_logic_vector(addr_width-1 downto 0);
        data : out std_logic_vector(data_width-1 downto 0)
    );
end entity;

architecture Behavioral of ROM_16x7 is

    type ROM_type is array (0 to addr_width**2 -1) of std_logic_vector(data_width-1 downto 0);
    
    signal ROM_7seg : rom_type := (
                            "1000000", -- 0, negativna logika: 0-prizgano, 1-ugasnjeno
                            "1111001", -- 1
                            "0100100", -- 2
                            "0110000", -- 3
                            "0011001", -- 4
                            "0010010", -- 5
                            "0000010", -- 6
                            "1111000", -- 7
                            "0000000", -- 8
                            "0010000", -- 9
                            "0001000", -- A
                            "0000011", -- B
                            "1000110", -- C
                            "0100001", -- D
                            "0000110", -- E
                            "0001110"  -- F
                            );
begin
    -- Pretvorba std_logic_vector v integer za naslavljanje polja
    data <= ROM_7seg(to_integer(unsigned(addr)));
    
    -- ALTERNATIVNI ZAPIS (brez ROM_type in ROM_7seg)
    --    with addr select data <=
    --        "1000000" when "0000", -- 0, negativna logika: 0-prizgano, 1-ugasnjeno
    --        "1111001" when "0001", -- 1
    --        "0100100" when "0010", -- 2
    --        "0110000" when "0011", -- 3
    --        "0011001" when "0100", -- 4
    --        "0010010" when "0101", -- 5
    --        "0000010" when "0110", -- 6
    --        "1111000" when "0111", -- 7
    --        "0000000" when "1000", -- 8
    --        "0010000" when "1001", -- 9
    --        "0001000" when "1010", -- A
    --        "0000011" when "1011", -- B
    --        "1000110" when "1100", -- C
    --        "0100001" when "1101", -- D
    --        "0000110" when "1110", -- E
    --        "0001110" when "1111", -- F
    --        "1111111" when others;

end Behavioral;
