//File3 name   : power_ctrl_veneer3.v
//Title3       : 
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------
module power_ctrl_veneer3 (
    //------------------------------------
    // Clocks3 & Reset3
    //------------------------------------
    pclk3,
    nprst3,
    //------------------------------------
    // APB3 programming3 interface
    //------------------------------------
    paddr3,
    psel3,
    penable3,
    pwrite3,
    pwdata3,
    prdata3,
    // mac3 i/f,
    macb3_wakeup3,
    macb2_wakeup3,
    macb1_wakeup3,
    macb0_wakeup3,
    //------------------------------------
    // Scan3 
    //------------------------------------
    scan_in3,
    scan_en3,
    scan_mode3,
    scan_out3,
    int_source_h3,
    //------------------------------------
    // Module3 control3 outputs3
    //------------------------------------
    // SMC3
    rstn_non_srpg_smc3,
    gate_clk_smc3,
    isolate_smc3,
    save_edge_smc3,
    restore_edge_smc3,
    pwr1_on_smc3,
    pwr2_on_smc3,
    // URT3
    rstn_non_srpg_urt3,
    gate_clk_urt3,
    isolate_urt3,
    save_edge_urt3,
    restore_edge_urt3,
    pwr1_on_urt3,
    pwr2_on_urt3,
    // ETH03
    rstn_non_srpg_macb03,
    gate_clk_macb03,
    isolate_macb03,
    save_edge_macb03,
    restore_edge_macb03,
    pwr1_on_macb03,
    pwr2_on_macb03,
    // ETH13
    rstn_non_srpg_macb13,
    gate_clk_macb13,
    isolate_macb13,
    save_edge_macb13,
    restore_edge_macb13,
    pwr1_on_macb13,
    pwr2_on_macb13,
    // ETH23
    rstn_non_srpg_macb23,
    gate_clk_macb23,
    isolate_macb23,
    save_edge_macb23,
    restore_edge_macb23,
    pwr1_on_macb23,
    pwr2_on_macb23,
    // ETH33
    rstn_non_srpg_macb33,
    gate_clk_macb33,
    isolate_macb33,
    save_edge_macb33,
    restore_edge_macb33,
    pwr1_on_macb33,
    pwr2_on_macb33,
    // core3 dvfs3 transitions3
    core06v3,
    core08v3,
    core10v3,
    core12v3,
    pcm_macb_wakeup_int3,
    isolate_mem3,
    
    // transit3 signals3
    mte_smc_start3,
    mte_uart_start3,
    mte_smc_uart_start3,  
    mte_pm_smc_to_default_start3, 
    mte_pm_uart_to_default_start3,
    mte_pm_smc_uart_to_default_start3
  );

//------------------------------------------------------------------------------
// I3/O3 declaration3
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks3 & Reset3
   //------------------------------------
   input             pclk3;
   input             nprst3;
   //------------------------------------
   // APB3 programming3 interface;
   //------------------------------------
   input  [31:0]     paddr3;
   input             psel3;
   input             penable3;
   input             pwrite3;
   input  [31:0]     pwdata3;
   output [31:0]     prdata3;
    // mac3
   input macb3_wakeup3;
   input macb2_wakeup3;
   input macb1_wakeup3;
   input macb0_wakeup3;
   //------------------------------------
   // Scan3
   //------------------------------------
   input             scan_in3;
   input             scan_en3;
   input             scan_mode3;
   output            scan_out3;
   //------------------------------------
   // Module3 control3 outputs3
   input             int_source_h3;
   //------------------------------------
   // SMC3
   output            rstn_non_srpg_smc3;
   output            gate_clk_smc3;
   output            isolate_smc3;
   output            save_edge_smc3;
   output            restore_edge_smc3;
   output            pwr1_on_smc3;
   output            pwr2_on_smc3;
   // URT3
   output            rstn_non_srpg_urt3;
   output            gate_clk_urt3;
   output            isolate_urt3;
   output            save_edge_urt3;
   output            restore_edge_urt3;
   output            pwr1_on_urt3;
   output            pwr2_on_urt3;
   // ETH03
   output            rstn_non_srpg_macb03;
   output            gate_clk_macb03;
   output            isolate_macb03;
   output            save_edge_macb03;
   output            restore_edge_macb03;
   output            pwr1_on_macb03;
   output            pwr2_on_macb03;
   // ETH13
   output            rstn_non_srpg_macb13;
   output            gate_clk_macb13;
   output            isolate_macb13;
   output            save_edge_macb13;
   output            restore_edge_macb13;
   output            pwr1_on_macb13;
   output            pwr2_on_macb13;
   // ETH23
   output            rstn_non_srpg_macb23;
   output            gate_clk_macb23;
   output            isolate_macb23;
   output            save_edge_macb23;
   output            restore_edge_macb23;
   output            pwr1_on_macb23;
   output            pwr2_on_macb23;
   // ETH33
   output            rstn_non_srpg_macb33;
   output            gate_clk_macb33;
   output            isolate_macb33;
   output            save_edge_macb33;
   output            restore_edge_macb33;
   output            pwr1_on_macb33;
   output            pwr2_on_macb33;

   // dvfs3
   output core06v3;
   output core08v3;
   output core10v3;
   output core12v3;
   output pcm_macb_wakeup_int3 ;
   output isolate_mem3 ;

   //transit3  signals3
   output mte_smc_start3;
   output mte_uart_start3;
   output mte_smc_uart_start3;  
   output mte_pm_smc_to_default_start3; 
   output mte_pm_uart_to_default_start3;
   output mte_pm_smc_uart_to_default_start3;



//##############################################################################
// if the POWER_CTRL3 is NOT3 black3 boxed3 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL3

power_ctrl3 i_power_ctrl3(
    // -- Clocks3 & Reset3
    	.pclk3(pclk3), 			//  : in  std_logic3;
    	.nprst3(nprst3), 		//  : in  std_logic3;
    // -- APB3 programming3 interface
    	.paddr3(paddr3), 			//  : in  std_logic_vector3(31 downto3 0);
    	.psel3(psel3), 			//  : in  std_logic3;
    	.penable3(penable3), 		//  : in  std_logic3;
    	.pwrite3(pwrite3), 		//  : in  std_logic3;
    	.pwdata3(pwdata3), 		//  : in  std_logic_vector3(31 downto3 0);
    	.prdata3(prdata3), 		//  : out std_logic_vector3(31 downto3 0);
        .macb3_wakeup3(macb3_wakeup3),
        .macb2_wakeup3(macb2_wakeup3),
        .macb1_wakeup3(macb1_wakeup3),
        .macb0_wakeup3(macb0_wakeup3),
    // -- Module3 control3 outputs3
    	.scan_in3(),			//  : in  std_logic3;
    	.scan_en3(scan_en3),             	//  : in  std_logic3;
    	.scan_mode3(scan_mode3),          //  : in  std_logic3;
    	.scan_out3(),            	//  : out std_logic3;
    	.int_source_h3(int_source_h3),    //  : out std_logic3;
     	.rstn_non_srpg_smc3(rstn_non_srpg_smc3), 		//   : out std_logic3;
    	.gate_clk_smc3(gate_clk_smc3), 	//  : out std_logic3;
    	.isolate_smc3(isolate_smc3), 	//  : out std_logic3;
    	.save_edge_smc3(save_edge_smc3), 	//  : out std_logic3;
    	.restore_edge_smc3(restore_edge_smc3), 	//  : out std_logic3;
    	.pwr1_on_smc3(pwr1_on_smc3), 	//  : out std_logic3;
    	.pwr2_on_smc3(pwr2_on_smc3), 	//  : out std_logic3
	.pwr1_off_smc3(pwr1_off_smc3), 	//  : out std_logic3;
    	.pwr2_off_smc3(pwr2_off_smc3), 	//  : out std_logic3
     	.rstn_non_srpg_urt3(rstn_non_srpg_urt3), 		//   : out std_logic3;
    	.gate_clk_urt3(gate_clk_urt3), 	//  : out std_logic3;
    	.isolate_urt3(isolate_urt3), 	//  : out std_logic3;
    	.save_edge_urt3(save_edge_urt3), 	//  : out std_logic3;
    	.restore_edge_urt3(restore_edge_urt3), 	//  : out std_logic3;
    	.pwr1_on_urt3(pwr1_on_urt3), 	//  : out std_logic3;
    	.pwr2_on_urt3(pwr2_on_urt3), 	//  : out std_logic3;
    	.pwr1_off_urt3(pwr1_off_urt3),    //  : out std_logic3;
    	.pwr2_off_urt3(pwr2_off_urt3),     //  : out std_logic3
     	.rstn_non_srpg_macb03(rstn_non_srpg_macb03), 		//   : out std_logic3;
    	.gate_clk_macb03(gate_clk_macb03), 	//  : out std_logic3;
    	.isolate_macb03(isolate_macb03), 	//  : out std_logic3;
    	.save_edge_macb03(save_edge_macb03), 	//  : out std_logic3;
    	.restore_edge_macb03(restore_edge_macb03), 	//  : out std_logic3;
    	.pwr1_on_macb03(pwr1_on_macb03), 	//  : out std_logic3;
    	.pwr2_on_macb03(pwr2_on_macb03), 	//  : out std_logic3;
    	.pwr1_off_macb03(pwr1_off_macb03),    //  : out std_logic3;
    	.pwr2_off_macb03(pwr2_off_macb03),     //  : out std_logic3
     	.rstn_non_srpg_macb13(rstn_non_srpg_macb13), 		//   : out std_logic3;
    	.gate_clk_macb13(gate_clk_macb13), 	//  : out std_logic3;
    	.isolate_macb13(isolate_macb13), 	//  : out std_logic3;
    	.save_edge_macb13(save_edge_macb13), 	//  : out std_logic3;
    	.restore_edge_macb13(restore_edge_macb13), 	//  : out std_logic3;
    	.pwr1_on_macb13(pwr1_on_macb13), 	//  : out std_logic3;
    	.pwr2_on_macb13(pwr2_on_macb13), 	//  : out std_logic3;
    	.pwr1_off_macb13(pwr1_off_macb13),    //  : out std_logic3;
    	.pwr2_off_macb13(pwr2_off_macb13),     //  : out std_logic3
     	.rstn_non_srpg_macb23(rstn_non_srpg_macb23), 		//   : out std_logic3;
    	.gate_clk_macb23(gate_clk_macb23), 	//  : out std_logic3;
    	.isolate_macb23(isolate_macb23), 	//  : out std_logic3;
    	.save_edge_macb23(save_edge_macb23), 	//  : out std_logic3;
    	.restore_edge_macb23(restore_edge_macb23), 	//  : out std_logic3;
    	.pwr1_on_macb23(pwr1_on_macb23), 	//  : out std_logic3;
    	.pwr2_on_macb23(pwr2_on_macb23), 	//  : out std_logic3;
    	.pwr1_off_macb23(pwr1_off_macb23),    //  : out std_logic3;
    	.pwr2_off_macb23(pwr2_off_macb23),     //  : out std_logic3
     	.rstn_non_srpg_macb33(rstn_non_srpg_macb33), 		//   : out std_logic3;
    	.gate_clk_macb33(gate_clk_macb33), 	//  : out std_logic3;
    	.isolate_macb33(isolate_macb33), 	//  : out std_logic3;
    	.save_edge_macb33(save_edge_macb33), 	//  : out std_logic3;
    	.restore_edge_macb33(restore_edge_macb33), 	//  : out std_logic3;
    	.pwr1_on_macb33(pwr1_on_macb33), 	//  : out std_logic3;
    	.pwr2_on_macb33(pwr2_on_macb33), 	//  : out std_logic3;
    	.pwr1_off_macb33(pwr1_off_macb33),    //  : out std_logic3;
    	.pwr2_off_macb33(pwr2_off_macb33),     //  : out std_logic3
        .rstn_non_srpg_dma3(rstn_non_srpg_dma3 ) ,
        .gate_clk_dma3(gate_clk_dma3      )      ,
        .isolate_dma3(isolate_dma3       )       ,
        .save_edge_dma3(save_edge_dma3   )   ,
        .restore_edge_dma3(restore_edge_dma3   )   ,
        .pwr1_on_dma3(pwr1_on_dma3       )       ,
        .pwr2_on_dma3(pwr2_on_dma3       )       ,
        .pwr1_off_dma3(pwr1_off_dma3      )      ,
        .pwr2_off_dma3(pwr2_off_dma3      )      ,
        
        .rstn_non_srpg_cpu3(rstn_non_srpg_cpu3 ) ,
        .gate_clk_cpu3(gate_clk_cpu3      )      ,
        .isolate_cpu3(isolate_cpu3       )       ,
        .save_edge_cpu3(save_edge_cpu3   )   ,
        .restore_edge_cpu3(restore_edge_cpu3   )   ,
        .pwr1_on_cpu3(pwr1_on_cpu3       )       ,
        .pwr2_on_cpu3(pwr2_on_cpu3       )       ,
        .pwr1_off_cpu3(pwr1_off_cpu3      )      ,
        .pwr2_off_cpu3(pwr2_off_cpu3      )      ,
        
        .rstn_non_srpg_alut3(rstn_non_srpg_alut3 ) ,
        .gate_clk_alut3(gate_clk_alut3      )      ,
        .isolate_alut3(isolate_alut3       )       ,
        .save_edge_alut3(save_edge_alut3   )   ,
        .restore_edge_alut3(restore_edge_alut3   )   ,
        .pwr1_on_alut3(pwr1_on_alut3       )       ,
        .pwr2_on_alut3(pwr2_on_alut3       )       ,
        .pwr1_off_alut3(pwr1_off_alut3      )      ,
        .pwr2_off_alut3(pwr2_off_alut3      )      ,
        
        .rstn_non_srpg_mem3(rstn_non_srpg_mem3 ) ,
        .gate_clk_mem3(gate_clk_mem3      )      ,
        .isolate_mem3(isolate_mem3       )       ,
        .save_edge_mem3(save_edge_mem3   )   ,
        .restore_edge_mem3(restore_edge_mem3   )   ,
        .pwr1_on_mem3(pwr1_on_mem3       )       ,
        .pwr2_on_mem3(pwr2_on_mem3       )       ,
        .pwr1_off_mem3(pwr1_off_mem3      )      ,
        .pwr2_off_mem3(pwr2_off_mem3      )      ,

    	.core06v3(core06v3),     //  : out std_logic3
    	.core08v3(core08v3),     //  : out std_logic3
    	.core10v3(core10v3),     //  : out std_logic3
    	.core12v3(core12v3),     //  : out std_logic3
        .pcm_macb_wakeup_int3(pcm_macb_wakeup_int3),
        .mte_smc_start3(mte_smc_start3),
        .mte_uart_start3(mte_uart_start3),
        .mte_smc_uart_start3(mte_smc_uart_start3),  
        .mte_pm_smc_to_default_start3(mte_pm_smc_to_default_start3), 
        .mte_pm_uart_to_default_start3(mte_pm_uart_to_default_start3),
        .mte_pm_smc_uart_to_default_start3(mte_pm_smc_uart_to_default_start3)
);


`else 
//##############################################################################
// if the POWER_CTRL3 is black3 boxed3 
//##############################################################################

   //------------------------------------
   // Clocks3 & Reset3
   //------------------------------------
   wire              pclk3;
   wire              nprst3;
   //------------------------------------
   // APB3 programming3 interface;
   //------------------------------------
   wire   [31:0]     paddr3;
   wire              psel3;
   wire              penable3;
   wire              pwrite3;
   wire   [31:0]     pwdata3;
   reg    [31:0]     prdata3;
   //------------------------------------
   // Scan3
   //------------------------------------
   wire              scan_in3;
   wire              scan_en3;
   wire              scan_mode3;
   reg               scan_out3;
   //------------------------------------
   // Module3 control3 outputs3
   //------------------------------------
   // SMC3;
   reg               rstn_non_srpg_smc3;
   reg               gate_clk_smc3;
   reg               isolate_smc3;
   reg               save_edge_smc3;
   reg               restore_edge_smc3;
   reg               pwr1_on_smc3;
   reg               pwr2_on_smc3;
   wire              pwr1_off_smc3;
   wire              pwr2_off_smc3;

   // URT3;
   reg               rstn_non_srpg_urt3;
   reg               gate_clk_urt3;
   reg               isolate_urt3;
   reg               save_edge_urt3;
   reg               restore_edge_urt3;
   reg               pwr1_on_urt3;
   reg               pwr2_on_urt3;
   wire              pwr1_off_urt3;
   wire              pwr2_off_urt3;

   // ETH03
   reg               rstn_non_srpg_macb03;
   reg               gate_clk_macb03;
   reg               isolate_macb03;
   reg               save_edge_macb03;
   reg               restore_edge_macb03;
   reg               pwr1_on_macb03;
   reg               pwr2_on_macb03;
   wire              pwr1_off_macb03;
   wire              pwr2_off_macb03;
   // ETH13
   reg               rstn_non_srpg_macb13;
   reg               gate_clk_macb13;
   reg               isolate_macb13;
   reg               save_edge_macb13;
   reg               restore_edge_macb13;
   reg               pwr1_on_macb13;
   reg               pwr2_on_macb13;
   wire              pwr1_off_macb13;
   wire              pwr2_off_macb13;
   // ETH23
   reg               rstn_non_srpg_macb23;
   reg               gate_clk_macb23;
   reg               isolate_macb23;
   reg               save_edge_macb23;
   reg               restore_edge_macb23;
   reg               pwr1_on_macb23;
   reg               pwr2_on_macb23;
   wire              pwr1_off_macb23;
   wire              pwr2_off_macb23;
   // ETH33
   reg               rstn_non_srpg_macb33;
   reg               gate_clk_macb33;
   reg               isolate_macb33;
   reg               save_edge_macb33;
   reg               restore_edge_macb33;
   reg               pwr1_on_macb33;
   reg               pwr2_on_macb33;
   wire              pwr1_off_macb33;
   wire              pwr2_off_macb33;

   wire core06v3;
   wire core08v3;
   wire core10v3;
   wire core12v3;



`endif
//##############################################################################
// black3 boxed3 defines3 
//##############################################################################

endmodule
