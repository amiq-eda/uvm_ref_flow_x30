//File6 name   : power_ctrl_veneer6.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------
module power_ctrl_veneer6 (
    //------------------------------------
    // Clocks6 & Reset6
    //------------------------------------
    pclk6,
    nprst6,
    //------------------------------------
    // APB6 programming6 interface
    //------------------------------------
    paddr6,
    psel6,
    penable6,
    pwrite6,
    pwdata6,
    prdata6,
    // mac6 i/f,
    macb3_wakeup6,
    macb2_wakeup6,
    macb1_wakeup6,
    macb0_wakeup6,
    //------------------------------------
    // Scan6 
    //------------------------------------
    scan_in6,
    scan_en6,
    scan_mode6,
    scan_out6,
    int_source_h6,
    //------------------------------------
    // Module6 control6 outputs6
    //------------------------------------
    // SMC6
    rstn_non_srpg_smc6,
    gate_clk_smc6,
    isolate_smc6,
    save_edge_smc6,
    restore_edge_smc6,
    pwr1_on_smc6,
    pwr2_on_smc6,
    // URT6
    rstn_non_srpg_urt6,
    gate_clk_urt6,
    isolate_urt6,
    save_edge_urt6,
    restore_edge_urt6,
    pwr1_on_urt6,
    pwr2_on_urt6,
    // ETH06
    rstn_non_srpg_macb06,
    gate_clk_macb06,
    isolate_macb06,
    save_edge_macb06,
    restore_edge_macb06,
    pwr1_on_macb06,
    pwr2_on_macb06,
    // ETH16
    rstn_non_srpg_macb16,
    gate_clk_macb16,
    isolate_macb16,
    save_edge_macb16,
    restore_edge_macb16,
    pwr1_on_macb16,
    pwr2_on_macb16,
    // ETH26
    rstn_non_srpg_macb26,
    gate_clk_macb26,
    isolate_macb26,
    save_edge_macb26,
    restore_edge_macb26,
    pwr1_on_macb26,
    pwr2_on_macb26,
    // ETH36
    rstn_non_srpg_macb36,
    gate_clk_macb36,
    isolate_macb36,
    save_edge_macb36,
    restore_edge_macb36,
    pwr1_on_macb36,
    pwr2_on_macb36,
    // core6 dvfs6 transitions6
    core06v6,
    core08v6,
    core10v6,
    core12v6,
    pcm_macb_wakeup_int6,
    isolate_mem6,
    
    // transit6 signals6
    mte_smc_start6,
    mte_uart_start6,
    mte_smc_uart_start6,  
    mte_pm_smc_to_default_start6, 
    mte_pm_uart_to_default_start6,
    mte_pm_smc_uart_to_default_start6
  );

//------------------------------------------------------------------------------
// I6/O6 declaration6
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks6 & Reset6
   //------------------------------------
   input             pclk6;
   input             nprst6;
   //------------------------------------
   // APB6 programming6 interface;
   //------------------------------------
   input  [31:0]     paddr6;
   input             psel6;
   input             penable6;
   input             pwrite6;
   input  [31:0]     pwdata6;
   output [31:0]     prdata6;
    // mac6
   input macb3_wakeup6;
   input macb2_wakeup6;
   input macb1_wakeup6;
   input macb0_wakeup6;
   //------------------------------------
   // Scan6
   //------------------------------------
   input             scan_in6;
   input             scan_en6;
   input             scan_mode6;
   output            scan_out6;
   //------------------------------------
   // Module6 control6 outputs6
   input             int_source_h6;
   //------------------------------------
   // SMC6
   output            rstn_non_srpg_smc6;
   output            gate_clk_smc6;
   output            isolate_smc6;
   output            save_edge_smc6;
   output            restore_edge_smc6;
   output            pwr1_on_smc6;
   output            pwr2_on_smc6;
   // URT6
   output            rstn_non_srpg_urt6;
   output            gate_clk_urt6;
   output            isolate_urt6;
   output            save_edge_urt6;
   output            restore_edge_urt6;
   output            pwr1_on_urt6;
   output            pwr2_on_urt6;
   // ETH06
   output            rstn_non_srpg_macb06;
   output            gate_clk_macb06;
   output            isolate_macb06;
   output            save_edge_macb06;
   output            restore_edge_macb06;
   output            pwr1_on_macb06;
   output            pwr2_on_macb06;
   // ETH16
   output            rstn_non_srpg_macb16;
   output            gate_clk_macb16;
   output            isolate_macb16;
   output            save_edge_macb16;
   output            restore_edge_macb16;
   output            pwr1_on_macb16;
   output            pwr2_on_macb16;
   // ETH26
   output            rstn_non_srpg_macb26;
   output            gate_clk_macb26;
   output            isolate_macb26;
   output            save_edge_macb26;
   output            restore_edge_macb26;
   output            pwr1_on_macb26;
   output            pwr2_on_macb26;
   // ETH36
   output            rstn_non_srpg_macb36;
   output            gate_clk_macb36;
   output            isolate_macb36;
   output            save_edge_macb36;
   output            restore_edge_macb36;
   output            pwr1_on_macb36;
   output            pwr2_on_macb36;

   // dvfs6
   output core06v6;
   output core08v6;
   output core10v6;
   output core12v6;
   output pcm_macb_wakeup_int6 ;
   output isolate_mem6 ;

   //transit6  signals6
   output mte_smc_start6;
   output mte_uart_start6;
   output mte_smc_uart_start6;  
   output mte_pm_smc_to_default_start6; 
   output mte_pm_uart_to_default_start6;
   output mte_pm_smc_uart_to_default_start6;



//##############################################################################
// if the POWER_CTRL6 is NOT6 black6 boxed6 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL6

power_ctrl6 i_power_ctrl6(
    // -- Clocks6 & Reset6
    	.pclk6(pclk6), 			//  : in  std_logic6;
    	.nprst6(nprst6), 		//  : in  std_logic6;
    // -- APB6 programming6 interface
    	.paddr6(paddr6), 			//  : in  std_logic_vector6(31 downto6 0);
    	.psel6(psel6), 			//  : in  std_logic6;
    	.penable6(penable6), 		//  : in  std_logic6;
    	.pwrite6(pwrite6), 		//  : in  std_logic6;
    	.pwdata6(pwdata6), 		//  : in  std_logic_vector6(31 downto6 0);
    	.prdata6(prdata6), 		//  : out std_logic_vector6(31 downto6 0);
        .macb3_wakeup6(macb3_wakeup6),
        .macb2_wakeup6(macb2_wakeup6),
        .macb1_wakeup6(macb1_wakeup6),
        .macb0_wakeup6(macb0_wakeup6),
    // -- Module6 control6 outputs6
    	.scan_in6(),			//  : in  std_logic6;
    	.scan_en6(scan_en6),             	//  : in  std_logic6;
    	.scan_mode6(scan_mode6),          //  : in  std_logic6;
    	.scan_out6(),            	//  : out std_logic6;
    	.int_source_h6(int_source_h6),    //  : out std_logic6;
     	.rstn_non_srpg_smc6(rstn_non_srpg_smc6), 		//   : out std_logic6;
    	.gate_clk_smc6(gate_clk_smc6), 	//  : out std_logic6;
    	.isolate_smc6(isolate_smc6), 	//  : out std_logic6;
    	.save_edge_smc6(save_edge_smc6), 	//  : out std_logic6;
    	.restore_edge_smc6(restore_edge_smc6), 	//  : out std_logic6;
    	.pwr1_on_smc6(pwr1_on_smc6), 	//  : out std_logic6;
    	.pwr2_on_smc6(pwr2_on_smc6), 	//  : out std_logic6
	.pwr1_off_smc6(pwr1_off_smc6), 	//  : out std_logic6;
    	.pwr2_off_smc6(pwr2_off_smc6), 	//  : out std_logic6
     	.rstn_non_srpg_urt6(rstn_non_srpg_urt6), 		//   : out std_logic6;
    	.gate_clk_urt6(gate_clk_urt6), 	//  : out std_logic6;
    	.isolate_urt6(isolate_urt6), 	//  : out std_logic6;
    	.save_edge_urt6(save_edge_urt6), 	//  : out std_logic6;
    	.restore_edge_urt6(restore_edge_urt6), 	//  : out std_logic6;
    	.pwr1_on_urt6(pwr1_on_urt6), 	//  : out std_logic6;
    	.pwr2_on_urt6(pwr2_on_urt6), 	//  : out std_logic6;
    	.pwr1_off_urt6(pwr1_off_urt6),    //  : out std_logic6;
    	.pwr2_off_urt6(pwr2_off_urt6),     //  : out std_logic6
     	.rstn_non_srpg_macb06(rstn_non_srpg_macb06), 		//   : out std_logic6;
    	.gate_clk_macb06(gate_clk_macb06), 	//  : out std_logic6;
    	.isolate_macb06(isolate_macb06), 	//  : out std_logic6;
    	.save_edge_macb06(save_edge_macb06), 	//  : out std_logic6;
    	.restore_edge_macb06(restore_edge_macb06), 	//  : out std_logic6;
    	.pwr1_on_macb06(pwr1_on_macb06), 	//  : out std_logic6;
    	.pwr2_on_macb06(pwr2_on_macb06), 	//  : out std_logic6;
    	.pwr1_off_macb06(pwr1_off_macb06),    //  : out std_logic6;
    	.pwr2_off_macb06(pwr2_off_macb06),     //  : out std_logic6
     	.rstn_non_srpg_macb16(rstn_non_srpg_macb16), 		//   : out std_logic6;
    	.gate_clk_macb16(gate_clk_macb16), 	//  : out std_logic6;
    	.isolate_macb16(isolate_macb16), 	//  : out std_logic6;
    	.save_edge_macb16(save_edge_macb16), 	//  : out std_logic6;
    	.restore_edge_macb16(restore_edge_macb16), 	//  : out std_logic6;
    	.pwr1_on_macb16(pwr1_on_macb16), 	//  : out std_logic6;
    	.pwr2_on_macb16(pwr2_on_macb16), 	//  : out std_logic6;
    	.pwr1_off_macb16(pwr1_off_macb16),    //  : out std_logic6;
    	.pwr2_off_macb16(pwr2_off_macb16),     //  : out std_logic6
     	.rstn_non_srpg_macb26(rstn_non_srpg_macb26), 		//   : out std_logic6;
    	.gate_clk_macb26(gate_clk_macb26), 	//  : out std_logic6;
    	.isolate_macb26(isolate_macb26), 	//  : out std_logic6;
    	.save_edge_macb26(save_edge_macb26), 	//  : out std_logic6;
    	.restore_edge_macb26(restore_edge_macb26), 	//  : out std_logic6;
    	.pwr1_on_macb26(pwr1_on_macb26), 	//  : out std_logic6;
    	.pwr2_on_macb26(pwr2_on_macb26), 	//  : out std_logic6;
    	.pwr1_off_macb26(pwr1_off_macb26),    //  : out std_logic6;
    	.pwr2_off_macb26(pwr2_off_macb26),     //  : out std_logic6
     	.rstn_non_srpg_macb36(rstn_non_srpg_macb36), 		//   : out std_logic6;
    	.gate_clk_macb36(gate_clk_macb36), 	//  : out std_logic6;
    	.isolate_macb36(isolate_macb36), 	//  : out std_logic6;
    	.save_edge_macb36(save_edge_macb36), 	//  : out std_logic6;
    	.restore_edge_macb36(restore_edge_macb36), 	//  : out std_logic6;
    	.pwr1_on_macb36(pwr1_on_macb36), 	//  : out std_logic6;
    	.pwr2_on_macb36(pwr2_on_macb36), 	//  : out std_logic6;
    	.pwr1_off_macb36(pwr1_off_macb36),    //  : out std_logic6;
    	.pwr2_off_macb36(pwr2_off_macb36),     //  : out std_logic6
        .rstn_non_srpg_dma6(rstn_non_srpg_dma6 ) ,
        .gate_clk_dma6(gate_clk_dma6      )      ,
        .isolate_dma6(isolate_dma6       )       ,
        .save_edge_dma6(save_edge_dma6   )   ,
        .restore_edge_dma6(restore_edge_dma6   )   ,
        .pwr1_on_dma6(pwr1_on_dma6       )       ,
        .pwr2_on_dma6(pwr2_on_dma6       )       ,
        .pwr1_off_dma6(pwr1_off_dma6      )      ,
        .pwr2_off_dma6(pwr2_off_dma6      )      ,
        
        .rstn_non_srpg_cpu6(rstn_non_srpg_cpu6 ) ,
        .gate_clk_cpu6(gate_clk_cpu6      )      ,
        .isolate_cpu6(isolate_cpu6       )       ,
        .save_edge_cpu6(save_edge_cpu6   )   ,
        .restore_edge_cpu6(restore_edge_cpu6   )   ,
        .pwr1_on_cpu6(pwr1_on_cpu6       )       ,
        .pwr2_on_cpu6(pwr2_on_cpu6       )       ,
        .pwr1_off_cpu6(pwr1_off_cpu6      )      ,
        .pwr2_off_cpu6(pwr2_off_cpu6      )      ,
        
        .rstn_non_srpg_alut6(rstn_non_srpg_alut6 ) ,
        .gate_clk_alut6(gate_clk_alut6      )      ,
        .isolate_alut6(isolate_alut6       )       ,
        .save_edge_alut6(save_edge_alut6   )   ,
        .restore_edge_alut6(restore_edge_alut6   )   ,
        .pwr1_on_alut6(pwr1_on_alut6       )       ,
        .pwr2_on_alut6(pwr2_on_alut6       )       ,
        .pwr1_off_alut6(pwr1_off_alut6      )      ,
        .pwr2_off_alut6(pwr2_off_alut6      )      ,
        
        .rstn_non_srpg_mem6(rstn_non_srpg_mem6 ) ,
        .gate_clk_mem6(gate_clk_mem6      )      ,
        .isolate_mem6(isolate_mem6       )       ,
        .save_edge_mem6(save_edge_mem6   )   ,
        .restore_edge_mem6(restore_edge_mem6   )   ,
        .pwr1_on_mem6(pwr1_on_mem6       )       ,
        .pwr2_on_mem6(pwr2_on_mem6       )       ,
        .pwr1_off_mem6(pwr1_off_mem6      )      ,
        .pwr2_off_mem6(pwr2_off_mem6      )      ,

    	.core06v6(core06v6),     //  : out std_logic6
    	.core08v6(core08v6),     //  : out std_logic6
    	.core10v6(core10v6),     //  : out std_logic6
    	.core12v6(core12v6),     //  : out std_logic6
        .pcm_macb_wakeup_int6(pcm_macb_wakeup_int6),
        .mte_smc_start6(mte_smc_start6),
        .mte_uart_start6(mte_uart_start6),
        .mte_smc_uart_start6(mte_smc_uart_start6),  
        .mte_pm_smc_to_default_start6(mte_pm_smc_to_default_start6), 
        .mte_pm_uart_to_default_start6(mte_pm_uart_to_default_start6),
        .mte_pm_smc_uart_to_default_start6(mte_pm_smc_uart_to_default_start6)
);


`else 
//##############################################################################
// if the POWER_CTRL6 is black6 boxed6 
//##############################################################################

   //------------------------------------
   // Clocks6 & Reset6
   //------------------------------------
   wire              pclk6;
   wire              nprst6;
   //------------------------------------
   // APB6 programming6 interface;
   //------------------------------------
   wire   [31:0]     paddr6;
   wire              psel6;
   wire              penable6;
   wire              pwrite6;
   wire   [31:0]     pwdata6;
   reg    [31:0]     prdata6;
   //------------------------------------
   // Scan6
   //------------------------------------
   wire              scan_in6;
   wire              scan_en6;
   wire              scan_mode6;
   reg               scan_out6;
   //------------------------------------
   // Module6 control6 outputs6
   //------------------------------------
   // SMC6;
   reg               rstn_non_srpg_smc6;
   reg               gate_clk_smc6;
   reg               isolate_smc6;
   reg               save_edge_smc6;
   reg               restore_edge_smc6;
   reg               pwr1_on_smc6;
   reg               pwr2_on_smc6;
   wire              pwr1_off_smc6;
   wire              pwr2_off_smc6;

   // URT6;
   reg               rstn_non_srpg_urt6;
   reg               gate_clk_urt6;
   reg               isolate_urt6;
   reg               save_edge_urt6;
   reg               restore_edge_urt6;
   reg               pwr1_on_urt6;
   reg               pwr2_on_urt6;
   wire              pwr1_off_urt6;
   wire              pwr2_off_urt6;

   // ETH06
   reg               rstn_non_srpg_macb06;
   reg               gate_clk_macb06;
   reg               isolate_macb06;
   reg               save_edge_macb06;
   reg               restore_edge_macb06;
   reg               pwr1_on_macb06;
   reg               pwr2_on_macb06;
   wire              pwr1_off_macb06;
   wire              pwr2_off_macb06;
   // ETH16
   reg               rstn_non_srpg_macb16;
   reg               gate_clk_macb16;
   reg               isolate_macb16;
   reg               save_edge_macb16;
   reg               restore_edge_macb16;
   reg               pwr1_on_macb16;
   reg               pwr2_on_macb16;
   wire              pwr1_off_macb16;
   wire              pwr2_off_macb16;
   // ETH26
   reg               rstn_non_srpg_macb26;
   reg               gate_clk_macb26;
   reg               isolate_macb26;
   reg               save_edge_macb26;
   reg               restore_edge_macb26;
   reg               pwr1_on_macb26;
   reg               pwr2_on_macb26;
   wire              pwr1_off_macb26;
   wire              pwr2_off_macb26;
   // ETH36
   reg               rstn_non_srpg_macb36;
   reg               gate_clk_macb36;
   reg               isolate_macb36;
   reg               save_edge_macb36;
   reg               restore_edge_macb36;
   reg               pwr1_on_macb36;
   reg               pwr2_on_macb36;
   wire              pwr1_off_macb36;
   wire              pwr2_off_macb36;

   wire core06v6;
   wire core08v6;
   wire core10v6;
   wire core12v6;



`endif
//##############################################################################
// black6 boxed6 defines6 
//##############################################################################

endmodule
