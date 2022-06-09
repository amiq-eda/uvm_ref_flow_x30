//File19 name   : power_ctrl_veneer19.v
//Title19       : 
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------
module power_ctrl_veneer19 (
    //------------------------------------
    // Clocks19 & Reset19
    //------------------------------------
    pclk19,
    nprst19,
    //------------------------------------
    // APB19 programming19 interface
    //------------------------------------
    paddr19,
    psel19,
    penable19,
    pwrite19,
    pwdata19,
    prdata19,
    // mac19 i/f,
    macb3_wakeup19,
    macb2_wakeup19,
    macb1_wakeup19,
    macb0_wakeup19,
    //------------------------------------
    // Scan19 
    //------------------------------------
    scan_in19,
    scan_en19,
    scan_mode19,
    scan_out19,
    int_source_h19,
    //------------------------------------
    // Module19 control19 outputs19
    //------------------------------------
    // SMC19
    rstn_non_srpg_smc19,
    gate_clk_smc19,
    isolate_smc19,
    save_edge_smc19,
    restore_edge_smc19,
    pwr1_on_smc19,
    pwr2_on_smc19,
    // URT19
    rstn_non_srpg_urt19,
    gate_clk_urt19,
    isolate_urt19,
    save_edge_urt19,
    restore_edge_urt19,
    pwr1_on_urt19,
    pwr2_on_urt19,
    // ETH019
    rstn_non_srpg_macb019,
    gate_clk_macb019,
    isolate_macb019,
    save_edge_macb019,
    restore_edge_macb019,
    pwr1_on_macb019,
    pwr2_on_macb019,
    // ETH119
    rstn_non_srpg_macb119,
    gate_clk_macb119,
    isolate_macb119,
    save_edge_macb119,
    restore_edge_macb119,
    pwr1_on_macb119,
    pwr2_on_macb119,
    // ETH219
    rstn_non_srpg_macb219,
    gate_clk_macb219,
    isolate_macb219,
    save_edge_macb219,
    restore_edge_macb219,
    pwr1_on_macb219,
    pwr2_on_macb219,
    // ETH319
    rstn_non_srpg_macb319,
    gate_clk_macb319,
    isolate_macb319,
    save_edge_macb319,
    restore_edge_macb319,
    pwr1_on_macb319,
    pwr2_on_macb319,
    // core19 dvfs19 transitions19
    core06v19,
    core08v19,
    core10v19,
    core12v19,
    pcm_macb_wakeup_int19,
    isolate_mem19,
    
    // transit19 signals19
    mte_smc_start19,
    mte_uart_start19,
    mte_smc_uart_start19,  
    mte_pm_smc_to_default_start19, 
    mte_pm_uart_to_default_start19,
    mte_pm_smc_uart_to_default_start19
  );

//------------------------------------------------------------------------------
// I19/O19 declaration19
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks19 & Reset19
   //------------------------------------
   input             pclk19;
   input             nprst19;
   //------------------------------------
   // APB19 programming19 interface;
   //------------------------------------
   input  [31:0]     paddr19;
   input             psel19;
   input             penable19;
   input             pwrite19;
   input  [31:0]     pwdata19;
   output [31:0]     prdata19;
    // mac19
   input macb3_wakeup19;
   input macb2_wakeup19;
   input macb1_wakeup19;
   input macb0_wakeup19;
   //------------------------------------
   // Scan19
   //------------------------------------
   input             scan_in19;
   input             scan_en19;
   input             scan_mode19;
   output            scan_out19;
   //------------------------------------
   // Module19 control19 outputs19
   input             int_source_h19;
   //------------------------------------
   // SMC19
   output            rstn_non_srpg_smc19;
   output            gate_clk_smc19;
   output            isolate_smc19;
   output            save_edge_smc19;
   output            restore_edge_smc19;
   output            pwr1_on_smc19;
   output            pwr2_on_smc19;
   // URT19
   output            rstn_non_srpg_urt19;
   output            gate_clk_urt19;
   output            isolate_urt19;
   output            save_edge_urt19;
   output            restore_edge_urt19;
   output            pwr1_on_urt19;
   output            pwr2_on_urt19;
   // ETH019
   output            rstn_non_srpg_macb019;
   output            gate_clk_macb019;
   output            isolate_macb019;
   output            save_edge_macb019;
   output            restore_edge_macb019;
   output            pwr1_on_macb019;
   output            pwr2_on_macb019;
   // ETH119
   output            rstn_non_srpg_macb119;
   output            gate_clk_macb119;
   output            isolate_macb119;
   output            save_edge_macb119;
   output            restore_edge_macb119;
   output            pwr1_on_macb119;
   output            pwr2_on_macb119;
   // ETH219
   output            rstn_non_srpg_macb219;
   output            gate_clk_macb219;
   output            isolate_macb219;
   output            save_edge_macb219;
   output            restore_edge_macb219;
   output            pwr1_on_macb219;
   output            pwr2_on_macb219;
   // ETH319
   output            rstn_non_srpg_macb319;
   output            gate_clk_macb319;
   output            isolate_macb319;
   output            save_edge_macb319;
   output            restore_edge_macb319;
   output            pwr1_on_macb319;
   output            pwr2_on_macb319;

   // dvfs19
   output core06v19;
   output core08v19;
   output core10v19;
   output core12v19;
   output pcm_macb_wakeup_int19 ;
   output isolate_mem19 ;

   //transit19  signals19
   output mte_smc_start19;
   output mte_uart_start19;
   output mte_smc_uart_start19;  
   output mte_pm_smc_to_default_start19; 
   output mte_pm_uart_to_default_start19;
   output mte_pm_smc_uart_to_default_start19;



//##############################################################################
// if the POWER_CTRL19 is NOT19 black19 boxed19 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL19

power_ctrl19 i_power_ctrl19(
    // -- Clocks19 & Reset19
    	.pclk19(pclk19), 			//  : in  std_logic19;
    	.nprst19(nprst19), 		//  : in  std_logic19;
    // -- APB19 programming19 interface
    	.paddr19(paddr19), 			//  : in  std_logic_vector19(31 downto19 0);
    	.psel19(psel19), 			//  : in  std_logic19;
    	.penable19(penable19), 		//  : in  std_logic19;
    	.pwrite19(pwrite19), 		//  : in  std_logic19;
    	.pwdata19(pwdata19), 		//  : in  std_logic_vector19(31 downto19 0);
    	.prdata19(prdata19), 		//  : out std_logic_vector19(31 downto19 0);
        .macb3_wakeup19(macb3_wakeup19),
        .macb2_wakeup19(macb2_wakeup19),
        .macb1_wakeup19(macb1_wakeup19),
        .macb0_wakeup19(macb0_wakeup19),
    // -- Module19 control19 outputs19
    	.scan_in19(),			//  : in  std_logic19;
    	.scan_en19(scan_en19),             	//  : in  std_logic19;
    	.scan_mode19(scan_mode19),          //  : in  std_logic19;
    	.scan_out19(),            	//  : out std_logic19;
    	.int_source_h19(int_source_h19),    //  : out std_logic19;
     	.rstn_non_srpg_smc19(rstn_non_srpg_smc19), 		//   : out std_logic19;
    	.gate_clk_smc19(gate_clk_smc19), 	//  : out std_logic19;
    	.isolate_smc19(isolate_smc19), 	//  : out std_logic19;
    	.save_edge_smc19(save_edge_smc19), 	//  : out std_logic19;
    	.restore_edge_smc19(restore_edge_smc19), 	//  : out std_logic19;
    	.pwr1_on_smc19(pwr1_on_smc19), 	//  : out std_logic19;
    	.pwr2_on_smc19(pwr2_on_smc19), 	//  : out std_logic19
	.pwr1_off_smc19(pwr1_off_smc19), 	//  : out std_logic19;
    	.pwr2_off_smc19(pwr2_off_smc19), 	//  : out std_logic19
     	.rstn_non_srpg_urt19(rstn_non_srpg_urt19), 		//   : out std_logic19;
    	.gate_clk_urt19(gate_clk_urt19), 	//  : out std_logic19;
    	.isolate_urt19(isolate_urt19), 	//  : out std_logic19;
    	.save_edge_urt19(save_edge_urt19), 	//  : out std_logic19;
    	.restore_edge_urt19(restore_edge_urt19), 	//  : out std_logic19;
    	.pwr1_on_urt19(pwr1_on_urt19), 	//  : out std_logic19;
    	.pwr2_on_urt19(pwr2_on_urt19), 	//  : out std_logic19;
    	.pwr1_off_urt19(pwr1_off_urt19),    //  : out std_logic19;
    	.pwr2_off_urt19(pwr2_off_urt19),     //  : out std_logic19
     	.rstn_non_srpg_macb019(rstn_non_srpg_macb019), 		//   : out std_logic19;
    	.gate_clk_macb019(gate_clk_macb019), 	//  : out std_logic19;
    	.isolate_macb019(isolate_macb019), 	//  : out std_logic19;
    	.save_edge_macb019(save_edge_macb019), 	//  : out std_logic19;
    	.restore_edge_macb019(restore_edge_macb019), 	//  : out std_logic19;
    	.pwr1_on_macb019(pwr1_on_macb019), 	//  : out std_logic19;
    	.pwr2_on_macb019(pwr2_on_macb019), 	//  : out std_logic19;
    	.pwr1_off_macb019(pwr1_off_macb019),    //  : out std_logic19;
    	.pwr2_off_macb019(pwr2_off_macb019),     //  : out std_logic19
     	.rstn_non_srpg_macb119(rstn_non_srpg_macb119), 		//   : out std_logic19;
    	.gate_clk_macb119(gate_clk_macb119), 	//  : out std_logic19;
    	.isolate_macb119(isolate_macb119), 	//  : out std_logic19;
    	.save_edge_macb119(save_edge_macb119), 	//  : out std_logic19;
    	.restore_edge_macb119(restore_edge_macb119), 	//  : out std_logic19;
    	.pwr1_on_macb119(pwr1_on_macb119), 	//  : out std_logic19;
    	.pwr2_on_macb119(pwr2_on_macb119), 	//  : out std_logic19;
    	.pwr1_off_macb119(pwr1_off_macb119),    //  : out std_logic19;
    	.pwr2_off_macb119(pwr2_off_macb119),     //  : out std_logic19
     	.rstn_non_srpg_macb219(rstn_non_srpg_macb219), 		//   : out std_logic19;
    	.gate_clk_macb219(gate_clk_macb219), 	//  : out std_logic19;
    	.isolate_macb219(isolate_macb219), 	//  : out std_logic19;
    	.save_edge_macb219(save_edge_macb219), 	//  : out std_logic19;
    	.restore_edge_macb219(restore_edge_macb219), 	//  : out std_logic19;
    	.pwr1_on_macb219(pwr1_on_macb219), 	//  : out std_logic19;
    	.pwr2_on_macb219(pwr2_on_macb219), 	//  : out std_logic19;
    	.pwr1_off_macb219(pwr1_off_macb219),    //  : out std_logic19;
    	.pwr2_off_macb219(pwr2_off_macb219),     //  : out std_logic19
     	.rstn_non_srpg_macb319(rstn_non_srpg_macb319), 		//   : out std_logic19;
    	.gate_clk_macb319(gate_clk_macb319), 	//  : out std_logic19;
    	.isolate_macb319(isolate_macb319), 	//  : out std_logic19;
    	.save_edge_macb319(save_edge_macb319), 	//  : out std_logic19;
    	.restore_edge_macb319(restore_edge_macb319), 	//  : out std_logic19;
    	.pwr1_on_macb319(pwr1_on_macb319), 	//  : out std_logic19;
    	.pwr2_on_macb319(pwr2_on_macb319), 	//  : out std_logic19;
    	.pwr1_off_macb319(pwr1_off_macb319),    //  : out std_logic19;
    	.pwr2_off_macb319(pwr2_off_macb319),     //  : out std_logic19
        .rstn_non_srpg_dma19(rstn_non_srpg_dma19 ) ,
        .gate_clk_dma19(gate_clk_dma19      )      ,
        .isolate_dma19(isolate_dma19       )       ,
        .save_edge_dma19(save_edge_dma19   )   ,
        .restore_edge_dma19(restore_edge_dma19   )   ,
        .pwr1_on_dma19(pwr1_on_dma19       )       ,
        .pwr2_on_dma19(pwr2_on_dma19       )       ,
        .pwr1_off_dma19(pwr1_off_dma19      )      ,
        .pwr2_off_dma19(pwr2_off_dma19      )      ,
        
        .rstn_non_srpg_cpu19(rstn_non_srpg_cpu19 ) ,
        .gate_clk_cpu19(gate_clk_cpu19      )      ,
        .isolate_cpu19(isolate_cpu19       )       ,
        .save_edge_cpu19(save_edge_cpu19   )   ,
        .restore_edge_cpu19(restore_edge_cpu19   )   ,
        .pwr1_on_cpu19(pwr1_on_cpu19       )       ,
        .pwr2_on_cpu19(pwr2_on_cpu19       )       ,
        .pwr1_off_cpu19(pwr1_off_cpu19      )      ,
        .pwr2_off_cpu19(pwr2_off_cpu19      )      ,
        
        .rstn_non_srpg_alut19(rstn_non_srpg_alut19 ) ,
        .gate_clk_alut19(gate_clk_alut19      )      ,
        .isolate_alut19(isolate_alut19       )       ,
        .save_edge_alut19(save_edge_alut19   )   ,
        .restore_edge_alut19(restore_edge_alut19   )   ,
        .pwr1_on_alut19(pwr1_on_alut19       )       ,
        .pwr2_on_alut19(pwr2_on_alut19       )       ,
        .pwr1_off_alut19(pwr1_off_alut19      )      ,
        .pwr2_off_alut19(pwr2_off_alut19      )      ,
        
        .rstn_non_srpg_mem19(rstn_non_srpg_mem19 ) ,
        .gate_clk_mem19(gate_clk_mem19      )      ,
        .isolate_mem19(isolate_mem19       )       ,
        .save_edge_mem19(save_edge_mem19   )   ,
        .restore_edge_mem19(restore_edge_mem19   )   ,
        .pwr1_on_mem19(pwr1_on_mem19       )       ,
        .pwr2_on_mem19(pwr2_on_mem19       )       ,
        .pwr1_off_mem19(pwr1_off_mem19      )      ,
        .pwr2_off_mem19(pwr2_off_mem19      )      ,

    	.core06v19(core06v19),     //  : out std_logic19
    	.core08v19(core08v19),     //  : out std_logic19
    	.core10v19(core10v19),     //  : out std_logic19
    	.core12v19(core12v19),     //  : out std_logic19
        .pcm_macb_wakeup_int19(pcm_macb_wakeup_int19),
        .mte_smc_start19(mte_smc_start19),
        .mte_uart_start19(mte_uart_start19),
        .mte_smc_uart_start19(mte_smc_uart_start19),  
        .mte_pm_smc_to_default_start19(mte_pm_smc_to_default_start19), 
        .mte_pm_uart_to_default_start19(mte_pm_uart_to_default_start19),
        .mte_pm_smc_uart_to_default_start19(mte_pm_smc_uart_to_default_start19)
);


`else 
//##############################################################################
// if the POWER_CTRL19 is black19 boxed19 
//##############################################################################

   //------------------------------------
   // Clocks19 & Reset19
   //------------------------------------
   wire              pclk19;
   wire              nprst19;
   //------------------------------------
   // APB19 programming19 interface;
   //------------------------------------
   wire   [31:0]     paddr19;
   wire              psel19;
   wire              penable19;
   wire              pwrite19;
   wire   [31:0]     pwdata19;
   reg    [31:0]     prdata19;
   //------------------------------------
   // Scan19
   //------------------------------------
   wire              scan_in19;
   wire              scan_en19;
   wire              scan_mode19;
   reg               scan_out19;
   //------------------------------------
   // Module19 control19 outputs19
   //------------------------------------
   // SMC19;
   reg               rstn_non_srpg_smc19;
   reg               gate_clk_smc19;
   reg               isolate_smc19;
   reg               save_edge_smc19;
   reg               restore_edge_smc19;
   reg               pwr1_on_smc19;
   reg               pwr2_on_smc19;
   wire              pwr1_off_smc19;
   wire              pwr2_off_smc19;

   // URT19;
   reg               rstn_non_srpg_urt19;
   reg               gate_clk_urt19;
   reg               isolate_urt19;
   reg               save_edge_urt19;
   reg               restore_edge_urt19;
   reg               pwr1_on_urt19;
   reg               pwr2_on_urt19;
   wire              pwr1_off_urt19;
   wire              pwr2_off_urt19;

   // ETH019
   reg               rstn_non_srpg_macb019;
   reg               gate_clk_macb019;
   reg               isolate_macb019;
   reg               save_edge_macb019;
   reg               restore_edge_macb019;
   reg               pwr1_on_macb019;
   reg               pwr2_on_macb019;
   wire              pwr1_off_macb019;
   wire              pwr2_off_macb019;
   // ETH119
   reg               rstn_non_srpg_macb119;
   reg               gate_clk_macb119;
   reg               isolate_macb119;
   reg               save_edge_macb119;
   reg               restore_edge_macb119;
   reg               pwr1_on_macb119;
   reg               pwr2_on_macb119;
   wire              pwr1_off_macb119;
   wire              pwr2_off_macb119;
   // ETH219
   reg               rstn_non_srpg_macb219;
   reg               gate_clk_macb219;
   reg               isolate_macb219;
   reg               save_edge_macb219;
   reg               restore_edge_macb219;
   reg               pwr1_on_macb219;
   reg               pwr2_on_macb219;
   wire              pwr1_off_macb219;
   wire              pwr2_off_macb219;
   // ETH319
   reg               rstn_non_srpg_macb319;
   reg               gate_clk_macb319;
   reg               isolate_macb319;
   reg               save_edge_macb319;
   reg               restore_edge_macb319;
   reg               pwr1_on_macb319;
   reg               pwr2_on_macb319;
   wire              pwr1_off_macb319;
   wire              pwr2_off_macb319;

   wire core06v19;
   wire core08v19;
   wire core10v19;
   wire core12v19;



`endif
//##############################################################################
// black19 boxed19 defines19 
//##############################################################################

endmodule
