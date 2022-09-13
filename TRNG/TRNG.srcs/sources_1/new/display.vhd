-- Avtor: Jakob Kenda

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity display is
    Port (
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        AN     : out STD_LOGIC_VECTOR(7 downto 0);
        CA     : out STD_LOGIC_VECTOR(6 downto 0);
        number : in  STD_LOGIC_VECTOR(31 downto 0)
    );
end display;

architecture Behavioral of display is

    component prescaler is
         Generic (  
            width : integer := 8;
            limit : integer := 255
        );
        Port (
            clk    : in   STD_LOGIC;
            rst    : in   STD_LOGIC;
            enable : out  STD_LOGIC
        );
    end component;
    
    component ROM_16x7 is
        Generic(
            addr_width : integer := 4; -- number of bits in the address
            data_width : integer := 7  -- number of bits in data
        );
        Port (
            addr : in  STD_LOGIC_VECTOR(addr_width-1 downto 0);
            data : out STD_LOGIC_VECTOR(data_width-1 downto 0)
        );
    end component;
    
    
    signal memory : STD_LOGIC_VECTOR(31 downto 0);
    
    signal E : STD_LOGIC := '0';
    signal digit : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal index : STD_LOGIC_VECTOR (2 downto 0) := "000";
    
begin

    display_prescaler : prescaler
        generic map (
            width => 10,
            limit => 1000
        )
        port map (
            clk => clk,
            rst => rst,
            enable => E
        );
        
    numbers_rom : ROM_16x7
        port map (
            addr => digit,
            data => CA
        );
    
    with CONV_INTEGER(index) select
        digit <= memory( 3 downto  0) when 0,
                 memory( 7 downto  4) when 1,
                 memory(11 downto  8) when 2,
                 memory(15 downto 12) when 3,
                 memory(19 downto 16) when 4,
                 memory(23 downto 20) when 5,
                 memory(27 downto 24) when 6,
                 memory(31 downto 28) when 7;
    
    process(index)
    begin
        AN <= (others => '1');
        AN(CONV_INTEGER(index)) <= '0' or rst;
    end process;
    
    output : process(clk, E)
    begin
        if rising_edge(clk) and E='1' then
            memory <= number;
            index <= index + 1;
        end if;
    end process;

end Behavioral;
