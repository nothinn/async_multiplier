library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity async_mult_top is
    Generic(
        bitwidth : integer := 8
    );
    Port ( rst : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR (bitwidth-1 downto 0);
           b : in STD_LOGIC_VECTOR (bitwidth-1 downto 0);
           result : out STD_LOGIC_VECTOR (bitwidth*2-1 downto 0);
           done : out STD_LOGIC;
           req_in  : in STD_LOGIC;
           ack_out : out STD_LOGIC;
           req_out : out STD_LOGIC;
           ack_in  : in std_logic);
end async_mult_top;

architecture behaviour of async_mult_top is


begin


    mult: entity work.multiplier_async
        generic map(
            BITWIDTH => bitwidth
        )
        port map(
            rst => rst,
            req_in => 
        )



end architecture;