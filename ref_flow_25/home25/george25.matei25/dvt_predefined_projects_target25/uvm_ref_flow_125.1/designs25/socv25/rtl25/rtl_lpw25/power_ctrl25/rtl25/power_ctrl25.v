//File25 name   : power_ctrl25.v
//Title25       : Power25 Control25 Module25
//Created25     : 1999
//Description25 : Top25 level of power25 controller25
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

module power_ctrl25 (


    // Clocks25 & Reset25
    pclk25,
    nprst25,
    // APB25 programming25 interface
    paddr25,
    psel25,
    penable25,
    pwrite25,
    pwdata25,
    prdata25,
    // mac25 i/f,
    macb3_wakeup25,
    macb2_wakeup25,
    macb1_wakeup25,
    macb0_wakeup25,
    // Scan25 
    scan_in25,
    scan_en25,
    scan_mode25,
    scan_out25,
    // Module25 control25 outputs25
    int_source_h25,
    // SMC25
    rstn_non_srpg_smc25,
    gate_clk_smc25,
    isolate_smc25,
    save_edge_smc25,
    restore_edge_smc25,
    pwr1_on_smc25,
    pwr2_on_smc25,
    pwr1_off_smc25,
    pwr2_off_smc25,
    // URT25
    rstn_non_srpg_urt25,
    gate_clk_urt25,
    isolate_urt25,
    save_edge_urt25,
    restore_edge_urt25,
    pwr1_on_urt25,
    pwr2_on_urt25,
    pwr1_off_urt25,      
    pwr2_off_urt25,
    // ETH025
    rstn_non_srpg_macb025,
    gate_clk_macb025,
    isolate_macb025,
    save_edge_macb025,
    restore_edge_macb025,
    pwr1_on_macb025,
    pwr2_on_macb025,
    pwr1_off_macb025,      
    pwr2_off_macb025,
    // ETH125
    rstn_non_srpg_macb125,
    gate_clk_macb125,
    isolate_macb125,
    save_edge_macb125,
    restore_edge_macb125,
    pwr1_on_macb125,
    pwr2_on_macb125,
    pwr1_off_macb125,      
    pwr2_off_macb125,
    // ETH225
    rstn_non_srpg_macb225,
    gate_clk_macb225,
    isolate_macb225,
    save_edge_macb225,
    restore_edge_macb225,
    pwr1_on_macb225,
    pwr2_on_macb225,
    pwr1_off_macb225,      
    pwr2_off_macb225,
    // ETH325
    rstn_non_srpg_macb325,
    gate_clk_macb325,
    isolate_macb325,
    save_edge_macb325,
    restore_edge_macb325,
    pwr1_on_macb325,
    pwr2_on_macb325,
    pwr1_off_macb325,      
    pwr2_off_macb325,
    // DMA25
    rstn_non_srpg_dma25,
    gate_clk_dma25,
    isolate_dma25,
    save_edge_dma25,
    restore_edge_dma25,
    pwr1_on_dma25,
    pwr2_on_dma25,
    pwr1_off_dma25,      
    pwr2_off_dma25,
    // CPU25
    rstn_non_srpg_cpu25,
    gate_clk_cpu25,
    isolate_cpu25,
    save_edge_cpu25,
    restore_edge_cpu25,
    pwr1_on_cpu25,
    pwr2_on_cpu25,
    pwr1_off_cpu25,      
    pwr2_off_cpu25,
    // ALUT25
    rstn_non_srpg_alut25,
    gate_clk_alut25,
    isolate_alut25,
    save_edge_alut25,
    restore_edge_alut25,
    pwr1_on_alut25,
    pwr2_on_alut25,
    pwr1_off_alut25,      
    pwr2_off_alut25,
    // MEM25
    rstn_non_srpg_mem25,
    gate_clk_mem25,
    isolate_mem25,
    save_edge_mem25,
    restore_edge_mem25,
    pwr1_on_mem25,
    pwr2_on_mem25,
    pwr1_off_mem25,      
    pwr2_off_mem25,
    // core25 dvfs25 transitions25
    core06v25,
    core08v25,
    core10v25,
    core12v25,
    pcm_macb_wakeup_int25,
    // mte25 signals25
    mte_smc_start25,
    mte_uart_start25,
    mte_smc_uart_start25,  
    mte_pm_smc_to_default_start25, 
    mte_pm_uart_to_default_start25,
    mte_pm_smc_uart_to_default_start25

  );

  parameter STATE_IDLE_12V25 = 4'b0001;
  parameter STATE_06V25 = 4'b0010;
  parameter STATE_08V25 = 4'b0100;
  parameter STATE_10V25 = 4'b1000;

    // Clocks25 & Reset25
    input pclk25;
    input nprst25;
    // APB25 programming25 interface
    input [31:0] paddr25;
    input psel25  ;
    input penable25;
    input pwrite25 ;
    input [31:0] pwdata25;
    output [31:0] prdata25;
    // mac25
    input macb3_wakeup25;
    input macb2_wakeup25;
    input macb1_wakeup25;
    input macb0_wakeup25;
    // Scan25 
    input scan_in25;
    input scan_en25;
    input scan_mode25;
    output scan_out25;
    // Module25 control25 outputs25
    input int_source_h25;
    // SMC25
    output rstn_non_srpg_smc25 ;
    output gate_clk_smc25   ;
    output isolate_smc25   ;
    output save_edge_smc25   ;
    output restore_edge_smc25   ;
    output pwr1_on_smc25   ;
    output pwr2_on_smc25   ;
    output pwr1_off_smc25  ;
    output pwr2_off_smc25  ;
    // URT25
    output rstn_non_srpg_urt25 ;
    output gate_clk_urt25      ;
    output isolate_urt25       ;
    output save_edge_urt25   ;
    output restore_edge_urt25   ;
    output pwr1_on_urt25       ;
    output pwr2_on_urt25       ;
    output pwr1_off_urt25      ;
    output pwr2_off_urt25      ;
    // ETH025
    output rstn_non_srpg_macb025 ;
    output gate_clk_macb025      ;
    output isolate_macb025       ;
    output save_edge_macb025   ;
    output restore_edge_macb025   ;
    output pwr1_on_macb025       ;
    output pwr2_on_macb025       ;
    output pwr1_off_macb025      ;
    output pwr2_off_macb025      ;
    // ETH125
    output rstn_non_srpg_macb125 ;
    output gate_clk_macb125      ;
    output isolate_macb125       ;
    output save_edge_macb125   ;
    output restore_edge_macb125   ;
    output pwr1_on_macb125       ;
    output pwr2_on_macb125       ;
    output pwr1_off_macb125      ;
    output pwr2_off_macb125      ;
    // ETH225
    output rstn_non_srpg_macb225 ;
    output gate_clk_macb225      ;
    output isolate_macb225       ;
    output save_edge_macb225   ;
    output restore_edge_macb225   ;
    output pwr1_on_macb225       ;
    output pwr2_on_macb225       ;
    output pwr1_off_macb225      ;
    output pwr2_off_macb225      ;
    // ETH325
    output rstn_non_srpg_macb325 ;
    output gate_clk_macb325      ;
    output isolate_macb325       ;
    output save_edge_macb325   ;
    output restore_edge_macb325   ;
    output pwr1_on_macb325       ;
    output pwr2_on_macb325       ;
    output pwr1_off_macb325      ;
    output pwr2_off_macb325      ;
    // DMA25
    output rstn_non_srpg_dma25 ;
    output gate_clk_dma25      ;
    output isolate_dma25       ;
    output save_edge_dma25   ;
    output restore_edge_dma25   ;
    output pwr1_on_dma25       ;
    output pwr2_on_dma25       ;
    output pwr1_off_dma25      ;
    output pwr2_off_dma25      ;
    // CPU25
    output rstn_non_srpg_cpu25 ;
    output gate_clk_cpu25      ;
    output isolate_cpu25       ;
    output save_edge_cpu25   ;
    output restore_edge_cpu25   ;
    output pwr1_on_cpu25       ;
    output pwr2_on_cpu25       ;
    output pwr1_off_cpu25      ;
    output pwr2_off_cpu25      ;
    // ALUT25
    output rstn_non_srpg_alut25 ;
    output gate_clk_alut25      ;
    output isolate_alut25       ;
    output save_edge_alut25   ;
    output restore_edge_alut25   ;
    output pwr1_on_alut25       ;
    output pwr2_on_alut25       ;
    output pwr1_off_alut25      ;
    output pwr2_off_alut25      ;
    // MEM25
    output rstn_non_srpg_mem25 ;
    output gate_clk_mem25      ;
    output isolate_mem25       ;
    output save_edge_mem25   ;
    output restore_edge_mem25   ;
    output pwr1_on_mem25       ;
    output pwr2_on_mem25       ;
    output pwr1_off_mem25      ;
    output pwr2_off_mem25      ;


   // core25 transitions25 o/p
    output core06v25;
    output core08v25;
    output core10v25;
    output core12v25;
    output pcm_macb_wakeup_int25 ;
    //mode mte25  signals25
    output mte_smc_start25;
    output mte_uart_start25;
    output mte_smc_uart_start25;  
    output mte_pm_smc_to_default_start25; 
    output mte_pm_uart_to_default_start25;
    output mte_pm_smc_uart_to_default_start25;

    reg mte_smc_start25;
    reg mte_uart_start25;
    reg mte_smc_uart_start25;  
    reg mte_pm_smc_to_default_start25; 
    reg mte_pm_uart_to_default_start25;
    reg mte_pm_smc_uart_to_default_start25;

    reg [31:0] prdata25;

  wire valid_reg_write25  ;
  wire valid_reg_read25   ;
  wire L1_ctrl_access25   ;
  wire L1_status_access25 ;
  wire pcm_int_mask_access25;
  wire pcm_int_status_access25;
  wire standby_mem025      ;
  wire standby_mem125      ;
  wire standby_mem225      ;
  wire standby_mem325      ;
  wire pwr1_off_mem025;
  wire pwr1_off_mem125;
  wire pwr1_off_mem225;
  wire pwr1_off_mem325;
  
  // Control25 signals25
  wire set_status_smc25   ;
  wire clr_status_smc25   ;
  wire set_status_urt25   ;
  wire clr_status_urt25   ;
  wire set_status_macb025   ;
  wire clr_status_macb025   ;
  wire set_status_macb125   ;
  wire clr_status_macb125   ;
  wire set_status_macb225   ;
  wire clr_status_macb225   ;
  wire set_status_macb325   ;
  wire clr_status_macb325   ;
  wire set_status_dma25   ;
  wire clr_status_dma25   ;
  wire set_status_cpu25   ;
  wire clr_status_cpu25   ;
  wire set_status_alut25   ;
  wire clr_status_alut25   ;
  wire set_status_mem25   ;
  wire clr_status_mem25   ;


  // Status and Control25 registers
  reg [31:0]  L1_status_reg25;
  reg  [31:0] L1_ctrl_reg25  ;
  reg  [31:0] L1_ctrl_domain25  ;
  reg L1_ctrl_cpu_off_reg25;
  reg [31:0]  pcm_mask_reg25;
  reg [31:0]  pcm_status_reg25;

  // Signals25 gated25 in scan_mode25
  //SMC25
  wire  rstn_non_srpg_smc_int25;
  wire  gate_clk_smc_int25    ;     
  wire  isolate_smc_int25    ;       
  wire save_edge_smc_int25;
  wire restore_edge_smc_int25;
  wire  pwr1_on_smc_int25    ;      
  wire  pwr2_on_smc_int25    ;      


  //URT25
  wire   rstn_non_srpg_urt_int25;
  wire   gate_clk_urt_int25     ;     
  wire   isolate_urt_int25      ;       
  wire save_edge_urt_int25;
  wire restore_edge_urt_int25;
  wire   pwr1_on_urt_int25      ;      
  wire   pwr2_on_urt_int25      ;      

  // ETH025
  wire   rstn_non_srpg_macb0_int25;
  wire   gate_clk_macb0_int25     ;     
  wire   isolate_macb0_int25      ;       
  wire save_edge_macb0_int25;
  wire restore_edge_macb0_int25;
  wire   pwr1_on_macb0_int25      ;      
  wire   pwr2_on_macb0_int25      ;      
  // ETH125
  wire   rstn_non_srpg_macb1_int25;
  wire   gate_clk_macb1_int25     ;     
  wire   isolate_macb1_int25      ;       
  wire save_edge_macb1_int25;
  wire restore_edge_macb1_int25;
  wire   pwr1_on_macb1_int25      ;      
  wire   pwr2_on_macb1_int25      ;      
  // ETH225
  wire   rstn_non_srpg_macb2_int25;
  wire   gate_clk_macb2_int25     ;     
  wire   isolate_macb2_int25      ;       
  wire save_edge_macb2_int25;
  wire restore_edge_macb2_int25;
  wire   pwr1_on_macb2_int25      ;      
  wire   pwr2_on_macb2_int25      ;      
  // ETH325
  wire   rstn_non_srpg_macb3_int25;
  wire   gate_clk_macb3_int25     ;     
  wire   isolate_macb3_int25      ;       
  wire save_edge_macb3_int25;
  wire restore_edge_macb3_int25;
  wire   pwr1_on_macb3_int25      ;      
  wire   pwr2_on_macb3_int25      ;      

  // DMA25
  wire   rstn_non_srpg_dma_int25;
  wire   gate_clk_dma_int25     ;     
  wire   isolate_dma_int25      ;       
  wire save_edge_dma_int25;
  wire restore_edge_dma_int25;
  wire   pwr1_on_dma_int25      ;      
  wire   pwr2_on_dma_int25      ;      

  // CPU25
  wire   rstn_non_srpg_cpu_int25;
  wire   gate_clk_cpu_int25     ;     
  wire   isolate_cpu_int25      ;       
  wire save_edge_cpu_int25;
  wire restore_edge_cpu_int25;
  wire   pwr1_on_cpu_int25      ;      
  wire   pwr2_on_cpu_int25      ;  
  wire L1_ctrl_cpu_off_p25;    

  reg save_alut_tmp25;
  // DFS25 sm25

  reg cpu_shutoff_ctrl25;

  reg mte_mac_off_start25, mte_mac012_start25, mte_mac013_start25, mte_mac023_start25, mte_mac123_start25;
  reg mte_mac01_start25, mte_mac02_start25, mte_mac03_start25, mte_mac12_start25, mte_mac13_start25, mte_mac23_start25;
  reg mte_mac0_start25, mte_mac1_start25, mte_mac2_start25, mte_mac3_start25;
  reg mte_sys_hibernate25 ;
  reg mte_dma_start25 ;
  reg mte_cpu_start25 ;
  reg mte_mac_off_sleep_start25, mte_mac012_sleep_start25, mte_mac013_sleep_start25, mte_mac023_sleep_start25, mte_mac123_sleep_start25;
  reg mte_mac01_sleep_start25, mte_mac02_sleep_start25, mte_mac03_sleep_start25, mte_mac12_sleep_start25, mte_mac13_sleep_start25, mte_mac23_sleep_start25;
  reg mte_mac0_sleep_start25, mte_mac1_sleep_start25, mte_mac2_sleep_start25, mte_mac3_sleep_start25;
  reg mte_dma_sleep_start25;
  reg mte_mac_off_to_default25, mte_mac012_to_default25, mte_mac013_to_default25, mte_mac023_to_default25, mte_mac123_to_default25;
  reg mte_mac01_to_default25, mte_mac02_to_default25, mte_mac03_to_default25, mte_mac12_to_default25, mte_mac13_to_default25, mte_mac23_to_default25;
  reg mte_mac0_to_default25, mte_mac1_to_default25, mte_mac2_to_default25, mte_mac3_to_default25;
  reg mte_dma_isolate_dis25;
  reg mte_cpu_isolate_dis25;
  reg mte_sys_hibernate_to_default25;


  // Latch25 the CPU25 SLEEP25 invocation25
  always @( posedge pclk25 or negedge nprst25) 
  begin
    if(!nprst25)
      L1_ctrl_cpu_off_reg25 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg25 <= L1_ctrl_domain25[8];
  end

  // Create25 a pulse25 for sleep25 detection25 
  assign L1_ctrl_cpu_off_p25 =  L1_ctrl_domain25[8] && !L1_ctrl_cpu_off_reg25;
  
  // CPU25 sleep25 contol25 logic 
  // Shut25 off25 CPU25 when L1_ctrl_cpu_off_p25 is set
  // wake25 cpu25 when any interrupt25 is seen25  
  always @( posedge pclk25 or negedge nprst25) 
  begin
    if(!nprst25)
     cpu_shutoff_ctrl25 <= 1'b0;
    else if(cpu_shutoff_ctrl25 && int_source_h25)
     cpu_shutoff_ctrl25 <= 1'b0;
    else if (L1_ctrl_cpu_off_p25)
     cpu_shutoff_ctrl25 <= 1'b1;
  end
 
  // instantiate25 power25 contol25  block for uart25
  power_ctrl_sm25 i_urt_power_ctrl_sm25(
    .pclk25(pclk25),
    .nprst25(nprst25),
    .L1_module_req25(L1_ctrl_domain25[1]),
    .set_status_module25(set_status_urt25),
    .clr_status_module25(clr_status_urt25),
    .rstn_non_srpg_module25(rstn_non_srpg_urt_int25),
    .gate_clk_module25(gate_clk_urt_int25),
    .isolate_module25(isolate_urt_int25),
    .save_edge25(save_edge_urt_int25),
    .restore_edge25(restore_edge_urt_int25),
    .pwr1_on25(pwr1_on_urt_int25),
    .pwr2_on25(pwr2_on_urt_int25)
    );
  

  // instantiate25 power25 contol25  block for smc25
  power_ctrl_sm25 i_smc_power_ctrl_sm25(
    .pclk25(pclk25),
    .nprst25(nprst25),
    .L1_module_req25(L1_ctrl_domain25[2]),
    .set_status_module25(set_status_smc25),
    .clr_status_module25(clr_status_smc25),
    .rstn_non_srpg_module25(rstn_non_srpg_smc_int25),
    .gate_clk_module25(gate_clk_smc_int25),
    .isolate_module25(isolate_smc_int25),
    .save_edge25(save_edge_smc_int25),
    .restore_edge25(restore_edge_smc_int25),
    .pwr1_on25(pwr1_on_smc_int25),
    .pwr2_on25(pwr2_on_smc_int25)
    );

  // power25 control25 for macb025
  power_ctrl_sm25 i_macb0_power_ctrl_sm25(
    .pclk25(pclk25),
    .nprst25(nprst25),
    .L1_module_req25(L1_ctrl_domain25[3]),
    .set_status_module25(set_status_macb025),
    .clr_status_module25(clr_status_macb025),
    .rstn_non_srpg_module25(rstn_non_srpg_macb0_int25),
    .gate_clk_module25(gate_clk_macb0_int25),
    .isolate_module25(isolate_macb0_int25),
    .save_edge25(save_edge_macb0_int25),
    .restore_edge25(restore_edge_macb0_int25),
    .pwr1_on25(pwr1_on_macb0_int25),
    .pwr2_on25(pwr2_on_macb0_int25)
    );
  // power25 control25 for macb125
  power_ctrl_sm25 i_macb1_power_ctrl_sm25(
    .pclk25(pclk25),
    .nprst25(nprst25),
    .L1_module_req25(L1_ctrl_domain25[4]),
    .set_status_module25(set_status_macb125),
    .clr_status_module25(clr_status_macb125),
    .rstn_non_srpg_module25(rstn_non_srpg_macb1_int25),
    .gate_clk_module25(gate_clk_macb1_int25),
    .isolate_module25(isolate_macb1_int25),
    .save_edge25(save_edge_macb1_int25),
    .restore_edge25(restore_edge_macb1_int25),
    .pwr1_on25(pwr1_on_macb1_int25),
    .pwr2_on25(pwr2_on_macb1_int25)
    );
  // power25 control25 for macb225
  power_ctrl_sm25 i_macb2_power_ctrl_sm25(
    .pclk25(pclk25),
    .nprst25(nprst25),
    .L1_module_req25(L1_ctrl_domain25[5]),
    .set_status_module25(set_status_macb225),
    .clr_status_module25(clr_status_macb225),
    .rstn_non_srpg_module25(rstn_non_srpg_macb2_int25),
    .gate_clk_module25(gate_clk_macb2_int25),
    .isolate_module25(isolate_macb2_int25),
    .save_edge25(save_edge_macb2_int25),
    .restore_edge25(restore_edge_macb2_int25),
    .pwr1_on25(pwr1_on_macb2_int25),
    .pwr2_on25(pwr2_on_macb2_int25)
    );
  // power25 control25 for macb325
  power_ctrl_sm25 i_macb3_power_ctrl_sm25(
    .pclk25(pclk25),
    .nprst25(nprst25),
    .L1_module_req25(L1_ctrl_domain25[6]),
    .set_status_module25(set_status_macb325),
    .clr_status_module25(clr_status_macb325),
    .rstn_non_srpg_module25(rstn_non_srpg_macb3_int25),
    .gate_clk_module25(gate_clk_macb3_int25),
    .isolate_module25(isolate_macb3_int25),
    .save_edge25(save_edge_macb3_int25),
    .restore_edge25(restore_edge_macb3_int25),
    .pwr1_on25(pwr1_on_macb3_int25),
    .pwr2_on25(pwr2_on_macb3_int25)
    );
  // power25 control25 for dma25
  power_ctrl_sm25 i_dma_power_ctrl_sm25(
    .pclk25(pclk25),
    .nprst25(nprst25),
    .L1_module_req25(L1_ctrl_domain25[7]),
    .set_status_module25(set_status_dma25),
    .clr_status_module25(clr_status_dma25),
    .rstn_non_srpg_module25(rstn_non_srpg_dma_int25),
    .gate_clk_module25(gate_clk_dma_int25),
    .isolate_module25(isolate_dma_int25),
    .save_edge25(save_edge_dma_int25),
    .restore_edge25(restore_edge_dma_int25),
    .pwr1_on25(pwr1_on_dma_int25),
    .pwr2_on25(pwr2_on_dma_int25)
    );
  // power25 control25 for CPU25
  power_ctrl_sm25 i_cpu_power_ctrl_sm25(
    .pclk25(pclk25),
    .nprst25(nprst25),
    .L1_module_req25(cpu_shutoff_ctrl25),
    .set_status_module25(set_status_cpu25),
    .clr_status_module25(clr_status_cpu25),
    .rstn_non_srpg_module25(rstn_non_srpg_cpu_int25),
    .gate_clk_module25(gate_clk_cpu_int25),
    .isolate_module25(isolate_cpu_int25),
    .save_edge25(save_edge_cpu_int25),
    .restore_edge25(restore_edge_cpu_int25),
    .pwr1_on25(pwr1_on_cpu_int25),
    .pwr2_on25(pwr2_on_cpu_int25)
    );

  assign valid_reg_write25 =  (psel25 && pwrite25 && penable25);
  assign valid_reg_read25  =  (psel25 && (!pwrite25) && penable25);

  assign L1_ctrl_access25  =  (paddr25[15:0] == 16'b0000000000000100); 
  assign L1_status_access25 = (paddr25[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access25 =   (paddr25[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access25 = (paddr25[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control25 and status register
  always @(*)
  begin  
    if(valid_reg_read25 && L1_ctrl_access25) 
      prdata25 = L1_ctrl_reg25;
    else if (valid_reg_read25 && L1_status_access25)
      prdata25 = L1_status_reg25;
    else if (valid_reg_read25 && pcm_int_mask_access25)
      prdata25 = pcm_mask_reg25;
    else if (valid_reg_read25 && pcm_int_status_access25)
      prdata25 = pcm_status_reg25;
    else 
      prdata25 = 0;
  end

  assign set_status_mem25 =  (set_status_macb025 && set_status_macb125 && set_status_macb225 &&
                            set_status_macb325 && set_status_dma25 && set_status_cpu25);

  assign clr_status_mem25 =  (clr_status_macb025 && clr_status_macb125 && clr_status_macb225 &&
                            clr_status_macb325 && clr_status_dma25 && clr_status_cpu25);

  assign set_status_alut25 = (set_status_macb025 && set_status_macb125 && set_status_macb225 && set_status_macb325);

  assign clr_status_alut25 = (clr_status_macb025 || clr_status_macb125 || clr_status_macb225  || clr_status_macb325);

  // Write accesses to the control25 and status register
 
  always @(posedge pclk25 or negedge nprst25)
  begin
    if (!nprst25) begin
      L1_ctrl_reg25   <= 0;
      L1_status_reg25 <= 0;
      pcm_mask_reg25 <= 0;
    end else begin
      // CTRL25 reg updates25
      if (valid_reg_write25 && L1_ctrl_access25) 
        L1_ctrl_reg25 <= pwdata25; // Writes25 to the ctrl25 reg
      if (valid_reg_write25 && pcm_int_mask_access25) 
        pcm_mask_reg25 <= pwdata25; // Writes25 to the ctrl25 reg

      if (set_status_urt25 == 1'b1)  
        L1_status_reg25[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt25 == 1'b1) 
        L1_status_reg25[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc25 == 1'b1) 
        L1_status_reg25[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc25 == 1'b1) 
        L1_status_reg25[2] <= 1'b0; // Clear the status bit

      if (set_status_macb025 == 1'b1)  
        L1_status_reg25[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb025 == 1'b1) 
        L1_status_reg25[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb125 == 1'b1)  
        L1_status_reg25[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb125 == 1'b1) 
        L1_status_reg25[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb225 == 1'b1)  
        L1_status_reg25[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb225 == 1'b1) 
        L1_status_reg25[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb325 == 1'b1)  
        L1_status_reg25[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb325 == 1'b1) 
        L1_status_reg25[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma25 == 1'b1)  
        L1_status_reg25[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma25 == 1'b1) 
        L1_status_reg25[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu25 == 1'b1)  
        L1_status_reg25[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu25 == 1'b1) 
        L1_status_reg25[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut25 == 1'b1)  
        L1_status_reg25[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut25 == 1'b1) 
        L1_status_reg25[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem25 == 1'b1)  
        L1_status_reg25[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem25 == 1'b1) 
        L1_status_reg25[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused25 bits of pcm_status_reg25 are tied25 to 0
  always @(posedge pclk25 or negedge nprst25)
  begin
    if (!nprst25)
      pcm_status_reg25[31:4] <= 'b0;
    else  
      pcm_status_reg25[31:4] <= pcm_status_reg25[31:4];
  end
  
  // interrupt25 only of h/w assisted25 wakeup
  // MAC25 3
  always @(posedge pclk25 or negedge nprst25)
  begin
    if(!nprst25)
      pcm_status_reg25[3] <= 1'b0;
    else if (valid_reg_write25 && pcm_int_status_access25) 
      pcm_status_reg25[3] <= pwdata25[3];
    else if (macb3_wakeup25 & ~pcm_mask_reg25[3])
      pcm_status_reg25[3] <= 1'b1;
    else if (valid_reg_read25 && pcm_int_status_access25) 
      pcm_status_reg25[3] <= 1'b0;
    else
      pcm_status_reg25[3] <= pcm_status_reg25[3];
  end  
   
  // MAC25 2
  always @(posedge pclk25 or negedge nprst25)
  begin
    if(!nprst25)
      pcm_status_reg25[2] <= 1'b0;
    else if (valid_reg_write25 && pcm_int_status_access25) 
      pcm_status_reg25[2] <= pwdata25[2];
    else if (macb2_wakeup25 & ~pcm_mask_reg25[2])
      pcm_status_reg25[2] <= 1'b1;
    else if (valid_reg_read25 && pcm_int_status_access25) 
      pcm_status_reg25[2] <= 1'b0;
    else
      pcm_status_reg25[2] <= pcm_status_reg25[2];
  end  

  // MAC25 1
  always @(posedge pclk25 or negedge nprst25)
  begin
    if(!nprst25)
      pcm_status_reg25[1] <= 1'b0;
    else if (valid_reg_write25 && pcm_int_status_access25) 
      pcm_status_reg25[1] <= pwdata25[1];
    else if (macb1_wakeup25 & ~pcm_mask_reg25[1])
      pcm_status_reg25[1] <= 1'b1;
    else if (valid_reg_read25 && pcm_int_status_access25) 
      pcm_status_reg25[1] <= 1'b0;
    else
      pcm_status_reg25[1] <= pcm_status_reg25[1];
  end  
   
  // MAC25 0
  always @(posedge pclk25 or negedge nprst25)
  begin
    if(!nprst25)
      pcm_status_reg25[0] <= 1'b0;
    else if (valid_reg_write25 && pcm_int_status_access25) 
      pcm_status_reg25[0] <= pwdata25[0];
    else if (macb0_wakeup25 & ~pcm_mask_reg25[0])
      pcm_status_reg25[0] <= 1'b1;
    else if (valid_reg_read25 && pcm_int_status_access25) 
      pcm_status_reg25[0] <= 1'b0;
    else
      pcm_status_reg25[0] <= pcm_status_reg25[0];
  end  

  assign pcm_macb_wakeup_int25 = |pcm_status_reg25;

  reg [31:0] L1_ctrl_reg125;
  always @(posedge pclk25 or negedge nprst25)
  begin
    if(!nprst25)
      L1_ctrl_reg125 <= 0;
    else
      L1_ctrl_reg125 <= L1_ctrl_reg25;
  end

  // Program25 mode decode
  always @(L1_ctrl_reg25 or L1_ctrl_reg125 or int_source_h25 or cpu_shutoff_ctrl25) begin
    mte_smc_start25 = 0;
    mte_uart_start25 = 0;
    mte_smc_uart_start25  = 0;
    mte_mac_off_start25  = 0;
    mte_mac012_start25 = 0;
    mte_mac013_start25 = 0;
    mte_mac023_start25 = 0;
    mte_mac123_start25 = 0;
    mte_mac01_start25 = 0;
    mte_mac02_start25 = 0;
    mte_mac03_start25 = 0;
    mte_mac12_start25 = 0;
    mte_mac13_start25 = 0;
    mte_mac23_start25 = 0;
    mte_mac0_start25 = 0;
    mte_mac1_start25 = 0;
    mte_mac2_start25 = 0;
    mte_mac3_start25 = 0;
    mte_sys_hibernate25 = 0 ;
    mte_dma_start25 = 0 ;
    mte_cpu_start25 = 0 ;

    mte_mac0_sleep_start25 = (L1_ctrl_reg25 ==  'h14) && (L1_ctrl_reg125 == 'h4 );
    mte_mac1_sleep_start25 = (L1_ctrl_reg25 ==  'h14) && (L1_ctrl_reg125 == 'h5 ); 
    mte_mac2_sleep_start25 = (L1_ctrl_reg25 ==  'h14) && (L1_ctrl_reg125 == 'h6 ); 
    mte_mac3_sleep_start25 = (L1_ctrl_reg25 ==  'h14) && (L1_ctrl_reg125 == 'h7 ); 
    mte_mac01_sleep_start25 = (L1_ctrl_reg25 ==  'h14) && (L1_ctrl_reg125 == 'h8 ); 
    mte_mac02_sleep_start25 = (L1_ctrl_reg25 ==  'h14) && (L1_ctrl_reg125 == 'h9 ); 
    mte_mac03_sleep_start25 = (L1_ctrl_reg25 ==  'h14) && (L1_ctrl_reg125 == 'hA ); 
    mte_mac12_sleep_start25 = (L1_ctrl_reg25 ==  'h14) && (L1_ctrl_reg125 == 'hB ); 
    mte_mac13_sleep_start25 = (L1_ctrl_reg25 ==  'h14) && (L1_ctrl_reg125 == 'hC ); 
    mte_mac23_sleep_start25 = (L1_ctrl_reg25 ==  'h14) && (L1_ctrl_reg125 == 'hD ); 
    mte_mac012_sleep_start25 = (L1_ctrl_reg25 ==  'h14) && (L1_ctrl_reg125 == 'hE ); 
    mte_mac013_sleep_start25 = (L1_ctrl_reg25 ==  'h14) && (L1_ctrl_reg125 == 'hF ); 
    mte_mac023_sleep_start25 = (L1_ctrl_reg25 ==  'h14) && (L1_ctrl_reg125 == 'h10 ); 
    mte_mac123_sleep_start25 = (L1_ctrl_reg25 ==  'h14) && (L1_ctrl_reg125 == 'h11 ); 
    mte_mac_off_sleep_start25 =  (L1_ctrl_reg25 == 'h14) && (L1_ctrl_reg125 == 'h12 );
    mte_dma_sleep_start25 =  (L1_ctrl_reg25 == 'h14) && (L1_ctrl_reg125 == 'h13 );

    mte_pm_uart_to_default_start25 = (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'h1);
    mte_pm_smc_to_default_start25 = (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'h2);
    mte_pm_smc_uart_to_default_start25 = (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'h3); 
    mte_mac0_to_default25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'h4); 
    mte_mac1_to_default25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'h5); 
    mte_mac2_to_default25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'h6); 
    mte_mac3_to_default25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'h7); 
    mte_mac01_to_default25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'h8); 
    mte_mac02_to_default25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'h9); 
    mte_mac03_to_default25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'hA); 
    mte_mac12_to_default25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'hB); 
    mte_mac13_to_default25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'hC); 
    mte_mac23_to_default25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'hD); 
    mte_mac012_to_default25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'hE); 
    mte_mac013_to_default25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'hF); 
    mte_mac023_to_default25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'h10); 
    mte_mac123_to_default25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'h11); 
    mte_mac_off_to_default25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'h12); 
    mte_dma_isolate_dis25 =  (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'h13); 
    mte_cpu_isolate_dis25 =  (int_source_h25) && (cpu_shutoff_ctrl25) && (L1_ctrl_reg25 != 'h15);
    mte_sys_hibernate_to_default25 = (L1_ctrl_reg25 == 32'h0) && (L1_ctrl_reg125 == 'h15); 

   
    if (L1_ctrl_reg125 == 'h0) begin // This25 check is to make mte_cpu_start25
                                   // is set only when you from default state 
      case (L1_ctrl_reg25)
        'h0 : L1_ctrl_domain25 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain25 = 32'h2; // PM_uart25
                mte_uart_start25 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain25 = 32'h4; // PM_smc25
                mte_smc_start25 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain25 = 32'h6; // PM_smc_uart25
                mte_smc_uart_start25 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain25 = 32'h8; //  PM_macb025
                mte_mac0_start25 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain25 = 32'h10; //  PM_macb125
                mte_mac1_start25 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain25 = 32'h20; //  PM_macb225
                mte_mac2_start25 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain25 = 32'h40; //  PM_macb325
                mte_mac3_start25 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain25 = 32'h18; //  PM_macb0125
                mte_mac01_start25 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain25 = 32'h28; //  PM_macb0225
                mte_mac02_start25 = 1;
              end
        'hA : begin  
                L1_ctrl_domain25 = 32'h48; //  PM_macb0325
                mte_mac03_start25 = 1;
              end
        'hB : begin  
                L1_ctrl_domain25 = 32'h30; //  PM_macb1225
                mte_mac12_start25 = 1;
              end
        'hC : begin  
                L1_ctrl_domain25 = 32'h50; //  PM_macb1325
                mte_mac13_start25 = 1;
              end
        'hD : begin  
                L1_ctrl_domain25 = 32'h60; //  PM_macb2325
                mte_mac23_start25 = 1;
              end
        'hE : begin  
                L1_ctrl_domain25 = 32'h38; //  PM_macb01225
                mte_mac012_start25 = 1;
              end
        'hF : begin  
                L1_ctrl_domain25 = 32'h58; //  PM_macb01325
                mte_mac013_start25 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain25 = 32'h68; //  PM_macb02325
                mte_mac023_start25 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain25 = 32'h70; //  PM_macb12325
                mte_mac123_start25 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain25 = 32'h78; //  PM_macb_off25
                mte_mac_off_start25 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain25 = 32'h80; //  PM_dma25
                mte_dma_start25 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain25 = 32'h100; //  PM_cpu_sleep25
                mte_cpu_start25 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain25 = 32'h1FE; //  PM_hibernate25
                mte_sys_hibernate25 = 1;
              end
         default: L1_ctrl_domain25 = 32'h0;
      endcase
    end
  end


  wire to_default25 = (L1_ctrl_reg25 == 0);

  // Scan25 mode gating25 of power25 and isolation25 control25 signals25
  //SMC25
  assign rstn_non_srpg_smc25  = (scan_mode25 == 1'b0) ? rstn_non_srpg_smc_int25 : 1'b1;  
  assign gate_clk_smc25       = (scan_mode25 == 1'b0) ? gate_clk_smc_int25 : 1'b0;     
  assign isolate_smc25        = (scan_mode25 == 1'b0) ? isolate_smc_int25 : 1'b0;      
  assign pwr1_on_smc25        = (scan_mode25 == 1'b0) ? pwr1_on_smc_int25 : 1'b1;       
  assign pwr2_on_smc25        = (scan_mode25 == 1'b0) ? pwr2_on_smc_int25 : 1'b1;       
  assign pwr1_off_smc25       = (scan_mode25 == 1'b0) ? (!pwr1_on_smc_int25) : 1'b0;       
  assign pwr2_off_smc25       = (scan_mode25 == 1'b0) ? (!pwr2_on_smc_int25) : 1'b0;       
  assign save_edge_smc25       = (scan_mode25 == 1'b0) ? (save_edge_smc_int25) : 1'b0;       
  assign restore_edge_smc25       = (scan_mode25 == 1'b0) ? (restore_edge_smc_int25) : 1'b0;       

  //URT25
  assign rstn_non_srpg_urt25  = (scan_mode25 == 1'b0) ?  rstn_non_srpg_urt_int25 : 1'b1;  
  assign gate_clk_urt25       = (scan_mode25 == 1'b0) ?  gate_clk_urt_int25      : 1'b0;     
  assign isolate_urt25        = (scan_mode25 == 1'b0) ?  isolate_urt_int25       : 1'b0;      
  assign pwr1_on_urt25        = (scan_mode25 == 1'b0) ?  pwr1_on_urt_int25       : 1'b1;       
  assign pwr2_on_urt25        = (scan_mode25 == 1'b0) ?  pwr2_on_urt_int25       : 1'b1;       
  assign pwr1_off_urt25       = (scan_mode25 == 1'b0) ?  (!pwr1_on_urt_int25)  : 1'b0;       
  assign pwr2_off_urt25       = (scan_mode25 == 1'b0) ?  (!pwr2_on_urt_int25)  : 1'b0;       
  assign save_edge_urt25       = (scan_mode25 == 1'b0) ? (save_edge_urt_int25) : 1'b0;       
  assign restore_edge_urt25       = (scan_mode25 == 1'b0) ? (restore_edge_urt_int25) : 1'b0;       

  //ETH025
  assign rstn_non_srpg_macb025 = (scan_mode25 == 1'b0) ?  rstn_non_srpg_macb0_int25 : 1'b1;  
  assign gate_clk_macb025       = (scan_mode25 == 1'b0) ?  gate_clk_macb0_int25      : 1'b0;     
  assign isolate_macb025        = (scan_mode25 == 1'b0) ?  isolate_macb0_int25       : 1'b0;      
  assign pwr1_on_macb025        = (scan_mode25 == 1'b0) ?  pwr1_on_macb0_int25       : 1'b1;       
  assign pwr2_on_macb025        = (scan_mode25 == 1'b0) ?  pwr2_on_macb0_int25       : 1'b1;       
  assign pwr1_off_macb025       = (scan_mode25 == 1'b0) ?  (!pwr1_on_macb0_int25)  : 1'b0;       
  assign pwr2_off_macb025       = (scan_mode25 == 1'b0) ?  (!pwr2_on_macb0_int25)  : 1'b0;       
  assign save_edge_macb025       = (scan_mode25 == 1'b0) ? (save_edge_macb0_int25) : 1'b0;       
  assign restore_edge_macb025       = (scan_mode25 == 1'b0) ? (restore_edge_macb0_int25) : 1'b0;       

  //ETH125
  assign rstn_non_srpg_macb125 = (scan_mode25 == 1'b0) ?  rstn_non_srpg_macb1_int25 : 1'b1;  
  assign gate_clk_macb125       = (scan_mode25 == 1'b0) ?  gate_clk_macb1_int25      : 1'b0;     
  assign isolate_macb125        = (scan_mode25 == 1'b0) ?  isolate_macb1_int25       : 1'b0;      
  assign pwr1_on_macb125        = (scan_mode25 == 1'b0) ?  pwr1_on_macb1_int25       : 1'b1;       
  assign pwr2_on_macb125        = (scan_mode25 == 1'b0) ?  pwr2_on_macb1_int25       : 1'b1;       
  assign pwr1_off_macb125       = (scan_mode25 == 1'b0) ?  (!pwr1_on_macb1_int25)  : 1'b0;       
  assign pwr2_off_macb125       = (scan_mode25 == 1'b0) ?  (!pwr2_on_macb1_int25)  : 1'b0;       
  assign save_edge_macb125       = (scan_mode25 == 1'b0) ? (save_edge_macb1_int25) : 1'b0;       
  assign restore_edge_macb125       = (scan_mode25 == 1'b0) ? (restore_edge_macb1_int25) : 1'b0;       

  //ETH225
  assign rstn_non_srpg_macb225 = (scan_mode25 == 1'b0) ?  rstn_non_srpg_macb2_int25 : 1'b1;  
  assign gate_clk_macb225       = (scan_mode25 == 1'b0) ?  gate_clk_macb2_int25      : 1'b0;     
  assign isolate_macb225        = (scan_mode25 == 1'b0) ?  isolate_macb2_int25       : 1'b0;      
  assign pwr1_on_macb225        = (scan_mode25 == 1'b0) ?  pwr1_on_macb2_int25       : 1'b1;       
  assign pwr2_on_macb225        = (scan_mode25 == 1'b0) ?  pwr2_on_macb2_int25       : 1'b1;       
  assign pwr1_off_macb225       = (scan_mode25 == 1'b0) ?  (!pwr1_on_macb2_int25)  : 1'b0;       
  assign pwr2_off_macb225       = (scan_mode25 == 1'b0) ?  (!pwr2_on_macb2_int25)  : 1'b0;       
  assign save_edge_macb225       = (scan_mode25 == 1'b0) ? (save_edge_macb2_int25) : 1'b0;       
  assign restore_edge_macb225       = (scan_mode25 == 1'b0) ? (restore_edge_macb2_int25) : 1'b0;       

  //ETH325
  assign rstn_non_srpg_macb325 = (scan_mode25 == 1'b0) ?  rstn_non_srpg_macb3_int25 : 1'b1;  
  assign gate_clk_macb325       = (scan_mode25 == 1'b0) ?  gate_clk_macb3_int25      : 1'b0;     
  assign isolate_macb325        = (scan_mode25 == 1'b0) ?  isolate_macb3_int25       : 1'b0;      
  assign pwr1_on_macb325        = (scan_mode25 == 1'b0) ?  pwr1_on_macb3_int25       : 1'b1;       
  assign pwr2_on_macb325        = (scan_mode25 == 1'b0) ?  pwr2_on_macb3_int25       : 1'b1;       
  assign pwr1_off_macb325       = (scan_mode25 == 1'b0) ?  (!pwr1_on_macb3_int25)  : 1'b0;       
  assign pwr2_off_macb325       = (scan_mode25 == 1'b0) ?  (!pwr2_on_macb3_int25)  : 1'b0;       
  assign save_edge_macb325       = (scan_mode25 == 1'b0) ? (save_edge_macb3_int25) : 1'b0;       
  assign restore_edge_macb325       = (scan_mode25 == 1'b0) ? (restore_edge_macb3_int25) : 1'b0;       

  // MEM25
  assign rstn_non_srpg_mem25 =   (rstn_non_srpg_macb025 && rstn_non_srpg_macb125 && rstn_non_srpg_macb225 &&
                                rstn_non_srpg_macb325 && rstn_non_srpg_dma25 && rstn_non_srpg_cpu25 && rstn_non_srpg_urt25 &&
                                rstn_non_srpg_smc25);

  assign gate_clk_mem25 =  (gate_clk_macb025 && gate_clk_macb125 && gate_clk_macb225 &&
                            gate_clk_macb325 && gate_clk_dma25 && gate_clk_cpu25 && gate_clk_urt25 && gate_clk_smc25);

  assign isolate_mem25  = (isolate_macb025 && isolate_macb125 && isolate_macb225 &&
                         isolate_macb325 && isolate_dma25 && isolate_cpu25 && isolate_urt25 && isolate_smc25);


  assign pwr1_on_mem25        =   ~pwr1_off_mem25;

  assign pwr2_on_mem25        =   ~pwr2_off_mem25;

  assign pwr1_off_mem25       =  (pwr1_off_macb025 && pwr1_off_macb125 && pwr1_off_macb225 &&
                                 pwr1_off_macb325 && pwr1_off_dma25 && pwr1_off_cpu25 && pwr1_off_urt25 && pwr1_off_smc25);


  assign pwr2_off_mem25       =  (pwr2_off_macb025 && pwr2_off_macb125 && pwr2_off_macb225 &&
                                pwr2_off_macb325 && pwr2_off_dma25 && pwr2_off_cpu25 && pwr2_off_urt25 && pwr2_off_smc25);

  assign save_edge_mem25      =  (save_edge_macb025 && save_edge_macb125 && save_edge_macb225 &&
                                save_edge_macb325 && save_edge_dma25 && save_edge_cpu25 && save_edge_smc25 && save_edge_urt25);

  assign restore_edge_mem25   =  (restore_edge_macb025 && restore_edge_macb125 && restore_edge_macb225  &&
                                restore_edge_macb325 && restore_edge_dma25 && restore_edge_cpu25 && restore_edge_urt25 &&
                                restore_edge_smc25);

  assign standby_mem025 = pwr1_off_macb025 && (~ (pwr1_off_macb025 && pwr1_off_macb125 && pwr1_off_macb225 && pwr1_off_macb325 && pwr1_off_urt25 && pwr1_off_smc25 && pwr1_off_dma25 && pwr1_off_cpu25));
  assign standby_mem125 = pwr1_off_macb125 && (~ (pwr1_off_macb025 && pwr1_off_macb125 && pwr1_off_macb225 && pwr1_off_macb325 && pwr1_off_urt25 && pwr1_off_smc25 && pwr1_off_dma25 && pwr1_off_cpu25));
  assign standby_mem225 = pwr1_off_macb225 && (~ (pwr1_off_macb025 && pwr1_off_macb125 && pwr1_off_macb225 && pwr1_off_macb325 && pwr1_off_urt25 && pwr1_off_smc25 && pwr1_off_dma25 && pwr1_off_cpu25));
  assign standby_mem325 = pwr1_off_macb325 && (~ (pwr1_off_macb025 && pwr1_off_macb125 && pwr1_off_macb225 && pwr1_off_macb325 && pwr1_off_urt25 && pwr1_off_smc25 && pwr1_off_dma25 && pwr1_off_cpu25));

  assign pwr1_off_mem025 = pwr1_off_mem25;
  assign pwr1_off_mem125 = pwr1_off_mem25;
  assign pwr1_off_mem225 = pwr1_off_mem25;
  assign pwr1_off_mem325 = pwr1_off_mem25;

  assign rstn_non_srpg_alut25  =  (rstn_non_srpg_macb025 && rstn_non_srpg_macb125 && rstn_non_srpg_macb225 && rstn_non_srpg_macb325);


   assign gate_clk_alut25       =  (gate_clk_macb025 && gate_clk_macb125 && gate_clk_macb225 && gate_clk_macb325);


    assign isolate_alut25        =  (isolate_macb025 && isolate_macb125 && isolate_macb225 && isolate_macb325);


    assign pwr1_on_alut25        =  (pwr1_on_macb025 || pwr1_on_macb125 || pwr1_on_macb225 || pwr1_on_macb325);


    assign pwr2_on_alut25        =  (pwr2_on_macb025 || pwr2_on_macb125 || pwr2_on_macb225 || pwr2_on_macb325);


    assign pwr1_off_alut25       =  (pwr1_off_macb025 && pwr1_off_macb125 && pwr1_off_macb225 && pwr1_off_macb325);


    assign pwr2_off_alut25       =  (pwr2_off_macb025 && pwr2_off_macb125 && pwr2_off_macb225 && pwr2_off_macb325);


    assign save_edge_alut25      =  (save_edge_macb025 && save_edge_macb125 && save_edge_macb225 && save_edge_macb325);


    assign restore_edge_alut25   =  (restore_edge_macb025 || restore_edge_macb125 || restore_edge_macb225 ||
                                   restore_edge_macb325) && save_alut_tmp25;

     // alut25 power25 off25 detection25
  always @(posedge pclk25 or negedge nprst25) begin
    if (!nprst25) 
       save_alut_tmp25 <= 0;
    else if (restore_edge_alut25)
       save_alut_tmp25 <= 0;
    else if (save_edge_alut25)
       save_alut_tmp25 <= 1;
  end

  //DMA25
  assign rstn_non_srpg_dma25 = (scan_mode25 == 1'b0) ?  rstn_non_srpg_dma_int25 : 1'b1;  
  assign gate_clk_dma25       = (scan_mode25 == 1'b0) ?  gate_clk_dma_int25      : 1'b0;     
  assign isolate_dma25        = (scan_mode25 == 1'b0) ?  isolate_dma_int25       : 1'b0;      
  assign pwr1_on_dma25        = (scan_mode25 == 1'b0) ?  pwr1_on_dma_int25       : 1'b1;       
  assign pwr2_on_dma25        = (scan_mode25 == 1'b0) ?  pwr2_on_dma_int25       : 1'b1;       
  assign pwr1_off_dma25       = (scan_mode25 == 1'b0) ?  (!pwr1_on_dma_int25)  : 1'b0;       
  assign pwr2_off_dma25       = (scan_mode25 == 1'b0) ?  (!pwr2_on_dma_int25)  : 1'b0;       
  assign save_edge_dma25       = (scan_mode25 == 1'b0) ? (save_edge_dma_int25) : 1'b0;       
  assign restore_edge_dma25       = (scan_mode25 == 1'b0) ? (restore_edge_dma_int25) : 1'b0;       

  //CPU25
  assign rstn_non_srpg_cpu25 = (scan_mode25 == 1'b0) ?  rstn_non_srpg_cpu_int25 : 1'b1;  
  assign gate_clk_cpu25       = (scan_mode25 == 1'b0) ?  gate_clk_cpu_int25      : 1'b0;     
  assign isolate_cpu25        = (scan_mode25 == 1'b0) ?  isolate_cpu_int25       : 1'b0;      
  assign pwr1_on_cpu25        = (scan_mode25 == 1'b0) ?  pwr1_on_cpu_int25       : 1'b1;       
  assign pwr2_on_cpu25        = (scan_mode25 == 1'b0) ?  pwr2_on_cpu_int25       : 1'b1;       
  assign pwr1_off_cpu25       = (scan_mode25 == 1'b0) ?  (!pwr1_on_cpu_int25)  : 1'b0;       
  assign pwr2_off_cpu25       = (scan_mode25 == 1'b0) ?  (!pwr2_on_cpu_int25)  : 1'b0;       
  assign save_edge_cpu25       = (scan_mode25 == 1'b0) ? (save_edge_cpu_int25) : 1'b0;       
  assign restore_edge_cpu25       = (scan_mode25 == 1'b0) ? (restore_edge_cpu_int25) : 1'b0;       



  // ASE25

   reg ase_core_12v25, ase_core_10v25, ase_core_08v25, ase_core_06v25;
   reg ase_macb0_12v25,ase_macb1_12v25,ase_macb2_12v25,ase_macb3_12v25;

    // core25 ase25

    // core25 at 1.0 v if (smc25 off25, urt25 off25, macb025 off25, macb125 off25, macb225 off25, macb325 off25
   // core25 at 0.8v if (mac01off25, macb02off25, macb03off25, macb12off25, mac13off25, mac23off25,
   // core25 at 0.6v if (mac012off25, mac013off25, mac023off25, mac123off25, mac0123off25
    // else core25 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb025 && pwr1_off_macb125 && pwr1_off_macb225 && pwr1_off_macb325) || // all mac25 off25
       (pwr1_off_macb325 && pwr1_off_macb225 && pwr1_off_macb125) || // mac123off25 
       (pwr1_off_macb325 && pwr1_off_macb225 && pwr1_off_macb025) || // mac023off25 
       (pwr1_off_macb325 && pwr1_off_macb125 && pwr1_off_macb025) || // mac013off25 
       (pwr1_off_macb225 && pwr1_off_macb125 && pwr1_off_macb025) )  // mac012off25 
       begin
         ase_core_12v25 = 0;
         ase_core_10v25 = 0;
         ase_core_08v25 = 0;
         ase_core_06v25 = 1;
       end
     else if( (pwr1_off_macb225 && pwr1_off_macb325) || // mac2325 off25
         (pwr1_off_macb325 && pwr1_off_macb125) || // mac13off25 
         (pwr1_off_macb125 && pwr1_off_macb225) || // mac12off25 
         (pwr1_off_macb325 && pwr1_off_macb025) || // mac03off25 
         (pwr1_off_macb225 && pwr1_off_macb025) || // mac02off25 
         (pwr1_off_macb125 && pwr1_off_macb025))  // mac01off25 
       begin
         ase_core_12v25 = 0;
         ase_core_10v25 = 0;
         ase_core_08v25 = 1;
         ase_core_06v25 = 0;
       end
     else if( (pwr1_off_smc25) || // smc25 off25
         (pwr1_off_macb025 ) || // mac0off25 
         (pwr1_off_macb125 ) || // mac1off25 
         (pwr1_off_macb225 ) || // mac2off25 
         (pwr1_off_macb325 ))  // mac3off25 
       begin
         ase_core_12v25 = 0;
         ase_core_10v25 = 1;
         ase_core_08v25 = 0;
         ase_core_06v25 = 0;
       end
     else if (pwr1_off_urt25)
       begin
         ase_core_12v25 = 1;
         ase_core_10v25 = 0;
         ase_core_08v25 = 0;
         ase_core_06v25 = 0;
       end
     else
       begin
         ase_core_12v25 = 1;
         ase_core_10v25 = 0;
         ase_core_08v25 = 0;
         ase_core_06v25 = 0;
       end
   end


   // cpu25
   // cpu25 @ 1.0v when macoff25, 
   // 
   reg ase_cpu_10v25, ase_cpu_12v25;
   always @(*) begin
    if(pwr1_off_cpu25) begin
     ase_cpu_12v25 = 1'b0;
     ase_cpu_10v25 = 1'b0;
    end
    else if(pwr1_off_macb025 || pwr1_off_macb125 || pwr1_off_macb225 || pwr1_off_macb325)
    begin
     ase_cpu_12v25 = 1'b0;
     ase_cpu_10v25 = 1'b1;
    end
    else
    begin
     ase_cpu_12v25 = 1'b1;
     ase_cpu_10v25 = 1'b0;
    end
   end

   // dma25
   // dma25 @v125.0 for macoff25, 

   reg ase_dma_10v25, ase_dma_12v25;
   always @(*) begin
    if(pwr1_off_dma25) begin
     ase_dma_12v25 = 1'b0;
     ase_dma_10v25 = 1'b0;
    end
    else if(pwr1_off_macb025 || pwr1_off_macb125 || pwr1_off_macb225 || pwr1_off_macb325)
    begin
     ase_dma_12v25 = 1'b0;
     ase_dma_10v25 = 1'b1;
    end
    else
    begin
     ase_dma_12v25 = 1'b1;
     ase_dma_10v25 = 1'b0;
    end
   end

   // alut25
   // @ v125.0 for macoff25

   reg ase_alut_10v25, ase_alut_12v25;
   always @(*) begin
    if(pwr1_off_alut25) begin
     ase_alut_12v25 = 1'b0;
     ase_alut_10v25 = 1'b0;
    end
    else if(pwr1_off_macb025 || pwr1_off_macb125 || pwr1_off_macb225 || pwr1_off_macb325)
    begin
     ase_alut_12v25 = 1'b0;
     ase_alut_10v25 = 1'b1;
    end
    else
    begin
     ase_alut_12v25 = 1'b1;
     ase_alut_10v25 = 1'b0;
    end
   end




   reg ase_uart_12v25;
   reg ase_uart_10v25;
   reg ase_uart_08v25;
   reg ase_uart_06v25;

   reg ase_smc_12v25;


   always @(*) begin
     if(pwr1_off_urt25) begin // uart25 off25
       ase_uart_08v25 = 1'b0;
       ase_uart_06v25 = 1'b0;
       ase_uart_10v25 = 1'b0;
       ase_uart_12v25 = 1'b0;
     end 
     else if( (pwr1_off_macb025 && pwr1_off_macb125 && pwr1_off_macb225 && pwr1_off_macb325) || // all mac25 off25
       (pwr1_off_macb325 && pwr1_off_macb225 && pwr1_off_macb125) || // mac123off25 
       (pwr1_off_macb325 && pwr1_off_macb225 && pwr1_off_macb025) || // mac023off25 
       (pwr1_off_macb325 && pwr1_off_macb125 && pwr1_off_macb025) || // mac013off25 
       (pwr1_off_macb225 && pwr1_off_macb125 && pwr1_off_macb025) )  // mac012off25 
     begin
       ase_uart_06v25 = 1'b1;
       ase_uart_08v25 = 1'b0;
       ase_uart_10v25 = 1'b0;
       ase_uart_12v25 = 1'b0;
     end
     else if( (pwr1_off_macb225 && pwr1_off_macb325) || // mac2325 off25
         (pwr1_off_macb325 && pwr1_off_macb125) || // mac13off25 
         (pwr1_off_macb125 && pwr1_off_macb225) || // mac12off25 
         (pwr1_off_macb325 && pwr1_off_macb025) || // mac03off25 
         (pwr1_off_macb125 && pwr1_off_macb025))  // mac01off25  
     begin
       ase_uart_06v25 = 1'b0;
       ase_uart_08v25 = 1'b1;
       ase_uart_10v25 = 1'b0;
       ase_uart_12v25 = 1'b0;
     end
     else if (pwr1_off_smc25 || pwr1_off_macb025 || pwr1_off_macb125 || pwr1_off_macb225 || pwr1_off_macb325) begin // smc25 off25
       ase_uart_08v25 = 1'b0;
       ase_uart_06v25 = 1'b0;
       ase_uart_10v25 = 1'b1;
       ase_uart_12v25 = 1'b0;
     end 
     else begin
       ase_uart_08v25 = 1'b0;
       ase_uart_06v25 = 1'b0;
       ase_uart_10v25 = 1'b0;
       ase_uart_12v25 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc25) begin
     if (pwr1_off_smc25)  // smc25 off25
       ase_smc_12v25 = 1'b0;
    else
       ase_smc_12v25 = 1'b1;
   end

   
   always @(pwr1_off_macb025) begin
     if (pwr1_off_macb025) // macb025 off25
       ase_macb0_12v25 = 1'b0;
     else
       ase_macb0_12v25 = 1'b1;
   end

   always @(pwr1_off_macb125) begin
     if (pwr1_off_macb125) // macb125 off25
       ase_macb1_12v25 = 1'b0;
     else
       ase_macb1_12v25 = 1'b1;
   end

   always @(pwr1_off_macb225) begin // macb225 off25
     if (pwr1_off_macb225) // macb225 off25
       ase_macb2_12v25 = 1'b0;
     else
       ase_macb2_12v25 = 1'b1;
   end

   always @(pwr1_off_macb325) begin // macb325 off25
     if (pwr1_off_macb325) // macb325 off25
       ase_macb3_12v25 = 1'b0;
     else
       ase_macb3_12v25 = 1'b1;
   end


   // core25 voltage25 for vco25
  assign core12v25 = ase_macb0_12v25 & ase_macb1_12v25 & ase_macb2_12v25 & ase_macb3_12v25;

  assign core10v25 =  (ase_macb0_12v25 & ase_macb1_12v25 & ase_macb2_12v25 & (!ase_macb3_12v25)) ||
                    (ase_macb0_12v25 & ase_macb1_12v25 & (!ase_macb2_12v25) & ase_macb3_12v25) ||
                    (ase_macb0_12v25 & (!ase_macb1_12v25) & ase_macb2_12v25 & ase_macb3_12v25) ||
                    ((!ase_macb0_12v25) & ase_macb1_12v25 & ase_macb2_12v25 & ase_macb3_12v25);

  assign core08v25 =  ((!ase_macb0_12v25) & (!ase_macb1_12v25) & (ase_macb2_12v25) & (ase_macb3_12v25)) ||
                    ((!ase_macb0_12v25) & (ase_macb1_12v25) & (!ase_macb2_12v25) & (ase_macb3_12v25)) ||
                    ((!ase_macb0_12v25) & (ase_macb1_12v25) & (ase_macb2_12v25) & (!ase_macb3_12v25)) ||
                    ((ase_macb0_12v25) & (!ase_macb1_12v25) & (!ase_macb2_12v25) & (ase_macb3_12v25)) ||
                    ((ase_macb0_12v25) & (!ase_macb1_12v25) & (ase_macb2_12v25) & (!ase_macb3_12v25)) ||
                    ((ase_macb0_12v25) & (ase_macb1_12v25) & (!ase_macb2_12v25) & (!ase_macb3_12v25));

  assign core06v25 =  ((!ase_macb0_12v25) & (!ase_macb1_12v25) & (!ase_macb2_12v25) & (ase_macb3_12v25)) ||
                    ((!ase_macb0_12v25) & (!ase_macb1_12v25) & (ase_macb2_12v25) & (!ase_macb3_12v25)) ||
                    ((!ase_macb0_12v25) & (ase_macb1_12v25) & (!ase_macb2_12v25) & (!ase_macb3_12v25)) ||
                    ((ase_macb0_12v25) & (!ase_macb1_12v25) & (!ase_macb2_12v25) & (!ase_macb3_12v25)) ||
                    ((!ase_macb0_12v25) & (!ase_macb1_12v25) & (!ase_macb2_12v25) & (!ase_macb3_12v25)) ;



`ifdef LP_ABV_ON25
// psl25 default clock25 = (posedge pclk25);

// Cover25 a condition in which SMC25 is powered25 down
// and again25 powered25 up while UART25 is going25 into POWER25 down
// state or UART25 is already in POWER25 DOWN25 state
// psl25 cover_overlapping_smc_urt_125:
//    cover{fell25(pwr1_on_urt25);[*];fell25(pwr1_on_smc25);[*];
//    rose25(pwr1_on_smc25);[*];rose25(pwr1_on_urt25)};
//
// Cover25 a condition in which UART25 is powered25 down
// and again25 powered25 up while SMC25 is going25 into POWER25 down
// state or SMC25 is already in POWER25 DOWN25 state
// psl25 cover_overlapping_smc_urt_225:
//    cover{fell25(pwr1_on_smc25);[*];fell25(pwr1_on_urt25);[*];
//    rose25(pwr1_on_urt25);[*];rose25(pwr1_on_smc25)};
//


// Power25 Down25 UART25
// This25 gets25 triggered on rising25 edge of Gate25 signal25 for
// UART25 (gate_clk_urt25). In a next cycle after gate_clk_urt25,
// Isolate25 UART25(isolate_urt25) signal25 become25 HIGH25 (active).
// In 2nd cycle after gate_clk_urt25 becomes HIGH25, RESET25 for NON25
// SRPG25 FFs25(rstn_non_srpg_urt25) and POWER125 for UART25(pwr1_on_urt25) should 
// go25 LOW25. 
// This25 completes25 a POWER25 DOWN25. 

sequence s_power_down_urt25;
      (gate_clk_urt25 & !isolate_urt25 & rstn_non_srpg_urt25 & pwr1_on_urt25) 
  ##1 (gate_clk_urt25 & isolate_urt25 & rstn_non_srpg_urt25 & pwr1_on_urt25) 
  ##3 (gate_clk_urt25 & isolate_urt25 & !rstn_non_srpg_urt25 & !pwr1_on_urt25);
endsequence


property p_power_down_urt25;
   @(posedge pclk25)
    $rose(gate_clk_urt25) |=> s_power_down_urt25;
endproperty

output_power_down_urt25:
  assert property (p_power_down_urt25);


// Power25 UP25 UART25
// Sequence starts with , Rising25 edge of pwr1_on_urt25.
// Two25 clock25 cycle after this, isolate_urt25 should become25 LOW25 
// On25 the following25 clk25 gate_clk_urt25 should go25 low25.
// 5 cycles25 after  Rising25 edge of pwr1_on_urt25, rstn_non_srpg_urt25
// should become25 HIGH25
sequence s_power_up_urt25;
##30 (pwr1_on_urt25 & !isolate_urt25 & gate_clk_urt25 & !rstn_non_srpg_urt25) 
##1 (pwr1_on_urt25 & !isolate_urt25 & !gate_clk_urt25 & !rstn_non_srpg_urt25) 
##2 (pwr1_on_urt25 & !isolate_urt25 & !gate_clk_urt25 & rstn_non_srpg_urt25);
endsequence

property p_power_up_urt25;
   @(posedge pclk25)
  disable iff(!nprst25)
    (!pwr1_on_urt25 ##1 pwr1_on_urt25) |=> s_power_up_urt25;
endproperty

output_power_up_urt25:
  assert property (p_power_up_urt25);


// Power25 Down25 SMC25
// This25 gets25 triggered on rising25 edge of Gate25 signal25 for
// SMC25 (gate_clk_smc25). In a next cycle after gate_clk_smc25,
// Isolate25 SMC25(isolate_smc25) signal25 become25 HIGH25 (active).
// In 2nd cycle after gate_clk_smc25 becomes HIGH25, RESET25 for NON25
// SRPG25 FFs25(rstn_non_srpg_smc25) and POWER125 for SMC25(pwr1_on_smc25) should 
// go25 LOW25. 
// This25 completes25 a POWER25 DOWN25. 

sequence s_power_down_smc25;
      (gate_clk_smc25 & !isolate_smc25 & rstn_non_srpg_smc25 & pwr1_on_smc25) 
  ##1 (gate_clk_smc25 & isolate_smc25 & rstn_non_srpg_smc25 & pwr1_on_smc25) 
  ##3 (gate_clk_smc25 & isolate_smc25 & !rstn_non_srpg_smc25 & !pwr1_on_smc25);
endsequence


property p_power_down_smc25;
   @(posedge pclk25)
    $rose(gate_clk_smc25) |=> s_power_down_smc25;
endproperty

output_power_down_smc25:
  assert property (p_power_down_smc25);


// Power25 UP25 SMC25
// Sequence starts with , Rising25 edge of pwr1_on_smc25.
// Two25 clock25 cycle after this, isolate_smc25 should become25 LOW25 
// On25 the following25 clk25 gate_clk_smc25 should go25 low25.
// 5 cycles25 after  Rising25 edge of pwr1_on_smc25, rstn_non_srpg_smc25
// should become25 HIGH25
sequence s_power_up_smc25;
##30 (pwr1_on_smc25 & !isolate_smc25 & gate_clk_smc25 & !rstn_non_srpg_smc25) 
##1 (pwr1_on_smc25 & !isolate_smc25 & !gate_clk_smc25 & !rstn_non_srpg_smc25) 
##2 (pwr1_on_smc25 & !isolate_smc25 & !gate_clk_smc25 & rstn_non_srpg_smc25);
endsequence

property p_power_up_smc25;
   @(posedge pclk25)
  disable iff(!nprst25)
    (!pwr1_on_smc25 ##1 pwr1_on_smc25) |=> s_power_up_smc25;
endproperty

output_power_up_smc25:
  assert property (p_power_up_smc25);


// COVER25 SMC25 POWER25 DOWN25 AND25 UP25
cover_power_down_up_smc25: cover property (@(posedge pclk25)
(s_power_down_smc25 ##[5:180] s_power_up_smc25));



// COVER25 UART25 POWER25 DOWN25 AND25 UP25
cover_power_down_up_urt25: cover property (@(posedge pclk25)
(s_power_down_urt25 ##[5:180] s_power_up_urt25));

cover_power_down_urt25: cover property (@(posedge pclk25)
(s_power_down_urt25));

cover_power_up_urt25: cover property (@(posedge pclk25)
(s_power_up_urt25));




`ifdef PCM_ABV_ON25
//------------------------------------------------------------------------------
// Power25 Controller25 Formal25 Verification25 component.  Each power25 domain has a 
// separate25 instantiation25
//------------------------------------------------------------------------------

// need to assume that CPU25 will leave25 a minimum time between powering25 down and 
// back up.  In this example25, 10clks has been selected.
// psl25 config_min_uart_pd_time25 : assume always {rose25(L1_ctrl_domain25[1])} |-> { L1_ctrl_domain25[1][*10] } abort25(~nprst25);
// psl25 config_min_uart_pu_time25 : assume always {fell25(L1_ctrl_domain25[1])} |-> { !L1_ctrl_domain25[1][*10] } abort25(~nprst25);
// psl25 config_min_smc_pd_time25 : assume always {rose25(L1_ctrl_domain25[2])} |-> { L1_ctrl_domain25[2][*10] } abort25(~nprst25);
// psl25 config_min_smc_pu_time25 : assume always {fell25(L1_ctrl_domain25[2])} |-> { !L1_ctrl_domain25[2][*10] } abort25(~nprst25);

// UART25 VCOMP25 parameters25
   defparam i_uart_vcomp_domain25.ENABLE_SAVE_RESTORE_EDGE25   = 1;
   defparam i_uart_vcomp_domain25.ENABLE_EXT_PWR_CNTRL25       = 1;
   defparam i_uart_vcomp_domain25.REF_CLK_DEFINED25            = 0;
   defparam i_uart_vcomp_domain25.MIN_SHUTOFF_CYCLES25         = 4;
   defparam i_uart_vcomp_domain25.MIN_RESTORE_TO_ISO_CYCLES25  = 0;
   defparam i_uart_vcomp_domain25.MIN_SAVE_TO_SHUTOFF_CYCLES25 = 1;


   vcomp_domain25 i_uart_vcomp_domain25
   ( .ref_clk25(pclk25),
     .start_lps25(L1_ctrl_domain25[1] || !rstn_non_srpg_urt25),
     .rst_n25(nprst25),
     .ext_power_down25(L1_ctrl_domain25[1]),
     .iso_en25(isolate_urt25),
     .save_edge25(save_edge_urt25),
     .restore_edge25(restore_edge_urt25),
     .domain_shut_off25(pwr1_off_urt25),
     .domain_clk25(!gate_clk_urt25 && pclk25)
   );


// SMC25 VCOMP25 parameters25
   defparam i_smc_vcomp_domain25.ENABLE_SAVE_RESTORE_EDGE25   = 1;
   defparam i_smc_vcomp_domain25.ENABLE_EXT_PWR_CNTRL25       = 1;
   defparam i_smc_vcomp_domain25.REF_CLK_DEFINED25            = 0;
   defparam i_smc_vcomp_domain25.MIN_SHUTOFF_CYCLES25         = 4;
   defparam i_smc_vcomp_domain25.MIN_RESTORE_TO_ISO_CYCLES25  = 0;
   defparam i_smc_vcomp_domain25.MIN_SAVE_TO_SHUTOFF_CYCLES25 = 1;


   vcomp_domain25 i_smc_vcomp_domain25
   ( .ref_clk25(pclk25),
     .start_lps25(L1_ctrl_domain25[2] || !rstn_non_srpg_smc25),
     .rst_n25(nprst25),
     .ext_power_down25(L1_ctrl_domain25[2]),
     .iso_en25(isolate_smc25),
     .save_edge25(save_edge_smc25),
     .restore_edge25(restore_edge_smc25),
     .domain_shut_off25(pwr1_off_smc25),
     .domain_clk25(!gate_clk_smc25 && pclk25)
   );

`endif

`endif



endmodule
