//File5 name   : power_ctrl_veneer5.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------
module power_ctrl_veneer5 (
    //------------------------------------
    // Clocks5 & Reset5
    //------------------------------------
    pclk5,
    nprst5,
    //------------------------------------
    // APB5 programming5 interface
    //------------------------------------
    paddr5,
    psel5,
    penable5,
    pwrite5,
    pwdata5,
    prdata5,
    // mac5 i/f,
    macb3_wakeup5,
    macb2_wakeup5,
    macb1_wakeup5,
    macb0_wakeup5,
    //------------------------------------
    // Scan5 
    //------------------------------------
    scan_in5,
    scan_en5,
    scan_mode5,
    scan_out5,
    int_source_h5,
    //------------------------------------
    // Module5 control5 outputs5
    //------------------------------------
    // SMC5
    rstn_non_srpg_smc5,
    gate_clk_smc5,
    isolate_smc5,
    save_edge_smc5,
    restore_edge_smc5,
    pwr1_on_smc5,
    pwr2_on_smc5,
    // URT5
    rstn_non_srpg_urt5,
    gate_clk_urt5,
    isolate_urt5,
    save_edge_urt5,
    restore_edge_urt5,
    pwr1_on_urt5,
    pwr2_on_urt5,
    // ETH05
    rstn_non_srpg_macb05,
    gate_clk_macb05,
    isolate_macb05,
    save_edge_macb05,
    restore_edge_macb05,
    pwr1_on_macb05,
    pwr2_on_macb05,
    // ETH15
    rstn_non_srpg_macb15,
    gate_clk_macb15,
    isolate_macb15,
    save_edge_macb15,
    restore_edge_macb15,
    pwr1_on_macb15,
    pwr2_on_macb15,
    // ETH25
    rstn_non_srpg_macb25,
    gate_clk_macb25,
    isolate_macb25,
    save_edge_macb25,
    restore_edge_macb25,
    pwr1_on_macb25,
    pwr2_on_macb25,
    // ETH35
    rstn_non_srpg_macb35,
    gate_clk_macb35,
    isolate_macb35,
    save_edge_macb35,
    restore_edge_macb35,
    pwr1_on_macb35,
    pwr2_on_macb35,
    // core5 dvfs5 transitions5
    core06v5,
    core08v5,
    core10v5,
    core12v5,
    pcm_macb_wakeup_int5,
    isolate_mem5,
    
    // transit5 signals5
    mte_smc_start5,
    mte_uart_start5,
    mte_smc_uart_start5,  
    mte_pm_smc_to_default_start5, 
    mte_pm_uart_to_default_start5,
    mte_pm_smc_uart_to_default_start5
  );

//------------------------------------------------------------------------------
// I5/O5 declaration5
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks5 & Reset5
   //------------------------------------
   input             pclk5;
   input             nprst5;
   //------------------------------------
   // APB5 programming5 interface;
   //------------------------------------
   input  [31:0]     paddr5;
   input             psel5;
   input             penable5;
   input             pwrite5;
   input  [31:0]     pwdata5;
   output [31:0]     prdata5;
    // mac5
   input macb3_wakeup5;
   input macb2_wakeup5;
   input macb1_wakeup5;
   input macb0_wakeup5;
   //------------------------------------
   // Scan5
   //------------------------------------
   input             scan_in5;
   input             scan_en5;
   input             scan_mode5;
   output            scan_out5;
   //------------------------------------
   // Module5 control5 outputs5
   input             int_source_h5;
   //------------------------------------
   // SMC5
   output            rstn_non_srpg_smc5;
   output            gate_clk_smc5;
   output            isolate_smc5;
   output            save_edge_smc5;
   output            restore_edge_smc5;
   output            pwr1_on_smc5;
   output            pwr2_on_smc5;
   // URT5
   output            rstn_non_srpg_urt5;
   output            gate_clk_urt5;
   output            isolate_urt5;
   output            save_edge_urt5;
   output            restore_edge_urt5;
   output            pwr1_on_urt5;
   output            pwr2_on_urt5;
   // ETH05
   output            rstn_non_srpg_macb05;
   output            gate_clk_macb05;
   output            isolate_macb05;
   output            save_edge_macb05;
   output            restore_edge_macb05;
   output            pwr1_on_macb05;
   output            pwr2_on_macb05;
   // ETH15
   output            rstn_non_srpg_macb15;
   output            gate_clk_macb15;
   output            isolate_macb15;
   output            save_edge_macb15;
   output            restore_edge_macb15;
   output            pwr1_on_macb15;
   output            pwr2_on_macb15;
   // ETH25
   output            rstn_non_srpg_macb25;
   output            gate_clk_macb25;
   output            isolate_macb25;
   output            save_edge_macb25;
   output            restore_edge_macb25;
   output            pwr1_on_macb25;
   output            pwr2_on_macb25;
   // ETH35
   output            rstn_non_srpg_macb35;
   output            gate_clk_macb35;
   output            isolate_macb35;
   output            save_edge_macb35;
   output            restore_edge_macb35;
   output            pwr1_on_macb35;
   output            pwr2_on_macb35;

   // dvfs5
   output core06v5;
   output core08v5;
   output core10v5;
   output core12v5;
   output pcm_macb_wakeup_int5 ;
   output isolate_mem5 ;

   //transit5  signals5
   output mte_smc_start5;
   output mte_uart_start5;
   output mte_smc_uart_start5;  
   output mte_pm_smc_to_default_start5; 
   output mte_pm_uart_to_default_start5;
   output mte_pm_smc_uart_to_default_start5;



//##############################################################################
// if the POWER_CTRL5 is NOT5 black5 boxed5 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL5

power_ctrl5 i_power_ctrl5(
    // -- Clocks5 & Reset5
    	.pclk5(pclk5), 			//  : in  std_logic5;
    	.nprst5(nprst5), 		//  : in  std_logic5;
    // -- APB5 programming5 interface
    	.paddr5(paddr5), 			//  : in  std_logic_vector5(31 downto5 0);
    	.psel5(psel5), 			//  : in  std_logic5;
    	.penable5(penable5), 		//  : in  std_logic5;
    	.pwrite5(pwrite5), 		//  : in  std_logic5;
    	.pwdata5(pwdata5), 		//  : in  std_logic_vector5(31 downto5 0);
    	.prdata5(prdata5), 		//  : out std_logic_vector5(31 downto5 0);
        .macb3_wakeup5(macb3_wakeup5),
        .macb2_wakeup5(macb2_wakeup5),
        .macb1_wakeup5(macb1_wakeup5),
        .macb0_wakeup5(macb0_wakeup5),
    // -- Module5 control5 outputs5
    	.scan_in5(),			//  : in  std_logic5;
    	.scan_en5(scan_en5),             	//  : in  std_logic5;
    	.scan_mode5(scan_mode5),          //  : in  std_logic5;
    	.scan_out5(),            	//  : out std_logic5;
    	.int_source_h5(int_source_h5),    //  : out std_logic5;
     	.rstn_non_srpg_smc5(rstn_non_srpg_smc5), 		//   : out std_logic5;
    	.gate_clk_smc5(gate_clk_smc5), 	//  : out std_logic5;
    	.isolate_smc5(isolate_smc5), 	//  : out std_logic5;
    	.save_edge_smc5(save_edge_smc5), 	//  : out std_logic5;
    	.restore_edge_smc5(restore_edge_smc5), 	//  : out std_logic5;
    	.pwr1_on_smc5(pwr1_on_smc5), 	//  : out std_logic5;
    	.pwr2_on_smc5(pwr2_on_smc5), 	//  : out std_logic5
	.pwr1_off_smc5(pwr1_off_smc5), 	//  : out std_logic5;
    	.pwr2_off_smc5(pwr2_off_smc5), 	//  : out std_logic5
     	.rstn_non_srpg_urt5(rstn_non_srpg_urt5), 		//   : out std_logic5;
    	.gate_clk_urt5(gate_clk_urt5), 	//  : out std_logic5;
    	.isolate_urt5(isolate_urt5), 	//  : out std_logic5;
    	.save_edge_urt5(save_edge_urt5), 	//  : out std_logic5;
    	.restore_edge_urt5(restore_edge_urt5), 	//  : out std_logic5;
    	.pwr1_on_urt5(pwr1_on_urt5), 	//  : out std_logic5;
    	.pwr2_on_urt5(pwr2_on_urt5), 	//  : out std_logic5;
    	.pwr1_off_urt5(pwr1_off_urt5),    //  : out std_logic5;
    	.pwr2_off_urt5(pwr2_off_urt5),     //  : out std_logic5
     	.rstn_non_srpg_macb05(rstn_non_srpg_macb05), 		//   : out std_logic5;
    	.gate_clk_macb05(gate_clk_macb05), 	//  : out std_logic5;
    	.isolate_macb05(isolate_macb05), 	//  : out std_logic5;
    	.save_edge_macb05(save_edge_macb05), 	//  : out std_logic5;
    	.restore_edge_macb05(restore_edge_macb05), 	//  : out std_logic5;
    	.pwr1_on_macb05(pwr1_on_macb05), 	//  : out std_logic5;
    	.pwr2_on_macb05(pwr2_on_macb05), 	//  : out std_logic5;
    	.pwr1_off_macb05(pwr1_off_macb05),    //  : out std_logic5;
    	.pwr2_off_macb05(pwr2_off_macb05),     //  : out std_logic5
     	.rstn_non_srpg_macb15(rstn_non_srpg_macb15), 		//   : out std_logic5;
    	.gate_clk_macb15(gate_clk_macb15), 	//  : out std_logic5;
    	.isolate_macb15(isolate_macb15), 	//  : out std_logic5;
    	.save_edge_macb15(save_edge_macb15), 	//  : out std_logic5;
    	.restore_edge_macb15(restore_edge_macb15), 	//  : out std_logic5;
    	.pwr1_on_macb15(pwr1_on_macb15), 	//  : out std_logic5;
    	.pwr2_on_macb15(pwr2_on_macb15), 	//  : out std_logic5;
    	.pwr1_off_macb15(pwr1_off_macb15),    //  : out std_logic5;
    	.pwr2_off_macb15(pwr2_off_macb15),     //  : out std_logic5
     	.rstn_non_srpg_macb25(rstn_non_srpg_macb25), 		//   : out std_logic5;
    	.gate_clk_macb25(gate_clk_macb25), 	//  : out std_logic5;
    	.isolate_macb25(isolate_macb25), 	//  : out std_logic5;
    	.save_edge_macb25(save_edge_macb25), 	//  : out std_logic5;
    	.restore_edge_macb25(restore_edge_macb25), 	//  : out std_logic5;
    	.pwr1_on_macb25(pwr1_on_macb25), 	//  : out std_logic5;
    	.pwr2_on_macb25(pwr2_on_macb25), 	//  : out std_logic5;
    	.pwr1_off_macb25(pwr1_off_macb25),    //  : out std_logic5;
    	.pwr2_off_macb25(pwr2_off_macb25),     //  : out std_logic5
     	.rstn_non_srpg_macb35(rstn_non_srpg_macb35), 		//   : out std_logic5;
    	.gate_clk_macb35(gate_clk_macb35), 	//  : out std_logic5;
    	.isolate_macb35(isolate_macb35), 	//  : out std_logic5;
    	.save_edge_macb35(save_edge_macb35), 	//  : out std_logic5;
    	.restore_edge_macb35(restore_edge_macb35), 	//  : out std_logic5;
    	.pwr1_on_macb35(pwr1_on_macb35), 	//  : out std_logic5;
    	.pwr2_on_macb35(pwr2_on_macb35), 	//  : out std_logic5;
    	.pwr1_off_macb35(pwr1_off_macb35),    //  : out std_logic5;
    	.pwr2_off_macb35(pwr2_off_macb35),     //  : out std_logic5
        .rstn_non_srpg_dma5(rstn_non_srpg_dma5 ) ,
        .gate_clk_dma5(gate_clk_dma5      )      ,
        .isolate_dma5(isolate_dma5       )       ,
        .save_edge_dma5(save_edge_dma5   )   ,
        .restore_edge_dma5(restore_edge_dma5   )   ,
        .pwr1_on_dma5(pwr1_on_dma5       )       ,
        .pwr2_on_dma5(pwr2_on_dma5       )       ,
        .pwr1_off_dma5(pwr1_off_dma5      )      ,
        .pwr2_off_dma5(pwr2_off_dma5      )      ,
        
        .rstn_non_srpg_cpu5(rstn_non_srpg_cpu5 ) ,
        .gate_clk_cpu5(gate_clk_cpu5      )      ,
        .isolate_cpu5(isolate_cpu5       )       ,
        .save_edge_cpu5(save_edge_cpu5   )   ,
        .restore_edge_cpu5(restore_edge_cpu5   )   ,
        .pwr1_on_cpu5(pwr1_on_cpu5       )       ,
        .pwr2_on_cpu5(pwr2_on_cpu5       )       ,
        .pwr1_off_cpu5(pwr1_off_cpu5      )      ,
        .pwr2_off_cpu5(pwr2_off_cpu5      )      ,
        
        .rstn_non_srpg_alut5(rstn_non_srpg_alut5 ) ,
        .gate_clk_alut5(gate_clk_alut5      )      ,
        .isolate_alut5(isolate_alut5       )       ,
        .save_edge_alut5(save_edge_alut5   )   ,
        .restore_edge_alut5(restore_edge_alut5   )   ,
        .pwr1_on_alut5(pwr1_on_alut5       )       ,
        .pwr2_on_alut5(pwr2_on_alut5       )       ,
        .pwr1_off_alut5(pwr1_off_alut5      )      ,
        .pwr2_off_alut5(pwr2_off_alut5      )      ,
        
        .rstn_non_srpg_mem5(rstn_non_srpg_mem5 ) ,
        .gate_clk_mem5(gate_clk_mem5      )      ,
        .isolate_mem5(isolate_mem5       )       ,
        .save_edge_mem5(save_edge_mem5   )   ,
        .restore_edge_mem5(restore_edge_mem5   )   ,
        .pwr1_on_mem5(pwr1_on_mem5       )       ,
        .pwr2_on_mem5(pwr2_on_mem5       )       ,
        .pwr1_off_mem5(pwr1_off_mem5      )      ,
        .pwr2_off_mem5(pwr2_off_mem5      )      ,

    	.core06v5(core06v5),     //  : out std_logic5
    	.core08v5(core08v5),     //  : out std_logic5
    	.core10v5(core10v5),     //  : out std_logic5
    	.core12v5(core12v5),     //  : out std_logic5
        .pcm_macb_wakeup_int5(pcm_macb_wakeup_int5),
        .mte_smc_start5(mte_smc_start5),
        .mte_uart_start5(mte_uart_start5),
        .mte_smc_uart_start5(mte_smc_uart_start5),  
        .mte_pm_smc_to_default_start5(mte_pm_smc_to_default_start5), 
        .mte_pm_uart_to_default_start5(mte_pm_uart_to_default_start5),
        .mte_pm_smc_uart_to_default_start5(mte_pm_smc_uart_to_default_start5)
);


`else 
//##############################################################################
// if the POWER_CTRL5 is black5 boxed5 
//##############################################################################

   //------------------------------------
   // Clocks5 & Reset5
   //------------------------------------
   wire              pclk5;
   wire              nprst5;
   //------------------------------------
   // APB5 programming5 interface;
   //------------------------------------
   wire   [31:0]     paddr5;
   wire              psel5;
   wire              penable5;
   wire              pwrite5;
   wire   [31:0]     pwdata5;
   reg    [31:0]     prdata5;
   //------------------------------------
   // Scan5
   //------------------------------------
   wire              scan_in5;
   wire              scan_en5;
   wire              scan_mode5;
   reg               scan_out5;
   //------------------------------------
   // Module5 control5 outputs5
   //------------------------------------
   // SMC5;
   reg               rstn_non_srpg_smc5;
   reg               gate_clk_smc5;
   reg               isolate_smc5;
   reg               save_edge_smc5;
   reg               restore_edge_smc5;
   reg               pwr1_on_smc5;
   reg               pwr2_on_smc5;
   wire              pwr1_off_smc5;
   wire              pwr2_off_smc5;

   // URT5;
   reg               rstn_non_srpg_urt5;
   reg               gate_clk_urt5;
   reg               isolate_urt5;
   reg               save_edge_urt5;
   reg               restore_edge_urt5;
   reg               pwr1_on_urt5;
   reg               pwr2_on_urt5;
   wire              pwr1_off_urt5;
   wire              pwr2_off_urt5;

   // ETH05
   reg               rstn_non_srpg_macb05;
   reg               gate_clk_macb05;
   reg               isolate_macb05;
   reg               save_edge_macb05;
   reg               restore_edge_macb05;
   reg               pwr1_on_macb05;
   reg               pwr2_on_macb05;
   wire              pwr1_off_macb05;
   wire              pwr2_off_macb05;
   // ETH15
   reg               rstn_non_srpg_macb15;
   reg               gate_clk_macb15;
   reg               isolate_macb15;
   reg               save_edge_macb15;
   reg               restore_edge_macb15;
   reg               pwr1_on_macb15;
   reg               pwr2_on_macb15;
   wire              pwr1_off_macb15;
   wire              pwr2_off_macb15;
   // ETH25
   reg               rstn_non_srpg_macb25;
   reg               gate_clk_macb25;
   reg               isolate_macb25;
   reg               save_edge_macb25;
   reg               restore_edge_macb25;
   reg               pwr1_on_macb25;
   reg               pwr2_on_macb25;
   wire              pwr1_off_macb25;
   wire              pwr2_off_macb25;
   // ETH35
   reg               rstn_non_srpg_macb35;
   reg               gate_clk_macb35;
   reg               isolate_macb35;
   reg               save_edge_macb35;
   reg               restore_edge_macb35;
   reg               pwr1_on_macb35;
   reg               pwr2_on_macb35;
   wire              pwr1_off_macb35;
   wire              pwr2_off_macb35;

   wire core06v5;
   wire core08v5;
   wire core10v5;
   wire core12v5;



`endif
//##############################################################################
// black5 boxed5 defines5 
//##############################################################################

endmodule
