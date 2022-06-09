//File13 name   : power_ctrl_veneer13.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------
module power_ctrl_veneer13 (
    //------------------------------------
    // Clocks13 & Reset13
    //------------------------------------
    pclk13,
    nprst13,
    //------------------------------------
    // APB13 programming13 interface
    //------------------------------------
    paddr13,
    psel13,
    penable13,
    pwrite13,
    pwdata13,
    prdata13,
    // mac13 i/f,
    macb3_wakeup13,
    macb2_wakeup13,
    macb1_wakeup13,
    macb0_wakeup13,
    //------------------------------------
    // Scan13 
    //------------------------------------
    scan_in13,
    scan_en13,
    scan_mode13,
    scan_out13,
    int_source_h13,
    //------------------------------------
    // Module13 control13 outputs13
    //------------------------------------
    // SMC13
    rstn_non_srpg_smc13,
    gate_clk_smc13,
    isolate_smc13,
    save_edge_smc13,
    restore_edge_smc13,
    pwr1_on_smc13,
    pwr2_on_smc13,
    // URT13
    rstn_non_srpg_urt13,
    gate_clk_urt13,
    isolate_urt13,
    save_edge_urt13,
    restore_edge_urt13,
    pwr1_on_urt13,
    pwr2_on_urt13,
    // ETH013
    rstn_non_srpg_macb013,
    gate_clk_macb013,
    isolate_macb013,
    save_edge_macb013,
    restore_edge_macb013,
    pwr1_on_macb013,
    pwr2_on_macb013,
    // ETH113
    rstn_non_srpg_macb113,
    gate_clk_macb113,
    isolate_macb113,
    save_edge_macb113,
    restore_edge_macb113,
    pwr1_on_macb113,
    pwr2_on_macb113,
    // ETH213
    rstn_non_srpg_macb213,
    gate_clk_macb213,
    isolate_macb213,
    save_edge_macb213,
    restore_edge_macb213,
    pwr1_on_macb213,
    pwr2_on_macb213,
    // ETH313
    rstn_non_srpg_macb313,
    gate_clk_macb313,
    isolate_macb313,
    save_edge_macb313,
    restore_edge_macb313,
    pwr1_on_macb313,
    pwr2_on_macb313,
    // core13 dvfs13 transitions13
    core06v13,
    core08v13,
    core10v13,
    core12v13,
    pcm_macb_wakeup_int13,
    isolate_mem13,
    
    // transit13 signals13
    mte_smc_start13,
    mte_uart_start13,
    mte_smc_uart_start13,  
    mte_pm_smc_to_default_start13, 
    mte_pm_uart_to_default_start13,
    mte_pm_smc_uart_to_default_start13
  );

//------------------------------------------------------------------------------
// I13/O13 declaration13
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks13 & Reset13
   //------------------------------------
   input             pclk13;
   input             nprst13;
   //------------------------------------
   // APB13 programming13 interface;
   //------------------------------------
   input  [31:0]     paddr13;
   input             psel13;
   input             penable13;
   input             pwrite13;
   input  [31:0]     pwdata13;
   output [31:0]     prdata13;
    // mac13
   input macb3_wakeup13;
   input macb2_wakeup13;
   input macb1_wakeup13;
   input macb0_wakeup13;
   //------------------------------------
   // Scan13
   //------------------------------------
   input             scan_in13;
   input             scan_en13;
   input             scan_mode13;
   output            scan_out13;
   //------------------------------------
   // Module13 control13 outputs13
   input             int_source_h13;
   //------------------------------------
   // SMC13
   output            rstn_non_srpg_smc13;
   output            gate_clk_smc13;
   output            isolate_smc13;
   output            save_edge_smc13;
   output            restore_edge_smc13;
   output            pwr1_on_smc13;
   output            pwr2_on_smc13;
   // URT13
   output            rstn_non_srpg_urt13;
   output            gate_clk_urt13;
   output            isolate_urt13;
   output            save_edge_urt13;
   output            restore_edge_urt13;
   output            pwr1_on_urt13;
   output            pwr2_on_urt13;
   // ETH013
   output            rstn_non_srpg_macb013;
   output            gate_clk_macb013;
   output            isolate_macb013;
   output            save_edge_macb013;
   output            restore_edge_macb013;
   output            pwr1_on_macb013;
   output            pwr2_on_macb013;
   // ETH113
   output            rstn_non_srpg_macb113;
   output            gate_clk_macb113;
   output            isolate_macb113;
   output            save_edge_macb113;
   output            restore_edge_macb113;
   output            pwr1_on_macb113;
   output            pwr2_on_macb113;
   // ETH213
   output            rstn_non_srpg_macb213;
   output            gate_clk_macb213;
   output            isolate_macb213;
   output            save_edge_macb213;
   output            restore_edge_macb213;
   output            pwr1_on_macb213;
   output            pwr2_on_macb213;
   // ETH313
   output            rstn_non_srpg_macb313;
   output            gate_clk_macb313;
   output            isolate_macb313;
   output            save_edge_macb313;
   output            restore_edge_macb313;
   output            pwr1_on_macb313;
   output            pwr2_on_macb313;

   // dvfs13
   output core06v13;
   output core08v13;
   output core10v13;
   output core12v13;
   output pcm_macb_wakeup_int13 ;
   output isolate_mem13 ;

   //transit13  signals13
   output mte_smc_start13;
   output mte_uart_start13;
   output mte_smc_uart_start13;  
   output mte_pm_smc_to_default_start13; 
   output mte_pm_uart_to_default_start13;
   output mte_pm_smc_uart_to_default_start13;



//##############################################################################
// if the POWER_CTRL13 is NOT13 black13 boxed13 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL13

power_ctrl13 i_power_ctrl13(
    // -- Clocks13 & Reset13
    	.pclk13(pclk13), 			//  : in  std_logic13;
    	.nprst13(nprst13), 		//  : in  std_logic13;
    // -- APB13 programming13 interface
    	.paddr13(paddr13), 			//  : in  std_logic_vector13(31 downto13 0);
    	.psel13(psel13), 			//  : in  std_logic13;
    	.penable13(penable13), 		//  : in  std_logic13;
    	.pwrite13(pwrite13), 		//  : in  std_logic13;
    	.pwdata13(pwdata13), 		//  : in  std_logic_vector13(31 downto13 0);
    	.prdata13(prdata13), 		//  : out std_logic_vector13(31 downto13 0);
        .macb3_wakeup13(macb3_wakeup13),
        .macb2_wakeup13(macb2_wakeup13),
        .macb1_wakeup13(macb1_wakeup13),
        .macb0_wakeup13(macb0_wakeup13),
    // -- Module13 control13 outputs13
    	.scan_in13(),			//  : in  std_logic13;
    	.scan_en13(scan_en13),             	//  : in  std_logic13;
    	.scan_mode13(scan_mode13),          //  : in  std_logic13;
    	.scan_out13(),            	//  : out std_logic13;
    	.int_source_h13(int_source_h13),    //  : out std_logic13;
     	.rstn_non_srpg_smc13(rstn_non_srpg_smc13), 		//   : out std_logic13;
    	.gate_clk_smc13(gate_clk_smc13), 	//  : out std_logic13;
    	.isolate_smc13(isolate_smc13), 	//  : out std_logic13;
    	.save_edge_smc13(save_edge_smc13), 	//  : out std_logic13;
    	.restore_edge_smc13(restore_edge_smc13), 	//  : out std_logic13;
    	.pwr1_on_smc13(pwr1_on_smc13), 	//  : out std_logic13;
    	.pwr2_on_smc13(pwr2_on_smc13), 	//  : out std_logic13
	.pwr1_off_smc13(pwr1_off_smc13), 	//  : out std_logic13;
    	.pwr2_off_smc13(pwr2_off_smc13), 	//  : out std_logic13
     	.rstn_non_srpg_urt13(rstn_non_srpg_urt13), 		//   : out std_logic13;
    	.gate_clk_urt13(gate_clk_urt13), 	//  : out std_logic13;
    	.isolate_urt13(isolate_urt13), 	//  : out std_logic13;
    	.save_edge_urt13(save_edge_urt13), 	//  : out std_logic13;
    	.restore_edge_urt13(restore_edge_urt13), 	//  : out std_logic13;
    	.pwr1_on_urt13(pwr1_on_urt13), 	//  : out std_logic13;
    	.pwr2_on_urt13(pwr2_on_urt13), 	//  : out std_logic13;
    	.pwr1_off_urt13(pwr1_off_urt13),    //  : out std_logic13;
    	.pwr2_off_urt13(pwr2_off_urt13),     //  : out std_logic13
     	.rstn_non_srpg_macb013(rstn_non_srpg_macb013), 		//   : out std_logic13;
    	.gate_clk_macb013(gate_clk_macb013), 	//  : out std_logic13;
    	.isolate_macb013(isolate_macb013), 	//  : out std_logic13;
    	.save_edge_macb013(save_edge_macb013), 	//  : out std_logic13;
    	.restore_edge_macb013(restore_edge_macb013), 	//  : out std_logic13;
    	.pwr1_on_macb013(pwr1_on_macb013), 	//  : out std_logic13;
    	.pwr2_on_macb013(pwr2_on_macb013), 	//  : out std_logic13;
    	.pwr1_off_macb013(pwr1_off_macb013),    //  : out std_logic13;
    	.pwr2_off_macb013(pwr2_off_macb013),     //  : out std_logic13
     	.rstn_non_srpg_macb113(rstn_non_srpg_macb113), 		//   : out std_logic13;
    	.gate_clk_macb113(gate_clk_macb113), 	//  : out std_logic13;
    	.isolate_macb113(isolate_macb113), 	//  : out std_logic13;
    	.save_edge_macb113(save_edge_macb113), 	//  : out std_logic13;
    	.restore_edge_macb113(restore_edge_macb113), 	//  : out std_logic13;
    	.pwr1_on_macb113(pwr1_on_macb113), 	//  : out std_logic13;
    	.pwr2_on_macb113(pwr2_on_macb113), 	//  : out std_logic13;
    	.pwr1_off_macb113(pwr1_off_macb113),    //  : out std_logic13;
    	.pwr2_off_macb113(pwr2_off_macb113),     //  : out std_logic13
     	.rstn_non_srpg_macb213(rstn_non_srpg_macb213), 		//   : out std_logic13;
    	.gate_clk_macb213(gate_clk_macb213), 	//  : out std_logic13;
    	.isolate_macb213(isolate_macb213), 	//  : out std_logic13;
    	.save_edge_macb213(save_edge_macb213), 	//  : out std_logic13;
    	.restore_edge_macb213(restore_edge_macb213), 	//  : out std_logic13;
    	.pwr1_on_macb213(pwr1_on_macb213), 	//  : out std_logic13;
    	.pwr2_on_macb213(pwr2_on_macb213), 	//  : out std_logic13;
    	.pwr1_off_macb213(pwr1_off_macb213),    //  : out std_logic13;
    	.pwr2_off_macb213(pwr2_off_macb213),     //  : out std_logic13
     	.rstn_non_srpg_macb313(rstn_non_srpg_macb313), 		//   : out std_logic13;
    	.gate_clk_macb313(gate_clk_macb313), 	//  : out std_logic13;
    	.isolate_macb313(isolate_macb313), 	//  : out std_logic13;
    	.save_edge_macb313(save_edge_macb313), 	//  : out std_logic13;
    	.restore_edge_macb313(restore_edge_macb313), 	//  : out std_logic13;
    	.pwr1_on_macb313(pwr1_on_macb313), 	//  : out std_logic13;
    	.pwr2_on_macb313(pwr2_on_macb313), 	//  : out std_logic13;
    	.pwr1_off_macb313(pwr1_off_macb313),    //  : out std_logic13;
    	.pwr2_off_macb313(pwr2_off_macb313),     //  : out std_logic13
        .rstn_non_srpg_dma13(rstn_non_srpg_dma13 ) ,
        .gate_clk_dma13(gate_clk_dma13      )      ,
        .isolate_dma13(isolate_dma13       )       ,
        .save_edge_dma13(save_edge_dma13   )   ,
        .restore_edge_dma13(restore_edge_dma13   )   ,
        .pwr1_on_dma13(pwr1_on_dma13       )       ,
        .pwr2_on_dma13(pwr2_on_dma13       )       ,
        .pwr1_off_dma13(pwr1_off_dma13      )      ,
        .pwr2_off_dma13(pwr2_off_dma13      )      ,
        
        .rstn_non_srpg_cpu13(rstn_non_srpg_cpu13 ) ,
        .gate_clk_cpu13(gate_clk_cpu13      )      ,
        .isolate_cpu13(isolate_cpu13       )       ,
        .save_edge_cpu13(save_edge_cpu13   )   ,
        .restore_edge_cpu13(restore_edge_cpu13   )   ,
        .pwr1_on_cpu13(pwr1_on_cpu13       )       ,
        .pwr2_on_cpu13(pwr2_on_cpu13       )       ,
        .pwr1_off_cpu13(pwr1_off_cpu13      )      ,
        .pwr2_off_cpu13(pwr2_off_cpu13      )      ,
        
        .rstn_non_srpg_alut13(rstn_non_srpg_alut13 ) ,
        .gate_clk_alut13(gate_clk_alut13      )      ,
        .isolate_alut13(isolate_alut13       )       ,
        .save_edge_alut13(save_edge_alut13   )   ,
        .restore_edge_alut13(restore_edge_alut13   )   ,
        .pwr1_on_alut13(pwr1_on_alut13       )       ,
        .pwr2_on_alut13(pwr2_on_alut13       )       ,
        .pwr1_off_alut13(pwr1_off_alut13      )      ,
        .pwr2_off_alut13(pwr2_off_alut13      )      ,
        
        .rstn_non_srpg_mem13(rstn_non_srpg_mem13 ) ,
        .gate_clk_mem13(gate_clk_mem13      )      ,
        .isolate_mem13(isolate_mem13       )       ,
        .save_edge_mem13(save_edge_mem13   )   ,
        .restore_edge_mem13(restore_edge_mem13   )   ,
        .pwr1_on_mem13(pwr1_on_mem13       )       ,
        .pwr2_on_mem13(pwr2_on_mem13       )       ,
        .pwr1_off_mem13(pwr1_off_mem13      )      ,
        .pwr2_off_mem13(pwr2_off_mem13      )      ,

    	.core06v13(core06v13),     //  : out std_logic13
    	.core08v13(core08v13),     //  : out std_logic13
    	.core10v13(core10v13),     //  : out std_logic13
    	.core12v13(core12v13),     //  : out std_logic13
        .pcm_macb_wakeup_int13(pcm_macb_wakeup_int13),
        .mte_smc_start13(mte_smc_start13),
        .mte_uart_start13(mte_uart_start13),
        .mte_smc_uart_start13(mte_smc_uart_start13),  
        .mte_pm_smc_to_default_start13(mte_pm_smc_to_default_start13), 
        .mte_pm_uart_to_default_start13(mte_pm_uart_to_default_start13),
        .mte_pm_smc_uart_to_default_start13(mte_pm_smc_uart_to_default_start13)
);


`else 
//##############################################################################
// if the POWER_CTRL13 is black13 boxed13 
//##############################################################################

   //------------------------------------
   // Clocks13 & Reset13
   //------------------------------------
   wire              pclk13;
   wire              nprst13;
   //------------------------------------
   // APB13 programming13 interface;
   //------------------------------------
   wire   [31:0]     paddr13;
   wire              psel13;
   wire              penable13;
   wire              pwrite13;
   wire   [31:0]     pwdata13;
   reg    [31:0]     prdata13;
   //------------------------------------
   // Scan13
   //------------------------------------
   wire              scan_in13;
   wire              scan_en13;
   wire              scan_mode13;
   reg               scan_out13;
   //------------------------------------
   // Module13 control13 outputs13
   //------------------------------------
   // SMC13;
   reg               rstn_non_srpg_smc13;
   reg               gate_clk_smc13;
   reg               isolate_smc13;
   reg               save_edge_smc13;
   reg               restore_edge_smc13;
   reg               pwr1_on_smc13;
   reg               pwr2_on_smc13;
   wire              pwr1_off_smc13;
   wire              pwr2_off_smc13;

   // URT13;
   reg               rstn_non_srpg_urt13;
   reg               gate_clk_urt13;
   reg               isolate_urt13;
   reg               save_edge_urt13;
   reg               restore_edge_urt13;
   reg               pwr1_on_urt13;
   reg               pwr2_on_urt13;
   wire              pwr1_off_urt13;
   wire              pwr2_off_urt13;

   // ETH013
   reg               rstn_non_srpg_macb013;
   reg               gate_clk_macb013;
   reg               isolate_macb013;
   reg               save_edge_macb013;
   reg               restore_edge_macb013;
   reg               pwr1_on_macb013;
   reg               pwr2_on_macb013;
   wire              pwr1_off_macb013;
   wire              pwr2_off_macb013;
   // ETH113
   reg               rstn_non_srpg_macb113;
   reg               gate_clk_macb113;
   reg               isolate_macb113;
   reg               save_edge_macb113;
   reg               restore_edge_macb113;
   reg               pwr1_on_macb113;
   reg               pwr2_on_macb113;
   wire              pwr1_off_macb113;
   wire              pwr2_off_macb113;
   // ETH213
   reg               rstn_non_srpg_macb213;
   reg               gate_clk_macb213;
   reg               isolate_macb213;
   reg               save_edge_macb213;
   reg               restore_edge_macb213;
   reg               pwr1_on_macb213;
   reg               pwr2_on_macb213;
   wire              pwr1_off_macb213;
   wire              pwr2_off_macb213;
   // ETH313
   reg               rstn_non_srpg_macb313;
   reg               gate_clk_macb313;
   reg               isolate_macb313;
   reg               save_edge_macb313;
   reg               restore_edge_macb313;
   reg               pwr1_on_macb313;
   reg               pwr2_on_macb313;
   wire              pwr1_off_macb313;
   wire              pwr2_off_macb313;

   wire core06v13;
   wire core08v13;
   wire core10v13;
   wire core12v13;



`endif
//##############################################################################
// black13 boxed13 defines13 
//##############################################################################

endmodule
