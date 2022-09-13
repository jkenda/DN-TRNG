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
        rst    : in  STD_LOGIC;
        output : out STD_LOGIC
    );
end oscillator;

architecture Behavioral of oscillator is
    signal chain: STD_LOGIC_VECTOR(length-1 downto 0);
    
    attribute DONT_TOUCH : string;
    attribute ALLOW_COMBINATORIAL_LOOPS : string;

    attribute DONT_TOUCH of chain  : signal is "true";
    attribute DONT_TOUCH of output : signal is "true";    
    attribute ALLOW_COMBINATORIAL_LOOPS of output : signal is "true";
begin

    generate_chain: for i in 1 to length-1 generate
        chain(i) <= not chain(i-1);
    end generate;
    chain(0) <= not chain(length-1) or rst;

    output <= chain(0);

end Behavioral;
