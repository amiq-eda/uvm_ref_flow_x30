//File21 name   : power_ctrl21.v
//Title21       : Power21 Control21 Module21
//Created21     : 1999
//Description21 : Top21 level of power21 controller21
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

module power_ctrl21 (


    // Clocks21 & Reset21
    pclk21,
    nprst21,
    // APB21 programming21 interface
    paddr21,
    psel21,
    penable21,
    pwrite21,
    pwdata21,
    prdata21,
    // mac21 i/f,
    macb3_wakeup21,
    macb2_wakeup21,
    macb1_wakeup21,
    macb0_wakeup21,
    // Scan21 
    scan_in21,
    scan_en21,
    scan_mode21,
    scan_out21,
    // Module21 control21 outputs21
    int_source_h21,
    // SMC21
    rstn_non_srpg_smc21,
    gate_clk_smc21,
    isolate_smc21,
    save_edge_smc21,
    restore_edge_smc21,
    pwr1_on_smc21,
    pwr2_on_smc21,
    pwr1_off_smc21,
    pwr2_off_smc21,
    // URT21
    rstn_non_srpg_urt21,
    gate_clk_urt21,
    isolate_urt21,
    save_edge_urt21,
    restore_edge_urt21,
    pwr1_on_urt21,
    pwr2_on_urt21,
    pwr1_off_urt21,      
    pwr2_off_urt21,
    // ETH021
    rstn_non_srpg_macb021,
    gate_clk_macb021,
    isolate_macb021,
    save_edge_macb021,
    restore_edge_macb021,
    pwr1_on_macb021,
    pwr2_on_macb021,
    pwr1_off_macb021,      
    pwr2_off_macb021,
    // ETH121
    rstn_non_srpg_macb121,
    gate_clk_macb121,
    isolate_macb121,
    save_edge_macb121,
    restore_edge_macb121,
    pwr1_on_macb121,
    pwr2_on_macb121,
    pwr1_off_macb121,      
    pwr2_off_macb121,
    // ETH221
    rstn_non_srpg_macb221,
    gate_clk_macb221,
    isolate_macb221,
    save_edge_macb221,
    restore_edge_macb221,
    pwr1_on_macb221,
    pwr2_on_macb221,
    pwr1_off_macb221,      
    pwr2_off_macb221,
    // ETH321
    rstn_non_srpg_macb321,
    gate_clk_macb321,
    isolate_macb321,
    save_edge_macb321,
    restore_edge_macb321,
    pwr1_on_macb321,
    pwr2_on_macb321,
    pwr1_off_macb321,      
    pwr2_off_macb321,
    // DMA21
    rstn_non_srpg_dma21,
    gate_clk_dma21,
    isolate_dma21,
    save_edge_dma21,
    restore_edge_dma21,
    pwr1_on_dma21,
    pwr2_on_dma21,
    pwr1_off_dma21,      
    pwr2_off_dma21,
    // CPU21
    rstn_non_srpg_cpu21,
    gate_clk_cpu21,
    isolate_cpu21,
    save_edge_cpu21,
    restore_edge_cpu21,
    pwr1_on_cpu21,
    pwr2_on_cpu21,
    pwr1_off_cpu21,      
    pwr2_off_cpu21,
    // ALUT21
    rstn_non_srpg_alut21,
    gate_clk_alut21,
    isolate_alut21,
    save_edge_alut21,
    restore_edge_alut21,
    pwr1_on_alut21,
    pwr2_on_alut21,
    pwr1_off_alut21,      
    pwr2_off_alut21,
    // MEM21
    rstn_non_srpg_mem21,
    gate_clk_mem21,
    isolate_mem21,
    save_edge_mem21,
    restore_edge_mem21,
    pwr1_on_mem21,
    pwr2_on_mem21,
    pwr1_off_mem21,      
    pwr2_off_mem21,
    // core21 dvfs21 transitions21
    core06v21,
    core08v21,
    core10v21,
    core12v21,
    pcm_macb_wakeup_int21,
    // mte21 signals21
    mte_smc_start21,
    mte_uart_start21,
    mte_smc_uart_start21,  
    mte_pm_smc_to_default_start21, 
    mte_pm_uart_to_default_start21,
    mte_pm_smc_uart_to_default_start21

  );

  parameter STATE_IDLE_12V21 = 4'b0001;
  parameter STATE_06V21 = 4'b0010;
  parameter STATE_08V21 = 4'b0100;
  parameter STATE_10V21 = 4'b1000;

    // Clocks21 & Reset21
    input pclk21;
    input nprst21;
    // APB21 programming21 interface
    input [31:0] paddr21;
    input psel21  ;
    input penable21;
    input pwrite21 ;
    input [31:0] pwdata21;
    output [31:0] prdata21;
    // mac21
    input macb3_wakeup21;
    input macb2_wakeup21;
    input macb1_wakeup21;
    input macb0_wakeup21;
    // Scan21 
    input scan_in21;
    input scan_en21;
    input scan_mode21;
    output scan_out21;
    // Module21 control21 outputs21
    input int_source_h21;
    // SMC21
    output rstn_non_srpg_smc21 ;
    output gate_clk_smc21   ;
    output isolate_smc21   ;
    output save_edge_smc21   ;
    output restore_edge_smc21   ;
    output pwr1_on_smc21   ;
    output pwr2_on_smc21   ;
    output pwr1_off_smc21  ;
    output pwr2_off_smc21  ;
    // URT21
    output rstn_non_srpg_urt21 ;
    output gate_clk_urt21      ;
    output isolate_urt21       ;
    output save_edge_urt21   ;
    output restore_edge_urt21   ;
    output pwr1_on_urt21       ;
    output pwr2_on_urt21       ;
    output pwr1_off_urt21      ;
    output pwr2_off_urt21      ;
    // ETH021
    output rstn_non_srpg_macb021 ;
    output gate_clk_macb021      ;
    output isolate_macb021       ;
    output save_edge_macb021   ;
    output restore_edge_macb021   ;
    output pwr1_on_macb021       ;
    output pwr2_on_macb021       ;
    output pwr1_off_macb021      ;
    output pwr2_off_macb021      ;
    // ETH121
    output rstn_non_srpg_macb121 ;
    output gate_clk_macb121      ;
    output isolate_macb121       ;
    output save_edge_macb121   ;
    output restore_edge_macb121   ;
    output pwr1_on_macb121       ;
    output pwr2_on_macb121       ;
    output pwr1_off_macb121      ;
    output pwr2_off_macb121      ;
    // ETH221
    output rstn_non_srpg_macb221 ;
    output gate_clk_macb221      ;
    output isolate_macb221       ;
    output save_edge_macb221   ;
    output restore_edge_macb221   ;
    output pwr1_on_macb221       ;
    output pwr2_on_macb221       ;
    output pwr1_off_macb221      ;
    output pwr2_off_macb221      ;
    // ETH321
    output rstn_non_srpg_macb321 ;
    output gate_clk_macb321      ;
    output isolate_macb321       ;
    output save_edge_macb321   ;
    output restore_edge_macb321   ;
    output pwr1_on_macb321       ;
    output pwr2_on_macb321       ;
    output pwr1_off_macb321      ;
    output pwr2_off_macb321      ;
    // DMA21
    output rstn_non_srpg_dma21 ;
    output gate_clk_dma21      ;
    output isolate_dma21       ;
    output save_edge_dma21   ;
    output restore_edge_dma21   ;
    output pwr1_on_dma21       ;
    output pwr2_on_dma21       ;
    output pwr1_off_dma21      ;
    output pwr2_off_dma21      ;
    // CPU21
    output rstn_non_srpg_cpu21 ;
    output gate_clk_cpu21      ;
    output isolate_cpu21       ;
    output save_edge_cpu21   ;
    output restore_edge_cpu21   ;
    output pwr1_on_cpu21       ;
    output pwr2_on_cpu21       ;
    output pwr1_off_cpu21      ;
    output pwr2_off_cpu21      ;
    // ALUT21
    output rstn_non_srpg_alut21 ;
    output gate_clk_alut21      ;
    output isolate_alut21       ;
    output save_edge_alut21   ;
    output restore_edge_alut21   ;
    output pwr1_on_alut21       ;
    output pwr2_on_alut21       ;
    output pwr1_off_alut21      ;
    output pwr2_off_alut21      ;
    // MEM21
    output rstn_non_srpg_mem21 ;
    output gate_clk_mem21      ;
    output isolate_mem21       ;
    output save_edge_mem21   ;
    output restore_edge_mem21   ;
    output pwr1_on_mem21       ;
    output pwr2_on_mem21       ;
    output pwr1_off_mem21      ;
    output pwr2_off_mem21      ;


   // core21 transitions21 o/p
    output core06v21;
    output core08v21;
    output core10v21;
    output core12v21;
    output pcm_macb_wakeup_int21 ;
    //mode mte21  signals21
    output mte_smc_start21;
    output mte_uart_start21;
    output mte_smc_uart_start21;  
    output mte_pm_smc_to_default_start21; 
    output mte_pm_uart_to_default_start21;
    output mte_pm_smc_uart_to_default_start21;

    reg mte_smc_start21;
    reg mte_uart_start21;
    reg mte_smc_uart_start21;  
    reg mte_pm_smc_to_default_start21; 
    reg mte_pm_uart_to_default_start21;
    reg mte_pm_smc_uart_to_default_start21;

    reg [31:0] prdata21;

  wire valid_reg_write21  ;
  wire valid_reg_read21   ;
  wire L1_ctrl_access21   ;
  wire L1_status_access21 ;
  wire pcm_int_mask_access21;
  wire pcm_int_status_access21;
  wire standby_mem021      ;
  wire standby_mem121      ;
  wire standby_mem221      ;
  wire standby_mem321      ;
  wire pwr1_off_mem021;
  wire pwr1_off_mem121;
  wire pwr1_off_mem221;
  wire pwr1_off_mem321;
  
  // Control21 signals21
  wire set_status_smc21   ;
  wire clr_status_smc21   ;
  wire set_status_urt21   ;
  wire clr_status_urt21   ;
  wire set_status_macb021   ;
  wire clr_status_macb021   ;
  wire set_status_macb121   ;
  wire clr_status_macb121   ;
  wire set_status_macb221   ;
  wire clr_status_macb221   ;
  wire set_status_macb321   ;
  wire clr_status_macb321   ;
  wire set_status_dma21   ;
  wire clr_status_dma21   ;
  wire set_status_cpu21   ;
  wire clr_status_cpu21   ;
  wire set_status_alut21   ;
  wire clr_status_alut21   ;
  wire set_status_mem21   ;
  wire clr_status_mem21   ;


  // Status and Control21 registers
  reg [31:0]  L1_status_reg21;
  reg  [31:0] L1_ctrl_reg21  ;
  reg  [31:0] L1_ctrl_domain21  ;
  reg L1_ctrl_cpu_off_reg21;
  reg [31:0]  pcm_mask_reg21;
  reg [31:0]  pcm_status_reg21;

  // Signals21 gated21 in scan_mode21
  //SMC21
  wire  rstn_non_srpg_smc_int21;
  wire  gate_clk_smc_int21    ;     
  wire  isolate_smc_int21    ;       
  wire save_edge_smc_int21;
  wire restore_edge_smc_int21;
  wire  pwr1_on_smc_int21    ;      
  wire  pwr2_on_smc_int21    ;      


  //URT21
  wire   rstn_non_srpg_urt_int21;
  wire   gate_clk_urt_int21     ;     
  wire   isolate_urt_int21      ;       
  wire save_edge_urt_int21;
  wire restore_edge_urt_int21;
  wire   pwr1_on_urt_int21      ;      
  wire   pwr2_on_urt_int21      ;      

  // ETH021
  wire   rstn_non_srpg_macb0_int21;
  wire   gate_clk_macb0_int21     ;     
  wire   isolate_macb0_int21      ;       
  wire save_edge_macb0_int21;
  wire restore_edge_macb0_int21;
  wire   pwr1_on_macb0_int21      ;      
  wire   pwr2_on_macb0_int21      ;      
  // ETH121
  wire   rstn_non_srpg_macb1_int21;
  wire   gate_clk_macb1_int21     ;     
  wire   isolate_macb1_int21      ;       
  wire save_edge_macb1_int21;
  wire restore_edge_macb1_int21;
  wire   pwr1_on_macb1_int21      ;      
  wire   pwr2_on_macb1_int21      ;      
  // ETH221
  wire   rstn_non_srpg_macb2_int21;
  wire   gate_clk_macb2_int21     ;     
  wire   isolate_macb2_int21      ;       
  wire save_edge_macb2_int21;
  wire restore_edge_macb2_int21;
  wire   pwr1_on_macb2_int21      ;      
  wire   pwr2_on_macb2_int21      ;      
  // ETH321
  wire   rstn_non_srpg_macb3_int21;
  wire   gate_clk_macb3_int21     ;     
  wire   isolate_macb3_int21      ;       
  wire save_edge_macb3_int21;
  wire restore_edge_macb3_int21;
  wire   pwr1_on_macb3_int21      ;      
  wire   pwr2_on_macb3_int21      ;      

  // DMA21
  wire   rstn_non_srpg_dma_int21;
  wire   gate_clk_dma_int21     ;     
  wire   isolate_dma_int21      ;       
  wire save_edge_dma_int21;
  wire restore_edge_dma_int21;
  wire   pwr1_on_dma_int21      ;      
  wire   pwr2_on_dma_int21      ;      

  // CPU21
  wire   rstn_non_srpg_cpu_int21;
  wire   gate_clk_cpu_int21     ;     
  wire   isolate_cpu_int21      ;       
  wire save_edge_cpu_int21;
  wire restore_edge_cpu_int21;
  wire   pwr1_on_cpu_int21      ;      
  wire   pwr2_on_cpu_int21      ;  
  wire L1_ctrl_cpu_off_p21;    

  reg save_alut_tmp21;
  // DFS21 sm21

  reg cpu_shutoff_ctrl21;

  reg mte_mac_off_start21, mte_mac012_start21, mte_mac013_start21, mte_mac023_start21, mte_mac123_start21;
  reg mte_mac01_start21, mte_mac02_start21, mte_mac03_start21, mte_mac12_start21, mte_mac13_start21, mte_mac23_start21;
  reg mte_mac0_start21, mte_mac1_start21, mte_mac2_start21, mte_mac3_start21;
  reg mte_sys_hibernate21 ;
  reg mte_dma_start21 ;
  reg mte_cpu_start21 ;
  reg mte_mac_off_sleep_start21, mte_mac012_sleep_start21, mte_mac013_sleep_start21, mte_mac023_sleep_start21, mte_mac123_sleep_start21;
  reg mte_mac01_sleep_start21, mte_mac02_sleep_start21, mte_mac03_sleep_start21, mte_mac12_sleep_start21, mte_mac13_sleep_start21, mte_mac23_sleep_start21;
  reg mte_mac0_sleep_start21, mte_mac1_sleep_start21, mte_mac2_sleep_start21, mte_mac3_sleep_start21;
  reg mte_dma_sleep_start21;
  reg mte_mac_off_to_default21, mte_mac012_to_default21, mte_mac013_to_default21, mte_mac023_to_default21, mte_mac123_to_default21;
  reg mte_mac01_to_default21, mte_mac02_to_default21, mte_mac03_to_default21, mte_mac12_to_default21, mte_mac13_to_default21, mte_mac23_to_default21;
  reg mte_mac0_to_default21, mte_mac1_to_default21, mte_mac2_to_default21, mte_mac3_to_default21;
  reg mte_dma_isolate_dis21;
  reg mte_cpu_isolate_dis21;
  reg mte_sys_hibernate_to_default21;


  // Latch21 the CPU21 SLEEP21 invocation21
  always @( posedge pclk21 or negedge nprst21) 
  begin
    if(!nprst21)
      L1_ctrl_cpu_off_reg21 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg21 <= L1_ctrl_domain21[8];
  end

  // Create21 a pulse21 for sleep21 detection21 
  assign L1_ctrl_cpu_off_p21 =  L1_ctrl_domain21[8] && !L1_ctrl_cpu_off_reg21;
  
  // CPU21 sleep21 contol21 logic 
  // Shut21 off21 CPU21 when L1_ctrl_cpu_off_p21 is set
  // wake21 cpu21 when any interrupt21 is seen21  
  always @( posedge pclk21 or negedge nprst21) 
  begin
    if(!nprst21)
     cpu_shutoff_ctrl21 <= 1'b0;
    else if(cpu_shutoff_ctrl21 && int_source_h21)
     cpu_shutoff_ctrl21 <= 1'b0;
    else if (L1_ctrl_cpu_off_p21)
     cpu_shutoff_ctrl21 <= 1'b1;
  end
 
  // instantiate21 power21 contol21  block for uart21
  power_ctrl_sm21 i_urt_power_ctrl_sm21(
    .pclk21(pclk21),
    .nprst21(nprst21),
    .L1_module_req21(L1_ctrl_domain21[1]),
    .set_status_module21(set_status_urt21),
    .clr_status_module21(clr_status_urt21),
    .rstn_non_srpg_module21(rstn_non_srpg_urt_int21),
    .gate_clk_module21(gate_clk_urt_int21),
    .isolate_module21(isolate_urt_int21),
    .save_edge21(save_edge_urt_int21),
    .restore_edge21(restore_edge_urt_int21),
    .pwr1_on21(pwr1_on_urt_int21),
    .pwr2_on21(pwr2_on_urt_int21)
    );
  

  // instantiate21 power21 contol21  block for smc21
  power_ctrl_sm21 i_smc_power_ctrl_sm21(
    .pclk21(pclk21),
    .nprst21(nprst21),
    .L1_module_req21(L1_ctrl_domain21[2]),
    .set_status_module21(set_status_smc21),
    .clr_status_module21(clr_status_smc21),
    .rstn_non_srpg_module21(rstn_non_srpg_smc_int21),
    .gate_clk_module21(gate_clk_smc_int21),
    .isolate_module21(isolate_smc_int21),
    .save_edge21(save_edge_smc_int21),
    .restore_edge21(restore_edge_smc_int21),
    .pwr1_on21(pwr1_on_smc_int21),
    .pwr2_on21(pwr2_on_smc_int21)
    );

  // power21 control21 for macb021
  power_ctrl_sm21 i_macb0_power_ctrl_sm21(
    .pclk21(pclk21),
    .nprst21(nprst21),
    .L1_module_req21(L1_ctrl_domain21[3]),
    .set_status_module21(set_status_macb021),
    .clr_status_module21(clr_status_macb021),
    .rstn_non_srpg_module21(rstn_non_srpg_macb0_int21),
    .gate_clk_module21(gate_clk_macb0_int21),
    .isolate_module21(isolate_macb0_int21),
    .save_edge21(save_edge_macb0_int21),
    .restore_edge21(restore_edge_macb0_int21),
    .pwr1_on21(pwr1_on_macb0_int21),
    .pwr2_on21(pwr2_on_macb0_int21)
    );
  // power21 control21 for macb121
  power_ctrl_sm21 i_macb1_power_ctrl_sm21(
    .pclk21(pclk21),
    .nprst21(nprst21),
    .L1_module_req21(L1_ctrl_domain21[4]),
    .set_status_module21(set_status_macb121),
    .clr_status_module21(clr_status_macb121),
    .rstn_non_srpg_module21(rstn_non_srpg_macb1_int21),
    .gate_clk_module21(gate_clk_macb1_int21),
    .isolate_module21(isolate_macb1_int21),
    .save_edge21(save_edge_macb1_int21),
    .restore_edge21(restore_edge_macb1_int21),
    .pwr1_on21(pwr1_on_macb1_int21),
    .pwr2_on21(pwr2_on_macb1_int21)
    );
  // power21 control21 for macb221
  power_ctrl_sm21 i_macb2_power_ctrl_sm21(
    .pclk21(pclk21),
    .nprst21(nprst21),
    .L1_module_req21(L1_ctrl_domain21[5]),
    .set_status_module21(set_status_macb221),
    .clr_status_module21(clr_status_macb221),
    .rstn_non_srpg_module21(rstn_non_srpg_macb2_int21),
    .gate_clk_module21(gate_clk_macb2_int21),
    .isolate_module21(isolate_macb2_int21),
    .save_edge21(save_edge_macb2_int21),
    .restore_edge21(restore_edge_macb2_int21),
    .pwr1_on21(pwr1_on_macb2_int21),
    .pwr2_on21(pwr2_on_macb2_int21)
    );
  // power21 control21 for macb321
  power_ctrl_sm21 i_macb3_power_ctrl_sm21(
    .pclk21(pclk21),
    .nprst21(nprst21),
    .L1_module_req21(L1_ctrl_domain21[6]),
    .set_status_module21(set_status_macb321),
    .clr_status_module21(clr_status_macb321),
    .rstn_non_srpg_module21(rstn_non_srpg_macb3_int21),
    .gate_clk_module21(gate_clk_macb3_int21),
    .isolate_module21(isolate_macb3_int21),
    .save_edge21(save_edge_macb3_int21),
    .restore_edge21(restore_edge_macb3_int21),
    .pwr1_on21(pwr1_on_macb3_int21),
    .pwr2_on21(pwr2_on_macb3_int21)
    );
  // power21 control21 for dma21
  power_ctrl_sm21 i_dma_power_ctrl_sm21(
    .pclk21(pclk21),
    .nprst21(nprst21),
    .L1_module_req21(L1_ctrl_domain21[7]),
    .set_status_module21(set_status_dma21),
    .clr_status_module21(clr_status_dma21),
    .rstn_non_srpg_module21(rstn_non_srpg_dma_int21),
    .gate_clk_module21(gate_clk_dma_int21),
    .isolate_module21(isolate_dma_int21),
    .save_edge21(save_edge_dma_int21),
    .restore_edge21(restore_edge_dma_int21),
    .pwr1_on21(pwr1_on_dma_int21),
    .pwr2_on21(pwr2_on_dma_int21)
    );
  // power21 control21 for CPU21
  power_ctrl_sm21 i_cpu_power_ctrl_sm21(
    .pclk21(pclk21),
    .nprst21(nprst21),
    .L1_module_req21(cpu_shutoff_ctrl21),
    .set_status_module21(set_status_cpu21),
    .clr_status_module21(clr_status_cpu21),
    .rstn_non_srpg_module21(rstn_non_srpg_cpu_int21),
    .gate_clk_module21(gate_clk_cpu_int21),
    .isolate_module21(isolate_cpu_int21),
    .save_edge21(save_edge_cpu_int21),
    .restore_edge21(restore_edge_cpu_int21),
    .pwr1_on21(pwr1_on_cpu_int21),
    .pwr2_on21(pwr2_on_cpu_int21)
    );

  assign valid_reg_write21 =  (psel21 && pwrite21 && penable21);
  assign valid_reg_read21  =  (psel21 && (!pwrite21) && penable21);

  assign L1_ctrl_access21  =  (paddr21[15:0] == 16'b0000000000000100); 
  assign L1_status_access21 = (paddr21[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access21 =   (paddr21[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access21 = (paddr21[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control21 and status register
  always @(*)
  begin  
    if(valid_reg_read21 && L1_ctrl_access21) 
      prdata21 = L1_ctrl_reg21;
    else if (valid_reg_read21 && L1_status_access21)
      prdata21 = L1_status_reg21;
    else if (valid_reg_read21 && pcm_int_mask_access21)
      prdata21 = pcm_mask_reg21;
    else if (valid_reg_read21 && pcm_int_status_access21)
      prdata21 = pcm_status_reg21;
    else 
      prdata21 = 0;
  end

  assign set_status_mem21 =  (set_status_macb021 && set_status_macb121 && set_status_macb221 &&
                            set_status_macb321 && set_status_dma21 && set_status_cpu21);

  assign clr_status_mem21 =  (clr_status_macb021 && clr_status_macb121 && clr_status_macb221 &&
                            clr_status_macb321 && clr_status_dma21 && clr_status_cpu21);

  assign set_status_alut21 = (set_status_macb021 && set_status_macb121 && set_status_macb221 && set_status_macb321);

  assign clr_status_alut21 = (clr_status_macb021 || clr_status_macb121 || clr_status_macb221  || clr_status_macb321);

  // Write accesses to the control21 and status register
 
  always @(posedge pclk21 or negedge nprst21)
  begin
    if (!nprst21) begin
      L1_ctrl_reg21   <= 0;
      L1_status_reg21 <= 0;
      pcm_mask_reg21 <= 0;
    end else begin
      // CTRL21 reg updates21
      if (valid_reg_write21 && L1_ctrl_access21) 
        L1_ctrl_reg21 <= pwdata21; // Writes21 to the ctrl21 reg
      if (valid_reg_write21 && pcm_int_mask_access21) 
        pcm_mask_reg21 <= pwdata21; // Writes21 to the ctrl21 reg

      if (set_status_urt21 == 1'b1)  
        L1_status_reg21[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt21 == 1'b1) 
        L1_status_reg21[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc21 == 1'b1) 
        L1_status_reg21[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc21 == 1'b1) 
        L1_status_reg21[2] <= 1'b0; // Clear the status bit

      if (set_status_macb021 == 1'b1)  
        L1_status_reg21[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb021 == 1'b1) 
        L1_status_reg21[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb121 == 1'b1)  
        L1_status_reg21[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb121 == 1'b1) 
        L1_status_reg21[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb221 == 1'b1)  
        L1_status_reg21[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb221 == 1'b1) 
        L1_status_reg21[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb321 == 1'b1)  
        L1_status_reg21[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb321 == 1'b1) 
        L1_status_reg21[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma21 == 1'b1)  
        L1_status_reg21[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma21 == 1'b1) 
        L1_status_reg21[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu21 == 1'b1)  
        L1_status_reg21[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu21 == 1'b1) 
        L1_status_reg21[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut21 == 1'b1)  
        L1_status_reg21[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut21 == 1'b1) 
        L1_status_reg21[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem21 == 1'b1)  
        L1_status_reg21[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem21 == 1'b1) 
        L1_status_reg21[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused21 bits of pcm_status_reg21 are tied21 to 0
  always @(posedge pclk21 or negedge nprst21)
  begin
    if (!nprst21)
      pcm_status_reg21[31:4] <= 'b0;
    else  
      pcm_status_reg21[31:4] <= pcm_status_reg21[31:4];
  end
  
  // interrupt21 only of h/w assisted21 wakeup
  // MAC21 3
  always @(posedge pclk21 or negedge nprst21)
  begin
    if(!nprst21)
      pcm_status_reg21[3] <= 1'b0;
    else if (valid_reg_write21 && pcm_int_status_access21) 
      pcm_status_reg21[3] <= pwdata21[3];
    else if (macb3_wakeup21 & ~pcm_mask_reg21[3])
      pcm_status_reg21[3] <= 1'b1;
    else if (valid_reg_read21 && pcm_int_status_access21) 
      pcm_status_reg21[3] <= 1'b0;
    else
      pcm_status_reg21[3] <= pcm_status_reg21[3];
  end  
   
  // MAC21 2
  always @(posedge pclk21 or negedge nprst21)
  begin
    if(!nprst21)
      pcm_status_reg21[2] <= 1'b0;
    else if (valid_reg_write21 && pcm_int_status_access21) 
      pcm_status_reg21[2] <= pwdata21[2];
    else if (macb2_wakeup21 & ~pcm_mask_reg21[2])
      pcm_status_reg21[2] <= 1'b1;
    else if (valid_reg_read21 && pcm_int_status_access21) 
      pcm_status_reg21[2] <= 1'b0;
    else
      pcm_status_reg21[2] <= pcm_status_reg21[2];
  end  

  // MAC21 1
  always @(posedge pclk21 or negedge nprst21)
  begin
    if(!nprst21)
      pcm_status_reg21[1] <= 1'b0;
    else if (valid_reg_write21 && pcm_int_status_access21) 
      pcm_status_reg21[1] <= pwdata21[1];
    else if (macb1_wakeup21 & ~pcm_mask_reg21[1])
      pcm_status_reg21[1] <= 1'b1;
    else if (valid_reg_read21 && pcm_int_status_access21) 
      pcm_status_reg21[1] <= 1'b0;
    else
      pcm_status_reg21[1] <= pcm_status_reg21[1];
  end  
   
  // MAC21 0
  always @(posedge pclk21 or negedge nprst21)
  begin
    if(!nprst21)
      pcm_status_reg21[0] <= 1'b0;
    else if (valid_reg_write21 && pcm_int_status_access21) 
      pcm_status_reg21[0] <= pwdata21[0];
    else if (macb0_wakeup21 & ~pcm_mask_reg21[0])
      pcm_status_reg21[0] <= 1'b1;
    else if (valid_reg_read21 && pcm_int_status_access21) 
      pcm_status_reg21[0] <= 1'b0;
    else
      pcm_status_reg21[0] <= pcm_status_reg21[0];
  end  

  assign pcm_macb_wakeup_int21 = |pcm_status_reg21;

  reg [31:0] L1_ctrl_reg121;
  always @(posedge pclk21 or negedge nprst21)
  begin
    if(!nprst21)
      L1_ctrl_reg121 <= 0;
    else
      L1_ctrl_reg121 <= L1_ctrl_reg21;
  end

  // Program21 mode decode
  always @(L1_ctrl_reg21 or L1_ctrl_reg121 or int_source_h21 or cpu_shutoff_ctrl21) begin
    mte_smc_start21 = 0;
    mte_uart_start21 = 0;
    mte_smc_uart_start21  = 0;
    mte_mac_off_start21  = 0;
    mte_mac012_start21 = 0;
    mte_mac013_start21 = 0;
    mte_mac023_start21 = 0;
    mte_mac123_start21 = 0;
    mte_mac01_start21 = 0;
    mte_mac02_start21 = 0;
    mte_mac03_start21 = 0;
    mte_mac12_start21 = 0;
    mte_mac13_start21 = 0;
    mte_mac23_start21 = 0;
    mte_mac0_start21 = 0;
    mte_mac1_start21 = 0;
    mte_mac2_start21 = 0;
    mte_mac3_start21 = 0;
    mte_sys_hibernate21 = 0 ;
    mte_dma_start21 = 0 ;
    mte_cpu_start21 = 0 ;

    mte_mac0_sleep_start21 = (L1_ctrl_reg21 ==  'h14) && (L1_ctrl_reg121 == 'h4 );
    mte_mac1_sleep_start21 = (L1_ctrl_reg21 ==  'h14) && (L1_ctrl_reg121 == 'h5 ); 
    mte_mac2_sleep_start21 = (L1_ctrl_reg21 ==  'h14) && (L1_ctrl_reg121 == 'h6 ); 
    mte_mac3_sleep_start21 = (L1_ctrl_reg21 ==  'h14) && (L1_ctrl_reg121 == 'h7 ); 
    mte_mac01_sleep_start21 = (L1_ctrl_reg21 ==  'h14) && (L1_ctrl_reg121 == 'h8 ); 
    mte_mac02_sleep_start21 = (L1_ctrl_reg21 ==  'h14) && (L1_ctrl_reg121 == 'h9 ); 
    mte_mac03_sleep_start21 = (L1_ctrl_reg21 ==  'h14) && (L1_ctrl_reg121 == 'hA ); 
    mte_mac12_sleep_start21 = (L1_ctrl_reg21 ==  'h14) && (L1_ctrl_reg121 == 'hB ); 
    mte_mac13_sleep_start21 = (L1_ctrl_reg21 ==  'h14) && (L1_ctrl_reg121 == 'hC ); 
    mte_mac23_sleep_start21 = (L1_ctrl_reg21 ==  'h14) && (L1_ctrl_reg121 == 'hD ); 
    mte_mac012_sleep_start21 = (L1_ctrl_reg21 ==  'h14) && (L1_ctrl_reg121 == 'hE ); 
    mte_mac013_sleep_start21 = (L1_ctrl_reg21 ==  'h14) && (L1_ctrl_reg121 == 'hF ); 
    mte_mac023_sleep_start21 = (L1_ctrl_reg21 ==  'h14) && (L1_ctrl_reg121 == 'h10 ); 
    mte_mac123_sleep_start21 = (L1_ctrl_reg21 ==  'h14) && (L1_ctrl_reg121 == 'h11 ); 
    mte_mac_off_sleep_start21 =  (L1_ctrl_reg21 == 'h14) && (L1_ctrl_reg121 == 'h12 );
    mte_dma_sleep_start21 =  (L1_ctrl_reg21 == 'h14) && (L1_ctrl_reg121 == 'h13 );

    mte_pm_uart_to_default_start21 = (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'h1);
    mte_pm_smc_to_default_start21 = (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'h2);
    mte_pm_smc_uart_to_default_start21 = (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'h3); 
    mte_mac0_to_default21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'h4); 
    mte_mac1_to_default21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'h5); 
    mte_mac2_to_default21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'h6); 
    mte_mac3_to_default21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'h7); 
    mte_mac01_to_default21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'h8); 
    mte_mac02_to_default21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'h9); 
    mte_mac03_to_default21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'hA); 
    mte_mac12_to_default21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'hB); 
    mte_mac13_to_default21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'hC); 
    mte_mac23_to_default21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'hD); 
    mte_mac012_to_default21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'hE); 
    mte_mac013_to_default21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'hF); 
    mte_mac023_to_default21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'h10); 
    mte_mac123_to_default21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'h11); 
    mte_mac_off_to_default21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'h12); 
    mte_dma_isolate_dis21 =  (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'h13); 
    mte_cpu_isolate_dis21 =  (int_source_h21) && (cpu_shutoff_ctrl21) && (L1_ctrl_reg21 != 'h15);
    mte_sys_hibernate_to_default21 = (L1_ctrl_reg21 == 32'h0) && (L1_ctrl_reg121 == 'h15); 

   
    if (L1_ctrl_reg121 == 'h0) begin // This21 check is to make mte_cpu_start21
                                   // is set only when you from default state 
      case (L1_ctrl_reg21)
        'h0 : L1_ctrl_domain21 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain21 = 32'h2; // PM_uart21
                mte_uart_start21 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain21 = 32'h4; // PM_smc21
                mte_smc_start21 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain21 = 32'h6; // PM_smc_uart21
                mte_smc_uart_start21 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain21 = 32'h8; //  PM_macb021
                mte_mac0_start21 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain21 = 32'h10; //  PM_macb121
                mte_mac1_start21 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain21 = 32'h20; //  PM_macb221
                mte_mac2_start21 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain21 = 32'h40; //  PM_macb321
                mte_mac3_start21 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain21 = 32'h18; //  PM_macb0121
                mte_mac01_start21 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain21 = 32'h28; //  PM_macb0221
                mte_mac02_start21 = 1;
              end
        'hA : begin  
                L1_ctrl_domain21 = 32'h48; //  PM_macb0321
                mte_mac03_start21 = 1;
              end
        'hB : begin  
                L1_ctrl_domain21 = 32'h30; //  PM_macb1221
                mte_mac12_start21 = 1;
              end
        'hC : begin  
                L1_ctrl_domain21 = 32'h50; //  PM_macb1321
                mte_mac13_start21 = 1;
              end
        'hD : begin  
                L1_ctrl_domain21 = 32'h60; //  PM_macb2321
                mte_mac23_start21 = 1;
              end
        'hE : begin  
                L1_ctrl_domain21 = 32'h38; //  PM_macb01221
                mte_mac012_start21 = 1;
              end
        'hF : begin  
                L1_ctrl_domain21 = 32'h58; //  PM_macb01321
                mte_mac013_start21 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain21 = 32'h68; //  PM_macb02321
                mte_mac023_start21 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain21 = 32'h70; //  PM_macb12321
                mte_mac123_start21 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain21 = 32'h78; //  PM_macb_off21
                mte_mac_off_start21 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain21 = 32'h80; //  PM_dma21
                mte_dma_start21 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain21 = 32'h100; //  PM_cpu_sleep21
                mte_cpu_start21 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain21 = 32'h1FE; //  PM_hibernate21
                mte_sys_hibernate21 = 1;
              end
         default: L1_ctrl_domain21 = 32'h0;
      endcase
    end
  end


  wire to_default21 = (L1_ctrl_reg21 == 0);

  // Scan21 mode gating21 of power21 and isolation21 control21 signals21
  //SMC21
  assign rstn_non_srpg_smc21  = (scan_mode21 == 1'b0) ? rstn_non_srpg_smc_int21 : 1'b1;  
  assign gate_clk_smc21       = (scan_mode21 == 1'b0) ? gate_clk_smc_int21 : 1'b0;     
  assign isolate_smc21        = (scan_mode21 == 1'b0) ? isolate_smc_int21 : 1'b0;      
  assign pwr1_on_smc21        = (scan_mode21 == 1'b0) ? pwr1_on_smc_int21 : 1'b1;       
  assign pwr2_on_smc21        = (scan_mode21 == 1'b0) ? pwr2_on_smc_int21 : 1'b1;       
  assign pwr1_off_smc21       = (scan_mode21 == 1'b0) ? (!pwr1_on_smc_int21) : 1'b0;       
  assign pwr2_off_smc21       = (scan_mode21 == 1'b0) ? (!pwr2_on_smc_int21) : 1'b0;       
  assign save_edge_smc21       = (scan_mode21 == 1'b0) ? (save_edge_smc_int21) : 1'b0;       
  assign restore_edge_smc21       = (scan_mode21 == 1'b0) ? (restore_edge_smc_int21) : 1'b0;       

  //URT21
  assign rstn_non_srpg_urt21  = (scan_mode21 == 1'b0) ?  rstn_non_srpg_urt_int21 : 1'b1;  
  assign gate_clk_urt21       = (scan_mode21 == 1'b0) ?  gate_clk_urt_int21      : 1'b0;     
  assign isolate_urt21        = (scan_mode21 == 1'b0) ?  isolate_urt_int21       : 1'b0;      
  assign pwr1_on_urt21        = (scan_mode21 == 1'b0) ?  pwr1_on_urt_int21       : 1'b1;       
  assign pwr2_on_urt21        = (scan_mode21 == 1'b0) ?  pwr2_on_urt_int21       : 1'b1;       
  assign pwr1_off_urt21       = (scan_mode21 == 1'b0) ?  (!pwr1_on_urt_int21)  : 1'b0;       
  assign pwr2_off_urt21       = (scan_mode21 == 1'b0) ?  (!pwr2_on_urt_int21)  : 1'b0;       
  assign save_edge_urt21       = (scan_mode21 == 1'b0) ? (save_edge_urt_int21) : 1'b0;       
  assign restore_edge_urt21       = (scan_mode21 == 1'b0) ? (restore_edge_urt_int21) : 1'b0;       

  //ETH021
  assign rstn_non_srpg_macb021 = (scan_mode21 == 1'b0) ?  rstn_non_srpg_macb0_int21 : 1'b1;  
  assign gate_clk_macb021       = (scan_mode21 == 1'b0) ?  gate_clk_macb0_int21      : 1'b0;     
  assign isolate_macb021        = (scan_mode21 == 1'b0) ?  isolate_macb0_int21       : 1'b0;      
  assign pwr1_on_macb021        = (scan_mode21 == 1'b0) ?  pwr1_on_macb0_int21       : 1'b1;       
  assign pwr2_on_macb021        = (scan_mode21 == 1'b0) ?  pwr2_on_macb0_int21       : 1'b1;       
  assign pwr1_off_macb021       = (scan_mode21 == 1'b0) ?  (!pwr1_on_macb0_int21)  : 1'b0;       
  assign pwr2_off_macb021       = (scan_mode21 == 1'b0) ?  (!pwr2_on_macb0_int21)  : 1'b0;       
  assign save_edge_macb021       = (scan_mode21 == 1'b0) ? (save_edge_macb0_int21) : 1'b0;       
  assign restore_edge_macb021       = (scan_mode21 == 1'b0) ? (restore_edge_macb0_int21) : 1'b0;       

  //ETH121
  assign rstn_non_srpg_macb121 = (scan_mode21 == 1'b0) ?  rstn_non_srpg_macb1_int21 : 1'b1;  
  assign gate_clk_macb121       = (scan_mode21 == 1'b0) ?  gate_clk_macb1_int21      : 1'b0;     
  assign isolate_macb121        = (scan_mode21 == 1'b0) ?  isolate_macb1_int21       : 1'b0;      
  assign pwr1_on_macb121        = (scan_mode21 == 1'b0) ?  pwr1_on_macb1_int21       : 1'b1;       
  assign pwr2_on_macb121        = (scan_mode21 == 1'b0) ?  pwr2_on_macb1_int21       : 1'b1;       
  assign pwr1_off_macb121       = (scan_mode21 == 1'b0) ?  (!pwr1_on_macb1_int21)  : 1'b0;       
  assign pwr2_off_macb121       = (scan_mode21 == 1'b0) ?  (!pwr2_on_macb1_int21)  : 1'b0;       
  assign save_edge_macb121       = (scan_mode21 == 1'b0) ? (save_edge_macb1_int21) : 1'b0;       
  assign restore_edge_macb121       = (scan_mode21 == 1'b0) ? (restore_edge_macb1_int21) : 1'b0;       

  //ETH221
  assign rstn_non_srpg_macb221 = (scan_mode21 == 1'b0) ?  rstn_non_srpg_macb2_int21 : 1'b1;  
  assign gate_clk_macb221       = (scan_mode21 == 1'b0) ?  gate_clk_macb2_int21      : 1'b0;     
  assign isolate_macb221        = (scan_mode21 == 1'b0) ?  isolate_macb2_int21       : 1'b0;      
  assign pwr1_on_macb221        = (scan_mode21 == 1'b0) ?  pwr1_on_macb2_int21       : 1'b1;       
  assign pwr2_on_macb221        = (scan_mode21 == 1'b0) ?  pwr2_on_macb2_int21       : 1'b1;       
  assign pwr1_off_macb221       = (scan_mode21 == 1'b0) ?  (!pwr1_on_macb2_int21)  : 1'b0;       
  assign pwr2_off_macb221       = (scan_mode21 == 1'b0) ?  (!pwr2_on_macb2_int21)  : 1'b0;       
  assign save_edge_macb221       = (scan_mode21 == 1'b0) ? (save_edge_macb2_int21) : 1'b0;       
  assign restore_edge_macb221       = (scan_mode21 == 1'b0) ? (restore_edge_macb2_int21) : 1'b0;       

  //ETH321
  assign rstn_non_srpg_macb321 = (scan_mode21 == 1'b0) ?  rstn_non_srpg_macb3_int21 : 1'b1;  
  assign gate_clk_macb321       = (scan_mode21 == 1'b0) ?  gate_clk_macb3_int21      : 1'b0;     
  assign isolate_macb321        = (scan_mode21 == 1'b0) ?  isolate_macb3_int21       : 1'b0;      
  assign pwr1_on_macb321        = (scan_mode21 == 1'b0) ?  pwr1_on_macb3_int21       : 1'b1;       
  assign pwr2_on_macb321        = (scan_mode21 == 1'b0) ?  pwr2_on_macb3_int21       : 1'b1;       
  assign pwr1_off_macb321       = (scan_mode21 == 1'b0) ?  (!pwr1_on_macb3_int21)  : 1'b0;       
  assign pwr2_off_macb321       = (scan_mode21 == 1'b0) ?  (!pwr2_on_macb3_int21)  : 1'b0;       
  assign save_edge_macb321       = (scan_mode21 == 1'b0) ? (save_edge_macb3_int21) : 1'b0;       
  assign restore_edge_macb321       = (scan_mode21 == 1'b0) ? (restore_edge_macb3_int21) : 1'b0;       

  // MEM21
  assign rstn_non_srpg_mem21 =   (rstn_non_srpg_macb021 && rstn_non_srpg_macb121 && rstn_non_srpg_macb221 &&
                                rstn_non_srpg_macb321 && rstn_non_srpg_dma21 && rstn_non_srpg_cpu21 && rstn_non_srpg_urt21 &&
                                rstn_non_srpg_smc21);

  assign gate_clk_mem21 =  (gate_clk_macb021 && gate_clk_macb121 && gate_clk_macb221 &&
                            gate_clk_macb321 && gate_clk_dma21 && gate_clk_cpu21 && gate_clk_urt21 && gate_clk_smc21);

  assign isolate_mem21  = (isolate_macb021 && isolate_macb121 && isolate_macb221 &&
                         isolate_macb321 && isolate_dma21 && isolate_cpu21 && isolate_urt21 && isolate_smc21);


  assign pwr1_on_mem21        =   ~pwr1_off_mem21;

  assign pwr2_on_mem21        =   ~pwr2_off_mem21;

  assign pwr1_off_mem21       =  (pwr1_off_macb021 && pwr1_off_macb121 && pwr1_off_macb221 &&
                                 pwr1_off_macb321 && pwr1_off_dma21 && pwr1_off_cpu21 && pwr1_off_urt21 && pwr1_off_smc21);


  assign pwr2_off_mem21       =  (pwr2_off_macb021 && pwr2_off_macb121 && pwr2_off_macb221 &&
                                pwr2_off_macb321 && pwr2_off_dma21 && pwr2_off_cpu21 && pwr2_off_urt21 && pwr2_off_smc21);

  assign save_edge_mem21      =  (save_edge_macb021 && save_edge_macb121 && save_edge_macb221 &&
                                save_edge_macb321 && save_edge_dma21 && save_edge_cpu21 && save_edge_smc21 && save_edge_urt21);

  assign restore_edge_mem21   =  (restore_edge_macb021 && restore_edge_macb121 && restore_edge_macb221  &&
                                restore_edge_macb321 && restore_edge_dma21 && restore_edge_cpu21 && restore_edge_urt21 &&
                                restore_edge_smc21);

  assign standby_mem021 = pwr1_off_macb021 && (~ (pwr1_off_macb021 && pwr1_off_macb121 && pwr1_off_macb221 && pwr1_off_macb321 && pwr1_off_urt21 && pwr1_off_smc21 && pwr1_off_dma21 && pwr1_off_cpu21));
  assign standby_mem121 = pwr1_off_macb121 && (~ (pwr1_off_macb021 && pwr1_off_macb121 && pwr1_off_macb221 && pwr1_off_macb321 && pwr1_off_urt21 && pwr1_off_smc21 && pwr1_off_dma21 && pwr1_off_cpu21));
  assign standby_mem221 = pwr1_off_macb221 && (~ (pwr1_off_macb021 && pwr1_off_macb121 && pwr1_off_macb221 && pwr1_off_macb321 && pwr1_off_urt21 && pwr1_off_smc21 && pwr1_off_dma21 && pwr1_off_cpu21));
  assign standby_mem321 = pwr1_off_macb321 && (~ (pwr1_off_macb021 && pwr1_off_macb121 && pwr1_off_macb221 && pwr1_off_macb321 && pwr1_off_urt21 && pwr1_off_smc21 && pwr1_off_dma21 && pwr1_off_cpu21));

  assign pwr1_off_mem021 = pwr1_off_mem21;
  assign pwr1_off_mem121 = pwr1_off_mem21;
  assign pwr1_off_mem221 = pwr1_off_mem21;
  assign pwr1_off_mem321 = pwr1_off_mem21;

  assign rstn_non_srpg_alut21  =  (rstn_non_srpg_macb021 && rstn_non_srpg_macb121 && rstn_non_srpg_macb221 && rstn_non_srpg_macb321);


   assign gate_clk_alut21       =  (gate_clk_macb021 && gate_clk_macb121 && gate_clk_macb221 && gate_clk_macb321);


    assign isolate_alut21        =  (isolate_macb021 && isolate_macb121 && isolate_macb221 && isolate_macb321);


    assign pwr1_on_alut21        =  (pwr1_on_macb021 || pwr1_on_macb121 || pwr1_on_macb221 || pwr1_on_macb321);


    assign pwr2_on_alut21        =  (pwr2_on_macb021 || pwr2_on_macb121 || pwr2_on_macb221 || pwr2_on_macb321);


    assign pwr1_off_alut21       =  (pwr1_off_macb021 && pwr1_off_macb121 && pwr1_off_macb221 && pwr1_off_macb321);


    assign pwr2_off_alut21       =  (pwr2_off_macb021 && pwr2_off_macb121 && pwr2_off_macb221 && pwr2_off_macb321);


    assign save_edge_alut21      =  (save_edge_macb021 && save_edge_macb121 && save_edge_macb221 && save_edge_macb321);


    assign restore_edge_alut21   =  (restore_edge_macb021 || restore_edge_macb121 || restore_edge_macb221 ||
                                   restore_edge_macb321) && save_alut_tmp21;

     // alut21 power21 off21 detection21
  always @(posedge pclk21 or negedge nprst21) begin
    if (!nprst21) 
       save_alut_tmp21 <= 0;
    else if (restore_edge_alut21)
       save_alut_tmp21 <= 0;
    else if (save_edge_alut21)
       save_alut_tmp21 <= 1;
  end

  //DMA21
  assign rstn_non_srpg_dma21 = (scan_mode21 == 1'b0) ?  rstn_non_srpg_dma_int21 : 1'b1;  
  assign gate_clk_dma21       = (scan_mode21 == 1'b0) ?  gate_clk_dma_int21      : 1'b0;     
  assign isolate_dma21        = (scan_mode21 == 1'b0) ?  isolate_dma_int21       : 1'b0;      
  assign pwr1_on_dma21        = (scan_mode21 == 1'b0) ?  pwr1_on_dma_int21       : 1'b1;       
  assign pwr2_on_dma21        = (scan_mode21 == 1'b0) ?  pwr2_on_dma_int21       : 1'b1;       
  assign pwr1_off_dma21       = (scan_mode21 == 1'b0) ?  (!pwr1_on_dma_int21)  : 1'b0;       
  assign pwr2_off_dma21       = (scan_mode21 == 1'b0) ?  (!pwr2_on_dma_int21)  : 1'b0;       
  assign save_edge_dma21       = (scan_mode21 == 1'b0) ? (save_edge_dma_int21) : 1'b0;       
  assign restore_edge_dma21       = (scan_mode21 == 1'b0) ? (restore_edge_dma_int21) : 1'b0;       

  //CPU21
  assign rstn_non_srpg_cpu21 = (scan_mode21 == 1'b0) ?  rstn_non_srpg_cpu_int21 : 1'b1;  
  assign gate_clk_cpu21       = (scan_mode21 == 1'b0) ?  gate_clk_cpu_int21      : 1'b0;     
  assign isolate_cpu21        = (scan_mode21 == 1'b0) ?  isolate_cpu_int21       : 1'b0;      
  assign pwr1_on_cpu21        = (scan_mode21 == 1'b0) ?  pwr1_on_cpu_int21       : 1'b1;       
  assign pwr2_on_cpu21        = (scan_mode21 == 1'b0) ?  pwr2_on_cpu_int21       : 1'b1;       
  assign pwr1_off_cpu21       = (scan_mode21 == 1'b0) ?  (!pwr1_on_cpu_int21)  : 1'b0;       
  assign pwr2_off_cpu21       = (scan_mode21 == 1'b0) ?  (!pwr2_on_cpu_int21)  : 1'b0;       
  assign save_edge_cpu21       = (scan_mode21 == 1'b0) ? (save_edge_cpu_int21) : 1'b0;       
  assign restore_edge_cpu21       = (scan_mode21 == 1'b0) ? (restore_edge_cpu_int21) : 1'b0;       



  // ASE21

   reg ase_core_12v21, ase_core_10v21, ase_core_08v21, ase_core_06v21;
   reg ase_macb0_12v21,ase_macb1_12v21,ase_macb2_12v21,ase_macb3_12v21;

    // core21 ase21

    // core21 at 1.0 v if (smc21 off21, urt21 off21, macb021 off21, macb121 off21, macb221 off21, macb321 off21
   // core21 at 0.8v if (mac01off21, macb02off21, macb03off21, macb12off21, mac13off21, mac23off21,
   // core21 at 0.6v if (mac012off21, mac013off21, mac023off21, mac123off21, mac0123off21
    // else core21 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb021 && pwr1_off_macb121 && pwr1_off_macb221 && pwr1_off_macb321) || // all mac21 off21
       (pwr1_off_macb321 && pwr1_off_macb221 && pwr1_off_macb121) || // mac123off21 
       (pwr1_off_macb321 && pwr1_off_macb221 && pwr1_off_macb021) || // mac023off21 
       (pwr1_off_macb321 && pwr1_off_macb121 && pwr1_off_macb021) || // mac013off21 
       (pwr1_off_macb221 && pwr1_off_macb121 && pwr1_off_macb021) )  // mac012off21 
       begin
         ase_core_12v21 = 0;
         ase_core_10v21 = 0;
         ase_core_08v21 = 0;
         ase_core_06v21 = 1;
       end
     else if( (pwr1_off_macb221 && pwr1_off_macb321) || // mac2321 off21
         (pwr1_off_macb321 && pwr1_off_macb121) || // mac13off21 
         (pwr1_off_macb121 && pwr1_off_macb221) || // mac12off21 
         (pwr1_off_macb321 && pwr1_off_macb021) || // mac03off21 
         (pwr1_off_macb221 && pwr1_off_macb021) || // mac02off21 
         (pwr1_off_macb121 && pwr1_off_macb021))  // mac01off21 
       begin
         ase_core_12v21 = 0;
         ase_core_10v21 = 0;
         ase_core_08v21 = 1;
         ase_core_06v21 = 0;
       end
     else if( (pwr1_off_smc21) || // smc21 off21
         (pwr1_off_macb021 ) || // mac0off21 
         (pwr1_off_macb121 ) || // mac1off21 
         (pwr1_off_macb221 ) || // mac2off21 
         (pwr1_off_macb321 ))  // mac3off21 
       begin
         ase_core_12v21 = 0;
         ase_core_10v21 = 1;
         ase_core_08v21 = 0;
         ase_core_06v21 = 0;
       end
     else if (pwr1_off_urt21)
       begin
         ase_core_12v21 = 1;
         ase_core_10v21 = 0;
         ase_core_08v21 = 0;
         ase_core_06v21 = 0;
       end
     else
       begin
         ase_core_12v21 = 1;
         ase_core_10v21 = 0;
         ase_core_08v21 = 0;
         ase_core_06v21 = 0;
       end
   end


   // cpu21
   // cpu21 @ 1.0v when macoff21, 
   // 
   reg ase_cpu_10v21, ase_cpu_12v21;
   always @(*) begin
    if(pwr1_off_cpu21) begin
     ase_cpu_12v21 = 1'b0;
     ase_cpu_10v21 = 1'b0;
    end
    else if(pwr1_off_macb021 || pwr1_off_macb121 || pwr1_off_macb221 || pwr1_off_macb321)
    begin
     ase_cpu_12v21 = 1'b0;
     ase_cpu_10v21 = 1'b1;
    end
    else
    begin
     ase_cpu_12v21 = 1'b1;
     ase_cpu_10v21 = 1'b0;
    end
   end

   // dma21
   // dma21 @v121.0 for macoff21, 

   reg ase_dma_10v21, ase_dma_12v21;
   always @(*) begin
    if(pwr1_off_dma21) begin
     ase_dma_12v21 = 1'b0;
     ase_dma_10v21 = 1'b0;
    end
    else if(pwr1_off_macb021 || pwr1_off_macb121 || pwr1_off_macb221 || pwr1_off_macb321)
    begin
     ase_dma_12v21 = 1'b0;
     ase_dma_10v21 = 1'b1;
    end
    else
    begin
     ase_dma_12v21 = 1'b1;
     ase_dma_10v21 = 1'b0;
    end
   end

   // alut21
   // @ v121.0 for macoff21

   reg ase_alut_10v21, ase_alut_12v21;
   always @(*) begin
    if(pwr1_off_alut21) begin
     ase_alut_12v21 = 1'b0;
     ase_alut_10v21 = 1'b0;
    end
    else if(pwr1_off_macb021 || pwr1_off_macb121 || pwr1_off_macb221 || pwr1_off_macb321)
    begin
     ase_alut_12v21 = 1'b0;
     ase_alut_10v21 = 1'b1;
    end
    else
    begin
     ase_alut_12v21 = 1'b1;
     ase_alut_10v21 = 1'b0;
    end
   end




   reg ase_uart_12v21;
   reg ase_uart_10v21;
   reg ase_uart_08v21;
   reg ase_uart_06v21;

   reg ase_smc_12v21;


   always @(*) begin
     if(pwr1_off_urt21) begin // uart21 off21
       ase_uart_08v21 = 1'b0;
       ase_uart_06v21 = 1'b0;
       ase_uart_10v21 = 1'b0;
       ase_uart_12v21 = 1'b0;
     end 
     else if( (pwr1_off_macb021 && pwr1_off_macb121 && pwr1_off_macb221 && pwr1_off_macb321) || // all mac21 off21
       (pwr1_off_macb321 && pwr1_off_macb221 && pwr1_off_macb121) || // mac123off21 
       (pwr1_off_macb321 && pwr1_off_macb221 && pwr1_off_macb021) || // mac023off21 
       (pwr1_off_macb321 && pwr1_off_macb121 && pwr1_off_macb021) || // mac013off21 
       (pwr1_off_macb221 && pwr1_off_macb121 && pwr1_off_macb021) )  // mac012off21 
     begin
       ase_uart_06v21 = 1'b1;
       ase_uart_08v21 = 1'b0;
       ase_uart_10v21 = 1'b0;
       ase_uart_12v21 = 1'b0;
     end
     else if( (pwr1_off_macb221 && pwr1_off_macb321) || // mac2321 off21
         (pwr1_off_macb321 && pwr1_off_macb121) || // mac13off21 
         (pwr1_off_macb121 && pwr1_off_macb221) || // mac12off21 
         (pwr1_off_macb321 && pwr1_off_macb021) || // mac03off21 
         (pwr1_off_macb121 && pwr1_off_macb021))  // mac01off21  
     begin
       ase_uart_06v21 = 1'b0;
       ase_uart_08v21 = 1'b1;
       ase_uart_10v21 = 1'b0;
       ase_uart_12v21 = 1'b0;
     end
     else if (pwr1_off_smc21 || pwr1_off_macb021 || pwr1_off_macb121 || pwr1_off_macb221 || pwr1_off_macb321) begin // smc21 off21
       ase_uart_08v21 = 1'b0;
       ase_uart_06v21 = 1'b0;
       ase_uart_10v21 = 1'b1;
       ase_uart_12v21 = 1'b0;
     end 
     else begin
       ase_uart_08v21 = 1'b0;
       ase_uart_06v21 = 1'b0;
       ase_uart_10v21 = 1'b0;
       ase_uart_12v21 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc21) begin
     if (pwr1_off_smc21)  // smc21 off21
       ase_smc_12v21 = 1'b0;
    else
       ase_smc_12v21 = 1'b1;
   end

   
   always @(pwr1_off_macb021) begin
     if (pwr1_off_macb021) // macb021 off21
       ase_macb0_12v21 = 1'b0;
     else
       ase_macb0_12v21 = 1'b1;
   end

   always @(pwr1_off_macb121) begin
     if (pwr1_off_macb121) // macb121 off21
       ase_macb1_12v21 = 1'b0;
     else
       ase_macb1_12v21 = 1'b1;
   end

   always @(pwr1_off_macb221) begin // macb221 off21
     if (pwr1_off_macb221) // macb221 off21
       ase_macb2_12v21 = 1'b0;
     else
       ase_macb2_12v21 = 1'b1;
   end

   always @(pwr1_off_macb321) begin // macb321 off21
     if (pwr1_off_macb321) // macb321 off21
       ase_macb3_12v21 = 1'b0;
     else
       ase_macb3_12v21 = 1'b1;
   end


   // core21 voltage21 for vco21
  assign core12v21 = ase_macb0_12v21 & ase_macb1_12v21 & ase_macb2_12v21 & ase_macb3_12v21;

  assign core10v21 =  (ase_macb0_12v21 & ase_macb1_12v21 & ase_macb2_12v21 & (!ase_macb3_12v21)) ||
                    (ase_macb0_12v21 & ase_macb1_12v21 & (!ase_macb2_12v21) & ase_macb3_12v21) ||
                    (ase_macb0_12v21 & (!ase_macb1_12v21) & ase_macb2_12v21 & ase_macb3_12v21) ||
                    ((!ase_macb0_12v21) & ase_macb1_12v21 & ase_macb2_12v21 & ase_macb3_12v21);

  assign core08v21 =  ((!ase_macb0_12v21) & (!ase_macb1_12v21) & (ase_macb2_12v21) & (ase_macb3_12v21)) ||
                    ((!ase_macb0_12v21) & (ase_macb1_12v21) & (!ase_macb2_12v21) & (ase_macb3_12v21)) ||
                    ((!ase_macb0_12v21) & (ase_macb1_12v21) & (ase_macb2_12v21) & (!ase_macb3_12v21)) ||
                    ((ase_macb0_12v21) & (!ase_macb1_12v21) & (!ase_macb2_12v21) & (ase_macb3_12v21)) ||
                    ((ase_macb0_12v21) & (!ase_macb1_12v21) & (ase_macb2_12v21) & (!ase_macb3_12v21)) ||
                    ((ase_macb0_12v21) & (ase_macb1_12v21) & (!ase_macb2_12v21) & (!ase_macb3_12v21));

  assign core06v21 =  ((!ase_macb0_12v21) & (!ase_macb1_12v21) & (!ase_macb2_12v21) & (ase_macb3_12v21)) ||
                    ((!ase_macb0_12v21) & (!ase_macb1_12v21) & (ase_macb2_12v21) & (!ase_macb3_12v21)) ||
                    ((!ase_macb0_12v21) & (ase_macb1_12v21) & (!ase_macb2_12v21) & (!ase_macb3_12v21)) ||
                    ((ase_macb0_12v21) & (!ase_macb1_12v21) & (!ase_macb2_12v21) & (!ase_macb3_12v21)) ||
                    ((!ase_macb0_12v21) & (!ase_macb1_12v21) & (!ase_macb2_12v21) & (!ase_macb3_12v21)) ;



`ifdef LP_ABV_ON21
// psl21 default clock21 = (posedge pclk21);

// Cover21 a condition in which SMC21 is powered21 down
// and again21 powered21 up while UART21 is going21 into POWER21 down
// state or UART21 is already in POWER21 DOWN21 state
// psl21 cover_overlapping_smc_urt_121:
//    cover{fell21(pwr1_on_urt21);[*];fell21(pwr1_on_smc21);[*];
//    rose21(pwr1_on_smc21);[*];rose21(pwr1_on_urt21)};
//
// Cover21 a condition in which UART21 is powered21 down
// and again21 powered21 up while SMC21 is going21 into POWER21 down
// state or SMC21 is already in POWER21 DOWN21 state
// psl21 cover_overlapping_smc_urt_221:
//    cover{fell21(pwr1_on_smc21);[*];fell21(pwr1_on_urt21);[*];
//    rose21(pwr1_on_urt21);[*];rose21(pwr1_on_smc21)};
//


// Power21 Down21 UART21
// This21 gets21 triggered on rising21 edge of Gate21 signal21 for
// UART21 (gate_clk_urt21). In a next cycle after gate_clk_urt21,
// Isolate21 UART21(isolate_urt21) signal21 become21 HIGH21 (active).
// In 2nd cycle after gate_clk_urt21 becomes HIGH21, RESET21 for NON21
// SRPG21 FFs21(rstn_non_srpg_urt21) and POWER121 for UART21(pwr1_on_urt21) should 
// go21 LOW21. 
// This21 completes21 a POWER21 DOWN21. 

sequence s_power_down_urt21;
      (gate_clk_urt21 & !isolate_urt21 & rstn_non_srpg_urt21 & pwr1_on_urt21) 
  ##1 (gate_clk_urt21 & isolate_urt21 & rstn_non_srpg_urt21 & pwr1_on_urt21) 
  ##3 (gate_clk_urt21 & isolate_urt21 & !rstn_non_srpg_urt21 & !pwr1_on_urt21);
endsequence


property p_power_down_urt21;
   @(posedge pclk21)
    $rose(gate_clk_urt21) |=> s_power_down_urt21;
endproperty

output_power_down_urt21:
  assert property (p_power_down_urt21);


// Power21 UP21 UART21
// Sequence starts with , Rising21 edge of pwr1_on_urt21.
// Two21 clock21 cycle after this, isolate_urt21 should become21 LOW21 
// On21 the following21 clk21 gate_clk_urt21 should go21 low21.
// 5 cycles21 after  Rising21 edge of pwr1_on_urt21, rstn_non_srpg_urt21
// should become21 HIGH21
sequence s_power_up_urt21;
##30 (pwr1_on_urt21 & !isolate_urt21 & gate_clk_urt21 & !rstn_non_srpg_urt21) 
##1 (pwr1_on_urt21 & !isolate_urt21 & !gate_clk_urt21 & !rstn_non_srpg_urt21) 
##2 (pwr1_on_urt21 & !isolate_urt21 & !gate_clk_urt21 & rstn_non_srpg_urt21);
endsequence

property p_power_up_urt21;
   @(posedge pclk21)
  disable iff(!nprst21)
    (!pwr1_on_urt21 ##1 pwr1_on_urt21) |=> s_power_up_urt21;
endproperty

output_power_up_urt21:
  assert property (p_power_up_urt21);


// Power21 Down21 SMC21
// This21 gets21 triggered on rising21 edge of Gate21 signal21 for
// SMC21 (gate_clk_smc21). In a next cycle after gate_clk_smc21,
// Isolate21 SMC21(isolate_smc21) signal21 become21 HIGH21 (active).
// In 2nd cycle after gate_clk_smc21 becomes HIGH21, RESET21 for NON21
// SRPG21 FFs21(rstn_non_srpg_smc21) and POWER121 for SMC21(pwr1_on_smc21) should 
// go21 LOW21. 
// This21 completes21 a POWER21 DOWN21. 

sequence s_power_down_smc21;
      (gate_clk_smc21 & !isolate_smc21 & rstn_non_srpg_smc21 & pwr1_on_smc21) 
  ##1 (gate_clk_smc21 & isolate_smc21 & rstn_non_srpg_smc21 & pwr1_on_smc21) 
  ##3 (gate_clk_smc21 & isolate_smc21 & !rstn_non_srpg_smc21 & !pwr1_on_smc21);
endsequence


property p_power_down_smc21;
   @(posedge pclk21)
    $rose(gate_clk_smc21) |=> s_power_down_smc21;
endproperty

output_power_down_smc21:
  assert property (p_power_down_smc21);


// Power21 UP21 SMC21
// Sequence starts with , Rising21 edge of pwr1_on_smc21.
// Two21 clock21 cycle after this, isolate_smc21 should become21 LOW21 
// On21 the following21 clk21 gate_clk_smc21 should go21 low21.
// 5 cycles21 after  Rising21 edge of pwr1_on_smc21, rstn_non_srpg_smc21
// should become21 HIGH21
sequence s_power_up_smc21;
##30 (pwr1_on_smc21 & !isolate_smc21 & gate_clk_smc21 & !rstn_non_srpg_smc21) 
##1 (pwr1_on_smc21 & !isolate_smc21 & !gate_clk_smc21 & !rstn_non_srpg_smc21) 
##2 (pwr1_on_smc21 & !isolate_smc21 & !gate_clk_smc21 & rstn_non_srpg_smc21);
endsequence

property p_power_up_smc21;
   @(posedge pclk21)
  disable iff(!nprst21)
    (!pwr1_on_smc21 ##1 pwr1_on_smc21) |=> s_power_up_smc21;
endproperty

output_power_up_smc21:
  assert property (p_power_up_smc21);


// COVER21 SMC21 POWER21 DOWN21 AND21 UP21
cover_power_down_up_smc21: cover property (@(posedge pclk21)
(s_power_down_smc21 ##[5:180] s_power_up_smc21));



// COVER21 UART21 POWER21 DOWN21 AND21 UP21
cover_power_down_up_urt21: cover property (@(posedge pclk21)
(s_power_down_urt21 ##[5:180] s_power_up_urt21));

cover_power_down_urt21: cover property (@(posedge pclk21)
(s_power_down_urt21));

cover_power_up_urt21: cover property (@(posedge pclk21)
(s_power_up_urt21));




`ifdef PCM_ABV_ON21
//------------------------------------------------------------------------------
// Power21 Controller21 Formal21 Verification21 component.  Each power21 domain has a 
// separate21 instantiation21
//------------------------------------------------------------------------------

// need to assume that CPU21 will leave21 a minimum time between powering21 down and 
// back up.  In this example21, 10clks has been selected.
// psl21 config_min_uart_pd_time21 : assume always {rose21(L1_ctrl_domain21[1])} |-> { L1_ctrl_domain21[1][*10] } abort21(~nprst21);
// psl21 config_min_uart_pu_time21 : assume always {fell21(L1_ctrl_domain21[1])} |-> { !L1_ctrl_domain21[1][*10] } abort21(~nprst21);
// psl21 config_min_smc_pd_time21 : assume always {rose21(L1_ctrl_domain21[2])} |-> { L1_ctrl_domain21[2][*10] } abort21(~nprst21);
// psl21 config_min_smc_pu_time21 : assume always {fell21(L1_ctrl_domain21[2])} |-> { !L1_ctrl_domain21[2][*10] } abort21(~nprst21);

// UART21 VCOMP21 parameters21
   defparam i_uart_vcomp_domain21.ENABLE_SAVE_RESTORE_EDGE21   = 1;
   defparam i_uart_vcomp_domain21.ENABLE_EXT_PWR_CNTRL21       = 1;
   defparam i_uart_vcomp_domain21.REF_CLK_DEFINED21            = 0;
   defparam i_uart_vcomp_domain21.MIN_SHUTOFF_CYCLES21         = 4;
   defparam i_uart_vcomp_domain21.MIN_RESTORE_TO_ISO_CYCLES21  = 0;
   defparam i_uart_vcomp_domain21.MIN_SAVE_TO_SHUTOFF_CYCLES21 = 1;


   vcomp_domain21 i_uart_vcomp_domain21
   ( .ref_clk21(pclk21),
     .start_lps21(L1_ctrl_domain21[1] || !rstn_non_srpg_urt21),
     .rst_n21(nprst21),
     .ext_power_down21(L1_ctrl_domain21[1]),
     .iso_en21(isolate_urt21),
     .save_edge21(save_edge_urt21),
     .restore_edge21(restore_edge_urt21),
     .domain_shut_off21(pwr1_off_urt21),
     .domain_clk21(!gate_clk_urt21 && pclk21)
   );


// SMC21 VCOMP21 parameters21
   defparam i_smc_vcomp_domain21.ENABLE_SAVE_RESTORE_EDGE21   = 1;
   defparam i_smc_vcomp_domain21.ENABLE_EXT_PWR_CNTRL21       = 1;
   defparam i_smc_vcomp_domain21.REF_CLK_DEFINED21            = 0;
   defparam i_smc_vcomp_domain21.MIN_SHUTOFF_CYCLES21         = 4;
   defparam i_smc_vcomp_domain21.MIN_RESTORE_TO_ISO_CYCLES21  = 0;
   defparam i_smc_vcomp_domain21.MIN_SAVE_TO_SHUTOFF_CYCLES21 = 1;


   vcomp_domain21 i_smc_vcomp_domain21
   ( .ref_clk21(pclk21),
     .start_lps21(L1_ctrl_domain21[2] || !rstn_non_srpg_smc21),
     .rst_n21(nprst21),
     .ext_power_down21(L1_ctrl_domain21[2]),
     .iso_en21(isolate_smc21),
     .save_edge21(save_edge_smc21),
     .restore_edge21(restore_edge_smc21),
     .domain_shut_off21(pwr1_off_smc21),
     .domain_clk21(!gate_clk_smc21 && pclk21)
   );

`endif

`endif



endmodule
