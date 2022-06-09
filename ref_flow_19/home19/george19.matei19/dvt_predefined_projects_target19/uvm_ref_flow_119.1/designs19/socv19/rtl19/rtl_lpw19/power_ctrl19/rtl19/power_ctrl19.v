//File19 name   : power_ctrl19.v
//Title19       : Power19 Control19 Module19
//Created19     : 1999
//Description19 : Top19 level of power19 controller19
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

module power_ctrl19 (


    // Clocks19 & Reset19
    pclk19,
    nprst19,
    // APB19 programming19 interface
    paddr19,
    psel19,
    penable19,
    pwrite19,
    pwdata19,
    prdata19,
    // mac19 i/f,
    macb3_wakeup19,
    macb2_wakeup19,
    macb1_wakeup19,
    macb0_wakeup19,
    // Scan19 
    scan_in19,
    scan_en19,
    scan_mode19,
    scan_out19,
    // Module19 control19 outputs19
    int_source_h19,
    // SMC19
    rstn_non_srpg_smc19,
    gate_clk_smc19,
    isolate_smc19,
    save_edge_smc19,
    restore_edge_smc19,
    pwr1_on_smc19,
    pwr2_on_smc19,
    pwr1_off_smc19,
    pwr2_off_smc19,
    // URT19
    rstn_non_srpg_urt19,
    gate_clk_urt19,
    isolate_urt19,
    save_edge_urt19,
    restore_edge_urt19,
    pwr1_on_urt19,
    pwr2_on_urt19,
    pwr1_off_urt19,      
    pwr2_off_urt19,
    // ETH019
    rstn_non_srpg_macb019,
    gate_clk_macb019,
    isolate_macb019,
    save_edge_macb019,
    restore_edge_macb019,
    pwr1_on_macb019,
    pwr2_on_macb019,
    pwr1_off_macb019,      
    pwr2_off_macb019,
    // ETH119
    rstn_non_srpg_macb119,
    gate_clk_macb119,
    isolate_macb119,
    save_edge_macb119,
    restore_edge_macb119,
    pwr1_on_macb119,
    pwr2_on_macb119,
    pwr1_off_macb119,      
    pwr2_off_macb119,
    // ETH219
    rstn_non_srpg_macb219,
    gate_clk_macb219,
    isolate_macb219,
    save_edge_macb219,
    restore_edge_macb219,
    pwr1_on_macb219,
    pwr2_on_macb219,
    pwr1_off_macb219,      
    pwr2_off_macb219,
    // ETH319
    rstn_non_srpg_macb319,
    gate_clk_macb319,
    isolate_macb319,
    save_edge_macb319,
    restore_edge_macb319,
    pwr1_on_macb319,
    pwr2_on_macb319,
    pwr1_off_macb319,      
    pwr2_off_macb319,
    // DMA19
    rstn_non_srpg_dma19,
    gate_clk_dma19,
    isolate_dma19,
    save_edge_dma19,
    restore_edge_dma19,
    pwr1_on_dma19,
    pwr2_on_dma19,
    pwr1_off_dma19,      
    pwr2_off_dma19,
    // CPU19
    rstn_non_srpg_cpu19,
    gate_clk_cpu19,
    isolate_cpu19,
    save_edge_cpu19,
    restore_edge_cpu19,
    pwr1_on_cpu19,
    pwr2_on_cpu19,
    pwr1_off_cpu19,      
    pwr2_off_cpu19,
    // ALUT19
    rstn_non_srpg_alut19,
    gate_clk_alut19,
    isolate_alut19,
    save_edge_alut19,
    restore_edge_alut19,
    pwr1_on_alut19,
    pwr2_on_alut19,
    pwr1_off_alut19,      
    pwr2_off_alut19,
    // MEM19
    rstn_non_srpg_mem19,
    gate_clk_mem19,
    isolate_mem19,
    save_edge_mem19,
    restore_edge_mem19,
    pwr1_on_mem19,
    pwr2_on_mem19,
    pwr1_off_mem19,      
    pwr2_off_mem19,
    // core19 dvfs19 transitions19
    core06v19,
    core08v19,
    core10v19,
    core12v19,
    pcm_macb_wakeup_int19,
    // mte19 signals19
    mte_smc_start19,
    mte_uart_start19,
    mte_smc_uart_start19,  
    mte_pm_smc_to_default_start19, 
    mte_pm_uart_to_default_start19,
    mte_pm_smc_uart_to_default_start19

  );

  parameter STATE_IDLE_12V19 = 4'b0001;
  parameter STATE_06V19 = 4'b0010;
  parameter STATE_08V19 = 4'b0100;
  parameter STATE_10V19 = 4'b1000;

    // Clocks19 & Reset19
    input pclk19;
    input nprst19;
    // APB19 programming19 interface
    input [31:0] paddr19;
    input psel19  ;
    input penable19;
    input pwrite19 ;
    input [31:0] pwdata19;
    output [31:0] prdata19;
    // mac19
    input macb3_wakeup19;
    input macb2_wakeup19;
    input macb1_wakeup19;
    input macb0_wakeup19;
    // Scan19 
    input scan_in19;
    input scan_en19;
    input scan_mode19;
    output scan_out19;
    // Module19 control19 outputs19
    input int_source_h19;
    // SMC19
    output rstn_non_srpg_smc19 ;
    output gate_clk_smc19   ;
    output isolate_smc19   ;
    output save_edge_smc19   ;
    output restore_edge_smc19   ;
    output pwr1_on_smc19   ;
    output pwr2_on_smc19   ;
    output pwr1_off_smc19  ;
    output pwr2_off_smc19  ;
    // URT19
    output rstn_non_srpg_urt19 ;
    output gate_clk_urt19      ;
    output isolate_urt19       ;
    output save_edge_urt19   ;
    output restore_edge_urt19   ;
    output pwr1_on_urt19       ;
    output pwr2_on_urt19       ;
    output pwr1_off_urt19      ;
    output pwr2_off_urt19      ;
    // ETH019
    output rstn_non_srpg_macb019 ;
    output gate_clk_macb019      ;
    output isolate_macb019       ;
    output save_edge_macb019   ;
    output restore_edge_macb019   ;
    output pwr1_on_macb019       ;
    output pwr2_on_macb019       ;
    output pwr1_off_macb019      ;
    output pwr2_off_macb019      ;
    // ETH119
    output rstn_non_srpg_macb119 ;
    output gate_clk_macb119      ;
    output isolate_macb119       ;
    output save_edge_macb119   ;
    output restore_edge_macb119   ;
    output pwr1_on_macb119       ;
    output pwr2_on_macb119       ;
    output pwr1_off_macb119      ;
    output pwr2_off_macb119      ;
    // ETH219
    output rstn_non_srpg_macb219 ;
    output gate_clk_macb219      ;
    output isolate_macb219       ;
    output save_edge_macb219   ;
    output restore_edge_macb219   ;
    output pwr1_on_macb219       ;
    output pwr2_on_macb219       ;
    output pwr1_off_macb219      ;
    output pwr2_off_macb219      ;
    // ETH319
    output rstn_non_srpg_macb319 ;
    output gate_clk_macb319      ;
    output isolate_macb319       ;
    output save_edge_macb319   ;
    output restore_edge_macb319   ;
    output pwr1_on_macb319       ;
    output pwr2_on_macb319       ;
    output pwr1_off_macb319      ;
    output pwr2_off_macb319      ;
    // DMA19
    output rstn_non_srpg_dma19 ;
    output gate_clk_dma19      ;
    output isolate_dma19       ;
    output save_edge_dma19   ;
    output restore_edge_dma19   ;
    output pwr1_on_dma19       ;
    output pwr2_on_dma19       ;
    output pwr1_off_dma19      ;
    output pwr2_off_dma19      ;
    // CPU19
    output rstn_non_srpg_cpu19 ;
    output gate_clk_cpu19      ;
    output isolate_cpu19       ;
    output save_edge_cpu19   ;
    output restore_edge_cpu19   ;
    output pwr1_on_cpu19       ;
    output pwr2_on_cpu19       ;
    output pwr1_off_cpu19      ;
    output pwr2_off_cpu19      ;
    // ALUT19
    output rstn_non_srpg_alut19 ;
    output gate_clk_alut19      ;
    output isolate_alut19       ;
    output save_edge_alut19   ;
    output restore_edge_alut19   ;
    output pwr1_on_alut19       ;
    output pwr2_on_alut19       ;
    output pwr1_off_alut19      ;
    output pwr2_off_alut19      ;
    // MEM19
    output rstn_non_srpg_mem19 ;
    output gate_clk_mem19      ;
    output isolate_mem19       ;
    output save_edge_mem19   ;
    output restore_edge_mem19   ;
    output pwr1_on_mem19       ;
    output pwr2_on_mem19       ;
    output pwr1_off_mem19      ;
    output pwr2_off_mem19      ;


   // core19 transitions19 o/p
    output core06v19;
    output core08v19;
    output core10v19;
    output core12v19;
    output pcm_macb_wakeup_int19 ;
    //mode mte19  signals19
    output mte_smc_start19;
    output mte_uart_start19;
    output mte_smc_uart_start19;  
    output mte_pm_smc_to_default_start19; 
    output mte_pm_uart_to_default_start19;
    output mte_pm_smc_uart_to_default_start19;

    reg mte_smc_start19;
    reg mte_uart_start19;
    reg mte_smc_uart_start19;  
    reg mte_pm_smc_to_default_start19; 
    reg mte_pm_uart_to_default_start19;
    reg mte_pm_smc_uart_to_default_start19;

    reg [31:0] prdata19;

  wire valid_reg_write19  ;
  wire valid_reg_read19   ;
  wire L1_ctrl_access19   ;
  wire L1_status_access19 ;
  wire pcm_int_mask_access19;
  wire pcm_int_status_access19;
  wire standby_mem019      ;
  wire standby_mem119      ;
  wire standby_mem219      ;
  wire standby_mem319      ;
  wire pwr1_off_mem019;
  wire pwr1_off_mem119;
  wire pwr1_off_mem219;
  wire pwr1_off_mem319;
  
  // Control19 signals19
  wire set_status_smc19   ;
  wire clr_status_smc19   ;
  wire set_status_urt19   ;
  wire clr_status_urt19   ;
  wire set_status_macb019   ;
  wire clr_status_macb019   ;
  wire set_status_macb119   ;
  wire clr_status_macb119   ;
  wire set_status_macb219   ;
  wire clr_status_macb219   ;
  wire set_status_macb319   ;
  wire clr_status_macb319   ;
  wire set_status_dma19   ;
  wire clr_status_dma19   ;
  wire set_status_cpu19   ;
  wire clr_status_cpu19   ;
  wire set_status_alut19   ;
  wire clr_status_alut19   ;
  wire set_status_mem19   ;
  wire clr_status_mem19   ;


  // Status and Control19 registers
  reg [31:0]  L1_status_reg19;
  reg  [31:0] L1_ctrl_reg19  ;
  reg  [31:0] L1_ctrl_domain19  ;
  reg L1_ctrl_cpu_off_reg19;
  reg [31:0]  pcm_mask_reg19;
  reg [31:0]  pcm_status_reg19;

  // Signals19 gated19 in scan_mode19
  //SMC19
  wire  rstn_non_srpg_smc_int19;
  wire  gate_clk_smc_int19    ;     
  wire  isolate_smc_int19    ;       
  wire save_edge_smc_int19;
  wire restore_edge_smc_int19;
  wire  pwr1_on_smc_int19    ;      
  wire  pwr2_on_smc_int19    ;      


  //URT19
  wire   rstn_non_srpg_urt_int19;
  wire   gate_clk_urt_int19     ;     
  wire   isolate_urt_int19      ;       
  wire save_edge_urt_int19;
  wire restore_edge_urt_int19;
  wire   pwr1_on_urt_int19      ;      
  wire   pwr2_on_urt_int19      ;      

  // ETH019
  wire   rstn_non_srpg_macb0_int19;
  wire   gate_clk_macb0_int19     ;     
  wire   isolate_macb0_int19      ;       
  wire save_edge_macb0_int19;
  wire restore_edge_macb0_int19;
  wire   pwr1_on_macb0_int19      ;      
  wire   pwr2_on_macb0_int19      ;      
  // ETH119
  wire   rstn_non_srpg_macb1_int19;
  wire   gate_clk_macb1_int19     ;     
  wire   isolate_macb1_int19      ;       
  wire save_edge_macb1_int19;
  wire restore_edge_macb1_int19;
  wire   pwr1_on_macb1_int19      ;      
  wire   pwr2_on_macb1_int19      ;      
  // ETH219
  wire   rstn_non_srpg_macb2_int19;
  wire   gate_clk_macb2_int19     ;     
  wire   isolate_macb2_int19      ;       
  wire save_edge_macb2_int19;
  wire restore_edge_macb2_int19;
  wire   pwr1_on_macb2_int19      ;      
  wire   pwr2_on_macb2_int19      ;      
  // ETH319
  wire   rstn_non_srpg_macb3_int19;
  wire   gate_clk_macb3_int19     ;     
  wire   isolate_macb3_int19      ;       
  wire save_edge_macb3_int19;
  wire restore_edge_macb3_int19;
  wire   pwr1_on_macb3_int19      ;      
  wire   pwr2_on_macb3_int19      ;      

  // DMA19
  wire   rstn_non_srpg_dma_int19;
  wire   gate_clk_dma_int19     ;     
  wire   isolate_dma_int19      ;       
  wire save_edge_dma_int19;
  wire restore_edge_dma_int19;
  wire   pwr1_on_dma_int19      ;      
  wire   pwr2_on_dma_int19      ;      

  // CPU19
  wire   rstn_non_srpg_cpu_int19;
  wire   gate_clk_cpu_int19     ;     
  wire   isolate_cpu_int19      ;       
  wire save_edge_cpu_int19;
  wire restore_edge_cpu_int19;
  wire   pwr1_on_cpu_int19      ;      
  wire   pwr2_on_cpu_int19      ;  
  wire L1_ctrl_cpu_off_p19;    

  reg save_alut_tmp19;
  // DFS19 sm19

  reg cpu_shutoff_ctrl19;

  reg mte_mac_off_start19, mte_mac012_start19, mte_mac013_start19, mte_mac023_start19, mte_mac123_start19;
  reg mte_mac01_start19, mte_mac02_start19, mte_mac03_start19, mte_mac12_start19, mte_mac13_start19, mte_mac23_start19;
  reg mte_mac0_start19, mte_mac1_start19, mte_mac2_start19, mte_mac3_start19;
  reg mte_sys_hibernate19 ;
  reg mte_dma_start19 ;
  reg mte_cpu_start19 ;
  reg mte_mac_off_sleep_start19, mte_mac012_sleep_start19, mte_mac013_sleep_start19, mte_mac023_sleep_start19, mte_mac123_sleep_start19;
  reg mte_mac01_sleep_start19, mte_mac02_sleep_start19, mte_mac03_sleep_start19, mte_mac12_sleep_start19, mte_mac13_sleep_start19, mte_mac23_sleep_start19;
  reg mte_mac0_sleep_start19, mte_mac1_sleep_start19, mte_mac2_sleep_start19, mte_mac3_sleep_start19;
  reg mte_dma_sleep_start19;
  reg mte_mac_off_to_default19, mte_mac012_to_default19, mte_mac013_to_default19, mte_mac023_to_default19, mte_mac123_to_default19;
  reg mte_mac01_to_default19, mte_mac02_to_default19, mte_mac03_to_default19, mte_mac12_to_default19, mte_mac13_to_default19, mte_mac23_to_default19;
  reg mte_mac0_to_default19, mte_mac1_to_default19, mte_mac2_to_default19, mte_mac3_to_default19;
  reg mte_dma_isolate_dis19;
  reg mte_cpu_isolate_dis19;
  reg mte_sys_hibernate_to_default19;


  // Latch19 the CPU19 SLEEP19 invocation19
  always @( posedge pclk19 or negedge nprst19) 
  begin
    if(!nprst19)
      L1_ctrl_cpu_off_reg19 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg19 <= L1_ctrl_domain19[8];
  end

  // Create19 a pulse19 for sleep19 detection19 
  assign L1_ctrl_cpu_off_p19 =  L1_ctrl_domain19[8] && !L1_ctrl_cpu_off_reg19;
  
  // CPU19 sleep19 contol19 logic 
  // Shut19 off19 CPU19 when L1_ctrl_cpu_off_p19 is set
  // wake19 cpu19 when any interrupt19 is seen19  
  always @( posedge pclk19 or negedge nprst19) 
  begin
    if(!nprst19)
     cpu_shutoff_ctrl19 <= 1'b0;
    else if(cpu_shutoff_ctrl19 && int_source_h19)
     cpu_shutoff_ctrl19 <= 1'b0;
    else if (L1_ctrl_cpu_off_p19)
     cpu_shutoff_ctrl19 <= 1'b1;
  end
 
  // instantiate19 power19 contol19  block for uart19
  power_ctrl_sm19 i_urt_power_ctrl_sm19(
    .pclk19(pclk19),
    .nprst19(nprst19),
    .L1_module_req19(L1_ctrl_domain19[1]),
    .set_status_module19(set_status_urt19),
    .clr_status_module19(clr_status_urt19),
    .rstn_non_srpg_module19(rstn_non_srpg_urt_int19),
    .gate_clk_module19(gate_clk_urt_int19),
    .isolate_module19(isolate_urt_int19),
    .save_edge19(save_edge_urt_int19),
    .restore_edge19(restore_edge_urt_int19),
    .pwr1_on19(pwr1_on_urt_int19),
    .pwr2_on19(pwr2_on_urt_int19)
    );
  

  // instantiate19 power19 contol19  block for smc19
  power_ctrl_sm19 i_smc_power_ctrl_sm19(
    .pclk19(pclk19),
    .nprst19(nprst19),
    .L1_module_req19(L1_ctrl_domain19[2]),
    .set_status_module19(set_status_smc19),
    .clr_status_module19(clr_status_smc19),
    .rstn_non_srpg_module19(rstn_non_srpg_smc_int19),
    .gate_clk_module19(gate_clk_smc_int19),
    .isolate_module19(isolate_smc_int19),
    .save_edge19(save_edge_smc_int19),
    .restore_edge19(restore_edge_smc_int19),
    .pwr1_on19(pwr1_on_smc_int19),
    .pwr2_on19(pwr2_on_smc_int19)
    );

  // power19 control19 for macb019
  power_ctrl_sm19 i_macb0_power_ctrl_sm19(
    .pclk19(pclk19),
    .nprst19(nprst19),
    .L1_module_req19(L1_ctrl_domain19[3]),
    .set_status_module19(set_status_macb019),
    .clr_status_module19(clr_status_macb019),
    .rstn_non_srpg_module19(rstn_non_srpg_macb0_int19),
    .gate_clk_module19(gate_clk_macb0_int19),
    .isolate_module19(isolate_macb0_int19),
    .save_edge19(save_edge_macb0_int19),
    .restore_edge19(restore_edge_macb0_int19),
    .pwr1_on19(pwr1_on_macb0_int19),
    .pwr2_on19(pwr2_on_macb0_int19)
    );
  // power19 control19 for macb119
  power_ctrl_sm19 i_macb1_power_ctrl_sm19(
    .pclk19(pclk19),
    .nprst19(nprst19),
    .L1_module_req19(L1_ctrl_domain19[4]),
    .set_status_module19(set_status_macb119),
    .clr_status_module19(clr_status_macb119),
    .rstn_non_srpg_module19(rstn_non_srpg_macb1_int19),
    .gate_clk_module19(gate_clk_macb1_int19),
    .isolate_module19(isolate_macb1_int19),
    .save_edge19(save_edge_macb1_int19),
    .restore_edge19(restore_edge_macb1_int19),
    .pwr1_on19(pwr1_on_macb1_int19),
    .pwr2_on19(pwr2_on_macb1_int19)
    );
  // power19 control19 for macb219
  power_ctrl_sm19 i_macb2_power_ctrl_sm19(
    .pclk19(pclk19),
    .nprst19(nprst19),
    .L1_module_req19(L1_ctrl_domain19[5]),
    .set_status_module19(set_status_macb219),
    .clr_status_module19(clr_status_macb219),
    .rstn_non_srpg_module19(rstn_non_srpg_macb2_int19),
    .gate_clk_module19(gate_clk_macb2_int19),
    .isolate_module19(isolate_macb2_int19),
    .save_edge19(save_edge_macb2_int19),
    .restore_edge19(restore_edge_macb2_int19),
    .pwr1_on19(pwr1_on_macb2_int19),
    .pwr2_on19(pwr2_on_macb2_int19)
    );
  // power19 control19 for macb319
  power_ctrl_sm19 i_macb3_power_ctrl_sm19(
    .pclk19(pclk19),
    .nprst19(nprst19),
    .L1_module_req19(L1_ctrl_domain19[6]),
    .set_status_module19(set_status_macb319),
    .clr_status_module19(clr_status_macb319),
    .rstn_non_srpg_module19(rstn_non_srpg_macb3_int19),
    .gate_clk_module19(gate_clk_macb3_int19),
    .isolate_module19(isolate_macb3_int19),
    .save_edge19(save_edge_macb3_int19),
    .restore_edge19(restore_edge_macb3_int19),
    .pwr1_on19(pwr1_on_macb3_int19),
    .pwr2_on19(pwr2_on_macb3_int19)
    );
  // power19 control19 for dma19
  power_ctrl_sm19 i_dma_power_ctrl_sm19(
    .pclk19(pclk19),
    .nprst19(nprst19),
    .L1_module_req19(L1_ctrl_domain19[7]),
    .set_status_module19(set_status_dma19),
    .clr_status_module19(clr_status_dma19),
    .rstn_non_srpg_module19(rstn_non_srpg_dma_int19),
    .gate_clk_module19(gate_clk_dma_int19),
    .isolate_module19(isolate_dma_int19),
    .save_edge19(save_edge_dma_int19),
    .restore_edge19(restore_edge_dma_int19),
    .pwr1_on19(pwr1_on_dma_int19),
    .pwr2_on19(pwr2_on_dma_int19)
    );
  // power19 control19 for CPU19
  power_ctrl_sm19 i_cpu_power_ctrl_sm19(
    .pclk19(pclk19),
    .nprst19(nprst19),
    .L1_module_req19(cpu_shutoff_ctrl19),
    .set_status_module19(set_status_cpu19),
    .clr_status_module19(clr_status_cpu19),
    .rstn_non_srpg_module19(rstn_non_srpg_cpu_int19),
    .gate_clk_module19(gate_clk_cpu_int19),
    .isolate_module19(isolate_cpu_int19),
    .save_edge19(save_edge_cpu_int19),
    .restore_edge19(restore_edge_cpu_int19),
    .pwr1_on19(pwr1_on_cpu_int19),
    .pwr2_on19(pwr2_on_cpu_int19)
    );

  assign valid_reg_write19 =  (psel19 && pwrite19 && penable19);
  assign valid_reg_read19  =  (psel19 && (!pwrite19) && penable19);

  assign L1_ctrl_access19  =  (paddr19[15:0] == 16'b0000000000000100); 
  assign L1_status_access19 = (paddr19[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access19 =   (paddr19[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access19 = (paddr19[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control19 and status register
  always @(*)
  begin  
    if(valid_reg_read19 && L1_ctrl_access19) 
      prdata19 = L1_ctrl_reg19;
    else if (valid_reg_read19 && L1_status_access19)
      prdata19 = L1_status_reg19;
    else if (valid_reg_read19 && pcm_int_mask_access19)
      prdata19 = pcm_mask_reg19;
    else if (valid_reg_read19 && pcm_int_status_access19)
      prdata19 = pcm_status_reg19;
    else 
      prdata19 = 0;
  end

  assign set_status_mem19 =  (set_status_macb019 && set_status_macb119 && set_status_macb219 &&
                            set_status_macb319 && set_status_dma19 && set_status_cpu19);

  assign clr_status_mem19 =  (clr_status_macb019 && clr_status_macb119 && clr_status_macb219 &&
                            clr_status_macb319 && clr_status_dma19 && clr_status_cpu19);

  assign set_status_alut19 = (set_status_macb019 && set_status_macb119 && set_status_macb219 && set_status_macb319);

  assign clr_status_alut19 = (clr_status_macb019 || clr_status_macb119 || clr_status_macb219  || clr_status_macb319);

  // Write accesses to the control19 and status register
 
  always @(posedge pclk19 or negedge nprst19)
  begin
    if (!nprst19) begin
      L1_ctrl_reg19   <= 0;
      L1_status_reg19 <= 0;
      pcm_mask_reg19 <= 0;
    end else begin
      // CTRL19 reg updates19
      if (valid_reg_write19 && L1_ctrl_access19) 
        L1_ctrl_reg19 <= pwdata19; // Writes19 to the ctrl19 reg
      if (valid_reg_write19 && pcm_int_mask_access19) 
        pcm_mask_reg19 <= pwdata19; // Writes19 to the ctrl19 reg

      if (set_status_urt19 == 1'b1)  
        L1_status_reg19[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt19 == 1'b1) 
        L1_status_reg19[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc19 == 1'b1) 
        L1_status_reg19[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc19 == 1'b1) 
        L1_status_reg19[2] <= 1'b0; // Clear the status bit

      if (set_status_macb019 == 1'b1)  
        L1_status_reg19[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb019 == 1'b1) 
        L1_status_reg19[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb119 == 1'b1)  
        L1_status_reg19[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb119 == 1'b1) 
        L1_status_reg19[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb219 == 1'b1)  
        L1_status_reg19[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb219 == 1'b1) 
        L1_status_reg19[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb319 == 1'b1)  
        L1_status_reg19[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb319 == 1'b1) 
        L1_status_reg19[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma19 == 1'b1)  
        L1_status_reg19[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma19 == 1'b1) 
        L1_status_reg19[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu19 == 1'b1)  
        L1_status_reg19[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu19 == 1'b1) 
        L1_status_reg19[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut19 == 1'b1)  
        L1_status_reg19[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut19 == 1'b1) 
        L1_status_reg19[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem19 == 1'b1)  
        L1_status_reg19[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem19 == 1'b1) 
        L1_status_reg19[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused19 bits of pcm_status_reg19 are tied19 to 0
  always @(posedge pclk19 or negedge nprst19)
  begin
    if (!nprst19)
      pcm_status_reg19[31:4] <= 'b0;
    else  
      pcm_status_reg19[31:4] <= pcm_status_reg19[31:4];
  end
  
  // interrupt19 only of h/w assisted19 wakeup
  // MAC19 3
  always @(posedge pclk19 or negedge nprst19)
  begin
    if(!nprst19)
      pcm_status_reg19[3] <= 1'b0;
    else if (valid_reg_write19 && pcm_int_status_access19) 
      pcm_status_reg19[3] <= pwdata19[3];
    else if (macb3_wakeup19 & ~pcm_mask_reg19[3])
      pcm_status_reg19[3] <= 1'b1;
    else if (valid_reg_read19 && pcm_int_status_access19) 
      pcm_status_reg19[3] <= 1'b0;
    else
      pcm_status_reg19[3] <= pcm_status_reg19[3];
  end  
   
  // MAC19 2
  always @(posedge pclk19 or negedge nprst19)
  begin
    if(!nprst19)
      pcm_status_reg19[2] <= 1'b0;
    else if (valid_reg_write19 && pcm_int_status_access19) 
      pcm_status_reg19[2] <= pwdata19[2];
    else if (macb2_wakeup19 & ~pcm_mask_reg19[2])
      pcm_status_reg19[2] <= 1'b1;
    else if (valid_reg_read19 && pcm_int_status_access19) 
      pcm_status_reg19[2] <= 1'b0;
    else
      pcm_status_reg19[2] <= pcm_status_reg19[2];
  end  

  // MAC19 1
  always @(posedge pclk19 or negedge nprst19)
  begin
    if(!nprst19)
      pcm_status_reg19[1] <= 1'b0;
    else if (valid_reg_write19 && pcm_int_status_access19) 
      pcm_status_reg19[1] <= pwdata19[1];
    else if (macb1_wakeup19 & ~pcm_mask_reg19[1])
      pcm_status_reg19[1] <= 1'b1;
    else if (valid_reg_read19 && pcm_int_status_access19) 
      pcm_status_reg19[1] <= 1'b0;
    else
      pcm_status_reg19[1] <= pcm_status_reg19[1];
  end  
   
  // MAC19 0
  always @(posedge pclk19 or negedge nprst19)
  begin
    if(!nprst19)
      pcm_status_reg19[0] <= 1'b0;
    else if (valid_reg_write19 && pcm_int_status_access19) 
      pcm_status_reg19[0] <= pwdata19[0];
    else if (macb0_wakeup19 & ~pcm_mask_reg19[0])
      pcm_status_reg19[0] <= 1'b1;
    else if (valid_reg_read19 && pcm_int_status_access19) 
      pcm_status_reg19[0] <= 1'b0;
    else
      pcm_status_reg19[0] <= pcm_status_reg19[0];
  end  

  assign pcm_macb_wakeup_int19 = |pcm_status_reg19;

  reg [31:0] L1_ctrl_reg119;
  always @(posedge pclk19 or negedge nprst19)
  begin
    if(!nprst19)
      L1_ctrl_reg119 <= 0;
    else
      L1_ctrl_reg119 <= L1_ctrl_reg19;
  end

  // Program19 mode decode
  always @(L1_ctrl_reg19 or L1_ctrl_reg119 or int_source_h19 or cpu_shutoff_ctrl19) begin
    mte_smc_start19 = 0;
    mte_uart_start19 = 0;
    mte_smc_uart_start19  = 0;
    mte_mac_off_start19  = 0;
    mte_mac012_start19 = 0;
    mte_mac013_start19 = 0;
    mte_mac023_start19 = 0;
    mte_mac123_start19 = 0;
    mte_mac01_start19 = 0;
    mte_mac02_start19 = 0;
    mte_mac03_start19 = 0;
    mte_mac12_start19 = 0;
    mte_mac13_start19 = 0;
    mte_mac23_start19 = 0;
    mte_mac0_start19 = 0;
    mte_mac1_start19 = 0;
    mte_mac2_start19 = 0;
    mte_mac3_start19 = 0;
    mte_sys_hibernate19 = 0 ;
    mte_dma_start19 = 0 ;
    mte_cpu_start19 = 0 ;

    mte_mac0_sleep_start19 = (L1_ctrl_reg19 ==  'h14) && (L1_ctrl_reg119 == 'h4 );
    mte_mac1_sleep_start19 = (L1_ctrl_reg19 ==  'h14) && (L1_ctrl_reg119 == 'h5 ); 
    mte_mac2_sleep_start19 = (L1_ctrl_reg19 ==  'h14) && (L1_ctrl_reg119 == 'h6 ); 
    mte_mac3_sleep_start19 = (L1_ctrl_reg19 ==  'h14) && (L1_ctrl_reg119 == 'h7 ); 
    mte_mac01_sleep_start19 = (L1_ctrl_reg19 ==  'h14) && (L1_ctrl_reg119 == 'h8 ); 
    mte_mac02_sleep_start19 = (L1_ctrl_reg19 ==  'h14) && (L1_ctrl_reg119 == 'h9 ); 
    mte_mac03_sleep_start19 = (L1_ctrl_reg19 ==  'h14) && (L1_ctrl_reg119 == 'hA ); 
    mte_mac12_sleep_start19 = (L1_ctrl_reg19 ==  'h14) && (L1_ctrl_reg119 == 'hB ); 
    mte_mac13_sleep_start19 = (L1_ctrl_reg19 ==  'h14) && (L1_ctrl_reg119 == 'hC ); 
    mte_mac23_sleep_start19 = (L1_ctrl_reg19 ==  'h14) && (L1_ctrl_reg119 == 'hD ); 
    mte_mac012_sleep_start19 = (L1_ctrl_reg19 ==  'h14) && (L1_ctrl_reg119 == 'hE ); 
    mte_mac013_sleep_start19 = (L1_ctrl_reg19 ==  'h14) && (L1_ctrl_reg119 == 'hF ); 
    mte_mac023_sleep_start19 = (L1_ctrl_reg19 ==  'h14) && (L1_ctrl_reg119 == 'h10 ); 
    mte_mac123_sleep_start19 = (L1_ctrl_reg19 ==  'h14) && (L1_ctrl_reg119 == 'h11 ); 
    mte_mac_off_sleep_start19 =  (L1_ctrl_reg19 == 'h14) && (L1_ctrl_reg119 == 'h12 );
    mte_dma_sleep_start19 =  (L1_ctrl_reg19 == 'h14) && (L1_ctrl_reg119 == 'h13 );

    mte_pm_uart_to_default_start19 = (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'h1);
    mte_pm_smc_to_default_start19 = (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'h2);
    mte_pm_smc_uart_to_default_start19 = (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'h3); 
    mte_mac0_to_default19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'h4); 
    mte_mac1_to_default19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'h5); 
    mte_mac2_to_default19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'h6); 
    mte_mac3_to_default19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'h7); 
    mte_mac01_to_default19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'h8); 
    mte_mac02_to_default19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'h9); 
    mte_mac03_to_default19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'hA); 
    mte_mac12_to_default19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'hB); 
    mte_mac13_to_default19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'hC); 
    mte_mac23_to_default19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'hD); 
    mte_mac012_to_default19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'hE); 
    mte_mac013_to_default19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'hF); 
    mte_mac023_to_default19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'h10); 
    mte_mac123_to_default19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'h11); 
    mte_mac_off_to_default19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'h12); 
    mte_dma_isolate_dis19 =  (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'h13); 
    mte_cpu_isolate_dis19 =  (int_source_h19) && (cpu_shutoff_ctrl19) && (L1_ctrl_reg19 != 'h15);
    mte_sys_hibernate_to_default19 = (L1_ctrl_reg19 == 32'h0) && (L1_ctrl_reg119 == 'h15); 

   
    if (L1_ctrl_reg119 == 'h0) begin // This19 check is to make mte_cpu_start19
                                   // is set only when you from default state 
      case (L1_ctrl_reg19)
        'h0 : L1_ctrl_domain19 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain19 = 32'h2; // PM_uart19
                mte_uart_start19 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain19 = 32'h4; // PM_smc19
                mte_smc_start19 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain19 = 32'h6; // PM_smc_uart19
                mte_smc_uart_start19 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain19 = 32'h8; //  PM_macb019
                mte_mac0_start19 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain19 = 32'h10; //  PM_macb119
                mte_mac1_start19 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain19 = 32'h20; //  PM_macb219
                mte_mac2_start19 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain19 = 32'h40; //  PM_macb319
                mte_mac3_start19 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain19 = 32'h18; //  PM_macb0119
                mte_mac01_start19 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain19 = 32'h28; //  PM_macb0219
                mte_mac02_start19 = 1;
              end
        'hA : begin  
                L1_ctrl_domain19 = 32'h48; //  PM_macb0319
                mte_mac03_start19 = 1;
              end
        'hB : begin  
                L1_ctrl_domain19 = 32'h30; //  PM_macb1219
                mte_mac12_start19 = 1;
              end
        'hC : begin  
                L1_ctrl_domain19 = 32'h50; //  PM_macb1319
                mte_mac13_start19 = 1;
              end
        'hD : begin  
                L1_ctrl_domain19 = 32'h60; //  PM_macb2319
                mte_mac23_start19 = 1;
              end
        'hE : begin  
                L1_ctrl_domain19 = 32'h38; //  PM_macb01219
                mte_mac012_start19 = 1;
              end
        'hF : begin  
                L1_ctrl_domain19 = 32'h58; //  PM_macb01319
                mte_mac013_start19 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain19 = 32'h68; //  PM_macb02319
                mte_mac023_start19 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain19 = 32'h70; //  PM_macb12319
                mte_mac123_start19 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain19 = 32'h78; //  PM_macb_off19
                mte_mac_off_start19 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain19 = 32'h80; //  PM_dma19
                mte_dma_start19 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain19 = 32'h100; //  PM_cpu_sleep19
                mte_cpu_start19 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain19 = 32'h1FE; //  PM_hibernate19
                mte_sys_hibernate19 = 1;
              end
         default: L1_ctrl_domain19 = 32'h0;
      endcase
    end
  end


  wire to_default19 = (L1_ctrl_reg19 == 0);

  // Scan19 mode gating19 of power19 and isolation19 control19 signals19
  //SMC19
  assign rstn_non_srpg_smc19  = (scan_mode19 == 1'b0) ? rstn_non_srpg_smc_int19 : 1'b1;  
  assign gate_clk_smc19       = (scan_mode19 == 1'b0) ? gate_clk_smc_int19 : 1'b0;     
  assign isolate_smc19        = (scan_mode19 == 1'b0) ? isolate_smc_int19 : 1'b0;      
  assign pwr1_on_smc19        = (scan_mode19 == 1'b0) ? pwr1_on_smc_int19 : 1'b1;       
  assign pwr2_on_smc19        = (scan_mode19 == 1'b0) ? pwr2_on_smc_int19 : 1'b1;       
  assign pwr1_off_smc19       = (scan_mode19 == 1'b0) ? (!pwr1_on_smc_int19) : 1'b0;       
  assign pwr2_off_smc19       = (scan_mode19 == 1'b0) ? (!pwr2_on_smc_int19) : 1'b0;       
  assign save_edge_smc19       = (scan_mode19 == 1'b0) ? (save_edge_smc_int19) : 1'b0;       
  assign restore_edge_smc19       = (scan_mode19 == 1'b0) ? (restore_edge_smc_int19) : 1'b0;       

  //URT19
  assign rstn_non_srpg_urt19  = (scan_mode19 == 1'b0) ?  rstn_non_srpg_urt_int19 : 1'b1;  
  assign gate_clk_urt19       = (scan_mode19 == 1'b0) ?  gate_clk_urt_int19      : 1'b0;     
  assign isolate_urt19        = (scan_mode19 == 1'b0) ?  isolate_urt_int19       : 1'b0;      
  assign pwr1_on_urt19        = (scan_mode19 == 1'b0) ?  pwr1_on_urt_int19       : 1'b1;       
  assign pwr2_on_urt19        = (scan_mode19 == 1'b0) ?  pwr2_on_urt_int19       : 1'b1;       
  assign pwr1_off_urt19       = (scan_mode19 == 1'b0) ?  (!pwr1_on_urt_int19)  : 1'b0;       
  assign pwr2_off_urt19       = (scan_mode19 == 1'b0) ?  (!pwr2_on_urt_int19)  : 1'b0;       
  assign save_edge_urt19       = (scan_mode19 == 1'b0) ? (save_edge_urt_int19) : 1'b0;       
  assign restore_edge_urt19       = (scan_mode19 == 1'b0) ? (restore_edge_urt_int19) : 1'b0;       

  //ETH019
  assign rstn_non_srpg_macb019 = (scan_mode19 == 1'b0) ?  rstn_non_srpg_macb0_int19 : 1'b1;  
  assign gate_clk_macb019       = (scan_mode19 == 1'b0) ?  gate_clk_macb0_int19      : 1'b0;     
  assign isolate_macb019        = (scan_mode19 == 1'b0) ?  isolate_macb0_int19       : 1'b0;      
  assign pwr1_on_macb019        = (scan_mode19 == 1'b0) ?  pwr1_on_macb0_int19       : 1'b1;       
  assign pwr2_on_macb019        = (scan_mode19 == 1'b0) ?  pwr2_on_macb0_int19       : 1'b1;       
  assign pwr1_off_macb019       = (scan_mode19 == 1'b0) ?  (!pwr1_on_macb0_int19)  : 1'b0;       
  assign pwr2_off_macb019       = (scan_mode19 == 1'b0) ?  (!pwr2_on_macb0_int19)  : 1'b0;       
  assign save_edge_macb019       = (scan_mode19 == 1'b0) ? (save_edge_macb0_int19) : 1'b0;       
  assign restore_edge_macb019       = (scan_mode19 == 1'b0) ? (restore_edge_macb0_int19) : 1'b0;       

  //ETH119
  assign rstn_non_srpg_macb119 = (scan_mode19 == 1'b0) ?  rstn_non_srpg_macb1_int19 : 1'b1;  
  assign gate_clk_macb119       = (scan_mode19 == 1'b0) ?  gate_clk_macb1_int19      : 1'b0;     
  assign isolate_macb119        = (scan_mode19 == 1'b0) ?  isolate_macb1_int19       : 1'b0;      
  assign pwr1_on_macb119        = (scan_mode19 == 1'b0) ?  pwr1_on_macb1_int19       : 1'b1;       
  assign pwr2_on_macb119        = (scan_mode19 == 1'b0) ?  pwr2_on_macb1_int19       : 1'b1;       
  assign pwr1_off_macb119       = (scan_mode19 == 1'b0) ?  (!pwr1_on_macb1_int19)  : 1'b0;       
  assign pwr2_off_macb119       = (scan_mode19 == 1'b0) ?  (!pwr2_on_macb1_int19)  : 1'b0;       
  assign save_edge_macb119       = (scan_mode19 == 1'b0) ? (save_edge_macb1_int19) : 1'b0;       
  assign restore_edge_macb119       = (scan_mode19 == 1'b0) ? (restore_edge_macb1_int19) : 1'b0;       

  //ETH219
  assign rstn_non_srpg_macb219 = (scan_mode19 == 1'b0) ?  rstn_non_srpg_macb2_int19 : 1'b1;  
  assign gate_clk_macb219       = (scan_mode19 == 1'b0) ?  gate_clk_macb2_int19      : 1'b0;     
  assign isolate_macb219        = (scan_mode19 == 1'b0) ?  isolate_macb2_int19       : 1'b0;      
  assign pwr1_on_macb219        = (scan_mode19 == 1'b0) ?  pwr1_on_macb2_int19       : 1'b1;       
  assign pwr2_on_macb219        = (scan_mode19 == 1'b0) ?  pwr2_on_macb2_int19       : 1'b1;       
  assign pwr1_off_macb219       = (scan_mode19 == 1'b0) ?  (!pwr1_on_macb2_int19)  : 1'b0;       
  assign pwr2_off_macb219       = (scan_mode19 == 1'b0) ?  (!pwr2_on_macb2_int19)  : 1'b0;       
  assign save_edge_macb219       = (scan_mode19 == 1'b0) ? (save_edge_macb2_int19) : 1'b0;       
  assign restore_edge_macb219       = (scan_mode19 == 1'b0) ? (restore_edge_macb2_int19) : 1'b0;       

  //ETH319
  assign rstn_non_srpg_macb319 = (scan_mode19 == 1'b0) ?  rstn_non_srpg_macb3_int19 : 1'b1;  
  assign gate_clk_macb319       = (scan_mode19 == 1'b0) ?  gate_clk_macb3_int19      : 1'b0;     
  assign isolate_macb319        = (scan_mode19 == 1'b0) ?  isolate_macb3_int19       : 1'b0;      
  assign pwr1_on_macb319        = (scan_mode19 == 1'b0) ?  pwr1_on_macb3_int19       : 1'b1;       
  assign pwr2_on_macb319        = (scan_mode19 == 1'b0) ?  pwr2_on_macb3_int19       : 1'b1;       
  assign pwr1_off_macb319       = (scan_mode19 == 1'b0) ?  (!pwr1_on_macb3_int19)  : 1'b0;       
  assign pwr2_off_macb319       = (scan_mode19 == 1'b0) ?  (!pwr2_on_macb3_int19)  : 1'b0;       
  assign save_edge_macb319       = (scan_mode19 == 1'b0) ? (save_edge_macb3_int19) : 1'b0;       
  assign restore_edge_macb319       = (scan_mode19 == 1'b0) ? (restore_edge_macb3_int19) : 1'b0;       

  // MEM19
  assign rstn_non_srpg_mem19 =   (rstn_non_srpg_macb019 && rstn_non_srpg_macb119 && rstn_non_srpg_macb219 &&
                                rstn_non_srpg_macb319 && rstn_non_srpg_dma19 && rstn_non_srpg_cpu19 && rstn_non_srpg_urt19 &&
                                rstn_non_srpg_smc19);

  assign gate_clk_mem19 =  (gate_clk_macb019 && gate_clk_macb119 && gate_clk_macb219 &&
                            gate_clk_macb319 && gate_clk_dma19 && gate_clk_cpu19 && gate_clk_urt19 && gate_clk_smc19);

  assign isolate_mem19  = (isolate_macb019 && isolate_macb119 && isolate_macb219 &&
                         isolate_macb319 && isolate_dma19 && isolate_cpu19 && isolate_urt19 && isolate_smc19);


  assign pwr1_on_mem19        =   ~pwr1_off_mem19;

  assign pwr2_on_mem19        =   ~pwr2_off_mem19;

  assign pwr1_off_mem19       =  (pwr1_off_macb019 && pwr1_off_macb119 && pwr1_off_macb219 &&
                                 pwr1_off_macb319 && pwr1_off_dma19 && pwr1_off_cpu19 && pwr1_off_urt19 && pwr1_off_smc19);


  assign pwr2_off_mem19       =  (pwr2_off_macb019 && pwr2_off_macb119 && pwr2_off_macb219 &&
                                pwr2_off_macb319 && pwr2_off_dma19 && pwr2_off_cpu19 && pwr2_off_urt19 && pwr2_off_smc19);

  assign save_edge_mem19      =  (save_edge_macb019 && save_edge_macb119 && save_edge_macb219 &&
                                save_edge_macb319 && save_edge_dma19 && save_edge_cpu19 && save_edge_smc19 && save_edge_urt19);

  assign restore_edge_mem19   =  (restore_edge_macb019 && restore_edge_macb119 && restore_edge_macb219  &&
                                restore_edge_macb319 && restore_edge_dma19 && restore_edge_cpu19 && restore_edge_urt19 &&
                                restore_edge_smc19);

  assign standby_mem019 = pwr1_off_macb019 && (~ (pwr1_off_macb019 && pwr1_off_macb119 && pwr1_off_macb219 && pwr1_off_macb319 && pwr1_off_urt19 && pwr1_off_smc19 && pwr1_off_dma19 && pwr1_off_cpu19));
  assign standby_mem119 = pwr1_off_macb119 && (~ (pwr1_off_macb019 && pwr1_off_macb119 && pwr1_off_macb219 && pwr1_off_macb319 && pwr1_off_urt19 && pwr1_off_smc19 && pwr1_off_dma19 && pwr1_off_cpu19));
  assign standby_mem219 = pwr1_off_macb219 && (~ (pwr1_off_macb019 && pwr1_off_macb119 && pwr1_off_macb219 && pwr1_off_macb319 && pwr1_off_urt19 && pwr1_off_smc19 && pwr1_off_dma19 && pwr1_off_cpu19));
  assign standby_mem319 = pwr1_off_macb319 && (~ (pwr1_off_macb019 && pwr1_off_macb119 && pwr1_off_macb219 && pwr1_off_macb319 && pwr1_off_urt19 && pwr1_off_smc19 && pwr1_off_dma19 && pwr1_off_cpu19));

  assign pwr1_off_mem019 = pwr1_off_mem19;
  assign pwr1_off_mem119 = pwr1_off_mem19;
  assign pwr1_off_mem219 = pwr1_off_mem19;
  assign pwr1_off_mem319 = pwr1_off_mem19;

  assign rstn_non_srpg_alut19  =  (rstn_non_srpg_macb019 && rstn_non_srpg_macb119 && rstn_non_srpg_macb219 && rstn_non_srpg_macb319);


   assign gate_clk_alut19       =  (gate_clk_macb019 && gate_clk_macb119 && gate_clk_macb219 && gate_clk_macb319);


    assign isolate_alut19        =  (isolate_macb019 && isolate_macb119 && isolate_macb219 && isolate_macb319);


    assign pwr1_on_alut19        =  (pwr1_on_macb019 || pwr1_on_macb119 || pwr1_on_macb219 || pwr1_on_macb319);


    assign pwr2_on_alut19        =  (pwr2_on_macb019 || pwr2_on_macb119 || pwr2_on_macb219 || pwr2_on_macb319);


    assign pwr1_off_alut19       =  (pwr1_off_macb019 && pwr1_off_macb119 && pwr1_off_macb219 && pwr1_off_macb319);


    assign pwr2_off_alut19       =  (pwr2_off_macb019 && pwr2_off_macb119 && pwr2_off_macb219 && pwr2_off_macb319);


    assign save_edge_alut19      =  (save_edge_macb019 && save_edge_macb119 && save_edge_macb219 && save_edge_macb319);


    assign restore_edge_alut19   =  (restore_edge_macb019 || restore_edge_macb119 || restore_edge_macb219 ||
                                   restore_edge_macb319) && save_alut_tmp19;

     // alut19 power19 off19 detection19
  always @(posedge pclk19 or negedge nprst19) begin
    if (!nprst19) 
       save_alut_tmp19 <= 0;
    else if (restore_edge_alut19)
       save_alut_tmp19 <= 0;
    else if (save_edge_alut19)
       save_alut_tmp19 <= 1;
  end

  //DMA19
  assign rstn_non_srpg_dma19 = (scan_mode19 == 1'b0) ?  rstn_non_srpg_dma_int19 : 1'b1;  
  assign gate_clk_dma19       = (scan_mode19 == 1'b0) ?  gate_clk_dma_int19      : 1'b0;     
  assign isolate_dma19        = (scan_mode19 == 1'b0) ?  isolate_dma_int19       : 1'b0;      
  assign pwr1_on_dma19        = (scan_mode19 == 1'b0) ?  pwr1_on_dma_int19       : 1'b1;       
  assign pwr2_on_dma19        = (scan_mode19 == 1'b0) ?  pwr2_on_dma_int19       : 1'b1;       
  assign pwr1_off_dma19       = (scan_mode19 == 1'b0) ?  (!pwr1_on_dma_int19)  : 1'b0;       
  assign pwr2_off_dma19       = (scan_mode19 == 1'b0) ?  (!pwr2_on_dma_int19)  : 1'b0;       
  assign save_edge_dma19       = (scan_mode19 == 1'b0) ? (save_edge_dma_int19) : 1'b0;       
  assign restore_edge_dma19       = (scan_mode19 == 1'b0) ? (restore_edge_dma_int19) : 1'b0;       

  //CPU19
  assign rstn_non_srpg_cpu19 = (scan_mode19 == 1'b0) ?  rstn_non_srpg_cpu_int19 : 1'b1;  
  assign gate_clk_cpu19       = (scan_mode19 == 1'b0) ?  gate_clk_cpu_int19      : 1'b0;     
  assign isolate_cpu19        = (scan_mode19 == 1'b0) ?  isolate_cpu_int19       : 1'b0;      
  assign pwr1_on_cpu19        = (scan_mode19 == 1'b0) ?  pwr1_on_cpu_int19       : 1'b1;       
  assign pwr2_on_cpu19        = (scan_mode19 == 1'b0) ?  pwr2_on_cpu_int19       : 1'b1;       
  assign pwr1_off_cpu19       = (scan_mode19 == 1'b0) ?  (!pwr1_on_cpu_int19)  : 1'b0;       
  assign pwr2_off_cpu19       = (scan_mode19 == 1'b0) ?  (!pwr2_on_cpu_int19)  : 1'b0;       
  assign save_edge_cpu19       = (scan_mode19 == 1'b0) ? (save_edge_cpu_int19) : 1'b0;       
  assign restore_edge_cpu19       = (scan_mode19 == 1'b0) ? (restore_edge_cpu_int19) : 1'b0;       



  // ASE19

   reg ase_core_12v19, ase_core_10v19, ase_core_08v19, ase_core_06v19;
   reg ase_macb0_12v19,ase_macb1_12v19,ase_macb2_12v19,ase_macb3_12v19;

    // core19 ase19

    // core19 at 1.0 v if (smc19 off19, urt19 off19, macb019 off19, macb119 off19, macb219 off19, macb319 off19
   // core19 at 0.8v if (mac01off19, macb02off19, macb03off19, macb12off19, mac13off19, mac23off19,
   // core19 at 0.6v if (mac012off19, mac013off19, mac023off19, mac123off19, mac0123off19
    // else core19 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb019 && pwr1_off_macb119 && pwr1_off_macb219 && pwr1_off_macb319) || // all mac19 off19
       (pwr1_off_macb319 && pwr1_off_macb219 && pwr1_off_macb119) || // mac123off19 
       (pwr1_off_macb319 && pwr1_off_macb219 && pwr1_off_macb019) || // mac023off19 
       (pwr1_off_macb319 && pwr1_off_macb119 && pwr1_off_macb019) || // mac013off19 
       (pwr1_off_macb219 && pwr1_off_macb119 && pwr1_off_macb019) )  // mac012off19 
       begin
         ase_core_12v19 = 0;
         ase_core_10v19 = 0;
         ase_core_08v19 = 0;
         ase_core_06v19 = 1;
       end
     else if( (pwr1_off_macb219 && pwr1_off_macb319) || // mac2319 off19
         (pwr1_off_macb319 && pwr1_off_macb119) || // mac13off19 
         (pwr1_off_macb119 && pwr1_off_macb219) || // mac12off19 
         (pwr1_off_macb319 && pwr1_off_macb019) || // mac03off19 
         (pwr1_off_macb219 && pwr1_off_macb019) || // mac02off19 
         (pwr1_off_macb119 && pwr1_off_macb019))  // mac01off19 
       begin
         ase_core_12v19 = 0;
         ase_core_10v19 = 0;
         ase_core_08v19 = 1;
         ase_core_06v19 = 0;
       end
     else if( (pwr1_off_smc19) || // smc19 off19
         (pwr1_off_macb019 ) || // mac0off19 
         (pwr1_off_macb119 ) || // mac1off19 
         (pwr1_off_macb219 ) || // mac2off19 
         (pwr1_off_macb319 ))  // mac3off19 
       begin
         ase_core_12v19 = 0;
         ase_core_10v19 = 1;
         ase_core_08v19 = 0;
         ase_core_06v19 = 0;
       end
     else if (pwr1_off_urt19)
       begin
         ase_core_12v19 = 1;
         ase_core_10v19 = 0;
         ase_core_08v19 = 0;
         ase_core_06v19 = 0;
       end
     else
       begin
         ase_core_12v19 = 1;
         ase_core_10v19 = 0;
         ase_core_08v19 = 0;
         ase_core_06v19 = 0;
       end
   end


   // cpu19
   // cpu19 @ 1.0v when macoff19, 
   // 
   reg ase_cpu_10v19, ase_cpu_12v19;
   always @(*) begin
    if(pwr1_off_cpu19) begin
     ase_cpu_12v19 = 1'b0;
     ase_cpu_10v19 = 1'b0;
    end
    else if(pwr1_off_macb019 || pwr1_off_macb119 || pwr1_off_macb219 || pwr1_off_macb319)
    begin
     ase_cpu_12v19 = 1'b0;
     ase_cpu_10v19 = 1'b1;
    end
    else
    begin
     ase_cpu_12v19 = 1'b1;
     ase_cpu_10v19 = 1'b0;
    end
   end

   // dma19
   // dma19 @v119.0 for macoff19, 

   reg ase_dma_10v19, ase_dma_12v19;
   always @(*) begin
    if(pwr1_off_dma19) begin
     ase_dma_12v19 = 1'b0;
     ase_dma_10v19 = 1'b0;
    end
    else if(pwr1_off_macb019 || pwr1_off_macb119 || pwr1_off_macb219 || pwr1_off_macb319)
    begin
     ase_dma_12v19 = 1'b0;
     ase_dma_10v19 = 1'b1;
    end
    else
    begin
     ase_dma_12v19 = 1'b1;
     ase_dma_10v19 = 1'b0;
    end
   end

   // alut19
   // @ v119.0 for macoff19

   reg ase_alut_10v19, ase_alut_12v19;
   always @(*) begin
    if(pwr1_off_alut19) begin
     ase_alut_12v19 = 1'b0;
     ase_alut_10v19 = 1'b0;
    end
    else if(pwr1_off_macb019 || pwr1_off_macb119 || pwr1_off_macb219 || pwr1_off_macb319)
    begin
     ase_alut_12v19 = 1'b0;
     ase_alut_10v19 = 1'b1;
    end
    else
    begin
     ase_alut_12v19 = 1'b1;
     ase_alut_10v19 = 1'b0;
    end
   end




   reg ase_uart_12v19;
   reg ase_uart_10v19;
   reg ase_uart_08v19;
   reg ase_uart_06v19;

   reg ase_smc_12v19;


   always @(*) begin
     if(pwr1_off_urt19) begin // uart19 off19
       ase_uart_08v19 = 1'b0;
       ase_uart_06v19 = 1'b0;
       ase_uart_10v19 = 1'b0;
       ase_uart_12v19 = 1'b0;
     end 
     else if( (pwr1_off_macb019 && pwr1_off_macb119 && pwr1_off_macb219 && pwr1_off_macb319) || // all mac19 off19
       (pwr1_off_macb319 && pwr1_off_macb219 && pwr1_off_macb119) || // mac123off19 
       (pwr1_off_macb319 && pwr1_off_macb219 && pwr1_off_macb019) || // mac023off19 
       (pwr1_off_macb319 && pwr1_off_macb119 && pwr1_off_macb019) || // mac013off19 
       (pwr1_off_macb219 && pwr1_off_macb119 && pwr1_off_macb019) )  // mac012off19 
     begin
       ase_uart_06v19 = 1'b1;
       ase_uart_08v19 = 1'b0;
       ase_uart_10v19 = 1'b0;
       ase_uart_12v19 = 1'b0;
     end
     else if( (pwr1_off_macb219 && pwr1_off_macb319) || // mac2319 off19
         (pwr1_off_macb319 && pwr1_off_macb119) || // mac13off19 
         (pwr1_off_macb119 && pwr1_off_macb219) || // mac12off19 
         (pwr1_off_macb319 && pwr1_off_macb019) || // mac03off19 
         (pwr1_off_macb119 && pwr1_off_macb019))  // mac01off19  
     begin
       ase_uart_06v19 = 1'b0;
       ase_uart_08v19 = 1'b1;
       ase_uart_10v19 = 1'b0;
       ase_uart_12v19 = 1'b0;
     end
     else if (pwr1_off_smc19 || pwr1_off_macb019 || pwr1_off_macb119 || pwr1_off_macb219 || pwr1_off_macb319) begin // smc19 off19
       ase_uart_08v19 = 1'b0;
       ase_uart_06v19 = 1'b0;
       ase_uart_10v19 = 1'b1;
       ase_uart_12v19 = 1'b0;
     end 
     else begin
       ase_uart_08v19 = 1'b0;
       ase_uart_06v19 = 1'b0;
       ase_uart_10v19 = 1'b0;
       ase_uart_12v19 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc19) begin
     if (pwr1_off_smc19)  // smc19 off19
       ase_smc_12v19 = 1'b0;
    else
       ase_smc_12v19 = 1'b1;
   end

   
   always @(pwr1_off_macb019) begin
     if (pwr1_off_macb019) // macb019 off19
       ase_macb0_12v19 = 1'b0;
     else
       ase_macb0_12v19 = 1'b1;
   end

   always @(pwr1_off_macb119) begin
     if (pwr1_off_macb119) // macb119 off19
       ase_macb1_12v19 = 1'b0;
     else
       ase_macb1_12v19 = 1'b1;
   end

   always @(pwr1_off_macb219) begin // macb219 off19
     if (pwr1_off_macb219) // macb219 off19
       ase_macb2_12v19 = 1'b0;
     else
       ase_macb2_12v19 = 1'b1;
   end

   always @(pwr1_off_macb319) begin // macb319 off19
     if (pwr1_off_macb319) // macb319 off19
       ase_macb3_12v19 = 1'b0;
     else
       ase_macb3_12v19 = 1'b1;
   end


   // core19 voltage19 for vco19
  assign core12v19 = ase_macb0_12v19 & ase_macb1_12v19 & ase_macb2_12v19 & ase_macb3_12v19;

  assign core10v19 =  (ase_macb0_12v19 & ase_macb1_12v19 & ase_macb2_12v19 & (!ase_macb3_12v19)) ||
                    (ase_macb0_12v19 & ase_macb1_12v19 & (!ase_macb2_12v19) & ase_macb3_12v19) ||
                    (ase_macb0_12v19 & (!ase_macb1_12v19) & ase_macb2_12v19 & ase_macb3_12v19) ||
                    ((!ase_macb0_12v19) & ase_macb1_12v19 & ase_macb2_12v19 & ase_macb3_12v19);

  assign core08v19 =  ((!ase_macb0_12v19) & (!ase_macb1_12v19) & (ase_macb2_12v19) & (ase_macb3_12v19)) ||
                    ((!ase_macb0_12v19) & (ase_macb1_12v19) & (!ase_macb2_12v19) & (ase_macb3_12v19)) ||
                    ((!ase_macb0_12v19) & (ase_macb1_12v19) & (ase_macb2_12v19) & (!ase_macb3_12v19)) ||
                    ((ase_macb0_12v19) & (!ase_macb1_12v19) & (!ase_macb2_12v19) & (ase_macb3_12v19)) ||
                    ((ase_macb0_12v19) & (!ase_macb1_12v19) & (ase_macb2_12v19) & (!ase_macb3_12v19)) ||
                    ((ase_macb0_12v19) & (ase_macb1_12v19) & (!ase_macb2_12v19) & (!ase_macb3_12v19));

  assign core06v19 =  ((!ase_macb0_12v19) & (!ase_macb1_12v19) & (!ase_macb2_12v19) & (ase_macb3_12v19)) ||
                    ((!ase_macb0_12v19) & (!ase_macb1_12v19) & (ase_macb2_12v19) & (!ase_macb3_12v19)) ||
                    ((!ase_macb0_12v19) & (ase_macb1_12v19) & (!ase_macb2_12v19) & (!ase_macb3_12v19)) ||
                    ((ase_macb0_12v19) & (!ase_macb1_12v19) & (!ase_macb2_12v19) & (!ase_macb3_12v19)) ||
                    ((!ase_macb0_12v19) & (!ase_macb1_12v19) & (!ase_macb2_12v19) & (!ase_macb3_12v19)) ;



`ifdef LP_ABV_ON19
// psl19 default clock19 = (posedge pclk19);

// Cover19 a condition in which SMC19 is powered19 down
// and again19 powered19 up while UART19 is going19 into POWER19 down
// state or UART19 is already in POWER19 DOWN19 state
// psl19 cover_overlapping_smc_urt_119:
//    cover{fell19(pwr1_on_urt19);[*];fell19(pwr1_on_smc19);[*];
//    rose19(pwr1_on_smc19);[*];rose19(pwr1_on_urt19)};
//
// Cover19 a condition in which UART19 is powered19 down
// and again19 powered19 up while SMC19 is going19 into POWER19 down
// state or SMC19 is already in POWER19 DOWN19 state
// psl19 cover_overlapping_smc_urt_219:
//    cover{fell19(pwr1_on_smc19);[*];fell19(pwr1_on_urt19);[*];
//    rose19(pwr1_on_urt19);[*];rose19(pwr1_on_smc19)};
//


// Power19 Down19 UART19
// This19 gets19 triggered on rising19 edge of Gate19 signal19 for
// UART19 (gate_clk_urt19). In a next cycle after gate_clk_urt19,
// Isolate19 UART19(isolate_urt19) signal19 become19 HIGH19 (active).
// In 2nd cycle after gate_clk_urt19 becomes HIGH19, RESET19 for NON19
// SRPG19 FFs19(rstn_non_srpg_urt19) and POWER119 for UART19(pwr1_on_urt19) should 
// go19 LOW19. 
// This19 completes19 a POWER19 DOWN19. 

sequence s_power_down_urt19;
      (gate_clk_urt19 & !isolate_urt19 & rstn_non_srpg_urt19 & pwr1_on_urt19) 
  ##1 (gate_clk_urt19 & isolate_urt19 & rstn_non_srpg_urt19 & pwr1_on_urt19) 
  ##3 (gate_clk_urt19 & isolate_urt19 & !rstn_non_srpg_urt19 & !pwr1_on_urt19);
endsequence


property p_power_down_urt19;
   @(posedge pclk19)
    $rose(gate_clk_urt19) |=> s_power_down_urt19;
endproperty

output_power_down_urt19:
  assert property (p_power_down_urt19);


// Power19 UP19 UART19
// Sequence starts with , Rising19 edge of pwr1_on_urt19.
// Two19 clock19 cycle after this, isolate_urt19 should become19 LOW19 
// On19 the following19 clk19 gate_clk_urt19 should go19 low19.
// 5 cycles19 after  Rising19 edge of pwr1_on_urt19, rstn_non_srpg_urt19
// should become19 HIGH19
sequence s_power_up_urt19;
##30 (pwr1_on_urt19 & !isolate_urt19 & gate_clk_urt19 & !rstn_non_srpg_urt19) 
##1 (pwr1_on_urt19 & !isolate_urt19 & !gate_clk_urt19 & !rstn_non_srpg_urt19) 
##2 (pwr1_on_urt19 & !isolate_urt19 & !gate_clk_urt19 & rstn_non_srpg_urt19);
endsequence

property p_power_up_urt19;
   @(posedge pclk19)
  disable iff(!nprst19)
    (!pwr1_on_urt19 ##1 pwr1_on_urt19) |=> s_power_up_urt19;
endproperty

output_power_up_urt19:
  assert property (p_power_up_urt19);


// Power19 Down19 SMC19
// This19 gets19 triggered on rising19 edge of Gate19 signal19 for
// SMC19 (gate_clk_smc19). In a next cycle after gate_clk_smc19,
// Isolate19 SMC19(isolate_smc19) signal19 become19 HIGH19 (active).
// In 2nd cycle after gate_clk_smc19 becomes HIGH19, RESET19 for NON19
// SRPG19 FFs19(rstn_non_srpg_smc19) and POWER119 for SMC19(pwr1_on_smc19) should 
// go19 LOW19. 
// This19 completes19 a POWER19 DOWN19. 

sequence s_power_down_smc19;
      (gate_clk_smc19 & !isolate_smc19 & rstn_non_srpg_smc19 & pwr1_on_smc19) 
  ##1 (gate_clk_smc19 & isolate_smc19 & rstn_non_srpg_smc19 & pwr1_on_smc19) 
  ##3 (gate_clk_smc19 & isolate_smc19 & !rstn_non_srpg_smc19 & !pwr1_on_smc19);
endsequence


property p_power_down_smc19;
   @(posedge pclk19)
    $rose(gate_clk_smc19) |=> s_power_down_smc19;
endproperty

output_power_down_smc19:
  assert property (p_power_down_smc19);


// Power19 UP19 SMC19
// Sequence starts with , Rising19 edge of pwr1_on_smc19.
// Two19 clock19 cycle after this, isolate_smc19 should become19 LOW19 
// On19 the following19 clk19 gate_clk_smc19 should go19 low19.
// 5 cycles19 after  Rising19 edge of pwr1_on_smc19, rstn_non_srpg_smc19
// should become19 HIGH19
sequence s_power_up_smc19;
##30 (pwr1_on_smc19 & !isolate_smc19 & gate_clk_smc19 & !rstn_non_srpg_smc19) 
##1 (pwr1_on_smc19 & !isolate_smc19 & !gate_clk_smc19 & !rstn_non_srpg_smc19) 
##2 (pwr1_on_smc19 & !isolate_smc19 & !gate_clk_smc19 & rstn_non_srpg_smc19);
endsequence

property p_power_up_smc19;
   @(posedge pclk19)
  disable iff(!nprst19)
    (!pwr1_on_smc19 ##1 pwr1_on_smc19) |=> s_power_up_smc19;
endproperty

output_power_up_smc19:
  assert property (p_power_up_smc19);


// COVER19 SMC19 POWER19 DOWN19 AND19 UP19
cover_power_down_up_smc19: cover property (@(posedge pclk19)
(s_power_down_smc19 ##[5:180] s_power_up_smc19));



// COVER19 UART19 POWER19 DOWN19 AND19 UP19
cover_power_down_up_urt19: cover property (@(posedge pclk19)
(s_power_down_urt19 ##[5:180] s_power_up_urt19));

cover_power_down_urt19: cover property (@(posedge pclk19)
(s_power_down_urt19));

cover_power_up_urt19: cover property (@(posedge pclk19)
(s_power_up_urt19));




`ifdef PCM_ABV_ON19
//------------------------------------------------------------------------------
// Power19 Controller19 Formal19 Verification19 component.  Each power19 domain has a 
// separate19 instantiation19
//------------------------------------------------------------------------------

// need to assume that CPU19 will leave19 a minimum time between powering19 down and 
// back up.  In this example19, 10clks has been selected.
// psl19 config_min_uart_pd_time19 : assume always {rose19(L1_ctrl_domain19[1])} |-> { L1_ctrl_domain19[1][*10] } abort19(~nprst19);
// psl19 config_min_uart_pu_time19 : assume always {fell19(L1_ctrl_domain19[1])} |-> { !L1_ctrl_domain19[1][*10] } abort19(~nprst19);
// psl19 config_min_smc_pd_time19 : assume always {rose19(L1_ctrl_domain19[2])} |-> { L1_ctrl_domain19[2][*10] } abort19(~nprst19);
// psl19 config_min_smc_pu_time19 : assume always {fell19(L1_ctrl_domain19[2])} |-> { !L1_ctrl_domain19[2][*10] } abort19(~nprst19);

// UART19 VCOMP19 parameters19
   defparam i_uart_vcomp_domain19.ENABLE_SAVE_RESTORE_EDGE19   = 1;
   defparam i_uart_vcomp_domain19.ENABLE_EXT_PWR_CNTRL19       = 1;
   defparam i_uart_vcomp_domain19.REF_CLK_DEFINED19            = 0;
   defparam i_uart_vcomp_domain19.MIN_SHUTOFF_CYCLES19         = 4;
   defparam i_uart_vcomp_domain19.MIN_RESTORE_TO_ISO_CYCLES19  = 0;
   defparam i_uart_vcomp_domain19.MIN_SAVE_TO_SHUTOFF_CYCLES19 = 1;


   vcomp_domain19 i_uart_vcomp_domain19
   ( .ref_clk19(pclk19),
     .start_lps19(L1_ctrl_domain19[1] || !rstn_non_srpg_urt19),
     .rst_n19(nprst19),
     .ext_power_down19(L1_ctrl_domain19[1]),
     .iso_en19(isolate_urt19),
     .save_edge19(save_edge_urt19),
     .restore_edge19(restore_edge_urt19),
     .domain_shut_off19(pwr1_off_urt19),
     .domain_clk19(!gate_clk_urt19 && pclk19)
   );


// SMC19 VCOMP19 parameters19
   defparam i_smc_vcomp_domain19.ENABLE_SAVE_RESTORE_EDGE19   = 1;
   defparam i_smc_vcomp_domain19.ENABLE_EXT_PWR_CNTRL19       = 1;
   defparam i_smc_vcomp_domain19.REF_CLK_DEFINED19            = 0;
   defparam i_smc_vcomp_domain19.MIN_SHUTOFF_CYCLES19         = 4;
   defparam i_smc_vcomp_domain19.MIN_RESTORE_TO_ISO_CYCLES19  = 0;
   defparam i_smc_vcomp_domain19.MIN_SAVE_TO_SHUTOFF_CYCLES19 = 1;


   vcomp_domain19 i_smc_vcomp_domain19
   ( .ref_clk19(pclk19),
     .start_lps19(L1_ctrl_domain19[2] || !rstn_non_srpg_smc19),
     .rst_n19(nprst19),
     .ext_power_down19(L1_ctrl_domain19[2]),
     .iso_en19(isolate_smc19),
     .save_edge19(save_edge_smc19),
     .restore_edge19(restore_edge_smc19),
     .domain_shut_off19(pwr1_off_smc19),
     .domain_clk19(!gate_clk_smc19 && pclk19)
   );

`endif

`endif



endmodule
