library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity prescaler is
	 Generic (  
        width : integer := 8;
        limit : integer := 255
    );
    Port (
        clk    : in   STD_LOGIC;
        rst    : in   STD_LOGIC;
        enable : out  STD_LOGIC := '0'
    );
end prescaler;

architecture Behavioral of prescaler is
	signal count : STD_LOGIC_VECTOR(width-1 downto 0) := (others => '0');	
begin

	process(clk)
	begin
		if rising_edge(clk) then
			if rst='1' then
				count <= (others => '0');
				enable <= '0';
            elsif count >= limit then
                count <= (others => '0');
                enable <= '1';
            else
                count <= count + 1;
                enable <= '0';
            end if;
        end if ;
	end process;

end Behavioral;
