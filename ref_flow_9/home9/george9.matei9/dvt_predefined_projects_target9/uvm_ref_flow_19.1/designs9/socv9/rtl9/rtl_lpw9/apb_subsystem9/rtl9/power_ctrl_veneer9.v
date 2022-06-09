//File9 name   : power_ctrl_veneer9.v
//Title9       : 
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------
module power_ctrl_veneer9 (
    //------------------------------------
    // Clocks9 & Reset9
    //------------------------------------
    pclk9,
    nprst9,
    //------------------------------------
    // APB9 programming9 interface
    //------------------------------------
    paddr9,
    psel9,
    penable9,
    pwrite9,
    pwdata9,
    prdata9,
    // mac9 i/f,
    macb3_wakeup9,
    macb2_wakeup9,
    macb1_wakeup9,
    macb0_wakeup9,
    //------------------------------------
    // Scan9 
    //------------------------------------
    scan_in9,
    scan_en9,
    scan_mode9,
    scan_out9,
    int_source_h9,
    //------------------------------------
    // Module9 control9 outputs9
    //------------------------------------
    // SMC9
    rstn_non_srpg_smc9,
    gate_clk_smc9,
    isolate_smc9,
    save_edge_smc9,
    restore_edge_smc9,
    pwr1_on_smc9,
    pwr2_on_smc9,
    // URT9
    rstn_non_srpg_urt9,
    gate_clk_urt9,
    isolate_urt9,
    save_edge_urt9,
    restore_edge_urt9,
    pwr1_on_urt9,
    pwr2_on_urt9,
    // ETH09
    rstn_non_srpg_macb09,
    gate_clk_macb09,
    isolate_macb09,
    save_edge_macb09,
    restore_edge_macb09,
    pwr1_on_macb09,
    pwr2_on_macb09,
    // ETH19
    rstn_non_srpg_macb19,
    gate_clk_macb19,
    isolate_macb19,
    save_edge_macb19,
    restore_edge_macb19,
    pwr1_on_macb19,
    pwr2_on_macb19,
    // ETH29
    rstn_non_srpg_macb29,
    gate_clk_macb29,
    isolate_macb29,
    save_edge_macb29,
    restore_edge_macb29,
    pwr1_on_macb29,
    pwr2_on_macb29,
    // ETH39
    rstn_non_srpg_macb39,
    gate_clk_macb39,
    isolate_macb39,
    save_edge_macb39,
    restore_edge_macb39,
    pwr1_on_macb39,
    pwr2_on_macb39,
    // core9 dvfs9 transitions9
    core06v9,
    core08v9,
    core10v9,
    core12v9,
    pcm_macb_wakeup_int9,
    isolate_mem9,
    
    // transit9 signals9
    mte_smc_start9,
    mte_uart_start9,
    mte_smc_uart_start9,  
    mte_pm_smc_to_default_start9, 
    mte_pm_uart_to_default_start9,
    mte_pm_smc_uart_to_default_start9
  );

//------------------------------------------------------------------------------
// I9/O9 declaration9
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks9 & Reset9
   //------------------------------------
   input             pclk9;
   input             nprst9;
   //------------------------------------
   // APB9 programming9 interface;
   //------------------------------------
   input  [31:0]     paddr9;
   input             psel9;
   input             penable9;
   input             pwrite9;
   input  [31:0]     pwdata9;
   output [31:0]     prdata9;
    // mac9
   input macb3_wakeup9;
   input macb2_wakeup9;
   input macb1_wakeup9;
   input macb0_wakeup9;
   //------------------------------------
   // Scan9
   //------------------------------------
   input             scan_in9;
   input             scan_en9;
   input             scan_mode9;
   output            scan_out9;
   //------------------------------------
   // Module9 control9 outputs9
   input             int_source_h9;
   //------------------------------------
   // SMC9
   output            rstn_non_srpg_smc9;
   output            gate_clk_smc9;
   output            isolate_smc9;
   output            save_edge_smc9;
   output            restore_edge_smc9;
   output            pwr1_on_smc9;
   output            pwr2_on_smc9;
   // URT9
   output            rstn_non_srpg_urt9;
   output            gate_clk_urt9;
   output            isolate_urt9;
   output            save_edge_urt9;
   output            restore_edge_urt9;
   output            pwr1_on_urt9;
   output            pwr2_on_urt9;
   // ETH09
   output            rstn_non_srpg_macb09;
   output            gate_clk_macb09;
   output            isolate_macb09;
   output            save_edge_macb09;
   output            restore_edge_macb09;
   output            pwr1_on_macb09;
   output            pwr2_on_macb09;
   // ETH19
   output            rstn_non_srpg_macb19;
   output            gate_clk_macb19;
   output            isolate_macb19;
   output            save_edge_macb19;
   output            restore_edge_macb19;
   output            pwr1_on_macb19;
   output            pwr2_on_macb19;
   // ETH29
   output            rstn_non_srpg_macb29;
   output            gate_clk_macb29;
   output            isolate_macb29;
   output            save_edge_macb29;
   output            restore_edge_macb29;
   output            pwr1_on_macb29;
   output            pwr2_on_macb29;
   // ETH39
   output            rstn_non_srpg_macb39;
   output            gate_clk_macb39;
   output            isolate_macb39;
   output            save_edge_macb39;
   output            restore_edge_macb39;
   output            pwr1_on_macb39;
   output            pwr2_on_macb39;

   // dvfs9
   output core06v9;
   output core08v9;
   output core10v9;
   output core12v9;
   output pcm_macb_wakeup_int9 ;
   output isolate_mem9 ;

   //transit9  signals9
   output mte_smc_start9;
   output mte_uart_start9;
   output mte_smc_uart_start9;  
   output mte_pm_smc_to_default_start9; 
   output mte_pm_uart_to_default_start9;
   output mte_pm_smc_uart_to_default_start9;



//##############################################################################
// if the POWER_CTRL9 is NOT9 black9 boxed9 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL9

power_ctrl9 i_power_ctrl9(
    // -- Clocks9 & Reset9
    	.pclk9(pclk9), 			//  : in  std_logic9;
    	.nprst9(nprst9), 		//  : in  std_logic9;
    // -- APB9 programming9 interface
    	.paddr9(paddr9), 			//  : in  std_logic_vector9(31 downto9 0);
    	.psel9(psel9), 			//  : in  std_logic9;
    	.penable9(penable9), 		//  : in  std_logic9;
    	.pwrite9(pwrite9), 		//  : in  std_logic9;
    	.pwdata9(pwdata9), 		//  : in  std_logic_vector9(31 downto9 0);
    	.prdata9(prdata9), 		//  : out std_logic_vector9(31 downto9 0);
        .macb3_wakeup9(macb3_wakeup9),
        .macb2_wakeup9(macb2_wakeup9),
        .macb1_wakeup9(macb1_wakeup9),
        .macb0_wakeup9(macb0_wakeup9),
    // -- Module9 control9 outputs9
    	.scan_in9(),			//  : in  std_logic9;
    	.scan_en9(scan_en9),             	//  : in  std_logic9;
    	.scan_mode9(scan_mode9),          //  : in  std_logic9;
    	.scan_out9(),            	//  : out std_logic9;
    	.int_source_h9(int_source_h9),    //  : out std_logic9;
     	.rstn_non_srpg_smc9(rstn_non_srpg_smc9), 		//   : out std_logic9;
    	.gate_clk_smc9(gate_clk_smc9), 	//  : out std_logic9;
    	.isolate_smc9(isolate_smc9), 	//  : out std_logic9;
    	.save_edge_smc9(save_edge_smc9), 	//  : out std_logic9;
    	.restore_edge_smc9(restore_edge_smc9), 	//  : out std_logic9;
    	.pwr1_on_smc9(pwr1_on_smc9), 	//  : out std_logic9;
    	.pwr2_on_smc9(pwr2_on_smc9), 	//  : out std_logic9
	.pwr1_off_smc9(pwr1_off_smc9), 	//  : out std_logic9;
    	.pwr2_off_smc9(pwr2_off_smc9), 	//  : out std_logic9
     	.rstn_non_srpg_urt9(rstn_non_srpg_urt9), 		//   : out std_logic9;
    	.gate_clk_urt9(gate_clk_urt9), 	//  : out std_logic9;
    	.isolate_urt9(isolate_urt9), 	//  : out std_logic9;
    	.save_edge_urt9(save_edge_urt9), 	//  : out std_logic9;
    	.restore_edge_urt9(restore_edge_urt9), 	//  : out std_logic9;
    	.pwr1_on_urt9(pwr1_on_urt9), 	//  : out std_logic9;
    	.pwr2_on_urt9(pwr2_on_urt9), 	//  : out std_logic9;
    	.pwr1_off_urt9(pwr1_off_urt9),    //  : out std_logic9;
    	.pwr2_off_urt9(pwr2_off_urt9),     //  : out std_logic9
     	.rstn_non_srpg_macb09(rstn_non_srpg_macb09), 		//   : out std_logic9;
    	.gate_clk_macb09(gate_clk_macb09), 	//  : out std_logic9;
    	.isolate_macb09(isolate_macb09), 	//  : out std_logic9;
    	.save_edge_macb09(save_edge_macb09), 	//  : out std_logic9;
    	.restore_edge_macb09(restore_edge_macb09), 	//  : out std_logic9;
    	.pwr1_on_macb09(pwr1_on_macb09), 	//  : out std_logic9;
    	.pwr2_on_macb09(pwr2_on_macb09), 	//  : out std_logic9;
    	.pwr1_off_macb09(pwr1_off_macb09),    //  : out std_logic9;
    	.pwr2_off_macb09(pwr2_off_macb09),     //  : out std_logic9
     	.rstn_non_srpg_macb19(rstn_non_srpg_macb19), 		//   : out std_logic9;
    	.gate_clk_macb19(gate_clk_macb19), 	//  : out std_logic9;
    	.isolate_macb19(isolate_macb19), 	//  : out std_logic9;
    	.save_edge_macb19(save_edge_macb19), 	//  : out std_logic9;
    	.restore_edge_macb19(restore_edge_macb19), 	//  : out std_logic9;
    	.pwr1_on_macb19(pwr1_on_macb19), 	//  : out std_logic9;
    	.pwr2_on_macb19(pwr2_on_macb19), 	//  : out std_logic9;
    	.pwr1_off_macb19(pwr1_off_macb19),    //  : out std_logic9;
    	.pwr2_off_macb19(pwr2_off_macb19),     //  : out std_logic9
     	.rstn_non_srpg_macb29(rstn_non_srpg_macb29), 		//   : out std_logic9;
    	.gate_clk_macb29(gate_clk_macb29), 	//  : out std_logic9;
    	.isolate_macb29(isolate_macb29), 	//  : out std_logic9;
    	.save_edge_macb29(save_edge_macb29), 	//  : out std_logic9;
    	.restore_edge_macb29(restore_edge_macb29), 	//  : out std_logic9;
    	.pwr1_on_macb29(pwr1_on_macb29), 	//  : out std_logic9;
    	.pwr2_on_macb29(pwr2_on_macb29), 	//  : out std_logic9;
    	.pwr1_off_macb29(pwr1_off_macb29),    //  : out std_logic9;
    	.pwr2_off_macb29(pwr2_off_macb29),     //  : out std_logic9
     	.rstn_non_srpg_macb39(rstn_non_srpg_macb39), 		//   : out std_logic9;
    	.gate_clk_macb39(gate_clk_macb39), 	//  : out std_logic9;
    	.isolate_macb39(isolate_macb39), 	//  : out std_logic9;
    	.save_edge_macb39(save_edge_macb39), 	//  : out std_logic9;
    	.restore_edge_macb39(restore_edge_macb39), 	//  : out std_logic9;
    	.pwr1_on_macb39(pwr1_on_macb39), 	//  : out std_logic9;
    	.pwr2_on_macb39(pwr2_on_macb39), 	//  : out std_logic9;
    	.pwr1_off_macb39(pwr1_off_macb39),    //  : out std_logic9;
    	.pwr2_off_macb39(pwr2_off_macb39),     //  : out std_logic9
        .rstn_non_srpg_dma9(rstn_non_srpg_dma9 ) ,
        .gate_clk_dma9(gate_clk_dma9      )      ,
        .isolate_dma9(isolate_dma9       )       ,
        .save_edge_dma9(save_edge_dma9   )   ,
        .restore_edge_dma9(restore_edge_dma9   )   ,
        .pwr1_on_dma9(pwr1_on_dma9       )       ,
        .pwr2_on_dma9(pwr2_on_dma9       )       ,
        .pwr1_off_dma9(pwr1_off_dma9      )      ,
        .pwr2_off_dma9(pwr2_off_dma9      )      ,
        
        .rstn_non_srpg_cpu9(rstn_non_srpg_cpu9 ) ,
        .gate_clk_cpu9(gate_clk_cpu9      )      ,
        .isolate_cpu9(isolate_cpu9       )       ,
        .save_edge_cpu9(save_edge_cpu9   )   ,
        .restore_edge_cpu9(restore_edge_cpu9   )   ,
        .pwr1_on_cpu9(pwr1_on_cpu9       )       ,
        .pwr2_on_cpu9(pwr2_on_cpu9       )       ,
        .pwr1_off_cpu9(pwr1_off_cpu9      )      ,
        .pwr2_off_cpu9(pwr2_off_cpu9      )      ,
        
        .rstn_non_srpg_alut9(rstn_non_srpg_alut9 ) ,
        .gate_clk_alut9(gate_clk_alut9      )      ,
        .isolate_alut9(isolate_alut9       )       ,
        .save_edge_alut9(save_edge_alut9   )   ,
        .restore_edge_alut9(restore_edge_alut9   )   ,
        .pwr1_on_alut9(pwr1_on_alut9       )       ,
        .pwr2_on_alut9(pwr2_on_alut9       )       ,
        .pwr1_off_alut9(pwr1_off_alut9      )      ,
        .pwr2_off_alut9(pwr2_off_alut9      )      ,
        
        .rstn_non_srpg_mem9(rstn_non_srpg_mem9 ) ,
        .gate_clk_mem9(gate_clk_mem9      )      ,
        .isolate_mem9(isolate_mem9       )       ,
        .save_edge_mem9(save_edge_mem9   )   ,
        .restore_edge_mem9(restore_edge_mem9   )   ,
        .pwr1_on_mem9(pwr1_on_mem9       )       ,
        .pwr2_on_mem9(pwr2_on_mem9       )       ,
        .pwr1_off_mem9(pwr1_off_mem9      )      ,
        .pwr2_off_mem9(pwr2_off_mem9      )      ,

    	.core06v9(core06v9),     //  : out std_logic9
    	.core08v9(core08v9),     //  : out std_logic9
    	.core10v9(core10v9),     //  : out std_logic9
    	.core12v9(core12v9),     //  : out std_logic9
        .pcm_macb_wakeup_int9(pcm_macb_wakeup_int9),
        .mte_smc_start9(mte_smc_start9),
        .mte_uart_start9(mte_uart_start9),
        .mte_smc_uart_start9(mte_smc_uart_start9),  
        .mte_pm_smc_to_default_start9(mte_pm_smc_to_default_start9), 
        .mte_pm_uart_to_default_start9(mte_pm_uart_to_default_start9),
        .mte_pm_smc_uart_to_default_start9(mte_pm_smc_uart_to_default_start9)
);


`else 
//##############################################################################
// if the POWER_CTRL9 is black9 boxed9 
//##############################################################################

   //------------------------------------
   // Clocks9 & Reset9
   //------------------------------------
   wire              pclk9;
   wire              nprst9;
   //------------------------------------
   // APB9 programming9 interface;
   //------------------------------------
   wire   [31:0]     paddr9;
   wire              psel9;
   wire              penable9;
   wire              pwrite9;
   wire   [31:0]     pwdata9;
   reg    [31:0]     prdata9;
   //------------------------------------
   // Scan9
   //------------------------------------
   wire              scan_in9;
   wire              scan_en9;
   wire              scan_mode9;
   reg               scan_out9;
   //------------------------------------
   // Module9 control9 outputs9
   //------------------------------------
   // SMC9;
   reg               rstn_non_srpg_smc9;
   reg               gate_clk_smc9;
   reg               isolate_smc9;
   reg               save_edge_smc9;
   reg               restore_edge_smc9;
   reg               pwr1_on_smc9;
   reg               pwr2_on_smc9;
   wire              pwr1_off_smc9;
   wire              pwr2_off_smc9;

   // URT9;
   reg               rstn_non_srpg_urt9;
   reg               gate_clk_urt9;
   reg               isolate_urt9;
   reg               save_edge_urt9;
   reg               restore_edge_urt9;
   reg               pwr1_on_urt9;
   reg               pwr2_on_urt9;
   wire              pwr1_off_urt9;
   wire              pwr2_off_urt9;

   // ETH09
   reg               rstn_non_srpg_macb09;
   reg               gate_clk_macb09;
   reg               isolate_macb09;
   reg               save_edge_macb09;
   reg               restore_edge_macb09;
   reg               pwr1_on_macb09;
   reg               pwr2_on_macb09;
   wire              pwr1_off_macb09;
   wire              pwr2_off_macb09;
   // ETH19
   reg               rstn_non_srpg_macb19;
   reg               gate_clk_macb19;
   reg               isolate_macb19;
   reg               save_edge_macb19;
   reg               restore_edge_macb19;
   reg               pwr1_on_macb19;
   reg               pwr2_on_macb19;
   wire              pwr1_off_macb19;
   wire              pwr2_off_macb19;
   // ETH29
   reg               rstn_non_srpg_macb29;
   reg               gate_clk_macb29;
   reg               isolate_macb29;
   reg               save_edge_macb29;
   reg               restore_edge_macb29;
   reg               pwr1_on_macb29;
   reg               pwr2_on_macb29;
   wire              pwr1_off_macb29;
   wire              pwr2_off_macb29;
   // ETH39
   reg               rstn_non_srpg_macb39;
   reg               gate_clk_macb39;
   reg               isolate_macb39;
   reg               save_edge_macb39;
   reg               restore_edge_macb39;
   reg               pwr1_on_macb39;
   reg               pwr2_on_macb39;
   wire              pwr1_off_macb39;
   wire              pwr2_off_macb39;

   wire core06v9;
   wire core08v9;
   wire core10v9;
   wire core12v9;



`endif
//##############################################################################
// black9 boxed9 defines9 
//##############################################################################

endmodule
