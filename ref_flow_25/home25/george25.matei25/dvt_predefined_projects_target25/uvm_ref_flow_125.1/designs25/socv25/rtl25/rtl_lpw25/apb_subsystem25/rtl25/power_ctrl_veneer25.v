//File25 name   : power_ctrl_veneer25.v
//Title25       : 
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------
module power_ctrl_veneer25 (
    //------------------------------------
    // Clocks25 & Reset25
    //------------------------------------
    pclk25,
    nprst25,
    //------------------------------------
    // APB25 programming25 interface
    //------------------------------------
    paddr25,
    psel25,
    penable25,
    pwrite25,
    pwdata25,
    prdata25,
    // mac25 i/f,
    macb3_wakeup25,
    macb2_wakeup25,
    macb1_wakeup25,
    macb0_wakeup25,
    //------------------------------------
    // Scan25 
    //------------------------------------
    scan_in25,
    scan_en25,
    scan_mode25,
    scan_out25,
    int_source_h25,
    //------------------------------------
    // Module25 control25 outputs25
    //------------------------------------
    // SMC25
    rstn_non_srpg_smc25,
    gate_clk_smc25,
    isolate_smc25,
    save_edge_smc25,
    restore_edge_smc25,
    pwr1_on_smc25,
    pwr2_on_smc25,
    // URT25
    rstn_non_srpg_urt25,
    gate_clk_urt25,
    isolate_urt25,
    save_edge_urt25,
    restore_edge_urt25,
    pwr1_on_urt25,
    pwr2_on_urt25,
    // ETH025
    rstn_non_srpg_macb025,
    gate_clk_macb025,
    isolate_macb025,
    save_edge_macb025,
    restore_edge_macb025,
    pwr1_on_macb025,
    pwr2_on_macb025,
    // ETH125
    rstn_non_srpg_macb125,
    gate_clk_macb125,
    isolate_macb125,
    save_edge_macb125,
    restore_edge_macb125,
    pwr1_on_macb125,
    pwr2_on_macb125,
    // ETH225
    rstn_non_srpg_macb225,
    gate_clk_macb225,
    isolate_macb225,
    save_edge_macb225,
    restore_edge_macb225,
    pwr1_on_macb225,
    pwr2_on_macb225,
    // ETH325
    rstn_non_srpg_macb325,
    gate_clk_macb325,
    isolate_macb325,
    save_edge_macb325,
    restore_edge_macb325,
    pwr1_on_macb325,
    pwr2_on_macb325,
    // core25 dvfs25 transitions25
    core06v25,
    core08v25,
    core10v25,
    core12v25,
    pcm_macb_wakeup_int25,
    isolate_mem25,
    
    // transit25 signals25
    mte_smc_start25,
    mte_uart_start25,
    mte_smc_uart_start25,  
    mte_pm_smc_to_default_start25, 
    mte_pm_uart_to_default_start25,
    mte_pm_smc_uart_to_default_start25
  );

//------------------------------------------------------------------------------
// I25/O25 declaration25
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks25 & Reset25
   //------------------------------------
   input             pclk25;
   input             nprst25;
   //------------------------------------
   // APB25 programming25 interface;
   //------------------------------------
   input  [31:0]     paddr25;
   input             psel25;
   input             penable25;
   input             pwrite25;
   input  [31:0]     pwdata25;
   output [31:0]     prdata25;
    // mac25
   input macb3_wakeup25;
   input macb2_wakeup25;
   input macb1_wakeup25;
   input macb0_wakeup25;
   //------------------------------------
   // Scan25
   //------------------------------------
   input             scan_in25;
   input             scan_en25;
   input             scan_mode25;
   output            scan_out25;
   //------------------------------------
   // Module25 control25 outputs25
   input             int_source_h25;
   //------------------------------------
   // SMC25
   output            rstn_non_srpg_smc25;
   output            gate_clk_smc25;
   output            isolate_smc25;
   output            save_edge_smc25;
   output            restore_edge_smc25;
   output            pwr1_on_smc25;
   output            pwr2_on_smc25;
   // URT25
   output            rstn_non_srpg_urt25;
   output            gate_clk_urt25;
   output            isolate_urt25;
   output            save_edge_urt25;
   output            restore_edge_urt25;
   output            pwr1_on_urt25;
   output            pwr2_on_urt25;
   // ETH025
   output            rstn_non_srpg_macb025;
   output            gate_clk_macb025;
   output            isolate_macb025;
   output            save_edge_macb025;
   output            restore_edge_macb025;
   output            pwr1_on_macb025;
   output            pwr2_on_macb025;
   // ETH125
   output            rstn_non_srpg_macb125;
   output            gate_clk_macb125;
   output            isolate_macb125;
   output            save_edge_macb125;
   output            restore_edge_macb125;
   output            pwr1_on_macb125;
   output            pwr2_on_macb125;
   // ETH225
   output            rstn_non_srpg_macb225;
   output            gate_clk_macb225;
   output            isolate_macb225;
   output            save_edge_macb225;
   output            restore_edge_macb225;
   output            pwr1_on_macb225;
   output            pwr2_on_macb225;
   // ETH325
   output            rstn_non_srpg_macb325;
   output            gate_clk_macb325;
   output            isolate_macb325;
   output            save_edge_macb325;
   output            restore_edge_macb325;
   output            pwr1_on_macb325;
   output            pwr2_on_macb325;

   // dvfs25
   output core06v25;
   output core08v25;
   output core10v25;
   output core12v25;
   output pcm_macb_wakeup_int25 ;
   output isolate_mem25 ;

   //transit25  signals25
   output mte_smc_start25;
   output mte_uart_start25;
   output mte_smc_uart_start25;  
   output mte_pm_smc_to_default_start25; 
   output mte_pm_uart_to_default_start25;
   output mte_pm_smc_uart_to_default_start25;



//##############################################################################
// if the POWER_CTRL25 is NOT25 black25 boxed25 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL25

power_ctrl25 i_power_ctrl25(
    // -- Clocks25 & Reset25
    	.pclk25(pclk25), 			//  : in  std_logic25;
    	.nprst25(nprst25), 		//  : in  std_logic25;
    // -- APB25 programming25 interface
    	.paddr25(paddr25), 			//  : in  std_logic_vector25(31 downto25 0);
    	.psel25(psel25), 			//  : in  std_logic25;
    	.penable25(penable25), 		//  : in  std_logic25;
    	.pwrite25(pwrite25), 		//  : in  std_logic25;
    	.pwdata25(pwdata25), 		//  : in  std_logic_vector25(31 downto25 0);
    	.prdata25(prdata25), 		//  : out std_logic_vector25(31 downto25 0);
        .macb3_wakeup25(macb3_wakeup25),
        .macb2_wakeup25(macb2_wakeup25),
        .macb1_wakeup25(macb1_wakeup25),
        .macb0_wakeup25(macb0_wakeup25),
    // -- Module25 control25 outputs25
    	.scan_in25(),			//  : in  std_logic25;
    	.scan_en25(scan_en25),             	//  : in  std_logic25;
    	.scan_mode25(scan_mode25),          //  : in  std_logic25;
    	.scan_out25(),            	//  : out std_logic25;
    	.int_source_h25(int_source_h25),    //  : out std_logic25;
     	.rstn_non_srpg_smc25(rstn_non_srpg_smc25), 		//   : out std_logic25;
    	.gate_clk_smc25(gate_clk_smc25), 	//  : out std_logic25;
    	.isolate_smc25(isolate_smc25), 	//  : out std_logic25;
    	.save_edge_smc25(save_edge_smc25), 	//  : out std_logic25;
    	.restore_edge_smc25(restore_edge_smc25), 	//  : out std_logic25;
    	.pwr1_on_smc25(pwr1_on_smc25), 	//  : out std_logic25;
    	.pwr2_on_smc25(pwr2_on_smc25), 	//  : out std_logic25
	.pwr1_off_smc25(pwr1_off_smc25), 	//  : out std_logic25;
    	.pwr2_off_smc25(pwr2_off_smc25), 	//  : out std_logic25
     	.rstn_non_srpg_urt25(rstn_non_srpg_urt25), 		//   : out std_logic25;
    	.gate_clk_urt25(gate_clk_urt25), 	//  : out std_logic25;
    	.isolate_urt25(isolate_urt25), 	//  : out std_logic25;
    	.save_edge_urt25(save_edge_urt25), 	//  : out std_logic25;
    	.restore_edge_urt25(restore_edge_urt25), 	//  : out std_logic25;
    	.pwr1_on_urt25(pwr1_on_urt25), 	//  : out std_logic25;
    	.pwr2_on_urt25(pwr2_on_urt25), 	//  : out std_logic25;
    	.pwr1_off_urt25(pwr1_off_urt25),    //  : out std_logic25;
    	.pwr2_off_urt25(pwr2_off_urt25),     //  : out std_logic25
     	.rstn_non_srpg_macb025(rstn_non_srpg_macb025), 		//   : out std_logic25;
    	.gate_clk_macb025(gate_clk_macb025), 	//  : out std_logic25;
    	.isolate_macb025(isolate_macb025), 	//  : out std_logic25;
    	.save_edge_macb025(save_edge_macb025), 	//  : out std_logic25;
    	.restore_edge_macb025(restore_edge_macb025), 	//  : out std_logic25;
    	.pwr1_on_macb025(pwr1_on_macb025), 	//  : out std_logic25;
    	.pwr2_on_macb025(pwr2_on_macb025), 	//  : out std_logic25;
    	.pwr1_off_macb025(pwr1_off_macb025),    //  : out std_logic25;
    	.pwr2_off_macb025(pwr2_off_macb025),     //  : out std_logic25
     	.rstn_non_srpg_macb125(rstn_non_srpg_macb125), 		//   : out std_logic25;
    	.gate_clk_macb125(gate_clk_macb125), 	//  : out std_logic25;
    	.isolate_macb125(isolate_macb125), 	//  : out std_logic25;
    	.save_edge_macb125(save_edge_macb125), 	//  : out std_logic25;
    	.restore_edge_macb125(restore_edge_macb125), 	//  : out std_logic25;
    	.pwr1_on_macb125(pwr1_on_macb125), 	//  : out std_logic25;
    	.pwr2_on_macb125(pwr2_on_macb125), 	//  : out std_logic25;
    	.pwr1_off_macb125(pwr1_off_macb125),    //  : out std_logic25;
    	.pwr2_off_macb125(pwr2_off_macb125),     //  : out std_logic25
     	.rstn_non_srpg_macb225(rstn_non_srpg_macb225), 		//   : out std_logic25;
    	.gate_clk_macb225(gate_clk_macb225), 	//  : out std_logic25;
    	.isolate_macb225(isolate_macb225), 	//  : out std_logic25;
    	.save_edge_macb225(save_edge_macb225), 	//  : out std_logic25;
    	.restore_edge_macb225(restore_edge_macb225), 	//  : out std_logic25;
    	.pwr1_on_macb225(pwr1_on_macb225), 	//  : out std_logic25;
    	.pwr2_on_macb225(pwr2_on_macb225), 	//  : out std_logic25;
    	.pwr1_off_macb225(pwr1_off_macb225),    //  : out std_logic25;
    	.pwr2_off_macb225(pwr2_off_macb225),     //  : out std_logic25
     	.rstn_non_srpg_macb325(rstn_non_srpg_macb325), 		//   : out std_logic25;
    	.gate_clk_macb325(gate_clk_macb325), 	//  : out std_logic25;
    	.isolate_macb325(isolate_macb325), 	//  : out std_logic25;
    	.save_edge_macb325(save_edge_macb325), 	//  : out std_logic25;
    	.restore_edge_macb325(restore_edge_macb325), 	//  : out std_logic25;
    	.pwr1_on_macb325(pwr1_on_macb325), 	//  : out std_logic25;
    	.pwr2_on_macb325(pwr2_on_macb325), 	//  : out std_logic25;
    	.pwr1_off_macb325(pwr1_off_macb325),    //  : out std_logic25;
    	.pwr2_off_macb325(pwr2_off_macb325),     //  : out std_logic25
        .rstn_non_srpg_dma25(rstn_non_srpg_dma25 ) ,
        .gate_clk_dma25(gate_clk_dma25      )      ,
        .isolate_dma25(isolate_dma25       )       ,
        .save_edge_dma25(save_edge_dma25   )   ,
        .restore_edge_dma25(restore_edge_dma25   )   ,
        .pwr1_on_dma25(pwr1_on_dma25       )       ,
        .pwr2_on_dma25(pwr2_on_dma25       )       ,
        .pwr1_off_dma25(pwr1_off_dma25      )      ,
        .pwr2_off_dma25(pwr2_off_dma25      )      ,
        
        .rstn_non_srpg_cpu25(rstn_non_srpg_cpu25 ) ,
        .gate_clk_cpu25(gate_clk_cpu25      )      ,
        .isolate_cpu25(isolate_cpu25       )       ,
        .save_edge_cpu25(save_edge_cpu25   )   ,
        .restore_edge_cpu25(restore_edge_cpu25   )   ,
        .pwr1_on_cpu25(pwr1_on_cpu25       )       ,
        .pwr2_on_cpu25(pwr2_on_cpu25       )       ,
        .pwr1_off_cpu25(pwr1_off_cpu25      )      ,
        .pwr2_off_cpu25(pwr2_off_cpu25      )      ,
        
        .rstn_non_srpg_alut25(rstn_non_srpg_alut25 ) ,
        .gate_clk_alut25(gate_clk_alut25      )      ,
        .isolate_alut25(isolate_alut25       )       ,
        .save_edge_alut25(save_edge_alut25   )   ,
        .restore_edge_alut25(restore_edge_alut25   )   ,
        .pwr1_on_alut25(pwr1_on_alut25       )       ,
        .pwr2_on_alut25(pwr2_on_alut25       )       ,
        .pwr1_off_alut25(pwr1_off_alut25      )      ,
        .pwr2_off_alut25(pwr2_off_alut25      )      ,
        
        .rstn_non_srpg_mem25(rstn_non_srpg_mem25 ) ,
        .gate_clk_mem25(gate_clk_mem25      )      ,
        .isolate_mem25(isolate_mem25       )       ,
        .save_edge_mem25(save_edge_mem25   )   ,
        .restore_edge_mem25(restore_edge_mem25   )   ,
        .pwr1_on_mem25(pwr1_on_mem25       )       ,
        .pwr2_on_mem25(pwr2_on_mem25       )       ,
        .pwr1_off_mem25(pwr1_off_mem25      )      ,
        .pwr2_off_mem25(pwr2_off_mem25      )      ,

    	.core06v25(core06v25),     //  : out std_logic25
    	.core08v25(core08v25),     //  : out std_logic25
    	.core10v25(core10v25),     //  : out std_logic25
    	.core12v25(core12v25),     //  : out std_logic25
        .pcm_macb_wakeup_int25(pcm_macb_wakeup_int25),
        .mte_smc_start25(mte_smc_start25),
        .mte_uart_start25(mte_uart_start25),
        .mte_smc_uart_start25(mte_smc_uart_start25),  
        .mte_pm_smc_to_default_start25(mte_pm_smc_to_default_start25), 
        .mte_pm_uart_to_default_start25(mte_pm_uart_to_default_start25),
        .mte_pm_smc_uart_to_default_start25(mte_pm_smc_uart_to_default_start25)
);


`else 
//##############################################################################
// if the POWER_CTRL25 is black25 boxed25 
//##############################################################################

   //------------------------------------
   // Clocks25 & Reset25
   //------------------------------------
   wire              pclk25;
   wire              nprst25;
   //------------------------------------
   // APB25 programming25 interface;
   //------------------------------------
   wire   [31:0]     paddr25;
   wire              psel25;
   wire              penable25;
   wire              pwrite25;
   wire   [31:0]     pwdata25;
   reg    [31:0]     prdata25;
   //------------------------------------
   // Scan25
   //------------------------------------
   wire              scan_in25;
   wire              scan_en25;
   wire              scan_mode25;
   reg               scan_out25;
   //------------------------------------
   // Module25 control25 outputs25
   //------------------------------------
   // SMC25;
   reg               rstn_non_srpg_smc25;
   reg               gate_clk_smc25;
   reg               isolate_smc25;
   reg               save_edge_smc25;
   reg               restore_edge_smc25;
   reg               pwr1_on_smc25;
   reg               pwr2_on_smc25;
   wire              pwr1_off_smc25;
   wire              pwr2_off_smc25;

   // URT25;
   reg               rstn_non_srpg_urt25;
   reg               gate_clk_urt25;
   reg               isolate_urt25;
   reg               save_edge_urt25;
   reg               restore_edge_urt25;
   reg               pwr1_on_urt25;
   reg               pwr2_on_urt25;
   wire              pwr1_off_urt25;
   wire              pwr2_off_urt25;

   // ETH025
   reg               rstn_non_srpg_macb025;
   reg               gate_clk_macb025;
   reg               isolate_macb025;
   reg               save_edge_macb025;
   reg               restore_edge_macb025;
   reg               pwr1_on_macb025;
   reg               pwr2_on_macb025;
   wire              pwr1_off_macb025;
   wire              pwr2_off_macb025;
   // ETH125
   reg               rstn_non_srpg_macb125;
   reg               gate_clk_macb125;
   reg               isolate_macb125;
   reg               save_edge_macb125;
   reg               restore_edge_macb125;
   reg               pwr1_on_macb125;
   reg               pwr2_on_macb125;
   wire              pwr1_off_macb125;
   wire              pwr2_off_macb125;
   // ETH225
   reg               rstn_non_srpg_macb225;
   reg               gate_clk_macb225;
   reg               isolate_macb225;
   reg               save_edge_macb225;
   reg               restore_edge_macb225;
   reg               pwr1_on_macb225;
   reg               pwr2_on_macb225;
   wire              pwr1_off_macb225;
   wire              pwr2_off_macb225;
   // ETH325
   reg               rstn_non_srpg_macb325;
   reg               gate_clk_macb325;
   reg               isolate_macb325;
   reg               save_edge_macb325;
   reg               restore_edge_macb325;
   reg               pwr1_on_macb325;
   reg               pwr2_on_macb325;
   wire              pwr1_off_macb325;
   wire              pwr2_off_macb325;

   wire core06v25;
   wire core08v25;
   wire core10v25;
   wire core12v25;



`endif
//##############################################################################
// black25 boxed25 defines25 
//##############################################################################

endmodule
