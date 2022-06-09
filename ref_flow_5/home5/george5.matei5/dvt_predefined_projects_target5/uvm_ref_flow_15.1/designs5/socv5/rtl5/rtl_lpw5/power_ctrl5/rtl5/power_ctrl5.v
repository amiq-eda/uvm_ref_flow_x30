//File5 name   : power_ctrl5.v
//Title5       : Power5 Control5 Module5
//Created5     : 1999
//Description5 : Top5 level of power5 controller5
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

module power_ctrl5 (


    // Clocks5 & Reset5
    pclk5,
    nprst5,
    // APB5 programming5 interface
    paddr5,
    psel5,
    penable5,
    pwrite5,
    pwdata5,
    prdata5,
    // mac5 i/f,
    macb3_wakeup5,
    macb2_wakeup5,
    macb1_wakeup5,
    macb0_wakeup5,
    // Scan5 
    scan_in5,
    scan_en5,
    scan_mode5,
    scan_out5,
    // Module5 control5 outputs5
    int_source_h5,
    // SMC5
    rstn_non_srpg_smc5,
    gate_clk_smc5,
    isolate_smc5,
    save_edge_smc5,
    restore_edge_smc5,
    pwr1_on_smc5,
    pwr2_on_smc5,
    pwr1_off_smc5,
    pwr2_off_smc5,
    // URT5
    rstn_non_srpg_urt5,
    gate_clk_urt5,
    isolate_urt5,
    save_edge_urt5,
    restore_edge_urt5,
    pwr1_on_urt5,
    pwr2_on_urt5,
    pwr1_off_urt5,      
    pwr2_off_urt5,
    // ETH05
    rstn_non_srpg_macb05,
    gate_clk_macb05,
    isolate_macb05,
    save_edge_macb05,
    restore_edge_macb05,
    pwr1_on_macb05,
    pwr2_on_macb05,
    pwr1_off_macb05,      
    pwr2_off_macb05,
    // ETH15
    rstn_non_srpg_macb15,
    gate_clk_macb15,
    isolate_macb15,
    save_edge_macb15,
    restore_edge_macb15,
    pwr1_on_macb15,
    pwr2_on_macb15,
    pwr1_off_macb15,      
    pwr2_off_macb15,
    // ETH25
    rstn_non_srpg_macb25,
    gate_clk_macb25,
    isolate_macb25,
    save_edge_macb25,
    restore_edge_macb25,
    pwr1_on_macb25,
    pwr2_on_macb25,
    pwr1_off_macb25,      
    pwr2_off_macb25,
    // ETH35
    rstn_non_srpg_macb35,
    gate_clk_macb35,
    isolate_macb35,
    save_edge_macb35,
    restore_edge_macb35,
    pwr1_on_macb35,
    pwr2_on_macb35,
    pwr1_off_macb35,      
    pwr2_off_macb35,
    // DMA5
    rstn_non_srpg_dma5,
    gate_clk_dma5,
    isolate_dma5,
    save_edge_dma5,
    restore_edge_dma5,
    pwr1_on_dma5,
    pwr2_on_dma5,
    pwr1_off_dma5,      
    pwr2_off_dma5,
    // CPU5
    rstn_non_srpg_cpu5,
    gate_clk_cpu5,
    isolate_cpu5,
    save_edge_cpu5,
    restore_edge_cpu5,
    pwr1_on_cpu5,
    pwr2_on_cpu5,
    pwr1_off_cpu5,      
    pwr2_off_cpu5,
    // ALUT5
    rstn_non_srpg_alut5,
    gate_clk_alut5,
    isolate_alut5,
    save_edge_alut5,
    restore_edge_alut5,
    pwr1_on_alut5,
    pwr2_on_alut5,
    pwr1_off_alut5,      
    pwr2_off_alut5,
    // MEM5
    rstn_non_srpg_mem5,
    gate_clk_mem5,
    isolate_mem5,
    save_edge_mem5,
    restore_edge_mem5,
    pwr1_on_mem5,
    pwr2_on_mem5,
    pwr1_off_mem5,      
    pwr2_off_mem5,
    // core5 dvfs5 transitions5
    core06v5,
    core08v5,
    core10v5,
    core12v5,
    pcm_macb_wakeup_int5,
    // mte5 signals5
    mte_smc_start5,
    mte_uart_start5,
    mte_smc_uart_start5,  
    mte_pm_smc_to_default_start5, 
    mte_pm_uart_to_default_start5,
    mte_pm_smc_uart_to_default_start5

  );

  parameter STATE_IDLE_12V5 = 4'b0001;
  parameter STATE_06V5 = 4'b0010;
  parameter STATE_08V5 = 4'b0100;
  parameter STATE_10V5 = 4'b1000;

    // Clocks5 & Reset5
    input pclk5;
    input nprst5;
    // APB5 programming5 interface
    input [31:0] paddr5;
    input psel5  ;
    input penable5;
    input pwrite5 ;
    input [31:0] pwdata5;
    output [31:0] prdata5;
    // mac5
    input macb3_wakeup5;
    input macb2_wakeup5;
    input macb1_wakeup5;
    input macb0_wakeup5;
    // Scan5 
    input scan_in5;
    input scan_en5;
    input scan_mode5;
    output scan_out5;
    // Module5 control5 outputs5
    input int_source_h5;
    // SMC5
    output rstn_non_srpg_smc5 ;
    output gate_clk_smc5   ;
    output isolate_smc5   ;
    output save_edge_smc5   ;
    output restore_edge_smc5   ;
    output pwr1_on_smc5   ;
    output pwr2_on_smc5   ;
    output pwr1_off_smc5  ;
    output pwr2_off_smc5  ;
    // URT5
    output rstn_non_srpg_urt5 ;
    output gate_clk_urt5      ;
    output isolate_urt5       ;
    output save_edge_urt5   ;
    output restore_edge_urt5   ;
    output pwr1_on_urt5       ;
    output pwr2_on_urt5       ;
    output pwr1_off_urt5      ;
    output pwr2_off_urt5      ;
    // ETH05
    output rstn_non_srpg_macb05 ;
    output gate_clk_macb05      ;
    output isolate_macb05       ;
    output save_edge_macb05   ;
    output restore_edge_macb05   ;
    output pwr1_on_macb05       ;
    output pwr2_on_macb05       ;
    output pwr1_off_macb05      ;
    output pwr2_off_macb05      ;
    // ETH15
    output rstn_non_srpg_macb15 ;
    output gate_clk_macb15      ;
    output isolate_macb15       ;
    output save_edge_macb15   ;
    output restore_edge_macb15   ;
    output pwr1_on_macb15       ;
    output pwr2_on_macb15       ;
    output pwr1_off_macb15      ;
    output pwr2_off_macb15      ;
    // ETH25
    output rstn_non_srpg_macb25 ;
    output gate_clk_macb25      ;
    output isolate_macb25       ;
    output save_edge_macb25   ;
    output restore_edge_macb25   ;
    output pwr1_on_macb25       ;
    output pwr2_on_macb25       ;
    output pwr1_off_macb25      ;
    output pwr2_off_macb25      ;
    // ETH35
    output rstn_non_srpg_macb35 ;
    output gate_clk_macb35      ;
    output isolate_macb35       ;
    output save_edge_macb35   ;
    output restore_edge_macb35   ;
    output pwr1_on_macb35       ;
    output pwr2_on_macb35       ;
    output pwr1_off_macb35      ;
    output pwr2_off_macb35      ;
    // DMA5
    output rstn_non_srpg_dma5 ;
    output gate_clk_dma5      ;
    output isolate_dma5       ;
    output save_edge_dma5   ;
    output restore_edge_dma5   ;
    output pwr1_on_dma5       ;
    output pwr2_on_dma5       ;
    output pwr1_off_dma5      ;
    output pwr2_off_dma5      ;
    // CPU5
    output rstn_non_srpg_cpu5 ;
    output gate_clk_cpu5      ;
    output isolate_cpu5       ;
    output save_edge_cpu5   ;
    output restore_edge_cpu5   ;
    output pwr1_on_cpu5       ;
    output pwr2_on_cpu5       ;
    output pwr1_off_cpu5      ;
    output pwr2_off_cpu5      ;
    // ALUT5
    output rstn_non_srpg_alut5 ;
    output gate_clk_alut5      ;
    output isolate_alut5       ;
    output save_edge_alut5   ;
    output restore_edge_alut5   ;
    output pwr1_on_alut5       ;
    output pwr2_on_alut5       ;
    output pwr1_off_alut5      ;
    output pwr2_off_alut5      ;
    // MEM5
    output rstn_non_srpg_mem5 ;
    output gate_clk_mem5      ;
    output isolate_mem5       ;
    output save_edge_mem5   ;
    output restore_edge_mem5   ;
    output pwr1_on_mem5       ;
    output pwr2_on_mem5       ;
    output pwr1_off_mem5      ;
    output pwr2_off_mem5      ;


   // core5 transitions5 o/p
    output core06v5;
    output core08v5;
    output core10v5;
    output core12v5;
    output pcm_macb_wakeup_int5 ;
    //mode mte5  signals5
    output mte_smc_start5;
    output mte_uart_start5;
    output mte_smc_uart_start5;  
    output mte_pm_smc_to_default_start5; 
    output mte_pm_uart_to_default_start5;
    output mte_pm_smc_uart_to_default_start5;

    reg mte_smc_start5;
    reg mte_uart_start5;
    reg mte_smc_uart_start5;  
    reg mte_pm_smc_to_default_start5; 
    reg mte_pm_uart_to_default_start5;
    reg mte_pm_smc_uart_to_default_start5;

    reg [31:0] prdata5;

  wire valid_reg_write5  ;
  wire valid_reg_read5   ;
  wire L1_ctrl_access5   ;
  wire L1_status_access5 ;
  wire pcm_int_mask_access5;
  wire pcm_int_status_access5;
  wire standby_mem05      ;
  wire standby_mem15      ;
  wire standby_mem25      ;
  wire standby_mem35      ;
  wire pwr1_off_mem05;
  wire pwr1_off_mem15;
  wire pwr1_off_mem25;
  wire pwr1_off_mem35;
  
  // Control5 signals5
  wire set_status_smc5   ;
  wire clr_status_smc5   ;
  wire set_status_urt5   ;
  wire clr_status_urt5   ;
  wire set_status_macb05   ;
  wire clr_status_macb05   ;
  wire set_status_macb15   ;
  wire clr_status_macb15   ;
  wire set_status_macb25   ;
  wire clr_status_macb25   ;
  wire set_status_macb35   ;
  wire clr_status_macb35   ;
  wire set_status_dma5   ;
  wire clr_status_dma5   ;
  wire set_status_cpu5   ;
  wire clr_status_cpu5   ;
  wire set_status_alut5   ;
  wire clr_status_alut5   ;
  wire set_status_mem5   ;
  wire clr_status_mem5   ;


  // Status and Control5 registers
  reg [31:0]  L1_status_reg5;
  reg  [31:0] L1_ctrl_reg5  ;
  reg  [31:0] L1_ctrl_domain5  ;
  reg L1_ctrl_cpu_off_reg5;
  reg [31:0]  pcm_mask_reg5;
  reg [31:0]  pcm_status_reg5;

  // Signals5 gated5 in scan_mode5
  //SMC5
  wire  rstn_non_srpg_smc_int5;
  wire  gate_clk_smc_int5    ;     
  wire  isolate_smc_int5    ;       
  wire save_edge_smc_int5;
  wire restore_edge_smc_int5;
  wire  pwr1_on_smc_int5    ;      
  wire  pwr2_on_smc_int5    ;      


  //URT5
  wire   rstn_non_srpg_urt_int5;
  wire   gate_clk_urt_int5     ;     
  wire   isolate_urt_int5      ;       
  wire save_edge_urt_int5;
  wire restore_edge_urt_int5;
  wire   pwr1_on_urt_int5      ;      
  wire   pwr2_on_urt_int5      ;      

  // ETH05
  wire   rstn_non_srpg_macb0_int5;
  wire   gate_clk_macb0_int5     ;     
  wire   isolate_macb0_int5      ;       
  wire save_edge_macb0_int5;
  wire restore_edge_macb0_int5;
  wire   pwr1_on_macb0_int5      ;      
  wire   pwr2_on_macb0_int5      ;      
  // ETH15
  wire   rstn_non_srpg_macb1_int5;
  wire   gate_clk_macb1_int5     ;     
  wire   isolate_macb1_int5      ;       
  wire save_edge_macb1_int5;
  wire restore_edge_macb1_int5;
  wire   pwr1_on_macb1_int5      ;      
  wire   pwr2_on_macb1_int5      ;      
  // ETH25
  wire   rstn_non_srpg_macb2_int5;
  wire   gate_clk_macb2_int5     ;     
  wire   isolate_macb2_int5      ;       
  wire save_edge_macb2_int5;
  wire restore_edge_macb2_int5;
  wire   pwr1_on_macb2_int5      ;      
  wire   pwr2_on_macb2_int5      ;      
  // ETH35
  wire   rstn_non_srpg_macb3_int5;
  wire   gate_clk_macb3_int5     ;     
  wire   isolate_macb3_int5      ;       
  wire save_edge_macb3_int5;
  wire restore_edge_macb3_int5;
  wire   pwr1_on_macb3_int5      ;      
  wire   pwr2_on_macb3_int5      ;      

  // DMA5
  wire   rstn_non_srpg_dma_int5;
  wire   gate_clk_dma_int5     ;     
  wire   isolate_dma_int5      ;       
  wire save_edge_dma_int5;
  wire restore_edge_dma_int5;
  wire   pwr1_on_dma_int5      ;      
  wire   pwr2_on_dma_int5      ;      

  // CPU5
  wire   rstn_non_srpg_cpu_int5;
  wire   gate_clk_cpu_int5     ;     
  wire   isolate_cpu_int5      ;       
  wire save_edge_cpu_int5;
  wire restore_edge_cpu_int5;
  wire   pwr1_on_cpu_int5      ;      
  wire   pwr2_on_cpu_int5      ;  
  wire L1_ctrl_cpu_off_p5;    

  reg save_alut_tmp5;
  // DFS5 sm5

  reg cpu_shutoff_ctrl5;

  reg mte_mac_off_start5, mte_mac012_start5, mte_mac013_start5, mte_mac023_start5, mte_mac123_start5;
  reg mte_mac01_start5, mte_mac02_start5, mte_mac03_start5, mte_mac12_start5, mte_mac13_start5, mte_mac23_start5;
  reg mte_mac0_start5, mte_mac1_start5, mte_mac2_start5, mte_mac3_start5;
  reg mte_sys_hibernate5 ;
  reg mte_dma_start5 ;
  reg mte_cpu_start5 ;
  reg mte_mac_off_sleep_start5, mte_mac012_sleep_start5, mte_mac013_sleep_start5, mte_mac023_sleep_start5, mte_mac123_sleep_start5;
  reg mte_mac01_sleep_start5, mte_mac02_sleep_start5, mte_mac03_sleep_start5, mte_mac12_sleep_start5, mte_mac13_sleep_start5, mte_mac23_sleep_start5;
  reg mte_mac0_sleep_start5, mte_mac1_sleep_start5, mte_mac2_sleep_start5, mte_mac3_sleep_start5;
  reg mte_dma_sleep_start5;
  reg mte_mac_off_to_default5, mte_mac012_to_default5, mte_mac013_to_default5, mte_mac023_to_default5, mte_mac123_to_default5;
  reg mte_mac01_to_default5, mte_mac02_to_default5, mte_mac03_to_default5, mte_mac12_to_default5, mte_mac13_to_default5, mte_mac23_to_default5;
  reg mte_mac0_to_default5, mte_mac1_to_default5, mte_mac2_to_default5, mte_mac3_to_default5;
  reg mte_dma_isolate_dis5;
  reg mte_cpu_isolate_dis5;
  reg mte_sys_hibernate_to_default5;


  // Latch5 the CPU5 SLEEP5 invocation5
  always @( posedge pclk5 or negedge nprst5) 
  begin
    if(!nprst5)
      L1_ctrl_cpu_off_reg5 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg5 <= L1_ctrl_domain5[8];
  end

  // Create5 a pulse5 for sleep5 detection5 
  assign L1_ctrl_cpu_off_p5 =  L1_ctrl_domain5[8] && !L1_ctrl_cpu_off_reg5;
  
  // CPU5 sleep5 contol5 logic 
  // Shut5 off5 CPU5 when L1_ctrl_cpu_off_p5 is set
  // wake5 cpu5 when any interrupt5 is seen5  
  always @( posedge pclk5 or negedge nprst5) 
  begin
    if(!nprst5)
     cpu_shutoff_ctrl5 <= 1'b0;
    else if(cpu_shutoff_ctrl5 && int_source_h5)
     cpu_shutoff_ctrl5 <= 1'b0;
    else if (L1_ctrl_cpu_off_p5)
     cpu_shutoff_ctrl5 <= 1'b1;
  end
 
  // instantiate5 power5 contol5  block for uart5
  power_ctrl_sm5 i_urt_power_ctrl_sm5(
    .pclk5(pclk5),
    .nprst5(nprst5),
    .L1_module_req5(L1_ctrl_domain5[1]),
    .set_status_module5(set_status_urt5),
    .clr_status_module5(clr_status_urt5),
    .rstn_non_srpg_module5(rstn_non_srpg_urt_int5),
    .gate_clk_module5(gate_clk_urt_int5),
    .isolate_module5(isolate_urt_int5),
    .save_edge5(save_edge_urt_int5),
    .restore_edge5(restore_edge_urt_int5),
    .pwr1_on5(pwr1_on_urt_int5),
    .pwr2_on5(pwr2_on_urt_int5)
    );
  

  // instantiate5 power5 contol5  block for smc5
  power_ctrl_sm5 i_smc_power_ctrl_sm5(
    .pclk5(pclk5),
    .nprst5(nprst5),
    .L1_module_req5(L1_ctrl_domain5[2]),
    .set_status_module5(set_status_smc5),
    .clr_status_module5(clr_status_smc5),
    .rstn_non_srpg_module5(rstn_non_srpg_smc_int5),
    .gate_clk_module5(gate_clk_smc_int5),
    .isolate_module5(isolate_smc_int5),
    .save_edge5(save_edge_smc_int5),
    .restore_edge5(restore_edge_smc_int5),
    .pwr1_on5(pwr1_on_smc_int5),
    .pwr2_on5(pwr2_on_smc_int5)
    );

  // power5 control5 for macb05
  power_ctrl_sm5 i_macb0_power_ctrl_sm5(
    .pclk5(pclk5),
    .nprst5(nprst5),
    .L1_module_req5(L1_ctrl_domain5[3]),
    .set_status_module5(set_status_macb05),
    .clr_status_module5(clr_status_macb05),
    .rstn_non_srpg_module5(rstn_non_srpg_macb0_int5),
    .gate_clk_module5(gate_clk_macb0_int5),
    .isolate_module5(isolate_macb0_int5),
    .save_edge5(save_edge_macb0_int5),
    .restore_edge5(restore_edge_macb0_int5),
    .pwr1_on5(pwr1_on_macb0_int5),
    .pwr2_on5(pwr2_on_macb0_int5)
    );
  // power5 control5 for macb15
  power_ctrl_sm5 i_macb1_power_ctrl_sm5(
    .pclk5(pclk5),
    .nprst5(nprst5),
    .L1_module_req5(L1_ctrl_domain5[4]),
    .set_status_module5(set_status_macb15),
    .clr_status_module5(clr_status_macb15),
    .rstn_non_srpg_module5(rstn_non_srpg_macb1_int5),
    .gate_clk_module5(gate_clk_macb1_int5),
    .isolate_module5(isolate_macb1_int5),
    .save_edge5(save_edge_macb1_int5),
    .restore_edge5(restore_edge_macb1_int5),
    .pwr1_on5(pwr1_on_macb1_int5),
    .pwr2_on5(pwr2_on_macb1_int5)
    );
  // power5 control5 for macb25
  power_ctrl_sm5 i_macb2_power_ctrl_sm5(
    .pclk5(pclk5),
    .nprst5(nprst5),
    .L1_module_req5(L1_ctrl_domain5[5]),
    .set_status_module5(set_status_macb25),
    .clr_status_module5(clr_status_macb25),
    .rstn_non_srpg_module5(rstn_non_srpg_macb2_int5),
    .gate_clk_module5(gate_clk_macb2_int5),
    .isolate_module5(isolate_macb2_int5),
    .save_edge5(save_edge_macb2_int5),
    .restore_edge5(restore_edge_macb2_int5),
    .pwr1_on5(pwr1_on_macb2_int5),
    .pwr2_on5(pwr2_on_macb2_int5)
    );
  // power5 control5 for macb35
  power_ctrl_sm5 i_macb3_power_ctrl_sm5(
    .pclk5(pclk5),
    .nprst5(nprst5),
    .L1_module_req5(L1_ctrl_domain5[6]),
    .set_status_module5(set_status_macb35),
    .clr_status_module5(clr_status_macb35),
    .rstn_non_srpg_module5(rstn_non_srpg_macb3_int5),
    .gate_clk_module5(gate_clk_macb3_int5),
    .isolate_module5(isolate_macb3_int5),
    .save_edge5(save_edge_macb3_int5),
    .restore_edge5(restore_edge_macb3_int5),
    .pwr1_on5(pwr1_on_macb3_int5),
    .pwr2_on5(pwr2_on_macb3_int5)
    );
  // power5 control5 for dma5
  power_ctrl_sm5 i_dma_power_ctrl_sm5(
    .pclk5(pclk5),
    .nprst5(nprst5),
    .L1_module_req5(L1_ctrl_domain5[7]),
    .set_status_module5(set_status_dma5),
    .clr_status_module5(clr_status_dma5),
    .rstn_non_srpg_module5(rstn_non_srpg_dma_int5),
    .gate_clk_module5(gate_clk_dma_int5),
    .isolate_module5(isolate_dma_int5),
    .save_edge5(save_edge_dma_int5),
    .restore_edge5(restore_edge_dma_int5),
    .pwr1_on5(pwr1_on_dma_int5),
    .pwr2_on5(pwr2_on_dma_int5)
    );
  // power5 control5 for CPU5
  power_ctrl_sm5 i_cpu_power_ctrl_sm5(
    .pclk5(pclk5),
    .nprst5(nprst5),
    .L1_module_req5(cpu_shutoff_ctrl5),
    .set_status_module5(set_status_cpu5),
    .clr_status_module5(clr_status_cpu5),
    .rstn_non_srpg_module5(rstn_non_srpg_cpu_int5),
    .gate_clk_module5(gate_clk_cpu_int5),
    .isolate_module5(isolate_cpu_int5),
    .save_edge5(save_edge_cpu_int5),
    .restore_edge5(restore_edge_cpu_int5),
    .pwr1_on5(pwr1_on_cpu_int5),
    .pwr2_on5(pwr2_on_cpu_int5)
    );

  assign valid_reg_write5 =  (psel5 && pwrite5 && penable5);
  assign valid_reg_read5  =  (psel5 && (!pwrite5) && penable5);

  assign L1_ctrl_access5  =  (paddr5[15:0] == 16'b0000000000000100); 
  assign L1_status_access5 = (paddr5[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access5 =   (paddr5[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access5 = (paddr5[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control5 and status register
  always @(*)
  begin  
    if(valid_reg_read5 && L1_ctrl_access5) 
      prdata5 = L1_ctrl_reg5;
    else if (valid_reg_read5 && L1_status_access5)
      prdata5 = L1_status_reg5;
    else if (valid_reg_read5 && pcm_int_mask_access5)
      prdata5 = pcm_mask_reg5;
    else if (valid_reg_read5 && pcm_int_status_access5)
      prdata5 = pcm_status_reg5;
    else 
      prdata5 = 0;
  end

  assign set_status_mem5 =  (set_status_macb05 && set_status_macb15 && set_status_macb25 &&
                            set_status_macb35 && set_status_dma5 && set_status_cpu5);

  assign clr_status_mem5 =  (clr_status_macb05 && clr_status_macb15 && clr_status_macb25 &&
                            clr_status_macb35 && clr_status_dma5 && clr_status_cpu5);

  assign set_status_alut5 = (set_status_macb05 && set_status_macb15 && set_status_macb25 && set_status_macb35);

  assign clr_status_alut5 = (clr_status_macb05 || clr_status_macb15 || clr_status_macb25  || clr_status_macb35);

  // Write accesses to the control5 and status register
 
  always @(posedge pclk5 or negedge nprst5)
  begin
    if (!nprst5) begin
      L1_ctrl_reg5   <= 0;
      L1_status_reg5 <= 0;
      pcm_mask_reg5 <= 0;
    end else begin
      // CTRL5 reg updates5
      if (valid_reg_write5 && L1_ctrl_access5) 
        L1_ctrl_reg5 <= pwdata5; // Writes5 to the ctrl5 reg
      if (valid_reg_write5 && pcm_int_mask_access5) 
        pcm_mask_reg5 <= pwdata5; // Writes5 to the ctrl5 reg

      if (set_status_urt5 == 1'b1)  
        L1_status_reg5[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt5 == 1'b1) 
        L1_status_reg5[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc5 == 1'b1) 
        L1_status_reg5[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc5 == 1'b1) 
        L1_status_reg5[2] <= 1'b0; // Clear the status bit

      if (set_status_macb05 == 1'b1)  
        L1_status_reg5[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb05 == 1'b1) 
        L1_status_reg5[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb15 == 1'b1)  
        L1_status_reg5[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb15 == 1'b1) 
        L1_status_reg5[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb25 == 1'b1)  
        L1_status_reg5[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb25 == 1'b1) 
        L1_status_reg5[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb35 == 1'b1)  
        L1_status_reg5[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb35 == 1'b1) 
        L1_status_reg5[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma5 == 1'b1)  
        L1_status_reg5[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma5 == 1'b1) 
        L1_status_reg5[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu5 == 1'b1)  
        L1_status_reg5[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu5 == 1'b1) 
        L1_status_reg5[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut5 == 1'b1)  
        L1_status_reg5[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut5 == 1'b1) 
        L1_status_reg5[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem5 == 1'b1)  
        L1_status_reg5[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem5 == 1'b1) 
        L1_status_reg5[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused5 bits of pcm_status_reg5 are tied5 to 0
  always @(posedge pclk5 or negedge nprst5)
  begin
    if (!nprst5)
      pcm_status_reg5[31:4] <= 'b0;
    else  
      pcm_status_reg5[31:4] <= pcm_status_reg5[31:4];
  end
  
  // interrupt5 only of h/w assisted5 wakeup
  // MAC5 3
  always @(posedge pclk5 or negedge nprst5)
  begin
    if(!nprst5)
      pcm_status_reg5[3] <= 1'b0;
    else if (valid_reg_write5 && pcm_int_status_access5) 
      pcm_status_reg5[3] <= pwdata5[3];
    else if (macb3_wakeup5 & ~pcm_mask_reg5[3])
      pcm_status_reg5[3] <= 1'b1;
    else if (valid_reg_read5 && pcm_int_status_access5) 
      pcm_status_reg5[3] <= 1'b0;
    else
      pcm_status_reg5[3] <= pcm_status_reg5[3];
  end  
   
  // MAC5 2
  always @(posedge pclk5 or negedge nprst5)
  begin
    if(!nprst5)
      pcm_status_reg5[2] <= 1'b0;
    else if (valid_reg_write5 && pcm_int_status_access5) 
      pcm_status_reg5[2] <= pwdata5[2];
    else if (macb2_wakeup5 & ~pcm_mask_reg5[2])
      pcm_status_reg5[2] <= 1'b1;
    else if (valid_reg_read5 && pcm_int_status_access5) 
      pcm_status_reg5[2] <= 1'b0;
    else
      pcm_status_reg5[2] <= pcm_status_reg5[2];
  end  

  // MAC5 1
  always @(posedge pclk5 or negedge nprst5)
  begin
    if(!nprst5)
      pcm_status_reg5[1] <= 1'b0;
    else if (valid_reg_write5 && pcm_int_status_access5) 
      pcm_status_reg5[1] <= pwdata5[1];
    else if (macb1_wakeup5 & ~pcm_mask_reg5[1])
      pcm_status_reg5[1] <= 1'b1;
    else if (valid_reg_read5 && pcm_int_status_access5) 
      pcm_status_reg5[1] <= 1'b0;
    else
      pcm_status_reg5[1] <= pcm_status_reg5[1];
  end  
   
  // MAC5 0
  always @(posedge pclk5 or negedge nprst5)
  begin
    if(!nprst5)
      pcm_status_reg5[0] <= 1'b0;
    else if (valid_reg_write5 && pcm_int_status_access5) 
      pcm_status_reg5[0] <= pwdata5[0];
    else if (macb0_wakeup5 & ~pcm_mask_reg5[0])
      pcm_status_reg5[0] <= 1'b1;
    else if (valid_reg_read5 && pcm_int_status_access5) 
      pcm_status_reg5[0] <= 1'b0;
    else
      pcm_status_reg5[0] <= pcm_status_reg5[0];
  end  

  assign pcm_macb_wakeup_int5 = |pcm_status_reg5;

  reg [31:0] L1_ctrl_reg15;
  always @(posedge pclk5 or negedge nprst5)
  begin
    if(!nprst5)
      L1_ctrl_reg15 <= 0;
    else
      L1_ctrl_reg15 <= L1_ctrl_reg5;
  end

  // Program5 mode decode
  always @(L1_ctrl_reg5 or L1_ctrl_reg15 or int_source_h5 or cpu_shutoff_ctrl5) begin
    mte_smc_start5 = 0;
    mte_uart_start5 = 0;
    mte_smc_uart_start5  = 0;
    mte_mac_off_start5  = 0;
    mte_mac012_start5 = 0;
    mte_mac013_start5 = 0;
    mte_mac023_start5 = 0;
    mte_mac123_start5 = 0;
    mte_mac01_start5 = 0;
    mte_mac02_start5 = 0;
    mte_mac03_start5 = 0;
    mte_mac12_start5 = 0;
    mte_mac13_start5 = 0;
    mte_mac23_start5 = 0;
    mte_mac0_start5 = 0;
    mte_mac1_start5 = 0;
    mte_mac2_start5 = 0;
    mte_mac3_start5 = 0;
    mte_sys_hibernate5 = 0 ;
    mte_dma_start5 = 0 ;
    mte_cpu_start5 = 0 ;

    mte_mac0_sleep_start5 = (L1_ctrl_reg5 ==  'h14) && (L1_ctrl_reg15 == 'h4 );
    mte_mac1_sleep_start5 = (L1_ctrl_reg5 ==  'h14) && (L1_ctrl_reg15 == 'h5 ); 
    mte_mac2_sleep_start5 = (L1_ctrl_reg5 ==  'h14) && (L1_ctrl_reg15 == 'h6 ); 
    mte_mac3_sleep_start5 = (L1_ctrl_reg5 ==  'h14) && (L1_ctrl_reg15 == 'h7 ); 
    mte_mac01_sleep_start5 = (L1_ctrl_reg5 ==  'h14) && (L1_ctrl_reg15 == 'h8 ); 
    mte_mac02_sleep_start5 = (L1_ctrl_reg5 ==  'h14) && (L1_ctrl_reg15 == 'h9 ); 
    mte_mac03_sleep_start5 = (L1_ctrl_reg5 ==  'h14) && (L1_ctrl_reg15 == 'hA ); 
    mte_mac12_sleep_start5 = (L1_ctrl_reg5 ==  'h14) && (L1_ctrl_reg15 == 'hB ); 
    mte_mac13_sleep_start5 = (L1_ctrl_reg5 ==  'h14) && (L1_ctrl_reg15 == 'hC ); 
    mte_mac23_sleep_start5 = (L1_ctrl_reg5 ==  'h14) && (L1_ctrl_reg15 == 'hD ); 
    mte_mac012_sleep_start5 = (L1_ctrl_reg5 ==  'h14) && (L1_ctrl_reg15 == 'hE ); 
    mte_mac013_sleep_start5 = (L1_ctrl_reg5 ==  'h14) && (L1_ctrl_reg15 == 'hF ); 
    mte_mac023_sleep_start5 = (L1_ctrl_reg5 ==  'h14) && (L1_ctrl_reg15 == 'h10 ); 
    mte_mac123_sleep_start5 = (L1_ctrl_reg5 ==  'h14) && (L1_ctrl_reg15 == 'h11 ); 
    mte_mac_off_sleep_start5 =  (L1_ctrl_reg5 == 'h14) && (L1_ctrl_reg15 == 'h12 );
    mte_dma_sleep_start5 =  (L1_ctrl_reg5 == 'h14) && (L1_ctrl_reg15 == 'h13 );

    mte_pm_uart_to_default_start5 = (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'h1);
    mte_pm_smc_to_default_start5 = (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'h2);
    mte_pm_smc_uart_to_default_start5 = (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'h3); 
    mte_mac0_to_default5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'h4); 
    mte_mac1_to_default5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'h5); 
    mte_mac2_to_default5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'h6); 
    mte_mac3_to_default5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'h7); 
    mte_mac01_to_default5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'h8); 
    mte_mac02_to_default5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'h9); 
    mte_mac03_to_default5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'hA); 
    mte_mac12_to_default5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'hB); 
    mte_mac13_to_default5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'hC); 
    mte_mac23_to_default5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'hD); 
    mte_mac012_to_default5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'hE); 
    mte_mac013_to_default5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'hF); 
    mte_mac023_to_default5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'h10); 
    mte_mac123_to_default5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'h11); 
    mte_mac_off_to_default5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'h12); 
    mte_dma_isolate_dis5 =  (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'h13); 
    mte_cpu_isolate_dis5 =  (int_source_h5) && (cpu_shutoff_ctrl5) && (L1_ctrl_reg5 != 'h15);
    mte_sys_hibernate_to_default5 = (L1_ctrl_reg5 == 32'h0) && (L1_ctrl_reg15 == 'h15); 

   
    if (L1_ctrl_reg15 == 'h0) begin // This5 check is to make mte_cpu_start5
                                   // is set only when you from default state 
      case (L1_ctrl_reg5)
        'h0 : L1_ctrl_domain5 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain5 = 32'h2; // PM_uart5
                mte_uart_start5 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain5 = 32'h4; // PM_smc5
                mte_smc_start5 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain5 = 32'h6; // PM_smc_uart5
                mte_smc_uart_start5 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain5 = 32'h8; //  PM_macb05
                mte_mac0_start5 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain5 = 32'h10; //  PM_macb15
                mte_mac1_start5 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain5 = 32'h20; //  PM_macb25
                mte_mac2_start5 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain5 = 32'h40; //  PM_macb35
                mte_mac3_start5 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain5 = 32'h18; //  PM_macb015
                mte_mac01_start5 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain5 = 32'h28; //  PM_macb025
                mte_mac02_start5 = 1;
              end
        'hA : begin  
                L1_ctrl_domain5 = 32'h48; //  PM_macb035
                mte_mac03_start5 = 1;
              end
        'hB : begin  
                L1_ctrl_domain5 = 32'h30; //  PM_macb125
                mte_mac12_start5 = 1;
              end
        'hC : begin  
                L1_ctrl_domain5 = 32'h50; //  PM_macb135
                mte_mac13_start5 = 1;
              end
        'hD : begin  
                L1_ctrl_domain5 = 32'h60; //  PM_macb235
                mte_mac23_start5 = 1;
              end
        'hE : begin  
                L1_ctrl_domain5 = 32'h38; //  PM_macb0125
                mte_mac012_start5 = 1;
              end
        'hF : begin  
                L1_ctrl_domain5 = 32'h58; //  PM_macb0135
                mte_mac013_start5 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain5 = 32'h68; //  PM_macb0235
                mte_mac023_start5 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain5 = 32'h70; //  PM_macb1235
                mte_mac123_start5 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain5 = 32'h78; //  PM_macb_off5
                mte_mac_off_start5 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain5 = 32'h80; //  PM_dma5
                mte_dma_start5 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain5 = 32'h100; //  PM_cpu_sleep5
                mte_cpu_start5 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain5 = 32'h1FE; //  PM_hibernate5
                mte_sys_hibernate5 = 1;
              end
         default: L1_ctrl_domain5 = 32'h0;
      endcase
    end
  end


  wire to_default5 = (L1_ctrl_reg5 == 0);

  // Scan5 mode gating5 of power5 and isolation5 control5 signals5
  //SMC5
  assign rstn_non_srpg_smc5  = (scan_mode5 == 1'b0) ? rstn_non_srpg_smc_int5 : 1'b1;  
  assign gate_clk_smc5       = (scan_mode5 == 1'b0) ? gate_clk_smc_int5 : 1'b0;     
  assign isolate_smc5        = (scan_mode5 == 1'b0) ? isolate_smc_int5 : 1'b0;      
  assign pwr1_on_smc5        = (scan_mode5 == 1'b0) ? pwr1_on_smc_int5 : 1'b1;       
  assign pwr2_on_smc5        = (scan_mode5 == 1'b0) ? pwr2_on_smc_int5 : 1'b1;       
  assign pwr1_off_smc5       = (scan_mode5 == 1'b0) ? (!pwr1_on_smc_int5) : 1'b0;       
  assign pwr2_off_smc5       = (scan_mode5 == 1'b0) ? (!pwr2_on_smc_int5) : 1'b0;       
  assign save_edge_smc5       = (scan_mode5 == 1'b0) ? (save_edge_smc_int5) : 1'b0;       
  assign restore_edge_smc5       = (scan_mode5 == 1'b0) ? (restore_edge_smc_int5) : 1'b0;       

  //URT5
  assign rstn_non_srpg_urt5  = (scan_mode5 == 1'b0) ?  rstn_non_srpg_urt_int5 : 1'b1;  
  assign gate_clk_urt5       = (scan_mode5 == 1'b0) ?  gate_clk_urt_int5      : 1'b0;     
  assign isolate_urt5        = (scan_mode5 == 1'b0) ?  isolate_urt_int5       : 1'b0;      
  assign pwr1_on_urt5        = (scan_mode5 == 1'b0) ?  pwr1_on_urt_int5       : 1'b1;       
  assign pwr2_on_urt5        = (scan_mode5 == 1'b0) ?  pwr2_on_urt_int5       : 1'b1;       
  assign pwr1_off_urt5       = (scan_mode5 == 1'b0) ?  (!pwr1_on_urt_int5)  : 1'b0;       
  assign pwr2_off_urt5       = (scan_mode5 == 1'b0) ?  (!pwr2_on_urt_int5)  : 1'b0;       
  assign save_edge_urt5       = (scan_mode5 == 1'b0) ? (save_edge_urt_int5) : 1'b0;       
  assign restore_edge_urt5       = (scan_mode5 == 1'b0) ? (restore_edge_urt_int5) : 1'b0;       

  //ETH05
  assign rstn_non_srpg_macb05 = (scan_mode5 == 1'b0) ?  rstn_non_srpg_macb0_int5 : 1'b1;  
  assign gate_clk_macb05       = (scan_mode5 == 1'b0) ?  gate_clk_macb0_int5      : 1'b0;     
  assign isolate_macb05        = (scan_mode5 == 1'b0) ?  isolate_macb0_int5       : 1'b0;      
  assign pwr1_on_macb05        = (scan_mode5 == 1'b0) ?  pwr1_on_macb0_int5       : 1'b1;       
  assign pwr2_on_macb05        = (scan_mode5 == 1'b0) ?  pwr2_on_macb0_int5       : 1'b1;       
  assign pwr1_off_macb05       = (scan_mode5 == 1'b0) ?  (!pwr1_on_macb0_int5)  : 1'b0;       
  assign pwr2_off_macb05       = (scan_mode5 == 1'b0) ?  (!pwr2_on_macb0_int5)  : 1'b0;       
  assign save_edge_macb05       = (scan_mode5 == 1'b0) ? (save_edge_macb0_int5) : 1'b0;       
  assign restore_edge_macb05       = (scan_mode5 == 1'b0) ? (restore_edge_macb0_int5) : 1'b0;       

  //ETH15
  assign rstn_non_srpg_macb15 = (scan_mode5 == 1'b0) ?  rstn_non_srpg_macb1_int5 : 1'b1;  
  assign gate_clk_macb15       = (scan_mode5 == 1'b0) ?  gate_clk_macb1_int5      : 1'b0;     
  assign isolate_macb15        = (scan_mode5 == 1'b0) ?  isolate_macb1_int5       : 1'b0;      
  assign pwr1_on_macb15        = (scan_mode5 == 1'b0) ?  pwr1_on_macb1_int5       : 1'b1;       
  assign pwr2_on_macb15        = (scan_mode5 == 1'b0) ?  pwr2_on_macb1_int5       : 1'b1;       
  assign pwr1_off_macb15       = (scan_mode5 == 1'b0) ?  (!pwr1_on_macb1_int5)  : 1'b0;       
  assign pwr2_off_macb15       = (scan_mode5 == 1'b0) ?  (!pwr2_on_macb1_int5)  : 1'b0;       
  assign save_edge_macb15       = (scan_mode5 == 1'b0) ? (save_edge_macb1_int5) : 1'b0;       
  assign restore_edge_macb15       = (scan_mode5 == 1'b0) ? (restore_edge_macb1_int5) : 1'b0;       

  //ETH25
  assign rstn_non_srpg_macb25 = (scan_mode5 == 1'b0) ?  rstn_non_srpg_macb2_int5 : 1'b1;  
  assign gate_clk_macb25       = (scan_mode5 == 1'b0) ?  gate_clk_macb2_int5      : 1'b0;     
  assign isolate_macb25        = (scan_mode5 == 1'b0) ?  isolate_macb2_int5       : 1'b0;      
  assign pwr1_on_macb25        = (scan_mode5 == 1'b0) ?  pwr1_on_macb2_int5       : 1'b1;       
  assign pwr2_on_macb25        = (scan_mode5 == 1'b0) ?  pwr2_on_macb2_int5       : 1'b1;       
  assign pwr1_off_macb25       = (scan_mode5 == 1'b0) ?  (!pwr1_on_macb2_int5)  : 1'b0;       
  assign pwr2_off_macb25       = (scan_mode5 == 1'b0) ?  (!pwr2_on_macb2_int5)  : 1'b0;       
  assign save_edge_macb25       = (scan_mode5 == 1'b0) ? (save_edge_macb2_int5) : 1'b0;       
  assign restore_edge_macb25       = (scan_mode5 == 1'b0) ? (restore_edge_macb2_int5) : 1'b0;       

  //ETH35
  assign rstn_non_srpg_macb35 = (scan_mode5 == 1'b0) ?  rstn_non_srpg_macb3_int5 : 1'b1;  
  assign gate_clk_macb35       = (scan_mode5 == 1'b0) ?  gate_clk_macb3_int5      : 1'b0;     
  assign isolate_macb35        = (scan_mode5 == 1'b0) ?  isolate_macb3_int5       : 1'b0;      
  assign pwr1_on_macb35        = (scan_mode5 == 1'b0) ?  pwr1_on_macb3_int5       : 1'b1;       
  assign pwr2_on_macb35        = (scan_mode5 == 1'b0) ?  pwr2_on_macb3_int5       : 1'b1;       
  assign pwr1_off_macb35       = (scan_mode5 == 1'b0) ?  (!pwr1_on_macb3_int5)  : 1'b0;       
  assign pwr2_off_macb35       = (scan_mode5 == 1'b0) ?  (!pwr2_on_macb3_int5)  : 1'b0;       
  assign save_edge_macb35       = (scan_mode5 == 1'b0) ? (save_edge_macb3_int5) : 1'b0;       
  assign restore_edge_macb35       = (scan_mode5 == 1'b0) ? (restore_edge_macb3_int5) : 1'b0;       

  // MEM5
  assign rstn_non_srpg_mem5 =   (rstn_non_srpg_macb05 && rstn_non_srpg_macb15 && rstn_non_srpg_macb25 &&
                                rstn_non_srpg_macb35 && rstn_non_srpg_dma5 && rstn_non_srpg_cpu5 && rstn_non_srpg_urt5 &&
                                rstn_non_srpg_smc5);

  assign gate_clk_mem5 =  (gate_clk_macb05 && gate_clk_macb15 && gate_clk_macb25 &&
                            gate_clk_macb35 && gate_clk_dma5 && gate_clk_cpu5 && gate_clk_urt5 && gate_clk_smc5);

  assign isolate_mem5  = (isolate_macb05 && isolate_macb15 && isolate_macb25 &&
                         isolate_macb35 && isolate_dma5 && isolate_cpu5 && isolate_urt5 && isolate_smc5);


  assign pwr1_on_mem5        =   ~pwr1_off_mem5;

  assign pwr2_on_mem5        =   ~pwr2_off_mem5;

  assign pwr1_off_mem5       =  (pwr1_off_macb05 && pwr1_off_macb15 && pwr1_off_macb25 &&
                                 pwr1_off_macb35 && pwr1_off_dma5 && pwr1_off_cpu5 && pwr1_off_urt5 && pwr1_off_smc5);


  assign pwr2_off_mem5       =  (pwr2_off_macb05 && pwr2_off_macb15 && pwr2_off_macb25 &&
                                pwr2_off_macb35 && pwr2_off_dma5 && pwr2_off_cpu5 && pwr2_off_urt5 && pwr2_off_smc5);

  assign save_edge_mem5      =  (save_edge_macb05 && save_edge_macb15 && save_edge_macb25 &&
                                save_edge_macb35 && save_edge_dma5 && save_edge_cpu5 && save_edge_smc5 && save_edge_urt5);

  assign restore_edge_mem5   =  (restore_edge_macb05 && restore_edge_macb15 && restore_edge_macb25  &&
                                restore_edge_macb35 && restore_edge_dma5 && restore_edge_cpu5 && restore_edge_urt5 &&
                                restore_edge_smc5);

  assign standby_mem05 = pwr1_off_macb05 && (~ (pwr1_off_macb05 && pwr1_off_macb15 && pwr1_off_macb25 && pwr1_off_macb35 && pwr1_off_urt5 && pwr1_off_smc5 && pwr1_off_dma5 && pwr1_off_cpu5));
  assign standby_mem15 = pwr1_off_macb15 && (~ (pwr1_off_macb05 && pwr1_off_macb15 && pwr1_off_macb25 && pwr1_off_macb35 && pwr1_off_urt5 && pwr1_off_smc5 && pwr1_off_dma5 && pwr1_off_cpu5));
  assign standby_mem25 = pwr1_off_macb25 && (~ (pwr1_off_macb05 && pwr1_off_macb15 && pwr1_off_macb25 && pwr1_off_macb35 && pwr1_off_urt5 && pwr1_off_smc5 && pwr1_off_dma5 && pwr1_off_cpu5));
  assign standby_mem35 = pwr1_off_macb35 && (~ (pwr1_off_macb05 && pwr1_off_macb15 && pwr1_off_macb25 && pwr1_off_macb35 && pwr1_off_urt5 && pwr1_off_smc5 && pwr1_off_dma5 && pwr1_off_cpu5));

  assign pwr1_off_mem05 = pwr1_off_mem5;
  assign pwr1_off_mem15 = pwr1_off_mem5;
  assign pwr1_off_mem25 = pwr1_off_mem5;
  assign pwr1_off_mem35 = pwr1_off_mem5;

  assign rstn_non_srpg_alut5  =  (rstn_non_srpg_macb05 && rstn_non_srpg_macb15 && rstn_non_srpg_macb25 && rstn_non_srpg_macb35);


   assign gate_clk_alut5       =  (gate_clk_macb05 && gate_clk_macb15 && gate_clk_macb25 && gate_clk_macb35);


    assign isolate_alut5        =  (isolate_macb05 && isolate_macb15 && isolate_macb25 && isolate_macb35);


    assign pwr1_on_alut5        =  (pwr1_on_macb05 || pwr1_on_macb15 || pwr1_on_macb25 || pwr1_on_macb35);


    assign pwr2_on_alut5        =  (pwr2_on_macb05 || pwr2_on_macb15 || pwr2_on_macb25 || pwr2_on_macb35);


    assign pwr1_off_alut5       =  (pwr1_off_macb05 && pwr1_off_macb15 && pwr1_off_macb25 && pwr1_off_macb35);


    assign pwr2_off_alut5       =  (pwr2_off_macb05 && pwr2_off_macb15 && pwr2_off_macb25 && pwr2_off_macb35);


    assign save_edge_alut5      =  (save_edge_macb05 && save_edge_macb15 && save_edge_macb25 && save_edge_macb35);


    assign restore_edge_alut5   =  (restore_edge_macb05 || restore_edge_macb15 || restore_edge_macb25 ||
                                   restore_edge_macb35) && save_alut_tmp5;

     // alut5 power5 off5 detection5
  always @(posedge pclk5 or negedge nprst5) begin
    if (!nprst5) 
       save_alut_tmp5 <= 0;
    else if (restore_edge_alut5)
       save_alut_tmp5 <= 0;
    else if (save_edge_alut5)
       save_alut_tmp5 <= 1;
  end

  //DMA5
  assign rstn_non_srpg_dma5 = (scan_mode5 == 1'b0) ?  rstn_non_srpg_dma_int5 : 1'b1;  
  assign gate_clk_dma5       = (scan_mode5 == 1'b0) ?  gate_clk_dma_int5      : 1'b0;     
  assign isolate_dma5        = (scan_mode5 == 1'b0) ?  isolate_dma_int5       : 1'b0;      
  assign pwr1_on_dma5        = (scan_mode5 == 1'b0) ?  pwr1_on_dma_int5       : 1'b1;       
  assign pwr2_on_dma5        = (scan_mode5 == 1'b0) ?  pwr2_on_dma_int5       : 1'b1;       
  assign pwr1_off_dma5       = (scan_mode5 == 1'b0) ?  (!pwr1_on_dma_int5)  : 1'b0;       
  assign pwr2_off_dma5       = (scan_mode5 == 1'b0) ?  (!pwr2_on_dma_int5)  : 1'b0;       
  assign save_edge_dma5       = (scan_mode5 == 1'b0) ? (save_edge_dma_int5) : 1'b0;       
  assign restore_edge_dma5       = (scan_mode5 == 1'b0) ? (restore_edge_dma_int5) : 1'b0;       

  //CPU5
  assign rstn_non_srpg_cpu5 = (scan_mode5 == 1'b0) ?  rstn_non_srpg_cpu_int5 : 1'b1;  
  assign gate_clk_cpu5       = (scan_mode5 == 1'b0) ?  gate_clk_cpu_int5      : 1'b0;     
  assign isolate_cpu5        = (scan_mode5 == 1'b0) ?  isolate_cpu_int5       : 1'b0;      
  assign pwr1_on_cpu5        = (scan_mode5 == 1'b0) ?  pwr1_on_cpu_int5       : 1'b1;       
  assign pwr2_on_cpu5        = (scan_mode5 == 1'b0) ?  pwr2_on_cpu_int5       : 1'b1;       
  assign pwr1_off_cpu5       = (scan_mode5 == 1'b0) ?  (!pwr1_on_cpu_int5)  : 1'b0;       
  assign pwr2_off_cpu5       = (scan_mode5 == 1'b0) ?  (!pwr2_on_cpu_int5)  : 1'b0;       
  assign save_edge_cpu5       = (scan_mode5 == 1'b0) ? (save_edge_cpu_int5) : 1'b0;       
  assign restore_edge_cpu5       = (scan_mode5 == 1'b0) ? (restore_edge_cpu_int5) : 1'b0;       



  // ASE5

   reg ase_core_12v5, ase_core_10v5, ase_core_08v5, ase_core_06v5;
   reg ase_macb0_12v5,ase_macb1_12v5,ase_macb2_12v5,ase_macb3_12v5;

    // core5 ase5

    // core5 at 1.0 v if (smc5 off5, urt5 off5, macb05 off5, macb15 off5, macb25 off5, macb35 off5
   // core5 at 0.8v if (mac01off5, macb02off5, macb03off5, macb12off5, mac13off5, mac23off5,
   // core5 at 0.6v if (mac012off5, mac013off5, mac023off5, mac123off5, mac0123off5
    // else core5 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb05 && pwr1_off_macb15 && pwr1_off_macb25 && pwr1_off_macb35) || // all mac5 off5
       (pwr1_off_macb35 && pwr1_off_macb25 && pwr1_off_macb15) || // mac123off5 
       (pwr1_off_macb35 && pwr1_off_macb25 && pwr1_off_macb05) || // mac023off5 
       (pwr1_off_macb35 && pwr1_off_macb15 && pwr1_off_macb05) || // mac013off5 
       (pwr1_off_macb25 && pwr1_off_macb15 && pwr1_off_macb05) )  // mac012off5 
       begin
         ase_core_12v5 = 0;
         ase_core_10v5 = 0;
         ase_core_08v5 = 0;
         ase_core_06v5 = 1;
       end
     else if( (pwr1_off_macb25 && pwr1_off_macb35) || // mac235 off5
         (pwr1_off_macb35 && pwr1_off_macb15) || // mac13off5 
         (pwr1_off_macb15 && pwr1_off_macb25) || // mac12off5 
         (pwr1_off_macb35 && pwr1_off_macb05) || // mac03off5 
         (pwr1_off_macb25 && pwr1_off_macb05) || // mac02off5 
         (pwr1_off_macb15 && pwr1_off_macb05))  // mac01off5 
       begin
         ase_core_12v5 = 0;
         ase_core_10v5 = 0;
         ase_core_08v5 = 1;
         ase_core_06v5 = 0;
       end
     else if( (pwr1_off_smc5) || // smc5 off5
         (pwr1_off_macb05 ) || // mac0off5 
         (pwr1_off_macb15 ) || // mac1off5 
         (pwr1_off_macb25 ) || // mac2off5 
         (pwr1_off_macb35 ))  // mac3off5 
       begin
         ase_core_12v5 = 0;
         ase_core_10v5 = 1;
         ase_core_08v5 = 0;
         ase_core_06v5 = 0;
       end
     else if (pwr1_off_urt5)
       begin
         ase_core_12v5 = 1;
         ase_core_10v5 = 0;
         ase_core_08v5 = 0;
         ase_core_06v5 = 0;
       end
     else
       begin
         ase_core_12v5 = 1;
         ase_core_10v5 = 0;
         ase_core_08v5 = 0;
         ase_core_06v5 = 0;
       end
   end


   // cpu5
   // cpu5 @ 1.0v when macoff5, 
   // 
   reg ase_cpu_10v5, ase_cpu_12v5;
   always @(*) begin
    if(pwr1_off_cpu5) begin
     ase_cpu_12v5 = 1'b0;
     ase_cpu_10v5 = 1'b0;
    end
    else if(pwr1_off_macb05 || pwr1_off_macb15 || pwr1_off_macb25 || pwr1_off_macb35)
    begin
     ase_cpu_12v5 = 1'b0;
     ase_cpu_10v5 = 1'b1;
    end
    else
    begin
     ase_cpu_12v5 = 1'b1;
     ase_cpu_10v5 = 1'b0;
    end
   end

   // dma5
   // dma5 @v15.0 for macoff5, 

   reg ase_dma_10v5, ase_dma_12v5;
   always @(*) begin
    if(pwr1_off_dma5) begin
     ase_dma_12v5 = 1'b0;
     ase_dma_10v5 = 1'b0;
    end
    else if(pwr1_off_macb05 || pwr1_off_macb15 || pwr1_off_macb25 || pwr1_off_macb35)
    begin
     ase_dma_12v5 = 1'b0;
     ase_dma_10v5 = 1'b1;
    end
    else
    begin
     ase_dma_12v5 = 1'b1;
     ase_dma_10v5 = 1'b0;
    end
   end

   // alut5
   // @ v15.0 for macoff5

   reg ase_alut_10v5, ase_alut_12v5;
   always @(*) begin
    if(pwr1_off_alut5) begin
     ase_alut_12v5 = 1'b0;
     ase_alut_10v5 = 1'b0;
    end
    else if(pwr1_off_macb05 || pwr1_off_macb15 || pwr1_off_macb25 || pwr1_off_macb35)
    begin
     ase_alut_12v5 = 1'b0;
     ase_alut_10v5 = 1'b1;
    end
    else
    begin
     ase_alut_12v5 = 1'b1;
     ase_alut_10v5 = 1'b0;
    end
   end




   reg ase_uart_12v5;
   reg ase_uart_10v5;
   reg ase_uart_08v5;
   reg ase_uart_06v5;

   reg ase_smc_12v5;


   always @(*) begin
     if(pwr1_off_urt5) begin // uart5 off5
       ase_uart_08v5 = 1'b0;
       ase_uart_06v5 = 1'b0;
       ase_uart_10v5 = 1'b0;
       ase_uart_12v5 = 1'b0;
     end 
     else if( (pwr1_off_macb05 && pwr1_off_macb15 && pwr1_off_macb25 && pwr1_off_macb35) || // all mac5 off5
       (pwr1_off_macb35 && pwr1_off_macb25 && pwr1_off_macb15) || // mac123off5 
       (pwr1_off_macb35 && pwr1_off_macb25 && pwr1_off_macb05) || // mac023off5 
       (pwr1_off_macb35 && pwr1_off_macb15 && pwr1_off_macb05) || // mac013off5 
       (pwr1_off_macb25 && pwr1_off_macb15 && pwr1_off_macb05) )  // mac012off5 
     begin
       ase_uart_06v5 = 1'b1;
       ase_uart_08v5 = 1'b0;
       ase_uart_10v5 = 1'b0;
       ase_uart_12v5 = 1'b0;
     end
     else if( (pwr1_off_macb25 && pwr1_off_macb35) || // mac235 off5
         (pwr1_off_macb35 && pwr1_off_macb15) || // mac13off5 
         (pwr1_off_macb15 && pwr1_off_macb25) || // mac12off5 
         (pwr1_off_macb35 && pwr1_off_macb05) || // mac03off5 
         (pwr1_off_macb15 && pwr1_off_macb05))  // mac01off5  
     begin
       ase_uart_06v5 = 1'b0;
       ase_uart_08v5 = 1'b1;
       ase_uart_10v5 = 1'b0;
       ase_uart_12v5 = 1'b0;
     end
     else if (pwr1_off_smc5 || pwr1_off_macb05 || pwr1_off_macb15 || pwr1_off_macb25 || pwr1_off_macb35) begin // smc5 off5
       ase_uart_08v5 = 1'b0;
       ase_uart_06v5 = 1'b0;
       ase_uart_10v5 = 1'b1;
       ase_uart_12v5 = 1'b0;
     end 
     else begin
       ase_uart_08v5 = 1'b0;
       ase_uart_06v5 = 1'b0;
       ase_uart_10v5 = 1'b0;
       ase_uart_12v5 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc5) begin
     if (pwr1_off_smc5)  // smc5 off5
       ase_smc_12v5 = 1'b0;
    else
       ase_smc_12v5 = 1'b1;
   end

   
   always @(pwr1_off_macb05) begin
     if (pwr1_off_macb05) // macb05 off5
       ase_macb0_12v5 = 1'b0;
     else
       ase_macb0_12v5 = 1'b1;
   end

   always @(pwr1_off_macb15) begin
     if (pwr1_off_macb15) // macb15 off5
       ase_macb1_12v5 = 1'b0;
     else
       ase_macb1_12v5 = 1'b1;
   end

   always @(pwr1_off_macb25) begin // macb25 off5
     if (pwr1_off_macb25) // macb25 off5
       ase_macb2_12v5 = 1'b0;
     else
       ase_macb2_12v5 = 1'b1;
   end

   always @(pwr1_off_macb35) begin // macb35 off5
     if (pwr1_off_macb35) // macb35 off5
       ase_macb3_12v5 = 1'b0;
     else
       ase_macb3_12v5 = 1'b1;
   end


   // core5 voltage5 for vco5
  assign core12v5 = ase_macb0_12v5 & ase_macb1_12v5 & ase_macb2_12v5 & ase_macb3_12v5;

  assign core10v5 =  (ase_macb0_12v5 & ase_macb1_12v5 & ase_macb2_12v5 & (!ase_macb3_12v5)) ||
                    (ase_macb0_12v5 & ase_macb1_12v5 & (!ase_macb2_12v5) & ase_macb3_12v5) ||
                    (ase_macb0_12v5 & (!ase_macb1_12v5) & ase_macb2_12v5 & ase_macb3_12v5) ||
                    ((!ase_macb0_12v5) & ase_macb1_12v5 & ase_macb2_12v5 & ase_macb3_12v5);

  assign core08v5 =  ((!ase_macb0_12v5) & (!ase_macb1_12v5) & (ase_macb2_12v5) & (ase_macb3_12v5)) ||
                    ((!ase_macb0_12v5) & (ase_macb1_12v5) & (!ase_macb2_12v5) & (ase_macb3_12v5)) ||
                    ((!ase_macb0_12v5) & (ase_macb1_12v5) & (ase_macb2_12v5) & (!ase_macb3_12v5)) ||
                    ((ase_macb0_12v5) & (!ase_macb1_12v5) & (!ase_macb2_12v5) & (ase_macb3_12v5)) ||
                    ((ase_macb0_12v5) & (!ase_macb1_12v5) & (ase_macb2_12v5) & (!ase_macb3_12v5)) ||
                    ((ase_macb0_12v5) & (ase_macb1_12v5) & (!ase_macb2_12v5) & (!ase_macb3_12v5));

  assign core06v5 =  ((!ase_macb0_12v5) & (!ase_macb1_12v5) & (!ase_macb2_12v5) & (ase_macb3_12v5)) ||
                    ((!ase_macb0_12v5) & (!ase_macb1_12v5) & (ase_macb2_12v5) & (!ase_macb3_12v5)) ||
                    ((!ase_macb0_12v5) & (ase_macb1_12v5) & (!ase_macb2_12v5) & (!ase_macb3_12v5)) ||
                    ((ase_macb0_12v5) & (!ase_macb1_12v5) & (!ase_macb2_12v5) & (!ase_macb3_12v5)) ||
                    ((!ase_macb0_12v5) & (!ase_macb1_12v5) & (!ase_macb2_12v5) & (!ase_macb3_12v5)) ;



`ifdef LP_ABV_ON5
// psl5 default clock5 = (posedge pclk5);

// Cover5 a condition in which SMC5 is powered5 down
// and again5 powered5 up while UART5 is going5 into POWER5 down
// state or UART5 is already in POWER5 DOWN5 state
// psl5 cover_overlapping_smc_urt_15:
//    cover{fell5(pwr1_on_urt5);[*];fell5(pwr1_on_smc5);[*];
//    rose5(pwr1_on_smc5);[*];rose5(pwr1_on_urt5)};
//
// Cover5 a condition in which UART5 is powered5 down
// and again5 powered5 up while SMC5 is going5 into POWER5 down
// state or SMC5 is already in POWER5 DOWN5 state
// psl5 cover_overlapping_smc_urt_25:
//    cover{fell5(pwr1_on_smc5);[*];fell5(pwr1_on_urt5);[*];
//    rose5(pwr1_on_urt5);[*];rose5(pwr1_on_smc5)};
//


// Power5 Down5 UART5
// This5 gets5 triggered on rising5 edge of Gate5 signal5 for
// UART5 (gate_clk_urt5). In a next cycle after gate_clk_urt5,
// Isolate5 UART5(isolate_urt5) signal5 become5 HIGH5 (active).
// In 2nd cycle after gate_clk_urt5 becomes HIGH5, RESET5 for NON5
// SRPG5 FFs5(rstn_non_srpg_urt5) and POWER15 for UART5(pwr1_on_urt5) should 
// go5 LOW5. 
// This5 completes5 a POWER5 DOWN5. 

sequence s_power_down_urt5;
      (gate_clk_urt5 & !isolate_urt5 & rstn_non_srpg_urt5 & pwr1_on_urt5) 
  ##1 (gate_clk_urt5 & isolate_urt5 & rstn_non_srpg_urt5 & pwr1_on_urt5) 
  ##3 (gate_clk_urt5 & isolate_urt5 & !rstn_non_srpg_urt5 & !pwr1_on_urt5);
endsequence


property p_power_down_urt5;
   @(posedge pclk5)
    $rose(gate_clk_urt5) |=> s_power_down_urt5;
endproperty

output_power_down_urt5:
  assert property (p_power_down_urt5);


// Power5 UP5 UART5
// Sequence starts with , Rising5 edge of pwr1_on_urt5.
// Two5 clock5 cycle after this, isolate_urt5 should become5 LOW5 
// On5 the following5 clk5 gate_clk_urt5 should go5 low5.
// 5 cycles5 after  Rising5 edge of pwr1_on_urt5, rstn_non_srpg_urt5
// should become5 HIGH5
sequence s_power_up_urt5;
##30 (pwr1_on_urt5 & !isolate_urt5 & gate_clk_urt5 & !rstn_non_srpg_urt5) 
##1 (pwr1_on_urt5 & !isolate_urt5 & !gate_clk_urt5 & !rstn_non_srpg_urt5) 
##2 (pwr1_on_urt5 & !isolate_urt5 & !gate_clk_urt5 & rstn_non_srpg_urt5);
endsequence

property p_power_up_urt5;
   @(posedge pclk5)
  disable iff(!nprst5)
    (!pwr1_on_urt5 ##1 pwr1_on_urt5) |=> s_power_up_urt5;
endproperty

output_power_up_urt5:
  assert property (p_power_up_urt5);


// Power5 Down5 SMC5
// This5 gets5 triggered on rising5 edge of Gate5 signal5 for
// SMC5 (gate_clk_smc5). In a next cycle after gate_clk_smc5,
// Isolate5 SMC5(isolate_smc5) signal5 become5 HIGH5 (active).
// In 2nd cycle after gate_clk_smc5 becomes HIGH5, RESET5 for NON5
// SRPG5 FFs5(rstn_non_srpg_smc5) and POWER15 for SMC5(pwr1_on_smc5) should 
// go5 LOW5. 
// This5 completes5 a POWER5 DOWN5. 

sequence s_power_down_smc5;
      (gate_clk_smc5 & !isolate_smc5 & rstn_non_srpg_smc5 & pwr1_on_smc5) 
  ##1 (gate_clk_smc5 & isolate_smc5 & rstn_non_srpg_smc5 & pwr1_on_smc5) 
  ##3 (gate_clk_smc5 & isolate_smc5 & !rstn_non_srpg_smc5 & !pwr1_on_smc5);
endsequence


property p_power_down_smc5;
   @(posedge pclk5)
    $rose(gate_clk_smc5) |=> s_power_down_smc5;
endproperty

output_power_down_smc5:
  assert property (p_power_down_smc5);


// Power5 UP5 SMC5
// Sequence starts with , Rising5 edge of pwr1_on_smc5.
// Two5 clock5 cycle after this, isolate_smc5 should become5 LOW5 
// On5 the following5 clk5 gate_clk_smc5 should go5 low5.
// 5 cycles5 after  Rising5 edge of pwr1_on_smc5, rstn_non_srpg_smc5
// should become5 HIGH5
sequence s_power_up_smc5;
##30 (pwr1_on_smc5 & !isolate_smc5 & gate_clk_smc5 & !rstn_non_srpg_smc5) 
##1 (pwr1_on_smc5 & !isolate_smc5 & !gate_clk_smc5 & !rstn_non_srpg_smc5) 
##2 (pwr1_on_smc5 & !isolate_smc5 & !gate_clk_smc5 & rstn_non_srpg_smc5);
endsequence

property p_power_up_smc5;
   @(posedge pclk5)
  disable iff(!nprst5)
    (!pwr1_on_smc5 ##1 pwr1_on_smc5) |=> s_power_up_smc5;
endproperty

output_power_up_smc5:
  assert property (p_power_up_smc5);


// COVER5 SMC5 POWER5 DOWN5 AND5 UP5
cover_power_down_up_smc5: cover property (@(posedge pclk5)
(s_power_down_smc5 ##[5:180] s_power_up_smc5));



// COVER5 UART5 POWER5 DOWN5 AND5 UP5
cover_power_down_up_urt5: cover property (@(posedge pclk5)
(s_power_down_urt5 ##[5:180] s_power_up_urt5));

cover_power_down_urt5: cover property (@(posedge pclk5)
(s_power_down_urt5));

cover_power_up_urt5: cover property (@(posedge pclk5)
(s_power_up_urt5));




`ifdef PCM_ABV_ON5
//------------------------------------------------------------------------------
// Power5 Controller5 Formal5 Verification5 component.  Each power5 domain has a 
// separate5 instantiation5
//------------------------------------------------------------------------------

// need to assume that CPU5 will leave5 a minimum time between powering5 down and 
// back up.  In this example5, 10clks has been selected.
// psl5 config_min_uart_pd_time5 : assume always {rose5(L1_ctrl_domain5[1])} |-> { L1_ctrl_domain5[1][*10] } abort5(~nprst5);
// psl5 config_min_uart_pu_time5 : assume always {fell5(L1_ctrl_domain5[1])} |-> { !L1_ctrl_domain5[1][*10] } abort5(~nprst5);
// psl5 config_min_smc_pd_time5 : assume always {rose5(L1_ctrl_domain5[2])} |-> { L1_ctrl_domain5[2][*10] } abort5(~nprst5);
// psl5 config_min_smc_pu_time5 : assume always {fell5(L1_ctrl_domain5[2])} |-> { !L1_ctrl_domain5[2][*10] } abort5(~nprst5);

// UART5 VCOMP5 parameters5
   defparam i_uart_vcomp_domain5.ENABLE_SAVE_RESTORE_EDGE5   = 1;
   defparam i_uart_vcomp_domain5.ENABLE_EXT_PWR_CNTRL5       = 1;
   defparam i_uart_vcomp_domain5.REF_CLK_DEFINED5            = 0;
   defparam i_uart_vcomp_domain5.MIN_SHUTOFF_CYCLES5         = 4;
   defparam i_uart_vcomp_domain5.MIN_RESTORE_TO_ISO_CYCLES5  = 0;
   defparam i_uart_vcomp_domain5.MIN_SAVE_TO_SHUTOFF_CYCLES5 = 1;


   vcomp_domain5 i_uart_vcomp_domain5
   ( .ref_clk5(pclk5),
     .start_lps5(L1_ctrl_domain5[1] || !rstn_non_srpg_urt5),
     .rst_n5(nprst5),
     .ext_power_down5(L1_ctrl_domain5[1]),
     .iso_en5(isolate_urt5),
     .save_edge5(save_edge_urt5),
     .restore_edge5(restore_edge_urt5),
     .domain_shut_off5(pwr1_off_urt5),
     .domain_clk5(!gate_clk_urt5 && pclk5)
   );


// SMC5 VCOMP5 parameters5
   defparam i_smc_vcomp_domain5.ENABLE_SAVE_RESTORE_EDGE5   = 1;
   defparam i_smc_vcomp_domain5.ENABLE_EXT_PWR_CNTRL5       = 1;
   defparam i_smc_vcomp_domain5.REF_CLK_DEFINED5            = 0;
   defparam i_smc_vcomp_domain5.MIN_SHUTOFF_CYCLES5         = 4;
   defparam i_smc_vcomp_domain5.MIN_RESTORE_TO_ISO_CYCLES5  = 0;
   defparam i_smc_vcomp_domain5.MIN_SAVE_TO_SHUTOFF_CYCLES5 = 1;


   vcomp_domain5 i_smc_vcomp_domain5
   ( .ref_clk5(pclk5),
     .start_lps5(L1_ctrl_domain5[2] || !rstn_non_srpg_smc5),
     .rst_n5(nprst5),
     .ext_power_down5(L1_ctrl_domain5[2]),
     .iso_en5(isolate_smc5),
     .save_edge5(save_edge_smc5),
     .restore_edge5(restore_edge_smc5),
     .domain_shut_off5(pwr1_off_smc5),
     .domain_clk5(!gate_clk_smc5 && pclk5)
   );

`endif

`endif



endmodule
