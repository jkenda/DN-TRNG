-- Avtor: Jakob Kenda

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RGB is
    Port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        number : in STD_LOGIC_VECTOR (2 downto 0);
        R, G, B : out STD_LOGIC := '0'
    );
end RGB;

architecture Behavioral of RGB is

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
    
    signal E, F : STD_LOGIC := '0';
    signal divide : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal mem: STD_LOGIC_VECTOR (2 downto 0) := "000";
    
    constant zero : STD_LOGIC_VECTOR(2 downto 0) := "000";
    
begin

    prescaler_inst : prescaler
        generic map (
            width => 10,
            limit => 1000
        )
        port map (
            clk => clk,
            rst => rst,
            enable => E
        );
        
    prescaler_color_change : prescaler
        generic map (
            width => 14,
            limit => 10_000
        )
        port map (
            clk => E,
            rst => rst,
            enable => F
        );
        
        with divide select
            (R, G, B) <= mem  when "000",
                         zero when others;
        
    process(clk)
    begin
        if rising_edge(clk) and E='1' then
            if F='1' then
                mem <= number;
            end if;
            divide <= divide + 1;
        end if;
    end process;

end Behavioral;
