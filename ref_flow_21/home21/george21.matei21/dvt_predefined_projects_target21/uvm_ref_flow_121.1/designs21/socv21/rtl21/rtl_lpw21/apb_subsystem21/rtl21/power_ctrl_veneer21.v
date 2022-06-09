//File21 name   : power_ctrl_veneer21.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------
module power_ctrl_veneer21 (
    //------------------------------------
    // Clocks21 & Reset21
    //------------------------------------
    pclk21,
    nprst21,
    //------------------------------------
    // APB21 programming21 interface
    //------------------------------------
    paddr21,
    psel21,
    penable21,
    pwrite21,
    pwdata21,
    prdata21,
    // mac21 i/f,
    macb3_wakeup21,
    macb2_wakeup21,
    macb1_wakeup21,
    macb0_wakeup21,
    //------------------------------------
    // Scan21 
    //------------------------------------
    scan_in21,
    scan_en21,
    scan_mode21,
    scan_out21,
    int_source_h21,
    //------------------------------------
    // Module21 control21 outputs21
    //------------------------------------
    // SMC21
    rstn_non_srpg_smc21,
    gate_clk_smc21,
    isolate_smc21,
    save_edge_smc21,
    restore_edge_smc21,
    pwr1_on_smc21,
    pwr2_on_smc21,
    // URT21
    rstn_non_srpg_urt21,
    gate_clk_urt21,
    isolate_urt21,
    save_edge_urt21,
    restore_edge_urt21,
    pwr1_on_urt21,
    pwr2_on_urt21,
    // ETH021
    rstn_non_srpg_macb021,
    gate_clk_macb021,
    isolate_macb021,
    save_edge_macb021,
    restore_edge_macb021,
    pwr1_on_macb021,
    pwr2_on_macb021,
    // ETH121
    rstn_non_srpg_macb121,
    gate_clk_macb121,
    isolate_macb121,
    save_edge_macb121,
    restore_edge_macb121,
    pwr1_on_macb121,
    pwr2_on_macb121,
    // ETH221
    rstn_non_srpg_macb221,
    gate_clk_macb221,
    isolate_macb221,
    save_edge_macb221,
    restore_edge_macb221,
    pwr1_on_macb221,
    pwr2_on_macb221,
    // ETH321
    rstn_non_srpg_macb321,
    gate_clk_macb321,
    isolate_macb321,
    save_edge_macb321,
    restore_edge_macb321,
    pwr1_on_macb321,
    pwr2_on_macb321,
    // core21 dvfs21 transitions21
    core06v21,
    core08v21,
    core10v21,
    core12v21,
    pcm_macb_wakeup_int21,
    isolate_mem21,
    
    // transit21 signals21
    mte_smc_start21,
    mte_uart_start21,
    mte_smc_uart_start21,  
    mte_pm_smc_to_default_start21, 
    mte_pm_uart_to_default_start21,
    mte_pm_smc_uart_to_default_start21
  );

//------------------------------------------------------------------------------
// I21/O21 declaration21
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks21 & Reset21
   //------------------------------------
   input             pclk21;
   input             nprst21;
   //------------------------------------
   // APB21 programming21 interface;
   //------------------------------------
   input  [31:0]     paddr21;
   input             psel21;
   input             penable21;
   input             pwrite21;
   input  [31:0]     pwdata21;
   output [31:0]     prdata21;
    // mac21
   input macb3_wakeup21;
   input macb2_wakeup21;
   input macb1_wakeup21;
   input macb0_wakeup21;
   //------------------------------------
   // Scan21
   //------------------------------------
   input             scan_in21;
   input             scan_en21;
   input             scan_mode21;
   output            scan_out21;
   //------------------------------------
   // Module21 control21 outputs21
   input             int_source_h21;
   //------------------------------------
   // SMC21
   output            rstn_non_srpg_smc21;
   output            gate_clk_smc21;
   output            isolate_smc21;
   output            save_edge_smc21;
   output            restore_edge_smc21;
   output            pwr1_on_smc21;
   output            pwr2_on_smc21;
   // URT21
   output            rstn_non_srpg_urt21;
   output            gate_clk_urt21;
   output            isolate_urt21;
   output            save_edge_urt21;
   output            restore_edge_urt21;
   output            pwr1_on_urt21;
   output            pwr2_on_urt21;
   // ETH021
   output            rstn_non_srpg_macb021;
   output            gate_clk_macb021;
   output            isolate_macb021;
   output            save_edge_macb021;
   output            restore_edge_macb021;
   output            pwr1_on_macb021;
   output            pwr2_on_macb021;
   // ETH121
   output            rstn_non_srpg_macb121;
   output            gate_clk_macb121;
   output            isolate_macb121;
   output            save_edge_macb121;
   output            restore_edge_macb121;
   output            pwr1_on_macb121;
   output            pwr2_on_macb121;
   // ETH221
   output            rstn_non_srpg_macb221;
   output            gate_clk_macb221;
   output            isolate_macb221;
   output            save_edge_macb221;
   output            restore_edge_macb221;
   output            pwr1_on_macb221;
   output            pwr2_on_macb221;
   // ETH321
   output            rstn_non_srpg_macb321;
   output            gate_clk_macb321;
   output            isolate_macb321;
   output            save_edge_macb321;
   output            restore_edge_macb321;
   output            pwr1_on_macb321;
   output            pwr2_on_macb321;

   // dvfs21
   output core06v21;
   output core08v21;
   output core10v21;
   output core12v21;
   output pcm_macb_wakeup_int21 ;
   output isolate_mem21 ;

   //transit21  signals21
   output mte_smc_start21;
   output mte_uart_start21;
   output mte_smc_uart_start21;  
   output mte_pm_smc_to_default_start21; 
   output mte_pm_uart_to_default_start21;
   output mte_pm_smc_uart_to_default_start21;



//##############################################################################
// if the POWER_CTRL21 is NOT21 black21 boxed21 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL21

power_ctrl21 i_power_ctrl21(
    // -- Clocks21 & Reset21
    	.pclk21(pclk21), 			//  : in  std_logic21;
    	.nprst21(nprst21), 		//  : in  std_logic21;
    // -- APB21 programming21 interface
    	.paddr21(paddr21), 			//  : in  std_logic_vector21(31 downto21 0);
    	.psel21(psel21), 			//  : in  std_logic21;
    	.penable21(penable21), 		//  : in  std_logic21;
    	.pwrite21(pwrite21), 		//  : in  std_logic21;
    	.pwdata21(pwdata21), 		//  : in  std_logic_vector21(31 downto21 0);
    	.prdata21(prdata21), 		//  : out std_logic_vector21(31 downto21 0);
        .macb3_wakeup21(macb3_wakeup21),
        .macb2_wakeup21(macb2_wakeup21),
        .macb1_wakeup21(macb1_wakeup21),
        .macb0_wakeup21(macb0_wakeup21),
    // -- Module21 control21 outputs21
    	.scan_in21(),			//  : in  std_logic21;
    	.scan_en21(scan_en21),             	//  : in  std_logic21;
    	.scan_mode21(scan_mode21),          //  : in  std_logic21;
    	.scan_out21(),            	//  : out std_logic21;
    	.int_source_h21(int_source_h21),    //  : out std_logic21;
     	.rstn_non_srpg_smc21(rstn_non_srpg_smc21), 		//   : out std_logic21;
    	.gate_clk_smc21(gate_clk_smc21), 	//  : out std_logic21;
    	.isolate_smc21(isolate_smc21), 	//  : out std_logic21;
    	.save_edge_smc21(save_edge_smc21), 	//  : out std_logic21;
    	.restore_edge_smc21(restore_edge_smc21), 	//  : out std_logic21;
    	.pwr1_on_smc21(pwr1_on_smc21), 	//  : out std_logic21;
    	.pwr2_on_smc21(pwr2_on_smc21), 	//  : out std_logic21
	.pwr1_off_smc21(pwr1_off_smc21), 	//  : out std_logic21;
    	.pwr2_off_smc21(pwr2_off_smc21), 	//  : out std_logic21
     	.rstn_non_srpg_urt21(rstn_non_srpg_urt21), 		//   : out std_logic21;
    	.gate_clk_urt21(gate_clk_urt21), 	//  : out std_logic21;
    	.isolate_urt21(isolate_urt21), 	//  : out std_logic21;
    	.save_edge_urt21(save_edge_urt21), 	//  : out std_logic21;
    	.restore_edge_urt21(restore_edge_urt21), 	//  : out std_logic21;
    	.pwr1_on_urt21(pwr1_on_urt21), 	//  : out std_logic21;
    	.pwr2_on_urt21(pwr2_on_urt21), 	//  : out std_logic21;
    	.pwr1_off_urt21(pwr1_off_urt21),    //  : out std_logic21;
    	.pwr2_off_urt21(pwr2_off_urt21),     //  : out std_logic21
     	.rstn_non_srpg_macb021(rstn_non_srpg_macb021), 		//   : out std_logic21;
    	.gate_clk_macb021(gate_clk_macb021), 	//  : out std_logic21;
    	.isolate_macb021(isolate_macb021), 	//  : out std_logic21;
    	.save_edge_macb021(save_edge_macb021), 	//  : out std_logic21;
    	.restore_edge_macb021(restore_edge_macb021), 	//  : out std_logic21;
    	.pwr1_on_macb021(pwr1_on_macb021), 	//  : out std_logic21;
    	.pwr2_on_macb021(pwr2_on_macb021), 	//  : out std_logic21;
    	.pwr1_off_macb021(pwr1_off_macb021),    //  : out std_logic21;
    	.pwr2_off_macb021(pwr2_off_macb021),     //  : out std_logic21
     	.rstn_non_srpg_macb121(rstn_non_srpg_macb121), 		//   : out std_logic21;
    	.gate_clk_macb121(gate_clk_macb121), 	//  : out std_logic21;
    	.isolate_macb121(isolate_macb121), 	//  : out std_logic21;
    	.save_edge_macb121(save_edge_macb121), 	//  : out std_logic21;
    	.restore_edge_macb121(restore_edge_macb121), 	//  : out std_logic21;
    	.pwr1_on_macb121(pwr1_on_macb121), 	//  : out std_logic21;
    	.pwr2_on_macb121(pwr2_on_macb121), 	//  : out std_logic21;
    	.pwr1_off_macb121(pwr1_off_macb121),    //  : out std_logic21;
    	.pwr2_off_macb121(pwr2_off_macb121),     //  : out std_logic21
     	.rstn_non_srpg_macb221(rstn_non_srpg_macb221), 		//   : out std_logic21;
    	.gate_clk_macb221(gate_clk_macb221), 	//  : out std_logic21;
    	.isolate_macb221(isolate_macb221), 	//  : out std_logic21;
    	.save_edge_macb221(save_edge_macb221), 	//  : out std_logic21;
    	.restore_edge_macb221(restore_edge_macb221), 	//  : out std_logic21;
    	.pwr1_on_macb221(pwr1_on_macb221), 	//  : out std_logic21;
    	.pwr2_on_macb221(pwr2_on_macb221), 	//  : out std_logic21;
    	.pwr1_off_macb221(pwr1_off_macb221),    //  : out std_logic21;
    	.pwr2_off_macb221(pwr2_off_macb221),     //  : out std_logic21
     	.rstn_non_srpg_macb321(rstn_non_srpg_macb321), 		//   : out std_logic21;
    	.gate_clk_macb321(gate_clk_macb321), 	//  : out std_logic21;
    	.isolate_macb321(isolate_macb321), 	//  : out std_logic21;
    	.save_edge_macb321(save_edge_macb321), 	//  : out std_logic21;
    	.restore_edge_macb321(restore_edge_macb321), 	//  : out std_logic21;
    	.pwr1_on_macb321(pwr1_on_macb321), 	//  : out std_logic21;
    	.pwr2_on_macb321(pwr2_on_macb321), 	//  : out std_logic21;
    	.pwr1_off_macb321(pwr1_off_macb321),    //  : out std_logic21;
    	.pwr2_off_macb321(pwr2_off_macb321),     //  : out std_logic21
        .rstn_non_srpg_dma21(rstn_non_srpg_dma21 ) ,
        .gate_clk_dma21(gate_clk_dma21      )      ,
        .isolate_dma21(isolate_dma21       )       ,
        .save_edge_dma21(save_edge_dma21   )   ,
        .restore_edge_dma21(restore_edge_dma21   )   ,
        .pwr1_on_dma21(pwr1_on_dma21       )       ,
        .pwr2_on_dma21(pwr2_on_dma21       )       ,
        .pwr1_off_dma21(pwr1_off_dma21      )      ,
        .pwr2_off_dma21(pwr2_off_dma21      )      ,
        
        .rstn_non_srpg_cpu21(rstn_non_srpg_cpu21 ) ,
        .gate_clk_cpu21(gate_clk_cpu21      )      ,
        .isolate_cpu21(isolate_cpu21       )       ,
        .save_edge_cpu21(save_edge_cpu21   )   ,
        .restore_edge_cpu21(restore_edge_cpu21   )   ,
        .pwr1_on_cpu21(pwr1_on_cpu21       )       ,
        .pwr2_on_cpu21(pwr2_on_cpu21       )       ,
        .pwr1_off_cpu21(pwr1_off_cpu21      )      ,
        .pwr2_off_cpu21(pwr2_off_cpu21      )      ,
        
        .rstn_non_srpg_alut21(rstn_non_srpg_alut21 ) ,
        .gate_clk_alut21(gate_clk_alut21      )      ,
        .isolate_alut21(isolate_alut21       )       ,
        .save_edge_alut21(save_edge_alut21   )   ,
        .restore_edge_alut21(restore_edge_alut21   )   ,
        .pwr1_on_alut21(pwr1_on_alut21       )       ,
        .pwr2_on_alut21(pwr2_on_alut21       )       ,
        .pwr1_off_alut21(pwr1_off_alut21      )      ,
        .pwr2_off_alut21(pwr2_off_alut21      )      ,
        
        .rstn_non_srpg_mem21(rstn_non_srpg_mem21 ) ,
        .gate_clk_mem21(gate_clk_mem21      )      ,
        .isolate_mem21(isolate_mem21       )       ,
        .save_edge_mem21(save_edge_mem21   )   ,
        .restore_edge_mem21(restore_edge_mem21   )   ,
        .pwr1_on_mem21(pwr1_on_mem21       )       ,
        .pwr2_on_mem21(pwr2_on_mem21       )       ,
        .pwr1_off_mem21(pwr1_off_mem21      )      ,
        .pwr2_off_mem21(pwr2_off_mem21      )      ,

    	.core06v21(core06v21),     //  : out std_logic21
    	.core08v21(core08v21),     //  : out std_logic21
    	.core10v21(core10v21),     //  : out std_logic21
    	.core12v21(core12v21),     //  : out std_logic21
        .pcm_macb_wakeup_int21(pcm_macb_wakeup_int21),
        .mte_smc_start21(mte_smc_start21),
        .mte_uart_start21(mte_uart_start21),
        .mte_smc_uart_start21(mte_smc_uart_start21),  
        .mte_pm_smc_to_default_start21(mte_pm_smc_to_default_start21), 
        .mte_pm_uart_to_default_start21(mte_pm_uart_to_default_start21),
        .mte_pm_smc_uart_to_default_start21(mte_pm_smc_uart_to_default_start21)
);


`else 
//##############################################################################
// if the POWER_CTRL21 is black21 boxed21 
//##############################################################################

   //------------------------------------
   // Clocks21 & Reset21
   //------------------------------------
   wire              pclk21;
   wire              nprst21;
   //------------------------------------
   // APB21 programming21 interface;
   //------------------------------------
   wire   [31:0]     paddr21;
   wire              psel21;
   wire              penable21;
   wire              pwrite21;
   wire   [31:0]     pwdata21;
   reg    [31:0]     prdata21;
   //------------------------------------
   // Scan21
   //------------------------------------
   wire              scan_in21;
   wire              scan_en21;
   wire              scan_mode21;
   reg               scan_out21;
   //------------------------------------
   // Module21 control21 outputs21
   //------------------------------------
   // SMC21;
   reg               rstn_non_srpg_smc21;
   reg               gate_clk_smc21;
   reg               isolate_smc21;
   reg               save_edge_smc21;
   reg               restore_edge_smc21;
   reg               pwr1_on_smc21;
   reg               pwr2_on_smc21;
   wire              pwr1_off_smc21;
   wire              pwr2_off_smc21;

   // URT21;
   reg               rstn_non_srpg_urt21;
   reg               gate_clk_urt21;
   reg               isolate_urt21;
   reg               save_edge_urt21;
   reg               restore_edge_urt21;
   reg               pwr1_on_urt21;
   reg               pwr2_on_urt21;
   wire              pwr1_off_urt21;
   wire              pwr2_off_urt21;

   // ETH021
   reg               rstn_non_srpg_macb021;
   reg               gate_clk_macb021;
   reg               isolate_macb021;
   reg               save_edge_macb021;
   reg               restore_edge_macb021;
   reg               pwr1_on_macb021;
   reg               pwr2_on_macb021;
   wire              pwr1_off_macb021;
   wire              pwr2_off_macb021;
   // ETH121
   reg               rstn_non_srpg_macb121;
   reg               gate_clk_macb121;
   reg               isolate_macb121;
   reg               save_edge_macb121;
   reg               restore_edge_macb121;
   reg               pwr1_on_macb121;
   reg               pwr2_on_macb121;
   wire              pwr1_off_macb121;
   wire              pwr2_off_macb121;
   // ETH221
   reg               rstn_non_srpg_macb221;
   reg               gate_clk_macb221;
   reg               isolate_macb221;
   reg               save_edge_macb221;
   reg               restore_edge_macb221;
   reg               pwr1_on_macb221;
   reg               pwr2_on_macb221;
   wire              pwr1_off_macb221;
   wire              pwr2_off_macb221;
   // ETH321
   reg               rstn_non_srpg_macb321;
   reg               gate_clk_macb321;
   reg               isolate_macb321;
   reg               save_edge_macb321;
   reg               restore_edge_macb321;
   reg               pwr1_on_macb321;
   reg               pwr2_on_macb321;
   wire              pwr1_off_macb321;
   wire              pwr2_off_macb321;

   wire core06v21;
   wire core08v21;
   wire core10v21;
   wire core12v21;



`endif
//##############################################################################
// black21 boxed21 defines21 
//##############################################################################

endmodule
