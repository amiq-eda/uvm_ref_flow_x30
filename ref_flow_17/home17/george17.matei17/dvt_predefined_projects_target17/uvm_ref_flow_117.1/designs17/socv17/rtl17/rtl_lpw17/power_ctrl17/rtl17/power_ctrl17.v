//File17 name   : power_ctrl17.v
//Title17       : Power17 Control17 Module17
//Created17     : 1999
//Description17 : Top17 level of power17 controller17
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

module power_ctrl17 (


    // Clocks17 & Reset17
    pclk17,
    nprst17,
    // APB17 programming17 interface
    paddr17,
    psel17,
    penable17,
    pwrite17,
    pwdata17,
    prdata17,
    // mac17 i/f,
    macb3_wakeup17,
    macb2_wakeup17,
    macb1_wakeup17,
    macb0_wakeup17,
    // Scan17 
    scan_in17,
    scan_en17,
    scan_mode17,
    scan_out17,
    // Module17 control17 outputs17
    int_source_h17,
    // SMC17
    rstn_non_srpg_smc17,
    gate_clk_smc17,
    isolate_smc17,
    save_edge_smc17,
    restore_edge_smc17,
    pwr1_on_smc17,
    pwr2_on_smc17,
    pwr1_off_smc17,
    pwr2_off_smc17,
    // URT17
    rstn_non_srpg_urt17,
    gate_clk_urt17,
    isolate_urt17,
    save_edge_urt17,
    restore_edge_urt17,
    pwr1_on_urt17,
    pwr2_on_urt17,
    pwr1_off_urt17,      
    pwr2_off_urt17,
    // ETH017
    rstn_non_srpg_macb017,
    gate_clk_macb017,
    isolate_macb017,
    save_edge_macb017,
    restore_edge_macb017,
    pwr1_on_macb017,
    pwr2_on_macb017,
    pwr1_off_macb017,      
    pwr2_off_macb017,
    // ETH117
    rstn_non_srpg_macb117,
    gate_clk_macb117,
    isolate_macb117,
    save_edge_macb117,
    restore_edge_macb117,
    pwr1_on_macb117,
    pwr2_on_macb117,
    pwr1_off_macb117,      
    pwr2_off_macb117,
    // ETH217
    rstn_non_srpg_macb217,
    gate_clk_macb217,
    isolate_macb217,
    save_edge_macb217,
    restore_edge_macb217,
    pwr1_on_macb217,
    pwr2_on_macb217,
    pwr1_off_macb217,      
    pwr2_off_macb217,
    // ETH317
    rstn_non_srpg_macb317,
    gate_clk_macb317,
    isolate_macb317,
    save_edge_macb317,
    restore_edge_macb317,
    pwr1_on_macb317,
    pwr2_on_macb317,
    pwr1_off_macb317,      
    pwr2_off_macb317,
    // DMA17
    rstn_non_srpg_dma17,
    gate_clk_dma17,
    isolate_dma17,
    save_edge_dma17,
    restore_edge_dma17,
    pwr1_on_dma17,
    pwr2_on_dma17,
    pwr1_off_dma17,      
    pwr2_off_dma17,
    // CPU17
    rstn_non_srpg_cpu17,
    gate_clk_cpu17,
    isolate_cpu17,
    save_edge_cpu17,
    restore_edge_cpu17,
    pwr1_on_cpu17,
    pwr2_on_cpu17,
    pwr1_off_cpu17,      
    pwr2_off_cpu17,
    // ALUT17
    rstn_non_srpg_alut17,
    gate_clk_alut17,
    isolate_alut17,
    save_edge_alut17,
    restore_edge_alut17,
    pwr1_on_alut17,
    pwr2_on_alut17,
    pwr1_off_alut17,      
    pwr2_off_alut17,
    // MEM17
    rstn_non_srpg_mem17,
    gate_clk_mem17,
    isolate_mem17,
    save_edge_mem17,
    restore_edge_mem17,
    pwr1_on_mem17,
    pwr2_on_mem17,
    pwr1_off_mem17,      
    pwr2_off_mem17,
    // core17 dvfs17 transitions17
    core06v17,
    core08v17,
    core10v17,
    core12v17,
    pcm_macb_wakeup_int17,
    // mte17 signals17
    mte_smc_start17,
    mte_uart_start17,
    mte_smc_uart_start17,  
    mte_pm_smc_to_default_start17, 
    mte_pm_uart_to_default_start17,
    mte_pm_smc_uart_to_default_start17

  );

  parameter STATE_IDLE_12V17 = 4'b0001;
  parameter STATE_06V17 = 4'b0010;
  parameter STATE_08V17 = 4'b0100;
  parameter STATE_10V17 = 4'b1000;

    // Clocks17 & Reset17
    input pclk17;
    input nprst17;
    // APB17 programming17 interface
    input [31:0] paddr17;
    input psel17  ;
    input penable17;
    input pwrite17 ;
    input [31:0] pwdata17;
    output [31:0] prdata17;
    // mac17
    input macb3_wakeup17;
    input macb2_wakeup17;
    input macb1_wakeup17;
    input macb0_wakeup17;
    // Scan17 
    input scan_in17;
    input scan_en17;
    input scan_mode17;
    output scan_out17;
    // Module17 control17 outputs17
    input int_source_h17;
    // SMC17
    output rstn_non_srpg_smc17 ;
    output gate_clk_smc17   ;
    output isolate_smc17   ;
    output save_edge_smc17   ;
    output restore_edge_smc17   ;
    output pwr1_on_smc17   ;
    output pwr2_on_smc17   ;
    output pwr1_off_smc17  ;
    output pwr2_off_smc17  ;
    // URT17
    output rstn_non_srpg_urt17 ;
    output gate_clk_urt17      ;
    output isolate_urt17       ;
    output save_edge_urt17   ;
    output restore_edge_urt17   ;
    output pwr1_on_urt17       ;
    output pwr2_on_urt17       ;
    output pwr1_off_urt17      ;
    output pwr2_off_urt17      ;
    // ETH017
    output rstn_non_srpg_macb017 ;
    output gate_clk_macb017      ;
    output isolate_macb017       ;
    output save_edge_macb017   ;
    output restore_edge_macb017   ;
    output pwr1_on_macb017       ;
    output pwr2_on_macb017       ;
    output pwr1_off_macb017      ;
    output pwr2_off_macb017      ;
    // ETH117
    output rstn_non_srpg_macb117 ;
    output gate_clk_macb117      ;
    output isolate_macb117       ;
    output save_edge_macb117   ;
    output restore_edge_macb117   ;
    output pwr1_on_macb117       ;
    output pwr2_on_macb117       ;
    output pwr1_off_macb117      ;
    output pwr2_off_macb117      ;
    // ETH217
    output rstn_non_srpg_macb217 ;
    output gate_clk_macb217      ;
    output isolate_macb217       ;
    output save_edge_macb217   ;
    output restore_edge_macb217   ;
    output pwr1_on_macb217       ;
    output pwr2_on_macb217       ;
    output pwr1_off_macb217      ;
    output pwr2_off_macb217      ;
    // ETH317
    output rstn_non_srpg_macb317 ;
    output gate_clk_macb317      ;
    output isolate_macb317       ;
    output save_edge_macb317   ;
    output restore_edge_macb317   ;
    output pwr1_on_macb317       ;
    output pwr2_on_macb317       ;
    output pwr1_off_macb317      ;
    output pwr2_off_macb317      ;
    // DMA17
    output rstn_non_srpg_dma17 ;
    output gate_clk_dma17      ;
    output isolate_dma17       ;
    output save_edge_dma17   ;
    output restore_edge_dma17   ;
    output pwr1_on_dma17       ;
    output pwr2_on_dma17       ;
    output pwr1_off_dma17      ;
    output pwr2_off_dma17      ;
    // CPU17
    output rstn_non_srpg_cpu17 ;
    output gate_clk_cpu17      ;
    output isolate_cpu17       ;
    output save_edge_cpu17   ;
    output restore_edge_cpu17   ;
    output pwr1_on_cpu17       ;
    output pwr2_on_cpu17       ;
    output pwr1_off_cpu17      ;
    output pwr2_off_cpu17      ;
    // ALUT17
    output rstn_non_srpg_alut17 ;
    output gate_clk_alut17      ;
    output isolate_alut17       ;
    output save_edge_alut17   ;
    output restore_edge_alut17   ;
    output pwr1_on_alut17       ;
    output pwr2_on_alut17       ;
    output pwr1_off_alut17      ;
    output pwr2_off_alut17      ;
    // MEM17
    output rstn_non_srpg_mem17 ;
    output gate_clk_mem17      ;
    output isolate_mem17       ;
    output save_edge_mem17   ;
    output restore_edge_mem17   ;
    output pwr1_on_mem17       ;
    output pwr2_on_mem17       ;
    output pwr1_off_mem17      ;
    output pwr2_off_mem17      ;


   // core17 transitions17 o/p
    output core06v17;
    output core08v17;
    output core10v17;
    output core12v17;
    output pcm_macb_wakeup_int17 ;
    //mode mte17  signals17
    output mte_smc_start17;
    output mte_uart_start17;
    output mte_smc_uart_start17;  
    output mte_pm_smc_to_default_start17; 
    output mte_pm_uart_to_default_start17;
    output mte_pm_smc_uart_to_default_start17;

    reg mte_smc_start17;
    reg mte_uart_start17;
    reg mte_smc_uart_start17;  
    reg mte_pm_smc_to_default_start17; 
    reg mte_pm_uart_to_default_start17;
    reg mte_pm_smc_uart_to_default_start17;

    reg [31:0] prdata17;

  wire valid_reg_write17  ;
  wire valid_reg_read17   ;
  wire L1_ctrl_access17   ;
  wire L1_status_access17 ;
  wire pcm_int_mask_access17;
  wire pcm_int_status_access17;
  wire standby_mem017      ;
  wire standby_mem117      ;
  wire standby_mem217      ;
  wire standby_mem317      ;
  wire pwr1_off_mem017;
  wire pwr1_off_mem117;
  wire pwr1_off_mem217;
  wire pwr1_off_mem317;
  
  // Control17 signals17
  wire set_status_smc17   ;
  wire clr_status_smc17   ;
  wire set_status_urt17   ;
  wire clr_status_urt17   ;
  wire set_status_macb017   ;
  wire clr_status_macb017   ;
  wire set_status_macb117   ;
  wire clr_status_macb117   ;
  wire set_status_macb217   ;
  wire clr_status_macb217   ;
  wire set_status_macb317   ;
  wire clr_status_macb317   ;
  wire set_status_dma17   ;
  wire clr_status_dma17   ;
  wire set_status_cpu17   ;
  wire clr_status_cpu17   ;
  wire set_status_alut17   ;
  wire clr_status_alut17   ;
  wire set_status_mem17   ;
  wire clr_status_mem17   ;


  // Status and Control17 registers
  reg [31:0]  L1_status_reg17;
  reg  [31:0] L1_ctrl_reg17  ;
  reg  [31:0] L1_ctrl_domain17  ;
  reg L1_ctrl_cpu_off_reg17;
  reg [31:0]  pcm_mask_reg17;
  reg [31:0]  pcm_status_reg17;

  // Signals17 gated17 in scan_mode17
  //SMC17
  wire  rstn_non_srpg_smc_int17;
  wire  gate_clk_smc_int17    ;     
  wire  isolate_smc_int17    ;       
  wire save_edge_smc_int17;
  wire restore_edge_smc_int17;
  wire  pwr1_on_smc_int17    ;      
  wire  pwr2_on_smc_int17    ;      


  //URT17
  wire   rstn_non_srpg_urt_int17;
  wire   gate_clk_urt_int17     ;     
  wire   isolate_urt_int17      ;       
  wire save_edge_urt_int17;
  wire restore_edge_urt_int17;
  wire   pwr1_on_urt_int17      ;      
  wire   pwr2_on_urt_int17      ;      

  // ETH017
  wire   rstn_non_srpg_macb0_int17;
  wire   gate_clk_macb0_int17     ;     
  wire   isolate_macb0_int17      ;       
  wire save_edge_macb0_int17;
  wire restore_edge_macb0_int17;
  wire   pwr1_on_macb0_int17      ;      
  wire   pwr2_on_macb0_int17      ;      
  // ETH117
  wire   rstn_non_srpg_macb1_int17;
  wire   gate_clk_macb1_int17     ;     
  wire   isolate_macb1_int17      ;       
  wire save_edge_macb1_int17;
  wire restore_edge_macb1_int17;
  wire   pwr1_on_macb1_int17      ;      
  wire   pwr2_on_macb1_int17      ;      
  // ETH217
  wire   rstn_non_srpg_macb2_int17;
  wire   gate_clk_macb2_int17     ;     
  wire   isolate_macb2_int17      ;       
  wire save_edge_macb2_int17;
  wire restore_edge_macb2_int17;
  wire   pwr1_on_macb2_int17      ;      
  wire   pwr2_on_macb2_int17      ;      
  // ETH317
  wire   rstn_non_srpg_macb3_int17;
  wire   gate_clk_macb3_int17     ;     
  wire   isolate_macb3_int17      ;       
  wire save_edge_macb3_int17;
  wire restore_edge_macb3_int17;
  wire   pwr1_on_macb3_int17      ;      
  wire   pwr2_on_macb3_int17      ;      

  // DMA17
  wire   rstn_non_srpg_dma_int17;
  wire   gate_clk_dma_int17     ;     
  wire   isolate_dma_int17      ;       
  wire save_edge_dma_int17;
  wire restore_edge_dma_int17;
  wire   pwr1_on_dma_int17      ;      
  wire   pwr2_on_dma_int17      ;      

  // CPU17
  wire   rstn_non_srpg_cpu_int17;
  wire   gate_clk_cpu_int17     ;     
  wire   isolate_cpu_int17      ;       
  wire save_edge_cpu_int17;
  wire restore_edge_cpu_int17;
  wire   pwr1_on_cpu_int17      ;      
  wire   pwr2_on_cpu_int17      ;  
  wire L1_ctrl_cpu_off_p17;    

  reg save_alut_tmp17;
  // DFS17 sm17

  reg cpu_shutoff_ctrl17;

  reg mte_mac_off_start17, mte_mac012_start17, mte_mac013_start17, mte_mac023_start17, mte_mac123_start17;
  reg mte_mac01_start17, mte_mac02_start17, mte_mac03_start17, mte_mac12_start17, mte_mac13_start17, mte_mac23_start17;
  reg mte_mac0_start17, mte_mac1_start17, mte_mac2_start17, mte_mac3_start17;
  reg mte_sys_hibernate17 ;
  reg mte_dma_start17 ;
  reg mte_cpu_start17 ;
  reg mte_mac_off_sleep_start17, mte_mac012_sleep_start17, mte_mac013_sleep_start17, mte_mac023_sleep_start17, mte_mac123_sleep_start17;
  reg mte_mac01_sleep_start17, mte_mac02_sleep_start17, mte_mac03_sleep_start17, mte_mac12_sleep_start17, mte_mac13_sleep_start17, mte_mac23_sleep_start17;
  reg mte_mac0_sleep_start17, mte_mac1_sleep_start17, mte_mac2_sleep_start17, mte_mac3_sleep_start17;
  reg mte_dma_sleep_start17;
  reg mte_mac_off_to_default17, mte_mac012_to_default17, mte_mac013_to_default17, mte_mac023_to_default17, mte_mac123_to_default17;
  reg mte_mac01_to_default17, mte_mac02_to_default17, mte_mac03_to_default17, mte_mac12_to_default17, mte_mac13_to_default17, mte_mac23_to_default17;
  reg mte_mac0_to_default17, mte_mac1_to_default17, mte_mac2_to_default17, mte_mac3_to_default17;
  reg mte_dma_isolate_dis17;
  reg mte_cpu_isolate_dis17;
  reg mte_sys_hibernate_to_default17;


  // Latch17 the CPU17 SLEEP17 invocation17
  always @( posedge pclk17 or negedge nprst17) 
  begin
    if(!nprst17)
      L1_ctrl_cpu_off_reg17 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg17 <= L1_ctrl_domain17[8];
  end

  // Create17 a pulse17 for sleep17 detection17 
  assign L1_ctrl_cpu_off_p17 =  L1_ctrl_domain17[8] && !L1_ctrl_cpu_off_reg17;
  
  // CPU17 sleep17 contol17 logic 
  // Shut17 off17 CPU17 when L1_ctrl_cpu_off_p17 is set
  // wake17 cpu17 when any interrupt17 is seen17  
  always @( posedge pclk17 or negedge nprst17) 
  begin
    if(!nprst17)
     cpu_shutoff_ctrl17 <= 1'b0;
    else if(cpu_shutoff_ctrl17 && int_source_h17)
     cpu_shutoff_ctrl17 <= 1'b0;
    else if (L1_ctrl_cpu_off_p17)
     cpu_shutoff_ctrl17 <= 1'b1;
  end
 
  // instantiate17 power17 contol17  block for uart17
  power_ctrl_sm17 i_urt_power_ctrl_sm17(
    .pclk17(pclk17),
    .nprst17(nprst17),
    .L1_module_req17(L1_ctrl_domain17[1]),
    .set_status_module17(set_status_urt17),
    .clr_status_module17(clr_status_urt17),
    .rstn_non_srpg_module17(rstn_non_srpg_urt_int17),
    .gate_clk_module17(gate_clk_urt_int17),
    .isolate_module17(isolate_urt_int17),
    .save_edge17(save_edge_urt_int17),
    .restore_edge17(restore_edge_urt_int17),
    .pwr1_on17(pwr1_on_urt_int17),
    .pwr2_on17(pwr2_on_urt_int17)
    );
  

  // instantiate17 power17 contol17  block for smc17
  power_ctrl_sm17 i_smc_power_ctrl_sm17(
    .pclk17(pclk17),
    .nprst17(nprst17),
    .L1_module_req17(L1_ctrl_domain17[2]),
    .set_status_module17(set_status_smc17),
    .clr_status_module17(clr_status_smc17),
    .rstn_non_srpg_module17(rstn_non_srpg_smc_int17),
    .gate_clk_module17(gate_clk_smc_int17),
    .isolate_module17(isolate_smc_int17),
    .save_edge17(save_edge_smc_int17),
    .restore_edge17(restore_edge_smc_int17),
    .pwr1_on17(pwr1_on_smc_int17),
    .pwr2_on17(pwr2_on_smc_int17)
    );

  // power17 control17 for macb017
  power_ctrl_sm17 i_macb0_power_ctrl_sm17(
    .pclk17(pclk17),
    .nprst17(nprst17),
    .L1_module_req17(L1_ctrl_domain17[3]),
    .set_status_module17(set_status_macb017),
    .clr_status_module17(clr_status_macb017),
    .rstn_non_srpg_module17(rstn_non_srpg_macb0_int17),
    .gate_clk_module17(gate_clk_macb0_int17),
    .isolate_module17(isolate_macb0_int17),
    .save_edge17(save_edge_macb0_int17),
    .restore_edge17(restore_edge_macb0_int17),
    .pwr1_on17(pwr1_on_macb0_int17),
    .pwr2_on17(pwr2_on_macb0_int17)
    );
  // power17 control17 for macb117
  power_ctrl_sm17 i_macb1_power_ctrl_sm17(
    .pclk17(pclk17),
    .nprst17(nprst17),
    .L1_module_req17(L1_ctrl_domain17[4]),
    .set_status_module17(set_status_macb117),
    .clr_status_module17(clr_status_macb117),
    .rstn_non_srpg_module17(rstn_non_srpg_macb1_int17),
    .gate_clk_module17(gate_clk_macb1_int17),
    .isolate_module17(isolate_macb1_int17),
    .save_edge17(save_edge_macb1_int17),
    .restore_edge17(restore_edge_macb1_int17),
    .pwr1_on17(pwr1_on_macb1_int17),
    .pwr2_on17(pwr2_on_macb1_int17)
    );
  // power17 control17 for macb217
  power_ctrl_sm17 i_macb2_power_ctrl_sm17(
    .pclk17(pclk17),
    .nprst17(nprst17),
    .L1_module_req17(L1_ctrl_domain17[5]),
    .set_status_module17(set_status_macb217),
    .clr_status_module17(clr_status_macb217),
    .rstn_non_srpg_module17(rstn_non_srpg_macb2_int17),
    .gate_clk_module17(gate_clk_macb2_int17),
    .isolate_module17(isolate_macb2_int17),
    .save_edge17(save_edge_macb2_int17),
    .restore_edge17(restore_edge_macb2_int17),
    .pwr1_on17(pwr1_on_macb2_int17),
    .pwr2_on17(pwr2_on_macb2_int17)
    );
  // power17 control17 for macb317
  power_ctrl_sm17 i_macb3_power_ctrl_sm17(
    .pclk17(pclk17),
    .nprst17(nprst17),
    .L1_module_req17(L1_ctrl_domain17[6]),
    .set_status_module17(set_status_macb317),
    .clr_status_module17(clr_status_macb317),
    .rstn_non_srpg_module17(rstn_non_srpg_macb3_int17),
    .gate_clk_module17(gate_clk_macb3_int17),
    .isolate_module17(isolate_macb3_int17),
    .save_edge17(save_edge_macb3_int17),
    .restore_edge17(restore_edge_macb3_int17),
    .pwr1_on17(pwr1_on_macb3_int17),
    .pwr2_on17(pwr2_on_macb3_int17)
    );
  // power17 control17 for dma17
  power_ctrl_sm17 i_dma_power_ctrl_sm17(
    .pclk17(pclk17),
    .nprst17(nprst17),
    .L1_module_req17(L1_ctrl_domain17[7]),
    .set_status_module17(set_status_dma17),
    .clr_status_module17(clr_status_dma17),
    .rstn_non_srpg_module17(rstn_non_srpg_dma_int17),
    .gate_clk_module17(gate_clk_dma_int17),
    .isolate_module17(isolate_dma_int17),
    .save_edge17(save_edge_dma_int17),
    .restore_edge17(restore_edge_dma_int17),
    .pwr1_on17(pwr1_on_dma_int17),
    .pwr2_on17(pwr2_on_dma_int17)
    );
  // power17 control17 for CPU17
  power_ctrl_sm17 i_cpu_power_ctrl_sm17(
    .pclk17(pclk17),
    .nprst17(nprst17),
    .L1_module_req17(cpu_shutoff_ctrl17),
    .set_status_module17(set_status_cpu17),
    .clr_status_module17(clr_status_cpu17),
    .rstn_non_srpg_module17(rstn_non_srpg_cpu_int17),
    .gate_clk_module17(gate_clk_cpu_int17),
    .isolate_module17(isolate_cpu_int17),
    .save_edge17(save_edge_cpu_int17),
    .restore_edge17(restore_edge_cpu_int17),
    .pwr1_on17(pwr1_on_cpu_int17),
    .pwr2_on17(pwr2_on_cpu_int17)
    );

  assign valid_reg_write17 =  (psel17 && pwrite17 && penable17);
  assign valid_reg_read17  =  (psel17 && (!pwrite17) && penable17);

  assign L1_ctrl_access17  =  (paddr17[15:0] == 16'b0000000000000100); 
  assign L1_status_access17 = (paddr17[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access17 =   (paddr17[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access17 = (paddr17[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control17 and status register
  always @(*)
  begin  
    if(valid_reg_read17 && L1_ctrl_access17) 
      prdata17 = L1_ctrl_reg17;
    else if (valid_reg_read17 && L1_status_access17)
      prdata17 = L1_status_reg17;
    else if (valid_reg_read17 && pcm_int_mask_access17)
      prdata17 = pcm_mask_reg17;
    else if (valid_reg_read17 && pcm_int_status_access17)
      prdata17 = pcm_status_reg17;
    else 
      prdata17 = 0;
  end

  assign set_status_mem17 =  (set_status_macb017 && set_status_macb117 && set_status_macb217 &&
                            set_status_macb317 && set_status_dma17 && set_status_cpu17);

  assign clr_status_mem17 =  (clr_status_macb017 && clr_status_macb117 && clr_status_macb217 &&
                            clr_status_macb317 && clr_status_dma17 && clr_status_cpu17);

  assign set_status_alut17 = (set_status_macb017 && set_status_macb117 && set_status_macb217 && set_status_macb317);

  assign clr_status_alut17 = (clr_status_macb017 || clr_status_macb117 || clr_status_macb217  || clr_status_macb317);

  // Write accesses to the control17 and status register
 
  always @(posedge pclk17 or negedge nprst17)
  begin
    if (!nprst17) begin
      L1_ctrl_reg17   <= 0;
      L1_status_reg17 <= 0;
      pcm_mask_reg17 <= 0;
    end else begin
      // CTRL17 reg updates17
      if (valid_reg_write17 && L1_ctrl_access17) 
        L1_ctrl_reg17 <= pwdata17; // Writes17 to the ctrl17 reg
      if (valid_reg_write17 && pcm_int_mask_access17) 
        pcm_mask_reg17 <= pwdata17; // Writes17 to the ctrl17 reg

      if (set_status_urt17 == 1'b1)  
        L1_status_reg17[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt17 == 1'b1) 
        L1_status_reg17[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc17 == 1'b1) 
        L1_status_reg17[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc17 == 1'b1) 
        L1_status_reg17[2] <= 1'b0; // Clear the status bit

      if (set_status_macb017 == 1'b1)  
        L1_status_reg17[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb017 == 1'b1) 
        L1_status_reg17[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb117 == 1'b1)  
        L1_status_reg17[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb117 == 1'b1) 
        L1_status_reg17[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb217 == 1'b1)  
        L1_status_reg17[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb217 == 1'b1) 
        L1_status_reg17[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb317 == 1'b1)  
        L1_status_reg17[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb317 == 1'b1) 
        L1_status_reg17[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma17 == 1'b1)  
        L1_status_reg17[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma17 == 1'b1) 
        L1_status_reg17[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu17 == 1'b1)  
        L1_status_reg17[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu17 == 1'b1) 
        L1_status_reg17[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut17 == 1'b1)  
        L1_status_reg17[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut17 == 1'b1) 
        L1_status_reg17[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem17 == 1'b1)  
        L1_status_reg17[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem17 == 1'b1) 
        L1_status_reg17[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused17 bits of pcm_status_reg17 are tied17 to 0
  always @(posedge pclk17 or negedge nprst17)
  begin
    if (!nprst17)
      pcm_status_reg17[31:4] <= 'b0;
    else  
      pcm_status_reg17[31:4] <= pcm_status_reg17[31:4];
  end
  
  // interrupt17 only of h/w assisted17 wakeup
  // MAC17 3
  always @(posedge pclk17 or negedge nprst17)
  begin
    if(!nprst17)
      pcm_status_reg17[3] <= 1'b0;
    else if (valid_reg_write17 && pcm_int_status_access17) 
      pcm_status_reg17[3] <= pwdata17[3];
    else if (macb3_wakeup17 & ~pcm_mask_reg17[3])
      pcm_status_reg17[3] <= 1'b1;
    else if (valid_reg_read17 && pcm_int_status_access17) 
      pcm_status_reg17[3] <= 1'b0;
    else
      pcm_status_reg17[3] <= pcm_status_reg17[3];
  end  
   
  // MAC17 2
  always @(posedge pclk17 or negedge nprst17)
  begin
    if(!nprst17)
      pcm_status_reg17[2] <= 1'b0;
    else if (valid_reg_write17 && pcm_int_status_access17) 
      pcm_status_reg17[2] <= pwdata17[2];
    else if (macb2_wakeup17 & ~pcm_mask_reg17[2])
      pcm_status_reg17[2] <= 1'b1;
    else if (valid_reg_read17 && pcm_int_status_access17) 
      pcm_status_reg17[2] <= 1'b0;
    else
      pcm_status_reg17[2] <= pcm_status_reg17[2];
  end  

  // MAC17 1
  always @(posedge pclk17 or negedge nprst17)
  begin
    if(!nprst17)
      pcm_status_reg17[1] <= 1'b0;
    else if (valid_reg_write17 && pcm_int_status_access17) 
      pcm_status_reg17[1] <= pwdata17[1];
    else if (macb1_wakeup17 & ~pcm_mask_reg17[1])
      pcm_status_reg17[1] <= 1'b1;
    else if (valid_reg_read17 && pcm_int_status_access17) 
      pcm_status_reg17[1] <= 1'b0;
    else
      pcm_status_reg17[1] <= pcm_status_reg17[1];
  end  
   
  // MAC17 0
  always @(posedge pclk17 or negedge nprst17)
  begin
    if(!nprst17)
      pcm_status_reg17[0] <= 1'b0;
    else if (valid_reg_write17 && pcm_int_status_access17) 
      pcm_status_reg17[0] <= pwdata17[0];
    else if (macb0_wakeup17 & ~pcm_mask_reg17[0])
      pcm_status_reg17[0] <= 1'b1;
    else if (valid_reg_read17 && pcm_int_status_access17) 
      pcm_status_reg17[0] <= 1'b0;
    else
      pcm_status_reg17[0] <= pcm_status_reg17[0];
  end  

  assign pcm_macb_wakeup_int17 = |pcm_status_reg17;

  reg [31:0] L1_ctrl_reg117;
  always @(posedge pclk17 or negedge nprst17)
  begin
    if(!nprst17)
      L1_ctrl_reg117 <= 0;
    else
      L1_ctrl_reg117 <= L1_ctrl_reg17;
  end

  // Program17 mode decode
  always @(L1_ctrl_reg17 or L1_ctrl_reg117 or int_source_h17 or cpu_shutoff_ctrl17) begin
    mte_smc_start17 = 0;
    mte_uart_start17 = 0;
    mte_smc_uart_start17  = 0;
    mte_mac_off_start17  = 0;
    mte_mac012_start17 = 0;
    mte_mac013_start17 = 0;
    mte_mac023_start17 = 0;
    mte_mac123_start17 = 0;
    mte_mac01_start17 = 0;
    mte_mac02_start17 = 0;
    mte_mac03_start17 = 0;
    mte_mac12_start17 = 0;
    mte_mac13_start17 = 0;
    mte_mac23_start17 = 0;
    mte_mac0_start17 = 0;
    mte_mac1_start17 = 0;
    mte_mac2_start17 = 0;
    mte_mac3_start17 = 0;
    mte_sys_hibernate17 = 0 ;
    mte_dma_start17 = 0 ;
    mte_cpu_start17 = 0 ;

    mte_mac0_sleep_start17 = (L1_ctrl_reg17 ==  'h14) && (L1_ctrl_reg117 == 'h4 );
    mte_mac1_sleep_start17 = (L1_ctrl_reg17 ==  'h14) && (L1_ctrl_reg117 == 'h5 ); 
    mte_mac2_sleep_start17 = (L1_ctrl_reg17 ==  'h14) && (L1_ctrl_reg117 == 'h6 ); 
    mte_mac3_sleep_start17 = (L1_ctrl_reg17 ==  'h14) && (L1_ctrl_reg117 == 'h7 ); 
    mte_mac01_sleep_start17 = (L1_ctrl_reg17 ==  'h14) && (L1_ctrl_reg117 == 'h8 ); 
    mte_mac02_sleep_start17 = (L1_ctrl_reg17 ==  'h14) && (L1_ctrl_reg117 == 'h9 ); 
    mte_mac03_sleep_start17 = (L1_ctrl_reg17 ==  'h14) && (L1_ctrl_reg117 == 'hA ); 
    mte_mac12_sleep_start17 = (L1_ctrl_reg17 ==  'h14) && (L1_ctrl_reg117 == 'hB ); 
    mte_mac13_sleep_start17 = (L1_ctrl_reg17 ==  'h14) && (L1_ctrl_reg117 == 'hC ); 
    mte_mac23_sleep_start17 = (L1_ctrl_reg17 ==  'h14) && (L1_ctrl_reg117 == 'hD ); 
    mte_mac012_sleep_start17 = (L1_ctrl_reg17 ==  'h14) && (L1_ctrl_reg117 == 'hE ); 
    mte_mac013_sleep_start17 = (L1_ctrl_reg17 ==  'h14) && (L1_ctrl_reg117 == 'hF ); 
    mte_mac023_sleep_start17 = (L1_ctrl_reg17 ==  'h14) && (L1_ctrl_reg117 == 'h10 ); 
    mte_mac123_sleep_start17 = (L1_ctrl_reg17 ==  'h14) && (L1_ctrl_reg117 == 'h11 ); 
    mte_mac_off_sleep_start17 =  (L1_ctrl_reg17 == 'h14) && (L1_ctrl_reg117 == 'h12 );
    mte_dma_sleep_start17 =  (L1_ctrl_reg17 == 'h14) && (L1_ctrl_reg117 == 'h13 );

    mte_pm_uart_to_default_start17 = (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'h1);
    mte_pm_smc_to_default_start17 = (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'h2);
    mte_pm_smc_uart_to_default_start17 = (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'h3); 
    mte_mac0_to_default17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'h4); 
    mte_mac1_to_default17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'h5); 
    mte_mac2_to_default17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'h6); 
    mte_mac3_to_default17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'h7); 
    mte_mac01_to_default17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'h8); 
    mte_mac02_to_default17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'h9); 
    mte_mac03_to_default17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'hA); 
    mte_mac12_to_default17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'hB); 
    mte_mac13_to_default17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'hC); 
    mte_mac23_to_default17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'hD); 
    mte_mac012_to_default17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'hE); 
    mte_mac013_to_default17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'hF); 
    mte_mac023_to_default17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'h10); 
    mte_mac123_to_default17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'h11); 
    mte_mac_off_to_default17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'h12); 
    mte_dma_isolate_dis17 =  (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'h13); 
    mte_cpu_isolate_dis17 =  (int_source_h17) && (cpu_shutoff_ctrl17) && (L1_ctrl_reg17 != 'h15);
    mte_sys_hibernate_to_default17 = (L1_ctrl_reg17 == 32'h0) && (L1_ctrl_reg117 == 'h15); 

   
    if (L1_ctrl_reg117 == 'h0) begin // This17 check is to make mte_cpu_start17
                                   // is set only when you from default state 
      case (L1_ctrl_reg17)
        'h0 : L1_ctrl_domain17 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain17 = 32'h2; // PM_uart17
                mte_uart_start17 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain17 = 32'h4; // PM_smc17
                mte_smc_start17 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain17 = 32'h6; // PM_smc_uart17
                mte_smc_uart_start17 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain17 = 32'h8; //  PM_macb017
                mte_mac0_start17 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain17 = 32'h10; //  PM_macb117
                mte_mac1_start17 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain17 = 32'h20; //  PM_macb217
                mte_mac2_start17 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain17 = 32'h40; //  PM_macb317
                mte_mac3_start17 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain17 = 32'h18; //  PM_macb0117
                mte_mac01_start17 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain17 = 32'h28; //  PM_macb0217
                mte_mac02_start17 = 1;
              end
        'hA : begin  
                L1_ctrl_domain17 = 32'h48; //  PM_macb0317
                mte_mac03_start17 = 1;
              end
        'hB : begin  
                L1_ctrl_domain17 = 32'h30; //  PM_macb1217
                mte_mac12_start17 = 1;
              end
        'hC : begin  
                L1_ctrl_domain17 = 32'h50; //  PM_macb1317
                mte_mac13_start17 = 1;
              end
        'hD : begin  
                L1_ctrl_domain17 = 32'h60; //  PM_macb2317
                mte_mac23_start17 = 1;
              end
        'hE : begin  
                L1_ctrl_domain17 = 32'h38; //  PM_macb01217
                mte_mac012_start17 = 1;
              end
        'hF : begin  
                L1_ctrl_domain17 = 32'h58; //  PM_macb01317
                mte_mac013_start17 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain17 = 32'h68; //  PM_macb02317
                mte_mac023_start17 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain17 = 32'h70; //  PM_macb12317
                mte_mac123_start17 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain17 = 32'h78; //  PM_macb_off17
                mte_mac_off_start17 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain17 = 32'h80; //  PM_dma17
                mte_dma_start17 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain17 = 32'h100; //  PM_cpu_sleep17
                mte_cpu_start17 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain17 = 32'h1FE; //  PM_hibernate17
                mte_sys_hibernate17 = 1;
              end
         default: L1_ctrl_domain17 = 32'h0;
      endcase
    end
  end


  wire to_default17 = (L1_ctrl_reg17 == 0);

  // Scan17 mode gating17 of power17 and isolation17 control17 signals17
  //SMC17
  assign rstn_non_srpg_smc17  = (scan_mode17 == 1'b0) ? rstn_non_srpg_smc_int17 : 1'b1;  
  assign gate_clk_smc17       = (scan_mode17 == 1'b0) ? gate_clk_smc_int17 : 1'b0;     
  assign isolate_smc17        = (scan_mode17 == 1'b0) ? isolate_smc_int17 : 1'b0;      
  assign pwr1_on_smc17        = (scan_mode17 == 1'b0) ? pwr1_on_smc_int17 : 1'b1;       
  assign pwr2_on_smc17        = (scan_mode17 == 1'b0) ? pwr2_on_smc_int17 : 1'b1;       
  assign pwr1_off_smc17       = (scan_mode17 == 1'b0) ? (!pwr1_on_smc_int17) : 1'b0;       
  assign pwr2_off_smc17       = (scan_mode17 == 1'b0) ? (!pwr2_on_smc_int17) : 1'b0;       
  assign save_edge_smc17       = (scan_mode17 == 1'b0) ? (save_edge_smc_int17) : 1'b0;       
  assign restore_edge_smc17       = (scan_mode17 == 1'b0) ? (restore_edge_smc_int17) : 1'b0;       

  //URT17
  assign rstn_non_srpg_urt17  = (scan_mode17 == 1'b0) ?  rstn_non_srpg_urt_int17 : 1'b1;  
  assign gate_clk_urt17       = (scan_mode17 == 1'b0) ?  gate_clk_urt_int17      : 1'b0;     
  assign isolate_urt17        = (scan_mode17 == 1'b0) ?  isolate_urt_int17       : 1'b0;      
  assign pwr1_on_urt17        = (scan_mode17 == 1'b0) ?  pwr1_on_urt_int17       : 1'b1;       
  assign pwr2_on_urt17        = (scan_mode17 == 1'b0) ?  pwr2_on_urt_int17       : 1'b1;       
  assign pwr1_off_urt17       = (scan_mode17 == 1'b0) ?  (!pwr1_on_urt_int17)  : 1'b0;       
  assign pwr2_off_urt17       = (scan_mode17 == 1'b0) ?  (!pwr2_on_urt_int17)  : 1'b0;       
  assign save_edge_urt17       = (scan_mode17 == 1'b0) ? (save_edge_urt_int17) : 1'b0;       
  assign restore_edge_urt17       = (scan_mode17 == 1'b0) ? (restore_edge_urt_int17) : 1'b0;       

  //ETH017
  assign rstn_non_srpg_macb017 = (scan_mode17 == 1'b0) ?  rstn_non_srpg_macb0_int17 : 1'b1;  
  assign gate_clk_macb017       = (scan_mode17 == 1'b0) ?  gate_clk_macb0_int17      : 1'b0;     
  assign isolate_macb017        = (scan_mode17 == 1'b0) ?  isolate_macb0_int17       : 1'b0;      
  assign pwr1_on_macb017        = (scan_mode17 == 1'b0) ?  pwr1_on_macb0_int17       : 1'b1;       
  assign pwr2_on_macb017        = (scan_mode17 == 1'b0) ?  pwr2_on_macb0_int17       : 1'b1;       
  assign pwr1_off_macb017       = (scan_mode17 == 1'b0) ?  (!pwr1_on_macb0_int17)  : 1'b0;       
  assign pwr2_off_macb017       = (scan_mode17 == 1'b0) ?  (!pwr2_on_macb0_int17)  : 1'b0;       
  assign save_edge_macb017       = (scan_mode17 == 1'b0) ? (save_edge_macb0_int17) : 1'b0;       
  assign restore_edge_macb017       = (scan_mode17 == 1'b0) ? (restore_edge_macb0_int17) : 1'b0;       

  //ETH117
  assign rstn_non_srpg_macb117 = (scan_mode17 == 1'b0) ?  rstn_non_srpg_macb1_int17 : 1'b1;  
  assign gate_clk_macb117       = (scan_mode17 == 1'b0) ?  gate_clk_macb1_int17      : 1'b0;     
  assign isolate_macb117        = (scan_mode17 == 1'b0) ?  isolate_macb1_int17       : 1'b0;      
  assign pwr1_on_macb117        = (scan_mode17 == 1'b0) ?  pwr1_on_macb1_int17       : 1'b1;       
  assign pwr2_on_macb117        = (scan_mode17 == 1'b0) ?  pwr2_on_macb1_int17       : 1'b1;       
  assign pwr1_off_macb117       = (scan_mode17 == 1'b0) ?  (!pwr1_on_macb1_int17)  : 1'b0;       
  assign pwr2_off_macb117       = (scan_mode17 == 1'b0) ?  (!pwr2_on_macb1_int17)  : 1'b0;       
  assign save_edge_macb117       = (scan_mode17 == 1'b0) ? (save_edge_macb1_int17) : 1'b0;       
  assign restore_edge_macb117       = (scan_mode17 == 1'b0) ? (restore_edge_macb1_int17) : 1'b0;       

  //ETH217
  assign rstn_non_srpg_macb217 = (scan_mode17 == 1'b0) ?  rstn_non_srpg_macb2_int17 : 1'b1;  
  assign gate_clk_macb217       = (scan_mode17 == 1'b0) ?  gate_clk_macb2_int17      : 1'b0;     
  assign isolate_macb217        = (scan_mode17 == 1'b0) ?  isolate_macb2_int17       : 1'b0;      
  assign pwr1_on_macb217        = (scan_mode17 == 1'b0) ?  pwr1_on_macb2_int17       : 1'b1;       
  assign pwr2_on_macb217        = (scan_mode17 == 1'b0) ?  pwr2_on_macb2_int17       : 1'b1;       
  assign pwr1_off_macb217       = (scan_mode17 == 1'b0) ?  (!pwr1_on_macb2_int17)  : 1'b0;       
  assign pwr2_off_macb217       = (scan_mode17 == 1'b0) ?  (!pwr2_on_macb2_int17)  : 1'b0;       
  assign save_edge_macb217       = (scan_mode17 == 1'b0) ? (save_edge_macb2_int17) : 1'b0;       
  assign restore_edge_macb217       = (scan_mode17 == 1'b0) ? (restore_edge_macb2_int17) : 1'b0;       

  //ETH317
  assign rstn_non_srpg_macb317 = (scan_mode17 == 1'b0) ?  rstn_non_srpg_macb3_int17 : 1'b1;  
  assign gate_clk_macb317       = (scan_mode17 == 1'b0) ?  gate_clk_macb3_int17      : 1'b0;     
  assign isolate_macb317        = (scan_mode17 == 1'b0) ?  isolate_macb3_int17       : 1'b0;      
  assign pwr1_on_macb317        = (scan_mode17 == 1'b0) ?  pwr1_on_macb3_int17       : 1'b1;       
  assign pwr2_on_macb317        = (scan_mode17 == 1'b0) ?  pwr2_on_macb3_int17       : 1'b1;       
  assign pwr1_off_macb317       = (scan_mode17 == 1'b0) ?  (!pwr1_on_macb3_int17)  : 1'b0;       
  assign pwr2_off_macb317       = (scan_mode17 == 1'b0) ?  (!pwr2_on_macb3_int17)  : 1'b0;       
  assign save_edge_macb317       = (scan_mode17 == 1'b0) ? (save_edge_macb3_int17) : 1'b0;       
  assign restore_edge_macb317       = (scan_mode17 == 1'b0) ? (restore_edge_macb3_int17) : 1'b0;       

  // MEM17
  assign rstn_non_srpg_mem17 =   (rstn_non_srpg_macb017 && rstn_non_srpg_macb117 && rstn_non_srpg_macb217 &&
                                rstn_non_srpg_macb317 && rstn_non_srpg_dma17 && rstn_non_srpg_cpu17 && rstn_non_srpg_urt17 &&
                                rstn_non_srpg_smc17);

  assign gate_clk_mem17 =  (gate_clk_macb017 && gate_clk_macb117 && gate_clk_macb217 &&
                            gate_clk_macb317 && gate_clk_dma17 && gate_clk_cpu17 && gate_clk_urt17 && gate_clk_smc17);

  assign isolate_mem17  = (isolate_macb017 && isolate_macb117 && isolate_macb217 &&
                         isolate_macb317 && isolate_dma17 && isolate_cpu17 && isolate_urt17 && isolate_smc17);


  assign pwr1_on_mem17        =   ~pwr1_off_mem17;

  assign pwr2_on_mem17        =   ~pwr2_off_mem17;

  assign pwr1_off_mem17       =  (pwr1_off_macb017 && pwr1_off_macb117 && pwr1_off_macb217 &&
                                 pwr1_off_macb317 && pwr1_off_dma17 && pwr1_off_cpu17 && pwr1_off_urt17 && pwr1_off_smc17);


  assign pwr2_off_mem17       =  (pwr2_off_macb017 && pwr2_off_macb117 && pwr2_off_macb217 &&
                                pwr2_off_macb317 && pwr2_off_dma17 && pwr2_off_cpu17 && pwr2_off_urt17 && pwr2_off_smc17);

  assign save_edge_mem17      =  (save_edge_macb017 && save_edge_macb117 && save_edge_macb217 &&
                                save_edge_macb317 && save_edge_dma17 && save_edge_cpu17 && save_edge_smc17 && save_edge_urt17);

  assign restore_edge_mem17   =  (restore_edge_macb017 && restore_edge_macb117 && restore_edge_macb217  &&
                                restore_edge_macb317 && restore_edge_dma17 && restore_edge_cpu17 && restore_edge_urt17 &&
                                restore_edge_smc17);

  assign standby_mem017 = pwr1_off_macb017 && (~ (pwr1_off_macb017 && pwr1_off_macb117 && pwr1_off_macb217 && pwr1_off_macb317 && pwr1_off_urt17 && pwr1_off_smc17 && pwr1_off_dma17 && pwr1_off_cpu17));
  assign standby_mem117 = pwr1_off_macb117 && (~ (pwr1_off_macb017 && pwr1_off_macb117 && pwr1_off_macb217 && pwr1_off_macb317 && pwr1_off_urt17 && pwr1_off_smc17 && pwr1_off_dma17 && pwr1_off_cpu17));
  assign standby_mem217 = pwr1_off_macb217 && (~ (pwr1_off_macb017 && pwr1_off_macb117 && pwr1_off_macb217 && pwr1_off_macb317 && pwr1_off_urt17 && pwr1_off_smc17 && pwr1_off_dma17 && pwr1_off_cpu17));
  assign standby_mem317 = pwr1_off_macb317 && (~ (pwr1_off_macb017 && pwr1_off_macb117 && pwr1_off_macb217 && pwr1_off_macb317 && pwr1_off_urt17 && pwr1_off_smc17 && pwr1_off_dma17 && pwr1_off_cpu17));

  assign pwr1_off_mem017 = pwr1_off_mem17;
  assign pwr1_off_mem117 = pwr1_off_mem17;
  assign pwr1_off_mem217 = pwr1_off_mem17;
  assign pwr1_off_mem317 = pwr1_off_mem17;

  assign rstn_non_srpg_alut17  =  (rstn_non_srpg_macb017 && rstn_non_srpg_macb117 && rstn_non_srpg_macb217 && rstn_non_srpg_macb317);


   assign gate_clk_alut17       =  (gate_clk_macb017 && gate_clk_macb117 && gate_clk_macb217 && gate_clk_macb317);


    assign isolate_alut17        =  (isolate_macb017 && isolate_macb117 && isolate_macb217 && isolate_macb317);


    assign pwr1_on_alut17        =  (pwr1_on_macb017 || pwr1_on_macb117 || pwr1_on_macb217 || pwr1_on_macb317);


    assign pwr2_on_alut17        =  (pwr2_on_macb017 || pwr2_on_macb117 || pwr2_on_macb217 || pwr2_on_macb317);


    assign pwr1_off_alut17       =  (pwr1_off_macb017 && pwr1_off_macb117 && pwr1_off_macb217 && pwr1_off_macb317);


    assign pwr2_off_alut17       =  (pwr2_off_macb017 && pwr2_off_macb117 && pwr2_off_macb217 && pwr2_off_macb317);


    assign save_edge_alut17      =  (save_edge_macb017 && save_edge_macb117 && save_edge_macb217 && save_edge_macb317);


    assign restore_edge_alut17   =  (restore_edge_macb017 || restore_edge_macb117 || restore_edge_macb217 ||
                                   restore_edge_macb317) && save_alut_tmp17;

     // alut17 power17 off17 detection17
  always @(posedge pclk17 or negedge nprst17) begin
    if (!nprst17) 
       save_alut_tmp17 <= 0;
    else if (restore_edge_alut17)
       save_alut_tmp17 <= 0;
    else if (save_edge_alut17)
       save_alut_tmp17 <= 1;
  end

  //DMA17
  assign rstn_non_srpg_dma17 = (scan_mode17 == 1'b0) ?  rstn_non_srpg_dma_int17 : 1'b1;  
  assign gate_clk_dma17       = (scan_mode17 == 1'b0) ?  gate_clk_dma_int17      : 1'b0;     
  assign isolate_dma17        = (scan_mode17 == 1'b0) ?  isolate_dma_int17       : 1'b0;      
  assign pwr1_on_dma17        = (scan_mode17 == 1'b0) ?  pwr1_on_dma_int17       : 1'b1;       
  assign pwr2_on_dma17        = (scan_mode17 == 1'b0) ?  pwr2_on_dma_int17       : 1'b1;       
  assign pwr1_off_dma17       = (scan_mode17 == 1'b0) ?  (!pwr1_on_dma_int17)  : 1'b0;       
  assign pwr2_off_dma17       = (scan_mode17 == 1'b0) ?  (!pwr2_on_dma_int17)  : 1'b0;       
  assign save_edge_dma17       = (scan_mode17 == 1'b0) ? (save_edge_dma_int17) : 1'b0;       
  assign restore_edge_dma17       = (scan_mode17 == 1'b0) ? (restore_edge_dma_int17) : 1'b0;       

  //CPU17
  assign rstn_non_srpg_cpu17 = (scan_mode17 == 1'b0) ?  rstn_non_srpg_cpu_int17 : 1'b1;  
  assign gate_clk_cpu17       = (scan_mode17 == 1'b0) ?  gate_clk_cpu_int17      : 1'b0;     
  assign isolate_cpu17        = (scan_mode17 == 1'b0) ?  isolate_cpu_int17       : 1'b0;      
  assign pwr1_on_cpu17        = (scan_mode17 == 1'b0) ?  pwr1_on_cpu_int17       : 1'b1;       
  assign pwr2_on_cpu17        = (scan_mode17 == 1'b0) ?  pwr2_on_cpu_int17       : 1'b1;       
  assign pwr1_off_cpu17       = (scan_mode17 == 1'b0) ?  (!pwr1_on_cpu_int17)  : 1'b0;       
  assign pwr2_off_cpu17       = (scan_mode17 == 1'b0) ?  (!pwr2_on_cpu_int17)  : 1'b0;       
  assign save_edge_cpu17       = (scan_mode17 == 1'b0) ? (save_edge_cpu_int17) : 1'b0;       
  assign restore_edge_cpu17       = (scan_mode17 == 1'b0) ? (restore_edge_cpu_int17) : 1'b0;       



  // ASE17

   reg ase_core_12v17, ase_core_10v17, ase_core_08v17, ase_core_06v17;
   reg ase_macb0_12v17,ase_macb1_12v17,ase_macb2_12v17,ase_macb3_12v17;

    // core17 ase17

    // core17 at 1.0 v if (smc17 off17, urt17 off17, macb017 off17, macb117 off17, macb217 off17, macb317 off17
   // core17 at 0.8v if (mac01off17, macb02off17, macb03off17, macb12off17, mac13off17, mac23off17,
   // core17 at 0.6v if (mac012off17, mac013off17, mac023off17, mac123off17, mac0123off17
    // else core17 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb017 && pwr1_off_macb117 && pwr1_off_macb217 && pwr1_off_macb317) || // all mac17 off17
       (pwr1_off_macb317 && pwr1_off_macb217 && pwr1_off_macb117) || // mac123off17 
       (pwr1_off_macb317 && pwr1_off_macb217 && pwr1_off_macb017) || // mac023off17 
       (pwr1_off_macb317 && pwr1_off_macb117 && pwr1_off_macb017) || // mac013off17 
       (pwr1_off_macb217 && pwr1_off_macb117 && pwr1_off_macb017) )  // mac012off17 
       begin
         ase_core_12v17 = 0;
         ase_core_10v17 = 0;
         ase_core_08v17 = 0;
         ase_core_06v17 = 1;
       end
     else if( (pwr1_off_macb217 && pwr1_off_macb317) || // mac2317 off17
         (pwr1_off_macb317 && pwr1_off_macb117) || // mac13off17 
         (pwr1_off_macb117 && pwr1_off_macb217) || // mac12off17 
         (pwr1_off_macb317 && pwr1_off_macb017) || // mac03off17 
         (pwr1_off_macb217 && pwr1_off_macb017) || // mac02off17 
         (pwr1_off_macb117 && pwr1_off_macb017))  // mac01off17 
       begin
         ase_core_12v17 = 0;
         ase_core_10v17 = 0;
         ase_core_08v17 = 1;
         ase_core_06v17 = 0;
       end
     else if( (pwr1_off_smc17) || // smc17 off17
         (pwr1_off_macb017 ) || // mac0off17 
         (pwr1_off_macb117 ) || // mac1off17 
         (pwr1_off_macb217 ) || // mac2off17 
         (pwr1_off_macb317 ))  // mac3off17 
       begin
         ase_core_12v17 = 0;
         ase_core_10v17 = 1;
         ase_core_08v17 = 0;
         ase_core_06v17 = 0;
       end
     else if (pwr1_off_urt17)
       begin
         ase_core_12v17 = 1;
         ase_core_10v17 = 0;
         ase_core_08v17 = 0;
         ase_core_06v17 = 0;
       end
     else
       begin
         ase_core_12v17 = 1;
         ase_core_10v17 = 0;
         ase_core_08v17 = 0;
         ase_core_06v17 = 0;
       end
   end


   // cpu17
   // cpu17 @ 1.0v when macoff17, 
   // 
   reg ase_cpu_10v17, ase_cpu_12v17;
   always @(*) begin
    if(pwr1_off_cpu17) begin
     ase_cpu_12v17 = 1'b0;
     ase_cpu_10v17 = 1'b0;
    end
    else if(pwr1_off_macb017 || pwr1_off_macb117 || pwr1_off_macb217 || pwr1_off_macb317)
    begin
     ase_cpu_12v17 = 1'b0;
     ase_cpu_10v17 = 1'b1;
    end
    else
    begin
     ase_cpu_12v17 = 1'b1;
     ase_cpu_10v17 = 1'b0;
    end
   end

   // dma17
   // dma17 @v117.0 for macoff17, 

   reg ase_dma_10v17, ase_dma_12v17;
   always @(*) begin
    if(pwr1_off_dma17) begin
     ase_dma_12v17 = 1'b0;
     ase_dma_10v17 = 1'b0;
    end
    else if(pwr1_off_macb017 || pwr1_off_macb117 || pwr1_off_macb217 || pwr1_off_macb317)
    begin
     ase_dma_12v17 = 1'b0;
     ase_dma_10v17 = 1'b1;
    end
    else
    begin
     ase_dma_12v17 = 1'b1;
     ase_dma_10v17 = 1'b0;
    end
   end

   // alut17
   // @ v117.0 for macoff17

   reg ase_alut_10v17, ase_alut_12v17;
   always @(*) begin
    if(pwr1_off_alut17) begin
     ase_alut_12v17 = 1'b0;
     ase_alut_10v17 = 1'b0;
    end
    else if(pwr1_off_macb017 || pwr1_off_macb117 || pwr1_off_macb217 || pwr1_off_macb317)
    begin
     ase_alut_12v17 = 1'b0;
     ase_alut_10v17 = 1'b1;
    end
    else
    begin
     ase_alut_12v17 = 1'b1;
     ase_alut_10v17 = 1'b0;
    end
   end




   reg ase_uart_12v17;
   reg ase_uart_10v17;
   reg ase_uart_08v17;
   reg ase_uart_06v17;

   reg ase_smc_12v17;


   always @(*) begin
     if(pwr1_off_urt17) begin // uart17 off17
       ase_uart_08v17 = 1'b0;
       ase_uart_06v17 = 1'b0;
       ase_uart_10v17 = 1'b0;
       ase_uart_12v17 = 1'b0;
     end 
     else if( (pwr1_off_macb017 && pwr1_off_macb117 && pwr1_off_macb217 && pwr1_off_macb317) || // all mac17 off17
       (pwr1_off_macb317 && pwr1_off_macb217 && pwr1_off_macb117) || // mac123off17 
       (pwr1_off_macb317 && pwr1_off_macb217 && pwr1_off_macb017) || // mac023off17 
       (pwr1_off_macb317 && pwr1_off_macb117 && pwr1_off_macb017) || // mac013off17 
       (pwr1_off_macb217 && pwr1_off_macb117 && pwr1_off_macb017) )  // mac012off17 
     begin
       ase_uart_06v17 = 1'b1;
       ase_uart_08v17 = 1'b0;
       ase_uart_10v17 = 1'b0;
       ase_uart_12v17 = 1'b0;
     end
     else if( (pwr1_off_macb217 && pwr1_off_macb317) || // mac2317 off17
         (pwr1_off_macb317 && pwr1_off_macb117) || // mac13off17 
         (pwr1_off_macb117 && pwr1_off_macb217) || // mac12off17 
         (pwr1_off_macb317 && pwr1_off_macb017) || // mac03off17 
         (pwr1_off_macb117 && pwr1_off_macb017))  // mac01off17  
     begin
       ase_uart_06v17 = 1'b0;
       ase_uart_08v17 = 1'b1;
       ase_uart_10v17 = 1'b0;
       ase_uart_12v17 = 1'b0;
     end
     else if (pwr1_off_smc17 || pwr1_off_macb017 || pwr1_off_macb117 || pwr1_off_macb217 || pwr1_off_macb317) begin // smc17 off17
       ase_uart_08v17 = 1'b0;
       ase_uart_06v17 = 1'b0;
       ase_uart_10v17 = 1'b1;
       ase_uart_12v17 = 1'b0;
     end 
     else begin
       ase_uart_08v17 = 1'b0;
       ase_uart_06v17 = 1'b0;
       ase_uart_10v17 = 1'b0;
       ase_uart_12v17 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc17) begin
     if (pwr1_off_smc17)  // smc17 off17
       ase_smc_12v17 = 1'b0;
    else
       ase_smc_12v17 = 1'b1;
   end

   
   always @(pwr1_off_macb017) begin
     if (pwr1_off_macb017) // macb017 off17
       ase_macb0_12v17 = 1'b0;
     else
       ase_macb0_12v17 = 1'b1;
   end

   always @(pwr1_off_macb117) begin
     if (pwr1_off_macb117) // macb117 off17
       ase_macb1_12v17 = 1'b0;
     else
       ase_macb1_12v17 = 1'b1;
   end

   always @(pwr1_off_macb217) begin // macb217 off17
     if (pwr1_off_macb217) // macb217 off17
       ase_macb2_12v17 = 1'b0;
     else
       ase_macb2_12v17 = 1'b1;
   end

   always @(pwr1_off_macb317) begin // macb317 off17
     if (pwr1_off_macb317) // macb317 off17
       ase_macb3_12v17 = 1'b0;
     else
       ase_macb3_12v17 = 1'b1;
   end


   // core17 voltage17 for vco17
  assign core12v17 = ase_macb0_12v17 & ase_macb1_12v17 & ase_macb2_12v17 & ase_macb3_12v17;

  assign core10v17 =  (ase_macb0_12v17 & ase_macb1_12v17 & ase_macb2_12v17 & (!ase_macb3_12v17)) ||
                    (ase_macb0_12v17 & ase_macb1_12v17 & (!ase_macb2_12v17) & ase_macb3_12v17) ||
                    (ase_macb0_12v17 & (!ase_macb1_12v17) & ase_macb2_12v17 & ase_macb3_12v17) ||
                    ((!ase_macb0_12v17) & ase_macb1_12v17 & ase_macb2_12v17 & ase_macb3_12v17);

  assign core08v17 =  ((!ase_macb0_12v17) & (!ase_macb1_12v17) & (ase_macb2_12v17) & (ase_macb3_12v17)) ||
                    ((!ase_macb0_12v17) & (ase_macb1_12v17) & (!ase_macb2_12v17) & (ase_macb3_12v17)) ||
                    ((!ase_macb0_12v17) & (ase_macb1_12v17) & (ase_macb2_12v17) & (!ase_macb3_12v17)) ||
                    ((ase_macb0_12v17) & (!ase_macb1_12v17) & (!ase_macb2_12v17) & (ase_macb3_12v17)) ||
                    ((ase_macb0_12v17) & (!ase_macb1_12v17) & (ase_macb2_12v17) & (!ase_macb3_12v17)) ||
                    ((ase_macb0_12v17) & (ase_macb1_12v17) & (!ase_macb2_12v17) & (!ase_macb3_12v17));

  assign core06v17 =  ((!ase_macb0_12v17) & (!ase_macb1_12v17) & (!ase_macb2_12v17) & (ase_macb3_12v17)) ||
                    ((!ase_macb0_12v17) & (!ase_macb1_12v17) & (ase_macb2_12v17) & (!ase_macb3_12v17)) ||
                    ((!ase_macb0_12v17) & (ase_macb1_12v17) & (!ase_macb2_12v17) & (!ase_macb3_12v17)) ||
                    ((ase_macb0_12v17) & (!ase_macb1_12v17) & (!ase_macb2_12v17) & (!ase_macb3_12v17)) ||
                    ((!ase_macb0_12v17) & (!ase_macb1_12v17) & (!ase_macb2_12v17) & (!ase_macb3_12v17)) ;



`ifdef LP_ABV_ON17
// psl17 default clock17 = (posedge pclk17);

// Cover17 a condition in which SMC17 is powered17 down
// and again17 powered17 up while UART17 is going17 into POWER17 down
// state or UART17 is already in POWER17 DOWN17 state
// psl17 cover_overlapping_smc_urt_117:
//    cover{fell17(pwr1_on_urt17);[*];fell17(pwr1_on_smc17);[*];
//    rose17(pwr1_on_smc17);[*];rose17(pwr1_on_urt17)};
//
// Cover17 a condition in which UART17 is powered17 down
// and again17 powered17 up while SMC17 is going17 into POWER17 down
// state or SMC17 is already in POWER17 DOWN17 state
// psl17 cover_overlapping_smc_urt_217:
//    cover{fell17(pwr1_on_smc17);[*];fell17(pwr1_on_urt17);[*];
//    rose17(pwr1_on_urt17);[*];rose17(pwr1_on_smc17)};
//


// Power17 Down17 UART17
// This17 gets17 triggered on rising17 edge of Gate17 signal17 for
// UART17 (gate_clk_urt17). In a next cycle after gate_clk_urt17,
// Isolate17 UART17(isolate_urt17) signal17 become17 HIGH17 (active).
// In 2nd cycle after gate_clk_urt17 becomes HIGH17, RESET17 for NON17
// SRPG17 FFs17(rstn_non_srpg_urt17) and POWER117 for UART17(pwr1_on_urt17) should 
// go17 LOW17. 
// This17 completes17 a POWER17 DOWN17. 

sequence s_power_down_urt17;
      (gate_clk_urt17 & !isolate_urt17 & rstn_non_srpg_urt17 & pwr1_on_urt17) 
  ##1 (gate_clk_urt17 & isolate_urt17 & rstn_non_srpg_urt17 & pwr1_on_urt17) 
  ##3 (gate_clk_urt17 & isolate_urt17 & !rstn_non_srpg_urt17 & !pwr1_on_urt17);
endsequence


property p_power_down_urt17;
   @(posedge pclk17)
    $rose(gate_clk_urt17) |=> s_power_down_urt17;
endproperty

output_power_down_urt17:
  assert property (p_power_down_urt17);


// Power17 UP17 UART17
// Sequence starts with , Rising17 edge of pwr1_on_urt17.
// Two17 clock17 cycle after this, isolate_urt17 should become17 LOW17 
// On17 the following17 clk17 gate_clk_urt17 should go17 low17.
// 5 cycles17 after  Rising17 edge of pwr1_on_urt17, rstn_non_srpg_urt17
// should become17 HIGH17
sequence s_power_up_urt17;
##30 (pwr1_on_urt17 & !isolate_urt17 & gate_clk_urt17 & !rstn_non_srpg_urt17) 
##1 (pwr1_on_urt17 & !isolate_urt17 & !gate_clk_urt17 & !rstn_non_srpg_urt17) 
##2 (pwr1_on_urt17 & !isolate_urt17 & !gate_clk_urt17 & rstn_non_srpg_urt17);
endsequence

property p_power_up_urt17;
   @(posedge pclk17)
  disable iff(!nprst17)
    (!pwr1_on_urt17 ##1 pwr1_on_urt17) |=> s_power_up_urt17;
endproperty

output_power_up_urt17:
  assert property (p_power_up_urt17);


// Power17 Down17 SMC17
// This17 gets17 triggered on rising17 edge of Gate17 signal17 for
// SMC17 (gate_clk_smc17). In a next cycle after gate_clk_smc17,
// Isolate17 SMC17(isolate_smc17) signal17 become17 HIGH17 (active).
// In 2nd cycle after gate_clk_smc17 becomes HIGH17, RESET17 for NON17
// SRPG17 FFs17(rstn_non_srpg_smc17) and POWER117 for SMC17(pwr1_on_smc17) should 
// go17 LOW17. 
// This17 completes17 a POWER17 DOWN17. 

sequence s_power_down_smc17;
      (gate_clk_smc17 & !isolate_smc17 & rstn_non_srpg_smc17 & pwr1_on_smc17) 
  ##1 (gate_clk_smc17 & isolate_smc17 & rstn_non_srpg_smc17 & pwr1_on_smc17) 
  ##3 (gate_clk_smc17 & isolate_smc17 & !rstn_non_srpg_smc17 & !pwr1_on_smc17);
endsequence


property p_power_down_smc17;
   @(posedge pclk17)
    $rose(gate_clk_smc17) |=> s_power_down_smc17;
endproperty

output_power_down_smc17:
  assert property (p_power_down_smc17);


// Power17 UP17 SMC17
// Sequence starts with , Rising17 edge of pwr1_on_smc17.
// Two17 clock17 cycle after this, isolate_smc17 should become17 LOW17 
// On17 the following17 clk17 gate_clk_smc17 should go17 low17.
// 5 cycles17 after  Rising17 edge of pwr1_on_smc17, rstn_non_srpg_smc17
// should become17 HIGH17
sequence s_power_up_smc17;
##30 (pwr1_on_smc17 & !isolate_smc17 & gate_clk_smc17 & !rstn_non_srpg_smc17) 
##1 (pwr1_on_smc17 & !isolate_smc17 & !gate_clk_smc17 & !rstn_non_srpg_smc17) 
##2 (pwr1_on_smc17 & !isolate_smc17 & !gate_clk_smc17 & rstn_non_srpg_smc17);
endsequence

property p_power_up_smc17;
   @(posedge pclk17)
  disable iff(!nprst17)
    (!pwr1_on_smc17 ##1 pwr1_on_smc17) |=> s_power_up_smc17;
endproperty

output_power_up_smc17:
  assert property (p_power_up_smc17);


// COVER17 SMC17 POWER17 DOWN17 AND17 UP17
cover_power_down_up_smc17: cover property (@(posedge pclk17)
(s_power_down_smc17 ##[5:180] s_power_up_smc17));



// COVER17 UART17 POWER17 DOWN17 AND17 UP17
cover_power_down_up_urt17: cover property (@(posedge pclk17)
(s_power_down_urt17 ##[5:180] s_power_up_urt17));

cover_power_down_urt17: cover property (@(posedge pclk17)
(s_power_down_urt17));

cover_power_up_urt17: cover property (@(posedge pclk17)
(s_power_up_urt17));




`ifdef PCM_ABV_ON17
//------------------------------------------------------------------------------
// Power17 Controller17 Formal17 Verification17 component.  Each power17 domain has a 
// separate17 instantiation17
//------------------------------------------------------------------------------

// need to assume that CPU17 will leave17 a minimum time between powering17 down and 
// back up.  In this example17, 10clks has been selected.
// psl17 config_min_uart_pd_time17 : assume always {rose17(L1_ctrl_domain17[1])} |-> { L1_ctrl_domain17[1][*10] } abort17(~nprst17);
// psl17 config_min_uart_pu_time17 : assume always {fell17(L1_ctrl_domain17[1])} |-> { !L1_ctrl_domain17[1][*10] } abort17(~nprst17);
// psl17 config_min_smc_pd_time17 : assume always {rose17(L1_ctrl_domain17[2])} |-> { L1_ctrl_domain17[2][*10] } abort17(~nprst17);
// psl17 config_min_smc_pu_time17 : assume always {fell17(L1_ctrl_domain17[2])} |-> { !L1_ctrl_domain17[2][*10] } abort17(~nprst17);

// UART17 VCOMP17 parameters17
   defparam i_uart_vcomp_domain17.ENABLE_SAVE_RESTORE_EDGE17   = 1;
   defparam i_uart_vcomp_domain17.ENABLE_EXT_PWR_CNTRL17       = 1;
   defparam i_uart_vcomp_domain17.REF_CLK_DEFINED17            = 0;
   defparam i_uart_vcomp_domain17.MIN_SHUTOFF_CYCLES17         = 4;
   defparam i_uart_vcomp_domain17.MIN_RESTORE_TO_ISO_CYCLES17  = 0;
   defparam i_uart_vcomp_domain17.MIN_SAVE_TO_SHUTOFF_CYCLES17 = 1;


   vcomp_domain17 i_uart_vcomp_domain17
   ( .ref_clk17(pclk17),
     .start_lps17(L1_ctrl_domain17[1] || !rstn_non_srpg_urt17),
     .rst_n17(nprst17),
     .ext_power_down17(L1_ctrl_domain17[1]),
     .iso_en17(isolate_urt17),
     .save_edge17(save_edge_urt17),
     .restore_edge17(restore_edge_urt17),
     .domain_shut_off17(pwr1_off_urt17),
     .domain_clk17(!gate_clk_urt17 && pclk17)
   );


// SMC17 VCOMP17 parameters17
   defparam i_smc_vcomp_domain17.ENABLE_SAVE_RESTORE_EDGE17   = 1;
   defparam i_smc_vcomp_domain17.ENABLE_EXT_PWR_CNTRL17       = 1;
   defparam i_smc_vcomp_domain17.REF_CLK_DEFINED17            = 0;
   defparam i_smc_vcomp_domain17.MIN_SHUTOFF_CYCLES17         = 4;
   defparam i_smc_vcomp_domain17.MIN_RESTORE_TO_ISO_CYCLES17  = 0;
   defparam i_smc_vcomp_domain17.MIN_SAVE_TO_SHUTOFF_CYCLES17 = 1;


   vcomp_domain17 i_smc_vcomp_domain17
   ( .ref_clk17(pclk17),
     .start_lps17(L1_ctrl_domain17[2] || !rstn_non_srpg_smc17),
     .rst_n17(nprst17),
     .ext_power_down17(L1_ctrl_domain17[2]),
     .iso_en17(isolate_smc17),
     .save_edge17(save_edge_smc17),
     .restore_edge17(restore_edge_smc17),
     .domain_shut_off17(pwr1_off_smc17),
     .domain_clk17(!gate_clk_smc17 && pclk17)
   );

`endif

`endif



endmodule
