//File22 name   : power_ctrl22.v
//Title22       : Power22 Control22 Module22
//Created22     : 1999
//Description22 : Top22 level of power22 controller22
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

module power_ctrl22 (


    // Clocks22 & Reset22
    pclk22,
    nprst22,
    // APB22 programming22 interface
    paddr22,
    psel22,
    penable22,
    pwrite22,
    pwdata22,
    prdata22,
    // mac22 i/f,
    macb3_wakeup22,
    macb2_wakeup22,
    macb1_wakeup22,
    macb0_wakeup22,
    // Scan22 
    scan_in22,
    scan_en22,
    scan_mode22,
    scan_out22,
    // Module22 control22 outputs22
    int_source_h22,
    // SMC22
    rstn_non_srpg_smc22,
    gate_clk_smc22,
    isolate_smc22,
    save_edge_smc22,
    restore_edge_smc22,
    pwr1_on_smc22,
    pwr2_on_smc22,
    pwr1_off_smc22,
    pwr2_off_smc22,
    // URT22
    rstn_non_srpg_urt22,
    gate_clk_urt22,
    isolate_urt22,
    save_edge_urt22,
    restore_edge_urt22,
    pwr1_on_urt22,
    pwr2_on_urt22,
    pwr1_off_urt22,      
    pwr2_off_urt22,
    // ETH022
    rstn_non_srpg_macb022,
    gate_clk_macb022,
    isolate_macb022,
    save_edge_macb022,
    restore_edge_macb022,
    pwr1_on_macb022,
    pwr2_on_macb022,
    pwr1_off_macb022,      
    pwr2_off_macb022,
    // ETH122
    rstn_non_srpg_macb122,
    gate_clk_macb122,
    isolate_macb122,
    save_edge_macb122,
    restore_edge_macb122,
    pwr1_on_macb122,
    pwr2_on_macb122,
    pwr1_off_macb122,      
    pwr2_off_macb122,
    // ETH222
    rstn_non_srpg_macb222,
    gate_clk_macb222,
    isolate_macb222,
    save_edge_macb222,
    restore_edge_macb222,
    pwr1_on_macb222,
    pwr2_on_macb222,
    pwr1_off_macb222,      
    pwr2_off_macb222,
    // ETH322
    rstn_non_srpg_macb322,
    gate_clk_macb322,
    isolate_macb322,
    save_edge_macb322,
    restore_edge_macb322,
    pwr1_on_macb322,
    pwr2_on_macb322,
    pwr1_off_macb322,      
    pwr2_off_macb322,
    // DMA22
    rstn_non_srpg_dma22,
    gate_clk_dma22,
    isolate_dma22,
    save_edge_dma22,
    restore_edge_dma22,
    pwr1_on_dma22,
    pwr2_on_dma22,
    pwr1_off_dma22,      
    pwr2_off_dma22,
    // CPU22
    rstn_non_srpg_cpu22,
    gate_clk_cpu22,
    isolate_cpu22,
    save_edge_cpu22,
    restore_edge_cpu22,
    pwr1_on_cpu22,
    pwr2_on_cpu22,
    pwr1_off_cpu22,      
    pwr2_off_cpu22,
    // ALUT22
    rstn_non_srpg_alut22,
    gate_clk_alut22,
    isolate_alut22,
    save_edge_alut22,
    restore_edge_alut22,
    pwr1_on_alut22,
    pwr2_on_alut22,
    pwr1_off_alut22,      
    pwr2_off_alut22,
    // MEM22
    rstn_non_srpg_mem22,
    gate_clk_mem22,
    isolate_mem22,
    save_edge_mem22,
    restore_edge_mem22,
    pwr1_on_mem22,
    pwr2_on_mem22,
    pwr1_off_mem22,      
    pwr2_off_mem22,
    // core22 dvfs22 transitions22
    core06v22,
    core08v22,
    core10v22,
    core12v22,
    pcm_macb_wakeup_int22,
    // mte22 signals22
    mte_smc_start22,
    mte_uart_start22,
    mte_smc_uart_start22,  
    mte_pm_smc_to_default_start22, 
    mte_pm_uart_to_default_start22,
    mte_pm_smc_uart_to_default_start22

  );

  parameter STATE_IDLE_12V22 = 4'b0001;
  parameter STATE_06V22 = 4'b0010;
  parameter STATE_08V22 = 4'b0100;
  parameter STATE_10V22 = 4'b1000;

    // Clocks22 & Reset22
    input pclk22;
    input nprst22;
    // APB22 programming22 interface
    input [31:0] paddr22;
    input psel22  ;
    input penable22;
    input pwrite22 ;
    input [31:0] pwdata22;
    output [31:0] prdata22;
    // mac22
    input macb3_wakeup22;
    input macb2_wakeup22;
    input macb1_wakeup22;
    input macb0_wakeup22;
    // Scan22 
    input scan_in22;
    input scan_en22;
    input scan_mode22;
    output scan_out22;
    // Module22 control22 outputs22
    input int_source_h22;
    // SMC22
    output rstn_non_srpg_smc22 ;
    output gate_clk_smc22   ;
    output isolate_smc22   ;
    output save_edge_smc22   ;
    output restore_edge_smc22   ;
    output pwr1_on_smc22   ;
    output pwr2_on_smc22   ;
    output pwr1_off_smc22  ;
    output pwr2_off_smc22  ;
    // URT22
    output rstn_non_srpg_urt22 ;
    output gate_clk_urt22      ;
    output isolate_urt22       ;
    output save_edge_urt22   ;
    output restore_edge_urt22   ;
    output pwr1_on_urt22       ;
    output pwr2_on_urt22       ;
    output pwr1_off_urt22      ;
    output pwr2_off_urt22      ;
    // ETH022
    output rstn_non_srpg_macb022 ;
    output gate_clk_macb022      ;
    output isolate_macb022       ;
    output save_edge_macb022   ;
    output restore_edge_macb022   ;
    output pwr1_on_macb022       ;
    output pwr2_on_macb022       ;
    output pwr1_off_macb022      ;
    output pwr2_off_macb022      ;
    // ETH122
    output rstn_non_srpg_macb122 ;
    output gate_clk_macb122      ;
    output isolate_macb122       ;
    output save_edge_macb122   ;
    output restore_edge_macb122   ;
    output pwr1_on_macb122       ;
    output pwr2_on_macb122       ;
    output pwr1_off_macb122      ;
    output pwr2_off_macb122      ;
    // ETH222
    output rstn_non_srpg_macb222 ;
    output gate_clk_macb222      ;
    output isolate_macb222       ;
    output save_edge_macb222   ;
    output restore_edge_macb222   ;
    output pwr1_on_macb222       ;
    output pwr2_on_macb222       ;
    output pwr1_off_macb222      ;
    output pwr2_off_macb222      ;
    // ETH322
    output rstn_non_srpg_macb322 ;
    output gate_clk_macb322      ;
    output isolate_macb322       ;
    output save_edge_macb322   ;
    output restore_edge_macb322   ;
    output pwr1_on_macb322       ;
    output pwr2_on_macb322       ;
    output pwr1_off_macb322      ;
    output pwr2_off_macb322      ;
    // DMA22
    output rstn_non_srpg_dma22 ;
    output gate_clk_dma22      ;
    output isolate_dma22       ;
    output save_edge_dma22   ;
    output restore_edge_dma22   ;
    output pwr1_on_dma22       ;
    output pwr2_on_dma22       ;
    output pwr1_off_dma22      ;
    output pwr2_off_dma22      ;
    // CPU22
    output rstn_non_srpg_cpu22 ;
    output gate_clk_cpu22      ;
    output isolate_cpu22       ;
    output save_edge_cpu22   ;
    output restore_edge_cpu22   ;
    output pwr1_on_cpu22       ;
    output pwr2_on_cpu22       ;
    output pwr1_off_cpu22      ;
    output pwr2_off_cpu22      ;
    // ALUT22
    output rstn_non_srpg_alut22 ;
    output gate_clk_alut22      ;
    output isolate_alut22       ;
    output save_edge_alut22   ;
    output restore_edge_alut22   ;
    output pwr1_on_alut22       ;
    output pwr2_on_alut22       ;
    output pwr1_off_alut22      ;
    output pwr2_off_alut22      ;
    // MEM22
    output rstn_non_srpg_mem22 ;
    output gate_clk_mem22      ;
    output isolate_mem22       ;
    output save_edge_mem22   ;
    output restore_edge_mem22   ;
    output pwr1_on_mem22       ;
    output pwr2_on_mem22       ;
    output pwr1_off_mem22      ;
    output pwr2_off_mem22      ;


   // core22 transitions22 o/p
    output core06v22;
    output core08v22;
    output core10v22;
    output core12v22;
    output pcm_macb_wakeup_int22 ;
    //mode mte22  signals22
    output mte_smc_start22;
    output mte_uart_start22;
    output mte_smc_uart_start22;  
    output mte_pm_smc_to_default_start22; 
    output mte_pm_uart_to_default_start22;
    output mte_pm_smc_uart_to_default_start22;

    reg mte_smc_start22;
    reg mte_uart_start22;
    reg mte_smc_uart_start22;  
    reg mte_pm_smc_to_default_start22; 
    reg mte_pm_uart_to_default_start22;
    reg mte_pm_smc_uart_to_default_start22;

    reg [31:0] prdata22;

  wire valid_reg_write22  ;
  wire valid_reg_read22   ;
  wire L1_ctrl_access22   ;
  wire L1_status_access22 ;
  wire pcm_int_mask_access22;
  wire pcm_int_status_access22;
  wire standby_mem022      ;
  wire standby_mem122      ;
  wire standby_mem222      ;
  wire standby_mem322      ;
  wire pwr1_off_mem022;
  wire pwr1_off_mem122;
  wire pwr1_off_mem222;
  wire pwr1_off_mem322;
  
  // Control22 signals22
  wire set_status_smc22   ;
  wire clr_status_smc22   ;
  wire set_status_urt22   ;
  wire clr_status_urt22   ;
  wire set_status_macb022   ;
  wire clr_status_macb022   ;
  wire set_status_macb122   ;
  wire clr_status_macb122   ;
  wire set_status_macb222   ;
  wire clr_status_macb222   ;
  wire set_status_macb322   ;
  wire clr_status_macb322   ;
  wire set_status_dma22   ;
  wire clr_status_dma22   ;
  wire set_status_cpu22   ;
  wire clr_status_cpu22   ;
  wire set_status_alut22   ;
  wire clr_status_alut22   ;
  wire set_status_mem22   ;
  wire clr_status_mem22   ;


  // Status and Control22 registers
  reg [31:0]  L1_status_reg22;
  reg  [31:0] L1_ctrl_reg22  ;
  reg  [31:0] L1_ctrl_domain22  ;
  reg L1_ctrl_cpu_off_reg22;
  reg [31:0]  pcm_mask_reg22;
  reg [31:0]  pcm_status_reg22;

  // Signals22 gated22 in scan_mode22
  //SMC22
  wire  rstn_non_srpg_smc_int22;
  wire  gate_clk_smc_int22    ;     
  wire  isolate_smc_int22    ;       
  wire save_edge_smc_int22;
  wire restore_edge_smc_int22;
  wire  pwr1_on_smc_int22    ;      
  wire  pwr2_on_smc_int22    ;      


  //URT22
  wire   rstn_non_srpg_urt_int22;
  wire   gate_clk_urt_int22     ;     
  wire   isolate_urt_int22      ;       
  wire save_edge_urt_int22;
  wire restore_edge_urt_int22;
  wire   pwr1_on_urt_int22      ;      
  wire   pwr2_on_urt_int22      ;      

  // ETH022
  wire   rstn_non_srpg_macb0_int22;
  wire   gate_clk_macb0_int22     ;     
  wire   isolate_macb0_int22      ;       
  wire save_edge_macb0_int22;
  wire restore_edge_macb0_int22;
  wire   pwr1_on_macb0_int22      ;      
  wire   pwr2_on_macb0_int22      ;      
  // ETH122
  wire   rstn_non_srpg_macb1_int22;
  wire   gate_clk_macb1_int22     ;     
  wire   isolate_macb1_int22      ;       
  wire save_edge_macb1_int22;
  wire restore_edge_macb1_int22;
  wire   pwr1_on_macb1_int22      ;      
  wire   pwr2_on_macb1_int22      ;      
  // ETH222
  wire   rstn_non_srpg_macb2_int22;
  wire   gate_clk_macb2_int22     ;     
  wire   isolate_macb2_int22      ;       
  wire save_edge_macb2_int22;
  wire restore_edge_macb2_int22;
  wire   pwr1_on_macb2_int22      ;      
  wire   pwr2_on_macb2_int22      ;      
  // ETH322
  wire   rstn_non_srpg_macb3_int22;
  wire   gate_clk_macb3_int22     ;     
  wire   isolate_macb3_int22      ;       
  wire save_edge_macb3_int22;
  wire restore_edge_macb3_int22;
  wire   pwr1_on_macb3_int22      ;      
  wire   pwr2_on_macb3_int22      ;      

  // DMA22
  wire   rstn_non_srpg_dma_int22;
  wire   gate_clk_dma_int22     ;     
  wire   isolate_dma_int22      ;       
  wire save_edge_dma_int22;
  wire restore_edge_dma_int22;
  wire   pwr1_on_dma_int22      ;      
  wire   pwr2_on_dma_int22      ;      

  // CPU22
  wire   rstn_non_srpg_cpu_int22;
  wire   gate_clk_cpu_int22     ;     
  wire   isolate_cpu_int22      ;       
  wire save_edge_cpu_int22;
  wire restore_edge_cpu_int22;
  wire   pwr1_on_cpu_int22      ;      
  wire   pwr2_on_cpu_int22      ;  
  wire L1_ctrl_cpu_off_p22;    

  reg save_alut_tmp22;
  // DFS22 sm22

  reg cpu_shutoff_ctrl22;

  reg mte_mac_off_start22, mte_mac012_start22, mte_mac013_start22, mte_mac023_start22, mte_mac123_start22;
  reg mte_mac01_start22, mte_mac02_start22, mte_mac03_start22, mte_mac12_start22, mte_mac13_start22, mte_mac23_start22;
  reg mte_mac0_start22, mte_mac1_start22, mte_mac2_start22, mte_mac3_start22;
  reg mte_sys_hibernate22 ;
  reg mte_dma_start22 ;
  reg mte_cpu_start22 ;
  reg mte_mac_off_sleep_start22, mte_mac012_sleep_start22, mte_mac013_sleep_start22, mte_mac023_sleep_start22, mte_mac123_sleep_start22;
  reg mte_mac01_sleep_start22, mte_mac02_sleep_start22, mte_mac03_sleep_start22, mte_mac12_sleep_start22, mte_mac13_sleep_start22, mte_mac23_sleep_start22;
  reg mte_mac0_sleep_start22, mte_mac1_sleep_start22, mte_mac2_sleep_start22, mte_mac3_sleep_start22;
  reg mte_dma_sleep_start22;
  reg mte_mac_off_to_default22, mte_mac012_to_default22, mte_mac013_to_default22, mte_mac023_to_default22, mte_mac123_to_default22;
  reg mte_mac01_to_default22, mte_mac02_to_default22, mte_mac03_to_default22, mte_mac12_to_default22, mte_mac13_to_default22, mte_mac23_to_default22;
  reg mte_mac0_to_default22, mte_mac1_to_default22, mte_mac2_to_default22, mte_mac3_to_default22;
  reg mte_dma_isolate_dis22;
  reg mte_cpu_isolate_dis22;
  reg mte_sys_hibernate_to_default22;


  // Latch22 the CPU22 SLEEP22 invocation22
  always @( posedge pclk22 or negedge nprst22) 
  begin
    if(!nprst22)
      L1_ctrl_cpu_off_reg22 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg22 <= L1_ctrl_domain22[8];
  end

  // Create22 a pulse22 for sleep22 detection22 
  assign L1_ctrl_cpu_off_p22 =  L1_ctrl_domain22[8] && !L1_ctrl_cpu_off_reg22;
  
  // CPU22 sleep22 contol22 logic 
  // Shut22 off22 CPU22 when L1_ctrl_cpu_off_p22 is set
  // wake22 cpu22 when any interrupt22 is seen22  
  always @( posedge pclk22 or negedge nprst22) 
  begin
    if(!nprst22)
     cpu_shutoff_ctrl22 <= 1'b0;
    else if(cpu_shutoff_ctrl22 && int_source_h22)
     cpu_shutoff_ctrl22 <= 1'b0;
    else if (L1_ctrl_cpu_off_p22)
     cpu_shutoff_ctrl22 <= 1'b1;
  end
 
  // instantiate22 power22 contol22  block for uart22
  power_ctrl_sm22 i_urt_power_ctrl_sm22(
    .pclk22(pclk22),
    .nprst22(nprst22),
    .L1_module_req22(L1_ctrl_domain22[1]),
    .set_status_module22(set_status_urt22),
    .clr_status_module22(clr_status_urt22),
    .rstn_non_srpg_module22(rstn_non_srpg_urt_int22),
    .gate_clk_module22(gate_clk_urt_int22),
    .isolate_module22(isolate_urt_int22),
    .save_edge22(save_edge_urt_int22),
    .restore_edge22(restore_edge_urt_int22),
    .pwr1_on22(pwr1_on_urt_int22),
    .pwr2_on22(pwr2_on_urt_int22)
    );
  

  // instantiate22 power22 contol22  block for smc22
  power_ctrl_sm22 i_smc_power_ctrl_sm22(
    .pclk22(pclk22),
    .nprst22(nprst22),
    .L1_module_req22(L1_ctrl_domain22[2]),
    .set_status_module22(set_status_smc22),
    .clr_status_module22(clr_status_smc22),
    .rstn_non_srpg_module22(rstn_non_srpg_smc_int22),
    .gate_clk_module22(gate_clk_smc_int22),
    .isolate_module22(isolate_smc_int22),
    .save_edge22(save_edge_smc_int22),
    .restore_edge22(restore_edge_smc_int22),
    .pwr1_on22(pwr1_on_smc_int22),
    .pwr2_on22(pwr2_on_smc_int22)
    );

  // power22 control22 for macb022
  power_ctrl_sm22 i_macb0_power_ctrl_sm22(
    .pclk22(pclk22),
    .nprst22(nprst22),
    .L1_module_req22(L1_ctrl_domain22[3]),
    .set_status_module22(set_status_macb022),
    .clr_status_module22(clr_status_macb022),
    .rstn_non_srpg_module22(rstn_non_srpg_macb0_int22),
    .gate_clk_module22(gate_clk_macb0_int22),
    .isolate_module22(isolate_macb0_int22),
    .save_edge22(save_edge_macb0_int22),
    .restore_edge22(restore_edge_macb0_int22),
    .pwr1_on22(pwr1_on_macb0_int22),
    .pwr2_on22(pwr2_on_macb0_int22)
    );
  // power22 control22 for macb122
  power_ctrl_sm22 i_macb1_power_ctrl_sm22(
    .pclk22(pclk22),
    .nprst22(nprst22),
    .L1_module_req22(L1_ctrl_domain22[4]),
    .set_status_module22(set_status_macb122),
    .clr_status_module22(clr_status_macb122),
    .rstn_non_srpg_module22(rstn_non_srpg_macb1_int22),
    .gate_clk_module22(gate_clk_macb1_int22),
    .isolate_module22(isolate_macb1_int22),
    .save_edge22(save_edge_macb1_int22),
    .restore_edge22(restore_edge_macb1_int22),
    .pwr1_on22(pwr1_on_macb1_int22),
    .pwr2_on22(pwr2_on_macb1_int22)
    );
  // power22 control22 for macb222
  power_ctrl_sm22 i_macb2_power_ctrl_sm22(
    .pclk22(pclk22),
    .nprst22(nprst22),
    .L1_module_req22(L1_ctrl_domain22[5]),
    .set_status_module22(set_status_macb222),
    .clr_status_module22(clr_status_macb222),
    .rstn_non_srpg_module22(rstn_non_srpg_macb2_int22),
    .gate_clk_module22(gate_clk_macb2_int22),
    .isolate_module22(isolate_macb2_int22),
    .save_edge22(save_edge_macb2_int22),
    .restore_edge22(restore_edge_macb2_int22),
    .pwr1_on22(pwr1_on_macb2_int22),
    .pwr2_on22(pwr2_on_macb2_int22)
    );
  // power22 control22 for macb322
  power_ctrl_sm22 i_macb3_power_ctrl_sm22(
    .pclk22(pclk22),
    .nprst22(nprst22),
    .L1_module_req22(L1_ctrl_domain22[6]),
    .set_status_module22(set_status_macb322),
    .clr_status_module22(clr_status_macb322),
    .rstn_non_srpg_module22(rstn_non_srpg_macb3_int22),
    .gate_clk_module22(gate_clk_macb3_int22),
    .isolate_module22(isolate_macb3_int22),
    .save_edge22(save_edge_macb3_int22),
    .restore_edge22(restore_edge_macb3_int22),
    .pwr1_on22(pwr1_on_macb3_int22),
    .pwr2_on22(pwr2_on_macb3_int22)
    );
  // power22 control22 for dma22
  power_ctrl_sm22 i_dma_power_ctrl_sm22(
    .pclk22(pclk22),
    .nprst22(nprst22),
    .L1_module_req22(L1_ctrl_domain22[7]),
    .set_status_module22(set_status_dma22),
    .clr_status_module22(clr_status_dma22),
    .rstn_non_srpg_module22(rstn_non_srpg_dma_int22),
    .gate_clk_module22(gate_clk_dma_int22),
    .isolate_module22(isolate_dma_int22),
    .save_edge22(save_edge_dma_int22),
    .restore_edge22(restore_edge_dma_int22),
    .pwr1_on22(pwr1_on_dma_int22),
    .pwr2_on22(pwr2_on_dma_int22)
    );
  // power22 control22 for CPU22
  power_ctrl_sm22 i_cpu_power_ctrl_sm22(
    .pclk22(pclk22),
    .nprst22(nprst22),
    .L1_module_req22(cpu_shutoff_ctrl22),
    .set_status_module22(set_status_cpu22),
    .clr_status_module22(clr_status_cpu22),
    .rstn_non_srpg_module22(rstn_non_srpg_cpu_int22),
    .gate_clk_module22(gate_clk_cpu_int22),
    .isolate_module22(isolate_cpu_int22),
    .save_edge22(save_edge_cpu_int22),
    .restore_edge22(restore_edge_cpu_int22),
    .pwr1_on22(pwr1_on_cpu_int22),
    .pwr2_on22(pwr2_on_cpu_int22)
    );

  assign valid_reg_write22 =  (psel22 && pwrite22 && penable22);
  assign valid_reg_read22  =  (psel22 && (!pwrite22) && penable22);

  assign L1_ctrl_access22  =  (paddr22[15:0] == 16'b0000000000000100); 
  assign L1_status_access22 = (paddr22[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access22 =   (paddr22[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access22 = (paddr22[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control22 and status register
  always @(*)
  begin  
    if(valid_reg_read22 && L1_ctrl_access22) 
      prdata22 = L1_ctrl_reg22;
    else if (valid_reg_read22 && L1_status_access22)
      prdata22 = L1_status_reg22;
    else if (valid_reg_read22 && pcm_int_mask_access22)
      prdata22 = pcm_mask_reg22;
    else if (valid_reg_read22 && pcm_int_status_access22)
      prdata22 = pcm_status_reg22;
    else 
      prdata22 = 0;
  end

  assign set_status_mem22 =  (set_status_macb022 && set_status_macb122 && set_status_macb222 &&
                            set_status_macb322 && set_status_dma22 && set_status_cpu22);

  assign clr_status_mem22 =  (clr_status_macb022 && clr_status_macb122 && clr_status_macb222 &&
                            clr_status_macb322 && clr_status_dma22 && clr_status_cpu22);

  assign set_status_alut22 = (set_status_macb022 && set_status_macb122 && set_status_macb222 && set_status_macb322);

  assign clr_status_alut22 = (clr_status_macb022 || clr_status_macb122 || clr_status_macb222  || clr_status_macb322);

  // Write accesses to the control22 and status register
 
  always @(posedge pclk22 or negedge nprst22)
  begin
    if (!nprst22) begin
      L1_ctrl_reg22   <= 0;
      L1_status_reg22 <= 0;
      pcm_mask_reg22 <= 0;
    end else begin
      // CTRL22 reg updates22
      if (valid_reg_write22 && L1_ctrl_access22) 
        L1_ctrl_reg22 <= pwdata22; // Writes22 to the ctrl22 reg
      if (valid_reg_write22 && pcm_int_mask_access22) 
        pcm_mask_reg22 <= pwdata22; // Writes22 to the ctrl22 reg

      if (set_status_urt22 == 1'b1)  
        L1_status_reg22[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt22 == 1'b1) 
        L1_status_reg22[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc22 == 1'b1) 
        L1_status_reg22[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc22 == 1'b1) 
        L1_status_reg22[2] <= 1'b0; // Clear the status bit

      if (set_status_macb022 == 1'b1)  
        L1_status_reg22[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb022 == 1'b1) 
        L1_status_reg22[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb122 == 1'b1)  
        L1_status_reg22[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb122 == 1'b1) 
        L1_status_reg22[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb222 == 1'b1)  
        L1_status_reg22[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb222 == 1'b1) 
        L1_status_reg22[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb322 == 1'b1)  
        L1_status_reg22[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb322 == 1'b1) 
        L1_status_reg22[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma22 == 1'b1)  
        L1_status_reg22[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma22 == 1'b1) 
        L1_status_reg22[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu22 == 1'b1)  
        L1_status_reg22[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu22 == 1'b1) 
        L1_status_reg22[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut22 == 1'b1)  
        L1_status_reg22[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut22 == 1'b1) 
        L1_status_reg22[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem22 == 1'b1)  
        L1_status_reg22[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem22 == 1'b1) 
        L1_status_reg22[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused22 bits of pcm_status_reg22 are tied22 to 0
  always @(posedge pclk22 or negedge nprst22)
  begin
    if (!nprst22)
      pcm_status_reg22[31:4] <= 'b0;
    else  
      pcm_status_reg22[31:4] <= pcm_status_reg22[31:4];
  end
  
  // interrupt22 only of h/w assisted22 wakeup
  // MAC22 3
  always @(posedge pclk22 or negedge nprst22)
  begin
    if(!nprst22)
      pcm_status_reg22[3] <= 1'b0;
    else if (valid_reg_write22 && pcm_int_status_access22) 
      pcm_status_reg22[3] <= pwdata22[3];
    else if (macb3_wakeup22 & ~pcm_mask_reg22[3])
      pcm_status_reg22[3] <= 1'b1;
    else if (valid_reg_read22 && pcm_int_status_access22) 
      pcm_status_reg22[3] <= 1'b0;
    else
      pcm_status_reg22[3] <= pcm_status_reg22[3];
  end  
   
  // MAC22 2
  always @(posedge pclk22 or negedge nprst22)
  begin
    if(!nprst22)
      pcm_status_reg22[2] <= 1'b0;
    else if (valid_reg_write22 && pcm_int_status_access22) 
      pcm_status_reg22[2] <= pwdata22[2];
    else if (macb2_wakeup22 & ~pcm_mask_reg22[2])
      pcm_status_reg22[2] <= 1'b1;
    else if (valid_reg_read22 && pcm_int_status_access22) 
      pcm_status_reg22[2] <= 1'b0;
    else
      pcm_status_reg22[2] <= pcm_status_reg22[2];
  end  

  // MAC22 1
  always @(posedge pclk22 or negedge nprst22)
  begin
    if(!nprst22)
      pcm_status_reg22[1] <= 1'b0;
    else if (valid_reg_write22 && pcm_int_status_access22) 
      pcm_status_reg22[1] <= pwdata22[1];
    else if (macb1_wakeup22 & ~pcm_mask_reg22[1])
      pcm_status_reg22[1] <= 1'b1;
    else if (valid_reg_read22 && pcm_int_status_access22) 
      pcm_status_reg22[1] <= 1'b0;
    else
      pcm_status_reg22[1] <= pcm_status_reg22[1];
  end  
   
  // MAC22 0
  always @(posedge pclk22 or negedge nprst22)
  begin
    if(!nprst22)
      pcm_status_reg22[0] <= 1'b0;
    else if (valid_reg_write22 && pcm_int_status_access22) 
      pcm_status_reg22[0] <= pwdata22[0];
    else if (macb0_wakeup22 & ~pcm_mask_reg22[0])
      pcm_status_reg22[0] <= 1'b1;
    else if (valid_reg_read22 && pcm_int_status_access22) 
      pcm_status_reg22[0] <= 1'b0;
    else
      pcm_status_reg22[0] <= pcm_status_reg22[0];
  end  

  assign pcm_macb_wakeup_int22 = |pcm_status_reg22;

  reg [31:0] L1_ctrl_reg122;
  always @(posedge pclk22 or negedge nprst22)
  begin
    if(!nprst22)
      L1_ctrl_reg122 <= 0;
    else
      L1_ctrl_reg122 <= L1_ctrl_reg22;
  end

  // Program22 mode decode
  always @(L1_ctrl_reg22 or L1_ctrl_reg122 or int_source_h22 or cpu_shutoff_ctrl22) begin
    mte_smc_start22 = 0;
    mte_uart_start22 = 0;
    mte_smc_uart_start22  = 0;
    mte_mac_off_start22  = 0;
    mte_mac012_start22 = 0;
    mte_mac013_start22 = 0;
    mte_mac023_start22 = 0;
    mte_mac123_start22 = 0;
    mte_mac01_start22 = 0;
    mte_mac02_start22 = 0;
    mte_mac03_start22 = 0;
    mte_mac12_start22 = 0;
    mte_mac13_start22 = 0;
    mte_mac23_start22 = 0;
    mte_mac0_start22 = 0;
    mte_mac1_start22 = 0;
    mte_mac2_start22 = 0;
    mte_mac3_start22 = 0;
    mte_sys_hibernate22 = 0 ;
    mte_dma_start22 = 0 ;
    mte_cpu_start22 = 0 ;

    mte_mac0_sleep_start22 = (L1_ctrl_reg22 ==  'h14) && (L1_ctrl_reg122 == 'h4 );
    mte_mac1_sleep_start22 = (L1_ctrl_reg22 ==  'h14) && (L1_ctrl_reg122 == 'h5 ); 
    mte_mac2_sleep_start22 = (L1_ctrl_reg22 ==  'h14) && (L1_ctrl_reg122 == 'h6 ); 
    mte_mac3_sleep_start22 = (L1_ctrl_reg22 ==  'h14) && (L1_ctrl_reg122 == 'h7 ); 
    mte_mac01_sleep_start22 = (L1_ctrl_reg22 ==  'h14) && (L1_ctrl_reg122 == 'h8 ); 
    mte_mac02_sleep_start22 = (L1_ctrl_reg22 ==  'h14) && (L1_ctrl_reg122 == 'h9 ); 
    mte_mac03_sleep_start22 = (L1_ctrl_reg22 ==  'h14) && (L1_ctrl_reg122 == 'hA ); 
    mte_mac12_sleep_start22 = (L1_ctrl_reg22 ==  'h14) && (L1_ctrl_reg122 == 'hB ); 
    mte_mac13_sleep_start22 = (L1_ctrl_reg22 ==  'h14) && (L1_ctrl_reg122 == 'hC ); 
    mte_mac23_sleep_start22 = (L1_ctrl_reg22 ==  'h14) && (L1_ctrl_reg122 == 'hD ); 
    mte_mac012_sleep_start22 = (L1_ctrl_reg22 ==  'h14) && (L1_ctrl_reg122 == 'hE ); 
    mte_mac013_sleep_start22 = (L1_ctrl_reg22 ==  'h14) && (L1_ctrl_reg122 == 'hF ); 
    mte_mac023_sleep_start22 = (L1_ctrl_reg22 ==  'h14) && (L1_ctrl_reg122 == 'h10 ); 
    mte_mac123_sleep_start22 = (L1_ctrl_reg22 ==  'h14) && (L1_ctrl_reg122 == 'h11 ); 
    mte_mac_off_sleep_start22 =  (L1_ctrl_reg22 == 'h14) && (L1_ctrl_reg122 == 'h12 );
    mte_dma_sleep_start22 =  (L1_ctrl_reg22 == 'h14) && (L1_ctrl_reg122 == 'h13 );

    mte_pm_uart_to_default_start22 = (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'h1);
    mte_pm_smc_to_default_start22 = (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'h2);
    mte_pm_smc_uart_to_default_start22 = (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'h3); 
    mte_mac0_to_default22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'h4); 
    mte_mac1_to_default22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'h5); 
    mte_mac2_to_default22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'h6); 
    mte_mac3_to_default22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'h7); 
    mte_mac01_to_default22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'h8); 
    mte_mac02_to_default22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'h9); 
    mte_mac03_to_default22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'hA); 
    mte_mac12_to_default22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'hB); 
    mte_mac13_to_default22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'hC); 
    mte_mac23_to_default22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'hD); 
    mte_mac012_to_default22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'hE); 
    mte_mac013_to_default22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'hF); 
    mte_mac023_to_default22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'h10); 
    mte_mac123_to_default22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'h11); 
    mte_mac_off_to_default22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'h12); 
    mte_dma_isolate_dis22 =  (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'h13); 
    mte_cpu_isolate_dis22 =  (int_source_h22) && (cpu_shutoff_ctrl22) && (L1_ctrl_reg22 != 'h15);
    mte_sys_hibernate_to_default22 = (L1_ctrl_reg22 == 32'h0) && (L1_ctrl_reg122 == 'h15); 

   
    if (L1_ctrl_reg122 == 'h0) begin // This22 check is to make mte_cpu_start22
                                   // is set only when you from default state 
      case (L1_ctrl_reg22)
        'h0 : L1_ctrl_domain22 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain22 = 32'h2; // PM_uart22
                mte_uart_start22 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain22 = 32'h4; // PM_smc22
                mte_smc_start22 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain22 = 32'h6; // PM_smc_uart22
                mte_smc_uart_start22 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain22 = 32'h8; //  PM_macb022
                mte_mac0_start22 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain22 = 32'h10; //  PM_macb122
                mte_mac1_start22 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain22 = 32'h20; //  PM_macb222
                mte_mac2_start22 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain22 = 32'h40; //  PM_macb322
                mte_mac3_start22 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain22 = 32'h18; //  PM_macb0122
                mte_mac01_start22 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain22 = 32'h28; //  PM_macb0222
                mte_mac02_start22 = 1;
              end
        'hA : begin  
                L1_ctrl_domain22 = 32'h48; //  PM_macb0322
                mte_mac03_start22 = 1;
              end
        'hB : begin  
                L1_ctrl_domain22 = 32'h30; //  PM_macb1222
                mte_mac12_start22 = 1;
              end
        'hC : begin  
                L1_ctrl_domain22 = 32'h50; //  PM_macb1322
                mte_mac13_start22 = 1;
              end
        'hD : begin  
                L1_ctrl_domain22 = 32'h60; //  PM_macb2322
                mte_mac23_start22 = 1;
              end
        'hE : begin  
                L1_ctrl_domain22 = 32'h38; //  PM_macb01222
                mte_mac012_start22 = 1;
              end
        'hF : begin  
                L1_ctrl_domain22 = 32'h58; //  PM_macb01322
                mte_mac013_start22 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain22 = 32'h68; //  PM_macb02322
                mte_mac023_start22 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain22 = 32'h70; //  PM_macb12322
                mte_mac123_start22 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain22 = 32'h78; //  PM_macb_off22
                mte_mac_off_start22 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain22 = 32'h80; //  PM_dma22
                mte_dma_start22 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain22 = 32'h100; //  PM_cpu_sleep22
                mte_cpu_start22 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain22 = 32'h1FE; //  PM_hibernate22
                mte_sys_hibernate22 = 1;
              end
         default: L1_ctrl_domain22 = 32'h0;
      endcase
    end
  end


  wire to_default22 = (L1_ctrl_reg22 == 0);

  // Scan22 mode gating22 of power22 and isolation22 control22 signals22
  //SMC22
  assign rstn_non_srpg_smc22  = (scan_mode22 == 1'b0) ? rstn_non_srpg_smc_int22 : 1'b1;  
  assign gate_clk_smc22       = (scan_mode22 == 1'b0) ? gate_clk_smc_int22 : 1'b0;     
  assign isolate_smc22        = (scan_mode22 == 1'b0) ? isolate_smc_int22 : 1'b0;      
  assign pwr1_on_smc22        = (scan_mode22 == 1'b0) ? pwr1_on_smc_int22 : 1'b1;       
  assign pwr2_on_smc22        = (scan_mode22 == 1'b0) ? pwr2_on_smc_int22 : 1'b1;       
  assign pwr1_off_smc22       = (scan_mode22 == 1'b0) ? (!pwr1_on_smc_int22) : 1'b0;       
  assign pwr2_off_smc22       = (scan_mode22 == 1'b0) ? (!pwr2_on_smc_int22) : 1'b0;       
  assign save_edge_smc22       = (scan_mode22 == 1'b0) ? (save_edge_smc_int22) : 1'b0;       
  assign restore_edge_smc22       = (scan_mode22 == 1'b0) ? (restore_edge_smc_int22) : 1'b0;       

  //URT22
  assign rstn_non_srpg_urt22  = (scan_mode22 == 1'b0) ?  rstn_non_srpg_urt_int22 : 1'b1;  
  assign gate_clk_urt22       = (scan_mode22 == 1'b0) ?  gate_clk_urt_int22      : 1'b0;     
  assign isolate_urt22        = (scan_mode22 == 1'b0) ?  isolate_urt_int22       : 1'b0;      
  assign pwr1_on_urt22        = (scan_mode22 == 1'b0) ?  pwr1_on_urt_int22       : 1'b1;       
  assign pwr2_on_urt22        = (scan_mode22 == 1'b0) ?  pwr2_on_urt_int22       : 1'b1;       
  assign pwr1_off_urt22       = (scan_mode22 == 1'b0) ?  (!pwr1_on_urt_int22)  : 1'b0;       
  assign pwr2_off_urt22       = (scan_mode22 == 1'b0) ?  (!pwr2_on_urt_int22)  : 1'b0;       
  assign save_edge_urt22       = (scan_mode22 == 1'b0) ? (save_edge_urt_int22) : 1'b0;       
  assign restore_edge_urt22       = (scan_mode22 == 1'b0) ? (restore_edge_urt_int22) : 1'b0;       

  //ETH022
  assign rstn_non_srpg_macb022 = (scan_mode22 == 1'b0) ?  rstn_non_srpg_macb0_int22 : 1'b1;  
  assign gate_clk_macb022       = (scan_mode22 == 1'b0) ?  gate_clk_macb0_int22      : 1'b0;     
  assign isolate_macb022        = (scan_mode22 == 1'b0) ?  isolate_macb0_int22       : 1'b0;      
  assign pwr1_on_macb022        = (scan_mode22 == 1'b0) ?  pwr1_on_macb0_int22       : 1'b1;       
  assign pwr2_on_macb022        = (scan_mode22 == 1'b0) ?  pwr2_on_macb0_int22       : 1'b1;       
  assign pwr1_off_macb022       = (scan_mode22 == 1'b0) ?  (!pwr1_on_macb0_int22)  : 1'b0;       
  assign pwr2_off_macb022       = (scan_mode22 == 1'b0) ?  (!pwr2_on_macb0_int22)  : 1'b0;       
  assign save_edge_macb022       = (scan_mode22 == 1'b0) ? (save_edge_macb0_int22) : 1'b0;       
  assign restore_edge_macb022       = (scan_mode22 == 1'b0) ? (restore_edge_macb0_int22) : 1'b0;       

  //ETH122
  assign rstn_non_srpg_macb122 = (scan_mode22 == 1'b0) ?  rstn_non_srpg_macb1_int22 : 1'b1;  
  assign gate_clk_macb122       = (scan_mode22 == 1'b0) ?  gate_clk_macb1_int22      : 1'b0;     
  assign isolate_macb122        = (scan_mode22 == 1'b0) ?  isolate_macb1_int22       : 1'b0;      
  assign pwr1_on_macb122        = (scan_mode22 == 1'b0) ?  pwr1_on_macb1_int22       : 1'b1;       
  assign pwr2_on_macb122        = (scan_mode22 == 1'b0) ?  pwr2_on_macb1_int22       : 1'b1;       
  assign pwr1_off_macb122       = (scan_mode22 == 1'b0) ?  (!pwr1_on_macb1_int22)  : 1'b0;       
  assign pwr2_off_macb122       = (scan_mode22 == 1'b0) ?  (!pwr2_on_macb1_int22)  : 1'b0;       
  assign save_edge_macb122       = (scan_mode22 == 1'b0) ? (save_edge_macb1_int22) : 1'b0;       
  assign restore_edge_macb122       = (scan_mode22 == 1'b0) ? (restore_edge_macb1_int22) : 1'b0;       

  //ETH222
  assign rstn_non_srpg_macb222 = (scan_mode22 == 1'b0) ?  rstn_non_srpg_macb2_int22 : 1'b1;  
  assign gate_clk_macb222       = (scan_mode22 == 1'b0) ?  gate_clk_macb2_int22      : 1'b0;     
  assign isolate_macb222        = (scan_mode22 == 1'b0) ?  isolate_macb2_int22       : 1'b0;      
  assign pwr1_on_macb222        = (scan_mode22 == 1'b0) ?  pwr1_on_macb2_int22       : 1'b1;       
  assign pwr2_on_macb222        = (scan_mode22 == 1'b0) ?  pwr2_on_macb2_int22       : 1'b1;       
  assign pwr1_off_macb222       = (scan_mode22 == 1'b0) ?  (!pwr1_on_macb2_int22)  : 1'b0;       
  assign pwr2_off_macb222       = (scan_mode22 == 1'b0) ?  (!pwr2_on_macb2_int22)  : 1'b0;       
  assign save_edge_macb222       = (scan_mode22 == 1'b0) ? (save_edge_macb2_int22) : 1'b0;       
  assign restore_edge_macb222       = (scan_mode22 == 1'b0) ? (restore_edge_macb2_int22) : 1'b0;       

  //ETH322
  assign rstn_non_srpg_macb322 = (scan_mode22 == 1'b0) ?  rstn_non_srpg_macb3_int22 : 1'b1;  
  assign gate_clk_macb322       = (scan_mode22 == 1'b0) ?  gate_clk_macb3_int22      : 1'b0;     
  assign isolate_macb322        = (scan_mode22 == 1'b0) ?  isolate_macb3_int22       : 1'b0;      
  assign pwr1_on_macb322        = (scan_mode22 == 1'b0) ?  pwr1_on_macb3_int22       : 1'b1;       
  assign pwr2_on_macb322        = (scan_mode22 == 1'b0) ?  pwr2_on_macb3_int22       : 1'b1;       
  assign pwr1_off_macb322       = (scan_mode22 == 1'b0) ?  (!pwr1_on_macb3_int22)  : 1'b0;       
  assign pwr2_off_macb322       = (scan_mode22 == 1'b0) ?  (!pwr2_on_macb3_int22)  : 1'b0;       
  assign save_edge_macb322       = (scan_mode22 == 1'b0) ? (save_edge_macb3_int22) : 1'b0;       
  assign restore_edge_macb322       = (scan_mode22 == 1'b0) ? (restore_edge_macb3_int22) : 1'b0;       

  // MEM22
  assign rstn_non_srpg_mem22 =   (rstn_non_srpg_macb022 && rstn_non_srpg_macb122 && rstn_non_srpg_macb222 &&
                                rstn_non_srpg_macb322 && rstn_non_srpg_dma22 && rstn_non_srpg_cpu22 && rstn_non_srpg_urt22 &&
                                rstn_non_srpg_smc22);

  assign gate_clk_mem22 =  (gate_clk_macb022 && gate_clk_macb122 && gate_clk_macb222 &&
                            gate_clk_macb322 && gate_clk_dma22 && gate_clk_cpu22 && gate_clk_urt22 && gate_clk_smc22);

  assign isolate_mem22  = (isolate_macb022 && isolate_macb122 && isolate_macb222 &&
                         isolate_macb322 && isolate_dma22 && isolate_cpu22 && isolate_urt22 && isolate_smc22);


  assign pwr1_on_mem22        =   ~pwr1_off_mem22;

  assign pwr2_on_mem22        =   ~pwr2_off_mem22;

  assign pwr1_off_mem22       =  (pwr1_off_macb022 && pwr1_off_macb122 && pwr1_off_macb222 &&
                                 pwr1_off_macb322 && pwr1_off_dma22 && pwr1_off_cpu22 && pwr1_off_urt22 && pwr1_off_smc22);


  assign pwr2_off_mem22       =  (pwr2_off_macb022 && pwr2_off_macb122 && pwr2_off_macb222 &&
                                pwr2_off_macb322 && pwr2_off_dma22 && pwr2_off_cpu22 && pwr2_off_urt22 && pwr2_off_smc22);

  assign save_edge_mem22      =  (save_edge_macb022 && save_edge_macb122 && save_edge_macb222 &&
                                save_edge_macb322 && save_edge_dma22 && save_edge_cpu22 && save_edge_smc22 && save_edge_urt22);

  assign restore_edge_mem22   =  (restore_edge_macb022 && restore_edge_macb122 && restore_edge_macb222  &&
                                restore_edge_macb322 && restore_edge_dma22 && restore_edge_cpu22 && restore_edge_urt22 &&
                                restore_edge_smc22);

  assign standby_mem022 = pwr1_off_macb022 && (~ (pwr1_off_macb022 && pwr1_off_macb122 && pwr1_off_macb222 && pwr1_off_macb322 && pwr1_off_urt22 && pwr1_off_smc22 && pwr1_off_dma22 && pwr1_off_cpu22));
  assign standby_mem122 = pwr1_off_macb122 && (~ (pwr1_off_macb022 && pwr1_off_macb122 && pwr1_off_macb222 && pwr1_off_macb322 && pwr1_off_urt22 && pwr1_off_smc22 && pwr1_off_dma22 && pwr1_off_cpu22));
  assign standby_mem222 = pwr1_off_macb222 && (~ (pwr1_off_macb022 && pwr1_off_macb122 && pwr1_off_macb222 && pwr1_off_macb322 && pwr1_off_urt22 && pwr1_off_smc22 && pwr1_off_dma22 && pwr1_off_cpu22));
  assign standby_mem322 = pwr1_off_macb322 && (~ (pwr1_off_macb022 && pwr1_off_macb122 && pwr1_off_macb222 && pwr1_off_macb322 && pwr1_off_urt22 && pwr1_off_smc22 && pwr1_off_dma22 && pwr1_off_cpu22));

  assign pwr1_off_mem022 = pwr1_off_mem22;
  assign pwr1_off_mem122 = pwr1_off_mem22;
  assign pwr1_off_mem222 = pwr1_off_mem22;
  assign pwr1_off_mem322 = pwr1_off_mem22;

  assign rstn_non_srpg_alut22  =  (rstn_non_srpg_macb022 && rstn_non_srpg_macb122 && rstn_non_srpg_macb222 && rstn_non_srpg_macb322);


   assign gate_clk_alut22       =  (gate_clk_macb022 && gate_clk_macb122 && gate_clk_macb222 && gate_clk_macb322);


    assign isolate_alut22        =  (isolate_macb022 && isolate_macb122 && isolate_macb222 && isolate_macb322);


    assign pwr1_on_alut22        =  (pwr1_on_macb022 || pwr1_on_macb122 || pwr1_on_macb222 || pwr1_on_macb322);


    assign pwr2_on_alut22        =  (pwr2_on_macb022 || pwr2_on_macb122 || pwr2_on_macb222 || pwr2_on_macb322);


    assign pwr1_off_alut22       =  (pwr1_off_macb022 && pwr1_off_macb122 && pwr1_off_macb222 && pwr1_off_macb322);


    assign pwr2_off_alut22       =  (pwr2_off_macb022 && pwr2_off_macb122 && pwr2_off_macb222 && pwr2_off_macb322);


    assign save_edge_alut22      =  (save_edge_macb022 && save_edge_macb122 && save_edge_macb222 && save_edge_macb322);


    assign restore_edge_alut22   =  (restore_edge_macb022 || restore_edge_macb122 || restore_edge_macb222 ||
                                   restore_edge_macb322) && save_alut_tmp22;

     // alut22 power22 off22 detection22
  always @(posedge pclk22 or negedge nprst22) begin
    if (!nprst22) 
       save_alut_tmp22 <= 0;
    else if (restore_edge_alut22)
       save_alut_tmp22 <= 0;
    else if (save_edge_alut22)
       save_alut_tmp22 <= 1;
  end

  //DMA22
  assign rstn_non_srpg_dma22 = (scan_mode22 == 1'b0) ?  rstn_non_srpg_dma_int22 : 1'b1;  
  assign gate_clk_dma22       = (scan_mode22 == 1'b0) ?  gate_clk_dma_int22      : 1'b0;     
  assign isolate_dma22        = (scan_mode22 == 1'b0) ?  isolate_dma_int22       : 1'b0;      
  assign pwr1_on_dma22        = (scan_mode22 == 1'b0) ?  pwr1_on_dma_int22       : 1'b1;       
  assign pwr2_on_dma22        = (scan_mode22 == 1'b0) ?  pwr2_on_dma_int22       : 1'b1;       
  assign pwr1_off_dma22       = (scan_mode22 == 1'b0) ?  (!pwr1_on_dma_int22)  : 1'b0;       
  assign pwr2_off_dma22       = (scan_mode22 == 1'b0) ?  (!pwr2_on_dma_int22)  : 1'b0;       
  assign save_edge_dma22       = (scan_mode22 == 1'b0) ? (save_edge_dma_int22) : 1'b0;       
  assign restore_edge_dma22       = (scan_mode22 == 1'b0) ? (restore_edge_dma_int22) : 1'b0;       

  //CPU22
  assign rstn_non_srpg_cpu22 = (scan_mode22 == 1'b0) ?  rstn_non_srpg_cpu_int22 : 1'b1;  
  assign gate_clk_cpu22       = (scan_mode22 == 1'b0) ?  gate_clk_cpu_int22      : 1'b0;     
  assign isolate_cpu22        = (scan_mode22 == 1'b0) ?  isolate_cpu_int22       : 1'b0;      
  assign pwr1_on_cpu22        = (scan_mode22 == 1'b0) ?  pwr1_on_cpu_int22       : 1'b1;       
  assign pwr2_on_cpu22        = (scan_mode22 == 1'b0) ?  pwr2_on_cpu_int22       : 1'b1;       
  assign pwr1_off_cpu22       = (scan_mode22 == 1'b0) ?  (!pwr1_on_cpu_int22)  : 1'b0;       
  assign pwr2_off_cpu22       = (scan_mode22 == 1'b0) ?  (!pwr2_on_cpu_int22)  : 1'b0;       
  assign save_edge_cpu22       = (scan_mode22 == 1'b0) ? (save_edge_cpu_int22) : 1'b0;       
  assign restore_edge_cpu22       = (scan_mode22 == 1'b0) ? (restore_edge_cpu_int22) : 1'b0;       



  // ASE22

   reg ase_core_12v22, ase_core_10v22, ase_core_08v22, ase_core_06v22;
   reg ase_macb0_12v22,ase_macb1_12v22,ase_macb2_12v22,ase_macb3_12v22;

    // core22 ase22

    // core22 at 1.0 v if (smc22 off22, urt22 off22, macb022 off22, macb122 off22, macb222 off22, macb322 off22
   // core22 at 0.8v if (mac01off22, macb02off22, macb03off22, macb12off22, mac13off22, mac23off22,
   // core22 at 0.6v if (mac012off22, mac013off22, mac023off22, mac123off22, mac0123off22
    // else core22 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb022 && pwr1_off_macb122 && pwr1_off_macb222 && pwr1_off_macb322) || // all mac22 off22
       (pwr1_off_macb322 && pwr1_off_macb222 && pwr1_off_macb122) || // mac123off22 
       (pwr1_off_macb322 && pwr1_off_macb222 && pwr1_off_macb022) || // mac023off22 
       (pwr1_off_macb322 && pwr1_off_macb122 && pwr1_off_macb022) || // mac013off22 
       (pwr1_off_macb222 && pwr1_off_macb122 && pwr1_off_macb022) )  // mac012off22 
       begin
         ase_core_12v22 = 0;
         ase_core_10v22 = 0;
         ase_core_08v22 = 0;
         ase_core_06v22 = 1;
       end
     else if( (pwr1_off_macb222 && pwr1_off_macb322) || // mac2322 off22
         (pwr1_off_macb322 && pwr1_off_macb122) || // mac13off22 
         (pwr1_off_macb122 && pwr1_off_macb222) || // mac12off22 
         (pwr1_off_macb322 && pwr1_off_macb022) || // mac03off22 
         (pwr1_off_macb222 && pwr1_off_macb022) || // mac02off22 
         (pwr1_off_macb122 && pwr1_off_macb022))  // mac01off22 
       begin
         ase_core_12v22 = 0;
         ase_core_10v22 = 0;
         ase_core_08v22 = 1;
         ase_core_06v22 = 0;
       end
     else if( (pwr1_off_smc22) || // smc22 off22
         (pwr1_off_macb022 ) || // mac0off22 
         (pwr1_off_macb122 ) || // mac1off22 
         (pwr1_off_macb222 ) || // mac2off22 
         (pwr1_off_macb322 ))  // mac3off22 
       begin
         ase_core_12v22 = 0;
         ase_core_10v22 = 1;
         ase_core_08v22 = 0;
         ase_core_06v22 = 0;
       end
     else if (pwr1_off_urt22)
       begin
         ase_core_12v22 = 1;
         ase_core_10v22 = 0;
         ase_core_08v22 = 0;
         ase_core_06v22 = 0;
       end
     else
       begin
         ase_core_12v22 = 1;
         ase_core_10v22 = 0;
         ase_core_08v22 = 0;
         ase_core_06v22 = 0;
       end
   end


   // cpu22
   // cpu22 @ 1.0v when macoff22, 
   // 
   reg ase_cpu_10v22, ase_cpu_12v22;
   always @(*) begin
    if(pwr1_off_cpu22) begin
     ase_cpu_12v22 = 1'b0;
     ase_cpu_10v22 = 1'b0;
    end
    else if(pwr1_off_macb022 || pwr1_off_macb122 || pwr1_off_macb222 || pwr1_off_macb322)
    begin
     ase_cpu_12v22 = 1'b0;
     ase_cpu_10v22 = 1'b1;
    end
    else
    begin
     ase_cpu_12v22 = 1'b1;
     ase_cpu_10v22 = 1'b0;
    end
   end

   // dma22
   // dma22 @v122.0 for macoff22, 

   reg ase_dma_10v22, ase_dma_12v22;
   always @(*) begin
    if(pwr1_off_dma22) begin
     ase_dma_12v22 = 1'b0;
     ase_dma_10v22 = 1'b0;
    end
    else if(pwr1_off_macb022 || pwr1_off_macb122 || pwr1_off_macb222 || pwr1_off_macb322)
    begin
     ase_dma_12v22 = 1'b0;
     ase_dma_10v22 = 1'b1;
    end
    else
    begin
     ase_dma_12v22 = 1'b1;
     ase_dma_10v22 = 1'b0;
    end
   end

   // alut22
   // @ v122.0 for macoff22

   reg ase_alut_10v22, ase_alut_12v22;
   always @(*) begin
    if(pwr1_off_alut22) begin
     ase_alut_12v22 = 1'b0;
     ase_alut_10v22 = 1'b0;
    end
    else if(pwr1_off_macb022 || pwr1_off_macb122 || pwr1_off_macb222 || pwr1_off_macb322)
    begin
     ase_alut_12v22 = 1'b0;
     ase_alut_10v22 = 1'b1;
    end
    else
    begin
     ase_alut_12v22 = 1'b1;
     ase_alut_10v22 = 1'b0;
    end
   end




   reg ase_uart_12v22;
   reg ase_uart_10v22;
   reg ase_uart_08v22;
   reg ase_uart_06v22;

   reg ase_smc_12v22;


   always @(*) begin
     if(pwr1_off_urt22) begin // uart22 off22
       ase_uart_08v22 = 1'b0;
       ase_uart_06v22 = 1'b0;
       ase_uart_10v22 = 1'b0;
       ase_uart_12v22 = 1'b0;
     end 
     else if( (pwr1_off_macb022 && pwr1_off_macb122 && pwr1_off_macb222 && pwr1_off_macb322) || // all mac22 off22
       (pwr1_off_macb322 && pwr1_off_macb222 && pwr1_off_macb122) || // mac123off22 
       (pwr1_off_macb322 && pwr1_off_macb222 && pwr1_off_macb022) || // mac023off22 
       (pwr1_off_macb322 && pwr1_off_macb122 && pwr1_off_macb022) || // mac013off22 
       (pwr1_off_macb222 && pwr1_off_macb122 && pwr1_off_macb022) )  // mac012off22 
     begin
       ase_uart_06v22 = 1'b1;
       ase_uart_08v22 = 1'b0;
       ase_uart_10v22 = 1'b0;
       ase_uart_12v22 = 1'b0;
     end
     else if( (pwr1_off_macb222 && pwr1_off_macb322) || // mac2322 off22
         (pwr1_off_macb322 && pwr1_off_macb122) || // mac13off22 
         (pwr1_off_macb122 && pwr1_off_macb222) || // mac12off22 
         (pwr1_off_macb322 && pwr1_off_macb022) || // mac03off22 
         (pwr1_off_macb122 && pwr1_off_macb022))  // mac01off22  
     begin
       ase_uart_06v22 = 1'b0;
       ase_uart_08v22 = 1'b1;
       ase_uart_10v22 = 1'b0;
       ase_uart_12v22 = 1'b0;
     end
     else if (pwr1_off_smc22 || pwr1_off_macb022 || pwr1_off_macb122 || pwr1_off_macb222 || pwr1_off_macb322) begin // smc22 off22
       ase_uart_08v22 = 1'b0;
       ase_uart_06v22 = 1'b0;
       ase_uart_10v22 = 1'b1;
       ase_uart_12v22 = 1'b0;
     end 
     else begin
       ase_uart_08v22 = 1'b0;
       ase_uart_06v22 = 1'b0;
       ase_uart_10v22 = 1'b0;
       ase_uart_12v22 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc22) begin
     if (pwr1_off_smc22)  // smc22 off22
       ase_smc_12v22 = 1'b0;
    else
       ase_smc_12v22 = 1'b1;
   end

   
   always @(pwr1_off_macb022) begin
     if (pwr1_off_macb022) // macb022 off22
       ase_macb0_12v22 = 1'b0;
     else
       ase_macb0_12v22 = 1'b1;
   end

   always @(pwr1_off_macb122) begin
     if (pwr1_off_macb122) // macb122 off22
       ase_macb1_12v22 = 1'b0;
     else
       ase_macb1_12v22 = 1'b1;
   end

   always @(pwr1_off_macb222) begin // macb222 off22
     if (pwr1_off_macb222) // macb222 off22
       ase_macb2_12v22 = 1'b0;
     else
       ase_macb2_12v22 = 1'b1;
   end

   always @(pwr1_off_macb322) begin // macb322 off22
     if (pwr1_off_macb322) // macb322 off22
       ase_macb3_12v22 = 1'b0;
     else
       ase_macb3_12v22 = 1'b1;
   end


   // core22 voltage22 for vco22
  assign core12v22 = ase_macb0_12v22 & ase_macb1_12v22 & ase_macb2_12v22 & ase_macb3_12v22;

  assign core10v22 =  (ase_macb0_12v22 & ase_macb1_12v22 & ase_macb2_12v22 & (!ase_macb3_12v22)) ||
                    (ase_macb0_12v22 & ase_macb1_12v22 & (!ase_macb2_12v22) & ase_macb3_12v22) ||
                    (ase_macb0_12v22 & (!ase_macb1_12v22) & ase_macb2_12v22 & ase_macb3_12v22) ||
                    ((!ase_macb0_12v22) & ase_macb1_12v22 & ase_macb2_12v22 & ase_macb3_12v22);

  assign core08v22 =  ((!ase_macb0_12v22) & (!ase_macb1_12v22) & (ase_macb2_12v22) & (ase_macb3_12v22)) ||
                    ((!ase_macb0_12v22) & (ase_macb1_12v22) & (!ase_macb2_12v22) & (ase_macb3_12v22)) ||
                    ((!ase_macb0_12v22) & (ase_macb1_12v22) & (ase_macb2_12v22) & (!ase_macb3_12v22)) ||
                    ((ase_macb0_12v22) & (!ase_macb1_12v22) & (!ase_macb2_12v22) & (ase_macb3_12v22)) ||
                    ((ase_macb0_12v22) & (!ase_macb1_12v22) & (ase_macb2_12v22) & (!ase_macb3_12v22)) ||
                    ((ase_macb0_12v22) & (ase_macb1_12v22) & (!ase_macb2_12v22) & (!ase_macb3_12v22));

  assign core06v22 =  ((!ase_macb0_12v22) & (!ase_macb1_12v22) & (!ase_macb2_12v22) & (ase_macb3_12v22)) ||
                    ((!ase_macb0_12v22) & (!ase_macb1_12v22) & (ase_macb2_12v22) & (!ase_macb3_12v22)) ||
                    ((!ase_macb0_12v22) & (ase_macb1_12v22) & (!ase_macb2_12v22) & (!ase_macb3_12v22)) ||
                    ((ase_macb0_12v22) & (!ase_macb1_12v22) & (!ase_macb2_12v22) & (!ase_macb3_12v22)) ||
                    ((!ase_macb0_12v22) & (!ase_macb1_12v22) & (!ase_macb2_12v22) & (!ase_macb3_12v22)) ;



`ifdef LP_ABV_ON22
// psl22 default clock22 = (posedge pclk22);

// Cover22 a condition in which SMC22 is powered22 down
// and again22 powered22 up while UART22 is going22 into POWER22 down
// state or UART22 is already in POWER22 DOWN22 state
// psl22 cover_overlapping_smc_urt_122:
//    cover{fell22(pwr1_on_urt22);[*];fell22(pwr1_on_smc22);[*];
//    rose22(pwr1_on_smc22);[*];rose22(pwr1_on_urt22)};
//
// Cover22 a condition in which UART22 is powered22 down
// and again22 powered22 up while SMC22 is going22 into POWER22 down
// state or SMC22 is already in POWER22 DOWN22 state
// psl22 cover_overlapping_smc_urt_222:
//    cover{fell22(pwr1_on_smc22);[*];fell22(pwr1_on_urt22);[*];
//    rose22(pwr1_on_urt22);[*];rose22(pwr1_on_smc22)};
//


// Power22 Down22 UART22
// This22 gets22 triggered on rising22 edge of Gate22 signal22 for
// UART22 (gate_clk_urt22). In a next cycle after gate_clk_urt22,
// Isolate22 UART22(isolate_urt22) signal22 become22 HIGH22 (active).
// In 2nd cycle after gate_clk_urt22 becomes HIGH22, RESET22 for NON22
// SRPG22 FFs22(rstn_non_srpg_urt22) and POWER122 for UART22(pwr1_on_urt22) should 
// go22 LOW22. 
// This22 completes22 a POWER22 DOWN22. 

sequence s_power_down_urt22;
      (gate_clk_urt22 & !isolate_urt22 & rstn_non_srpg_urt22 & pwr1_on_urt22) 
  ##1 (gate_clk_urt22 & isolate_urt22 & rstn_non_srpg_urt22 & pwr1_on_urt22) 
  ##3 (gate_clk_urt22 & isolate_urt22 & !rstn_non_srpg_urt22 & !pwr1_on_urt22);
endsequence


property p_power_down_urt22;
   @(posedge pclk22)
    $rose(gate_clk_urt22) |=> s_power_down_urt22;
endproperty

output_power_down_urt22:
  assert property (p_power_down_urt22);


// Power22 UP22 UART22
// Sequence starts with , Rising22 edge of pwr1_on_urt22.
// Two22 clock22 cycle after this, isolate_urt22 should become22 LOW22 
// On22 the following22 clk22 gate_clk_urt22 should go22 low22.
// 5 cycles22 after  Rising22 edge of pwr1_on_urt22, rstn_non_srpg_urt22
// should become22 HIGH22
sequence s_power_up_urt22;
##30 (pwr1_on_urt22 & !isolate_urt22 & gate_clk_urt22 & !rstn_non_srpg_urt22) 
##1 (pwr1_on_urt22 & !isolate_urt22 & !gate_clk_urt22 & !rstn_non_srpg_urt22) 
##2 (pwr1_on_urt22 & !isolate_urt22 & !gate_clk_urt22 & rstn_non_srpg_urt22);
endsequence

property p_power_up_urt22;
   @(posedge pclk22)
  disable iff(!nprst22)
    (!pwr1_on_urt22 ##1 pwr1_on_urt22) |=> s_power_up_urt22;
endproperty

output_power_up_urt22:
  assert property (p_power_up_urt22);


// Power22 Down22 SMC22
// This22 gets22 triggered on rising22 edge of Gate22 signal22 for
// SMC22 (gate_clk_smc22). In a next cycle after gate_clk_smc22,
// Isolate22 SMC22(isolate_smc22) signal22 become22 HIGH22 (active).
// In 2nd cycle after gate_clk_smc22 becomes HIGH22, RESET22 for NON22
// SRPG22 FFs22(rstn_non_srpg_smc22) and POWER122 for SMC22(pwr1_on_smc22) should 
// go22 LOW22. 
// This22 completes22 a POWER22 DOWN22. 

sequence s_power_down_smc22;
      (gate_clk_smc22 & !isolate_smc22 & rstn_non_srpg_smc22 & pwr1_on_smc22) 
  ##1 (gate_clk_smc22 & isolate_smc22 & rstn_non_srpg_smc22 & pwr1_on_smc22) 
  ##3 (gate_clk_smc22 & isolate_smc22 & !rstn_non_srpg_smc22 & !pwr1_on_smc22);
endsequence


property p_power_down_smc22;
   @(posedge pclk22)
    $rose(gate_clk_smc22) |=> s_power_down_smc22;
endproperty

output_power_down_smc22:
  assert property (p_power_down_smc22);


// Power22 UP22 SMC22
// Sequence starts with , Rising22 edge of pwr1_on_smc22.
// Two22 clock22 cycle after this, isolate_smc22 should become22 LOW22 
// On22 the following22 clk22 gate_clk_smc22 should go22 low22.
// 5 cycles22 after  Rising22 edge of pwr1_on_smc22, rstn_non_srpg_smc22
// should become22 HIGH22
sequence s_power_up_smc22;
##30 (pwr1_on_smc22 & !isolate_smc22 & gate_clk_smc22 & !rstn_non_srpg_smc22) 
##1 (pwr1_on_smc22 & !isolate_smc22 & !gate_clk_smc22 & !rstn_non_srpg_smc22) 
##2 (pwr1_on_smc22 & !isolate_smc22 & !gate_clk_smc22 & rstn_non_srpg_smc22);
endsequence

property p_power_up_smc22;
   @(posedge pclk22)
  disable iff(!nprst22)
    (!pwr1_on_smc22 ##1 pwr1_on_smc22) |=> s_power_up_smc22;
endproperty

output_power_up_smc22:
  assert property (p_power_up_smc22);


// COVER22 SMC22 POWER22 DOWN22 AND22 UP22
cover_power_down_up_smc22: cover property (@(posedge pclk22)
(s_power_down_smc22 ##[5:180] s_power_up_smc22));



// COVER22 UART22 POWER22 DOWN22 AND22 UP22
cover_power_down_up_urt22: cover property (@(posedge pclk22)
(s_power_down_urt22 ##[5:180] s_power_up_urt22));

cover_power_down_urt22: cover property (@(posedge pclk22)
(s_power_down_urt22));

cover_power_up_urt22: cover property (@(posedge pclk22)
(s_power_up_urt22));




`ifdef PCM_ABV_ON22
//------------------------------------------------------------------------------
// Power22 Controller22 Formal22 Verification22 component.  Each power22 domain has a 
// separate22 instantiation22
//------------------------------------------------------------------------------

// need to assume that CPU22 will leave22 a minimum time between powering22 down and 
// back up.  In this example22, 10clks has been selected.
// psl22 config_min_uart_pd_time22 : assume always {rose22(L1_ctrl_domain22[1])} |-> { L1_ctrl_domain22[1][*10] } abort22(~nprst22);
// psl22 config_min_uart_pu_time22 : assume always {fell22(L1_ctrl_domain22[1])} |-> { !L1_ctrl_domain22[1][*10] } abort22(~nprst22);
// psl22 config_min_smc_pd_time22 : assume always {rose22(L1_ctrl_domain22[2])} |-> { L1_ctrl_domain22[2][*10] } abort22(~nprst22);
// psl22 config_min_smc_pu_time22 : assume always {fell22(L1_ctrl_domain22[2])} |-> { !L1_ctrl_domain22[2][*10] } abort22(~nprst22);

// UART22 VCOMP22 parameters22
   defparam i_uart_vcomp_domain22.ENABLE_SAVE_RESTORE_EDGE22   = 1;
   defparam i_uart_vcomp_domain22.ENABLE_EXT_PWR_CNTRL22       = 1;
   defparam i_uart_vcomp_domain22.REF_CLK_DEFINED22            = 0;
   defparam i_uart_vcomp_domain22.MIN_SHUTOFF_CYCLES22         = 4;
   defparam i_uart_vcomp_domain22.MIN_RESTORE_TO_ISO_CYCLES22  = 0;
   defparam i_uart_vcomp_domain22.MIN_SAVE_TO_SHUTOFF_CYCLES22 = 1;


   vcomp_domain22 i_uart_vcomp_domain22
   ( .ref_clk22(pclk22),
     .start_lps22(L1_ctrl_domain22[1] || !rstn_non_srpg_urt22),
     .rst_n22(nprst22),
     .ext_power_down22(L1_ctrl_domain22[1]),
     .iso_en22(isolate_urt22),
     .save_edge22(save_edge_urt22),
     .restore_edge22(restore_edge_urt22),
     .domain_shut_off22(pwr1_off_urt22),
     .domain_clk22(!gate_clk_urt22 && pclk22)
   );


// SMC22 VCOMP22 parameters22
   defparam i_smc_vcomp_domain22.ENABLE_SAVE_RESTORE_EDGE22   = 1;
   defparam i_smc_vcomp_domain22.ENABLE_EXT_PWR_CNTRL22       = 1;
   defparam i_smc_vcomp_domain22.REF_CLK_DEFINED22            = 0;
   defparam i_smc_vcomp_domain22.MIN_SHUTOFF_CYCLES22         = 4;
   defparam i_smc_vcomp_domain22.MIN_RESTORE_TO_ISO_CYCLES22  = 0;
   defparam i_smc_vcomp_domain22.MIN_SAVE_TO_SHUTOFF_CYCLES22 = 1;


   vcomp_domain22 i_smc_vcomp_domain22
   ( .ref_clk22(pclk22),
     .start_lps22(L1_ctrl_domain22[2] || !rstn_non_srpg_smc22),
     .rst_n22(nprst22),
     .ext_power_down22(L1_ctrl_domain22[2]),
     .iso_en22(isolate_smc22),
     .save_edge22(save_edge_smc22),
     .restore_edge22(restore_edge_smc22),
     .domain_shut_off22(pwr1_off_smc22),
     .domain_clk22(!gate_clk_smc22 && pclk22)
   );

`endif

`endif



endmodule
