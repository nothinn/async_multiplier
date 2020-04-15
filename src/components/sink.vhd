
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

use IEEE.std_logic_misc.ALL;

entity sink is
    Generic(
        BITWIDTH : integer := 16;
        sink_delay : time := 1 ps
    );
    Port ( 
        req_in      : in std_logic;
        ack_out      : out std_logic;
        data_in      : in std_logic_vector(BITWIDTH - 1 downto 0));
end sink;


architecture Behavior of sink is


begin
    in_ack <= transport in_req after sink_delay;
end Behavior;