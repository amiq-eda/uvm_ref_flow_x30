//File23 name   : power_ctrl_veneer23.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------
module power_ctrl_veneer23 (
    //------------------------------------
    // Clocks23 & Reset23
    //------------------------------------
    pclk23,
    nprst23,
    //------------------------------------
    // APB23 programming23 interface
    //------------------------------------
    paddr23,
    psel23,
    penable23,
    pwrite23,
    pwdata23,
    prdata23,
    // mac23 i/f,
    macb3_wakeup23,
    macb2_wakeup23,
    macb1_wakeup23,
    macb0_wakeup23,
    //------------------------------------
    // Scan23 
    //------------------------------------
    scan_in23,
    scan_en23,
    scan_mode23,
    scan_out23,
    int_source_h23,
    //------------------------------------
    // Module23 control23 outputs23
    //------------------------------------
    // SMC23
    rstn_non_srpg_smc23,
    gate_clk_smc23,
    isolate_smc23,
    save_edge_smc23,
    restore_edge_smc23,
    pwr1_on_smc23,
    pwr2_on_smc23,
    // URT23
    rstn_non_srpg_urt23,
    gate_clk_urt23,
    isolate_urt23,
    save_edge_urt23,
    restore_edge_urt23,
    pwr1_on_urt23,
    pwr2_on_urt23,
    // ETH023
    rstn_non_srpg_macb023,
    gate_clk_macb023,
    isolate_macb023,
    save_edge_macb023,
    restore_edge_macb023,
    pwr1_on_macb023,
    pwr2_on_macb023,
    // ETH123
    rstn_non_srpg_macb123,
    gate_clk_macb123,
    isolate_macb123,
    save_edge_macb123,
    restore_edge_macb123,
    pwr1_on_macb123,
    pwr2_on_macb123,
    // ETH223
    rstn_non_srpg_macb223,
    gate_clk_macb223,
    isolate_macb223,
    save_edge_macb223,
    restore_edge_macb223,
    pwr1_on_macb223,
    pwr2_on_macb223,
    // ETH323
    rstn_non_srpg_macb323,
    gate_clk_macb323,
    isolate_macb323,
    save_edge_macb323,
    restore_edge_macb323,
    pwr1_on_macb323,
    pwr2_on_macb323,
    // core23 dvfs23 transitions23
    core06v23,
    core08v23,
    core10v23,
    core12v23,
    pcm_macb_wakeup_int23,
    isolate_mem23,
    
    // transit23 signals23
    mte_smc_start23,
    mte_uart_start23,
    mte_smc_uart_start23,  
    mte_pm_smc_to_default_start23, 
    mte_pm_uart_to_default_start23,
    mte_pm_smc_uart_to_default_start23
  );

//------------------------------------------------------------------------------
// I23/O23 declaration23
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks23 & Reset23
   //------------------------------------
   input             pclk23;
   input             nprst23;
   //------------------------------------
   // APB23 programming23 interface;
   //------------------------------------
   input  [31:0]     paddr23;
   input             psel23;
   input             penable23;
   input             pwrite23;
   input  [31:0]     pwdata23;
   output [31:0]     prdata23;
    // mac23
   input macb3_wakeup23;
   input macb2_wakeup23;
   input macb1_wakeup23;
   input macb0_wakeup23;
   //------------------------------------
   // Scan23
   //------------------------------------
   input             scan_in23;
   input             scan_en23;
   input             scan_mode23;
   output            scan_out23;
   //------------------------------------
   // Module23 control23 outputs23
   input             int_source_h23;
   //------------------------------------
   // SMC23
   output            rstn_non_srpg_smc23;
   output            gate_clk_smc23;
   output            isolate_smc23;
   output            save_edge_smc23;
   output            restore_edge_smc23;
   output            pwr1_on_smc23;
   output            pwr2_on_smc23;
   // URT23
   output            rstn_non_srpg_urt23;
   output            gate_clk_urt23;
   output            isolate_urt23;
   output            save_edge_urt23;
   output            restore_edge_urt23;
   output            pwr1_on_urt23;
   output            pwr2_on_urt23;
   // ETH023
   output            rstn_non_srpg_macb023;
   output            gate_clk_macb023;
   output            isolate_macb023;
   output            save_edge_macb023;
   output            restore_edge_macb023;
   output            pwr1_on_macb023;
   output            pwr2_on_macb023;
   // ETH123
   output            rstn_non_srpg_macb123;
   output            gate_clk_macb123;
   output            isolate_macb123;
   output            save_edge_macb123;
   output            restore_edge_macb123;
   output            pwr1_on_macb123;
   output            pwr2_on_macb123;
   // ETH223
   output            rstn_non_srpg_macb223;
   output            gate_clk_macb223;
   output            isolate_macb223;
   output            save_edge_macb223;
   output            restore_edge_macb223;
   output            pwr1_on_macb223;
   output            pwr2_on_macb223;
   // ETH323
   output            rstn_non_srpg_macb323;
   output            gate_clk_macb323;
   output            isolate_macb323;
   output            save_edge_macb323;
   output            restore_edge_macb323;
   output            pwr1_on_macb323;
   output            pwr2_on_macb323;

   // dvfs23
   output core06v23;
   output core08v23;
   output core10v23;
   output core12v23;
   output pcm_macb_wakeup_int23 ;
   output isolate_mem23 ;

   //transit23  signals23
   output mte_smc_start23;
   output mte_uart_start23;
   output mte_smc_uart_start23;  
   output mte_pm_smc_to_default_start23; 
   output mte_pm_uart_to_default_start23;
   output mte_pm_smc_uart_to_default_start23;



//##############################################################################
// if the POWER_CTRL23 is NOT23 black23 boxed23 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL23

power_ctrl23 i_power_ctrl23(
    // -- Clocks23 & Reset23
    	.pclk23(pclk23), 			//  : in  std_logic23;
    	.nprst23(nprst23), 		//  : in  std_logic23;
    // -- APB23 programming23 interface
    	.paddr23(paddr23), 			//  : in  std_logic_vector23(31 downto23 0);
    	.psel23(psel23), 			//  : in  std_logic23;
    	.penable23(penable23), 		//  : in  std_logic23;
    	.pwrite23(pwrite23), 		//  : in  std_logic23;
    	.pwdata23(pwdata23), 		//  : in  std_logic_vector23(31 downto23 0);
    	.prdata23(prdata23), 		//  : out std_logic_vector23(31 downto23 0);
        .macb3_wakeup23(macb3_wakeup23),
        .macb2_wakeup23(macb2_wakeup23),
        .macb1_wakeup23(macb1_wakeup23),
        .macb0_wakeup23(macb0_wakeup23),
    // -- Module23 control23 outputs23
    	.scan_in23(),			//  : in  std_logic23;
    	.scan_en23(scan_en23),             	//  : in  std_logic23;
    	.scan_mode23(scan_mode23),          //  : in  std_logic23;
    	.scan_out23(),            	//  : out std_logic23;
    	.int_source_h23(int_source_h23),    //  : out std_logic23;
     	.rstn_non_srpg_smc23(rstn_non_srpg_smc23), 		//   : out std_logic23;
    	.gate_clk_smc23(gate_clk_smc23), 	//  : out std_logic23;
    	.isolate_smc23(isolate_smc23), 	//  : out std_logic23;
    	.save_edge_smc23(save_edge_smc23), 	//  : out std_logic23;
    	.restore_edge_smc23(restore_edge_smc23), 	//  : out std_logic23;
    	.pwr1_on_smc23(pwr1_on_smc23), 	//  : out std_logic23;
    	.pwr2_on_smc23(pwr2_on_smc23), 	//  : out std_logic23
	.pwr1_off_smc23(pwr1_off_smc23), 	//  : out std_logic23;
    	.pwr2_off_smc23(pwr2_off_smc23), 	//  : out std_logic23
     	.rstn_non_srpg_urt23(rstn_non_srpg_urt23), 		//   : out std_logic23;
    	.gate_clk_urt23(gate_clk_urt23), 	//  : out std_logic23;
    	.isolate_urt23(isolate_urt23), 	//  : out std_logic23;
    	.save_edge_urt23(save_edge_urt23), 	//  : out std_logic23;
    	.restore_edge_urt23(restore_edge_urt23), 	//  : out std_logic23;
    	.pwr1_on_urt23(pwr1_on_urt23), 	//  : out std_logic23;
    	.pwr2_on_urt23(pwr2_on_urt23), 	//  : out std_logic23;
    	.pwr1_off_urt23(pwr1_off_urt23),    //  : out std_logic23;
    	.pwr2_off_urt23(pwr2_off_urt23),     //  : out std_logic23
     	.rstn_non_srpg_macb023(rstn_non_srpg_macb023), 		//   : out std_logic23;
    	.gate_clk_macb023(gate_clk_macb023), 	//  : out std_logic23;
    	.isolate_macb023(isolate_macb023), 	//  : out std_logic23;
    	.save_edge_macb023(save_edge_macb023), 	//  : out std_logic23;
    	.restore_edge_macb023(restore_edge_macb023), 	//  : out std_logic23;
    	.pwr1_on_macb023(pwr1_on_macb023), 	//  : out std_logic23;
    	.pwr2_on_macb023(pwr2_on_macb023), 	//  : out std_logic23;
    	.pwr1_off_macb023(pwr1_off_macb023),    //  : out std_logic23;
    	.pwr2_off_macb023(pwr2_off_macb023),     //  : out std_logic23
     	.rstn_non_srpg_macb123(rstn_non_srpg_macb123), 		//   : out std_logic23;
    	.gate_clk_macb123(gate_clk_macb123), 	//  : out std_logic23;
    	.isolate_macb123(isolate_macb123), 	//  : out std_logic23;
    	.save_edge_macb123(save_edge_macb123), 	//  : out std_logic23;
    	.restore_edge_macb123(restore_edge_macb123), 	//  : out std_logic23;
    	.pwr1_on_macb123(pwr1_on_macb123), 	//  : out std_logic23;
    	.pwr2_on_macb123(pwr2_on_macb123), 	//  : out std_logic23;
    	.pwr1_off_macb123(pwr1_off_macb123),    //  : out std_logic23;
    	.pwr2_off_macb123(pwr2_off_macb123),     //  : out std_logic23
     	.rstn_non_srpg_macb223(rstn_non_srpg_macb223), 		//   : out std_logic23;
    	.gate_clk_macb223(gate_clk_macb223), 	//  : out std_logic23;
    	.isolate_macb223(isolate_macb223), 	//  : out std_logic23;
    	.save_edge_macb223(save_edge_macb223), 	//  : out std_logic23;
    	.restore_edge_macb223(restore_edge_macb223), 	//  : out std_logic23;
    	.pwr1_on_macb223(pwr1_on_macb223), 	//  : out std_logic23;
    	.pwr2_on_macb223(pwr2_on_macb223), 	//  : out std_logic23;
    	.pwr1_off_macb223(pwr1_off_macb223),    //  : out std_logic23;
    	.pwr2_off_macb223(pwr2_off_macb223),     //  : out std_logic23
     	.rstn_non_srpg_macb323(rstn_non_srpg_macb323), 		//   : out std_logic23;
    	.gate_clk_macb323(gate_clk_macb323), 	//  : out std_logic23;
    	.isolate_macb323(isolate_macb323), 	//  : out std_logic23;
    	.save_edge_macb323(save_edge_macb323), 	//  : out std_logic23;
    	.restore_edge_macb323(restore_edge_macb323), 	//  : out std_logic23;
    	.pwr1_on_macb323(pwr1_on_macb323), 	//  : out std_logic23;
    	.pwr2_on_macb323(pwr2_on_macb323), 	//  : out std_logic23;
    	.pwr1_off_macb323(pwr1_off_macb323),    //  : out std_logic23;
    	.pwr2_off_macb323(pwr2_off_macb323),     //  : out std_logic23
        .rstn_non_srpg_dma23(rstn_non_srpg_dma23 ) ,
        .gate_clk_dma23(gate_clk_dma23      )      ,
        .isolate_dma23(isolate_dma23       )       ,
        .save_edge_dma23(save_edge_dma23   )   ,
        .restore_edge_dma23(restore_edge_dma23   )   ,
        .pwr1_on_dma23(pwr1_on_dma23       )       ,
        .pwr2_on_dma23(pwr2_on_dma23       )       ,
        .pwr1_off_dma23(pwr1_off_dma23      )      ,
        .pwr2_off_dma23(pwr2_off_dma23      )      ,
        
        .rstn_non_srpg_cpu23(rstn_non_srpg_cpu23 ) ,
        .gate_clk_cpu23(gate_clk_cpu23      )      ,
        .isolate_cpu23(isolate_cpu23       )       ,
        .save_edge_cpu23(save_edge_cpu23   )   ,
        .restore_edge_cpu23(restore_edge_cpu23   )   ,
        .pwr1_on_cpu23(pwr1_on_cpu23       )       ,
        .pwr2_on_cpu23(pwr2_on_cpu23       )       ,
        .pwr1_off_cpu23(pwr1_off_cpu23      )      ,
        .pwr2_off_cpu23(pwr2_off_cpu23      )      ,
        
        .rstn_non_srpg_alut23(rstn_non_srpg_alut23 ) ,
        .gate_clk_alut23(gate_clk_alut23      )      ,
        .isolate_alut23(isolate_alut23       )       ,
        .save_edge_alut23(save_edge_alut23   )   ,
        .restore_edge_alut23(restore_edge_alut23   )   ,
        .pwr1_on_alut23(pwr1_on_alut23       )       ,
        .pwr2_on_alut23(pwr2_on_alut23       )       ,
        .pwr1_off_alut23(pwr1_off_alut23      )      ,
        .pwr2_off_alut23(pwr2_off_alut23      )      ,
        
        .rstn_non_srpg_mem23(rstn_non_srpg_mem23 ) ,
        .gate_clk_mem23(gate_clk_mem23      )      ,
        .isolate_mem23(isolate_mem23       )       ,
        .save_edge_mem23(save_edge_mem23   )   ,
        .restore_edge_mem23(restore_edge_mem23   )   ,
        .pwr1_on_mem23(pwr1_on_mem23       )       ,
        .pwr2_on_mem23(pwr2_on_mem23       )       ,
        .pwr1_off_mem23(pwr1_off_mem23      )      ,
        .pwr2_off_mem23(pwr2_off_mem23      )      ,

    	.core06v23(core06v23),     //  : out std_logic23
    	.core08v23(core08v23),     //  : out std_logic23
    	.core10v23(core10v23),     //  : out std_logic23
    	.core12v23(core12v23),     //  : out std_logic23
        .pcm_macb_wakeup_int23(pcm_macb_wakeup_int23),
        .mte_smc_start23(mte_smc_start23),
        .mte_uart_start23(mte_uart_start23),
        .mte_smc_uart_start23(mte_smc_uart_start23),  
        .mte_pm_smc_to_default_start23(mte_pm_smc_to_default_start23), 
        .mte_pm_uart_to_default_start23(mte_pm_uart_to_default_start23),
        .mte_pm_smc_uart_to_default_start23(mte_pm_smc_uart_to_default_start23)
);


`else 
//##############################################################################
// if the POWER_CTRL23 is black23 boxed23 
//##############################################################################

   //------------------------------------
   // Clocks23 & Reset23
   //------------------------------------
   wire              pclk23;
   wire              nprst23;
   //------------------------------------
   // APB23 programming23 interface;
   //------------------------------------
   wire   [31:0]     paddr23;
   wire              psel23;
   wire              penable23;
   wire              pwrite23;
   wire   [31:0]     pwdata23;
   reg    [31:0]     prdata23;
   //------------------------------------
   // Scan23
   //------------------------------------
   wire              scan_in23;
   wire              scan_en23;
   wire              scan_mode23;
   reg               scan_out23;
   //------------------------------------
   // Module23 control23 outputs23
   //------------------------------------
   // SMC23;
   reg               rstn_non_srpg_smc23;
   reg               gate_clk_smc23;
   reg               isolate_smc23;
   reg               save_edge_smc23;
   reg               restore_edge_smc23;
   reg               pwr1_on_smc23;
   reg               pwr2_on_smc23;
   wire              pwr1_off_smc23;
   wire              pwr2_off_smc23;

   // URT23;
   reg               rstn_non_srpg_urt23;
   reg               gate_clk_urt23;
   reg               isolate_urt23;
   reg               save_edge_urt23;
   reg               restore_edge_urt23;
   reg               pwr1_on_urt23;
   reg               pwr2_on_urt23;
   wire              pwr1_off_urt23;
   wire              pwr2_off_urt23;

   // ETH023
   reg               rstn_non_srpg_macb023;
   reg               gate_clk_macb023;
   reg               isolate_macb023;
   reg               save_edge_macb023;
   reg               restore_edge_macb023;
   reg               pwr1_on_macb023;
   reg               pwr2_on_macb023;
   wire              pwr1_off_macb023;
   wire              pwr2_off_macb023;
   // ETH123
   reg               rstn_non_srpg_macb123;
   reg               gate_clk_macb123;
   reg               isolate_macb123;
   reg               save_edge_macb123;
   reg               restore_edge_macb123;
   reg               pwr1_on_macb123;
   reg               pwr2_on_macb123;
   wire              pwr1_off_macb123;
   wire              pwr2_off_macb123;
   // ETH223
   reg               rstn_non_srpg_macb223;
   reg               gate_clk_macb223;
   reg               isolate_macb223;
   reg               save_edge_macb223;
   reg               restore_edge_macb223;
   reg               pwr1_on_macb223;
   reg               pwr2_on_macb223;
   wire              pwr1_off_macb223;
   wire              pwr2_off_macb223;
   // ETH323
   reg               rstn_non_srpg_macb323;
   reg               gate_clk_macb323;
   reg               isolate_macb323;
   reg               save_edge_macb323;
   reg               restore_edge_macb323;
   reg               pwr1_on_macb323;
   reg               pwr2_on_macb323;
   wire              pwr1_off_macb323;
   wire              pwr2_off_macb323;

   wire core06v23;
   wire core08v23;
   wire core10v23;
   wire core12v23;



`endif
//##############################################################################
// black23 boxed23 defines23 
//##############################################################################

endmodule
