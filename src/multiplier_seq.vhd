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

entity multiplier_seq is
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
end multiplier_seq;

architecture Behavior of multiplier_seq is

    signal a_reg, b_reg : std_logic_vector(bitwidth*2-1 downto 0);
    
    signal result_reg : std_logic_vector(bitwidth*2-1 downto 0);
    
    
    signal valid_reg, valid_reg2 : std_logic;


    signal CSA_out_S, CSA_out_C : std_logic_vector(bitwidth*2-1 downto 0);
    signal CSA_out_S_reg, CSA_out_C_reg : std_logic_vector(bitwidth*2-1 downto 0);
    
    signal CSA_in_0, CSA_in_1, CSA_in_2 : std_logic_vector(bitwidth*2-1 downto 0);
    

    signal xor1 : std_logic_vector(bitwidth*2-1 downto 0);

    signal calculating : std_logic;

begin


    --CSA part

    gen_CSA: for i in 0 to bitwidth*2-1 generate
        xor1(i) <= CSA_in_0(i) xor CSA_in_1(i);

        CSA_out_S(i) <= xor1(i) xor CSA_in_2(i);

        CSA_out_C(i) <= (xor1(i) and CSA_in_2(i)) or (CSA_in_0(i) and CSA_in_1(i));
    end generate;


    CSA_in_0 <= (others => '0') when calculating = '0' else CSA_out_S_reg;
    CSA_in_1 <= (others => '0') when calculating = '0' else CSA_out_C_reg sll 1;

    process(all)
    begin
        if calculating = '1' then
            if a_reg(0) = '0' then
                CSA_in_2 <= (others => '0');
            else
                CSA_in_2 <= b_reg;
            end if;
        else
            if a(0) = '0' then
                CSA_in_2 <= (others => '0');
            else
                CSA_in_2 <= (bitwidth-1 downto 0 => '0') & b;
            end if;
        end if;
    end process;
    
    process(clk,rst)
    begin
        if rst = '1' then
            a_reg <= (others => '0');
            b_reg <= (others => '0');
            
            valid_reg <= '0';
            valid_reg2 <= '1';
            
            result_reg <= (others => '0');
            
            calculating <= '0';
            
            CSA_out_S_reg <= (others => '0');
            CSA_out_C_reg <= (others => '0');
            
            
        elsif rising_edge(clk) then
            valid_reg <= valid;
            

            if calculating = '1' then
                a_reg <= a_reg srl 1;
                b_reg <= b_reg sll 1;
            elsif valid = '1' then
                calculating <= '1';
                a_reg <= (bitwidth-1 downto 0 => '0') & a srl 1;
                b_reg <= (bitwidth-1 downto 0 => '0') & b sll 1;
            end if;

            CSA_out_S_reg <= CSA_out_S;
            CSA_out_C_reg <= CSA_out_C;

            if(a_reg = (a_reg'RANGE => '0') and calculating = '1') then
                result_reg <= std_logic_vector(unsigned(CSA_out_S_reg) + unsigned(CSA_out_C_reg sll 1));
                if calculating = '1' then
                    done <= '1';
                else
                    done <= '0';
                end if;
                calculating <= '0';
            else
                done <= '0';
            end if;


        end if;

    end process;
    
    ready <= not calculating;
    result <= result_reg;
    --std_logic_vector(unsigned(CSA_out_S_reg) + unsigned(CSA_out_C_reg sll 1));--
end Behavior;
