----------------------------------------------------------------------------------
-- Projekt: Krmilnik VGA
-- Verzija: 10. 11. 2021
-- Modul za navpicno sinhronizacijo
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vsync is
    Port (
        clk:     in  STD_LOGIC;             -- ura (globalna)
        rst:     in  STD_LOGIC;             -- ponastavitev vezja
        ce:      in  STD_LOGIC;             -- "clock enable", ki naznani stetje vrstic
        vsync:   out STD_LOGIC;             -- navpicni sinhronizacijski signal
        display: out STD_LOGIC;             -- ali smo v vidnem delu zaslona
        row:     out UNSIGNED(9 downto 0)); -- trenutni odmik vrstce v vidnem delu zaslona
end entity;

architecture Behavioral of vsync is
    -----------------------------------------------------------
    -- SIGNALI
    -----------------------------------------------------------
    -- Stevec steje do 521-1, torej mora biti vsaj 10 biten
    signal count:     UNSIGNED(9 downto 0);
    signal sync_on:   STD_LOGIC;
    signal sync_off:  STD_LOGIC;
    signal q:         STD_LOGIC;
    signal display_i: STD_LOGIC;

    -----------------------------------------------------------
    -- KONSTANTE 
    -----------------------------------------------------------
    constant SP: integer := 2;   -- sync pulse (2 * 32 us = 2 vrstici)
    constant T:  integer := 521; -- cas periode (16,6667 ms)
    constant BP: integer := 29;  -- back porch
    constant FP: integer := 10;  -- front porch

begin
    -----------------------------------------------------------
    -- VZPOREDNI STAVKI
    -----------------------------------------------------------
    -- Prirejanje V/I 
    vsync <= q;
    display <= display_i;

    -- primerjalnik za SP 
    sync_on <= '1' when count=SP else '0';

    -- primerjalnik za T 
    sync_off <= '1' when count=T-1 and ce='1' else '0';

    -- primerjalnik za prikazno obmo�je 
    display_i <= '1' when count >= (SP+BP) and count < (T-FP) else '0';

    -- preslikava urinih ciklov na vrstice v vidnem delu zaslona
    row <= (count-SP-BP) when display_i='1' else (others=> '0');

    -----------------------------------------------------------
    -- PROCESI
    -----------------------------------------------------------
    stevec: process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' or sync_off='1' then
                count <= (others => '0');
            else
                if ce='1' then
                    -- Pristevamo vrstice samo,
                    -- ko tako pravi "clock enable".
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;

    -- Oblikovanje izhodnega signala 
    sig_ff: process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                q <= '0';
            elsif sync_on='1' and sync_off='0' then
                q <= '1';
            elsif sync_off='1' and sync_on='0' then
                q <= '0';
            end if;
        end if;
    end process;
end Behavioral;
