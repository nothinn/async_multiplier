
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

use IEEE.std_logic_misc.ALL;

entity source is
    Generic(
        source_delay : time := 1 ps
    );
    Port ( 
        req_out      : out std_logic;
        ack_in       : in std_logic);
end source;

architecture Behavior of source is

    signal internal : std_logic;

    attribute dont_touch : string;
    attribute dont_touch of internal : signal is "true";
    

begin
    internal <= transport not(ack_in) after source_delay;
    req_out <= internal;
end Behavior;