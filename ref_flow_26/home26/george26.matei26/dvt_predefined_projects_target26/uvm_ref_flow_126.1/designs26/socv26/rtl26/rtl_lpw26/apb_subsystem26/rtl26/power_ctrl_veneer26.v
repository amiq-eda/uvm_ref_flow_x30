//File26 name   : power_ctrl_veneer26.v
//Title26       : 
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------
module power_ctrl_veneer26 (
    //------------------------------------
    // Clocks26 & Reset26
    //------------------------------------
    pclk26,
    nprst26,
    //------------------------------------
    // APB26 programming26 interface
    //------------------------------------
    paddr26,
    psel26,
    penable26,
    pwrite26,
    pwdata26,
    prdata26,
    // mac26 i/f,
    macb3_wakeup26,
    macb2_wakeup26,
    macb1_wakeup26,
    macb0_wakeup26,
    //------------------------------------
    // Scan26 
    //------------------------------------
    scan_in26,
    scan_en26,
    scan_mode26,
    scan_out26,
    int_source_h26,
    //------------------------------------
    // Module26 control26 outputs26
    //------------------------------------
    // SMC26
    rstn_non_srpg_smc26,
    gate_clk_smc26,
    isolate_smc26,
    save_edge_smc26,
    restore_edge_smc26,
    pwr1_on_smc26,
    pwr2_on_smc26,
    // URT26
    rstn_non_srpg_urt26,
    gate_clk_urt26,
    isolate_urt26,
    save_edge_urt26,
    restore_edge_urt26,
    pwr1_on_urt26,
    pwr2_on_urt26,
    // ETH026
    rstn_non_srpg_macb026,
    gate_clk_macb026,
    isolate_macb026,
    save_edge_macb026,
    restore_edge_macb026,
    pwr1_on_macb026,
    pwr2_on_macb026,
    // ETH126
    rstn_non_srpg_macb126,
    gate_clk_macb126,
    isolate_macb126,
    save_edge_macb126,
    restore_edge_macb126,
    pwr1_on_macb126,
    pwr2_on_macb126,
    // ETH226
    rstn_non_srpg_macb226,
    gate_clk_macb226,
    isolate_macb226,
    save_edge_macb226,
    restore_edge_macb226,
    pwr1_on_macb226,
    pwr2_on_macb226,
    // ETH326
    rstn_non_srpg_macb326,
    gate_clk_macb326,
    isolate_macb326,
    save_edge_macb326,
    restore_edge_macb326,
    pwr1_on_macb326,
    pwr2_on_macb326,
    // core26 dvfs26 transitions26
    core06v26,
    core08v26,
    core10v26,
    core12v26,
    pcm_macb_wakeup_int26,
    isolate_mem26,
    
    // transit26 signals26
    mte_smc_start26,
    mte_uart_start26,
    mte_smc_uart_start26,  
    mte_pm_smc_to_default_start26, 
    mte_pm_uart_to_default_start26,
    mte_pm_smc_uart_to_default_start26
  );

//------------------------------------------------------------------------------
// I26/O26 declaration26
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks26 & Reset26
   //------------------------------------
   input             pclk26;
   input             nprst26;
   //------------------------------------
   // APB26 programming26 interface;
   //------------------------------------
   input  [31:0]     paddr26;
   input             psel26;
   input             penable26;
   input             pwrite26;
   input  [31:0]     pwdata26;
   output [31:0]     prdata26;
    // mac26
   input macb3_wakeup26;
   input macb2_wakeup26;
   input macb1_wakeup26;
   input macb0_wakeup26;
   //------------------------------------
   // Scan26
   //------------------------------------
   input             scan_in26;
   input             scan_en26;
   input             scan_mode26;
   output            scan_out26;
   //------------------------------------
   // Module26 control26 outputs26
   input             int_source_h26;
   //------------------------------------
   // SMC26
   output            rstn_non_srpg_smc26;
   output            gate_clk_smc26;
   output            isolate_smc26;
   output            save_edge_smc26;
   output            restore_edge_smc26;
   output            pwr1_on_smc26;
   output            pwr2_on_smc26;
   // URT26
   output            rstn_non_srpg_urt26;
   output            gate_clk_urt26;
   output            isolate_urt26;
   output            save_edge_urt26;
   output            restore_edge_urt26;
   output            pwr1_on_urt26;
   output            pwr2_on_urt26;
   // ETH026
   output            rstn_non_srpg_macb026;
   output            gate_clk_macb026;
   output            isolate_macb026;
   output            save_edge_macb026;
   output            restore_edge_macb026;
   output            pwr1_on_macb026;
   output            pwr2_on_macb026;
   // ETH126
   output            rstn_non_srpg_macb126;
   output            gate_clk_macb126;
   output            isolate_macb126;
   output            save_edge_macb126;
   output            restore_edge_macb126;
   output            pwr1_on_macb126;
   output            pwr2_on_macb126;
   // ETH226
   output            rstn_non_srpg_macb226;
   output            gate_clk_macb226;
   output            isolate_macb226;
   output            save_edge_macb226;
   output            restore_edge_macb226;
   output            pwr1_on_macb226;
   output            pwr2_on_macb226;
   // ETH326
   output            rstn_non_srpg_macb326;
   output            gate_clk_macb326;
   output            isolate_macb326;
   output            save_edge_macb326;
   output            restore_edge_macb326;
   output            pwr1_on_macb326;
   output            pwr2_on_macb326;

   // dvfs26
   output core06v26;
   output core08v26;
   output core10v26;
   output core12v26;
   output pcm_macb_wakeup_int26 ;
   output isolate_mem26 ;

   //transit26  signals26
   output mte_smc_start26;
   output mte_uart_start26;
   output mte_smc_uart_start26;  
   output mte_pm_smc_to_default_start26; 
   output mte_pm_uart_to_default_start26;
   output mte_pm_smc_uart_to_default_start26;



//##############################################################################
// if the POWER_CTRL26 is NOT26 black26 boxed26 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL26

power_ctrl26 i_power_ctrl26(
    // -- Clocks26 & Reset26
    	.pclk26(pclk26), 			//  : in  std_logic26;
    	.nprst26(nprst26), 		//  : in  std_logic26;
    // -- APB26 programming26 interface
    	.paddr26(paddr26), 			//  : in  std_logic_vector26(31 downto26 0);
    	.psel26(psel26), 			//  : in  std_logic26;
    	.penable26(penable26), 		//  : in  std_logic26;
    	.pwrite26(pwrite26), 		//  : in  std_logic26;
    	.pwdata26(pwdata26), 		//  : in  std_logic_vector26(31 downto26 0);
    	.prdata26(prdata26), 		//  : out std_logic_vector26(31 downto26 0);
        .macb3_wakeup26(macb3_wakeup26),
        .macb2_wakeup26(macb2_wakeup26),
        .macb1_wakeup26(macb1_wakeup26),
        .macb0_wakeup26(macb0_wakeup26),
    // -- Module26 control26 outputs26
    	.scan_in26(),			//  : in  std_logic26;
    	.scan_en26(scan_en26),             	//  : in  std_logic26;
    	.scan_mode26(scan_mode26),          //  : in  std_logic26;
    	.scan_out26(),            	//  : out std_logic26;
    	.int_source_h26(int_source_h26),    //  : out std_logic26;
     	.rstn_non_srpg_smc26(rstn_non_srpg_smc26), 		//   : out std_logic26;
    	.gate_clk_smc26(gate_clk_smc26), 	//  : out std_logic26;
    	.isolate_smc26(isolate_smc26), 	//  : out std_logic26;
    	.save_edge_smc26(save_edge_smc26), 	//  : out std_logic26;
    	.restore_edge_smc26(restore_edge_smc26), 	//  : out std_logic26;
    	.pwr1_on_smc26(pwr1_on_smc26), 	//  : out std_logic26;
    	.pwr2_on_smc26(pwr2_on_smc26), 	//  : out std_logic26
	.pwr1_off_smc26(pwr1_off_smc26), 	//  : out std_logic26;
    	.pwr2_off_smc26(pwr2_off_smc26), 	//  : out std_logic26
     	.rstn_non_srpg_urt26(rstn_non_srpg_urt26), 		//   : out std_logic26;
    	.gate_clk_urt26(gate_clk_urt26), 	//  : out std_logic26;
    	.isolate_urt26(isolate_urt26), 	//  : out std_logic26;
    	.save_edge_urt26(save_edge_urt26), 	//  : out std_logic26;
    	.restore_edge_urt26(restore_edge_urt26), 	//  : out std_logic26;
    	.pwr1_on_urt26(pwr1_on_urt26), 	//  : out std_logic26;
    	.pwr2_on_urt26(pwr2_on_urt26), 	//  : out std_logic26;
    	.pwr1_off_urt26(pwr1_off_urt26),    //  : out std_logic26;
    	.pwr2_off_urt26(pwr2_off_urt26),     //  : out std_logic26
     	.rstn_non_srpg_macb026(rstn_non_srpg_macb026), 		//   : out std_logic26;
    	.gate_clk_macb026(gate_clk_macb026), 	//  : out std_logic26;
    	.isolate_macb026(isolate_macb026), 	//  : out std_logic26;
    	.save_edge_macb026(save_edge_macb026), 	//  : out std_logic26;
    	.restore_edge_macb026(restore_edge_macb026), 	//  : out std_logic26;
    	.pwr1_on_macb026(pwr1_on_macb026), 	//  : out std_logic26;
    	.pwr2_on_macb026(pwr2_on_macb026), 	//  : out std_logic26;
    	.pwr1_off_macb026(pwr1_off_macb026),    //  : out std_logic26;
    	.pwr2_off_macb026(pwr2_off_macb026),     //  : out std_logic26
     	.rstn_non_srpg_macb126(rstn_non_srpg_macb126), 		//   : out std_logic26;
    	.gate_clk_macb126(gate_clk_macb126), 	//  : out std_logic26;
    	.isolate_macb126(isolate_macb126), 	//  : out std_logic26;
    	.save_edge_macb126(save_edge_macb126), 	//  : out std_logic26;
    	.restore_edge_macb126(restore_edge_macb126), 	//  : out std_logic26;
    	.pwr1_on_macb126(pwr1_on_macb126), 	//  : out std_logic26;
    	.pwr2_on_macb126(pwr2_on_macb126), 	//  : out std_logic26;
    	.pwr1_off_macb126(pwr1_off_macb126),    //  : out std_logic26;
    	.pwr2_off_macb126(pwr2_off_macb126),     //  : out std_logic26
     	.rstn_non_srpg_macb226(rstn_non_srpg_macb226), 		//   : out std_logic26;
    	.gate_clk_macb226(gate_clk_macb226), 	//  : out std_logic26;
    	.isolate_macb226(isolate_macb226), 	//  : out std_logic26;
    	.save_edge_macb226(save_edge_macb226), 	//  : out std_logic26;
    	.restore_edge_macb226(restore_edge_macb226), 	//  : out std_logic26;
    	.pwr1_on_macb226(pwr1_on_macb226), 	//  : out std_logic26;
    	.pwr2_on_macb226(pwr2_on_macb226), 	//  : out std_logic26;
    	.pwr1_off_macb226(pwr1_off_macb226),    //  : out std_logic26;
    	.pwr2_off_macb226(pwr2_off_macb226),     //  : out std_logic26
     	.rstn_non_srpg_macb326(rstn_non_srpg_macb326), 		//   : out std_logic26;
    	.gate_clk_macb326(gate_clk_macb326), 	//  : out std_logic26;
    	.isolate_macb326(isolate_macb326), 	//  : out std_logic26;
    	.save_edge_macb326(save_edge_macb326), 	//  : out std_logic26;
    	.restore_edge_macb326(restore_edge_macb326), 	//  : out std_logic26;
    	.pwr1_on_macb326(pwr1_on_macb326), 	//  : out std_logic26;
    	.pwr2_on_macb326(pwr2_on_macb326), 	//  : out std_logic26;
    	.pwr1_off_macb326(pwr1_off_macb326),    //  : out std_logic26;
    	.pwr2_off_macb326(pwr2_off_macb326),     //  : out std_logic26
        .rstn_non_srpg_dma26(rstn_non_srpg_dma26 ) ,
        .gate_clk_dma26(gate_clk_dma26      )      ,
        .isolate_dma26(isolate_dma26       )       ,
        .save_edge_dma26(save_edge_dma26   )   ,
        .restore_edge_dma26(restore_edge_dma26   )   ,
        .pwr1_on_dma26(pwr1_on_dma26       )       ,
        .pwr2_on_dma26(pwr2_on_dma26       )       ,
        .pwr1_off_dma26(pwr1_off_dma26      )      ,
        .pwr2_off_dma26(pwr2_off_dma26      )      ,
        
        .rstn_non_srpg_cpu26(rstn_non_srpg_cpu26 ) ,
        .gate_clk_cpu26(gate_clk_cpu26      )      ,
        .isolate_cpu26(isolate_cpu26       )       ,
        .save_edge_cpu26(save_edge_cpu26   )   ,
        .restore_edge_cpu26(restore_edge_cpu26   )   ,
        .pwr1_on_cpu26(pwr1_on_cpu26       )       ,
        .pwr2_on_cpu26(pwr2_on_cpu26       )       ,
        .pwr1_off_cpu26(pwr1_off_cpu26      )      ,
        .pwr2_off_cpu26(pwr2_off_cpu26      )      ,
        
        .rstn_non_srpg_alut26(rstn_non_srpg_alut26 ) ,
        .gate_clk_alut26(gate_clk_alut26      )      ,
        .isolate_alut26(isolate_alut26       )       ,
        .save_edge_alut26(save_edge_alut26   )   ,
        .restore_edge_alut26(restore_edge_alut26   )   ,
        .pwr1_on_alut26(pwr1_on_alut26       )       ,
        .pwr2_on_alut26(pwr2_on_alut26       )       ,
        .pwr1_off_alut26(pwr1_off_alut26      )      ,
        .pwr2_off_alut26(pwr2_off_alut26      )      ,
        
        .rstn_non_srpg_mem26(rstn_non_srpg_mem26 ) ,
        .gate_clk_mem26(gate_clk_mem26      )      ,
        .isolate_mem26(isolate_mem26       )       ,
        .save_edge_mem26(save_edge_mem26   )   ,
        .restore_edge_mem26(restore_edge_mem26   )   ,
        .pwr1_on_mem26(pwr1_on_mem26       )       ,
        .pwr2_on_mem26(pwr2_on_mem26       )       ,
        .pwr1_off_mem26(pwr1_off_mem26      )      ,
        .pwr2_off_mem26(pwr2_off_mem26      )      ,

    	.core06v26(core06v26),     //  : out std_logic26
    	.core08v26(core08v26),     //  : out std_logic26
    	.core10v26(core10v26),     //  : out std_logic26
    	.core12v26(core12v26),     //  : out std_logic26
        .pcm_macb_wakeup_int26(pcm_macb_wakeup_int26),
        .mte_smc_start26(mte_smc_start26),
        .mte_uart_start26(mte_uart_start26),
        .mte_smc_uart_start26(mte_smc_uart_start26),  
        .mte_pm_smc_to_default_start26(mte_pm_smc_to_default_start26), 
        .mte_pm_uart_to_default_start26(mte_pm_uart_to_default_start26),
        .mte_pm_smc_uart_to_default_start26(mte_pm_smc_uart_to_default_start26)
);


`else 
//##############################################################################
// if the POWER_CTRL26 is black26 boxed26 
//##############################################################################

   //------------------------------------
   // Clocks26 & Reset26
   //------------------------------------
   wire              pclk26;
   wire              nprst26;
   //------------------------------------
   // APB26 programming26 interface;
   //------------------------------------
   wire   [31:0]     paddr26;
   wire              psel26;
   wire              penable26;
   wire              pwrite26;
   wire   [31:0]     pwdata26;
   reg    [31:0]     prdata26;
   //------------------------------------
   // Scan26
   //------------------------------------
   wire              scan_in26;
   wire              scan_en26;
   wire              scan_mode26;
   reg               scan_out26;
   //------------------------------------
   // Module26 control26 outputs26
   //------------------------------------
   // SMC26;
   reg               rstn_non_srpg_smc26;
   reg               gate_clk_smc26;
   reg               isolate_smc26;
   reg               save_edge_smc26;
   reg               restore_edge_smc26;
   reg               pwr1_on_smc26;
   reg               pwr2_on_smc26;
   wire              pwr1_off_smc26;
   wire              pwr2_off_smc26;

   // URT26;
   reg               rstn_non_srpg_urt26;
   reg               gate_clk_urt26;
   reg               isolate_urt26;
   reg               save_edge_urt26;
   reg               restore_edge_urt26;
   reg               pwr1_on_urt26;
   reg               pwr2_on_urt26;
   wire              pwr1_off_urt26;
   wire              pwr2_off_urt26;

   // ETH026
   reg               rstn_non_srpg_macb026;
   reg               gate_clk_macb026;
   reg               isolate_macb026;
   reg               save_edge_macb026;
   reg               restore_edge_macb026;
   reg               pwr1_on_macb026;
   reg               pwr2_on_macb026;
   wire              pwr1_off_macb026;
   wire              pwr2_off_macb026;
   // ETH126
   reg               rstn_non_srpg_macb126;
   reg               gate_clk_macb126;
   reg               isolate_macb126;
   reg               save_edge_macb126;
   reg               restore_edge_macb126;
   reg               pwr1_on_macb126;
   reg               pwr2_on_macb126;
   wire              pwr1_off_macb126;
   wire              pwr2_off_macb126;
   // ETH226
   reg               rstn_non_srpg_macb226;
   reg               gate_clk_macb226;
   reg               isolate_macb226;
   reg               save_edge_macb226;
   reg               restore_edge_macb226;
   reg               pwr1_on_macb226;
   reg               pwr2_on_macb226;
   wire              pwr1_off_macb226;
   wire              pwr2_off_macb226;
   // ETH326
   reg               rstn_non_srpg_macb326;
   reg               gate_clk_macb326;
   reg               isolate_macb326;
   reg               save_edge_macb326;
   reg               restore_edge_macb326;
   reg               pwr1_on_macb326;
   reg               pwr2_on_macb326;
   wire              pwr1_off_macb326;
   wire              pwr2_off_macb326;

   wire core06v26;
   wire core08v26;
   wire core10v26;
   wire core12v26;



`endif
//##############################################################################
// black26 boxed26 defines26 
//##############################################################################

endmodule
