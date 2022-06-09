//File14 name   : power_ctrl_veneer14.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------
module power_ctrl_veneer14 (
    //------------------------------------
    // Clocks14 & Reset14
    //------------------------------------
    pclk14,
    nprst14,
    //------------------------------------
    // APB14 programming14 interface
    //------------------------------------
    paddr14,
    psel14,
    penable14,
    pwrite14,
    pwdata14,
    prdata14,
    // mac14 i/f,
    macb3_wakeup14,
    macb2_wakeup14,
    macb1_wakeup14,
    macb0_wakeup14,
    //------------------------------------
    // Scan14 
    //------------------------------------
    scan_in14,
    scan_en14,
    scan_mode14,
    scan_out14,
    int_source_h14,
    //------------------------------------
    // Module14 control14 outputs14
    //------------------------------------
    // SMC14
    rstn_non_srpg_smc14,
    gate_clk_smc14,
    isolate_smc14,
    save_edge_smc14,
    restore_edge_smc14,
    pwr1_on_smc14,
    pwr2_on_smc14,
    // URT14
    rstn_non_srpg_urt14,
    gate_clk_urt14,
    isolate_urt14,
    save_edge_urt14,
    restore_edge_urt14,
    pwr1_on_urt14,
    pwr2_on_urt14,
    // ETH014
    rstn_non_srpg_macb014,
    gate_clk_macb014,
    isolate_macb014,
    save_edge_macb014,
    restore_edge_macb014,
    pwr1_on_macb014,
    pwr2_on_macb014,
    // ETH114
    rstn_non_srpg_macb114,
    gate_clk_macb114,
    isolate_macb114,
    save_edge_macb114,
    restore_edge_macb114,
    pwr1_on_macb114,
    pwr2_on_macb114,
    // ETH214
    rstn_non_srpg_macb214,
    gate_clk_macb214,
    isolate_macb214,
    save_edge_macb214,
    restore_edge_macb214,
    pwr1_on_macb214,
    pwr2_on_macb214,
    // ETH314
    rstn_non_srpg_macb314,
    gate_clk_macb314,
    isolate_macb314,
    save_edge_macb314,
    restore_edge_macb314,
    pwr1_on_macb314,
    pwr2_on_macb314,
    // core14 dvfs14 transitions14
    core06v14,
    core08v14,
    core10v14,
    core12v14,
    pcm_macb_wakeup_int14,
    isolate_mem14,
    
    // transit14 signals14
    mte_smc_start14,
    mte_uart_start14,
    mte_smc_uart_start14,  
    mte_pm_smc_to_default_start14, 
    mte_pm_uart_to_default_start14,
    mte_pm_smc_uart_to_default_start14
  );

//------------------------------------------------------------------------------
// I14/O14 declaration14
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks14 & Reset14
   //------------------------------------
   input             pclk14;
   input             nprst14;
   //------------------------------------
   // APB14 programming14 interface;
   //------------------------------------
   input  [31:0]     paddr14;
   input             psel14;
   input             penable14;
   input             pwrite14;
   input  [31:0]     pwdata14;
   output [31:0]     prdata14;
    // mac14
   input macb3_wakeup14;
   input macb2_wakeup14;
   input macb1_wakeup14;
   input macb0_wakeup14;
   //------------------------------------
   // Scan14
   //------------------------------------
   input             scan_in14;
   input             scan_en14;
   input             scan_mode14;
   output            scan_out14;
   //------------------------------------
   // Module14 control14 outputs14
   input             int_source_h14;
   //------------------------------------
   // SMC14
   output            rstn_non_srpg_smc14;
   output            gate_clk_smc14;
   output            isolate_smc14;
   output            save_edge_smc14;
   output            restore_edge_smc14;
   output            pwr1_on_smc14;
   output            pwr2_on_smc14;
   // URT14
   output            rstn_non_srpg_urt14;
   output            gate_clk_urt14;
   output            isolate_urt14;
   output            save_edge_urt14;
   output            restore_edge_urt14;
   output            pwr1_on_urt14;
   output            pwr2_on_urt14;
   // ETH014
   output            rstn_non_srpg_macb014;
   output            gate_clk_macb014;
   output            isolate_macb014;
   output            save_edge_macb014;
   output            restore_edge_macb014;
   output            pwr1_on_macb014;
   output            pwr2_on_macb014;
   // ETH114
   output            rstn_non_srpg_macb114;
   output            gate_clk_macb114;
   output            isolate_macb114;
   output            save_edge_macb114;
   output            restore_edge_macb114;
   output            pwr1_on_macb114;
   output            pwr2_on_macb114;
   // ETH214
   output            rstn_non_srpg_macb214;
   output            gate_clk_macb214;
   output            isolate_macb214;
   output            save_edge_macb214;
   output            restore_edge_macb214;
   output            pwr1_on_macb214;
   output            pwr2_on_macb214;
   // ETH314
   output            rstn_non_srpg_macb314;
   output            gate_clk_macb314;
   output            isolate_macb314;
   output            save_edge_macb314;
   output            restore_edge_macb314;
   output            pwr1_on_macb314;
   output            pwr2_on_macb314;

   // dvfs14
   output core06v14;
   output core08v14;
   output core10v14;
   output core12v14;
   output pcm_macb_wakeup_int14 ;
   output isolate_mem14 ;

   //transit14  signals14
   output mte_smc_start14;
   output mte_uart_start14;
   output mte_smc_uart_start14;  
   output mte_pm_smc_to_default_start14; 
   output mte_pm_uart_to_default_start14;
   output mte_pm_smc_uart_to_default_start14;



//##############################################################################
// if the POWER_CTRL14 is NOT14 black14 boxed14 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL14

power_ctrl14 i_power_ctrl14(
    // -- Clocks14 & Reset14
    	.pclk14(pclk14), 			//  : in  std_logic14;
    	.nprst14(nprst14), 		//  : in  std_logic14;
    // -- APB14 programming14 interface
    	.paddr14(paddr14), 			//  : in  std_logic_vector14(31 downto14 0);
    	.psel14(psel14), 			//  : in  std_logic14;
    	.penable14(penable14), 		//  : in  std_logic14;
    	.pwrite14(pwrite14), 		//  : in  std_logic14;
    	.pwdata14(pwdata14), 		//  : in  std_logic_vector14(31 downto14 0);
    	.prdata14(prdata14), 		//  : out std_logic_vector14(31 downto14 0);
        .macb3_wakeup14(macb3_wakeup14),
        .macb2_wakeup14(macb2_wakeup14),
        .macb1_wakeup14(macb1_wakeup14),
        .macb0_wakeup14(macb0_wakeup14),
    // -- Module14 control14 outputs14
    	.scan_in14(),			//  : in  std_logic14;
    	.scan_en14(scan_en14),             	//  : in  std_logic14;
    	.scan_mode14(scan_mode14),          //  : in  std_logic14;
    	.scan_out14(),            	//  : out std_logic14;
    	.int_source_h14(int_source_h14),    //  : out std_logic14;
     	.rstn_non_srpg_smc14(rstn_non_srpg_smc14), 		//   : out std_logic14;
    	.gate_clk_smc14(gate_clk_smc14), 	//  : out std_logic14;
    	.isolate_smc14(isolate_smc14), 	//  : out std_logic14;
    	.save_edge_smc14(save_edge_smc14), 	//  : out std_logic14;
    	.restore_edge_smc14(restore_edge_smc14), 	//  : out std_logic14;
    	.pwr1_on_smc14(pwr1_on_smc14), 	//  : out std_logic14;
    	.pwr2_on_smc14(pwr2_on_smc14), 	//  : out std_logic14
	.pwr1_off_smc14(pwr1_off_smc14), 	//  : out std_logic14;
    	.pwr2_off_smc14(pwr2_off_smc14), 	//  : out std_logic14
     	.rstn_non_srpg_urt14(rstn_non_srpg_urt14), 		//   : out std_logic14;
    	.gate_clk_urt14(gate_clk_urt14), 	//  : out std_logic14;
    	.isolate_urt14(isolate_urt14), 	//  : out std_logic14;
    	.save_edge_urt14(save_edge_urt14), 	//  : out std_logic14;
    	.restore_edge_urt14(restore_edge_urt14), 	//  : out std_logic14;
    	.pwr1_on_urt14(pwr1_on_urt14), 	//  : out std_logic14;
    	.pwr2_on_urt14(pwr2_on_urt14), 	//  : out std_logic14;
    	.pwr1_off_urt14(pwr1_off_urt14),    //  : out std_logic14;
    	.pwr2_off_urt14(pwr2_off_urt14),     //  : out std_logic14
     	.rstn_non_srpg_macb014(rstn_non_srpg_macb014), 		//   : out std_logic14;
    	.gate_clk_macb014(gate_clk_macb014), 	//  : out std_logic14;
    	.isolate_macb014(isolate_macb014), 	//  : out std_logic14;
    	.save_edge_macb014(save_edge_macb014), 	//  : out std_logic14;
    	.restore_edge_macb014(restore_edge_macb014), 	//  : out std_logic14;
    	.pwr1_on_macb014(pwr1_on_macb014), 	//  : out std_logic14;
    	.pwr2_on_macb014(pwr2_on_macb014), 	//  : out std_logic14;
    	.pwr1_off_macb014(pwr1_off_macb014),    //  : out std_logic14;
    	.pwr2_off_macb014(pwr2_off_macb014),     //  : out std_logic14
     	.rstn_non_srpg_macb114(rstn_non_srpg_macb114), 		//   : out std_logic14;
    	.gate_clk_macb114(gate_clk_macb114), 	//  : out std_logic14;
    	.isolate_macb114(isolate_macb114), 	//  : out std_logic14;
    	.save_edge_macb114(save_edge_macb114), 	//  : out std_logic14;
    	.restore_edge_macb114(restore_edge_macb114), 	//  : out std_logic14;
    	.pwr1_on_macb114(pwr1_on_macb114), 	//  : out std_logic14;
    	.pwr2_on_macb114(pwr2_on_macb114), 	//  : out std_logic14;
    	.pwr1_off_macb114(pwr1_off_macb114),    //  : out std_logic14;
    	.pwr2_off_macb114(pwr2_off_macb114),     //  : out std_logic14
     	.rstn_non_srpg_macb214(rstn_non_srpg_macb214), 		//   : out std_logic14;
    	.gate_clk_macb214(gate_clk_macb214), 	//  : out std_logic14;
    	.isolate_macb214(isolate_macb214), 	//  : out std_logic14;
    	.save_edge_macb214(save_edge_macb214), 	//  : out std_logic14;
    	.restore_edge_macb214(restore_edge_macb214), 	//  : out std_logic14;
    	.pwr1_on_macb214(pwr1_on_macb214), 	//  : out std_logic14;
    	.pwr2_on_macb214(pwr2_on_macb214), 	//  : out std_logic14;
    	.pwr1_off_macb214(pwr1_off_macb214),    //  : out std_logic14;
    	.pwr2_off_macb214(pwr2_off_macb214),     //  : out std_logic14
     	.rstn_non_srpg_macb314(rstn_non_srpg_macb314), 		//   : out std_logic14;
    	.gate_clk_macb314(gate_clk_macb314), 	//  : out std_logic14;
    	.isolate_macb314(isolate_macb314), 	//  : out std_logic14;
    	.save_edge_macb314(save_edge_macb314), 	//  : out std_logic14;
    	.restore_edge_macb314(restore_edge_macb314), 	//  : out std_logic14;
    	.pwr1_on_macb314(pwr1_on_macb314), 	//  : out std_logic14;
    	.pwr2_on_macb314(pwr2_on_macb314), 	//  : out std_logic14;
    	.pwr1_off_macb314(pwr1_off_macb314),    //  : out std_logic14;
    	.pwr2_off_macb314(pwr2_off_macb314),     //  : out std_logic14
        .rstn_non_srpg_dma14(rstn_non_srpg_dma14 ) ,
        .gate_clk_dma14(gate_clk_dma14      )      ,
        .isolate_dma14(isolate_dma14       )       ,
        .save_edge_dma14(save_edge_dma14   )   ,
        .restore_edge_dma14(restore_edge_dma14   )   ,
        .pwr1_on_dma14(pwr1_on_dma14       )       ,
        .pwr2_on_dma14(pwr2_on_dma14       )       ,
        .pwr1_off_dma14(pwr1_off_dma14      )      ,
        .pwr2_off_dma14(pwr2_off_dma14      )      ,
        
        .rstn_non_srpg_cpu14(rstn_non_srpg_cpu14 ) ,
        .gate_clk_cpu14(gate_clk_cpu14      )      ,
        .isolate_cpu14(isolate_cpu14       )       ,
        .save_edge_cpu14(save_edge_cpu14   )   ,
        .restore_edge_cpu14(restore_edge_cpu14   )   ,
        .pwr1_on_cpu14(pwr1_on_cpu14       )       ,
        .pwr2_on_cpu14(pwr2_on_cpu14       )       ,
        .pwr1_off_cpu14(pwr1_off_cpu14      )      ,
        .pwr2_off_cpu14(pwr2_off_cpu14      )      ,
        
        .rstn_non_srpg_alut14(rstn_non_srpg_alut14 ) ,
        .gate_clk_alut14(gate_clk_alut14      )      ,
        .isolate_alut14(isolate_alut14       )       ,
        .save_edge_alut14(save_edge_alut14   )   ,
        .restore_edge_alut14(restore_edge_alut14   )   ,
        .pwr1_on_alut14(pwr1_on_alut14       )       ,
        .pwr2_on_alut14(pwr2_on_alut14       )       ,
        .pwr1_off_alut14(pwr1_off_alut14      )      ,
        .pwr2_off_alut14(pwr2_off_alut14      )      ,
        
        .rstn_non_srpg_mem14(rstn_non_srpg_mem14 ) ,
        .gate_clk_mem14(gate_clk_mem14      )      ,
        .isolate_mem14(isolate_mem14       )       ,
        .save_edge_mem14(save_edge_mem14   )   ,
        .restore_edge_mem14(restore_edge_mem14   )   ,
        .pwr1_on_mem14(pwr1_on_mem14       )       ,
        .pwr2_on_mem14(pwr2_on_mem14       )       ,
        .pwr1_off_mem14(pwr1_off_mem14      )      ,
        .pwr2_off_mem14(pwr2_off_mem14      )      ,

    	.core06v14(core06v14),     //  : out std_logic14
    	.core08v14(core08v14),     //  : out std_logic14
    	.core10v14(core10v14),     //  : out std_logic14
    	.core12v14(core12v14),     //  : out std_logic14
        .pcm_macb_wakeup_int14(pcm_macb_wakeup_int14),
        .mte_smc_start14(mte_smc_start14),
        .mte_uart_start14(mte_uart_start14),
        .mte_smc_uart_start14(mte_smc_uart_start14),  
        .mte_pm_smc_to_default_start14(mte_pm_smc_to_default_start14), 
        .mte_pm_uart_to_default_start14(mte_pm_uart_to_default_start14),
        .mte_pm_smc_uart_to_default_start14(mte_pm_smc_uart_to_default_start14)
);


`else 
//##############################################################################
// if the POWER_CTRL14 is black14 boxed14 
//##############################################################################

   //------------------------------------
   // Clocks14 & Reset14
   //------------------------------------
   wire              pclk14;
   wire              nprst14;
   //------------------------------------
   // APB14 programming14 interface;
   //------------------------------------
   wire   [31:0]     paddr14;
   wire              psel14;
   wire              penable14;
   wire              pwrite14;
   wire   [31:0]     pwdata14;
   reg    [31:0]     prdata14;
   //------------------------------------
   // Scan14
   //------------------------------------
   wire              scan_in14;
   wire              scan_en14;
   wire              scan_mode14;
   reg               scan_out14;
   //------------------------------------
   // Module14 control14 outputs14
   //------------------------------------
   // SMC14;
   reg               rstn_non_srpg_smc14;
   reg               gate_clk_smc14;
   reg               isolate_smc14;
   reg               save_edge_smc14;
   reg               restore_edge_smc14;
   reg               pwr1_on_smc14;
   reg               pwr2_on_smc14;
   wire              pwr1_off_smc14;
   wire              pwr2_off_smc14;

   // URT14;
   reg               rstn_non_srpg_urt14;
   reg               gate_clk_urt14;
   reg               isolate_urt14;
   reg               save_edge_urt14;
   reg               restore_edge_urt14;
   reg               pwr1_on_urt14;
   reg               pwr2_on_urt14;
   wire              pwr1_off_urt14;
   wire              pwr2_off_urt14;

   // ETH014
   reg               rstn_non_srpg_macb014;
   reg               gate_clk_macb014;
   reg               isolate_macb014;
   reg               save_edge_macb014;
   reg               restore_edge_macb014;
   reg               pwr1_on_macb014;
   reg               pwr2_on_macb014;
   wire              pwr1_off_macb014;
   wire              pwr2_off_macb014;
   // ETH114
   reg               rstn_non_srpg_macb114;
   reg               gate_clk_macb114;
   reg               isolate_macb114;
   reg               save_edge_macb114;
   reg               restore_edge_macb114;
   reg               pwr1_on_macb114;
   reg               pwr2_on_macb114;
   wire              pwr1_off_macb114;
   wire              pwr2_off_macb114;
   // ETH214
   reg               rstn_non_srpg_macb214;
   reg               gate_clk_macb214;
   reg               isolate_macb214;
   reg               save_edge_macb214;
   reg               restore_edge_macb214;
   reg               pwr1_on_macb214;
   reg               pwr2_on_macb214;
   wire              pwr1_off_macb214;
   wire              pwr2_off_macb214;
   // ETH314
   reg               rstn_non_srpg_macb314;
   reg               gate_clk_macb314;
   reg               isolate_macb314;
   reg               save_edge_macb314;
   reg               restore_edge_macb314;
   reg               pwr1_on_macb314;
   reg               pwr2_on_macb314;
   wire              pwr1_off_macb314;
   wire              pwr2_off_macb314;

   wire core06v14;
   wire core08v14;
   wire core10v14;
   wire core12v14;



`endif
//##############################################################################
// black14 boxed14 defines14 
//##############################################################################

endmodule
