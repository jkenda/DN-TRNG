-- Avtor: Jakob Kenda

-- Oscilator za naklučni bit

-- a->-b->-c->------output
-- |            |
-- --------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity oscillator is
    Generic (
        length : integer := 13
    );
    Port (
        rst  : in  std_logic;
        output : out std_logic
    );
end oscillator;

architecture Behavioral of oscillator is
    signal chain: std_logic_vector(length-1 downto 0);
    
    attribute dont_touch : string;
    attribute allow_combinatorial_loops : string;

    attribute dont_touch of chain  : signal is "true";
    attribute dont_touch of output : signal is "true";    
    attribute allow_combinatorial_loops of output : signal is "true";
begin

    generate_chain: for i in 1 to length-1 generate
        chain(i) <= not chain(i-1);
    end generate;
    chain(0) <= not chain(length-1) or rst;

    output <= chain(0);

end Behavioral;
