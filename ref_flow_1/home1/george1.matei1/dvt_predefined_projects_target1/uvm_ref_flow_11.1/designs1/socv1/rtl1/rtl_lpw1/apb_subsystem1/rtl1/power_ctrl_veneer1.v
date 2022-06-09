//File1 name   : power_ctrl_veneer1.v
//Title1       : 
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------
module power_ctrl_veneer1 (
    //------------------------------------
    // Clocks1 & Reset1
    //------------------------------------
    pclk1,
    nprst1,
    //------------------------------------
    // APB1 programming1 interface
    //------------------------------------
    paddr1,
    psel1,
    penable1,
    pwrite1,
    pwdata1,
    prdata1,
    // mac1 i/f,
    macb3_wakeup1,
    macb2_wakeup1,
    macb1_wakeup1,
    macb0_wakeup1,
    //------------------------------------
    // Scan1 
    //------------------------------------
    scan_in1,
    scan_en1,
    scan_mode1,
    scan_out1,
    int_source_h1,
    //------------------------------------
    // Module1 control1 outputs1
    //------------------------------------
    // SMC1
    rstn_non_srpg_smc1,
    gate_clk_smc1,
    isolate_smc1,
    save_edge_smc1,
    restore_edge_smc1,
    pwr1_on_smc1,
    pwr2_on_smc1,
    // URT1
    rstn_non_srpg_urt1,
    gate_clk_urt1,
    isolate_urt1,
    save_edge_urt1,
    restore_edge_urt1,
    pwr1_on_urt1,
    pwr2_on_urt1,
    // ETH01
    rstn_non_srpg_macb01,
    gate_clk_macb01,
    isolate_macb01,
    save_edge_macb01,
    restore_edge_macb01,
    pwr1_on_macb01,
    pwr2_on_macb01,
    // ETH11
    rstn_non_srpg_macb11,
    gate_clk_macb11,
    isolate_macb11,
    save_edge_macb11,
    restore_edge_macb11,
    pwr1_on_macb11,
    pwr2_on_macb11,
    // ETH21
    rstn_non_srpg_macb21,
    gate_clk_macb21,
    isolate_macb21,
    save_edge_macb21,
    restore_edge_macb21,
    pwr1_on_macb21,
    pwr2_on_macb21,
    // ETH31
    rstn_non_srpg_macb31,
    gate_clk_macb31,
    isolate_macb31,
    save_edge_macb31,
    restore_edge_macb31,
    pwr1_on_macb31,
    pwr2_on_macb31,
    // core1 dvfs1 transitions1
    core06v1,
    core08v1,
    core10v1,
    core12v1,
    pcm_macb_wakeup_int1,
    isolate_mem1,
    
    // transit1 signals1
    mte_smc_start1,
    mte_uart_start1,
    mte_smc_uart_start1,  
    mte_pm_smc_to_default_start1, 
    mte_pm_uart_to_default_start1,
    mte_pm_smc_uart_to_default_start1
  );

//------------------------------------------------------------------------------
// I1/O1 declaration1
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks1 & Reset1
   //------------------------------------
   input             pclk1;
   input             nprst1;
   //------------------------------------
   // APB1 programming1 interface;
   //------------------------------------
   input  [31:0]     paddr1;
   input             psel1;
   input             penable1;
   input             pwrite1;
   input  [31:0]     pwdata1;
   output [31:0]     prdata1;
    // mac1
   input macb3_wakeup1;
   input macb2_wakeup1;
   input macb1_wakeup1;
   input macb0_wakeup1;
   //------------------------------------
   // Scan1
   //------------------------------------
   input             scan_in1;
   input             scan_en1;
   input             scan_mode1;
   output            scan_out1;
   //------------------------------------
   // Module1 control1 outputs1
   input             int_source_h1;
   //------------------------------------
   // SMC1
   output            rstn_non_srpg_smc1;
   output            gate_clk_smc1;
   output            isolate_smc1;
   output            save_edge_smc1;
   output            restore_edge_smc1;
   output            pwr1_on_smc1;
   output            pwr2_on_smc1;
   // URT1
   output            rstn_non_srpg_urt1;
   output            gate_clk_urt1;
   output            isolate_urt1;
   output            save_edge_urt1;
   output            restore_edge_urt1;
   output            pwr1_on_urt1;
   output            pwr2_on_urt1;
   // ETH01
   output            rstn_non_srpg_macb01;
   output            gate_clk_macb01;
   output            isolate_macb01;
   output            save_edge_macb01;
   output            restore_edge_macb01;
   output            pwr1_on_macb01;
   output            pwr2_on_macb01;
   // ETH11
   output            rstn_non_srpg_macb11;
   output            gate_clk_macb11;
   output            isolate_macb11;
   output            save_edge_macb11;
   output            restore_edge_macb11;
   output            pwr1_on_macb11;
   output            pwr2_on_macb11;
   // ETH21
   output            rstn_non_srpg_macb21;
   output            gate_clk_macb21;
   output            isolate_macb21;
   output            save_edge_macb21;
   output            restore_edge_macb21;
   output            pwr1_on_macb21;
   output            pwr2_on_macb21;
   // ETH31
   output            rstn_non_srpg_macb31;
   output            gate_clk_macb31;
   output            isolate_macb31;
   output            save_edge_macb31;
   output            restore_edge_macb31;
   output            pwr1_on_macb31;
   output            pwr2_on_macb31;

   // dvfs1
   output core06v1;
   output core08v1;
   output core10v1;
   output core12v1;
   output pcm_macb_wakeup_int1 ;
   output isolate_mem1 ;

   //transit1  signals1
   output mte_smc_start1;
   output mte_uart_start1;
   output mte_smc_uart_start1;  
   output mte_pm_smc_to_default_start1; 
   output mte_pm_uart_to_default_start1;
   output mte_pm_smc_uart_to_default_start1;



//##############################################################################
// if the POWER_CTRL1 is NOT1 black1 boxed1 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL1

power_ctrl1 i_power_ctrl1(
    // -- Clocks1 & Reset1
    	.pclk1(pclk1), 			//  : in  std_logic1;
    	.nprst1(nprst1), 		//  : in  std_logic1;
    // -- APB1 programming1 interface
    	.paddr1(paddr1), 			//  : in  std_logic_vector1(31 downto1 0);
    	.psel1(psel1), 			//  : in  std_logic1;
    	.penable1(penable1), 		//  : in  std_logic1;
    	.pwrite1(pwrite1), 		//  : in  std_logic1;
    	.pwdata1(pwdata1), 		//  : in  std_logic_vector1(31 downto1 0);
    	.prdata1(prdata1), 		//  : out std_logic_vector1(31 downto1 0);
        .macb3_wakeup1(macb3_wakeup1),
        .macb2_wakeup1(macb2_wakeup1),
        .macb1_wakeup1(macb1_wakeup1),
        .macb0_wakeup1(macb0_wakeup1),
    // -- Module1 control1 outputs1
    	.scan_in1(),			//  : in  std_logic1;
    	.scan_en1(scan_en1),             	//  : in  std_logic1;
    	.scan_mode1(scan_mode1),          //  : in  std_logic1;
    	.scan_out1(),            	//  : out std_logic1;
    	.int_source_h1(int_source_h1),    //  : out std_logic1;
     	.rstn_non_srpg_smc1(rstn_non_srpg_smc1), 		//   : out std_logic1;
    	.gate_clk_smc1(gate_clk_smc1), 	//  : out std_logic1;
    	.isolate_smc1(isolate_smc1), 	//  : out std_logic1;
    	.save_edge_smc1(save_edge_smc1), 	//  : out std_logic1;
    	.restore_edge_smc1(restore_edge_smc1), 	//  : out std_logic1;
    	.pwr1_on_smc1(pwr1_on_smc1), 	//  : out std_logic1;
    	.pwr2_on_smc1(pwr2_on_smc1), 	//  : out std_logic1
	.pwr1_off_smc1(pwr1_off_smc1), 	//  : out std_logic1;
    	.pwr2_off_smc1(pwr2_off_smc1), 	//  : out std_logic1
     	.rstn_non_srpg_urt1(rstn_non_srpg_urt1), 		//   : out std_logic1;
    	.gate_clk_urt1(gate_clk_urt1), 	//  : out std_logic1;
    	.isolate_urt1(isolate_urt1), 	//  : out std_logic1;
    	.save_edge_urt1(save_edge_urt1), 	//  : out std_logic1;
    	.restore_edge_urt1(restore_edge_urt1), 	//  : out std_logic1;
    	.pwr1_on_urt1(pwr1_on_urt1), 	//  : out std_logic1;
    	.pwr2_on_urt1(pwr2_on_urt1), 	//  : out std_logic1;
    	.pwr1_off_urt1(pwr1_off_urt1),    //  : out std_logic1;
    	.pwr2_off_urt1(pwr2_off_urt1),     //  : out std_logic1
     	.rstn_non_srpg_macb01(rstn_non_srpg_macb01), 		//   : out std_logic1;
    	.gate_clk_macb01(gate_clk_macb01), 	//  : out std_logic1;
    	.isolate_macb01(isolate_macb01), 	//  : out std_logic1;
    	.save_edge_macb01(save_edge_macb01), 	//  : out std_logic1;
    	.restore_edge_macb01(restore_edge_macb01), 	//  : out std_logic1;
    	.pwr1_on_macb01(pwr1_on_macb01), 	//  : out std_logic1;
    	.pwr2_on_macb01(pwr2_on_macb01), 	//  : out std_logic1;
    	.pwr1_off_macb01(pwr1_off_macb01),    //  : out std_logic1;
    	.pwr2_off_macb01(pwr2_off_macb01),     //  : out std_logic1
     	.rstn_non_srpg_macb11(rstn_non_srpg_macb11), 		//   : out std_logic1;
    	.gate_clk_macb11(gate_clk_macb11), 	//  : out std_logic1;
    	.isolate_macb11(isolate_macb11), 	//  : out std_logic1;
    	.save_edge_macb11(save_edge_macb11), 	//  : out std_logic1;
    	.restore_edge_macb11(restore_edge_macb11), 	//  : out std_logic1;
    	.pwr1_on_macb11(pwr1_on_macb11), 	//  : out std_logic1;
    	.pwr2_on_macb11(pwr2_on_macb11), 	//  : out std_logic1;
    	.pwr1_off_macb11(pwr1_off_macb11),    //  : out std_logic1;
    	.pwr2_off_macb11(pwr2_off_macb11),     //  : out std_logic1
     	.rstn_non_srpg_macb21(rstn_non_srpg_macb21), 		//   : out std_logic1;
    	.gate_clk_macb21(gate_clk_macb21), 	//  : out std_logic1;
    	.isolate_macb21(isolate_macb21), 	//  : out std_logic1;
    	.save_edge_macb21(save_edge_macb21), 	//  : out std_logic1;
    	.restore_edge_macb21(restore_edge_macb21), 	//  : out std_logic1;
    	.pwr1_on_macb21(pwr1_on_macb21), 	//  : out std_logic1;
    	.pwr2_on_macb21(pwr2_on_macb21), 	//  : out std_logic1;
    	.pwr1_off_macb21(pwr1_off_macb21),    //  : out std_logic1;
    	.pwr2_off_macb21(pwr2_off_macb21),     //  : out std_logic1
     	.rstn_non_srpg_macb31(rstn_non_srpg_macb31), 		//   : out std_logic1;
    	.gate_clk_macb31(gate_clk_macb31), 	//  : out std_logic1;
    	.isolate_macb31(isolate_macb31), 	//  : out std_logic1;
    	.save_edge_macb31(save_edge_macb31), 	//  : out std_logic1;
    	.restore_edge_macb31(restore_edge_macb31), 	//  : out std_logic1;
    	.pwr1_on_macb31(pwr1_on_macb31), 	//  : out std_logic1;
    	.pwr2_on_macb31(pwr2_on_macb31), 	//  : out std_logic1;
    	.pwr1_off_macb31(pwr1_off_macb31),    //  : out std_logic1;
    	.pwr2_off_macb31(pwr2_off_macb31),     //  : out std_logic1
        .rstn_non_srpg_dma1(rstn_non_srpg_dma1 ) ,
        .gate_clk_dma1(gate_clk_dma1      )      ,
        .isolate_dma1(isolate_dma1       )       ,
        .save_edge_dma1(save_edge_dma1   )   ,
        .restore_edge_dma1(restore_edge_dma1   )   ,
        .pwr1_on_dma1(pwr1_on_dma1       )       ,
        .pwr2_on_dma1(pwr2_on_dma1       )       ,
        .pwr1_off_dma1(pwr1_off_dma1      )      ,
        .pwr2_off_dma1(pwr2_off_dma1      )      ,
        
        .rstn_non_srpg_cpu1(rstn_non_srpg_cpu1 ) ,
        .gate_clk_cpu1(gate_clk_cpu1      )      ,
        .isolate_cpu1(isolate_cpu1       )       ,
        .save_edge_cpu1(save_edge_cpu1   )   ,
        .restore_edge_cpu1(restore_edge_cpu1   )   ,
        .pwr1_on_cpu1(pwr1_on_cpu1       )       ,
        .pwr2_on_cpu1(pwr2_on_cpu1       )       ,
        .pwr1_off_cpu1(pwr1_off_cpu1      )      ,
        .pwr2_off_cpu1(pwr2_off_cpu1      )      ,
        
        .rstn_non_srpg_alut1(rstn_non_srpg_alut1 ) ,
        .gate_clk_alut1(gate_clk_alut1      )      ,
        .isolate_alut1(isolate_alut1       )       ,
        .save_edge_alut1(save_edge_alut1   )   ,
        .restore_edge_alut1(restore_edge_alut1   )   ,
        .pwr1_on_alut1(pwr1_on_alut1       )       ,
        .pwr2_on_alut1(pwr2_on_alut1       )       ,
        .pwr1_off_alut1(pwr1_off_alut1      )      ,
        .pwr2_off_alut1(pwr2_off_alut1      )      ,
        
        .rstn_non_srpg_mem1(rstn_non_srpg_mem1 ) ,
        .gate_clk_mem1(gate_clk_mem1      )      ,
        .isolate_mem1(isolate_mem1       )       ,
        .save_edge_mem1(save_edge_mem1   )   ,
        .restore_edge_mem1(restore_edge_mem1   )   ,
        .pwr1_on_mem1(pwr1_on_mem1       )       ,
        .pwr2_on_mem1(pwr2_on_mem1       )       ,
        .pwr1_off_mem1(pwr1_off_mem1      )      ,
        .pwr2_off_mem1(pwr2_off_mem1      )      ,

    	.core06v1(core06v1),     //  : out std_logic1
    	.core08v1(core08v1),     //  : out std_logic1
    	.core10v1(core10v1),     //  : out std_logic1
    	.core12v1(core12v1),     //  : out std_logic1
        .pcm_macb_wakeup_int1(pcm_macb_wakeup_int1),
        .mte_smc_start1(mte_smc_start1),
        .mte_uart_start1(mte_uart_start1),
        .mte_smc_uart_start1(mte_smc_uart_start1),  
        .mte_pm_smc_to_default_start1(mte_pm_smc_to_default_start1), 
        .mte_pm_uart_to_default_start1(mte_pm_uart_to_default_start1),
        .mte_pm_smc_uart_to_default_start1(mte_pm_smc_uart_to_default_start1)
);


`else 
//##############################################################################
// if the POWER_CTRL1 is black1 boxed1 
//##############################################################################

   //------------------------------------
   // Clocks1 & Reset1
   //------------------------------------
   wire              pclk1;
   wire              nprst1;
   //------------------------------------
   // APB1 programming1 interface;
   //------------------------------------
   wire   [31:0]     paddr1;
   wire              psel1;
   wire              penable1;
   wire              pwrite1;
   wire   [31:0]     pwdata1;
   reg    [31:0]     prdata1;
   //------------------------------------
   // Scan1
   //------------------------------------
   wire              scan_in1;
   wire              scan_en1;
   wire              scan_mode1;
   reg               scan_out1;
   //------------------------------------
   // Module1 control1 outputs1
   //------------------------------------
   // SMC1;
   reg               rstn_non_srpg_smc1;
   reg               gate_clk_smc1;
   reg               isolate_smc1;
   reg               save_edge_smc1;
   reg               restore_edge_smc1;
   reg               pwr1_on_smc1;
   reg               pwr2_on_smc1;
   wire              pwr1_off_smc1;
   wire              pwr2_off_smc1;

   // URT1;
   reg               rstn_non_srpg_urt1;
   reg               gate_clk_urt1;
   reg               isolate_urt1;
   reg               save_edge_urt1;
   reg               restore_edge_urt1;
   reg               pwr1_on_urt1;
   reg               pwr2_on_urt1;
   wire              pwr1_off_urt1;
   wire              pwr2_off_urt1;

   // ETH01
   reg               rstn_non_srpg_macb01;
   reg               gate_clk_macb01;
   reg               isolate_macb01;
   reg               save_edge_macb01;
   reg               restore_edge_macb01;
   reg               pwr1_on_macb01;
   reg               pwr2_on_macb01;
   wire              pwr1_off_macb01;
   wire              pwr2_off_macb01;
   // ETH11
   reg               rstn_non_srpg_macb11;
   reg               gate_clk_macb11;
   reg               isolate_macb11;
   reg               save_edge_macb11;
   reg               restore_edge_macb11;
   reg               pwr1_on_macb11;
   reg               pwr2_on_macb11;
   wire              pwr1_off_macb11;
   wire              pwr2_off_macb11;
   // ETH21
   reg               rstn_non_srpg_macb21;
   reg               gate_clk_macb21;
   reg               isolate_macb21;
   reg               save_edge_macb21;
   reg               restore_edge_macb21;
   reg               pwr1_on_macb21;
   reg               pwr2_on_macb21;
   wire              pwr1_off_macb21;
   wire              pwr2_off_macb21;
   // ETH31
   reg               rstn_non_srpg_macb31;
   reg               gate_clk_macb31;
   reg               isolate_macb31;
   reg               save_edge_macb31;
   reg               restore_edge_macb31;
   reg               pwr1_on_macb31;
   reg               pwr2_on_macb31;
   wire              pwr1_off_macb31;
   wire              pwr2_off_macb31;

   wire core06v1;
   wire core08v1;
   wire core10v1;
   wire core12v1;



`endif
//##############################################################################
// black1 boxed1 defines1 
//##############################################################################

endmodule
