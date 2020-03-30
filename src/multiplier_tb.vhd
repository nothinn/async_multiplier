----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2020 12:23:30 PM
-- Design Name: 
-- Module Name: multiplier_tb - Behavioral
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

entity multiplier_tb is
--  Port ( );
end multiplier_tb;

architecture Behavioral of multiplier_tb is

    -- Clock period definitions
    constant clock_period : time := 20 ns;
    
    constant bitwidth : integer := 32;
    constant lfsr1_poly : std_logic_vector := ("01001011001010100100101100101010");
    constant lfsr2_poly : std_logic_vector := ("01101010001000100110101000100010");
    
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    
    signal lfsr1_out : std_logic_vector(bitwidth-1 downto 0);
    signal lfsr1_en : std_logic := '0';
    signal lfsr2_out : std_logic_vector(bitwidth-1 downto 0);
    signal lfsr2_en : std_logic := '0';
    
    
    signal mul_result : std_logic_vector(bitwidth*2-1 downto 0);

    signal mul_ready : std_logic;
    signal mul_done : std_logic;
    signal mul_valid : std_logic := '0';
    
    signal done : std_logic := '0';
    
    

begin


    multiplier: entity work.multiplier
        GENERIC MAP(
            bitwidth => bitwidth
        )
        PORT MAP(
            clk => clk,
            rst => rst,
            a => lfsr1_out,
            b => lfsr2_out,
            result => mul_result,
            ready => mul_ready,
            valid => mul_valid,
            done  => mul_done
        );

    --Stimulus of multiplier. Go through a list of values and multiply them
    process
    begin
        wait until rst = '0';
        wait until rising_edge(clk);
        
        --Wait for multiplier to be ready. Might need to initialize
        if mul_ready = '0' then
            wait until mul_ready = '1';
        end if;
        
        for i in 0 to 10000 loop
        
            mul_valid <= '1';
            lfsr1_en <= '0';
            lfsr2_en <= '0';
            wait until rising_edge(clk);
            mul_valid <= '0';
            
            if mul_done = '0' then
                wait until mul_done = '1';
            end if;
            
            assert std_logic_vector(signed(lfsr1_out) * signed(lfsr2_out)) = mul_result
                report "Multiplications did not match" severity error;
                
            lfsr1_en <= '1';
            lfsr2_en <= '1';
            wait until rising_edge(clk);
        end loop;
        
        
    done <= '1';
    std.env.finish;
    wait;
    end process;
    
    
    --Two LFSR generates pseudo-random numbers for multiplying.
    lfsr1: entity work.lfsr 
    GENERIC MAP(
        G_M => bitwidth,
        G_POLY => lfsr1_poly
    )
    PORT MAP(
        i_clk  => clk,
        i_rstb => rst,
        o_lsfr => lfsr1_out,
        i_en   => lfsr1_en
    );
    
    lfsr2: entity work.lfsr 
    GENERIC MAP(
        G_M => bitwidth,
        G_POLY => lfsr2_poly
    )
    PORT MAP(
        i_clk => clk,
        i_rstb => rst,
        o_lsfr => lfsr2_out,
        i_en   => lfsr2_en
    );

    --clock process
    process
    begin
        wait for clock_period/2;
        clk <= not clk;
        
        if done = '1' then
            wait;
        end if;
    end process;
    
    --reset process
    process
    begin
        rst <= '1';
        wait for clock_period*5;
        rst <= '0';
        wait;
    end process;
    
end Behavioral;
