-- Avtor: Jakob Kenda

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port ( 
        clk  : in  std_logic;
        rst  : in  std_logic;
        BTNC : in  std_logic;
        SW   : in  std_logic_vector (5 downto 0);
        LED  : out std_logic_vector (5 downto 0);
        AN   : out std_logic_vector (7 downto 0);
        CA   : out std_logic_vector (6 downto 0);
        VGA_R, VGA_G, VGA_B : out std_logic_vector (3 downto 0);
        VGA_HS, VGA_VS : out std_logic
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
    
    component vgaController is
        Port (
            clk:    in  std_logic;
            rst:    in  std_logic;
            VGA_HS: out std_logic;
            VGA_VS: out std_logic;
            VGA_R:  out std_logic_vector (3 downto 0);
            VGA_G:  out std_logic_vector (3 downto 0);
            VGA_B:  out std_logic_vector (3 downto 0);
            RED, GREEN, BLUE: in std_logic_vector (3 downto 0)
        );
    end component;
    
    
    signal number : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal enable : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    
    signal byte : std_logic_vector (7 downto 0) := (others => '0');
    signal index : std_logic_vector (1 downto 0) := "00";
    
    signal BTNC_prev : std_logic;
    
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
        
    vga_inst : vgaController 
        port map (
            clk => clk,
            rst => not rst,
            VGA_HS => VGA_HS,
            VGA_VS => VGA_VS,
            VGA_R => VGA_R,
            VGA_G => VGA_G,
            VGA_B => VGA_B,
            RED   => byte(3 downto 0),
            GREEN => byte(3 downto 0),
            BLUE  => byte(3 downto 0)
        );
    
    
    with rst select
        LED <= SW when '1',
               (others => '0') when '0';
    
    -- omeji velikost števila
    enable_proc : process(SW)
    begin
        gen_enable: for i in 0 to 31 loop
            enable(i) <= '1' when SW > i else '0';
        end loop;
    end process;
    
    synchronous : process(clk)
    begin
        if rising_edge(clk) then
            if rst='0' then
                number <= (others => '0');
            elsif (BTNC = '1' and BTNC_prev = '0') or (index /= "00") then
                case conv_integer(index) is
                    when 3 => number(31 downto 24) <= byte and enable(31 downto 24);
                    when 2 => number(23 downto 16) <= byte and enable(23 downto 16);
                    when 1 => number(15 downto  8) <= byte and enable(15 downto  8);
                    when 0 => number( 7 downto  0) <= byte and enable( 7 downto  0);
                end case;
                index <= index + 1;
            end if;
            
            BTNC_prev <= BTNC;
        end if;
    end process;
    
end Behavioral;
