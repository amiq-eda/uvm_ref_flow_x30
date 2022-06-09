//File8 name   : power_ctrl_veneer8.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------
module power_ctrl_veneer8 (
    //------------------------------------
    // Clocks8 & Reset8
    //------------------------------------
    pclk8,
    nprst8,
    //------------------------------------
    // APB8 programming8 interface
    //------------------------------------
    paddr8,
    psel8,
    penable8,
    pwrite8,
    pwdata8,
    prdata8,
    // mac8 i/f,
    macb3_wakeup8,
    macb2_wakeup8,
    macb1_wakeup8,
    macb0_wakeup8,
    //------------------------------------
    // Scan8 
    //------------------------------------
    scan_in8,
    scan_en8,
    scan_mode8,
    scan_out8,
    int_source_h8,
    //------------------------------------
    // Module8 control8 outputs8
    //------------------------------------
    // SMC8
    rstn_non_srpg_smc8,
    gate_clk_smc8,
    isolate_smc8,
    save_edge_smc8,
    restore_edge_smc8,
    pwr1_on_smc8,
    pwr2_on_smc8,
    // URT8
    rstn_non_srpg_urt8,
    gate_clk_urt8,
    isolate_urt8,
    save_edge_urt8,
    restore_edge_urt8,
    pwr1_on_urt8,
    pwr2_on_urt8,
    // ETH08
    rstn_non_srpg_macb08,
    gate_clk_macb08,
    isolate_macb08,
    save_edge_macb08,
    restore_edge_macb08,
    pwr1_on_macb08,
    pwr2_on_macb08,
    // ETH18
    rstn_non_srpg_macb18,
    gate_clk_macb18,
    isolate_macb18,
    save_edge_macb18,
    restore_edge_macb18,
    pwr1_on_macb18,
    pwr2_on_macb18,
    // ETH28
    rstn_non_srpg_macb28,
    gate_clk_macb28,
    isolate_macb28,
    save_edge_macb28,
    restore_edge_macb28,
    pwr1_on_macb28,
    pwr2_on_macb28,
    // ETH38
    rstn_non_srpg_macb38,
    gate_clk_macb38,
    isolate_macb38,
    save_edge_macb38,
    restore_edge_macb38,
    pwr1_on_macb38,
    pwr2_on_macb38,
    // core8 dvfs8 transitions8
    core06v8,
    core08v8,
    core10v8,
    core12v8,
    pcm_macb_wakeup_int8,
    isolate_mem8,
    
    // transit8 signals8
    mte_smc_start8,
    mte_uart_start8,
    mte_smc_uart_start8,  
    mte_pm_smc_to_default_start8, 
    mte_pm_uart_to_default_start8,
    mte_pm_smc_uart_to_default_start8
  );

//------------------------------------------------------------------------------
// I8/O8 declaration8
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks8 & Reset8
   //------------------------------------
   input             pclk8;
   input             nprst8;
   //------------------------------------
   // APB8 programming8 interface;
   //------------------------------------
   input  [31:0]     paddr8;
   input             psel8;
   input             penable8;
   input             pwrite8;
   input  [31:0]     pwdata8;
   output [31:0]     prdata8;
    // mac8
   input macb3_wakeup8;
   input macb2_wakeup8;
   input macb1_wakeup8;
   input macb0_wakeup8;
   //------------------------------------
   // Scan8
   //------------------------------------
   input             scan_in8;
   input             scan_en8;
   input             scan_mode8;
   output            scan_out8;
   //------------------------------------
   // Module8 control8 outputs8
   input             int_source_h8;
   //------------------------------------
   // SMC8
   output            rstn_non_srpg_smc8;
   output            gate_clk_smc8;
   output            isolate_smc8;
   output            save_edge_smc8;
   output            restore_edge_smc8;
   output            pwr1_on_smc8;
   output            pwr2_on_smc8;
   // URT8
   output            rstn_non_srpg_urt8;
   output            gate_clk_urt8;
   output            isolate_urt8;
   output            save_edge_urt8;
   output            restore_edge_urt8;
   output            pwr1_on_urt8;
   output            pwr2_on_urt8;
   // ETH08
   output            rstn_non_srpg_macb08;
   output            gate_clk_macb08;
   output            isolate_macb08;
   output            save_edge_macb08;
   output            restore_edge_macb08;
   output            pwr1_on_macb08;
   output            pwr2_on_macb08;
   // ETH18
   output            rstn_non_srpg_macb18;
   output            gate_clk_macb18;
   output            isolate_macb18;
   output            save_edge_macb18;
   output            restore_edge_macb18;
   output            pwr1_on_macb18;
   output            pwr2_on_macb18;
   // ETH28
   output            rstn_non_srpg_macb28;
   output            gate_clk_macb28;
   output            isolate_macb28;
   output            save_edge_macb28;
   output            restore_edge_macb28;
   output            pwr1_on_macb28;
   output            pwr2_on_macb28;
   // ETH38
   output            rstn_non_srpg_macb38;
   output            gate_clk_macb38;
   output            isolate_macb38;
   output            save_edge_macb38;
   output            restore_edge_macb38;
   output            pwr1_on_macb38;
   output            pwr2_on_macb38;

   // dvfs8
   output core06v8;
   output core08v8;
   output core10v8;
   output core12v8;
   output pcm_macb_wakeup_int8 ;
   output isolate_mem8 ;

   //transit8  signals8
   output mte_smc_start8;
   output mte_uart_start8;
   output mte_smc_uart_start8;  
   output mte_pm_smc_to_default_start8; 
   output mte_pm_uart_to_default_start8;
   output mte_pm_smc_uart_to_default_start8;



//##############################################################################
// if the POWER_CTRL8 is NOT8 black8 boxed8 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL8

power_ctrl8 i_power_ctrl8(
    // -- Clocks8 & Reset8
    	.pclk8(pclk8), 			//  : in  std_logic8;
    	.nprst8(nprst8), 		//  : in  std_logic8;
    // -- APB8 programming8 interface
    	.paddr8(paddr8), 			//  : in  std_logic_vector8(31 downto8 0);
    	.psel8(psel8), 			//  : in  std_logic8;
    	.penable8(penable8), 		//  : in  std_logic8;
    	.pwrite8(pwrite8), 		//  : in  std_logic8;
    	.pwdata8(pwdata8), 		//  : in  std_logic_vector8(31 downto8 0);
    	.prdata8(prdata8), 		//  : out std_logic_vector8(31 downto8 0);
        .macb3_wakeup8(macb3_wakeup8),
        .macb2_wakeup8(macb2_wakeup8),
        .macb1_wakeup8(macb1_wakeup8),
        .macb0_wakeup8(macb0_wakeup8),
    // -- Module8 control8 outputs8
    	.scan_in8(),			//  : in  std_logic8;
    	.scan_en8(scan_en8),             	//  : in  std_logic8;
    	.scan_mode8(scan_mode8),          //  : in  std_logic8;
    	.scan_out8(),            	//  : out std_logic8;
    	.int_source_h8(int_source_h8),    //  : out std_logic8;
     	.rstn_non_srpg_smc8(rstn_non_srpg_smc8), 		//   : out std_logic8;
    	.gate_clk_smc8(gate_clk_smc8), 	//  : out std_logic8;
    	.isolate_smc8(isolate_smc8), 	//  : out std_logic8;
    	.save_edge_smc8(save_edge_smc8), 	//  : out std_logic8;
    	.restore_edge_smc8(restore_edge_smc8), 	//  : out std_logic8;
    	.pwr1_on_smc8(pwr1_on_smc8), 	//  : out std_logic8;
    	.pwr2_on_smc8(pwr2_on_smc8), 	//  : out std_logic8
	.pwr1_off_smc8(pwr1_off_smc8), 	//  : out std_logic8;
    	.pwr2_off_smc8(pwr2_off_smc8), 	//  : out std_logic8
     	.rstn_non_srpg_urt8(rstn_non_srpg_urt8), 		//   : out std_logic8;
    	.gate_clk_urt8(gate_clk_urt8), 	//  : out std_logic8;
    	.isolate_urt8(isolate_urt8), 	//  : out std_logic8;
    	.save_edge_urt8(save_edge_urt8), 	//  : out std_logic8;
    	.restore_edge_urt8(restore_edge_urt8), 	//  : out std_logic8;
    	.pwr1_on_urt8(pwr1_on_urt8), 	//  : out std_logic8;
    	.pwr2_on_urt8(pwr2_on_urt8), 	//  : out std_logic8;
    	.pwr1_off_urt8(pwr1_off_urt8),    //  : out std_logic8;
    	.pwr2_off_urt8(pwr2_off_urt8),     //  : out std_logic8
     	.rstn_non_srpg_macb08(rstn_non_srpg_macb08), 		//   : out std_logic8;
    	.gate_clk_macb08(gate_clk_macb08), 	//  : out std_logic8;
    	.isolate_macb08(isolate_macb08), 	//  : out std_logic8;
    	.save_edge_macb08(save_edge_macb08), 	//  : out std_logic8;
    	.restore_edge_macb08(restore_edge_macb08), 	//  : out std_logic8;
    	.pwr1_on_macb08(pwr1_on_macb08), 	//  : out std_logic8;
    	.pwr2_on_macb08(pwr2_on_macb08), 	//  : out std_logic8;
    	.pwr1_off_macb08(pwr1_off_macb08),    //  : out std_logic8;
    	.pwr2_off_macb08(pwr2_off_macb08),     //  : out std_logic8
     	.rstn_non_srpg_macb18(rstn_non_srpg_macb18), 		//   : out std_logic8;
    	.gate_clk_macb18(gate_clk_macb18), 	//  : out std_logic8;
    	.isolate_macb18(isolate_macb18), 	//  : out std_logic8;
    	.save_edge_macb18(save_edge_macb18), 	//  : out std_logic8;
    	.restore_edge_macb18(restore_edge_macb18), 	//  : out std_logic8;
    	.pwr1_on_macb18(pwr1_on_macb18), 	//  : out std_logic8;
    	.pwr2_on_macb18(pwr2_on_macb18), 	//  : out std_logic8;
    	.pwr1_off_macb18(pwr1_off_macb18),    //  : out std_logic8;
    	.pwr2_off_macb18(pwr2_off_macb18),     //  : out std_logic8
     	.rstn_non_srpg_macb28(rstn_non_srpg_macb28), 		//   : out std_logic8;
    	.gate_clk_macb28(gate_clk_macb28), 	//  : out std_logic8;
    	.isolate_macb28(isolate_macb28), 	//  : out std_logic8;
    	.save_edge_macb28(save_edge_macb28), 	//  : out std_logic8;
    	.restore_edge_macb28(restore_edge_macb28), 	//  : out std_logic8;
    	.pwr1_on_macb28(pwr1_on_macb28), 	//  : out std_logic8;
    	.pwr2_on_macb28(pwr2_on_macb28), 	//  : out std_logic8;
    	.pwr1_off_macb28(pwr1_off_macb28),    //  : out std_logic8;
    	.pwr2_off_macb28(pwr2_off_macb28),     //  : out std_logic8
     	.rstn_non_srpg_macb38(rstn_non_srpg_macb38), 		//   : out std_logic8;
    	.gate_clk_macb38(gate_clk_macb38), 	//  : out std_logic8;
    	.isolate_macb38(isolate_macb38), 	//  : out std_logic8;
    	.save_edge_macb38(save_edge_macb38), 	//  : out std_logic8;
    	.restore_edge_macb38(restore_edge_macb38), 	//  : out std_logic8;
    	.pwr1_on_macb38(pwr1_on_macb38), 	//  : out std_logic8;
    	.pwr2_on_macb38(pwr2_on_macb38), 	//  : out std_logic8;
    	.pwr1_off_macb38(pwr1_off_macb38),    //  : out std_logic8;
    	.pwr2_off_macb38(pwr2_off_macb38),     //  : out std_logic8
        .rstn_non_srpg_dma8(rstn_non_srpg_dma8 ) ,
        .gate_clk_dma8(gate_clk_dma8      )      ,
        .isolate_dma8(isolate_dma8       )       ,
        .save_edge_dma8(save_edge_dma8   )   ,
        .restore_edge_dma8(restore_edge_dma8   )   ,
        .pwr1_on_dma8(pwr1_on_dma8       )       ,
        .pwr2_on_dma8(pwr2_on_dma8       )       ,
        .pwr1_off_dma8(pwr1_off_dma8      )      ,
        .pwr2_off_dma8(pwr2_off_dma8      )      ,
        
        .rstn_non_srpg_cpu8(rstn_non_srpg_cpu8 ) ,
        .gate_clk_cpu8(gate_clk_cpu8      )      ,
        .isolate_cpu8(isolate_cpu8       )       ,
        .save_edge_cpu8(save_edge_cpu8   )   ,
        .restore_edge_cpu8(restore_edge_cpu8   )   ,
        .pwr1_on_cpu8(pwr1_on_cpu8       )       ,
        .pwr2_on_cpu8(pwr2_on_cpu8       )       ,
        .pwr1_off_cpu8(pwr1_off_cpu8      )      ,
        .pwr2_off_cpu8(pwr2_off_cpu8      )      ,
        
        .rstn_non_srpg_alut8(rstn_non_srpg_alut8 ) ,
        .gate_clk_alut8(gate_clk_alut8      )      ,
        .isolate_alut8(isolate_alut8       )       ,
        .save_edge_alut8(save_edge_alut8   )   ,
        .restore_edge_alut8(restore_edge_alut8   )   ,
        .pwr1_on_alut8(pwr1_on_alut8       )       ,
        .pwr2_on_alut8(pwr2_on_alut8       )       ,
        .pwr1_off_alut8(pwr1_off_alut8      )      ,
        .pwr2_off_alut8(pwr2_off_alut8      )      ,
        
        .rstn_non_srpg_mem8(rstn_non_srpg_mem8 ) ,
        .gate_clk_mem8(gate_clk_mem8      )      ,
        .isolate_mem8(isolate_mem8       )       ,
        .save_edge_mem8(save_edge_mem8   )   ,
        .restore_edge_mem8(restore_edge_mem8   )   ,
        .pwr1_on_mem8(pwr1_on_mem8       )       ,
        .pwr2_on_mem8(pwr2_on_mem8       )       ,
        .pwr1_off_mem8(pwr1_off_mem8      )      ,
        .pwr2_off_mem8(pwr2_off_mem8      )      ,

    	.core06v8(core06v8),     //  : out std_logic8
    	.core08v8(core08v8),     //  : out std_logic8
    	.core10v8(core10v8),     //  : out std_logic8
    	.core12v8(core12v8),     //  : out std_logic8
        .pcm_macb_wakeup_int8(pcm_macb_wakeup_int8),
        .mte_smc_start8(mte_smc_start8),
        .mte_uart_start8(mte_uart_start8),
        .mte_smc_uart_start8(mte_smc_uart_start8),  
        .mte_pm_smc_to_default_start8(mte_pm_smc_to_default_start8), 
        .mte_pm_uart_to_default_start8(mte_pm_uart_to_default_start8),
        .mte_pm_smc_uart_to_default_start8(mte_pm_smc_uart_to_default_start8)
);


`else 
//##############################################################################
// if the POWER_CTRL8 is black8 boxed8 
//##############################################################################

   //------------------------------------
   // Clocks8 & Reset8
   //------------------------------------
   wire              pclk8;
   wire              nprst8;
   //------------------------------------
   // APB8 programming8 interface;
   //------------------------------------
   wire   [31:0]     paddr8;
   wire              psel8;
   wire              penable8;
   wire              pwrite8;
   wire   [31:0]     pwdata8;
   reg    [31:0]     prdata8;
   //------------------------------------
   // Scan8
   //------------------------------------
   wire              scan_in8;
   wire              scan_en8;
   wire              scan_mode8;
   reg               scan_out8;
   //------------------------------------
   // Module8 control8 outputs8
   //------------------------------------
   // SMC8;
   reg               rstn_non_srpg_smc8;
   reg               gate_clk_smc8;
   reg               isolate_smc8;
   reg               save_edge_smc8;
   reg               restore_edge_smc8;
   reg               pwr1_on_smc8;
   reg               pwr2_on_smc8;
   wire              pwr1_off_smc8;
   wire              pwr2_off_smc8;

   // URT8;
   reg               rstn_non_srpg_urt8;
   reg               gate_clk_urt8;
   reg               isolate_urt8;
   reg               save_edge_urt8;
   reg               restore_edge_urt8;
   reg               pwr1_on_urt8;
   reg               pwr2_on_urt8;
   wire              pwr1_off_urt8;
   wire              pwr2_off_urt8;

   // ETH08
   reg               rstn_non_srpg_macb08;
   reg               gate_clk_macb08;
   reg               isolate_macb08;
   reg               save_edge_macb08;
   reg               restore_edge_macb08;
   reg               pwr1_on_macb08;
   reg               pwr2_on_macb08;
   wire              pwr1_off_macb08;
   wire              pwr2_off_macb08;
   // ETH18
   reg               rstn_non_srpg_macb18;
   reg               gate_clk_macb18;
   reg               isolate_macb18;
   reg               save_edge_macb18;
   reg               restore_edge_macb18;
   reg               pwr1_on_macb18;
   reg               pwr2_on_macb18;
   wire              pwr1_off_macb18;
   wire              pwr2_off_macb18;
   // ETH28
   reg               rstn_non_srpg_macb28;
   reg               gate_clk_macb28;
   reg               isolate_macb28;
   reg               save_edge_macb28;
   reg               restore_edge_macb28;
   reg               pwr1_on_macb28;
   reg               pwr2_on_macb28;
   wire              pwr1_off_macb28;
   wire              pwr2_off_macb28;
   // ETH38
   reg               rstn_non_srpg_macb38;
   reg               gate_clk_macb38;
   reg               isolate_macb38;
   reg               save_edge_macb38;
   reg               restore_edge_macb38;
   reg               pwr1_on_macb38;
   reg               pwr2_on_macb38;
   wire              pwr1_off_macb38;
   wire              pwr2_off_macb38;

   wire core06v8;
   wire core08v8;
   wire core10v8;
   wire core12v8;



`endif
//##############################################################################
// black8 boxed8 defines8 
//##############################################################################

endmodule
