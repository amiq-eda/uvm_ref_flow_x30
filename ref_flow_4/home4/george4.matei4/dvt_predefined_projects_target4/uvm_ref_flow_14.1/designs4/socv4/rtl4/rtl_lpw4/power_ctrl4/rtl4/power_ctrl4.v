//File4 name   : power_ctrl4.v
//Title4       : Power4 Control4 Module4
//Created4     : 1999
//Description4 : Top4 level of power4 controller4
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

module power_ctrl4 (


    // Clocks4 & Reset4
    pclk4,
    nprst4,
    // APB4 programming4 interface
    paddr4,
    psel4,
    penable4,
    pwrite4,
    pwdata4,
    prdata4,
    // mac4 i/f,
    macb3_wakeup4,
    macb2_wakeup4,
    macb1_wakeup4,
    macb0_wakeup4,
    // Scan4 
    scan_in4,
    scan_en4,
    scan_mode4,
    scan_out4,
    // Module4 control4 outputs4
    int_source_h4,
    // SMC4
    rstn_non_srpg_smc4,
    gate_clk_smc4,
    isolate_smc4,
    save_edge_smc4,
    restore_edge_smc4,
    pwr1_on_smc4,
    pwr2_on_smc4,
    pwr1_off_smc4,
    pwr2_off_smc4,
    // URT4
    rstn_non_srpg_urt4,
    gate_clk_urt4,
    isolate_urt4,
    save_edge_urt4,
    restore_edge_urt4,
    pwr1_on_urt4,
    pwr2_on_urt4,
    pwr1_off_urt4,      
    pwr2_off_urt4,
    // ETH04
    rstn_non_srpg_macb04,
    gate_clk_macb04,
    isolate_macb04,
    save_edge_macb04,
    restore_edge_macb04,
    pwr1_on_macb04,
    pwr2_on_macb04,
    pwr1_off_macb04,      
    pwr2_off_macb04,
    // ETH14
    rstn_non_srpg_macb14,
    gate_clk_macb14,
    isolate_macb14,
    save_edge_macb14,
    restore_edge_macb14,
    pwr1_on_macb14,
    pwr2_on_macb14,
    pwr1_off_macb14,      
    pwr2_off_macb14,
    // ETH24
    rstn_non_srpg_macb24,
    gate_clk_macb24,
    isolate_macb24,
    save_edge_macb24,
    restore_edge_macb24,
    pwr1_on_macb24,
    pwr2_on_macb24,
    pwr1_off_macb24,      
    pwr2_off_macb24,
    // ETH34
    rstn_non_srpg_macb34,
    gate_clk_macb34,
    isolate_macb34,
    save_edge_macb34,
    restore_edge_macb34,
    pwr1_on_macb34,
    pwr2_on_macb34,
    pwr1_off_macb34,      
    pwr2_off_macb34,
    // DMA4
    rstn_non_srpg_dma4,
    gate_clk_dma4,
    isolate_dma4,
    save_edge_dma4,
    restore_edge_dma4,
    pwr1_on_dma4,
    pwr2_on_dma4,
    pwr1_off_dma4,      
    pwr2_off_dma4,
    // CPU4
    rstn_non_srpg_cpu4,
    gate_clk_cpu4,
    isolate_cpu4,
    save_edge_cpu4,
    restore_edge_cpu4,
    pwr1_on_cpu4,
    pwr2_on_cpu4,
    pwr1_off_cpu4,      
    pwr2_off_cpu4,
    // ALUT4
    rstn_non_srpg_alut4,
    gate_clk_alut4,
    isolate_alut4,
    save_edge_alut4,
    restore_edge_alut4,
    pwr1_on_alut4,
    pwr2_on_alut4,
    pwr1_off_alut4,      
    pwr2_off_alut4,
    // MEM4
    rstn_non_srpg_mem4,
    gate_clk_mem4,
    isolate_mem4,
    save_edge_mem4,
    restore_edge_mem4,
    pwr1_on_mem4,
    pwr2_on_mem4,
    pwr1_off_mem4,      
    pwr2_off_mem4,
    // core4 dvfs4 transitions4
    core06v4,
    core08v4,
    core10v4,
    core12v4,
    pcm_macb_wakeup_int4,
    // mte4 signals4
    mte_smc_start4,
    mte_uart_start4,
    mte_smc_uart_start4,  
    mte_pm_smc_to_default_start4, 
    mte_pm_uart_to_default_start4,
    mte_pm_smc_uart_to_default_start4

  );

  parameter STATE_IDLE_12V4 = 4'b0001;
  parameter STATE_06V4 = 4'b0010;
  parameter STATE_08V4 = 4'b0100;
  parameter STATE_10V4 = 4'b1000;

    // Clocks4 & Reset4
    input pclk4;
    input nprst4;
    // APB4 programming4 interface
    input [31:0] paddr4;
    input psel4  ;
    input penable4;
    input pwrite4 ;
    input [31:0] pwdata4;
    output [31:0] prdata4;
    // mac4
    input macb3_wakeup4;
    input macb2_wakeup4;
    input macb1_wakeup4;
    input macb0_wakeup4;
    // Scan4 
    input scan_in4;
    input scan_en4;
    input scan_mode4;
    output scan_out4;
    // Module4 control4 outputs4
    input int_source_h4;
    // SMC4
    output rstn_non_srpg_smc4 ;
    output gate_clk_smc4   ;
    output isolate_smc4   ;
    output save_edge_smc4   ;
    output restore_edge_smc4   ;
    output pwr1_on_smc4   ;
    output pwr2_on_smc4   ;
    output pwr1_off_smc4  ;
    output pwr2_off_smc4  ;
    // URT4
    output rstn_non_srpg_urt4 ;
    output gate_clk_urt4      ;
    output isolate_urt4       ;
    output save_edge_urt4   ;
    output restore_edge_urt4   ;
    output pwr1_on_urt4       ;
    output pwr2_on_urt4       ;
    output pwr1_off_urt4      ;
    output pwr2_off_urt4      ;
    // ETH04
    output rstn_non_srpg_macb04 ;
    output gate_clk_macb04      ;
    output isolate_macb04       ;
    output save_edge_macb04   ;
    output restore_edge_macb04   ;
    output pwr1_on_macb04       ;
    output pwr2_on_macb04       ;
    output pwr1_off_macb04      ;
    output pwr2_off_macb04      ;
    // ETH14
    output rstn_non_srpg_macb14 ;
    output gate_clk_macb14      ;
    output isolate_macb14       ;
    output save_edge_macb14   ;
    output restore_edge_macb14   ;
    output pwr1_on_macb14       ;
    output pwr2_on_macb14       ;
    output pwr1_off_macb14      ;
    output pwr2_off_macb14      ;
    // ETH24
    output rstn_non_srpg_macb24 ;
    output gate_clk_macb24      ;
    output isolate_macb24       ;
    output save_edge_macb24   ;
    output restore_edge_macb24   ;
    output pwr1_on_macb24       ;
    output pwr2_on_macb24       ;
    output pwr1_off_macb24      ;
    output pwr2_off_macb24      ;
    // ETH34
    output rstn_non_srpg_macb34 ;
    output gate_clk_macb34      ;
    output isolate_macb34       ;
    output save_edge_macb34   ;
    output restore_edge_macb34   ;
    output pwr1_on_macb34       ;
    output pwr2_on_macb34       ;
    output pwr1_off_macb34      ;
    output pwr2_off_macb34      ;
    // DMA4
    output rstn_non_srpg_dma4 ;
    output gate_clk_dma4      ;
    output isolate_dma4       ;
    output save_edge_dma4   ;
    output restore_edge_dma4   ;
    output pwr1_on_dma4       ;
    output pwr2_on_dma4       ;
    output pwr1_off_dma4      ;
    output pwr2_off_dma4      ;
    // CPU4
    output rstn_non_srpg_cpu4 ;
    output gate_clk_cpu4      ;
    output isolate_cpu4       ;
    output save_edge_cpu4   ;
    output restore_edge_cpu4   ;
    output pwr1_on_cpu4       ;
    output pwr2_on_cpu4       ;
    output pwr1_off_cpu4      ;
    output pwr2_off_cpu4      ;
    // ALUT4
    output rstn_non_srpg_alut4 ;
    output gate_clk_alut4      ;
    output isolate_alut4       ;
    output save_edge_alut4   ;
    output restore_edge_alut4   ;
    output pwr1_on_alut4       ;
    output pwr2_on_alut4       ;
    output pwr1_off_alut4      ;
    output pwr2_off_alut4      ;
    // MEM4
    output rstn_non_srpg_mem4 ;
    output gate_clk_mem4      ;
    output isolate_mem4       ;
    output save_edge_mem4   ;
    output restore_edge_mem4   ;
    output pwr1_on_mem4       ;
    output pwr2_on_mem4       ;
    output pwr1_off_mem4      ;
    output pwr2_off_mem4      ;


   // core4 transitions4 o/p
    output core06v4;
    output core08v4;
    output core10v4;
    output core12v4;
    output pcm_macb_wakeup_int4 ;
    //mode mte4  signals4
    output mte_smc_start4;
    output mte_uart_start4;
    output mte_smc_uart_start4;  
    output mte_pm_smc_to_default_start4; 
    output mte_pm_uart_to_default_start4;
    output mte_pm_smc_uart_to_default_start4;

    reg mte_smc_start4;
    reg mte_uart_start4;
    reg mte_smc_uart_start4;  
    reg mte_pm_smc_to_default_start4; 
    reg mte_pm_uart_to_default_start4;
    reg mte_pm_smc_uart_to_default_start4;

    reg [31:0] prdata4;

  wire valid_reg_write4  ;
  wire valid_reg_read4   ;
  wire L1_ctrl_access4   ;
  wire L1_status_access4 ;
  wire pcm_int_mask_access4;
  wire pcm_int_status_access4;
  wire standby_mem04      ;
  wire standby_mem14      ;
  wire standby_mem24      ;
  wire standby_mem34      ;
  wire pwr1_off_mem04;
  wire pwr1_off_mem14;
  wire pwr1_off_mem24;
  wire pwr1_off_mem34;
  
  // Control4 signals4
  wire set_status_smc4   ;
  wire clr_status_smc4   ;
  wire set_status_urt4   ;
  wire clr_status_urt4   ;
  wire set_status_macb04   ;
  wire clr_status_macb04   ;
  wire set_status_macb14   ;
  wire clr_status_macb14   ;
  wire set_status_macb24   ;
  wire clr_status_macb24   ;
  wire set_status_macb34   ;
  wire clr_status_macb34   ;
  wire set_status_dma4   ;
  wire clr_status_dma4   ;
  wire set_status_cpu4   ;
  wire clr_status_cpu4   ;
  wire set_status_alut4   ;
  wire clr_status_alut4   ;
  wire set_status_mem4   ;
  wire clr_status_mem4   ;


  // Status and Control4 registers
  reg [31:0]  L1_status_reg4;
  reg  [31:0] L1_ctrl_reg4  ;
  reg  [31:0] L1_ctrl_domain4  ;
  reg L1_ctrl_cpu_off_reg4;
  reg [31:0]  pcm_mask_reg4;
  reg [31:0]  pcm_status_reg4;

  // Signals4 gated4 in scan_mode4
  //SMC4
  wire  rstn_non_srpg_smc_int4;
  wire  gate_clk_smc_int4    ;     
  wire  isolate_smc_int4    ;       
  wire save_edge_smc_int4;
  wire restore_edge_smc_int4;
  wire  pwr1_on_smc_int4    ;      
  wire  pwr2_on_smc_int4    ;      


  //URT4
  wire   rstn_non_srpg_urt_int4;
  wire   gate_clk_urt_int4     ;     
  wire   isolate_urt_int4      ;       
  wire save_edge_urt_int4;
  wire restore_edge_urt_int4;
  wire   pwr1_on_urt_int4      ;      
  wire   pwr2_on_urt_int4      ;      

  // ETH04
  wire   rstn_non_srpg_macb0_int4;
  wire   gate_clk_macb0_int4     ;     
  wire   isolate_macb0_int4      ;       
  wire save_edge_macb0_int4;
  wire restore_edge_macb0_int4;
  wire   pwr1_on_macb0_int4      ;      
  wire   pwr2_on_macb0_int4      ;      
  // ETH14
  wire   rstn_non_srpg_macb1_int4;
  wire   gate_clk_macb1_int4     ;     
  wire   isolate_macb1_int4      ;       
  wire save_edge_macb1_int4;
  wire restore_edge_macb1_int4;
  wire   pwr1_on_macb1_int4      ;      
  wire   pwr2_on_macb1_int4      ;      
  // ETH24
  wire   rstn_non_srpg_macb2_int4;
  wire   gate_clk_macb2_int4     ;     
  wire   isolate_macb2_int4      ;       
  wire save_edge_macb2_int4;
  wire restore_edge_macb2_int4;
  wire   pwr1_on_macb2_int4      ;      
  wire   pwr2_on_macb2_int4      ;      
  // ETH34
  wire   rstn_non_srpg_macb3_int4;
  wire   gate_clk_macb3_int4     ;     
  wire   isolate_macb3_int4      ;       
  wire save_edge_macb3_int4;
  wire restore_edge_macb3_int4;
  wire   pwr1_on_macb3_int4      ;      
  wire   pwr2_on_macb3_int4      ;      

  // DMA4
  wire   rstn_non_srpg_dma_int4;
  wire   gate_clk_dma_int4     ;     
  wire   isolate_dma_int4      ;       
  wire save_edge_dma_int4;
  wire restore_edge_dma_int4;
  wire   pwr1_on_dma_int4      ;      
  wire   pwr2_on_dma_int4      ;      

  // CPU4
  wire   rstn_non_srpg_cpu_int4;
  wire   gate_clk_cpu_int4     ;     
  wire   isolate_cpu_int4      ;       
  wire save_edge_cpu_int4;
  wire restore_edge_cpu_int4;
  wire   pwr1_on_cpu_int4      ;      
  wire   pwr2_on_cpu_int4      ;  
  wire L1_ctrl_cpu_off_p4;    

  reg save_alut_tmp4;
  // DFS4 sm4

  reg cpu_shutoff_ctrl4;

  reg mte_mac_off_start4, mte_mac012_start4, mte_mac013_start4, mte_mac023_start4, mte_mac123_start4;
  reg mte_mac01_start4, mte_mac02_start4, mte_mac03_start4, mte_mac12_start4, mte_mac13_start4, mte_mac23_start4;
  reg mte_mac0_start4, mte_mac1_start4, mte_mac2_start4, mte_mac3_start4;
  reg mte_sys_hibernate4 ;
  reg mte_dma_start4 ;
  reg mte_cpu_start4 ;
  reg mte_mac_off_sleep_start4, mte_mac012_sleep_start4, mte_mac013_sleep_start4, mte_mac023_sleep_start4, mte_mac123_sleep_start4;
  reg mte_mac01_sleep_start4, mte_mac02_sleep_start4, mte_mac03_sleep_start4, mte_mac12_sleep_start4, mte_mac13_sleep_start4, mte_mac23_sleep_start4;
  reg mte_mac0_sleep_start4, mte_mac1_sleep_start4, mte_mac2_sleep_start4, mte_mac3_sleep_start4;
  reg mte_dma_sleep_start4;
  reg mte_mac_off_to_default4, mte_mac012_to_default4, mte_mac013_to_default4, mte_mac023_to_default4, mte_mac123_to_default4;
  reg mte_mac01_to_default4, mte_mac02_to_default4, mte_mac03_to_default4, mte_mac12_to_default4, mte_mac13_to_default4, mte_mac23_to_default4;
  reg mte_mac0_to_default4, mte_mac1_to_default4, mte_mac2_to_default4, mte_mac3_to_default4;
  reg mte_dma_isolate_dis4;
  reg mte_cpu_isolate_dis4;
  reg mte_sys_hibernate_to_default4;


  // Latch4 the CPU4 SLEEP4 invocation4
  always @( posedge pclk4 or negedge nprst4) 
  begin
    if(!nprst4)
      L1_ctrl_cpu_off_reg4 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg4 <= L1_ctrl_domain4[8];
  end

  // Create4 a pulse4 for sleep4 detection4 
  assign L1_ctrl_cpu_off_p4 =  L1_ctrl_domain4[8] && !L1_ctrl_cpu_off_reg4;
  
  // CPU4 sleep4 contol4 logic 
  // Shut4 off4 CPU4 when L1_ctrl_cpu_off_p4 is set
  // wake4 cpu4 when any interrupt4 is seen4  
  always @( posedge pclk4 or negedge nprst4) 
  begin
    if(!nprst4)
     cpu_shutoff_ctrl4 <= 1'b0;
    else if(cpu_shutoff_ctrl4 && int_source_h4)
     cpu_shutoff_ctrl4 <= 1'b0;
    else if (L1_ctrl_cpu_off_p4)
     cpu_shutoff_ctrl4 <= 1'b1;
  end
 
  // instantiate4 power4 contol4  block for uart4
  power_ctrl_sm4 i_urt_power_ctrl_sm4(
    .pclk4(pclk4),
    .nprst4(nprst4),
    .L1_module_req4(L1_ctrl_domain4[1]),
    .set_status_module4(set_status_urt4),
    .clr_status_module4(clr_status_urt4),
    .rstn_non_srpg_module4(rstn_non_srpg_urt_int4),
    .gate_clk_module4(gate_clk_urt_int4),
    .isolate_module4(isolate_urt_int4),
    .save_edge4(save_edge_urt_int4),
    .restore_edge4(restore_edge_urt_int4),
    .pwr1_on4(pwr1_on_urt_int4),
    .pwr2_on4(pwr2_on_urt_int4)
    );
  

  // instantiate4 power4 contol4  block for smc4
  power_ctrl_sm4 i_smc_power_ctrl_sm4(
    .pclk4(pclk4),
    .nprst4(nprst4),
    .L1_module_req4(L1_ctrl_domain4[2]),
    .set_status_module4(set_status_smc4),
    .clr_status_module4(clr_status_smc4),
    .rstn_non_srpg_module4(rstn_non_srpg_smc_int4),
    .gate_clk_module4(gate_clk_smc_int4),
    .isolate_module4(isolate_smc_int4),
    .save_edge4(save_edge_smc_int4),
    .restore_edge4(restore_edge_smc_int4),
    .pwr1_on4(pwr1_on_smc_int4),
    .pwr2_on4(pwr2_on_smc_int4)
    );

  // power4 control4 for macb04
  power_ctrl_sm4 i_macb0_power_ctrl_sm4(
    .pclk4(pclk4),
    .nprst4(nprst4),
    .L1_module_req4(L1_ctrl_domain4[3]),
    .set_status_module4(set_status_macb04),
    .clr_status_module4(clr_status_macb04),
    .rstn_non_srpg_module4(rstn_non_srpg_macb0_int4),
    .gate_clk_module4(gate_clk_macb0_int4),
    .isolate_module4(isolate_macb0_int4),
    .save_edge4(save_edge_macb0_int4),
    .restore_edge4(restore_edge_macb0_int4),
    .pwr1_on4(pwr1_on_macb0_int4),
    .pwr2_on4(pwr2_on_macb0_int4)
    );
  // power4 control4 for macb14
  power_ctrl_sm4 i_macb1_power_ctrl_sm4(
    .pclk4(pclk4),
    .nprst4(nprst4),
    .L1_module_req4(L1_ctrl_domain4[4]),
    .set_status_module4(set_status_macb14),
    .clr_status_module4(clr_status_macb14),
    .rstn_non_srpg_module4(rstn_non_srpg_macb1_int4),
    .gate_clk_module4(gate_clk_macb1_int4),
    .isolate_module4(isolate_macb1_int4),
    .save_edge4(save_edge_macb1_int4),
    .restore_edge4(restore_edge_macb1_int4),
    .pwr1_on4(pwr1_on_macb1_int4),
    .pwr2_on4(pwr2_on_macb1_int4)
    );
  // power4 control4 for macb24
  power_ctrl_sm4 i_macb2_power_ctrl_sm4(
    .pclk4(pclk4),
    .nprst4(nprst4),
    .L1_module_req4(L1_ctrl_domain4[5]),
    .set_status_module4(set_status_macb24),
    .clr_status_module4(clr_status_macb24),
    .rstn_non_srpg_module4(rstn_non_srpg_macb2_int4),
    .gate_clk_module4(gate_clk_macb2_int4),
    .isolate_module4(isolate_macb2_int4),
    .save_edge4(save_edge_macb2_int4),
    .restore_edge4(restore_edge_macb2_int4),
    .pwr1_on4(pwr1_on_macb2_int4),
    .pwr2_on4(pwr2_on_macb2_int4)
    );
  // power4 control4 for macb34
  power_ctrl_sm4 i_macb3_power_ctrl_sm4(
    .pclk4(pclk4),
    .nprst4(nprst4),
    .L1_module_req4(L1_ctrl_domain4[6]),
    .set_status_module4(set_status_macb34),
    .clr_status_module4(clr_status_macb34),
    .rstn_non_srpg_module4(rstn_non_srpg_macb3_int4),
    .gate_clk_module4(gate_clk_macb3_int4),
    .isolate_module4(isolate_macb3_int4),
    .save_edge4(save_edge_macb3_int4),
    .restore_edge4(restore_edge_macb3_int4),
    .pwr1_on4(pwr1_on_macb3_int4),
    .pwr2_on4(pwr2_on_macb3_int4)
    );
  // power4 control4 for dma4
  power_ctrl_sm4 i_dma_power_ctrl_sm4(
    .pclk4(pclk4),
    .nprst4(nprst4),
    .L1_module_req4(L1_ctrl_domain4[7]),
    .set_status_module4(set_status_dma4),
    .clr_status_module4(clr_status_dma4),
    .rstn_non_srpg_module4(rstn_non_srpg_dma_int4),
    .gate_clk_module4(gate_clk_dma_int4),
    .isolate_module4(isolate_dma_int4),
    .save_edge4(save_edge_dma_int4),
    .restore_edge4(restore_edge_dma_int4),
    .pwr1_on4(pwr1_on_dma_int4),
    .pwr2_on4(pwr2_on_dma_int4)
    );
  // power4 control4 for CPU4
  power_ctrl_sm4 i_cpu_power_ctrl_sm4(
    .pclk4(pclk4),
    .nprst4(nprst4),
    .L1_module_req4(cpu_shutoff_ctrl4),
    .set_status_module4(set_status_cpu4),
    .clr_status_module4(clr_status_cpu4),
    .rstn_non_srpg_module4(rstn_non_srpg_cpu_int4),
    .gate_clk_module4(gate_clk_cpu_int4),
    .isolate_module4(isolate_cpu_int4),
    .save_edge4(save_edge_cpu_int4),
    .restore_edge4(restore_edge_cpu_int4),
    .pwr1_on4(pwr1_on_cpu_int4),
    .pwr2_on4(pwr2_on_cpu_int4)
    );

  assign valid_reg_write4 =  (psel4 && pwrite4 && penable4);
  assign valid_reg_read4  =  (psel4 && (!pwrite4) && penable4);

  assign L1_ctrl_access4  =  (paddr4[15:0] == 16'b0000000000000100); 
  assign L1_status_access4 = (paddr4[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access4 =   (paddr4[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access4 = (paddr4[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control4 and status register
  always @(*)
  begin  
    if(valid_reg_read4 && L1_ctrl_access4) 
      prdata4 = L1_ctrl_reg4;
    else if (valid_reg_read4 && L1_status_access4)
      prdata4 = L1_status_reg4;
    else if (valid_reg_read4 && pcm_int_mask_access4)
      prdata4 = pcm_mask_reg4;
    else if (valid_reg_read4 && pcm_int_status_access4)
      prdata4 = pcm_status_reg4;
    else 
      prdata4 = 0;
  end

  assign set_status_mem4 =  (set_status_macb04 && set_status_macb14 && set_status_macb24 &&
                            set_status_macb34 && set_status_dma4 && set_status_cpu4);

  assign clr_status_mem4 =  (clr_status_macb04 && clr_status_macb14 && clr_status_macb24 &&
                            clr_status_macb34 && clr_status_dma4 && clr_status_cpu4);

  assign set_status_alut4 = (set_status_macb04 && set_status_macb14 && set_status_macb24 && set_status_macb34);

  assign clr_status_alut4 = (clr_status_macb04 || clr_status_macb14 || clr_status_macb24  || clr_status_macb34);

  // Write accesses to the control4 and status register
 
  always @(posedge pclk4 or negedge nprst4)
  begin
    if (!nprst4) begin
      L1_ctrl_reg4   <= 0;
      L1_status_reg4 <= 0;
      pcm_mask_reg4 <= 0;
    end else begin
      // CTRL4 reg updates4
      if (valid_reg_write4 && L1_ctrl_access4) 
        L1_ctrl_reg4 <= pwdata4; // Writes4 to the ctrl4 reg
      if (valid_reg_write4 && pcm_int_mask_access4) 
        pcm_mask_reg4 <= pwdata4; // Writes4 to the ctrl4 reg

      if (set_status_urt4 == 1'b1)  
        L1_status_reg4[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt4 == 1'b1) 
        L1_status_reg4[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc4 == 1'b1) 
        L1_status_reg4[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc4 == 1'b1) 
        L1_status_reg4[2] <= 1'b0; // Clear the status bit

      if (set_status_macb04 == 1'b1)  
        L1_status_reg4[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb04 == 1'b1) 
        L1_status_reg4[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb14 == 1'b1)  
        L1_status_reg4[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb14 == 1'b1) 
        L1_status_reg4[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb24 == 1'b1)  
        L1_status_reg4[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb24 == 1'b1) 
        L1_status_reg4[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb34 == 1'b1)  
        L1_status_reg4[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb34 == 1'b1) 
        L1_status_reg4[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma4 == 1'b1)  
        L1_status_reg4[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma4 == 1'b1) 
        L1_status_reg4[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu4 == 1'b1)  
        L1_status_reg4[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu4 == 1'b1) 
        L1_status_reg4[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut4 == 1'b1)  
        L1_status_reg4[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut4 == 1'b1) 
        L1_status_reg4[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem4 == 1'b1)  
        L1_status_reg4[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem4 == 1'b1) 
        L1_status_reg4[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused4 bits of pcm_status_reg4 are tied4 to 0
  always @(posedge pclk4 or negedge nprst4)
  begin
    if (!nprst4)
      pcm_status_reg4[31:4] <= 'b0;
    else  
      pcm_status_reg4[31:4] <= pcm_status_reg4[31:4];
  end
  
  // interrupt4 only of h/w assisted4 wakeup
  // MAC4 3
  always @(posedge pclk4 or negedge nprst4)
  begin
    if(!nprst4)
      pcm_status_reg4[3] <= 1'b0;
    else if (valid_reg_write4 && pcm_int_status_access4) 
      pcm_status_reg4[3] <= pwdata4[3];
    else if (macb3_wakeup4 & ~pcm_mask_reg4[3])
      pcm_status_reg4[3] <= 1'b1;
    else if (valid_reg_read4 && pcm_int_status_access4) 
      pcm_status_reg4[3] <= 1'b0;
    else
      pcm_status_reg4[3] <= pcm_status_reg4[3];
  end  
   
  // MAC4 2
  always @(posedge pclk4 or negedge nprst4)
  begin
    if(!nprst4)
      pcm_status_reg4[2] <= 1'b0;
    else if (valid_reg_write4 && pcm_int_status_access4) 
      pcm_status_reg4[2] <= pwdata4[2];
    else if (macb2_wakeup4 & ~pcm_mask_reg4[2])
      pcm_status_reg4[2] <= 1'b1;
    else if (valid_reg_read4 && pcm_int_status_access4) 
      pcm_status_reg4[2] <= 1'b0;
    else
      pcm_status_reg4[2] <= pcm_status_reg4[2];
  end  

  // MAC4 1
  always @(posedge pclk4 or negedge nprst4)
  begin
    if(!nprst4)
      pcm_status_reg4[1] <= 1'b0;
    else if (valid_reg_write4 && pcm_int_status_access4) 
      pcm_status_reg4[1] <= pwdata4[1];
    else if (macb1_wakeup4 & ~pcm_mask_reg4[1])
      pcm_status_reg4[1] <= 1'b1;
    else if (valid_reg_read4 && pcm_int_status_access4) 
      pcm_status_reg4[1] <= 1'b0;
    else
      pcm_status_reg4[1] <= pcm_status_reg4[1];
  end  
   
  // MAC4 0
  always @(posedge pclk4 or negedge nprst4)
  begin
    if(!nprst4)
      pcm_status_reg4[0] <= 1'b0;
    else if (valid_reg_write4 && pcm_int_status_access4) 
      pcm_status_reg4[0] <= pwdata4[0];
    else if (macb0_wakeup4 & ~pcm_mask_reg4[0])
      pcm_status_reg4[0] <= 1'b1;
    else if (valid_reg_read4 && pcm_int_status_access4) 
      pcm_status_reg4[0] <= 1'b0;
    else
      pcm_status_reg4[0] <= pcm_status_reg4[0];
  end  

  assign pcm_macb_wakeup_int4 = |pcm_status_reg4;

  reg [31:0] L1_ctrl_reg14;
  always @(posedge pclk4 or negedge nprst4)
  begin
    if(!nprst4)
      L1_ctrl_reg14 <= 0;
    else
      L1_ctrl_reg14 <= L1_ctrl_reg4;
  end

  // Program4 mode decode
  always @(L1_ctrl_reg4 or L1_ctrl_reg14 or int_source_h4 or cpu_shutoff_ctrl4) begin
    mte_smc_start4 = 0;
    mte_uart_start4 = 0;
    mte_smc_uart_start4  = 0;
    mte_mac_off_start4  = 0;
    mte_mac012_start4 = 0;
    mte_mac013_start4 = 0;
    mte_mac023_start4 = 0;
    mte_mac123_start4 = 0;
    mte_mac01_start4 = 0;
    mte_mac02_start4 = 0;
    mte_mac03_start4 = 0;
    mte_mac12_start4 = 0;
    mte_mac13_start4 = 0;
    mte_mac23_start4 = 0;
    mte_mac0_start4 = 0;
    mte_mac1_start4 = 0;
    mte_mac2_start4 = 0;
    mte_mac3_start4 = 0;
    mte_sys_hibernate4 = 0 ;
    mte_dma_start4 = 0 ;
    mte_cpu_start4 = 0 ;

    mte_mac0_sleep_start4 = (L1_ctrl_reg4 ==  'h14) && (L1_ctrl_reg14 == 'h4 );
    mte_mac1_sleep_start4 = (L1_ctrl_reg4 ==  'h14) && (L1_ctrl_reg14 == 'h5 ); 
    mte_mac2_sleep_start4 = (L1_ctrl_reg4 ==  'h14) && (L1_ctrl_reg14 == 'h6 ); 
    mte_mac3_sleep_start4 = (L1_ctrl_reg4 ==  'h14) && (L1_ctrl_reg14 == 'h7 ); 
    mte_mac01_sleep_start4 = (L1_ctrl_reg4 ==  'h14) && (L1_ctrl_reg14 == 'h8 ); 
    mte_mac02_sleep_start4 = (L1_ctrl_reg4 ==  'h14) && (L1_ctrl_reg14 == 'h9 ); 
    mte_mac03_sleep_start4 = (L1_ctrl_reg4 ==  'h14) && (L1_ctrl_reg14 == 'hA ); 
    mte_mac12_sleep_start4 = (L1_ctrl_reg4 ==  'h14) && (L1_ctrl_reg14 == 'hB ); 
    mte_mac13_sleep_start4 = (L1_ctrl_reg4 ==  'h14) && (L1_ctrl_reg14 == 'hC ); 
    mte_mac23_sleep_start4 = (L1_ctrl_reg4 ==  'h14) && (L1_ctrl_reg14 == 'hD ); 
    mte_mac012_sleep_start4 = (L1_ctrl_reg4 ==  'h14) && (L1_ctrl_reg14 == 'hE ); 
    mte_mac013_sleep_start4 = (L1_ctrl_reg4 ==  'h14) && (L1_ctrl_reg14 == 'hF ); 
    mte_mac023_sleep_start4 = (L1_ctrl_reg4 ==  'h14) && (L1_ctrl_reg14 == 'h10 ); 
    mte_mac123_sleep_start4 = (L1_ctrl_reg4 ==  'h14) && (L1_ctrl_reg14 == 'h11 ); 
    mte_mac_off_sleep_start4 =  (L1_ctrl_reg4 == 'h14) && (L1_ctrl_reg14 == 'h12 );
    mte_dma_sleep_start4 =  (L1_ctrl_reg4 == 'h14) && (L1_ctrl_reg14 == 'h13 );

    mte_pm_uart_to_default_start4 = (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'h1);
    mte_pm_smc_to_default_start4 = (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'h2);
    mte_pm_smc_uart_to_default_start4 = (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'h3); 
    mte_mac0_to_default4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'h4); 
    mte_mac1_to_default4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'h5); 
    mte_mac2_to_default4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'h6); 
    mte_mac3_to_default4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'h7); 
    mte_mac01_to_default4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'h8); 
    mte_mac02_to_default4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'h9); 
    mte_mac03_to_default4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'hA); 
    mte_mac12_to_default4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'hB); 
    mte_mac13_to_default4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'hC); 
    mte_mac23_to_default4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'hD); 
    mte_mac012_to_default4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'hE); 
    mte_mac013_to_default4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'hF); 
    mte_mac023_to_default4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'h10); 
    mte_mac123_to_default4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'h11); 
    mte_mac_off_to_default4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'h12); 
    mte_dma_isolate_dis4 =  (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'h13); 
    mte_cpu_isolate_dis4 =  (int_source_h4) && (cpu_shutoff_ctrl4) && (L1_ctrl_reg4 != 'h15);
    mte_sys_hibernate_to_default4 = (L1_ctrl_reg4 == 32'h0) && (L1_ctrl_reg14 == 'h15); 

   
    if (L1_ctrl_reg14 == 'h0) begin // This4 check is to make mte_cpu_start4
                                   // is set only when you from default state 
      case (L1_ctrl_reg4)
        'h0 : L1_ctrl_domain4 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain4 = 32'h2; // PM_uart4
                mte_uart_start4 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain4 = 32'h4; // PM_smc4
                mte_smc_start4 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain4 = 32'h6; // PM_smc_uart4
                mte_smc_uart_start4 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain4 = 32'h8; //  PM_macb04
                mte_mac0_start4 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain4 = 32'h10; //  PM_macb14
                mte_mac1_start4 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain4 = 32'h20; //  PM_macb24
                mte_mac2_start4 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain4 = 32'h40; //  PM_macb34
                mte_mac3_start4 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain4 = 32'h18; //  PM_macb014
                mte_mac01_start4 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain4 = 32'h28; //  PM_macb024
                mte_mac02_start4 = 1;
              end
        'hA : begin  
                L1_ctrl_domain4 = 32'h48; //  PM_macb034
                mte_mac03_start4 = 1;
              end
        'hB : begin  
                L1_ctrl_domain4 = 32'h30; //  PM_macb124
                mte_mac12_start4 = 1;
              end
        'hC : begin  
                L1_ctrl_domain4 = 32'h50; //  PM_macb134
                mte_mac13_start4 = 1;
              end
        'hD : begin  
                L1_ctrl_domain4 = 32'h60; //  PM_macb234
                mte_mac23_start4 = 1;
              end
        'hE : begin  
                L1_ctrl_domain4 = 32'h38; //  PM_macb0124
                mte_mac012_start4 = 1;
              end
        'hF : begin  
                L1_ctrl_domain4 = 32'h58; //  PM_macb0134
                mte_mac013_start4 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain4 = 32'h68; //  PM_macb0234
                mte_mac023_start4 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain4 = 32'h70; //  PM_macb1234
                mte_mac123_start4 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain4 = 32'h78; //  PM_macb_off4
                mte_mac_off_start4 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain4 = 32'h80; //  PM_dma4
                mte_dma_start4 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain4 = 32'h100; //  PM_cpu_sleep4
                mte_cpu_start4 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain4 = 32'h1FE; //  PM_hibernate4
                mte_sys_hibernate4 = 1;
              end
         default: L1_ctrl_domain4 = 32'h0;
      endcase
    end
  end


  wire to_default4 = (L1_ctrl_reg4 == 0);

  // Scan4 mode gating4 of power4 and isolation4 control4 signals4
  //SMC4
  assign rstn_non_srpg_smc4  = (scan_mode4 == 1'b0) ? rstn_non_srpg_smc_int4 : 1'b1;  
  assign gate_clk_smc4       = (scan_mode4 == 1'b0) ? gate_clk_smc_int4 : 1'b0;     
  assign isolate_smc4        = (scan_mode4 == 1'b0) ? isolate_smc_int4 : 1'b0;      
  assign pwr1_on_smc4        = (scan_mode4 == 1'b0) ? pwr1_on_smc_int4 : 1'b1;       
  assign pwr2_on_smc4        = (scan_mode4 == 1'b0) ? pwr2_on_smc_int4 : 1'b1;       
  assign pwr1_off_smc4       = (scan_mode4 == 1'b0) ? (!pwr1_on_smc_int4) : 1'b0;       
  assign pwr2_off_smc4       = (scan_mode4 == 1'b0) ? (!pwr2_on_smc_int4) : 1'b0;       
  assign save_edge_smc4       = (scan_mode4 == 1'b0) ? (save_edge_smc_int4) : 1'b0;       
  assign restore_edge_smc4       = (scan_mode4 == 1'b0) ? (restore_edge_smc_int4) : 1'b0;       

  //URT4
  assign rstn_non_srpg_urt4  = (scan_mode4 == 1'b0) ?  rstn_non_srpg_urt_int4 : 1'b1;  
  assign gate_clk_urt4       = (scan_mode4 == 1'b0) ?  gate_clk_urt_int4      : 1'b0;     
  assign isolate_urt4        = (scan_mode4 == 1'b0) ?  isolate_urt_int4       : 1'b0;      
  assign pwr1_on_urt4        = (scan_mode4 == 1'b0) ?  pwr1_on_urt_int4       : 1'b1;       
  assign pwr2_on_urt4        = (scan_mode4 == 1'b0) ?  pwr2_on_urt_int4       : 1'b1;       
  assign pwr1_off_urt4       = (scan_mode4 == 1'b0) ?  (!pwr1_on_urt_int4)  : 1'b0;       
  assign pwr2_off_urt4       = (scan_mode4 == 1'b0) ?  (!pwr2_on_urt_int4)  : 1'b0;       
  assign save_edge_urt4       = (scan_mode4 == 1'b0) ? (save_edge_urt_int4) : 1'b0;       
  assign restore_edge_urt4       = (scan_mode4 == 1'b0) ? (restore_edge_urt_int4) : 1'b0;       

  //ETH04
  assign rstn_non_srpg_macb04 = (scan_mode4 == 1'b0) ?  rstn_non_srpg_macb0_int4 : 1'b1;  
  assign gate_clk_macb04       = (scan_mode4 == 1'b0) ?  gate_clk_macb0_int4      : 1'b0;     
  assign isolate_macb04        = (scan_mode4 == 1'b0) ?  isolate_macb0_int4       : 1'b0;      
  assign pwr1_on_macb04        = (scan_mode4 == 1'b0) ?  pwr1_on_macb0_int4       : 1'b1;       
  assign pwr2_on_macb04        = (scan_mode4 == 1'b0) ?  pwr2_on_macb0_int4       : 1'b1;       
  assign pwr1_off_macb04       = (scan_mode4 == 1'b0) ?  (!pwr1_on_macb0_int4)  : 1'b0;       
  assign pwr2_off_macb04       = (scan_mode4 == 1'b0) ?  (!pwr2_on_macb0_int4)  : 1'b0;       
  assign save_edge_macb04       = (scan_mode4 == 1'b0) ? (save_edge_macb0_int4) : 1'b0;       
  assign restore_edge_macb04       = (scan_mode4 == 1'b0) ? (restore_edge_macb0_int4) : 1'b0;       

  //ETH14
  assign rstn_non_srpg_macb14 = (scan_mode4 == 1'b0) ?  rstn_non_srpg_macb1_int4 : 1'b1;  
  assign gate_clk_macb14       = (scan_mode4 == 1'b0) ?  gate_clk_macb1_int4      : 1'b0;     
  assign isolate_macb14        = (scan_mode4 == 1'b0) ?  isolate_macb1_int4       : 1'b0;      
  assign pwr1_on_macb14        = (scan_mode4 == 1'b0) ?  pwr1_on_macb1_int4       : 1'b1;       
  assign pwr2_on_macb14        = (scan_mode4 == 1'b0) ?  pwr2_on_macb1_int4       : 1'b1;       
  assign pwr1_off_macb14       = (scan_mode4 == 1'b0) ?  (!pwr1_on_macb1_int4)  : 1'b0;       
  assign pwr2_off_macb14       = (scan_mode4 == 1'b0) ?  (!pwr2_on_macb1_int4)  : 1'b0;       
  assign save_edge_macb14       = (scan_mode4 == 1'b0) ? (save_edge_macb1_int4) : 1'b0;       
  assign restore_edge_macb14       = (scan_mode4 == 1'b0) ? (restore_edge_macb1_int4) : 1'b0;       

  //ETH24
  assign rstn_non_srpg_macb24 = (scan_mode4 == 1'b0) ?  rstn_non_srpg_macb2_int4 : 1'b1;  
  assign gate_clk_macb24       = (scan_mode4 == 1'b0) ?  gate_clk_macb2_int4      : 1'b0;     
  assign isolate_macb24        = (scan_mode4 == 1'b0) ?  isolate_macb2_int4       : 1'b0;      
  assign pwr1_on_macb24        = (scan_mode4 == 1'b0) ?  pwr1_on_macb2_int4       : 1'b1;       
  assign pwr2_on_macb24        = (scan_mode4 == 1'b0) ?  pwr2_on_macb2_int4       : 1'b1;       
  assign pwr1_off_macb24       = (scan_mode4 == 1'b0) ?  (!pwr1_on_macb2_int4)  : 1'b0;       
  assign pwr2_off_macb24       = (scan_mode4 == 1'b0) ?  (!pwr2_on_macb2_int4)  : 1'b0;       
  assign save_edge_macb24       = (scan_mode4 == 1'b0) ? (save_edge_macb2_int4) : 1'b0;       
  assign restore_edge_macb24       = (scan_mode4 == 1'b0) ? (restore_edge_macb2_int4) : 1'b0;       

  //ETH34
  assign rstn_non_srpg_macb34 = (scan_mode4 == 1'b0) ?  rstn_non_srpg_macb3_int4 : 1'b1;  
  assign gate_clk_macb34       = (scan_mode4 == 1'b0) ?  gate_clk_macb3_int4      : 1'b0;     
  assign isolate_macb34        = (scan_mode4 == 1'b0) ?  isolate_macb3_int4       : 1'b0;      
  assign pwr1_on_macb34        = (scan_mode4 == 1'b0) ?  pwr1_on_macb3_int4       : 1'b1;       
  assign pwr2_on_macb34        = (scan_mode4 == 1'b0) ?  pwr2_on_macb3_int4       : 1'b1;       
  assign pwr1_off_macb34       = (scan_mode4 == 1'b0) ?  (!pwr1_on_macb3_int4)  : 1'b0;       
  assign pwr2_off_macb34       = (scan_mode4 == 1'b0) ?  (!pwr2_on_macb3_int4)  : 1'b0;       
  assign save_edge_macb34       = (scan_mode4 == 1'b0) ? (save_edge_macb3_int4) : 1'b0;       
  assign restore_edge_macb34       = (scan_mode4 == 1'b0) ? (restore_edge_macb3_int4) : 1'b0;       

  // MEM4
  assign rstn_non_srpg_mem4 =   (rstn_non_srpg_macb04 && rstn_non_srpg_macb14 && rstn_non_srpg_macb24 &&
                                rstn_non_srpg_macb34 && rstn_non_srpg_dma4 && rstn_non_srpg_cpu4 && rstn_non_srpg_urt4 &&
                                rstn_non_srpg_smc4);

  assign gate_clk_mem4 =  (gate_clk_macb04 && gate_clk_macb14 && gate_clk_macb24 &&
                            gate_clk_macb34 && gate_clk_dma4 && gate_clk_cpu4 && gate_clk_urt4 && gate_clk_smc4);

  assign isolate_mem4  = (isolate_macb04 && isolate_macb14 && isolate_macb24 &&
                         isolate_macb34 && isolate_dma4 && isolate_cpu4 && isolate_urt4 && isolate_smc4);


  assign pwr1_on_mem4        =   ~pwr1_off_mem4;

  assign pwr2_on_mem4        =   ~pwr2_off_mem4;

  assign pwr1_off_mem4       =  (pwr1_off_macb04 && pwr1_off_macb14 && pwr1_off_macb24 &&
                                 pwr1_off_macb34 && pwr1_off_dma4 && pwr1_off_cpu4 && pwr1_off_urt4 && pwr1_off_smc4);


  assign pwr2_off_mem4       =  (pwr2_off_macb04 && pwr2_off_macb14 && pwr2_off_macb24 &&
                                pwr2_off_macb34 && pwr2_off_dma4 && pwr2_off_cpu4 && pwr2_off_urt4 && pwr2_off_smc4);

  assign save_edge_mem4      =  (save_edge_macb04 && save_edge_macb14 && save_edge_macb24 &&
                                save_edge_macb34 && save_edge_dma4 && save_edge_cpu4 && save_edge_smc4 && save_edge_urt4);

  assign restore_edge_mem4   =  (restore_edge_macb04 && restore_edge_macb14 && restore_edge_macb24  &&
                                restore_edge_macb34 && restore_edge_dma4 && restore_edge_cpu4 && restore_edge_urt4 &&
                                restore_edge_smc4);

  assign standby_mem04 = pwr1_off_macb04 && (~ (pwr1_off_macb04 && pwr1_off_macb14 && pwr1_off_macb24 && pwr1_off_macb34 && pwr1_off_urt4 && pwr1_off_smc4 && pwr1_off_dma4 && pwr1_off_cpu4));
  assign standby_mem14 = pwr1_off_macb14 && (~ (pwr1_off_macb04 && pwr1_off_macb14 && pwr1_off_macb24 && pwr1_off_macb34 && pwr1_off_urt4 && pwr1_off_smc4 && pwr1_off_dma4 && pwr1_off_cpu4));
  assign standby_mem24 = pwr1_off_macb24 && (~ (pwr1_off_macb04 && pwr1_off_macb14 && pwr1_off_macb24 && pwr1_off_macb34 && pwr1_off_urt4 && pwr1_off_smc4 && pwr1_off_dma4 && pwr1_off_cpu4));
  assign standby_mem34 = pwr1_off_macb34 && (~ (pwr1_off_macb04 && pwr1_off_macb14 && pwr1_off_macb24 && pwr1_off_macb34 && pwr1_off_urt4 && pwr1_off_smc4 && pwr1_off_dma4 && pwr1_off_cpu4));

  assign pwr1_off_mem04 = pwr1_off_mem4;
  assign pwr1_off_mem14 = pwr1_off_mem4;
  assign pwr1_off_mem24 = pwr1_off_mem4;
  assign pwr1_off_mem34 = pwr1_off_mem4;

  assign rstn_non_srpg_alut4  =  (rstn_non_srpg_macb04 && rstn_non_srpg_macb14 && rstn_non_srpg_macb24 && rstn_non_srpg_macb34);


   assign gate_clk_alut4       =  (gate_clk_macb04 && gate_clk_macb14 && gate_clk_macb24 && gate_clk_macb34);


    assign isolate_alut4        =  (isolate_macb04 && isolate_macb14 && isolate_macb24 && isolate_macb34);


    assign pwr1_on_alut4        =  (pwr1_on_macb04 || pwr1_on_macb14 || pwr1_on_macb24 || pwr1_on_macb34);


    assign pwr2_on_alut4        =  (pwr2_on_macb04 || pwr2_on_macb14 || pwr2_on_macb24 || pwr2_on_macb34);


    assign pwr1_off_alut4       =  (pwr1_off_macb04 && pwr1_off_macb14 && pwr1_off_macb24 && pwr1_off_macb34);


    assign pwr2_off_alut4       =  (pwr2_off_macb04 && pwr2_off_macb14 && pwr2_off_macb24 && pwr2_off_macb34);


    assign save_edge_alut4      =  (save_edge_macb04 && save_edge_macb14 && save_edge_macb24 && save_edge_macb34);


    assign restore_edge_alut4   =  (restore_edge_macb04 || restore_edge_macb14 || restore_edge_macb24 ||
                                   restore_edge_macb34) && save_alut_tmp4;

     // alut4 power4 off4 detection4
  always @(posedge pclk4 or negedge nprst4) begin
    if (!nprst4) 
       save_alut_tmp4 <= 0;
    else if (restore_edge_alut4)
       save_alut_tmp4 <= 0;
    else if (save_edge_alut4)
       save_alut_tmp4 <= 1;
  end

  //DMA4
  assign rstn_non_srpg_dma4 = (scan_mode4 == 1'b0) ?  rstn_non_srpg_dma_int4 : 1'b1;  
  assign gate_clk_dma4       = (scan_mode4 == 1'b0) ?  gate_clk_dma_int4      : 1'b0;     
  assign isolate_dma4        = (scan_mode4 == 1'b0) ?  isolate_dma_int4       : 1'b0;      
  assign pwr1_on_dma4        = (scan_mode4 == 1'b0) ?  pwr1_on_dma_int4       : 1'b1;       
  assign pwr2_on_dma4        = (scan_mode4 == 1'b0) ?  pwr2_on_dma_int4       : 1'b1;       
  assign pwr1_off_dma4       = (scan_mode4 == 1'b0) ?  (!pwr1_on_dma_int4)  : 1'b0;       
  assign pwr2_off_dma4       = (scan_mode4 == 1'b0) ?  (!pwr2_on_dma_int4)  : 1'b0;       
  assign save_edge_dma4       = (scan_mode4 == 1'b0) ? (save_edge_dma_int4) : 1'b0;       
  assign restore_edge_dma4       = (scan_mode4 == 1'b0) ? (restore_edge_dma_int4) : 1'b0;       

  //CPU4
  assign rstn_non_srpg_cpu4 = (scan_mode4 == 1'b0) ?  rstn_non_srpg_cpu_int4 : 1'b1;  
  assign gate_clk_cpu4       = (scan_mode4 == 1'b0) ?  gate_clk_cpu_int4      : 1'b0;     
  assign isolate_cpu4        = (scan_mode4 == 1'b0) ?  isolate_cpu_int4       : 1'b0;      
  assign pwr1_on_cpu4        = (scan_mode4 == 1'b0) ?  pwr1_on_cpu_int4       : 1'b1;       
  assign pwr2_on_cpu4        = (scan_mode4 == 1'b0) ?  pwr2_on_cpu_int4       : 1'b1;       
  assign pwr1_off_cpu4       = (scan_mode4 == 1'b0) ?  (!pwr1_on_cpu_int4)  : 1'b0;       
  assign pwr2_off_cpu4       = (scan_mode4 == 1'b0) ?  (!pwr2_on_cpu_int4)  : 1'b0;       
  assign save_edge_cpu4       = (scan_mode4 == 1'b0) ? (save_edge_cpu_int4) : 1'b0;       
  assign restore_edge_cpu4       = (scan_mode4 == 1'b0) ? (restore_edge_cpu_int4) : 1'b0;       



  // ASE4

   reg ase_core_12v4, ase_core_10v4, ase_core_08v4, ase_core_06v4;
   reg ase_macb0_12v4,ase_macb1_12v4,ase_macb2_12v4,ase_macb3_12v4;

    // core4 ase4

    // core4 at 1.0 v if (smc4 off4, urt4 off4, macb04 off4, macb14 off4, macb24 off4, macb34 off4
   // core4 at 0.8v if (mac01off4, macb02off4, macb03off4, macb12off4, mac13off4, mac23off4,
   // core4 at 0.6v if (mac012off4, mac013off4, mac023off4, mac123off4, mac0123off4
    // else core4 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb04 && pwr1_off_macb14 && pwr1_off_macb24 && pwr1_off_macb34) || // all mac4 off4
       (pwr1_off_macb34 && pwr1_off_macb24 && pwr1_off_macb14) || // mac123off4 
       (pwr1_off_macb34 && pwr1_off_macb24 && pwr1_off_macb04) || // mac023off4 
       (pwr1_off_macb34 && pwr1_off_macb14 && pwr1_off_macb04) || // mac013off4 
       (pwr1_off_macb24 && pwr1_off_macb14 && pwr1_off_macb04) )  // mac012off4 
       begin
         ase_core_12v4 = 0;
         ase_core_10v4 = 0;
         ase_core_08v4 = 0;
         ase_core_06v4 = 1;
       end
     else if( (pwr1_off_macb24 && pwr1_off_macb34) || // mac234 off4
         (pwr1_off_macb34 && pwr1_off_macb14) || // mac13off4 
         (pwr1_off_macb14 && pwr1_off_macb24) || // mac12off4 
         (pwr1_off_macb34 && pwr1_off_macb04) || // mac03off4 
         (pwr1_off_macb24 && pwr1_off_macb04) || // mac02off4 
         (pwr1_off_macb14 && pwr1_off_macb04))  // mac01off4 
       begin
         ase_core_12v4 = 0;
         ase_core_10v4 = 0;
         ase_core_08v4 = 1;
         ase_core_06v4 = 0;
       end
     else if( (pwr1_off_smc4) || // smc4 off4
         (pwr1_off_macb04 ) || // mac0off4 
         (pwr1_off_macb14 ) || // mac1off4 
         (pwr1_off_macb24 ) || // mac2off4 
         (pwr1_off_macb34 ))  // mac3off4 
       begin
         ase_core_12v4 = 0;
         ase_core_10v4 = 1;
         ase_core_08v4 = 0;
         ase_core_06v4 = 0;
       end
     else if (pwr1_off_urt4)
       begin
         ase_core_12v4 = 1;
         ase_core_10v4 = 0;
         ase_core_08v4 = 0;
         ase_core_06v4 = 0;
       end
     else
       begin
         ase_core_12v4 = 1;
         ase_core_10v4 = 0;
         ase_core_08v4 = 0;
         ase_core_06v4 = 0;
       end
   end


   // cpu4
   // cpu4 @ 1.0v when macoff4, 
   // 
   reg ase_cpu_10v4, ase_cpu_12v4;
   always @(*) begin
    if(pwr1_off_cpu4) begin
     ase_cpu_12v4 = 1'b0;
     ase_cpu_10v4 = 1'b0;
    end
    else if(pwr1_off_macb04 || pwr1_off_macb14 || pwr1_off_macb24 || pwr1_off_macb34)
    begin
     ase_cpu_12v4 = 1'b0;
     ase_cpu_10v4 = 1'b1;
    end
    else
    begin
     ase_cpu_12v4 = 1'b1;
     ase_cpu_10v4 = 1'b0;
    end
   end

   // dma4
   // dma4 @v14.0 for macoff4, 

   reg ase_dma_10v4, ase_dma_12v4;
   always @(*) begin
    if(pwr1_off_dma4) begin
     ase_dma_12v4 = 1'b0;
     ase_dma_10v4 = 1'b0;
    end
    else if(pwr1_off_macb04 || pwr1_off_macb14 || pwr1_off_macb24 || pwr1_off_macb34)
    begin
     ase_dma_12v4 = 1'b0;
     ase_dma_10v4 = 1'b1;
    end
    else
    begin
     ase_dma_12v4 = 1'b1;
     ase_dma_10v4 = 1'b0;
    end
   end

   // alut4
   // @ v14.0 for macoff4

   reg ase_alut_10v4, ase_alut_12v4;
   always @(*) begin
    if(pwr1_off_alut4) begin
     ase_alut_12v4 = 1'b0;
     ase_alut_10v4 = 1'b0;
    end
    else if(pwr1_off_macb04 || pwr1_off_macb14 || pwr1_off_macb24 || pwr1_off_macb34)
    begin
     ase_alut_12v4 = 1'b0;
     ase_alut_10v4 = 1'b1;
    end
    else
    begin
     ase_alut_12v4 = 1'b1;
     ase_alut_10v4 = 1'b0;
    end
   end




   reg ase_uart_12v4;
   reg ase_uart_10v4;
   reg ase_uart_08v4;
   reg ase_uart_06v4;

   reg ase_smc_12v4;


   always @(*) begin
     if(pwr1_off_urt4) begin // uart4 off4
       ase_uart_08v4 = 1'b0;
       ase_uart_06v4 = 1'b0;
       ase_uart_10v4 = 1'b0;
       ase_uart_12v4 = 1'b0;
     end 
     else if( (pwr1_off_macb04 && pwr1_off_macb14 && pwr1_off_macb24 && pwr1_off_macb34) || // all mac4 off4
       (pwr1_off_macb34 && pwr1_off_macb24 && pwr1_off_macb14) || // mac123off4 
       (pwr1_off_macb34 && pwr1_off_macb24 && pwr1_off_macb04) || // mac023off4 
       (pwr1_off_macb34 && pwr1_off_macb14 && pwr1_off_macb04) || // mac013off4 
       (pwr1_off_macb24 && pwr1_off_macb14 && pwr1_off_macb04) )  // mac012off4 
     begin
       ase_uart_06v4 = 1'b1;
       ase_uart_08v4 = 1'b0;
       ase_uart_10v4 = 1'b0;
       ase_uart_12v4 = 1'b0;
     end
     else if( (pwr1_off_macb24 && pwr1_off_macb34) || // mac234 off4
         (pwr1_off_macb34 && pwr1_off_macb14) || // mac13off4 
         (pwr1_off_macb14 && pwr1_off_macb24) || // mac12off4 
         (pwr1_off_macb34 && pwr1_off_macb04) || // mac03off4 
         (pwr1_off_macb14 && pwr1_off_macb04))  // mac01off4  
     begin
       ase_uart_06v4 = 1'b0;
       ase_uart_08v4 = 1'b1;
       ase_uart_10v4 = 1'b0;
       ase_uart_12v4 = 1'b0;
     end
     else if (pwr1_off_smc4 || pwr1_off_macb04 || pwr1_off_macb14 || pwr1_off_macb24 || pwr1_off_macb34) begin // smc4 off4
       ase_uart_08v4 = 1'b0;
       ase_uart_06v4 = 1'b0;
       ase_uart_10v4 = 1'b1;
       ase_uart_12v4 = 1'b0;
     end 
     else begin
       ase_uart_08v4 = 1'b0;
       ase_uart_06v4 = 1'b0;
       ase_uart_10v4 = 1'b0;
       ase_uart_12v4 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc4) begin
     if (pwr1_off_smc4)  // smc4 off4
       ase_smc_12v4 = 1'b0;
    else
       ase_smc_12v4 = 1'b1;
   end

   
   always @(pwr1_off_macb04) begin
     if (pwr1_off_macb04) // macb04 off4
       ase_macb0_12v4 = 1'b0;
     else
       ase_macb0_12v4 = 1'b1;
   end

   always @(pwr1_off_macb14) begin
     if (pwr1_off_macb14) // macb14 off4
       ase_macb1_12v4 = 1'b0;
     else
       ase_macb1_12v4 = 1'b1;
   end

   always @(pwr1_off_macb24) begin // macb24 off4
     if (pwr1_off_macb24) // macb24 off4
       ase_macb2_12v4 = 1'b0;
     else
       ase_macb2_12v4 = 1'b1;
   end

   always @(pwr1_off_macb34) begin // macb34 off4
     if (pwr1_off_macb34) // macb34 off4
       ase_macb3_12v4 = 1'b0;
     else
       ase_macb3_12v4 = 1'b1;
   end


   // core4 voltage4 for vco4
  assign core12v4 = ase_macb0_12v4 & ase_macb1_12v4 & ase_macb2_12v4 & ase_macb3_12v4;

  assign core10v4 =  (ase_macb0_12v4 & ase_macb1_12v4 & ase_macb2_12v4 & (!ase_macb3_12v4)) ||
                    (ase_macb0_12v4 & ase_macb1_12v4 & (!ase_macb2_12v4) & ase_macb3_12v4) ||
                    (ase_macb0_12v4 & (!ase_macb1_12v4) & ase_macb2_12v4 & ase_macb3_12v4) ||
                    ((!ase_macb0_12v4) & ase_macb1_12v4 & ase_macb2_12v4 & ase_macb3_12v4);

  assign core08v4 =  ((!ase_macb0_12v4) & (!ase_macb1_12v4) & (ase_macb2_12v4) & (ase_macb3_12v4)) ||
                    ((!ase_macb0_12v4) & (ase_macb1_12v4) & (!ase_macb2_12v4) & (ase_macb3_12v4)) ||
                    ((!ase_macb0_12v4) & (ase_macb1_12v4) & (ase_macb2_12v4) & (!ase_macb3_12v4)) ||
                    ((ase_macb0_12v4) & (!ase_macb1_12v4) & (!ase_macb2_12v4) & (ase_macb3_12v4)) ||
                    ((ase_macb0_12v4) & (!ase_macb1_12v4) & (ase_macb2_12v4) & (!ase_macb3_12v4)) ||
                    ((ase_macb0_12v4) & (ase_macb1_12v4) & (!ase_macb2_12v4) & (!ase_macb3_12v4));

  assign core06v4 =  ((!ase_macb0_12v4) & (!ase_macb1_12v4) & (!ase_macb2_12v4) & (ase_macb3_12v4)) ||
                    ((!ase_macb0_12v4) & (!ase_macb1_12v4) & (ase_macb2_12v4) & (!ase_macb3_12v4)) ||
                    ((!ase_macb0_12v4) & (ase_macb1_12v4) & (!ase_macb2_12v4) & (!ase_macb3_12v4)) ||
                    ((ase_macb0_12v4) & (!ase_macb1_12v4) & (!ase_macb2_12v4) & (!ase_macb3_12v4)) ||
                    ((!ase_macb0_12v4) & (!ase_macb1_12v4) & (!ase_macb2_12v4) & (!ase_macb3_12v4)) ;



`ifdef LP_ABV_ON4
// psl4 default clock4 = (posedge pclk4);

// Cover4 a condition in which SMC4 is powered4 down
// and again4 powered4 up while UART4 is going4 into POWER4 down
// state or UART4 is already in POWER4 DOWN4 state
// psl4 cover_overlapping_smc_urt_14:
//    cover{fell4(pwr1_on_urt4);[*];fell4(pwr1_on_smc4);[*];
//    rose4(pwr1_on_smc4);[*];rose4(pwr1_on_urt4)};
//
// Cover4 a condition in which UART4 is powered4 down
// and again4 powered4 up while SMC4 is going4 into POWER4 down
// state or SMC4 is already in POWER4 DOWN4 state
// psl4 cover_overlapping_smc_urt_24:
//    cover{fell4(pwr1_on_smc4);[*];fell4(pwr1_on_urt4);[*];
//    rose4(pwr1_on_urt4);[*];rose4(pwr1_on_smc4)};
//


// Power4 Down4 UART4
// This4 gets4 triggered on rising4 edge of Gate4 signal4 for
// UART4 (gate_clk_urt4). In a next cycle after gate_clk_urt4,
// Isolate4 UART4(isolate_urt4) signal4 become4 HIGH4 (active).
// In 2nd cycle after gate_clk_urt4 becomes HIGH4, RESET4 for NON4
// SRPG4 FFs4(rstn_non_srpg_urt4) and POWER14 for UART4(pwr1_on_urt4) should 
// go4 LOW4. 
// This4 completes4 a POWER4 DOWN4. 

sequence s_power_down_urt4;
      (gate_clk_urt4 & !isolate_urt4 & rstn_non_srpg_urt4 & pwr1_on_urt4) 
  ##1 (gate_clk_urt4 & isolate_urt4 & rstn_non_srpg_urt4 & pwr1_on_urt4) 
  ##3 (gate_clk_urt4 & isolate_urt4 & !rstn_non_srpg_urt4 & !pwr1_on_urt4);
endsequence


property p_power_down_urt4;
   @(posedge pclk4)
    $rose(gate_clk_urt4) |=> s_power_down_urt4;
endproperty

output_power_down_urt4:
  assert property (p_power_down_urt4);


// Power4 UP4 UART4
// Sequence starts with , Rising4 edge of pwr1_on_urt4.
// Two4 clock4 cycle after this, isolate_urt4 should become4 LOW4 
// On4 the following4 clk4 gate_clk_urt4 should go4 low4.
// 5 cycles4 after  Rising4 edge of pwr1_on_urt4, rstn_non_srpg_urt4
// should become4 HIGH4
sequence s_power_up_urt4;
##30 (pwr1_on_urt4 & !isolate_urt4 & gate_clk_urt4 & !rstn_non_srpg_urt4) 
##1 (pwr1_on_urt4 & !isolate_urt4 & !gate_clk_urt4 & !rstn_non_srpg_urt4) 
##2 (pwr1_on_urt4 & !isolate_urt4 & !gate_clk_urt4 & rstn_non_srpg_urt4);
endsequence

property p_power_up_urt4;
   @(posedge pclk4)
  disable iff(!nprst4)
    (!pwr1_on_urt4 ##1 pwr1_on_urt4) |=> s_power_up_urt4;
endproperty

output_power_up_urt4:
  assert property (p_power_up_urt4);


// Power4 Down4 SMC4
// This4 gets4 triggered on rising4 edge of Gate4 signal4 for
// SMC4 (gate_clk_smc4). In a next cycle after gate_clk_smc4,
// Isolate4 SMC4(isolate_smc4) signal4 become4 HIGH4 (active).
// In 2nd cycle after gate_clk_smc4 becomes HIGH4, RESET4 for NON4
// SRPG4 FFs4(rstn_non_srpg_smc4) and POWER14 for SMC4(pwr1_on_smc4) should 
// go4 LOW4. 
// This4 completes4 a POWER4 DOWN4. 

sequence s_power_down_smc4;
      (gate_clk_smc4 & !isolate_smc4 & rstn_non_srpg_smc4 & pwr1_on_smc4) 
  ##1 (gate_clk_smc4 & isolate_smc4 & rstn_non_srpg_smc4 & pwr1_on_smc4) 
  ##3 (gate_clk_smc4 & isolate_smc4 & !rstn_non_srpg_smc4 & !pwr1_on_smc4);
endsequence


property p_power_down_smc4;
   @(posedge pclk4)
    $rose(gate_clk_smc4) |=> s_power_down_smc4;
endproperty

output_power_down_smc4:
  assert property (p_power_down_smc4);


// Power4 UP4 SMC4
// Sequence starts with , Rising4 edge of pwr1_on_smc4.
// Two4 clock4 cycle after this, isolate_smc4 should become4 LOW4 
// On4 the following4 clk4 gate_clk_smc4 should go4 low4.
// 5 cycles4 after  Rising4 edge of pwr1_on_smc4, rstn_non_srpg_smc4
// should become4 HIGH4
sequence s_power_up_smc4;
##30 (pwr1_on_smc4 & !isolate_smc4 & gate_clk_smc4 & !rstn_non_srpg_smc4) 
##1 (pwr1_on_smc4 & !isolate_smc4 & !gate_clk_smc4 & !rstn_non_srpg_smc4) 
##2 (pwr1_on_smc4 & !isolate_smc4 & !gate_clk_smc4 & rstn_non_srpg_smc4);
endsequence

property p_power_up_smc4;
   @(posedge pclk4)
  disable iff(!nprst4)
    (!pwr1_on_smc4 ##1 pwr1_on_smc4) |=> s_power_up_smc4;
endproperty

output_power_up_smc4:
  assert property (p_power_up_smc4);


// COVER4 SMC4 POWER4 DOWN4 AND4 UP4
cover_power_down_up_smc4: cover property (@(posedge pclk4)
(s_power_down_smc4 ##[5:180] s_power_up_smc4));



// COVER4 UART4 POWER4 DOWN4 AND4 UP4
cover_power_down_up_urt4: cover property (@(posedge pclk4)
(s_power_down_urt4 ##[5:180] s_power_up_urt4));

cover_power_down_urt4: cover property (@(posedge pclk4)
(s_power_down_urt4));

cover_power_up_urt4: cover property (@(posedge pclk4)
(s_power_up_urt4));




`ifdef PCM_ABV_ON4
//------------------------------------------------------------------------------
// Power4 Controller4 Formal4 Verification4 component.  Each power4 domain has a 
// separate4 instantiation4
//------------------------------------------------------------------------------

// need to assume that CPU4 will leave4 a minimum time between powering4 down and 
// back up.  In this example4, 10clks has been selected.
// psl4 config_min_uart_pd_time4 : assume always {rose4(L1_ctrl_domain4[1])} |-> { L1_ctrl_domain4[1][*10] } abort4(~nprst4);
// psl4 config_min_uart_pu_time4 : assume always {fell4(L1_ctrl_domain4[1])} |-> { !L1_ctrl_domain4[1][*10] } abort4(~nprst4);
// psl4 config_min_smc_pd_time4 : assume always {rose4(L1_ctrl_domain4[2])} |-> { L1_ctrl_domain4[2][*10] } abort4(~nprst4);
// psl4 config_min_smc_pu_time4 : assume always {fell4(L1_ctrl_domain4[2])} |-> { !L1_ctrl_domain4[2][*10] } abort4(~nprst4);

// UART4 VCOMP4 parameters4
   defparam i_uart_vcomp_domain4.ENABLE_SAVE_RESTORE_EDGE4   = 1;
   defparam i_uart_vcomp_domain4.ENABLE_EXT_PWR_CNTRL4       = 1;
   defparam i_uart_vcomp_domain4.REF_CLK_DEFINED4            = 0;
   defparam i_uart_vcomp_domain4.MIN_SHUTOFF_CYCLES4         = 4;
   defparam i_uart_vcomp_domain4.MIN_RESTORE_TO_ISO_CYCLES4  = 0;
   defparam i_uart_vcomp_domain4.MIN_SAVE_TO_SHUTOFF_CYCLES4 = 1;


   vcomp_domain4 i_uart_vcomp_domain4
   ( .ref_clk4(pclk4),
     .start_lps4(L1_ctrl_domain4[1] || !rstn_non_srpg_urt4),
     .rst_n4(nprst4),
     .ext_power_down4(L1_ctrl_domain4[1]),
     .iso_en4(isolate_urt4),
     .save_edge4(save_edge_urt4),
     .restore_edge4(restore_edge_urt4),
     .domain_shut_off4(pwr1_off_urt4),
     .domain_clk4(!gate_clk_urt4 && pclk4)
   );


// SMC4 VCOMP4 parameters4
   defparam i_smc_vcomp_domain4.ENABLE_SAVE_RESTORE_EDGE4   = 1;
   defparam i_smc_vcomp_domain4.ENABLE_EXT_PWR_CNTRL4       = 1;
   defparam i_smc_vcomp_domain4.REF_CLK_DEFINED4            = 0;
   defparam i_smc_vcomp_domain4.MIN_SHUTOFF_CYCLES4         = 4;
   defparam i_smc_vcomp_domain4.MIN_RESTORE_TO_ISO_CYCLES4  = 0;
   defparam i_smc_vcomp_domain4.MIN_SAVE_TO_SHUTOFF_CYCLES4 = 1;


   vcomp_domain4 i_smc_vcomp_domain4
   ( .ref_clk4(pclk4),
     .start_lps4(L1_ctrl_domain4[2] || !rstn_non_srpg_smc4),
     .rst_n4(nprst4),
     .ext_power_down4(L1_ctrl_domain4[2]),
     .iso_en4(isolate_smc4),
     .save_edge4(save_edge_smc4),
     .restore_edge4(restore_edge_smc4),
     .domain_shut_off4(pwr1_off_smc4),
     .domain_clk4(!gate_clk_smc4 && pclk4)
   );

`endif

`endif



endmodule
