//File30 name   : power_ctrl_veneer30.v
//Title30       : 
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------
module power_ctrl_veneer30 (
    //------------------------------------
    // Clocks30 & Reset30
    //------------------------------------
    pclk30,
    nprst30,
    //------------------------------------
    // APB30 programming30 interface
    //------------------------------------
    paddr30,
    psel30,
    penable30,
    pwrite30,
    pwdata30,
    prdata30,
    // mac30 i/f,
    macb3_wakeup30,
    macb2_wakeup30,
    macb1_wakeup30,
    macb0_wakeup30,
    //------------------------------------
    // Scan30 
    //------------------------------------
    scan_in30,
    scan_en30,
    scan_mode30,
    scan_out30,
    int_source_h30,
    //------------------------------------
    // Module30 control30 outputs30
    //------------------------------------
    // SMC30
    rstn_non_srpg_smc30,
    gate_clk_smc30,
    isolate_smc30,
    save_edge_smc30,
    restore_edge_smc30,
    pwr1_on_smc30,
    pwr2_on_smc30,
    // URT30
    rstn_non_srpg_urt30,
    gate_clk_urt30,
    isolate_urt30,
    save_edge_urt30,
    restore_edge_urt30,
    pwr1_on_urt30,
    pwr2_on_urt30,
    // ETH030
    rstn_non_srpg_macb030,
    gate_clk_macb030,
    isolate_macb030,
    save_edge_macb030,
    restore_edge_macb030,
    pwr1_on_macb030,
    pwr2_on_macb030,
    // ETH130
    rstn_non_srpg_macb130,
    gate_clk_macb130,
    isolate_macb130,
    save_edge_macb130,
    restore_edge_macb130,
    pwr1_on_macb130,
    pwr2_on_macb130,
    // ETH230
    rstn_non_srpg_macb230,
    gate_clk_macb230,
    isolate_macb230,
    save_edge_macb230,
    restore_edge_macb230,
    pwr1_on_macb230,
    pwr2_on_macb230,
    // ETH330
    rstn_non_srpg_macb330,
    gate_clk_macb330,
    isolate_macb330,
    save_edge_macb330,
    restore_edge_macb330,
    pwr1_on_macb330,
    pwr2_on_macb330,
    // core30 dvfs30 transitions30
    core06v30,
    core08v30,
    core10v30,
    core12v30,
    pcm_macb_wakeup_int30,
    isolate_mem30,
    
    // transit30 signals30
    mte_smc_start30,
    mte_uart_start30,
    mte_smc_uart_start30,  
    mte_pm_smc_to_default_start30, 
    mte_pm_uart_to_default_start30,
    mte_pm_smc_uart_to_default_start30
  );

//------------------------------------------------------------------------------
// I30/O30 declaration30
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks30 & Reset30
   //------------------------------------
   input             pclk30;
   input             nprst30;
   //------------------------------------
   // APB30 programming30 interface;
   //------------------------------------
   input  [31:0]     paddr30;
   input             psel30;
   input             penable30;
   input             pwrite30;
   input  [31:0]     pwdata30;
   output [31:0]     prdata30;
    // mac30
   input macb3_wakeup30;
   input macb2_wakeup30;
   input macb1_wakeup30;
   input macb0_wakeup30;
   //------------------------------------
   // Scan30
   //------------------------------------
   input             scan_in30;
   input             scan_en30;
   input             scan_mode30;
   output            scan_out30;
   //------------------------------------
   // Module30 control30 outputs30
   input             int_source_h30;
   //------------------------------------
   // SMC30
   output            rstn_non_srpg_smc30;
   output            gate_clk_smc30;
   output            isolate_smc30;
   output            save_edge_smc30;
   output            restore_edge_smc30;
   output            pwr1_on_smc30;
   output            pwr2_on_smc30;
   // URT30
   output            rstn_non_srpg_urt30;
   output            gate_clk_urt30;
   output            isolate_urt30;
   output            save_edge_urt30;
   output            restore_edge_urt30;
   output            pwr1_on_urt30;
   output            pwr2_on_urt30;
   // ETH030
   output            rstn_non_srpg_macb030;
   output            gate_clk_macb030;
   output            isolate_macb030;
   output            save_edge_macb030;
   output            restore_edge_macb030;
   output            pwr1_on_macb030;
   output            pwr2_on_macb030;
   // ETH130
   output            rstn_non_srpg_macb130;
   output            gate_clk_macb130;
   output            isolate_macb130;
   output            save_edge_macb130;
   output            restore_edge_macb130;
   output            pwr1_on_macb130;
   output            pwr2_on_macb130;
   // ETH230
   output            rstn_non_srpg_macb230;
   output            gate_clk_macb230;
   output            isolate_macb230;
   output            save_edge_macb230;
   output            restore_edge_macb230;
   output            pwr1_on_macb230;
   output            pwr2_on_macb230;
   // ETH330
   output            rstn_non_srpg_macb330;
   output            gate_clk_macb330;
   output            isolate_macb330;
   output            save_edge_macb330;
   output            restore_edge_macb330;
   output            pwr1_on_macb330;
   output            pwr2_on_macb330;

   // dvfs30
   output core06v30;
   output core08v30;
   output core10v30;
   output core12v30;
   output pcm_macb_wakeup_int30 ;
   output isolate_mem30 ;

   //transit30  signals30
   output mte_smc_start30;
   output mte_uart_start30;
   output mte_smc_uart_start30;  
   output mte_pm_smc_to_default_start30; 
   output mte_pm_uart_to_default_start30;
   output mte_pm_smc_uart_to_default_start30;



//##############################################################################
// if the POWER_CTRL30 is NOT30 black30 boxed30 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL30

power_ctrl30 i_power_ctrl30(
    // -- Clocks30 & Reset30
    	.pclk30(pclk30), 			//  : in  std_logic30;
    	.nprst30(nprst30), 		//  : in  std_logic30;
    // -- APB30 programming30 interface
    	.paddr30(paddr30), 			//  : in  std_logic_vector30(31 downto30 0);
    	.psel30(psel30), 			//  : in  std_logic30;
    	.penable30(penable30), 		//  : in  std_logic30;
    	.pwrite30(pwrite30), 		//  : in  std_logic30;
    	.pwdata30(pwdata30), 		//  : in  std_logic_vector30(31 downto30 0);
    	.prdata30(prdata30), 		//  : out std_logic_vector30(31 downto30 0);
        .macb3_wakeup30(macb3_wakeup30),
        .macb2_wakeup30(macb2_wakeup30),
        .macb1_wakeup30(macb1_wakeup30),
        .macb0_wakeup30(macb0_wakeup30),
    // -- Module30 control30 outputs30
    	.scan_in30(),			//  : in  std_logic30;
    	.scan_en30(scan_en30),             	//  : in  std_logic30;
    	.scan_mode30(scan_mode30),          //  : in  std_logic30;
    	.scan_out30(),            	//  : out std_logic30;
    	.int_source_h30(int_source_h30),    //  : out std_logic30;
     	.rstn_non_srpg_smc30(rstn_non_srpg_smc30), 		//   : out std_logic30;
    	.gate_clk_smc30(gate_clk_smc30), 	//  : out std_logic30;
    	.isolate_smc30(isolate_smc30), 	//  : out std_logic30;
    	.save_edge_smc30(save_edge_smc30), 	//  : out std_logic30;
    	.restore_edge_smc30(restore_edge_smc30), 	//  : out std_logic30;
    	.pwr1_on_smc30(pwr1_on_smc30), 	//  : out std_logic30;
    	.pwr2_on_smc30(pwr2_on_smc30), 	//  : out std_logic30
	.pwr1_off_smc30(pwr1_off_smc30), 	//  : out std_logic30;
    	.pwr2_off_smc30(pwr2_off_smc30), 	//  : out std_logic30
     	.rstn_non_srpg_urt30(rstn_non_srpg_urt30), 		//   : out std_logic30;
    	.gate_clk_urt30(gate_clk_urt30), 	//  : out std_logic30;
    	.isolate_urt30(isolate_urt30), 	//  : out std_logic30;
    	.save_edge_urt30(save_edge_urt30), 	//  : out std_logic30;
    	.restore_edge_urt30(restore_edge_urt30), 	//  : out std_logic30;
    	.pwr1_on_urt30(pwr1_on_urt30), 	//  : out std_logic30;
    	.pwr2_on_urt30(pwr2_on_urt30), 	//  : out std_logic30;
    	.pwr1_off_urt30(pwr1_off_urt30),    //  : out std_logic30;
    	.pwr2_off_urt30(pwr2_off_urt30),     //  : out std_logic30
     	.rstn_non_srpg_macb030(rstn_non_srpg_macb030), 		//   : out std_logic30;
    	.gate_clk_macb030(gate_clk_macb030), 	//  : out std_logic30;
    	.isolate_macb030(isolate_macb030), 	//  : out std_logic30;
    	.save_edge_macb030(save_edge_macb030), 	//  : out std_logic30;
    	.restore_edge_macb030(restore_edge_macb030), 	//  : out std_logic30;
    	.pwr1_on_macb030(pwr1_on_macb030), 	//  : out std_logic30;
    	.pwr2_on_macb030(pwr2_on_macb030), 	//  : out std_logic30;
    	.pwr1_off_macb030(pwr1_off_macb030),    //  : out std_logic30;
    	.pwr2_off_macb030(pwr2_off_macb030),     //  : out std_logic30
     	.rstn_non_srpg_macb130(rstn_non_srpg_macb130), 		//   : out std_logic30;
    	.gate_clk_macb130(gate_clk_macb130), 	//  : out std_logic30;
    	.isolate_macb130(isolate_macb130), 	//  : out std_logic30;
    	.save_edge_macb130(save_edge_macb130), 	//  : out std_logic30;
    	.restore_edge_macb130(restore_edge_macb130), 	//  : out std_logic30;
    	.pwr1_on_macb130(pwr1_on_macb130), 	//  : out std_logic30;
    	.pwr2_on_macb130(pwr2_on_macb130), 	//  : out std_logic30;
    	.pwr1_off_macb130(pwr1_off_macb130),    //  : out std_logic30;
    	.pwr2_off_macb130(pwr2_off_macb130),     //  : out std_logic30
     	.rstn_non_srpg_macb230(rstn_non_srpg_macb230), 		//   : out std_logic30;
    	.gate_clk_macb230(gate_clk_macb230), 	//  : out std_logic30;
    	.isolate_macb230(isolate_macb230), 	//  : out std_logic30;
    	.save_edge_macb230(save_edge_macb230), 	//  : out std_logic30;
    	.restore_edge_macb230(restore_edge_macb230), 	//  : out std_logic30;
    	.pwr1_on_macb230(pwr1_on_macb230), 	//  : out std_logic30;
    	.pwr2_on_macb230(pwr2_on_macb230), 	//  : out std_logic30;
    	.pwr1_off_macb230(pwr1_off_macb230),    //  : out std_logic30;
    	.pwr2_off_macb230(pwr2_off_macb230),     //  : out std_logic30
     	.rstn_non_srpg_macb330(rstn_non_srpg_macb330), 		//   : out std_logic30;
    	.gate_clk_macb330(gate_clk_macb330), 	//  : out std_logic30;
    	.isolate_macb330(isolate_macb330), 	//  : out std_logic30;
    	.save_edge_macb330(save_edge_macb330), 	//  : out std_logic30;
    	.restore_edge_macb330(restore_edge_macb330), 	//  : out std_logic30;
    	.pwr1_on_macb330(pwr1_on_macb330), 	//  : out std_logic30;
    	.pwr2_on_macb330(pwr2_on_macb330), 	//  : out std_logic30;
    	.pwr1_off_macb330(pwr1_off_macb330),    //  : out std_logic30;
    	.pwr2_off_macb330(pwr2_off_macb330),     //  : out std_logic30
        .rstn_non_srpg_dma30(rstn_non_srpg_dma30 ) ,
        .gate_clk_dma30(gate_clk_dma30      )      ,
        .isolate_dma30(isolate_dma30       )       ,
        .save_edge_dma30(save_edge_dma30   )   ,
        .restore_edge_dma30(restore_edge_dma30   )   ,
        .pwr1_on_dma30(pwr1_on_dma30       )       ,
        .pwr2_on_dma30(pwr2_on_dma30       )       ,
        .pwr1_off_dma30(pwr1_off_dma30      )      ,
        .pwr2_off_dma30(pwr2_off_dma30      )      ,
        
        .rstn_non_srpg_cpu30(rstn_non_srpg_cpu30 ) ,
        .gate_clk_cpu30(gate_clk_cpu30      )      ,
        .isolate_cpu30(isolate_cpu30       )       ,
        .save_edge_cpu30(save_edge_cpu30   )   ,
        .restore_edge_cpu30(restore_edge_cpu30   )   ,
        .pwr1_on_cpu30(pwr1_on_cpu30       )       ,
        .pwr2_on_cpu30(pwr2_on_cpu30       )       ,
        .pwr1_off_cpu30(pwr1_off_cpu30      )      ,
        .pwr2_off_cpu30(pwr2_off_cpu30      )      ,
        
        .rstn_non_srpg_alut30(rstn_non_srpg_alut30 ) ,
        .gate_clk_alut30(gate_clk_alut30      )      ,
        .isolate_alut30(isolate_alut30       )       ,
        .save_edge_alut30(save_edge_alut30   )   ,
        .restore_edge_alut30(restore_edge_alut30   )   ,
        .pwr1_on_alut30(pwr1_on_alut30       )       ,
        .pwr2_on_alut30(pwr2_on_alut30       )       ,
        .pwr1_off_alut30(pwr1_off_alut30      )      ,
        .pwr2_off_alut30(pwr2_off_alut30      )      ,
        
        .rstn_non_srpg_mem30(rstn_non_srpg_mem30 ) ,
        .gate_clk_mem30(gate_clk_mem30      )      ,
        .isolate_mem30(isolate_mem30       )       ,
        .save_edge_mem30(save_edge_mem30   )   ,
        .restore_edge_mem30(restore_edge_mem30   )   ,
        .pwr1_on_mem30(pwr1_on_mem30       )       ,
        .pwr2_on_mem30(pwr2_on_mem30       )       ,
        .pwr1_off_mem30(pwr1_off_mem30      )      ,
        .pwr2_off_mem30(pwr2_off_mem30      )      ,

    	.core06v30(core06v30),     //  : out std_logic30
    	.core08v30(core08v30),     //  : out std_logic30
    	.core10v30(core10v30),     //  : out std_logic30
    	.core12v30(core12v30),     //  : out std_logic30
        .pcm_macb_wakeup_int30(pcm_macb_wakeup_int30),
        .mte_smc_start30(mte_smc_start30),
        .mte_uart_start30(mte_uart_start30),
        .mte_smc_uart_start30(mte_smc_uart_start30),  
        .mte_pm_smc_to_default_start30(mte_pm_smc_to_default_start30), 
        .mte_pm_uart_to_default_start30(mte_pm_uart_to_default_start30),
        .mte_pm_smc_uart_to_default_start30(mte_pm_smc_uart_to_default_start30)
);


`else 
//##############################################################################
// if the POWER_CTRL30 is black30 boxed30 
//##############################################################################

   //------------------------------------
   // Clocks30 & Reset30
   //------------------------------------
   wire              pclk30;
   wire              nprst30;
   //------------------------------------
   // APB30 programming30 interface;
   //------------------------------------
   wire   [31:0]     paddr30;
   wire              psel30;
   wire              penable30;
   wire              pwrite30;
   wire   [31:0]     pwdata30;
   reg    [31:0]     prdata30;
   //------------------------------------
   // Scan30
   //------------------------------------
   wire              scan_in30;
   wire              scan_en30;
   wire              scan_mode30;
   reg               scan_out30;
   //------------------------------------
   // Module30 control30 outputs30
   //------------------------------------
   // SMC30;
   reg               rstn_non_srpg_smc30;
   reg               gate_clk_smc30;
   reg               isolate_smc30;
   reg               save_edge_smc30;
   reg               restore_edge_smc30;
   reg               pwr1_on_smc30;
   reg               pwr2_on_smc30;
   wire              pwr1_off_smc30;
   wire              pwr2_off_smc30;

   // URT30;
   reg               rstn_non_srpg_urt30;
   reg               gate_clk_urt30;
   reg               isolate_urt30;
   reg               save_edge_urt30;
   reg               restore_edge_urt30;
   reg               pwr1_on_urt30;
   reg               pwr2_on_urt30;
   wire              pwr1_off_urt30;
   wire              pwr2_off_urt30;

   // ETH030
   reg               rstn_non_srpg_macb030;
   reg               gate_clk_macb030;
   reg               isolate_macb030;
   reg               save_edge_macb030;
   reg               restore_edge_macb030;
   reg               pwr1_on_macb030;
   reg               pwr2_on_macb030;
   wire              pwr1_off_macb030;
   wire              pwr2_off_macb030;
   // ETH130
   reg               rstn_non_srpg_macb130;
   reg               gate_clk_macb130;
   reg               isolate_macb130;
   reg               save_edge_macb130;
   reg               restore_edge_macb130;
   reg               pwr1_on_macb130;
   reg               pwr2_on_macb130;
   wire              pwr1_off_macb130;
   wire              pwr2_off_macb130;
   // ETH230
   reg               rstn_non_srpg_macb230;
   reg               gate_clk_macb230;
   reg               isolate_macb230;
   reg               save_edge_macb230;
   reg               restore_edge_macb230;
   reg               pwr1_on_macb230;
   reg               pwr2_on_macb230;
   wire              pwr1_off_macb230;
   wire              pwr2_off_macb230;
   // ETH330
   reg               rstn_non_srpg_macb330;
   reg               gate_clk_macb330;
   reg               isolate_macb330;
   reg               save_edge_macb330;
   reg               restore_edge_macb330;
   reg               pwr1_on_macb330;
   reg               pwr2_on_macb330;
   wire              pwr1_off_macb330;
   wire              pwr2_off_macb330;

   wire core06v30;
   wire core08v30;
   wire core10v30;
   wire core12v30;



`endif
//##############################################################################
// black30 boxed30 defines30 
//##############################################################################

endmodule
