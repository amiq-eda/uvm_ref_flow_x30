//File18 name   : power_ctrl_veneer18.v
//Title18       : 
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------
module power_ctrl_veneer18 (
    //------------------------------------
    // Clocks18 & Reset18
    //------------------------------------
    pclk18,
    nprst18,
    //------------------------------------
    // APB18 programming18 interface
    //------------------------------------
    paddr18,
    psel18,
    penable18,
    pwrite18,
    pwdata18,
    prdata18,
    // mac18 i/f,
    macb3_wakeup18,
    macb2_wakeup18,
    macb1_wakeup18,
    macb0_wakeup18,
    //------------------------------------
    // Scan18 
    //------------------------------------
    scan_in18,
    scan_en18,
    scan_mode18,
    scan_out18,
    int_source_h18,
    //------------------------------------
    // Module18 control18 outputs18
    //------------------------------------
    // SMC18
    rstn_non_srpg_smc18,
    gate_clk_smc18,
    isolate_smc18,
    save_edge_smc18,
    restore_edge_smc18,
    pwr1_on_smc18,
    pwr2_on_smc18,
    // URT18
    rstn_non_srpg_urt18,
    gate_clk_urt18,
    isolate_urt18,
    save_edge_urt18,
    restore_edge_urt18,
    pwr1_on_urt18,
    pwr2_on_urt18,
    // ETH018
    rstn_non_srpg_macb018,
    gate_clk_macb018,
    isolate_macb018,
    save_edge_macb018,
    restore_edge_macb018,
    pwr1_on_macb018,
    pwr2_on_macb018,
    // ETH118
    rstn_non_srpg_macb118,
    gate_clk_macb118,
    isolate_macb118,
    save_edge_macb118,
    restore_edge_macb118,
    pwr1_on_macb118,
    pwr2_on_macb118,
    // ETH218
    rstn_non_srpg_macb218,
    gate_clk_macb218,
    isolate_macb218,
    save_edge_macb218,
    restore_edge_macb218,
    pwr1_on_macb218,
    pwr2_on_macb218,
    // ETH318
    rstn_non_srpg_macb318,
    gate_clk_macb318,
    isolate_macb318,
    save_edge_macb318,
    restore_edge_macb318,
    pwr1_on_macb318,
    pwr2_on_macb318,
    // core18 dvfs18 transitions18
    core06v18,
    core08v18,
    core10v18,
    core12v18,
    pcm_macb_wakeup_int18,
    isolate_mem18,
    
    // transit18 signals18
    mte_smc_start18,
    mte_uart_start18,
    mte_smc_uart_start18,  
    mte_pm_smc_to_default_start18, 
    mte_pm_uart_to_default_start18,
    mte_pm_smc_uart_to_default_start18
  );

//------------------------------------------------------------------------------
// I18/O18 declaration18
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks18 & Reset18
   //------------------------------------
   input             pclk18;
   input             nprst18;
   //------------------------------------
   // APB18 programming18 interface;
   //------------------------------------
   input  [31:0]     paddr18;
   input             psel18;
   input             penable18;
   input             pwrite18;
   input  [31:0]     pwdata18;
   output [31:0]     prdata18;
    // mac18
   input macb3_wakeup18;
   input macb2_wakeup18;
   input macb1_wakeup18;
   input macb0_wakeup18;
   //------------------------------------
   // Scan18
   //------------------------------------
   input             scan_in18;
   input             scan_en18;
   input             scan_mode18;
   output            scan_out18;
   //------------------------------------
   // Module18 control18 outputs18
   input             int_source_h18;
   //------------------------------------
   // SMC18
   output            rstn_non_srpg_smc18;
   output            gate_clk_smc18;
   output            isolate_smc18;
   output            save_edge_smc18;
   output            restore_edge_smc18;
   output            pwr1_on_smc18;
   output            pwr2_on_smc18;
   // URT18
   output            rstn_non_srpg_urt18;
   output            gate_clk_urt18;
   output            isolate_urt18;
   output            save_edge_urt18;
   output            restore_edge_urt18;
   output            pwr1_on_urt18;
   output            pwr2_on_urt18;
   // ETH018
   output            rstn_non_srpg_macb018;
   output            gate_clk_macb018;
   output            isolate_macb018;
   output            save_edge_macb018;
   output            restore_edge_macb018;
   output            pwr1_on_macb018;
   output            pwr2_on_macb018;
   // ETH118
   output            rstn_non_srpg_macb118;
   output            gate_clk_macb118;
   output            isolate_macb118;
   output            save_edge_macb118;
   output            restore_edge_macb118;
   output            pwr1_on_macb118;
   output            pwr2_on_macb118;
   // ETH218
   output            rstn_non_srpg_macb218;
   output            gate_clk_macb218;
   output            isolate_macb218;
   output            save_edge_macb218;
   output            restore_edge_macb218;
   output            pwr1_on_macb218;
   output            pwr2_on_macb218;
   // ETH318
   output            rstn_non_srpg_macb318;
   output            gate_clk_macb318;
   output            isolate_macb318;
   output            save_edge_macb318;
   output            restore_edge_macb318;
   output            pwr1_on_macb318;
   output            pwr2_on_macb318;

   // dvfs18
   output core06v18;
   output core08v18;
   output core10v18;
   output core12v18;
   output pcm_macb_wakeup_int18 ;
   output isolate_mem18 ;

   //transit18  signals18
   output mte_smc_start18;
   output mte_uart_start18;
   output mte_smc_uart_start18;  
   output mte_pm_smc_to_default_start18; 
   output mte_pm_uart_to_default_start18;
   output mte_pm_smc_uart_to_default_start18;



//##############################################################################
// if the POWER_CTRL18 is NOT18 black18 boxed18 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL18

power_ctrl18 i_power_ctrl18(
    // -- Clocks18 & Reset18
    	.pclk18(pclk18), 			//  : in  std_logic18;
    	.nprst18(nprst18), 		//  : in  std_logic18;
    // -- APB18 programming18 interface
    	.paddr18(paddr18), 			//  : in  std_logic_vector18(31 downto18 0);
    	.psel18(psel18), 			//  : in  std_logic18;
    	.penable18(penable18), 		//  : in  std_logic18;
    	.pwrite18(pwrite18), 		//  : in  std_logic18;
    	.pwdata18(pwdata18), 		//  : in  std_logic_vector18(31 downto18 0);
    	.prdata18(prdata18), 		//  : out std_logic_vector18(31 downto18 0);
        .macb3_wakeup18(macb3_wakeup18),
        .macb2_wakeup18(macb2_wakeup18),
        .macb1_wakeup18(macb1_wakeup18),
        .macb0_wakeup18(macb0_wakeup18),
    // -- Module18 control18 outputs18
    	.scan_in18(),			//  : in  std_logic18;
    	.scan_en18(scan_en18),             	//  : in  std_logic18;
    	.scan_mode18(scan_mode18),          //  : in  std_logic18;
    	.scan_out18(),            	//  : out std_logic18;
    	.int_source_h18(int_source_h18),    //  : out std_logic18;
     	.rstn_non_srpg_smc18(rstn_non_srpg_smc18), 		//   : out std_logic18;
    	.gate_clk_smc18(gate_clk_smc18), 	//  : out std_logic18;
    	.isolate_smc18(isolate_smc18), 	//  : out std_logic18;
    	.save_edge_smc18(save_edge_smc18), 	//  : out std_logic18;
    	.restore_edge_smc18(restore_edge_smc18), 	//  : out std_logic18;
    	.pwr1_on_smc18(pwr1_on_smc18), 	//  : out std_logic18;
    	.pwr2_on_smc18(pwr2_on_smc18), 	//  : out std_logic18
	.pwr1_off_smc18(pwr1_off_smc18), 	//  : out std_logic18;
    	.pwr2_off_smc18(pwr2_off_smc18), 	//  : out std_logic18
     	.rstn_non_srpg_urt18(rstn_non_srpg_urt18), 		//   : out std_logic18;
    	.gate_clk_urt18(gate_clk_urt18), 	//  : out std_logic18;
    	.isolate_urt18(isolate_urt18), 	//  : out std_logic18;
    	.save_edge_urt18(save_edge_urt18), 	//  : out std_logic18;
    	.restore_edge_urt18(restore_edge_urt18), 	//  : out std_logic18;
    	.pwr1_on_urt18(pwr1_on_urt18), 	//  : out std_logic18;
    	.pwr2_on_urt18(pwr2_on_urt18), 	//  : out std_logic18;
    	.pwr1_off_urt18(pwr1_off_urt18),    //  : out std_logic18;
    	.pwr2_off_urt18(pwr2_off_urt18),     //  : out std_logic18
     	.rstn_non_srpg_macb018(rstn_non_srpg_macb018), 		//   : out std_logic18;
    	.gate_clk_macb018(gate_clk_macb018), 	//  : out std_logic18;
    	.isolate_macb018(isolate_macb018), 	//  : out std_logic18;
    	.save_edge_macb018(save_edge_macb018), 	//  : out std_logic18;
    	.restore_edge_macb018(restore_edge_macb018), 	//  : out std_logic18;
    	.pwr1_on_macb018(pwr1_on_macb018), 	//  : out std_logic18;
    	.pwr2_on_macb018(pwr2_on_macb018), 	//  : out std_logic18;
    	.pwr1_off_macb018(pwr1_off_macb018),    //  : out std_logic18;
    	.pwr2_off_macb018(pwr2_off_macb018),     //  : out std_logic18
     	.rstn_non_srpg_macb118(rstn_non_srpg_macb118), 		//   : out std_logic18;
    	.gate_clk_macb118(gate_clk_macb118), 	//  : out std_logic18;
    	.isolate_macb118(isolate_macb118), 	//  : out std_logic18;
    	.save_edge_macb118(save_edge_macb118), 	//  : out std_logic18;
    	.restore_edge_macb118(restore_edge_macb118), 	//  : out std_logic18;
    	.pwr1_on_macb118(pwr1_on_macb118), 	//  : out std_logic18;
    	.pwr2_on_macb118(pwr2_on_macb118), 	//  : out std_logic18;
    	.pwr1_off_macb118(pwr1_off_macb118),    //  : out std_logic18;
    	.pwr2_off_macb118(pwr2_off_macb118),     //  : out std_logic18
     	.rstn_non_srpg_macb218(rstn_non_srpg_macb218), 		//   : out std_logic18;
    	.gate_clk_macb218(gate_clk_macb218), 	//  : out std_logic18;
    	.isolate_macb218(isolate_macb218), 	//  : out std_logic18;
    	.save_edge_macb218(save_edge_macb218), 	//  : out std_logic18;
    	.restore_edge_macb218(restore_edge_macb218), 	//  : out std_logic18;
    	.pwr1_on_macb218(pwr1_on_macb218), 	//  : out std_logic18;
    	.pwr2_on_macb218(pwr2_on_macb218), 	//  : out std_logic18;
    	.pwr1_off_macb218(pwr1_off_macb218),    //  : out std_logic18;
    	.pwr2_off_macb218(pwr2_off_macb218),     //  : out std_logic18
     	.rstn_non_srpg_macb318(rstn_non_srpg_macb318), 		//   : out std_logic18;
    	.gate_clk_macb318(gate_clk_macb318), 	//  : out std_logic18;
    	.isolate_macb318(isolate_macb318), 	//  : out std_logic18;
    	.save_edge_macb318(save_edge_macb318), 	//  : out std_logic18;
    	.restore_edge_macb318(restore_edge_macb318), 	//  : out std_logic18;
    	.pwr1_on_macb318(pwr1_on_macb318), 	//  : out std_logic18;
    	.pwr2_on_macb318(pwr2_on_macb318), 	//  : out std_logic18;
    	.pwr1_off_macb318(pwr1_off_macb318),    //  : out std_logic18;
    	.pwr2_off_macb318(pwr2_off_macb318),     //  : out std_logic18
        .rstn_non_srpg_dma18(rstn_non_srpg_dma18 ) ,
        .gate_clk_dma18(gate_clk_dma18      )      ,
        .isolate_dma18(isolate_dma18       )       ,
        .save_edge_dma18(save_edge_dma18   )   ,
        .restore_edge_dma18(restore_edge_dma18   )   ,
        .pwr1_on_dma18(pwr1_on_dma18       )       ,
        .pwr2_on_dma18(pwr2_on_dma18       )       ,
        .pwr1_off_dma18(pwr1_off_dma18      )      ,
        .pwr2_off_dma18(pwr2_off_dma18      )      ,
        
        .rstn_non_srpg_cpu18(rstn_non_srpg_cpu18 ) ,
        .gate_clk_cpu18(gate_clk_cpu18      )      ,
        .isolate_cpu18(isolate_cpu18       )       ,
        .save_edge_cpu18(save_edge_cpu18   )   ,
        .restore_edge_cpu18(restore_edge_cpu18   )   ,
        .pwr1_on_cpu18(pwr1_on_cpu18       )       ,
        .pwr2_on_cpu18(pwr2_on_cpu18       )       ,
        .pwr1_off_cpu18(pwr1_off_cpu18      )      ,
        .pwr2_off_cpu18(pwr2_off_cpu18      )      ,
        
        .rstn_non_srpg_alut18(rstn_non_srpg_alut18 ) ,
        .gate_clk_alut18(gate_clk_alut18      )      ,
        .isolate_alut18(isolate_alut18       )       ,
        .save_edge_alut18(save_edge_alut18   )   ,
        .restore_edge_alut18(restore_edge_alut18   )   ,
        .pwr1_on_alut18(pwr1_on_alut18       )       ,
        .pwr2_on_alut18(pwr2_on_alut18       )       ,
        .pwr1_off_alut18(pwr1_off_alut18      )      ,
        .pwr2_off_alut18(pwr2_off_alut18      )      ,
        
        .rstn_non_srpg_mem18(rstn_non_srpg_mem18 ) ,
        .gate_clk_mem18(gate_clk_mem18      )      ,
        .isolate_mem18(isolate_mem18       )       ,
        .save_edge_mem18(save_edge_mem18   )   ,
        .restore_edge_mem18(restore_edge_mem18   )   ,
        .pwr1_on_mem18(pwr1_on_mem18       )       ,
        .pwr2_on_mem18(pwr2_on_mem18       )       ,
        .pwr1_off_mem18(pwr1_off_mem18      )      ,
        .pwr2_off_mem18(pwr2_off_mem18      )      ,

    	.core06v18(core06v18),     //  : out std_logic18
    	.core08v18(core08v18),     //  : out std_logic18
    	.core10v18(core10v18),     //  : out std_logic18
    	.core12v18(core12v18),     //  : out std_logic18
        .pcm_macb_wakeup_int18(pcm_macb_wakeup_int18),
        .mte_smc_start18(mte_smc_start18),
        .mte_uart_start18(mte_uart_start18),
        .mte_smc_uart_start18(mte_smc_uart_start18),  
        .mte_pm_smc_to_default_start18(mte_pm_smc_to_default_start18), 
        .mte_pm_uart_to_default_start18(mte_pm_uart_to_default_start18),
        .mte_pm_smc_uart_to_default_start18(mte_pm_smc_uart_to_default_start18)
);


`else 
//##############################################################################
// if the POWER_CTRL18 is black18 boxed18 
//##############################################################################

   //------------------------------------
   // Clocks18 & Reset18
   //------------------------------------
   wire              pclk18;
   wire              nprst18;
   //------------------------------------
   // APB18 programming18 interface;
   //------------------------------------
   wire   [31:0]     paddr18;
   wire              psel18;
   wire              penable18;
   wire              pwrite18;
   wire   [31:0]     pwdata18;
   reg    [31:0]     prdata18;
   //------------------------------------
   // Scan18
   //------------------------------------
   wire              scan_in18;
   wire              scan_en18;
   wire              scan_mode18;
   reg               scan_out18;
   //------------------------------------
   // Module18 control18 outputs18
   //------------------------------------
   // SMC18;
   reg               rstn_non_srpg_smc18;
   reg               gate_clk_smc18;
   reg               isolate_smc18;
   reg               save_edge_smc18;
   reg               restore_edge_smc18;
   reg               pwr1_on_smc18;
   reg               pwr2_on_smc18;
   wire              pwr1_off_smc18;
   wire              pwr2_off_smc18;

   // URT18;
   reg               rstn_non_srpg_urt18;
   reg               gate_clk_urt18;
   reg               isolate_urt18;
   reg               save_edge_urt18;
   reg               restore_edge_urt18;
   reg               pwr1_on_urt18;
   reg               pwr2_on_urt18;
   wire              pwr1_off_urt18;
   wire              pwr2_off_urt18;

   // ETH018
   reg               rstn_non_srpg_macb018;
   reg               gate_clk_macb018;
   reg               isolate_macb018;
   reg               save_edge_macb018;
   reg               restore_edge_macb018;
   reg               pwr1_on_macb018;
   reg               pwr2_on_macb018;
   wire              pwr1_off_macb018;
   wire              pwr2_off_macb018;
   // ETH118
   reg               rstn_non_srpg_macb118;
   reg               gate_clk_macb118;
   reg               isolate_macb118;
   reg               save_edge_macb118;
   reg               restore_edge_macb118;
   reg               pwr1_on_macb118;
   reg               pwr2_on_macb118;
   wire              pwr1_off_macb118;
   wire              pwr2_off_macb118;
   // ETH218
   reg               rstn_non_srpg_macb218;
   reg               gate_clk_macb218;
   reg               isolate_macb218;
   reg               save_edge_macb218;
   reg               restore_edge_macb218;
   reg               pwr1_on_macb218;
   reg               pwr2_on_macb218;
   wire              pwr1_off_macb218;
   wire              pwr2_off_macb218;
   // ETH318
   reg               rstn_non_srpg_macb318;
   reg               gate_clk_macb318;
   reg               isolate_macb318;
   reg               save_edge_macb318;
   reg               restore_edge_macb318;
   reg               pwr1_on_macb318;
   reg               pwr2_on_macb318;
   wire              pwr1_off_macb318;
   wire              pwr2_off_macb318;

   wire core06v18;
   wire core08v18;
   wire core10v18;
   wire core12v18;



`endif
//##############################################################################
// black18 boxed18 defines18 
//##############################################################################

endmodule
