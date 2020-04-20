----------------------------------------------------------------------------------
-- Delay element
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library  unisim;
use  unisim.vcomponents.lut1;

entity  delay_element_sim  is
  generic(
    delay : time := 10ps);
  port (
    d     : in std_logic; -- Data  in
    z     : out std_logic);
end  delay_element_sim;

architecture  behaviour of  delay_element_sim  is

begin

    z <= transport d after delay;

end  behaviour;