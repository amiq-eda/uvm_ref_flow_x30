//File18 name   : power_ctrl18.v
//Title18       : Power18 Control18 Module18
//Created18     : 1999
//Description18 : Top18 level of power18 controller18
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

module power_ctrl18 (


    // Clocks18 & Reset18
    pclk18,
    nprst18,
    // APB18 programming18 interface
    paddr18,
    psel18,
    penable18,
    pwrite18,
    pwdata18,
    prdata18,
    // mac18 i/f,
    macb3_wakeup18,
    macb2_wakeup18,
    macb1_wakeup18,
    macb0_wakeup18,
    // Scan18 
    scan_in18,
    scan_en18,
    scan_mode18,
    scan_out18,
    // Module18 control18 outputs18
    int_source_h18,
    // SMC18
    rstn_non_srpg_smc18,
    gate_clk_smc18,
    isolate_smc18,
    save_edge_smc18,
    restore_edge_smc18,
    pwr1_on_smc18,
    pwr2_on_smc18,
    pwr1_off_smc18,
    pwr2_off_smc18,
    // URT18
    rstn_non_srpg_urt18,
    gate_clk_urt18,
    isolate_urt18,
    save_edge_urt18,
    restore_edge_urt18,
    pwr1_on_urt18,
    pwr2_on_urt18,
    pwr1_off_urt18,      
    pwr2_off_urt18,
    // ETH018
    rstn_non_srpg_macb018,
    gate_clk_macb018,
    isolate_macb018,
    save_edge_macb018,
    restore_edge_macb018,
    pwr1_on_macb018,
    pwr2_on_macb018,
    pwr1_off_macb018,      
    pwr2_off_macb018,
    // ETH118
    rstn_non_srpg_macb118,
    gate_clk_macb118,
    isolate_macb118,
    save_edge_macb118,
    restore_edge_macb118,
    pwr1_on_macb118,
    pwr2_on_macb118,
    pwr1_off_macb118,      
    pwr2_off_macb118,
    // ETH218
    rstn_non_srpg_macb218,
    gate_clk_macb218,
    isolate_macb218,
    save_edge_macb218,
    restore_edge_macb218,
    pwr1_on_macb218,
    pwr2_on_macb218,
    pwr1_off_macb218,      
    pwr2_off_macb218,
    // ETH318
    rstn_non_srpg_macb318,
    gate_clk_macb318,
    isolate_macb318,
    save_edge_macb318,
    restore_edge_macb318,
    pwr1_on_macb318,
    pwr2_on_macb318,
    pwr1_off_macb318,      
    pwr2_off_macb318,
    // DMA18
    rstn_non_srpg_dma18,
    gate_clk_dma18,
    isolate_dma18,
    save_edge_dma18,
    restore_edge_dma18,
    pwr1_on_dma18,
    pwr2_on_dma18,
    pwr1_off_dma18,      
    pwr2_off_dma18,
    // CPU18
    rstn_non_srpg_cpu18,
    gate_clk_cpu18,
    isolate_cpu18,
    save_edge_cpu18,
    restore_edge_cpu18,
    pwr1_on_cpu18,
    pwr2_on_cpu18,
    pwr1_off_cpu18,      
    pwr2_off_cpu18,
    // ALUT18
    rstn_non_srpg_alut18,
    gate_clk_alut18,
    isolate_alut18,
    save_edge_alut18,
    restore_edge_alut18,
    pwr1_on_alut18,
    pwr2_on_alut18,
    pwr1_off_alut18,      
    pwr2_off_alut18,
    // MEM18
    rstn_non_srpg_mem18,
    gate_clk_mem18,
    isolate_mem18,
    save_edge_mem18,
    restore_edge_mem18,
    pwr1_on_mem18,
    pwr2_on_mem18,
    pwr1_off_mem18,      
    pwr2_off_mem18,
    // core18 dvfs18 transitions18
    core06v18,
    core08v18,
    core10v18,
    core12v18,
    pcm_macb_wakeup_int18,
    // mte18 signals18
    mte_smc_start18,
    mte_uart_start18,
    mte_smc_uart_start18,  
    mte_pm_smc_to_default_start18, 
    mte_pm_uart_to_default_start18,
    mte_pm_smc_uart_to_default_start18

  );

  parameter STATE_IDLE_12V18 = 4'b0001;
  parameter STATE_06V18 = 4'b0010;
  parameter STATE_08V18 = 4'b0100;
  parameter STATE_10V18 = 4'b1000;

    // Clocks18 & Reset18
    input pclk18;
    input nprst18;
    // APB18 programming18 interface
    input [31:0] paddr18;
    input psel18  ;
    input penable18;
    input pwrite18 ;
    input [31:0] pwdata18;
    output [31:0] prdata18;
    // mac18
    input macb3_wakeup18;
    input macb2_wakeup18;
    input macb1_wakeup18;
    input macb0_wakeup18;
    // Scan18 
    input scan_in18;
    input scan_en18;
    input scan_mode18;
    output scan_out18;
    // Module18 control18 outputs18
    input int_source_h18;
    // SMC18
    output rstn_non_srpg_smc18 ;
    output gate_clk_smc18   ;
    output isolate_smc18   ;
    output save_edge_smc18   ;
    output restore_edge_smc18   ;
    output pwr1_on_smc18   ;
    output pwr2_on_smc18   ;
    output pwr1_off_smc18  ;
    output pwr2_off_smc18  ;
    // URT18
    output rstn_non_srpg_urt18 ;
    output gate_clk_urt18      ;
    output isolate_urt18       ;
    output save_edge_urt18   ;
    output restore_edge_urt18   ;
    output pwr1_on_urt18       ;
    output pwr2_on_urt18       ;
    output pwr1_off_urt18      ;
    output pwr2_off_urt18      ;
    // ETH018
    output rstn_non_srpg_macb018 ;
    output gate_clk_macb018      ;
    output isolate_macb018       ;
    output save_edge_macb018   ;
    output restore_edge_macb018   ;
    output pwr1_on_macb018       ;
    output pwr2_on_macb018       ;
    output pwr1_off_macb018      ;
    output pwr2_off_macb018      ;
    // ETH118
    output rstn_non_srpg_macb118 ;
    output gate_clk_macb118      ;
    output isolate_macb118       ;
    output save_edge_macb118   ;
    output restore_edge_macb118   ;
    output pwr1_on_macb118       ;
    output pwr2_on_macb118       ;
    output pwr1_off_macb118      ;
    output pwr2_off_macb118      ;
    // ETH218
    output rstn_non_srpg_macb218 ;
    output gate_clk_macb218      ;
    output isolate_macb218       ;
    output save_edge_macb218   ;
    output restore_edge_macb218   ;
    output pwr1_on_macb218       ;
    output pwr2_on_macb218       ;
    output pwr1_off_macb218      ;
    output pwr2_off_macb218      ;
    // ETH318
    output rstn_non_srpg_macb318 ;
    output gate_clk_macb318      ;
    output isolate_macb318       ;
    output save_edge_macb318   ;
    output restore_edge_macb318   ;
    output pwr1_on_macb318       ;
    output pwr2_on_macb318       ;
    output pwr1_off_macb318      ;
    output pwr2_off_macb318      ;
    // DMA18
    output rstn_non_srpg_dma18 ;
    output gate_clk_dma18      ;
    output isolate_dma18       ;
    output save_edge_dma18   ;
    output restore_edge_dma18   ;
    output pwr1_on_dma18       ;
    output pwr2_on_dma18       ;
    output pwr1_off_dma18      ;
    output pwr2_off_dma18      ;
    // CPU18
    output rstn_non_srpg_cpu18 ;
    output gate_clk_cpu18      ;
    output isolate_cpu18       ;
    output save_edge_cpu18   ;
    output restore_edge_cpu18   ;
    output pwr1_on_cpu18       ;
    output pwr2_on_cpu18       ;
    output pwr1_off_cpu18      ;
    output pwr2_off_cpu18      ;
    // ALUT18
    output rstn_non_srpg_alut18 ;
    output gate_clk_alut18      ;
    output isolate_alut18       ;
    output save_edge_alut18   ;
    output restore_edge_alut18   ;
    output pwr1_on_alut18       ;
    output pwr2_on_alut18       ;
    output pwr1_off_alut18      ;
    output pwr2_off_alut18      ;
    // MEM18
    output rstn_non_srpg_mem18 ;
    output gate_clk_mem18      ;
    output isolate_mem18       ;
    output save_edge_mem18   ;
    output restore_edge_mem18   ;
    output pwr1_on_mem18       ;
    output pwr2_on_mem18       ;
    output pwr1_off_mem18      ;
    output pwr2_off_mem18      ;


   // core18 transitions18 o/p
    output core06v18;
    output core08v18;
    output core10v18;
    output core12v18;
    output pcm_macb_wakeup_int18 ;
    //mode mte18  signals18
    output mte_smc_start18;
    output mte_uart_start18;
    output mte_smc_uart_start18;  
    output mte_pm_smc_to_default_start18; 
    output mte_pm_uart_to_default_start18;
    output mte_pm_smc_uart_to_default_start18;

    reg mte_smc_start18;
    reg mte_uart_start18;
    reg mte_smc_uart_start18;  
    reg mte_pm_smc_to_default_start18; 
    reg mte_pm_uart_to_default_start18;
    reg mte_pm_smc_uart_to_default_start18;

    reg [31:0] prdata18;

  wire valid_reg_write18  ;
  wire valid_reg_read18   ;
  wire L1_ctrl_access18   ;
  wire L1_status_access18 ;
  wire pcm_int_mask_access18;
  wire pcm_int_status_access18;
  wire standby_mem018      ;
  wire standby_mem118      ;
  wire standby_mem218      ;
  wire standby_mem318      ;
  wire pwr1_off_mem018;
  wire pwr1_off_mem118;
  wire pwr1_off_mem218;
  wire pwr1_off_mem318;
  
  // Control18 signals18
  wire set_status_smc18   ;
  wire clr_status_smc18   ;
  wire set_status_urt18   ;
  wire clr_status_urt18   ;
  wire set_status_macb018   ;
  wire clr_status_macb018   ;
  wire set_status_macb118   ;
  wire clr_status_macb118   ;
  wire set_status_macb218   ;
  wire clr_status_macb218   ;
  wire set_status_macb318   ;
  wire clr_status_macb318   ;
  wire set_status_dma18   ;
  wire clr_status_dma18   ;
  wire set_status_cpu18   ;
  wire clr_status_cpu18   ;
  wire set_status_alut18   ;
  wire clr_status_alut18   ;
  wire set_status_mem18   ;
  wire clr_status_mem18   ;


  // Status and Control18 registers
  reg [31:0]  L1_status_reg18;
  reg  [31:0] L1_ctrl_reg18  ;
  reg  [31:0] L1_ctrl_domain18  ;
  reg L1_ctrl_cpu_off_reg18;
  reg [31:0]  pcm_mask_reg18;
  reg [31:0]  pcm_status_reg18;

  // Signals18 gated18 in scan_mode18
  //SMC18
  wire  rstn_non_srpg_smc_int18;
  wire  gate_clk_smc_int18    ;     
  wire  isolate_smc_int18    ;       
  wire save_edge_smc_int18;
  wire restore_edge_smc_int18;
  wire  pwr1_on_smc_int18    ;      
  wire  pwr2_on_smc_int18    ;      


  //URT18
  wire   rstn_non_srpg_urt_int18;
  wire   gate_clk_urt_int18     ;     
  wire   isolate_urt_int18      ;       
  wire save_edge_urt_int18;
  wire restore_edge_urt_int18;
  wire   pwr1_on_urt_int18      ;      
  wire   pwr2_on_urt_int18      ;      

  // ETH018
  wire   rstn_non_srpg_macb0_int18;
  wire   gate_clk_macb0_int18     ;     
  wire   isolate_macb0_int18      ;       
  wire save_edge_macb0_int18;
  wire restore_edge_macb0_int18;
  wire   pwr1_on_macb0_int18      ;      
  wire   pwr2_on_macb0_int18      ;      
  // ETH118
  wire   rstn_non_srpg_macb1_int18;
  wire   gate_clk_macb1_int18     ;     
  wire   isolate_macb1_int18      ;       
  wire save_edge_macb1_int18;
  wire restore_edge_macb1_int18;
  wire   pwr1_on_macb1_int18      ;      
  wire   pwr2_on_macb1_int18      ;      
  // ETH218
  wire   rstn_non_srpg_macb2_int18;
  wire   gate_clk_macb2_int18     ;     
  wire   isolate_macb2_int18      ;       
  wire save_edge_macb2_int18;
  wire restore_edge_macb2_int18;
  wire   pwr1_on_macb2_int18      ;      
  wire   pwr2_on_macb2_int18      ;      
  // ETH318
  wire   rstn_non_srpg_macb3_int18;
  wire   gate_clk_macb3_int18     ;     
  wire   isolate_macb3_int18      ;       
  wire save_edge_macb3_int18;
  wire restore_edge_macb3_int18;
  wire   pwr1_on_macb3_int18      ;      
  wire   pwr2_on_macb3_int18      ;      

  // DMA18
  wire   rstn_non_srpg_dma_int18;
  wire   gate_clk_dma_int18     ;     
  wire   isolate_dma_int18      ;       
  wire save_edge_dma_int18;
  wire restore_edge_dma_int18;
  wire   pwr1_on_dma_int18      ;      
  wire   pwr2_on_dma_int18      ;      

  // CPU18
  wire   rstn_non_srpg_cpu_int18;
  wire   gate_clk_cpu_int18     ;     
  wire   isolate_cpu_int18      ;       
  wire save_edge_cpu_int18;
  wire restore_edge_cpu_int18;
  wire   pwr1_on_cpu_int18      ;      
  wire   pwr2_on_cpu_int18      ;  
  wire L1_ctrl_cpu_off_p18;    

  reg save_alut_tmp18;
  // DFS18 sm18

  reg cpu_shutoff_ctrl18;

  reg mte_mac_off_start18, mte_mac012_start18, mte_mac013_start18, mte_mac023_start18, mte_mac123_start18;
  reg mte_mac01_start18, mte_mac02_start18, mte_mac03_start18, mte_mac12_start18, mte_mac13_start18, mte_mac23_start18;
  reg mte_mac0_start18, mte_mac1_start18, mte_mac2_start18, mte_mac3_start18;
  reg mte_sys_hibernate18 ;
  reg mte_dma_start18 ;
  reg mte_cpu_start18 ;
  reg mte_mac_off_sleep_start18, mte_mac012_sleep_start18, mte_mac013_sleep_start18, mte_mac023_sleep_start18, mte_mac123_sleep_start18;
  reg mte_mac01_sleep_start18, mte_mac02_sleep_start18, mte_mac03_sleep_start18, mte_mac12_sleep_start18, mte_mac13_sleep_start18, mte_mac23_sleep_start18;
  reg mte_mac0_sleep_start18, mte_mac1_sleep_start18, mte_mac2_sleep_start18, mte_mac3_sleep_start18;
  reg mte_dma_sleep_start18;
  reg mte_mac_off_to_default18, mte_mac012_to_default18, mte_mac013_to_default18, mte_mac023_to_default18, mte_mac123_to_default18;
  reg mte_mac01_to_default18, mte_mac02_to_default18, mte_mac03_to_default18, mte_mac12_to_default18, mte_mac13_to_default18, mte_mac23_to_default18;
  reg mte_mac0_to_default18, mte_mac1_to_default18, mte_mac2_to_default18, mte_mac3_to_default18;
  reg mte_dma_isolate_dis18;
  reg mte_cpu_isolate_dis18;
  reg mte_sys_hibernate_to_default18;


  // Latch18 the CPU18 SLEEP18 invocation18
  always @( posedge pclk18 or negedge nprst18) 
  begin
    if(!nprst18)
      L1_ctrl_cpu_off_reg18 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg18 <= L1_ctrl_domain18[8];
  end

  // Create18 a pulse18 for sleep18 detection18 
  assign L1_ctrl_cpu_off_p18 =  L1_ctrl_domain18[8] && !L1_ctrl_cpu_off_reg18;
  
  // CPU18 sleep18 contol18 logic 
  // Shut18 off18 CPU18 when L1_ctrl_cpu_off_p18 is set
  // wake18 cpu18 when any interrupt18 is seen18  
  always @( posedge pclk18 or negedge nprst18) 
  begin
    if(!nprst18)
     cpu_shutoff_ctrl18 <= 1'b0;
    else if(cpu_shutoff_ctrl18 && int_source_h18)
     cpu_shutoff_ctrl18 <= 1'b0;
    else if (L1_ctrl_cpu_off_p18)
     cpu_shutoff_ctrl18 <= 1'b1;
  end
 
  // instantiate18 power18 contol18  block for uart18
  power_ctrl_sm18 i_urt_power_ctrl_sm18(
    .pclk18(pclk18),
    .nprst18(nprst18),
    .L1_module_req18(L1_ctrl_domain18[1]),
    .set_status_module18(set_status_urt18),
    .clr_status_module18(clr_status_urt18),
    .rstn_non_srpg_module18(rstn_non_srpg_urt_int18),
    .gate_clk_module18(gate_clk_urt_int18),
    .isolate_module18(isolate_urt_int18),
    .save_edge18(save_edge_urt_int18),
    .restore_edge18(restore_edge_urt_int18),
    .pwr1_on18(pwr1_on_urt_int18),
    .pwr2_on18(pwr2_on_urt_int18)
    );
  

  // instantiate18 power18 contol18  block for smc18
  power_ctrl_sm18 i_smc_power_ctrl_sm18(
    .pclk18(pclk18),
    .nprst18(nprst18),
    .L1_module_req18(L1_ctrl_domain18[2]),
    .set_status_module18(set_status_smc18),
    .clr_status_module18(clr_status_smc18),
    .rstn_non_srpg_module18(rstn_non_srpg_smc_int18),
    .gate_clk_module18(gate_clk_smc_int18),
    .isolate_module18(isolate_smc_int18),
    .save_edge18(save_edge_smc_int18),
    .restore_edge18(restore_edge_smc_int18),
    .pwr1_on18(pwr1_on_smc_int18),
    .pwr2_on18(pwr2_on_smc_int18)
    );

  // power18 control18 for macb018
  power_ctrl_sm18 i_macb0_power_ctrl_sm18(
    .pclk18(pclk18),
    .nprst18(nprst18),
    .L1_module_req18(L1_ctrl_domain18[3]),
    .set_status_module18(set_status_macb018),
    .clr_status_module18(clr_status_macb018),
    .rstn_non_srpg_module18(rstn_non_srpg_macb0_int18),
    .gate_clk_module18(gate_clk_macb0_int18),
    .isolate_module18(isolate_macb0_int18),
    .save_edge18(save_edge_macb0_int18),
    .restore_edge18(restore_edge_macb0_int18),
    .pwr1_on18(pwr1_on_macb0_int18),
    .pwr2_on18(pwr2_on_macb0_int18)
    );
  // power18 control18 for macb118
  power_ctrl_sm18 i_macb1_power_ctrl_sm18(
    .pclk18(pclk18),
    .nprst18(nprst18),
    .L1_module_req18(L1_ctrl_domain18[4]),
    .set_status_module18(set_status_macb118),
    .clr_status_module18(clr_status_macb118),
    .rstn_non_srpg_module18(rstn_non_srpg_macb1_int18),
    .gate_clk_module18(gate_clk_macb1_int18),
    .isolate_module18(isolate_macb1_int18),
    .save_edge18(save_edge_macb1_int18),
    .restore_edge18(restore_edge_macb1_int18),
    .pwr1_on18(pwr1_on_macb1_int18),
    .pwr2_on18(pwr2_on_macb1_int18)
    );
  // power18 control18 for macb218
  power_ctrl_sm18 i_macb2_power_ctrl_sm18(
    .pclk18(pclk18),
    .nprst18(nprst18),
    .L1_module_req18(L1_ctrl_domain18[5]),
    .set_status_module18(set_status_macb218),
    .clr_status_module18(clr_status_macb218),
    .rstn_non_srpg_module18(rstn_non_srpg_macb2_int18),
    .gate_clk_module18(gate_clk_macb2_int18),
    .isolate_module18(isolate_macb2_int18),
    .save_edge18(save_edge_macb2_int18),
    .restore_edge18(restore_edge_macb2_int18),
    .pwr1_on18(pwr1_on_macb2_int18),
    .pwr2_on18(pwr2_on_macb2_int18)
    );
  // power18 control18 for macb318
  power_ctrl_sm18 i_macb3_power_ctrl_sm18(
    .pclk18(pclk18),
    .nprst18(nprst18),
    .L1_module_req18(L1_ctrl_domain18[6]),
    .set_status_module18(set_status_macb318),
    .clr_status_module18(clr_status_macb318),
    .rstn_non_srpg_module18(rstn_non_srpg_macb3_int18),
    .gate_clk_module18(gate_clk_macb3_int18),
    .isolate_module18(isolate_macb3_int18),
    .save_edge18(save_edge_macb3_int18),
    .restore_edge18(restore_edge_macb3_int18),
    .pwr1_on18(pwr1_on_macb3_int18),
    .pwr2_on18(pwr2_on_macb3_int18)
    );
  // power18 control18 for dma18
  power_ctrl_sm18 i_dma_power_ctrl_sm18(
    .pclk18(pclk18),
    .nprst18(nprst18),
    .L1_module_req18(L1_ctrl_domain18[7]),
    .set_status_module18(set_status_dma18),
    .clr_status_module18(clr_status_dma18),
    .rstn_non_srpg_module18(rstn_non_srpg_dma_int18),
    .gate_clk_module18(gate_clk_dma_int18),
    .isolate_module18(isolate_dma_int18),
    .save_edge18(save_edge_dma_int18),
    .restore_edge18(restore_edge_dma_int18),
    .pwr1_on18(pwr1_on_dma_int18),
    .pwr2_on18(pwr2_on_dma_int18)
    );
  // power18 control18 for CPU18
  power_ctrl_sm18 i_cpu_power_ctrl_sm18(
    .pclk18(pclk18),
    .nprst18(nprst18),
    .L1_module_req18(cpu_shutoff_ctrl18),
    .set_status_module18(set_status_cpu18),
    .clr_status_module18(clr_status_cpu18),
    .rstn_non_srpg_module18(rstn_non_srpg_cpu_int18),
    .gate_clk_module18(gate_clk_cpu_int18),
    .isolate_module18(isolate_cpu_int18),
    .save_edge18(save_edge_cpu_int18),
    .restore_edge18(restore_edge_cpu_int18),
    .pwr1_on18(pwr1_on_cpu_int18),
    .pwr2_on18(pwr2_on_cpu_int18)
    );

  assign valid_reg_write18 =  (psel18 && pwrite18 && penable18);
  assign valid_reg_read18  =  (psel18 && (!pwrite18) && penable18);

  assign L1_ctrl_access18  =  (paddr18[15:0] == 16'b0000000000000100); 
  assign L1_status_access18 = (paddr18[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access18 =   (paddr18[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access18 = (paddr18[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control18 and status register
  always @(*)
  begin  
    if(valid_reg_read18 && L1_ctrl_access18) 
      prdata18 = L1_ctrl_reg18;
    else if (valid_reg_read18 && L1_status_access18)
      prdata18 = L1_status_reg18;
    else if (valid_reg_read18 && pcm_int_mask_access18)
      prdata18 = pcm_mask_reg18;
    else if (valid_reg_read18 && pcm_int_status_access18)
      prdata18 = pcm_status_reg18;
    else 
      prdata18 = 0;
  end

  assign set_status_mem18 =  (set_status_macb018 && set_status_macb118 && set_status_macb218 &&
                            set_status_macb318 && set_status_dma18 && set_status_cpu18);

  assign clr_status_mem18 =  (clr_status_macb018 && clr_status_macb118 && clr_status_macb218 &&
                            clr_status_macb318 && clr_status_dma18 && clr_status_cpu18);

  assign set_status_alut18 = (set_status_macb018 && set_status_macb118 && set_status_macb218 && set_status_macb318);

  assign clr_status_alut18 = (clr_status_macb018 || clr_status_macb118 || clr_status_macb218  || clr_status_macb318);

  // Write accesses to the control18 and status register
 
  always @(posedge pclk18 or negedge nprst18)
  begin
    if (!nprst18) begin
      L1_ctrl_reg18   <= 0;
      L1_status_reg18 <= 0;
      pcm_mask_reg18 <= 0;
    end else begin
      // CTRL18 reg updates18
      if (valid_reg_write18 && L1_ctrl_access18) 
        L1_ctrl_reg18 <= pwdata18; // Writes18 to the ctrl18 reg
      if (valid_reg_write18 && pcm_int_mask_access18) 
        pcm_mask_reg18 <= pwdata18; // Writes18 to the ctrl18 reg

      if (set_status_urt18 == 1'b1)  
        L1_status_reg18[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt18 == 1'b1) 
        L1_status_reg18[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc18 == 1'b1) 
        L1_status_reg18[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc18 == 1'b1) 
        L1_status_reg18[2] <= 1'b0; // Clear the status bit

      if (set_status_macb018 == 1'b1)  
        L1_status_reg18[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb018 == 1'b1) 
        L1_status_reg18[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb118 == 1'b1)  
        L1_status_reg18[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb118 == 1'b1) 
        L1_status_reg18[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb218 == 1'b1)  
        L1_status_reg18[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb218 == 1'b1) 
        L1_status_reg18[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb318 == 1'b1)  
        L1_status_reg18[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb318 == 1'b1) 
        L1_status_reg18[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma18 == 1'b1)  
        L1_status_reg18[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma18 == 1'b1) 
        L1_status_reg18[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu18 == 1'b1)  
        L1_status_reg18[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu18 == 1'b1) 
        L1_status_reg18[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut18 == 1'b1)  
        L1_status_reg18[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut18 == 1'b1) 
        L1_status_reg18[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem18 == 1'b1)  
        L1_status_reg18[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem18 == 1'b1) 
        L1_status_reg18[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused18 bits of pcm_status_reg18 are tied18 to 0
  always @(posedge pclk18 or negedge nprst18)
  begin
    if (!nprst18)
      pcm_status_reg18[31:4] <= 'b0;
    else  
      pcm_status_reg18[31:4] <= pcm_status_reg18[31:4];
  end
  
  // interrupt18 only of h/w assisted18 wakeup
  // MAC18 3
  always @(posedge pclk18 or negedge nprst18)
  begin
    if(!nprst18)
      pcm_status_reg18[3] <= 1'b0;
    else if (valid_reg_write18 && pcm_int_status_access18) 
      pcm_status_reg18[3] <= pwdata18[3];
    else if (macb3_wakeup18 & ~pcm_mask_reg18[3])
      pcm_status_reg18[3] <= 1'b1;
    else if (valid_reg_read18 && pcm_int_status_access18) 
      pcm_status_reg18[3] <= 1'b0;
    else
      pcm_status_reg18[3] <= pcm_status_reg18[3];
  end  
   
  // MAC18 2
  always @(posedge pclk18 or negedge nprst18)
  begin
    if(!nprst18)
      pcm_status_reg18[2] <= 1'b0;
    else if (valid_reg_write18 && pcm_int_status_access18) 
      pcm_status_reg18[2] <= pwdata18[2];
    else if (macb2_wakeup18 & ~pcm_mask_reg18[2])
      pcm_status_reg18[2] <= 1'b1;
    else if (valid_reg_read18 && pcm_int_status_access18) 
      pcm_status_reg18[2] <= 1'b0;
    else
      pcm_status_reg18[2] <= pcm_status_reg18[2];
  end  

  // MAC18 1
  always @(posedge pclk18 or negedge nprst18)
  begin
    if(!nprst18)
      pcm_status_reg18[1] <= 1'b0;
    else if (valid_reg_write18 && pcm_int_status_access18) 
      pcm_status_reg18[1] <= pwdata18[1];
    else if (macb1_wakeup18 & ~pcm_mask_reg18[1])
      pcm_status_reg18[1] <= 1'b1;
    else if (valid_reg_read18 && pcm_int_status_access18) 
      pcm_status_reg18[1] <= 1'b0;
    else
      pcm_status_reg18[1] <= pcm_status_reg18[1];
  end  
   
  // MAC18 0
  always @(posedge pclk18 or negedge nprst18)
  begin
    if(!nprst18)
      pcm_status_reg18[0] <= 1'b0;
    else if (valid_reg_write18 && pcm_int_status_access18) 
      pcm_status_reg18[0] <= pwdata18[0];
    else if (macb0_wakeup18 & ~pcm_mask_reg18[0])
      pcm_status_reg18[0] <= 1'b1;
    else if (valid_reg_read18 && pcm_int_status_access18) 
      pcm_status_reg18[0] <= 1'b0;
    else
      pcm_status_reg18[0] <= pcm_status_reg18[0];
  end  

  assign pcm_macb_wakeup_int18 = |pcm_status_reg18;

  reg [31:0] L1_ctrl_reg118;
  always @(posedge pclk18 or negedge nprst18)
  begin
    if(!nprst18)
      L1_ctrl_reg118 <= 0;
    else
      L1_ctrl_reg118 <= L1_ctrl_reg18;
  end

  // Program18 mode decode
  always @(L1_ctrl_reg18 or L1_ctrl_reg118 or int_source_h18 or cpu_shutoff_ctrl18) begin
    mte_smc_start18 = 0;
    mte_uart_start18 = 0;
    mte_smc_uart_start18  = 0;
    mte_mac_off_start18  = 0;
    mte_mac012_start18 = 0;
    mte_mac013_start18 = 0;
    mte_mac023_start18 = 0;
    mte_mac123_start18 = 0;
    mte_mac01_start18 = 0;
    mte_mac02_start18 = 0;
    mte_mac03_start18 = 0;
    mte_mac12_start18 = 0;
    mte_mac13_start18 = 0;
    mte_mac23_start18 = 0;
    mte_mac0_start18 = 0;
    mte_mac1_start18 = 0;
    mte_mac2_start18 = 0;
    mte_mac3_start18 = 0;
    mte_sys_hibernate18 = 0 ;
    mte_dma_start18 = 0 ;
    mte_cpu_start18 = 0 ;

    mte_mac0_sleep_start18 = (L1_ctrl_reg18 ==  'h14) && (L1_ctrl_reg118 == 'h4 );
    mte_mac1_sleep_start18 = (L1_ctrl_reg18 ==  'h14) && (L1_ctrl_reg118 == 'h5 ); 
    mte_mac2_sleep_start18 = (L1_ctrl_reg18 ==  'h14) && (L1_ctrl_reg118 == 'h6 ); 
    mte_mac3_sleep_start18 = (L1_ctrl_reg18 ==  'h14) && (L1_ctrl_reg118 == 'h7 ); 
    mte_mac01_sleep_start18 = (L1_ctrl_reg18 ==  'h14) && (L1_ctrl_reg118 == 'h8 ); 
    mte_mac02_sleep_start18 = (L1_ctrl_reg18 ==  'h14) && (L1_ctrl_reg118 == 'h9 ); 
    mte_mac03_sleep_start18 = (L1_ctrl_reg18 ==  'h14) && (L1_ctrl_reg118 == 'hA ); 
    mte_mac12_sleep_start18 = (L1_ctrl_reg18 ==  'h14) && (L1_ctrl_reg118 == 'hB ); 
    mte_mac13_sleep_start18 = (L1_ctrl_reg18 ==  'h14) && (L1_ctrl_reg118 == 'hC ); 
    mte_mac23_sleep_start18 = (L1_ctrl_reg18 ==  'h14) && (L1_ctrl_reg118 == 'hD ); 
    mte_mac012_sleep_start18 = (L1_ctrl_reg18 ==  'h14) && (L1_ctrl_reg118 == 'hE ); 
    mte_mac013_sleep_start18 = (L1_ctrl_reg18 ==  'h14) && (L1_ctrl_reg118 == 'hF ); 
    mte_mac023_sleep_start18 = (L1_ctrl_reg18 ==  'h14) && (L1_ctrl_reg118 == 'h10 ); 
    mte_mac123_sleep_start18 = (L1_ctrl_reg18 ==  'h14) && (L1_ctrl_reg118 == 'h11 ); 
    mte_mac_off_sleep_start18 =  (L1_ctrl_reg18 == 'h14) && (L1_ctrl_reg118 == 'h12 );
    mte_dma_sleep_start18 =  (L1_ctrl_reg18 == 'h14) && (L1_ctrl_reg118 == 'h13 );

    mte_pm_uart_to_default_start18 = (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'h1);
    mte_pm_smc_to_default_start18 = (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'h2);
    mte_pm_smc_uart_to_default_start18 = (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'h3); 
    mte_mac0_to_default18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'h4); 
    mte_mac1_to_default18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'h5); 
    mte_mac2_to_default18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'h6); 
    mte_mac3_to_default18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'h7); 
    mte_mac01_to_default18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'h8); 
    mte_mac02_to_default18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'h9); 
    mte_mac03_to_default18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'hA); 
    mte_mac12_to_default18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'hB); 
    mte_mac13_to_default18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'hC); 
    mte_mac23_to_default18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'hD); 
    mte_mac012_to_default18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'hE); 
    mte_mac013_to_default18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'hF); 
    mte_mac023_to_default18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'h10); 
    mte_mac123_to_default18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'h11); 
    mte_mac_off_to_default18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'h12); 
    mte_dma_isolate_dis18 =  (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'h13); 
    mte_cpu_isolate_dis18 =  (int_source_h18) && (cpu_shutoff_ctrl18) && (L1_ctrl_reg18 != 'h15);
    mte_sys_hibernate_to_default18 = (L1_ctrl_reg18 == 32'h0) && (L1_ctrl_reg118 == 'h15); 

   
    if (L1_ctrl_reg118 == 'h0) begin // This18 check is to make mte_cpu_start18
                                   // is set only when you from default state 
      case (L1_ctrl_reg18)
        'h0 : L1_ctrl_domain18 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain18 = 32'h2; // PM_uart18
                mte_uart_start18 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain18 = 32'h4; // PM_smc18
                mte_smc_start18 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain18 = 32'h6; // PM_smc_uart18
                mte_smc_uart_start18 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain18 = 32'h8; //  PM_macb018
                mte_mac0_start18 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain18 = 32'h10; //  PM_macb118
                mte_mac1_start18 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain18 = 32'h20; //  PM_macb218
                mte_mac2_start18 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain18 = 32'h40; //  PM_macb318
                mte_mac3_start18 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain18 = 32'h18; //  PM_macb0118
                mte_mac01_start18 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain18 = 32'h28; //  PM_macb0218
                mte_mac02_start18 = 1;
              end
        'hA : begin  
                L1_ctrl_domain18 = 32'h48; //  PM_macb0318
                mte_mac03_start18 = 1;
              end
        'hB : begin  
                L1_ctrl_domain18 = 32'h30; //  PM_macb1218
                mte_mac12_start18 = 1;
              end
        'hC : begin  
                L1_ctrl_domain18 = 32'h50; //  PM_macb1318
                mte_mac13_start18 = 1;
              end
        'hD : begin  
                L1_ctrl_domain18 = 32'h60; //  PM_macb2318
                mte_mac23_start18 = 1;
              end
        'hE : begin  
                L1_ctrl_domain18 = 32'h38; //  PM_macb01218
                mte_mac012_start18 = 1;
              end
        'hF : begin  
                L1_ctrl_domain18 = 32'h58; //  PM_macb01318
                mte_mac013_start18 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain18 = 32'h68; //  PM_macb02318
                mte_mac023_start18 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain18 = 32'h70; //  PM_macb12318
                mte_mac123_start18 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain18 = 32'h78; //  PM_macb_off18
                mte_mac_off_start18 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain18 = 32'h80; //  PM_dma18
                mte_dma_start18 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain18 = 32'h100; //  PM_cpu_sleep18
                mte_cpu_start18 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain18 = 32'h1FE; //  PM_hibernate18
                mte_sys_hibernate18 = 1;
              end
         default: L1_ctrl_domain18 = 32'h0;
      endcase
    end
  end


  wire to_default18 = (L1_ctrl_reg18 == 0);

  // Scan18 mode gating18 of power18 and isolation18 control18 signals18
  //SMC18
  assign rstn_non_srpg_smc18  = (scan_mode18 == 1'b0) ? rstn_non_srpg_smc_int18 : 1'b1;  
  assign gate_clk_smc18       = (scan_mode18 == 1'b0) ? gate_clk_smc_int18 : 1'b0;     
  assign isolate_smc18        = (scan_mode18 == 1'b0) ? isolate_smc_int18 : 1'b0;      
  assign pwr1_on_smc18        = (scan_mode18 == 1'b0) ? pwr1_on_smc_int18 : 1'b1;       
  assign pwr2_on_smc18        = (scan_mode18 == 1'b0) ? pwr2_on_smc_int18 : 1'b1;       
  assign pwr1_off_smc18       = (scan_mode18 == 1'b0) ? (!pwr1_on_smc_int18) : 1'b0;       
  assign pwr2_off_smc18       = (scan_mode18 == 1'b0) ? (!pwr2_on_smc_int18) : 1'b0;       
  assign save_edge_smc18       = (scan_mode18 == 1'b0) ? (save_edge_smc_int18) : 1'b0;       
  assign restore_edge_smc18       = (scan_mode18 == 1'b0) ? (restore_edge_smc_int18) : 1'b0;       

  //URT18
  assign rstn_non_srpg_urt18  = (scan_mode18 == 1'b0) ?  rstn_non_srpg_urt_int18 : 1'b1;  
  assign gate_clk_urt18       = (scan_mode18 == 1'b0) ?  gate_clk_urt_int18      : 1'b0;     
  assign isolate_urt18        = (scan_mode18 == 1'b0) ?  isolate_urt_int18       : 1'b0;      
  assign pwr1_on_urt18        = (scan_mode18 == 1'b0) ?  pwr1_on_urt_int18       : 1'b1;       
  assign pwr2_on_urt18        = (scan_mode18 == 1'b0) ?  pwr2_on_urt_int18       : 1'b1;       
  assign pwr1_off_urt18       = (scan_mode18 == 1'b0) ?  (!pwr1_on_urt_int18)  : 1'b0;       
  assign pwr2_off_urt18       = (scan_mode18 == 1'b0) ?  (!pwr2_on_urt_int18)  : 1'b0;       
  assign save_edge_urt18       = (scan_mode18 == 1'b0) ? (save_edge_urt_int18) : 1'b0;       
  assign restore_edge_urt18       = (scan_mode18 == 1'b0) ? (restore_edge_urt_int18) : 1'b0;       

  //ETH018
  assign rstn_non_srpg_macb018 = (scan_mode18 == 1'b0) ?  rstn_non_srpg_macb0_int18 : 1'b1;  
  assign gate_clk_macb018       = (scan_mode18 == 1'b0) ?  gate_clk_macb0_int18      : 1'b0;     
  assign isolate_macb018        = (scan_mode18 == 1'b0) ?  isolate_macb0_int18       : 1'b0;      
  assign pwr1_on_macb018        = (scan_mode18 == 1'b0) ?  pwr1_on_macb0_int18       : 1'b1;       
  assign pwr2_on_macb018        = (scan_mode18 == 1'b0) ?  pwr2_on_macb0_int18       : 1'b1;       
  assign pwr1_off_macb018       = (scan_mode18 == 1'b0) ?  (!pwr1_on_macb0_int18)  : 1'b0;       
  assign pwr2_off_macb018       = (scan_mode18 == 1'b0) ?  (!pwr2_on_macb0_int18)  : 1'b0;       
  assign save_edge_macb018       = (scan_mode18 == 1'b0) ? (save_edge_macb0_int18) : 1'b0;       
  assign restore_edge_macb018       = (scan_mode18 == 1'b0) ? (restore_edge_macb0_int18) : 1'b0;       

  //ETH118
  assign rstn_non_srpg_macb118 = (scan_mode18 == 1'b0) ?  rstn_non_srpg_macb1_int18 : 1'b1;  
  assign gate_clk_macb118       = (scan_mode18 == 1'b0) ?  gate_clk_macb1_int18      : 1'b0;     
  assign isolate_macb118        = (scan_mode18 == 1'b0) ?  isolate_macb1_int18       : 1'b0;      
  assign pwr1_on_macb118        = (scan_mode18 == 1'b0) ?  pwr1_on_macb1_int18       : 1'b1;       
  assign pwr2_on_macb118        = (scan_mode18 == 1'b0) ?  pwr2_on_macb1_int18       : 1'b1;       
  assign pwr1_off_macb118       = (scan_mode18 == 1'b0) ?  (!pwr1_on_macb1_int18)  : 1'b0;       
  assign pwr2_off_macb118       = (scan_mode18 == 1'b0) ?  (!pwr2_on_macb1_int18)  : 1'b0;       
  assign save_edge_macb118       = (scan_mode18 == 1'b0) ? (save_edge_macb1_int18) : 1'b0;       
  assign restore_edge_macb118       = (scan_mode18 == 1'b0) ? (restore_edge_macb1_int18) : 1'b0;       

  //ETH218
  assign rstn_non_srpg_macb218 = (scan_mode18 == 1'b0) ?  rstn_non_srpg_macb2_int18 : 1'b1;  
  assign gate_clk_macb218       = (scan_mode18 == 1'b0) ?  gate_clk_macb2_int18      : 1'b0;     
  assign isolate_macb218        = (scan_mode18 == 1'b0) ?  isolate_macb2_int18       : 1'b0;      
  assign pwr1_on_macb218        = (scan_mode18 == 1'b0) ?  pwr1_on_macb2_int18       : 1'b1;       
  assign pwr2_on_macb218        = (scan_mode18 == 1'b0) ?  pwr2_on_macb2_int18       : 1'b1;       
  assign pwr1_off_macb218       = (scan_mode18 == 1'b0) ?  (!pwr1_on_macb2_int18)  : 1'b0;       
  assign pwr2_off_macb218       = (scan_mode18 == 1'b0) ?  (!pwr2_on_macb2_int18)  : 1'b0;       
  assign save_edge_macb218       = (scan_mode18 == 1'b0) ? (save_edge_macb2_int18) : 1'b0;       
  assign restore_edge_macb218       = (scan_mode18 == 1'b0) ? (restore_edge_macb2_int18) : 1'b0;       

  //ETH318
  assign rstn_non_srpg_macb318 = (scan_mode18 == 1'b0) ?  rstn_non_srpg_macb3_int18 : 1'b1;  
  assign gate_clk_macb318       = (scan_mode18 == 1'b0) ?  gate_clk_macb3_int18      : 1'b0;     
  assign isolate_macb318        = (scan_mode18 == 1'b0) ?  isolate_macb3_int18       : 1'b0;      
  assign pwr1_on_macb318        = (scan_mode18 == 1'b0) ?  pwr1_on_macb3_int18       : 1'b1;       
  assign pwr2_on_macb318        = (scan_mode18 == 1'b0) ?  pwr2_on_macb3_int18       : 1'b1;       
  assign pwr1_off_macb318       = (scan_mode18 == 1'b0) ?  (!pwr1_on_macb3_int18)  : 1'b0;       
  assign pwr2_off_macb318       = (scan_mode18 == 1'b0) ?  (!pwr2_on_macb3_int18)  : 1'b0;       
  assign save_edge_macb318       = (scan_mode18 == 1'b0) ? (save_edge_macb3_int18) : 1'b0;       
  assign restore_edge_macb318       = (scan_mode18 == 1'b0) ? (restore_edge_macb3_int18) : 1'b0;       

  // MEM18
  assign rstn_non_srpg_mem18 =   (rstn_non_srpg_macb018 && rstn_non_srpg_macb118 && rstn_non_srpg_macb218 &&
                                rstn_non_srpg_macb318 && rstn_non_srpg_dma18 && rstn_non_srpg_cpu18 && rstn_non_srpg_urt18 &&
                                rstn_non_srpg_smc18);

  assign gate_clk_mem18 =  (gate_clk_macb018 && gate_clk_macb118 && gate_clk_macb218 &&
                            gate_clk_macb318 && gate_clk_dma18 && gate_clk_cpu18 && gate_clk_urt18 && gate_clk_smc18);

  assign isolate_mem18  = (isolate_macb018 && isolate_macb118 && isolate_macb218 &&
                         isolate_macb318 && isolate_dma18 && isolate_cpu18 && isolate_urt18 && isolate_smc18);


  assign pwr1_on_mem18        =   ~pwr1_off_mem18;

  assign pwr2_on_mem18        =   ~pwr2_off_mem18;

  assign pwr1_off_mem18       =  (pwr1_off_macb018 && pwr1_off_macb118 && pwr1_off_macb218 &&
                                 pwr1_off_macb318 && pwr1_off_dma18 && pwr1_off_cpu18 && pwr1_off_urt18 && pwr1_off_smc18);


  assign pwr2_off_mem18       =  (pwr2_off_macb018 && pwr2_off_macb118 && pwr2_off_macb218 &&
                                pwr2_off_macb318 && pwr2_off_dma18 && pwr2_off_cpu18 && pwr2_off_urt18 && pwr2_off_smc18);

  assign save_edge_mem18      =  (save_edge_macb018 && save_edge_macb118 && save_edge_macb218 &&
                                save_edge_macb318 && save_edge_dma18 && save_edge_cpu18 && save_edge_smc18 && save_edge_urt18);

  assign restore_edge_mem18   =  (restore_edge_macb018 && restore_edge_macb118 && restore_edge_macb218  &&
                                restore_edge_macb318 && restore_edge_dma18 && restore_edge_cpu18 && restore_edge_urt18 &&
                                restore_edge_smc18);

  assign standby_mem018 = pwr1_off_macb018 && (~ (pwr1_off_macb018 && pwr1_off_macb118 && pwr1_off_macb218 && pwr1_off_macb318 && pwr1_off_urt18 && pwr1_off_smc18 && pwr1_off_dma18 && pwr1_off_cpu18));
  assign standby_mem118 = pwr1_off_macb118 && (~ (pwr1_off_macb018 && pwr1_off_macb118 && pwr1_off_macb218 && pwr1_off_macb318 && pwr1_off_urt18 && pwr1_off_smc18 && pwr1_off_dma18 && pwr1_off_cpu18));
  assign standby_mem218 = pwr1_off_macb218 && (~ (pwr1_off_macb018 && pwr1_off_macb118 && pwr1_off_macb218 && pwr1_off_macb318 && pwr1_off_urt18 && pwr1_off_smc18 && pwr1_off_dma18 && pwr1_off_cpu18));
  assign standby_mem318 = pwr1_off_macb318 && (~ (pwr1_off_macb018 && pwr1_off_macb118 && pwr1_off_macb218 && pwr1_off_macb318 && pwr1_off_urt18 && pwr1_off_smc18 && pwr1_off_dma18 && pwr1_off_cpu18));

  assign pwr1_off_mem018 = pwr1_off_mem18;
  assign pwr1_off_mem118 = pwr1_off_mem18;
  assign pwr1_off_mem218 = pwr1_off_mem18;
  assign pwr1_off_mem318 = pwr1_off_mem18;

  assign rstn_non_srpg_alut18  =  (rstn_non_srpg_macb018 && rstn_non_srpg_macb118 && rstn_non_srpg_macb218 && rstn_non_srpg_macb318);


   assign gate_clk_alut18       =  (gate_clk_macb018 && gate_clk_macb118 && gate_clk_macb218 && gate_clk_macb318);


    assign isolate_alut18        =  (isolate_macb018 && isolate_macb118 && isolate_macb218 && isolate_macb318);


    assign pwr1_on_alut18        =  (pwr1_on_macb018 || pwr1_on_macb118 || pwr1_on_macb218 || pwr1_on_macb318);


    assign pwr2_on_alut18        =  (pwr2_on_macb018 || pwr2_on_macb118 || pwr2_on_macb218 || pwr2_on_macb318);


    assign pwr1_off_alut18       =  (pwr1_off_macb018 && pwr1_off_macb118 && pwr1_off_macb218 && pwr1_off_macb318);


    assign pwr2_off_alut18       =  (pwr2_off_macb018 && pwr2_off_macb118 && pwr2_off_macb218 && pwr2_off_macb318);


    assign save_edge_alut18      =  (save_edge_macb018 && save_edge_macb118 && save_edge_macb218 && save_edge_macb318);


    assign restore_edge_alut18   =  (restore_edge_macb018 || restore_edge_macb118 || restore_edge_macb218 ||
                                   restore_edge_macb318) && save_alut_tmp18;

     // alut18 power18 off18 detection18
  always @(posedge pclk18 or negedge nprst18) begin
    if (!nprst18) 
       save_alut_tmp18 <= 0;
    else if (restore_edge_alut18)
       save_alut_tmp18 <= 0;
    else if (save_edge_alut18)
       save_alut_tmp18 <= 1;
  end

  //DMA18
  assign rstn_non_srpg_dma18 = (scan_mode18 == 1'b0) ?  rstn_non_srpg_dma_int18 : 1'b1;  
  assign gate_clk_dma18       = (scan_mode18 == 1'b0) ?  gate_clk_dma_int18      : 1'b0;     
  assign isolate_dma18        = (scan_mode18 == 1'b0) ?  isolate_dma_int18       : 1'b0;      
  assign pwr1_on_dma18        = (scan_mode18 == 1'b0) ?  pwr1_on_dma_int18       : 1'b1;       
  assign pwr2_on_dma18        = (scan_mode18 == 1'b0) ?  pwr2_on_dma_int18       : 1'b1;       
  assign pwr1_off_dma18       = (scan_mode18 == 1'b0) ?  (!pwr1_on_dma_int18)  : 1'b0;       
  assign pwr2_off_dma18       = (scan_mode18 == 1'b0) ?  (!pwr2_on_dma_int18)  : 1'b0;       
  assign save_edge_dma18       = (scan_mode18 == 1'b0) ? (save_edge_dma_int18) : 1'b0;       
  assign restore_edge_dma18       = (scan_mode18 == 1'b0) ? (restore_edge_dma_int18) : 1'b0;       

  //CPU18
  assign rstn_non_srpg_cpu18 = (scan_mode18 == 1'b0) ?  rstn_non_srpg_cpu_int18 : 1'b1;  
  assign gate_clk_cpu18       = (scan_mode18 == 1'b0) ?  gate_clk_cpu_int18      : 1'b0;     
  assign isolate_cpu18        = (scan_mode18 == 1'b0) ?  isolate_cpu_int18       : 1'b0;      
  assign pwr1_on_cpu18        = (scan_mode18 == 1'b0) ?  pwr1_on_cpu_int18       : 1'b1;       
  assign pwr2_on_cpu18        = (scan_mode18 == 1'b0) ?  pwr2_on_cpu_int18       : 1'b1;       
  assign pwr1_off_cpu18       = (scan_mode18 == 1'b0) ?  (!pwr1_on_cpu_int18)  : 1'b0;       
  assign pwr2_off_cpu18       = (scan_mode18 == 1'b0) ?  (!pwr2_on_cpu_int18)  : 1'b0;       
  assign save_edge_cpu18       = (scan_mode18 == 1'b0) ? (save_edge_cpu_int18) : 1'b0;       
  assign restore_edge_cpu18       = (scan_mode18 == 1'b0) ? (restore_edge_cpu_int18) : 1'b0;       



  // ASE18

   reg ase_core_12v18, ase_core_10v18, ase_core_08v18, ase_core_06v18;
   reg ase_macb0_12v18,ase_macb1_12v18,ase_macb2_12v18,ase_macb3_12v18;

    // core18 ase18

    // core18 at 1.0 v if (smc18 off18, urt18 off18, macb018 off18, macb118 off18, macb218 off18, macb318 off18
   // core18 at 0.8v if (mac01off18, macb02off18, macb03off18, macb12off18, mac13off18, mac23off18,
   // core18 at 0.6v if (mac012off18, mac013off18, mac023off18, mac123off18, mac0123off18
    // else core18 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb018 && pwr1_off_macb118 && pwr1_off_macb218 && pwr1_off_macb318) || // all mac18 off18
       (pwr1_off_macb318 && pwr1_off_macb218 && pwr1_off_macb118) || // mac123off18 
       (pwr1_off_macb318 && pwr1_off_macb218 && pwr1_off_macb018) || // mac023off18 
       (pwr1_off_macb318 && pwr1_off_macb118 && pwr1_off_macb018) || // mac013off18 
       (pwr1_off_macb218 && pwr1_off_macb118 && pwr1_off_macb018) )  // mac012off18 
       begin
         ase_core_12v18 = 0;
         ase_core_10v18 = 0;
         ase_core_08v18 = 0;
         ase_core_06v18 = 1;
       end
     else if( (pwr1_off_macb218 && pwr1_off_macb318) || // mac2318 off18
         (pwr1_off_macb318 && pwr1_off_macb118) || // mac13off18 
         (pwr1_off_macb118 && pwr1_off_macb218) || // mac12off18 
         (pwr1_off_macb318 && pwr1_off_macb018) || // mac03off18 
         (pwr1_off_macb218 && pwr1_off_macb018) || // mac02off18 
         (pwr1_off_macb118 && pwr1_off_macb018))  // mac01off18 
       begin
         ase_core_12v18 = 0;
         ase_core_10v18 = 0;
         ase_core_08v18 = 1;
         ase_core_06v18 = 0;
       end
     else if( (pwr1_off_smc18) || // smc18 off18
         (pwr1_off_macb018 ) || // mac0off18 
         (pwr1_off_macb118 ) || // mac1off18 
         (pwr1_off_macb218 ) || // mac2off18 
         (pwr1_off_macb318 ))  // mac3off18 
       begin
         ase_core_12v18 = 0;
         ase_core_10v18 = 1;
         ase_core_08v18 = 0;
         ase_core_06v18 = 0;
       end
     else if (pwr1_off_urt18)
       begin
         ase_core_12v18 = 1;
         ase_core_10v18 = 0;
         ase_core_08v18 = 0;
         ase_core_06v18 = 0;
       end
     else
       begin
         ase_core_12v18 = 1;
         ase_core_10v18 = 0;
         ase_core_08v18 = 0;
         ase_core_06v18 = 0;
       end
   end


   // cpu18
   // cpu18 @ 1.0v when macoff18, 
   // 
   reg ase_cpu_10v18, ase_cpu_12v18;
   always @(*) begin
    if(pwr1_off_cpu18) begin
     ase_cpu_12v18 = 1'b0;
     ase_cpu_10v18 = 1'b0;
    end
    else if(pwr1_off_macb018 || pwr1_off_macb118 || pwr1_off_macb218 || pwr1_off_macb318)
    begin
     ase_cpu_12v18 = 1'b0;
     ase_cpu_10v18 = 1'b1;
    end
    else
    begin
     ase_cpu_12v18 = 1'b1;
     ase_cpu_10v18 = 1'b0;
    end
   end

   // dma18
   // dma18 @v118.0 for macoff18, 

   reg ase_dma_10v18, ase_dma_12v18;
   always @(*) begin
    if(pwr1_off_dma18) begin
     ase_dma_12v18 = 1'b0;
     ase_dma_10v18 = 1'b0;
    end
    else if(pwr1_off_macb018 || pwr1_off_macb118 || pwr1_off_macb218 || pwr1_off_macb318)
    begin
     ase_dma_12v18 = 1'b0;
     ase_dma_10v18 = 1'b1;
    end
    else
    begin
     ase_dma_12v18 = 1'b1;
     ase_dma_10v18 = 1'b0;
    end
   end

   // alut18
   // @ v118.0 for macoff18

   reg ase_alut_10v18, ase_alut_12v18;
   always @(*) begin
    if(pwr1_off_alut18) begin
     ase_alut_12v18 = 1'b0;
     ase_alut_10v18 = 1'b0;
    end
    else if(pwr1_off_macb018 || pwr1_off_macb118 || pwr1_off_macb218 || pwr1_off_macb318)
    begin
     ase_alut_12v18 = 1'b0;
     ase_alut_10v18 = 1'b1;
    end
    else
    begin
     ase_alut_12v18 = 1'b1;
     ase_alut_10v18 = 1'b0;
    end
   end




   reg ase_uart_12v18;
   reg ase_uart_10v18;
   reg ase_uart_08v18;
   reg ase_uart_06v18;

   reg ase_smc_12v18;


   always @(*) begin
     if(pwr1_off_urt18) begin // uart18 off18
       ase_uart_08v18 = 1'b0;
       ase_uart_06v18 = 1'b0;
       ase_uart_10v18 = 1'b0;
       ase_uart_12v18 = 1'b0;
     end 
     else if( (pwr1_off_macb018 && pwr1_off_macb118 && pwr1_off_macb218 && pwr1_off_macb318) || // all mac18 off18
       (pwr1_off_macb318 && pwr1_off_macb218 && pwr1_off_macb118) || // mac123off18 
       (pwr1_off_macb318 && pwr1_off_macb218 && pwr1_off_macb018) || // mac023off18 
       (pwr1_off_macb318 && pwr1_off_macb118 && pwr1_off_macb018) || // mac013off18 
       (pwr1_off_macb218 && pwr1_off_macb118 && pwr1_off_macb018) )  // mac012off18 
     begin
       ase_uart_06v18 = 1'b1;
       ase_uart_08v18 = 1'b0;
       ase_uart_10v18 = 1'b0;
       ase_uart_12v18 = 1'b0;
     end
     else if( (pwr1_off_macb218 && pwr1_off_macb318) || // mac2318 off18
         (pwr1_off_macb318 && pwr1_off_macb118) || // mac13off18 
         (pwr1_off_macb118 && pwr1_off_macb218) || // mac12off18 
         (pwr1_off_macb318 && pwr1_off_macb018) || // mac03off18 
         (pwr1_off_macb118 && pwr1_off_macb018))  // mac01off18  
     begin
       ase_uart_06v18 = 1'b0;
       ase_uart_08v18 = 1'b1;
       ase_uart_10v18 = 1'b0;
       ase_uart_12v18 = 1'b0;
     end
     else if (pwr1_off_smc18 || pwr1_off_macb018 || pwr1_off_macb118 || pwr1_off_macb218 || pwr1_off_macb318) begin // smc18 off18
       ase_uart_08v18 = 1'b0;
       ase_uart_06v18 = 1'b0;
       ase_uart_10v18 = 1'b1;
       ase_uart_12v18 = 1'b0;
     end 
     else begin
       ase_uart_08v18 = 1'b0;
       ase_uart_06v18 = 1'b0;
       ase_uart_10v18 = 1'b0;
       ase_uart_12v18 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc18) begin
     if (pwr1_off_smc18)  // smc18 off18
       ase_smc_12v18 = 1'b0;
    else
       ase_smc_12v18 = 1'b1;
   end

   
   always @(pwr1_off_macb018) begin
     if (pwr1_off_macb018) // macb018 off18
       ase_macb0_12v18 = 1'b0;
     else
       ase_macb0_12v18 = 1'b1;
   end

   always @(pwr1_off_macb118) begin
     if (pwr1_off_macb118) // macb118 off18
       ase_macb1_12v18 = 1'b0;
     else
       ase_macb1_12v18 = 1'b1;
   end

   always @(pwr1_off_macb218) begin // macb218 off18
     if (pwr1_off_macb218) // macb218 off18
       ase_macb2_12v18 = 1'b0;
     else
       ase_macb2_12v18 = 1'b1;
   end

   always @(pwr1_off_macb318) begin // macb318 off18
     if (pwr1_off_macb318) // macb318 off18
       ase_macb3_12v18 = 1'b0;
     else
       ase_macb3_12v18 = 1'b1;
   end


   // core18 voltage18 for vco18
  assign core12v18 = ase_macb0_12v18 & ase_macb1_12v18 & ase_macb2_12v18 & ase_macb3_12v18;

  assign core10v18 =  (ase_macb0_12v18 & ase_macb1_12v18 & ase_macb2_12v18 & (!ase_macb3_12v18)) ||
                    (ase_macb0_12v18 & ase_macb1_12v18 & (!ase_macb2_12v18) & ase_macb3_12v18) ||
                    (ase_macb0_12v18 & (!ase_macb1_12v18) & ase_macb2_12v18 & ase_macb3_12v18) ||
                    ((!ase_macb0_12v18) & ase_macb1_12v18 & ase_macb2_12v18 & ase_macb3_12v18);

  assign core08v18 =  ((!ase_macb0_12v18) & (!ase_macb1_12v18) & (ase_macb2_12v18) & (ase_macb3_12v18)) ||
                    ((!ase_macb0_12v18) & (ase_macb1_12v18) & (!ase_macb2_12v18) & (ase_macb3_12v18)) ||
                    ((!ase_macb0_12v18) & (ase_macb1_12v18) & (ase_macb2_12v18) & (!ase_macb3_12v18)) ||
                    ((ase_macb0_12v18) & (!ase_macb1_12v18) & (!ase_macb2_12v18) & (ase_macb3_12v18)) ||
                    ((ase_macb0_12v18) & (!ase_macb1_12v18) & (ase_macb2_12v18) & (!ase_macb3_12v18)) ||
                    ((ase_macb0_12v18) & (ase_macb1_12v18) & (!ase_macb2_12v18) & (!ase_macb3_12v18));

  assign core06v18 =  ((!ase_macb0_12v18) & (!ase_macb1_12v18) & (!ase_macb2_12v18) & (ase_macb3_12v18)) ||
                    ((!ase_macb0_12v18) & (!ase_macb1_12v18) & (ase_macb2_12v18) & (!ase_macb3_12v18)) ||
                    ((!ase_macb0_12v18) & (ase_macb1_12v18) & (!ase_macb2_12v18) & (!ase_macb3_12v18)) ||
                    ((ase_macb0_12v18) & (!ase_macb1_12v18) & (!ase_macb2_12v18) & (!ase_macb3_12v18)) ||
                    ((!ase_macb0_12v18) & (!ase_macb1_12v18) & (!ase_macb2_12v18) & (!ase_macb3_12v18)) ;



`ifdef LP_ABV_ON18
// psl18 default clock18 = (posedge pclk18);

// Cover18 a condition in which SMC18 is powered18 down
// and again18 powered18 up while UART18 is going18 into POWER18 down
// state or UART18 is already in POWER18 DOWN18 state
// psl18 cover_overlapping_smc_urt_118:
//    cover{fell18(pwr1_on_urt18);[*];fell18(pwr1_on_smc18);[*];
//    rose18(pwr1_on_smc18);[*];rose18(pwr1_on_urt18)};
//
// Cover18 a condition in which UART18 is powered18 down
// and again18 powered18 up while SMC18 is going18 into POWER18 down
// state or SMC18 is already in POWER18 DOWN18 state
// psl18 cover_overlapping_smc_urt_218:
//    cover{fell18(pwr1_on_smc18);[*];fell18(pwr1_on_urt18);[*];
//    rose18(pwr1_on_urt18);[*];rose18(pwr1_on_smc18)};
//


// Power18 Down18 UART18
// This18 gets18 triggered on rising18 edge of Gate18 signal18 for
// UART18 (gate_clk_urt18). In a next cycle after gate_clk_urt18,
// Isolate18 UART18(isolate_urt18) signal18 become18 HIGH18 (active).
// In 2nd cycle after gate_clk_urt18 becomes HIGH18, RESET18 for NON18
// SRPG18 FFs18(rstn_non_srpg_urt18) and POWER118 for UART18(pwr1_on_urt18) should 
// go18 LOW18. 
// This18 completes18 a POWER18 DOWN18. 

sequence s_power_down_urt18;
      (gate_clk_urt18 & !isolate_urt18 & rstn_non_srpg_urt18 & pwr1_on_urt18) 
  ##1 (gate_clk_urt18 & isolate_urt18 & rstn_non_srpg_urt18 & pwr1_on_urt18) 
  ##3 (gate_clk_urt18 & isolate_urt18 & !rstn_non_srpg_urt18 & !pwr1_on_urt18);
endsequence


property p_power_down_urt18;
   @(posedge pclk18)
    $rose(gate_clk_urt18) |=> s_power_down_urt18;
endproperty

output_power_down_urt18:
  assert property (p_power_down_urt18);


// Power18 UP18 UART18
// Sequence starts with , Rising18 edge of pwr1_on_urt18.
// Two18 clock18 cycle after this, isolate_urt18 should become18 LOW18 
// On18 the following18 clk18 gate_clk_urt18 should go18 low18.
// 5 cycles18 after  Rising18 edge of pwr1_on_urt18, rstn_non_srpg_urt18
// should become18 HIGH18
sequence s_power_up_urt18;
##30 (pwr1_on_urt18 & !isolate_urt18 & gate_clk_urt18 & !rstn_non_srpg_urt18) 
##1 (pwr1_on_urt18 & !isolate_urt18 & !gate_clk_urt18 & !rstn_non_srpg_urt18) 
##2 (pwr1_on_urt18 & !isolate_urt18 & !gate_clk_urt18 & rstn_non_srpg_urt18);
endsequence

property p_power_up_urt18;
   @(posedge pclk18)
  disable iff(!nprst18)
    (!pwr1_on_urt18 ##1 pwr1_on_urt18) |=> s_power_up_urt18;
endproperty

output_power_up_urt18:
  assert property (p_power_up_urt18);


// Power18 Down18 SMC18
// This18 gets18 triggered on rising18 edge of Gate18 signal18 for
// SMC18 (gate_clk_smc18). In a next cycle after gate_clk_smc18,
// Isolate18 SMC18(isolate_smc18) signal18 become18 HIGH18 (active).
// In 2nd cycle after gate_clk_smc18 becomes HIGH18, RESET18 for NON18
// SRPG18 FFs18(rstn_non_srpg_smc18) and POWER118 for SMC18(pwr1_on_smc18) should 
// go18 LOW18. 
// This18 completes18 a POWER18 DOWN18. 

sequence s_power_down_smc18;
      (gate_clk_smc18 & !isolate_smc18 & rstn_non_srpg_smc18 & pwr1_on_smc18) 
  ##1 (gate_clk_smc18 & isolate_smc18 & rstn_non_srpg_smc18 & pwr1_on_smc18) 
  ##3 (gate_clk_smc18 & isolate_smc18 & !rstn_non_srpg_smc18 & !pwr1_on_smc18);
endsequence


property p_power_down_smc18;
   @(posedge pclk18)
    $rose(gate_clk_smc18) |=> s_power_down_smc18;
endproperty

output_power_down_smc18:
  assert property (p_power_down_smc18);


// Power18 UP18 SMC18
// Sequence starts with , Rising18 edge of pwr1_on_smc18.
// Two18 clock18 cycle after this, isolate_smc18 should become18 LOW18 
// On18 the following18 clk18 gate_clk_smc18 should go18 low18.
// 5 cycles18 after  Rising18 edge of pwr1_on_smc18, rstn_non_srpg_smc18
// should become18 HIGH18
sequence s_power_up_smc18;
##30 (pwr1_on_smc18 & !isolate_smc18 & gate_clk_smc18 & !rstn_non_srpg_smc18) 
##1 (pwr1_on_smc18 & !isolate_smc18 & !gate_clk_smc18 & !rstn_non_srpg_smc18) 
##2 (pwr1_on_smc18 & !isolate_smc18 & !gate_clk_smc18 & rstn_non_srpg_smc18);
endsequence

property p_power_up_smc18;
   @(posedge pclk18)
  disable iff(!nprst18)
    (!pwr1_on_smc18 ##1 pwr1_on_smc18) |=> s_power_up_smc18;
endproperty

output_power_up_smc18:
  assert property (p_power_up_smc18);


// COVER18 SMC18 POWER18 DOWN18 AND18 UP18
cover_power_down_up_smc18: cover property (@(posedge pclk18)
(s_power_down_smc18 ##[5:180] s_power_up_smc18));



// COVER18 UART18 POWER18 DOWN18 AND18 UP18
cover_power_down_up_urt18: cover property (@(posedge pclk18)
(s_power_down_urt18 ##[5:180] s_power_up_urt18));

cover_power_down_urt18: cover property (@(posedge pclk18)
(s_power_down_urt18));

cover_power_up_urt18: cover property (@(posedge pclk18)
(s_power_up_urt18));




`ifdef PCM_ABV_ON18
//------------------------------------------------------------------------------
// Power18 Controller18 Formal18 Verification18 component.  Each power18 domain has a 
// separate18 instantiation18
//------------------------------------------------------------------------------

// need to assume that CPU18 will leave18 a minimum time between powering18 down and 
// back up.  In this example18, 10clks has been selected.
// psl18 config_min_uart_pd_time18 : assume always {rose18(L1_ctrl_domain18[1])} |-> { L1_ctrl_domain18[1][*10] } abort18(~nprst18);
// psl18 config_min_uart_pu_time18 : assume always {fell18(L1_ctrl_domain18[1])} |-> { !L1_ctrl_domain18[1][*10] } abort18(~nprst18);
// psl18 config_min_smc_pd_time18 : assume always {rose18(L1_ctrl_domain18[2])} |-> { L1_ctrl_domain18[2][*10] } abort18(~nprst18);
// psl18 config_min_smc_pu_time18 : assume always {fell18(L1_ctrl_domain18[2])} |-> { !L1_ctrl_domain18[2][*10] } abort18(~nprst18);

// UART18 VCOMP18 parameters18
   defparam i_uart_vcomp_domain18.ENABLE_SAVE_RESTORE_EDGE18   = 1;
   defparam i_uart_vcomp_domain18.ENABLE_EXT_PWR_CNTRL18       = 1;
   defparam i_uart_vcomp_domain18.REF_CLK_DEFINED18            = 0;
   defparam i_uart_vcomp_domain18.MIN_SHUTOFF_CYCLES18         = 4;
   defparam i_uart_vcomp_domain18.MIN_RESTORE_TO_ISO_CYCLES18  = 0;
   defparam i_uart_vcomp_domain18.MIN_SAVE_TO_SHUTOFF_CYCLES18 = 1;


   vcomp_domain18 i_uart_vcomp_domain18
   ( .ref_clk18(pclk18),
     .start_lps18(L1_ctrl_domain18[1] || !rstn_non_srpg_urt18),
     .rst_n18(nprst18),
     .ext_power_down18(L1_ctrl_domain18[1]),
     .iso_en18(isolate_urt18),
     .save_edge18(save_edge_urt18),
     .restore_edge18(restore_edge_urt18),
     .domain_shut_off18(pwr1_off_urt18),
     .domain_clk18(!gate_clk_urt18 && pclk18)
   );


// SMC18 VCOMP18 parameters18
   defparam i_smc_vcomp_domain18.ENABLE_SAVE_RESTORE_EDGE18   = 1;
   defparam i_smc_vcomp_domain18.ENABLE_EXT_PWR_CNTRL18       = 1;
   defparam i_smc_vcomp_domain18.REF_CLK_DEFINED18            = 0;
   defparam i_smc_vcomp_domain18.MIN_SHUTOFF_CYCLES18         = 4;
   defparam i_smc_vcomp_domain18.MIN_RESTORE_TO_ISO_CYCLES18  = 0;
   defparam i_smc_vcomp_domain18.MIN_SAVE_TO_SHUTOFF_CYCLES18 = 1;


   vcomp_domain18 i_smc_vcomp_domain18
   ( .ref_clk18(pclk18),
     .start_lps18(L1_ctrl_domain18[2] || !rstn_non_srpg_smc18),
     .rst_n18(nprst18),
     .ext_power_down18(L1_ctrl_domain18[2]),
     .iso_en18(isolate_smc18),
     .save_edge18(save_edge_smc18),
     .restore_edge18(restore_edge_smc18),
     .domain_shut_off18(pwr1_off_smc18),
     .domain_clk18(!gate_clk_smc18 && pclk18)
   );

`endif

`endif



endmodule
