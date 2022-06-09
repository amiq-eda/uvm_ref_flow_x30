//File28 name   : power_ctrl_veneer28.v
//Title28       : 
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------
module power_ctrl_veneer28 (
    //------------------------------------
    // Clocks28 & Reset28
    //------------------------------------
    pclk28,
    nprst28,
    //------------------------------------
    // APB28 programming28 interface
    //------------------------------------
    paddr28,
    psel28,
    penable28,
    pwrite28,
    pwdata28,
    prdata28,
    // mac28 i/f,
    macb3_wakeup28,
    macb2_wakeup28,
    macb1_wakeup28,
    macb0_wakeup28,
    //------------------------------------
    // Scan28 
    //------------------------------------
    scan_in28,
    scan_en28,
    scan_mode28,
    scan_out28,
    int_source_h28,
    //------------------------------------
    // Module28 control28 outputs28
    //------------------------------------
    // SMC28
    rstn_non_srpg_smc28,
    gate_clk_smc28,
    isolate_smc28,
    save_edge_smc28,
    restore_edge_smc28,
    pwr1_on_smc28,
    pwr2_on_smc28,
    // URT28
    rstn_non_srpg_urt28,
    gate_clk_urt28,
    isolate_urt28,
    save_edge_urt28,
    restore_edge_urt28,
    pwr1_on_urt28,
    pwr2_on_urt28,
    // ETH028
    rstn_non_srpg_macb028,
    gate_clk_macb028,
    isolate_macb028,
    save_edge_macb028,
    restore_edge_macb028,
    pwr1_on_macb028,
    pwr2_on_macb028,
    // ETH128
    rstn_non_srpg_macb128,
    gate_clk_macb128,
    isolate_macb128,
    save_edge_macb128,
    restore_edge_macb128,
    pwr1_on_macb128,
    pwr2_on_macb128,
    // ETH228
    rstn_non_srpg_macb228,
    gate_clk_macb228,
    isolate_macb228,
    save_edge_macb228,
    restore_edge_macb228,
    pwr1_on_macb228,
    pwr2_on_macb228,
    // ETH328
    rstn_non_srpg_macb328,
    gate_clk_macb328,
    isolate_macb328,
    save_edge_macb328,
    restore_edge_macb328,
    pwr1_on_macb328,
    pwr2_on_macb328,
    // core28 dvfs28 transitions28
    core06v28,
    core08v28,
    core10v28,
    core12v28,
    pcm_macb_wakeup_int28,
    isolate_mem28,
    
    // transit28 signals28
    mte_smc_start28,
    mte_uart_start28,
    mte_smc_uart_start28,  
    mte_pm_smc_to_default_start28, 
    mte_pm_uart_to_default_start28,
    mte_pm_smc_uart_to_default_start28
  );

//------------------------------------------------------------------------------
// I28/O28 declaration28
//------------------------------------------------------------------------------

   //------------------------------------
   // Clocks28 & Reset28
   //------------------------------------
   input             pclk28;
   input             nprst28;
   //------------------------------------
   // APB28 programming28 interface;
   //------------------------------------
   input  [31:0]     paddr28;
   input             psel28;
   input             penable28;
   input             pwrite28;
   input  [31:0]     pwdata28;
   output [31:0]     prdata28;
    // mac28
   input macb3_wakeup28;
   input macb2_wakeup28;
   input macb1_wakeup28;
   input macb0_wakeup28;
   //------------------------------------
   // Scan28
   //------------------------------------
   input             scan_in28;
   input             scan_en28;
   input             scan_mode28;
   output            scan_out28;
   //------------------------------------
   // Module28 control28 outputs28
   input             int_source_h28;
   //------------------------------------
   // SMC28
   output            rstn_non_srpg_smc28;
   output            gate_clk_smc28;
   output            isolate_smc28;
   output            save_edge_smc28;
   output            restore_edge_smc28;
   output            pwr1_on_smc28;
   output            pwr2_on_smc28;
   // URT28
   output            rstn_non_srpg_urt28;
   output            gate_clk_urt28;
   output            isolate_urt28;
   output            save_edge_urt28;
   output            restore_edge_urt28;
   output            pwr1_on_urt28;
   output            pwr2_on_urt28;
   // ETH028
   output            rstn_non_srpg_macb028;
   output            gate_clk_macb028;
   output            isolate_macb028;
   output            save_edge_macb028;
   output            restore_edge_macb028;
   output            pwr1_on_macb028;
   output            pwr2_on_macb028;
   // ETH128
   output            rstn_non_srpg_macb128;
   output            gate_clk_macb128;
   output            isolate_macb128;
   output            save_edge_macb128;
   output            restore_edge_macb128;
   output            pwr1_on_macb128;
   output            pwr2_on_macb128;
   // ETH228
   output            rstn_non_srpg_macb228;
   output            gate_clk_macb228;
   output            isolate_macb228;
   output            save_edge_macb228;
   output            restore_edge_macb228;
   output            pwr1_on_macb228;
   output            pwr2_on_macb228;
   // ETH328
   output            rstn_non_srpg_macb328;
   output            gate_clk_macb328;
   output            isolate_macb328;
   output            save_edge_macb328;
   output            restore_edge_macb328;
   output            pwr1_on_macb328;
   output            pwr2_on_macb328;

   // dvfs28
   output core06v28;
   output core08v28;
   output core10v28;
   output core12v28;
   output pcm_macb_wakeup_int28 ;
   output isolate_mem28 ;

   //transit28  signals28
   output mte_smc_start28;
   output mte_uart_start28;
   output mte_smc_uart_start28;  
   output mte_pm_smc_to_default_start28; 
   output mte_pm_uart_to_default_start28;
   output mte_pm_smc_uart_to_default_start28;



//##############################################################################
// if the POWER_CTRL28 is NOT28 black28 boxed28 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_POWER_CTRL28

power_ctrl28 i_power_ctrl28(
    // -- Clocks28 & Reset28
    	.pclk28(pclk28), 			//  : in  std_logic28;
    	.nprst28(nprst28), 		//  : in  std_logic28;
    // -- APB28 programming28 interface
    	.paddr28(paddr28), 			//  : in  std_logic_vector28(31 downto28 0);
    	.psel28(psel28), 			//  : in  std_logic28;
    	.penable28(penable28), 		//  : in  std_logic28;
    	.pwrite28(pwrite28), 		//  : in  std_logic28;
    	.pwdata28(pwdata28), 		//  : in  std_logic_vector28(31 downto28 0);
    	.prdata28(prdata28), 		//  : out std_logic_vector28(31 downto28 0);
        .macb3_wakeup28(macb3_wakeup28),
        .macb2_wakeup28(macb2_wakeup28),
        .macb1_wakeup28(macb1_wakeup28),
        .macb0_wakeup28(macb0_wakeup28),
    // -- Module28 control28 outputs28
    	.scan_in28(),			//  : in  std_logic28;
    	.scan_en28(scan_en28),             	//  : in  std_logic28;
    	.scan_mode28(scan_mode28),          //  : in  std_logic28;
    	.scan_out28(),            	//  : out std_logic28;
    	.int_source_h28(int_source_h28),    //  : out std_logic28;
     	.rstn_non_srpg_smc28(rstn_non_srpg_smc28), 		//   : out std_logic28;
    	.gate_clk_smc28(gate_clk_smc28), 	//  : out std_logic28;
    	.isolate_smc28(isolate_smc28), 	//  : out std_logic28;
    	.save_edge_smc28(save_edge_smc28), 	//  : out std_logic28;
    	.restore_edge_smc28(restore_edge_smc28), 	//  : out std_logic28;
    	.pwr1_on_smc28(pwr1_on_smc28), 	//  : out std_logic28;
    	.pwr2_on_smc28(pwr2_on_smc28), 	//  : out std_logic28
	.pwr1_off_smc28(pwr1_off_smc28), 	//  : out std_logic28;
    	.pwr2_off_smc28(pwr2_off_smc28), 	//  : out std_logic28
     	.rstn_non_srpg_urt28(rstn_non_srpg_urt28), 		//   : out std_logic28;
    	.gate_clk_urt28(gate_clk_urt28), 	//  : out std_logic28;
    	.isolate_urt28(isolate_urt28), 	//  : out std_logic28;
    	.save_edge_urt28(save_edge_urt28), 	//  : out std_logic28;
    	.restore_edge_urt28(restore_edge_urt28), 	//  : out std_logic28;
    	.pwr1_on_urt28(pwr1_on_urt28), 	//  : out std_logic28;
    	.pwr2_on_urt28(pwr2_on_urt28), 	//  : out std_logic28;
    	.pwr1_off_urt28(pwr1_off_urt28),    //  : out std_logic28;
    	.pwr2_off_urt28(pwr2_off_urt28),     //  : out std_logic28
     	.rstn_non_srpg_macb028(rstn_non_srpg_macb028), 		//   : out std_logic28;
    	.gate_clk_macb028(gate_clk_macb028), 	//  : out std_logic28;
    	.isolate_macb028(isolate_macb028), 	//  : out std_logic28;
    	.save_edge_macb028(save_edge_macb028), 	//  : out std_logic28;
    	.restore_edge_macb028(restore_edge_macb028), 	//  : out std_logic28;
    	.pwr1_on_macb028(pwr1_on_macb028), 	//  : out std_logic28;
    	.pwr2_on_macb028(pwr2_on_macb028), 	//  : out std_logic28;
    	.pwr1_off_macb028(pwr1_off_macb028),    //  : out std_logic28;
    	.pwr2_off_macb028(pwr2_off_macb028),     //  : out std_logic28
     	.rstn_non_srpg_macb128(rstn_non_srpg_macb128), 		//   : out std_logic28;
    	.gate_clk_macb128(gate_clk_macb128), 	//  : out std_logic28;
    	.isolate_macb128(isolate_macb128), 	//  : out std_logic28;
    	.save_edge_macb128(save_edge_macb128), 	//  : out std_logic28;
    	.restore_edge_macb128(restore_edge_macb128), 	//  : out std_logic28;
    	.pwr1_on_macb128(pwr1_on_macb128), 	//  : out std_logic28;
    	.pwr2_on_macb128(pwr2_on_macb128), 	//  : out std_logic28;
    	.pwr1_off_macb128(pwr1_off_macb128),    //  : out std_logic28;
    	.pwr2_off_macb128(pwr2_off_macb128),     //  : out std_logic28
     	.rstn_non_srpg_macb228(rstn_non_srpg_macb228), 		//   : out std_logic28;
    	.gate_clk_macb228(gate_clk_macb228), 	//  : out std_logic28;
    	.isolate_macb228(isolate_macb228), 	//  : out std_logic28;
    	.save_edge_macb228(save_edge_macb228), 	//  : out std_logic28;
    	.restore_edge_macb228(restore_edge_macb228), 	//  : out std_logic28;
    	.pwr1_on_macb228(pwr1_on_macb228), 	//  : out std_logic28;
    	.pwr2_on_macb228(pwr2_on_macb228), 	//  : out std_logic28;
    	.pwr1_off_macb228(pwr1_off_macb228),    //  : out std_logic28;
    	.pwr2_off_macb228(pwr2_off_macb228),     //  : out std_logic28
     	.rstn_non_srpg_macb328(rstn_non_srpg_macb328), 		//   : out std_logic28;
    	.gate_clk_macb328(gate_clk_macb328), 	//  : out std_logic28;
    	.isolate_macb328(isolate_macb328), 	//  : out std_logic28;
    	.save_edge_macb328(save_edge_macb328), 	//  : out std_logic28;
    	.restore_edge_macb328(restore_edge_macb328), 	//  : out std_logic28;
    	.pwr1_on_macb328(pwr1_on_macb328), 	//  : out std_logic28;
    	.pwr2_on_macb328(pwr2_on_macb328), 	//  : out std_logic28;
    	.pwr1_off_macb328(pwr1_off_macb328),    //  : out std_logic28;
    	.pwr2_off_macb328(pwr2_off_macb328),     //  : out std_logic28
        .rstn_non_srpg_dma28(rstn_non_srpg_dma28 ) ,
        .gate_clk_dma28(gate_clk_dma28      )      ,
        .isolate_dma28(isolate_dma28       )       ,
        .save_edge_dma28(save_edge_dma28   )   ,
        .restore_edge_dma28(restore_edge_dma28   )   ,
        .pwr1_on_dma28(pwr1_on_dma28       )       ,
        .pwr2_on_dma28(pwr2_on_dma28       )       ,
        .pwr1_off_dma28(pwr1_off_dma28      )      ,
        .pwr2_off_dma28(pwr2_off_dma28      )      ,
        
        .rstn_non_srpg_cpu28(rstn_non_srpg_cpu28 ) ,
        .gate_clk_cpu28(gate_clk_cpu28      )      ,
        .isolate_cpu28(isolate_cpu28       )       ,
        .save_edge_cpu28(save_edge_cpu28   )   ,
        .restore_edge_cpu28(restore_edge_cpu28   )   ,
        .pwr1_on_cpu28(pwr1_on_cpu28       )       ,
        .pwr2_on_cpu28(pwr2_on_cpu28       )       ,
        .pwr1_off_cpu28(pwr1_off_cpu28      )      ,
        .pwr2_off_cpu28(pwr2_off_cpu28      )      ,
        
        .rstn_non_srpg_alut28(rstn_non_srpg_alut28 ) ,
        .gate_clk_alut28(gate_clk_alut28      )      ,
        .isolate_alut28(isolate_alut28       )       ,
        .save_edge_alut28(save_edge_alut28   )   ,
        .restore_edge_alut28(restore_edge_alut28   )   ,
        .pwr1_on_alut28(pwr1_on_alut28       )       ,
        .pwr2_on_alut28(pwr2_on_alut28       )       ,
        .pwr1_off_alut28(pwr1_off_alut28      )      ,
        .pwr2_off_alut28(pwr2_off_alut28      )      ,
        
        .rstn_non_srpg_mem28(rstn_non_srpg_mem28 ) ,
        .gate_clk_mem28(gate_clk_mem28      )      ,
        .isolate_mem28(isolate_mem28       )       ,
        .save_edge_mem28(save_edge_mem28   )   ,
        .restore_edge_mem28(restore_edge_mem28   )   ,
        .pwr1_on_mem28(pwr1_on_mem28       )       ,
        .pwr2_on_mem28(pwr2_on_mem28       )       ,
        .pwr1_off_mem28(pwr1_off_mem28      )      ,
        .pwr2_off_mem28(pwr2_off_mem28      )      ,

    	.core06v28(core06v28),     //  : out std_logic28
    	.core08v28(core08v28),     //  : out std_logic28
    	.core10v28(core10v28),     //  : out std_logic28
    	.core12v28(core12v28),     //  : out std_logic28
        .pcm_macb_wakeup_int28(pcm_macb_wakeup_int28),
        .mte_smc_start28(mte_smc_start28),
        .mte_uart_start28(mte_uart_start28),
        .mte_smc_uart_start28(mte_smc_uart_start28),  
        .mte_pm_smc_to_default_start28(mte_pm_smc_to_default_start28), 
        .mte_pm_uart_to_default_start28(mte_pm_uart_to_default_start28),
        .mte_pm_smc_uart_to_default_start28(mte_pm_smc_uart_to_default_start28)
);


`else 
//##############################################################################
// if the POWER_CTRL28 is black28 boxed28 
//##############################################################################

   //------------------------------------
   // Clocks28 & Reset28
   //------------------------------------
   wire              pclk28;
   wire              nprst28;
   //------------------------------------
   // APB28 programming28 interface;
   //------------------------------------
   wire   [31:0]     paddr28;
   wire              psel28;
   wire              penable28;
   wire              pwrite28;
   wire   [31:0]     pwdata28;
   reg    [31:0]     prdata28;
   //------------------------------------
   // Scan28
   //------------------------------------
   wire              scan_in28;
   wire              scan_en28;
   wire              scan_mode28;
   reg               scan_out28;
   //------------------------------------
   // Module28 control28 outputs28
   //------------------------------------
   // SMC28;
   reg               rstn_non_srpg_smc28;
   reg               gate_clk_smc28;
   reg               isolate_smc28;
   reg               save_edge_smc28;
   reg               restore_edge_smc28;
   reg               pwr1_on_smc28;
   reg               pwr2_on_smc28;
   wire              pwr1_off_smc28;
   wire              pwr2_off_smc28;

   // URT28;
   reg               rstn_non_srpg_urt28;
   reg               gate_clk_urt28;
   reg               isolate_urt28;
   reg               save_edge_urt28;
   reg               restore_edge_urt28;
   reg               pwr1_on_urt28;
   reg               pwr2_on_urt28;
   wire              pwr1_off_urt28;
   wire              pwr2_off_urt28;

   // ETH028
   reg               rstn_non_srpg_macb028;
   reg               gate_clk_macb028;
   reg               isolate_macb028;
   reg               save_edge_macb028;
   reg               restore_edge_macb028;
   reg               pwr1_on_macb028;
   reg               pwr2_on_macb028;
   wire              pwr1_off_macb028;
   wire              pwr2_off_macb028;
   // ETH128
   reg               rstn_non_srpg_macb128;
   reg               gate_clk_macb128;
   reg               isolate_macb128;
   reg               save_edge_macb128;
   reg               restore_edge_macb128;
   reg               pwr1_on_macb128;
   reg               pwr2_on_macb128;
   wire              pwr1_off_macb128;
   wire              pwr2_off_macb128;
   // ETH228
   reg               rstn_non_srpg_macb228;
   reg               gate_clk_macb228;
   reg               isolate_macb228;
   reg               save_edge_macb228;
   reg               restore_edge_macb228;
   reg               pwr1_on_macb228;
   reg               pwr2_on_macb228;
   wire              pwr1_off_macb228;
   wire              pwr2_off_macb228;
   // ETH328
   reg               rstn_non_srpg_macb328;
   reg               gate_clk_macb328;
   reg               isolate_macb328;
   reg               save_edge_macb328;
   reg               restore_edge_macb328;
   reg               pwr1_on_macb328;
   reg               pwr2_on_macb328;
   wire              pwr1_off_macb328;
   wire              pwr2_off_macb328;

   wire core06v28;
   wire core08v28;
   wire core10v28;
   wire core12v28;



`endif
//##############################################################################
// black28 boxed28 defines28 
//##############################################################################

endmodule
