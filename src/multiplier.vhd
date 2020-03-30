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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplier is
    Generic(
        bitwidth : integer := 16
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR (bitwidth-1 downto 0);
           b : in STD_LOGIC_VECTOR (bitwidth-1 downto 0);
           result : out STD_LOGIC_VECTOR (bitwidth*2-1 downto 0);
           done : out STD_LOGIC;
           valid : in STD_LOGIC;
           ready : out STD_LOGIC);
end multiplier;

architecture Behavioral of multiplier is

    signal a_reg, b_reg : std_logic_vector(bitwidth-1 downto 0);
    
    signal result_reg : std_logic_vector(bitwidth*2-1 downto 0);
    
    signal ready_reg, ready_reg2 : std_logic;
    
    signal valid_reg, valid_reg2 : std_logic;
    

begin
    process(all)
    begin
        if rst = '1' then
            a_reg <= (others => '0');
            b_reg <= (others => '0');
            
            valid_reg <= '0';
            valid_reg2 <= '1';
            
            result_reg <= (others => '0');
            
        elsif rising_edge(clk) then
            result_reg <= std_logic_vector(signed(a_reg) * signed(b_reg));
            
            valid_reg <= valid;
            valid_reg2 <= valid_reg;
            
            if valid = '1' then
                a_reg <= a;
                b_reg <= b;
            end if;
        end if;
        
        done <= valid_reg2;
        ready <= not valid_reg;
        
        result <= result_reg;
    end process;
    
end Behavioral;
