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

entity CSA is
    Generic(
        BITWIDTH : integer := 16;
        CSA_DELAY: time := time
    );
    Port ( 
        CSA_in_0 : in std_logic_vector(BITWIDTH-1 downto 0);
        CSA_in_1 : in std_logic_vector(BITWIDTH-1 downto 0);
        CSA_in_2 : in std_logic_vector(BITWIDTH-1 downto 0);

        CSA_out_S : out std_logic_vector(BITWIDTH-1 downto 0);
        CSA_out_C : out std_logic_vector(BITWIDTH-1 downto 0));
end CSA;


architecture Behavior of CSA is

    signal xor1  : std_logic_vector(BITWIDTH-1 downto 0);
    signal CSA_S : std_logic_vector(BITWIDTH-1 downto 0);
    signal CSA_C : std_logic_vector(BITWIDTH-1 downto 0);

begin
    gen_CSA: for i in 0 to BITWIDTH-1 generate
        xor1(i) <= CSA_in_0(i) xor CSA_in_1(i);

        CSA_S(i) <= xor1(i) xor CSA_in_2(i);

        CSA_C(i) <= (xor1(i) and CSA_in_2(i)) or (CSA_in_0(i) and CSA_in_1(i));
    end generate;

    CSA_out_S <= transport CSA_S after CSA_DELAY;
    CSA_out_C <= transport CSA_C after CSA_DELAY;
end Behavior;