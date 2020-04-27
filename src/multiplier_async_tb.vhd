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

entity multiplier_async_tb is
--  Port ( );
end multiplier_async_tb;

architecture Behavioral of multiplier_async_tb is

    -- Clock period definitions
    constant clock_period : time := 20 ns;
    
    constant bitwidth : integer := 32; 
    constant lfsr1_poly : std_logic_vector := ("01001011001010100100101100101010");
    constant lfsr2_poly : std_logic_vector := ("01101010001000100110101000100010");
    --constant lfsr1_poly : std_logic_vector := ("01101010");
    --constant lfsr2_poly : std_logic_vector := ("00100010");
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
    
    

    --Multiplier data
    signal a_in, b_in : std_logic_vector(bitwidth-1 downto 0);

    --Handshake for multiplier
    signal req_in, req_out : std_logic := '0';
    signal ack_out, ack_in : std_logic := '0';

    signal nreset : std_logic;
begin

    nreset <= not rst;

    --Sink the output using a loopback
    ack_in <= transport req_out after 1 ns; 


    multiplier: entity work.multiplier_async
        --GENERIC MAP(
        --    BITWIDTH => bitwidth
        --)
        PORT MAP(
            rst => rst,

            req_in => req_in,
            req_out => req_out,

            ack_in => ack_in,
            ack_out => ack_out,

            start => nreset,

            --Data
            a_in => a_in,
            b_in => b_in,

            result_out => mul_result
        );

    --Stimulus of multiplier. Go through a list of values and multiply them
    process
    begin
        
        a_in <= (others => '0');
        b_in <= (others => '0');
        
        
        wait until rst = '0';

        wait for 100 ns;
        

        


        for i in 0 to 10000 loop
            lfsr1_en <= '0';
            lfsr2_en <= '0';

            wait until falling_edge(clk);

            if req_in /= ack_out then
                wait until req_in = ack_out;
            end if;

            req_in <= not req_in;
            

            --a_in <= std_logic_vector(to_unsigned(43690,32));-- lfsr1_out;
            --b_in <= std_logic_vector(to_unsigned(4095,32));--lfsr1_out;
            a_in <= lfsr1_out;
            b_in <= lfsr2_out;

            -- Wait until req_out triggers
            --report "waiting for req_out to change";
            wait on req_out;
            --report "Req_out changed";



            
            assert std_logic_vector(unsigned(lfsr1_out) * unsigned(lfsr2_out)) = mul_result
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
