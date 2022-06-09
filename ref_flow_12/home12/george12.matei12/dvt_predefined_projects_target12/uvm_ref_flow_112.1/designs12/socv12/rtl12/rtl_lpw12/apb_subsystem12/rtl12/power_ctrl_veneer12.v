//File12 name   : power_ctrl_veneer12.v
//Title12       : 
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------
module power_ctrl_veneer12 (
    //------------------------------------
    // Clocks12 & Reset12
    //------------------------------------
    pclk12,
    nprst12,
    //------------------------------------
    // APB12 programming12 interface
    //------------------------------------
    paddr12,
    psel12,
    penable12,
    pwrite12,
    pwdata12,
    prdata12,
    // mac12 i/f,
    macb3_wakeup12,
    macb2_wakeup12,
    macb1_wakeup12,
    macb0_wakeup12,
    //------------------------------------
    // Scan12 
    //------------------------------------
    scan_in12,
    scan_en12,
    scan_mode12,
    scan_out12,
    int_source_h12,
    //------------------------------------
    // Module12 control12 outputs12
    //------------------------------------
    // SMC12
    rstn_non_srpg_smc12,
    gate_clk_smc12,
    isolate_smc12,
    save_edge_smc12,
    restore_edge_smc12,
    pwr1_on_smc12,
    pwr2_on_smc12,
    // URT12
    rstn_non_srpg_urt12,
    gate_clk_urt12,
    isolate_urt12,
    save_edge_urt12,
    restore_edge_urt12,
    pwr1_on_urt12,
    pwr2_on_urt12,
    // ETH012
    rstn_non_srpg_macb012,
    gate_clk_macb012,
    isolate_macb012,
    save_edge_macb012,
    restore_edge_macb012,
    pwr1_on_macb012,
    pwr2_on_macb012,
    // ETH112
    rstn_non_srpg_macb112,
    gate_clk_macb112,
    isolate_macb112,
    save_edge_macb112,
    restore_edge_macb112,
    pwr1_on_macb112,
    pwr2_on_macb112,
    // ETH212
    rstn_non_srpg_macb212,
    gate_clk_macb212,
    isolate_macb212,
    save_edge_macb212,
    restore_edge_macb212,
    pwr1_on_macb212,
    pwr2_on_macb212,
    // ETH312
    rstn_non_srpg_macb312,
    gate_clk_macb312,
    isolate_macb312,
    save_edge_macb312,
    restore_edge_macb312,
    pwr1_on_macb312,
    pwr2_on_macb312,
    // core12 dvfs12 transitions12
    core06v12,
    core08v12,
    core10v12,
    core12v12,
    pcm_macb_wakeup_int12,
    isolate_mem12,
    
    // transit12 signals12
    mte_smc_start12,
    mte_uart_start12,
    mte_smc_uart_start12,  
    mte_pm_smc_to_default_start12, 
    mte_pm_uart_to_default_start12,
    mte_pm_smc_uart_to_default_start12
  );

//------------------------------------------------------------------------------
// I12/O12 declaration12
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks12 & Reset12
   //------------------------------------
   input             pclk12;
   input             nprst12;
   //------------------------------------
   // APB12 programming12 interface;
   //------------------------------------
   input  [31:0]     paddr12;
   input             psel12;
   input             penable12;
   input             pwrite12;
   input  [31:0]     pwdata12;
   output [31:0]     prdata12;
    // mac12
   input macb3_wakeup12;
   input macb2_wakeup12;
   input macb1_wakeup12;
   input macb0_wakeup12;
   //------------------------------------
   // Scan12
   //------------------------------------
   input             scan_in12;
   input             scan_en12;
   input             scan_mode12;
   output            scan_out12;
   //------------------------------------
   // Module12 control12 outputs12
   input             int_source_h12;
   //------------------------------------
   // SMC12
   output            rstn_non_srpg_smc12;
   output            gate_clk_smc12;
   output            isolate_smc12;
   output            save_edge_smc12;
   output            restore_edge_smc12;
   output            pwr1_on_smc12;
   output            pwr2_on_smc12;
   // URT12
   output            rstn_non_srpg_urt12;
   output            gate_clk_urt12;
   output            isolate_urt12;
   output            save_edge_urt12;
   output            restore_edge_urt12;
   output            pwr1_on_urt12;
   output            pwr2_on_urt12;
   // ETH012
   output            rstn_non_srpg_macb012;
   output            gate_clk_macb012;
   output            isolate_macb012;
   output            save_edge_macb012;
   output            restore_edge_macb012;
   output            pwr1_on_macb012;
   output            pwr2_on_macb012;
   // ETH112
   output            rstn_non_srpg_macb112;
   output            gate_clk_macb112;
   output            isolate_macb112;
   output            save_edge_macb112;
   output            restore_edge_macb112;
   output            pwr1_on_macb112;
   output            pwr2_on_macb112;
   // ETH212
   output            rstn_non_srpg_macb212;
   output            gate_clk_macb212;
   output            isolate_macb212;
   output            save_edge_macb212;
   output            restore_edge_macb212;
   output            pwr1_on_macb212;
   output            pwr2_on_macb212;
   // ETH312
   output            rstn_non_srpg_macb312;
   output            gate_clk_macb312;
   output            isolate_macb312;
   output            save_edge_macb312;
   output            restore_edge_macb312;
   output            pwr1_on_macb312;
   output            pwr2_on_macb312;

   // dvfs12
   output core06v12;
   output core08v12;
   output core10v12;
   output core12v12;
   output pcm_macb_wakeup_int12 ;
   output isolate_mem12 ;

   //transit12  signals12
   output mte_smc_start12;
   output mte_uart_start12;
   output mte_smc_uart_start12;  
   output mte_pm_smc_to_default_start12; 
   output mte_pm_uart_to_default_start12;
   output mte_pm_smc_uart_to_default_start12;



//##############################################################################
// if the POWER_CTRL12 is NOT12 black12 boxed12 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL12

power_ctrl12 i_power_ctrl12(
    // -- Clocks12 & Reset12
    	.pclk12(pclk12), 			//  : in  std_logic12;
    	.nprst12(nprst12), 		//  : in  std_logic12;
    // -- APB12 programming12 interface
    	.paddr12(paddr12), 			//  : in  std_logic_vector12(31 downto12 0);
    	.psel12(psel12), 			//  : in  std_logic12;
    	.penable12(penable12), 		//  : in  std_logic12;
    	.pwrite12(pwrite12), 		//  : in  std_logic12;
    	.pwdata12(pwdata12), 		//  : in  std_logic_vector12(31 downto12 0);
    	.prdata12(prdata12), 		//  : out std_logic_vector12(31 downto12 0);
        .macb3_wakeup12(macb3_wakeup12),
        .macb2_wakeup12(macb2_wakeup12),
        .macb1_wakeup12(macb1_wakeup12),
        .macb0_wakeup12(macb0_wakeup12),
    // -- Module12 control12 outputs12
    	.scan_in12(),			//  : in  std_logic12;
    	.scan_en12(scan_en12),             	//  : in  std_logic12;
    	.scan_mode12(scan_mode12),          //  : in  std_logic12;
    	.scan_out12(),            	//  : out std_logic12;
    	.int_source_h12(int_source_h12),    //  : out std_logic12;
     	.rstn_non_srpg_smc12(rstn_non_srpg_smc12), 		//   : out std_logic12;
    	.gate_clk_smc12(gate_clk_smc12), 	//  : out std_logic12;
    	.isolate_smc12(isolate_smc12), 	//  : out std_logic12;
    	.save_edge_smc12(save_edge_smc12), 	//  : out std_logic12;
    	.restore_edge_smc12(restore_edge_smc12), 	//  : out std_logic12;
    	.pwr1_on_smc12(pwr1_on_smc12), 	//  : out std_logic12;
    	.pwr2_on_smc12(pwr2_on_smc12), 	//  : out std_logic12
	.pwr1_off_smc12(pwr1_off_smc12), 	//  : out std_logic12;
    	.pwr2_off_smc12(pwr2_off_smc12), 	//  : out std_logic12
     	.rstn_non_srpg_urt12(rstn_non_srpg_urt12), 		//   : out std_logic12;
    	.gate_clk_urt12(gate_clk_urt12), 	//  : out std_logic12;
    	.isolate_urt12(isolate_urt12), 	//  : out std_logic12;
    	.save_edge_urt12(save_edge_urt12), 	//  : out std_logic12;
    	.restore_edge_urt12(restore_edge_urt12), 	//  : out std_logic12;
    	.pwr1_on_urt12(pwr1_on_urt12), 	//  : out std_logic12;
    	.pwr2_on_urt12(pwr2_on_urt12), 	//  : out std_logic12;
    	.pwr1_off_urt12(pwr1_off_urt12),    //  : out std_logic12;
    	.pwr2_off_urt12(pwr2_off_urt12),     //  : out std_logic12
     	.rstn_non_srpg_macb012(rstn_non_srpg_macb012), 		//   : out std_logic12;
    	.gate_clk_macb012(gate_clk_macb012), 	//  : out std_logic12;
    	.isolate_macb012(isolate_macb012), 	//  : out std_logic12;
    	.save_edge_macb012(save_edge_macb012), 	//  : out std_logic12;
    	.restore_edge_macb012(restore_edge_macb012), 	//  : out std_logic12;
    	.pwr1_on_macb012(pwr1_on_macb012), 	//  : out std_logic12;
    	.pwr2_on_macb012(pwr2_on_macb012), 	//  : out std_logic12;
    	.pwr1_off_macb012(pwr1_off_macb012),    //  : out std_logic12;
    	.pwr2_off_macb012(pwr2_off_macb012),     //  : out std_logic12
     	.rstn_non_srpg_macb112(rstn_non_srpg_macb112), 		//   : out std_logic12;
    	.gate_clk_macb112(gate_clk_macb112), 	//  : out std_logic12;
    	.isolate_macb112(isolate_macb112), 	//  : out std_logic12;
    	.save_edge_macb112(save_edge_macb112), 	//  : out std_logic12;
    	.restore_edge_macb112(restore_edge_macb112), 	//  : out std_logic12;
    	.pwr1_on_macb112(pwr1_on_macb112), 	//  : out std_logic12;
    	.pwr2_on_macb112(pwr2_on_macb112), 	//  : out std_logic12;
    	.pwr1_off_macb112(pwr1_off_macb112),    //  : out std_logic12;
    	.pwr2_off_macb112(pwr2_off_macb112),     //  : out std_logic12
     	.rstn_non_srpg_macb212(rstn_non_srpg_macb212), 		//   : out std_logic12;
    	.gate_clk_macb212(gate_clk_macb212), 	//  : out std_logic12;
    	.isolate_macb212(isolate_macb212), 	//  : out std_logic12;
    	.save_edge_macb212(save_edge_macb212), 	//  : out std_logic12;
    	.restore_edge_macb212(restore_edge_macb212), 	//  : out std_logic12;
    	.pwr1_on_macb212(pwr1_on_macb212), 	//  : out std_logic12;
    	.pwr2_on_macb212(pwr2_on_macb212), 	//  : out std_logic12;
    	.pwr1_off_macb212(pwr1_off_macb212),    //  : out std_logic12;
    	.pwr2_off_macb212(pwr2_off_macb212),     //  : out std_logic12
     	.rstn_non_srpg_macb312(rstn_non_srpg_macb312), 		//   : out std_logic12;
    	.gate_clk_macb312(gate_clk_macb312), 	//  : out std_logic12;
    	.isolate_macb312(isolate_macb312), 	//  : out std_logic12;
    	.save_edge_macb312(save_edge_macb312), 	//  : out std_logic12;
    	.restore_edge_macb312(restore_edge_macb312), 	//  : out std_logic12;
    	.pwr1_on_macb312(pwr1_on_macb312), 	//  : out std_logic12;
    	.pwr2_on_macb312(pwr2_on_macb312), 	//  : out std_logic12;
    	.pwr1_off_macb312(pwr1_off_macb312),    //  : out std_logic12;
    	.pwr2_off_macb312(pwr2_off_macb312),     //  : out std_logic12
        .rstn_non_srpg_dma12(rstn_non_srpg_dma12 ) ,
        .gate_clk_dma12(gate_clk_dma12      )      ,
        .isolate_dma12(isolate_dma12       )       ,
        .save_edge_dma12(save_edge_dma12   )   ,
        .restore_edge_dma12(restore_edge_dma12   )   ,
        .pwr1_on_dma12(pwr1_on_dma12       )       ,
        .pwr2_on_dma12(pwr2_on_dma12       )       ,
        .pwr1_off_dma12(pwr1_off_dma12      )      ,
        .pwr2_off_dma12(pwr2_off_dma12      )      ,
        
        .rstn_non_srpg_cpu12(rstn_non_srpg_cpu12 ) ,
        .gate_clk_cpu12(gate_clk_cpu12      )      ,
        .isolate_cpu12(isolate_cpu12       )       ,
        .save_edge_cpu12(save_edge_cpu12   )   ,
        .restore_edge_cpu12(restore_edge_cpu12   )   ,
        .pwr1_on_cpu12(pwr1_on_cpu12       )       ,
        .pwr2_on_cpu12(pwr2_on_cpu12       )       ,
        .pwr1_off_cpu12(pwr1_off_cpu12      )      ,
        .pwr2_off_cpu12(pwr2_off_cpu12      )      ,
        
        .rstn_non_srpg_alut12(rstn_non_srpg_alut12 ) ,
        .gate_clk_alut12(gate_clk_alut12      )      ,
        .isolate_alut12(isolate_alut12       )       ,
        .save_edge_alut12(save_edge_alut12   )   ,
        .restore_edge_alut12(restore_edge_alut12   )   ,
        .pwr1_on_alut12(pwr1_on_alut12       )       ,
        .pwr2_on_alut12(pwr2_on_alut12       )       ,
        .pwr1_off_alut12(pwr1_off_alut12      )      ,
        .pwr2_off_alut12(pwr2_off_alut12      )      ,
        
        .rstn_non_srpg_mem12(rstn_non_srpg_mem12 ) ,
        .gate_clk_mem12(gate_clk_mem12      )      ,
        .isolate_mem12(isolate_mem12       )       ,
        .save_edge_mem12(save_edge_mem12   )   ,
        .restore_edge_mem12(restore_edge_mem12   )   ,
        .pwr1_on_mem12(pwr1_on_mem12       )       ,
        .pwr2_on_mem12(pwr2_on_mem12       )       ,
        .pwr1_off_mem12(pwr1_off_mem12      )      ,
        .pwr2_off_mem12(pwr2_off_mem12      )      ,

    	.core06v12(core06v12),     //  : out std_logic12
    	.core08v12(core08v12),     //  : out std_logic12
    	.core10v12(core10v12),     //  : out std_logic12
    	.core12v12(core12v12),     //  : out std_logic12
        .pcm_macb_wakeup_int12(pcm_macb_wakeup_int12),
        .mte_smc_start12(mte_smc_start12),
        .mte_uart_start12(mte_uart_start12),
        .mte_smc_uart_start12(mte_smc_uart_start12),  
        .mte_pm_smc_to_default_start12(mte_pm_smc_to_default_start12), 
        .mte_pm_uart_to_default_start12(mte_pm_uart_to_default_start12),
        .mte_pm_smc_uart_to_default_start12(mte_pm_smc_uart_to_default_start12)
);


`else 
//##############################################################################
// if the POWER_CTRL12 is black12 boxed12 
//##############################################################################

   //------------------------------------
   // Clocks12 & Reset12
   //------------------------------------
   wire              pclk12;
   wire              nprst12;
   //------------------------------------
   // APB12 programming12 interface;
   //------------------------------------
   wire   [31:0]     paddr12;
   wire              psel12;
   wire              penable12;
   wire              pwrite12;
   wire   [31:0]     pwdata12;
   reg    [31:0]     prdata12;
   //------------------------------------
   // Scan12
   //------------------------------------
   wire              scan_in12;
   wire              scan_en12;
   wire              scan_mode12;
   reg               scan_out12;
   //------------------------------------
   // Module12 control12 outputs12
   //------------------------------------
   // SMC12;
   reg               rstn_non_srpg_smc12;
   reg               gate_clk_smc12;
   reg               isolate_smc12;
   reg               save_edge_smc12;
   reg               restore_edge_smc12;
   reg               pwr1_on_smc12;
   reg               pwr2_on_smc12;
   wire              pwr1_off_smc12;
   wire              pwr2_off_smc12;

   // URT12;
   reg               rstn_non_srpg_urt12;
   reg               gate_clk_urt12;
   reg               isolate_urt12;
   reg               save_edge_urt12;
   reg               restore_edge_urt12;
   reg               pwr1_on_urt12;
   reg               pwr2_on_urt12;
   wire              pwr1_off_urt12;
   wire              pwr2_off_urt12;

   // ETH012
   reg               rstn_non_srpg_macb012;
   reg               gate_clk_macb012;
   reg               isolate_macb012;
   reg               save_edge_macb012;
   reg               restore_edge_macb012;
   reg               pwr1_on_macb012;
   reg               pwr2_on_macb012;
   wire              pwr1_off_macb012;
   wire              pwr2_off_macb012;
   // ETH112
   reg               rstn_non_srpg_macb112;
   reg               gate_clk_macb112;
   reg               isolate_macb112;
   reg               save_edge_macb112;
   reg               restore_edge_macb112;
   reg               pwr1_on_macb112;
   reg               pwr2_on_macb112;
   wire              pwr1_off_macb112;
   wire              pwr2_off_macb112;
   // ETH212
   reg               rstn_non_srpg_macb212;
   reg               gate_clk_macb212;
   reg               isolate_macb212;
   reg               save_edge_macb212;
   reg               restore_edge_macb212;
   reg               pwr1_on_macb212;
   reg               pwr2_on_macb212;
   wire              pwr1_off_macb212;
   wire              pwr2_off_macb212;
   // ETH312
   reg               rstn_non_srpg_macb312;
   reg               gate_clk_macb312;
   reg               isolate_macb312;
   reg               save_edge_macb312;
   reg               restore_edge_macb312;
   reg               pwr1_on_macb312;
   reg               pwr2_on_macb312;
   wire              pwr1_off_macb312;
   wire              pwr2_off_macb312;

   wire core06v12;
   wire core08v12;
   wire core10v12;
   wire core12v12;



`endif
//##############################################################################
// black12 boxed12 defines12 
//##############################################################################

endmodule
