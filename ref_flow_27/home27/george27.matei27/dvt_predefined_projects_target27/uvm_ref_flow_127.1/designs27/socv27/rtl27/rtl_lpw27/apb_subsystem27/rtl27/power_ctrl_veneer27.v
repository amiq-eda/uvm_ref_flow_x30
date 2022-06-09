//File27 name   : power_ctrl_veneer27.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------
module power_ctrl_veneer27 (
    //------------------------------------
    // Clocks27 & Reset27
    //------------------------------------
    pclk27,
    nprst27,
    //------------------------------------
    // APB27 programming27 interface
    //------------------------------------
    paddr27,
    psel27,
    penable27,
    pwrite27,
    pwdata27,
    prdata27,
    // mac27 i/f,
    macb3_wakeup27,
    macb2_wakeup27,
    macb1_wakeup27,
    macb0_wakeup27,
    //------------------------------------
    // Scan27 
    //------------------------------------
    scan_in27,
    scan_en27,
    scan_mode27,
    scan_out27,
    int_source_h27,
    //------------------------------------
    // Module27 control27 outputs27
    //------------------------------------
    // SMC27
    rstn_non_srpg_smc27,
    gate_clk_smc27,
    isolate_smc27,
    save_edge_smc27,
    restore_edge_smc27,
    pwr1_on_smc27,
    pwr2_on_smc27,
    // URT27
    rstn_non_srpg_urt27,
    gate_clk_urt27,
    isolate_urt27,
    save_edge_urt27,
    restore_edge_urt27,
    pwr1_on_urt27,
    pwr2_on_urt27,
    // ETH027
    rstn_non_srpg_macb027,
    gate_clk_macb027,
    isolate_macb027,
    save_edge_macb027,
    restore_edge_macb027,
    pwr1_on_macb027,
    pwr2_on_macb027,
    // ETH127
    rstn_non_srpg_macb127,
    gate_clk_macb127,
    isolate_macb127,
    save_edge_macb127,
    restore_edge_macb127,
    pwr1_on_macb127,
    pwr2_on_macb127,
    // ETH227
    rstn_non_srpg_macb227,
    gate_clk_macb227,
    isolate_macb227,
    save_edge_macb227,
    restore_edge_macb227,
    pwr1_on_macb227,
    pwr2_on_macb227,
    // ETH327
    rstn_non_srpg_macb327,
    gate_clk_macb327,
    isolate_macb327,
    save_edge_macb327,
    restore_edge_macb327,
    pwr1_on_macb327,
    pwr2_on_macb327,
    // core27 dvfs27 transitions27
    core06v27,
    core08v27,
    core10v27,
    core12v27,
    pcm_macb_wakeup_int27,
    isolate_mem27,
    
    // transit27 signals27
    mte_smc_start27,
    mte_uart_start27,
    mte_smc_uart_start27,  
    mte_pm_smc_to_default_start27, 
    mte_pm_uart_to_default_start27,
    mte_pm_smc_uart_to_default_start27
  );

//------------------------------------------------------------------------------
// I27/O27 declaration27
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks27 & Reset27
   //------------------------------------
   input             pclk27;
   input             nprst27;
   //------------------------------------
   // APB27 programming27 interface;
   //------------------------------------
   input  [31:0]     paddr27;
   input             psel27;
   input             penable27;
   input             pwrite27;
   input  [31:0]     pwdata27;
   output [31:0]     prdata27;
    // mac27
   input macb3_wakeup27;
   input macb2_wakeup27;
   input macb1_wakeup27;
   input macb0_wakeup27;
   //------------------------------------
   // Scan27
   //------------------------------------
   input             scan_in27;
   input             scan_en27;
   input             scan_mode27;
   output            scan_out27;
   //------------------------------------
   // Module27 control27 outputs27
   input             int_source_h27;
   //------------------------------------
   // SMC27
   output            rstn_non_srpg_smc27;
   output            gate_clk_smc27;
   output            isolate_smc27;
   output            save_edge_smc27;
   output            restore_edge_smc27;
   output            pwr1_on_smc27;
   output            pwr2_on_smc27;
   // URT27
   output            rstn_non_srpg_urt27;
   output            gate_clk_urt27;
   output            isolate_urt27;
   output            save_edge_urt27;
   output            restore_edge_urt27;
   output            pwr1_on_urt27;
   output            pwr2_on_urt27;
   // ETH027
   output            rstn_non_srpg_macb027;
   output            gate_clk_macb027;
   output            isolate_macb027;
   output            save_edge_macb027;
   output            restore_edge_macb027;
   output            pwr1_on_macb027;
   output            pwr2_on_macb027;
   // ETH127
   output            rstn_non_srpg_macb127;
   output            gate_clk_macb127;
   output            isolate_macb127;
   output            save_edge_macb127;
   output            restore_edge_macb127;
   output            pwr1_on_macb127;
   output            pwr2_on_macb127;
   // ETH227
   output            rstn_non_srpg_macb227;
   output            gate_clk_macb227;
   output            isolate_macb227;
   output            save_edge_macb227;
   output            restore_edge_macb227;
   output            pwr1_on_macb227;
   output            pwr2_on_macb227;
   // ETH327
   output            rstn_non_srpg_macb327;
   output            gate_clk_macb327;
   output            isolate_macb327;
   output            save_edge_macb327;
   output            restore_edge_macb327;
   output            pwr1_on_macb327;
   output            pwr2_on_macb327;

   // dvfs27
   output core06v27;
   output core08v27;
   output core10v27;
   output core12v27;
   output pcm_macb_wakeup_int27 ;
   output isolate_mem27 ;

   //transit27  signals27
   output mte_smc_start27;
   output mte_uart_start27;
   output mte_smc_uart_start27;  
   output mte_pm_smc_to_default_start27; 
   output mte_pm_uart_to_default_start27;
   output mte_pm_smc_uart_to_default_start27;



//##############################################################################
// if the POWER_CTRL27 is NOT27 black27 boxed27 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL27

power_ctrl27 i_power_ctrl27(
    // -- Clocks27 & Reset27
    	.pclk27(pclk27), 			//  : in  std_logic27;
    	.nprst27(nprst27), 		//  : in  std_logic27;
    // -- APB27 programming27 interface
    	.paddr27(paddr27), 			//  : in  std_logic_vector27(31 downto27 0);
    	.psel27(psel27), 			//  : in  std_logic27;
    	.penable27(penable27), 		//  : in  std_logic27;
    	.pwrite27(pwrite27), 		//  : in  std_logic27;
    	.pwdata27(pwdata27), 		//  : in  std_logic_vector27(31 downto27 0);
    	.prdata27(prdata27), 		//  : out std_logic_vector27(31 downto27 0);
        .macb3_wakeup27(macb3_wakeup27),
        .macb2_wakeup27(macb2_wakeup27),
        .macb1_wakeup27(macb1_wakeup27),
        .macb0_wakeup27(macb0_wakeup27),
    // -- Module27 control27 outputs27
    	.scan_in27(),			//  : in  std_logic27;
    	.scan_en27(scan_en27),             	//  : in  std_logic27;
    	.scan_mode27(scan_mode27),          //  : in  std_logic27;
    	.scan_out27(),            	//  : out std_logic27;
    	.int_source_h27(int_source_h27),    //  : out std_logic27;
     	.rstn_non_srpg_smc27(rstn_non_srpg_smc27), 		//   : out std_logic27;
    	.gate_clk_smc27(gate_clk_smc27), 	//  : out std_logic27;
    	.isolate_smc27(isolate_smc27), 	//  : out std_logic27;
    	.save_edge_smc27(save_edge_smc27), 	//  : out std_logic27;
    	.restore_edge_smc27(restore_edge_smc27), 	//  : out std_logic27;
    	.pwr1_on_smc27(pwr1_on_smc27), 	//  : out std_logic27;
    	.pwr2_on_smc27(pwr2_on_smc27), 	//  : out std_logic27
	.pwr1_off_smc27(pwr1_off_smc27), 	//  : out std_logic27;
    	.pwr2_off_smc27(pwr2_off_smc27), 	//  : out std_logic27
     	.rstn_non_srpg_urt27(rstn_non_srpg_urt27), 		//   : out std_logic27;
    	.gate_clk_urt27(gate_clk_urt27), 	//  : out std_logic27;
    	.isolate_urt27(isolate_urt27), 	//  : out std_logic27;
    	.save_edge_urt27(save_edge_urt27), 	//  : out std_logic27;
    	.restore_edge_urt27(restore_edge_urt27), 	//  : out std_logic27;
    	.pwr1_on_urt27(pwr1_on_urt27), 	//  : out std_logic27;
    	.pwr2_on_urt27(pwr2_on_urt27), 	//  : out std_logic27;
    	.pwr1_off_urt27(pwr1_off_urt27),    //  : out std_logic27;
    	.pwr2_off_urt27(pwr2_off_urt27),     //  : out std_logic27
     	.rstn_non_srpg_macb027(rstn_non_srpg_macb027), 		//   : out std_logic27;
    	.gate_clk_macb027(gate_clk_macb027), 	//  : out std_logic27;
    	.isolate_macb027(isolate_macb027), 	//  : out std_logic27;
    	.save_edge_macb027(save_edge_macb027), 	//  : out std_logic27;
    	.restore_edge_macb027(restore_edge_macb027), 	//  : out std_logic27;
    	.pwr1_on_macb027(pwr1_on_macb027), 	//  : out std_logic27;
    	.pwr2_on_macb027(pwr2_on_macb027), 	//  : out std_logic27;
    	.pwr1_off_macb027(pwr1_off_macb027),    //  : out std_logic27;
    	.pwr2_off_macb027(pwr2_off_macb027),     //  : out std_logic27
     	.rstn_non_srpg_macb127(rstn_non_srpg_macb127), 		//   : out std_logic27;
    	.gate_clk_macb127(gate_clk_macb127), 	//  : out std_logic27;
    	.isolate_macb127(isolate_macb127), 	//  : out std_logic27;
    	.save_edge_macb127(save_edge_macb127), 	//  : out std_logic27;
    	.restore_edge_macb127(restore_edge_macb127), 	//  : out std_logic27;
    	.pwr1_on_macb127(pwr1_on_macb127), 	//  : out std_logic27;
    	.pwr2_on_macb127(pwr2_on_macb127), 	//  : out std_logic27;
    	.pwr1_off_macb127(pwr1_off_macb127),    //  : out std_logic27;
    	.pwr2_off_macb127(pwr2_off_macb127),     //  : out std_logic27
     	.rstn_non_srpg_macb227(rstn_non_srpg_macb227), 		//   : out std_logic27;
    	.gate_clk_macb227(gate_clk_macb227), 	//  : out std_logic27;
    	.isolate_macb227(isolate_macb227), 	//  : out std_logic27;
    	.save_edge_macb227(save_edge_macb227), 	//  : out std_logic27;
    	.restore_edge_macb227(restore_edge_macb227), 	//  : out std_logic27;
    	.pwr1_on_macb227(pwr1_on_macb227), 	//  : out std_logic27;
    	.pwr2_on_macb227(pwr2_on_macb227), 	//  : out std_logic27;
    	.pwr1_off_macb227(pwr1_off_macb227),    //  : out std_logic27;
    	.pwr2_off_macb227(pwr2_off_macb227),     //  : out std_logic27
     	.rstn_non_srpg_macb327(rstn_non_srpg_macb327), 		//   : out std_logic27;
    	.gate_clk_macb327(gate_clk_macb327), 	//  : out std_logic27;
    	.isolate_macb327(isolate_macb327), 	//  : out std_logic27;
    	.save_edge_macb327(save_edge_macb327), 	//  : out std_logic27;
    	.restore_edge_macb327(restore_edge_macb327), 	//  : out std_logic27;
    	.pwr1_on_macb327(pwr1_on_macb327), 	//  : out std_logic27;
    	.pwr2_on_macb327(pwr2_on_macb327), 	//  : out std_logic27;
    	.pwr1_off_macb327(pwr1_off_macb327),    //  : out std_logic27;
    	.pwr2_off_macb327(pwr2_off_macb327),     //  : out std_logic27
        .rstn_non_srpg_dma27(rstn_non_srpg_dma27 ) ,
        .gate_clk_dma27(gate_clk_dma27      )      ,
        .isolate_dma27(isolate_dma27       )       ,
        .save_edge_dma27(save_edge_dma27   )   ,
        .restore_edge_dma27(restore_edge_dma27   )   ,
        .pwr1_on_dma27(pwr1_on_dma27       )       ,
        .pwr2_on_dma27(pwr2_on_dma27       )       ,
        .pwr1_off_dma27(pwr1_off_dma27      )      ,
        .pwr2_off_dma27(pwr2_off_dma27      )      ,
        
        .rstn_non_srpg_cpu27(rstn_non_srpg_cpu27 ) ,
        .gate_clk_cpu27(gate_clk_cpu27      )      ,
        .isolate_cpu27(isolate_cpu27       )       ,
        .save_edge_cpu27(save_edge_cpu27   )   ,
        .restore_edge_cpu27(restore_edge_cpu27   )   ,
        .pwr1_on_cpu27(pwr1_on_cpu27       )       ,
        .pwr2_on_cpu27(pwr2_on_cpu27       )       ,
        .pwr1_off_cpu27(pwr1_off_cpu27      )      ,
        .pwr2_off_cpu27(pwr2_off_cpu27      )      ,
        
        .rstn_non_srpg_alut27(rstn_non_srpg_alut27 ) ,
        .gate_clk_alut27(gate_clk_alut27      )      ,
        .isolate_alut27(isolate_alut27       )       ,
        .save_edge_alut27(save_edge_alut27   )   ,
        .restore_edge_alut27(restore_edge_alut27   )   ,
        .pwr1_on_alut27(pwr1_on_alut27       )       ,
        .pwr2_on_alut27(pwr2_on_alut27       )       ,
        .pwr1_off_alut27(pwr1_off_alut27      )      ,
        .pwr2_off_alut27(pwr2_off_alut27      )      ,
        
        .rstn_non_srpg_mem27(rstn_non_srpg_mem27 ) ,
        .gate_clk_mem27(gate_clk_mem27      )      ,
        .isolate_mem27(isolate_mem27       )       ,
        .save_edge_mem27(save_edge_mem27   )   ,
        .restore_edge_mem27(restore_edge_mem27   )   ,
        .pwr1_on_mem27(pwr1_on_mem27       )       ,
        .pwr2_on_mem27(pwr2_on_mem27       )       ,
        .pwr1_off_mem27(pwr1_off_mem27      )      ,
        .pwr2_off_mem27(pwr2_off_mem27      )      ,

    	.core06v27(core06v27),     //  : out std_logic27
    	.core08v27(core08v27),     //  : out std_logic27
    	.core10v27(core10v27),     //  : out std_logic27
    	.core12v27(core12v27),     //  : out std_logic27
        .pcm_macb_wakeup_int27(pcm_macb_wakeup_int27),
        .mte_smc_start27(mte_smc_start27),
        .mte_uart_start27(mte_uart_start27),
        .mte_smc_uart_start27(mte_smc_uart_start27),  
        .mte_pm_smc_to_default_start27(mte_pm_smc_to_default_start27), 
        .mte_pm_uart_to_default_start27(mte_pm_uart_to_default_start27),
        .mte_pm_smc_uart_to_default_start27(mte_pm_smc_uart_to_default_start27)
);


`else 
//##############################################################################
// if the POWER_CTRL27 is black27 boxed27 
//##############################################################################

   //------------------------------------
   // Clocks27 & Reset27
   //------------------------------------
   wire              pclk27;
   wire              nprst27;
   //------------------------------------
   // APB27 programming27 interface;
   //------------------------------------
   wire   [31:0]     paddr27;
   wire              psel27;
   wire              penable27;
   wire              pwrite27;
   wire   [31:0]     pwdata27;
   reg    [31:0]     prdata27;
   //------------------------------------
   // Scan27
   //------------------------------------
   wire              scan_in27;
   wire              scan_en27;
   wire              scan_mode27;
   reg               scan_out27;
   //------------------------------------
   // Module27 control27 outputs27
   //------------------------------------
   // SMC27;
   reg               rstn_non_srpg_smc27;
   reg               gate_clk_smc27;
   reg               isolate_smc27;
   reg               save_edge_smc27;
   reg               restore_edge_smc27;
   reg               pwr1_on_smc27;
   reg               pwr2_on_smc27;
   wire              pwr1_off_smc27;
   wire              pwr2_off_smc27;

   // URT27;
   reg               rstn_non_srpg_urt27;
   reg               gate_clk_urt27;
   reg               isolate_urt27;
   reg               save_edge_urt27;
   reg               restore_edge_urt27;
   reg               pwr1_on_urt27;
   reg               pwr2_on_urt27;
   wire              pwr1_off_urt27;
   wire              pwr2_off_urt27;

   // ETH027
   reg               rstn_non_srpg_macb027;
   reg               gate_clk_macb027;
   reg               isolate_macb027;
   reg               save_edge_macb027;
   reg               restore_edge_macb027;
   reg               pwr1_on_macb027;
   reg               pwr2_on_macb027;
   wire              pwr1_off_macb027;
   wire              pwr2_off_macb027;
   // ETH127
   reg               rstn_non_srpg_macb127;
   reg               gate_clk_macb127;
   reg               isolate_macb127;
   reg               save_edge_macb127;
   reg               restore_edge_macb127;
   reg               pwr1_on_macb127;
   reg               pwr2_on_macb127;
   wire              pwr1_off_macb127;
   wire              pwr2_off_macb127;
   // ETH227
   reg               rstn_non_srpg_macb227;
   reg               gate_clk_macb227;
   reg               isolate_macb227;
   reg               save_edge_macb227;
   reg               restore_edge_macb227;
   reg               pwr1_on_macb227;
   reg               pwr2_on_macb227;
   wire              pwr1_off_macb227;
   wire              pwr2_off_macb227;
   // ETH327
   reg               rstn_non_srpg_macb327;
   reg               gate_clk_macb327;
   reg               isolate_macb327;
   reg               save_edge_macb327;
   reg               restore_edge_macb327;
   reg               pwr1_on_macb327;
   reg               pwr2_on_macb327;
   wire              pwr1_off_macb327;
   wire              pwr2_off_macb327;

   wire core06v27;
   wire core08v27;
   wire core10v27;
   wire core12v27;



`endif
//##############################################################################
// black27 boxed27 defines27 
//##############################################################################

endmodule
