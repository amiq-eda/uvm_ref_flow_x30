//File4 name   : power_ctrl_veneer4.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------
module power_ctrl_veneer4 (
    //------------------------------------
    // Clocks4 & Reset4
    //------------------------------------
    pclk4,
    nprst4,
    //------------------------------------
    // APB4 programming4 interface
    //------------------------------------
    paddr4,
    psel4,
    penable4,
    pwrite4,
    pwdata4,
    prdata4,
    // mac4 i/f,
    macb3_wakeup4,
    macb2_wakeup4,
    macb1_wakeup4,
    macb0_wakeup4,
    //------------------------------------
    // Scan4 
    //------------------------------------
    scan_in4,
    scan_en4,
    scan_mode4,
    scan_out4,
    int_source_h4,
    //------------------------------------
    // Module4 control4 outputs4
    //------------------------------------
    // SMC4
    rstn_non_srpg_smc4,
    gate_clk_smc4,
    isolate_smc4,
    save_edge_smc4,
    restore_edge_smc4,
    pwr1_on_smc4,
    pwr2_on_smc4,
    // URT4
    rstn_non_srpg_urt4,
    gate_clk_urt4,
    isolate_urt4,
    save_edge_urt4,
    restore_edge_urt4,
    pwr1_on_urt4,
    pwr2_on_urt4,
    // ETH04
    rstn_non_srpg_macb04,
    gate_clk_macb04,
    isolate_macb04,
    save_edge_macb04,
    restore_edge_macb04,
    pwr1_on_macb04,
    pwr2_on_macb04,
    // ETH14
    rstn_non_srpg_macb14,
    gate_clk_macb14,
    isolate_macb14,
    save_edge_macb14,
    restore_edge_macb14,
    pwr1_on_macb14,
    pwr2_on_macb14,
    // ETH24
    rstn_non_srpg_macb24,
    gate_clk_macb24,
    isolate_macb24,
    save_edge_macb24,
    restore_edge_macb24,
    pwr1_on_macb24,
    pwr2_on_macb24,
    // ETH34
    rstn_non_srpg_macb34,
    gate_clk_macb34,
    isolate_macb34,
    save_edge_macb34,
    restore_edge_macb34,
    pwr1_on_macb34,
    pwr2_on_macb34,
    // core4 dvfs4 transitions4
    core06v4,
    core08v4,
    core10v4,
    core12v4,
    pcm_macb_wakeup_int4,
    isolate_mem4,
    
    // transit4 signals4
    mte_smc_start4,
    mte_uart_start4,
    mte_smc_uart_start4,  
    mte_pm_smc_to_default_start4, 
    mte_pm_uart_to_default_start4,
    mte_pm_smc_uart_to_default_start4
  );

//------------------------------------------------------------------------------
// I4/O4 declaration4
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks4 & Reset4
   //------------------------------------
   input             pclk4;
   input             nprst4;
   //------------------------------------
   // APB4 programming4 interface;
   //------------------------------------
   input  [31:0]     paddr4;
   input             psel4;
   input             penable4;
   input             pwrite4;
   input  [31:0]     pwdata4;
   output [31:0]     prdata4;
    // mac4
   input macb3_wakeup4;
   input macb2_wakeup4;
   input macb1_wakeup4;
   input macb0_wakeup4;
   //------------------------------------
   // Scan4
   //------------------------------------
   input             scan_in4;
   input             scan_en4;
   input             scan_mode4;
   output            scan_out4;
   //------------------------------------
   // Module4 control4 outputs4
   input             int_source_h4;
   //------------------------------------
   // SMC4
   output            rstn_non_srpg_smc4;
   output            gate_clk_smc4;
   output            isolate_smc4;
   output            save_edge_smc4;
   output            restore_edge_smc4;
   output            pwr1_on_smc4;
   output            pwr2_on_smc4;
   // URT4
   output            rstn_non_srpg_urt4;
   output            gate_clk_urt4;
   output            isolate_urt4;
   output            save_edge_urt4;
   output            restore_edge_urt4;
   output            pwr1_on_urt4;
   output            pwr2_on_urt4;
   // ETH04
   output            rstn_non_srpg_macb04;
   output            gate_clk_macb04;
   output            isolate_macb04;
   output            save_edge_macb04;
   output            restore_edge_macb04;
   output            pwr1_on_macb04;
   output            pwr2_on_macb04;
   // ETH14
   output            rstn_non_srpg_macb14;
   output            gate_clk_macb14;
   output            isolate_macb14;
   output            save_edge_macb14;
   output            restore_edge_macb14;
   output            pwr1_on_macb14;
   output            pwr2_on_macb14;
   // ETH24
   output            rstn_non_srpg_macb24;
   output            gate_clk_macb24;
   output            isolate_macb24;
   output            save_edge_macb24;
   output            restore_edge_macb24;
   output            pwr1_on_macb24;
   output            pwr2_on_macb24;
   // ETH34
   output            rstn_non_srpg_macb34;
   output            gate_clk_macb34;
   output            isolate_macb34;
   output            save_edge_macb34;
   output            restore_edge_macb34;
   output            pwr1_on_macb34;
   output            pwr2_on_macb34;

   // dvfs4
   output core06v4;
   output core08v4;
   output core10v4;
   output core12v4;
   output pcm_macb_wakeup_int4 ;
   output isolate_mem4 ;

   //transit4  signals4
   output mte_smc_start4;
   output mte_uart_start4;
   output mte_smc_uart_start4;  
   output mte_pm_smc_to_default_start4; 
   output mte_pm_uart_to_default_start4;
   output mte_pm_smc_uart_to_default_start4;



//##############################################################################
// if the POWER_CTRL4 is NOT4 black4 boxed4 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL4

power_ctrl4 i_power_ctrl4(
    // -- Clocks4 & Reset4
    	.pclk4(pclk4), 			//  : in  std_logic4;
    	.nprst4(nprst4), 		//  : in  std_logic4;
    // -- APB4 programming4 interface
    	.paddr4(paddr4), 			//  : in  std_logic_vector4(31 downto4 0);
    	.psel4(psel4), 			//  : in  std_logic4;
    	.penable4(penable4), 		//  : in  std_logic4;
    	.pwrite4(pwrite4), 		//  : in  std_logic4;
    	.pwdata4(pwdata4), 		//  : in  std_logic_vector4(31 downto4 0);
    	.prdata4(prdata4), 		//  : out std_logic_vector4(31 downto4 0);
        .macb3_wakeup4(macb3_wakeup4),
        .macb2_wakeup4(macb2_wakeup4),
        .macb1_wakeup4(macb1_wakeup4),
        .macb0_wakeup4(macb0_wakeup4),
    // -- Module4 control4 outputs4
    	.scan_in4(),			//  : in  std_logic4;
    	.scan_en4(scan_en4),             	//  : in  std_logic4;
    	.scan_mode4(scan_mode4),          //  : in  std_logic4;
    	.scan_out4(),            	//  : out std_logic4;
    	.int_source_h4(int_source_h4),    //  : out std_logic4;
     	.rstn_non_srpg_smc4(rstn_non_srpg_smc4), 		//   : out std_logic4;
    	.gate_clk_smc4(gate_clk_smc4), 	//  : out std_logic4;
    	.isolate_smc4(isolate_smc4), 	//  : out std_logic4;
    	.save_edge_smc4(save_edge_smc4), 	//  : out std_logic4;
    	.restore_edge_smc4(restore_edge_smc4), 	//  : out std_logic4;
    	.pwr1_on_smc4(pwr1_on_smc4), 	//  : out std_logic4;
    	.pwr2_on_smc4(pwr2_on_smc4), 	//  : out std_logic4
	.pwr1_off_smc4(pwr1_off_smc4), 	//  : out std_logic4;
    	.pwr2_off_smc4(pwr2_off_smc4), 	//  : out std_logic4
     	.rstn_non_srpg_urt4(rstn_non_srpg_urt4), 		//   : out std_logic4;
    	.gate_clk_urt4(gate_clk_urt4), 	//  : out std_logic4;
    	.isolate_urt4(isolate_urt4), 	//  : out std_logic4;
    	.save_edge_urt4(save_edge_urt4), 	//  : out std_logic4;
    	.restore_edge_urt4(restore_edge_urt4), 	//  : out std_logic4;
    	.pwr1_on_urt4(pwr1_on_urt4), 	//  : out std_logic4;
    	.pwr2_on_urt4(pwr2_on_urt4), 	//  : out std_logic4;
    	.pwr1_off_urt4(pwr1_off_urt4),    //  : out std_logic4;
    	.pwr2_off_urt4(pwr2_off_urt4),     //  : out std_logic4
     	.rstn_non_srpg_macb04(rstn_non_srpg_macb04), 		//   : out std_logic4;
    	.gate_clk_macb04(gate_clk_macb04), 	//  : out std_logic4;
    	.isolate_macb04(isolate_macb04), 	//  : out std_logic4;
    	.save_edge_macb04(save_edge_macb04), 	//  : out std_logic4;
    	.restore_edge_macb04(restore_edge_macb04), 	//  : out std_logic4;
    	.pwr1_on_macb04(pwr1_on_macb04), 	//  : out std_logic4;
    	.pwr2_on_macb04(pwr2_on_macb04), 	//  : out std_logic4;
    	.pwr1_off_macb04(pwr1_off_macb04),    //  : out std_logic4;
    	.pwr2_off_macb04(pwr2_off_macb04),     //  : out std_logic4
     	.rstn_non_srpg_macb14(rstn_non_srpg_macb14), 		//   : out std_logic4;
    	.gate_clk_macb14(gate_clk_macb14), 	//  : out std_logic4;
    	.isolate_macb14(isolate_macb14), 	//  : out std_logic4;
    	.save_edge_macb14(save_edge_macb14), 	//  : out std_logic4;
    	.restore_edge_macb14(restore_edge_macb14), 	//  : out std_logic4;
    	.pwr1_on_macb14(pwr1_on_macb14), 	//  : out std_logic4;
    	.pwr2_on_macb14(pwr2_on_macb14), 	//  : out std_logic4;
    	.pwr1_off_macb14(pwr1_off_macb14),    //  : out std_logic4;
    	.pwr2_off_macb14(pwr2_off_macb14),     //  : out std_logic4
     	.rstn_non_srpg_macb24(rstn_non_srpg_macb24), 		//   : out std_logic4;
    	.gate_clk_macb24(gate_clk_macb24), 	//  : out std_logic4;
    	.isolate_macb24(isolate_macb24), 	//  : out std_logic4;
    	.save_edge_macb24(save_edge_macb24), 	//  : out std_logic4;
    	.restore_edge_macb24(restore_edge_macb24), 	//  : out std_logic4;
    	.pwr1_on_macb24(pwr1_on_macb24), 	//  : out std_logic4;
    	.pwr2_on_macb24(pwr2_on_macb24), 	//  : out std_logic4;
    	.pwr1_off_macb24(pwr1_off_macb24),    //  : out std_logic4;
    	.pwr2_off_macb24(pwr2_off_macb24),     //  : out std_logic4
     	.rstn_non_srpg_macb34(rstn_non_srpg_macb34), 		//   : out std_logic4;
    	.gate_clk_macb34(gate_clk_macb34), 	//  : out std_logic4;
    	.isolate_macb34(isolate_macb34), 	//  : out std_logic4;
    	.save_edge_macb34(save_edge_macb34), 	//  : out std_logic4;
    	.restore_edge_macb34(restore_edge_macb34), 	//  : out std_logic4;
    	.pwr1_on_macb34(pwr1_on_macb34), 	//  : out std_logic4;
    	.pwr2_on_macb34(pwr2_on_macb34), 	//  : out std_logic4;
    	.pwr1_off_macb34(pwr1_off_macb34),    //  : out std_logic4;
    	.pwr2_off_macb34(pwr2_off_macb34),     //  : out std_logic4
        .rstn_non_srpg_dma4(rstn_non_srpg_dma4 ) ,
        .gate_clk_dma4(gate_clk_dma4      )      ,
        .isolate_dma4(isolate_dma4       )       ,
        .save_edge_dma4(save_edge_dma4   )   ,
        .restore_edge_dma4(restore_edge_dma4   )   ,
        .pwr1_on_dma4(pwr1_on_dma4       )       ,
        .pwr2_on_dma4(pwr2_on_dma4       )       ,
        .pwr1_off_dma4(pwr1_off_dma4      )      ,
        .pwr2_off_dma4(pwr2_off_dma4      )      ,
        
        .rstn_non_srpg_cpu4(rstn_non_srpg_cpu4 ) ,
        .gate_clk_cpu4(gate_clk_cpu4      )      ,
        .isolate_cpu4(isolate_cpu4       )       ,
        .save_edge_cpu4(save_edge_cpu4   )   ,
        .restore_edge_cpu4(restore_edge_cpu4   )   ,
        .pwr1_on_cpu4(pwr1_on_cpu4       )       ,
        .pwr2_on_cpu4(pwr2_on_cpu4       )       ,
        .pwr1_off_cpu4(pwr1_off_cpu4      )      ,
        .pwr2_off_cpu4(pwr2_off_cpu4      )      ,
        
        .rstn_non_srpg_alut4(rstn_non_srpg_alut4 ) ,
        .gate_clk_alut4(gate_clk_alut4      )      ,
        .isolate_alut4(isolate_alut4       )       ,
        .save_edge_alut4(save_edge_alut4   )   ,
        .restore_edge_alut4(restore_edge_alut4   )   ,
        .pwr1_on_alut4(pwr1_on_alut4       )       ,
        .pwr2_on_alut4(pwr2_on_alut4       )       ,
        .pwr1_off_alut4(pwr1_off_alut4      )      ,
        .pwr2_off_alut4(pwr2_off_alut4      )      ,
        
        .rstn_non_srpg_mem4(rstn_non_srpg_mem4 ) ,
        .gate_clk_mem4(gate_clk_mem4      )      ,
        .isolate_mem4(isolate_mem4       )       ,
        .save_edge_mem4(save_edge_mem4   )   ,
        .restore_edge_mem4(restore_edge_mem4   )   ,
        .pwr1_on_mem4(pwr1_on_mem4       )       ,
        .pwr2_on_mem4(pwr2_on_mem4       )       ,
        .pwr1_off_mem4(pwr1_off_mem4      )      ,
        .pwr2_off_mem4(pwr2_off_mem4      )      ,

    	.core06v4(core06v4),     //  : out std_logic4
    	.core08v4(core08v4),     //  : out std_logic4
    	.core10v4(core10v4),     //  : out std_logic4
    	.core12v4(core12v4),     //  : out std_logic4
        .pcm_macb_wakeup_int4(pcm_macb_wakeup_int4),
        .mte_smc_start4(mte_smc_start4),
        .mte_uart_start4(mte_uart_start4),
        .mte_smc_uart_start4(mte_smc_uart_start4),  
        .mte_pm_smc_to_default_start4(mte_pm_smc_to_default_start4), 
        .mte_pm_uart_to_default_start4(mte_pm_uart_to_default_start4),
        .mte_pm_smc_uart_to_default_start4(mte_pm_smc_uart_to_default_start4)
);


`else 
//##############################################################################
// if the POWER_CTRL4 is black4 boxed4 
//##############################################################################

   //------------------------------------
   // Clocks4 & Reset4
   //------------------------------------
   wire              pclk4;
   wire              nprst4;
   //------------------------------------
   // APB4 programming4 interface;
   //------------------------------------
   wire   [31:0]     paddr4;
   wire              psel4;
   wire              penable4;
   wire              pwrite4;
   wire   [31:0]     pwdata4;
   reg    [31:0]     prdata4;
   //------------------------------------
   // Scan4
   //------------------------------------
   wire              scan_in4;
   wire              scan_en4;
   wire              scan_mode4;
   reg               scan_out4;
   //------------------------------------
   // Module4 control4 outputs4
   //------------------------------------
   // SMC4;
   reg               rstn_non_srpg_smc4;
   reg               gate_clk_smc4;
   reg               isolate_smc4;
   reg               save_edge_smc4;
   reg               restore_edge_smc4;
   reg               pwr1_on_smc4;
   reg               pwr2_on_smc4;
   wire              pwr1_off_smc4;
   wire              pwr2_off_smc4;

   // URT4;
   reg               rstn_non_srpg_urt4;
   reg               gate_clk_urt4;
   reg               isolate_urt4;
   reg               save_edge_urt4;
   reg               restore_edge_urt4;
   reg               pwr1_on_urt4;
   reg               pwr2_on_urt4;
   wire              pwr1_off_urt4;
   wire              pwr2_off_urt4;

   // ETH04
   reg               rstn_non_srpg_macb04;
   reg               gate_clk_macb04;
   reg               isolate_macb04;
   reg               save_edge_macb04;
   reg               restore_edge_macb04;
   reg               pwr1_on_macb04;
   reg               pwr2_on_macb04;
   wire              pwr1_off_macb04;
   wire              pwr2_off_macb04;
   // ETH14
   reg               rstn_non_srpg_macb14;
   reg               gate_clk_macb14;
   reg               isolate_macb14;
   reg               save_edge_macb14;
   reg               restore_edge_macb14;
   reg               pwr1_on_macb14;
   reg               pwr2_on_macb14;
   wire              pwr1_off_macb14;
   wire              pwr2_off_macb14;
   // ETH24
   reg               rstn_non_srpg_macb24;
   reg               gate_clk_macb24;
   reg               isolate_macb24;
   reg               save_edge_macb24;
   reg               restore_edge_macb24;
   reg               pwr1_on_macb24;
   reg               pwr2_on_macb24;
   wire              pwr1_off_macb24;
   wire              pwr2_off_macb24;
   // ETH34
   reg               rstn_non_srpg_macb34;
   reg               gate_clk_macb34;
   reg               isolate_macb34;
   reg               save_edge_macb34;
   reg               restore_edge_macb34;
   reg               pwr1_on_macb34;
   reg               pwr2_on_macb34;
   wire              pwr1_off_macb34;
   wire              pwr2_off_macb34;

   wire core06v4;
   wire core08v4;
   wire core10v4;
   wire core12v4;



`endif
//##############################################################################
// black4 boxed4 defines4 
//##############################################################################

endmodule
