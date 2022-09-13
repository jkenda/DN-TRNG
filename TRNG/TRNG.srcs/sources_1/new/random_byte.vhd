-- Avtor: Jakob Kenda
--
-- Skupek 32 naljučnih bitov


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity random_byte is
    Port (
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        output : out STD_LOGIC_VECTOR(7 downto 0)
    );
end random_byte;

architecture Behavioral of random_byte is
    
    component random_bit is
        Port (
            clk    : in STD_LOGIC;
            rst    : in STD_LOGIC;
            output : out STD_LOGIC
        );
    end component;
    
    attribute DONT_TOUCH : string;
    attribute DONT_TOUCH of output : signal is "true";    

begin

    generate_bits: for i in 7 downto 0 generate 
    
        rand_bit: random_bit 
            port map ( 
                clk => clk,
                rst => rst,
                output => output(i)
            );
    
    end generate;

end Behavioral;
