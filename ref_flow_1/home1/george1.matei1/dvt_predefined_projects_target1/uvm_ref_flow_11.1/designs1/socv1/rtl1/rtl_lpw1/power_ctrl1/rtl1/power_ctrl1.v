//File1 name   : power_ctrl1.v
//Title1       : Power1 Control1 Module1
//Created1     : 1999
//Description1 : Top1 level of power1 controller1
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

module power_ctrl1 (


    // Clocks1 & Reset1
    pclk1,
    nprst1,
    // APB1 programming1 interface
    paddr1,
    psel1,
    penable1,
    pwrite1,
    pwdata1,
    prdata1,
    // mac1 i/f,
    macb3_wakeup1,
    macb2_wakeup1,
    macb1_wakeup1,
    macb0_wakeup1,
    // Scan1 
    scan_in1,
    scan_en1,
    scan_mode1,
    scan_out1,
    // Module1 control1 outputs1
    int_source_h1,
    // SMC1
    rstn_non_srpg_smc1,
    gate_clk_smc1,
    isolate_smc1,
    save_edge_smc1,
    restore_edge_smc1,
    pwr1_on_smc1,
    pwr2_on_smc1,
    pwr1_off_smc1,
    pwr2_off_smc1,
    // URT1
    rstn_non_srpg_urt1,
    gate_clk_urt1,
    isolate_urt1,
    save_edge_urt1,
    restore_edge_urt1,
    pwr1_on_urt1,
    pwr2_on_urt1,
    pwr1_off_urt1,      
    pwr2_off_urt1,
    // ETH01
    rstn_non_srpg_macb01,
    gate_clk_macb01,
    isolate_macb01,
    save_edge_macb01,
    restore_edge_macb01,
    pwr1_on_macb01,
    pwr2_on_macb01,
    pwr1_off_macb01,      
    pwr2_off_macb01,
    // ETH11
    rstn_non_srpg_macb11,
    gate_clk_macb11,
    isolate_macb11,
    save_edge_macb11,
    restore_edge_macb11,
    pwr1_on_macb11,
    pwr2_on_macb11,
    pwr1_off_macb11,      
    pwr2_off_macb11,
    // ETH21
    rstn_non_srpg_macb21,
    gate_clk_macb21,
    isolate_macb21,
    save_edge_macb21,
    restore_edge_macb21,
    pwr1_on_macb21,
    pwr2_on_macb21,
    pwr1_off_macb21,      
    pwr2_off_macb21,
    // ETH31
    rstn_non_srpg_macb31,
    gate_clk_macb31,
    isolate_macb31,
    save_edge_macb31,
    restore_edge_macb31,
    pwr1_on_macb31,
    pwr2_on_macb31,
    pwr1_off_macb31,      
    pwr2_off_macb31,
    // DMA1
    rstn_non_srpg_dma1,
    gate_clk_dma1,
    isolate_dma1,
    save_edge_dma1,
    restore_edge_dma1,
    pwr1_on_dma1,
    pwr2_on_dma1,
    pwr1_off_dma1,      
    pwr2_off_dma1,
    // CPU1
    rstn_non_srpg_cpu1,
    gate_clk_cpu1,
    isolate_cpu1,
    save_edge_cpu1,
    restore_edge_cpu1,
    pwr1_on_cpu1,
    pwr2_on_cpu1,
    pwr1_off_cpu1,      
    pwr2_off_cpu1,
    // ALUT1
    rstn_non_srpg_alut1,
    gate_clk_alut1,
    isolate_alut1,
    save_edge_alut1,
    restore_edge_alut1,
    pwr1_on_alut1,
    pwr2_on_alut1,
    pwr1_off_alut1,      
    pwr2_off_alut1,
    // MEM1
    rstn_non_srpg_mem1,
    gate_clk_mem1,
    isolate_mem1,
    save_edge_mem1,
    restore_edge_mem1,
    pwr1_on_mem1,
    pwr2_on_mem1,
    pwr1_off_mem1,      
    pwr2_off_mem1,
    // core1 dvfs1 transitions1
    core06v1,
    core08v1,
    core10v1,
    core12v1,
    pcm_macb_wakeup_int1,
    // mte1 signals1
    mte_smc_start1,
    mte_uart_start1,
    mte_smc_uart_start1,  
    mte_pm_smc_to_default_start1, 
    mte_pm_uart_to_default_start1,
    mte_pm_smc_uart_to_default_start1

  );

  parameter STATE_IDLE_12V1 = 4'b0001;
  parameter STATE_06V1 = 4'b0010;
  parameter STATE_08V1 = 4'b0100;
  parameter STATE_10V1 = 4'b1000;

    // Clocks1 & Reset1
    input pclk1;
    input nprst1;
    // APB1 programming1 interface
    input [31:0] paddr1;
    input psel1  ;
    input penable1;
    input pwrite1 ;
    input [31:0] pwdata1;
    output [31:0] prdata1;
    // mac1
    input macb3_wakeup1;
    input macb2_wakeup1;
    input macb1_wakeup1;
    input macb0_wakeup1;
    // Scan1 
    input scan_in1;
    input scan_en1;
    input scan_mode1;
    output scan_out1;
    // Module1 control1 outputs1
    input int_source_h1;
    // SMC1
    output rstn_non_srpg_smc1 ;
    output gate_clk_smc1   ;
    output isolate_smc1   ;
    output save_edge_smc1   ;
    output restore_edge_smc1   ;
    output pwr1_on_smc1   ;
    output pwr2_on_smc1   ;
    output pwr1_off_smc1  ;
    output pwr2_off_smc1  ;
    // URT1
    output rstn_non_srpg_urt1 ;
    output gate_clk_urt1      ;
    output isolate_urt1       ;
    output save_edge_urt1   ;
    output restore_edge_urt1   ;
    output pwr1_on_urt1       ;
    output pwr2_on_urt1       ;
    output pwr1_off_urt1      ;
    output pwr2_off_urt1      ;
    // ETH01
    output rstn_non_srpg_macb01 ;
    output gate_clk_macb01      ;
    output isolate_macb01       ;
    output save_edge_macb01   ;
    output restore_edge_macb01   ;
    output pwr1_on_macb01       ;
    output pwr2_on_macb01       ;
    output pwr1_off_macb01      ;
    output pwr2_off_macb01      ;
    // ETH11
    output rstn_non_srpg_macb11 ;
    output gate_clk_macb11      ;
    output isolate_macb11       ;
    output save_edge_macb11   ;
    output restore_edge_macb11   ;
    output pwr1_on_macb11       ;
    output pwr2_on_macb11       ;
    output pwr1_off_macb11      ;
    output pwr2_off_macb11      ;
    // ETH21
    output rstn_non_srpg_macb21 ;
    output gate_clk_macb21      ;
    output isolate_macb21       ;
    output save_edge_macb21   ;
    output restore_edge_macb21   ;
    output pwr1_on_macb21       ;
    output pwr2_on_macb21       ;
    output pwr1_off_macb21      ;
    output pwr2_off_macb21      ;
    // ETH31
    output rstn_non_srpg_macb31 ;
    output gate_clk_macb31      ;
    output isolate_macb31       ;
    output save_edge_macb31   ;
    output restore_edge_macb31   ;
    output pwr1_on_macb31       ;
    output pwr2_on_macb31       ;
    output pwr1_off_macb31      ;
    output pwr2_off_macb31      ;
    // DMA1
    output rstn_non_srpg_dma1 ;
    output gate_clk_dma1      ;
    output isolate_dma1       ;
    output save_edge_dma1   ;
    output restore_edge_dma1   ;
    output pwr1_on_dma1       ;
    output pwr2_on_dma1       ;
    output pwr1_off_dma1      ;
    output pwr2_off_dma1      ;
    // CPU1
    output rstn_non_srpg_cpu1 ;
    output gate_clk_cpu1      ;
    output isolate_cpu1       ;
    output save_edge_cpu1   ;
    output restore_edge_cpu1   ;
    output pwr1_on_cpu1       ;
    output pwr2_on_cpu1       ;
    output pwr1_off_cpu1      ;
    output pwr2_off_cpu1      ;
    // ALUT1
    output rstn_non_srpg_alut1 ;
    output gate_clk_alut1      ;
    output isolate_alut1       ;
    output save_edge_alut1   ;
    output restore_edge_alut1   ;
    output pwr1_on_alut1       ;
    output pwr2_on_alut1       ;
    output pwr1_off_alut1      ;
    output pwr2_off_alut1      ;
    // MEM1
    output rstn_non_srpg_mem1 ;
    output gate_clk_mem1      ;
    output isolate_mem1       ;
    output save_edge_mem1   ;
    output restore_edge_mem1   ;
    output pwr1_on_mem1       ;
    output pwr2_on_mem1       ;
    output pwr1_off_mem1      ;
    output pwr2_off_mem1      ;


   // core1 transitions1 o/p
    output core06v1;
    output core08v1;
    output core10v1;
    output core12v1;
    output pcm_macb_wakeup_int1 ;
    //mode mte1  signals1
    output mte_smc_start1;
    output mte_uart_start1;
    output mte_smc_uart_start1;  
    output mte_pm_smc_to_default_start1; 
    output mte_pm_uart_to_default_start1;
    output mte_pm_smc_uart_to_default_start1;

    reg mte_smc_start1;
    reg mte_uart_start1;
    reg mte_smc_uart_start1;  
    reg mte_pm_smc_to_default_start1; 
    reg mte_pm_uart_to_default_start1;
    reg mte_pm_smc_uart_to_default_start1;

    reg [31:0] prdata1;

  wire valid_reg_write1  ;
  wire valid_reg_read1   ;
  wire L1_ctrl_access1   ;
  wire L1_status_access1 ;
  wire pcm_int_mask_access1;
  wire pcm_int_status_access1;
  wire standby_mem01      ;
  wire standby_mem11      ;
  wire standby_mem21      ;
  wire standby_mem31      ;
  wire pwr1_off_mem01;
  wire pwr1_off_mem11;
  wire pwr1_off_mem21;
  wire pwr1_off_mem31;
  
  // Control1 signals1
  wire set_status_smc1   ;
  wire clr_status_smc1   ;
  wire set_status_urt1   ;
  wire clr_status_urt1   ;
  wire set_status_macb01   ;
  wire clr_status_macb01   ;
  wire set_status_macb11   ;
  wire clr_status_macb11   ;
  wire set_status_macb21   ;
  wire clr_status_macb21   ;
  wire set_status_macb31   ;
  wire clr_status_macb31   ;
  wire set_status_dma1   ;
  wire clr_status_dma1   ;
  wire set_status_cpu1   ;
  wire clr_status_cpu1   ;
  wire set_status_alut1   ;
  wire clr_status_alut1   ;
  wire set_status_mem1   ;
  wire clr_status_mem1   ;


  // Status and Control1 registers
  reg [31:0]  L1_status_reg1;
  reg  [31:0] L1_ctrl_reg1  ;
  reg  [31:0] L1_ctrl_domain1  ;
  reg L1_ctrl_cpu_off_reg1;
  reg [31:0]  pcm_mask_reg1;
  reg [31:0]  pcm_status_reg1;

  // Signals1 gated1 in scan_mode1
  //SMC1
  wire  rstn_non_srpg_smc_int1;
  wire  gate_clk_smc_int1    ;     
  wire  isolate_smc_int1    ;       
  wire save_edge_smc_int1;
  wire restore_edge_smc_int1;
  wire  pwr1_on_smc_int1    ;      
  wire  pwr2_on_smc_int1    ;      


  //URT1
  wire   rstn_non_srpg_urt_int1;
  wire   gate_clk_urt_int1     ;     
  wire   isolate_urt_int1      ;       
  wire save_edge_urt_int1;
  wire restore_edge_urt_int1;
  wire   pwr1_on_urt_int1      ;      
  wire   pwr2_on_urt_int1      ;      

  // ETH01
  wire   rstn_non_srpg_macb0_int1;
  wire   gate_clk_macb0_int1     ;     
  wire   isolate_macb0_int1      ;       
  wire save_edge_macb0_int1;
  wire restore_edge_macb0_int1;
  wire   pwr1_on_macb0_int1      ;      
  wire   pwr2_on_macb0_int1      ;      
  // ETH11
  wire   rstn_non_srpg_macb1_int1;
  wire   gate_clk_macb1_int1     ;     
  wire   isolate_macb1_int1      ;       
  wire save_edge_macb1_int1;
  wire restore_edge_macb1_int1;
  wire   pwr1_on_macb1_int1      ;      
  wire   pwr2_on_macb1_int1      ;      
  // ETH21
  wire   rstn_non_srpg_macb2_int1;
  wire   gate_clk_macb2_int1     ;     
  wire   isolate_macb2_int1      ;       
  wire save_edge_macb2_int1;
  wire restore_edge_macb2_int1;
  wire   pwr1_on_macb2_int1      ;      
  wire   pwr2_on_macb2_int1      ;      
  // ETH31
  wire   rstn_non_srpg_macb3_int1;
  wire   gate_clk_macb3_int1     ;     
  wire   isolate_macb3_int1      ;       
  wire save_edge_macb3_int1;
  wire restore_edge_macb3_int1;
  wire   pwr1_on_macb3_int1      ;      
  wire   pwr2_on_macb3_int1      ;      

  // DMA1
  wire   rstn_non_srpg_dma_int1;
  wire   gate_clk_dma_int1     ;     
  wire   isolate_dma_int1      ;       
  wire save_edge_dma_int1;
  wire restore_edge_dma_int1;
  wire   pwr1_on_dma_int1      ;      
  wire   pwr2_on_dma_int1      ;      

  // CPU1
  wire   rstn_non_srpg_cpu_int1;
  wire   gate_clk_cpu_int1     ;     
  wire   isolate_cpu_int1      ;       
  wire save_edge_cpu_int1;
  wire restore_edge_cpu_int1;
  wire   pwr1_on_cpu_int1      ;      
  wire   pwr2_on_cpu_int1      ;  
  wire L1_ctrl_cpu_off_p1;    

  reg save_alut_tmp1;
  // DFS1 sm1

  reg cpu_shutoff_ctrl1;

  reg mte_mac_off_start1, mte_mac012_start1, mte_mac013_start1, mte_mac023_start1, mte_mac123_start1;
  reg mte_mac01_start1, mte_mac02_start1, mte_mac03_start1, mte_mac12_start1, mte_mac13_start1, mte_mac23_start1;
  reg mte_mac0_start1, mte_mac1_start1, mte_mac2_start1, mte_mac3_start1;
  reg mte_sys_hibernate1 ;
  reg mte_dma_start1 ;
  reg mte_cpu_start1 ;
  reg mte_mac_off_sleep_start1, mte_mac012_sleep_start1, mte_mac013_sleep_start1, mte_mac023_sleep_start1, mte_mac123_sleep_start1;
  reg mte_mac01_sleep_start1, mte_mac02_sleep_start1, mte_mac03_sleep_start1, mte_mac12_sleep_start1, mte_mac13_sleep_start1, mte_mac23_sleep_start1;
  reg mte_mac0_sleep_start1, mte_mac1_sleep_start1, mte_mac2_sleep_start1, mte_mac3_sleep_start1;
  reg mte_dma_sleep_start1;
  reg mte_mac_off_to_default1, mte_mac012_to_default1, mte_mac013_to_default1, mte_mac023_to_default1, mte_mac123_to_default1;
  reg mte_mac01_to_default1, mte_mac02_to_default1, mte_mac03_to_default1, mte_mac12_to_default1, mte_mac13_to_default1, mte_mac23_to_default1;
  reg mte_mac0_to_default1, mte_mac1_to_default1, mte_mac2_to_default1, mte_mac3_to_default1;
  reg mte_dma_isolate_dis1;
  reg mte_cpu_isolate_dis1;
  reg mte_sys_hibernate_to_default1;


  // Latch1 the CPU1 SLEEP1 invocation1
  always @( posedge pclk1 or negedge nprst1) 
  begin
    if(!nprst1)
      L1_ctrl_cpu_off_reg1 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg1 <= L1_ctrl_domain1[8];
  end

  // Create1 a pulse1 for sleep1 detection1 
  assign L1_ctrl_cpu_off_p1 =  L1_ctrl_domain1[8] && !L1_ctrl_cpu_off_reg1;
  
  // CPU1 sleep1 contol1 logic 
  // Shut1 off1 CPU1 when L1_ctrl_cpu_off_p1 is set
  // wake1 cpu1 when any interrupt1 is seen1  
  always @( posedge pclk1 or negedge nprst1) 
  begin
    if(!nprst1)
     cpu_shutoff_ctrl1 <= 1'b0;
    else if(cpu_shutoff_ctrl1 && int_source_h1)
     cpu_shutoff_ctrl1 <= 1'b0;
    else if (L1_ctrl_cpu_off_p1)
     cpu_shutoff_ctrl1 <= 1'b1;
  end
 
  // instantiate1 power1 contol1  block for uart1
  power_ctrl_sm1 i_urt_power_ctrl_sm1(
    .pclk1(pclk1),
    .nprst1(nprst1),
    .L1_module_req1(L1_ctrl_domain1[1]),
    .set_status_module1(set_status_urt1),
    .clr_status_module1(clr_status_urt1),
    .rstn_non_srpg_module1(rstn_non_srpg_urt_int1),
    .gate_clk_module1(gate_clk_urt_int1),
    .isolate_module1(isolate_urt_int1),
    .save_edge1(save_edge_urt_int1),
    .restore_edge1(restore_edge_urt_int1),
    .pwr1_on1(pwr1_on_urt_int1),
    .pwr2_on1(pwr2_on_urt_int1)
    );
  

  // instantiate1 power1 contol1  block for smc1
  power_ctrl_sm1 i_smc_power_ctrl_sm1(
    .pclk1(pclk1),
    .nprst1(nprst1),
    .L1_module_req1(L1_ctrl_domain1[2]),
    .set_status_module1(set_status_smc1),
    .clr_status_module1(clr_status_smc1),
    .rstn_non_srpg_module1(rstn_non_srpg_smc_int1),
    .gate_clk_module1(gate_clk_smc_int1),
    .isolate_module1(isolate_smc_int1),
    .save_edge1(save_edge_smc_int1),
    .restore_edge1(restore_edge_smc_int1),
    .pwr1_on1(pwr1_on_smc_int1),
    .pwr2_on1(pwr2_on_smc_int1)
    );

  // power1 control1 for macb01
  power_ctrl_sm1 i_macb0_power_ctrl_sm1(
    .pclk1(pclk1),
    .nprst1(nprst1),
    .L1_module_req1(L1_ctrl_domain1[3]),
    .set_status_module1(set_status_macb01),
    .clr_status_module1(clr_status_macb01),
    .rstn_non_srpg_module1(rstn_non_srpg_macb0_int1),
    .gate_clk_module1(gate_clk_macb0_int1),
    .isolate_module1(isolate_macb0_int1),
    .save_edge1(save_edge_macb0_int1),
    .restore_edge1(restore_edge_macb0_int1),
    .pwr1_on1(pwr1_on_macb0_int1),
    .pwr2_on1(pwr2_on_macb0_int1)
    );
  // power1 control1 for macb11
  power_ctrl_sm1 i_macb1_power_ctrl_sm1(
    .pclk1(pclk1),
    .nprst1(nprst1),
    .L1_module_req1(L1_ctrl_domain1[4]),
    .set_status_module1(set_status_macb11),
    .clr_status_module1(clr_status_macb11),
    .rstn_non_srpg_module1(rstn_non_srpg_macb1_int1),
    .gate_clk_module1(gate_clk_macb1_int1),
    .isolate_module1(isolate_macb1_int1),
    .save_edge1(save_edge_macb1_int1),
    .restore_edge1(restore_edge_macb1_int1),
    .pwr1_on1(pwr1_on_macb1_int1),
    .pwr2_on1(pwr2_on_macb1_int1)
    );
  // power1 control1 for macb21
  power_ctrl_sm1 i_macb2_power_ctrl_sm1(
    .pclk1(pclk1),
    .nprst1(nprst1),
    .L1_module_req1(L1_ctrl_domain1[5]),
    .set_status_module1(set_status_macb21),
    .clr_status_module1(clr_status_macb21),
    .rstn_non_srpg_module1(rstn_non_srpg_macb2_int1),
    .gate_clk_module1(gate_clk_macb2_int1),
    .isolate_module1(isolate_macb2_int1),
    .save_edge1(save_edge_macb2_int1),
    .restore_edge1(restore_edge_macb2_int1),
    .pwr1_on1(pwr1_on_macb2_int1),
    .pwr2_on1(pwr2_on_macb2_int1)
    );
  // power1 control1 for macb31
  power_ctrl_sm1 i_macb3_power_ctrl_sm1(
    .pclk1(pclk1),
    .nprst1(nprst1),
    .L1_module_req1(L1_ctrl_domain1[6]),
    .set_status_module1(set_status_macb31),
    .clr_status_module1(clr_status_macb31),
    .rstn_non_srpg_module1(rstn_non_srpg_macb3_int1),
    .gate_clk_module1(gate_clk_macb3_int1),
    .isolate_module1(isolate_macb3_int1),
    .save_edge1(save_edge_macb3_int1),
    .restore_edge1(restore_edge_macb3_int1),
    .pwr1_on1(pwr1_on_macb3_int1),
    .pwr2_on1(pwr2_on_macb3_int1)
    );
  // power1 control1 for dma1
  power_ctrl_sm1 i_dma_power_ctrl_sm1(
    .pclk1(pclk1),
    .nprst1(nprst1),
    .L1_module_req1(L1_ctrl_domain1[7]),
    .set_status_module1(set_status_dma1),
    .clr_status_module1(clr_status_dma1),
    .rstn_non_srpg_module1(rstn_non_srpg_dma_int1),
    .gate_clk_module1(gate_clk_dma_int1),
    .isolate_module1(isolate_dma_int1),
    .save_edge1(save_edge_dma_int1),
    .restore_edge1(restore_edge_dma_int1),
    .pwr1_on1(pwr1_on_dma_int1),
    .pwr2_on1(pwr2_on_dma_int1)
    );
  // power1 control1 for CPU1
  power_ctrl_sm1 i_cpu_power_ctrl_sm1(
    .pclk1(pclk1),
    .nprst1(nprst1),
    .L1_module_req1(cpu_shutoff_ctrl1),
    .set_status_module1(set_status_cpu1),
    .clr_status_module1(clr_status_cpu1),
    .rstn_non_srpg_module1(rstn_non_srpg_cpu_int1),
    .gate_clk_module1(gate_clk_cpu_int1),
    .isolate_module1(isolate_cpu_int1),
    .save_edge1(save_edge_cpu_int1),
    .restore_edge1(restore_edge_cpu_int1),
    .pwr1_on1(pwr1_on_cpu_int1),
    .pwr2_on1(pwr2_on_cpu_int1)
    );

  assign valid_reg_write1 =  (psel1 && pwrite1 && penable1);
  assign valid_reg_read1  =  (psel1 && (!pwrite1) && penable1);

  assign L1_ctrl_access1  =  (paddr1[15:0] == 16'b0000000000000100); 
  assign L1_status_access1 = (paddr1[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access1 =   (paddr1[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access1 = (paddr1[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control1 and status register
  always @(*)
  begin  
    if(valid_reg_read1 && L1_ctrl_access1) 
      prdata1 = L1_ctrl_reg1;
    else if (valid_reg_read1 && L1_status_access1)
      prdata1 = L1_status_reg1;
    else if (valid_reg_read1 && pcm_int_mask_access1)
      prdata1 = pcm_mask_reg1;
    else if (valid_reg_read1 && pcm_int_status_access1)
      prdata1 = pcm_status_reg1;
    else 
      prdata1 = 0;
  end

  assign set_status_mem1 =  (set_status_macb01 && set_status_macb11 && set_status_macb21 &&
                            set_status_macb31 && set_status_dma1 && set_status_cpu1);

  assign clr_status_mem1 =  (clr_status_macb01 && clr_status_macb11 && clr_status_macb21 &&
                            clr_status_macb31 && clr_status_dma1 && clr_status_cpu1);

  assign set_status_alut1 = (set_status_macb01 && set_status_macb11 && set_status_macb21 && set_status_macb31);

  assign clr_status_alut1 = (clr_status_macb01 || clr_status_macb11 || clr_status_macb21  || clr_status_macb31);

  // Write accesses to the control1 and status register
 
  always @(posedge pclk1 or negedge nprst1)
  begin
    if (!nprst1) begin
      L1_ctrl_reg1   <= 0;
      L1_status_reg1 <= 0;
      pcm_mask_reg1 <= 0;
    end else begin
      // CTRL1 reg updates1
      if (valid_reg_write1 && L1_ctrl_access1) 
        L1_ctrl_reg1 <= pwdata1; // Writes1 to the ctrl1 reg
      if (valid_reg_write1 && pcm_int_mask_access1) 
        pcm_mask_reg1 <= pwdata1; // Writes1 to the ctrl1 reg

      if (set_status_urt1 == 1'b1)  
        L1_status_reg1[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt1 == 1'b1) 
        L1_status_reg1[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc1 == 1'b1) 
        L1_status_reg1[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc1 == 1'b1) 
        L1_status_reg1[2] <= 1'b0; // Clear the status bit

      if (set_status_macb01 == 1'b1)  
        L1_status_reg1[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb01 == 1'b1) 
        L1_status_reg1[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb11 == 1'b1)  
        L1_status_reg1[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb11 == 1'b1) 
        L1_status_reg1[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb21 == 1'b1)  
        L1_status_reg1[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb21 == 1'b1) 
        L1_status_reg1[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb31 == 1'b1)  
        L1_status_reg1[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb31 == 1'b1) 
        L1_status_reg1[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma1 == 1'b1)  
        L1_status_reg1[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma1 == 1'b1) 
        L1_status_reg1[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu1 == 1'b1)  
        L1_status_reg1[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu1 == 1'b1) 
        L1_status_reg1[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut1 == 1'b1)  
        L1_status_reg1[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut1 == 1'b1) 
        L1_status_reg1[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem1 == 1'b1)  
        L1_status_reg1[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem1 == 1'b1) 
        L1_status_reg1[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused1 bits of pcm_status_reg1 are tied1 to 0
  always @(posedge pclk1 or negedge nprst1)
  begin
    if (!nprst1)
      pcm_status_reg1[31:4] <= 'b0;
    else  
      pcm_status_reg1[31:4] <= pcm_status_reg1[31:4];
  end
  
  // interrupt1 only of h/w assisted1 wakeup
  // MAC1 3
  always @(posedge pclk1 or negedge nprst1)
  begin
    if(!nprst1)
      pcm_status_reg1[3] <= 1'b0;
    else if (valid_reg_write1 && pcm_int_status_access1) 
      pcm_status_reg1[3] <= pwdata1[3];
    else if (macb3_wakeup1 & ~pcm_mask_reg1[3])
      pcm_status_reg1[3] <= 1'b1;
    else if (valid_reg_read1 && pcm_int_status_access1) 
      pcm_status_reg1[3] <= 1'b0;
    else
      pcm_status_reg1[3] <= pcm_status_reg1[3];
  end  
   
  // MAC1 2
  always @(posedge pclk1 or negedge nprst1)
  begin
    if(!nprst1)
      pcm_status_reg1[2] <= 1'b0;
    else if (valid_reg_write1 && pcm_int_status_access1) 
      pcm_status_reg1[2] <= pwdata1[2];
    else if (macb2_wakeup1 & ~pcm_mask_reg1[2])
      pcm_status_reg1[2] <= 1'b1;
    else if (valid_reg_read1 && pcm_int_status_access1) 
      pcm_status_reg1[2] <= 1'b0;
    else
      pcm_status_reg1[2] <= pcm_status_reg1[2];
  end  

  // MAC1 1
  always @(posedge pclk1 or negedge nprst1)
  begin
    if(!nprst1)
      pcm_status_reg1[1] <= 1'b0;
    else if (valid_reg_write1 && pcm_int_status_access1) 
      pcm_status_reg1[1] <= pwdata1[1];
    else if (macb1_wakeup1 & ~pcm_mask_reg1[1])
      pcm_status_reg1[1] <= 1'b1;
    else if (valid_reg_read1 && pcm_int_status_access1) 
      pcm_status_reg1[1] <= 1'b0;
    else
      pcm_status_reg1[1] <= pcm_status_reg1[1];
  end  
   
  // MAC1 0
  always @(posedge pclk1 or negedge nprst1)
  begin
    if(!nprst1)
      pcm_status_reg1[0] <= 1'b0;
    else if (valid_reg_write1 && pcm_int_status_access1) 
      pcm_status_reg1[0] <= pwdata1[0];
    else if (macb0_wakeup1 & ~pcm_mask_reg1[0])
      pcm_status_reg1[0] <= 1'b1;
    else if (valid_reg_read1 && pcm_int_status_access1) 
      pcm_status_reg1[0] <= 1'b0;
    else
      pcm_status_reg1[0] <= pcm_status_reg1[0];
  end  

  assign pcm_macb_wakeup_int1 = |pcm_status_reg1;

  reg [31:0] L1_ctrl_reg11;
  always @(posedge pclk1 or negedge nprst1)
  begin
    if(!nprst1)
      L1_ctrl_reg11 <= 0;
    else
      L1_ctrl_reg11 <= L1_ctrl_reg1;
  end

  // Program1 mode decode
  always @(L1_ctrl_reg1 or L1_ctrl_reg11 or int_source_h1 or cpu_shutoff_ctrl1) begin
    mte_smc_start1 = 0;
    mte_uart_start1 = 0;
    mte_smc_uart_start1  = 0;
    mte_mac_off_start1  = 0;
    mte_mac012_start1 = 0;
    mte_mac013_start1 = 0;
    mte_mac023_start1 = 0;
    mte_mac123_start1 = 0;
    mte_mac01_start1 = 0;
    mte_mac02_start1 = 0;
    mte_mac03_start1 = 0;
    mte_mac12_start1 = 0;
    mte_mac13_start1 = 0;
    mte_mac23_start1 = 0;
    mte_mac0_start1 = 0;
    mte_mac1_start1 = 0;
    mte_mac2_start1 = 0;
    mte_mac3_start1 = 0;
    mte_sys_hibernate1 = 0 ;
    mte_dma_start1 = 0 ;
    mte_cpu_start1 = 0 ;

    mte_mac0_sleep_start1 = (L1_ctrl_reg1 ==  'h14) && (L1_ctrl_reg11 == 'h4 );
    mte_mac1_sleep_start1 = (L1_ctrl_reg1 ==  'h14) && (L1_ctrl_reg11 == 'h5 ); 
    mte_mac2_sleep_start1 = (L1_ctrl_reg1 ==  'h14) && (L1_ctrl_reg11 == 'h6 ); 
    mte_mac3_sleep_start1 = (L1_ctrl_reg1 ==  'h14) && (L1_ctrl_reg11 == 'h7 ); 
    mte_mac01_sleep_start1 = (L1_ctrl_reg1 ==  'h14) && (L1_ctrl_reg11 == 'h8 ); 
    mte_mac02_sleep_start1 = (L1_ctrl_reg1 ==  'h14) && (L1_ctrl_reg11 == 'h9 ); 
    mte_mac03_sleep_start1 = (L1_ctrl_reg1 ==  'h14) && (L1_ctrl_reg11 == 'hA ); 
    mte_mac12_sleep_start1 = (L1_ctrl_reg1 ==  'h14) && (L1_ctrl_reg11 == 'hB ); 
    mte_mac13_sleep_start1 = (L1_ctrl_reg1 ==  'h14) && (L1_ctrl_reg11 == 'hC ); 
    mte_mac23_sleep_start1 = (L1_ctrl_reg1 ==  'h14) && (L1_ctrl_reg11 == 'hD ); 
    mte_mac012_sleep_start1 = (L1_ctrl_reg1 ==  'h14) && (L1_ctrl_reg11 == 'hE ); 
    mte_mac013_sleep_start1 = (L1_ctrl_reg1 ==  'h14) && (L1_ctrl_reg11 == 'hF ); 
    mte_mac023_sleep_start1 = (L1_ctrl_reg1 ==  'h14) && (L1_ctrl_reg11 == 'h10 ); 
    mte_mac123_sleep_start1 = (L1_ctrl_reg1 ==  'h14) && (L1_ctrl_reg11 == 'h11 ); 
    mte_mac_off_sleep_start1 =  (L1_ctrl_reg1 == 'h14) && (L1_ctrl_reg11 == 'h12 );
    mte_dma_sleep_start1 =  (L1_ctrl_reg1 == 'h14) && (L1_ctrl_reg11 == 'h13 );

    mte_pm_uart_to_default_start1 = (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'h1);
    mte_pm_smc_to_default_start1 = (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'h2);
    mte_pm_smc_uart_to_default_start1 = (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'h3); 
    mte_mac0_to_default1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'h4); 
    mte_mac1_to_default1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'h5); 
    mte_mac2_to_default1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'h6); 
    mte_mac3_to_default1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'h7); 
    mte_mac01_to_default1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'h8); 
    mte_mac02_to_default1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'h9); 
    mte_mac03_to_default1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'hA); 
    mte_mac12_to_default1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'hB); 
    mte_mac13_to_default1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'hC); 
    mte_mac23_to_default1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'hD); 
    mte_mac012_to_default1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'hE); 
    mte_mac013_to_default1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'hF); 
    mte_mac023_to_default1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'h10); 
    mte_mac123_to_default1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'h11); 
    mte_mac_off_to_default1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'h12); 
    mte_dma_isolate_dis1 =  (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'h13); 
    mte_cpu_isolate_dis1 =  (int_source_h1) && (cpu_shutoff_ctrl1) && (L1_ctrl_reg1 != 'h15);
    mte_sys_hibernate_to_default1 = (L1_ctrl_reg1 == 32'h0) && (L1_ctrl_reg11 == 'h15); 

   
    if (L1_ctrl_reg11 == 'h0) begin // This1 check is to make mte_cpu_start1
                                   // is set only when you from default state 
      case (L1_ctrl_reg1)
        'h0 : L1_ctrl_domain1 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain1 = 32'h2; // PM_uart1
                mte_uart_start1 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain1 = 32'h4; // PM_smc1
                mte_smc_start1 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain1 = 32'h6; // PM_smc_uart1
                mte_smc_uart_start1 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain1 = 32'h8; //  PM_macb01
                mte_mac0_start1 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain1 = 32'h10; //  PM_macb11
                mte_mac1_start1 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain1 = 32'h20; //  PM_macb21
                mte_mac2_start1 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain1 = 32'h40; //  PM_macb31
                mte_mac3_start1 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain1 = 32'h18; //  PM_macb011
                mte_mac01_start1 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain1 = 32'h28; //  PM_macb021
                mte_mac02_start1 = 1;
              end
        'hA : begin  
                L1_ctrl_domain1 = 32'h48; //  PM_macb031
                mte_mac03_start1 = 1;
              end
        'hB : begin  
                L1_ctrl_domain1 = 32'h30; //  PM_macb121
                mte_mac12_start1 = 1;
              end
        'hC : begin  
                L1_ctrl_domain1 = 32'h50; //  PM_macb131
                mte_mac13_start1 = 1;
              end
        'hD : begin  
                L1_ctrl_domain1 = 32'h60; //  PM_macb231
                mte_mac23_start1 = 1;
              end
        'hE : begin  
                L1_ctrl_domain1 = 32'h38; //  PM_macb0121
                mte_mac012_start1 = 1;
              end
        'hF : begin  
                L1_ctrl_domain1 = 32'h58; //  PM_macb0131
                mte_mac013_start1 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain1 = 32'h68; //  PM_macb0231
                mte_mac023_start1 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain1 = 32'h70; //  PM_macb1231
                mte_mac123_start1 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain1 = 32'h78; //  PM_macb_off1
                mte_mac_off_start1 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain1 = 32'h80; //  PM_dma1
                mte_dma_start1 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain1 = 32'h100; //  PM_cpu_sleep1
                mte_cpu_start1 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain1 = 32'h1FE; //  PM_hibernate1
                mte_sys_hibernate1 = 1;
              end
         default: L1_ctrl_domain1 = 32'h0;
      endcase
    end
  end


  wire to_default1 = (L1_ctrl_reg1 == 0);

  // Scan1 mode gating1 of power1 and isolation1 control1 signals1
  //SMC1
  assign rstn_non_srpg_smc1  = (scan_mode1 == 1'b0) ? rstn_non_srpg_smc_int1 : 1'b1;  
  assign gate_clk_smc1       = (scan_mode1 == 1'b0) ? gate_clk_smc_int1 : 1'b0;     
  assign isolate_smc1        = (scan_mode1 == 1'b0) ? isolate_smc_int1 : 1'b0;      
  assign pwr1_on_smc1        = (scan_mode1 == 1'b0) ? pwr1_on_smc_int1 : 1'b1;       
  assign pwr2_on_smc1        = (scan_mode1 == 1'b0) ? pwr2_on_smc_int1 : 1'b1;       
  assign pwr1_off_smc1       = (scan_mode1 == 1'b0) ? (!pwr1_on_smc_int1) : 1'b0;       
  assign pwr2_off_smc1       = (scan_mode1 == 1'b0) ? (!pwr2_on_smc_int1) : 1'b0;       
  assign save_edge_smc1       = (scan_mode1 == 1'b0) ? (save_edge_smc_int1) : 1'b0;       
  assign restore_edge_smc1       = (scan_mode1 == 1'b0) ? (restore_edge_smc_int1) : 1'b0;       

  //URT1
  assign rstn_non_srpg_urt1  = (scan_mode1 == 1'b0) ?  rstn_non_srpg_urt_int1 : 1'b1;  
  assign gate_clk_urt1       = (scan_mode1 == 1'b0) ?  gate_clk_urt_int1      : 1'b0;     
  assign isolate_urt1        = (scan_mode1 == 1'b0) ?  isolate_urt_int1       : 1'b0;      
  assign pwr1_on_urt1        = (scan_mode1 == 1'b0) ?  pwr1_on_urt_int1       : 1'b1;       
  assign pwr2_on_urt1        = (scan_mode1 == 1'b0) ?  pwr2_on_urt_int1       : 1'b1;       
  assign pwr1_off_urt1       = (scan_mode1 == 1'b0) ?  (!pwr1_on_urt_int1)  : 1'b0;       
  assign pwr2_off_urt1       = (scan_mode1 == 1'b0) ?  (!pwr2_on_urt_int1)  : 1'b0;       
  assign save_edge_urt1       = (scan_mode1 == 1'b0) ? (save_edge_urt_int1) : 1'b0;       
  assign restore_edge_urt1       = (scan_mode1 == 1'b0) ? (restore_edge_urt_int1) : 1'b0;       

  //ETH01
  assign rstn_non_srpg_macb01 = (scan_mode1 == 1'b0) ?  rstn_non_srpg_macb0_int1 : 1'b1;  
  assign gate_clk_macb01       = (scan_mode1 == 1'b0) ?  gate_clk_macb0_int1      : 1'b0;     
  assign isolate_macb01        = (scan_mode1 == 1'b0) ?  isolate_macb0_int1       : 1'b0;      
  assign pwr1_on_macb01        = (scan_mode1 == 1'b0) ?  pwr1_on_macb0_int1       : 1'b1;       
  assign pwr2_on_macb01        = (scan_mode1 == 1'b0) ?  pwr2_on_macb0_int1       : 1'b1;       
  assign pwr1_off_macb01       = (scan_mode1 == 1'b0) ?  (!pwr1_on_macb0_int1)  : 1'b0;       
  assign pwr2_off_macb01       = (scan_mode1 == 1'b0) ?  (!pwr2_on_macb0_int1)  : 1'b0;       
  assign save_edge_macb01       = (scan_mode1 == 1'b0) ? (save_edge_macb0_int1) : 1'b0;       
  assign restore_edge_macb01       = (scan_mode1 == 1'b0) ? (restore_edge_macb0_int1) : 1'b0;       

  //ETH11
  assign rstn_non_srpg_macb11 = (scan_mode1 == 1'b0) ?  rstn_non_srpg_macb1_int1 : 1'b1;  
  assign gate_clk_macb11       = (scan_mode1 == 1'b0) ?  gate_clk_macb1_int1      : 1'b0;     
  assign isolate_macb11        = (scan_mode1 == 1'b0) ?  isolate_macb1_int1       : 1'b0;      
  assign pwr1_on_macb11        = (scan_mode1 == 1'b0) ?  pwr1_on_macb1_int1       : 1'b1;       
  assign pwr2_on_macb11        = (scan_mode1 == 1'b0) ?  pwr2_on_macb1_int1       : 1'b1;       
  assign pwr1_off_macb11       = (scan_mode1 == 1'b0) ?  (!pwr1_on_macb1_int1)  : 1'b0;       
  assign pwr2_off_macb11       = (scan_mode1 == 1'b0) ?  (!pwr2_on_macb1_int1)  : 1'b0;       
  assign save_edge_macb11       = (scan_mode1 == 1'b0) ? (save_edge_macb1_int1) : 1'b0;       
  assign restore_edge_macb11       = (scan_mode1 == 1'b0) ? (restore_edge_macb1_int1) : 1'b0;       

  //ETH21
  assign rstn_non_srpg_macb21 = (scan_mode1 == 1'b0) ?  rstn_non_srpg_macb2_int1 : 1'b1;  
  assign gate_clk_macb21       = (scan_mode1 == 1'b0) ?  gate_clk_macb2_int1      : 1'b0;     
  assign isolate_macb21        = (scan_mode1 == 1'b0) ?  isolate_macb2_int1       : 1'b0;      
  assign pwr1_on_macb21        = (scan_mode1 == 1'b0) ?  pwr1_on_macb2_int1       : 1'b1;       
  assign pwr2_on_macb21        = (scan_mode1 == 1'b0) ?  pwr2_on_macb2_int1       : 1'b1;       
  assign pwr1_off_macb21       = (scan_mode1 == 1'b0) ?  (!pwr1_on_macb2_int1)  : 1'b0;       
  assign pwr2_off_macb21       = (scan_mode1 == 1'b0) ?  (!pwr2_on_macb2_int1)  : 1'b0;       
  assign save_edge_macb21       = (scan_mode1 == 1'b0) ? (save_edge_macb2_int1) : 1'b0;       
  assign restore_edge_macb21       = (scan_mode1 == 1'b0) ? (restore_edge_macb2_int1) : 1'b0;       

  //ETH31
  assign rstn_non_srpg_macb31 = (scan_mode1 == 1'b0) ?  rstn_non_srpg_macb3_int1 : 1'b1;  
  assign gate_clk_macb31       = (scan_mode1 == 1'b0) ?  gate_clk_macb3_int1      : 1'b0;     
  assign isolate_macb31        = (scan_mode1 == 1'b0) ?  isolate_macb3_int1       : 1'b0;      
  assign pwr1_on_macb31        = (scan_mode1 == 1'b0) ?  pwr1_on_macb3_int1       : 1'b1;       
  assign pwr2_on_macb31        = (scan_mode1 == 1'b0) ?  pwr2_on_macb3_int1       : 1'b1;       
  assign pwr1_off_macb31       = (scan_mode1 == 1'b0) ?  (!pwr1_on_macb3_int1)  : 1'b0;       
  assign pwr2_off_macb31       = (scan_mode1 == 1'b0) ?  (!pwr2_on_macb3_int1)  : 1'b0;       
  assign save_edge_macb31       = (scan_mode1 == 1'b0) ? (save_edge_macb3_int1) : 1'b0;       
  assign restore_edge_macb31       = (scan_mode1 == 1'b0) ? (restore_edge_macb3_int1) : 1'b0;       

  // MEM1
  assign rstn_non_srpg_mem1 =   (rstn_non_srpg_macb01 && rstn_non_srpg_macb11 && rstn_non_srpg_macb21 &&
                                rstn_non_srpg_macb31 && rstn_non_srpg_dma1 && rstn_non_srpg_cpu1 && rstn_non_srpg_urt1 &&
                                rstn_non_srpg_smc1);

  assign gate_clk_mem1 =  (gate_clk_macb01 && gate_clk_macb11 && gate_clk_macb21 &&
                            gate_clk_macb31 && gate_clk_dma1 && gate_clk_cpu1 && gate_clk_urt1 && gate_clk_smc1);

  assign isolate_mem1  = (isolate_macb01 && isolate_macb11 && isolate_macb21 &&
                         isolate_macb31 && isolate_dma1 && isolate_cpu1 && isolate_urt1 && isolate_smc1);


  assign pwr1_on_mem1        =   ~pwr1_off_mem1;

  assign pwr2_on_mem1        =   ~pwr2_off_mem1;

  assign pwr1_off_mem1       =  (pwr1_off_macb01 && pwr1_off_macb11 && pwr1_off_macb21 &&
                                 pwr1_off_macb31 && pwr1_off_dma1 && pwr1_off_cpu1 && pwr1_off_urt1 && pwr1_off_smc1);


  assign pwr2_off_mem1       =  (pwr2_off_macb01 && pwr2_off_macb11 && pwr2_off_macb21 &&
                                pwr2_off_macb31 && pwr2_off_dma1 && pwr2_off_cpu1 && pwr2_off_urt1 && pwr2_off_smc1);

  assign save_edge_mem1      =  (save_edge_macb01 && save_edge_macb11 && save_edge_macb21 &&
                                save_edge_macb31 && save_edge_dma1 && save_edge_cpu1 && save_edge_smc1 && save_edge_urt1);

  assign restore_edge_mem1   =  (restore_edge_macb01 && restore_edge_macb11 && restore_edge_macb21  &&
                                restore_edge_macb31 && restore_edge_dma1 && restore_edge_cpu1 && restore_edge_urt1 &&
                                restore_edge_smc1);

  assign standby_mem01 = pwr1_off_macb01 && (~ (pwr1_off_macb01 && pwr1_off_macb11 && pwr1_off_macb21 && pwr1_off_macb31 && pwr1_off_urt1 && pwr1_off_smc1 && pwr1_off_dma1 && pwr1_off_cpu1));
  assign standby_mem11 = pwr1_off_macb11 && (~ (pwr1_off_macb01 && pwr1_off_macb11 && pwr1_off_macb21 && pwr1_off_macb31 && pwr1_off_urt1 && pwr1_off_smc1 && pwr1_off_dma1 && pwr1_off_cpu1));
  assign standby_mem21 = pwr1_off_macb21 && (~ (pwr1_off_macb01 && pwr1_off_macb11 && pwr1_off_macb21 && pwr1_off_macb31 && pwr1_off_urt1 && pwr1_off_smc1 && pwr1_off_dma1 && pwr1_off_cpu1));
  assign standby_mem31 = pwr1_off_macb31 && (~ (pwr1_off_macb01 && pwr1_off_macb11 && pwr1_off_macb21 && pwr1_off_macb31 && pwr1_off_urt1 && pwr1_off_smc1 && pwr1_off_dma1 && pwr1_off_cpu1));

  assign pwr1_off_mem01 = pwr1_off_mem1;
  assign pwr1_off_mem11 = pwr1_off_mem1;
  assign pwr1_off_mem21 = pwr1_off_mem1;
  assign pwr1_off_mem31 = pwr1_off_mem1;

  assign rstn_non_srpg_alut1  =  (rstn_non_srpg_macb01 && rstn_non_srpg_macb11 && rstn_non_srpg_macb21 && rstn_non_srpg_macb31);


   assign gate_clk_alut1       =  (gate_clk_macb01 && gate_clk_macb11 && gate_clk_macb21 && gate_clk_macb31);


    assign isolate_alut1        =  (isolate_macb01 && isolate_macb11 && isolate_macb21 && isolate_macb31);


    assign pwr1_on_alut1        =  (pwr1_on_macb01 || pwr1_on_macb11 || pwr1_on_macb21 || pwr1_on_macb31);


    assign pwr2_on_alut1        =  (pwr2_on_macb01 || pwr2_on_macb11 || pwr2_on_macb21 || pwr2_on_macb31);


    assign pwr1_off_alut1       =  (pwr1_off_macb01 && pwr1_off_macb11 && pwr1_off_macb21 && pwr1_off_macb31);


    assign pwr2_off_alut1       =  (pwr2_off_macb01 && pwr2_off_macb11 && pwr2_off_macb21 && pwr2_off_macb31);


    assign save_edge_alut1      =  (save_edge_macb01 && save_edge_macb11 && save_edge_macb21 && save_edge_macb31);


    assign restore_edge_alut1   =  (restore_edge_macb01 || restore_edge_macb11 || restore_edge_macb21 ||
                                   restore_edge_macb31) && save_alut_tmp1;

     // alut1 power1 off1 detection1
  always @(posedge pclk1 or negedge nprst1) begin
    if (!nprst1) 
       save_alut_tmp1 <= 0;
    else if (restore_edge_alut1)
       save_alut_tmp1 <= 0;
    else if (save_edge_alut1)
       save_alut_tmp1 <= 1;
  end

  //DMA1
  assign rstn_non_srpg_dma1 = (scan_mode1 == 1'b0) ?  rstn_non_srpg_dma_int1 : 1'b1;  
  assign gate_clk_dma1       = (scan_mode1 == 1'b0) ?  gate_clk_dma_int1      : 1'b0;     
  assign isolate_dma1        = (scan_mode1 == 1'b0) ?  isolate_dma_int1       : 1'b0;      
  assign pwr1_on_dma1        = (scan_mode1 == 1'b0) ?  pwr1_on_dma_int1       : 1'b1;       
  assign pwr2_on_dma1        = (scan_mode1 == 1'b0) ?  pwr2_on_dma_int1       : 1'b1;       
  assign pwr1_off_dma1       = (scan_mode1 == 1'b0) ?  (!pwr1_on_dma_int1)  : 1'b0;       
  assign pwr2_off_dma1       = (scan_mode1 == 1'b0) ?  (!pwr2_on_dma_int1)  : 1'b0;       
  assign save_edge_dma1       = (scan_mode1 == 1'b0) ? (save_edge_dma_int1) : 1'b0;       
  assign restore_edge_dma1       = (scan_mode1 == 1'b0) ? (restore_edge_dma_int1) : 1'b0;       

  //CPU1
  assign rstn_non_srpg_cpu1 = (scan_mode1 == 1'b0) ?  rstn_non_srpg_cpu_int1 : 1'b1;  
  assign gate_clk_cpu1       = (scan_mode1 == 1'b0) ?  gate_clk_cpu_int1      : 1'b0;     
  assign isolate_cpu1        = (scan_mode1 == 1'b0) ?  isolate_cpu_int1       : 1'b0;      
  assign pwr1_on_cpu1        = (scan_mode1 == 1'b0) ?  pwr1_on_cpu_int1       : 1'b1;       
  assign pwr2_on_cpu1        = (scan_mode1 == 1'b0) ?  pwr2_on_cpu_int1       : 1'b1;       
  assign pwr1_off_cpu1       = (scan_mode1 == 1'b0) ?  (!pwr1_on_cpu_int1)  : 1'b0;       
  assign pwr2_off_cpu1       = (scan_mode1 == 1'b0) ?  (!pwr2_on_cpu_int1)  : 1'b0;       
  assign save_edge_cpu1       = (scan_mode1 == 1'b0) ? (save_edge_cpu_int1) : 1'b0;       
  assign restore_edge_cpu1       = (scan_mode1 == 1'b0) ? (restore_edge_cpu_int1) : 1'b0;       



  // ASE1

   reg ase_core_12v1, ase_core_10v1, ase_core_08v1, ase_core_06v1;
   reg ase_macb0_12v1,ase_macb1_12v1,ase_macb2_12v1,ase_macb3_12v1;

    // core1 ase1

    // core1 at 1.0 v if (smc1 off1, urt1 off1, macb01 off1, macb11 off1, macb21 off1, macb31 off1
   // core1 at 0.8v if (mac01off1, macb02off1, macb03off1, macb12off1, mac13off1, mac23off1,
   // core1 at 0.6v if (mac012off1, mac013off1, mac023off1, mac123off1, mac0123off1
    // else core1 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb01 && pwr1_off_macb11 && pwr1_off_macb21 && pwr1_off_macb31) || // all mac1 off1
       (pwr1_off_macb31 && pwr1_off_macb21 && pwr1_off_macb11) || // mac123off1 
       (pwr1_off_macb31 && pwr1_off_macb21 && pwr1_off_macb01) || // mac023off1 
       (pwr1_off_macb31 && pwr1_off_macb11 && pwr1_off_macb01) || // mac013off1 
       (pwr1_off_macb21 && pwr1_off_macb11 && pwr1_off_macb01) )  // mac012off1 
       begin
         ase_core_12v1 = 0;
         ase_core_10v1 = 0;
         ase_core_08v1 = 0;
         ase_core_06v1 = 1;
       end
     else if( (pwr1_off_macb21 && pwr1_off_macb31) || // mac231 off1
         (pwr1_off_macb31 && pwr1_off_macb11) || // mac13off1 
         (pwr1_off_macb11 && pwr1_off_macb21) || // mac12off1 
         (pwr1_off_macb31 && pwr1_off_macb01) || // mac03off1 
         (pwr1_off_macb21 && pwr1_off_macb01) || // mac02off1 
         (pwr1_off_macb11 && pwr1_off_macb01))  // mac01off1 
       begin
         ase_core_12v1 = 0;
         ase_core_10v1 = 0;
         ase_core_08v1 = 1;
         ase_core_06v1 = 0;
       end
     else if( (pwr1_off_smc1) || // smc1 off1
         (pwr1_off_macb01 ) || // mac0off1 
         (pwr1_off_macb11 ) || // mac1off1 
         (pwr1_off_macb21 ) || // mac2off1 
         (pwr1_off_macb31 ))  // mac3off1 
       begin
         ase_core_12v1 = 0;
         ase_core_10v1 = 1;
         ase_core_08v1 = 0;
         ase_core_06v1 = 0;
       end
     else if (pwr1_off_urt1)
       begin
         ase_core_12v1 = 1;
         ase_core_10v1 = 0;
         ase_core_08v1 = 0;
         ase_core_06v1 = 0;
       end
     else
       begin
         ase_core_12v1 = 1;
         ase_core_10v1 = 0;
         ase_core_08v1 = 0;
         ase_core_06v1 = 0;
       end
   end


   // cpu1
   // cpu1 @ 1.0v when macoff1, 
   // 
   reg ase_cpu_10v1, ase_cpu_12v1;
   always @(*) begin
    if(pwr1_off_cpu1) begin
     ase_cpu_12v1 = 1'b0;
     ase_cpu_10v1 = 1'b0;
    end
    else if(pwr1_off_macb01 || pwr1_off_macb11 || pwr1_off_macb21 || pwr1_off_macb31)
    begin
     ase_cpu_12v1 = 1'b0;
     ase_cpu_10v1 = 1'b1;
    end
    else
    begin
     ase_cpu_12v1 = 1'b1;
     ase_cpu_10v1 = 1'b0;
    end
   end

   // dma1
   // dma1 @v11.0 for macoff1, 

   reg ase_dma_10v1, ase_dma_12v1;
   always @(*) begin
    if(pwr1_off_dma1) begin
     ase_dma_12v1 = 1'b0;
     ase_dma_10v1 = 1'b0;
    end
    else if(pwr1_off_macb01 || pwr1_off_macb11 || pwr1_off_macb21 || pwr1_off_macb31)
    begin
     ase_dma_12v1 = 1'b0;
     ase_dma_10v1 = 1'b1;
    end
    else
    begin
     ase_dma_12v1 = 1'b1;
     ase_dma_10v1 = 1'b0;
    end
   end

   // alut1
   // @ v11.0 for macoff1

   reg ase_alut_10v1, ase_alut_12v1;
   always @(*) begin
    if(pwr1_off_alut1) begin
     ase_alut_12v1 = 1'b0;
     ase_alut_10v1 = 1'b0;
    end
    else if(pwr1_off_macb01 || pwr1_off_macb11 || pwr1_off_macb21 || pwr1_off_macb31)
    begin
     ase_alut_12v1 = 1'b0;
     ase_alut_10v1 = 1'b1;
    end
    else
    begin
     ase_alut_12v1 = 1'b1;
     ase_alut_10v1 = 1'b0;
    end
   end




   reg ase_uart_12v1;
   reg ase_uart_10v1;
   reg ase_uart_08v1;
   reg ase_uart_06v1;

   reg ase_smc_12v1;


   always @(*) begin
     if(pwr1_off_urt1) begin // uart1 off1
       ase_uart_08v1 = 1'b0;
       ase_uart_06v1 = 1'b0;
       ase_uart_10v1 = 1'b0;
       ase_uart_12v1 = 1'b0;
     end 
     else if( (pwr1_off_macb01 && pwr1_off_macb11 && pwr1_off_macb21 && pwr1_off_macb31) || // all mac1 off1
       (pwr1_off_macb31 && pwr1_off_macb21 && pwr1_off_macb11) || // mac123off1 
       (pwr1_off_macb31 && pwr1_off_macb21 && pwr1_off_macb01) || // mac023off1 
       (pwr1_off_macb31 && pwr1_off_macb11 && pwr1_off_macb01) || // mac013off1 
       (pwr1_off_macb21 && pwr1_off_macb11 && pwr1_off_macb01) )  // mac012off1 
     begin
       ase_uart_06v1 = 1'b1;
       ase_uart_08v1 = 1'b0;
       ase_uart_10v1 = 1'b0;
       ase_uart_12v1 = 1'b0;
     end
     else if( (pwr1_off_macb21 && pwr1_off_macb31) || // mac231 off1
         (pwr1_off_macb31 && pwr1_off_macb11) || // mac13off1 
         (pwr1_off_macb11 && pwr1_off_macb21) || // mac12off1 
         (pwr1_off_macb31 && pwr1_off_macb01) || // mac03off1 
         (pwr1_off_macb11 && pwr1_off_macb01))  // mac01off1  
     begin
       ase_uart_06v1 = 1'b0;
       ase_uart_08v1 = 1'b1;
       ase_uart_10v1 = 1'b0;
       ase_uart_12v1 = 1'b0;
     end
     else if (pwr1_off_smc1 || pwr1_off_macb01 || pwr1_off_macb11 || pwr1_off_macb21 || pwr1_off_macb31) begin // smc1 off1
       ase_uart_08v1 = 1'b0;
       ase_uart_06v1 = 1'b0;
       ase_uart_10v1 = 1'b1;
       ase_uart_12v1 = 1'b0;
     end 
     else begin
       ase_uart_08v1 = 1'b0;
       ase_uart_06v1 = 1'b0;
       ase_uart_10v1 = 1'b0;
       ase_uart_12v1 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc1) begin
     if (pwr1_off_smc1)  // smc1 off1
       ase_smc_12v1 = 1'b0;
    else
       ase_smc_12v1 = 1'b1;
   end

   
   always @(pwr1_off_macb01) begin
     if (pwr1_off_macb01) // macb01 off1
       ase_macb0_12v1 = 1'b0;
     else
       ase_macb0_12v1 = 1'b1;
   end

   always @(pwr1_off_macb11) begin
     if (pwr1_off_macb11) // macb11 off1
       ase_macb1_12v1 = 1'b0;
     else
       ase_macb1_12v1 = 1'b1;
   end

   always @(pwr1_off_macb21) begin // macb21 off1
     if (pwr1_off_macb21) // macb21 off1
       ase_macb2_12v1 = 1'b0;
     else
       ase_macb2_12v1 = 1'b1;
   end

   always @(pwr1_off_macb31) begin // macb31 off1
     if (pwr1_off_macb31) // macb31 off1
       ase_macb3_12v1 = 1'b0;
     else
       ase_macb3_12v1 = 1'b1;
   end


   // core1 voltage1 for vco1
  assign core12v1 = ase_macb0_12v1 & ase_macb1_12v1 & ase_macb2_12v1 & ase_macb3_12v1;

  assign core10v1 =  (ase_macb0_12v1 & ase_macb1_12v1 & ase_macb2_12v1 & (!ase_macb3_12v1)) ||
                    (ase_macb0_12v1 & ase_macb1_12v1 & (!ase_macb2_12v1) & ase_macb3_12v1) ||
                    (ase_macb0_12v1 & (!ase_macb1_12v1) & ase_macb2_12v1 & ase_macb3_12v1) ||
                    ((!ase_macb0_12v1) & ase_macb1_12v1 & ase_macb2_12v1 & ase_macb3_12v1);

  assign core08v1 =  ((!ase_macb0_12v1) & (!ase_macb1_12v1) & (ase_macb2_12v1) & (ase_macb3_12v1)) ||
                    ((!ase_macb0_12v1) & (ase_macb1_12v1) & (!ase_macb2_12v1) & (ase_macb3_12v1)) ||
                    ((!ase_macb0_12v1) & (ase_macb1_12v1) & (ase_macb2_12v1) & (!ase_macb3_12v1)) ||
                    ((ase_macb0_12v1) & (!ase_macb1_12v1) & (!ase_macb2_12v1) & (ase_macb3_12v1)) ||
                    ((ase_macb0_12v1) & (!ase_macb1_12v1) & (ase_macb2_12v1) & (!ase_macb3_12v1)) ||
                    ((ase_macb0_12v1) & (ase_macb1_12v1) & (!ase_macb2_12v1) & (!ase_macb3_12v1));

  assign core06v1 =  ((!ase_macb0_12v1) & (!ase_macb1_12v1) & (!ase_macb2_12v1) & (ase_macb3_12v1)) ||
                    ((!ase_macb0_12v1) & (!ase_macb1_12v1) & (ase_macb2_12v1) & (!ase_macb3_12v1)) ||
                    ((!ase_macb0_12v1) & (ase_macb1_12v1) & (!ase_macb2_12v1) & (!ase_macb3_12v1)) ||
                    ((ase_macb0_12v1) & (!ase_macb1_12v1) & (!ase_macb2_12v1) & (!ase_macb3_12v1)) ||
                    ((!ase_macb0_12v1) & (!ase_macb1_12v1) & (!ase_macb2_12v1) & (!ase_macb3_12v1)) ;



`ifdef LP_ABV_ON1
// psl1 default clock1 = (posedge pclk1);

// Cover1 a condition in which SMC1 is powered1 down
// and again1 powered1 up while UART1 is going1 into POWER1 down
// state or UART1 is already in POWER1 DOWN1 state
// psl1 cover_overlapping_smc_urt_11:
//    cover{fell1(pwr1_on_urt1);[*];fell1(pwr1_on_smc1);[*];
//    rose1(pwr1_on_smc1);[*];rose1(pwr1_on_urt1)};
//
// Cover1 a condition in which UART1 is powered1 down
// and again1 powered1 up while SMC1 is going1 into POWER1 down
// state or SMC1 is already in POWER1 DOWN1 state
// psl1 cover_overlapping_smc_urt_21:
//    cover{fell1(pwr1_on_smc1);[*];fell1(pwr1_on_urt1);[*];
//    rose1(pwr1_on_urt1);[*];rose1(pwr1_on_smc1)};
//


// Power1 Down1 UART1
// This1 gets1 triggered on rising1 edge of Gate1 signal1 for
// UART1 (gate_clk_urt1). In a next cycle after gate_clk_urt1,
// Isolate1 UART1(isolate_urt1) signal1 become1 HIGH1 (active).
// In 2nd cycle after gate_clk_urt1 becomes HIGH1, RESET1 for NON1
// SRPG1 FFs1(rstn_non_srpg_urt1) and POWER11 for UART1(pwr1_on_urt1) should 
// go1 LOW1. 
// This1 completes1 a POWER1 DOWN1. 

sequence s_power_down_urt1;
      (gate_clk_urt1 & !isolate_urt1 & rstn_non_srpg_urt1 & pwr1_on_urt1) 
  ##1 (gate_clk_urt1 & isolate_urt1 & rstn_non_srpg_urt1 & pwr1_on_urt1) 
  ##3 (gate_clk_urt1 & isolate_urt1 & !rstn_non_srpg_urt1 & !pwr1_on_urt1);
endsequence


property p_power_down_urt1;
   @(posedge pclk1)
    $rose(gate_clk_urt1) |=> s_power_down_urt1;
endproperty

output_power_down_urt1:
  assert property (p_power_down_urt1);


// Power1 UP1 UART1
// Sequence starts with , Rising1 edge of pwr1_on_urt1.
// Two1 clock1 cycle after this, isolate_urt1 should become1 LOW1 
// On1 the following1 clk1 gate_clk_urt1 should go1 low1.
// 5 cycles1 after  Rising1 edge of pwr1_on_urt1, rstn_non_srpg_urt1
// should become1 HIGH1
sequence s_power_up_urt1;
##30 (pwr1_on_urt1 & !isolate_urt1 & gate_clk_urt1 & !rstn_non_srpg_urt1) 
##1 (pwr1_on_urt1 & !isolate_urt1 & !gate_clk_urt1 & !rstn_non_srpg_urt1) 
##2 (pwr1_on_urt1 & !isolate_urt1 & !gate_clk_urt1 & rstn_non_srpg_urt1);
endsequence

property p_power_up_urt1;
   @(posedge pclk1)
  disable iff(!nprst1)
    (!pwr1_on_urt1 ##1 pwr1_on_urt1) |=> s_power_up_urt1;
endproperty

output_power_up_urt1:
  assert property (p_power_up_urt1);


// Power1 Down1 SMC1
// This1 gets1 triggered on rising1 edge of Gate1 signal1 for
// SMC1 (gate_clk_smc1). In a next cycle after gate_clk_smc1,
// Isolate1 SMC1(isolate_smc1) signal1 become1 HIGH1 (active).
// In 2nd cycle after gate_clk_smc1 becomes HIGH1, RESET1 for NON1
// SRPG1 FFs1(rstn_non_srpg_smc1) and POWER11 for SMC1(pwr1_on_smc1) should 
// go1 LOW1. 
// This1 completes1 a POWER1 DOWN1. 

sequence s_power_down_smc1;
      (gate_clk_smc1 & !isolate_smc1 & rstn_non_srpg_smc1 & pwr1_on_smc1) 
  ##1 (gate_clk_smc1 & isolate_smc1 & rstn_non_srpg_smc1 & pwr1_on_smc1) 
  ##3 (gate_clk_smc1 & isolate_smc1 & !rstn_non_srpg_smc1 & !pwr1_on_smc1);
endsequence


property p_power_down_smc1;
   @(posedge pclk1)
    $rose(gate_clk_smc1) |=> s_power_down_smc1;
endproperty

output_power_down_smc1:
  assert property (p_power_down_smc1);


// Power1 UP1 SMC1
// Sequence starts with , Rising1 edge of pwr1_on_smc1.
// Two1 clock1 cycle after this, isolate_smc1 should become1 LOW1 
// On1 the following1 clk1 gate_clk_smc1 should go1 low1.
// 5 cycles1 after  Rising1 edge of pwr1_on_smc1, rstn_non_srpg_smc1
// should become1 HIGH1
sequence s_power_up_smc1;
##30 (pwr1_on_smc1 & !isolate_smc1 & gate_clk_smc1 & !rstn_non_srpg_smc1) 
##1 (pwr1_on_smc1 & !isolate_smc1 & !gate_clk_smc1 & !rstn_non_srpg_smc1) 
##2 (pwr1_on_smc1 & !isolate_smc1 & !gate_clk_smc1 & rstn_non_srpg_smc1);
endsequence

property p_power_up_smc1;
   @(posedge pclk1)
  disable iff(!nprst1)
    (!pwr1_on_smc1 ##1 pwr1_on_smc1) |=> s_power_up_smc1;
endproperty

output_power_up_smc1:
  assert property (p_power_up_smc1);


// COVER1 SMC1 POWER1 DOWN1 AND1 UP1
cover_power_down_up_smc1: cover property (@(posedge pclk1)
(s_power_down_smc1 ##[5:180] s_power_up_smc1));



// COVER1 UART1 POWER1 DOWN1 AND1 UP1
cover_power_down_up_urt1: cover property (@(posedge pclk1)
(s_power_down_urt1 ##[5:180] s_power_up_urt1));

cover_power_down_urt1: cover property (@(posedge pclk1)
(s_power_down_urt1));

cover_power_up_urt1: cover property (@(posedge pclk1)
(s_power_up_urt1));




`ifdef PCM_ABV_ON1
//------------------------------------------------------------------------------
// Power1 Controller1 Formal1 Verification1 component.  Each power1 domain has a 
// separate1 instantiation1
//------------------------------------------------------------------------------

// need to assume that CPU1 will leave1 a minimum time between powering1 down and 
// back up.  In this example1, 10clks has been selected.
// psl1 config_min_uart_pd_time1 : assume always {rose1(L1_ctrl_domain1[1])} |-> { L1_ctrl_domain1[1][*10] } abort1(~nprst1);
// psl1 config_min_uart_pu_time1 : assume always {fell1(L1_ctrl_domain1[1])} |-> { !L1_ctrl_domain1[1][*10] } abort1(~nprst1);
// psl1 config_min_smc_pd_time1 : assume always {rose1(L1_ctrl_domain1[2])} |-> { L1_ctrl_domain1[2][*10] } abort1(~nprst1);
// psl1 config_min_smc_pu_time1 : assume always {fell1(L1_ctrl_domain1[2])} |-> { !L1_ctrl_domain1[2][*10] } abort1(~nprst1);

// UART1 VCOMP1 parameters1
   defparam i_uart_vcomp_domain1.ENABLE_SAVE_RESTORE_EDGE1   = 1;
   defparam i_uart_vcomp_domain1.ENABLE_EXT_PWR_CNTRL1       = 1;
   defparam i_uart_vcomp_domain1.REF_CLK_DEFINED1            = 0;
   defparam i_uart_vcomp_domain1.MIN_SHUTOFF_CYCLES1         = 4;
   defparam i_uart_vcomp_domain1.MIN_RESTORE_TO_ISO_CYCLES1  = 0;
   defparam i_uart_vcomp_domain1.MIN_SAVE_TO_SHUTOFF_CYCLES1 = 1;


   vcomp_domain1 i_uart_vcomp_domain1
   ( .ref_clk1(pclk1),
     .start_lps1(L1_ctrl_domain1[1] || !rstn_non_srpg_urt1),
     .rst_n1(nprst1),
     .ext_power_down1(L1_ctrl_domain1[1]),
     .iso_en1(isolate_urt1),
     .save_edge1(save_edge_urt1),
     .restore_edge1(restore_edge_urt1),
     .domain_shut_off1(pwr1_off_urt1),
     .domain_clk1(!gate_clk_urt1 && pclk1)
   );


// SMC1 VCOMP1 parameters1
   defparam i_smc_vcomp_domain1.ENABLE_SAVE_RESTORE_EDGE1   = 1;
   defparam i_smc_vcomp_domain1.ENABLE_EXT_PWR_CNTRL1       = 1;
   defparam i_smc_vcomp_domain1.REF_CLK_DEFINED1            = 0;
   defparam i_smc_vcomp_domain1.MIN_SHUTOFF_CYCLES1         = 4;
   defparam i_smc_vcomp_domain1.MIN_RESTORE_TO_ISO_CYCLES1  = 0;
   defparam i_smc_vcomp_domain1.MIN_SAVE_TO_SHUTOFF_CYCLES1 = 1;


   vcomp_domain1 i_smc_vcomp_domain1
   ( .ref_clk1(pclk1),
     .start_lps1(L1_ctrl_domain1[2] || !rstn_non_srpg_smc1),
     .rst_n1(nprst1),
     .ext_power_down1(L1_ctrl_domain1[2]),
     .iso_en1(isolate_smc1),
     .save_edge1(save_edge_smc1),
     .restore_edge1(restore_edge_smc1),
     .domain_shut_off1(pwr1_off_smc1),
     .domain_clk1(!gate_clk_smc1 && pclk1)
   );

`endif

`endif



endmodule
