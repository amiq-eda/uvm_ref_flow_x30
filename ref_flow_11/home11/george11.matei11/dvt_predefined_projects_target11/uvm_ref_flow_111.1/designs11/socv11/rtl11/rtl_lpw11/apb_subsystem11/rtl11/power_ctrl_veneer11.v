//File11 name   : power_ctrl_veneer11.v
//Title11       : 
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------
module power_ctrl_veneer11 (
    //------------------------------------
    // Clocks11 & Reset11
    //------------------------------------
    pclk11,
    nprst11,
    //------------------------------------
    // APB11 programming11 interface
    //------------------------------------
    paddr11,
    psel11,
    penable11,
    pwrite11,
    pwdata11,
    prdata11,
    // mac11 i/f,
    macb3_wakeup11,
    macb2_wakeup11,
    macb1_wakeup11,
    macb0_wakeup11,
    //------------------------------------
    // Scan11 
    //------------------------------------
    scan_in11,
    scan_en11,
    scan_mode11,
    scan_out11,
    int_source_h11,
    //------------------------------------
    // Module11 control11 outputs11
    //------------------------------------
    // SMC11
    rstn_non_srpg_smc11,
    gate_clk_smc11,
    isolate_smc11,
    save_edge_smc11,
    restore_edge_smc11,
    pwr1_on_smc11,
    pwr2_on_smc11,
    // URT11
    rstn_non_srpg_urt11,
    gate_clk_urt11,
    isolate_urt11,
    save_edge_urt11,
    restore_edge_urt11,
    pwr1_on_urt11,
    pwr2_on_urt11,
    // ETH011
    rstn_non_srpg_macb011,
    gate_clk_macb011,
    isolate_macb011,
    save_edge_macb011,
    restore_edge_macb011,
    pwr1_on_macb011,
    pwr2_on_macb011,
    // ETH111
    rstn_non_srpg_macb111,
    gate_clk_macb111,
    isolate_macb111,
    save_edge_macb111,
    restore_edge_macb111,
    pwr1_on_macb111,
    pwr2_on_macb111,
    // ETH211
    rstn_non_srpg_macb211,
    gate_clk_macb211,
    isolate_macb211,
    save_edge_macb211,
    restore_edge_macb211,
    pwr1_on_macb211,
    pwr2_on_macb211,
    // ETH311
    rstn_non_srpg_macb311,
    gate_clk_macb311,
    isolate_macb311,
    save_edge_macb311,
    restore_edge_macb311,
    pwr1_on_macb311,
    pwr2_on_macb311,
    // core11 dvfs11 transitions11
    core06v11,
    core08v11,
    core10v11,
    core12v11,
    pcm_macb_wakeup_int11,
    isolate_mem11,
    
    // transit11 signals11
    mte_smc_start11,
    mte_uart_start11,
    mte_smc_uart_start11,  
    mte_pm_smc_to_default_start11, 
    mte_pm_uart_to_default_start11,
    mte_pm_smc_uart_to_default_start11
  );

//------------------------------------------------------------------------------
// I11/O11 declaration11
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks11 & Reset11
   //------------------------------------
   input             pclk11;
   input             nprst11;
   //------------------------------------
   // APB11 programming11 interface;
   //------------------------------------
   input  [31:0]     paddr11;
   input             psel11;
   input             penable11;
   input             pwrite11;
   input  [31:0]     pwdata11;
   output [31:0]     prdata11;
    // mac11
   input macb3_wakeup11;
   input macb2_wakeup11;
   input macb1_wakeup11;
   input macb0_wakeup11;
   //------------------------------------
   // Scan11
   //------------------------------------
   input             scan_in11;
   input             scan_en11;
   input             scan_mode11;
   output            scan_out11;
   //------------------------------------
   // Module11 control11 outputs11
   input             int_source_h11;
   //------------------------------------
   // SMC11
   output            rstn_non_srpg_smc11;
   output            gate_clk_smc11;
   output            isolate_smc11;
   output            save_edge_smc11;
   output            restore_edge_smc11;
   output            pwr1_on_smc11;
   output            pwr2_on_smc11;
   // URT11
   output            rstn_non_srpg_urt11;
   output            gate_clk_urt11;
   output            isolate_urt11;
   output            save_edge_urt11;
   output            restore_edge_urt11;
   output            pwr1_on_urt11;
   output            pwr2_on_urt11;
   // ETH011
   output            rstn_non_srpg_macb011;
   output            gate_clk_macb011;
   output            isolate_macb011;
   output            save_edge_macb011;
   output            restore_edge_macb011;
   output            pwr1_on_macb011;
   output            pwr2_on_macb011;
   // ETH111
   output            rstn_non_srpg_macb111;
   output            gate_clk_macb111;
   output            isolate_macb111;
   output            save_edge_macb111;
   output            restore_edge_macb111;
   output            pwr1_on_macb111;
   output            pwr2_on_macb111;
   // ETH211
   output            rstn_non_srpg_macb211;
   output            gate_clk_macb211;
   output            isolate_macb211;
   output            save_edge_macb211;
   output            restore_edge_macb211;
   output            pwr1_on_macb211;
   output            pwr2_on_macb211;
   // ETH311
   output            rstn_non_srpg_macb311;
   output            gate_clk_macb311;
   output            isolate_macb311;
   output            save_edge_macb311;
   output            restore_edge_macb311;
   output            pwr1_on_macb311;
   output            pwr2_on_macb311;

   // dvfs11
   output core06v11;
   output core08v11;
   output core10v11;
   output core12v11;
   output pcm_macb_wakeup_int11 ;
   output isolate_mem11 ;

   //transit11  signals11
   output mte_smc_start11;
   output mte_uart_start11;
   output mte_smc_uart_start11;  
   output mte_pm_smc_to_default_start11; 
   output mte_pm_uart_to_default_start11;
   output mte_pm_smc_uart_to_default_start11;



//##############################################################################
// if the POWER_CTRL11 is NOT11 black11 boxed11 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL11

power_ctrl11 i_power_ctrl11(
    // -- Clocks11 & Reset11
    	.pclk11(pclk11), 			//  : in  std_logic11;
    	.nprst11(nprst11), 		//  : in  std_logic11;
    // -- APB11 programming11 interface
    	.paddr11(paddr11), 			//  : in  std_logic_vector11(31 downto11 0);
    	.psel11(psel11), 			//  : in  std_logic11;
    	.penable11(penable11), 		//  : in  std_logic11;
    	.pwrite11(pwrite11), 		//  : in  std_logic11;
    	.pwdata11(pwdata11), 		//  : in  std_logic_vector11(31 downto11 0);
    	.prdata11(prdata11), 		//  : out std_logic_vector11(31 downto11 0);
        .macb3_wakeup11(macb3_wakeup11),
        .macb2_wakeup11(macb2_wakeup11),
        .macb1_wakeup11(macb1_wakeup11),
        .macb0_wakeup11(macb0_wakeup11),
    // -- Module11 control11 outputs11
    	.scan_in11(),			//  : in  std_logic11;
    	.scan_en11(scan_en11),             	//  : in  std_logic11;
    	.scan_mode11(scan_mode11),          //  : in  std_logic11;
    	.scan_out11(),            	//  : out std_logic11;
    	.int_source_h11(int_source_h11),    //  : out std_logic11;
     	.rstn_non_srpg_smc11(rstn_non_srpg_smc11), 		//   : out std_logic11;
    	.gate_clk_smc11(gate_clk_smc11), 	//  : out std_logic11;
    	.isolate_smc11(isolate_smc11), 	//  : out std_logic11;
    	.save_edge_smc11(save_edge_smc11), 	//  : out std_logic11;
    	.restore_edge_smc11(restore_edge_smc11), 	//  : out std_logic11;
    	.pwr1_on_smc11(pwr1_on_smc11), 	//  : out std_logic11;
    	.pwr2_on_smc11(pwr2_on_smc11), 	//  : out std_logic11
	.pwr1_off_smc11(pwr1_off_smc11), 	//  : out std_logic11;
    	.pwr2_off_smc11(pwr2_off_smc11), 	//  : out std_logic11
     	.rstn_non_srpg_urt11(rstn_non_srpg_urt11), 		//   : out std_logic11;
    	.gate_clk_urt11(gate_clk_urt11), 	//  : out std_logic11;
    	.isolate_urt11(isolate_urt11), 	//  : out std_logic11;
    	.save_edge_urt11(save_edge_urt11), 	//  : out std_logic11;
    	.restore_edge_urt11(restore_edge_urt11), 	//  : out std_logic11;
    	.pwr1_on_urt11(pwr1_on_urt11), 	//  : out std_logic11;
    	.pwr2_on_urt11(pwr2_on_urt11), 	//  : out std_logic11;
    	.pwr1_off_urt11(pwr1_off_urt11),    //  : out std_logic11;
    	.pwr2_off_urt11(pwr2_off_urt11),     //  : out std_logic11
     	.rstn_non_srpg_macb011(rstn_non_srpg_macb011), 		//   : out std_logic11;
    	.gate_clk_macb011(gate_clk_macb011), 	//  : out std_logic11;
    	.isolate_macb011(isolate_macb011), 	//  : out std_logic11;
    	.save_edge_macb011(save_edge_macb011), 	//  : out std_logic11;
    	.restore_edge_macb011(restore_edge_macb011), 	//  : out std_logic11;
    	.pwr1_on_macb011(pwr1_on_macb011), 	//  : out std_logic11;
    	.pwr2_on_macb011(pwr2_on_macb011), 	//  : out std_logic11;
    	.pwr1_off_macb011(pwr1_off_macb011),    //  : out std_logic11;
    	.pwr2_off_macb011(pwr2_off_macb011),     //  : out std_logic11
     	.rstn_non_srpg_macb111(rstn_non_srpg_macb111), 		//   : out std_logic11;
    	.gate_clk_macb111(gate_clk_macb111), 	//  : out std_logic11;
    	.isolate_macb111(isolate_macb111), 	//  : out std_logic11;
    	.save_edge_macb111(save_edge_macb111), 	//  : out std_logic11;
    	.restore_edge_macb111(restore_edge_macb111), 	//  : out std_logic11;
    	.pwr1_on_macb111(pwr1_on_macb111), 	//  : out std_logic11;
    	.pwr2_on_macb111(pwr2_on_macb111), 	//  : out std_logic11;
    	.pwr1_off_macb111(pwr1_off_macb111),    //  : out std_logic11;
    	.pwr2_off_macb111(pwr2_off_macb111),     //  : out std_logic11
     	.rstn_non_srpg_macb211(rstn_non_srpg_macb211), 		//   : out std_logic11;
    	.gate_clk_macb211(gate_clk_macb211), 	//  : out std_logic11;
    	.isolate_macb211(isolate_macb211), 	//  : out std_logic11;
    	.save_edge_macb211(save_edge_macb211), 	//  : out std_logic11;
    	.restore_edge_macb211(restore_edge_macb211), 	//  : out std_logic11;
    	.pwr1_on_macb211(pwr1_on_macb211), 	//  : out std_logic11;
    	.pwr2_on_macb211(pwr2_on_macb211), 	//  : out std_logic11;
    	.pwr1_off_macb211(pwr1_off_macb211),    //  : out std_logic11;
    	.pwr2_off_macb211(pwr2_off_macb211),     //  : out std_logic11
     	.rstn_non_srpg_macb311(rstn_non_srpg_macb311), 		//   : out std_logic11;
    	.gate_clk_macb311(gate_clk_macb311), 	//  : out std_logic11;
    	.isolate_macb311(isolate_macb311), 	//  : out std_logic11;
    	.save_edge_macb311(save_edge_macb311), 	//  : out std_logic11;
    	.restore_edge_macb311(restore_edge_macb311), 	//  : out std_logic11;
    	.pwr1_on_macb311(pwr1_on_macb311), 	//  : out std_logic11;
    	.pwr2_on_macb311(pwr2_on_macb311), 	//  : out std_logic11;
    	.pwr1_off_macb311(pwr1_off_macb311),    //  : out std_logic11;
    	.pwr2_off_macb311(pwr2_off_macb311),     //  : out std_logic11
        .rstn_non_srpg_dma11(rstn_non_srpg_dma11 ) ,
        .gate_clk_dma11(gate_clk_dma11      )      ,
        .isolate_dma11(isolate_dma11       )       ,
        .save_edge_dma11(save_edge_dma11   )   ,
        .restore_edge_dma11(restore_edge_dma11   )   ,
        .pwr1_on_dma11(pwr1_on_dma11       )       ,
        .pwr2_on_dma11(pwr2_on_dma11       )       ,
        .pwr1_off_dma11(pwr1_off_dma11      )      ,
        .pwr2_off_dma11(pwr2_off_dma11      )      ,
        
        .rstn_non_srpg_cpu11(rstn_non_srpg_cpu11 ) ,
        .gate_clk_cpu11(gate_clk_cpu11      )      ,
        .isolate_cpu11(isolate_cpu11       )       ,
        .save_edge_cpu11(save_edge_cpu11   )   ,
        .restore_edge_cpu11(restore_edge_cpu11   )   ,
        .pwr1_on_cpu11(pwr1_on_cpu11       )       ,
        .pwr2_on_cpu11(pwr2_on_cpu11       )       ,
        .pwr1_off_cpu11(pwr1_off_cpu11      )      ,
        .pwr2_off_cpu11(pwr2_off_cpu11      )      ,
        
        .rstn_non_srpg_alut11(rstn_non_srpg_alut11 ) ,
        .gate_clk_alut11(gate_clk_alut11      )      ,
        .isolate_alut11(isolate_alut11       )       ,
        .save_edge_alut11(save_edge_alut11   )   ,
        .restore_edge_alut11(restore_edge_alut11   )   ,
        .pwr1_on_alut11(pwr1_on_alut11       )       ,
        .pwr2_on_alut11(pwr2_on_alut11       )       ,
        .pwr1_off_alut11(pwr1_off_alut11      )      ,
        .pwr2_off_alut11(pwr2_off_alut11      )      ,
        
        .rstn_non_srpg_mem11(rstn_non_srpg_mem11 ) ,
        .gate_clk_mem11(gate_clk_mem11      )      ,
        .isolate_mem11(isolate_mem11       )       ,
        .save_edge_mem11(save_edge_mem11   )   ,
        .restore_edge_mem11(restore_edge_mem11   )   ,
        .pwr1_on_mem11(pwr1_on_mem11       )       ,
        .pwr2_on_mem11(pwr2_on_mem11       )       ,
        .pwr1_off_mem11(pwr1_off_mem11      )      ,
        .pwr2_off_mem11(pwr2_off_mem11      )      ,

    	.core06v11(core06v11),     //  : out std_logic11
    	.core08v11(core08v11),     //  : out std_logic11
    	.core10v11(core10v11),     //  : out std_logic11
    	.core12v11(core12v11),     //  : out std_logic11
        .pcm_macb_wakeup_int11(pcm_macb_wakeup_int11),
        .mte_smc_start11(mte_smc_start11),
        .mte_uart_start11(mte_uart_start11),
        .mte_smc_uart_start11(mte_smc_uart_start11),  
        .mte_pm_smc_to_default_start11(mte_pm_smc_to_default_start11), 
        .mte_pm_uart_to_default_start11(mte_pm_uart_to_default_start11),
        .mte_pm_smc_uart_to_default_start11(mte_pm_smc_uart_to_default_start11)
);


`else 
//##############################################################################
// if the POWER_CTRL11 is black11 boxed11 
//##############################################################################

   //------------------------------------
   // Clocks11 & Reset11
   //------------------------------------
   wire              pclk11;
   wire              nprst11;
   //------------------------------------
   // APB11 programming11 interface;
   //------------------------------------
   wire   [31:0]     paddr11;
   wire              psel11;
   wire              penable11;
   wire              pwrite11;
   wire   [31:0]     pwdata11;
   reg    [31:0]     prdata11;
   //------------------------------------
   // Scan11
   //------------------------------------
   wire              scan_in11;
   wire              scan_en11;
   wire              scan_mode11;
   reg               scan_out11;
   //------------------------------------
   // Module11 control11 outputs11
   //------------------------------------
   // SMC11;
   reg               rstn_non_srpg_smc11;
   reg               gate_clk_smc11;
   reg               isolate_smc11;
   reg               save_edge_smc11;
   reg               restore_edge_smc11;
   reg               pwr1_on_smc11;
   reg               pwr2_on_smc11;
   wire              pwr1_off_smc11;
   wire              pwr2_off_smc11;

   // URT11;
   reg               rstn_non_srpg_urt11;
   reg               gate_clk_urt11;
   reg               isolate_urt11;
   reg               save_edge_urt11;
   reg               restore_edge_urt11;
   reg               pwr1_on_urt11;
   reg               pwr2_on_urt11;
   wire              pwr1_off_urt11;
   wire              pwr2_off_urt11;

   // ETH011
   reg               rstn_non_srpg_macb011;
   reg               gate_clk_macb011;
   reg               isolate_macb011;
   reg               save_edge_macb011;
   reg               restore_edge_macb011;
   reg               pwr1_on_macb011;
   reg               pwr2_on_macb011;
   wire              pwr1_off_macb011;
   wire              pwr2_off_macb011;
   // ETH111
   reg               rstn_non_srpg_macb111;
   reg               gate_clk_macb111;
   reg               isolate_macb111;
   reg               save_edge_macb111;
   reg               restore_edge_macb111;
   reg               pwr1_on_macb111;
   reg               pwr2_on_macb111;
   wire              pwr1_off_macb111;
   wire              pwr2_off_macb111;
   // ETH211
   reg               rstn_non_srpg_macb211;
   reg               gate_clk_macb211;
   reg               isolate_macb211;
   reg               save_edge_macb211;
   reg               restore_edge_macb211;
   reg               pwr1_on_macb211;
   reg               pwr2_on_macb211;
   wire              pwr1_off_macb211;
   wire              pwr2_off_macb211;
   // ETH311
   reg               rstn_non_srpg_macb311;
   reg               gate_clk_macb311;
   reg               isolate_macb311;
   reg               save_edge_macb311;
   reg               restore_edge_macb311;
   reg               pwr1_on_macb311;
   reg               pwr2_on_macb311;
   wire              pwr1_off_macb311;
   wire              pwr2_off_macb311;

   wire core06v11;
   wire core08v11;
   wire core10v11;
   wire core12v11;



`endif
//##############################################################################
// black11 boxed11 defines11 
//##############################################################################

endmodule
