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
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        VGA_HS  : out STD_LOGIC;
        VGA_VS  : out STD_LOGIC;
        VGA_R   : out STD_LOGIC_VECTOR(3 downto 0);
        VGA_G   : out STD_LOGIC_VECTOR(3 downto 0);
        VGA_B   : out STD_LOGIC_VECTOR(3 downto 0);
        R, G, B : in  STD_LOGIC_VECTOR(3 downto 0)
    );
end entity;

architecture Behavioral of vgaController is
    -----------------------------------------------------------
    -- KOMPONENTE
    -----------------------------------------------------------
    component hsync is
        Port (
            clk:     in  STD_LOGIC;
            rst:     in  STD_LOGIC;
            hsync:   out STD_LOGIC;
            ce:      out STD_LOGIC;
            display: out STD_LOGIC;
            column:  out UNSIGNED(9 downto 0));
    end component;

    component vsync is
        Port (
            clk:     in  STD_LOGIC;
            rst:     in  STD_LOGIC;
            ce:      in  STD_LOGIC;
            vsync:   out STD_LOGIC;
            display: out STD_LOGIC;
            row:     out UNSIGNED(9 downto 0));
    end component;

    -----------------------------------------------------------
    -- SIGNALI 
    -----------------------------------------------------------
    signal clock_enable: STD_LOGIC;
    signal h_display:    STD_LOGIC;
    signal v_display:    STD_LOGIC;
    signal display_both: STD_LOGIC;
    signal column:       UNSIGNED(9 downto 0);
    signal row:          UNSIGNED(9 downto 0);
    signal border_on:    STD_LOGIC;
    
    signal column_prev: UNSIGNED(9 downto 0);

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
                VGA_R <= R when display_both='1' else "0000";
                VGA_G <= G when display_both='1' else "0000";
                VGA_B <= B when display_both='1' else "0000";
            end if;
        
            column_prev <= column;
        end if;
    end process;

end Behavioral;
