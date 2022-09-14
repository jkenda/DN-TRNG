-- Avtor: Jakob Kenda

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port (
        clk          : in  STD_LOGIC;
        rst          : in  STD_LOGIC;
        BTNC         : in  STD_LOGIC;
        SW           : in  STD_LOGIC_VECTOR(5 downto 0);
        LED          : out STD_LOGIC_VECTOR(5 downto 0);
        AN           : out STD_LOGIC_VECTOR(7 downto 0);
        CA           : out STD_LOGIC_VECTOR(6 downto 0);
        VGA_R        : out STD_LOGIC_VECTOR(3 downto 0);
        VGA_G        : out STD_LOGIC_VECTOR(3 downto 0);
        VGA_B        : out STD_LOGIC_VECTOR(3 downto 0);
        VGA_HS       : out STD_LOGIC;
        VGA_VS       : out STD_LOGIC;
        UART_RXD_OUT : out STD_LOGIC;
        UART_CTS     : in  STD_LOGIC;
        LED16_R      : out STD_LOGIC
    );
end top;

architecture Behavioral of top is

    component random_bits is
        Generic (
            width : integer := 8
        );
        Port (
            clk    : in  STD_LOGIC;
            rst    : in  STD_LOGIC;
            output : out STD_LOGIC_VECTOR(width-1 downto 0)
        );
    end component;

    component display is
        Port (
            clk    : in  STD_LOGIC;
            rst    : in  STD_LOGIC;
            AN     : out STD_LOGIC_VECTOR(7 downto 0);
            CA     : out STD_LOGIC_VECTOR(6 downto 0);
            number : in  STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component vgaController is
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
    end component;

    component uart is
        Port (
            clk          : in  STD_LOGIC;
            rst          : in  STD_LOGIC;
            UART_RXD_OUT : out STD_LOGIC;
            UART_CTS     : in  STD_LOGIC;
            data         : in  STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component number_handler is
        Port (
            clk, rst : in STD_LOGIC;
            BTNC     : in  STD_LOGIC;
            SW       : in  STD_LOGIC_VECTOR (5 downto 0);
            LED      : out STD_LOGIC_VECTOR (5 downto 0);
            byte     : in STD_LOGIC_VECTOR (7 downto 0);
            number   : out STD_LOGIC_VECTOR (31 downto 0) := (others => '0')
        );
    end component;

    signal number    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal rand_bits : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
    signal reset     : STD_LOGIC;

begin

    reset <= not rst;
    LED16_R <= not UART_CTS;

    rand : random_bits
        generic map (
            width => 12
        )
        port map (
            clk    => clk,
            rst    => reset,
            output => rand_bits
        );

    display_7seg : display
        port map (
            clk    => clk,
            rst    => reset,
            AN     => AN,
            CA     => CA,
            number => number
        );

    vga_inst : vgaController
        port map (
            clk    => clk,
            rst    => reset,
            VGA_HS => VGA_HS,
            VGA_VS => VGA_VS,
            VGA_R  => VGA_R,
            VGA_G  => VGA_G,
            VGA_B  => VGA_B,
            R      => rand_bits(11 downto 8),
            G      => rand_bits( 7 downto 4),
            B      => rand_bits( 3 downto 0)
        );

    uart_comm : uart
        port map (
            clk          => clk,
            rst          => reset,
            UART_RXD_OUT => UART_RXD_OUT,
            UART_CTS     => UART_CTS,
            data         => rand_bits(11 downto 4)
        );

    num_handler : number_handler
        port map (
            clk    => clk,
            rst    => reset,
            BTNC   => BTNC,
            SW     => SW,
            LED    => LED,
            byte   => rand_bits(7 downto 0),
            number => number
        );

end Behavioral;
