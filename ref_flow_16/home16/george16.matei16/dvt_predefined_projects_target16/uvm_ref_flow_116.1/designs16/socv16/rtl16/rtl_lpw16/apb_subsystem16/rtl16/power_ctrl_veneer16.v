//File16 name   : power_ctrl_veneer16.v
//Title16       : 
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------
module power_ctrl_veneer16 (
    //------------------------------------
    // Clocks16 & Reset16
    //------------------------------------
    pclk16,
    nprst16,
    //------------------------------------
    // APB16 programming16 interface
    //------------------------------------
    paddr16,
    psel16,
    penable16,
    pwrite16,
    pwdata16,
    prdata16,
    // mac16 i/f,
    macb3_wakeup16,
    macb2_wakeup16,
    macb1_wakeup16,
    macb0_wakeup16,
    //------------------------------------
    // Scan16 
    //------------------------------------
    scan_in16,
    scan_en16,
    scan_mode16,
    scan_out16,
    int_source_h16,
    //------------------------------------
    // Module16 control16 outputs16
    //------------------------------------
    // SMC16
    rstn_non_srpg_smc16,
    gate_clk_smc16,
    isolate_smc16,
    save_edge_smc16,
    restore_edge_smc16,
    pwr1_on_smc16,
    pwr2_on_smc16,
    // URT16
    rstn_non_srpg_urt16,
    gate_clk_urt16,
    isolate_urt16,
    save_edge_urt16,
    restore_edge_urt16,
    pwr1_on_urt16,
    pwr2_on_urt16,
    // ETH016
    rstn_non_srpg_macb016,
    gate_clk_macb016,
    isolate_macb016,
    save_edge_macb016,
    restore_edge_macb016,
    pwr1_on_macb016,
    pwr2_on_macb016,
    // ETH116
    rstn_non_srpg_macb116,
    gate_clk_macb116,
    isolate_macb116,
    save_edge_macb116,
    restore_edge_macb116,
    pwr1_on_macb116,
    pwr2_on_macb116,
    // ETH216
    rstn_non_srpg_macb216,
    gate_clk_macb216,
    isolate_macb216,
    save_edge_macb216,
    restore_edge_macb216,
    pwr1_on_macb216,
    pwr2_on_macb216,
    // ETH316
    rstn_non_srpg_macb316,
    gate_clk_macb316,
    isolate_macb316,
    save_edge_macb316,
    restore_edge_macb316,
    pwr1_on_macb316,
    pwr2_on_macb316,
    // core16 dvfs16 transitions16
    core06v16,
    core08v16,
    core10v16,
    core12v16,
    pcm_macb_wakeup_int16,
    isolate_mem16,
    
    // transit16 signals16
    mte_smc_start16,
    mte_uart_start16,
    mte_smc_uart_start16,  
    mte_pm_smc_to_default_start16, 
    mte_pm_uart_to_default_start16,
    mte_pm_smc_uart_to_default_start16
  );

//------------------------------------------------------------------------------
// I16/O16 declaration16
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks16 & Reset16
   //------------------------------------
   input             pclk16;
   input             nprst16;
   //------------------------------------
   // APB16 programming16 interface;
   //------------------------------------
   input  [31:0]     paddr16;
   input             psel16;
   input             penable16;
   input             pwrite16;
   input  [31:0]     pwdata16;
   output [31:0]     prdata16;
    // mac16
   input macb3_wakeup16;
   input macb2_wakeup16;
   input macb1_wakeup16;
   input macb0_wakeup16;
   //------------------------------------
   // Scan16
   //------------------------------------
   input             scan_in16;
   input             scan_en16;
   input             scan_mode16;
   output            scan_out16;
   //------------------------------------
   // Module16 control16 outputs16
   input             int_source_h16;
   //------------------------------------
   // SMC16
   output            rstn_non_srpg_smc16;
   output            gate_clk_smc16;
   output            isolate_smc16;
   output            save_edge_smc16;
   output            restore_edge_smc16;
   output            pwr1_on_smc16;
   output            pwr2_on_smc16;
   // URT16
   output            rstn_non_srpg_urt16;
   output            gate_clk_urt16;
   output            isolate_urt16;
   output            save_edge_urt16;
   output            restore_edge_urt16;
   output            pwr1_on_urt16;
   output            pwr2_on_urt16;
   // ETH016
   output            rstn_non_srpg_macb016;
   output            gate_clk_macb016;
   output            isolate_macb016;
   output            save_edge_macb016;
   output            restore_edge_macb016;
   output            pwr1_on_macb016;
   output            pwr2_on_macb016;
   // ETH116
   output            rstn_non_srpg_macb116;
   output            gate_clk_macb116;
   output            isolate_macb116;
   output            save_edge_macb116;
   output            restore_edge_macb116;
   output            pwr1_on_macb116;
   output            pwr2_on_macb116;
   // ETH216
   output            rstn_non_srpg_macb216;
   output            gate_clk_macb216;
   output            isolate_macb216;
   output            save_edge_macb216;
   output            restore_edge_macb216;
   output            pwr1_on_macb216;
   output            pwr2_on_macb216;
   // ETH316
   output            rstn_non_srpg_macb316;
   output            gate_clk_macb316;
   output            isolate_macb316;
   output            save_edge_macb316;
   output            restore_edge_macb316;
   output            pwr1_on_macb316;
   output            pwr2_on_macb316;

   // dvfs16
   output core06v16;
   output core08v16;
   output core10v16;
   output core12v16;
   output pcm_macb_wakeup_int16 ;
   output isolate_mem16 ;

   //transit16  signals16
   output mte_smc_start16;
   output mte_uart_start16;
   output mte_smc_uart_start16;  
   output mte_pm_smc_to_default_start16; 
   output mte_pm_uart_to_default_start16;
   output mte_pm_smc_uart_to_default_start16;



//##############################################################################
// if the POWER_CTRL16 is NOT16 black16 boxed16 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL16

power_ctrl16 i_power_ctrl16(
    // -- Clocks16 & Reset16
    	.pclk16(pclk16), 			//  : in  std_logic16;
    	.nprst16(nprst16), 		//  : in  std_logic16;
    // -- APB16 programming16 interface
    	.paddr16(paddr16), 			//  : in  std_logic_vector16(31 downto16 0);
    	.psel16(psel16), 			//  : in  std_logic16;
    	.penable16(penable16), 		//  : in  std_logic16;
    	.pwrite16(pwrite16), 		//  : in  std_logic16;
    	.pwdata16(pwdata16), 		//  : in  std_logic_vector16(31 downto16 0);
    	.prdata16(prdata16), 		//  : out std_logic_vector16(31 downto16 0);
        .macb3_wakeup16(macb3_wakeup16),
        .macb2_wakeup16(macb2_wakeup16),
        .macb1_wakeup16(macb1_wakeup16),
        .macb0_wakeup16(macb0_wakeup16),
    // -- Module16 control16 outputs16
    	.scan_in16(),			//  : in  std_logic16;
    	.scan_en16(scan_en16),             	//  : in  std_logic16;
    	.scan_mode16(scan_mode16),          //  : in  std_logic16;
    	.scan_out16(),            	//  : out std_logic16;
    	.int_source_h16(int_source_h16),    //  : out std_logic16;
     	.rstn_non_srpg_smc16(rstn_non_srpg_smc16), 		//   : out std_logic16;
    	.gate_clk_smc16(gate_clk_smc16), 	//  : out std_logic16;
    	.isolate_smc16(isolate_smc16), 	//  : out std_logic16;
    	.save_edge_smc16(save_edge_smc16), 	//  : out std_logic16;
    	.restore_edge_smc16(restore_edge_smc16), 	//  : out std_logic16;
    	.pwr1_on_smc16(pwr1_on_smc16), 	//  : out std_logic16;
    	.pwr2_on_smc16(pwr2_on_smc16), 	//  : out std_logic16
	.pwr1_off_smc16(pwr1_off_smc16), 	//  : out std_logic16;
    	.pwr2_off_smc16(pwr2_off_smc16), 	//  : out std_logic16
     	.rstn_non_srpg_urt16(rstn_non_srpg_urt16), 		//   : out std_logic16;
    	.gate_clk_urt16(gate_clk_urt16), 	//  : out std_logic16;
    	.isolate_urt16(isolate_urt16), 	//  : out std_logic16;
    	.save_edge_urt16(save_edge_urt16), 	//  : out std_logic16;
    	.restore_edge_urt16(restore_edge_urt16), 	//  : out std_logic16;
    	.pwr1_on_urt16(pwr1_on_urt16), 	//  : out std_logic16;
    	.pwr2_on_urt16(pwr2_on_urt16), 	//  : out std_logic16;
    	.pwr1_off_urt16(pwr1_off_urt16),    //  : out std_logic16;
    	.pwr2_off_urt16(pwr2_off_urt16),     //  : out std_logic16
     	.rstn_non_srpg_macb016(rstn_non_srpg_macb016), 		//   : out std_logic16;
    	.gate_clk_macb016(gate_clk_macb016), 	//  : out std_logic16;
    	.isolate_macb016(isolate_macb016), 	//  : out std_logic16;
    	.save_edge_macb016(save_edge_macb016), 	//  : out std_logic16;
    	.restore_edge_macb016(restore_edge_macb016), 	//  : out std_logic16;
    	.pwr1_on_macb016(pwr1_on_macb016), 	//  : out std_logic16;
    	.pwr2_on_macb016(pwr2_on_macb016), 	//  : out std_logic16;
    	.pwr1_off_macb016(pwr1_off_macb016),    //  : out std_logic16;
    	.pwr2_off_macb016(pwr2_off_macb016),     //  : out std_logic16
     	.rstn_non_srpg_macb116(rstn_non_srpg_macb116), 		//   : out std_logic16;
    	.gate_clk_macb116(gate_clk_macb116), 	//  : out std_logic16;
    	.isolate_macb116(isolate_macb116), 	//  : out std_logic16;
    	.save_edge_macb116(save_edge_macb116), 	//  : out std_logic16;
    	.restore_edge_macb116(restore_edge_macb116), 	//  : out std_logic16;
    	.pwr1_on_macb116(pwr1_on_macb116), 	//  : out std_logic16;
    	.pwr2_on_macb116(pwr2_on_macb116), 	//  : out std_logic16;
    	.pwr1_off_macb116(pwr1_off_macb116),    //  : out std_logic16;
    	.pwr2_off_macb116(pwr2_off_macb116),     //  : out std_logic16
     	.rstn_non_srpg_macb216(rstn_non_srpg_macb216), 		//   : out std_logic16;
    	.gate_clk_macb216(gate_clk_macb216), 	//  : out std_logic16;
    	.isolate_macb216(isolate_macb216), 	//  : out std_logic16;
    	.save_edge_macb216(save_edge_macb216), 	//  : out std_logic16;
    	.restore_edge_macb216(restore_edge_macb216), 	//  : out std_logic16;
    	.pwr1_on_macb216(pwr1_on_macb216), 	//  : out std_logic16;
    	.pwr2_on_macb216(pwr2_on_macb216), 	//  : out std_logic16;
    	.pwr1_off_macb216(pwr1_off_macb216),    //  : out std_logic16;
    	.pwr2_off_macb216(pwr2_off_macb216),     //  : out std_logic16
     	.rstn_non_srpg_macb316(rstn_non_srpg_macb316), 		//   : out std_logic16;
    	.gate_clk_macb316(gate_clk_macb316), 	//  : out std_logic16;
    	.isolate_macb316(isolate_macb316), 	//  : out std_logic16;
    	.save_edge_macb316(save_edge_macb316), 	//  : out std_logic16;
    	.restore_edge_macb316(restore_edge_macb316), 	//  : out std_logic16;
    	.pwr1_on_macb316(pwr1_on_macb316), 	//  : out std_logic16;
    	.pwr2_on_macb316(pwr2_on_macb316), 	//  : out std_logic16;
    	.pwr1_off_macb316(pwr1_off_macb316),    //  : out std_logic16;
    	.pwr2_off_macb316(pwr2_off_macb316),     //  : out std_logic16
        .rstn_non_srpg_dma16(rstn_non_srpg_dma16 ) ,
        .gate_clk_dma16(gate_clk_dma16      )      ,
        .isolate_dma16(isolate_dma16       )       ,
        .save_edge_dma16(save_edge_dma16   )   ,
        .restore_edge_dma16(restore_edge_dma16   )   ,
        .pwr1_on_dma16(pwr1_on_dma16       )       ,
        .pwr2_on_dma16(pwr2_on_dma16       )       ,
        .pwr1_off_dma16(pwr1_off_dma16      )      ,
        .pwr2_off_dma16(pwr2_off_dma16      )      ,
        
        .rstn_non_srpg_cpu16(rstn_non_srpg_cpu16 ) ,
        .gate_clk_cpu16(gate_clk_cpu16      )      ,
        .isolate_cpu16(isolate_cpu16       )       ,
        .save_edge_cpu16(save_edge_cpu16   )   ,
        .restore_edge_cpu16(restore_edge_cpu16   )   ,
        .pwr1_on_cpu16(pwr1_on_cpu16       )       ,
        .pwr2_on_cpu16(pwr2_on_cpu16       )       ,
        .pwr1_off_cpu16(pwr1_off_cpu16      )      ,
        .pwr2_off_cpu16(pwr2_off_cpu16      )      ,
        
        .rstn_non_srpg_alut16(rstn_non_srpg_alut16 ) ,
        .gate_clk_alut16(gate_clk_alut16      )      ,
        .isolate_alut16(isolate_alut16       )       ,
        .save_edge_alut16(save_edge_alut16   )   ,
        .restore_edge_alut16(restore_edge_alut16   )   ,
        .pwr1_on_alut16(pwr1_on_alut16       )       ,
        .pwr2_on_alut16(pwr2_on_alut16       )       ,
        .pwr1_off_alut16(pwr1_off_alut16      )      ,
        .pwr2_off_alut16(pwr2_off_alut16      )      ,
        
        .rstn_non_srpg_mem16(rstn_non_srpg_mem16 ) ,
        .gate_clk_mem16(gate_clk_mem16      )      ,
        .isolate_mem16(isolate_mem16       )       ,
        .save_edge_mem16(save_edge_mem16   )   ,
        .restore_edge_mem16(restore_edge_mem16   )   ,
        .pwr1_on_mem16(pwr1_on_mem16       )       ,
        .pwr2_on_mem16(pwr2_on_mem16       )       ,
        .pwr1_off_mem16(pwr1_off_mem16      )      ,
        .pwr2_off_mem16(pwr2_off_mem16      )      ,

    	.core06v16(core06v16),     //  : out std_logic16
    	.core08v16(core08v16),     //  : out std_logic16
    	.core10v16(core10v16),     //  : out std_logic16
    	.core12v16(core12v16),     //  : out std_logic16
        .pcm_macb_wakeup_int16(pcm_macb_wakeup_int16),
        .mte_smc_start16(mte_smc_start16),
        .mte_uart_start16(mte_uart_start16),
        .mte_smc_uart_start16(mte_smc_uart_start16),  
        .mte_pm_smc_to_default_start16(mte_pm_smc_to_default_start16), 
        .mte_pm_uart_to_default_start16(mte_pm_uart_to_default_start16),
        .mte_pm_smc_uart_to_default_start16(mte_pm_smc_uart_to_default_start16)
);


`else 
//##############################################################################
// if the POWER_CTRL16 is black16 boxed16 
//##############################################################################

   //------------------------------------
   // Clocks16 & Reset16
   //------------------------------------
   wire              pclk16;
   wire              nprst16;
   //------------------------------------
   // APB16 programming16 interface;
   //------------------------------------
   wire   [31:0]     paddr16;
   wire              psel16;
   wire              penable16;
   wire              pwrite16;
   wire   [31:0]     pwdata16;
   reg    [31:0]     prdata16;
   //------------------------------------
   // Scan16
   //------------------------------------
   wire              scan_in16;
   wire              scan_en16;
   wire              scan_mode16;
   reg               scan_out16;
   //------------------------------------
   // Module16 control16 outputs16
   //------------------------------------
   // SMC16;
   reg               rstn_non_srpg_smc16;
   reg               gate_clk_smc16;
   reg               isolate_smc16;
   reg               save_edge_smc16;
   reg               restore_edge_smc16;
   reg               pwr1_on_smc16;
   reg               pwr2_on_smc16;
   wire              pwr1_off_smc16;
   wire              pwr2_off_smc16;

   // URT16;
   reg               rstn_non_srpg_urt16;
   reg               gate_clk_urt16;
   reg               isolate_urt16;
   reg               save_edge_urt16;
   reg               restore_edge_urt16;
   reg               pwr1_on_urt16;
   reg               pwr2_on_urt16;
   wire              pwr1_off_urt16;
   wire              pwr2_off_urt16;

   // ETH016
   reg               rstn_non_srpg_macb016;
   reg               gate_clk_macb016;
   reg               isolate_macb016;
   reg               save_edge_macb016;
   reg               restore_edge_macb016;
   reg               pwr1_on_macb016;
   reg               pwr2_on_macb016;
   wire              pwr1_off_macb016;
   wire              pwr2_off_macb016;
   // ETH116
   reg               rstn_non_srpg_macb116;
   reg               gate_clk_macb116;
   reg               isolate_macb116;
   reg               save_edge_macb116;
   reg               restore_edge_macb116;
   reg               pwr1_on_macb116;
   reg               pwr2_on_macb116;
   wire              pwr1_off_macb116;
   wire              pwr2_off_macb116;
   // ETH216
   reg               rstn_non_srpg_macb216;
   reg               gate_clk_macb216;
   reg               isolate_macb216;
   reg               save_edge_macb216;
   reg               restore_edge_macb216;
   reg               pwr1_on_macb216;
   reg               pwr2_on_macb216;
   wire              pwr1_off_macb216;
   wire              pwr2_off_macb216;
   // ETH316
   reg               rstn_non_srpg_macb316;
   reg               gate_clk_macb316;
   reg               isolate_macb316;
   reg               save_edge_macb316;
   reg               restore_edge_macb316;
   reg               pwr1_on_macb316;
   reg               pwr2_on_macb316;
   wire              pwr1_off_macb316;
   wire              pwr2_off_macb316;

   wire core06v16;
   wire core08v16;
   wire core10v16;
   wire core12v16;



`endif
//##############################################################################
// black16 boxed16 defines16 
//##############################################################################

endmodule
