//File7 name   : power_ctrl_veneer7.v
//Title7       : 
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------
module power_ctrl_veneer7 (
    //------------------------------------
    // Clocks7 & Reset7
    //------------------------------------
    pclk7,
    nprst7,
    //------------------------------------
    // APB7 programming7 interface
    //------------------------------------
    paddr7,
    psel7,
    penable7,
    pwrite7,
    pwdata7,
    prdata7,
    // mac7 i/f,
    macb3_wakeup7,
    macb2_wakeup7,
    macb1_wakeup7,
    macb0_wakeup7,
    //------------------------------------
    // Scan7 
    //------------------------------------
    scan_in7,
    scan_en7,
    scan_mode7,
    scan_out7,
    int_source_h7,
    //------------------------------------
    // Module7 control7 outputs7
    //------------------------------------
    // SMC7
    rstn_non_srpg_smc7,
    gate_clk_smc7,
    isolate_smc7,
    save_edge_smc7,
    restore_edge_smc7,
    pwr1_on_smc7,
    pwr2_on_smc7,
    // URT7
    rstn_non_srpg_urt7,
    gate_clk_urt7,
    isolate_urt7,
    save_edge_urt7,
    restore_edge_urt7,
    pwr1_on_urt7,
    pwr2_on_urt7,
    // ETH07
    rstn_non_srpg_macb07,
    gate_clk_macb07,
    isolate_macb07,
    save_edge_macb07,
    restore_edge_macb07,
    pwr1_on_macb07,
    pwr2_on_macb07,
    // ETH17
    rstn_non_srpg_macb17,
    gate_clk_macb17,
    isolate_macb17,
    save_edge_macb17,
    restore_edge_macb17,
    pwr1_on_macb17,
    pwr2_on_macb17,
    // ETH27
    rstn_non_srpg_macb27,
    gate_clk_macb27,
    isolate_macb27,
    save_edge_macb27,
    restore_edge_macb27,
    pwr1_on_macb27,
    pwr2_on_macb27,
    // ETH37
    rstn_non_srpg_macb37,
    gate_clk_macb37,
    isolate_macb37,
    save_edge_macb37,
    restore_edge_macb37,
    pwr1_on_macb37,
    pwr2_on_macb37,
    // core7 dvfs7 transitions7
    core06v7,
    core08v7,
    core10v7,
    core12v7,
    pcm_macb_wakeup_int7,
    isolate_mem7,
    
    // transit7 signals7
    mte_smc_start7,
    mte_uart_start7,
    mte_smc_uart_start7,  
    mte_pm_smc_to_default_start7, 
    mte_pm_uart_to_default_start7,
    mte_pm_smc_uart_to_default_start7
  );

//------------------------------------------------------------------------------
// I7/O7 declaration7
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks7 & Reset7
   //------------------------------------
   input             pclk7;
   input             nprst7;
   //------------------------------------
   // APB7 programming7 interface;
   //------------------------------------
   input  [31:0]     paddr7;
   input             psel7;
   input             penable7;
   input             pwrite7;
   input  [31:0]     pwdata7;
   output [31:0]     prdata7;
    // mac7
   input macb3_wakeup7;
   input macb2_wakeup7;
   input macb1_wakeup7;
   input macb0_wakeup7;
   //------------------------------------
   // Scan7
   //------------------------------------
   input             scan_in7;
   input             scan_en7;
   input             scan_mode7;
   output            scan_out7;
   //------------------------------------
   // Module7 control7 outputs7
   input             int_source_h7;
   //------------------------------------
   // SMC7
   output            rstn_non_srpg_smc7;
   output            gate_clk_smc7;
   output            isolate_smc7;
   output            save_edge_smc7;
   output            restore_edge_smc7;
   output            pwr1_on_smc7;
   output            pwr2_on_smc7;
   // URT7
   output            rstn_non_srpg_urt7;
   output            gate_clk_urt7;
   output            isolate_urt7;
   output            save_edge_urt7;
   output            restore_edge_urt7;
   output            pwr1_on_urt7;
   output            pwr2_on_urt7;
   // ETH07
   output            rstn_non_srpg_macb07;
   output            gate_clk_macb07;
   output            isolate_macb07;
   output            save_edge_macb07;
   output            restore_edge_macb07;
   output            pwr1_on_macb07;
   output            pwr2_on_macb07;
   // ETH17
   output            rstn_non_srpg_macb17;
   output            gate_clk_macb17;
   output            isolate_macb17;
   output            save_edge_macb17;
   output            restore_edge_macb17;
   output            pwr1_on_macb17;
   output            pwr2_on_macb17;
   // ETH27
   output            rstn_non_srpg_macb27;
   output            gate_clk_macb27;
   output            isolate_macb27;
   output            save_edge_macb27;
   output            restore_edge_macb27;
   output            pwr1_on_macb27;
   output            pwr2_on_macb27;
   // ETH37
   output            rstn_non_srpg_macb37;
   output            gate_clk_macb37;
   output            isolate_macb37;
   output            save_edge_macb37;
   output            restore_edge_macb37;
   output            pwr1_on_macb37;
   output            pwr2_on_macb37;

   // dvfs7
   output core06v7;
   output core08v7;
   output core10v7;
   output core12v7;
   output pcm_macb_wakeup_int7 ;
   output isolate_mem7 ;

   //transit7  signals7
   output mte_smc_start7;
   output mte_uart_start7;
   output mte_smc_uart_start7;  
   output mte_pm_smc_to_default_start7; 
   output mte_pm_uart_to_default_start7;
   output mte_pm_smc_uart_to_default_start7;



//##############################################################################
// if the POWER_CTRL7 is NOT7 black7 boxed7 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL7

power_ctrl7 i_power_ctrl7(
    // -- Clocks7 & Reset7
    	.pclk7(pclk7), 			//  : in  std_logic7;
    	.nprst7(nprst7), 		//  : in  std_logic7;
    // -- APB7 programming7 interface
    	.paddr7(paddr7), 			//  : in  std_logic_vector7(31 downto7 0);
    	.psel7(psel7), 			//  : in  std_logic7;
    	.penable7(penable7), 		//  : in  std_logic7;
    	.pwrite7(pwrite7), 		//  : in  std_logic7;
    	.pwdata7(pwdata7), 		//  : in  std_logic_vector7(31 downto7 0);
    	.prdata7(prdata7), 		//  : out std_logic_vector7(31 downto7 0);
        .macb3_wakeup7(macb3_wakeup7),
        .macb2_wakeup7(macb2_wakeup7),
        .macb1_wakeup7(macb1_wakeup7),
        .macb0_wakeup7(macb0_wakeup7),
    // -- Module7 control7 outputs7
    	.scan_in7(),			//  : in  std_logic7;
    	.scan_en7(scan_en7),             	//  : in  std_logic7;
    	.scan_mode7(scan_mode7),          //  : in  std_logic7;
    	.scan_out7(),            	//  : out std_logic7;
    	.int_source_h7(int_source_h7),    //  : out std_logic7;
     	.rstn_non_srpg_smc7(rstn_non_srpg_smc7), 		//   : out std_logic7;
    	.gate_clk_smc7(gate_clk_smc7), 	//  : out std_logic7;
    	.isolate_smc7(isolate_smc7), 	//  : out std_logic7;
    	.save_edge_smc7(save_edge_smc7), 	//  : out std_logic7;
    	.restore_edge_smc7(restore_edge_smc7), 	//  : out std_logic7;
    	.pwr1_on_smc7(pwr1_on_smc7), 	//  : out std_logic7;
    	.pwr2_on_smc7(pwr2_on_smc7), 	//  : out std_logic7
	.pwr1_off_smc7(pwr1_off_smc7), 	//  : out std_logic7;
    	.pwr2_off_smc7(pwr2_off_smc7), 	//  : out std_logic7
     	.rstn_non_srpg_urt7(rstn_non_srpg_urt7), 		//   : out std_logic7;
    	.gate_clk_urt7(gate_clk_urt7), 	//  : out std_logic7;
    	.isolate_urt7(isolate_urt7), 	//  : out std_logic7;
    	.save_edge_urt7(save_edge_urt7), 	//  : out std_logic7;
    	.restore_edge_urt7(restore_edge_urt7), 	//  : out std_logic7;
    	.pwr1_on_urt7(pwr1_on_urt7), 	//  : out std_logic7;
    	.pwr2_on_urt7(pwr2_on_urt7), 	//  : out std_logic7;
    	.pwr1_off_urt7(pwr1_off_urt7),    //  : out std_logic7;
    	.pwr2_off_urt7(pwr2_off_urt7),     //  : out std_logic7
     	.rstn_non_srpg_macb07(rstn_non_srpg_macb07), 		//   : out std_logic7;
    	.gate_clk_macb07(gate_clk_macb07), 	//  : out std_logic7;
    	.isolate_macb07(isolate_macb07), 	//  : out std_logic7;
    	.save_edge_macb07(save_edge_macb07), 	//  : out std_logic7;
    	.restore_edge_macb07(restore_edge_macb07), 	//  : out std_logic7;
    	.pwr1_on_macb07(pwr1_on_macb07), 	//  : out std_logic7;
    	.pwr2_on_macb07(pwr2_on_macb07), 	//  : out std_logic7;
    	.pwr1_off_macb07(pwr1_off_macb07),    //  : out std_logic7;
    	.pwr2_off_macb07(pwr2_off_macb07),     //  : out std_logic7
     	.rstn_non_srpg_macb17(rstn_non_srpg_macb17), 		//   : out std_logic7;
    	.gate_clk_macb17(gate_clk_macb17), 	//  : out std_logic7;
    	.isolate_macb17(isolate_macb17), 	//  : out std_logic7;
    	.save_edge_macb17(save_edge_macb17), 	//  : out std_logic7;
    	.restore_edge_macb17(restore_edge_macb17), 	//  : out std_logic7;
    	.pwr1_on_macb17(pwr1_on_macb17), 	//  : out std_logic7;
    	.pwr2_on_macb17(pwr2_on_macb17), 	//  : out std_logic7;
    	.pwr1_off_macb17(pwr1_off_macb17),    //  : out std_logic7;
    	.pwr2_off_macb17(pwr2_off_macb17),     //  : out std_logic7
     	.rstn_non_srpg_macb27(rstn_non_srpg_macb27), 		//   : out std_logic7;
    	.gate_clk_macb27(gate_clk_macb27), 	//  : out std_logic7;
    	.isolate_macb27(isolate_macb27), 	//  : out std_logic7;
    	.save_edge_macb27(save_edge_macb27), 	//  : out std_logic7;
    	.restore_edge_macb27(restore_edge_macb27), 	//  : out std_logic7;
    	.pwr1_on_macb27(pwr1_on_macb27), 	//  : out std_logic7;
    	.pwr2_on_macb27(pwr2_on_macb27), 	//  : out std_logic7;
    	.pwr1_off_macb27(pwr1_off_macb27),    //  : out std_logic7;
    	.pwr2_off_macb27(pwr2_off_macb27),     //  : out std_logic7
     	.rstn_non_srpg_macb37(rstn_non_srpg_macb37), 		//   : out std_logic7;
    	.gate_clk_macb37(gate_clk_macb37), 	//  : out std_logic7;
    	.isolate_macb37(isolate_macb37), 	//  : out std_logic7;
    	.save_edge_macb37(save_edge_macb37), 	//  : out std_logic7;
    	.restore_edge_macb37(restore_edge_macb37), 	//  : out std_logic7;
    	.pwr1_on_macb37(pwr1_on_macb37), 	//  : out std_logic7;
    	.pwr2_on_macb37(pwr2_on_macb37), 	//  : out std_logic7;
    	.pwr1_off_macb37(pwr1_off_macb37),    //  : out std_logic7;
    	.pwr2_off_macb37(pwr2_off_macb37),     //  : out std_logic7
        .rstn_non_srpg_dma7(rstn_non_srpg_dma7 ) ,
        .gate_clk_dma7(gate_clk_dma7      )      ,
        .isolate_dma7(isolate_dma7       )       ,
        .save_edge_dma7(save_edge_dma7   )   ,
        .restore_edge_dma7(restore_edge_dma7   )   ,
        .pwr1_on_dma7(pwr1_on_dma7       )       ,
        .pwr2_on_dma7(pwr2_on_dma7       )       ,
        .pwr1_off_dma7(pwr1_off_dma7      )      ,
        .pwr2_off_dma7(pwr2_off_dma7      )      ,
        
        .rstn_non_srpg_cpu7(rstn_non_srpg_cpu7 ) ,
        .gate_clk_cpu7(gate_clk_cpu7      )      ,
        .isolate_cpu7(isolate_cpu7       )       ,
        .save_edge_cpu7(save_edge_cpu7   )   ,
        .restore_edge_cpu7(restore_edge_cpu7   )   ,
        .pwr1_on_cpu7(pwr1_on_cpu7       )       ,
        .pwr2_on_cpu7(pwr2_on_cpu7       )       ,
        .pwr1_off_cpu7(pwr1_off_cpu7      )      ,
        .pwr2_off_cpu7(pwr2_off_cpu7      )      ,
        
        .rstn_non_srpg_alut7(rstn_non_srpg_alut7 ) ,
        .gate_clk_alut7(gate_clk_alut7      )      ,
        .isolate_alut7(isolate_alut7       )       ,
        .save_edge_alut7(save_edge_alut7   )   ,
        .restore_edge_alut7(restore_edge_alut7   )   ,
        .pwr1_on_alut7(pwr1_on_alut7       )       ,
        .pwr2_on_alut7(pwr2_on_alut7       )       ,
        .pwr1_off_alut7(pwr1_off_alut7      )      ,
        .pwr2_off_alut7(pwr2_off_alut7      )      ,
        
        .rstn_non_srpg_mem7(rstn_non_srpg_mem7 ) ,
        .gate_clk_mem7(gate_clk_mem7      )      ,
        .isolate_mem7(isolate_mem7       )       ,
        .save_edge_mem7(save_edge_mem7   )   ,
        .restore_edge_mem7(restore_edge_mem7   )   ,
        .pwr1_on_mem7(pwr1_on_mem7       )       ,
        .pwr2_on_mem7(pwr2_on_mem7       )       ,
        .pwr1_off_mem7(pwr1_off_mem7      )      ,
        .pwr2_off_mem7(pwr2_off_mem7      )      ,

    	.core06v7(core06v7),     //  : out std_logic7
    	.core08v7(core08v7),     //  : out std_logic7
    	.core10v7(core10v7),     //  : out std_logic7
    	.core12v7(core12v7),     //  : out std_logic7
        .pcm_macb_wakeup_int7(pcm_macb_wakeup_int7),
        .mte_smc_start7(mte_smc_start7),
        .mte_uart_start7(mte_uart_start7),
        .mte_smc_uart_start7(mte_smc_uart_start7),  
        .mte_pm_smc_to_default_start7(mte_pm_smc_to_default_start7), 
        .mte_pm_uart_to_default_start7(mte_pm_uart_to_default_start7),
        .mte_pm_smc_uart_to_default_start7(mte_pm_smc_uart_to_default_start7)
);


`else 
//##############################################################################
// if the POWER_CTRL7 is black7 boxed7 
//##############################################################################

   //------------------------------------
   // Clocks7 & Reset7
   //------------------------------------
   wire              pclk7;
   wire              nprst7;
   //------------------------------------
   // APB7 programming7 interface;
   //------------------------------------
   wire   [31:0]     paddr7;
   wire              psel7;
   wire              penable7;
   wire              pwrite7;
   wire   [31:0]     pwdata7;
   reg    [31:0]     prdata7;
   //------------------------------------
   // Scan7
   //------------------------------------
   wire              scan_in7;
   wire              scan_en7;
   wire              scan_mode7;
   reg               scan_out7;
   //------------------------------------
   // Module7 control7 outputs7
   //------------------------------------
   // SMC7;
   reg               rstn_non_srpg_smc7;
   reg               gate_clk_smc7;
   reg               isolate_smc7;
   reg               save_edge_smc7;
   reg               restore_edge_smc7;
   reg               pwr1_on_smc7;
   reg               pwr2_on_smc7;
   wire              pwr1_off_smc7;
   wire              pwr2_off_smc7;

   // URT7;
   reg               rstn_non_srpg_urt7;
   reg               gate_clk_urt7;
   reg               isolate_urt7;
   reg               save_edge_urt7;
   reg               restore_edge_urt7;
   reg               pwr1_on_urt7;
   reg               pwr2_on_urt7;
   wire              pwr1_off_urt7;
   wire              pwr2_off_urt7;

   // ETH07
   reg               rstn_non_srpg_macb07;
   reg               gate_clk_macb07;
   reg               isolate_macb07;
   reg               save_edge_macb07;
   reg               restore_edge_macb07;
   reg               pwr1_on_macb07;
   reg               pwr2_on_macb07;
   wire              pwr1_off_macb07;
   wire              pwr2_off_macb07;
   // ETH17
   reg               rstn_non_srpg_macb17;
   reg               gate_clk_macb17;
   reg               isolate_macb17;
   reg               save_edge_macb17;
   reg               restore_edge_macb17;
   reg               pwr1_on_macb17;
   reg               pwr2_on_macb17;
   wire              pwr1_off_macb17;
   wire              pwr2_off_macb17;
   // ETH27
   reg               rstn_non_srpg_macb27;
   reg               gate_clk_macb27;
   reg               isolate_macb27;
   reg               save_edge_macb27;
   reg               restore_edge_macb27;
   reg               pwr1_on_macb27;
   reg               pwr2_on_macb27;
   wire              pwr1_off_macb27;
   wire              pwr2_off_macb27;
   // ETH37
   reg               rstn_non_srpg_macb37;
   reg               gate_clk_macb37;
   reg               isolate_macb37;
   reg               save_edge_macb37;
   reg               restore_edge_macb37;
   reg               pwr1_on_macb37;
   reg               pwr2_on_macb37;
   wire              pwr1_off_macb37;
   wire              pwr2_off_macb37;

   wire core06v7;
   wire core08v7;
   wire core10v7;
   wire core12v7;



`endif
//##############################################################################
// black7 boxed7 defines7 
//##############################################################################

endmodule
