-- Avtor: Jakob Kenda

-- Vezje, ki iz izhoda oscilatorjev generira naključen bit

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity random_bit is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        output : out std_logic
    );
end random_bit;

architecture Behavioral of random_bit is
    
    component oscillator is
        Generic (
            length : integer := 13
        ); 
        Port (
            rst    : in  std_logic;
            output : out std_logic
        );
    end component;
    
    signal oscillators : std_logic_vector (0 to 199);
    
    attribute dont_touch : string;
    attribute dont_touch of oscillators : signal is "true";    
    attribute dont_touch of output : signal is "true";    

begin

    generate_oscillators: for i in 0 to 199 generate 
    
        oscillator_group: if i < 40 generate
            oscil : oscillator
                generic map (
                    length => 7
                )
                port map(
                    rst => rst,
                    output => oscillators(i)
                );
        elsif i < 80 generate
            oscil : oscillator
                generic map (
                    length => 11
                )
                port map(
                    rst => rst,
                    output => oscillators(i)
                );
        elsif i < 120 generate
            oscil : oscillator
                generic map (
                    length => 13
                )
                port map(
                    rst => rst,
                    output => oscillators(i)
                );
        elsif i < 160 generate
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
