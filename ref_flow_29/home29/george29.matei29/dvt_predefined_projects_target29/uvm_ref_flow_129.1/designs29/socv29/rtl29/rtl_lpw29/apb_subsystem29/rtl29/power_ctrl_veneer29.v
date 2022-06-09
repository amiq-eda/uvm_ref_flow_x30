//File29 name   : power_ctrl_veneer29.v
//Title29       : 
//Created29     : 1999
//Description29 : 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------
module power_ctrl_veneer29 (
    //------------------------------------
    // Clocks29 & Reset29
    //------------------------------------
    pclk29,
    nprst29,
    //------------------------------------
    // APB29 programming29 interface
    //------------------------------------
    paddr29,
    psel29,
    penable29,
    pwrite29,
    pwdata29,
    prdata29,
    // mac29 i/f,
    macb3_wakeup29,
    macb2_wakeup29,
    macb1_wakeup29,
    macb0_wakeup29,
    //------------------------------------
    // Scan29 
    //------------------------------------
    scan_in29,
    scan_en29,
    scan_mode29,
    scan_out29,
    int_source_h29,
    //------------------------------------
    // Module29 control29 outputs29
    //------------------------------------
    // SMC29
    rstn_non_srpg_smc29,
    gate_clk_smc29,
    isolate_smc29,
    save_edge_smc29,
    restore_edge_smc29,
    pwr1_on_smc29,
    pwr2_on_smc29,
    // URT29
    rstn_non_srpg_urt29,
    gate_clk_urt29,
    isolate_urt29,
    save_edge_urt29,
    restore_edge_urt29,
    pwr1_on_urt29,
    pwr2_on_urt29,
    // ETH029
    rstn_non_srpg_macb029,
    gate_clk_macb029,
    isolate_macb029,
    save_edge_macb029,
    restore_edge_macb029,
    pwr1_on_macb029,
    pwr2_on_macb029,
    // ETH129
    rstn_non_srpg_macb129,
    gate_clk_macb129,
    isolate_macb129,
    save_edge_macb129,
    restore_edge_macb129,
    pwr1_on_macb129,
    pwr2_on_macb129,
    // ETH229
    rstn_non_srpg_macb229,
    gate_clk_macb229,
    isolate_macb229,
    save_edge_macb229,
    restore_edge_macb229,
    pwr1_on_macb229,
    pwr2_on_macb229,
    // ETH329
    rstn_non_srpg_macb329,
    gate_clk_macb329,
    isolate_macb329,
    save_edge_macb329,
    restore_edge_macb329,
    pwr1_on_macb329,
    pwr2_on_macb329,
    // core29 dvfs29 transitions29
    core06v29,
    core08v29,
    core10v29,
    core12v29,
    pcm_macb_wakeup_int29,
    isolate_mem29,
    
    // transit29 signals29
    mte_smc_start29,
    mte_uart_start29,
    mte_smc_uart_start29,  
    mte_pm_smc_to_default_start29, 
    mte_pm_uart_to_default_start29,
    mte_pm_smc_uart_to_default_start29
  );

//------------------------------------------------------------------------------
// I29/O29 declaration29
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks29 & Reset29
   //------------------------------------
   input             pclk29;
   input             nprst29;
   //------------------------------------
   // APB29 programming29 interface;
   //------------------------------------
   input  [31:0]     paddr29;
   input             psel29;
   input             penable29;
   input             pwrite29;
   input  [31:0]     pwdata29;
   output [31:0]     prdata29;
    // mac29
   input macb3_wakeup29;
   input macb2_wakeup29;
   input macb1_wakeup29;
   input macb0_wakeup29;
   //------------------------------------
   // Scan29
   //------------------------------------
   input             scan_in29;
   input             scan_en29;
   input             scan_mode29;
   output            scan_out29;
   //------------------------------------
   // Module29 control29 outputs29
   input             int_source_h29;
   //------------------------------------
   // SMC29
   output            rstn_non_srpg_smc29;
   output            gate_clk_smc29;
   output            isolate_smc29;
   output            save_edge_smc29;
   output            restore_edge_smc29;
   output            pwr1_on_smc29;
   output            pwr2_on_smc29;
   // URT29
   output            rstn_non_srpg_urt29;
   output            gate_clk_urt29;
   output            isolate_urt29;
   output            save_edge_urt29;
   output            restore_edge_urt29;
   output            pwr1_on_urt29;
   output            pwr2_on_urt29;
   // ETH029
   output            rstn_non_srpg_macb029;
   output            gate_clk_macb029;
   output            isolate_macb029;
   output            save_edge_macb029;
   output            restore_edge_macb029;
   output            pwr1_on_macb029;
   output            pwr2_on_macb029;
   // ETH129
   output            rstn_non_srpg_macb129;
   output            gate_clk_macb129;
   output            isolate_macb129;
   output            save_edge_macb129;
   output            restore_edge_macb129;
   output            pwr1_on_macb129;
   output            pwr2_on_macb129;
   // ETH229
   output            rstn_non_srpg_macb229;
   output            gate_clk_macb229;
   output            isolate_macb229;
   output            save_edge_macb229;
   output            restore_edge_macb229;
   output            pwr1_on_macb229;
   output            pwr2_on_macb229;
   // ETH329
   output            rstn_non_srpg_macb329;
   output            gate_clk_macb329;
   output            isolate_macb329;
   output            save_edge_macb329;
   output            restore_edge_macb329;
   output            pwr1_on_macb329;
   output            pwr2_on_macb329;

   // dvfs29
   output core06v29;
   output core08v29;
   output core10v29;
   output core12v29;
   output pcm_macb_wakeup_int29 ;
   output isolate_mem29 ;

   //transit29  signals29
   output mte_smc_start29;
   output mte_uart_start29;
   output mte_smc_uart_start29;  
   output mte_pm_smc_to_default_start29; 
   output mte_pm_uart_to_default_start29;
   output mte_pm_smc_uart_to_default_start29;



//##############################################################################
// if the POWER_CTRL29 is NOT29 black29 boxed29 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL29

power_ctrl29 i_power_ctrl29(
    // -- Clocks29 & Reset29
    	.pclk29(pclk29), 			//  : in  std_logic29;
    	.nprst29(nprst29), 		//  : in  std_logic29;
    // -- APB29 programming29 interface
    	.paddr29(paddr29), 			//  : in  std_logic_vector29(31 downto29 0);
    	.psel29(psel29), 			//  : in  std_logic29;
    	.penable29(penable29), 		//  : in  std_logic29;
    	.pwrite29(pwrite29), 		//  : in  std_logic29;
    	.pwdata29(pwdata29), 		//  : in  std_logic_vector29(31 downto29 0);
    	.prdata29(prdata29), 		//  : out std_logic_vector29(31 downto29 0);
        .macb3_wakeup29(macb3_wakeup29),
        .macb2_wakeup29(macb2_wakeup29),
        .macb1_wakeup29(macb1_wakeup29),
        .macb0_wakeup29(macb0_wakeup29),
    // -- Module29 control29 outputs29
    	.scan_in29(),			//  : in  std_logic29;
    	.scan_en29(scan_en29),             	//  : in  std_logic29;
    	.scan_mode29(scan_mode29),          //  : in  std_logic29;
    	.scan_out29(),            	//  : out std_logic29;
    	.int_source_h29(int_source_h29),    //  : out std_logic29;
     	.rstn_non_srpg_smc29(rstn_non_srpg_smc29), 		//   : out std_logic29;
    	.gate_clk_smc29(gate_clk_smc29), 	//  : out std_logic29;
    	.isolate_smc29(isolate_smc29), 	//  : out std_logic29;
    	.save_edge_smc29(save_edge_smc29), 	//  : out std_logic29;
    	.restore_edge_smc29(restore_edge_smc29), 	//  : out std_logic29;
    	.pwr1_on_smc29(pwr1_on_smc29), 	//  : out std_logic29;
    	.pwr2_on_smc29(pwr2_on_smc29), 	//  : out std_logic29
	.pwr1_off_smc29(pwr1_off_smc29), 	//  : out std_logic29;
    	.pwr2_off_smc29(pwr2_off_smc29), 	//  : out std_logic29
     	.rstn_non_srpg_urt29(rstn_non_srpg_urt29), 		//   : out std_logic29;
    	.gate_clk_urt29(gate_clk_urt29), 	//  : out std_logic29;
    	.isolate_urt29(isolate_urt29), 	//  : out std_logic29;
    	.save_edge_urt29(save_edge_urt29), 	//  : out std_logic29;
    	.restore_edge_urt29(restore_edge_urt29), 	//  : out std_logic29;
    	.pwr1_on_urt29(pwr1_on_urt29), 	//  : out std_logic29;
    	.pwr2_on_urt29(pwr2_on_urt29), 	//  : out std_logic29;
    	.pwr1_off_urt29(pwr1_off_urt29),    //  : out std_logic29;
    	.pwr2_off_urt29(pwr2_off_urt29),     //  : out std_logic29
     	.rstn_non_srpg_macb029(rstn_non_srpg_macb029), 		//   : out std_logic29;
    	.gate_clk_macb029(gate_clk_macb029), 	//  : out std_logic29;
    	.isolate_macb029(isolate_macb029), 	//  : out std_logic29;
    	.save_edge_macb029(save_edge_macb029), 	//  : out std_logic29;
    	.restore_edge_macb029(restore_edge_macb029), 	//  : out std_logic29;
    	.pwr1_on_macb029(pwr1_on_macb029), 	//  : out std_logic29;
    	.pwr2_on_macb029(pwr2_on_macb029), 	//  : out std_logic29;
    	.pwr1_off_macb029(pwr1_off_macb029),    //  : out std_logic29;
    	.pwr2_off_macb029(pwr2_off_macb029),     //  : out std_logic29
     	.rstn_non_srpg_macb129(rstn_non_srpg_macb129), 		//   : out std_logic29;
    	.gate_clk_macb129(gate_clk_macb129), 	//  : out std_logic29;
    	.isolate_macb129(isolate_macb129), 	//  : out std_logic29;
    	.save_edge_macb129(save_edge_macb129), 	//  : out std_logic29;
    	.restore_edge_macb129(restore_edge_macb129), 	//  : out std_logic29;
    	.pwr1_on_macb129(pwr1_on_macb129), 	//  : out std_logic29;
    	.pwr2_on_macb129(pwr2_on_macb129), 	//  : out std_logic29;
    	.pwr1_off_macb129(pwr1_off_macb129),    //  : out std_logic29;
    	.pwr2_off_macb129(pwr2_off_macb129),     //  : out std_logic29
     	.rstn_non_srpg_macb229(rstn_non_srpg_macb229), 		//   : out std_logic29;
    	.gate_clk_macb229(gate_clk_macb229), 	//  : out std_logic29;
    	.isolate_macb229(isolate_macb229), 	//  : out std_logic29;
    	.save_edge_macb229(save_edge_macb229), 	//  : out std_logic29;
    	.restore_edge_macb229(restore_edge_macb229), 	//  : out std_logic29;
    	.pwr1_on_macb229(pwr1_on_macb229), 	//  : out std_logic29;
    	.pwr2_on_macb229(pwr2_on_macb229), 	//  : out std_logic29;
    	.pwr1_off_macb229(pwr1_off_macb229),    //  : out std_logic29;
    	.pwr2_off_macb229(pwr2_off_macb229),     //  : out std_logic29
     	.rstn_non_srpg_macb329(rstn_non_srpg_macb329), 		//   : out std_logic29;
    	.gate_clk_macb329(gate_clk_macb329), 	//  : out std_logic29;
    	.isolate_macb329(isolate_macb329), 	//  : out std_logic29;
    	.save_edge_macb329(save_edge_macb329), 	//  : out std_logic29;
    	.restore_edge_macb329(restore_edge_macb329), 	//  : out std_logic29;
    	.pwr1_on_macb329(pwr1_on_macb329), 	//  : out std_logic29;
    	.pwr2_on_macb329(pwr2_on_macb329), 	//  : out std_logic29;
    	.pwr1_off_macb329(pwr1_off_macb329),    //  : out std_logic29;
    	.pwr2_off_macb329(pwr2_off_macb329),     //  : out std_logic29
        .rstn_non_srpg_dma29(rstn_non_srpg_dma29 ) ,
        .gate_clk_dma29(gate_clk_dma29      )      ,
        .isolate_dma29(isolate_dma29       )       ,
        .save_edge_dma29(save_edge_dma29   )   ,
        .restore_edge_dma29(restore_edge_dma29   )   ,
        .pwr1_on_dma29(pwr1_on_dma29       )       ,
        .pwr2_on_dma29(pwr2_on_dma29       )       ,
        .pwr1_off_dma29(pwr1_off_dma29      )      ,
        .pwr2_off_dma29(pwr2_off_dma29      )      ,
        
        .rstn_non_srpg_cpu29(rstn_non_srpg_cpu29 ) ,
        .gate_clk_cpu29(gate_clk_cpu29      )      ,
        .isolate_cpu29(isolate_cpu29       )       ,
        .save_edge_cpu29(save_edge_cpu29   )   ,
        .restore_edge_cpu29(restore_edge_cpu29   )   ,
        .pwr1_on_cpu29(pwr1_on_cpu29       )       ,
        .pwr2_on_cpu29(pwr2_on_cpu29       )       ,
        .pwr1_off_cpu29(pwr1_off_cpu29      )      ,
        .pwr2_off_cpu29(pwr2_off_cpu29      )      ,
        
        .rstn_non_srpg_alut29(rstn_non_srpg_alut29 ) ,
        .gate_clk_alut29(gate_clk_alut29      )      ,
        .isolate_alut29(isolate_alut29       )       ,
        .save_edge_alut29(save_edge_alut29   )   ,
        .restore_edge_alut29(restore_edge_alut29   )   ,
        .pwr1_on_alut29(pwr1_on_alut29       )       ,
        .pwr2_on_alut29(pwr2_on_alut29       )       ,
        .pwr1_off_alut29(pwr1_off_alut29      )      ,
        .pwr2_off_alut29(pwr2_off_alut29      )      ,
        
        .rstn_non_srpg_mem29(rstn_non_srpg_mem29 ) ,
        .gate_clk_mem29(gate_clk_mem29      )      ,
        .isolate_mem29(isolate_mem29       )       ,
        .save_edge_mem29(save_edge_mem29   )   ,
        .restore_edge_mem29(restore_edge_mem29   )   ,
        .pwr1_on_mem29(pwr1_on_mem29       )       ,
        .pwr2_on_mem29(pwr2_on_mem29       )       ,
        .pwr1_off_mem29(pwr1_off_mem29      )      ,
        .pwr2_off_mem29(pwr2_off_mem29      )      ,

    	.core06v29(core06v29),     //  : out std_logic29
    	.core08v29(core08v29),     //  : out std_logic29
    	.core10v29(core10v29),     //  : out std_logic29
    	.core12v29(core12v29),     //  : out std_logic29
        .pcm_macb_wakeup_int29(pcm_macb_wakeup_int29),
        .mte_smc_start29(mte_smc_start29),
        .mte_uart_start29(mte_uart_start29),
        .mte_smc_uart_start29(mte_smc_uart_start29),  
        .mte_pm_smc_to_default_start29(mte_pm_smc_to_default_start29), 
        .mte_pm_uart_to_default_start29(mte_pm_uart_to_default_start29),
        .mte_pm_smc_uart_to_default_start29(mte_pm_smc_uart_to_default_start29)
);


`else 
//##############################################################################
// if the POWER_CTRL29 is black29 boxed29 
//##############################################################################

   //------------------------------------
   // Clocks29 & Reset29
   //------------------------------------
   wire              pclk29;
   wire              nprst29;
   //------------------------------------
   // APB29 programming29 interface;
   //------------------------------------
   wire   [31:0]     paddr29;
   wire              psel29;
   wire              penable29;
   wire              pwrite29;
   wire   [31:0]     pwdata29;
   reg    [31:0]     prdata29;
   //------------------------------------
   // Scan29
   //------------------------------------
   wire              scan_in29;
   wire              scan_en29;
   wire              scan_mode29;
   reg               scan_out29;
   //------------------------------------
   // Module29 control29 outputs29
   //------------------------------------
   // SMC29;
   reg               rstn_non_srpg_smc29;
   reg               gate_clk_smc29;
   reg               isolate_smc29;
   reg               save_edge_smc29;
   reg               restore_edge_smc29;
   reg               pwr1_on_smc29;
   reg               pwr2_on_smc29;
   wire              pwr1_off_smc29;
   wire              pwr2_off_smc29;

   // URT29;
   reg               rstn_non_srpg_urt29;
   reg               gate_clk_urt29;
   reg               isolate_urt29;
   reg               save_edge_urt29;
   reg               restore_edge_urt29;
   reg               pwr1_on_urt29;
   reg               pwr2_on_urt29;
   wire              pwr1_off_urt29;
   wire              pwr2_off_urt29;

   // ETH029
   reg               rstn_non_srpg_macb029;
   reg               gate_clk_macb029;
   reg               isolate_macb029;
   reg               save_edge_macb029;
   reg               restore_edge_macb029;
   reg               pwr1_on_macb029;
   reg               pwr2_on_macb029;
   wire              pwr1_off_macb029;
   wire              pwr2_off_macb029;
   // ETH129
   reg               rstn_non_srpg_macb129;
   reg               gate_clk_macb129;
   reg               isolate_macb129;
   reg               save_edge_macb129;
   reg               restore_edge_macb129;
   reg               pwr1_on_macb129;
   reg               pwr2_on_macb129;
   wire              pwr1_off_macb129;
   wire              pwr2_off_macb129;
   // ETH229
   reg               rstn_non_srpg_macb229;
   reg               gate_clk_macb229;
   reg               isolate_macb229;
   reg               save_edge_macb229;
   reg               restore_edge_macb229;
   reg               pwr1_on_macb229;
   reg               pwr2_on_macb229;
   wire              pwr1_off_macb229;
   wire              pwr2_off_macb229;
   // ETH329
   reg               rstn_non_srpg_macb329;
   reg               gate_clk_macb329;
   reg               isolate_macb329;
   reg               save_edge_macb329;
   reg               restore_edge_macb329;
   reg               pwr1_on_macb329;
   reg               pwr2_on_macb329;
   wire              pwr1_off_macb329;
   wire              pwr2_off_macb329;

   wire core06v29;
   wire core08v29;
   wire core10v29;
   wire core12v29;



`endif
//##############################################################################
// black29 boxed29 defines29 
//##############################################################################

endmodule
