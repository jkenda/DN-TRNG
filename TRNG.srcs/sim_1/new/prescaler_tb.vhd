----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/10/2022 06:39:56 PM
-- Design Name: 
-- Module Name: prescaler_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity prescaler_tb is
    -- Port ();
end prescaler_tb;

architecture Behavioral of prescaler_tb is
    
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
    
    signal clk, E, combined : std_logic;
    
begin

    uut : prescaler
        generic map (
            width => 10,
            limit => 1000
        )
        port map (
            clk => clk,
            rst =>'0',
            enable => E
        );
        
    process(clk)
    begin
        if rising_edge(clk) and E='1' then
            combined <= '1';
        else
            combined <= '0';
        end if;
    end process;
        
    stimulus: process
    begin
        
        for i in 0 to 2002 loop
            clk <= '0';
            wait for 1 ns;
            clk <= '1';
            wait for 1 ns;
        end loop;
        
    end process;

end Behavioral;
