----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2020 12:11:34 PM
-- Design Name: 
-- Module Name: multiplier - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

use IEEE.std_logic_misc.ALL;

entity NOR_gate is
    Generic(
        BITWIDTH : integer := 16;
        NOR_DELAY : time := 2 ps
    );
    Port ( 
        in_req      : in std_logic;
        in_ack      : out std_logic;
        in_bus      : in std_logic_vector(BITWIDTH - 1 downto 0);
        -- Output channel
        out_req     : out std_logic;
        out_ack     : in std_logic;
        result      : out std_logic);
end NOR_gate;


architecture Behavior of NOR_gate is


begin
    -- TODO Implement delay

    out_req <= in_req;
    in_ack <= out_ack;

    result  <= nor_reduce(in_bus);

end Behavior;