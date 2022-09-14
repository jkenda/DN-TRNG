-- Avtor: Jakob Kenda

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart is
    Port (
        clk          : in  STD_LOGIC;
        rst          : in  STD_LOGIC;
        UART_RXD_OUT : out STD_LOGIC;
        UART_CTS     : in  STD_LOGIC;
        data         : in  STD_LOGIC_VECTOR(7 downto 0)
    );
end uart;

architecture Behavioral of uart is

    component prescaler is
         Generic (  
            width : integer := 8;
            limit : integer := 255
        );
        Port (
            clk    : in   STD_LOGIC;
            rst    : in   STD_LOGIC;
            enable : out  STD_LOGIC := '0'
        );
    end component;
    
    signal mem : STD_LOGIC_VECTOR(9 downto 0);
    
    signal CTS_prev : STD_LOGIC;
    signal pres_rst : STD_LOGIC;
    
    signal index : UNSIGNED(3 downto 0) := to_unsigned(9, 4);
    signal E     : STD_LOGIC;
    
    constant clk_frequency : integer := 100_000_000;
    constant baud_rate     : integer := 460800;
    constant char : UNSIGNED(7 downto 0) := to_unsigned(46, 8);
    
begin
    
    uart_prescaler : prescaler 
         generic map (  
            width => 14,
            limit => clk_frequency / baud_rate
        )
        port map (
            clk    => clk,
            rst    => pres_rst,
            enable => E
        );
        
    mem(0) <= '0';
    mem(9) <= '1';
    
    UART_RXD_OUT <= mem(to_integer(index));
    
    process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                mem(8 downto 1) <= (others => '0');
                index <= to_unsigned(9, 4);
            elsif E='1' then
                if index = 0 then
                    mem(8 downto 1) <= data;
                end if;
                if UART_CTS='1' or index < 9 then
                    index <= (index + 1) mod 10;
                end if;             
            end if;
            
            if UART_CTS='1' and CTS_prev='0' then
                pres_rst <= '1';
            else
                pres_rst <= '0';
            end if;
            
            CTS_prev <= UART_CTS;
        end if;
    end process;
    
end Behavioral;
