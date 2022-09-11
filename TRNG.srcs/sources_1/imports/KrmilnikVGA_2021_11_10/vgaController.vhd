----------------------------------------------------------------------------------
-- Projekt: Krmilnik VGA
-- Verzija: 10. 11. 2021
-- Glavni modul
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vgaController is
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
end entity;

architecture Behavioral of vgaController is
    -----------------------------------------------------------
    -- KOMPONENTE
    -----------------------------------------------------------
    component hsync is
        Port (
            clk:     in  std_logic;
            rst:     in  std_logic;
            hsync:   out std_logic;
            ce:      out std_logic;
            display: out std_logic;
            column:  out unsigned(9 downto 0));
    end component;

    component vsync is
        Port (
            clk:     in  std_logic;
            rst:     in  std_logic;
            ce:      in  std_logic;
            vsync:   out std_logic;
            display: out std_logic;
            row:     out unsigned(9 downto 0));
    end component;

    -----------------------------------------------------------
    -- SIGNALI 
    -----------------------------------------------------------
    signal clock_enable: std_logic;
    signal h_display:    std_logic;
    signal v_display:    std_logic;
    signal display_both: std_logic;
    signal column:       unsigned(9 downto 0);
    signal row:          unsigned(9 downto 0);
    signal border_on:    std_logic;
    
    signal column_prev: unsigned(9 downto 0);

begin
    -----------------------------------------------------------
    -- INSTANCIRANJE KOMPONENT 
    -----------------------------------------------------------
    hsync_inst: hsync
        port map (
            clk     => clk,
            rst     => rst,
            ce      => clock_enable,
            hsync   => VGA_HS,
            display => h_display,
            column  => column
        );

    vsync_inst: vsync
        port map (
            clk     => clk,
            rst     => rst,
            ce      => clock_enable,
            vsync   => VGA_VS,
            display => v_display,
            row     => row
        );

    -----------------------------------------------------------
    -- IZRIS NA ZASLON 
    -- Logika za prižiganje elektronskih topov (R,G,B)
    -----------------------------------------------------------
    
    -- Kdaj smo v vidnem delu zaslona po obeh oseh 
    display_both <= h_display and v_display;

    process(clk)
    begin
        if rising_edge(clk) then
            -- izhod spremeni samo ob spremembi stolpca
            if column /= column_prev then
                VGA_R <= RED   when display_both='1' else "0000";
                VGA_G <= GREEN when display_both='1' else "0000";
                VGA_B <= BLUE  when display_both='1' else "0000";
            end if;
        
            column_prev <= column;
        end if;
    end process;

end Behavioral;
