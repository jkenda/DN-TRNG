-- Avtor: Jakob Kenda

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity top is
    Port ( 
        clk  : in std_logic;
        rst  : in std_logic;
        BTNC : in std_logic;
        SW   : in std_logic_vector (15 downto 0);
        AN   : out std_logic_vector (7 downto 0);
        CA   : out std_logic_vector (6 downto 0);
        LED  : out std_logic_vector (15 downto 0)
   );
end top;

architecture Behavioral of top is
    
    component random_byte is
        Port (
            clk : in STD_LOGIC;
            rst : in std_logic;
            output : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    component display is
        Port ( clk : in STD_LOGIC;
               rst : in std_logic;
               AN : out std_logic_vector (7 downto 0);
               CA : out std_logic_vector (6 downto 0);
               number : in STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    signal number : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal enable : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    
    signal byte : std_logic_vector (7 downto 0);
    signal index : std_logic_vector (1 downto 0) := "00";
    
begin

    random_byte_inst : random_byte 
        port map (
            clk => clk,
            rst => not rst,
            output => byte
        );

    display_inst : display
        port map (
            clk => clk,
            rst => not rst, 
            AN => AN,
            CA => CA,
            number => number
        );
        
    LED <= SW;
    
    gen_enable: for i in 0 to 15 generate 
        enable(2*i + 1 downto 2*i) <= (SW(i), SW(i));
    end generate;
    
    process(clk)
    begin
        if rising_edge(clk) and BTNC='1' then
            case conv_integer(index) is
                when 3 => number(31 downto 24) <= byte and enable(31 downto 24);
                when 2 => number(23 downto 16) <= byte and enable(23 downto 16);
                when 1 => number(15 downto  8) <= byte and enable(15 downto  8);
                when 0 => number( 7 downto  0) <= byte and enable( 7 downto  0);
            end case;
            
            index <= index + 1;
        end if;
    end process;
    
end Behavioral;
