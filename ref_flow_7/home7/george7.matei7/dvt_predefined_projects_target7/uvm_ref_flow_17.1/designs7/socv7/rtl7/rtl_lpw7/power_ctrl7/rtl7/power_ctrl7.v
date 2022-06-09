//File7 name   : power_ctrl7.v
//Title7       : Power7 Control7 Module7
//Created7     : 1999
//Description7 : Top7 level of power7 controller7
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

module power_ctrl7 (


    // Clocks7 & Reset7
    pclk7,
    nprst7,
    // APB7 programming7 interface
    paddr7,
    psel7,
    penable7,
    pwrite7,
    pwdata7,
    prdata7,
    // mac7 i/f,
    macb3_wakeup7,
    macb2_wakeup7,
    macb1_wakeup7,
    macb0_wakeup7,
    // Scan7 
    scan_in7,
    scan_en7,
    scan_mode7,
    scan_out7,
    // Module7 control7 outputs7
    int_source_h7,
    // SMC7
    rstn_non_srpg_smc7,
    gate_clk_smc7,
    isolate_smc7,
    save_edge_smc7,
    restore_edge_smc7,
    pwr1_on_smc7,
    pwr2_on_smc7,
    pwr1_off_smc7,
    pwr2_off_smc7,
    // URT7
    rstn_non_srpg_urt7,
    gate_clk_urt7,
    isolate_urt7,
    save_edge_urt7,
    restore_edge_urt7,
    pwr1_on_urt7,
    pwr2_on_urt7,
    pwr1_off_urt7,      
    pwr2_off_urt7,
    // ETH07
    rstn_non_srpg_macb07,
    gate_clk_macb07,
    isolate_macb07,
    save_edge_macb07,
    restore_edge_macb07,
    pwr1_on_macb07,
    pwr2_on_macb07,
    pwr1_off_macb07,      
    pwr2_off_macb07,
    // ETH17
    rstn_non_srpg_macb17,
    gate_clk_macb17,
    isolate_macb17,
    save_edge_macb17,
    restore_edge_macb17,
    pwr1_on_macb17,
    pwr2_on_macb17,
    pwr1_off_macb17,      
    pwr2_off_macb17,
    // ETH27
    rstn_non_srpg_macb27,
    gate_clk_macb27,
    isolate_macb27,
    save_edge_macb27,
    restore_edge_macb27,
    pwr1_on_macb27,
    pwr2_on_macb27,
    pwr1_off_macb27,      
    pwr2_off_macb27,
    // ETH37
    rstn_non_srpg_macb37,
    gate_clk_macb37,
    isolate_macb37,
    save_edge_macb37,
    restore_edge_macb37,
    pwr1_on_macb37,
    pwr2_on_macb37,
    pwr1_off_macb37,      
    pwr2_off_macb37,
    // DMA7
    rstn_non_srpg_dma7,
    gate_clk_dma7,
    isolate_dma7,
    save_edge_dma7,
    restore_edge_dma7,
    pwr1_on_dma7,
    pwr2_on_dma7,
    pwr1_off_dma7,      
    pwr2_off_dma7,
    // CPU7
    rstn_non_srpg_cpu7,
    gate_clk_cpu7,
    isolate_cpu7,
    save_edge_cpu7,
    restore_edge_cpu7,
    pwr1_on_cpu7,
    pwr2_on_cpu7,
    pwr1_off_cpu7,      
    pwr2_off_cpu7,
    // ALUT7
    rstn_non_srpg_alut7,
    gate_clk_alut7,
    isolate_alut7,
    save_edge_alut7,
    restore_edge_alut7,
    pwr1_on_alut7,
    pwr2_on_alut7,
    pwr1_off_alut7,      
    pwr2_off_alut7,
    // MEM7
    rstn_non_srpg_mem7,
    gate_clk_mem7,
    isolate_mem7,
    save_edge_mem7,
    restore_edge_mem7,
    pwr1_on_mem7,
    pwr2_on_mem7,
    pwr1_off_mem7,      
    pwr2_off_mem7,
    // core7 dvfs7 transitions7
    core06v7,
    core08v7,
    core10v7,
    core12v7,
    pcm_macb_wakeup_int7,
    // mte7 signals7
    mte_smc_start7,
    mte_uart_start7,
    mte_smc_uart_start7,  
    mte_pm_smc_to_default_start7, 
    mte_pm_uart_to_default_start7,
    mte_pm_smc_uart_to_default_start7

  );

  parameter STATE_IDLE_12V7 = 4'b0001;
  parameter STATE_06V7 = 4'b0010;
  parameter STATE_08V7 = 4'b0100;
  parameter STATE_10V7 = 4'b1000;

    // Clocks7 & Reset7
    input pclk7;
    input nprst7;
    // APB7 programming7 interface
    input [31:0] paddr7;
    input psel7  ;
    input penable7;
    input pwrite7 ;
    input [31:0] pwdata7;
    output [31:0] prdata7;
    // mac7
    input macb3_wakeup7;
    input macb2_wakeup7;
    input macb1_wakeup7;
    input macb0_wakeup7;
    // Scan7 
    input scan_in7;
    input scan_en7;
    input scan_mode7;
    output scan_out7;
    // Module7 control7 outputs7
    input int_source_h7;
    // SMC7
    output rstn_non_srpg_smc7 ;
    output gate_clk_smc7   ;
    output isolate_smc7   ;
    output save_edge_smc7   ;
    output restore_edge_smc7   ;
    output pwr1_on_smc7   ;
    output pwr2_on_smc7   ;
    output pwr1_off_smc7  ;
    output pwr2_off_smc7  ;
    // URT7
    output rstn_non_srpg_urt7 ;
    output gate_clk_urt7      ;
    output isolate_urt7       ;
    output save_edge_urt7   ;
    output restore_edge_urt7   ;
    output pwr1_on_urt7       ;
    output pwr2_on_urt7       ;
    output pwr1_off_urt7      ;
    output pwr2_off_urt7      ;
    // ETH07
    output rstn_non_srpg_macb07 ;
    output gate_clk_macb07      ;
    output isolate_macb07       ;
    output save_edge_macb07   ;
    output restore_edge_macb07   ;
    output pwr1_on_macb07       ;
    output pwr2_on_macb07       ;
    output pwr1_off_macb07      ;
    output pwr2_off_macb07      ;
    // ETH17
    output rstn_non_srpg_macb17 ;
    output gate_clk_macb17      ;
    output isolate_macb17       ;
    output save_edge_macb17   ;
    output restore_edge_macb17   ;
    output pwr1_on_macb17       ;
    output pwr2_on_macb17       ;
    output pwr1_off_macb17      ;
    output pwr2_off_macb17      ;
    // ETH27
    output rstn_non_srpg_macb27 ;
    output gate_clk_macb27      ;
    output isolate_macb27       ;
    output save_edge_macb27   ;
    output restore_edge_macb27   ;
    output pwr1_on_macb27       ;
    output pwr2_on_macb27       ;
    output pwr1_off_macb27      ;
    output pwr2_off_macb27      ;
    // ETH37
    output rstn_non_srpg_macb37 ;
    output gate_clk_macb37      ;
    output isolate_macb37       ;
    output save_edge_macb37   ;
    output restore_edge_macb37   ;
    output pwr1_on_macb37       ;
    output pwr2_on_macb37       ;
    output pwr1_off_macb37      ;
    output pwr2_off_macb37      ;
    // DMA7
    output rstn_non_srpg_dma7 ;
    output gate_clk_dma7      ;
    output isolate_dma7       ;
    output save_edge_dma7   ;
    output restore_edge_dma7   ;
    output pwr1_on_dma7       ;
    output pwr2_on_dma7       ;
    output pwr1_off_dma7      ;
    output pwr2_off_dma7      ;
    // CPU7
    output rstn_non_srpg_cpu7 ;
    output gate_clk_cpu7      ;
    output isolate_cpu7       ;
    output save_edge_cpu7   ;
    output restore_edge_cpu7   ;
    output pwr1_on_cpu7       ;
    output pwr2_on_cpu7       ;
    output pwr1_off_cpu7      ;
    output pwr2_off_cpu7      ;
    // ALUT7
    output rstn_non_srpg_alut7 ;
    output gate_clk_alut7      ;
    output isolate_alut7       ;
    output save_edge_alut7   ;
    output restore_edge_alut7   ;
    output pwr1_on_alut7       ;
    output pwr2_on_alut7       ;
    output pwr1_off_alut7      ;
    output pwr2_off_alut7      ;
    // MEM7
    output rstn_non_srpg_mem7 ;
    output gate_clk_mem7      ;
    output isolate_mem7       ;
    output save_edge_mem7   ;
    output restore_edge_mem7   ;
    output pwr1_on_mem7       ;
    output pwr2_on_mem7       ;
    output pwr1_off_mem7      ;
    output pwr2_off_mem7      ;


   // core7 transitions7 o/p
    output core06v7;
    output core08v7;
    output core10v7;
    output core12v7;
    output pcm_macb_wakeup_int7 ;
    //mode mte7  signals7
    output mte_smc_start7;
    output mte_uart_start7;
    output mte_smc_uart_start7;  
    output mte_pm_smc_to_default_start7; 
    output mte_pm_uart_to_default_start7;
    output mte_pm_smc_uart_to_default_start7;

    reg mte_smc_start7;
    reg mte_uart_start7;
    reg mte_smc_uart_start7;  
    reg mte_pm_smc_to_default_start7; 
    reg mte_pm_uart_to_default_start7;
    reg mte_pm_smc_uart_to_default_start7;

    reg [31:0] prdata7;

  wire valid_reg_write7  ;
  wire valid_reg_read7   ;
  wire L1_ctrl_access7   ;
  wire L1_status_access7 ;
  wire pcm_int_mask_access7;
  wire pcm_int_status_access7;
  wire standby_mem07      ;
  wire standby_mem17      ;
  wire standby_mem27      ;
  wire standby_mem37      ;
  wire pwr1_off_mem07;
  wire pwr1_off_mem17;
  wire pwr1_off_mem27;
  wire pwr1_off_mem37;
  
  // Control7 signals7
  wire set_status_smc7   ;
  wire clr_status_smc7   ;
  wire set_status_urt7   ;
  wire clr_status_urt7   ;
  wire set_status_macb07   ;
  wire clr_status_macb07   ;
  wire set_status_macb17   ;
  wire clr_status_macb17   ;
  wire set_status_macb27   ;
  wire clr_status_macb27   ;
  wire set_status_macb37   ;
  wire clr_status_macb37   ;
  wire set_status_dma7   ;
  wire clr_status_dma7   ;
  wire set_status_cpu7   ;
  wire clr_status_cpu7   ;
  wire set_status_alut7   ;
  wire clr_status_alut7   ;
  wire set_status_mem7   ;
  wire clr_status_mem7   ;


  // Status and Control7 registers
  reg [31:0]  L1_status_reg7;
  reg  [31:0] L1_ctrl_reg7  ;
  reg  [31:0] L1_ctrl_domain7  ;
  reg L1_ctrl_cpu_off_reg7;
  reg [31:0]  pcm_mask_reg7;
  reg [31:0]  pcm_status_reg7;

  // Signals7 gated7 in scan_mode7
  //SMC7
  wire  rstn_non_srpg_smc_int7;
  wire  gate_clk_smc_int7    ;     
  wire  isolate_smc_int7    ;       
  wire save_edge_smc_int7;
  wire restore_edge_smc_int7;
  wire  pwr1_on_smc_int7    ;      
  wire  pwr2_on_smc_int7    ;      


  //URT7
  wire   rstn_non_srpg_urt_int7;
  wire   gate_clk_urt_int7     ;     
  wire   isolate_urt_int7      ;       
  wire save_edge_urt_int7;
  wire restore_edge_urt_int7;
  wire   pwr1_on_urt_int7      ;      
  wire   pwr2_on_urt_int7      ;      

  // ETH07
  wire   rstn_non_srpg_macb0_int7;
  wire   gate_clk_macb0_int7     ;     
  wire   isolate_macb0_int7      ;       
  wire save_edge_macb0_int7;
  wire restore_edge_macb0_int7;
  wire   pwr1_on_macb0_int7      ;      
  wire   pwr2_on_macb0_int7      ;      
  // ETH17
  wire   rstn_non_srpg_macb1_int7;
  wire   gate_clk_macb1_int7     ;     
  wire   isolate_macb1_int7      ;       
  wire save_edge_macb1_int7;
  wire restore_edge_macb1_int7;
  wire   pwr1_on_macb1_int7      ;      
  wire   pwr2_on_macb1_int7      ;      
  // ETH27
  wire   rstn_non_srpg_macb2_int7;
  wire   gate_clk_macb2_int7     ;     
  wire   isolate_macb2_int7      ;       
  wire save_edge_macb2_int7;
  wire restore_edge_macb2_int7;
  wire   pwr1_on_macb2_int7      ;      
  wire   pwr2_on_macb2_int7      ;      
  // ETH37
  wire   rstn_non_srpg_macb3_int7;
  wire   gate_clk_macb3_int7     ;     
  wire   isolate_macb3_int7      ;       
  wire save_edge_macb3_int7;
  wire restore_edge_macb3_int7;
  wire   pwr1_on_macb3_int7      ;      
  wire   pwr2_on_macb3_int7      ;      

  // DMA7
  wire   rstn_non_srpg_dma_int7;
  wire   gate_clk_dma_int7     ;     
  wire   isolate_dma_int7      ;       
  wire save_edge_dma_int7;
  wire restore_edge_dma_int7;
  wire   pwr1_on_dma_int7      ;      
  wire   pwr2_on_dma_int7      ;      

  // CPU7
  wire   rstn_non_srpg_cpu_int7;
  wire   gate_clk_cpu_int7     ;     
  wire   isolate_cpu_int7      ;       
  wire save_edge_cpu_int7;
  wire restore_edge_cpu_int7;
  wire   pwr1_on_cpu_int7      ;      
  wire   pwr2_on_cpu_int7      ;  
  wire L1_ctrl_cpu_off_p7;    

  reg save_alut_tmp7;
  // DFS7 sm7

  reg cpu_shutoff_ctrl7;

  reg mte_mac_off_start7, mte_mac012_start7, mte_mac013_start7, mte_mac023_start7, mte_mac123_start7;
  reg mte_mac01_start7, mte_mac02_start7, mte_mac03_start7, mte_mac12_start7, mte_mac13_start7, mte_mac23_start7;
  reg mte_mac0_start7, mte_mac1_start7, mte_mac2_start7, mte_mac3_start7;
  reg mte_sys_hibernate7 ;
  reg mte_dma_start7 ;
  reg mte_cpu_start7 ;
  reg mte_mac_off_sleep_start7, mte_mac012_sleep_start7, mte_mac013_sleep_start7, mte_mac023_sleep_start7, mte_mac123_sleep_start7;
  reg mte_mac01_sleep_start7, mte_mac02_sleep_start7, mte_mac03_sleep_start7, mte_mac12_sleep_start7, mte_mac13_sleep_start7, mte_mac23_sleep_start7;
  reg mte_mac0_sleep_start7, mte_mac1_sleep_start7, mte_mac2_sleep_start7, mte_mac3_sleep_start7;
  reg mte_dma_sleep_start7;
  reg mte_mac_off_to_default7, mte_mac012_to_default7, mte_mac013_to_default7, mte_mac023_to_default7, mte_mac123_to_default7;
  reg mte_mac01_to_default7, mte_mac02_to_default7, mte_mac03_to_default7, mte_mac12_to_default7, mte_mac13_to_default7, mte_mac23_to_default7;
  reg mte_mac0_to_default7, mte_mac1_to_default7, mte_mac2_to_default7, mte_mac3_to_default7;
  reg mte_dma_isolate_dis7;
  reg mte_cpu_isolate_dis7;
  reg mte_sys_hibernate_to_default7;


  // Latch7 the CPU7 SLEEP7 invocation7
  always @( posedge pclk7 or negedge nprst7) 
  begin
    if(!nprst7)
      L1_ctrl_cpu_off_reg7 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg7 <= L1_ctrl_domain7[8];
  end

  // Create7 a pulse7 for sleep7 detection7 
  assign L1_ctrl_cpu_off_p7 =  L1_ctrl_domain7[8] && !L1_ctrl_cpu_off_reg7;
  
  // CPU7 sleep7 contol7 logic 
  // Shut7 off7 CPU7 when L1_ctrl_cpu_off_p7 is set
  // wake7 cpu7 when any interrupt7 is seen7  
  always @( posedge pclk7 or negedge nprst7) 
  begin
    if(!nprst7)
     cpu_shutoff_ctrl7 <= 1'b0;
    else if(cpu_shutoff_ctrl7 && int_source_h7)
     cpu_shutoff_ctrl7 <= 1'b0;
    else if (L1_ctrl_cpu_off_p7)
     cpu_shutoff_ctrl7 <= 1'b1;
  end
 
  // instantiate7 power7 contol7  block for uart7
  power_ctrl_sm7 i_urt_power_ctrl_sm7(
    .pclk7(pclk7),
    .nprst7(nprst7),
    .L1_module_req7(L1_ctrl_domain7[1]),
    .set_status_module7(set_status_urt7),
    .clr_status_module7(clr_status_urt7),
    .rstn_non_srpg_module7(rstn_non_srpg_urt_int7),
    .gate_clk_module7(gate_clk_urt_int7),
    .isolate_module7(isolate_urt_int7),
    .save_edge7(save_edge_urt_int7),
    .restore_edge7(restore_edge_urt_int7),
    .pwr1_on7(pwr1_on_urt_int7),
    .pwr2_on7(pwr2_on_urt_int7)
    );
  

  // instantiate7 power7 contol7  block for smc7
  power_ctrl_sm7 i_smc_power_ctrl_sm7(
    .pclk7(pclk7),
    .nprst7(nprst7),
    .L1_module_req7(L1_ctrl_domain7[2]),
    .set_status_module7(set_status_smc7),
    .clr_status_module7(clr_status_smc7),
    .rstn_non_srpg_module7(rstn_non_srpg_smc_int7),
    .gate_clk_module7(gate_clk_smc_int7),
    .isolate_module7(isolate_smc_int7),
    .save_edge7(save_edge_smc_int7),
    .restore_edge7(restore_edge_smc_int7),
    .pwr1_on7(pwr1_on_smc_int7),
    .pwr2_on7(pwr2_on_smc_int7)
    );

  // power7 control7 for macb07
  power_ctrl_sm7 i_macb0_power_ctrl_sm7(
    .pclk7(pclk7),
    .nprst7(nprst7),
    .L1_module_req7(L1_ctrl_domain7[3]),
    .set_status_module7(set_status_macb07),
    .clr_status_module7(clr_status_macb07),
    .rstn_non_srpg_module7(rstn_non_srpg_macb0_int7),
    .gate_clk_module7(gate_clk_macb0_int7),
    .isolate_module7(isolate_macb0_int7),
    .save_edge7(save_edge_macb0_int7),
    .restore_edge7(restore_edge_macb0_int7),
    .pwr1_on7(pwr1_on_macb0_int7),
    .pwr2_on7(pwr2_on_macb0_int7)
    );
  // power7 control7 for macb17
  power_ctrl_sm7 i_macb1_power_ctrl_sm7(
    .pclk7(pclk7),
    .nprst7(nprst7),
    .L1_module_req7(L1_ctrl_domain7[4]),
    .set_status_module7(set_status_macb17),
    .clr_status_module7(clr_status_macb17),
    .rstn_non_srpg_module7(rstn_non_srpg_macb1_int7),
    .gate_clk_module7(gate_clk_macb1_int7),
    .isolate_module7(isolate_macb1_int7),
    .save_edge7(save_edge_macb1_int7),
    .restore_edge7(restore_edge_macb1_int7),
    .pwr1_on7(pwr1_on_macb1_int7),
    .pwr2_on7(pwr2_on_macb1_int7)
    );
  // power7 control7 for macb27
  power_ctrl_sm7 i_macb2_power_ctrl_sm7(
    .pclk7(pclk7),
    .nprst7(nprst7),
    .L1_module_req7(L1_ctrl_domain7[5]),
    .set_status_module7(set_status_macb27),
    .clr_status_module7(clr_status_macb27),
    .rstn_non_srpg_module7(rstn_non_srpg_macb2_int7),
    .gate_clk_module7(gate_clk_macb2_int7),
    .isolate_module7(isolate_macb2_int7),
    .save_edge7(save_edge_macb2_int7),
    .restore_edge7(restore_edge_macb2_int7),
    .pwr1_on7(pwr1_on_macb2_int7),
    .pwr2_on7(pwr2_on_macb2_int7)
    );
  // power7 control7 for macb37
  power_ctrl_sm7 i_macb3_power_ctrl_sm7(
    .pclk7(pclk7),
    .nprst7(nprst7),
    .L1_module_req7(L1_ctrl_domain7[6]),
    .set_status_module7(set_status_macb37),
    .clr_status_module7(clr_status_macb37),
    .rstn_non_srpg_module7(rstn_non_srpg_macb3_int7),
    .gate_clk_module7(gate_clk_macb3_int7),
    .isolate_module7(isolate_macb3_int7),
    .save_edge7(save_edge_macb3_int7),
    .restore_edge7(restore_edge_macb3_int7),
    .pwr1_on7(pwr1_on_macb3_int7),
    .pwr2_on7(pwr2_on_macb3_int7)
    );
  // power7 control7 for dma7
  power_ctrl_sm7 i_dma_power_ctrl_sm7(
    .pclk7(pclk7),
    .nprst7(nprst7),
    .L1_module_req7(L1_ctrl_domain7[7]),
    .set_status_module7(set_status_dma7),
    .clr_status_module7(clr_status_dma7),
    .rstn_non_srpg_module7(rstn_non_srpg_dma_int7),
    .gate_clk_module7(gate_clk_dma_int7),
    .isolate_module7(isolate_dma_int7),
    .save_edge7(save_edge_dma_int7),
    .restore_edge7(restore_edge_dma_int7),
    .pwr1_on7(pwr1_on_dma_int7),
    .pwr2_on7(pwr2_on_dma_int7)
    );
  // power7 control7 for CPU7
  power_ctrl_sm7 i_cpu_power_ctrl_sm7(
    .pclk7(pclk7),
    .nprst7(nprst7),
    .L1_module_req7(cpu_shutoff_ctrl7),
    .set_status_module7(set_status_cpu7),
    .clr_status_module7(clr_status_cpu7),
    .rstn_non_srpg_module7(rstn_non_srpg_cpu_int7),
    .gate_clk_module7(gate_clk_cpu_int7),
    .isolate_module7(isolate_cpu_int7),
    .save_edge7(save_edge_cpu_int7),
    .restore_edge7(restore_edge_cpu_int7),
    .pwr1_on7(pwr1_on_cpu_int7),
    .pwr2_on7(pwr2_on_cpu_int7)
    );

  assign valid_reg_write7 =  (psel7 && pwrite7 && penable7);
  assign valid_reg_read7  =  (psel7 && (!pwrite7) && penable7);

  assign L1_ctrl_access7  =  (paddr7[15:0] == 16'b0000000000000100); 
  assign L1_status_access7 = (paddr7[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access7 =   (paddr7[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access7 = (paddr7[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control7 and status register
  always @(*)
  begin  
    if(valid_reg_read7 && L1_ctrl_access7) 
      prdata7 = L1_ctrl_reg7;
    else if (valid_reg_read7 && L1_status_access7)
      prdata7 = L1_status_reg7;
    else if (valid_reg_read7 && pcm_int_mask_access7)
      prdata7 = pcm_mask_reg7;
    else if (valid_reg_read7 && pcm_int_status_access7)
      prdata7 = pcm_status_reg7;
    else 
      prdata7 = 0;
  end

  assign set_status_mem7 =  (set_status_macb07 && set_status_macb17 && set_status_macb27 &&
                            set_status_macb37 && set_status_dma7 && set_status_cpu7);

  assign clr_status_mem7 =  (clr_status_macb07 && clr_status_macb17 && clr_status_macb27 &&
                            clr_status_macb37 && clr_status_dma7 && clr_status_cpu7);

  assign set_status_alut7 = (set_status_macb07 && set_status_macb17 && set_status_macb27 && set_status_macb37);

  assign clr_status_alut7 = (clr_status_macb07 || clr_status_macb17 || clr_status_macb27  || clr_status_macb37);

  // Write accesses to the control7 and status register
 
  always @(posedge pclk7 or negedge nprst7)
  begin
    if (!nprst7) begin
      L1_ctrl_reg7   <= 0;
      L1_status_reg7 <= 0;
      pcm_mask_reg7 <= 0;
    end else begin
      // CTRL7 reg updates7
      if (valid_reg_write7 && L1_ctrl_access7) 
        L1_ctrl_reg7 <= pwdata7; // Writes7 to the ctrl7 reg
      if (valid_reg_write7 && pcm_int_mask_access7) 
        pcm_mask_reg7 <= pwdata7; // Writes7 to the ctrl7 reg

      if (set_status_urt7 == 1'b1)  
        L1_status_reg7[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt7 == 1'b1) 
        L1_status_reg7[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc7 == 1'b1) 
        L1_status_reg7[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc7 == 1'b1) 
        L1_status_reg7[2] <= 1'b0; // Clear the status bit

      if (set_status_macb07 == 1'b1)  
        L1_status_reg7[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb07 == 1'b1) 
        L1_status_reg7[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb17 == 1'b1)  
        L1_status_reg7[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb17 == 1'b1) 
        L1_status_reg7[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb27 == 1'b1)  
        L1_status_reg7[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb27 == 1'b1) 
        L1_status_reg7[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb37 == 1'b1)  
        L1_status_reg7[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb37 == 1'b1) 
        L1_status_reg7[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma7 == 1'b1)  
        L1_status_reg7[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma7 == 1'b1) 
        L1_status_reg7[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu7 == 1'b1)  
        L1_status_reg7[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu7 == 1'b1) 
        L1_status_reg7[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut7 == 1'b1)  
        L1_status_reg7[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut7 == 1'b1) 
        L1_status_reg7[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem7 == 1'b1)  
        L1_status_reg7[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem7 == 1'b1) 
        L1_status_reg7[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused7 bits of pcm_status_reg7 are tied7 to 0
  always @(posedge pclk7 or negedge nprst7)
  begin
    if (!nprst7)
      pcm_status_reg7[31:4] <= 'b0;
    else  
      pcm_status_reg7[31:4] <= pcm_status_reg7[31:4];
  end
  
  // interrupt7 only of h/w assisted7 wakeup
  // MAC7 3
  always @(posedge pclk7 or negedge nprst7)
  begin
    if(!nprst7)
      pcm_status_reg7[3] <= 1'b0;
    else if (valid_reg_write7 && pcm_int_status_access7) 
      pcm_status_reg7[3] <= pwdata7[3];
    else if (macb3_wakeup7 & ~pcm_mask_reg7[3])
      pcm_status_reg7[3] <= 1'b1;
    else if (valid_reg_read7 && pcm_int_status_access7) 
      pcm_status_reg7[3] <= 1'b0;
    else
      pcm_status_reg7[3] <= pcm_status_reg7[3];
  end  
   
  // MAC7 2
  always @(posedge pclk7 or negedge nprst7)
  begin
    if(!nprst7)
      pcm_status_reg7[2] <= 1'b0;
    else if (valid_reg_write7 && pcm_int_status_access7) 
      pcm_status_reg7[2] <= pwdata7[2];
    else if (macb2_wakeup7 & ~pcm_mask_reg7[2])
      pcm_status_reg7[2] <= 1'b1;
    else if (valid_reg_read7 && pcm_int_status_access7) 
      pcm_status_reg7[2] <= 1'b0;
    else
      pcm_status_reg7[2] <= pcm_status_reg7[2];
  end  

  // MAC7 1
  always @(posedge pclk7 or negedge nprst7)
  begin
    if(!nprst7)
      pcm_status_reg7[1] <= 1'b0;
    else if (valid_reg_write7 && pcm_int_status_access7) 
      pcm_status_reg7[1] <= pwdata7[1];
    else if (macb1_wakeup7 & ~pcm_mask_reg7[1])
      pcm_status_reg7[1] <= 1'b1;
    else if (valid_reg_read7 && pcm_int_status_access7) 
      pcm_status_reg7[1] <= 1'b0;
    else
      pcm_status_reg7[1] <= pcm_status_reg7[1];
  end  
   
  // MAC7 0
  always @(posedge pclk7 or negedge nprst7)
  begin
    if(!nprst7)
      pcm_status_reg7[0] <= 1'b0;
    else if (valid_reg_write7 && pcm_int_status_access7) 
      pcm_status_reg7[0] <= pwdata7[0];
    else if (macb0_wakeup7 & ~pcm_mask_reg7[0])
      pcm_status_reg7[0] <= 1'b1;
    else if (valid_reg_read7 && pcm_int_status_access7) 
      pcm_status_reg7[0] <= 1'b0;
    else
      pcm_status_reg7[0] <= pcm_status_reg7[0];
  end  

  assign pcm_macb_wakeup_int7 = |pcm_status_reg7;

  reg [31:0] L1_ctrl_reg17;
  always @(posedge pclk7 or negedge nprst7)
  begin
    if(!nprst7)
      L1_ctrl_reg17 <= 0;
    else
      L1_ctrl_reg17 <= L1_ctrl_reg7;
  end

  // Program7 mode decode
  always @(L1_ctrl_reg7 or L1_ctrl_reg17 or int_source_h7 or cpu_shutoff_ctrl7) begin
    mte_smc_start7 = 0;
    mte_uart_start7 = 0;
    mte_smc_uart_start7  = 0;
    mte_mac_off_start7  = 0;
    mte_mac012_start7 = 0;
    mte_mac013_start7 = 0;
    mte_mac023_start7 = 0;
    mte_mac123_start7 = 0;
    mte_mac01_start7 = 0;
    mte_mac02_start7 = 0;
    mte_mac03_start7 = 0;
    mte_mac12_start7 = 0;
    mte_mac13_start7 = 0;
    mte_mac23_start7 = 0;
    mte_mac0_start7 = 0;
    mte_mac1_start7 = 0;
    mte_mac2_start7 = 0;
    mte_mac3_start7 = 0;
    mte_sys_hibernate7 = 0 ;
    mte_dma_start7 = 0 ;
    mte_cpu_start7 = 0 ;

    mte_mac0_sleep_start7 = (L1_ctrl_reg7 ==  'h14) && (L1_ctrl_reg17 == 'h4 );
    mte_mac1_sleep_start7 = (L1_ctrl_reg7 ==  'h14) && (L1_ctrl_reg17 == 'h5 ); 
    mte_mac2_sleep_start7 = (L1_ctrl_reg7 ==  'h14) && (L1_ctrl_reg17 == 'h6 ); 
    mte_mac3_sleep_start7 = (L1_ctrl_reg7 ==  'h14) && (L1_ctrl_reg17 == 'h7 ); 
    mte_mac01_sleep_start7 = (L1_ctrl_reg7 ==  'h14) && (L1_ctrl_reg17 == 'h8 ); 
    mte_mac02_sleep_start7 = (L1_ctrl_reg7 ==  'h14) && (L1_ctrl_reg17 == 'h9 ); 
    mte_mac03_sleep_start7 = (L1_ctrl_reg7 ==  'h14) && (L1_ctrl_reg17 == 'hA ); 
    mte_mac12_sleep_start7 = (L1_ctrl_reg7 ==  'h14) && (L1_ctrl_reg17 == 'hB ); 
    mte_mac13_sleep_start7 = (L1_ctrl_reg7 ==  'h14) && (L1_ctrl_reg17 == 'hC ); 
    mte_mac23_sleep_start7 = (L1_ctrl_reg7 ==  'h14) && (L1_ctrl_reg17 == 'hD ); 
    mte_mac012_sleep_start7 = (L1_ctrl_reg7 ==  'h14) && (L1_ctrl_reg17 == 'hE ); 
    mte_mac013_sleep_start7 = (L1_ctrl_reg7 ==  'h14) && (L1_ctrl_reg17 == 'hF ); 
    mte_mac023_sleep_start7 = (L1_ctrl_reg7 ==  'h14) && (L1_ctrl_reg17 == 'h10 ); 
    mte_mac123_sleep_start7 = (L1_ctrl_reg7 ==  'h14) && (L1_ctrl_reg17 == 'h11 ); 
    mte_mac_off_sleep_start7 =  (L1_ctrl_reg7 == 'h14) && (L1_ctrl_reg17 == 'h12 );
    mte_dma_sleep_start7 =  (L1_ctrl_reg7 == 'h14) && (L1_ctrl_reg17 == 'h13 );

    mte_pm_uart_to_default_start7 = (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'h1);
    mte_pm_smc_to_default_start7 = (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'h2);
    mte_pm_smc_uart_to_default_start7 = (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'h3); 
    mte_mac0_to_default7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'h4); 
    mte_mac1_to_default7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'h5); 
    mte_mac2_to_default7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'h6); 
    mte_mac3_to_default7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'h7); 
    mte_mac01_to_default7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'h8); 
    mte_mac02_to_default7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'h9); 
    mte_mac03_to_default7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'hA); 
    mte_mac12_to_default7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'hB); 
    mte_mac13_to_default7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'hC); 
    mte_mac23_to_default7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'hD); 
    mte_mac012_to_default7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'hE); 
    mte_mac013_to_default7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'hF); 
    mte_mac023_to_default7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'h10); 
    mte_mac123_to_default7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'h11); 
    mte_mac_off_to_default7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'h12); 
    mte_dma_isolate_dis7 =  (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'h13); 
    mte_cpu_isolate_dis7 =  (int_source_h7) && (cpu_shutoff_ctrl7) && (L1_ctrl_reg7 != 'h15);
    mte_sys_hibernate_to_default7 = (L1_ctrl_reg7 == 32'h0) && (L1_ctrl_reg17 == 'h15); 

   
    if (L1_ctrl_reg17 == 'h0) begin // This7 check is to make mte_cpu_start7
                                   // is set only when you from default state 
      case (L1_ctrl_reg7)
        'h0 : L1_ctrl_domain7 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain7 = 32'h2; // PM_uart7
                mte_uart_start7 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain7 = 32'h4; // PM_smc7
                mte_smc_start7 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain7 = 32'h6; // PM_smc_uart7
                mte_smc_uart_start7 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain7 = 32'h8; //  PM_macb07
                mte_mac0_start7 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain7 = 32'h10; //  PM_macb17
                mte_mac1_start7 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain7 = 32'h20; //  PM_macb27
                mte_mac2_start7 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain7 = 32'h40; //  PM_macb37
                mte_mac3_start7 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain7 = 32'h18; //  PM_macb017
                mte_mac01_start7 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain7 = 32'h28; //  PM_macb027
                mte_mac02_start7 = 1;
              end
        'hA : begin  
                L1_ctrl_domain7 = 32'h48; //  PM_macb037
                mte_mac03_start7 = 1;
              end
        'hB : begin  
                L1_ctrl_domain7 = 32'h30; //  PM_macb127
                mte_mac12_start7 = 1;
              end
        'hC : begin  
                L1_ctrl_domain7 = 32'h50; //  PM_macb137
                mte_mac13_start7 = 1;
              end
        'hD : begin  
                L1_ctrl_domain7 = 32'h60; //  PM_macb237
                mte_mac23_start7 = 1;
              end
        'hE : begin  
                L1_ctrl_domain7 = 32'h38; //  PM_macb0127
                mte_mac012_start7 = 1;
              end
        'hF : begin  
                L1_ctrl_domain7 = 32'h58; //  PM_macb0137
                mte_mac013_start7 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain7 = 32'h68; //  PM_macb0237
                mte_mac023_start7 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain7 = 32'h70; //  PM_macb1237
                mte_mac123_start7 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain7 = 32'h78; //  PM_macb_off7
                mte_mac_off_start7 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain7 = 32'h80; //  PM_dma7
                mte_dma_start7 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain7 = 32'h100; //  PM_cpu_sleep7
                mte_cpu_start7 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain7 = 32'h1FE; //  PM_hibernate7
                mte_sys_hibernate7 = 1;
              end
         default: L1_ctrl_domain7 = 32'h0;
      endcase
    end
  end


  wire to_default7 = (L1_ctrl_reg7 == 0);

  // Scan7 mode gating7 of power7 and isolation7 control7 signals7
  //SMC7
  assign rstn_non_srpg_smc7  = (scan_mode7 == 1'b0) ? rstn_non_srpg_smc_int7 : 1'b1;  
  assign gate_clk_smc7       = (scan_mode7 == 1'b0) ? gate_clk_smc_int7 : 1'b0;     
  assign isolate_smc7        = (scan_mode7 == 1'b0) ? isolate_smc_int7 : 1'b0;      
  assign pwr1_on_smc7        = (scan_mode7 == 1'b0) ? pwr1_on_smc_int7 : 1'b1;       
  assign pwr2_on_smc7        = (scan_mode7 == 1'b0) ? pwr2_on_smc_int7 : 1'b1;       
  assign pwr1_off_smc7       = (scan_mode7 == 1'b0) ? (!pwr1_on_smc_int7) : 1'b0;       
  assign pwr2_off_smc7       = (scan_mode7 == 1'b0) ? (!pwr2_on_smc_int7) : 1'b0;       
  assign save_edge_smc7       = (scan_mode7 == 1'b0) ? (save_edge_smc_int7) : 1'b0;       
  assign restore_edge_smc7       = (scan_mode7 == 1'b0) ? (restore_edge_smc_int7) : 1'b0;       

  //URT7
  assign rstn_non_srpg_urt7  = (scan_mode7 == 1'b0) ?  rstn_non_srpg_urt_int7 : 1'b1;  
  assign gate_clk_urt7       = (scan_mode7 == 1'b0) ?  gate_clk_urt_int7      : 1'b0;     
  assign isolate_urt7        = (scan_mode7 == 1'b0) ?  isolate_urt_int7       : 1'b0;      
  assign pwr1_on_urt7        = (scan_mode7 == 1'b0) ?  pwr1_on_urt_int7       : 1'b1;       
  assign pwr2_on_urt7        = (scan_mode7 == 1'b0) ?  pwr2_on_urt_int7       : 1'b1;       
  assign pwr1_off_urt7       = (scan_mode7 == 1'b0) ?  (!pwr1_on_urt_int7)  : 1'b0;       
  assign pwr2_off_urt7       = (scan_mode7 == 1'b0) ?  (!pwr2_on_urt_int7)  : 1'b0;       
  assign save_edge_urt7       = (scan_mode7 == 1'b0) ? (save_edge_urt_int7) : 1'b0;       
  assign restore_edge_urt7       = (scan_mode7 == 1'b0) ? (restore_edge_urt_int7) : 1'b0;       

  //ETH07
  assign rstn_non_srpg_macb07 = (scan_mode7 == 1'b0) ?  rstn_non_srpg_macb0_int7 : 1'b1;  
  assign gate_clk_macb07       = (scan_mode7 == 1'b0) ?  gate_clk_macb0_int7      : 1'b0;     
  assign isolate_macb07        = (scan_mode7 == 1'b0) ?  isolate_macb0_int7       : 1'b0;      
  assign pwr1_on_macb07        = (scan_mode7 == 1'b0) ?  pwr1_on_macb0_int7       : 1'b1;       
  assign pwr2_on_macb07        = (scan_mode7 == 1'b0) ?  pwr2_on_macb0_int7       : 1'b1;       
  assign pwr1_off_macb07       = (scan_mode7 == 1'b0) ?  (!pwr1_on_macb0_int7)  : 1'b0;       
  assign pwr2_off_macb07       = (scan_mode7 == 1'b0) ?  (!pwr2_on_macb0_int7)  : 1'b0;       
  assign save_edge_macb07       = (scan_mode7 == 1'b0) ? (save_edge_macb0_int7) : 1'b0;       
  assign restore_edge_macb07       = (scan_mode7 == 1'b0) ? (restore_edge_macb0_int7) : 1'b0;       

  //ETH17
  assign rstn_non_srpg_macb17 = (scan_mode7 == 1'b0) ?  rstn_non_srpg_macb1_int7 : 1'b1;  
  assign gate_clk_macb17       = (scan_mode7 == 1'b0) ?  gate_clk_macb1_int7      : 1'b0;     
  assign isolate_macb17        = (scan_mode7 == 1'b0) ?  isolate_macb1_int7       : 1'b0;      
  assign pwr1_on_macb17        = (scan_mode7 == 1'b0) ?  pwr1_on_macb1_int7       : 1'b1;       
  assign pwr2_on_macb17        = (scan_mode7 == 1'b0) ?  pwr2_on_macb1_int7       : 1'b1;       
  assign pwr1_off_macb17       = (scan_mode7 == 1'b0) ?  (!pwr1_on_macb1_int7)  : 1'b0;       
  assign pwr2_off_macb17       = (scan_mode7 == 1'b0) ?  (!pwr2_on_macb1_int7)  : 1'b0;       
  assign save_edge_macb17       = (scan_mode7 == 1'b0) ? (save_edge_macb1_int7) : 1'b0;       
  assign restore_edge_macb17       = (scan_mode7 == 1'b0) ? (restore_edge_macb1_int7) : 1'b0;       

  //ETH27
  assign rstn_non_srpg_macb27 = (scan_mode7 == 1'b0) ?  rstn_non_srpg_macb2_int7 : 1'b1;  
  assign gate_clk_macb27       = (scan_mode7 == 1'b0) ?  gate_clk_macb2_int7      : 1'b0;     
  assign isolate_macb27        = (scan_mode7 == 1'b0) ?  isolate_macb2_int7       : 1'b0;      
  assign pwr1_on_macb27        = (scan_mode7 == 1'b0) ?  pwr1_on_macb2_int7       : 1'b1;       
  assign pwr2_on_macb27        = (scan_mode7 == 1'b0) ?  pwr2_on_macb2_int7       : 1'b1;       
  assign pwr1_off_macb27       = (scan_mode7 == 1'b0) ?  (!pwr1_on_macb2_int7)  : 1'b0;       
  assign pwr2_off_macb27       = (scan_mode7 == 1'b0) ?  (!pwr2_on_macb2_int7)  : 1'b0;       
  assign save_edge_macb27       = (scan_mode7 == 1'b0) ? (save_edge_macb2_int7) : 1'b0;       
  assign restore_edge_macb27       = (scan_mode7 == 1'b0) ? (restore_edge_macb2_int7) : 1'b0;       

  //ETH37
  assign rstn_non_srpg_macb37 = (scan_mode7 == 1'b0) ?  rstn_non_srpg_macb3_int7 : 1'b1;  
  assign gate_clk_macb37       = (scan_mode7 == 1'b0) ?  gate_clk_macb3_int7      : 1'b0;     
  assign isolate_macb37        = (scan_mode7 == 1'b0) ?  isolate_macb3_int7       : 1'b0;      
  assign pwr1_on_macb37        = (scan_mode7 == 1'b0) ?  pwr1_on_macb3_int7       : 1'b1;       
  assign pwr2_on_macb37        = (scan_mode7 == 1'b0) ?  pwr2_on_macb3_int7       : 1'b1;       
  assign pwr1_off_macb37       = (scan_mode7 == 1'b0) ?  (!pwr1_on_macb3_int7)  : 1'b0;       
  assign pwr2_off_macb37       = (scan_mode7 == 1'b0) ?  (!pwr2_on_macb3_int7)  : 1'b0;       
  assign save_edge_macb37       = (scan_mode7 == 1'b0) ? (save_edge_macb3_int7) : 1'b0;       
  assign restore_edge_macb37       = (scan_mode7 == 1'b0) ? (restore_edge_macb3_int7) : 1'b0;       

  // MEM7
  assign rstn_non_srpg_mem7 =   (rstn_non_srpg_macb07 && rstn_non_srpg_macb17 && rstn_non_srpg_macb27 &&
                                rstn_non_srpg_macb37 && rstn_non_srpg_dma7 && rstn_non_srpg_cpu7 && rstn_non_srpg_urt7 &&
                                rstn_non_srpg_smc7);

  assign gate_clk_mem7 =  (gate_clk_macb07 && gate_clk_macb17 && gate_clk_macb27 &&
                            gate_clk_macb37 && gate_clk_dma7 && gate_clk_cpu7 && gate_clk_urt7 && gate_clk_smc7);

  assign isolate_mem7  = (isolate_macb07 && isolate_macb17 && isolate_macb27 &&
                         isolate_macb37 && isolate_dma7 && isolate_cpu7 && isolate_urt7 && isolate_smc7);


  assign pwr1_on_mem7        =   ~pwr1_off_mem7;

  assign pwr2_on_mem7        =   ~pwr2_off_mem7;

  assign pwr1_off_mem7       =  (pwr1_off_macb07 && pwr1_off_macb17 && pwr1_off_macb27 &&
                                 pwr1_off_macb37 && pwr1_off_dma7 && pwr1_off_cpu7 && pwr1_off_urt7 && pwr1_off_smc7);


  assign pwr2_off_mem7       =  (pwr2_off_macb07 && pwr2_off_macb17 && pwr2_off_macb27 &&
                                pwr2_off_macb37 && pwr2_off_dma7 && pwr2_off_cpu7 && pwr2_off_urt7 && pwr2_off_smc7);

  assign save_edge_mem7      =  (save_edge_macb07 && save_edge_macb17 && save_edge_macb27 &&
                                save_edge_macb37 && save_edge_dma7 && save_edge_cpu7 && save_edge_smc7 && save_edge_urt7);

  assign restore_edge_mem7   =  (restore_edge_macb07 && restore_edge_macb17 && restore_edge_macb27  &&
                                restore_edge_macb37 && restore_edge_dma7 && restore_edge_cpu7 && restore_edge_urt7 &&
                                restore_edge_smc7);

  assign standby_mem07 = pwr1_off_macb07 && (~ (pwr1_off_macb07 && pwr1_off_macb17 && pwr1_off_macb27 && pwr1_off_macb37 && pwr1_off_urt7 && pwr1_off_smc7 && pwr1_off_dma7 && pwr1_off_cpu7));
  assign standby_mem17 = pwr1_off_macb17 && (~ (pwr1_off_macb07 && pwr1_off_macb17 && pwr1_off_macb27 && pwr1_off_macb37 && pwr1_off_urt7 && pwr1_off_smc7 && pwr1_off_dma7 && pwr1_off_cpu7));
  assign standby_mem27 = pwr1_off_macb27 && (~ (pwr1_off_macb07 && pwr1_off_macb17 && pwr1_off_macb27 && pwr1_off_macb37 && pwr1_off_urt7 && pwr1_off_smc7 && pwr1_off_dma7 && pwr1_off_cpu7));
  assign standby_mem37 = pwr1_off_macb37 && (~ (pwr1_off_macb07 && pwr1_off_macb17 && pwr1_off_macb27 && pwr1_off_macb37 && pwr1_off_urt7 && pwr1_off_smc7 && pwr1_off_dma7 && pwr1_off_cpu7));

  assign pwr1_off_mem07 = pwr1_off_mem7;
  assign pwr1_off_mem17 = pwr1_off_mem7;
  assign pwr1_off_mem27 = pwr1_off_mem7;
  assign pwr1_off_mem37 = pwr1_off_mem7;

  assign rstn_non_srpg_alut7  =  (rstn_non_srpg_macb07 && rstn_non_srpg_macb17 && rstn_non_srpg_macb27 && rstn_non_srpg_macb37);


   assign gate_clk_alut7       =  (gate_clk_macb07 && gate_clk_macb17 && gate_clk_macb27 && gate_clk_macb37);


    assign isolate_alut7        =  (isolate_macb07 && isolate_macb17 && isolate_macb27 && isolate_macb37);


    assign pwr1_on_alut7        =  (pwr1_on_macb07 || pwr1_on_macb17 || pwr1_on_macb27 || pwr1_on_macb37);


    assign pwr2_on_alut7        =  (pwr2_on_macb07 || pwr2_on_macb17 || pwr2_on_macb27 || pwr2_on_macb37);


    assign pwr1_off_alut7       =  (pwr1_off_macb07 && pwr1_off_macb17 && pwr1_off_macb27 && pwr1_off_macb37);


    assign pwr2_off_alut7       =  (pwr2_off_macb07 && pwr2_off_macb17 && pwr2_off_macb27 && pwr2_off_macb37);


    assign save_edge_alut7      =  (save_edge_macb07 && save_edge_macb17 && save_edge_macb27 && save_edge_macb37);


    assign restore_edge_alut7   =  (restore_edge_macb07 || restore_edge_macb17 || restore_edge_macb27 ||
                                   restore_edge_macb37) && save_alut_tmp7;

     // alut7 power7 off7 detection7
  always @(posedge pclk7 or negedge nprst7) begin
    if (!nprst7) 
       save_alut_tmp7 <= 0;
    else if (restore_edge_alut7)
       save_alut_tmp7 <= 0;
    else if (save_edge_alut7)
       save_alut_tmp7 <= 1;
  end

  //DMA7
  assign rstn_non_srpg_dma7 = (scan_mode7 == 1'b0) ?  rstn_non_srpg_dma_int7 : 1'b1;  
  assign gate_clk_dma7       = (scan_mode7 == 1'b0) ?  gate_clk_dma_int7      : 1'b0;     
  assign isolate_dma7        = (scan_mode7 == 1'b0) ?  isolate_dma_int7       : 1'b0;      
  assign pwr1_on_dma7        = (scan_mode7 == 1'b0) ?  pwr1_on_dma_int7       : 1'b1;       
  assign pwr2_on_dma7        = (scan_mode7 == 1'b0) ?  pwr2_on_dma_int7       : 1'b1;       
  assign pwr1_off_dma7       = (scan_mode7 == 1'b0) ?  (!pwr1_on_dma_int7)  : 1'b0;       
  assign pwr2_off_dma7       = (scan_mode7 == 1'b0) ?  (!pwr2_on_dma_int7)  : 1'b0;       
  assign save_edge_dma7       = (scan_mode7 == 1'b0) ? (save_edge_dma_int7) : 1'b0;       
  assign restore_edge_dma7       = (scan_mode7 == 1'b0) ? (restore_edge_dma_int7) : 1'b0;       

  //CPU7
  assign rstn_non_srpg_cpu7 = (scan_mode7 == 1'b0) ?  rstn_non_srpg_cpu_int7 : 1'b1;  
  assign gate_clk_cpu7       = (scan_mode7 == 1'b0) ?  gate_clk_cpu_int7      : 1'b0;     
  assign isolate_cpu7        = (scan_mode7 == 1'b0) ?  isolate_cpu_int7       : 1'b0;      
  assign pwr1_on_cpu7        = (scan_mode7 == 1'b0) ?  pwr1_on_cpu_int7       : 1'b1;       
  assign pwr2_on_cpu7        = (scan_mode7 == 1'b0) ?  pwr2_on_cpu_int7       : 1'b1;       
  assign pwr1_off_cpu7       = (scan_mode7 == 1'b0) ?  (!pwr1_on_cpu_int7)  : 1'b0;       
  assign pwr2_off_cpu7       = (scan_mode7 == 1'b0) ?  (!pwr2_on_cpu_int7)  : 1'b0;       
  assign save_edge_cpu7       = (scan_mode7 == 1'b0) ? (save_edge_cpu_int7) : 1'b0;       
  assign restore_edge_cpu7       = (scan_mode7 == 1'b0) ? (restore_edge_cpu_int7) : 1'b0;       



  // ASE7

   reg ase_core_12v7, ase_core_10v7, ase_core_08v7, ase_core_06v7;
   reg ase_macb0_12v7,ase_macb1_12v7,ase_macb2_12v7,ase_macb3_12v7;

    // core7 ase7

    // core7 at 1.0 v if (smc7 off7, urt7 off7, macb07 off7, macb17 off7, macb27 off7, macb37 off7
   // core7 at 0.8v if (mac01off7, macb02off7, macb03off7, macb12off7, mac13off7, mac23off7,
   // core7 at 0.6v if (mac012off7, mac013off7, mac023off7, mac123off7, mac0123off7
    // else core7 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb07 && pwr1_off_macb17 && pwr1_off_macb27 && pwr1_off_macb37) || // all mac7 off7
       (pwr1_off_macb37 && pwr1_off_macb27 && pwr1_off_macb17) || // mac123off7 
       (pwr1_off_macb37 && pwr1_off_macb27 && pwr1_off_macb07) || // mac023off7 
       (pwr1_off_macb37 && pwr1_off_macb17 && pwr1_off_macb07) || // mac013off7 
       (pwr1_off_macb27 && pwr1_off_macb17 && pwr1_off_macb07) )  // mac012off7 
       begin
         ase_core_12v7 = 0;
         ase_core_10v7 = 0;
         ase_core_08v7 = 0;
         ase_core_06v7 = 1;
       end
     else if( (pwr1_off_macb27 && pwr1_off_macb37) || // mac237 off7
         (pwr1_off_macb37 && pwr1_off_macb17) || // mac13off7 
         (pwr1_off_macb17 && pwr1_off_macb27) || // mac12off7 
         (pwr1_off_macb37 && pwr1_off_macb07) || // mac03off7 
         (pwr1_off_macb27 && pwr1_off_macb07) || // mac02off7 
         (pwr1_off_macb17 && pwr1_off_macb07))  // mac01off7 
       begin
         ase_core_12v7 = 0;
         ase_core_10v7 = 0;
         ase_core_08v7 = 1;
         ase_core_06v7 = 0;
       end
     else if( (pwr1_off_smc7) || // smc7 off7
         (pwr1_off_macb07 ) || // mac0off7 
         (pwr1_off_macb17 ) || // mac1off7 
         (pwr1_off_macb27 ) || // mac2off7 
         (pwr1_off_macb37 ))  // mac3off7 
       begin
         ase_core_12v7 = 0;
         ase_core_10v7 = 1;
         ase_core_08v7 = 0;
         ase_core_06v7 = 0;
       end
     else if (pwr1_off_urt7)
       begin
         ase_core_12v7 = 1;
         ase_core_10v7 = 0;
         ase_core_08v7 = 0;
         ase_core_06v7 = 0;
       end
     else
       begin
         ase_core_12v7 = 1;
         ase_core_10v7 = 0;
         ase_core_08v7 = 0;
         ase_core_06v7 = 0;
       end
   end


   // cpu7
   // cpu7 @ 1.0v when macoff7, 
   // 
   reg ase_cpu_10v7, ase_cpu_12v7;
   always @(*) begin
    if(pwr1_off_cpu7) begin
     ase_cpu_12v7 = 1'b0;
     ase_cpu_10v7 = 1'b0;
    end
    else if(pwr1_off_macb07 || pwr1_off_macb17 || pwr1_off_macb27 || pwr1_off_macb37)
    begin
     ase_cpu_12v7 = 1'b0;
     ase_cpu_10v7 = 1'b1;
    end
    else
    begin
     ase_cpu_12v7 = 1'b1;
     ase_cpu_10v7 = 1'b0;
    end
   end

   // dma7
   // dma7 @v17.0 for macoff7, 

   reg ase_dma_10v7, ase_dma_12v7;
   always @(*) begin
    if(pwr1_off_dma7) begin
     ase_dma_12v7 = 1'b0;
     ase_dma_10v7 = 1'b0;
    end
    else if(pwr1_off_macb07 || pwr1_off_macb17 || pwr1_off_macb27 || pwr1_off_macb37)
    begin
     ase_dma_12v7 = 1'b0;
     ase_dma_10v7 = 1'b1;
    end
    else
    begin
     ase_dma_12v7 = 1'b1;
     ase_dma_10v7 = 1'b0;
    end
   end

   // alut7
   // @ v17.0 for macoff7

   reg ase_alut_10v7, ase_alut_12v7;
   always @(*) begin
    if(pwr1_off_alut7) begin
     ase_alut_12v7 = 1'b0;
     ase_alut_10v7 = 1'b0;
    end
    else if(pwr1_off_macb07 || pwr1_off_macb17 || pwr1_off_macb27 || pwr1_off_macb37)
    begin
     ase_alut_12v7 = 1'b0;
     ase_alut_10v7 = 1'b1;
    end
    else
    begin
     ase_alut_12v7 = 1'b1;
     ase_alut_10v7 = 1'b0;
    end
   end




   reg ase_uart_12v7;
   reg ase_uart_10v7;
   reg ase_uart_08v7;
   reg ase_uart_06v7;

   reg ase_smc_12v7;


   always @(*) begin
     if(pwr1_off_urt7) begin // uart7 off7
       ase_uart_08v7 = 1'b0;
       ase_uart_06v7 = 1'b0;
       ase_uart_10v7 = 1'b0;
       ase_uart_12v7 = 1'b0;
     end 
     else if( (pwr1_off_macb07 && pwr1_off_macb17 && pwr1_off_macb27 && pwr1_off_macb37) || // all mac7 off7
       (pwr1_off_macb37 && pwr1_off_macb27 && pwr1_off_macb17) || // mac123off7 
       (pwr1_off_macb37 && pwr1_off_macb27 && pwr1_off_macb07) || // mac023off7 
       (pwr1_off_macb37 && pwr1_off_macb17 && pwr1_off_macb07) || // mac013off7 
       (pwr1_off_macb27 && pwr1_off_macb17 && pwr1_off_macb07) )  // mac012off7 
     begin
       ase_uart_06v7 = 1'b1;
       ase_uart_08v7 = 1'b0;
       ase_uart_10v7 = 1'b0;
       ase_uart_12v7 = 1'b0;
     end
     else if( (pwr1_off_macb27 && pwr1_off_macb37) || // mac237 off7
         (pwr1_off_macb37 && pwr1_off_macb17) || // mac13off7 
         (pwr1_off_macb17 && pwr1_off_macb27) || // mac12off7 
         (pwr1_off_macb37 && pwr1_off_macb07) || // mac03off7 
         (pwr1_off_macb17 && pwr1_off_macb07))  // mac01off7  
     begin
       ase_uart_06v7 = 1'b0;
       ase_uart_08v7 = 1'b1;
       ase_uart_10v7 = 1'b0;
       ase_uart_12v7 = 1'b0;
     end
     else if (pwr1_off_smc7 || pwr1_off_macb07 || pwr1_off_macb17 || pwr1_off_macb27 || pwr1_off_macb37) begin // smc7 off7
       ase_uart_08v7 = 1'b0;
       ase_uart_06v7 = 1'b0;
       ase_uart_10v7 = 1'b1;
       ase_uart_12v7 = 1'b0;
     end 
     else begin
       ase_uart_08v7 = 1'b0;
       ase_uart_06v7 = 1'b0;
       ase_uart_10v7 = 1'b0;
       ase_uart_12v7 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc7) begin
     if (pwr1_off_smc7)  // smc7 off7
       ase_smc_12v7 = 1'b0;
    else
       ase_smc_12v7 = 1'b1;
   end

   
   always @(pwr1_off_macb07) begin
     if (pwr1_off_macb07) // macb07 off7
       ase_macb0_12v7 = 1'b0;
     else
       ase_macb0_12v7 = 1'b1;
   end

   always @(pwr1_off_macb17) begin
     if (pwr1_off_macb17) // macb17 off7
       ase_macb1_12v7 = 1'b0;
     else
       ase_macb1_12v7 = 1'b1;
   end

   always @(pwr1_off_macb27) begin // macb27 off7
     if (pwr1_off_macb27) // macb27 off7
       ase_macb2_12v7 = 1'b0;
     else
       ase_macb2_12v7 = 1'b1;
   end

   always @(pwr1_off_macb37) begin // macb37 off7
     if (pwr1_off_macb37) // macb37 off7
       ase_macb3_12v7 = 1'b0;
     else
       ase_macb3_12v7 = 1'b1;
   end


   // core7 voltage7 for vco7
  assign core12v7 = ase_macb0_12v7 & ase_macb1_12v7 & ase_macb2_12v7 & ase_macb3_12v7;

  assign core10v7 =  (ase_macb0_12v7 & ase_macb1_12v7 & ase_macb2_12v7 & (!ase_macb3_12v7)) ||
                    (ase_macb0_12v7 & ase_macb1_12v7 & (!ase_macb2_12v7) & ase_macb3_12v7) ||
                    (ase_macb0_12v7 & (!ase_macb1_12v7) & ase_macb2_12v7 & ase_macb3_12v7) ||
                    ((!ase_macb0_12v7) & ase_macb1_12v7 & ase_macb2_12v7 & ase_macb3_12v7);

  assign core08v7 =  ((!ase_macb0_12v7) & (!ase_macb1_12v7) & (ase_macb2_12v7) & (ase_macb3_12v7)) ||
                    ((!ase_macb0_12v7) & (ase_macb1_12v7) & (!ase_macb2_12v7) & (ase_macb3_12v7)) ||
                    ((!ase_macb0_12v7) & (ase_macb1_12v7) & (ase_macb2_12v7) & (!ase_macb3_12v7)) ||
                    ((ase_macb0_12v7) & (!ase_macb1_12v7) & (!ase_macb2_12v7) & (ase_macb3_12v7)) ||
                    ((ase_macb0_12v7) & (!ase_macb1_12v7) & (ase_macb2_12v7) & (!ase_macb3_12v7)) ||
                    ((ase_macb0_12v7) & (ase_macb1_12v7) & (!ase_macb2_12v7) & (!ase_macb3_12v7));

  assign core06v7 =  ((!ase_macb0_12v7) & (!ase_macb1_12v7) & (!ase_macb2_12v7) & (ase_macb3_12v7)) ||
                    ((!ase_macb0_12v7) & (!ase_macb1_12v7) & (ase_macb2_12v7) & (!ase_macb3_12v7)) ||
                    ((!ase_macb0_12v7) & (ase_macb1_12v7) & (!ase_macb2_12v7) & (!ase_macb3_12v7)) ||
                    ((ase_macb0_12v7) & (!ase_macb1_12v7) & (!ase_macb2_12v7) & (!ase_macb3_12v7)) ||
                    ((!ase_macb0_12v7) & (!ase_macb1_12v7) & (!ase_macb2_12v7) & (!ase_macb3_12v7)) ;



`ifdef LP_ABV_ON7
// psl7 default clock7 = (posedge pclk7);

// Cover7 a condition in which SMC7 is powered7 down
// and again7 powered7 up while UART7 is going7 into POWER7 down
// state or UART7 is already in POWER7 DOWN7 state
// psl7 cover_overlapping_smc_urt_17:
//    cover{fell7(pwr1_on_urt7);[*];fell7(pwr1_on_smc7);[*];
//    rose7(pwr1_on_smc7);[*];rose7(pwr1_on_urt7)};
//
// Cover7 a condition in which UART7 is powered7 down
// and again7 powered7 up while SMC7 is going7 into POWER7 down
// state or SMC7 is already in POWER7 DOWN7 state
// psl7 cover_overlapping_smc_urt_27:
//    cover{fell7(pwr1_on_smc7);[*];fell7(pwr1_on_urt7);[*];
//    rose7(pwr1_on_urt7);[*];rose7(pwr1_on_smc7)};
//


// Power7 Down7 UART7
// This7 gets7 triggered on rising7 edge of Gate7 signal7 for
// UART7 (gate_clk_urt7). In a next cycle after gate_clk_urt7,
// Isolate7 UART7(isolate_urt7) signal7 become7 HIGH7 (active).
// In 2nd cycle after gate_clk_urt7 becomes HIGH7, RESET7 for NON7
// SRPG7 FFs7(rstn_non_srpg_urt7) and POWER17 for UART7(pwr1_on_urt7) should 
// go7 LOW7. 
// This7 completes7 a POWER7 DOWN7. 

sequence s_power_down_urt7;
      (gate_clk_urt7 & !isolate_urt7 & rstn_non_srpg_urt7 & pwr1_on_urt7) 
  ##1 (gate_clk_urt7 & isolate_urt7 & rstn_non_srpg_urt7 & pwr1_on_urt7) 
  ##3 (gate_clk_urt7 & isolate_urt7 & !rstn_non_srpg_urt7 & !pwr1_on_urt7);
endsequence


property p_power_down_urt7;
   @(posedge pclk7)
    $rose(gate_clk_urt7) |=> s_power_down_urt7;
endproperty

output_power_down_urt7:
  assert property (p_power_down_urt7);


// Power7 UP7 UART7
// Sequence starts with , Rising7 edge of pwr1_on_urt7.
// Two7 clock7 cycle after this, isolate_urt7 should become7 LOW7 
// On7 the following7 clk7 gate_clk_urt7 should go7 low7.
// 5 cycles7 after  Rising7 edge of pwr1_on_urt7, rstn_non_srpg_urt7
// should become7 HIGH7
sequence s_power_up_urt7;
##30 (pwr1_on_urt7 & !isolate_urt7 & gate_clk_urt7 & !rstn_non_srpg_urt7) 
##1 (pwr1_on_urt7 & !isolate_urt7 & !gate_clk_urt7 & !rstn_non_srpg_urt7) 
##2 (pwr1_on_urt7 & !isolate_urt7 & !gate_clk_urt7 & rstn_non_srpg_urt7);
endsequence

property p_power_up_urt7;
   @(posedge pclk7)
  disable iff(!nprst7)
    (!pwr1_on_urt7 ##1 pwr1_on_urt7) |=> s_power_up_urt7;
endproperty

output_power_up_urt7:
  assert property (p_power_up_urt7);


// Power7 Down7 SMC7
// This7 gets7 triggered on rising7 edge of Gate7 signal7 for
// SMC7 (gate_clk_smc7). In a next cycle after gate_clk_smc7,
// Isolate7 SMC7(isolate_smc7) signal7 become7 HIGH7 (active).
// In 2nd cycle after gate_clk_smc7 becomes HIGH7, RESET7 for NON7
// SRPG7 FFs7(rstn_non_srpg_smc7) and POWER17 for SMC7(pwr1_on_smc7) should 
// go7 LOW7. 
// This7 completes7 a POWER7 DOWN7. 

sequence s_power_down_smc7;
      (gate_clk_smc7 & !isolate_smc7 & rstn_non_srpg_smc7 & pwr1_on_smc7) 
  ##1 (gate_clk_smc7 & isolate_smc7 & rstn_non_srpg_smc7 & pwr1_on_smc7) 
  ##3 (gate_clk_smc7 & isolate_smc7 & !rstn_non_srpg_smc7 & !pwr1_on_smc7);
endsequence


property p_power_down_smc7;
   @(posedge pclk7)
    $rose(gate_clk_smc7) |=> s_power_down_smc7;
endproperty

output_power_down_smc7:
  assert property (p_power_down_smc7);


// Power7 UP7 SMC7
// Sequence starts with , Rising7 edge of pwr1_on_smc7.
// Two7 clock7 cycle after this, isolate_smc7 should become7 LOW7 
// On7 the following7 clk7 gate_clk_smc7 should go7 low7.
// 5 cycles7 after  Rising7 edge of pwr1_on_smc7, rstn_non_srpg_smc7
// should become7 HIGH7
sequence s_power_up_smc7;
##30 (pwr1_on_smc7 & !isolate_smc7 & gate_clk_smc7 & !rstn_non_srpg_smc7) 
##1 (pwr1_on_smc7 & !isolate_smc7 & !gate_clk_smc7 & !rstn_non_srpg_smc7) 
##2 (pwr1_on_smc7 & !isolate_smc7 & !gate_clk_smc7 & rstn_non_srpg_smc7);
endsequence

property p_power_up_smc7;
   @(posedge pclk7)
  disable iff(!nprst7)
    (!pwr1_on_smc7 ##1 pwr1_on_smc7) |=> s_power_up_smc7;
endproperty

output_power_up_smc7:
  assert property (p_power_up_smc7);


// COVER7 SMC7 POWER7 DOWN7 AND7 UP7
cover_power_down_up_smc7: cover property (@(posedge pclk7)
(s_power_down_smc7 ##[5:180] s_power_up_smc7));



// COVER7 UART7 POWER7 DOWN7 AND7 UP7
cover_power_down_up_urt7: cover property (@(posedge pclk7)
(s_power_down_urt7 ##[5:180] s_power_up_urt7));

cover_power_down_urt7: cover property (@(posedge pclk7)
(s_power_down_urt7));

cover_power_up_urt7: cover property (@(posedge pclk7)
(s_power_up_urt7));




`ifdef PCM_ABV_ON7
//------------------------------------------------------------------------------
// Power7 Controller7 Formal7 Verification7 component.  Each power7 domain has a 
// separate7 instantiation7
//------------------------------------------------------------------------------

// need to assume that CPU7 will leave7 a minimum time between powering7 down and 
// back up.  In this example7, 10clks has been selected.
// psl7 config_min_uart_pd_time7 : assume always {rose7(L1_ctrl_domain7[1])} |-> { L1_ctrl_domain7[1][*10] } abort7(~nprst7);
// psl7 config_min_uart_pu_time7 : assume always {fell7(L1_ctrl_domain7[1])} |-> { !L1_ctrl_domain7[1][*10] } abort7(~nprst7);
// psl7 config_min_smc_pd_time7 : assume always {rose7(L1_ctrl_domain7[2])} |-> { L1_ctrl_domain7[2][*10] } abort7(~nprst7);
// psl7 config_min_smc_pu_time7 : assume always {fell7(L1_ctrl_domain7[2])} |-> { !L1_ctrl_domain7[2][*10] } abort7(~nprst7);

// UART7 VCOMP7 parameters7
   defparam i_uart_vcomp_domain7.ENABLE_SAVE_RESTORE_EDGE7   = 1;
   defparam i_uart_vcomp_domain7.ENABLE_EXT_PWR_CNTRL7       = 1;
   defparam i_uart_vcomp_domain7.REF_CLK_DEFINED7            = 0;
   defparam i_uart_vcomp_domain7.MIN_SHUTOFF_CYCLES7         = 4;
   defparam i_uart_vcomp_domain7.MIN_RESTORE_TO_ISO_CYCLES7  = 0;
   defparam i_uart_vcomp_domain7.MIN_SAVE_TO_SHUTOFF_CYCLES7 = 1;


   vcomp_domain7 i_uart_vcomp_domain7
   ( .ref_clk7(pclk7),
     .start_lps7(L1_ctrl_domain7[1] || !rstn_non_srpg_urt7),
     .rst_n7(nprst7),
     .ext_power_down7(L1_ctrl_domain7[1]),
     .iso_en7(isolate_urt7),
     .save_edge7(save_edge_urt7),
     .restore_edge7(restore_edge_urt7),
     .domain_shut_off7(pwr1_off_urt7),
     .domain_clk7(!gate_clk_urt7 && pclk7)
   );


// SMC7 VCOMP7 parameters7
   defparam i_smc_vcomp_domain7.ENABLE_SAVE_RESTORE_EDGE7   = 1;
   defparam i_smc_vcomp_domain7.ENABLE_EXT_PWR_CNTRL7       = 1;
   defparam i_smc_vcomp_domain7.REF_CLK_DEFINED7            = 0;
   defparam i_smc_vcomp_domain7.MIN_SHUTOFF_CYCLES7         = 4;
   defparam i_smc_vcomp_domain7.MIN_RESTORE_TO_ISO_CYCLES7  = 0;
   defparam i_smc_vcomp_domain7.MIN_SAVE_TO_SHUTOFF_CYCLES7 = 1;


   vcomp_domain7 i_smc_vcomp_domain7
   ( .ref_clk7(pclk7),
     .start_lps7(L1_ctrl_domain7[2] || !rstn_non_srpg_smc7),
     .rst_n7(nprst7),
     .ext_power_down7(L1_ctrl_domain7[2]),
     .iso_en7(isolate_smc7),
     .save_edge7(save_edge_smc7),
     .restore_edge7(restore_edge_smc7),
     .domain_shut_off7(pwr1_off_smc7),
     .domain_clk7(!gate_clk_smc7 && pclk7)
   );

`endif

`endif



endmodule
