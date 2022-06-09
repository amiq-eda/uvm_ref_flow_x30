//File12 name   : power_ctrl12.v
//Title12       : Power12 Control12 Module12
//Created12     : 1999
//Description12 : Top12 level of power12 controller12
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

module power_ctrl12 (


    // Clocks12 & Reset12
    pclk12,
    nprst12,
    // APB12 programming12 interface
    paddr12,
    psel12,
    penable12,
    pwrite12,
    pwdata12,
    prdata12,
    // mac12 i/f,
    macb3_wakeup12,
    macb2_wakeup12,
    macb1_wakeup12,
    macb0_wakeup12,
    // Scan12 
    scan_in12,
    scan_en12,
    scan_mode12,
    scan_out12,
    // Module12 control12 outputs12
    int_source_h12,
    // SMC12
    rstn_non_srpg_smc12,
    gate_clk_smc12,
    isolate_smc12,
    save_edge_smc12,
    restore_edge_smc12,
    pwr1_on_smc12,
    pwr2_on_smc12,
    pwr1_off_smc12,
    pwr2_off_smc12,
    // URT12
    rstn_non_srpg_urt12,
    gate_clk_urt12,
    isolate_urt12,
    save_edge_urt12,
    restore_edge_urt12,
    pwr1_on_urt12,
    pwr2_on_urt12,
    pwr1_off_urt12,      
    pwr2_off_urt12,
    // ETH012
    rstn_non_srpg_macb012,
    gate_clk_macb012,
    isolate_macb012,
    save_edge_macb012,
    restore_edge_macb012,
    pwr1_on_macb012,
    pwr2_on_macb012,
    pwr1_off_macb012,      
    pwr2_off_macb012,
    // ETH112
    rstn_non_srpg_macb112,
    gate_clk_macb112,
    isolate_macb112,
    save_edge_macb112,
    restore_edge_macb112,
    pwr1_on_macb112,
    pwr2_on_macb112,
    pwr1_off_macb112,      
    pwr2_off_macb112,
    // ETH212
    rstn_non_srpg_macb212,
    gate_clk_macb212,
    isolate_macb212,
    save_edge_macb212,
    restore_edge_macb212,
    pwr1_on_macb212,
    pwr2_on_macb212,
    pwr1_off_macb212,      
    pwr2_off_macb212,
    // ETH312
    rstn_non_srpg_macb312,
    gate_clk_macb312,
    isolate_macb312,
    save_edge_macb312,
    restore_edge_macb312,
    pwr1_on_macb312,
    pwr2_on_macb312,
    pwr1_off_macb312,      
    pwr2_off_macb312,
    // DMA12
    rstn_non_srpg_dma12,
    gate_clk_dma12,
    isolate_dma12,
    save_edge_dma12,
    restore_edge_dma12,
    pwr1_on_dma12,
    pwr2_on_dma12,
    pwr1_off_dma12,      
    pwr2_off_dma12,
    // CPU12
    rstn_non_srpg_cpu12,
    gate_clk_cpu12,
    isolate_cpu12,
    save_edge_cpu12,
    restore_edge_cpu12,
    pwr1_on_cpu12,
    pwr2_on_cpu12,
    pwr1_off_cpu12,      
    pwr2_off_cpu12,
    // ALUT12
    rstn_non_srpg_alut12,
    gate_clk_alut12,
    isolate_alut12,
    save_edge_alut12,
    restore_edge_alut12,
    pwr1_on_alut12,
    pwr2_on_alut12,
    pwr1_off_alut12,      
    pwr2_off_alut12,
    // MEM12
    rstn_non_srpg_mem12,
    gate_clk_mem12,
    isolate_mem12,
    save_edge_mem12,
    restore_edge_mem12,
    pwr1_on_mem12,
    pwr2_on_mem12,
    pwr1_off_mem12,      
    pwr2_off_mem12,
    // core12 dvfs12 transitions12
    core06v12,
    core08v12,
    core10v12,
    core12v12,
    pcm_macb_wakeup_int12,
    // mte12 signals12
    mte_smc_start12,
    mte_uart_start12,
    mte_smc_uart_start12,  
    mte_pm_smc_to_default_start12, 
    mte_pm_uart_to_default_start12,
    mte_pm_smc_uart_to_default_start12

  );

  parameter STATE_IDLE_12V12 = 4'b0001;
  parameter STATE_06V12 = 4'b0010;
  parameter STATE_08V12 = 4'b0100;
  parameter STATE_10V12 = 4'b1000;

    // Clocks12 & Reset12
    input pclk12;
    input nprst12;
    // APB12 programming12 interface
    input [31:0] paddr12;
    input psel12  ;
    input penable12;
    input pwrite12 ;
    input [31:0] pwdata12;
    output [31:0] prdata12;
    // mac12
    input macb3_wakeup12;
    input macb2_wakeup12;
    input macb1_wakeup12;
    input macb0_wakeup12;
    // Scan12 
    input scan_in12;
    input scan_en12;
    input scan_mode12;
    output scan_out12;
    // Module12 control12 outputs12
    input int_source_h12;
    // SMC12
    output rstn_non_srpg_smc12 ;
    output gate_clk_smc12   ;
    output isolate_smc12   ;
    output save_edge_smc12   ;
    output restore_edge_smc12   ;
    output pwr1_on_smc12   ;
    output pwr2_on_smc12   ;
    output pwr1_off_smc12  ;
    output pwr2_off_smc12  ;
    // URT12
    output rstn_non_srpg_urt12 ;
    output gate_clk_urt12      ;
    output isolate_urt12       ;
    output save_edge_urt12   ;
    output restore_edge_urt12   ;
    output pwr1_on_urt12       ;
    output pwr2_on_urt12       ;
    output pwr1_off_urt12      ;
    output pwr2_off_urt12      ;
    // ETH012
    output rstn_non_srpg_macb012 ;
    output gate_clk_macb012      ;
    output isolate_macb012       ;
    output save_edge_macb012   ;
    output restore_edge_macb012   ;
    output pwr1_on_macb012       ;
    output pwr2_on_macb012       ;
    output pwr1_off_macb012      ;
    output pwr2_off_macb012      ;
    // ETH112
    output rstn_non_srpg_macb112 ;
    output gate_clk_macb112      ;
    output isolate_macb112       ;
    output save_edge_macb112   ;
    output restore_edge_macb112   ;
    output pwr1_on_macb112       ;
    output pwr2_on_macb112       ;
    output pwr1_off_macb112      ;
    output pwr2_off_macb112      ;
    // ETH212
    output rstn_non_srpg_macb212 ;
    output gate_clk_macb212      ;
    output isolate_macb212       ;
    output save_edge_macb212   ;
    output restore_edge_macb212   ;
    output pwr1_on_macb212       ;
    output pwr2_on_macb212       ;
    output pwr1_off_macb212      ;
    output pwr2_off_macb212      ;
    // ETH312
    output rstn_non_srpg_macb312 ;
    output gate_clk_macb312      ;
    output isolate_macb312       ;
    output save_edge_macb312   ;
    output restore_edge_macb312   ;
    output pwr1_on_macb312       ;
    output pwr2_on_macb312       ;
    output pwr1_off_macb312      ;
    output pwr2_off_macb312      ;
    // DMA12
    output rstn_non_srpg_dma12 ;
    output gate_clk_dma12      ;
    output isolate_dma12       ;
    output save_edge_dma12   ;
    output restore_edge_dma12   ;
    output pwr1_on_dma12       ;
    output pwr2_on_dma12       ;
    output pwr1_off_dma12      ;
    output pwr2_off_dma12      ;
    // CPU12
    output rstn_non_srpg_cpu12 ;
    output gate_clk_cpu12      ;
    output isolate_cpu12       ;
    output save_edge_cpu12   ;
    output restore_edge_cpu12   ;
    output pwr1_on_cpu12       ;
    output pwr2_on_cpu12       ;
    output pwr1_off_cpu12      ;
    output pwr2_off_cpu12      ;
    // ALUT12
    output rstn_non_srpg_alut12 ;
    output gate_clk_alut12      ;
    output isolate_alut12       ;
    output save_edge_alut12   ;
    output restore_edge_alut12   ;
    output pwr1_on_alut12       ;
    output pwr2_on_alut12       ;
    output pwr1_off_alut12      ;
    output pwr2_off_alut12      ;
    // MEM12
    output rstn_non_srpg_mem12 ;
    output gate_clk_mem12      ;
    output isolate_mem12       ;
    output save_edge_mem12   ;
    output restore_edge_mem12   ;
    output pwr1_on_mem12       ;
    output pwr2_on_mem12       ;
    output pwr1_off_mem12      ;
    output pwr2_off_mem12      ;


   // core12 transitions12 o/p
    output core06v12;
    output core08v12;
    output core10v12;
    output core12v12;
    output pcm_macb_wakeup_int12 ;
    //mode mte12  signals12
    output mte_smc_start12;
    output mte_uart_start12;
    output mte_smc_uart_start12;  
    output mte_pm_smc_to_default_start12; 
    output mte_pm_uart_to_default_start12;
    output mte_pm_smc_uart_to_default_start12;

    reg mte_smc_start12;
    reg mte_uart_start12;
    reg mte_smc_uart_start12;  
    reg mte_pm_smc_to_default_start12; 
    reg mte_pm_uart_to_default_start12;
    reg mte_pm_smc_uart_to_default_start12;

    reg [31:0] prdata12;

  wire valid_reg_write12  ;
  wire valid_reg_read12   ;
  wire L1_ctrl_access12   ;
  wire L1_status_access12 ;
  wire pcm_int_mask_access12;
  wire pcm_int_status_access12;
  wire standby_mem012      ;
  wire standby_mem112      ;
  wire standby_mem212      ;
  wire standby_mem312      ;
  wire pwr1_off_mem012;
  wire pwr1_off_mem112;
  wire pwr1_off_mem212;
  wire pwr1_off_mem312;
  
  // Control12 signals12
  wire set_status_smc12   ;
  wire clr_status_smc12   ;
  wire set_status_urt12   ;
  wire clr_status_urt12   ;
  wire set_status_macb012   ;
  wire clr_status_macb012   ;
  wire set_status_macb112   ;
  wire clr_status_macb112   ;
  wire set_status_macb212   ;
  wire clr_status_macb212   ;
  wire set_status_macb312   ;
  wire clr_status_macb312   ;
  wire set_status_dma12   ;
  wire clr_status_dma12   ;
  wire set_status_cpu12   ;
  wire clr_status_cpu12   ;
  wire set_status_alut12   ;
  wire clr_status_alut12   ;
  wire set_status_mem12   ;
  wire clr_status_mem12   ;


  // Status and Control12 registers
  reg [31:0]  L1_status_reg12;
  reg  [31:0] L1_ctrl_reg12  ;
  reg  [31:0] L1_ctrl_domain12  ;
  reg L1_ctrl_cpu_off_reg12;
  reg [31:0]  pcm_mask_reg12;
  reg [31:0]  pcm_status_reg12;

  // Signals12 gated12 in scan_mode12
  //SMC12
  wire  rstn_non_srpg_smc_int12;
  wire  gate_clk_smc_int12    ;     
  wire  isolate_smc_int12    ;       
  wire save_edge_smc_int12;
  wire restore_edge_smc_int12;
  wire  pwr1_on_smc_int12    ;      
  wire  pwr2_on_smc_int12    ;      


  //URT12
  wire   rstn_non_srpg_urt_int12;
  wire   gate_clk_urt_int12     ;     
  wire   isolate_urt_int12      ;       
  wire save_edge_urt_int12;
  wire restore_edge_urt_int12;
  wire   pwr1_on_urt_int12      ;      
  wire   pwr2_on_urt_int12      ;      

  // ETH012
  wire   rstn_non_srpg_macb0_int12;
  wire   gate_clk_macb0_int12     ;     
  wire   isolate_macb0_int12      ;       
  wire save_edge_macb0_int12;
  wire restore_edge_macb0_int12;
  wire   pwr1_on_macb0_int12      ;      
  wire   pwr2_on_macb0_int12      ;      
  // ETH112
  wire   rstn_non_srpg_macb1_int12;
  wire   gate_clk_macb1_int12     ;     
  wire   isolate_macb1_int12      ;       
  wire save_edge_macb1_int12;
  wire restore_edge_macb1_int12;
  wire   pwr1_on_macb1_int12      ;      
  wire   pwr2_on_macb1_int12      ;      
  // ETH212
  wire   rstn_non_srpg_macb2_int12;
  wire   gate_clk_macb2_int12     ;     
  wire   isolate_macb2_int12      ;       
  wire save_edge_macb2_int12;
  wire restore_edge_macb2_int12;
  wire   pwr1_on_macb2_int12      ;      
  wire   pwr2_on_macb2_int12      ;      
  // ETH312
  wire   rstn_non_srpg_macb3_int12;
  wire   gate_clk_macb3_int12     ;     
  wire   isolate_macb3_int12      ;       
  wire save_edge_macb3_int12;
  wire restore_edge_macb3_int12;
  wire   pwr1_on_macb3_int12      ;      
  wire   pwr2_on_macb3_int12      ;      

  // DMA12
  wire   rstn_non_srpg_dma_int12;
  wire   gate_clk_dma_int12     ;     
  wire   isolate_dma_int12      ;       
  wire save_edge_dma_int12;
  wire restore_edge_dma_int12;
  wire   pwr1_on_dma_int12      ;      
  wire   pwr2_on_dma_int12      ;      

  // CPU12
  wire   rstn_non_srpg_cpu_int12;
  wire   gate_clk_cpu_int12     ;     
  wire   isolate_cpu_int12      ;       
  wire save_edge_cpu_int12;
  wire restore_edge_cpu_int12;
  wire   pwr1_on_cpu_int12      ;      
  wire   pwr2_on_cpu_int12      ;  
  wire L1_ctrl_cpu_off_p12;    

  reg save_alut_tmp12;
  // DFS12 sm12

  reg cpu_shutoff_ctrl12;

  reg mte_mac_off_start12, mte_mac012_start12, mte_mac013_start12, mte_mac023_start12, mte_mac123_start12;
  reg mte_mac01_start12, mte_mac02_start12, mte_mac03_start12, mte_mac12_start12, mte_mac13_start12, mte_mac23_start12;
  reg mte_mac0_start12, mte_mac1_start12, mte_mac2_start12, mte_mac3_start12;
  reg mte_sys_hibernate12 ;
  reg mte_dma_start12 ;
  reg mte_cpu_start12 ;
  reg mte_mac_off_sleep_start12, mte_mac012_sleep_start12, mte_mac013_sleep_start12, mte_mac023_sleep_start12, mte_mac123_sleep_start12;
  reg mte_mac01_sleep_start12, mte_mac02_sleep_start12, mte_mac03_sleep_start12, mte_mac12_sleep_start12, mte_mac13_sleep_start12, mte_mac23_sleep_start12;
  reg mte_mac0_sleep_start12, mte_mac1_sleep_start12, mte_mac2_sleep_start12, mte_mac3_sleep_start12;
  reg mte_dma_sleep_start12;
  reg mte_mac_off_to_default12, mte_mac012_to_default12, mte_mac013_to_default12, mte_mac023_to_default12, mte_mac123_to_default12;
  reg mte_mac01_to_default12, mte_mac02_to_default12, mte_mac03_to_default12, mte_mac12_to_default12, mte_mac13_to_default12, mte_mac23_to_default12;
  reg mte_mac0_to_default12, mte_mac1_to_default12, mte_mac2_to_default12, mte_mac3_to_default12;
  reg mte_dma_isolate_dis12;
  reg mte_cpu_isolate_dis12;
  reg mte_sys_hibernate_to_default12;


  // Latch12 the CPU12 SLEEP12 invocation12
  always @( posedge pclk12 or negedge nprst12) 
  begin
    if(!nprst12)
      L1_ctrl_cpu_off_reg12 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg12 <= L1_ctrl_domain12[8];
  end

  // Create12 a pulse12 for sleep12 detection12 
  assign L1_ctrl_cpu_off_p12 =  L1_ctrl_domain12[8] && !L1_ctrl_cpu_off_reg12;
  
  // CPU12 sleep12 contol12 logic 
  // Shut12 off12 CPU12 when L1_ctrl_cpu_off_p12 is set
  // wake12 cpu12 when any interrupt12 is seen12  
  always @( posedge pclk12 or negedge nprst12) 
  begin
    if(!nprst12)
     cpu_shutoff_ctrl12 <= 1'b0;
    else if(cpu_shutoff_ctrl12 && int_source_h12)
     cpu_shutoff_ctrl12 <= 1'b0;
    else if (L1_ctrl_cpu_off_p12)
     cpu_shutoff_ctrl12 <= 1'b1;
  end
 
  // instantiate12 power12 contol12  block for uart12
  power_ctrl_sm12 i_urt_power_ctrl_sm12(
    .pclk12(pclk12),
    .nprst12(nprst12),
    .L1_module_req12(L1_ctrl_domain12[1]),
    .set_status_module12(set_status_urt12),
    .clr_status_module12(clr_status_urt12),
    .rstn_non_srpg_module12(rstn_non_srpg_urt_int12),
    .gate_clk_module12(gate_clk_urt_int12),
    .isolate_module12(isolate_urt_int12),
    .save_edge12(save_edge_urt_int12),
    .restore_edge12(restore_edge_urt_int12),
    .pwr1_on12(pwr1_on_urt_int12),
    .pwr2_on12(pwr2_on_urt_int12)
    );
  

  // instantiate12 power12 contol12  block for smc12
  power_ctrl_sm12 i_smc_power_ctrl_sm12(
    .pclk12(pclk12),
    .nprst12(nprst12),
    .L1_module_req12(L1_ctrl_domain12[2]),
    .set_status_module12(set_status_smc12),
    .clr_status_module12(clr_status_smc12),
    .rstn_non_srpg_module12(rstn_non_srpg_smc_int12),
    .gate_clk_module12(gate_clk_smc_int12),
    .isolate_module12(isolate_smc_int12),
    .save_edge12(save_edge_smc_int12),
    .restore_edge12(restore_edge_smc_int12),
    .pwr1_on12(pwr1_on_smc_int12),
    .pwr2_on12(pwr2_on_smc_int12)
    );

  // power12 control12 for macb012
  power_ctrl_sm12 i_macb0_power_ctrl_sm12(
    .pclk12(pclk12),
    .nprst12(nprst12),
    .L1_module_req12(L1_ctrl_domain12[3]),
    .set_status_module12(set_status_macb012),
    .clr_status_module12(clr_status_macb012),
    .rstn_non_srpg_module12(rstn_non_srpg_macb0_int12),
    .gate_clk_module12(gate_clk_macb0_int12),
    .isolate_module12(isolate_macb0_int12),
    .save_edge12(save_edge_macb0_int12),
    .restore_edge12(restore_edge_macb0_int12),
    .pwr1_on12(pwr1_on_macb0_int12),
    .pwr2_on12(pwr2_on_macb0_int12)
    );
  // power12 control12 for macb112
  power_ctrl_sm12 i_macb1_power_ctrl_sm12(
    .pclk12(pclk12),
    .nprst12(nprst12),
    .L1_module_req12(L1_ctrl_domain12[4]),
    .set_status_module12(set_status_macb112),
    .clr_status_module12(clr_status_macb112),
    .rstn_non_srpg_module12(rstn_non_srpg_macb1_int12),
    .gate_clk_module12(gate_clk_macb1_int12),
    .isolate_module12(isolate_macb1_int12),
    .save_edge12(save_edge_macb1_int12),
    .restore_edge12(restore_edge_macb1_int12),
    .pwr1_on12(pwr1_on_macb1_int12),
    .pwr2_on12(pwr2_on_macb1_int12)
    );
  // power12 control12 for macb212
  power_ctrl_sm12 i_macb2_power_ctrl_sm12(
    .pclk12(pclk12),
    .nprst12(nprst12),
    .L1_module_req12(L1_ctrl_domain12[5]),
    .set_status_module12(set_status_macb212),
    .clr_status_module12(clr_status_macb212),
    .rstn_non_srpg_module12(rstn_non_srpg_macb2_int12),
    .gate_clk_module12(gate_clk_macb2_int12),
    .isolate_module12(isolate_macb2_int12),
    .save_edge12(save_edge_macb2_int12),
    .restore_edge12(restore_edge_macb2_int12),
    .pwr1_on12(pwr1_on_macb2_int12),
    .pwr2_on12(pwr2_on_macb2_int12)
    );
  // power12 control12 for macb312
  power_ctrl_sm12 i_macb3_power_ctrl_sm12(
    .pclk12(pclk12),
    .nprst12(nprst12),
    .L1_module_req12(L1_ctrl_domain12[6]),
    .set_status_module12(set_status_macb312),
    .clr_status_module12(clr_status_macb312),
    .rstn_non_srpg_module12(rstn_non_srpg_macb3_int12),
    .gate_clk_module12(gate_clk_macb3_int12),
    .isolate_module12(isolate_macb3_int12),
    .save_edge12(save_edge_macb3_int12),
    .restore_edge12(restore_edge_macb3_int12),
    .pwr1_on12(pwr1_on_macb3_int12),
    .pwr2_on12(pwr2_on_macb3_int12)
    );
  // power12 control12 for dma12
  power_ctrl_sm12 i_dma_power_ctrl_sm12(
    .pclk12(pclk12),
    .nprst12(nprst12),
    .L1_module_req12(L1_ctrl_domain12[7]),
    .set_status_module12(set_status_dma12),
    .clr_status_module12(clr_status_dma12),
    .rstn_non_srpg_module12(rstn_non_srpg_dma_int12),
    .gate_clk_module12(gate_clk_dma_int12),
    .isolate_module12(isolate_dma_int12),
    .save_edge12(save_edge_dma_int12),
    .restore_edge12(restore_edge_dma_int12),
    .pwr1_on12(pwr1_on_dma_int12),
    .pwr2_on12(pwr2_on_dma_int12)
    );
  // power12 control12 for CPU12
  power_ctrl_sm12 i_cpu_power_ctrl_sm12(
    .pclk12(pclk12),
    .nprst12(nprst12),
    .L1_module_req12(cpu_shutoff_ctrl12),
    .set_status_module12(set_status_cpu12),
    .clr_status_module12(clr_status_cpu12),
    .rstn_non_srpg_module12(rstn_non_srpg_cpu_int12),
    .gate_clk_module12(gate_clk_cpu_int12),
    .isolate_module12(isolate_cpu_int12),
    .save_edge12(save_edge_cpu_int12),
    .restore_edge12(restore_edge_cpu_int12),
    .pwr1_on12(pwr1_on_cpu_int12),
    .pwr2_on12(pwr2_on_cpu_int12)
    );

  assign valid_reg_write12 =  (psel12 && pwrite12 && penable12);
  assign valid_reg_read12  =  (psel12 && (!pwrite12) && penable12);

  assign L1_ctrl_access12  =  (paddr12[15:0] == 16'b0000000000000100); 
  assign L1_status_access12 = (paddr12[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access12 =   (paddr12[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access12 = (paddr12[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control12 and status register
  always @(*)
  begin  
    if(valid_reg_read12 && L1_ctrl_access12) 
      prdata12 = L1_ctrl_reg12;
    else if (valid_reg_read12 && L1_status_access12)
      prdata12 = L1_status_reg12;
    else if (valid_reg_read12 && pcm_int_mask_access12)
      prdata12 = pcm_mask_reg12;
    else if (valid_reg_read12 && pcm_int_status_access12)
      prdata12 = pcm_status_reg12;
    else 
      prdata12 = 0;
  end

  assign set_status_mem12 =  (set_status_macb012 && set_status_macb112 && set_status_macb212 &&
                            set_status_macb312 && set_status_dma12 && set_status_cpu12);

  assign clr_status_mem12 =  (clr_status_macb012 && clr_status_macb112 && clr_status_macb212 &&
                            clr_status_macb312 && clr_status_dma12 && clr_status_cpu12);

  assign set_status_alut12 = (set_status_macb012 && set_status_macb112 && set_status_macb212 && set_status_macb312);

  assign clr_status_alut12 = (clr_status_macb012 || clr_status_macb112 || clr_status_macb212  || clr_status_macb312);

  // Write accesses to the control12 and status register
 
  always @(posedge pclk12 or negedge nprst12)
  begin
    if (!nprst12) begin
      L1_ctrl_reg12   <= 0;
      L1_status_reg12 <= 0;
      pcm_mask_reg12 <= 0;
    end else begin
      // CTRL12 reg updates12
      if (valid_reg_write12 && L1_ctrl_access12) 
        L1_ctrl_reg12 <= pwdata12; // Writes12 to the ctrl12 reg
      if (valid_reg_write12 && pcm_int_mask_access12) 
        pcm_mask_reg12 <= pwdata12; // Writes12 to the ctrl12 reg

      if (set_status_urt12 == 1'b1)  
        L1_status_reg12[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt12 == 1'b1) 
        L1_status_reg12[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc12 == 1'b1) 
        L1_status_reg12[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc12 == 1'b1) 
        L1_status_reg12[2] <= 1'b0; // Clear the status bit

      if (set_status_macb012 == 1'b1)  
        L1_status_reg12[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb012 == 1'b1) 
        L1_status_reg12[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb112 == 1'b1)  
        L1_status_reg12[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb112 == 1'b1) 
        L1_status_reg12[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb212 == 1'b1)  
        L1_status_reg12[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb212 == 1'b1) 
        L1_status_reg12[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb312 == 1'b1)  
        L1_status_reg12[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb312 == 1'b1) 
        L1_status_reg12[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma12 == 1'b1)  
        L1_status_reg12[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma12 == 1'b1) 
        L1_status_reg12[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu12 == 1'b1)  
        L1_status_reg12[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu12 == 1'b1) 
        L1_status_reg12[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut12 == 1'b1)  
        L1_status_reg12[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut12 == 1'b1) 
        L1_status_reg12[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem12 == 1'b1)  
        L1_status_reg12[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem12 == 1'b1) 
        L1_status_reg12[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused12 bits of pcm_status_reg12 are tied12 to 0
  always @(posedge pclk12 or negedge nprst12)
  begin
    if (!nprst12)
      pcm_status_reg12[31:4] <= 'b0;
    else  
      pcm_status_reg12[31:4] <= pcm_status_reg12[31:4];
  end
  
  // interrupt12 only of h/w assisted12 wakeup
  // MAC12 3
  always @(posedge pclk12 or negedge nprst12)
  begin
    if(!nprst12)
      pcm_status_reg12[3] <= 1'b0;
    else if (valid_reg_write12 && pcm_int_status_access12) 
      pcm_status_reg12[3] <= pwdata12[3];
    else if (macb3_wakeup12 & ~pcm_mask_reg12[3])
      pcm_status_reg12[3] <= 1'b1;
    else if (valid_reg_read12 && pcm_int_status_access12) 
      pcm_status_reg12[3] <= 1'b0;
    else
      pcm_status_reg12[3] <= pcm_status_reg12[3];
  end  
   
  // MAC12 2
  always @(posedge pclk12 or negedge nprst12)
  begin
    if(!nprst12)
      pcm_status_reg12[2] <= 1'b0;
    else if (valid_reg_write12 && pcm_int_status_access12) 
      pcm_status_reg12[2] <= pwdata12[2];
    else if (macb2_wakeup12 & ~pcm_mask_reg12[2])
      pcm_status_reg12[2] <= 1'b1;
    else if (valid_reg_read12 && pcm_int_status_access12) 
      pcm_status_reg12[2] <= 1'b0;
    else
      pcm_status_reg12[2] <= pcm_status_reg12[2];
  end  

  // MAC12 1
  always @(posedge pclk12 or negedge nprst12)
  begin
    if(!nprst12)
      pcm_status_reg12[1] <= 1'b0;
    else if (valid_reg_write12 && pcm_int_status_access12) 
      pcm_status_reg12[1] <= pwdata12[1];
    else if (macb1_wakeup12 & ~pcm_mask_reg12[1])
      pcm_status_reg12[1] <= 1'b1;
    else if (valid_reg_read12 && pcm_int_status_access12) 
      pcm_status_reg12[1] <= 1'b0;
    else
      pcm_status_reg12[1] <= pcm_status_reg12[1];
  end  
   
  // MAC12 0
  always @(posedge pclk12 or negedge nprst12)
  begin
    if(!nprst12)
      pcm_status_reg12[0] <= 1'b0;
    else if (valid_reg_write12 && pcm_int_status_access12) 
      pcm_status_reg12[0] <= pwdata12[0];
    else if (macb0_wakeup12 & ~pcm_mask_reg12[0])
      pcm_status_reg12[0] <= 1'b1;
    else if (valid_reg_read12 && pcm_int_status_access12) 
      pcm_status_reg12[0] <= 1'b0;
    else
      pcm_status_reg12[0] <= pcm_status_reg12[0];
  end  

  assign pcm_macb_wakeup_int12 = |pcm_status_reg12;

  reg [31:0] L1_ctrl_reg112;
  always @(posedge pclk12 or negedge nprst12)
  begin
    if(!nprst12)
      L1_ctrl_reg112 <= 0;
    else
      L1_ctrl_reg112 <= L1_ctrl_reg12;
  end

  // Program12 mode decode
  always @(L1_ctrl_reg12 or L1_ctrl_reg112 or int_source_h12 or cpu_shutoff_ctrl12) begin
    mte_smc_start12 = 0;
    mte_uart_start12 = 0;
    mte_smc_uart_start12  = 0;
    mte_mac_off_start12  = 0;
    mte_mac012_start12 = 0;
    mte_mac013_start12 = 0;
    mte_mac023_start12 = 0;
    mte_mac123_start12 = 0;
    mte_mac01_start12 = 0;
    mte_mac02_start12 = 0;
    mte_mac03_start12 = 0;
    mte_mac12_start12 = 0;
    mte_mac13_start12 = 0;
    mte_mac23_start12 = 0;
    mte_mac0_start12 = 0;
    mte_mac1_start12 = 0;
    mte_mac2_start12 = 0;
    mte_mac3_start12 = 0;
    mte_sys_hibernate12 = 0 ;
    mte_dma_start12 = 0 ;
    mte_cpu_start12 = 0 ;

    mte_mac0_sleep_start12 = (L1_ctrl_reg12 ==  'h14) && (L1_ctrl_reg112 == 'h4 );
    mte_mac1_sleep_start12 = (L1_ctrl_reg12 ==  'h14) && (L1_ctrl_reg112 == 'h5 ); 
    mte_mac2_sleep_start12 = (L1_ctrl_reg12 ==  'h14) && (L1_ctrl_reg112 == 'h6 ); 
    mte_mac3_sleep_start12 = (L1_ctrl_reg12 ==  'h14) && (L1_ctrl_reg112 == 'h7 ); 
    mte_mac01_sleep_start12 = (L1_ctrl_reg12 ==  'h14) && (L1_ctrl_reg112 == 'h8 ); 
    mte_mac02_sleep_start12 = (L1_ctrl_reg12 ==  'h14) && (L1_ctrl_reg112 == 'h9 ); 
    mte_mac03_sleep_start12 = (L1_ctrl_reg12 ==  'h14) && (L1_ctrl_reg112 == 'hA ); 
    mte_mac12_sleep_start12 = (L1_ctrl_reg12 ==  'h14) && (L1_ctrl_reg112 == 'hB ); 
    mte_mac13_sleep_start12 = (L1_ctrl_reg12 ==  'h14) && (L1_ctrl_reg112 == 'hC ); 
    mte_mac23_sleep_start12 = (L1_ctrl_reg12 ==  'h14) && (L1_ctrl_reg112 == 'hD ); 
    mte_mac012_sleep_start12 = (L1_ctrl_reg12 ==  'h14) && (L1_ctrl_reg112 == 'hE ); 
    mte_mac013_sleep_start12 = (L1_ctrl_reg12 ==  'h14) && (L1_ctrl_reg112 == 'hF ); 
    mte_mac023_sleep_start12 = (L1_ctrl_reg12 ==  'h14) && (L1_ctrl_reg112 == 'h10 ); 
    mte_mac123_sleep_start12 = (L1_ctrl_reg12 ==  'h14) && (L1_ctrl_reg112 == 'h11 ); 
    mte_mac_off_sleep_start12 =  (L1_ctrl_reg12 == 'h14) && (L1_ctrl_reg112 == 'h12 );
    mte_dma_sleep_start12 =  (L1_ctrl_reg12 == 'h14) && (L1_ctrl_reg112 == 'h13 );

    mte_pm_uart_to_default_start12 = (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'h1);
    mte_pm_smc_to_default_start12 = (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'h2);
    mte_pm_smc_uart_to_default_start12 = (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'h3); 
    mte_mac0_to_default12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'h4); 
    mte_mac1_to_default12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'h5); 
    mte_mac2_to_default12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'h6); 
    mte_mac3_to_default12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'h7); 
    mte_mac01_to_default12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'h8); 
    mte_mac02_to_default12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'h9); 
    mte_mac03_to_default12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'hA); 
    mte_mac12_to_default12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'hB); 
    mte_mac13_to_default12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'hC); 
    mte_mac23_to_default12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'hD); 
    mte_mac012_to_default12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'hE); 
    mte_mac013_to_default12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'hF); 
    mte_mac023_to_default12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'h10); 
    mte_mac123_to_default12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'h11); 
    mte_mac_off_to_default12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'h12); 
    mte_dma_isolate_dis12 =  (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'h13); 
    mte_cpu_isolate_dis12 =  (int_source_h12) && (cpu_shutoff_ctrl12) && (L1_ctrl_reg12 != 'h15);
    mte_sys_hibernate_to_default12 = (L1_ctrl_reg12 == 32'h0) && (L1_ctrl_reg112 == 'h15); 

   
    if (L1_ctrl_reg112 == 'h0) begin // This12 check is to make mte_cpu_start12
                                   // is set only when you from default state 
      case (L1_ctrl_reg12)
        'h0 : L1_ctrl_domain12 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain12 = 32'h2; // PM_uart12
                mte_uart_start12 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain12 = 32'h4; // PM_smc12
                mte_smc_start12 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain12 = 32'h6; // PM_smc_uart12
                mte_smc_uart_start12 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain12 = 32'h8; //  PM_macb012
                mte_mac0_start12 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain12 = 32'h10; //  PM_macb112
                mte_mac1_start12 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain12 = 32'h20; //  PM_macb212
                mte_mac2_start12 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain12 = 32'h40; //  PM_macb312
                mte_mac3_start12 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain12 = 32'h18; //  PM_macb0112
                mte_mac01_start12 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain12 = 32'h28; //  PM_macb0212
                mte_mac02_start12 = 1;
              end
        'hA : begin  
                L1_ctrl_domain12 = 32'h48; //  PM_macb0312
                mte_mac03_start12 = 1;
              end
        'hB : begin  
                L1_ctrl_domain12 = 32'h30; //  PM_macb1212
                mte_mac12_start12 = 1;
              end
        'hC : begin  
                L1_ctrl_domain12 = 32'h50; //  PM_macb1312
                mte_mac13_start12 = 1;
              end
        'hD : begin  
                L1_ctrl_domain12 = 32'h60; //  PM_macb2312
                mte_mac23_start12 = 1;
              end
        'hE : begin  
                L1_ctrl_domain12 = 32'h38; //  PM_macb01212
                mte_mac012_start12 = 1;
              end
        'hF : begin  
                L1_ctrl_domain12 = 32'h58; //  PM_macb01312
                mte_mac013_start12 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain12 = 32'h68; //  PM_macb02312
                mte_mac023_start12 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain12 = 32'h70; //  PM_macb12312
                mte_mac123_start12 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain12 = 32'h78; //  PM_macb_off12
                mte_mac_off_start12 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain12 = 32'h80; //  PM_dma12
                mte_dma_start12 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain12 = 32'h100; //  PM_cpu_sleep12
                mte_cpu_start12 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain12 = 32'h1FE; //  PM_hibernate12
                mte_sys_hibernate12 = 1;
              end
         default: L1_ctrl_domain12 = 32'h0;
      endcase
    end
  end


  wire to_default12 = (L1_ctrl_reg12 == 0);

  // Scan12 mode gating12 of power12 and isolation12 control12 signals12
  //SMC12
  assign rstn_non_srpg_smc12  = (scan_mode12 == 1'b0) ? rstn_non_srpg_smc_int12 : 1'b1;  
  assign gate_clk_smc12       = (scan_mode12 == 1'b0) ? gate_clk_smc_int12 : 1'b0;     
  assign isolate_smc12        = (scan_mode12 == 1'b0) ? isolate_smc_int12 : 1'b0;      
  assign pwr1_on_smc12        = (scan_mode12 == 1'b0) ? pwr1_on_smc_int12 : 1'b1;       
  assign pwr2_on_smc12        = (scan_mode12 == 1'b0) ? pwr2_on_smc_int12 : 1'b1;       
  assign pwr1_off_smc12       = (scan_mode12 == 1'b0) ? (!pwr1_on_smc_int12) : 1'b0;       
  assign pwr2_off_smc12       = (scan_mode12 == 1'b0) ? (!pwr2_on_smc_int12) : 1'b0;       
  assign save_edge_smc12       = (scan_mode12 == 1'b0) ? (save_edge_smc_int12) : 1'b0;       
  assign restore_edge_smc12       = (scan_mode12 == 1'b0) ? (restore_edge_smc_int12) : 1'b0;       

  //URT12
  assign rstn_non_srpg_urt12  = (scan_mode12 == 1'b0) ?  rstn_non_srpg_urt_int12 : 1'b1;  
  assign gate_clk_urt12       = (scan_mode12 == 1'b0) ?  gate_clk_urt_int12      : 1'b0;     
  assign isolate_urt12        = (scan_mode12 == 1'b0) ?  isolate_urt_int12       : 1'b0;      
  assign pwr1_on_urt12        = (scan_mode12 == 1'b0) ?  pwr1_on_urt_int12       : 1'b1;       
  assign pwr2_on_urt12        = (scan_mode12 == 1'b0) ?  pwr2_on_urt_int12       : 1'b1;       
  assign pwr1_off_urt12       = (scan_mode12 == 1'b0) ?  (!pwr1_on_urt_int12)  : 1'b0;       
  assign pwr2_off_urt12       = (scan_mode12 == 1'b0) ?  (!pwr2_on_urt_int12)  : 1'b0;       
  assign save_edge_urt12       = (scan_mode12 == 1'b0) ? (save_edge_urt_int12) : 1'b0;       
  assign restore_edge_urt12       = (scan_mode12 == 1'b0) ? (restore_edge_urt_int12) : 1'b0;       

  //ETH012
  assign rstn_non_srpg_macb012 = (scan_mode12 == 1'b0) ?  rstn_non_srpg_macb0_int12 : 1'b1;  
  assign gate_clk_macb012       = (scan_mode12 == 1'b0) ?  gate_clk_macb0_int12      : 1'b0;     
  assign isolate_macb012        = (scan_mode12 == 1'b0) ?  isolate_macb0_int12       : 1'b0;      
  assign pwr1_on_macb012        = (scan_mode12 == 1'b0) ?  pwr1_on_macb0_int12       : 1'b1;       
  assign pwr2_on_macb012        = (scan_mode12 == 1'b0) ?  pwr2_on_macb0_int12       : 1'b1;       
  assign pwr1_off_macb012       = (scan_mode12 == 1'b0) ?  (!pwr1_on_macb0_int12)  : 1'b0;       
  assign pwr2_off_macb012       = (scan_mode12 == 1'b0) ?  (!pwr2_on_macb0_int12)  : 1'b0;       
  assign save_edge_macb012       = (scan_mode12 == 1'b0) ? (save_edge_macb0_int12) : 1'b0;       
  assign restore_edge_macb012       = (scan_mode12 == 1'b0) ? (restore_edge_macb0_int12) : 1'b0;       

  //ETH112
  assign rstn_non_srpg_macb112 = (scan_mode12 == 1'b0) ?  rstn_non_srpg_macb1_int12 : 1'b1;  
  assign gate_clk_macb112       = (scan_mode12 == 1'b0) ?  gate_clk_macb1_int12      : 1'b0;     
  assign isolate_macb112        = (scan_mode12 == 1'b0) ?  isolate_macb1_int12       : 1'b0;      
  assign pwr1_on_macb112        = (scan_mode12 == 1'b0) ?  pwr1_on_macb1_int12       : 1'b1;       
  assign pwr2_on_macb112        = (scan_mode12 == 1'b0) ?  pwr2_on_macb1_int12       : 1'b1;       
  assign pwr1_off_macb112       = (scan_mode12 == 1'b0) ?  (!pwr1_on_macb1_int12)  : 1'b0;       
  assign pwr2_off_macb112       = (scan_mode12 == 1'b0) ?  (!pwr2_on_macb1_int12)  : 1'b0;       
  assign save_edge_macb112       = (scan_mode12 == 1'b0) ? (save_edge_macb1_int12) : 1'b0;       
  assign restore_edge_macb112       = (scan_mode12 == 1'b0) ? (restore_edge_macb1_int12) : 1'b0;       

  //ETH212
  assign rstn_non_srpg_macb212 = (scan_mode12 == 1'b0) ?  rstn_non_srpg_macb2_int12 : 1'b1;  
  assign gate_clk_macb212       = (scan_mode12 == 1'b0) ?  gate_clk_macb2_int12      : 1'b0;     
  assign isolate_macb212        = (scan_mode12 == 1'b0) ?  isolate_macb2_int12       : 1'b0;      
  assign pwr1_on_macb212        = (scan_mode12 == 1'b0) ?  pwr1_on_macb2_int12       : 1'b1;       
  assign pwr2_on_macb212        = (scan_mode12 == 1'b0) ?  pwr2_on_macb2_int12       : 1'b1;       
  assign pwr1_off_macb212       = (scan_mode12 == 1'b0) ?  (!pwr1_on_macb2_int12)  : 1'b0;       
  assign pwr2_off_macb212       = (scan_mode12 == 1'b0) ?  (!pwr2_on_macb2_int12)  : 1'b0;       
  assign save_edge_macb212       = (scan_mode12 == 1'b0) ? (save_edge_macb2_int12) : 1'b0;       
  assign restore_edge_macb212       = (scan_mode12 == 1'b0) ? (restore_edge_macb2_int12) : 1'b0;       

  //ETH312
  assign rstn_non_srpg_macb312 = (scan_mode12 == 1'b0) ?  rstn_non_srpg_macb3_int12 : 1'b1;  
  assign gate_clk_macb312       = (scan_mode12 == 1'b0) ?  gate_clk_macb3_int12      : 1'b0;     
  assign isolate_macb312        = (scan_mode12 == 1'b0) ?  isolate_macb3_int12       : 1'b0;      
  assign pwr1_on_macb312        = (scan_mode12 == 1'b0) ?  pwr1_on_macb3_int12       : 1'b1;       
  assign pwr2_on_macb312        = (scan_mode12 == 1'b0) ?  pwr2_on_macb3_int12       : 1'b1;       
  assign pwr1_off_macb312       = (scan_mode12 == 1'b0) ?  (!pwr1_on_macb3_int12)  : 1'b0;       
  assign pwr2_off_macb312       = (scan_mode12 == 1'b0) ?  (!pwr2_on_macb3_int12)  : 1'b0;       
  assign save_edge_macb312       = (scan_mode12 == 1'b0) ? (save_edge_macb3_int12) : 1'b0;       
  assign restore_edge_macb312       = (scan_mode12 == 1'b0) ? (restore_edge_macb3_int12) : 1'b0;       

  // MEM12
  assign rstn_non_srpg_mem12 =   (rstn_non_srpg_macb012 && rstn_non_srpg_macb112 && rstn_non_srpg_macb212 &&
                                rstn_non_srpg_macb312 && rstn_non_srpg_dma12 && rstn_non_srpg_cpu12 && rstn_non_srpg_urt12 &&
                                rstn_non_srpg_smc12);

  assign gate_clk_mem12 =  (gate_clk_macb012 && gate_clk_macb112 && gate_clk_macb212 &&
                            gate_clk_macb312 && gate_clk_dma12 && gate_clk_cpu12 && gate_clk_urt12 && gate_clk_smc12);

  assign isolate_mem12  = (isolate_macb012 && isolate_macb112 && isolate_macb212 &&
                         isolate_macb312 && isolate_dma12 && isolate_cpu12 && isolate_urt12 && isolate_smc12);


  assign pwr1_on_mem12        =   ~pwr1_off_mem12;

  assign pwr2_on_mem12        =   ~pwr2_off_mem12;

  assign pwr1_off_mem12       =  (pwr1_off_macb012 && pwr1_off_macb112 && pwr1_off_macb212 &&
                                 pwr1_off_macb312 && pwr1_off_dma12 && pwr1_off_cpu12 && pwr1_off_urt12 && pwr1_off_smc12);


  assign pwr2_off_mem12       =  (pwr2_off_macb012 && pwr2_off_macb112 && pwr2_off_macb212 &&
                                pwr2_off_macb312 && pwr2_off_dma12 && pwr2_off_cpu12 && pwr2_off_urt12 && pwr2_off_smc12);

  assign save_edge_mem12      =  (save_edge_macb012 && save_edge_macb112 && save_edge_macb212 &&
                                save_edge_macb312 && save_edge_dma12 && save_edge_cpu12 && save_edge_smc12 && save_edge_urt12);

  assign restore_edge_mem12   =  (restore_edge_macb012 && restore_edge_macb112 && restore_edge_macb212  &&
                                restore_edge_macb312 && restore_edge_dma12 && restore_edge_cpu12 && restore_edge_urt12 &&
                                restore_edge_smc12);

  assign standby_mem012 = pwr1_off_macb012 && (~ (pwr1_off_macb012 && pwr1_off_macb112 && pwr1_off_macb212 && pwr1_off_macb312 && pwr1_off_urt12 && pwr1_off_smc12 && pwr1_off_dma12 && pwr1_off_cpu12));
  assign standby_mem112 = pwr1_off_macb112 && (~ (pwr1_off_macb012 && pwr1_off_macb112 && pwr1_off_macb212 && pwr1_off_macb312 && pwr1_off_urt12 && pwr1_off_smc12 && pwr1_off_dma12 && pwr1_off_cpu12));
  assign standby_mem212 = pwr1_off_macb212 && (~ (pwr1_off_macb012 && pwr1_off_macb112 && pwr1_off_macb212 && pwr1_off_macb312 && pwr1_off_urt12 && pwr1_off_smc12 && pwr1_off_dma12 && pwr1_off_cpu12));
  assign standby_mem312 = pwr1_off_macb312 && (~ (pwr1_off_macb012 && pwr1_off_macb112 && pwr1_off_macb212 && pwr1_off_macb312 && pwr1_off_urt12 && pwr1_off_smc12 && pwr1_off_dma12 && pwr1_off_cpu12));

  assign pwr1_off_mem012 = pwr1_off_mem12;
  assign pwr1_off_mem112 = pwr1_off_mem12;
  assign pwr1_off_mem212 = pwr1_off_mem12;
  assign pwr1_off_mem312 = pwr1_off_mem12;

  assign rstn_non_srpg_alut12  =  (rstn_non_srpg_macb012 && rstn_non_srpg_macb112 && rstn_non_srpg_macb212 && rstn_non_srpg_macb312);


   assign gate_clk_alut12       =  (gate_clk_macb012 && gate_clk_macb112 && gate_clk_macb212 && gate_clk_macb312);


    assign isolate_alut12        =  (isolate_macb012 && isolate_macb112 && isolate_macb212 && isolate_macb312);


    assign pwr1_on_alut12        =  (pwr1_on_macb012 || pwr1_on_macb112 || pwr1_on_macb212 || pwr1_on_macb312);


    assign pwr2_on_alut12        =  (pwr2_on_macb012 || pwr2_on_macb112 || pwr2_on_macb212 || pwr2_on_macb312);


    assign pwr1_off_alut12       =  (pwr1_off_macb012 && pwr1_off_macb112 && pwr1_off_macb212 && pwr1_off_macb312);


    assign pwr2_off_alut12       =  (pwr2_off_macb012 && pwr2_off_macb112 && pwr2_off_macb212 && pwr2_off_macb312);


    assign save_edge_alut12      =  (save_edge_macb012 && save_edge_macb112 && save_edge_macb212 && save_edge_macb312);


    assign restore_edge_alut12   =  (restore_edge_macb012 || restore_edge_macb112 || restore_edge_macb212 ||
                                   restore_edge_macb312) && save_alut_tmp12;

     // alut12 power12 off12 detection12
  always @(posedge pclk12 or negedge nprst12) begin
    if (!nprst12) 
       save_alut_tmp12 <= 0;
    else if (restore_edge_alut12)
       save_alut_tmp12 <= 0;
    else if (save_edge_alut12)
       save_alut_tmp12 <= 1;
  end

  //DMA12
  assign rstn_non_srpg_dma12 = (scan_mode12 == 1'b0) ?  rstn_non_srpg_dma_int12 : 1'b1;  
  assign gate_clk_dma12       = (scan_mode12 == 1'b0) ?  gate_clk_dma_int12      : 1'b0;     
  assign isolate_dma12        = (scan_mode12 == 1'b0) ?  isolate_dma_int12       : 1'b0;      
  assign pwr1_on_dma12        = (scan_mode12 == 1'b0) ?  pwr1_on_dma_int12       : 1'b1;       
  assign pwr2_on_dma12        = (scan_mode12 == 1'b0) ?  pwr2_on_dma_int12       : 1'b1;       
  assign pwr1_off_dma12       = (scan_mode12 == 1'b0) ?  (!pwr1_on_dma_int12)  : 1'b0;       
  assign pwr2_off_dma12       = (scan_mode12 == 1'b0) ?  (!pwr2_on_dma_int12)  : 1'b0;       
  assign save_edge_dma12       = (scan_mode12 == 1'b0) ? (save_edge_dma_int12) : 1'b0;       
  assign restore_edge_dma12       = (scan_mode12 == 1'b0) ? (restore_edge_dma_int12) : 1'b0;       

  //CPU12
  assign rstn_non_srpg_cpu12 = (scan_mode12 == 1'b0) ?  rstn_non_srpg_cpu_int12 : 1'b1;  
  assign gate_clk_cpu12       = (scan_mode12 == 1'b0) ?  gate_clk_cpu_int12      : 1'b0;     
  assign isolate_cpu12        = (scan_mode12 == 1'b0) ?  isolate_cpu_int12       : 1'b0;      
  assign pwr1_on_cpu12        = (scan_mode12 == 1'b0) ?  pwr1_on_cpu_int12       : 1'b1;       
  assign pwr2_on_cpu12        = (scan_mode12 == 1'b0) ?  pwr2_on_cpu_int12       : 1'b1;       
  assign pwr1_off_cpu12       = (scan_mode12 == 1'b0) ?  (!pwr1_on_cpu_int12)  : 1'b0;       
  assign pwr2_off_cpu12       = (scan_mode12 == 1'b0) ?  (!pwr2_on_cpu_int12)  : 1'b0;       
  assign save_edge_cpu12       = (scan_mode12 == 1'b0) ? (save_edge_cpu_int12) : 1'b0;       
  assign restore_edge_cpu12       = (scan_mode12 == 1'b0) ? (restore_edge_cpu_int12) : 1'b0;       



  // ASE12

   reg ase_core_12v12, ase_core_10v12, ase_core_08v12, ase_core_06v12;
   reg ase_macb0_12v12,ase_macb1_12v12,ase_macb2_12v12,ase_macb3_12v12;

    // core12 ase12

    // core12 at 1.0 v if (smc12 off12, urt12 off12, macb012 off12, macb112 off12, macb212 off12, macb312 off12
   // core12 at 0.8v if (mac01off12, macb02off12, macb03off12, macb12off12, mac13off12, mac23off12,
   // core12 at 0.6v if (mac012off12, mac013off12, mac023off12, mac123off12, mac0123off12
    // else core12 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb012 && pwr1_off_macb112 && pwr1_off_macb212 && pwr1_off_macb312) || // all mac12 off12
       (pwr1_off_macb312 && pwr1_off_macb212 && pwr1_off_macb112) || // mac123off12 
       (pwr1_off_macb312 && pwr1_off_macb212 && pwr1_off_macb012) || // mac023off12 
       (pwr1_off_macb312 && pwr1_off_macb112 && pwr1_off_macb012) || // mac013off12 
       (pwr1_off_macb212 && pwr1_off_macb112 && pwr1_off_macb012) )  // mac012off12 
       begin
         ase_core_12v12 = 0;
         ase_core_10v12 = 0;
         ase_core_08v12 = 0;
         ase_core_06v12 = 1;
       end
     else if( (pwr1_off_macb212 && pwr1_off_macb312) || // mac2312 off12
         (pwr1_off_macb312 && pwr1_off_macb112) || // mac13off12 
         (pwr1_off_macb112 && pwr1_off_macb212) || // mac12off12 
         (pwr1_off_macb312 && pwr1_off_macb012) || // mac03off12 
         (pwr1_off_macb212 && pwr1_off_macb012) || // mac02off12 
         (pwr1_off_macb112 && pwr1_off_macb012))  // mac01off12 
       begin
         ase_core_12v12 = 0;
         ase_core_10v12 = 0;
         ase_core_08v12 = 1;
         ase_core_06v12 = 0;
       end
     else if( (pwr1_off_smc12) || // smc12 off12
         (pwr1_off_macb012 ) || // mac0off12 
         (pwr1_off_macb112 ) || // mac1off12 
         (pwr1_off_macb212 ) || // mac2off12 
         (pwr1_off_macb312 ))  // mac3off12 
       begin
         ase_core_12v12 = 0;
         ase_core_10v12 = 1;
         ase_core_08v12 = 0;
         ase_core_06v12 = 0;
       end
     else if (pwr1_off_urt12)
       begin
         ase_core_12v12 = 1;
         ase_core_10v12 = 0;
         ase_core_08v12 = 0;
         ase_core_06v12 = 0;
       end
     else
       begin
         ase_core_12v12 = 1;
         ase_core_10v12 = 0;
         ase_core_08v12 = 0;
         ase_core_06v12 = 0;
       end
   end


   // cpu12
   // cpu12 @ 1.0v when macoff12, 
   // 
   reg ase_cpu_10v12, ase_cpu_12v12;
   always @(*) begin
    if(pwr1_off_cpu12) begin
     ase_cpu_12v12 = 1'b0;
     ase_cpu_10v12 = 1'b0;
    end
    else if(pwr1_off_macb012 || pwr1_off_macb112 || pwr1_off_macb212 || pwr1_off_macb312)
    begin
     ase_cpu_12v12 = 1'b0;
     ase_cpu_10v12 = 1'b1;
    end
    else
    begin
     ase_cpu_12v12 = 1'b1;
     ase_cpu_10v12 = 1'b0;
    end
   end

   // dma12
   // dma12 @v112.0 for macoff12, 

   reg ase_dma_10v12, ase_dma_12v12;
   always @(*) begin
    if(pwr1_off_dma12) begin
     ase_dma_12v12 = 1'b0;
     ase_dma_10v12 = 1'b0;
    end
    else if(pwr1_off_macb012 || pwr1_off_macb112 || pwr1_off_macb212 || pwr1_off_macb312)
    begin
     ase_dma_12v12 = 1'b0;
     ase_dma_10v12 = 1'b1;
    end
    else
    begin
     ase_dma_12v12 = 1'b1;
     ase_dma_10v12 = 1'b0;
    end
   end

   // alut12
   // @ v112.0 for macoff12

   reg ase_alut_10v12, ase_alut_12v12;
   always @(*) begin
    if(pwr1_off_alut12) begin
     ase_alut_12v12 = 1'b0;
     ase_alut_10v12 = 1'b0;
    end
    else if(pwr1_off_macb012 || pwr1_off_macb112 || pwr1_off_macb212 || pwr1_off_macb312)
    begin
     ase_alut_12v12 = 1'b0;
     ase_alut_10v12 = 1'b1;
    end
    else
    begin
     ase_alut_12v12 = 1'b1;
     ase_alut_10v12 = 1'b0;
    end
   end




   reg ase_uart_12v12;
   reg ase_uart_10v12;
   reg ase_uart_08v12;
   reg ase_uart_06v12;

   reg ase_smc_12v12;


   always @(*) begin
     if(pwr1_off_urt12) begin // uart12 off12
       ase_uart_08v12 = 1'b0;
       ase_uart_06v12 = 1'b0;
       ase_uart_10v12 = 1'b0;
       ase_uart_12v12 = 1'b0;
     end 
     else if( (pwr1_off_macb012 && pwr1_off_macb112 && pwr1_off_macb212 && pwr1_off_macb312) || // all mac12 off12
       (pwr1_off_macb312 && pwr1_off_macb212 && pwr1_off_macb112) || // mac123off12 
       (pwr1_off_macb312 && pwr1_off_macb212 && pwr1_off_macb012) || // mac023off12 
       (pwr1_off_macb312 && pwr1_off_macb112 && pwr1_off_macb012) || // mac013off12 
       (pwr1_off_macb212 && pwr1_off_macb112 && pwr1_off_macb012) )  // mac012off12 
     begin
       ase_uart_06v12 = 1'b1;
       ase_uart_08v12 = 1'b0;
       ase_uart_10v12 = 1'b0;
       ase_uart_12v12 = 1'b0;
     end
     else if( (pwr1_off_macb212 && pwr1_off_macb312) || // mac2312 off12
         (pwr1_off_macb312 && pwr1_off_macb112) || // mac13off12 
         (pwr1_off_macb112 && pwr1_off_macb212) || // mac12off12 
         (pwr1_off_macb312 && pwr1_off_macb012) || // mac03off12 
         (pwr1_off_macb112 && pwr1_off_macb012))  // mac01off12  
     begin
       ase_uart_06v12 = 1'b0;
       ase_uart_08v12 = 1'b1;
       ase_uart_10v12 = 1'b0;
       ase_uart_12v12 = 1'b0;
     end
     else if (pwr1_off_smc12 || pwr1_off_macb012 || pwr1_off_macb112 || pwr1_off_macb212 || pwr1_off_macb312) begin // smc12 off12
       ase_uart_08v12 = 1'b0;
       ase_uart_06v12 = 1'b0;
       ase_uart_10v12 = 1'b1;
       ase_uart_12v12 = 1'b0;
     end 
     else begin
       ase_uart_08v12 = 1'b0;
       ase_uart_06v12 = 1'b0;
       ase_uart_10v12 = 1'b0;
       ase_uart_12v12 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc12) begin
     if (pwr1_off_smc12)  // smc12 off12
       ase_smc_12v12 = 1'b0;
    else
       ase_smc_12v12 = 1'b1;
   end

   
   always @(pwr1_off_macb012) begin
     if (pwr1_off_macb012) // macb012 off12
       ase_macb0_12v12 = 1'b0;
     else
       ase_macb0_12v12 = 1'b1;
   end

   always @(pwr1_off_macb112) begin
     if (pwr1_off_macb112) // macb112 off12
       ase_macb1_12v12 = 1'b0;
     else
       ase_macb1_12v12 = 1'b1;
   end

   always @(pwr1_off_macb212) begin // macb212 off12
     if (pwr1_off_macb212) // macb212 off12
       ase_macb2_12v12 = 1'b0;
     else
       ase_macb2_12v12 = 1'b1;
   end

   always @(pwr1_off_macb312) begin // macb312 off12
     if (pwr1_off_macb312) // macb312 off12
       ase_macb3_12v12 = 1'b0;
     else
       ase_macb3_12v12 = 1'b1;
   end


   // core12 voltage12 for vco12
  assign core12v12 = ase_macb0_12v12 & ase_macb1_12v12 & ase_macb2_12v12 & ase_macb3_12v12;

  assign core10v12 =  (ase_macb0_12v12 & ase_macb1_12v12 & ase_macb2_12v12 & (!ase_macb3_12v12)) ||
                    (ase_macb0_12v12 & ase_macb1_12v12 & (!ase_macb2_12v12) & ase_macb3_12v12) ||
                    (ase_macb0_12v12 & (!ase_macb1_12v12) & ase_macb2_12v12 & ase_macb3_12v12) ||
                    ((!ase_macb0_12v12) & ase_macb1_12v12 & ase_macb2_12v12 & ase_macb3_12v12);

  assign core08v12 =  ((!ase_macb0_12v12) & (!ase_macb1_12v12) & (ase_macb2_12v12) & (ase_macb3_12v12)) ||
                    ((!ase_macb0_12v12) & (ase_macb1_12v12) & (!ase_macb2_12v12) & (ase_macb3_12v12)) ||
                    ((!ase_macb0_12v12) & (ase_macb1_12v12) & (ase_macb2_12v12) & (!ase_macb3_12v12)) ||
                    ((ase_macb0_12v12) & (!ase_macb1_12v12) & (!ase_macb2_12v12) & (ase_macb3_12v12)) ||
                    ((ase_macb0_12v12) & (!ase_macb1_12v12) & (ase_macb2_12v12) & (!ase_macb3_12v12)) ||
                    ((ase_macb0_12v12) & (ase_macb1_12v12) & (!ase_macb2_12v12) & (!ase_macb3_12v12));

  assign core06v12 =  ((!ase_macb0_12v12) & (!ase_macb1_12v12) & (!ase_macb2_12v12) & (ase_macb3_12v12)) ||
                    ((!ase_macb0_12v12) & (!ase_macb1_12v12) & (ase_macb2_12v12) & (!ase_macb3_12v12)) ||
                    ((!ase_macb0_12v12) & (ase_macb1_12v12) & (!ase_macb2_12v12) & (!ase_macb3_12v12)) ||
                    ((ase_macb0_12v12) & (!ase_macb1_12v12) & (!ase_macb2_12v12) & (!ase_macb3_12v12)) ||
                    ((!ase_macb0_12v12) & (!ase_macb1_12v12) & (!ase_macb2_12v12) & (!ase_macb3_12v12)) ;



`ifdef LP_ABV_ON12
// psl12 default clock12 = (posedge pclk12);

// Cover12 a condition in which SMC12 is powered12 down
// and again12 powered12 up while UART12 is going12 into POWER12 down
// state or UART12 is already in POWER12 DOWN12 state
// psl12 cover_overlapping_smc_urt_112:
//    cover{fell12(pwr1_on_urt12);[*];fell12(pwr1_on_smc12);[*];
//    rose12(pwr1_on_smc12);[*];rose12(pwr1_on_urt12)};
//
// Cover12 a condition in which UART12 is powered12 down
// and again12 powered12 up while SMC12 is going12 into POWER12 down
// state or SMC12 is already in POWER12 DOWN12 state
// psl12 cover_overlapping_smc_urt_212:
//    cover{fell12(pwr1_on_smc12);[*];fell12(pwr1_on_urt12);[*];
//    rose12(pwr1_on_urt12);[*];rose12(pwr1_on_smc12)};
//


// Power12 Down12 UART12
// This12 gets12 triggered on rising12 edge of Gate12 signal12 for
// UART12 (gate_clk_urt12). In a next cycle after gate_clk_urt12,
// Isolate12 UART12(isolate_urt12) signal12 become12 HIGH12 (active).
// In 2nd cycle after gate_clk_urt12 becomes HIGH12, RESET12 for NON12
// SRPG12 FFs12(rstn_non_srpg_urt12) and POWER112 for UART12(pwr1_on_urt12) should 
// go12 LOW12. 
// This12 completes12 a POWER12 DOWN12. 

sequence s_power_down_urt12;
      (gate_clk_urt12 & !isolate_urt12 & rstn_non_srpg_urt12 & pwr1_on_urt12) 
  ##1 (gate_clk_urt12 & isolate_urt12 & rstn_non_srpg_urt12 & pwr1_on_urt12) 
  ##3 (gate_clk_urt12 & isolate_urt12 & !rstn_non_srpg_urt12 & !pwr1_on_urt12);
endsequence


property p_power_down_urt12;
   @(posedge pclk12)
    $rose(gate_clk_urt12) |=> s_power_down_urt12;
endproperty

output_power_down_urt12:
  assert property (p_power_down_urt12);


// Power12 UP12 UART12
// Sequence starts with , Rising12 edge of pwr1_on_urt12.
// Two12 clock12 cycle after this, isolate_urt12 should become12 LOW12 
// On12 the following12 clk12 gate_clk_urt12 should go12 low12.
// 5 cycles12 after  Rising12 edge of pwr1_on_urt12, rstn_non_srpg_urt12
// should become12 HIGH12
sequence s_power_up_urt12;
##30 (pwr1_on_urt12 & !isolate_urt12 & gate_clk_urt12 & !rstn_non_srpg_urt12) 
##1 (pwr1_on_urt12 & !isolate_urt12 & !gate_clk_urt12 & !rstn_non_srpg_urt12) 
##2 (pwr1_on_urt12 & !isolate_urt12 & !gate_clk_urt12 & rstn_non_srpg_urt12);
endsequence

property p_power_up_urt12;
   @(posedge pclk12)
  disable iff(!nprst12)
    (!pwr1_on_urt12 ##1 pwr1_on_urt12) |=> s_power_up_urt12;
endproperty

output_power_up_urt12:
  assert property (p_power_up_urt12);


// Power12 Down12 SMC12
// This12 gets12 triggered on rising12 edge of Gate12 signal12 for
// SMC12 (gate_clk_smc12). In a next cycle after gate_clk_smc12,
// Isolate12 SMC12(isolate_smc12) signal12 become12 HIGH12 (active).
// In 2nd cycle after gate_clk_smc12 becomes HIGH12, RESET12 for NON12
// SRPG12 FFs12(rstn_non_srpg_smc12) and POWER112 for SMC12(pwr1_on_smc12) should 
// go12 LOW12. 
// This12 completes12 a POWER12 DOWN12. 

sequence s_power_down_smc12;
      (gate_clk_smc12 & !isolate_smc12 & rstn_non_srpg_smc12 & pwr1_on_smc12) 
  ##1 (gate_clk_smc12 & isolate_smc12 & rstn_non_srpg_smc12 & pwr1_on_smc12) 
  ##3 (gate_clk_smc12 & isolate_smc12 & !rstn_non_srpg_smc12 & !pwr1_on_smc12);
endsequence


property p_power_down_smc12;
   @(posedge pclk12)
    $rose(gate_clk_smc12) |=> s_power_down_smc12;
endproperty

output_power_down_smc12:
  assert property (p_power_down_smc12);


// Power12 UP12 SMC12
// Sequence starts with , Rising12 edge of pwr1_on_smc12.
// Two12 clock12 cycle after this, isolate_smc12 should become12 LOW12 
// On12 the following12 clk12 gate_clk_smc12 should go12 low12.
// 5 cycles12 after  Rising12 edge of pwr1_on_smc12, rstn_non_srpg_smc12
// should become12 HIGH12
sequence s_power_up_smc12;
##30 (pwr1_on_smc12 & !isolate_smc12 & gate_clk_smc12 & !rstn_non_srpg_smc12) 
##1 (pwr1_on_smc12 & !isolate_smc12 & !gate_clk_smc12 & !rstn_non_srpg_smc12) 
##2 (pwr1_on_smc12 & !isolate_smc12 & !gate_clk_smc12 & rstn_non_srpg_smc12);
endsequence

property p_power_up_smc12;
   @(posedge pclk12)
  disable iff(!nprst12)
    (!pwr1_on_smc12 ##1 pwr1_on_smc12) |=> s_power_up_smc12;
endproperty

output_power_up_smc12:
  assert property (p_power_up_smc12);


// COVER12 SMC12 POWER12 DOWN12 AND12 UP12
cover_power_down_up_smc12: cover property (@(posedge pclk12)
(s_power_down_smc12 ##[5:180] s_power_up_smc12));



// COVER12 UART12 POWER12 DOWN12 AND12 UP12
cover_power_down_up_urt12: cover property (@(posedge pclk12)
(s_power_down_urt12 ##[5:180] s_power_up_urt12));

cover_power_down_urt12: cover property (@(posedge pclk12)
(s_power_down_urt12));

cover_power_up_urt12: cover property (@(posedge pclk12)
(s_power_up_urt12));




`ifdef PCM_ABV_ON12
//------------------------------------------------------------------------------
// Power12 Controller12 Formal12 Verification12 component.  Each power12 domain has a 
// separate12 instantiation12
//------------------------------------------------------------------------------

// need to assume that CPU12 will leave12 a minimum time between powering12 down and 
// back up.  In this example12, 10clks has been selected.
// psl12 config_min_uart_pd_time12 : assume always {rose12(L1_ctrl_domain12[1])} |-> { L1_ctrl_domain12[1][*10] } abort12(~nprst12);
// psl12 config_min_uart_pu_time12 : assume always {fell12(L1_ctrl_domain12[1])} |-> { !L1_ctrl_domain12[1][*10] } abort12(~nprst12);
// psl12 config_min_smc_pd_time12 : assume always {rose12(L1_ctrl_domain12[2])} |-> { L1_ctrl_domain12[2][*10] } abort12(~nprst12);
// psl12 config_min_smc_pu_time12 : assume always {fell12(L1_ctrl_domain12[2])} |-> { !L1_ctrl_domain12[2][*10] } abort12(~nprst12);

// UART12 VCOMP12 parameters12
   defparam i_uart_vcomp_domain12.ENABLE_SAVE_RESTORE_EDGE12   = 1;
   defparam i_uart_vcomp_domain12.ENABLE_EXT_PWR_CNTRL12       = 1;
   defparam i_uart_vcomp_domain12.REF_CLK_DEFINED12            = 0;
   defparam i_uart_vcomp_domain12.MIN_SHUTOFF_CYCLES12         = 4;
   defparam i_uart_vcomp_domain12.MIN_RESTORE_TO_ISO_CYCLES12  = 0;
   defparam i_uart_vcomp_domain12.MIN_SAVE_TO_SHUTOFF_CYCLES12 = 1;


   vcomp_domain12 i_uart_vcomp_domain12
   ( .ref_clk12(pclk12),
     .start_lps12(L1_ctrl_domain12[1] || !rstn_non_srpg_urt12),
     .rst_n12(nprst12),
     .ext_power_down12(L1_ctrl_domain12[1]),
     .iso_en12(isolate_urt12),
     .save_edge12(save_edge_urt12),
     .restore_edge12(restore_edge_urt12),
     .domain_shut_off12(pwr1_off_urt12),
     .domain_clk12(!gate_clk_urt12 && pclk12)
   );


// SMC12 VCOMP12 parameters12
   defparam i_smc_vcomp_domain12.ENABLE_SAVE_RESTORE_EDGE12   = 1;
   defparam i_smc_vcomp_domain12.ENABLE_EXT_PWR_CNTRL12       = 1;
   defparam i_smc_vcomp_domain12.REF_CLK_DEFINED12            = 0;
   defparam i_smc_vcomp_domain12.MIN_SHUTOFF_CYCLES12         = 4;
   defparam i_smc_vcomp_domain12.MIN_RESTORE_TO_ISO_CYCLES12  = 0;
   defparam i_smc_vcomp_domain12.MIN_SAVE_TO_SHUTOFF_CYCLES12 = 1;


   vcomp_domain12 i_smc_vcomp_domain12
   ( .ref_clk12(pclk12),
     .start_lps12(L1_ctrl_domain12[2] || !rstn_non_srpg_smc12),
     .rst_n12(nprst12),
     .ext_power_down12(L1_ctrl_domain12[2]),
     .iso_en12(isolate_smc12),
     .save_edge12(save_edge_smc12),
     .restore_edge12(restore_edge_smc12),
     .domain_shut_off12(pwr1_off_smc12),
     .domain_clk12(!gate_clk_smc12 && pclk12)
   );

`endif

`endif



endmodule
