----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2020 12:11:34 PM
-- Design Name: 
-- Module Name: Asynchrounous multiplier - Behavioral
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

-- name             initiated
-- aclick0          yes
-- aclick1          yes
-- bclick0          yes
-- bclick1          yes
-- afork0           yes
-- afork1           yes
-- bfork0           yes
-- nor              yes
-- amux             yes
-- bmux             yes
-- csademuxin       yes
-- noaddsink        yes
-- CSA              yes
-- csaclick0        yes
-- csaclick1        yes
-- csademuxout      yes
-- csajoin          yes
-- csamux           yes, needs 0-input verification
-- donefork0        yes
-- donefork1        yes
-- donefork2        yes
-- donefork3        yes
-- CSAresetsource   yes



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplier_async is
    --Generic(
    --    BITWIDTH : integer := 8 
    --);
    Port ( 
        rst : in std_logic;
    --Handshake ports
        --Ingoing channel
        req_in : in std_logic;
        ack_out: out std_logic;

        --Outgoing channel
        req_out: out std_logic;
        ack_in : in std_logic;
        

        start : in std_logic;

        --Data
        a_in : in std_logic_vector(8 - 1 downto 0);
        b_in : in std_logic_vector(8 - 1 downto 0);
        result_out : out std_logic_vector(8 *2 - 1 downto 0)
    );

end multiplier_async;
    
architecture Behavior of multiplier_async is

    CONSTANT BITWIDTH : integer := 8;


    --DELAY SIGNALS
    CONSTANT SINK_DELAY : time := 1ns;
    CONSTANT CSA_DELAY : time := 30ns;
    CONSTANT SAFETY_MARGIN : real := 1.5;
    CONSTANT SOURCE_DELAY : time := 1ns;
        




    -- Signal and component declarations
    --fw: forward, bw: backward

    signal b_pad : std_logic_vector(BITWIDTH - 1 downto 0);
    
    signal in_fork_fwt_req : std_logic;
    signal in_fork_fwt_ack : std_logic;
    signal in_fork_fwb_req : std_logic;
    signal in_fork_fwb_ack : std_logic;

    signal a_mux_fw_req : std_logic;
    signal a_mux_fw_ack : std_logic;
    signal a_mux_fw_data : std_logic_vector(BITWIDTH - 1 downto 0);
    signal a_mux_fw_data_in : std_logic_vector(BITWIDTH - 1 downto 0);


    signal a_click_0_fw_req : std_logic;
    signal a_click_0_fw_ack : std_logic;
    signal a_click_0_fw_data : std_logic_vector(BITWIDTH - 1 downto 0);

    signal a_click_1_fw_req : std_logic;
    signal a_click_1_fw_ack : std_logic;
    signal a_click_1_fw_data : std_logic_vector(BITWIDTH - 1 downto 0);

    signal a_fork_0_fwt_req : std_logic;
    signal a_fork_0_fwt_ack : std_logic;
    signal a_fork_0_fwb_req : std_logic;
    signal a_fork_0_fwb_ack : std_logic;

    signal a_fork_2_fwt_req : std_logic;
    signal a_fork_2_fwt_ack : std_logic;
    signal a_fork_2_fwb_req : std_logic;
    signal a_fork_2_fwb_ack : std_logic;

    signal a_demux_fwb_req : std_logic;
    signal a_demux_fwb_ack : std_logic;
    signal a_demux_fwb_data : std_logic_vector(BITWIDTH - 1 downto 0);
    signal a_demux_fwc_req : std_logic;
    signal a_demux_fwc_ack : std_logic;
    signal a_demux_fwc_data : std_logic_vector(BITWIDTH - 1 downto 0);
    signal a_click_1_fw_data_shift :  std_logic_vector(BITWIDTH - 1 downto 0);


    signal b_demux_fwb_req : std_logic;
    signal b_demux_fwb_ack : std_logic;
    signal b_demux_fwb_data : std_logic_vector(BITWIDTH*2 - 1 downto 0);
    signal b_demux_fwc_req : std_logic;
    signal b_demux_fwc_ack : std_logic;
    signal b_demux_fwc_data : std_logic_vector(BITWIDTH*2 - 1 downto 0);
    signal b_click_1_fw_data_shift : std_logic_vector(BITWIDTH*2 - 1 downto 0);

    signal a_fork_1_fwt_req : std_logic;
    signal a_fork_1_fwt_ack : std_logic;
    signal a_fork_1_fwb_req : std_logic;
    signal a_fork_1_fwb_ack : std_logic;

    signal nor_fw_req : std_logic;
    signal nor_fw_ack : std_logic;
    signal nor_fw_data : std_logic;

    signal done_fork_0_fwt_req : std_logic;
    signal done_fork_0_fwt_ack : std_logic;
    signal done_fork_0_fwb_req : std_logic;
    signal done_fork_0_fwb_ack : std_logic;

    signal done_demux_fwb_req : std_logic;
    signal done_demux_fwb_ack : std_logic;
    signal done_demux_fwb_data : std_logic_vector(0 downto 0);
    signal done_demux_fwc_req : std_logic;
    signal done_demux_fwc_ack : std_logic;
    signal done_demux_fwc_data : std_logic_vector(0 downto 0);

    signal done_demux_selector : std_logic;

    signal done_fork_1_fwt_req : std_logic;
    signal done_fork_1_fwt_ack : std_logic;
    signal done_fork_1_fwb_req : std_logic;
    signal done_fork_1_fwb_ack : std_logic;

    signal done_fork_2_fwt_req : std_logic;
    signal done_fork_2_fwt_ack : std_logic;
    signal done_fork_2_fwb_req : std_logic;
    signal done_fork_2_fwb_ack : std_logic;

    signal done_fork_3_fwt_req : std_logic;
    signal done_fork_3_fwt_ack : std_logic;
    signal done_fork_3_fwb_req : std_logic;
    signal done_fork_3_fwb_ack : std_logic;

    signal done_fork_4_fwt_req : std_logic;
    signal done_fork_4_fwt_ack : std_logic;
    signal done_fork_4_fwb_req : std_logic;
    signal done_fork_4_fwb_ack : std_logic;

    signal done_fork_5_fwt_req : std_logic;
    signal done_fork_5_fwt_ack : std_logic;
    signal done_fork_5_fwb_req : std_logic;
    signal done_fork_5_fwb_ack : std_logic;

    signal done_fork_6_fwt_req : std_logic;
    signal done_fork_6_fwt_ack : std_logic;
    signal done_fork_6_fwb_req : std_logic;
    signal done_fork_6_fwb_ack : std_logic;

    signal done_fork_7_fwt_req : std_logic;
    signal done_fork_7_fwt_ack : std_logic;
    signal done_fork_7_fwb_req : std_logic;
    signal done_fork_7_fwb_ack : std_logic;

    signal demux_sel_delay_req : std_logic;
    signal csa_demux_in_req : std_logic;
    signal a_join_fw_req : std_logic;
    signal a_join_fw_ack : std_logic;

    signal b_join_fw_req : std_logic;
    signal b_join_fw_ack : std_logic;

    signal b_mux_fw_req : std_logic;
    signal b_mux_fw_ack : std_logic;
    signal b_mux_fw_data : std_logic_vector(BITWIDTH*2 - 1 downto 0);
    signal b_mux_fw_data_inA : std_logic_vector(BITWIDTH*2 - 1 downto 0);
    signal b_mux_fw_data_inB : std_logic_vector(BITWIDTH*2 - 1 downto 0);

    signal b_click_0_fw_req : std_logic;
    signal b_click_0_fw_ack : std_logic;
    signal b_click_0_fw_data : std_logic_vector(BITWIDTH*2 - 1 downto 0);

    signal b_click_1_fw_req : std_logic;
    signal b_click_1_fw_ack : std_logic;
    signal b_click_1_fw_data : std_logic_vector(BITWIDTH*2 - 1 downto 0);

    signal b_fork_0_fwt_req : std_logic;
    signal b_fork_0_fwt_ack : std_logic;
    signal b_fork_0_fwb_req : std_logic;
    signal b_fork_0_fwb_ack : std_logic;

    signal csa_demux_fwb_req : std_logic;
    signal csa_demux_fwb_ack : std_logic;
    signal csa_demux_fwb_data : std_logic_vector(BITWIDTH*2 - 1 downto 0);
    signal csa_demux_fwc_req : std_logic;
    signal csa_demux_fwc_ack : std_logic;
    signal csa_demux_fwc_data : std_logic_vector(BITWIDTH*2 - 1 downto 0);

    signal CSA_demux_in_selector : std_logic;
    signal CSA_demux_in_data : std_logic_vector(BITWIDTH*2 - 1 downto 0);
    

    signal CSA_join_fw_req : std_logic;
    signal CSA_join_fw_ack : std_logic;

    signal CSA_join_fw_delayed_req : std_logic;
    signal CSA_join_fw_delayed_ack : std_logic;

    signal CSA_carry : std_logic_vector(BITWIDTH*2-1 downto 0);
    signal CSA_sum : std_logic_vector(BITWIDTH*2-1 downto 0);

--    signal CSA_click_0_fw_ack : std_logic;
--    signal CSA_click_0_fw_req : std_logic;
--    signal CSA_click_0_fw_data : std_logic_vector(BITWIDTH*2 - 1 downto 0);


    signal CSA_click_0_fw_req : std_logic;
    signal CSA_click_0_fw_ack : std_logic;
    signal CSA_click_0_fw_data : std_logic_vector(BITWIDTH*2*2-1 downto 0); --*2*2 due to carry and sum
    signal CSA_click_0_data_in : std_logic_vector(BITWIDTH*2*2-1 downto 0);
    
    signal CSA_click_1_fw_req : std_logic;
    signal CSA_click_1_fw_ack : std_logic;
    signal CSA_click_1_fw_data : std_logic_vector(BITWIDTH*2*2-1 downto 0); --*2*2 due to carry and sum
    
    
    signal reset_barrier_a_click1 : std_logic;
    signal reset_barrier_CSA_click1 : std_logic;

    attribute dont_touch : string;
    attribute dont_touch of reset_barrier_a_click1 : signal is "true";
    attribute dont_touch of reset_barrier_CSA_click1 : signal is "true";
    

    signal csa_demux_out_fwb_req : std_logic;
    signal csa_demux_out_fwb_ack : std_logic;
    signal csa_demux_out_fwb_data : std_logic_vector(BITWIDTH*2*2 - 1 downto 0);
    signal csa_demux_out_fwc_req : std_logic;
    signal csa_demux_out_fwc_ack : std_logic;
    signal csa_demux_out_fwc_data : std_logic_vector(BITWIDTH*2*2 - 1 downto 0);

    signal csa_reset_src_req : std_logic;
    signal csa_reset_src_ack : std_logic;

    signal csa_mux_fw_req : std_logic;
    signal csa_mux_fw_ack : std_logic;
    signal csa_mux_fw_data : std_logic_vector(BITWIDTH*2*2 - 1 downto 0);

    signal result : std_logic_vector(BITWIDTH*2 - 1 downto 0);
    
begin


    --CSA
    b_pad <= (others => '0');
    --instantiate a operand click elements
    in_fork : entity work.fork
        generic map( 
          PHASE_INIT => '0'  -- set the phase to the same as the click element driving it
        ) 
        port map(
         rst => rst,
         -- Input channel
         inA_req => req_in,
         inA_ack => ack_out,
         -- Output channel 1
         outB_req => in_fork_fwt_req,
         outB_ack => in_fork_fwt_ack,
         -- Output channel 2
         outC_req => in_fork_fwb_req,
         outC_ack => in_fork_fwb_ack
        );


    a_click_0 : entity work.decoupled_hs_reg
        generic map(
            DATA_WIDTH => BITWIDTH,
            VALUE => 0
        )
        port map(
            rst => rst,
            -- Input channel
            in_ack => a_mux_fw_ack,
            in_req => a_mux_fw_req,
            in_data =>  a_mux_fw_data,
            -- Output channel
            out_req => a_click_0_fw_req,
            out_data => a_click_0_fw_data,
            out_ack => a_click_0_fw_ack
        );

    a_click_1 : entity work.decoupled_hs_reg
        generic map(
            DATA_WIDTH => BITWIDTH,
            VALUE => 0,
            PHASE_INIT_IN => '0',
            PHASE_INIT_OUT => '1'
        )
        port map(
            rst => rst,
            -- Input channel
            in_ack => a_click_0_fw_ack,
            in_req => a_click_0_fw_req,
            in_data =>  a_click_0_fw_data,
            -- Output channel
            out_req => a_click_1_fw_req,
            out_data => a_click_1_fw_data,
            out_ack => a_click_1_fw_ack
        );


    reset_barrier_a_click1 <= a_click_1_fw_req and start;

    a_fork_0 : entity work.fork
        generic map( 
          PHASE_INIT => '0'  -- set the phase to the same as the click element driving it
        ) 
        port map(
         rst => rst,
         -- Input channel
         inA_req => reset_barrier_a_click1,
         inA_ack => a_click_1_fw_ack,
         -- Output channel 1
         outB_req => a_fork_0_fwt_req,
         outB_ack => a_fork_0_fwt_ack,
         -- Output channel 2
         outC_req => a_fork_0_fwb_req,
         outC_ack => a_fork_0_fwb_ack
        );


    demux_sel_delay : entity work.delay_element
        generic map(
            size => 1
        )
        port map(
            d => a_join_fw_req,
            z => demux_sel_delay_req
        );
    done_demux_selector <= a_click_1_fw_data(0) or nor_fw_data;


    done_demux : entity work.demux
        generic map(
            DATA_WIDTH   => 1,
            PHASE_INIT_A => '0', --TODO consider INIT
            PHASE_INIT_B => '0',
            PHASE_INIT_C => '0'
        )
        port map(
            rst => rst,
            -- Input port
            inA_req => done_fork_6_fwt_req,
            inA_data => (others => '0'),
            inA_ack => done_fork_6_fwt_ack,
            -- Select port 
            inSel_req => a_fork_2_fwt_req,  
            inSel_ack => a_fork_2_fwt_ack,
            selector => done_demux_selector,
            -- Output channel 1
            outB_req => done_demux_fwb_req,   
            outB_data => done_demux_fwb_data,
            outB_ack => done_demux_fwb_ack,
            -- Output channel 2
            outC_req => done_demux_fwc_req,  --
            outC_data => done_demux_fwc_data,
            outC_ack => done_demux_fwc_ack
            );

    done_DEMUX_SINK : entity work.sink
        generic map(
            BITWIDTH => 1,
            sink_delay => sink_delay
        )
        port map(
            req_in  => done_demux_fwc_req,
            ack_out => done_demux_fwc_ack,
            data_in => done_demux_fwc_data
        );

    a_click_1_fw_data_shift <= '0' & a_click_1_fw_data(BITWIDTH-1 downto 1);
  
    a_demux : entity work.demux
        generic map(
            DATA_WIDTH   => BITWIDTH,
            PHASE_INIT_A => '0', --TODO consider INIT
            PHASE_INIT_B => '0',
            PHASE_INIT_C => '0'
        )
        port map(
            rst => rst,
            -- Input port
            inA_req => a_fork_0_fwt_req,
            inA_data => a_click_1_fw_data_shift,
            inA_ack => a_fork_0_fwt_ack,
            -- Select port 
            inSel_req => done_fork_4_fwb_req,
            inSel_ack => done_fork_4_fwb_ack,
            selector => nor_fw_data,
            -- Output channel 1
            outB_req => a_demux_fwb_req,   --sink
            outB_data => a_demux_fwb_data,
            outB_ack => a_demux_fwb_ack,
            -- Output channel 2
            outC_req => a_demux_fwc_req,  --amux
            outC_data => a_demux_fwc_data,
            outC_ack => a_demux_fwc_ack
            );


            a_new_sink : entity work.sink
            generic map(
                BITWIDTH => BITWIDTH,
                sink_delay => sink_delay
            )
            port map(
                req_in  => a_demux_fwb_req,
                ack_out => a_demux_fwb_ack,
                data_in => a_demux_fwb_data
            );

    a_fork_1 : entity work.fork
        generic map( 
          PHASE_INIT => '0'  
        ) 
        port map(
         rst => rst,
         -- Input channel
         inA_req => a_fork_0_fwb_req,
         inA_ack => a_fork_0_fwb_ack,
         -- Output channel 1
         outB_req => a_fork_1_fwt_req,
         outB_ack => a_fork_1_fwt_ack,
         -- Output channel 2
         outC_req => a_fork_1_fwb_req,
         outC_ack => a_fork_1_fwb_ack
        );

    a_fork_2 : entity work.fork
        generic map( 
          PHASE_INIT => '0'  
        ) 
        port map(
         rst => rst,
         -- Input channel
         inA_req => demux_sel_delay_req,
         inA_ack => a_join_fw_ack,
         -- Output channel 1
         outB_req => a_fork_2_fwt_req,
         outB_ack => a_fork_2_fwt_ack,
         -- Output channel 2
         outC_req => a_fork_2_fwb_req,
         outC_ack => a_fork_2_fwb_ack
        );


        nor_gate1 : entity work.NOR_gate
            Generic map(
                BITWIDTH => BITWIDTH,
                NOR_DELAY => 2 ps --TODO decide this time 
            )
            Port map( 
                in_req => a_fork_1_fwt_req,
                in_ack => a_fork_1_fwt_ack,
                in_bus => a_click_1_fw_data,
                -- Output channel
                out_req => nor_fw_req,
                out_ack => nor_fw_ack,
                result => nor_fw_data
            );

    done_fork_0 : entity work.fork
            generic map( 
              PHASE_INIT => '0'  
            ) 
            port map(
             rst => rst,
             -- Input channel
             inA_req => nor_fw_req,
             inA_ack => nor_fw_ack,
             -- Output channel 1
             outB_req => done_fork_0_fwt_req,
             outB_ack => done_fork_0_fwt_ack,
             -- Output channel 2
             outC_req => done_fork_0_fwb_req,
             outC_ack => done_fork_0_fwb_ack
            );
            
    done_fork_1 : entity work.fork
            generic map( 
              PHASE_INIT => '0'  
            ) 
            port map(
             rst => rst,
             -- Input channel
             inA_req => done_demux_fwb_req,
             inA_ack => done_demux_fwb_ack,
             -- Output channel 1
             outB_req => done_fork_1_fwt_req,
             outB_ack => done_fork_1_fwt_ack,
             -- Output channel 2
             outC_req => done_fork_1_fwb_req,
             outC_ack => done_fork_1_fwb_ack
            );


    done_fork_3 : entity work.fork
            generic map( 
              PHASE_INIT => '0'  
            ) 
            port map(
             rst => rst,
             -- Input channel
             inA_req => done_fork_0_fwt_req,
             inA_ack => done_fork_0_fwt_ack,
             -- Output channel 1
             outB_req => done_fork_3_fwt_req,
             outB_ack => done_fork_3_fwt_ack,
             -- Output channel 2
             outC_req => done_fork_3_fwb_req,
             outC_ack => done_fork_3_fwb_ack
            );

    done_fork_4 : entity work.fork
            generic map( 
              PHASE_INIT => '0'  
            ) 
            port map(
             rst => rst,
             -- Input channel
             inA_req => done_fork_3_fwb_req,
             inA_ack => done_fork_3_fwb_ack,
             -- Output channel 1
             outB_req => done_fork_4_fwt_req,
             outB_ack => done_fork_4_fwt_ack,
             -- Output channel 2
             outC_req => done_fork_4_fwb_req,
             outC_ack => done_fork_4_fwb_ack
            );

    done_fork_5 : entity work.fork
            generic map( 
              PHASE_INIT => '0'  
            ) 
            port map(
             rst => rst,
             -- Input channel
             inA_req => done_fork_3_fwt_req,
             inA_ack => done_fork_3_fwt_ack,
             -- Output channel 1
             outB_req => done_fork_5_fwt_req,
             outB_ack => done_fork_5_fwt_ack,
             -- Output channel 2
             outC_req => done_fork_5_fwb_req,
             outC_ack => done_fork_5_fwb_ack
            );

    done_fork_6 : entity work.fork
            generic map( 
              PHASE_INIT => '0'  
            ) 
            port map(
             rst => rst,
             -- Input channel
             inA_req => done_fork_0_fwb_req,
             inA_ack => done_fork_0_fwb_ack,
             -- Output channel 1
             outB_req => done_fork_6_fwt_req,
             outB_ack => done_fork_6_fwt_ack,
             -- Output channel 2
             outC_req => done_fork_6_fwb_req,
             outC_ack => done_fork_6_fwb_ack
            );

    done_fork_7 : entity work.fork
            generic map( 
              PHASE_INIT => '0'  
            ) 
            port map(
             rst => rst,
             -- Input channel
             inA_req => done_fork_6_fwb_req,
             inA_ack => done_fork_6_fwb_ack,
             -- Output channel 1
             outB_req => done_fork_7_fwt_req,
             outB_ack => done_fork_7_fwt_ack,
             -- Output channel 2
             outC_req => done_fork_7_fwb_req,
             outC_ack => done_fork_7_fwb_ack
            );
    
    a_join : entity work.join
        generic map(
            PHASE_INIT => '0' --TODO verify phase
        )
        port map(
            rst => rst,
            --UPSTREAM channels
            inA_req => done_fork_7_fwb_req,
            inA_ack => done_fork_7_fwb_ack,
            inB_req => a_fork_1_fwb_req,
            inB_ack => a_fork_1_fwb_ack,
            --DOWNSTREAM channel
            outC_req => a_join_fw_req,
            outC_ack => a_join_fw_ack

        );

        b_join : entity work.join
        generic map(
            PHASE_INIT => '0' --TODO verify phase
        )
        port map(
            rst => rst,
            --UPSTREAM channels
            inA_req => done_fork_7_fwt_req,
            inA_ack => done_fork_7_fwt_ack,
            inB_req => b_fork_0_fwb_req,
            inB_ack => b_fork_0_fwb_ack,
            --DOWNSTREAM channel
            outC_req => b_join_fw_req,
            outC_ack => b_join_fw_ack

        );
    
    
    a_mux : entity work.mux
        --generic for initializing the phase registers
        generic map (
           DATA_WIDTH => BITWIDTH,
           PHASE_INIT_C => '0',
           PHASE_INIT_A => '0',
           PHASE_INIT_B => '0',
           PHASE_INIT_SEL => '0'
        )
        port map(
          rst => rst,
          -- Input from channel 1
          inA_req => in_fork_fwt_req,
          inA_data => a_in,
          inA_ack => in_fork_fwt_ack,
          -- Input from channel 2
          inB_req => a_demux_fwc_req,
          inB_data => a_demux_fwc_data,
          inB_ack => a_demux_fwc_ack,
          -- Output port 
          outC_req => a_mux_fw_req,
          outC_data => a_mux_fw_data,
          outC_ack => a_mux_fw_ack,
          -- Select port
          inSel_req => done_fork_4_fwt_req,
          inSel_ack => done_fork_4_fwt_ack,
          selector(0) => nor_fw_data
          );

        
      b_click_0 : entity work.decoupled_hs_reg
          generic map(
              DATA_WIDTH => BITWIDTH*2,
              VALUE => 0
          )
          port map(
              rst => rst,
              -- Input channel
              in_ack => b_mux_fw_ack,
              in_req => b_mux_fw_req,
              in_data =>  b_mux_fw_data,
              -- Output channel
              out_req => b_click_0_fw_req,
              out_data => b_click_0_fw_data,
              out_ack => b_click_0_fw_ack
          );
  
      b_click_1 : entity work.decoupled_hs_reg
          generic map(
              DATA_WIDTH => BITWIDTH*2,
              VALUE => 0,
              PHASE_INIT_OUT => '1'
          )
          port map(
              rst => rst,
              -- Input channel
              in_ack => b_click_0_fw_ack,
              in_req => b_click_0_fw_req,
              in_data =>  b_click_0_fw_data,
              -- Output channel
              out_req => b_click_1_fw_req,
              out_data => b_click_1_fw_data,
              out_ack => b_click_1_fw_ack
          );
  
      b_fork_0 : entity work.fork
          generic map( 
            PHASE_INIT => '0'  -- set the phase to the same as the click element driving it
          ) 
          port map(
           rst => rst,
           -- Input channel
           inA_req => b_click_1_fw_req,
           inA_ack => b_click_1_fw_ack,
           -- Output channel 1
           outB_req => b_fork_0_fwt_req,
           outB_ack => b_fork_0_fwt_ack,
           -- Output channel 2
           outC_req => b_fork_0_fwb_req,
           outC_ack => b_fork_0_fwb_ack
          );
          

    b_click_1_fw_data_shift <= (b_click_1_fw_data(BITWIDTH*2-2 downto 0) & '0');
    B_DEMUX_IN : entity work.demux
          generic map(
              DATA_WIDTH   => BITWIDTH*2,
              PHASE_INIT_A => '0', --TODO consider INIT
              PHASE_INIT_B => '0',
              PHASE_INIT_C => '0'
          )
          port map(
              rst => rst,
              -- Input port
              inA_req => b_fork_0_fwt_req,
              inA_data => b_click_1_fw_data_shift,
              inA_ack => b_fork_0_fwt_ack,
              -- Select port 
              inSel_req => done_fork_5_fwb_req,
              inSel_ack => done_fork_5_fwb_ack,
              selector => nor_fw_data,
              -- Output channel 1
              outB_req => b_demux_fwb_req,   --TODO Verify that the selector decides the intented output
              outB_data => b_demux_fwb_data,
              outB_ack => b_demux_fwb_ack,
              -- Output channel 2
              outC_req => b_demux_fwc_req,
              outC_data => b_demux_fwc_data,
              outC_ack => b_demux_fwc_ack
              );



    B_DEMUX_SINK : entity work.sink
            generic map(
                BITWIDTH => BITWIDTH*2,
                sink_delay => sink_delay
            )
            port map(
                req_in  => b_demux_fwb_req,
                ack_out => b_demux_fwb_ack,
                data_in => b_demux_fwb_data
            );
              
              b_mux_fw_data_inA <= b_pad & b_in;
      

      b_mux : entity work.mux
          --generic for initializing the phase registers
          generic map (
             DATA_WIDTH => BITWIDTH*2,
             PHASE_INIT_C => '0',
             PHASE_INIT_A => '0',
             PHASE_INIT_B => '0',
             PHASE_INIT_SEL => '0'
          )
          port map(
            rst => rst,
            -- Input from channel 1
            inA_req => in_fork_fwb_req,
            inA_data => b_mux_fw_data_inA,
            inA_ack => in_fork_fwb_ack,
            -- Input from channel 2
            inB_req => b_demux_fwc_req,
            inB_data => b_demux_fwc_data,
            inB_ack => b_demux_fwc_ack,
            -- Output port 
            outC_req => b_mux_fw_req,
            outC_data => b_mux_fw_data,
            outC_ack => b_mux_fw_ack,
            -- Select port
            inSel_req => done_fork_5_fwt_req,
            inSel_ack => done_fork_5_fwt_ack,
            selector(0) => nor_fw_data
            );


    CSA_demux_in_selector <= a_click_1_fw_data(0) or nor_fw_data;
    csa_demux_in_delay : entity work.delay_element
        generic map(
            size => 1
        )
        port map(
            d => b_join_fw_req,
            z => csa_demux_in_req
        );

    CSA_demux_in_data <= b_click_1_fw_data when nor_fw_data = '0' else (others => '0');
    CSA_DEMUX_IN : entity work.demux
        generic map(
            DATA_WIDTH   => BITWIDTH*2,
            PHASE_INIT_A => '0', --TODO consider INIT
            PHASE_INIT_B => '0',
            PHASE_INIT_C => '0'
        )
        port map(
            rst => rst,
            -- Input port
            inA_req => csa_demux_in_req,
            inA_data => CSA_demux_in_data,
            inA_ack => b_join_fw_ack,
            -- Select port 
            inSel_req => a_fork_2_fwb_req,
            inSel_ack => a_fork_2_fwb_ack,
            selector => CSA_demux_in_selector,
            -- Output channel 1
            outB_req => csa_demux_fwb_req,   --TODO Verify that the selector decides the intented output
            outB_data => csa_demux_fwb_data,
            outB_ack => csa_demux_fwb_ack,
            -- Output channel 2
            outC_req => csa_demux_fwc_req,
            outC_data => csa_demux_fwc_data,
            outC_ack => csa_demux_fwc_ack
            );

        
    NO_ADD_SINK : entity work.sink
        generic map(
            BITWIDTH => BITWIDTH*2,
            sink_delay => sink_delay
        )
        port map(
            req_in  => csa_demux_fwc_req,
            ack_out => csa_demux_fwc_ack,
            data_in => csa_demux_fwc_data
        );

    CSA_JOIN : entity work.join
        generic map(
            PHASE_INIT => '0' --TODO verify phase
        )
        port map(
            rst => rst,
            --UPSTREAM channels
            inA_req => csa_mux_fw_req,
            inA_ack => csa_mux_fw_ack,
            inB_req => csa_demux_fwb_req,
            inB_ack => csa_demux_fwb_ack,
            --DOWNSTREAM channel
            outC_req => CSA_join_fw_req,
            outC_ack => CSA_join_fw_ack

        );

    CSA1 : entity work.CSA
        generic map(
            BITWIDTH => BITWIDTH*2,
            CSA_DELAY => CSA_DELAY
        )
        port map(
            CSA_in_0 => csa_mux_fw_data(BITWIDTH*2-1 downto 0),
            CSA_in_1 => csa_mux_fw_data(BITWIDTH*2*2-1 downto BITWIDTH*2),
            CSA_in_2 => csa_demux_fwb_data,

            CSA_out_S => CSA_sum,
            CSA_out_C => CSA_carry
        );



    csa_delay_req : entity work.delay_element
        generic map(
            size => 6
        )
        port map(
            d => CSA_join_fw_req,
            z => CSA_join_fw_delayed_req
        );

--    csa_delay_reg : entity work.delay_element_sim
--        generic map(
--            delay => CSA_DELAY * SAFETY_MARGIN
--        )
--        port map(
--            d => CSA_join_fw_req,
--            z => CSA_join_fw_delayed_req
--        );


--    csa_delay_ack : entity work.delay_element_sim
--        generic map(
--            delay => CSA_DELAY * SAFETY_MARGIN
--        )
--        port map(
--            d => CSA_join_fw_ack,
--            z => CSA_join_fw_delayed_ack
--        );


    CSA_click_0_data_in <= CSA_sum & (CSA_carry(BITWIDTH*2-2 downto 0) & '0');
    csa_click_0 : entity work.decoupled_hs_reg
        generic map(
            DATA_WIDTH => BITWIDTH*2*2,
            VALUE => 0
        )
        port map(
            rst => rst,
            -- Input channel
            in_ack => CSA_join_fw_ack,
            in_req => CSA_join_fw_delayed_req,
            in_data =>  CSA_click_0_data_in,
            -- Output channel
            out_req => CSA_click_0_fw_req,
            out_data => CSA_click_0_fw_data,
            out_ack => CSA_click_0_fw_ack
        );


    csa_click_1 : entity work.decoupled_hs_reg
        generic map(
            DATA_WIDTH => BITWIDTH*2*2,
            VALUE => 0,
            PHASE_INIT_IN => '0',
            PHASE_INIT_OUT => '1'
        )
        port map(
            rst => rst,
            -- Input channel
            in_ack => CSA_click_0_fw_ack,
            in_req => CSA_click_0_fw_req,
            in_data =>  CSA_click_0_fw_data,
            -- Output channel
            out_req => CSA_click_1_fw_req,
            out_data => CSA_click_1_fw_data,
            out_ack => CSA_click_1_fw_ack
        );

    reset_barrier_CSA_click1 <= CSA_click_1_fw_req AND start;



    CSA_DEMUX_OUT : entity work.demux
        generic map(
            DATA_WIDTH   => BITWIDTH*2*2,
            PHASE_INIT_A => '0', --TODO consider INIT
            PHASE_INIT_B => '0',
            PHASE_INIT_C => '0'
        )
        port map(
            rst => rst,
            -- Input port
            inA_req => reset_barrier_CSA_click1,
            inA_data => CSA_click_1_fw_data,
            inA_ack => CSA_click_1_fw_ack,
            -- Select port 
            inSel_req => done_fork_1_fwb_req,
            inSel_ack => done_fork_1_fwb_ack,
            selector => nor_fw_data,
            -- Output channel 1
            outC_req => csa_demux_out_fwb_req,   --TODO Verify that the selector decides the intented output
            outC_data => csa_demux_out_fwb_data,
            outC_ack => csa_demux_out_fwb_ack,
            -- Output channel 2
            outB_req => csa_demux_out_fwc_req,
            outB_data => csa_demux_out_fwc_data,
            outB_ack => csa_demux_out_fwc_ack
            );


    
--    RES_SINK : entity work.sink
--    generic map(
--        BITWIDTH => BITWIDTH*2*2,
--        sink_delay => sink_delay
--    )
--    port map(
--        req_in  => csa_demux_out_fwc_req,
--        ack_out => csa_demux_out_fwc_ack,
--        data_in => csa_demux_out_fwc_data
--    );
    req_out <= csa_demux_out_fwc_req;
    csa_demux_out_fwc_ack <= ack_in;

    result_out <= std_logic_vector( unsigned(csa_demux_out_fwc_data(BITWIDTH*2*2-1 downto BITWIDTH*2)) + unsigned(csa_demux_out_fwc_data(BITWIDTH*2-1    downto 0)));
    



    CSA_RESET_SOURCE : entity work.source 
    generic map( -- TODO check this component
        source_delay => source_delay
    )
    port map(
        req_out => csa_reset_src_req,
        ack_in  => csa_reset_src_ack
    );

    csa_mux : entity work.mux
        --generic for initializing the phase registers
        generic map (
           DATA_WIDTH => BITWIDTH*2*2,
           PHASE_INIT_C => '0', --TODO check init values
           PHASE_INIT_A => '0',
           PHASE_INIT_B => '0',
           PHASE_INIT_SEL => '0'
        )
        port map(
          rst => rst,
          -- Input from channel 1
          inA_req => csa_reset_src_req,
          inA_data => (others => '0'),
          inA_ack => csa_reset_src_ack,
          -- Input from channel 2
          inB_req => csa_demux_out_fwb_req,
          inB_data => csa_demux_out_fwb_data,
          inB_ack => csa_demux_out_fwb_ack,
          -- Output port 
          outC_req => csa_mux_fw_req,
          outC_data => csa_mux_fw_data,
          outC_ack => csa_mux_fw_ack,
          -- Select port
          inSel_req => done_fork_1_fwt_req,
          inSel_ack => done_fork_1_fwt_ack,
          selector(0) => nor_fw_data
          );

--TODO:
--  Fix flushing
--  Fix req-ack to input - Look ok
--  Fix req-ack to output
--  Add results
--  Fix req-out for tb
-- we have added or gate neglecting delay


-- man kan lave en renerer demux sink løsning
-- annoter handhaske kritrier på figu

end Behavior;