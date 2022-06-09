//File15 name   : power_ctrl_veneer15.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------
module power_ctrl_veneer15 (
    //------------------------------------
    // Clocks15 & Reset15
    //------------------------------------
    pclk15,
    nprst15,
    //------------------------------------
    // APB15 programming15 interface
    //------------------------------------
    paddr15,
    psel15,
    penable15,
    pwrite15,
    pwdata15,
    prdata15,
    // mac15 i/f,
    macb3_wakeup15,
    macb2_wakeup15,
    macb1_wakeup15,
    macb0_wakeup15,
    //------------------------------------
    // Scan15 
    //------------------------------------
    scan_in15,
    scan_en15,
    scan_mode15,
    scan_out15,
    int_source_h15,
    //------------------------------------
    // Module15 control15 outputs15
    //------------------------------------
    // SMC15
    rstn_non_srpg_smc15,
    gate_clk_smc15,
    isolate_smc15,
    save_edge_smc15,
    restore_edge_smc15,
    pwr1_on_smc15,
    pwr2_on_smc15,
    // URT15
    rstn_non_srpg_urt15,
    gate_clk_urt15,
    isolate_urt15,
    save_edge_urt15,
    restore_edge_urt15,
    pwr1_on_urt15,
    pwr2_on_urt15,
    // ETH015
    rstn_non_srpg_macb015,
    gate_clk_macb015,
    isolate_macb015,
    save_edge_macb015,
    restore_edge_macb015,
    pwr1_on_macb015,
    pwr2_on_macb015,
    // ETH115
    rstn_non_srpg_macb115,
    gate_clk_macb115,
    isolate_macb115,
    save_edge_macb115,
    restore_edge_macb115,
    pwr1_on_macb115,
    pwr2_on_macb115,
    // ETH215
    rstn_non_srpg_macb215,
    gate_clk_macb215,
    isolate_macb215,
    save_edge_macb215,
    restore_edge_macb215,
    pwr1_on_macb215,
    pwr2_on_macb215,
    // ETH315
    rstn_non_srpg_macb315,
    gate_clk_macb315,
    isolate_macb315,
    save_edge_macb315,
    restore_edge_macb315,
    pwr1_on_macb315,
    pwr2_on_macb315,
    // core15 dvfs15 transitions15
    core06v15,
    core08v15,
    core10v15,
    core12v15,
    pcm_macb_wakeup_int15,
    isolate_mem15,
    
    // transit15 signals15
    mte_smc_start15,
    mte_uart_start15,
    mte_smc_uart_start15,  
    mte_pm_smc_to_default_start15, 
    mte_pm_uart_to_default_start15,
    mte_pm_smc_uart_to_default_start15
  );

//------------------------------------------------------------------------------
// I15/O15 declaration15
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks15 & Reset15
   //------------------------------------
   input             pclk15;
   input             nprst15;
   //------------------------------------
   // APB15 programming15 interface;
   //------------------------------------
   input  [31:0]     paddr15;
   input             psel15;
   input             penable15;
   input             pwrite15;
   input  [31:0]     pwdata15;
   output [31:0]     prdata15;
    // mac15
   input macb3_wakeup15;
   input macb2_wakeup15;
   input macb1_wakeup15;
   input macb0_wakeup15;
   //------------------------------------
   // Scan15
   //------------------------------------
   input             scan_in15;
   input             scan_en15;
   input             scan_mode15;
   output            scan_out15;
   //------------------------------------
   // Module15 control15 outputs15
   input             int_source_h15;
   //------------------------------------
   // SMC15
   output            rstn_non_srpg_smc15;
   output            gate_clk_smc15;
   output            isolate_smc15;
   output            save_edge_smc15;
   output            restore_edge_smc15;
   output            pwr1_on_smc15;
   output            pwr2_on_smc15;
   // URT15
   output            rstn_non_srpg_urt15;
   output            gate_clk_urt15;
   output            isolate_urt15;
   output            save_edge_urt15;
   output            restore_edge_urt15;
   output            pwr1_on_urt15;
   output            pwr2_on_urt15;
   // ETH015
   output            rstn_non_srpg_macb015;
   output            gate_clk_macb015;
   output            isolate_macb015;
   output            save_edge_macb015;
   output            restore_edge_macb015;
   output            pwr1_on_macb015;
   output            pwr2_on_macb015;
   // ETH115
   output            rstn_non_srpg_macb115;
   output            gate_clk_macb115;
   output            isolate_macb115;
   output            save_edge_macb115;
   output            restore_edge_macb115;
   output            pwr1_on_macb115;
   output            pwr2_on_macb115;
   // ETH215
   output            rstn_non_srpg_macb215;
   output            gate_clk_macb215;
   output            isolate_macb215;
   output            save_edge_macb215;
   output            restore_edge_macb215;
   output            pwr1_on_macb215;
   output            pwr2_on_macb215;
   // ETH315
   output            rstn_non_srpg_macb315;
   output            gate_clk_macb315;
   output            isolate_macb315;
   output            save_edge_macb315;
   output            restore_edge_macb315;
   output            pwr1_on_macb315;
   output            pwr2_on_macb315;

   // dvfs15
   output core06v15;
   output core08v15;
   output core10v15;
   output core12v15;
   output pcm_macb_wakeup_int15 ;
   output isolate_mem15 ;

   //transit15  signals15
   output mte_smc_start15;
   output mte_uart_start15;
   output mte_smc_uart_start15;  
   output mte_pm_smc_to_default_start15; 
   output mte_pm_uart_to_default_start15;
   output mte_pm_smc_uart_to_default_start15;



//##############################################################################
// if the POWER_CTRL15 is NOT15 black15 boxed15 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL15

power_ctrl15 i_power_ctrl15(
    // -- Clocks15 & Reset15
    	.pclk15(pclk15), 			//  : in  std_logic15;
    	.nprst15(nprst15), 		//  : in  std_logic15;
    // -- APB15 programming15 interface
    	.paddr15(paddr15), 			//  : in  std_logic_vector15(31 downto15 0);
    	.psel15(psel15), 			//  : in  std_logic15;
    	.penable15(penable15), 		//  : in  std_logic15;
    	.pwrite15(pwrite15), 		//  : in  std_logic15;
    	.pwdata15(pwdata15), 		//  : in  std_logic_vector15(31 downto15 0);
    	.prdata15(prdata15), 		//  : out std_logic_vector15(31 downto15 0);
        .macb3_wakeup15(macb3_wakeup15),
        .macb2_wakeup15(macb2_wakeup15),
        .macb1_wakeup15(macb1_wakeup15),
        .macb0_wakeup15(macb0_wakeup15),
    // -- Module15 control15 outputs15
    	.scan_in15(),			//  : in  std_logic15;
    	.scan_en15(scan_en15),             	//  : in  std_logic15;
    	.scan_mode15(scan_mode15),          //  : in  std_logic15;
    	.scan_out15(),            	//  : out std_logic15;
    	.int_source_h15(int_source_h15),    //  : out std_logic15;
     	.rstn_non_srpg_smc15(rstn_non_srpg_smc15), 		//   : out std_logic15;
    	.gate_clk_smc15(gate_clk_smc15), 	//  : out std_logic15;
    	.isolate_smc15(isolate_smc15), 	//  : out std_logic15;
    	.save_edge_smc15(save_edge_smc15), 	//  : out std_logic15;
    	.restore_edge_smc15(restore_edge_smc15), 	//  : out std_logic15;
    	.pwr1_on_smc15(pwr1_on_smc15), 	//  : out std_logic15;
    	.pwr2_on_smc15(pwr2_on_smc15), 	//  : out std_logic15
	.pwr1_off_smc15(pwr1_off_smc15), 	//  : out std_logic15;
    	.pwr2_off_smc15(pwr2_off_smc15), 	//  : out std_logic15
     	.rstn_non_srpg_urt15(rstn_non_srpg_urt15), 		//   : out std_logic15;
    	.gate_clk_urt15(gate_clk_urt15), 	//  : out std_logic15;
    	.isolate_urt15(isolate_urt15), 	//  : out std_logic15;
    	.save_edge_urt15(save_edge_urt15), 	//  : out std_logic15;
    	.restore_edge_urt15(restore_edge_urt15), 	//  : out std_logic15;
    	.pwr1_on_urt15(pwr1_on_urt15), 	//  : out std_logic15;
    	.pwr2_on_urt15(pwr2_on_urt15), 	//  : out std_logic15;
    	.pwr1_off_urt15(pwr1_off_urt15),    //  : out std_logic15;
    	.pwr2_off_urt15(pwr2_off_urt15),     //  : out std_logic15
     	.rstn_non_srpg_macb015(rstn_non_srpg_macb015), 		//   : out std_logic15;
    	.gate_clk_macb015(gate_clk_macb015), 	//  : out std_logic15;
    	.isolate_macb015(isolate_macb015), 	//  : out std_logic15;
    	.save_edge_macb015(save_edge_macb015), 	//  : out std_logic15;
    	.restore_edge_macb015(restore_edge_macb015), 	//  : out std_logic15;
    	.pwr1_on_macb015(pwr1_on_macb015), 	//  : out std_logic15;
    	.pwr2_on_macb015(pwr2_on_macb015), 	//  : out std_logic15;
    	.pwr1_off_macb015(pwr1_off_macb015),    //  : out std_logic15;
    	.pwr2_off_macb015(pwr2_off_macb015),     //  : out std_logic15
     	.rstn_non_srpg_macb115(rstn_non_srpg_macb115), 		//   : out std_logic15;
    	.gate_clk_macb115(gate_clk_macb115), 	//  : out std_logic15;
    	.isolate_macb115(isolate_macb115), 	//  : out std_logic15;
    	.save_edge_macb115(save_edge_macb115), 	//  : out std_logic15;
    	.restore_edge_macb115(restore_edge_macb115), 	//  : out std_logic15;
    	.pwr1_on_macb115(pwr1_on_macb115), 	//  : out std_logic15;
    	.pwr2_on_macb115(pwr2_on_macb115), 	//  : out std_logic15;
    	.pwr1_off_macb115(pwr1_off_macb115),    //  : out std_logic15;
    	.pwr2_off_macb115(pwr2_off_macb115),     //  : out std_logic15
     	.rstn_non_srpg_macb215(rstn_non_srpg_macb215), 		//   : out std_logic15;
    	.gate_clk_macb215(gate_clk_macb215), 	//  : out std_logic15;
    	.isolate_macb215(isolate_macb215), 	//  : out std_logic15;
    	.save_edge_macb215(save_edge_macb215), 	//  : out std_logic15;
    	.restore_edge_macb215(restore_edge_macb215), 	//  : out std_logic15;
    	.pwr1_on_macb215(pwr1_on_macb215), 	//  : out std_logic15;
    	.pwr2_on_macb215(pwr2_on_macb215), 	//  : out std_logic15;
    	.pwr1_off_macb215(pwr1_off_macb215),    //  : out std_logic15;
    	.pwr2_off_macb215(pwr2_off_macb215),     //  : out std_logic15
     	.rstn_non_srpg_macb315(rstn_non_srpg_macb315), 		//   : out std_logic15;
    	.gate_clk_macb315(gate_clk_macb315), 	//  : out std_logic15;
    	.isolate_macb315(isolate_macb315), 	//  : out std_logic15;
    	.save_edge_macb315(save_edge_macb315), 	//  : out std_logic15;
    	.restore_edge_macb315(restore_edge_macb315), 	//  : out std_logic15;
    	.pwr1_on_macb315(pwr1_on_macb315), 	//  : out std_logic15;
    	.pwr2_on_macb315(pwr2_on_macb315), 	//  : out std_logic15;
    	.pwr1_off_macb315(pwr1_off_macb315),    //  : out std_logic15;
    	.pwr2_off_macb315(pwr2_off_macb315),     //  : out std_logic15
        .rstn_non_srpg_dma15(rstn_non_srpg_dma15 ) ,
        .gate_clk_dma15(gate_clk_dma15      )      ,
        .isolate_dma15(isolate_dma15       )       ,
        .save_edge_dma15(save_edge_dma15   )   ,
        .restore_edge_dma15(restore_edge_dma15   )   ,
        .pwr1_on_dma15(pwr1_on_dma15       )       ,
        .pwr2_on_dma15(pwr2_on_dma15       )       ,
        .pwr1_off_dma15(pwr1_off_dma15      )      ,
        .pwr2_off_dma15(pwr2_off_dma15      )      ,
        
        .rstn_non_srpg_cpu15(rstn_non_srpg_cpu15 ) ,
        .gate_clk_cpu15(gate_clk_cpu15      )      ,
        .isolate_cpu15(isolate_cpu15       )       ,
        .save_edge_cpu15(save_edge_cpu15   )   ,
        .restore_edge_cpu15(restore_edge_cpu15   )   ,
        .pwr1_on_cpu15(pwr1_on_cpu15       )       ,
        .pwr2_on_cpu15(pwr2_on_cpu15       )       ,
        .pwr1_off_cpu15(pwr1_off_cpu15      )      ,
        .pwr2_off_cpu15(pwr2_off_cpu15      )      ,
        
        .rstn_non_srpg_alut15(rstn_non_srpg_alut15 ) ,
        .gate_clk_alut15(gate_clk_alut15      )      ,
        .isolate_alut15(isolate_alut15       )       ,
        .save_edge_alut15(save_edge_alut15   )   ,
        .restore_edge_alut15(restore_edge_alut15   )   ,
        .pwr1_on_alut15(pwr1_on_alut15       )       ,
        .pwr2_on_alut15(pwr2_on_alut15       )       ,
        .pwr1_off_alut15(pwr1_off_alut15      )      ,
        .pwr2_off_alut15(pwr2_off_alut15      )      ,
        
        .rstn_non_srpg_mem15(rstn_non_srpg_mem15 ) ,
        .gate_clk_mem15(gate_clk_mem15      )      ,
        .isolate_mem15(isolate_mem15       )       ,
        .save_edge_mem15(save_edge_mem15   )   ,
        .restore_edge_mem15(restore_edge_mem15   )   ,
        .pwr1_on_mem15(pwr1_on_mem15       )       ,
        .pwr2_on_mem15(pwr2_on_mem15       )       ,
        .pwr1_off_mem15(pwr1_off_mem15      )      ,
        .pwr2_off_mem15(pwr2_off_mem15      )      ,

    	.core06v15(core06v15),     //  : out std_logic15
    	.core08v15(core08v15),     //  : out std_logic15
    	.core10v15(core10v15),     //  : out std_logic15
    	.core12v15(core12v15),     //  : out std_logic15
        .pcm_macb_wakeup_int15(pcm_macb_wakeup_int15),
        .mte_smc_start15(mte_smc_start15),
        .mte_uart_start15(mte_uart_start15),
        .mte_smc_uart_start15(mte_smc_uart_start15),  
        .mte_pm_smc_to_default_start15(mte_pm_smc_to_default_start15), 
        .mte_pm_uart_to_default_start15(mte_pm_uart_to_default_start15),
        .mte_pm_smc_uart_to_default_start15(mte_pm_smc_uart_to_default_start15)
);


`else 
//##############################################################################
// if the POWER_CTRL15 is black15 boxed15 
//##############################################################################

   //------------------------------------
   // Clocks15 & Reset15
   //------------------------------------
   wire              pclk15;
   wire              nprst15;
   //------------------------------------
   // APB15 programming15 interface;
   //------------------------------------
   wire   [31:0]     paddr15;
   wire              psel15;
   wire              penable15;
   wire              pwrite15;
   wire   [31:0]     pwdata15;
   reg    [31:0]     prdata15;
   //------------------------------------
   // Scan15
   //------------------------------------
   wire              scan_in15;
   wire              scan_en15;
   wire              scan_mode15;
   reg               scan_out15;
   //------------------------------------
   // Module15 control15 outputs15
   //------------------------------------
   // SMC15;
   reg               rstn_non_srpg_smc15;
   reg               gate_clk_smc15;
   reg               isolate_smc15;
   reg               save_edge_smc15;
   reg               restore_edge_smc15;
   reg               pwr1_on_smc15;
   reg               pwr2_on_smc15;
   wire              pwr1_off_smc15;
   wire              pwr2_off_smc15;

   // URT15;
   reg               rstn_non_srpg_urt15;
   reg               gate_clk_urt15;
   reg               isolate_urt15;
   reg               save_edge_urt15;
   reg               restore_edge_urt15;
   reg               pwr1_on_urt15;
   reg               pwr2_on_urt15;
   wire              pwr1_off_urt15;
   wire              pwr2_off_urt15;

   // ETH015
   reg               rstn_non_srpg_macb015;
   reg               gate_clk_macb015;
   reg               isolate_macb015;
   reg               save_edge_macb015;
   reg               restore_edge_macb015;
   reg               pwr1_on_macb015;
   reg               pwr2_on_macb015;
   wire              pwr1_off_macb015;
   wire              pwr2_off_macb015;
   // ETH115
   reg               rstn_non_srpg_macb115;
   reg               gate_clk_macb115;
   reg               isolate_macb115;
   reg               save_edge_macb115;
   reg               restore_edge_macb115;
   reg               pwr1_on_macb115;
   reg               pwr2_on_macb115;
   wire              pwr1_off_macb115;
   wire              pwr2_off_macb115;
   // ETH215
   reg               rstn_non_srpg_macb215;
   reg               gate_clk_macb215;
   reg               isolate_macb215;
   reg               save_edge_macb215;
   reg               restore_edge_macb215;
   reg               pwr1_on_macb215;
   reg               pwr2_on_macb215;
   wire              pwr1_off_macb215;
   wire              pwr2_off_macb215;
   // ETH315
   reg               rstn_non_srpg_macb315;
   reg               gate_clk_macb315;
   reg               isolate_macb315;
   reg               save_edge_macb315;
   reg               restore_edge_macb315;
   reg               pwr1_on_macb315;
   reg               pwr2_on_macb315;
   wire              pwr1_off_macb315;
   wire              pwr2_off_macb315;

   wire core06v15;
   wire core08v15;
   wire core10v15;
   wire core12v15;



`endif
//##############################################################################
// black15 boxed15 defines15 
//##############################################################################

endmodule
