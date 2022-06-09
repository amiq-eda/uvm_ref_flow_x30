//File17 name   : power_ctrl_veneer17.v
//Title17       : 
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------
module power_ctrl_veneer17 (
    //------------------------------------
    // Clocks17 & Reset17
    //------------------------------------
    pclk17,
    nprst17,
    //------------------------------------
    // APB17 programming17 interface
    //------------------------------------
    paddr17,
    psel17,
    penable17,
    pwrite17,
    pwdata17,
    prdata17,
    // mac17 i/f,
    macb3_wakeup17,
    macb2_wakeup17,
    macb1_wakeup17,
    macb0_wakeup17,
    //------------------------------------
    // Scan17 
    //------------------------------------
    scan_in17,
    scan_en17,
    scan_mode17,
    scan_out17,
    int_source_h17,
    //------------------------------------
    // Module17 control17 outputs17
    //------------------------------------
    // SMC17
    rstn_non_srpg_smc17,
    gate_clk_smc17,
    isolate_smc17,
    save_edge_smc17,
    restore_edge_smc17,
    pwr1_on_smc17,
    pwr2_on_smc17,
    // URT17
    rstn_non_srpg_urt17,
    gate_clk_urt17,
    isolate_urt17,
    save_edge_urt17,
    restore_edge_urt17,
    pwr1_on_urt17,
    pwr2_on_urt17,
    // ETH017
    rstn_non_srpg_macb017,
    gate_clk_macb017,
    isolate_macb017,
    save_edge_macb017,
    restore_edge_macb017,
    pwr1_on_macb017,
    pwr2_on_macb017,
    // ETH117
    rstn_non_srpg_macb117,
    gate_clk_macb117,
    isolate_macb117,
    save_edge_macb117,
    restore_edge_macb117,
    pwr1_on_macb117,
    pwr2_on_macb117,
    // ETH217
    rstn_non_srpg_macb217,
    gate_clk_macb217,
    isolate_macb217,
    save_edge_macb217,
    restore_edge_macb217,
    pwr1_on_macb217,
    pwr2_on_macb217,
    // ETH317
    rstn_non_srpg_macb317,
    gate_clk_macb317,
    isolate_macb317,
    save_edge_macb317,
    restore_edge_macb317,
    pwr1_on_macb317,
    pwr2_on_macb317,
    // core17 dvfs17 transitions17
    core06v17,
    core08v17,
    core10v17,
    core12v17,
    pcm_macb_wakeup_int17,
    isolate_mem17,
    
    // transit17 signals17
    mte_smc_start17,
    mte_uart_start17,
    mte_smc_uart_start17,  
    mte_pm_smc_to_default_start17, 
    mte_pm_uart_to_default_start17,
    mte_pm_smc_uart_to_default_start17
  );

//------------------------------------------------------------------------------
// I17/O17 declaration17
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks17 & Reset17
   //------------------------------------
   input             pclk17;
   input             nprst17;
   //------------------------------------
   // APB17 programming17 interface;
   //------------------------------------
   input  [31:0]     paddr17;
   input             psel17;
   input             penable17;
   input             pwrite17;
   input  [31:0]     pwdata17;
   output [31:0]     prdata17;
    // mac17
   input macb3_wakeup17;
   input macb2_wakeup17;
   input macb1_wakeup17;
   input macb0_wakeup17;
   //------------------------------------
   // Scan17
   //------------------------------------
   input             scan_in17;
   input             scan_en17;
   input             scan_mode17;
   output            scan_out17;
   //------------------------------------
   // Module17 control17 outputs17
   input             int_source_h17;
   //------------------------------------
   // SMC17
   output            rstn_non_srpg_smc17;
   output            gate_clk_smc17;
   output            isolate_smc17;
   output            save_edge_smc17;
   output            restore_edge_smc17;
   output            pwr1_on_smc17;
   output            pwr2_on_smc17;
   // URT17
   output            rstn_non_srpg_urt17;
   output            gate_clk_urt17;
   output            isolate_urt17;
   output            save_edge_urt17;
   output            restore_edge_urt17;
   output            pwr1_on_urt17;
   output            pwr2_on_urt17;
   // ETH017
   output            rstn_non_srpg_macb017;
   output            gate_clk_macb017;
   output            isolate_macb017;
   output            save_edge_macb017;
   output            restore_edge_macb017;
   output            pwr1_on_macb017;
   output            pwr2_on_macb017;
   // ETH117
   output            rstn_non_srpg_macb117;
   output            gate_clk_macb117;
   output            isolate_macb117;
   output            save_edge_macb117;
   output            restore_edge_macb117;
   output            pwr1_on_macb117;
   output            pwr2_on_macb117;
   // ETH217
   output            rstn_non_srpg_macb217;
   output            gate_clk_macb217;
   output            isolate_macb217;
   output            save_edge_macb217;
   output            restore_edge_macb217;
   output            pwr1_on_macb217;
   output            pwr2_on_macb217;
   // ETH317
   output            rstn_non_srpg_macb317;
   output            gate_clk_macb317;
   output            isolate_macb317;
   output            save_edge_macb317;
   output            restore_edge_macb317;
   output            pwr1_on_macb317;
   output            pwr2_on_macb317;

   // dvfs17
   output core06v17;
   output core08v17;
   output core10v17;
   output core12v17;
   output pcm_macb_wakeup_int17 ;
   output isolate_mem17 ;

   //transit17  signals17
   output mte_smc_start17;
   output mte_uart_start17;
   output mte_smc_uart_start17;  
   output mte_pm_smc_to_default_start17; 
   output mte_pm_uart_to_default_start17;
   output mte_pm_smc_uart_to_default_start17;



//##############################################################################
// if the POWER_CTRL17 is NOT17 black17 boxed17 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL17

power_ctrl17 i_power_ctrl17(
    // -- Clocks17 & Reset17
    	.pclk17(pclk17), 			//  : in  std_logic17;
    	.nprst17(nprst17), 		//  : in  std_logic17;
    // -- APB17 programming17 interface
    	.paddr17(paddr17), 			//  : in  std_logic_vector17(31 downto17 0);
    	.psel17(psel17), 			//  : in  std_logic17;
    	.penable17(penable17), 		//  : in  std_logic17;
    	.pwrite17(pwrite17), 		//  : in  std_logic17;
    	.pwdata17(pwdata17), 		//  : in  std_logic_vector17(31 downto17 0);
    	.prdata17(prdata17), 		//  : out std_logic_vector17(31 downto17 0);
        .macb3_wakeup17(macb3_wakeup17),
        .macb2_wakeup17(macb2_wakeup17),
        .macb1_wakeup17(macb1_wakeup17),
        .macb0_wakeup17(macb0_wakeup17),
    // -- Module17 control17 outputs17
    	.scan_in17(),			//  : in  std_logic17;
    	.scan_en17(scan_en17),             	//  : in  std_logic17;
    	.scan_mode17(scan_mode17),          //  : in  std_logic17;
    	.scan_out17(),            	//  : out std_logic17;
    	.int_source_h17(int_source_h17),    //  : out std_logic17;
     	.rstn_non_srpg_smc17(rstn_non_srpg_smc17), 		//   : out std_logic17;
    	.gate_clk_smc17(gate_clk_smc17), 	//  : out std_logic17;
    	.isolate_smc17(isolate_smc17), 	//  : out std_logic17;
    	.save_edge_smc17(save_edge_smc17), 	//  : out std_logic17;
    	.restore_edge_smc17(restore_edge_smc17), 	//  : out std_logic17;
    	.pwr1_on_smc17(pwr1_on_smc17), 	//  : out std_logic17;
    	.pwr2_on_smc17(pwr2_on_smc17), 	//  : out std_logic17
	.pwr1_off_smc17(pwr1_off_smc17), 	//  : out std_logic17;
    	.pwr2_off_smc17(pwr2_off_smc17), 	//  : out std_logic17
     	.rstn_non_srpg_urt17(rstn_non_srpg_urt17), 		//   : out std_logic17;
    	.gate_clk_urt17(gate_clk_urt17), 	//  : out std_logic17;
    	.isolate_urt17(isolate_urt17), 	//  : out std_logic17;
    	.save_edge_urt17(save_edge_urt17), 	//  : out std_logic17;
    	.restore_edge_urt17(restore_edge_urt17), 	//  : out std_logic17;
    	.pwr1_on_urt17(pwr1_on_urt17), 	//  : out std_logic17;
    	.pwr2_on_urt17(pwr2_on_urt17), 	//  : out std_logic17;
    	.pwr1_off_urt17(pwr1_off_urt17),    //  : out std_logic17;
    	.pwr2_off_urt17(pwr2_off_urt17),     //  : out std_logic17
     	.rstn_non_srpg_macb017(rstn_non_srpg_macb017), 		//   : out std_logic17;
    	.gate_clk_macb017(gate_clk_macb017), 	//  : out std_logic17;
    	.isolate_macb017(isolate_macb017), 	//  : out std_logic17;
    	.save_edge_macb017(save_edge_macb017), 	//  : out std_logic17;
    	.restore_edge_macb017(restore_edge_macb017), 	//  : out std_logic17;
    	.pwr1_on_macb017(pwr1_on_macb017), 	//  : out std_logic17;
    	.pwr2_on_macb017(pwr2_on_macb017), 	//  : out std_logic17;
    	.pwr1_off_macb017(pwr1_off_macb017),    //  : out std_logic17;
    	.pwr2_off_macb017(pwr2_off_macb017),     //  : out std_logic17
     	.rstn_non_srpg_macb117(rstn_non_srpg_macb117), 		//   : out std_logic17;
    	.gate_clk_macb117(gate_clk_macb117), 	//  : out std_logic17;
    	.isolate_macb117(isolate_macb117), 	//  : out std_logic17;
    	.save_edge_macb117(save_edge_macb117), 	//  : out std_logic17;
    	.restore_edge_macb117(restore_edge_macb117), 	//  : out std_logic17;
    	.pwr1_on_macb117(pwr1_on_macb117), 	//  : out std_logic17;
    	.pwr2_on_macb117(pwr2_on_macb117), 	//  : out std_logic17;
    	.pwr1_off_macb117(pwr1_off_macb117),    //  : out std_logic17;
    	.pwr2_off_macb117(pwr2_off_macb117),     //  : out std_logic17
     	.rstn_non_srpg_macb217(rstn_non_srpg_macb217), 		//   : out std_logic17;
    	.gate_clk_macb217(gate_clk_macb217), 	//  : out std_logic17;
    	.isolate_macb217(isolate_macb217), 	//  : out std_logic17;
    	.save_edge_macb217(save_edge_macb217), 	//  : out std_logic17;
    	.restore_edge_macb217(restore_edge_macb217), 	//  : out std_logic17;
    	.pwr1_on_macb217(pwr1_on_macb217), 	//  : out std_logic17;
    	.pwr2_on_macb217(pwr2_on_macb217), 	//  : out std_logic17;
    	.pwr1_off_macb217(pwr1_off_macb217),    //  : out std_logic17;
    	.pwr2_off_macb217(pwr2_off_macb217),     //  : out std_logic17
     	.rstn_non_srpg_macb317(rstn_non_srpg_macb317), 		//   : out std_logic17;
    	.gate_clk_macb317(gate_clk_macb317), 	//  : out std_logic17;
    	.isolate_macb317(isolate_macb317), 	//  : out std_logic17;
    	.save_edge_macb317(save_edge_macb317), 	//  : out std_logic17;
    	.restore_edge_macb317(restore_edge_macb317), 	//  : out std_logic17;
    	.pwr1_on_macb317(pwr1_on_macb317), 	//  : out std_logic17;
    	.pwr2_on_macb317(pwr2_on_macb317), 	//  : out std_logic17;
    	.pwr1_off_macb317(pwr1_off_macb317),    //  : out std_logic17;
    	.pwr2_off_macb317(pwr2_off_macb317),     //  : out std_logic17
        .rstn_non_srpg_dma17(rstn_non_srpg_dma17 ) ,
        .gate_clk_dma17(gate_clk_dma17      )      ,
        .isolate_dma17(isolate_dma17       )       ,
        .save_edge_dma17(save_edge_dma17   )   ,
        .restore_edge_dma17(restore_edge_dma17   )   ,
        .pwr1_on_dma17(pwr1_on_dma17       )       ,
        .pwr2_on_dma17(pwr2_on_dma17       )       ,
        .pwr1_off_dma17(pwr1_off_dma17      )      ,
        .pwr2_off_dma17(pwr2_off_dma17      )      ,
        
        .rstn_non_srpg_cpu17(rstn_non_srpg_cpu17 ) ,
        .gate_clk_cpu17(gate_clk_cpu17      )      ,
        .isolate_cpu17(isolate_cpu17       )       ,
        .save_edge_cpu17(save_edge_cpu17   )   ,
        .restore_edge_cpu17(restore_edge_cpu17   )   ,
        .pwr1_on_cpu17(pwr1_on_cpu17       )       ,
        .pwr2_on_cpu17(pwr2_on_cpu17       )       ,
        .pwr1_off_cpu17(pwr1_off_cpu17      )      ,
        .pwr2_off_cpu17(pwr2_off_cpu17      )      ,
        
        .rstn_non_srpg_alut17(rstn_non_srpg_alut17 ) ,
        .gate_clk_alut17(gate_clk_alut17      )      ,
        .isolate_alut17(isolate_alut17       )       ,
        .save_edge_alut17(save_edge_alut17   )   ,
        .restore_edge_alut17(restore_edge_alut17   )   ,
        .pwr1_on_alut17(pwr1_on_alut17       )       ,
        .pwr2_on_alut17(pwr2_on_alut17       )       ,
        .pwr1_off_alut17(pwr1_off_alut17      )      ,
        .pwr2_off_alut17(pwr2_off_alut17      )      ,
        
        .rstn_non_srpg_mem17(rstn_non_srpg_mem17 ) ,
        .gate_clk_mem17(gate_clk_mem17      )      ,
        .isolate_mem17(isolate_mem17       )       ,
        .save_edge_mem17(save_edge_mem17   )   ,
        .restore_edge_mem17(restore_edge_mem17   )   ,
        .pwr1_on_mem17(pwr1_on_mem17       )       ,
        .pwr2_on_mem17(pwr2_on_mem17       )       ,
        .pwr1_off_mem17(pwr1_off_mem17      )      ,
        .pwr2_off_mem17(pwr2_off_mem17      )      ,

    	.core06v17(core06v17),     //  : out std_logic17
    	.core08v17(core08v17),     //  : out std_logic17
    	.core10v17(core10v17),     //  : out std_logic17
    	.core12v17(core12v17),     //  : out std_logic17
        .pcm_macb_wakeup_int17(pcm_macb_wakeup_int17),
        .mte_smc_start17(mte_smc_start17),
        .mte_uart_start17(mte_uart_start17),
        .mte_smc_uart_start17(mte_smc_uart_start17),  
        .mte_pm_smc_to_default_start17(mte_pm_smc_to_default_start17), 
        .mte_pm_uart_to_default_start17(mte_pm_uart_to_default_start17),
        .mte_pm_smc_uart_to_default_start17(mte_pm_smc_uart_to_default_start17)
);


`else 
//##############################################################################
// if the POWER_CTRL17 is black17 boxed17 
//##############################################################################

   //------------------------------------
   // Clocks17 & Reset17
   //------------------------------------
   wire              pclk17;
   wire              nprst17;
   //------------------------------------
   // APB17 programming17 interface;
   //------------------------------------
   wire   [31:0]     paddr17;
   wire              psel17;
   wire              penable17;
   wire              pwrite17;
   wire   [31:0]     pwdata17;
   reg    [31:0]     prdata17;
   //------------------------------------
   // Scan17
   //------------------------------------
   wire              scan_in17;
   wire              scan_en17;
   wire              scan_mode17;
   reg               scan_out17;
   //------------------------------------
   // Module17 control17 outputs17
   //------------------------------------
   // SMC17;
   reg               rstn_non_srpg_smc17;
   reg               gate_clk_smc17;
   reg               isolate_smc17;
   reg               save_edge_smc17;
   reg               restore_edge_smc17;
   reg               pwr1_on_smc17;
   reg               pwr2_on_smc17;
   wire              pwr1_off_smc17;
   wire              pwr2_off_smc17;

   // URT17;
   reg               rstn_non_srpg_urt17;
   reg               gate_clk_urt17;
   reg               isolate_urt17;
   reg               save_edge_urt17;
   reg               restore_edge_urt17;
   reg               pwr1_on_urt17;
   reg               pwr2_on_urt17;
   wire              pwr1_off_urt17;
   wire              pwr2_off_urt17;

   // ETH017
   reg               rstn_non_srpg_macb017;
   reg               gate_clk_macb017;
   reg               isolate_macb017;
   reg               save_edge_macb017;
   reg               restore_edge_macb017;
   reg               pwr1_on_macb017;
   reg               pwr2_on_macb017;
   wire              pwr1_off_macb017;
   wire              pwr2_off_macb017;
   // ETH117
   reg               rstn_non_srpg_macb117;
   reg               gate_clk_macb117;
   reg               isolate_macb117;
   reg               save_edge_macb117;
   reg               restore_edge_macb117;
   reg               pwr1_on_macb117;
   reg               pwr2_on_macb117;
   wire              pwr1_off_macb117;
   wire              pwr2_off_macb117;
   // ETH217
   reg               rstn_non_srpg_macb217;
   reg               gate_clk_macb217;
   reg               isolate_macb217;
   reg               save_edge_macb217;
   reg               restore_edge_macb217;
   reg               pwr1_on_macb217;
   reg               pwr2_on_macb217;
   wire              pwr1_off_macb217;
   wire              pwr2_off_macb217;
   // ETH317
   reg               rstn_non_srpg_macb317;
   reg               gate_clk_macb317;
   reg               isolate_macb317;
   reg               save_edge_macb317;
   reg               restore_edge_macb317;
   reg               pwr1_on_macb317;
   reg               pwr2_on_macb317;
   wire              pwr1_off_macb317;
   wire              pwr2_off_macb317;

   wire core06v17;
   wire core08v17;
   wire core10v17;
   wire core12v17;



`endif
//##############################################################################
// black17 boxed17 defines17 
//##############################################################################

endmodule
