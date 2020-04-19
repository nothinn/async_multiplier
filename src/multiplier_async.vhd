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
    Generic(
        BITWIDTH : integer := 16
    );
    Port ( 
        rst : std_logic;
    --Handshake ports
        --Ingoing channel
        req_in : std_logic;
        ack_out: std_logic;

        --Outgoing channel
        req_out: std_logic;
        ack_in : std_logic;
        


        --Data
        a_in : std_logic_vector(BITWIDTH - 1 downto 0);
        b_in : std_logic_vector(BITWIDTH - 1 downto 0);
        result_out : std_logic_vector(BITWIDTH*2 - 1 downto 0)
    );

end multiplier_async;
    
architecture Behavior of multiplier_async is
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

    signal b_mux_fw_req : std_logic;
    signal b_mux_fw_ack : std_logic;
    signal b_mux_fw_data : std_logic_vector(BITWIDTH*2 - 1 downto 0);

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

    signal csa_demux_in_fwb_req : std_logic;
    signal csa_demux_in_fwb_ack : std_logic;
    signal csa_demux_in_fwb_data : std_logic_vector(BITWIDTH*2 - 1 downto 0);
    signal csa_demux_in_fwc_req : std_logic;
    signal csa_demux_in_fwc_ack : std_logic;
    signal csa_demux_in_fwc_data : std_logic_vector(BITWIDTH*2 - 1 downto 0);

    signal CSA_join_fw_req : std_logic;
    signal CSA_join_fw_ack : std_logic;

    signal CSA_carry : std_logic_vector(BITWIDTH*2-1 downto 0);
    signal CSA_sum : std_logic_vector(BITWIDTH*2-1 downto 0);

    signal CSA_click_0_fw_req : std_logic;
    signal CSA_click_0_fw_ack : std_logic;
    signal CSA_click_0_fw_data : std_logic_vector(BITWIDTH*2 - 1 downto 0);


    signal CSA_click_0_fw_req : std_logic;
    signal CSA_click_0_fw_ack : std_logic;
    signal CSA_click_0_fw_data : std_logic_vector(BITWIDTH*2*2-1 downto 0); --*2*2 due to carry and sum
    
    signal CSA_click_1_fw_req : std_logic;
    signal CSA_click_1_fw_ack : std_logic;
    signal CSA_click_1_fw_data : std_logic_vector(BITWIDTH*2*2-1 downto 0); --*2*2 due to carry and sum
    
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
    
begin


    --CSA
    b_pad => (others => '0');
    --instantiate a operand click elements
    in_fork : entity work.fork
        generic map( 
          PHASE_INIT => '1'  -- set the phase to the same as the click element driving it
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


    a_click_0 : entity work.click_element
        generic map(
            DATA_WIDTH => BITWIDTH,
            VALUE => 0,
            PHASE_INIT => '0'
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

    a_click_1 : entity work.click_element
        generic map(
            DATA_WIDTH => BITWIDTH,
            VALUE => 0,
            PHASE_INIT => '1'
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

    a_fork_0 : entity work.fork
        generic map( 
          PHASE_INIT => '1'  -- set the phase to the same as the click element driving it
        ) 
        port map(
         rst => rst,
         -- Input channel
         inA_req => a_click_1_fw_req,
         inA_ack => a_click_1_fw_ack,
         -- Output channel 1
         outB_req => a_fork_0_fwt_req,
         outB_ack => a_fork_0_fwt_ack,
         -- Output channel 2
         outC_req => a_fork_0_fwb_req,
         outC_ack => a_fork_0_fwb_ack
        );

    a_fork_1 : entity work.fork
        generic map( 
          PHASE_INIT => '1'  
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
              PHASE_INIT => '1'  
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
              PHASE_INIT => '1'  
            ) 
            port map(
             rst => rst,
             -- Input channel
             inA_req => done_fork_0_fwb_req,
             inA_ack => done_fork_0_fwb_ack,
             -- Output channel 1
             outB_req => done_fork_1_fwt_req,
             outB_ack => done_fork_1_fwt_ack,
             -- Output channel 2
             outC_req => done_fork_1_fwb_req,
             outC_ack => done_fork_1_fwb_ack
            );

    done_fork_2 : entity work.fork
            generic map( 
              PHASE_INIT => '1'  
            ) 
            port map(
             rst => rst,
             -- Input channel
             inA_req => done_fork_1_fwt_req,
             inA_ack => done_fork_1_fwt_ack,
             -- Output channel 1
             outB_req => done_fork_2_fwt_req,
             outB_ack => done_fork_2_fwt_ack,
             -- Output channel 2
             outC_req => done_fork_2_fwb_req,
             outC_ack => done_fork_2_fwb_ack
            );

    done_fork_3 : entity work.fork
            generic map( 
              PHASE_INIT => '1'  
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
    
    a_mux : entity work.mux
        --generic for initializing the phase registers
        generic map (
           DATA_WIDTH => BITWIDTH,
           PHASE_INIT_C => '0',
           PHASE_INIT_A => '1',
           PHASE_INIT_B => '0',
           PHASE_INIT_SEL => '1'
        );
        port(
          rst => rst,
          -- Input from channel 1
          inA_req => in_fork_fwt_req,
          inA_data => a_in
          inA_ack => in_fork_fwt_ack,
          -- Input from channel 2
          inB_req => a_fork_0_fwt_req,
          inB_data => '0' & a_click_1_fw_data(BITWIDTH-1 downto 1),
          inB_ack => a_fork_0_fwt_ack,
          -- Output port 
          outC_req => a_mux_fw_req,
          outC_data => a_mux_fw_data,
          outC_ack => a_mux_fw_req,
          -- Select port
          inSel_req => done_fork_3_fwb_req,
          inSel_ack => done_fork_3_fwb_ack,
          selector => nor_fw_data
          );

        
      b_click_0 : entity work.click_element
          generic map(
              DATA_WIDTH => BITWIDTH*2,
              VALUE => 0,
              PHASE_INIT => '0'
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
  
      a_click_1 : entity work.click_element
          generic map(
              DATA_WIDTH => BITWIDTH*2,
              VALUE => 0,
              PHASE_INIT => '1'
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
            PHASE_INIT => '1'  -- set the phase to the same as the click element driving it
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


      b_mux : entity work.mux
          --generic for initializing the phase registers
          generic map (
             DATA_WIDTH => BITWIDTH*2,
             PHASE_INIT_C => '0',
             PHASE_INIT_A => '1',
             PHASE_INIT_B => '0',
             PHASE_INIT_SEL => '1'
          );
          port(
            rst => rst,
            -- Input from channel 1
            inA_req => in_fork_fwb_req,
            inA_data => b_pad & b_in
            inA_ack => in_fork_fwb_ack,
            -- Input from channel 2
            inB_req => b_fork_0_fwt_req,
            inB_data => b_click_1_fw_data(BITWIDTH*2-2 downto 0) & '0',
            inB_ack => b_fork_0_fwt_ack,
            -- Output port 
            outC_req => b_mux_fw_req,
            outC_data => b_mux_fw_data,
            outC_ack => b_mux_fw_req,
            -- Select port
            inSel_req => done_fork_3_fwt_req,
            inSel_ack => done_fork_3_fwt_ack,
            selector => nor_fw_data
            );

    CSA_DEMUX_IN : entity work.demux
        generic map(
            PHASE_INIT_A => '1', --TODO consider INIT
            PHASE_INIT_B => '0',
            PHASE_INIT_C => '0'
        );
        port(
            rst => rst,
            -- Input port
            inA_req => b_fork_0_fwb_req,
            inA_data => b_click_1_fw_data,
            inA_ack => b_fork_0_fwb_ack,
            -- Select port 
            inSel_req => done_fork_1_fwb_req,
            inSel_ack => done_fork_1_fwb_ack,
            selector => a_click_1_fw_data(0),
            -- Output channel 1
            outB_req => csa_demux_in_fwb_req,   --TODO Verify that the selector decides the intented output
            outB_data => csa_demux_in_fwb_data,
            outB_ack => csa_demux_in_fwb_ack,
            -- Output channel 2
            outC_req => csa_demux_in_fwc_req,
            outC_data => csa_demux_in_fwc_data,
            outC_ack => csa_demux_in_fwc_ack
            );

        
    NO_ADD_SINK : entity work.sink
        generic map(
            BITWIDTH => BITWIDTH*2,
            sink_delay => sink_delay
        );
        port(
            req_in  => csa_demux_in_fwb_req,
            ack_out => csa_demux_in_fwb_ack,
            data_in => csa_demux_in_fwb_data
        );

    CSA_JOIN : entity work.join
        generic map(
            PHASE_INIT => '0' --TODO verify phase
        );
        port(
            rst => rst,
            --UPSTREAM channels
            inA_req => csa_mux_fw_req,
            inA_ack => csa_mux_fw_ack,
            inB_req => csa_demux_in_fwc_req,
            inB_ack => csa_demux_in_fwc_ack,
            --DOWNSTREAM channel
            outC_req => CSA_join_fw_req,
            outC_ack => CSA_join_fw_ack

        )

    CSA1 : entity work.CSA
        generic map(
            BITWIDTH => BITWIDTH*2,
            CSA_DELAY => CSA_DELAY
        )
        port(
            CSA_in_0 => csa_demux_out_fwb_data(BITWIDTH*2-1 downto 0),
            CSA_in_1 => csa_demux_out_fwb_data(BITWIDTH*2*2-1 downto BITWIDTH*2),
            CSA_in_2 => csa_demux_in_fwb_data,

            CSA_out_S => CSA_sum,
            CSA_out_C => CSA_carry
        )



    csa_delay_reg : entity work.delay_element_sim
        generic map(
            delay => CSA_DELAY * SAFETY_MARGIN
        )
        port map(
            d => CSA_join_fw_req,
            z => CSA_join_fw_delayed_req
        );


    csa_delay_ack : entity work.delay_element_sim
        generic map(
            delay => CSA_DELAY * SAFETY_MARGIN
        )
        port map(
            d => CSA_join_fw_ack,
            z => CSA_join_fw_delayed_ack
        );


    csa_click_0 : entity work.click_element
        generic map(
            DATA_WIDTH => BITWIDTH*2*2,
            VALUE => 0,
            PHASE_INIT => '1' --TODO check phase
        )
        port map(
            rst => rst,
            -- Input channel
            in_ack => CSA_join_fw_delayed_ack,
            in_req => CSA_join_fw_delayed_req,
            in_data =>  CSA_sum & CSA_carry,
            -- Output channel
            out_req => CSA_click_0_fw_req,
            out_data => CSA_click_0_fw_data,
            out_ack => CSA_click_0_fw_ack
        );


    csa_click_1 : entity work.click_element
        generic map(
            DATA_WIDTH => BITWIDTH*2*2,
            VALUE => 0,
            PHASE_INIT => '1' --TODO check phase
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



    CSA_DEMUX_OUT : entity work.demux
        generic map(
            PHASE_INIT_A => '1', --TODO consider INIT
            PHASE_INIT_B => '0',
            PHASE_INIT_C => '0'
        );
        port(
            rst => rst,
            -- Input port
            inA_req => CSA_click_1_fw_req,
            inA_data => b_click_1_fw_data,
            inA_ack => CSA_click_1_fw_ack,
            -- Select port 
            inSel_req => done_fork_2_fwb_req,
            inSel_ack => done_fork_2_fwb_ack,
            selector => nor_fw_data,
            -- Output channel 1
            outB_req => csa_demux_out_fwb_req,   --TODO Verify that the selector decides the intented output
            outB_data => csa_demux_out_fwb_data,
            outB_ack => csa_demux_out_fwb_ack,
            -- Output channel 2
            outC_req => csa_demux_out_fwc_req,
            outC_data => csa_demux_out_fwc_data,
            outC_ack => csa_demux_out_fwc_ack
            );


    RES_SINK : entity work.sink
    generic map(
        BITWIDTH => BITWIDTH*2*2,
        sink_delay => sink_delay
    );
    port(
        req_in  => csa_demux_out_fwc_req,
        ack_out => csa_demux_out_fwc_ack,
        data_in => csa_demux_out_fwc_data
    );

    CSA_RESET_SOURCE : entity work.source 
    generic map( -- TODO check this component
        source_delay => source_delay
    );
    port(
        req_out => csa_reset_src_req,
        ack_in  => csa_reset_src_ack
    );

    csa_mux : entity work.mux
        --generic for initializing the phase registers
        generic map (
           DATA_WIDTH => BITWIDTH*2*2,
           PHASE_INIT_C => '0', --TODO check init values
           PHASE_INIT_A => '1',
           PHASE_INIT_B => '0',
           PHASE_INIT_SEL => '1'
        );
        port(
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
          outC_ack => csa_mux_fw_req,
          -- Select port
          inSel_req => done_fork_1_fwb_req,
          inSel_ack => done_fork_1_fwb_ack,
          selector => nor_fw_data
          );


end Behavior;