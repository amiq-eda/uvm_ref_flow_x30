//File24 name   : power_ctrl_veneer24.v
//Title24       : 
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------
module power_ctrl_veneer24 (
    //------------------------------------
    // Clocks24 & Reset24
    //------------------------------------
    pclk24,
    nprst24,
    //------------------------------------
    // APB24 programming24 interface
    //------------------------------------
    paddr24,
    psel24,
    penable24,
    pwrite24,
    pwdata24,
    prdata24,
    // mac24 i/f,
    macb3_wakeup24,
    macb2_wakeup24,
    macb1_wakeup24,
    macb0_wakeup24,
    //------------------------------------
    // Scan24 
    //------------------------------------
    scan_in24,
    scan_en24,
    scan_mode24,
    scan_out24,
    int_source_h24,
    //------------------------------------
    // Module24 control24 outputs24
    //------------------------------------
    // SMC24
    rstn_non_srpg_smc24,
    gate_clk_smc24,
    isolate_smc24,
    save_edge_smc24,
    restore_edge_smc24,
    pwr1_on_smc24,
    pwr2_on_smc24,
    // URT24
    rstn_non_srpg_urt24,
    gate_clk_urt24,
    isolate_urt24,
    save_edge_urt24,
    restore_edge_urt24,
    pwr1_on_urt24,
    pwr2_on_urt24,
    // ETH024
    rstn_non_srpg_macb024,
    gate_clk_macb024,
    isolate_macb024,
    save_edge_macb024,
    restore_edge_macb024,
    pwr1_on_macb024,
    pwr2_on_macb024,
    // ETH124
    rstn_non_srpg_macb124,
    gate_clk_macb124,
    isolate_macb124,
    save_edge_macb124,
    restore_edge_macb124,
    pwr1_on_macb124,
    pwr2_on_macb124,
    // ETH224
    rstn_non_srpg_macb224,
    gate_clk_macb224,
    isolate_macb224,
    save_edge_macb224,
    restore_edge_macb224,
    pwr1_on_macb224,
    pwr2_on_macb224,
    // ETH324
    rstn_non_srpg_macb324,
    gate_clk_macb324,
    isolate_macb324,
    save_edge_macb324,
    restore_edge_macb324,
    pwr1_on_macb324,
    pwr2_on_macb324,
    // core24 dvfs24 transitions24
    core06v24,
    core08v24,
    core10v24,
    core12v24,
    pcm_macb_wakeup_int24,
    isolate_mem24,
    
    // transit24 signals24
    mte_smc_start24,
    mte_uart_start24,
    mte_smc_uart_start24,  
    mte_pm_smc_to_default_start24, 
    mte_pm_uart_to_default_start24,
    mte_pm_smc_uart_to_default_start24
  );

//------------------------------------------------------------------------------
// I24/O24 declaration24
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks24 & Reset24
   //------------------------------------
   input             pclk24;
   input             nprst24;
   //------------------------------------
   // APB24 programming24 interface;
   //------------------------------------
   input  [31:0]     paddr24;
   input             psel24;
   input             penable24;
   input             pwrite24;
   input  [31:0]     pwdata24;
   output [31:0]     prdata24;
    // mac24
   input macb3_wakeup24;
   input macb2_wakeup24;
   input macb1_wakeup24;
   input macb0_wakeup24;
   //------------------------------------
   // Scan24
   //------------------------------------
   input             scan_in24;
   input             scan_en24;
   input             scan_mode24;
   output            scan_out24;
   //------------------------------------
   // Module24 control24 outputs24
   input             int_source_h24;
   //------------------------------------
   // SMC24
   output            rstn_non_srpg_smc24;
   output            gate_clk_smc24;
   output            isolate_smc24;
   output            save_edge_smc24;
   output            restore_edge_smc24;
   output            pwr1_on_smc24;
   output            pwr2_on_smc24;
   // URT24
   output            rstn_non_srpg_urt24;
   output            gate_clk_urt24;
   output            isolate_urt24;
   output            save_edge_urt24;
   output            restore_edge_urt24;
   output            pwr1_on_urt24;
   output            pwr2_on_urt24;
   // ETH024
   output            rstn_non_srpg_macb024;
   output            gate_clk_macb024;
   output            isolate_macb024;
   output            save_edge_macb024;
   output            restore_edge_macb024;
   output            pwr1_on_macb024;
   output            pwr2_on_macb024;
   // ETH124
   output            rstn_non_srpg_macb124;
   output            gate_clk_macb124;
   output            isolate_macb124;
   output            save_edge_macb124;
   output            restore_edge_macb124;
   output            pwr1_on_macb124;
   output            pwr2_on_macb124;
   // ETH224
   output            rstn_non_srpg_macb224;
   output            gate_clk_macb224;
   output            isolate_macb224;
   output            save_edge_macb224;
   output            restore_edge_macb224;
   output            pwr1_on_macb224;
   output            pwr2_on_macb224;
   // ETH324
   output            rstn_non_srpg_macb324;
   output            gate_clk_macb324;
   output            isolate_macb324;
   output            save_edge_macb324;
   output            restore_edge_macb324;
   output            pwr1_on_macb324;
   output            pwr2_on_macb324;

   // dvfs24
   output core06v24;
   output core08v24;
   output core10v24;
   output core12v24;
   output pcm_macb_wakeup_int24 ;
   output isolate_mem24 ;

   //transit24  signals24
   output mte_smc_start24;
   output mte_uart_start24;
   output mte_smc_uart_start24;  
   output mte_pm_smc_to_default_start24; 
   output mte_pm_uart_to_default_start24;
   output mte_pm_smc_uart_to_default_start24;



//##############################################################################
// if the POWER_CTRL24 is NOT24 black24 boxed24 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL24

power_ctrl24 i_power_ctrl24(
    // -- Clocks24 & Reset24
    	.pclk24(pclk24), 			//  : in  std_logic24;
    	.nprst24(nprst24), 		//  : in  std_logic24;
    // -- APB24 programming24 interface
    	.paddr24(paddr24), 			//  : in  std_logic_vector24(31 downto24 0);
    	.psel24(psel24), 			//  : in  std_logic24;
    	.penable24(penable24), 		//  : in  std_logic24;
    	.pwrite24(pwrite24), 		//  : in  std_logic24;
    	.pwdata24(pwdata24), 		//  : in  std_logic_vector24(31 downto24 0);
    	.prdata24(prdata24), 		//  : out std_logic_vector24(31 downto24 0);
        .macb3_wakeup24(macb3_wakeup24),
        .macb2_wakeup24(macb2_wakeup24),
        .macb1_wakeup24(macb1_wakeup24),
        .macb0_wakeup24(macb0_wakeup24),
    // -- Module24 control24 outputs24
    	.scan_in24(),			//  : in  std_logic24;
    	.scan_en24(scan_en24),             	//  : in  std_logic24;
    	.scan_mode24(scan_mode24),          //  : in  std_logic24;
    	.scan_out24(),            	//  : out std_logic24;
    	.int_source_h24(int_source_h24),    //  : out std_logic24;
     	.rstn_non_srpg_smc24(rstn_non_srpg_smc24), 		//   : out std_logic24;
    	.gate_clk_smc24(gate_clk_smc24), 	//  : out std_logic24;
    	.isolate_smc24(isolate_smc24), 	//  : out std_logic24;
    	.save_edge_smc24(save_edge_smc24), 	//  : out std_logic24;
    	.restore_edge_smc24(restore_edge_smc24), 	//  : out std_logic24;
    	.pwr1_on_smc24(pwr1_on_smc24), 	//  : out std_logic24;
    	.pwr2_on_smc24(pwr2_on_smc24), 	//  : out std_logic24
	.pwr1_off_smc24(pwr1_off_smc24), 	//  : out std_logic24;
    	.pwr2_off_smc24(pwr2_off_smc24), 	//  : out std_logic24
     	.rstn_non_srpg_urt24(rstn_non_srpg_urt24), 		//   : out std_logic24;
    	.gate_clk_urt24(gate_clk_urt24), 	//  : out std_logic24;
    	.isolate_urt24(isolate_urt24), 	//  : out std_logic24;
    	.save_edge_urt24(save_edge_urt24), 	//  : out std_logic24;
    	.restore_edge_urt24(restore_edge_urt24), 	//  : out std_logic24;
    	.pwr1_on_urt24(pwr1_on_urt24), 	//  : out std_logic24;
    	.pwr2_on_urt24(pwr2_on_urt24), 	//  : out std_logic24;
    	.pwr1_off_urt24(pwr1_off_urt24),    //  : out std_logic24;
    	.pwr2_off_urt24(pwr2_off_urt24),     //  : out std_logic24
     	.rstn_non_srpg_macb024(rstn_non_srpg_macb024), 		//   : out std_logic24;
    	.gate_clk_macb024(gate_clk_macb024), 	//  : out std_logic24;
    	.isolate_macb024(isolate_macb024), 	//  : out std_logic24;
    	.save_edge_macb024(save_edge_macb024), 	//  : out std_logic24;
    	.restore_edge_macb024(restore_edge_macb024), 	//  : out std_logic24;
    	.pwr1_on_macb024(pwr1_on_macb024), 	//  : out std_logic24;
    	.pwr2_on_macb024(pwr2_on_macb024), 	//  : out std_logic24;
    	.pwr1_off_macb024(pwr1_off_macb024),    //  : out std_logic24;
    	.pwr2_off_macb024(pwr2_off_macb024),     //  : out std_logic24
     	.rstn_non_srpg_macb124(rstn_non_srpg_macb124), 		//   : out std_logic24;
    	.gate_clk_macb124(gate_clk_macb124), 	//  : out std_logic24;
    	.isolate_macb124(isolate_macb124), 	//  : out std_logic24;
    	.save_edge_macb124(save_edge_macb124), 	//  : out std_logic24;
    	.restore_edge_macb124(restore_edge_macb124), 	//  : out std_logic24;
    	.pwr1_on_macb124(pwr1_on_macb124), 	//  : out std_logic24;
    	.pwr2_on_macb124(pwr2_on_macb124), 	//  : out std_logic24;
    	.pwr1_off_macb124(pwr1_off_macb124),    //  : out std_logic24;
    	.pwr2_off_macb124(pwr2_off_macb124),     //  : out std_logic24
     	.rstn_non_srpg_macb224(rstn_non_srpg_macb224), 		//   : out std_logic24;
    	.gate_clk_macb224(gate_clk_macb224), 	//  : out std_logic24;
    	.isolate_macb224(isolate_macb224), 	//  : out std_logic24;
    	.save_edge_macb224(save_edge_macb224), 	//  : out std_logic24;
    	.restore_edge_macb224(restore_edge_macb224), 	//  : out std_logic24;
    	.pwr1_on_macb224(pwr1_on_macb224), 	//  : out std_logic24;
    	.pwr2_on_macb224(pwr2_on_macb224), 	//  : out std_logic24;
    	.pwr1_off_macb224(pwr1_off_macb224),    //  : out std_logic24;
    	.pwr2_off_macb224(pwr2_off_macb224),     //  : out std_logic24
     	.rstn_non_srpg_macb324(rstn_non_srpg_macb324), 		//   : out std_logic24;
    	.gate_clk_macb324(gate_clk_macb324), 	//  : out std_logic24;
    	.isolate_macb324(isolate_macb324), 	//  : out std_logic24;
    	.save_edge_macb324(save_edge_macb324), 	//  : out std_logic24;
    	.restore_edge_macb324(restore_edge_macb324), 	//  : out std_logic24;
    	.pwr1_on_macb324(pwr1_on_macb324), 	//  : out std_logic24;
    	.pwr2_on_macb324(pwr2_on_macb324), 	//  : out std_logic24;
    	.pwr1_off_macb324(pwr1_off_macb324),    //  : out std_logic24;
    	.pwr2_off_macb324(pwr2_off_macb324),     //  : out std_logic24
        .rstn_non_srpg_dma24(rstn_non_srpg_dma24 ) ,
        .gate_clk_dma24(gate_clk_dma24      )      ,
        .isolate_dma24(isolate_dma24       )       ,
        .save_edge_dma24(save_edge_dma24   )   ,
        .restore_edge_dma24(restore_edge_dma24   )   ,
        .pwr1_on_dma24(pwr1_on_dma24       )       ,
        .pwr2_on_dma24(pwr2_on_dma24       )       ,
        .pwr1_off_dma24(pwr1_off_dma24      )      ,
        .pwr2_off_dma24(pwr2_off_dma24      )      ,
        
        .rstn_non_srpg_cpu24(rstn_non_srpg_cpu24 ) ,
        .gate_clk_cpu24(gate_clk_cpu24      )      ,
        .isolate_cpu24(isolate_cpu24       )       ,
        .save_edge_cpu24(save_edge_cpu24   )   ,
        .restore_edge_cpu24(restore_edge_cpu24   )   ,
        .pwr1_on_cpu24(pwr1_on_cpu24       )       ,
        .pwr2_on_cpu24(pwr2_on_cpu24       )       ,
        .pwr1_off_cpu24(pwr1_off_cpu24      )      ,
        .pwr2_off_cpu24(pwr2_off_cpu24      )      ,
        
        .rstn_non_srpg_alut24(rstn_non_srpg_alut24 ) ,
        .gate_clk_alut24(gate_clk_alut24      )      ,
        .isolate_alut24(isolate_alut24       )       ,
        .save_edge_alut24(save_edge_alut24   )   ,
        .restore_edge_alut24(restore_edge_alut24   )   ,
        .pwr1_on_alut24(pwr1_on_alut24       )       ,
        .pwr2_on_alut24(pwr2_on_alut24       )       ,
        .pwr1_off_alut24(pwr1_off_alut24      )      ,
        .pwr2_off_alut24(pwr2_off_alut24      )      ,
        
        .rstn_non_srpg_mem24(rstn_non_srpg_mem24 ) ,
        .gate_clk_mem24(gate_clk_mem24      )      ,
        .isolate_mem24(isolate_mem24       )       ,
        .save_edge_mem24(save_edge_mem24   )   ,
        .restore_edge_mem24(restore_edge_mem24   )   ,
        .pwr1_on_mem24(pwr1_on_mem24       )       ,
        .pwr2_on_mem24(pwr2_on_mem24       )       ,
        .pwr1_off_mem24(pwr1_off_mem24      )      ,
        .pwr2_off_mem24(pwr2_off_mem24      )      ,

    	.core06v24(core06v24),     //  : out std_logic24
    	.core08v24(core08v24),     //  : out std_logic24
    	.core10v24(core10v24),     //  : out std_logic24
    	.core12v24(core12v24),     //  : out std_logic24
        .pcm_macb_wakeup_int24(pcm_macb_wakeup_int24),
        .mte_smc_start24(mte_smc_start24),
        .mte_uart_start24(mte_uart_start24),
        .mte_smc_uart_start24(mte_smc_uart_start24),  
        .mte_pm_smc_to_default_start24(mte_pm_smc_to_default_start24), 
        .mte_pm_uart_to_default_start24(mte_pm_uart_to_default_start24),
        .mte_pm_smc_uart_to_default_start24(mte_pm_smc_uart_to_default_start24)
);


`else 
//##############################################################################
// if the POWER_CTRL24 is black24 boxed24 
//##############################################################################

   //------------------------------------
   // Clocks24 & Reset24
   //------------------------------------
   wire              pclk24;
   wire              nprst24;
   //------------------------------------
   // APB24 programming24 interface;
   //------------------------------------
   wire   [31:0]     paddr24;
   wire              psel24;
   wire              penable24;
   wire              pwrite24;
   wire   [31:0]     pwdata24;
   reg    [31:0]     prdata24;
   //------------------------------------
   // Scan24
   //------------------------------------
   wire              scan_in24;
   wire              scan_en24;
   wire              scan_mode24;
   reg               scan_out24;
   //------------------------------------
   // Module24 control24 outputs24
   //------------------------------------
   // SMC24;
   reg               rstn_non_srpg_smc24;
   reg               gate_clk_smc24;
   reg               isolate_smc24;
   reg               save_edge_smc24;
   reg               restore_edge_smc24;
   reg               pwr1_on_smc24;
   reg               pwr2_on_smc24;
   wire              pwr1_off_smc24;
   wire              pwr2_off_smc24;

   // URT24;
   reg               rstn_non_srpg_urt24;
   reg               gate_clk_urt24;
   reg               isolate_urt24;
   reg               save_edge_urt24;
   reg               restore_edge_urt24;
   reg               pwr1_on_urt24;
   reg               pwr2_on_urt24;
   wire              pwr1_off_urt24;
   wire              pwr2_off_urt24;

   // ETH024
   reg               rstn_non_srpg_macb024;
   reg               gate_clk_macb024;
   reg               isolate_macb024;
   reg               save_edge_macb024;
   reg               restore_edge_macb024;
   reg               pwr1_on_macb024;
   reg               pwr2_on_macb024;
   wire              pwr1_off_macb024;
   wire              pwr2_off_macb024;
   // ETH124
   reg               rstn_non_srpg_macb124;
   reg               gate_clk_macb124;
   reg               isolate_macb124;
   reg               save_edge_macb124;
   reg               restore_edge_macb124;
   reg               pwr1_on_macb124;
   reg               pwr2_on_macb124;
   wire              pwr1_off_macb124;
   wire              pwr2_off_macb124;
   // ETH224
   reg               rstn_non_srpg_macb224;
   reg               gate_clk_macb224;
   reg               isolate_macb224;
   reg               save_edge_macb224;
   reg               restore_edge_macb224;
   reg               pwr1_on_macb224;
   reg               pwr2_on_macb224;
   wire              pwr1_off_macb224;
   wire              pwr2_off_macb224;
   // ETH324
   reg               rstn_non_srpg_macb324;
   reg               gate_clk_macb324;
   reg               isolate_macb324;
   reg               save_edge_macb324;
   reg               restore_edge_macb324;
   reg               pwr1_on_macb324;
   reg               pwr2_on_macb324;
   wire              pwr1_off_macb324;
   wire              pwr2_off_macb324;

   wire core06v24;
   wire core08v24;
   wire core10v24;
   wire core12v24;



`endif
//##############################################################################
// black24 boxed24 defines24 
//##############################################################################

endmodule
