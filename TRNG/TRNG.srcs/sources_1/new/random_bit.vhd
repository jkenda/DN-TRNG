-- Avtor: Jakob Kenda

-- Vezje, ki iz izhoda oscilatorjev generira naključen bit

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity random_bit is
    Port (
        clk    : in STD_LOGIC;
        rst    : in STD_LOGIC;
        output : out STD_LOGIC
    );
end random_bit;

architecture Behavioral of random_bit is
    
    component oscillator is
        Generic (
            length : integer := 13
        ); 
        Port (
            rst    : in  STD_LOGIC;
            output : out STD_LOGIC
        );
    end component;
    
    signal oscillators : STD_LOGIC_VECTOR (0 to 199);
    
    attribute DONT_TOUCH : string;
    attribute DONT_TOUCH of oscillators : signal is "true";    
    attribute DONT_TOUCH of output : signal is "true";
    
begin

    generate_oscillators: for i in 0 to 199 generate 
    
        oscillator_group: if i mod 5 = 0 generate
            oscil : oscillator
                generic map (
                    length => 7
                )
                port map(
                    rst => rst,
                    output => oscillators(i)
                );
        elsif i mod 5 = 1 generate
            oscil : oscillator
                generic map (
                    length => 11
                )
                port map(
                    rst => rst,
                    output => oscillators(i)
                );
        elsif i mod 5 = 2 generate
            oscil : oscillator
                generic map (
                    length => 13
                )
                port map(
                    rst => rst,
                    output => oscillators(i)
                );
        elsif i mod 5 = 3 generate
            oscil : oscillator
                generic map (
                    length => 17
                )
                port map(
                    rst => rst,
                    output => oscillators(i)
                );
        else generate
            oscil : oscillator
                generic map (
                    length => 19
                )
                port map(
                    rst => rst,
                    output => oscillators(i)
                );
        end generate oscillator_group ;
        
    end generate generate_oscillators;

    digitalize : process(clk)
    begin
        if rising_edge(clk) then
            output <= xor oscillators;
        end if;
    end process;
     
end Behavioral;
