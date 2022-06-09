//File26 name   : power_ctrl26.v
//Title26       : Power26 Control26 Module26
//Created26     : 1999
//Description26 : Top26 level of power26 controller26
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

module power_ctrl26 (


    // Clocks26 & Reset26
    pclk26,
    nprst26,
    // APB26 programming26 interface
    paddr26,
    psel26,
    penable26,
    pwrite26,
    pwdata26,
    prdata26,
    // mac26 i/f,
    macb3_wakeup26,
    macb2_wakeup26,
    macb1_wakeup26,
    macb0_wakeup26,
    // Scan26 
    scan_in26,
    scan_en26,
    scan_mode26,
    scan_out26,
    // Module26 control26 outputs26
    int_source_h26,
    // SMC26
    rstn_non_srpg_smc26,
    gate_clk_smc26,
    isolate_smc26,
    save_edge_smc26,
    restore_edge_smc26,
    pwr1_on_smc26,
    pwr2_on_smc26,
    pwr1_off_smc26,
    pwr2_off_smc26,
    // URT26
    rstn_non_srpg_urt26,
    gate_clk_urt26,
    isolate_urt26,
    save_edge_urt26,
    restore_edge_urt26,
    pwr1_on_urt26,
    pwr2_on_urt26,
    pwr1_off_urt26,      
    pwr2_off_urt26,
    // ETH026
    rstn_non_srpg_macb026,
    gate_clk_macb026,
    isolate_macb026,
    save_edge_macb026,
    restore_edge_macb026,
    pwr1_on_macb026,
    pwr2_on_macb026,
    pwr1_off_macb026,      
    pwr2_off_macb026,
    // ETH126
    rstn_non_srpg_macb126,
    gate_clk_macb126,
    isolate_macb126,
    save_edge_macb126,
    restore_edge_macb126,
    pwr1_on_macb126,
    pwr2_on_macb126,
    pwr1_off_macb126,      
    pwr2_off_macb126,
    // ETH226
    rstn_non_srpg_macb226,
    gate_clk_macb226,
    isolate_macb226,
    save_edge_macb226,
    restore_edge_macb226,
    pwr1_on_macb226,
    pwr2_on_macb226,
    pwr1_off_macb226,      
    pwr2_off_macb226,
    // ETH326
    rstn_non_srpg_macb326,
    gate_clk_macb326,
    isolate_macb326,
    save_edge_macb326,
    restore_edge_macb326,
    pwr1_on_macb326,
    pwr2_on_macb326,
    pwr1_off_macb326,      
    pwr2_off_macb326,
    // DMA26
    rstn_non_srpg_dma26,
    gate_clk_dma26,
    isolate_dma26,
    save_edge_dma26,
    restore_edge_dma26,
    pwr1_on_dma26,
    pwr2_on_dma26,
    pwr1_off_dma26,      
    pwr2_off_dma26,
    // CPU26
    rstn_non_srpg_cpu26,
    gate_clk_cpu26,
    isolate_cpu26,
    save_edge_cpu26,
    restore_edge_cpu26,
    pwr1_on_cpu26,
    pwr2_on_cpu26,
    pwr1_off_cpu26,      
    pwr2_off_cpu26,
    // ALUT26
    rstn_non_srpg_alut26,
    gate_clk_alut26,
    isolate_alut26,
    save_edge_alut26,
    restore_edge_alut26,
    pwr1_on_alut26,
    pwr2_on_alut26,
    pwr1_off_alut26,      
    pwr2_off_alut26,
    // MEM26
    rstn_non_srpg_mem26,
    gate_clk_mem26,
    isolate_mem26,
    save_edge_mem26,
    restore_edge_mem26,
    pwr1_on_mem26,
    pwr2_on_mem26,
    pwr1_off_mem26,      
    pwr2_off_mem26,
    // core26 dvfs26 transitions26
    core06v26,
    core08v26,
    core10v26,
    core12v26,
    pcm_macb_wakeup_int26,
    // mte26 signals26
    mte_smc_start26,
    mte_uart_start26,
    mte_smc_uart_start26,  
    mte_pm_smc_to_default_start26, 
    mte_pm_uart_to_default_start26,
    mte_pm_smc_uart_to_default_start26

  );

  parameter STATE_IDLE_12V26 = 4'b0001;
  parameter STATE_06V26 = 4'b0010;
  parameter STATE_08V26 = 4'b0100;
  parameter STATE_10V26 = 4'b1000;

    // Clocks26 & Reset26
    input pclk26;
    input nprst26;
    // APB26 programming26 interface
    input [31:0] paddr26;
    input psel26  ;
    input penable26;
    input pwrite26 ;
    input [31:0] pwdata26;
    output [31:0] prdata26;
    // mac26
    input macb3_wakeup26;
    input macb2_wakeup26;
    input macb1_wakeup26;
    input macb0_wakeup26;
    // Scan26 
    input scan_in26;
    input scan_en26;
    input scan_mode26;
    output scan_out26;
    // Module26 control26 outputs26
    input int_source_h26;
    // SMC26
    output rstn_non_srpg_smc26 ;
    output gate_clk_smc26   ;
    output isolate_smc26   ;
    output save_edge_smc26   ;
    output restore_edge_smc26   ;
    output pwr1_on_smc26   ;
    output pwr2_on_smc26   ;
    output pwr1_off_smc26  ;
    output pwr2_off_smc26  ;
    // URT26
    output rstn_non_srpg_urt26 ;
    output gate_clk_urt26      ;
    output isolate_urt26       ;
    output save_edge_urt26   ;
    output restore_edge_urt26   ;
    output pwr1_on_urt26       ;
    output pwr2_on_urt26       ;
    output pwr1_off_urt26      ;
    output pwr2_off_urt26      ;
    // ETH026
    output rstn_non_srpg_macb026 ;
    output gate_clk_macb026      ;
    output isolate_macb026       ;
    output save_edge_macb026   ;
    output restore_edge_macb026   ;
    output pwr1_on_macb026       ;
    output pwr2_on_macb026       ;
    output pwr1_off_macb026      ;
    output pwr2_off_macb026      ;
    // ETH126
    output rstn_non_srpg_macb126 ;
    output gate_clk_macb126      ;
    output isolate_macb126       ;
    output save_edge_macb126   ;
    output restore_edge_macb126   ;
    output pwr1_on_macb126       ;
    output pwr2_on_macb126       ;
    output pwr1_off_macb126      ;
    output pwr2_off_macb126      ;
    // ETH226
    output rstn_non_srpg_macb226 ;
    output gate_clk_macb226      ;
    output isolate_macb226       ;
    output save_edge_macb226   ;
    output restore_edge_macb226   ;
    output pwr1_on_macb226       ;
    output pwr2_on_macb226       ;
    output pwr1_off_macb226      ;
    output pwr2_off_macb226      ;
    // ETH326
    output rstn_non_srpg_macb326 ;
    output gate_clk_macb326      ;
    output isolate_macb326       ;
    output save_edge_macb326   ;
    output restore_edge_macb326   ;
    output pwr1_on_macb326       ;
    output pwr2_on_macb326       ;
    output pwr1_off_macb326      ;
    output pwr2_off_macb326      ;
    // DMA26
    output rstn_non_srpg_dma26 ;
    output gate_clk_dma26      ;
    output isolate_dma26       ;
    output save_edge_dma26   ;
    output restore_edge_dma26   ;
    output pwr1_on_dma26       ;
    output pwr2_on_dma26       ;
    output pwr1_off_dma26      ;
    output pwr2_off_dma26      ;
    // CPU26
    output rstn_non_srpg_cpu26 ;
    output gate_clk_cpu26      ;
    output isolate_cpu26       ;
    output save_edge_cpu26   ;
    output restore_edge_cpu26   ;
    output pwr1_on_cpu26       ;
    output pwr2_on_cpu26       ;
    output pwr1_off_cpu26      ;
    output pwr2_off_cpu26      ;
    // ALUT26
    output rstn_non_srpg_alut26 ;
    output gate_clk_alut26      ;
    output isolate_alut26       ;
    output save_edge_alut26   ;
    output restore_edge_alut26   ;
    output pwr1_on_alut26       ;
    output pwr2_on_alut26       ;
    output pwr1_off_alut26      ;
    output pwr2_off_alut26      ;
    // MEM26
    output rstn_non_srpg_mem26 ;
    output gate_clk_mem26      ;
    output isolate_mem26       ;
    output save_edge_mem26   ;
    output restore_edge_mem26   ;
    output pwr1_on_mem26       ;
    output pwr2_on_mem26       ;
    output pwr1_off_mem26      ;
    output pwr2_off_mem26      ;


   // core26 transitions26 o/p
    output core06v26;
    output core08v26;
    output core10v26;
    output core12v26;
    output pcm_macb_wakeup_int26 ;
    //mode mte26  signals26
    output mte_smc_start26;
    output mte_uart_start26;
    output mte_smc_uart_start26;  
    output mte_pm_smc_to_default_start26; 
    output mte_pm_uart_to_default_start26;
    output mte_pm_smc_uart_to_default_start26;

    reg mte_smc_start26;
    reg mte_uart_start26;
    reg mte_smc_uart_start26;  
    reg mte_pm_smc_to_default_start26; 
    reg mte_pm_uart_to_default_start26;
    reg mte_pm_smc_uart_to_default_start26;

    reg [31:0] prdata26;

  wire valid_reg_write26  ;
  wire valid_reg_read26   ;
  wire L1_ctrl_access26   ;
  wire L1_status_access26 ;
  wire pcm_int_mask_access26;
  wire pcm_int_status_access26;
  wire standby_mem026      ;
  wire standby_mem126      ;
  wire standby_mem226      ;
  wire standby_mem326      ;
  wire pwr1_off_mem026;
  wire pwr1_off_mem126;
  wire pwr1_off_mem226;
  wire pwr1_off_mem326;
  
  // Control26 signals26
  wire set_status_smc26   ;
  wire clr_status_smc26   ;
  wire set_status_urt26   ;
  wire clr_status_urt26   ;
  wire set_status_macb026   ;
  wire clr_status_macb026   ;
  wire set_status_macb126   ;
  wire clr_status_macb126   ;
  wire set_status_macb226   ;
  wire clr_status_macb226   ;
  wire set_status_macb326   ;
  wire clr_status_macb326   ;
  wire set_status_dma26   ;
  wire clr_status_dma26   ;
  wire set_status_cpu26   ;
  wire clr_status_cpu26   ;
  wire set_status_alut26   ;
  wire clr_status_alut26   ;
  wire set_status_mem26   ;
  wire clr_status_mem26   ;


  // Status and Control26 registers
  reg [31:0]  L1_status_reg26;
  reg  [31:0] L1_ctrl_reg26  ;
  reg  [31:0] L1_ctrl_domain26  ;
  reg L1_ctrl_cpu_off_reg26;
  reg [31:0]  pcm_mask_reg26;
  reg [31:0]  pcm_status_reg26;

  // Signals26 gated26 in scan_mode26
  //SMC26
  wire  rstn_non_srpg_smc_int26;
  wire  gate_clk_smc_int26    ;     
  wire  isolate_smc_int26    ;       
  wire save_edge_smc_int26;
  wire restore_edge_smc_int26;
  wire  pwr1_on_smc_int26    ;      
  wire  pwr2_on_smc_int26    ;      


  //URT26
  wire   rstn_non_srpg_urt_int26;
  wire   gate_clk_urt_int26     ;     
  wire   isolate_urt_int26      ;       
  wire save_edge_urt_int26;
  wire restore_edge_urt_int26;
  wire   pwr1_on_urt_int26      ;      
  wire   pwr2_on_urt_int26      ;      

  // ETH026
  wire   rstn_non_srpg_macb0_int26;
  wire   gate_clk_macb0_int26     ;     
  wire   isolate_macb0_int26      ;       
  wire save_edge_macb0_int26;
  wire restore_edge_macb0_int26;
  wire   pwr1_on_macb0_int26      ;      
  wire   pwr2_on_macb0_int26      ;      
  // ETH126
  wire   rstn_non_srpg_macb1_int26;
  wire   gate_clk_macb1_int26     ;     
  wire   isolate_macb1_int26      ;       
  wire save_edge_macb1_int26;
  wire restore_edge_macb1_int26;
  wire   pwr1_on_macb1_int26      ;      
  wire   pwr2_on_macb1_int26      ;      
  // ETH226
  wire   rstn_non_srpg_macb2_int26;
  wire   gate_clk_macb2_int26     ;     
  wire   isolate_macb2_int26      ;       
  wire save_edge_macb2_int26;
  wire restore_edge_macb2_int26;
  wire   pwr1_on_macb2_int26      ;      
  wire   pwr2_on_macb2_int26      ;      
  // ETH326
  wire   rstn_non_srpg_macb3_int26;
  wire   gate_clk_macb3_int26     ;     
  wire   isolate_macb3_int26      ;       
  wire save_edge_macb3_int26;
  wire restore_edge_macb3_int26;
  wire   pwr1_on_macb3_int26      ;      
  wire   pwr2_on_macb3_int26      ;      

  // DMA26
  wire   rstn_non_srpg_dma_int26;
  wire   gate_clk_dma_int26     ;     
  wire   isolate_dma_int26      ;       
  wire save_edge_dma_int26;
  wire restore_edge_dma_int26;
  wire   pwr1_on_dma_int26      ;      
  wire   pwr2_on_dma_int26      ;      

  // CPU26
  wire   rstn_non_srpg_cpu_int26;
  wire   gate_clk_cpu_int26     ;     
  wire   isolate_cpu_int26      ;       
  wire save_edge_cpu_int26;
  wire restore_edge_cpu_int26;
  wire   pwr1_on_cpu_int26      ;      
  wire   pwr2_on_cpu_int26      ;  
  wire L1_ctrl_cpu_off_p26;    

  reg save_alut_tmp26;
  // DFS26 sm26

  reg cpu_shutoff_ctrl26;

  reg mte_mac_off_start26, mte_mac012_start26, mte_mac013_start26, mte_mac023_start26, mte_mac123_start26;
  reg mte_mac01_start26, mte_mac02_start26, mte_mac03_start26, mte_mac12_start26, mte_mac13_start26, mte_mac23_start26;
  reg mte_mac0_start26, mte_mac1_start26, mte_mac2_start26, mte_mac3_start26;
  reg mte_sys_hibernate26 ;
  reg mte_dma_start26 ;
  reg mte_cpu_start26 ;
  reg mte_mac_off_sleep_start26, mte_mac012_sleep_start26, mte_mac013_sleep_start26, mte_mac023_sleep_start26, mte_mac123_sleep_start26;
  reg mte_mac01_sleep_start26, mte_mac02_sleep_start26, mte_mac03_sleep_start26, mte_mac12_sleep_start26, mte_mac13_sleep_start26, mte_mac23_sleep_start26;
  reg mte_mac0_sleep_start26, mte_mac1_sleep_start26, mte_mac2_sleep_start26, mte_mac3_sleep_start26;
  reg mte_dma_sleep_start26;
  reg mte_mac_off_to_default26, mte_mac012_to_default26, mte_mac013_to_default26, mte_mac023_to_default26, mte_mac123_to_default26;
  reg mte_mac01_to_default26, mte_mac02_to_default26, mte_mac03_to_default26, mte_mac12_to_default26, mte_mac13_to_default26, mte_mac23_to_default26;
  reg mte_mac0_to_default26, mte_mac1_to_default26, mte_mac2_to_default26, mte_mac3_to_default26;
  reg mte_dma_isolate_dis26;
  reg mte_cpu_isolate_dis26;
  reg mte_sys_hibernate_to_default26;


  // Latch26 the CPU26 SLEEP26 invocation26
  always @( posedge pclk26 or negedge nprst26) 
  begin
    if(!nprst26)
      L1_ctrl_cpu_off_reg26 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg26 <= L1_ctrl_domain26[8];
  end

  // Create26 a pulse26 for sleep26 detection26 
  assign L1_ctrl_cpu_off_p26 =  L1_ctrl_domain26[8] && !L1_ctrl_cpu_off_reg26;
  
  // CPU26 sleep26 contol26 logic 
  // Shut26 off26 CPU26 when L1_ctrl_cpu_off_p26 is set
  // wake26 cpu26 when any interrupt26 is seen26  
  always @( posedge pclk26 or negedge nprst26) 
  begin
    if(!nprst26)
     cpu_shutoff_ctrl26 <= 1'b0;
    else if(cpu_shutoff_ctrl26 && int_source_h26)
     cpu_shutoff_ctrl26 <= 1'b0;
    else if (L1_ctrl_cpu_off_p26)
     cpu_shutoff_ctrl26 <= 1'b1;
  end
 
  // instantiate26 power26 contol26  block for uart26
  power_ctrl_sm26 i_urt_power_ctrl_sm26(
    .pclk26(pclk26),
    .nprst26(nprst26),
    .L1_module_req26(L1_ctrl_domain26[1]),
    .set_status_module26(set_status_urt26),
    .clr_status_module26(clr_status_urt26),
    .rstn_non_srpg_module26(rstn_non_srpg_urt_int26),
    .gate_clk_module26(gate_clk_urt_int26),
    .isolate_module26(isolate_urt_int26),
    .save_edge26(save_edge_urt_int26),
    .restore_edge26(restore_edge_urt_int26),
    .pwr1_on26(pwr1_on_urt_int26),
    .pwr2_on26(pwr2_on_urt_int26)
    );
  

  // instantiate26 power26 contol26  block for smc26
  power_ctrl_sm26 i_smc_power_ctrl_sm26(
    .pclk26(pclk26),
    .nprst26(nprst26),
    .L1_module_req26(L1_ctrl_domain26[2]),
    .set_status_module26(set_status_smc26),
    .clr_status_module26(clr_status_smc26),
    .rstn_non_srpg_module26(rstn_non_srpg_smc_int26),
    .gate_clk_module26(gate_clk_smc_int26),
    .isolate_module26(isolate_smc_int26),
    .save_edge26(save_edge_smc_int26),
    .restore_edge26(restore_edge_smc_int26),
    .pwr1_on26(pwr1_on_smc_int26),
    .pwr2_on26(pwr2_on_smc_int26)
    );

  // power26 control26 for macb026
  power_ctrl_sm26 i_macb0_power_ctrl_sm26(
    .pclk26(pclk26),
    .nprst26(nprst26),
    .L1_module_req26(L1_ctrl_domain26[3]),
    .set_status_module26(set_status_macb026),
    .clr_status_module26(clr_status_macb026),
    .rstn_non_srpg_module26(rstn_non_srpg_macb0_int26),
    .gate_clk_module26(gate_clk_macb0_int26),
    .isolate_module26(isolate_macb0_int26),
    .save_edge26(save_edge_macb0_int26),
    .restore_edge26(restore_edge_macb0_int26),
    .pwr1_on26(pwr1_on_macb0_int26),
    .pwr2_on26(pwr2_on_macb0_int26)
    );
  // power26 control26 for macb126
  power_ctrl_sm26 i_macb1_power_ctrl_sm26(
    .pclk26(pclk26),
    .nprst26(nprst26),
    .L1_module_req26(L1_ctrl_domain26[4]),
    .set_status_module26(set_status_macb126),
    .clr_status_module26(clr_status_macb126),
    .rstn_non_srpg_module26(rstn_non_srpg_macb1_int26),
    .gate_clk_module26(gate_clk_macb1_int26),
    .isolate_module26(isolate_macb1_int26),
    .save_edge26(save_edge_macb1_int26),
    .restore_edge26(restore_edge_macb1_int26),
    .pwr1_on26(pwr1_on_macb1_int26),
    .pwr2_on26(pwr2_on_macb1_int26)
    );
  // power26 control26 for macb226
  power_ctrl_sm26 i_macb2_power_ctrl_sm26(
    .pclk26(pclk26),
    .nprst26(nprst26),
    .L1_module_req26(L1_ctrl_domain26[5]),
    .set_status_module26(set_status_macb226),
    .clr_status_module26(clr_status_macb226),
    .rstn_non_srpg_module26(rstn_non_srpg_macb2_int26),
    .gate_clk_module26(gate_clk_macb2_int26),
    .isolate_module26(isolate_macb2_int26),
    .save_edge26(save_edge_macb2_int26),
    .restore_edge26(restore_edge_macb2_int26),
    .pwr1_on26(pwr1_on_macb2_int26),
    .pwr2_on26(pwr2_on_macb2_int26)
    );
  // power26 control26 for macb326
  power_ctrl_sm26 i_macb3_power_ctrl_sm26(
    .pclk26(pclk26),
    .nprst26(nprst26),
    .L1_module_req26(L1_ctrl_domain26[6]),
    .set_status_module26(set_status_macb326),
    .clr_status_module26(clr_status_macb326),
    .rstn_non_srpg_module26(rstn_non_srpg_macb3_int26),
    .gate_clk_module26(gate_clk_macb3_int26),
    .isolate_module26(isolate_macb3_int26),
    .save_edge26(save_edge_macb3_int26),
    .restore_edge26(restore_edge_macb3_int26),
    .pwr1_on26(pwr1_on_macb3_int26),
    .pwr2_on26(pwr2_on_macb3_int26)
    );
  // power26 control26 for dma26
  power_ctrl_sm26 i_dma_power_ctrl_sm26(
    .pclk26(pclk26),
    .nprst26(nprst26),
    .L1_module_req26(L1_ctrl_domain26[7]),
    .set_status_module26(set_status_dma26),
    .clr_status_module26(clr_status_dma26),
    .rstn_non_srpg_module26(rstn_non_srpg_dma_int26),
    .gate_clk_module26(gate_clk_dma_int26),
    .isolate_module26(isolate_dma_int26),
    .save_edge26(save_edge_dma_int26),
    .restore_edge26(restore_edge_dma_int26),
    .pwr1_on26(pwr1_on_dma_int26),
    .pwr2_on26(pwr2_on_dma_int26)
    );
  // power26 control26 for CPU26
  power_ctrl_sm26 i_cpu_power_ctrl_sm26(
    .pclk26(pclk26),
    .nprst26(nprst26),
    .L1_module_req26(cpu_shutoff_ctrl26),
    .set_status_module26(set_status_cpu26),
    .clr_status_module26(clr_status_cpu26),
    .rstn_non_srpg_module26(rstn_non_srpg_cpu_int26),
    .gate_clk_module26(gate_clk_cpu_int26),
    .isolate_module26(isolate_cpu_int26),
    .save_edge26(save_edge_cpu_int26),
    .restore_edge26(restore_edge_cpu_int26),
    .pwr1_on26(pwr1_on_cpu_int26),
    .pwr2_on26(pwr2_on_cpu_int26)
    );

  assign valid_reg_write26 =  (psel26 && pwrite26 && penable26);
  assign valid_reg_read26  =  (psel26 && (!pwrite26) && penable26);

  assign L1_ctrl_access26  =  (paddr26[15:0] == 16'b0000000000000100); 
  assign L1_status_access26 = (paddr26[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access26 =   (paddr26[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access26 = (paddr26[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control26 and status register
  always @(*)
  begin  
    if(valid_reg_read26 && L1_ctrl_access26) 
      prdata26 = L1_ctrl_reg26;
    else if (valid_reg_read26 && L1_status_access26)
      prdata26 = L1_status_reg26;
    else if (valid_reg_read26 && pcm_int_mask_access26)
      prdata26 = pcm_mask_reg26;
    else if (valid_reg_read26 && pcm_int_status_access26)
      prdata26 = pcm_status_reg26;
    else 
      prdata26 = 0;
  end

  assign set_status_mem26 =  (set_status_macb026 && set_status_macb126 && set_status_macb226 &&
                            set_status_macb326 && set_status_dma26 && set_status_cpu26);

  assign clr_status_mem26 =  (clr_status_macb026 && clr_status_macb126 && clr_status_macb226 &&
                            clr_status_macb326 && clr_status_dma26 && clr_status_cpu26);

  assign set_status_alut26 = (set_status_macb026 && set_status_macb126 && set_status_macb226 && set_status_macb326);

  assign clr_status_alut26 = (clr_status_macb026 || clr_status_macb126 || clr_status_macb226  || clr_status_macb326);

  // Write accesses to the control26 and status register
 
  always @(posedge pclk26 or negedge nprst26)
  begin
    if (!nprst26) begin
      L1_ctrl_reg26   <= 0;
      L1_status_reg26 <= 0;
      pcm_mask_reg26 <= 0;
    end else begin
      // CTRL26 reg updates26
      if (valid_reg_write26 && L1_ctrl_access26) 
        L1_ctrl_reg26 <= pwdata26; // Writes26 to the ctrl26 reg
      if (valid_reg_write26 && pcm_int_mask_access26) 
        pcm_mask_reg26 <= pwdata26; // Writes26 to the ctrl26 reg

      if (set_status_urt26 == 1'b1)  
        L1_status_reg26[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt26 == 1'b1) 
        L1_status_reg26[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc26 == 1'b1) 
        L1_status_reg26[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc26 == 1'b1) 
        L1_status_reg26[2] <= 1'b0; // Clear the status bit

      if (set_status_macb026 == 1'b1)  
        L1_status_reg26[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb026 == 1'b1) 
        L1_status_reg26[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb126 == 1'b1)  
        L1_status_reg26[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb126 == 1'b1) 
        L1_status_reg26[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb226 == 1'b1)  
        L1_status_reg26[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb226 == 1'b1) 
        L1_status_reg26[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb326 == 1'b1)  
        L1_status_reg26[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb326 == 1'b1) 
        L1_status_reg26[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma26 == 1'b1)  
        L1_status_reg26[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma26 == 1'b1) 
        L1_status_reg26[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu26 == 1'b1)  
        L1_status_reg26[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu26 == 1'b1) 
        L1_status_reg26[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut26 == 1'b1)  
        L1_status_reg26[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut26 == 1'b1) 
        L1_status_reg26[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem26 == 1'b1)  
        L1_status_reg26[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem26 == 1'b1) 
        L1_status_reg26[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused26 bits of pcm_status_reg26 are tied26 to 0
  always @(posedge pclk26 or negedge nprst26)
  begin
    if (!nprst26)
      pcm_status_reg26[31:4] <= 'b0;
    else  
      pcm_status_reg26[31:4] <= pcm_status_reg26[31:4];
  end
  
  // interrupt26 only of h/w assisted26 wakeup
  // MAC26 3
  always @(posedge pclk26 or negedge nprst26)
  begin
    if(!nprst26)
      pcm_status_reg26[3] <= 1'b0;
    else if (valid_reg_write26 && pcm_int_status_access26) 
      pcm_status_reg26[3] <= pwdata26[3];
    else if (macb3_wakeup26 & ~pcm_mask_reg26[3])
      pcm_status_reg26[3] <= 1'b1;
    else if (valid_reg_read26 && pcm_int_status_access26) 
      pcm_status_reg26[3] <= 1'b0;
    else
      pcm_status_reg26[3] <= pcm_status_reg26[3];
  end  
   
  // MAC26 2
  always @(posedge pclk26 or negedge nprst26)
  begin
    if(!nprst26)
      pcm_status_reg26[2] <= 1'b0;
    else if (valid_reg_write26 && pcm_int_status_access26) 
      pcm_status_reg26[2] <= pwdata26[2];
    else if (macb2_wakeup26 & ~pcm_mask_reg26[2])
      pcm_status_reg26[2] <= 1'b1;
    else if (valid_reg_read26 && pcm_int_status_access26) 
      pcm_status_reg26[2] <= 1'b0;
    else
      pcm_status_reg26[2] <= pcm_status_reg26[2];
  end  

  // MAC26 1
  always @(posedge pclk26 or negedge nprst26)
  begin
    if(!nprst26)
      pcm_status_reg26[1] <= 1'b0;
    else if (valid_reg_write26 && pcm_int_status_access26) 
      pcm_status_reg26[1] <= pwdata26[1];
    else if (macb1_wakeup26 & ~pcm_mask_reg26[1])
      pcm_status_reg26[1] <= 1'b1;
    else if (valid_reg_read26 && pcm_int_status_access26) 
      pcm_status_reg26[1] <= 1'b0;
    else
      pcm_status_reg26[1] <= pcm_status_reg26[1];
  end  
   
  // MAC26 0
  always @(posedge pclk26 or negedge nprst26)
  begin
    if(!nprst26)
      pcm_status_reg26[0] <= 1'b0;
    else if (valid_reg_write26 && pcm_int_status_access26) 
      pcm_status_reg26[0] <= pwdata26[0];
    else if (macb0_wakeup26 & ~pcm_mask_reg26[0])
      pcm_status_reg26[0] <= 1'b1;
    else if (valid_reg_read26 && pcm_int_status_access26) 
      pcm_status_reg26[0] <= 1'b0;
    else
      pcm_status_reg26[0] <= pcm_status_reg26[0];
  end  

  assign pcm_macb_wakeup_int26 = |pcm_status_reg26;

  reg [31:0] L1_ctrl_reg126;
  always @(posedge pclk26 or negedge nprst26)
  begin
    if(!nprst26)
      L1_ctrl_reg126 <= 0;
    else
      L1_ctrl_reg126 <= L1_ctrl_reg26;
  end

  // Program26 mode decode
  always @(L1_ctrl_reg26 or L1_ctrl_reg126 or int_source_h26 or cpu_shutoff_ctrl26) begin
    mte_smc_start26 = 0;
    mte_uart_start26 = 0;
    mte_smc_uart_start26  = 0;
    mte_mac_off_start26  = 0;
    mte_mac012_start26 = 0;
    mte_mac013_start26 = 0;
    mte_mac023_start26 = 0;
    mte_mac123_start26 = 0;
    mte_mac01_start26 = 0;
    mte_mac02_start26 = 0;
    mte_mac03_start26 = 0;
    mte_mac12_start26 = 0;
    mte_mac13_start26 = 0;
    mte_mac23_start26 = 0;
    mte_mac0_start26 = 0;
    mte_mac1_start26 = 0;
    mte_mac2_start26 = 0;
    mte_mac3_start26 = 0;
    mte_sys_hibernate26 = 0 ;
    mte_dma_start26 = 0 ;
    mte_cpu_start26 = 0 ;

    mte_mac0_sleep_start26 = (L1_ctrl_reg26 ==  'h14) && (L1_ctrl_reg126 == 'h4 );
    mte_mac1_sleep_start26 = (L1_ctrl_reg26 ==  'h14) && (L1_ctrl_reg126 == 'h5 ); 
    mte_mac2_sleep_start26 = (L1_ctrl_reg26 ==  'h14) && (L1_ctrl_reg126 == 'h6 ); 
    mte_mac3_sleep_start26 = (L1_ctrl_reg26 ==  'h14) && (L1_ctrl_reg126 == 'h7 ); 
    mte_mac01_sleep_start26 = (L1_ctrl_reg26 ==  'h14) && (L1_ctrl_reg126 == 'h8 ); 
    mte_mac02_sleep_start26 = (L1_ctrl_reg26 ==  'h14) && (L1_ctrl_reg126 == 'h9 ); 
    mte_mac03_sleep_start26 = (L1_ctrl_reg26 ==  'h14) && (L1_ctrl_reg126 == 'hA ); 
    mte_mac12_sleep_start26 = (L1_ctrl_reg26 ==  'h14) && (L1_ctrl_reg126 == 'hB ); 
    mte_mac13_sleep_start26 = (L1_ctrl_reg26 ==  'h14) && (L1_ctrl_reg126 == 'hC ); 
    mte_mac23_sleep_start26 = (L1_ctrl_reg26 ==  'h14) && (L1_ctrl_reg126 == 'hD ); 
    mte_mac012_sleep_start26 = (L1_ctrl_reg26 ==  'h14) && (L1_ctrl_reg126 == 'hE ); 
    mte_mac013_sleep_start26 = (L1_ctrl_reg26 ==  'h14) && (L1_ctrl_reg126 == 'hF ); 
    mte_mac023_sleep_start26 = (L1_ctrl_reg26 ==  'h14) && (L1_ctrl_reg126 == 'h10 ); 
    mte_mac123_sleep_start26 = (L1_ctrl_reg26 ==  'h14) && (L1_ctrl_reg126 == 'h11 ); 
    mte_mac_off_sleep_start26 =  (L1_ctrl_reg26 == 'h14) && (L1_ctrl_reg126 == 'h12 );
    mte_dma_sleep_start26 =  (L1_ctrl_reg26 == 'h14) && (L1_ctrl_reg126 == 'h13 );

    mte_pm_uart_to_default_start26 = (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'h1);
    mte_pm_smc_to_default_start26 = (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'h2);
    mte_pm_smc_uart_to_default_start26 = (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'h3); 
    mte_mac0_to_default26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'h4); 
    mte_mac1_to_default26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'h5); 
    mte_mac2_to_default26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'h6); 
    mte_mac3_to_default26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'h7); 
    mte_mac01_to_default26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'h8); 
    mte_mac02_to_default26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'h9); 
    mte_mac03_to_default26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'hA); 
    mte_mac12_to_default26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'hB); 
    mte_mac13_to_default26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'hC); 
    mte_mac23_to_default26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'hD); 
    mte_mac012_to_default26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'hE); 
    mte_mac013_to_default26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'hF); 
    mte_mac023_to_default26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'h10); 
    mte_mac123_to_default26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'h11); 
    mte_mac_off_to_default26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'h12); 
    mte_dma_isolate_dis26 =  (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'h13); 
    mte_cpu_isolate_dis26 =  (int_source_h26) && (cpu_shutoff_ctrl26) && (L1_ctrl_reg26 != 'h15);
    mte_sys_hibernate_to_default26 = (L1_ctrl_reg26 == 32'h0) && (L1_ctrl_reg126 == 'h15); 

   
    if (L1_ctrl_reg126 == 'h0) begin // This26 check is to make mte_cpu_start26
                                   // is set only when you from default state 
      case (L1_ctrl_reg26)
        'h0 : L1_ctrl_domain26 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain26 = 32'h2; // PM_uart26
                mte_uart_start26 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain26 = 32'h4; // PM_smc26
                mte_smc_start26 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain26 = 32'h6; // PM_smc_uart26
                mte_smc_uart_start26 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain26 = 32'h8; //  PM_macb026
                mte_mac0_start26 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain26 = 32'h10; //  PM_macb126
                mte_mac1_start26 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain26 = 32'h20; //  PM_macb226
                mte_mac2_start26 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain26 = 32'h40; //  PM_macb326
                mte_mac3_start26 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain26 = 32'h18; //  PM_macb0126
                mte_mac01_start26 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain26 = 32'h28; //  PM_macb0226
                mte_mac02_start26 = 1;
              end
        'hA : begin  
                L1_ctrl_domain26 = 32'h48; //  PM_macb0326
                mte_mac03_start26 = 1;
              end
        'hB : begin  
                L1_ctrl_domain26 = 32'h30; //  PM_macb1226
                mte_mac12_start26 = 1;
              end
        'hC : begin  
                L1_ctrl_domain26 = 32'h50; //  PM_macb1326
                mte_mac13_start26 = 1;
              end
        'hD : begin  
                L1_ctrl_domain26 = 32'h60; //  PM_macb2326
                mte_mac23_start26 = 1;
              end
        'hE : begin  
                L1_ctrl_domain26 = 32'h38; //  PM_macb01226
                mte_mac012_start26 = 1;
              end
        'hF : begin  
                L1_ctrl_domain26 = 32'h58; //  PM_macb01326
                mte_mac013_start26 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain26 = 32'h68; //  PM_macb02326
                mte_mac023_start26 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain26 = 32'h70; //  PM_macb12326
                mte_mac123_start26 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain26 = 32'h78; //  PM_macb_off26
                mte_mac_off_start26 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain26 = 32'h80; //  PM_dma26
                mte_dma_start26 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain26 = 32'h100; //  PM_cpu_sleep26
                mte_cpu_start26 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain26 = 32'h1FE; //  PM_hibernate26
                mte_sys_hibernate26 = 1;
              end
         default: L1_ctrl_domain26 = 32'h0;
      endcase
    end
  end


  wire to_default26 = (L1_ctrl_reg26 == 0);

  // Scan26 mode gating26 of power26 and isolation26 control26 signals26
  //SMC26
  assign rstn_non_srpg_smc26  = (scan_mode26 == 1'b0) ? rstn_non_srpg_smc_int26 : 1'b1;  
  assign gate_clk_smc26       = (scan_mode26 == 1'b0) ? gate_clk_smc_int26 : 1'b0;     
  assign isolate_smc26        = (scan_mode26 == 1'b0) ? isolate_smc_int26 : 1'b0;      
  assign pwr1_on_smc26        = (scan_mode26 == 1'b0) ? pwr1_on_smc_int26 : 1'b1;       
  assign pwr2_on_smc26        = (scan_mode26 == 1'b0) ? pwr2_on_smc_int26 : 1'b1;       
  assign pwr1_off_smc26       = (scan_mode26 == 1'b0) ? (!pwr1_on_smc_int26) : 1'b0;       
  assign pwr2_off_smc26       = (scan_mode26 == 1'b0) ? (!pwr2_on_smc_int26) : 1'b0;       
  assign save_edge_smc26       = (scan_mode26 == 1'b0) ? (save_edge_smc_int26) : 1'b0;       
  assign restore_edge_smc26       = (scan_mode26 == 1'b0) ? (restore_edge_smc_int26) : 1'b0;       

  //URT26
  assign rstn_non_srpg_urt26  = (scan_mode26 == 1'b0) ?  rstn_non_srpg_urt_int26 : 1'b1;  
  assign gate_clk_urt26       = (scan_mode26 == 1'b0) ?  gate_clk_urt_int26      : 1'b0;     
  assign isolate_urt26        = (scan_mode26 == 1'b0) ?  isolate_urt_int26       : 1'b0;      
  assign pwr1_on_urt26        = (scan_mode26 == 1'b0) ?  pwr1_on_urt_int26       : 1'b1;       
  assign pwr2_on_urt26        = (scan_mode26 == 1'b0) ?  pwr2_on_urt_int26       : 1'b1;       
  assign pwr1_off_urt26       = (scan_mode26 == 1'b0) ?  (!pwr1_on_urt_int26)  : 1'b0;       
  assign pwr2_off_urt26       = (scan_mode26 == 1'b0) ?  (!pwr2_on_urt_int26)  : 1'b0;       
  assign save_edge_urt26       = (scan_mode26 == 1'b0) ? (save_edge_urt_int26) : 1'b0;       
  assign restore_edge_urt26       = (scan_mode26 == 1'b0) ? (restore_edge_urt_int26) : 1'b0;       

  //ETH026
  assign rstn_non_srpg_macb026 = (scan_mode26 == 1'b0) ?  rstn_non_srpg_macb0_int26 : 1'b1;  
  assign gate_clk_macb026       = (scan_mode26 == 1'b0) ?  gate_clk_macb0_int26      : 1'b0;     
  assign isolate_macb026        = (scan_mode26 == 1'b0) ?  isolate_macb0_int26       : 1'b0;      
  assign pwr1_on_macb026        = (scan_mode26 == 1'b0) ?  pwr1_on_macb0_int26       : 1'b1;       
  assign pwr2_on_macb026        = (scan_mode26 == 1'b0) ?  pwr2_on_macb0_int26       : 1'b1;       
  assign pwr1_off_macb026       = (scan_mode26 == 1'b0) ?  (!pwr1_on_macb0_int26)  : 1'b0;       
  assign pwr2_off_macb026       = (scan_mode26 == 1'b0) ?  (!pwr2_on_macb0_int26)  : 1'b0;       
  assign save_edge_macb026       = (scan_mode26 == 1'b0) ? (save_edge_macb0_int26) : 1'b0;       
  assign restore_edge_macb026       = (scan_mode26 == 1'b0) ? (restore_edge_macb0_int26) : 1'b0;       

  //ETH126
  assign rstn_non_srpg_macb126 = (scan_mode26 == 1'b0) ?  rstn_non_srpg_macb1_int26 : 1'b1;  
  assign gate_clk_macb126       = (scan_mode26 == 1'b0) ?  gate_clk_macb1_int26      : 1'b0;     
  assign isolate_macb126        = (scan_mode26 == 1'b0) ?  isolate_macb1_int26       : 1'b0;      
  assign pwr1_on_macb126        = (scan_mode26 == 1'b0) ?  pwr1_on_macb1_int26       : 1'b1;       
  assign pwr2_on_macb126        = (scan_mode26 == 1'b0) ?  pwr2_on_macb1_int26       : 1'b1;       
  assign pwr1_off_macb126       = (scan_mode26 == 1'b0) ?  (!pwr1_on_macb1_int26)  : 1'b0;       
  assign pwr2_off_macb126       = (scan_mode26 == 1'b0) ?  (!pwr2_on_macb1_int26)  : 1'b0;       
  assign save_edge_macb126       = (scan_mode26 == 1'b0) ? (save_edge_macb1_int26) : 1'b0;       
  assign restore_edge_macb126       = (scan_mode26 == 1'b0) ? (restore_edge_macb1_int26) : 1'b0;       

  //ETH226
  assign rstn_non_srpg_macb226 = (scan_mode26 == 1'b0) ?  rstn_non_srpg_macb2_int26 : 1'b1;  
  assign gate_clk_macb226       = (scan_mode26 == 1'b0) ?  gate_clk_macb2_int26      : 1'b0;     
  assign isolate_macb226        = (scan_mode26 == 1'b0) ?  isolate_macb2_int26       : 1'b0;      
  assign pwr1_on_macb226        = (scan_mode26 == 1'b0) ?  pwr1_on_macb2_int26       : 1'b1;       
  assign pwr2_on_macb226        = (scan_mode26 == 1'b0) ?  pwr2_on_macb2_int26       : 1'b1;       
  assign pwr1_off_macb226       = (scan_mode26 == 1'b0) ?  (!pwr1_on_macb2_int26)  : 1'b0;       
  assign pwr2_off_macb226       = (scan_mode26 == 1'b0) ?  (!pwr2_on_macb2_int26)  : 1'b0;       
  assign save_edge_macb226       = (scan_mode26 == 1'b0) ? (save_edge_macb2_int26) : 1'b0;       
  assign restore_edge_macb226       = (scan_mode26 == 1'b0) ? (restore_edge_macb2_int26) : 1'b0;       

  //ETH326
  assign rstn_non_srpg_macb326 = (scan_mode26 == 1'b0) ?  rstn_non_srpg_macb3_int26 : 1'b1;  
  assign gate_clk_macb326       = (scan_mode26 == 1'b0) ?  gate_clk_macb3_int26      : 1'b0;     
  assign isolate_macb326        = (scan_mode26 == 1'b0) ?  isolate_macb3_int26       : 1'b0;      
  assign pwr1_on_macb326        = (scan_mode26 == 1'b0) ?  pwr1_on_macb3_int26       : 1'b1;       
  assign pwr2_on_macb326        = (scan_mode26 == 1'b0) ?  pwr2_on_macb3_int26       : 1'b1;       
  assign pwr1_off_macb326       = (scan_mode26 == 1'b0) ?  (!pwr1_on_macb3_int26)  : 1'b0;       
  assign pwr2_off_macb326       = (scan_mode26 == 1'b0) ?  (!pwr2_on_macb3_int26)  : 1'b0;       
  assign save_edge_macb326       = (scan_mode26 == 1'b0) ? (save_edge_macb3_int26) : 1'b0;       
  assign restore_edge_macb326       = (scan_mode26 == 1'b0) ? (restore_edge_macb3_int26) : 1'b0;       

  // MEM26
  assign rstn_non_srpg_mem26 =   (rstn_non_srpg_macb026 && rstn_non_srpg_macb126 && rstn_non_srpg_macb226 &&
                                rstn_non_srpg_macb326 && rstn_non_srpg_dma26 && rstn_non_srpg_cpu26 && rstn_non_srpg_urt26 &&
                                rstn_non_srpg_smc26);

  assign gate_clk_mem26 =  (gate_clk_macb026 && gate_clk_macb126 && gate_clk_macb226 &&
                            gate_clk_macb326 && gate_clk_dma26 && gate_clk_cpu26 && gate_clk_urt26 && gate_clk_smc26);

  assign isolate_mem26  = (isolate_macb026 && isolate_macb126 && isolate_macb226 &&
                         isolate_macb326 && isolate_dma26 && isolate_cpu26 && isolate_urt26 && isolate_smc26);


  assign pwr1_on_mem26        =   ~pwr1_off_mem26;

  assign pwr2_on_mem26        =   ~pwr2_off_mem26;

  assign pwr1_off_mem26       =  (pwr1_off_macb026 && pwr1_off_macb126 && pwr1_off_macb226 &&
                                 pwr1_off_macb326 && pwr1_off_dma26 && pwr1_off_cpu26 && pwr1_off_urt26 && pwr1_off_smc26);


  assign pwr2_off_mem26       =  (pwr2_off_macb026 && pwr2_off_macb126 && pwr2_off_macb226 &&
                                pwr2_off_macb326 && pwr2_off_dma26 && pwr2_off_cpu26 && pwr2_off_urt26 && pwr2_off_smc26);

  assign save_edge_mem26      =  (save_edge_macb026 && save_edge_macb126 && save_edge_macb226 &&
                                save_edge_macb326 && save_edge_dma26 && save_edge_cpu26 && save_edge_smc26 && save_edge_urt26);

  assign restore_edge_mem26   =  (restore_edge_macb026 && restore_edge_macb126 && restore_edge_macb226  &&
                                restore_edge_macb326 && restore_edge_dma26 && restore_edge_cpu26 && restore_edge_urt26 &&
                                restore_edge_smc26);

  assign standby_mem026 = pwr1_off_macb026 && (~ (pwr1_off_macb026 && pwr1_off_macb126 && pwr1_off_macb226 && pwr1_off_macb326 && pwr1_off_urt26 && pwr1_off_smc26 && pwr1_off_dma26 && pwr1_off_cpu26));
  assign standby_mem126 = pwr1_off_macb126 && (~ (pwr1_off_macb026 && pwr1_off_macb126 && pwr1_off_macb226 && pwr1_off_macb326 && pwr1_off_urt26 && pwr1_off_smc26 && pwr1_off_dma26 && pwr1_off_cpu26));
  assign standby_mem226 = pwr1_off_macb226 && (~ (pwr1_off_macb026 && pwr1_off_macb126 && pwr1_off_macb226 && pwr1_off_macb326 && pwr1_off_urt26 && pwr1_off_smc26 && pwr1_off_dma26 && pwr1_off_cpu26));
  assign standby_mem326 = pwr1_off_macb326 && (~ (pwr1_off_macb026 && pwr1_off_macb126 && pwr1_off_macb226 && pwr1_off_macb326 && pwr1_off_urt26 && pwr1_off_smc26 && pwr1_off_dma26 && pwr1_off_cpu26));

  assign pwr1_off_mem026 = pwr1_off_mem26;
  assign pwr1_off_mem126 = pwr1_off_mem26;
  assign pwr1_off_mem226 = pwr1_off_mem26;
  assign pwr1_off_mem326 = pwr1_off_mem26;

  assign rstn_non_srpg_alut26  =  (rstn_non_srpg_macb026 && rstn_non_srpg_macb126 && rstn_non_srpg_macb226 && rstn_non_srpg_macb326);


   assign gate_clk_alut26       =  (gate_clk_macb026 && gate_clk_macb126 && gate_clk_macb226 && gate_clk_macb326);


    assign isolate_alut26        =  (isolate_macb026 && isolate_macb126 && isolate_macb226 && isolate_macb326);


    assign pwr1_on_alut26        =  (pwr1_on_macb026 || pwr1_on_macb126 || pwr1_on_macb226 || pwr1_on_macb326);


    assign pwr2_on_alut26        =  (pwr2_on_macb026 || pwr2_on_macb126 || pwr2_on_macb226 || pwr2_on_macb326);


    assign pwr1_off_alut26       =  (pwr1_off_macb026 && pwr1_off_macb126 && pwr1_off_macb226 && pwr1_off_macb326);


    assign pwr2_off_alut26       =  (pwr2_off_macb026 && pwr2_off_macb126 && pwr2_off_macb226 && pwr2_off_macb326);


    assign save_edge_alut26      =  (save_edge_macb026 && save_edge_macb126 && save_edge_macb226 && save_edge_macb326);


    assign restore_edge_alut26   =  (restore_edge_macb026 || restore_edge_macb126 || restore_edge_macb226 ||
                                   restore_edge_macb326) && save_alut_tmp26;

     // alut26 power26 off26 detection26
  always @(posedge pclk26 or negedge nprst26) begin
    if (!nprst26) 
       save_alut_tmp26 <= 0;
    else if (restore_edge_alut26)
       save_alut_tmp26 <= 0;
    else if (save_edge_alut26)
       save_alut_tmp26 <= 1;
  end

  //DMA26
  assign rstn_non_srpg_dma26 = (scan_mode26 == 1'b0) ?  rstn_non_srpg_dma_int26 : 1'b1;  
  assign gate_clk_dma26       = (scan_mode26 == 1'b0) ?  gate_clk_dma_int26      : 1'b0;     
  assign isolate_dma26        = (scan_mode26 == 1'b0) ?  isolate_dma_int26       : 1'b0;      
  assign pwr1_on_dma26        = (scan_mode26 == 1'b0) ?  pwr1_on_dma_int26       : 1'b1;       
  assign pwr2_on_dma26        = (scan_mode26 == 1'b0) ?  pwr2_on_dma_int26       : 1'b1;       
  assign pwr1_off_dma26       = (scan_mode26 == 1'b0) ?  (!pwr1_on_dma_int26)  : 1'b0;       
  assign pwr2_off_dma26       = (scan_mode26 == 1'b0) ?  (!pwr2_on_dma_int26)  : 1'b0;       
  assign save_edge_dma26       = (scan_mode26 == 1'b0) ? (save_edge_dma_int26) : 1'b0;       
  assign restore_edge_dma26       = (scan_mode26 == 1'b0) ? (restore_edge_dma_int26) : 1'b0;       

  //CPU26
  assign rstn_non_srpg_cpu26 = (scan_mode26 == 1'b0) ?  rstn_non_srpg_cpu_int26 : 1'b1;  
  assign gate_clk_cpu26       = (scan_mode26 == 1'b0) ?  gate_clk_cpu_int26      : 1'b0;     
  assign isolate_cpu26        = (scan_mode26 == 1'b0) ?  isolate_cpu_int26       : 1'b0;      
  assign pwr1_on_cpu26        = (scan_mode26 == 1'b0) ?  pwr1_on_cpu_int26       : 1'b1;       
  assign pwr2_on_cpu26        = (scan_mode26 == 1'b0) ?  pwr2_on_cpu_int26       : 1'b1;       
  assign pwr1_off_cpu26       = (scan_mode26 == 1'b0) ?  (!pwr1_on_cpu_int26)  : 1'b0;       
  assign pwr2_off_cpu26       = (scan_mode26 == 1'b0) ?  (!pwr2_on_cpu_int26)  : 1'b0;       
  assign save_edge_cpu26       = (scan_mode26 == 1'b0) ? (save_edge_cpu_int26) : 1'b0;       
  assign restore_edge_cpu26       = (scan_mode26 == 1'b0) ? (restore_edge_cpu_int26) : 1'b0;       



  // ASE26

   reg ase_core_12v26, ase_core_10v26, ase_core_08v26, ase_core_06v26;
   reg ase_macb0_12v26,ase_macb1_12v26,ase_macb2_12v26,ase_macb3_12v26;

    // core26 ase26

    // core26 at 1.0 v if (smc26 off26, urt26 off26, macb026 off26, macb126 off26, macb226 off26, macb326 off26
   // core26 at 0.8v if (mac01off26, macb02off26, macb03off26, macb12off26, mac13off26, mac23off26,
   // core26 at 0.6v if (mac012off26, mac013off26, mac023off26, mac123off26, mac0123off26
    // else core26 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb026 && pwr1_off_macb126 && pwr1_off_macb226 && pwr1_off_macb326) || // all mac26 off26
       (pwr1_off_macb326 && pwr1_off_macb226 && pwr1_off_macb126) || // mac123off26 
       (pwr1_off_macb326 && pwr1_off_macb226 && pwr1_off_macb026) || // mac023off26 
       (pwr1_off_macb326 && pwr1_off_macb126 && pwr1_off_macb026) || // mac013off26 
       (pwr1_off_macb226 && pwr1_off_macb126 && pwr1_off_macb026) )  // mac012off26 
       begin
         ase_core_12v26 = 0;
         ase_core_10v26 = 0;
         ase_core_08v26 = 0;
         ase_core_06v26 = 1;
       end
     else if( (pwr1_off_macb226 && pwr1_off_macb326) || // mac2326 off26
         (pwr1_off_macb326 && pwr1_off_macb126) || // mac13off26 
         (pwr1_off_macb126 && pwr1_off_macb226) || // mac12off26 
         (pwr1_off_macb326 && pwr1_off_macb026) || // mac03off26 
         (pwr1_off_macb226 && pwr1_off_macb026) || // mac02off26 
         (pwr1_off_macb126 && pwr1_off_macb026))  // mac01off26 
       begin
         ase_core_12v26 = 0;
         ase_core_10v26 = 0;
         ase_core_08v26 = 1;
         ase_core_06v26 = 0;
       end
     else if( (pwr1_off_smc26) || // smc26 off26
         (pwr1_off_macb026 ) || // mac0off26 
         (pwr1_off_macb126 ) || // mac1off26 
         (pwr1_off_macb226 ) || // mac2off26 
         (pwr1_off_macb326 ))  // mac3off26 
       begin
         ase_core_12v26 = 0;
         ase_core_10v26 = 1;
         ase_core_08v26 = 0;
         ase_core_06v26 = 0;
       end
     else if (pwr1_off_urt26)
       begin
         ase_core_12v26 = 1;
         ase_core_10v26 = 0;
         ase_core_08v26 = 0;
         ase_core_06v26 = 0;
       end
     else
       begin
         ase_core_12v26 = 1;
         ase_core_10v26 = 0;
         ase_core_08v26 = 0;
         ase_core_06v26 = 0;
       end
   end


   // cpu26
   // cpu26 @ 1.0v when macoff26, 
   // 
   reg ase_cpu_10v26, ase_cpu_12v26;
   always @(*) begin
    if(pwr1_off_cpu26) begin
     ase_cpu_12v26 = 1'b0;
     ase_cpu_10v26 = 1'b0;
    end
    else if(pwr1_off_macb026 || pwr1_off_macb126 || pwr1_off_macb226 || pwr1_off_macb326)
    begin
     ase_cpu_12v26 = 1'b0;
     ase_cpu_10v26 = 1'b1;
    end
    else
    begin
     ase_cpu_12v26 = 1'b1;
     ase_cpu_10v26 = 1'b0;
    end
   end

   // dma26
   // dma26 @v126.0 for macoff26, 

   reg ase_dma_10v26, ase_dma_12v26;
   always @(*) begin
    if(pwr1_off_dma26) begin
     ase_dma_12v26 = 1'b0;
     ase_dma_10v26 = 1'b0;
    end
    else if(pwr1_off_macb026 || pwr1_off_macb126 || pwr1_off_macb226 || pwr1_off_macb326)
    begin
     ase_dma_12v26 = 1'b0;
     ase_dma_10v26 = 1'b1;
    end
    else
    begin
     ase_dma_12v26 = 1'b1;
     ase_dma_10v26 = 1'b0;
    end
   end

   // alut26
   // @ v126.0 for macoff26

   reg ase_alut_10v26, ase_alut_12v26;
   always @(*) begin
    if(pwr1_off_alut26) begin
     ase_alut_12v26 = 1'b0;
     ase_alut_10v26 = 1'b0;
    end
    else if(pwr1_off_macb026 || pwr1_off_macb126 || pwr1_off_macb226 || pwr1_off_macb326)
    begin
     ase_alut_12v26 = 1'b0;
     ase_alut_10v26 = 1'b1;
    end
    else
    begin
     ase_alut_12v26 = 1'b1;
     ase_alut_10v26 = 1'b0;
    end
   end




   reg ase_uart_12v26;
   reg ase_uart_10v26;
   reg ase_uart_08v26;
   reg ase_uart_06v26;

   reg ase_smc_12v26;


   always @(*) begin
     if(pwr1_off_urt26) begin // uart26 off26
       ase_uart_08v26 = 1'b0;
       ase_uart_06v26 = 1'b0;
       ase_uart_10v26 = 1'b0;
       ase_uart_12v26 = 1'b0;
     end 
     else if( (pwr1_off_macb026 && pwr1_off_macb126 && pwr1_off_macb226 && pwr1_off_macb326) || // all mac26 off26
       (pwr1_off_macb326 && pwr1_off_macb226 && pwr1_off_macb126) || // mac123off26 
       (pwr1_off_macb326 && pwr1_off_macb226 && pwr1_off_macb026) || // mac023off26 
       (pwr1_off_macb326 && pwr1_off_macb126 && pwr1_off_macb026) || // mac013off26 
       (pwr1_off_macb226 && pwr1_off_macb126 && pwr1_off_macb026) )  // mac012off26 
     begin
       ase_uart_06v26 = 1'b1;
       ase_uart_08v26 = 1'b0;
       ase_uart_10v26 = 1'b0;
       ase_uart_12v26 = 1'b0;
     end
     else if( (pwr1_off_macb226 && pwr1_off_macb326) || // mac2326 off26
         (pwr1_off_macb326 && pwr1_off_macb126) || // mac13off26 
         (pwr1_off_macb126 && pwr1_off_macb226) || // mac12off26 
         (pwr1_off_macb326 && pwr1_off_macb026) || // mac03off26 
         (pwr1_off_macb126 && pwr1_off_macb026))  // mac01off26  
     begin
       ase_uart_06v26 = 1'b0;
       ase_uart_08v26 = 1'b1;
       ase_uart_10v26 = 1'b0;
       ase_uart_12v26 = 1'b0;
     end
     else if (pwr1_off_smc26 || pwr1_off_macb026 || pwr1_off_macb126 || pwr1_off_macb226 || pwr1_off_macb326) begin // smc26 off26
       ase_uart_08v26 = 1'b0;
       ase_uart_06v26 = 1'b0;
       ase_uart_10v26 = 1'b1;
       ase_uart_12v26 = 1'b0;
     end 
     else begin
       ase_uart_08v26 = 1'b0;
       ase_uart_06v26 = 1'b0;
       ase_uart_10v26 = 1'b0;
       ase_uart_12v26 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc26) begin
     if (pwr1_off_smc26)  // smc26 off26
       ase_smc_12v26 = 1'b0;
    else
       ase_smc_12v26 = 1'b1;
   end

   
   always @(pwr1_off_macb026) begin
     if (pwr1_off_macb026) // macb026 off26
       ase_macb0_12v26 = 1'b0;
     else
       ase_macb0_12v26 = 1'b1;
   end

   always @(pwr1_off_macb126) begin
     if (pwr1_off_macb126) // macb126 off26
       ase_macb1_12v26 = 1'b0;
     else
       ase_macb1_12v26 = 1'b1;
   end

   always @(pwr1_off_macb226) begin // macb226 off26
     if (pwr1_off_macb226) // macb226 off26
       ase_macb2_12v26 = 1'b0;
     else
       ase_macb2_12v26 = 1'b1;
   end

   always @(pwr1_off_macb326) begin // macb326 off26
     if (pwr1_off_macb326) // macb326 off26
       ase_macb3_12v26 = 1'b0;
     else
       ase_macb3_12v26 = 1'b1;
   end


   // core26 voltage26 for vco26
  assign core12v26 = ase_macb0_12v26 & ase_macb1_12v26 & ase_macb2_12v26 & ase_macb3_12v26;

  assign core10v26 =  (ase_macb0_12v26 & ase_macb1_12v26 & ase_macb2_12v26 & (!ase_macb3_12v26)) ||
                    (ase_macb0_12v26 & ase_macb1_12v26 & (!ase_macb2_12v26) & ase_macb3_12v26) ||
                    (ase_macb0_12v26 & (!ase_macb1_12v26) & ase_macb2_12v26 & ase_macb3_12v26) ||
                    ((!ase_macb0_12v26) & ase_macb1_12v26 & ase_macb2_12v26 & ase_macb3_12v26);

  assign core08v26 =  ((!ase_macb0_12v26) & (!ase_macb1_12v26) & (ase_macb2_12v26) & (ase_macb3_12v26)) ||
                    ((!ase_macb0_12v26) & (ase_macb1_12v26) & (!ase_macb2_12v26) & (ase_macb3_12v26)) ||
                    ((!ase_macb0_12v26) & (ase_macb1_12v26) & (ase_macb2_12v26) & (!ase_macb3_12v26)) ||
                    ((ase_macb0_12v26) & (!ase_macb1_12v26) & (!ase_macb2_12v26) & (ase_macb3_12v26)) ||
                    ((ase_macb0_12v26) & (!ase_macb1_12v26) & (ase_macb2_12v26) & (!ase_macb3_12v26)) ||
                    ((ase_macb0_12v26) & (ase_macb1_12v26) & (!ase_macb2_12v26) & (!ase_macb3_12v26));

  assign core06v26 =  ((!ase_macb0_12v26) & (!ase_macb1_12v26) & (!ase_macb2_12v26) & (ase_macb3_12v26)) ||
                    ((!ase_macb0_12v26) & (!ase_macb1_12v26) & (ase_macb2_12v26) & (!ase_macb3_12v26)) ||
                    ((!ase_macb0_12v26) & (ase_macb1_12v26) & (!ase_macb2_12v26) & (!ase_macb3_12v26)) ||
                    ((ase_macb0_12v26) & (!ase_macb1_12v26) & (!ase_macb2_12v26) & (!ase_macb3_12v26)) ||
                    ((!ase_macb0_12v26) & (!ase_macb1_12v26) & (!ase_macb2_12v26) & (!ase_macb3_12v26)) ;



`ifdef LP_ABV_ON26
// psl26 default clock26 = (posedge pclk26);

// Cover26 a condition in which SMC26 is powered26 down
// and again26 powered26 up while UART26 is going26 into POWER26 down
// state or UART26 is already in POWER26 DOWN26 state
// psl26 cover_overlapping_smc_urt_126:
//    cover{fell26(pwr1_on_urt26);[*];fell26(pwr1_on_smc26);[*];
//    rose26(pwr1_on_smc26);[*];rose26(pwr1_on_urt26)};
//
// Cover26 a condition in which UART26 is powered26 down
// and again26 powered26 up while SMC26 is going26 into POWER26 down
// state or SMC26 is already in POWER26 DOWN26 state
// psl26 cover_overlapping_smc_urt_226:
//    cover{fell26(pwr1_on_smc26);[*];fell26(pwr1_on_urt26);[*];
//    rose26(pwr1_on_urt26);[*];rose26(pwr1_on_smc26)};
//


// Power26 Down26 UART26
// This26 gets26 triggered on rising26 edge of Gate26 signal26 for
// UART26 (gate_clk_urt26). In a next cycle after gate_clk_urt26,
// Isolate26 UART26(isolate_urt26) signal26 become26 HIGH26 (active).
// In 2nd cycle after gate_clk_urt26 becomes HIGH26, RESET26 for NON26
// SRPG26 FFs26(rstn_non_srpg_urt26) and POWER126 for UART26(pwr1_on_urt26) should 
// go26 LOW26. 
// This26 completes26 a POWER26 DOWN26. 

sequence s_power_down_urt26;
      (gate_clk_urt26 & !isolate_urt26 & rstn_non_srpg_urt26 & pwr1_on_urt26) 
  ##1 (gate_clk_urt26 & isolate_urt26 & rstn_non_srpg_urt26 & pwr1_on_urt26) 
  ##3 (gate_clk_urt26 & isolate_urt26 & !rstn_non_srpg_urt26 & !pwr1_on_urt26);
endsequence


property p_power_down_urt26;
   @(posedge pclk26)
    $rose(gate_clk_urt26) |=> s_power_down_urt26;
endproperty

output_power_down_urt26:
  assert property (p_power_down_urt26);


// Power26 UP26 UART26
// Sequence starts with , Rising26 edge of pwr1_on_urt26.
// Two26 clock26 cycle after this, isolate_urt26 should become26 LOW26 
// On26 the following26 clk26 gate_clk_urt26 should go26 low26.
// 5 cycles26 after  Rising26 edge of pwr1_on_urt26, rstn_non_srpg_urt26
// should become26 HIGH26
sequence s_power_up_urt26;
##30 (pwr1_on_urt26 & !isolate_urt26 & gate_clk_urt26 & !rstn_non_srpg_urt26) 
##1 (pwr1_on_urt26 & !isolate_urt26 & !gate_clk_urt26 & !rstn_non_srpg_urt26) 
##2 (pwr1_on_urt26 & !isolate_urt26 & !gate_clk_urt26 & rstn_non_srpg_urt26);
endsequence

property p_power_up_urt26;
   @(posedge pclk26)
  disable iff(!nprst26)
    (!pwr1_on_urt26 ##1 pwr1_on_urt26) |=> s_power_up_urt26;
endproperty

output_power_up_urt26:
  assert property (p_power_up_urt26);


// Power26 Down26 SMC26
// This26 gets26 triggered on rising26 edge of Gate26 signal26 for
// SMC26 (gate_clk_smc26). In a next cycle after gate_clk_smc26,
// Isolate26 SMC26(isolate_smc26) signal26 become26 HIGH26 (active).
// In 2nd cycle after gate_clk_smc26 becomes HIGH26, RESET26 for NON26
// SRPG26 FFs26(rstn_non_srpg_smc26) and POWER126 for SMC26(pwr1_on_smc26) should 
// go26 LOW26. 
// This26 completes26 a POWER26 DOWN26. 

sequence s_power_down_smc26;
      (gate_clk_smc26 & !isolate_smc26 & rstn_non_srpg_smc26 & pwr1_on_smc26) 
  ##1 (gate_clk_smc26 & isolate_smc26 & rstn_non_srpg_smc26 & pwr1_on_smc26) 
  ##3 (gate_clk_smc26 & isolate_smc26 & !rstn_non_srpg_smc26 & !pwr1_on_smc26);
endsequence


property p_power_down_smc26;
   @(posedge pclk26)
    $rose(gate_clk_smc26) |=> s_power_down_smc26;
endproperty

output_power_down_smc26:
  assert property (p_power_down_smc26);


// Power26 UP26 SMC26
// Sequence starts with , Rising26 edge of pwr1_on_smc26.
// Two26 clock26 cycle after this, isolate_smc26 should become26 LOW26 
// On26 the following26 clk26 gate_clk_smc26 should go26 low26.
// 5 cycles26 after  Rising26 edge of pwr1_on_smc26, rstn_non_srpg_smc26
// should become26 HIGH26
sequence s_power_up_smc26;
##30 (pwr1_on_smc26 & !isolate_smc26 & gate_clk_smc26 & !rstn_non_srpg_smc26) 
##1 (pwr1_on_smc26 & !isolate_smc26 & !gate_clk_smc26 & !rstn_non_srpg_smc26) 
##2 (pwr1_on_smc26 & !isolate_smc26 & !gate_clk_smc26 & rstn_non_srpg_smc26);
endsequence

property p_power_up_smc26;
   @(posedge pclk26)
  disable iff(!nprst26)
    (!pwr1_on_smc26 ##1 pwr1_on_smc26) |=> s_power_up_smc26;
endproperty

output_power_up_smc26:
  assert property (p_power_up_smc26);


// COVER26 SMC26 POWER26 DOWN26 AND26 UP26
cover_power_down_up_smc26: cover property (@(posedge pclk26)
(s_power_down_smc26 ##[5:180] s_power_up_smc26));



// COVER26 UART26 POWER26 DOWN26 AND26 UP26
cover_power_down_up_urt26: cover property (@(posedge pclk26)
(s_power_down_urt26 ##[5:180] s_power_up_urt26));

cover_power_down_urt26: cover property (@(posedge pclk26)
(s_power_down_urt26));

cover_power_up_urt26: cover property (@(posedge pclk26)
(s_power_up_urt26));




`ifdef PCM_ABV_ON26
//------------------------------------------------------------------------------
// Power26 Controller26 Formal26 Verification26 component.  Each power26 domain has a 
// separate26 instantiation26
//------------------------------------------------------------------------------

// need to assume that CPU26 will leave26 a minimum time between powering26 down and 
// back up.  In this example26, 10clks has been selected.
// psl26 config_min_uart_pd_time26 : assume always {rose26(L1_ctrl_domain26[1])} |-> { L1_ctrl_domain26[1][*10] } abort26(~nprst26);
// psl26 config_min_uart_pu_time26 : assume always {fell26(L1_ctrl_domain26[1])} |-> { !L1_ctrl_domain26[1][*10] } abort26(~nprst26);
// psl26 config_min_smc_pd_time26 : assume always {rose26(L1_ctrl_domain26[2])} |-> { L1_ctrl_domain26[2][*10] } abort26(~nprst26);
// psl26 config_min_smc_pu_time26 : assume always {fell26(L1_ctrl_domain26[2])} |-> { !L1_ctrl_domain26[2][*10] } abort26(~nprst26);

// UART26 VCOMP26 parameters26
   defparam i_uart_vcomp_domain26.ENABLE_SAVE_RESTORE_EDGE26   = 1;
   defparam i_uart_vcomp_domain26.ENABLE_EXT_PWR_CNTRL26       = 1;
   defparam i_uart_vcomp_domain26.REF_CLK_DEFINED26            = 0;
   defparam i_uart_vcomp_domain26.MIN_SHUTOFF_CYCLES26         = 4;
   defparam i_uart_vcomp_domain26.MIN_RESTORE_TO_ISO_CYCLES26  = 0;
   defparam i_uart_vcomp_domain26.MIN_SAVE_TO_SHUTOFF_CYCLES26 = 1;


   vcomp_domain26 i_uart_vcomp_domain26
   ( .ref_clk26(pclk26),
     .start_lps26(L1_ctrl_domain26[1] || !rstn_non_srpg_urt26),
     .rst_n26(nprst26),
     .ext_power_down26(L1_ctrl_domain26[1]),
     .iso_en26(isolate_urt26),
     .save_edge26(save_edge_urt26),
     .restore_edge26(restore_edge_urt26),
     .domain_shut_off26(pwr1_off_urt26),
     .domain_clk26(!gate_clk_urt26 && pclk26)
   );


// SMC26 VCOMP26 parameters26
   defparam i_smc_vcomp_domain26.ENABLE_SAVE_RESTORE_EDGE26   = 1;
   defparam i_smc_vcomp_domain26.ENABLE_EXT_PWR_CNTRL26       = 1;
   defparam i_smc_vcomp_domain26.REF_CLK_DEFINED26            = 0;
   defparam i_smc_vcomp_domain26.MIN_SHUTOFF_CYCLES26         = 4;
   defparam i_smc_vcomp_domain26.MIN_RESTORE_TO_ISO_CYCLES26  = 0;
   defparam i_smc_vcomp_domain26.MIN_SAVE_TO_SHUTOFF_CYCLES26 = 1;


   vcomp_domain26 i_smc_vcomp_domain26
   ( .ref_clk26(pclk26),
     .start_lps26(L1_ctrl_domain26[2] || !rstn_non_srpg_smc26),
     .rst_n26(nprst26),
     .ext_power_down26(L1_ctrl_domain26[2]),
     .iso_en26(isolate_smc26),
     .save_edge26(save_edge_smc26),
     .restore_edge26(restore_edge_smc26),
     .domain_shut_off26(pwr1_off_smc26),
     .domain_clk26(!gate_clk_smc26 && pclk26)
   );

`endif

`endif



endmodule
