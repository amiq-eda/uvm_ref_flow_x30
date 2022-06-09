//File10 name   : power_ctrl_veneer10.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------
module power_ctrl_veneer10 (
    //------------------------------------
    // Clocks10 & Reset10
    //------------------------------------
    pclk10,
    nprst10,
    //------------------------------------
    // APB10 programming10 interface
    //------------------------------------
    paddr10,
    psel10,
    penable10,
    pwrite10,
    pwdata10,
    prdata10,
    // mac10 i/f,
    macb3_wakeup10,
    macb2_wakeup10,
    macb1_wakeup10,
    macb0_wakeup10,
    //------------------------------------
    // Scan10 
    //------------------------------------
    scan_in10,
    scan_en10,
    scan_mode10,
    scan_out10,
    int_source_h10,
    //------------------------------------
    // Module10 control10 outputs10
    //------------------------------------
    // SMC10
    rstn_non_srpg_smc10,
    gate_clk_smc10,
    isolate_smc10,
    save_edge_smc10,
    restore_edge_smc10,
    pwr1_on_smc10,
    pwr2_on_smc10,
    // URT10
    rstn_non_srpg_urt10,
    gate_clk_urt10,
    isolate_urt10,
    save_edge_urt10,
    restore_edge_urt10,
    pwr1_on_urt10,
    pwr2_on_urt10,
    // ETH010
    rstn_non_srpg_macb010,
    gate_clk_macb010,
    isolate_macb010,
    save_edge_macb010,
    restore_edge_macb010,
    pwr1_on_macb010,
    pwr2_on_macb010,
    // ETH110
    rstn_non_srpg_macb110,
    gate_clk_macb110,
    isolate_macb110,
    save_edge_macb110,
    restore_edge_macb110,
    pwr1_on_macb110,
    pwr2_on_macb110,
    // ETH210
    rstn_non_srpg_macb210,
    gate_clk_macb210,
    isolate_macb210,
    save_edge_macb210,
    restore_edge_macb210,
    pwr1_on_macb210,
    pwr2_on_macb210,
    // ETH310
    rstn_non_srpg_macb310,
    gate_clk_macb310,
    isolate_macb310,
    save_edge_macb310,
    restore_edge_macb310,
    pwr1_on_macb310,
    pwr2_on_macb310,
    // core10 dvfs10 transitions10
    core06v10,
    core08v10,
    core10v10,
    core12v10,
    pcm_macb_wakeup_int10,
    isolate_mem10,
    
    // transit10 signals10
    mte_smc_start10,
    mte_uart_start10,
    mte_smc_uart_start10,  
    mte_pm_smc_to_default_start10, 
    mte_pm_uart_to_default_start10,
    mte_pm_smc_uart_to_default_start10
  );

//------------------------------------------------------------------------------
// I10/O10 declaration10
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks10 & Reset10
   //------------------------------------
   input             pclk10;
   input             nprst10;
   //------------------------------------
   // APB10 programming10 interface;
   //------------------------------------
   input  [31:0]     paddr10;
   input             psel10;
   input             penable10;
   input             pwrite10;
   input  [31:0]     pwdata10;
   output [31:0]     prdata10;
    // mac10
   input macb3_wakeup10;
   input macb2_wakeup10;
   input macb1_wakeup10;
   input macb0_wakeup10;
   //------------------------------------
   // Scan10
   //------------------------------------
   input             scan_in10;
   input             scan_en10;
   input             scan_mode10;
   output            scan_out10;
   //------------------------------------
   // Module10 control10 outputs10
   input             int_source_h10;
   //------------------------------------
   // SMC10
   output            rstn_non_srpg_smc10;
   output            gate_clk_smc10;
   output            isolate_smc10;
   output            save_edge_smc10;
   output            restore_edge_smc10;
   output            pwr1_on_smc10;
   output            pwr2_on_smc10;
   // URT10
   output            rstn_non_srpg_urt10;
   output            gate_clk_urt10;
   output            isolate_urt10;
   output            save_edge_urt10;
   output            restore_edge_urt10;
   output            pwr1_on_urt10;
   output            pwr2_on_urt10;
   // ETH010
   output            rstn_non_srpg_macb010;
   output            gate_clk_macb010;
   output            isolate_macb010;
   output            save_edge_macb010;
   output            restore_edge_macb010;
   output            pwr1_on_macb010;
   output            pwr2_on_macb010;
   // ETH110
   output            rstn_non_srpg_macb110;
   output            gate_clk_macb110;
   output            isolate_macb110;
   output            save_edge_macb110;
   output            restore_edge_macb110;
   output            pwr1_on_macb110;
   output            pwr2_on_macb110;
   // ETH210
   output            rstn_non_srpg_macb210;
   output            gate_clk_macb210;
   output            isolate_macb210;
   output            save_edge_macb210;
   output            restore_edge_macb210;
   output            pwr1_on_macb210;
   output            pwr2_on_macb210;
   // ETH310
   output            rstn_non_srpg_macb310;
   output            gate_clk_macb310;
   output            isolate_macb310;
   output            save_edge_macb310;
   output            restore_edge_macb310;
   output            pwr1_on_macb310;
   output            pwr2_on_macb310;

   // dvfs10
   output core06v10;
   output core08v10;
   output core10v10;
   output core12v10;
   output pcm_macb_wakeup_int10 ;
   output isolate_mem10 ;

   //transit10  signals10
   output mte_smc_start10;
   output mte_uart_start10;
   output mte_smc_uart_start10;  
   output mte_pm_smc_to_default_start10; 
   output mte_pm_uart_to_default_start10;
   output mte_pm_smc_uart_to_default_start10;



//##############################################################################
// if the POWER_CTRL10 is NOT10 black10 boxed10 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL10

power_ctrl10 i_power_ctrl10(
    // -- Clocks10 & Reset10
    	.pclk10(pclk10), 			//  : in  std_logic10;
    	.nprst10(nprst10), 		//  : in  std_logic10;
    // -- APB10 programming10 interface
    	.paddr10(paddr10), 			//  : in  std_logic_vector10(31 downto10 0);
    	.psel10(psel10), 			//  : in  std_logic10;
    	.penable10(penable10), 		//  : in  std_logic10;
    	.pwrite10(pwrite10), 		//  : in  std_logic10;
    	.pwdata10(pwdata10), 		//  : in  std_logic_vector10(31 downto10 0);
    	.prdata10(prdata10), 		//  : out std_logic_vector10(31 downto10 0);
        .macb3_wakeup10(macb3_wakeup10),
        .macb2_wakeup10(macb2_wakeup10),
        .macb1_wakeup10(macb1_wakeup10),
        .macb0_wakeup10(macb0_wakeup10),
    // -- Module10 control10 outputs10
    	.scan_in10(),			//  : in  std_logic10;
    	.scan_en10(scan_en10),             	//  : in  std_logic10;
    	.scan_mode10(scan_mode10),          //  : in  std_logic10;
    	.scan_out10(),            	//  : out std_logic10;
    	.int_source_h10(int_source_h10),    //  : out std_logic10;
     	.rstn_non_srpg_smc10(rstn_non_srpg_smc10), 		//   : out std_logic10;
    	.gate_clk_smc10(gate_clk_smc10), 	//  : out std_logic10;
    	.isolate_smc10(isolate_smc10), 	//  : out std_logic10;
    	.save_edge_smc10(save_edge_smc10), 	//  : out std_logic10;
    	.restore_edge_smc10(restore_edge_smc10), 	//  : out std_logic10;
    	.pwr1_on_smc10(pwr1_on_smc10), 	//  : out std_logic10;
    	.pwr2_on_smc10(pwr2_on_smc10), 	//  : out std_logic10
	.pwr1_off_smc10(pwr1_off_smc10), 	//  : out std_logic10;
    	.pwr2_off_smc10(pwr2_off_smc10), 	//  : out std_logic10
     	.rstn_non_srpg_urt10(rstn_non_srpg_urt10), 		//   : out std_logic10;
    	.gate_clk_urt10(gate_clk_urt10), 	//  : out std_logic10;
    	.isolate_urt10(isolate_urt10), 	//  : out std_logic10;
    	.save_edge_urt10(save_edge_urt10), 	//  : out std_logic10;
    	.restore_edge_urt10(restore_edge_urt10), 	//  : out std_logic10;
    	.pwr1_on_urt10(pwr1_on_urt10), 	//  : out std_logic10;
    	.pwr2_on_urt10(pwr2_on_urt10), 	//  : out std_logic10;
    	.pwr1_off_urt10(pwr1_off_urt10),    //  : out std_logic10;
    	.pwr2_off_urt10(pwr2_off_urt10),     //  : out std_logic10
     	.rstn_non_srpg_macb010(rstn_non_srpg_macb010), 		//   : out std_logic10;
    	.gate_clk_macb010(gate_clk_macb010), 	//  : out std_logic10;
    	.isolate_macb010(isolate_macb010), 	//  : out std_logic10;
    	.save_edge_macb010(save_edge_macb010), 	//  : out std_logic10;
    	.restore_edge_macb010(restore_edge_macb010), 	//  : out std_logic10;
    	.pwr1_on_macb010(pwr1_on_macb010), 	//  : out std_logic10;
    	.pwr2_on_macb010(pwr2_on_macb010), 	//  : out std_logic10;
    	.pwr1_off_macb010(pwr1_off_macb010),    //  : out std_logic10;
    	.pwr2_off_macb010(pwr2_off_macb010),     //  : out std_logic10
     	.rstn_non_srpg_macb110(rstn_non_srpg_macb110), 		//   : out std_logic10;
    	.gate_clk_macb110(gate_clk_macb110), 	//  : out std_logic10;
    	.isolate_macb110(isolate_macb110), 	//  : out std_logic10;
    	.save_edge_macb110(save_edge_macb110), 	//  : out std_logic10;
    	.restore_edge_macb110(restore_edge_macb110), 	//  : out std_logic10;
    	.pwr1_on_macb110(pwr1_on_macb110), 	//  : out std_logic10;
    	.pwr2_on_macb110(pwr2_on_macb110), 	//  : out std_logic10;
    	.pwr1_off_macb110(pwr1_off_macb110),    //  : out std_logic10;
    	.pwr2_off_macb110(pwr2_off_macb110),     //  : out std_logic10
     	.rstn_non_srpg_macb210(rstn_non_srpg_macb210), 		//   : out std_logic10;
    	.gate_clk_macb210(gate_clk_macb210), 	//  : out std_logic10;
    	.isolate_macb210(isolate_macb210), 	//  : out std_logic10;
    	.save_edge_macb210(save_edge_macb210), 	//  : out std_logic10;
    	.restore_edge_macb210(restore_edge_macb210), 	//  : out std_logic10;
    	.pwr1_on_macb210(pwr1_on_macb210), 	//  : out std_logic10;
    	.pwr2_on_macb210(pwr2_on_macb210), 	//  : out std_logic10;
    	.pwr1_off_macb210(pwr1_off_macb210),    //  : out std_logic10;
    	.pwr2_off_macb210(pwr2_off_macb210),     //  : out std_logic10
     	.rstn_non_srpg_macb310(rstn_non_srpg_macb310), 		//   : out std_logic10;
    	.gate_clk_macb310(gate_clk_macb310), 	//  : out std_logic10;
    	.isolate_macb310(isolate_macb310), 	//  : out std_logic10;
    	.save_edge_macb310(save_edge_macb310), 	//  : out std_logic10;
    	.restore_edge_macb310(restore_edge_macb310), 	//  : out std_logic10;
    	.pwr1_on_macb310(pwr1_on_macb310), 	//  : out std_logic10;
    	.pwr2_on_macb310(pwr2_on_macb310), 	//  : out std_logic10;
    	.pwr1_off_macb310(pwr1_off_macb310),    //  : out std_logic10;
    	.pwr2_off_macb310(pwr2_off_macb310),     //  : out std_logic10
        .rstn_non_srpg_dma10(rstn_non_srpg_dma10 ) ,
        .gate_clk_dma10(gate_clk_dma10      )      ,
        .isolate_dma10(isolate_dma10       )       ,
        .save_edge_dma10(save_edge_dma10   )   ,
        .restore_edge_dma10(restore_edge_dma10   )   ,
        .pwr1_on_dma10(pwr1_on_dma10       )       ,
        .pwr2_on_dma10(pwr2_on_dma10       )       ,
        .pwr1_off_dma10(pwr1_off_dma10      )      ,
        .pwr2_off_dma10(pwr2_off_dma10      )      ,
        
        .rstn_non_srpg_cpu10(rstn_non_srpg_cpu10 ) ,
        .gate_clk_cpu10(gate_clk_cpu10      )      ,
        .isolate_cpu10(isolate_cpu10       )       ,
        .save_edge_cpu10(save_edge_cpu10   )   ,
        .restore_edge_cpu10(restore_edge_cpu10   )   ,
        .pwr1_on_cpu10(pwr1_on_cpu10       )       ,
        .pwr2_on_cpu10(pwr2_on_cpu10       )       ,
        .pwr1_off_cpu10(pwr1_off_cpu10      )      ,
        .pwr2_off_cpu10(pwr2_off_cpu10      )      ,
        
        .rstn_non_srpg_alut10(rstn_non_srpg_alut10 ) ,
        .gate_clk_alut10(gate_clk_alut10      )      ,
        .isolate_alut10(isolate_alut10       )       ,
        .save_edge_alut10(save_edge_alut10   )   ,
        .restore_edge_alut10(restore_edge_alut10   )   ,
        .pwr1_on_alut10(pwr1_on_alut10       )       ,
        .pwr2_on_alut10(pwr2_on_alut10       )       ,
        .pwr1_off_alut10(pwr1_off_alut10      )      ,
        .pwr2_off_alut10(pwr2_off_alut10      )      ,
        
        .rstn_non_srpg_mem10(rstn_non_srpg_mem10 ) ,
        .gate_clk_mem10(gate_clk_mem10      )      ,
        .isolate_mem10(isolate_mem10       )       ,
        .save_edge_mem10(save_edge_mem10   )   ,
        .restore_edge_mem10(restore_edge_mem10   )   ,
        .pwr1_on_mem10(pwr1_on_mem10       )       ,
        .pwr2_on_mem10(pwr2_on_mem10       )       ,
        .pwr1_off_mem10(pwr1_off_mem10      )      ,
        .pwr2_off_mem10(pwr2_off_mem10      )      ,

    	.core06v10(core06v10),     //  : out std_logic10
    	.core08v10(core08v10),     //  : out std_logic10
    	.core10v10(core10v10),     //  : out std_logic10
    	.core12v10(core12v10),     //  : out std_logic10
        .pcm_macb_wakeup_int10(pcm_macb_wakeup_int10),
        .mte_smc_start10(mte_smc_start10),
        .mte_uart_start10(mte_uart_start10),
        .mte_smc_uart_start10(mte_smc_uart_start10),  
        .mte_pm_smc_to_default_start10(mte_pm_smc_to_default_start10), 
        .mte_pm_uart_to_default_start10(mte_pm_uart_to_default_start10),
        .mte_pm_smc_uart_to_default_start10(mte_pm_smc_uart_to_default_start10)
);


`else 
//##############################################################################
// if the POWER_CTRL10 is black10 boxed10 
//##############################################################################

   //------------------------------------
   // Clocks10 & Reset10
   //------------------------------------
   wire              pclk10;
   wire              nprst10;
   //------------------------------------
   // APB10 programming10 interface;
   //------------------------------------
   wire   [31:0]     paddr10;
   wire              psel10;
   wire              penable10;
   wire              pwrite10;
   wire   [31:0]     pwdata10;
   reg    [31:0]     prdata10;
   //------------------------------------
   // Scan10
   //------------------------------------
   wire              scan_in10;
   wire              scan_en10;
   wire              scan_mode10;
   reg               scan_out10;
   //------------------------------------
   // Module10 control10 outputs10
   //------------------------------------
   // SMC10;
   reg               rstn_non_srpg_smc10;
   reg               gate_clk_smc10;
   reg               isolate_smc10;
   reg               save_edge_smc10;
   reg               restore_edge_smc10;
   reg               pwr1_on_smc10;
   reg               pwr2_on_smc10;
   wire              pwr1_off_smc10;
   wire              pwr2_off_smc10;

   // URT10;
   reg               rstn_non_srpg_urt10;
   reg               gate_clk_urt10;
   reg               isolate_urt10;
   reg               save_edge_urt10;
   reg               restore_edge_urt10;
   reg               pwr1_on_urt10;
   reg               pwr2_on_urt10;
   wire              pwr1_off_urt10;
   wire              pwr2_off_urt10;

   // ETH010
   reg               rstn_non_srpg_macb010;
   reg               gate_clk_macb010;
   reg               isolate_macb010;
   reg               save_edge_macb010;
   reg               restore_edge_macb010;
   reg               pwr1_on_macb010;
   reg               pwr2_on_macb010;
   wire              pwr1_off_macb010;
   wire              pwr2_off_macb010;
   // ETH110
   reg               rstn_non_srpg_macb110;
   reg               gate_clk_macb110;
   reg               isolate_macb110;
   reg               save_edge_macb110;
   reg               restore_edge_macb110;
   reg               pwr1_on_macb110;
   reg               pwr2_on_macb110;
   wire              pwr1_off_macb110;
   wire              pwr2_off_macb110;
   // ETH210
   reg               rstn_non_srpg_macb210;
   reg               gate_clk_macb210;
   reg               isolate_macb210;
   reg               save_edge_macb210;
   reg               restore_edge_macb210;
   reg               pwr1_on_macb210;
   reg               pwr2_on_macb210;
   wire              pwr1_off_macb210;
   wire              pwr2_off_macb210;
   // ETH310
   reg               rstn_non_srpg_macb310;
   reg               gate_clk_macb310;
   reg               isolate_macb310;
   reg               save_edge_macb310;
   reg               restore_edge_macb310;
   reg               pwr1_on_macb310;
   reg               pwr2_on_macb310;
   wire              pwr1_off_macb310;
   wire              pwr2_off_macb310;

   wire core06v10;
   wire core08v10;
   wire core10v10;
   wire core12v10;



`endif
//##############################################################################
// black10 boxed10 defines10 
//##############################################################################

endmodule
