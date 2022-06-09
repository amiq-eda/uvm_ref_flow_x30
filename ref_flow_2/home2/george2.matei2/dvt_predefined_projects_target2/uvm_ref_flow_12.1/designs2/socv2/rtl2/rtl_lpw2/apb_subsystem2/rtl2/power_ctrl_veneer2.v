//File2 name   : power_ctrl_veneer2.v
//Title2       : 
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------
module power_ctrl_veneer2 (
    //------------------------------------
    // Clocks2 & Reset2
    //------------------------------------
    pclk2,
    nprst2,
    //------------------------------------
    // APB2 programming2 interface
    //------------------------------------
    paddr2,
    psel2,
    penable2,
    pwrite2,
    pwdata2,
    prdata2,
    // mac2 i/f,
    macb3_wakeup2,
    macb2_wakeup2,
    macb1_wakeup2,
    macb0_wakeup2,
    //------------------------------------
    // Scan2 
    //------------------------------------
    scan_in2,
    scan_en2,
    scan_mode2,
    scan_out2,
    int_source_h2,
    //------------------------------------
    // Module2 control2 outputs2
    //------------------------------------
    // SMC2
    rstn_non_srpg_smc2,
    gate_clk_smc2,
    isolate_smc2,
    save_edge_smc2,
    restore_edge_smc2,
    pwr1_on_smc2,
    pwr2_on_smc2,
    // URT2
    rstn_non_srpg_urt2,
    gate_clk_urt2,
    isolate_urt2,
    save_edge_urt2,
    restore_edge_urt2,
    pwr1_on_urt2,
    pwr2_on_urt2,
    // ETH02
    rstn_non_srpg_macb02,
    gate_clk_macb02,
    isolate_macb02,
    save_edge_macb02,
    restore_edge_macb02,
    pwr1_on_macb02,
    pwr2_on_macb02,
    // ETH12
    rstn_non_srpg_macb12,
    gate_clk_macb12,
    isolate_macb12,
    save_edge_macb12,
    restore_edge_macb12,
    pwr1_on_macb12,
    pwr2_on_macb12,
    // ETH22
    rstn_non_srpg_macb22,
    gate_clk_macb22,
    isolate_macb22,
    save_edge_macb22,
    restore_edge_macb22,
    pwr1_on_macb22,
    pwr2_on_macb22,
    // ETH32
    rstn_non_srpg_macb32,
    gate_clk_macb32,
    isolate_macb32,
    save_edge_macb32,
    restore_edge_macb32,
    pwr1_on_macb32,
    pwr2_on_macb32,
    // core2 dvfs2 transitions2
    core06v2,
    core08v2,
    core10v2,
    core12v2,
    pcm_macb_wakeup_int2,
    isolate_mem2,
    
    // transit2 signals2
    mte_smc_start2,
    mte_uart_start2,
    mte_smc_uart_start2,  
    mte_pm_smc_to_default_start2, 
    mte_pm_uart_to_default_start2,
    mte_pm_smc_uart_to_default_start2
  );

//------------------------------------------------------------------------------
// I2/O2 declaration2
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks2 & Reset2
   //------------------------------------
   input             pclk2;
   input             nprst2;
   //------------------------------------
   // APB2 programming2 interface;
   //------------------------------------
   input  [31:0]     paddr2;
   input             psel2;
   input             penable2;
   input             pwrite2;
   input  [31:0]     pwdata2;
   output [31:0]     prdata2;
    // mac2
   input macb3_wakeup2;
   input macb2_wakeup2;
   input macb1_wakeup2;
   input macb0_wakeup2;
   //------------------------------------
   // Scan2
   //------------------------------------
   input             scan_in2;
   input             scan_en2;
   input             scan_mode2;
   output            scan_out2;
   //------------------------------------
   // Module2 control2 outputs2
   input             int_source_h2;
   //------------------------------------
   // SMC2
   output            rstn_non_srpg_smc2;
   output            gate_clk_smc2;
   output            isolate_smc2;
   output            save_edge_smc2;
   output            restore_edge_smc2;
   output            pwr1_on_smc2;
   output            pwr2_on_smc2;
   // URT2
   output            rstn_non_srpg_urt2;
   output            gate_clk_urt2;
   output            isolate_urt2;
   output            save_edge_urt2;
   output            restore_edge_urt2;
   output            pwr1_on_urt2;
   output            pwr2_on_urt2;
   // ETH02
   output            rstn_non_srpg_macb02;
   output            gate_clk_macb02;
   output            isolate_macb02;
   output            save_edge_macb02;
   output            restore_edge_macb02;
   output            pwr1_on_macb02;
   output            pwr2_on_macb02;
   // ETH12
   output            rstn_non_srpg_macb12;
   output            gate_clk_macb12;
   output            isolate_macb12;
   output            save_edge_macb12;
   output            restore_edge_macb12;
   output            pwr1_on_macb12;
   output            pwr2_on_macb12;
   // ETH22
   output            rstn_non_srpg_macb22;
   output            gate_clk_macb22;
   output            isolate_macb22;
   output            save_edge_macb22;
   output            restore_edge_macb22;
   output            pwr1_on_macb22;
   output            pwr2_on_macb22;
   // ETH32
   output            rstn_non_srpg_macb32;
   output            gate_clk_macb32;
   output            isolate_macb32;
   output            save_edge_macb32;
   output            restore_edge_macb32;
   output            pwr1_on_macb32;
   output            pwr2_on_macb32;

   // dvfs2
   output core06v2;
   output core08v2;
   output core10v2;
   output core12v2;
   output pcm_macb_wakeup_int2 ;
   output isolate_mem2 ;

   //transit2  signals2
   output mte_smc_start2;
   output mte_uart_start2;
   output mte_smc_uart_start2;  
   output mte_pm_smc_to_default_start2; 
   output mte_pm_uart_to_default_start2;
   output mte_pm_smc_uart_to_default_start2;



//##############################################################################
// if the POWER_CTRL2 is NOT2 black2 boxed2 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL2

power_ctrl2 i_power_ctrl2(
    // -- Clocks2 & Reset2
    	.pclk2(pclk2), 			//  : in  std_logic2;
    	.nprst2(nprst2), 		//  : in  std_logic2;
    // -- APB2 programming2 interface
    	.paddr2(paddr2), 			//  : in  std_logic_vector2(31 downto2 0);
    	.psel2(psel2), 			//  : in  std_logic2;
    	.penable2(penable2), 		//  : in  std_logic2;
    	.pwrite2(pwrite2), 		//  : in  std_logic2;
    	.pwdata2(pwdata2), 		//  : in  std_logic_vector2(31 downto2 0);
    	.prdata2(prdata2), 		//  : out std_logic_vector2(31 downto2 0);
        .macb3_wakeup2(macb3_wakeup2),
        .macb2_wakeup2(macb2_wakeup2),
        .macb1_wakeup2(macb1_wakeup2),
        .macb0_wakeup2(macb0_wakeup2),
    // -- Module2 control2 outputs2
    	.scan_in2(),			//  : in  std_logic2;
    	.scan_en2(scan_en2),             	//  : in  std_logic2;
    	.scan_mode2(scan_mode2),          //  : in  std_logic2;
    	.scan_out2(),            	//  : out std_logic2;
    	.int_source_h2(int_source_h2),    //  : out std_logic2;
     	.rstn_non_srpg_smc2(rstn_non_srpg_smc2), 		//   : out std_logic2;
    	.gate_clk_smc2(gate_clk_smc2), 	//  : out std_logic2;
    	.isolate_smc2(isolate_smc2), 	//  : out std_logic2;
    	.save_edge_smc2(save_edge_smc2), 	//  : out std_logic2;
    	.restore_edge_smc2(restore_edge_smc2), 	//  : out std_logic2;
    	.pwr1_on_smc2(pwr1_on_smc2), 	//  : out std_logic2;
    	.pwr2_on_smc2(pwr2_on_smc2), 	//  : out std_logic2
	.pwr1_off_smc2(pwr1_off_smc2), 	//  : out std_logic2;
    	.pwr2_off_smc2(pwr2_off_smc2), 	//  : out std_logic2
     	.rstn_non_srpg_urt2(rstn_non_srpg_urt2), 		//   : out std_logic2;
    	.gate_clk_urt2(gate_clk_urt2), 	//  : out std_logic2;
    	.isolate_urt2(isolate_urt2), 	//  : out std_logic2;
    	.save_edge_urt2(save_edge_urt2), 	//  : out std_logic2;
    	.restore_edge_urt2(restore_edge_urt2), 	//  : out std_logic2;
    	.pwr1_on_urt2(pwr1_on_urt2), 	//  : out std_logic2;
    	.pwr2_on_urt2(pwr2_on_urt2), 	//  : out std_logic2;
    	.pwr1_off_urt2(pwr1_off_urt2),    //  : out std_logic2;
    	.pwr2_off_urt2(pwr2_off_urt2),     //  : out std_logic2
     	.rstn_non_srpg_macb02(rstn_non_srpg_macb02), 		//   : out std_logic2;
    	.gate_clk_macb02(gate_clk_macb02), 	//  : out std_logic2;
    	.isolate_macb02(isolate_macb02), 	//  : out std_logic2;
    	.save_edge_macb02(save_edge_macb02), 	//  : out std_logic2;
    	.restore_edge_macb02(restore_edge_macb02), 	//  : out std_logic2;
    	.pwr1_on_macb02(pwr1_on_macb02), 	//  : out std_logic2;
    	.pwr2_on_macb02(pwr2_on_macb02), 	//  : out std_logic2;
    	.pwr1_off_macb02(pwr1_off_macb02),    //  : out std_logic2;
    	.pwr2_off_macb02(pwr2_off_macb02),     //  : out std_logic2
     	.rstn_non_srpg_macb12(rstn_non_srpg_macb12), 		//   : out std_logic2;
    	.gate_clk_macb12(gate_clk_macb12), 	//  : out std_logic2;
    	.isolate_macb12(isolate_macb12), 	//  : out std_logic2;
    	.save_edge_macb12(save_edge_macb12), 	//  : out std_logic2;
    	.restore_edge_macb12(restore_edge_macb12), 	//  : out std_logic2;
    	.pwr1_on_macb12(pwr1_on_macb12), 	//  : out std_logic2;
    	.pwr2_on_macb12(pwr2_on_macb12), 	//  : out std_logic2;
    	.pwr1_off_macb12(pwr1_off_macb12),    //  : out std_logic2;
    	.pwr2_off_macb12(pwr2_off_macb12),     //  : out std_logic2
     	.rstn_non_srpg_macb22(rstn_non_srpg_macb22), 		//   : out std_logic2;
    	.gate_clk_macb22(gate_clk_macb22), 	//  : out std_logic2;
    	.isolate_macb22(isolate_macb22), 	//  : out std_logic2;
    	.save_edge_macb22(save_edge_macb22), 	//  : out std_logic2;
    	.restore_edge_macb22(restore_edge_macb22), 	//  : out std_logic2;
    	.pwr1_on_macb22(pwr1_on_macb22), 	//  : out std_logic2;
    	.pwr2_on_macb22(pwr2_on_macb22), 	//  : out std_logic2;
    	.pwr1_off_macb22(pwr1_off_macb22),    //  : out std_logic2;
    	.pwr2_off_macb22(pwr2_off_macb22),     //  : out std_logic2
     	.rstn_non_srpg_macb32(rstn_non_srpg_macb32), 		//   : out std_logic2;
    	.gate_clk_macb32(gate_clk_macb32), 	//  : out std_logic2;
    	.isolate_macb32(isolate_macb32), 	//  : out std_logic2;
    	.save_edge_macb32(save_edge_macb32), 	//  : out std_logic2;
    	.restore_edge_macb32(restore_edge_macb32), 	//  : out std_logic2;
    	.pwr1_on_macb32(pwr1_on_macb32), 	//  : out std_logic2;
    	.pwr2_on_macb32(pwr2_on_macb32), 	//  : out std_logic2;
    	.pwr1_off_macb32(pwr1_off_macb32),    //  : out std_logic2;
    	.pwr2_off_macb32(pwr2_off_macb32),     //  : out std_logic2
        .rstn_non_srpg_dma2(rstn_non_srpg_dma2 ) ,
        .gate_clk_dma2(gate_clk_dma2      )      ,
        .isolate_dma2(isolate_dma2       )       ,
        .save_edge_dma2(save_edge_dma2   )   ,
        .restore_edge_dma2(restore_edge_dma2   )   ,
        .pwr1_on_dma2(pwr1_on_dma2       )       ,
        .pwr2_on_dma2(pwr2_on_dma2       )       ,
        .pwr1_off_dma2(pwr1_off_dma2      )      ,
        .pwr2_off_dma2(pwr2_off_dma2      )      ,
        
        .rstn_non_srpg_cpu2(rstn_non_srpg_cpu2 ) ,
        .gate_clk_cpu2(gate_clk_cpu2      )      ,
        .isolate_cpu2(isolate_cpu2       )       ,
        .save_edge_cpu2(save_edge_cpu2   )   ,
        .restore_edge_cpu2(restore_edge_cpu2   )   ,
        .pwr1_on_cpu2(pwr1_on_cpu2       )       ,
        .pwr2_on_cpu2(pwr2_on_cpu2       )       ,
        .pwr1_off_cpu2(pwr1_off_cpu2      )      ,
        .pwr2_off_cpu2(pwr2_off_cpu2      )      ,
        
        .rstn_non_srpg_alut2(rstn_non_srpg_alut2 ) ,
        .gate_clk_alut2(gate_clk_alut2      )      ,
        .isolate_alut2(isolate_alut2       )       ,
        .save_edge_alut2(save_edge_alut2   )   ,
        .restore_edge_alut2(restore_edge_alut2   )   ,
        .pwr1_on_alut2(pwr1_on_alut2       )       ,
        .pwr2_on_alut2(pwr2_on_alut2       )       ,
        .pwr1_off_alut2(pwr1_off_alut2      )      ,
        .pwr2_off_alut2(pwr2_off_alut2      )      ,
        
        .rstn_non_srpg_mem2(rstn_non_srpg_mem2 ) ,
        .gate_clk_mem2(gate_clk_mem2      )      ,
        .isolate_mem2(isolate_mem2       )       ,
        .save_edge_mem2(save_edge_mem2   )   ,
        .restore_edge_mem2(restore_edge_mem2   )   ,
        .pwr1_on_mem2(pwr1_on_mem2       )       ,
        .pwr2_on_mem2(pwr2_on_mem2       )       ,
        .pwr1_off_mem2(pwr1_off_mem2      )      ,
        .pwr2_off_mem2(pwr2_off_mem2      )      ,

    	.core06v2(core06v2),     //  : out std_logic2
    	.core08v2(core08v2),     //  : out std_logic2
    	.core10v2(core10v2),     //  : out std_logic2
    	.core12v2(core12v2),     //  : out std_logic2
        .pcm_macb_wakeup_int2(pcm_macb_wakeup_int2),
        .mte_smc_start2(mte_smc_start2),
        .mte_uart_start2(mte_uart_start2),
        .mte_smc_uart_start2(mte_smc_uart_start2),  
        .mte_pm_smc_to_default_start2(mte_pm_smc_to_default_start2), 
        .mte_pm_uart_to_default_start2(mte_pm_uart_to_default_start2),
        .mte_pm_smc_uart_to_default_start2(mte_pm_smc_uart_to_default_start2)
);


`else 
//##############################################################################
// if the POWER_CTRL2 is black2 boxed2 
//##############################################################################

   //------------------------------------
   // Clocks2 & Reset2
   //------------------------------------
   wire              pclk2;
   wire              nprst2;
   //------------------------------------
   // APB2 programming2 interface;
   //------------------------------------
   wire   [31:0]     paddr2;
   wire              psel2;
   wire              penable2;
   wire              pwrite2;
   wire   [31:0]     pwdata2;
   reg    [31:0]     prdata2;
   //------------------------------------
   // Scan2
   //------------------------------------
   wire              scan_in2;
   wire              scan_en2;
   wire              scan_mode2;
   reg               scan_out2;
   //------------------------------------
   // Module2 control2 outputs2
   //------------------------------------
   // SMC2;
   reg               rstn_non_srpg_smc2;
   reg               gate_clk_smc2;
   reg               isolate_smc2;
   reg               save_edge_smc2;
   reg               restore_edge_smc2;
   reg               pwr1_on_smc2;
   reg               pwr2_on_smc2;
   wire              pwr1_off_smc2;
   wire              pwr2_off_smc2;

   // URT2;
   reg               rstn_non_srpg_urt2;
   reg               gate_clk_urt2;
   reg               isolate_urt2;
   reg               save_edge_urt2;
   reg               restore_edge_urt2;
   reg               pwr1_on_urt2;
   reg               pwr2_on_urt2;
   wire              pwr1_off_urt2;
   wire              pwr2_off_urt2;

   // ETH02
   reg               rstn_non_srpg_macb02;
   reg               gate_clk_macb02;
   reg               isolate_macb02;
   reg               save_edge_macb02;
   reg               restore_edge_macb02;
   reg               pwr1_on_macb02;
   reg               pwr2_on_macb02;
   wire              pwr1_off_macb02;
   wire              pwr2_off_macb02;
   // ETH12
   reg               rstn_non_srpg_macb12;
   reg               gate_clk_macb12;
   reg               isolate_macb12;
   reg               save_edge_macb12;
   reg               restore_edge_macb12;
   reg               pwr1_on_macb12;
   reg               pwr2_on_macb12;
   wire              pwr1_off_macb12;
   wire              pwr2_off_macb12;
   // ETH22
   reg               rstn_non_srpg_macb22;
   reg               gate_clk_macb22;
   reg               isolate_macb22;
   reg               save_edge_macb22;
   reg               restore_edge_macb22;
   reg               pwr1_on_macb22;
   reg               pwr2_on_macb22;
   wire              pwr1_off_macb22;
   wire              pwr2_off_macb22;
   // ETH32
   reg               rstn_non_srpg_macb32;
   reg               gate_clk_macb32;
   reg               isolate_macb32;
   reg               save_edge_macb32;
   reg               restore_edge_macb32;
   reg               pwr1_on_macb32;
   reg               pwr2_on_macb32;
   wire              pwr1_off_macb32;
   wire              pwr2_off_macb32;

   wire core06v2;
   wire core08v2;
   wire core10v2;
   wire core12v2;



`endif
//##############################################################################
// black2 boxed2 defines2 
//##############################################################################

endmodule
