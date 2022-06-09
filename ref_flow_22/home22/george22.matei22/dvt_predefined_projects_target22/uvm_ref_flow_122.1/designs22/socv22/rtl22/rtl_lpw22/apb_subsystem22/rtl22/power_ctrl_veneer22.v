//File22 name   : power_ctrl_veneer22.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------
module power_ctrl_veneer22 (
    //------------------------------------
    // Clocks22 & Reset22
    //------------------------------------
    pclk22,
    nprst22,
    //------------------------------------
    // APB22 programming22 interface
    //------------------------------------
    paddr22,
    psel22,
    penable22,
    pwrite22,
    pwdata22,
    prdata22,
    // mac22 i/f,
    macb3_wakeup22,
    macb2_wakeup22,
    macb1_wakeup22,
    macb0_wakeup22,
    //------------------------------------
    // Scan22 
    //------------------------------------
    scan_in22,
    scan_en22,
    scan_mode22,
    scan_out22,
    int_source_h22,
    //------------------------------------
    // Module22 control22 outputs22
    //------------------------------------
    // SMC22
    rstn_non_srpg_smc22,
    gate_clk_smc22,
    isolate_smc22,
    save_edge_smc22,
    restore_edge_smc22,
    pwr1_on_smc22,
    pwr2_on_smc22,
    // URT22
    rstn_non_srpg_urt22,
    gate_clk_urt22,
    isolate_urt22,
    save_edge_urt22,
    restore_edge_urt22,
    pwr1_on_urt22,
    pwr2_on_urt22,
    // ETH022
    rstn_non_srpg_macb022,
    gate_clk_macb022,
    isolate_macb022,
    save_edge_macb022,
    restore_edge_macb022,
    pwr1_on_macb022,
    pwr2_on_macb022,
    // ETH122
    rstn_non_srpg_macb122,
    gate_clk_macb122,
    isolate_macb122,
    save_edge_macb122,
    restore_edge_macb122,
    pwr1_on_macb122,
    pwr2_on_macb122,
    // ETH222
    rstn_non_srpg_macb222,
    gate_clk_macb222,
    isolate_macb222,
    save_edge_macb222,
    restore_edge_macb222,
    pwr1_on_macb222,
    pwr2_on_macb222,
    // ETH322
    rstn_non_srpg_macb322,
    gate_clk_macb322,
    isolate_macb322,
    save_edge_macb322,
    restore_edge_macb322,
    pwr1_on_macb322,
    pwr2_on_macb322,
    // core22 dvfs22 transitions22
    core06v22,
    core08v22,
    core10v22,
    core12v22,
    pcm_macb_wakeup_int22,
    isolate_mem22,
    
    // transit22 signals22
    mte_smc_start22,
    mte_uart_start22,
    mte_smc_uart_start22,  
    mte_pm_smc_to_default_start22, 
    mte_pm_uart_to_default_start22,
    mte_pm_smc_uart_to_default_start22
  );

//------------------------------------------------------------------------------
// I22/O22 declaration22
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks22 & Reset22
   //------------------------------------
   input             pclk22;
   input             nprst22;
   //------------------------------------
   // APB22 programming22 interface;
   //------------------------------------
   input  [31:0]     paddr22;
   input             psel22;
   input             penable22;
   input             pwrite22;
   input  [31:0]     pwdata22;
   output [31:0]     prdata22;
    // mac22
   input macb3_wakeup22;
   input macb2_wakeup22;
   input macb1_wakeup22;
   input macb0_wakeup22;
   //------------------------------------
   // Scan22
   //------------------------------------
   input             scan_in22;
   input             scan_en22;
   input             scan_mode22;
   output            scan_out22;
   //------------------------------------
   // Module22 control22 outputs22
   input             int_source_h22;
   //------------------------------------
   // SMC22
   output            rstn_non_srpg_smc22;
   output            gate_clk_smc22;
   output            isolate_smc22;
   output            save_edge_smc22;
   output            restore_edge_smc22;
   output            pwr1_on_smc22;
   output            pwr2_on_smc22;
   // URT22
   output            rstn_non_srpg_urt22;
   output            gate_clk_urt22;
   output            isolate_urt22;
   output            save_edge_urt22;
   output            restore_edge_urt22;
   output            pwr1_on_urt22;
   output            pwr2_on_urt22;
   // ETH022
   output            rstn_non_srpg_macb022;
   output            gate_clk_macb022;
   output            isolate_macb022;
   output            save_edge_macb022;
   output            restore_edge_macb022;
   output            pwr1_on_macb022;
   output            pwr2_on_macb022;
   // ETH122
   output            rstn_non_srpg_macb122;
   output            gate_clk_macb122;
   output            isolate_macb122;
   output            save_edge_macb122;
   output            restore_edge_macb122;
   output            pwr1_on_macb122;
   output            pwr2_on_macb122;
   // ETH222
   output            rstn_non_srpg_macb222;
   output            gate_clk_macb222;
   output            isolate_macb222;
   output            save_edge_macb222;
   output            restore_edge_macb222;
   output            pwr1_on_macb222;
   output            pwr2_on_macb222;
   // ETH322
   output            rstn_non_srpg_macb322;
   output            gate_clk_macb322;
   output            isolate_macb322;
   output            save_edge_macb322;
   output            restore_edge_macb322;
   output            pwr1_on_macb322;
   output            pwr2_on_macb322;

   // dvfs22
   output core06v22;
   output core08v22;
   output core10v22;
   output core12v22;
   output pcm_macb_wakeup_int22 ;
   output isolate_mem22 ;

   //transit22  signals22
   output mte_smc_start22;
   output mte_uart_start22;
   output mte_smc_uart_start22;  
   output mte_pm_smc_to_default_start22; 
   output mte_pm_uart_to_default_start22;
   output mte_pm_smc_uart_to_default_start22;



//##############################################################################
// if the POWER_CTRL22 is NOT22 black22 boxed22 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL22

power_ctrl22 i_power_ctrl22(
    // -- Clocks22 & Reset22
    	.pclk22(pclk22), 			//  : in  std_logic22;
    	.nprst22(nprst22), 		//  : in  std_logic22;
    // -- APB22 programming22 interface
    	.paddr22(paddr22), 			//  : in  std_logic_vector22(31 downto22 0);
    	.psel22(psel22), 			//  : in  std_logic22;
    	.penable22(penable22), 		//  : in  std_logic22;
    	.pwrite22(pwrite22), 		//  : in  std_logic22;
    	.pwdata22(pwdata22), 		//  : in  std_logic_vector22(31 downto22 0);
    	.prdata22(prdata22), 		//  : out std_logic_vector22(31 downto22 0);
        .macb3_wakeup22(macb3_wakeup22),
        .macb2_wakeup22(macb2_wakeup22),
        .macb1_wakeup22(macb1_wakeup22),
        .macb0_wakeup22(macb0_wakeup22),
    // -- Module22 control22 outputs22
    	.scan_in22(),			//  : in  std_logic22;
    	.scan_en22(scan_en22),             	//  : in  std_logic22;
    	.scan_mode22(scan_mode22),          //  : in  std_logic22;
    	.scan_out22(),            	//  : out std_logic22;
    	.int_source_h22(int_source_h22),    //  : out std_logic22;
     	.rstn_non_srpg_smc22(rstn_non_srpg_smc22), 		//   : out std_logic22;
    	.gate_clk_smc22(gate_clk_smc22), 	//  : out std_logic22;
    	.isolate_smc22(isolate_smc22), 	//  : out std_logic22;
    	.save_edge_smc22(save_edge_smc22), 	//  : out std_logic22;
    	.restore_edge_smc22(restore_edge_smc22), 	//  : out std_logic22;
    	.pwr1_on_smc22(pwr1_on_smc22), 	//  : out std_logic22;
    	.pwr2_on_smc22(pwr2_on_smc22), 	//  : out std_logic22
	.pwr1_off_smc22(pwr1_off_smc22), 	//  : out std_logic22;
    	.pwr2_off_smc22(pwr2_off_smc22), 	//  : out std_logic22
     	.rstn_non_srpg_urt22(rstn_non_srpg_urt22), 		//   : out std_logic22;
    	.gate_clk_urt22(gate_clk_urt22), 	//  : out std_logic22;
    	.isolate_urt22(isolate_urt22), 	//  : out std_logic22;
    	.save_edge_urt22(save_edge_urt22), 	//  : out std_logic22;
    	.restore_edge_urt22(restore_edge_urt22), 	//  : out std_logic22;
    	.pwr1_on_urt22(pwr1_on_urt22), 	//  : out std_logic22;
    	.pwr2_on_urt22(pwr2_on_urt22), 	//  : out std_logic22;
    	.pwr1_off_urt22(pwr1_off_urt22),    //  : out std_logic22;
    	.pwr2_off_urt22(pwr2_off_urt22),     //  : out std_logic22
     	.rstn_non_srpg_macb022(rstn_non_srpg_macb022), 		//   : out std_logic22;
    	.gate_clk_macb022(gate_clk_macb022), 	//  : out std_logic22;
    	.isolate_macb022(isolate_macb022), 	//  : out std_logic22;
    	.save_edge_macb022(save_edge_macb022), 	//  : out std_logic22;
    	.restore_edge_macb022(restore_edge_macb022), 	//  : out std_logic22;
    	.pwr1_on_macb022(pwr1_on_macb022), 	//  : out std_logic22;
    	.pwr2_on_macb022(pwr2_on_macb022), 	//  : out std_logic22;
    	.pwr1_off_macb022(pwr1_off_macb022),    //  : out std_logic22;
    	.pwr2_off_macb022(pwr2_off_macb022),     //  : out std_logic22
     	.rstn_non_srpg_macb122(rstn_non_srpg_macb122), 		//   : out std_logic22;
    	.gate_clk_macb122(gate_clk_macb122), 	//  : out std_logic22;
    	.isolate_macb122(isolate_macb122), 	//  : out std_logic22;
    	.save_edge_macb122(save_edge_macb122), 	//  : out std_logic22;
    	.restore_edge_macb122(restore_edge_macb122), 	//  : out std_logic22;
    	.pwr1_on_macb122(pwr1_on_macb122), 	//  : out std_logic22;
    	.pwr2_on_macb122(pwr2_on_macb122), 	//  : out std_logic22;
    	.pwr1_off_macb122(pwr1_off_macb122),    //  : out std_logic22;
    	.pwr2_off_macb122(pwr2_off_macb122),     //  : out std_logic22
     	.rstn_non_srpg_macb222(rstn_non_srpg_macb222), 		//   : out std_logic22;
    	.gate_clk_macb222(gate_clk_macb222), 	//  : out std_logic22;
    	.isolate_macb222(isolate_macb222), 	//  : out std_logic22;
    	.save_edge_macb222(save_edge_macb222), 	//  : out std_logic22;
    	.restore_edge_macb222(restore_edge_macb222), 	//  : out std_logic22;
    	.pwr1_on_macb222(pwr1_on_macb222), 	//  : out std_logic22;
    	.pwr2_on_macb222(pwr2_on_macb222), 	//  : out std_logic22;
    	.pwr1_off_macb222(pwr1_off_macb222),    //  : out std_logic22;
    	.pwr2_off_macb222(pwr2_off_macb222),     //  : out std_logic22
     	.rstn_non_srpg_macb322(rstn_non_srpg_macb322), 		//   : out std_logic22;
    	.gate_clk_macb322(gate_clk_macb322), 	//  : out std_logic22;
    	.isolate_macb322(isolate_macb322), 	//  : out std_logic22;
    	.save_edge_macb322(save_edge_macb322), 	//  : out std_logic22;
    	.restore_edge_macb322(restore_edge_macb322), 	//  : out std_logic22;
    	.pwr1_on_macb322(pwr1_on_macb322), 	//  : out std_logic22;
    	.pwr2_on_macb322(pwr2_on_macb322), 	//  : out std_logic22;
    	.pwr1_off_macb322(pwr1_off_macb322),    //  : out std_logic22;
    	.pwr2_off_macb322(pwr2_off_macb322),     //  : out std_logic22
        .rstn_non_srpg_dma22(rstn_non_srpg_dma22 ) ,
        .gate_clk_dma22(gate_clk_dma22      )      ,
        .isolate_dma22(isolate_dma22       )       ,
        .save_edge_dma22(save_edge_dma22   )   ,
        .restore_edge_dma22(restore_edge_dma22   )   ,
        .pwr1_on_dma22(pwr1_on_dma22       )       ,
        .pwr2_on_dma22(pwr2_on_dma22       )       ,
        .pwr1_off_dma22(pwr1_off_dma22      )      ,
        .pwr2_off_dma22(pwr2_off_dma22      )      ,
        
        .rstn_non_srpg_cpu22(rstn_non_srpg_cpu22 ) ,
        .gate_clk_cpu22(gate_clk_cpu22      )      ,
        .isolate_cpu22(isolate_cpu22       )       ,
        .save_edge_cpu22(save_edge_cpu22   )   ,
        .restore_edge_cpu22(restore_edge_cpu22   )   ,
        .pwr1_on_cpu22(pwr1_on_cpu22       )       ,
        .pwr2_on_cpu22(pwr2_on_cpu22       )       ,
        .pwr1_off_cpu22(pwr1_off_cpu22      )      ,
        .pwr2_off_cpu22(pwr2_off_cpu22      )      ,
        
        .rstn_non_srpg_alut22(rstn_non_srpg_alut22 ) ,
        .gate_clk_alut22(gate_clk_alut22      )      ,
        .isolate_alut22(isolate_alut22       )       ,
        .save_edge_alut22(save_edge_alut22   )   ,
        .restore_edge_alut22(restore_edge_alut22   )   ,
        .pwr1_on_alut22(pwr1_on_alut22       )       ,
        .pwr2_on_alut22(pwr2_on_alut22       )       ,
        .pwr1_off_alut22(pwr1_off_alut22      )      ,
        .pwr2_off_alut22(pwr2_off_alut22      )      ,
        
        .rstn_non_srpg_mem22(rstn_non_srpg_mem22 ) ,
        .gate_clk_mem22(gate_clk_mem22      )      ,
        .isolate_mem22(isolate_mem22       )       ,
        .save_edge_mem22(save_edge_mem22   )   ,
        .restore_edge_mem22(restore_edge_mem22   )   ,
        .pwr1_on_mem22(pwr1_on_mem22       )       ,
        .pwr2_on_mem22(pwr2_on_mem22       )       ,
        .pwr1_off_mem22(pwr1_off_mem22      )      ,
        .pwr2_off_mem22(pwr2_off_mem22      )      ,

    	.core06v22(core06v22),     //  : out std_logic22
    	.core08v22(core08v22),     //  : out std_logic22
    	.core10v22(core10v22),     //  : out std_logic22
    	.core12v22(core12v22),     //  : out std_logic22
        .pcm_macb_wakeup_int22(pcm_macb_wakeup_int22),
        .mte_smc_start22(mte_smc_start22),
        .mte_uart_start22(mte_uart_start22),
        .mte_smc_uart_start22(mte_smc_uart_start22),  
        .mte_pm_smc_to_default_start22(mte_pm_smc_to_default_start22), 
        .mte_pm_uart_to_default_start22(mte_pm_uart_to_default_start22),
        .mte_pm_smc_uart_to_default_start22(mte_pm_smc_uart_to_default_start22)
);


`else 
//##############################################################################
// if the POWER_CTRL22 is black22 boxed22 
//##############################################################################

   //------------------------------------
   // Clocks22 & Reset22
   //------------------------------------
   wire              pclk22;
   wire              nprst22;
   //------------------------------------
   // APB22 programming22 interface;
   //------------------------------------
   wire   [31:0]     paddr22;
   wire              psel22;
   wire              penable22;
   wire              pwrite22;
   wire   [31:0]     pwdata22;
   reg    [31:0]     prdata22;
   //------------------------------------
   // Scan22
   //------------------------------------
   wire              scan_in22;
   wire              scan_en22;
   wire              scan_mode22;
   reg               scan_out22;
   //------------------------------------
   // Module22 control22 outputs22
   //------------------------------------
   // SMC22;
   reg               rstn_non_srpg_smc22;
   reg               gate_clk_smc22;
   reg               isolate_smc22;
   reg               save_edge_smc22;
   reg               restore_edge_smc22;
   reg               pwr1_on_smc22;
   reg               pwr2_on_smc22;
   wire              pwr1_off_smc22;
   wire              pwr2_off_smc22;

   // URT22;
   reg               rstn_non_srpg_urt22;
   reg               gate_clk_urt22;
   reg               isolate_urt22;
   reg               save_edge_urt22;
   reg               restore_edge_urt22;
   reg               pwr1_on_urt22;
   reg               pwr2_on_urt22;
   wire              pwr1_off_urt22;
   wire              pwr2_off_urt22;

   // ETH022
   reg               rstn_non_srpg_macb022;
   reg               gate_clk_macb022;
   reg               isolate_macb022;
   reg               save_edge_macb022;
   reg               restore_edge_macb022;
   reg               pwr1_on_macb022;
   reg               pwr2_on_macb022;
   wire              pwr1_off_macb022;
   wire              pwr2_off_macb022;
   // ETH122
   reg               rstn_non_srpg_macb122;
   reg               gate_clk_macb122;
   reg               isolate_macb122;
   reg               save_edge_macb122;
   reg               restore_edge_macb122;
   reg               pwr1_on_macb122;
   reg               pwr2_on_macb122;
   wire              pwr1_off_macb122;
   wire              pwr2_off_macb122;
   // ETH222
   reg               rstn_non_srpg_macb222;
   reg               gate_clk_macb222;
   reg               isolate_macb222;
   reg               save_edge_macb222;
   reg               restore_edge_macb222;
   reg               pwr1_on_macb222;
   reg               pwr2_on_macb222;
   wire              pwr1_off_macb222;
   wire              pwr2_off_macb222;
   // ETH322
   reg               rstn_non_srpg_macb322;
   reg               gate_clk_macb322;
   reg               isolate_macb322;
   reg               save_edge_macb322;
   reg               restore_edge_macb322;
   reg               pwr1_on_macb322;
   reg               pwr2_on_macb322;
   wire              pwr1_off_macb322;
   wire              pwr2_off_macb322;

   wire core06v22;
   wire core08v22;
   wire core10v22;
   wire core12v22;



`endif
//##############################################################################
// black22 boxed22 defines22 
//##############################################################################

endmodule
