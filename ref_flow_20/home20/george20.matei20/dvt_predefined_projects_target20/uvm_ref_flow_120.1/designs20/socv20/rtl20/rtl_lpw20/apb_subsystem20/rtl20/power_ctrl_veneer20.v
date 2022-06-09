//File20 name   : power_ctrl_veneer20.v
//Title20       : 
//Created20     : 1999
//Description20 : 
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------
module power_ctrl_veneer20 (
    //------------------------------------
    // Clocks20 & Reset20
    //------------------------------------
    pclk20,
    nprst20,
    //------------------------------------
    // APB20 programming20 interface
    //------------------------------------
    paddr20,
    psel20,
    penable20,
    pwrite20,
    pwdata20,
    prdata20,
    // mac20 i/f,
    macb3_wakeup20,
    macb2_wakeup20,
    macb1_wakeup20,
    macb0_wakeup20,
    //------------------------------------
    // Scan20 
    //------------------------------------
    scan_in20,
    scan_en20,
    scan_mode20,
    scan_out20,
    int_source_h20,
    //------------------------------------
    // Module20 control20 outputs20
    //------------------------------------
    // SMC20
    rstn_non_srpg_smc20,
    gate_clk_smc20,
    isolate_smc20,
    save_edge_smc20,
    restore_edge_smc20,
    pwr1_on_smc20,
    pwr2_on_smc20,
    // URT20
    rstn_non_srpg_urt20,
    gate_clk_urt20,
    isolate_urt20,
    save_edge_urt20,
    restore_edge_urt20,
    pwr1_on_urt20,
    pwr2_on_urt20,
    // ETH020
    rstn_non_srpg_macb020,
    gate_clk_macb020,
    isolate_macb020,
    save_edge_macb020,
    restore_edge_macb020,
    pwr1_on_macb020,
    pwr2_on_macb020,
    // ETH120
    rstn_non_srpg_macb120,
    gate_clk_macb120,
    isolate_macb120,
    save_edge_macb120,
    restore_edge_macb120,
    pwr1_on_macb120,
    pwr2_on_macb120,
    // ETH220
    rstn_non_srpg_macb220,
    gate_clk_macb220,
    isolate_macb220,
    save_edge_macb220,
    restore_edge_macb220,
    pwr1_on_macb220,
    pwr2_on_macb220,
    // ETH320
    rstn_non_srpg_macb320,
    gate_clk_macb320,
    isolate_macb320,
    save_edge_macb320,
    restore_edge_macb320,
    pwr1_on_macb320,
    pwr2_on_macb320,
    // core20 dvfs20 transitions20
    core06v20,
    core08v20,
    core10v20,
    core12v20,
    pcm_macb_wakeup_int20,
    isolate_mem20,
    
    // transit20 signals20
    mte_smc_start20,
    mte_uart_start20,
    mte_smc_uart_start20,  
    mte_pm_smc_to_default_start20, 
    mte_pm_uart_to_default_start20,
    mte_pm_smc_uart_to_default_start20
  );

//------------------------------------------------------------------------------
// I20/O20 declaration20
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks20 & Reset20
   //------------------------------------
   input             pclk20;
   input             nprst20;
   //------------------------------------
   // APB20 programming20 interface;
   //------------------------------------
   input  [31:0]     paddr20;
   input             psel20;
   input             penable20;
   input             pwrite20;
   input  [31:0]     pwdata20;
   output [31:0]     prdata20;
    // mac20
   input macb3_wakeup20;
   input macb2_wakeup20;
   input macb1_wakeup20;
   input macb0_wakeup20;
   //------------------------------------
   // Scan20
   //------------------------------------
   input             scan_in20;
   input             scan_en20;
   input             scan_mode20;
   output            scan_out20;
   //------------------------------------
   // Module20 control20 outputs20
   input             int_source_h20;
   //------------------------------------
   // SMC20
   output            rstn_non_srpg_smc20;
   output            gate_clk_smc20;
   output            isolate_smc20;
   output            save_edge_smc20;
   output            restore_edge_smc20;
   output            pwr1_on_smc20;
   output            pwr2_on_smc20;
   // URT20
   output            rstn_non_srpg_urt20;
   output            gate_clk_urt20;
   output            isolate_urt20;
   output            save_edge_urt20;
   output            restore_edge_urt20;
   output            pwr1_on_urt20;
   output            pwr2_on_urt20;
   // ETH020
   output            rstn_non_srpg_macb020;
   output            gate_clk_macb020;
   output            isolate_macb020;
   output            save_edge_macb020;
   output            restore_edge_macb020;
   output            pwr1_on_macb020;
   output            pwr2_on_macb020;
   // ETH120
   output            rstn_non_srpg_macb120;
   output            gate_clk_macb120;
   output            isolate_macb120;
   output            save_edge_macb120;
   output            restore_edge_macb120;
   output            pwr1_on_macb120;
   output            pwr2_on_macb120;
   // ETH220
   output            rstn_non_srpg_macb220;
   output            gate_clk_macb220;
   output            isolate_macb220;
   output            save_edge_macb220;
   output            restore_edge_macb220;
   output            pwr1_on_macb220;
   output            pwr2_on_macb220;
   // ETH320
   output            rstn_non_srpg_macb320;
   output            gate_clk_macb320;
   output            isolate_macb320;
   output            save_edge_macb320;
   output            restore_edge_macb320;
   output            pwr1_on_macb320;
   output            pwr2_on_macb320;

   // dvfs20
   output core06v20;
   output core08v20;
   output core10v20;
   output core12v20;
   output pcm_macb_wakeup_int20 ;
   output isolate_mem20 ;

   //transit20  signals20
   output mte_smc_start20;
   output mte_uart_start20;
   output mte_smc_uart_start20;  
   output mte_pm_smc_to_default_start20; 
   output mte_pm_uart_to_default_start20;
   output mte_pm_smc_uart_to_default_start20;



//##############################################################################
// if the POWER_CTRL20 is NOT20 black20 boxed20 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL20

power_ctrl20 i_power_ctrl20(
    // -- Clocks20 & Reset20
    	.pclk20(pclk20), 			//  : in  std_logic20;
    	.nprst20(nprst20), 		//  : in  std_logic20;
    // -- APB20 programming20 interface
    	.paddr20(paddr20), 			//  : in  std_logic_vector20(31 downto20 0);
    	.psel20(psel20), 			//  : in  std_logic20;
    	.penable20(penable20), 		//  : in  std_logic20;
    	.pwrite20(pwrite20), 		//  : in  std_logic20;
    	.pwdata20(pwdata20), 		//  : in  std_logic_vector20(31 downto20 0);
    	.prdata20(prdata20), 		//  : out std_logic_vector20(31 downto20 0);
        .macb3_wakeup20(macb3_wakeup20),
        .macb2_wakeup20(macb2_wakeup20),
        .macb1_wakeup20(macb1_wakeup20),
        .macb0_wakeup20(macb0_wakeup20),
    // -- Module20 control20 outputs20
    	.scan_in20(),			//  : in  std_logic20;
    	.scan_en20(scan_en20),             	//  : in  std_logic20;
    	.scan_mode20(scan_mode20),          //  : in  std_logic20;
    	.scan_out20(),            	//  : out std_logic20;
    	.int_source_h20(int_source_h20),    //  : out std_logic20;
     	.rstn_non_srpg_smc20(rstn_non_srpg_smc20), 		//   : out std_logic20;
    	.gate_clk_smc20(gate_clk_smc20), 	//  : out std_logic20;
    	.isolate_smc20(isolate_smc20), 	//  : out std_logic20;
    	.save_edge_smc20(save_edge_smc20), 	//  : out std_logic20;
    	.restore_edge_smc20(restore_edge_smc20), 	//  : out std_logic20;
    	.pwr1_on_smc20(pwr1_on_smc20), 	//  : out std_logic20;
    	.pwr2_on_smc20(pwr2_on_smc20), 	//  : out std_logic20
	.pwr1_off_smc20(pwr1_off_smc20), 	//  : out std_logic20;
    	.pwr2_off_smc20(pwr2_off_smc20), 	//  : out std_logic20
     	.rstn_non_srpg_urt20(rstn_non_srpg_urt20), 		//   : out std_logic20;
    	.gate_clk_urt20(gate_clk_urt20), 	//  : out std_logic20;
    	.isolate_urt20(isolate_urt20), 	//  : out std_logic20;
    	.save_edge_urt20(save_edge_urt20), 	//  : out std_logic20;
    	.restore_edge_urt20(restore_edge_urt20), 	//  : out std_logic20;
    	.pwr1_on_urt20(pwr1_on_urt20), 	//  : out std_logic20;
    	.pwr2_on_urt20(pwr2_on_urt20), 	//  : out std_logic20;
    	.pwr1_off_urt20(pwr1_off_urt20),    //  : out std_logic20;
    	.pwr2_off_urt20(pwr2_off_urt20),     //  : out std_logic20
     	.rstn_non_srpg_macb020(rstn_non_srpg_macb020), 		//   : out std_logic20;
    	.gate_clk_macb020(gate_clk_macb020), 	//  : out std_logic20;
    	.isolate_macb020(isolate_macb020), 	//  : out std_logic20;
    	.save_edge_macb020(save_edge_macb020), 	//  : out std_logic20;
    	.restore_edge_macb020(restore_edge_macb020), 	//  : out std_logic20;
    	.pwr1_on_macb020(pwr1_on_macb020), 	//  : out std_logic20;
    	.pwr2_on_macb020(pwr2_on_macb020), 	//  : out std_logic20;
    	.pwr1_off_macb020(pwr1_off_macb020),    //  : out std_logic20;
    	.pwr2_off_macb020(pwr2_off_macb020),     //  : out std_logic20
     	.rstn_non_srpg_macb120(rstn_non_srpg_macb120), 		//   : out std_logic20;
    	.gate_clk_macb120(gate_clk_macb120), 	//  : out std_logic20;
    	.isolate_macb120(isolate_macb120), 	//  : out std_logic20;
    	.save_edge_macb120(save_edge_macb120), 	//  : out std_logic20;
    	.restore_edge_macb120(restore_edge_macb120), 	//  : out std_logic20;
    	.pwr1_on_macb120(pwr1_on_macb120), 	//  : out std_logic20;
    	.pwr2_on_macb120(pwr2_on_macb120), 	//  : out std_logic20;
    	.pwr1_off_macb120(pwr1_off_macb120),    //  : out std_logic20;
    	.pwr2_off_macb120(pwr2_off_macb120),     //  : out std_logic20
     	.rstn_non_srpg_macb220(rstn_non_srpg_macb220), 		//   : out std_logic20;
    	.gate_clk_macb220(gate_clk_macb220), 	//  : out std_logic20;
    	.isolate_macb220(isolate_macb220), 	//  : out std_logic20;
    	.save_edge_macb220(save_edge_macb220), 	//  : out std_logic20;
    	.restore_edge_macb220(restore_edge_macb220), 	//  : out std_logic20;
    	.pwr1_on_macb220(pwr1_on_macb220), 	//  : out std_logic20;
    	.pwr2_on_macb220(pwr2_on_macb220), 	//  : out std_logic20;
    	.pwr1_off_macb220(pwr1_off_macb220),    //  : out std_logic20;
    	.pwr2_off_macb220(pwr2_off_macb220),     //  : out std_logic20
     	.rstn_non_srpg_macb320(rstn_non_srpg_macb320), 		//   : out std_logic20;
    	.gate_clk_macb320(gate_clk_macb320), 	//  : out std_logic20;
    	.isolate_macb320(isolate_macb320), 	//  : out std_logic20;
    	.save_edge_macb320(save_edge_macb320), 	//  : out std_logic20;
    	.restore_edge_macb320(restore_edge_macb320), 	//  : out std_logic20;
    	.pwr1_on_macb320(pwr1_on_macb320), 	//  : out std_logic20;
    	.pwr2_on_macb320(pwr2_on_macb320), 	//  : out std_logic20;
    	.pwr1_off_macb320(pwr1_off_macb320),    //  : out std_logic20;
    	.pwr2_off_macb320(pwr2_off_macb320),     //  : out std_logic20
        .rstn_non_srpg_dma20(rstn_non_srpg_dma20 ) ,
        .gate_clk_dma20(gate_clk_dma20      )      ,
        .isolate_dma20(isolate_dma20       )       ,
        .save_edge_dma20(save_edge_dma20   )   ,
        .restore_edge_dma20(restore_edge_dma20   )   ,
        .pwr1_on_dma20(pwr1_on_dma20       )       ,
        .pwr2_on_dma20(pwr2_on_dma20       )       ,
        .pwr1_off_dma20(pwr1_off_dma20      )      ,
        .pwr2_off_dma20(pwr2_off_dma20      )      ,
        
        .rstn_non_srpg_cpu20(rstn_non_srpg_cpu20 ) ,
        .gate_clk_cpu20(gate_clk_cpu20      )      ,
        .isolate_cpu20(isolate_cpu20       )       ,
        .save_edge_cpu20(save_edge_cpu20   )   ,
        .restore_edge_cpu20(restore_edge_cpu20   )   ,
        .pwr1_on_cpu20(pwr1_on_cpu20       )       ,
        .pwr2_on_cpu20(pwr2_on_cpu20       )       ,
        .pwr1_off_cpu20(pwr1_off_cpu20      )      ,
        .pwr2_off_cpu20(pwr2_off_cpu20      )      ,
        
        .rstn_non_srpg_alut20(rstn_non_srpg_alut20 ) ,
        .gate_clk_alut20(gate_clk_alut20      )      ,
        .isolate_alut20(isolate_alut20       )       ,
        .save_edge_alut20(save_edge_alut20   )   ,
        .restore_edge_alut20(restore_edge_alut20   )   ,
        .pwr1_on_alut20(pwr1_on_alut20       )       ,
        .pwr2_on_alut20(pwr2_on_alut20       )       ,
        .pwr1_off_alut20(pwr1_off_alut20      )      ,
        .pwr2_off_alut20(pwr2_off_alut20      )      ,
        
        .rstn_non_srpg_mem20(rstn_non_srpg_mem20 ) ,
        .gate_clk_mem20(gate_clk_mem20      )      ,
        .isolate_mem20(isolate_mem20       )       ,
        .save_edge_mem20(save_edge_mem20   )   ,
        .restore_edge_mem20(restore_edge_mem20   )   ,
        .pwr1_on_mem20(pwr1_on_mem20       )       ,
        .pwr2_on_mem20(pwr2_on_mem20       )       ,
        .pwr1_off_mem20(pwr1_off_mem20      )      ,
        .pwr2_off_mem20(pwr2_off_mem20      )      ,

    	.core06v20(core06v20),     //  : out std_logic20
    	.core08v20(core08v20),     //  : out std_logic20
    	.core10v20(core10v20),     //  : out std_logic20
    	.core12v20(core12v20),     //  : out std_logic20
        .pcm_macb_wakeup_int20(pcm_macb_wakeup_int20),
        .mte_smc_start20(mte_smc_start20),
        .mte_uart_start20(mte_uart_start20),
        .mte_smc_uart_start20(mte_smc_uart_start20),  
        .mte_pm_smc_to_default_start20(mte_pm_smc_to_default_start20), 
        .mte_pm_uart_to_default_start20(mte_pm_uart_to_default_start20),
        .mte_pm_smc_uart_to_default_start20(mte_pm_smc_uart_to_default_start20)
);


`else 
//##############################################################################
// if the POWER_CTRL20 is black20 boxed20 
//##############################################################################

   //------------------------------------
   // Clocks20 & Reset20
   //------------------------------------
   wire              pclk20;
   wire              nprst20;
   //------------------------------------
   // APB20 programming20 interface;
   //------------------------------------
   wire   [31:0]     paddr20;
   wire              psel20;
   wire              penable20;
   wire              pwrite20;
   wire   [31:0]     pwdata20;
   reg    [31:0]     prdata20;
   //------------------------------------
   // Scan20
   //------------------------------------
   wire              scan_in20;
   wire              scan_en20;
   wire              scan_mode20;
   reg               scan_out20;
   //------------------------------------
   // Module20 control20 outputs20
   //------------------------------------
   // SMC20;
   reg               rstn_non_srpg_smc20;
   reg               gate_clk_smc20;
   reg               isolate_smc20;
   reg               save_edge_smc20;
   reg               restore_edge_smc20;
   reg               pwr1_on_smc20;
   reg               pwr2_on_smc20;
   wire              pwr1_off_smc20;
   wire              pwr2_off_smc20;

   // URT20;
   reg               rstn_non_srpg_urt20;
   reg               gate_clk_urt20;
   reg               isolate_urt20;
   reg               save_edge_urt20;
   reg               restore_edge_urt20;
   reg               pwr1_on_urt20;
   reg               pwr2_on_urt20;
   wire              pwr1_off_urt20;
   wire              pwr2_off_urt20;

   // ETH020
   reg               rstn_non_srpg_macb020;
   reg               gate_clk_macb020;
   reg               isolate_macb020;
   reg               save_edge_macb020;
   reg               restore_edge_macb020;
   reg               pwr1_on_macb020;
   reg               pwr2_on_macb020;
   wire              pwr1_off_macb020;
   wire              pwr2_off_macb020;
   // ETH120
   reg               rstn_non_srpg_macb120;
   reg               gate_clk_macb120;
   reg               isolate_macb120;
   reg               save_edge_macb120;
   reg               restore_edge_macb120;
   reg               pwr1_on_macb120;
   reg               pwr2_on_macb120;
   wire              pwr1_off_macb120;
   wire              pwr2_off_macb120;
   // ETH220
   reg               rstn_non_srpg_macb220;
   reg               gate_clk_macb220;
   reg               isolate_macb220;
   reg               save_edge_macb220;
   reg               restore_edge_macb220;
   reg               pwr1_on_macb220;
   reg               pwr2_on_macb220;
   wire              pwr1_off_macb220;
   wire              pwr2_off_macb220;
   // ETH320
   reg               rstn_non_srpg_macb320;
   reg               gate_clk_macb320;
   reg               isolate_macb320;
   reg               save_edge_macb320;
   reg               restore_edge_macb320;
   reg               pwr1_on_macb320;
   reg               pwr2_on_macb320;
   wire              pwr1_off_macb320;
   wire              pwr2_off_macb320;

   wire core06v20;
   wire core08v20;
   wire core10v20;
   wire core12v20;



`endif
//##############################################################################
// black20 boxed20 defines20 
//##############################################################################

endmodule
