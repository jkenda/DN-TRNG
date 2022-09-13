----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/13/2022 12:58:39 AM
-- Design Name: 
-- Module Name: uart_tb - Behavioral
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

entity uart_tb is
--  Port ( );
end uart_tb;

architecture Behavioral of uart_tb is
    
    component uart is
        Port (
            clk          : in  STD_LOGIC;
            rst          : in  STD_LOGIC;
            UART_RXD_OUT : out STD_LOGIC;
            UART_CTS     : in  STD_LOGIC;
            data         : in  STD_LOGIC
        );
    end component;
    
    signal clk, rx, cts : std_logic;
    
begin

    uut: uart
        port map (
            clk => clk,
            rst => '0',
            UART_RXD_OUT => rx,
            UART_CTS => cts,
            data => '1'
        );
        
    clk_sim: process
    begin
        for i in 1 to 100000 loop
            clk <= '1';
            wait for 1 ns;
            clk <= '0';
            wait for 1 ns;
        end loop;
    end process;

    stimulus: process
    begin
        cts <= '1';
        wait for 10 ms;
        cts <= '0';
        wait for 1 ms;
        cts <= '1';
    end process;
    
end Behavioral;
