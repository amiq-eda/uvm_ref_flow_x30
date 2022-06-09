//File15 name   : power_ctrl15.v
//Title15       : Power15 Control15 Module15
//Created15     : 1999
//Description15 : Top15 level of power15 controller15
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

module power_ctrl15 (


    // Clocks15 & Reset15
    pclk15,
    nprst15,
    // APB15 programming15 interface
    paddr15,
    psel15,
    penable15,
    pwrite15,
    pwdata15,
    prdata15,
    // mac15 i/f,
    macb3_wakeup15,
    macb2_wakeup15,
    macb1_wakeup15,
    macb0_wakeup15,
    // Scan15 
    scan_in15,
    scan_en15,
    scan_mode15,
    scan_out15,
    // Module15 control15 outputs15
    int_source_h15,
    // SMC15
    rstn_non_srpg_smc15,
    gate_clk_smc15,
    isolate_smc15,
    save_edge_smc15,
    restore_edge_smc15,
    pwr1_on_smc15,
    pwr2_on_smc15,
    pwr1_off_smc15,
    pwr2_off_smc15,
    // URT15
    rstn_non_srpg_urt15,
    gate_clk_urt15,
    isolate_urt15,
    save_edge_urt15,
    restore_edge_urt15,
    pwr1_on_urt15,
    pwr2_on_urt15,
    pwr1_off_urt15,      
    pwr2_off_urt15,
    // ETH015
    rstn_non_srpg_macb015,
    gate_clk_macb015,
    isolate_macb015,
    save_edge_macb015,
    restore_edge_macb015,
    pwr1_on_macb015,
    pwr2_on_macb015,
    pwr1_off_macb015,      
    pwr2_off_macb015,
    // ETH115
    rstn_non_srpg_macb115,
    gate_clk_macb115,
    isolate_macb115,
    save_edge_macb115,
    restore_edge_macb115,
    pwr1_on_macb115,
    pwr2_on_macb115,
    pwr1_off_macb115,      
    pwr2_off_macb115,
    // ETH215
    rstn_non_srpg_macb215,
    gate_clk_macb215,
    isolate_macb215,
    save_edge_macb215,
    restore_edge_macb215,
    pwr1_on_macb215,
    pwr2_on_macb215,
    pwr1_off_macb215,      
    pwr2_off_macb215,
    // ETH315
    rstn_non_srpg_macb315,
    gate_clk_macb315,
    isolate_macb315,
    save_edge_macb315,
    restore_edge_macb315,
    pwr1_on_macb315,
    pwr2_on_macb315,
    pwr1_off_macb315,      
    pwr2_off_macb315,
    // DMA15
    rstn_non_srpg_dma15,
    gate_clk_dma15,
    isolate_dma15,
    save_edge_dma15,
    restore_edge_dma15,
    pwr1_on_dma15,
    pwr2_on_dma15,
    pwr1_off_dma15,      
    pwr2_off_dma15,
    // CPU15
    rstn_non_srpg_cpu15,
    gate_clk_cpu15,
    isolate_cpu15,
    save_edge_cpu15,
    restore_edge_cpu15,
    pwr1_on_cpu15,
    pwr2_on_cpu15,
    pwr1_off_cpu15,      
    pwr2_off_cpu15,
    // ALUT15
    rstn_non_srpg_alut15,
    gate_clk_alut15,
    isolate_alut15,
    save_edge_alut15,
    restore_edge_alut15,
    pwr1_on_alut15,
    pwr2_on_alut15,
    pwr1_off_alut15,      
    pwr2_off_alut15,
    // MEM15
    rstn_non_srpg_mem15,
    gate_clk_mem15,
    isolate_mem15,
    save_edge_mem15,
    restore_edge_mem15,
    pwr1_on_mem15,
    pwr2_on_mem15,
    pwr1_off_mem15,      
    pwr2_off_mem15,
    // core15 dvfs15 transitions15
    core06v15,
    core08v15,
    core10v15,
    core12v15,
    pcm_macb_wakeup_int15,
    // mte15 signals15
    mte_smc_start15,
    mte_uart_start15,
    mte_smc_uart_start15,  
    mte_pm_smc_to_default_start15, 
    mte_pm_uart_to_default_start15,
    mte_pm_smc_uart_to_default_start15

  );

  parameter STATE_IDLE_12V15 = 4'b0001;
  parameter STATE_06V15 = 4'b0010;
  parameter STATE_08V15 = 4'b0100;
  parameter STATE_10V15 = 4'b1000;

    // Clocks15 & Reset15
    input pclk15;
    input nprst15;
    // APB15 programming15 interface
    input [31:0] paddr15;
    input psel15  ;
    input penable15;
    input pwrite15 ;
    input [31:0] pwdata15;
    output [31:0] prdata15;
    // mac15
    input macb3_wakeup15;
    input macb2_wakeup15;
    input macb1_wakeup15;
    input macb0_wakeup15;
    // Scan15 
    input scan_in15;
    input scan_en15;
    input scan_mode15;
    output scan_out15;
    // Module15 control15 outputs15
    input int_source_h15;
    // SMC15
    output rstn_non_srpg_smc15 ;
    output gate_clk_smc15   ;
    output isolate_smc15   ;
    output save_edge_smc15   ;
    output restore_edge_smc15   ;
    output pwr1_on_smc15   ;
    output pwr2_on_smc15   ;
    output pwr1_off_smc15  ;
    output pwr2_off_smc15  ;
    // URT15
    output rstn_non_srpg_urt15 ;
    output gate_clk_urt15      ;
    output isolate_urt15       ;
    output save_edge_urt15   ;
    output restore_edge_urt15   ;
    output pwr1_on_urt15       ;
    output pwr2_on_urt15       ;
    output pwr1_off_urt15      ;
    output pwr2_off_urt15      ;
    // ETH015
    output rstn_non_srpg_macb015 ;
    output gate_clk_macb015      ;
    output isolate_macb015       ;
    output save_edge_macb015   ;
    output restore_edge_macb015   ;
    output pwr1_on_macb015       ;
    output pwr2_on_macb015       ;
    output pwr1_off_macb015      ;
    output pwr2_off_macb015      ;
    // ETH115
    output rstn_non_srpg_macb115 ;
    output gate_clk_macb115      ;
    output isolate_macb115       ;
    output save_edge_macb115   ;
    output restore_edge_macb115   ;
    output pwr1_on_macb115       ;
    output pwr2_on_macb115       ;
    output pwr1_off_macb115      ;
    output pwr2_off_macb115      ;
    // ETH215
    output rstn_non_srpg_macb215 ;
    output gate_clk_macb215      ;
    output isolate_macb215       ;
    output save_edge_macb215   ;
    output restore_edge_macb215   ;
    output pwr1_on_macb215       ;
    output pwr2_on_macb215       ;
    output pwr1_off_macb215      ;
    output pwr2_off_macb215      ;
    // ETH315
    output rstn_non_srpg_macb315 ;
    output gate_clk_macb315      ;
    output isolate_macb315       ;
    output save_edge_macb315   ;
    output restore_edge_macb315   ;
    output pwr1_on_macb315       ;
    output pwr2_on_macb315       ;
    output pwr1_off_macb315      ;
    output pwr2_off_macb315      ;
    // DMA15
    output rstn_non_srpg_dma15 ;
    output gate_clk_dma15      ;
    output isolate_dma15       ;
    output save_edge_dma15   ;
    output restore_edge_dma15   ;
    output pwr1_on_dma15       ;
    output pwr2_on_dma15       ;
    output pwr1_off_dma15      ;
    output pwr2_off_dma15      ;
    // CPU15
    output rstn_non_srpg_cpu15 ;
    output gate_clk_cpu15      ;
    output isolate_cpu15       ;
    output save_edge_cpu15   ;
    output restore_edge_cpu15   ;
    output pwr1_on_cpu15       ;
    output pwr2_on_cpu15       ;
    output pwr1_off_cpu15      ;
    output pwr2_off_cpu15      ;
    // ALUT15
    output rstn_non_srpg_alut15 ;
    output gate_clk_alut15      ;
    output isolate_alut15       ;
    output save_edge_alut15   ;
    output restore_edge_alut15   ;
    output pwr1_on_alut15       ;
    output pwr2_on_alut15       ;
    output pwr1_off_alut15      ;
    output pwr2_off_alut15      ;
    // MEM15
    output rstn_non_srpg_mem15 ;
    output gate_clk_mem15      ;
    output isolate_mem15       ;
    output save_edge_mem15   ;
    output restore_edge_mem15   ;
    output pwr1_on_mem15       ;
    output pwr2_on_mem15       ;
    output pwr1_off_mem15      ;
    output pwr2_off_mem15      ;


   // core15 transitions15 o/p
    output core06v15;
    output core08v15;
    output core10v15;
    output core12v15;
    output pcm_macb_wakeup_int15 ;
    //mode mte15  signals15
    output mte_smc_start15;
    output mte_uart_start15;
    output mte_smc_uart_start15;  
    output mte_pm_smc_to_default_start15; 
    output mte_pm_uart_to_default_start15;
    output mte_pm_smc_uart_to_default_start15;

    reg mte_smc_start15;
    reg mte_uart_start15;
    reg mte_smc_uart_start15;  
    reg mte_pm_smc_to_default_start15; 
    reg mte_pm_uart_to_default_start15;
    reg mte_pm_smc_uart_to_default_start15;

    reg [31:0] prdata15;

  wire valid_reg_write15  ;
  wire valid_reg_read15   ;
  wire L1_ctrl_access15   ;
  wire L1_status_access15 ;
  wire pcm_int_mask_access15;
  wire pcm_int_status_access15;
  wire standby_mem015      ;
  wire standby_mem115      ;
  wire standby_mem215      ;
  wire standby_mem315      ;
  wire pwr1_off_mem015;
  wire pwr1_off_mem115;
  wire pwr1_off_mem215;
  wire pwr1_off_mem315;
  
  // Control15 signals15
  wire set_status_smc15   ;
  wire clr_status_smc15   ;
  wire set_status_urt15   ;
  wire clr_status_urt15   ;
  wire set_status_macb015   ;
  wire clr_status_macb015   ;
  wire set_status_macb115   ;
  wire clr_status_macb115   ;
  wire set_status_macb215   ;
  wire clr_status_macb215   ;
  wire set_status_macb315   ;
  wire clr_status_macb315   ;
  wire set_status_dma15   ;
  wire clr_status_dma15   ;
  wire set_status_cpu15   ;
  wire clr_status_cpu15   ;
  wire set_status_alut15   ;
  wire clr_status_alut15   ;
  wire set_status_mem15   ;
  wire clr_status_mem15   ;


  // Status and Control15 registers
  reg [31:0]  L1_status_reg15;
  reg  [31:0] L1_ctrl_reg15  ;
  reg  [31:0] L1_ctrl_domain15  ;
  reg L1_ctrl_cpu_off_reg15;
  reg [31:0]  pcm_mask_reg15;
  reg [31:0]  pcm_status_reg15;

  // Signals15 gated15 in scan_mode15
  //SMC15
  wire  rstn_non_srpg_smc_int15;
  wire  gate_clk_smc_int15    ;     
  wire  isolate_smc_int15    ;       
  wire save_edge_smc_int15;
  wire restore_edge_smc_int15;
  wire  pwr1_on_smc_int15    ;      
  wire  pwr2_on_smc_int15    ;      


  //URT15
  wire   rstn_non_srpg_urt_int15;
  wire   gate_clk_urt_int15     ;     
  wire   isolate_urt_int15      ;       
  wire save_edge_urt_int15;
  wire restore_edge_urt_int15;
  wire   pwr1_on_urt_int15      ;      
  wire   pwr2_on_urt_int15      ;      

  // ETH015
  wire   rstn_non_srpg_macb0_int15;
  wire   gate_clk_macb0_int15     ;     
  wire   isolate_macb0_int15      ;       
  wire save_edge_macb0_int15;
  wire restore_edge_macb0_int15;
  wire   pwr1_on_macb0_int15      ;      
  wire   pwr2_on_macb0_int15      ;      
  // ETH115
  wire   rstn_non_srpg_macb1_int15;
  wire   gate_clk_macb1_int15     ;     
  wire   isolate_macb1_int15      ;       
  wire save_edge_macb1_int15;
  wire restore_edge_macb1_int15;
  wire   pwr1_on_macb1_int15      ;      
  wire   pwr2_on_macb1_int15      ;      
  // ETH215
  wire   rstn_non_srpg_macb2_int15;
  wire   gate_clk_macb2_int15     ;     
  wire   isolate_macb2_int15      ;       
  wire save_edge_macb2_int15;
  wire restore_edge_macb2_int15;
  wire   pwr1_on_macb2_int15      ;      
  wire   pwr2_on_macb2_int15      ;      
  // ETH315
  wire   rstn_non_srpg_macb3_int15;
  wire   gate_clk_macb3_int15     ;     
  wire   isolate_macb3_int15      ;       
  wire save_edge_macb3_int15;
  wire restore_edge_macb3_int15;
  wire   pwr1_on_macb3_int15      ;      
  wire   pwr2_on_macb3_int15      ;      

  // DMA15
  wire   rstn_non_srpg_dma_int15;
  wire   gate_clk_dma_int15     ;     
  wire   isolate_dma_int15      ;       
  wire save_edge_dma_int15;
  wire restore_edge_dma_int15;
  wire   pwr1_on_dma_int15      ;      
  wire   pwr2_on_dma_int15      ;      

  // CPU15
  wire   rstn_non_srpg_cpu_int15;
  wire   gate_clk_cpu_int15     ;     
  wire   isolate_cpu_int15      ;       
  wire save_edge_cpu_int15;
  wire restore_edge_cpu_int15;
  wire   pwr1_on_cpu_int15      ;      
  wire   pwr2_on_cpu_int15      ;  
  wire L1_ctrl_cpu_off_p15;    

  reg save_alut_tmp15;
  // DFS15 sm15

  reg cpu_shutoff_ctrl15;

  reg mte_mac_off_start15, mte_mac012_start15, mte_mac013_start15, mte_mac023_start15, mte_mac123_start15;
  reg mte_mac01_start15, mte_mac02_start15, mte_mac03_start15, mte_mac12_start15, mte_mac13_start15, mte_mac23_start15;
  reg mte_mac0_start15, mte_mac1_start15, mte_mac2_start15, mte_mac3_start15;
  reg mte_sys_hibernate15 ;
  reg mte_dma_start15 ;
  reg mte_cpu_start15 ;
  reg mte_mac_off_sleep_start15, mte_mac012_sleep_start15, mte_mac013_sleep_start15, mte_mac023_sleep_start15, mte_mac123_sleep_start15;
  reg mte_mac01_sleep_start15, mte_mac02_sleep_start15, mte_mac03_sleep_start15, mte_mac12_sleep_start15, mte_mac13_sleep_start15, mte_mac23_sleep_start15;
  reg mte_mac0_sleep_start15, mte_mac1_sleep_start15, mte_mac2_sleep_start15, mte_mac3_sleep_start15;
  reg mte_dma_sleep_start15;
  reg mte_mac_off_to_default15, mte_mac012_to_default15, mte_mac013_to_default15, mte_mac023_to_default15, mte_mac123_to_default15;
  reg mte_mac01_to_default15, mte_mac02_to_default15, mte_mac03_to_default15, mte_mac12_to_default15, mte_mac13_to_default15, mte_mac23_to_default15;
  reg mte_mac0_to_default15, mte_mac1_to_default15, mte_mac2_to_default15, mte_mac3_to_default15;
  reg mte_dma_isolate_dis15;
  reg mte_cpu_isolate_dis15;
  reg mte_sys_hibernate_to_default15;


  // Latch15 the CPU15 SLEEP15 invocation15
  always @( posedge pclk15 or negedge nprst15) 
  begin
    if(!nprst15)
      L1_ctrl_cpu_off_reg15 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg15 <= L1_ctrl_domain15[8];
  end

  // Create15 a pulse15 for sleep15 detection15 
  assign L1_ctrl_cpu_off_p15 =  L1_ctrl_domain15[8] && !L1_ctrl_cpu_off_reg15;
  
  // CPU15 sleep15 contol15 logic 
  // Shut15 off15 CPU15 when L1_ctrl_cpu_off_p15 is set
  // wake15 cpu15 when any interrupt15 is seen15  
  always @( posedge pclk15 or negedge nprst15) 
  begin
    if(!nprst15)
     cpu_shutoff_ctrl15 <= 1'b0;
    else if(cpu_shutoff_ctrl15 && int_source_h15)
     cpu_shutoff_ctrl15 <= 1'b0;
    else if (L1_ctrl_cpu_off_p15)
     cpu_shutoff_ctrl15 <= 1'b1;
  end
 
  // instantiate15 power15 contol15  block for uart15
  power_ctrl_sm15 i_urt_power_ctrl_sm15(
    .pclk15(pclk15),
    .nprst15(nprst15),
    .L1_module_req15(L1_ctrl_domain15[1]),
    .set_status_module15(set_status_urt15),
    .clr_status_module15(clr_status_urt15),
    .rstn_non_srpg_module15(rstn_non_srpg_urt_int15),
    .gate_clk_module15(gate_clk_urt_int15),
    .isolate_module15(isolate_urt_int15),
    .save_edge15(save_edge_urt_int15),
    .restore_edge15(restore_edge_urt_int15),
    .pwr1_on15(pwr1_on_urt_int15),
    .pwr2_on15(pwr2_on_urt_int15)
    );
  

  // instantiate15 power15 contol15  block for smc15
  power_ctrl_sm15 i_smc_power_ctrl_sm15(
    .pclk15(pclk15),
    .nprst15(nprst15),
    .L1_module_req15(L1_ctrl_domain15[2]),
    .set_status_module15(set_status_smc15),
    .clr_status_module15(clr_status_smc15),
    .rstn_non_srpg_module15(rstn_non_srpg_smc_int15),
    .gate_clk_module15(gate_clk_smc_int15),
    .isolate_module15(isolate_smc_int15),
    .save_edge15(save_edge_smc_int15),
    .restore_edge15(restore_edge_smc_int15),
    .pwr1_on15(pwr1_on_smc_int15),
    .pwr2_on15(pwr2_on_smc_int15)
    );

  // power15 control15 for macb015
  power_ctrl_sm15 i_macb0_power_ctrl_sm15(
    .pclk15(pclk15),
    .nprst15(nprst15),
    .L1_module_req15(L1_ctrl_domain15[3]),
    .set_status_module15(set_status_macb015),
    .clr_status_module15(clr_status_macb015),
    .rstn_non_srpg_module15(rstn_non_srpg_macb0_int15),
    .gate_clk_module15(gate_clk_macb0_int15),
    .isolate_module15(isolate_macb0_int15),
    .save_edge15(save_edge_macb0_int15),
    .restore_edge15(restore_edge_macb0_int15),
    .pwr1_on15(pwr1_on_macb0_int15),
    .pwr2_on15(pwr2_on_macb0_int15)
    );
  // power15 control15 for macb115
  power_ctrl_sm15 i_macb1_power_ctrl_sm15(
    .pclk15(pclk15),
    .nprst15(nprst15),
    .L1_module_req15(L1_ctrl_domain15[4]),
    .set_status_module15(set_status_macb115),
    .clr_status_module15(clr_status_macb115),
    .rstn_non_srpg_module15(rstn_non_srpg_macb1_int15),
    .gate_clk_module15(gate_clk_macb1_int15),
    .isolate_module15(isolate_macb1_int15),
    .save_edge15(save_edge_macb1_int15),
    .restore_edge15(restore_edge_macb1_int15),
    .pwr1_on15(pwr1_on_macb1_int15),
    .pwr2_on15(pwr2_on_macb1_int15)
    );
  // power15 control15 for macb215
  power_ctrl_sm15 i_macb2_power_ctrl_sm15(
    .pclk15(pclk15),
    .nprst15(nprst15),
    .L1_module_req15(L1_ctrl_domain15[5]),
    .set_status_module15(set_status_macb215),
    .clr_status_module15(clr_status_macb215),
    .rstn_non_srpg_module15(rstn_non_srpg_macb2_int15),
    .gate_clk_module15(gate_clk_macb2_int15),
    .isolate_module15(isolate_macb2_int15),
    .save_edge15(save_edge_macb2_int15),
    .restore_edge15(restore_edge_macb2_int15),
    .pwr1_on15(pwr1_on_macb2_int15),
    .pwr2_on15(pwr2_on_macb2_int15)
    );
  // power15 control15 for macb315
  power_ctrl_sm15 i_macb3_power_ctrl_sm15(
    .pclk15(pclk15),
    .nprst15(nprst15),
    .L1_module_req15(L1_ctrl_domain15[6]),
    .set_status_module15(set_status_macb315),
    .clr_status_module15(clr_status_macb315),
    .rstn_non_srpg_module15(rstn_non_srpg_macb3_int15),
    .gate_clk_module15(gate_clk_macb3_int15),
    .isolate_module15(isolate_macb3_int15),
    .save_edge15(save_edge_macb3_int15),
    .restore_edge15(restore_edge_macb3_int15),
    .pwr1_on15(pwr1_on_macb3_int15),
    .pwr2_on15(pwr2_on_macb3_int15)
    );
  // power15 control15 for dma15
  power_ctrl_sm15 i_dma_power_ctrl_sm15(
    .pclk15(pclk15),
    .nprst15(nprst15),
    .L1_module_req15(L1_ctrl_domain15[7]),
    .set_status_module15(set_status_dma15),
    .clr_status_module15(clr_status_dma15),
    .rstn_non_srpg_module15(rstn_non_srpg_dma_int15),
    .gate_clk_module15(gate_clk_dma_int15),
    .isolate_module15(isolate_dma_int15),
    .save_edge15(save_edge_dma_int15),
    .restore_edge15(restore_edge_dma_int15),
    .pwr1_on15(pwr1_on_dma_int15),
    .pwr2_on15(pwr2_on_dma_int15)
    );
  // power15 control15 for CPU15
  power_ctrl_sm15 i_cpu_power_ctrl_sm15(
    .pclk15(pclk15),
    .nprst15(nprst15),
    .L1_module_req15(cpu_shutoff_ctrl15),
    .set_status_module15(set_status_cpu15),
    .clr_status_module15(clr_status_cpu15),
    .rstn_non_srpg_module15(rstn_non_srpg_cpu_int15),
    .gate_clk_module15(gate_clk_cpu_int15),
    .isolate_module15(isolate_cpu_int15),
    .save_edge15(save_edge_cpu_int15),
    .restore_edge15(restore_edge_cpu_int15),
    .pwr1_on15(pwr1_on_cpu_int15),
    .pwr2_on15(pwr2_on_cpu_int15)
    );

  assign valid_reg_write15 =  (psel15 && pwrite15 && penable15);
  assign valid_reg_read15  =  (psel15 && (!pwrite15) && penable15);

  assign L1_ctrl_access15  =  (paddr15[15:0] == 16'b0000000000000100); 
  assign L1_status_access15 = (paddr15[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access15 =   (paddr15[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access15 = (paddr15[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control15 and status register
  always @(*)
  begin  
    if(valid_reg_read15 && L1_ctrl_access15) 
      prdata15 = L1_ctrl_reg15;
    else if (valid_reg_read15 && L1_status_access15)
      prdata15 = L1_status_reg15;
    else if (valid_reg_read15 && pcm_int_mask_access15)
      prdata15 = pcm_mask_reg15;
    else if (valid_reg_read15 && pcm_int_status_access15)
      prdata15 = pcm_status_reg15;
    else 
      prdata15 = 0;
  end

  assign set_status_mem15 =  (set_status_macb015 && set_status_macb115 && set_status_macb215 &&
                            set_status_macb315 && set_status_dma15 && set_status_cpu15);

  assign clr_status_mem15 =  (clr_status_macb015 && clr_status_macb115 && clr_status_macb215 &&
                            clr_status_macb315 && clr_status_dma15 && clr_status_cpu15);

  assign set_status_alut15 = (set_status_macb015 && set_status_macb115 && set_status_macb215 && set_status_macb315);

  assign clr_status_alut15 = (clr_status_macb015 || clr_status_macb115 || clr_status_macb215  || clr_status_macb315);

  // Write accesses to the control15 and status register
 
  always @(posedge pclk15 or negedge nprst15)
  begin
    if (!nprst15) begin
      L1_ctrl_reg15   <= 0;
      L1_status_reg15 <= 0;
      pcm_mask_reg15 <= 0;
    end else begin
      // CTRL15 reg updates15
      if (valid_reg_write15 && L1_ctrl_access15) 
        L1_ctrl_reg15 <= pwdata15; // Writes15 to the ctrl15 reg
      if (valid_reg_write15 && pcm_int_mask_access15) 
        pcm_mask_reg15 <= pwdata15; // Writes15 to the ctrl15 reg

      if (set_status_urt15 == 1'b1)  
        L1_status_reg15[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt15 == 1'b1) 
        L1_status_reg15[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc15 == 1'b1) 
        L1_status_reg15[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc15 == 1'b1) 
        L1_status_reg15[2] <= 1'b0; // Clear the status bit

      if (set_status_macb015 == 1'b1)  
        L1_status_reg15[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb015 == 1'b1) 
        L1_status_reg15[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb115 == 1'b1)  
        L1_status_reg15[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb115 == 1'b1) 
        L1_status_reg15[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb215 == 1'b1)  
        L1_status_reg15[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb215 == 1'b1) 
        L1_status_reg15[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb315 == 1'b1)  
        L1_status_reg15[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb315 == 1'b1) 
        L1_status_reg15[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma15 == 1'b1)  
        L1_status_reg15[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma15 == 1'b1) 
        L1_status_reg15[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu15 == 1'b1)  
        L1_status_reg15[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu15 == 1'b1) 
        L1_status_reg15[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut15 == 1'b1)  
        L1_status_reg15[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut15 == 1'b1) 
        L1_status_reg15[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem15 == 1'b1)  
        L1_status_reg15[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem15 == 1'b1) 
        L1_status_reg15[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused15 bits of pcm_status_reg15 are tied15 to 0
  always @(posedge pclk15 or negedge nprst15)
  begin
    if (!nprst15)
      pcm_status_reg15[31:4] <= 'b0;
    else  
      pcm_status_reg15[31:4] <= pcm_status_reg15[31:4];
  end
  
  // interrupt15 only of h/w assisted15 wakeup
  // MAC15 3
  always @(posedge pclk15 or negedge nprst15)
  begin
    if(!nprst15)
      pcm_status_reg15[3] <= 1'b0;
    else if (valid_reg_write15 && pcm_int_status_access15) 
      pcm_status_reg15[3] <= pwdata15[3];
    else if (macb3_wakeup15 & ~pcm_mask_reg15[3])
      pcm_status_reg15[3] <= 1'b1;
    else if (valid_reg_read15 && pcm_int_status_access15) 
      pcm_status_reg15[3] <= 1'b0;
    else
      pcm_status_reg15[3] <= pcm_status_reg15[3];
  end  
   
  // MAC15 2
  always @(posedge pclk15 or negedge nprst15)
  begin
    if(!nprst15)
      pcm_status_reg15[2] <= 1'b0;
    else if (valid_reg_write15 && pcm_int_status_access15) 
      pcm_status_reg15[2] <= pwdata15[2];
    else if (macb2_wakeup15 & ~pcm_mask_reg15[2])
      pcm_status_reg15[2] <= 1'b1;
    else if (valid_reg_read15 && pcm_int_status_access15) 
      pcm_status_reg15[2] <= 1'b0;
    else
      pcm_status_reg15[2] <= pcm_status_reg15[2];
  end  

  // MAC15 1
  always @(posedge pclk15 or negedge nprst15)
  begin
    if(!nprst15)
      pcm_status_reg15[1] <= 1'b0;
    else if (valid_reg_write15 && pcm_int_status_access15) 
      pcm_status_reg15[1] <= pwdata15[1];
    else if (macb1_wakeup15 & ~pcm_mask_reg15[1])
      pcm_status_reg15[1] <= 1'b1;
    else if (valid_reg_read15 && pcm_int_status_access15) 
      pcm_status_reg15[1] <= 1'b0;
    else
      pcm_status_reg15[1] <= pcm_status_reg15[1];
  end  
   
  // MAC15 0
  always @(posedge pclk15 or negedge nprst15)
  begin
    if(!nprst15)
      pcm_status_reg15[0] <= 1'b0;
    else if (valid_reg_write15 && pcm_int_status_access15) 
      pcm_status_reg15[0] <= pwdata15[0];
    else if (macb0_wakeup15 & ~pcm_mask_reg15[0])
      pcm_status_reg15[0] <= 1'b1;
    else if (valid_reg_read15 && pcm_int_status_access15) 
      pcm_status_reg15[0] <= 1'b0;
    else
      pcm_status_reg15[0] <= pcm_status_reg15[0];
  end  

  assign pcm_macb_wakeup_int15 = |pcm_status_reg15;

  reg [31:0] L1_ctrl_reg115;
  always @(posedge pclk15 or negedge nprst15)
  begin
    if(!nprst15)
      L1_ctrl_reg115 <= 0;
    else
      L1_ctrl_reg115 <= L1_ctrl_reg15;
  end

  // Program15 mode decode
  always @(L1_ctrl_reg15 or L1_ctrl_reg115 or int_source_h15 or cpu_shutoff_ctrl15) begin
    mte_smc_start15 = 0;
    mte_uart_start15 = 0;
    mte_smc_uart_start15  = 0;
    mte_mac_off_start15  = 0;
    mte_mac012_start15 = 0;
    mte_mac013_start15 = 0;
    mte_mac023_start15 = 0;
    mte_mac123_start15 = 0;
    mte_mac01_start15 = 0;
    mte_mac02_start15 = 0;
    mte_mac03_start15 = 0;
    mte_mac12_start15 = 0;
    mte_mac13_start15 = 0;
    mte_mac23_start15 = 0;
    mte_mac0_start15 = 0;
    mte_mac1_start15 = 0;
    mte_mac2_start15 = 0;
    mte_mac3_start15 = 0;
    mte_sys_hibernate15 = 0 ;
    mte_dma_start15 = 0 ;
    mte_cpu_start15 = 0 ;

    mte_mac0_sleep_start15 = (L1_ctrl_reg15 ==  'h14) && (L1_ctrl_reg115 == 'h4 );
    mte_mac1_sleep_start15 = (L1_ctrl_reg15 ==  'h14) && (L1_ctrl_reg115 == 'h5 ); 
    mte_mac2_sleep_start15 = (L1_ctrl_reg15 ==  'h14) && (L1_ctrl_reg115 == 'h6 ); 
    mte_mac3_sleep_start15 = (L1_ctrl_reg15 ==  'h14) && (L1_ctrl_reg115 == 'h7 ); 
    mte_mac01_sleep_start15 = (L1_ctrl_reg15 ==  'h14) && (L1_ctrl_reg115 == 'h8 ); 
    mte_mac02_sleep_start15 = (L1_ctrl_reg15 ==  'h14) && (L1_ctrl_reg115 == 'h9 ); 
    mte_mac03_sleep_start15 = (L1_ctrl_reg15 ==  'h14) && (L1_ctrl_reg115 == 'hA ); 
    mte_mac12_sleep_start15 = (L1_ctrl_reg15 ==  'h14) && (L1_ctrl_reg115 == 'hB ); 
    mte_mac13_sleep_start15 = (L1_ctrl_reg15 ==  'h14) && (L1_ctrl_reg115 == 'hC ); 
    mte_mac23_sleep_start15 = (L1_ctrl_reg15 ==  'h14) && (L1_ctrl_reg115 == 'hD ); 
    mte_mac012_sleep_start15 = (L1_ctrl_reg15 ==  'h14) && (L1_ctrl_reg115 == 'hE ); 
    mte_mac013_sleep_start15 = (L1_ctrl_reg15 ==  'h14) && (L1_ctrl_reg115 == 'hF ); 
    mte_mac023_sleep_start15 = (L1_ctrl_reg15 ==  'h14) && (L1_ctrl_reg115 == 'h10 ); 
    mte_mac123_sleep_start15 = (L1_ctrl_reg15 ==  'h14) && (L1_ctrl_reg115 == 'h11 ); 
    mte_mac_off_sleep_start15 =  (L1_ctrl_reg15 == 'h14) && (L1_ctrl_reg115 == 'h12 );
    mte_dma_sleep_start15 =  (L1_ctrl_reg15 == 'h14) && (L1_ctrl_reg115 == 'h13 );

    mte_pm_uart_to_default_start15 = (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'h1);
    mte_pm_smc_to_default_start15 = (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'h2);
    mte_pm_smc_uart_to_default_start15 = (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'h3); 
    mte_mac0_to_default15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'h4); 
    mte_mac1_to_default15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'h5); 
    mte_mac2_to_default15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'h6); 
    mte_mac3_to_default15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'h7); 
    mte_mac01_to_default15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'h8); 
    mte_mac02_to_default15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'h9); 
    mte_mac03_to_default15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'hA); 
    mte_mac12_to_default15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'hB); 
    mte_mac13_to_default15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'hC); 
    mte_mac23_to_default15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'hD); 
    mte_mac012_to_default15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'hE); 
    mte_mac013_to_default15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'hF); 
    mte_mac023_to_default15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'h10); 
    mte_mac123_to_default15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'h11); 
    mte_mac_off_to_default15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'h12); 
    mte_dma_isolate_dis15 =  (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'h13); 
    mte_cpu_isolate_dis15 =  (int_source_h15) && (cpu_shutoff_ctrl15) && (L1_ctrl_reg15 != 'h15);
    mte_sys_hibernate_to_default15 = (L1_ctrl_reg15 == 32'h0) && (L1_ctrl_reg115 == 'h15); 

   
    if (L1_ctrl_reg115 == 'h0) begin // This15 check is to make mte_cpu_start15
                                   // is set only when you from default state 
      case (L1_ctrl_reg15)
        'h0 : L1_ctrl_domain15 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain15 = 32'h2; // PM_uart15
                mte_uart_start15 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain15 = 32'h4; // PM_smc15
                mte_smc_start15 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain15 = 32'h6; // PM_smc_uart15
                mte_smc_uart_start15 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain15 = 32'h8; //  PM_macb015
                mte_mac0_start15 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain15 = 32'h10; //  PM_macb115
                mte_mac1_start15 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain15 = 32'h20; //  PM_macb215
                mte_mac2_start15 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain15 = 32'h40; //  PM_macb315
                mte_mac3_start15 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain15 = 32'h18; //  PM_macb0115
                mte_mac01_start15 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain15 = 32'h28; //  PM_macb0215
                mte_mac02_start15 = 1;
              end
        'hA : begin  
                L1_ctrl_domain15 = 32'h48; //  PM_macb0315
                mte_mac03_start15 = 1;
              end
        'hB : begin  
                L1_ctrl_domain15 = 32'h30; //  PM_macb1215
                mte_mac12_start15 = 1;
              end
        'hC : begin  
                L1_ctrl_domain15 = 32'h50; //  PM_macb1315
                mte_mac13_start15 = 1;
              end
        'hD : begin  
                L1_ctrl_domain15 = 32'h60; //  PM_macb2315
                mte_mac23_start15 = 1;
              end
        'hE : begin  
                L1_ctrl_domain15 = 32'h38; //  PM_macb01215
                mte_mac012_start15 = 1;
              end
        'hF : begin  
                L1_ctrl_domain15 = 32'h58; //  PM_macb01315
                mte_mac013_start15 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain15 = 32'h68; //  PM_macb02315
                mte_mac023_start15 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain15 = 32'h70; //  PM_macb12315
                mte_mac123_start15 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain15 = 32'h78; //  PM_macb_off15
                mte_mac_off_start15 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain15 = 32'h80; //  PM_dma15
                mte_dma_start15 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain15 = 32'h100; //  PM_cpu_sleep15
                mte_cpu_start15 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain15 = 32'h1FE; //  PM_hibernate15
                mte_sys_hibernate15 = 1;
              end
         default: L1_ctrl_domain15 = 32'h0;
      endcase
    end
  end


  wire to_default15 = (L1_ctrl_reg15 == 0);

  // Scan15 mode gating15 of power15 and isolation15 control15 signals15
  //SMC15
  assign rstn_non_srpg_smc15  = (scan_mode15 == 1'b0) ? rstn_non_srpg_smc_int15 : 1'b1;  
  assign gate_clk_smc15       = (scan_mode15 == 1'b0) ? gate_clk_smc_int15 : 1'b0;     
  assign isolate_smc15        = (scan_mode15 == 1'b0) ? isolate_smc_int15 : 1'b0;      
  assign pwr1_on_smc15        = (scan_mode15 == 1'b0) ? pwr1_on_smc_int15 : 1'b1;       
  assign pwr2_on_smc15        = (scan_mode15 == 1'b0) ? pwr2_on_smc_int15 : 1'b1;       
  assign pwr1_off_smc15       = (scan_mode15 == 1'b0) ? (!pwr1_on_smc_int15) : 1'b0;       
  assign pwr2_off_smc15       = (scan_mode15 == 1'b0) ? (!pwr2_on_smc_int15) : 1'b0;       
  assign save_edge_smc15       = (scan_mode15 == 1'b0) ? (save_edge_smc_int15) : 1'b0;       
  assign restore_edge_smc15       = (scan_mode15 == 1'b0) ? (restore_edge_smc_int15) : 1'b0;       

  //URT15
  assign rstn_non_srpg_urt15  = (scan_mode15 == 1'b0) ?  rstn_non_srpg_urt_int15 : 1'b1;  
  assign gate_clk_urt15       = (scan_mode15 == 1'b0) ?  gate_clk_urt_int15      : 1'b0;     
  assign isolate_urt15        = (scan_mode15 == 1'b0) ?  isolate_urt_int15       : 1'b0;      
  assign pwr1_on_urt15        = (scan_mode15 == 1'b0) ?  pwr1_on_urt_int15       : 1'b1;       
  assign pwr2_on_urt15        = (scan_mode15 == 1'b0) ?  pwr2_on_urt_int15       : 1'b1;       
  assign pwr1_off_urt15       = (scan_mode15 == 1'b0) ?  (!pwr1_on_urt_int15)  : 1'b0;       
  assign pwr2_off_urt15       = (scan_mode15 == 1'b0) ?  (!pwr2_on_urt_int15)  : 1'b0;       
  assign save_edge_urt15       = (scan_mode15 == 1'b0) ? (save_edge_urt_int15) : 1'b0;       
  assign restore_edge_urt15       = (scan_mode15 == 1'b0) ? (restore_edge_urt_int15) : 1'b0;       

  //ETH015
  assign rstn_non_srpg_macb015 = (scan_mode15 == 1'b0) ?  rstn_non_srpg_macb0_int15 : 1'b1;  
  assign gate_clk_macb015       = (scan_mode15 == 1'b0) ?  gate_clk_macb0_int15      : 1'b0;     
  assign isolate_macb015        = (scan_mode15 == 1'b0) ?  isolate_macb0_int15       : 1'b0;      
  assign pwr1_on_macb015        = (scan_mode15 == 1'b0) ?  pwr1_on_macb0_int15       : 1'b1;       
  assign pwr2_on_macb015        = (scan_mode15 == 1'b0) ?  pwr2_on_macb0_int15       : 1'b1;       
  assign pwr1_off_macb015       = (scan_mode15 == 1'b0) ?  (!pwr1_on_macb0_int15)  : 1'b0;       
  assign pwr2_off_macb015       = (scan_mode15 == 1'b0) ?  (!pwr2_on_macb0_int15)  : 1'b0;       
  assign save_edge_macb015       = (scan_mode15 == 1'b0) ? (save_edge_macb0_int15) : 1'b0;       
  assign restore_edge_macb015       = (scan_mode15 == 1'b0) ? (restore_edge_macb0_int15) : 1'b0;       

  //ETH115
  assign rstn_non_srpg_macb115 = (scan_mode15 == 1'b0) ?  rstn_non_srpg_macb1_int15 : 1'b1;  
  assign gate_clk_macb115       = (scan_mode15 == 1'b0) ?  gate_clk_macb1_int15      : 1'b0;     
  assign isolate_macb115        = (scan_mode15 == 1'b0) ?  isolate_macb1_int15       : 1'b0;      
  assign pwr1_on_macb115        = (scan_mode15 == 1'b0) ?  pwr1_on_macb1_int15       : 1'b1;       
  assign pwr2_on_macb115        = (scan_mode15 == 1'b0) ?  pwr2_on_macb1_int15       : 1'b1;       
  assign pwr1_off_macb115       = (scan_mode15 == 1'b0) ?  (!pwr1_on_macb1_int15)  : 1'b0;       
  assign pwr2_off_macb115       = (scan_mode15 == 1'b0) ?  (!pwr2_on_macb1_int15)  : 1'b0;       
  assign save_edge_macb115       = (scan_mode15 == 1'b0) ? (save_edge_macb1_int15) : 1'b0;       
  assign restore_edge_macb115       = (scan_mode15 == 1'b0) ? (restore_edge_macb1_int15) : 1'b0;       

  //ETH215
  assign rstn_non_srpg_macb215 = (scan_mode15 == 1'b0) ?  rstn_non_srpg_macb2_int15 : 1'b1;  
  assign gate_clk_macb215       = (scan_mode15 == 1'b0) ?  gate_clk_macb2_int15      : 1'b0;     
  assign isolate_macb215        = (scan_mode15 == 1'b0) ?  isolate_macb2_int15       : 1'b0;      
  assign pwr1_on_macb215        = (scan_mode15 == 1'b0) ?  pwr1_on_macb2_int15       : 1'b1;       
  assign pwr2_on_macb215        = (scan_mode15 == 1'b0) ?  pwr2_on_macb2_int15       : 1'b1;       
  assign pwr1_off_macb215       = (scan_mode15 == 1'b0) ?  (!pwr1_on_macb2_int15)  : 1'b0;       
  assign pwr2_off_macb215       = (scan_mode15 == 1'b0) ?  (!pwr2_on_macb2_int15)  : 1'b0;       
  assign save_edge_macb215       = (scan_mode15 == 1'b0) ? (save_edge_macb2_int15) : 1'b0;       
  assign restore_edge_macb215       = (scan_mode15 == 1'b0) ? (restore_edge_macb2_int15) : 1'b0;       

  //ETH315
  assign rstn_non_srpg_macb315 = (scan_mode15 == 1'b0) ?  rstn_non_srpg_macb3_int15 : 1'b1;  
  assign gate_clk_macb315       = (scan_mode15 == 1'b0) ?  gate_clk_macb3_int15      : 1'b0;     
  assign isolate_macb315        = (scan_mode15 == 1'b0) ?  isolate_macb3_int15       : 1'b0;      
  assign pwr1_on_macb315        = (scan_mode15 == 1'b0) ?  pwr1_on_macb3_int15       : 1'b1;       
  assign pwr2_on_macb315        = (scan_mode15 == 1'b0) ?  pwr2_on_macb3_int15       : 1'b1;       
  assign pwr1_off_macb315       = (scan_mode15 == 1'b0) ?  (!pwr1_on_macb3_int15)  : 1'b0;       
  assign pwr2_off_macb315       = (scan_mode15 == 1'b0) ?  (!pwr2_on_macb3_int15)  : 1'b0;       
  assign save_edge_macb315       = (scan_mode15 == 1'b0) ? (save_edge_macb3_int15) : 1'b0;       
  assign restore_edge_macb315       = (scan_mode15 == 1'b0) ? (restore_edge_macb3_int15) : 1'b0;       

  // MEM15
  assign rstn_non_srpg_mem15 =   (rstn_non_srpg_macb015 && rstn_non_srpg_macb115 && rstn_non_srpg_macb215 &&
                                rstn_non_srpg_macb315 && rstn_non_srpg_dma15 && rstn_non_srpg_cpu15 && rstn_non_srpg_urt15 &&
                                rstn_non_srpg_smc15);

  assign gate_clk_mem15 =  (gate_clk_macb015 && gate_clk_macb115 && gate_clk_macb215 &&
                            gate_clk_macb315 && gate_clk_dma15 && gate_clk_cpu15 && gate_clk_urt15 && gate_clk_smc15);

  assign isolate_mem15  = (isolate_macb015 && isolate_macb115 && isolate_macb215 &&
                         isolate_macb315 && isolate_dma15 && isolate_cpu15 && isolate_urt15 && isolate_smc15);


  assign pwr1_on_mem15        =   ~pwr1_off_mem15;

  assign pwr2_on_mem15        =   ~pwr2_off_mem15;

  assign pwr1_off_mem15       =  (pwr1_off_macb015 && pwr1_off_macb115 && pwr1_off_macb215 &&
                                 pwr1_off_macb315 && pwr1_off_dma15 && pwr1_off_cpu15 && pwr1_off_urt15 && pwr1_off_smc15);


  assign pwr2_off_mem15       =  (pwr2_off_macb015 && pwr2_off_macb115 && pwr2_off_macb215 &&
                                pwr2_off_macb315 && pwr2_off_dma15 && pwr2_off_cpu15 && pwr2_off_urt15 && pwr2_off_smc15);

  assign save_edge_mem15      =  (save_edge_macb015 && save_edge_macb115 && save_edge_macb215 &&
                                save_edge_macb315 && save_edge_dma15 && save_edge_cpu15 && save_edge_smc15 && save_edge_urt15);

  assign restore_edge_mem15   =  (restore_edge_macb015 && restore_edge_macb115 && restore_edge_macb215  &&
                                restore_edge_macb315 && restore_edge_dma15 && restore_edge_cpu15 && restore_edge_urt15 &&
                                restore_edge_smc15);

  assign standby_mem015 = pwr1_off_macb015 && (~ (pwr1_off_macb015 && pwr1_off_macb115 && pwr1_off_macb215 && pwr1_off_macb315 && pwr1_off_urt15 && pwr1_off_smc15 && pwr1_off_dma15 && pwr1_off_cpu15));
  assign standby_mem115 = pwr1_off_macb115 && (~ (pwr1_off_macb015 && pwr1_off_macb115 && pwr1_off_macb215 && pwr1_off_macb315 && pwr1_off_urt15 && pwr1_off_smc15 && pwr1_off_dma15 && pwr1_off_cpu15));
  assign standby_mem215 = pwr1_off_macb215 && (~ (pwr1_off_macb015 && pwr1_off_macb115 && pwr1_off_macb215 && pwr1_off_macb315 && pwr1_off_urt15 && pwr1_off_smc15 && pwr1_off_dma15 && pwr1_off_cpu15));
  assign standby_mem315 = pwr1_off_macb315 && (~ (pwr1_off_macb015 && pwr1_off_macb115 && pwr1_off_macb215 && pwr1_off_macb315 && pwr1_off_urt15 && pwr1_off_smc15 && pwr1_off_dma15 && pwr1_off_cpu15));

  assign pwr1_off_mem015 = pwr1_off_mem15;
  assign pwr1_off_mem115 = pwr1_off_mem15;
  assign pwr1_off_mem215 = pwr1_off_mem15;
  assign pwr1_off_mem315 = pwr1_off_mem15;

  assign rstn_non_srpg_alut15  =  (rstn_non_srpg_macb015 && rstn_non_srpg_macb115 && rstn_non_srpg_macb215 && rstn_non_srpg_macb315);


   assign gate_clk_alut15       =  (gate_clk_macb015 && gate_clk_macb115 && gate_clk_macb215 && gate_clk_macb315);


    assign isolate_alut15        =  (isolate_macb015 && isolate_macb115 && isolate_macb215 && isolate_macb315);


    assign pwr1_on_alut15        =  (pwr1_on_macb015 || pwr1_on_macb115 || pwr1_on_macb215 || pwr1_on_macb315);


    assign pwr2_on_alut15        =  (pwr2_on_macb015 || pwr2_on_macb115 || pwr2_on_macb215 || pwr2_on_macb315);


    assign pwr1_off_alut15       =  (pwr1_off_macb015 && pwr1_off_macb115 && pwr1_off_macb215 && pwr1_off_macb315);


    assign pwr2_off_alut15       =  (pwr2_off_macb015 && pwr2_off_macb115 && pwr2_off_macb215 && pwr2_off_macb315);


    assign save_edge_alut15      =  (save_edge_macb015 && save_edge_macb115 && save_edge_macb215 && save_edge_macb315);


    assign restore_edge_alut15   =  (restore_edge_macb015 || restore_edge_macb115 || restore_edge_macb215 ||
                                   restore_edge_macb315) && save_alut_tmp15;

     // alut15 power15 off15 detection15
  always @(posedge pclk15 or negedge nprst15) begin
    if (!nprst15) 
       save_alut_tmp15 <= 0;
    else if (restore_edge_alut15)
       save_alut_tmp15 <= 0;
    else if (save_edge_alut15)
       save_alut_tmp15 <= 1;
  end

  //DMA15
  assign rstn_non_srpg_dma15 = (scan_mode15 == 1'b0) ?  rstn_non_srpg_dma_int15 : 1'b1;  
  assign gate_clk_dma15       = (scan_mode15 == 1'b0) ?  gate_clk_dma_int15      : 1'b0;     
  assign isolate_dma15        = (scan_mode15 == 1'b0) ?  isolate_dma_int15       : 1'b0;      
  assign pwr1_on_dma15        = (scan_mode15 == 1'b0) ?  pwr1_on_dma_int15       : 1'b1;       
  assign pwr2_on_dma15        = (scan_mode15 == 1'b0) ?  pwr2_on_dma_int15       : 1'b1;       
  assign pwr1_off_dma15       = (scan_mode15 == 1'b0) ?  (!pwr1_on_dma_int15)  : 1'b0;       
  assign pwr2_off_dma15       = (scan_mode15 == 1'b0) ?  (!pwr2_on_dma_int15)  : 1'b0;       
  assign save_edge_dma15       = (scan_mode15 == 1'b0) ? (save_edge_dma_int15) : 1'b0;       
  assign restore_edge_dma15       = (scan_mode15 == 1'b0) ? (restore_edge_dma_int15) : 1'b0;       

  //CPU15
  assign rstn_non_srpg_cpu15 = (scan_mode15 == 1'b0) ?  rstn_non_srpg_cpu_int15 : 1'b1;  
  assign gate_clk_cpu15       = (scan_mode15 == 1'b0) ?  gate_clk_cpu_int15      : 1'b0;     
  assign isolate_cpu15        = (scan_mode15 == 1'b0) ?  isolate_cpu_int15       : 1'b0;      
  assign pwr1_on_cpu15        = (scan_mode15 == 1'b0) ?  pwr1_on_cpu_int15       : 1'b1;       
  assign pwr2_on_cpu15        = (scan_mode15 == 1'b0) ?  pwr2_on_cpu_int15       : 1'b1;       
  assign pwr1_off_cpu15       = (scan_mode15 == 1'b0) ?  (!pwr1_on_cpu_int15)  : 1'b0;       
  assign pwr2_off_cpu15       = (scan_mode15 == 1'b0) ?  (!pwr2_on_cpu_int15)  : 1'b0;       
  assign save_edge_cpu15       = (scan_mode15 == 1'b0) ? (save_edge_cpu_int15) : 1'b0;       
  assign restore_edge_cpu15       = (scan_mode15 == 1'b0) ? (restore_edge_cpu_int15) : 1'b0;       



  // ASE15

   reg ase_core_12v15, ase_core_10v15, ase_core_08v15, ase_core_06v15;
   reg ase_macb0_12v15,ase_macb1_12v15,ase_macb2_12v15,ase_macb3_12v15;

    // core15 ase15

    // core15 at 1.0 v if (smc15 off15, urt15 off15, macb015 off15, macb115 off15, macb215 off15, macb315 off15
   // core15 at 0.8v if (mac01off15, macb02off15, macb03off15, macb12off15, mac13off15, mac23off15,
   // core15 at 0.6v if (mac012off15, mac013off15, mac023off15, mac123off15, mac0123off15
    // else core15 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb015 && pwr1_off_macb115 && pwr1_off_macb215 && pwr1_off_macb315) || // all mac15 off15
       (pwr1_off_macb315 && pwr1_off_macb215 && pwr1_off_macb115) || // mac123off15 
       (pwr1_off_macb315 && pwr1_off_macb215 && pwr1_off_macb015) || // mac023off15 
       (pwr1_off_macb315 && pwr1_off_macb115 && pwr1_off_macb015) || // mac013off15 
       (pwr1_off_macb215 && pwr1_off_macb115 && pwr1_off_macb015) )  // mac012off15 
       begin
         ase_core_12v15 = 0;
         ase_core_10v15 = 0;
         ase_core_08v15 = 0;
         ase_core_06v15 = 1;
       end
     else if( (pwr1_off_macb215 && pwr1_off_macb315) || // mac2315 off15
         (pwr1_off_macb315 && pwr1_off_macb115) || // mac13off15 
         (pwr1_off_macb115 && pwr1_off_macb215) || // mac12off15 
         (pwr1_off_macb315 && pwr1_off_macb015) || // mac03off15 
         (pwr1_off_macb215 && pwr1_off_macb015) || // mac02off15 
         (pwr1_off_macb115 && pwr1_off_macb015))  // mac01off15 
       begin
         ase_core_12v15 = 0;
         ase_core_10v15 = 0;
         ase_core_08v15 = 1;
         ase_core_06v15 = 0;
       end
     else if( (pwr1_off_smc15) || // smc15 off15
         (pwr1_off_macb015 ) || // mac0off15 
         (pwr1_off_macb115 ) || // mac1off15 
         (pwr1_off_macb215 ) || // mac2off15 
         (pwr1_off_macb315 ))  // mac3off15 
       begin
         ase_core_12v15 = 0;
         ase_core_10v15 = 1;
         ase_core_08v15 = 0;
         ase_core_06v15 = 0;
       end
     else if (pwr1_off_urt15)
       begin
         ase_core_12v15 = 1;
         ase_core_10v15 = 0;
         ase_core_08v15 = 0;
         ase_core_06v15 = 0;
       end
     else
       begin
         ase_core_12v15 = 1;
         ase_core_10v15 = 0;
         ase_core_08v15 = 0;
         ase_core_06v15 = 0;
       end
   end


   // cpu15
   // cpu15 @ 1.0v when macoff15, 
   // 
   reg ase_cpu_10v15, ase_cpu_12v15;
   always @(*) begin
    if(pwr1_off_cpu15) begin
     ase_cpu_12v15 = 1'b0;
     ase_cpu_10v15 = 1'b0;
    end
    else if(pwr1_off_macb015 || pwr1_off_macb115 || pwr1_off_macb215 || pwr1_off_macb315)
    begin
     ase_cpu_12v15 = 1'b0;
     ase_cpu_10v15 = 1'b1;
    end
    else
    begin
     ase_cpu_12v15 = 1'b1;
     ase_cpu_10v15 = 1'b0;
    end
   end

   // dma15
   // dma15 @v115.0 for macoff15, 

   reg ase_dma_10v15, ase_dma_12v15;
   always @(*) begin
    if(pwr1_off_dma15) begin
     ase_dma_12v15 = 1'b0;
     ase_dma_10v15 = 1'b0;
    end
    else if(pwr1_off_macb015 || pwr1_off_macb115 || pwr1_off_macb215 || pwr1_off_macb315)
    begin
     ase_dma_12v15 = 1'b0;
     ase_dma_10v15 = 1'b1;
    end
    else
    begin
     ase_dma_12v15 = 1'b1;
     ase_dma_10v15 = 1'b0;
    end
   end

   // alut15
   // @ v115.0 for macoff15

   reg ase_alut_10v15, ase_alut_12v15;
   always @(*) begin
    if(pwr1_off_alut15) begin
     ase_alut_12v15 = 1'b0;
     ase_alut_10v15 = 1'b0;
    end
    else if(pwr1_off_macb015 || pwr1_off_macb115 || pwr1_off_macb215 || pwr1_off_macb315)
    begin
     ase_alut_12v15 = 1'b0;
     ase_alut_10v15 = 1'b1;
    end
    else
    begin
     ase_alut_12v15 = 1'b1;
     ase_alut_10v15 = 1'b0;
    end
   end




   reg ase_uart_12v15;
   reg ase_uart_10v15;
   reg ase_uart_08v15;
   reg ase_uart_06v15;

   reg ase_smc_12v15;


   always @(*) begin
     if(pwr1_off_urt15) begin // uart15 off15
       ase_uart_08v15 = 1'b0;
       ase_uart_06v15 = 1'b0;
       ase_uart_10v15 = 1'b0;
       ase_uart_12v15 = 1'b0;
     end 
     else if( (pwr1_off_macb015 && pwr1_off_macb115 && pwr1_off_macb215 && pwr1_off_macb315) || // all mac15 off15
       (pwr1_off_macb315 && pwr1_off_macb215 && pwr1_off_macb115) || // mac123off15 
       (pwr1_off_macb315 && pwr1_off_macb215 && pwr1_off_macb015) || // mac023off15 
       (pwr1_off_macb315 && pwr1_off_macb115 && pwr1_off_macb015) || // mac013off15 
       (pwr1_off_macb215 && pwr1_off_macb115 && pwr1_off_macb015) )  // mac012off15 
     begin
       ase_uart_06v15 = 1'b1;
       ase_uart_08v15 = 1'b0;
       ase_uart_10v15 = 1'b0;
       ase_uart_12v15 = 1'b0;
     end
     else if( (pwr1_off_macb215 && pwr1_off_macb315) || // mac2315 off15
         (pwr1_off_macb315 && pwr1_off_macb115) || // mac13off15 
         (pwr1_off_macb115 && pwr1_off_macb215) || // mac12off15 
         (pwr1_off_macb315 && pwr1_off_macb015) || // mac03off15 
         (pwr1_off_macb115 && pwr1_off_macb015))  // mac01off15  
     begin
       ase_uart_06v15 = 1'b0;
       ase_uart_08v15 = 1'b1;
       ase_uart_10v15 = 1'b0;
       ase_uart_12v15 = 1'b0;
     end
     else if (pwr1_off_smc15 || pwr1_off_macb015 || pwr1_off_macb115 || pwr1_off_macb215 || pwr1_off_macb315) begin // smc15 off15
       ase_uart_08v15 = 1'b0;
       ase_uart_06v15 = 1'b0;
       ase_uart_10v15 = 1'b1;
       ase_uart_12v15 = 1'b0;
     end 
     else begin
       ase_uart_08v15 = 1'b0;
       ase_uart_06v15 = 1'b0;
       ase_uart_10v15 = 1'b0;
       ase_uart_12v15 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc15) begin
     if (pwr1_off_smc15)  // smc15 off15
       ase_smc_12v15 = 1'b0;
    else
       ase_smc_12v15 = 1'b1;
   end

   
   always @(pwr1_off_macb015) begin
     if (pwr1_off_macb015) // macb015 off15
       ase_macb0_12v15 = 1'b0;
     else
       ase_macb0_12v15 = 1'b1;
   end

   always @(pwr1_off_macb115) begin
     if (pwr1_off_macb115) // macb115 off15
       ase_macb1_12v15 = 1'b0;
     else
       ase_macb1_12v15 = 1'b1;
   end

   always @(pwr1_off_macb215) begin // macb215 off15
     if (pwr1_off_macb215) // macb215 off15
       ase_macb2_12v15 = 1'b0;
     else
       ase_macb2_12v15 = 1'b1;
   end

   always @(pwr1_off_macb315) begin // macb315 off15
     if (pwr1_off_macb315) // macb315 off15
       ase_macb3_12v15 = 1'b0;
     else
       ase_macb3_12v15 = 1'b1;
   end


   // core15 voltage15 for vco15
  assign core12v15 = ase_macb0_12v15 & ase_macb1_12v15 & ase_macb2_12v15 & ase_macb3_12v15;

  assign core10v15 =  (ase_macb0_12v15 & ase_macb1_12v15 & ase_macb2_12v15 & (!ase_macb3_12v15)) ||
                    (ase_macb0_12v15 & ase_macb1_12v15 & (!ase_macb2_12v15) & ase_macb3_12v15) ||
                    (ase_macb0_12v15 & (!ase_macb1_12v15) & ase_macb2_12v15 & ase_macb3_12v15) ||
                    ((!ase_macb0_12v15) & ase_macb1_12v15 & ase_macb2_12v15 & ase_macb3_12v15);

  assign core08v15 =  ((!ase_macb0_12v15) & (!ase_macb1_12v15) & (ase_macb2_12v15) & (ase_macb3_12v15)) ||
                    ((!ase_macb0_12v15) & (ase_macb1_12v15) & (!ase_macb2_12v15) & (ase_macb3_12v15)) ||
                    ((!ase_macb0_12v15) & (ase_macb1_12v15) & (ase_macb2_12v15) & (!ase_macb3_12v15)) ||
                    ((ase_macb0_12v15) & (!ase_macb1_12v15) & (!ase_macb2_12v15) & (ase_macb3_12v15)) ||
                    ((ase_macb0_12v15) & (!ase_macb1_12v15) & (ase_macb2_12v15) & (!ase_macb3_12v15)) ||
                    ((ase_macb0_12v15) & (ase_macb1_12v15) & (!ase_macb2_12v15) & (!ase_macb3_12v15));

  assign core06v15 =  ((!ase_macb0_12v15) & (!ase_macb1_12v15) & (!ase_macb2_12v15) & (ase_macb3_12v15)) ||
                    ((!ase_macb0_12v15) & (!ase_macb1_12v15) & (ase_macb2_12v15) & (!ase_macb3_12v15)) ||
                    ((!ase_macb0_12v15) & (ase_macb1_12v15) & (!ase_macb2_12v15) & (!ase_macb3_12v15)) ||
                    ((ase_macb0_12v15) & (!ase_macb1_12v15) & (!ase_macb2_12v15) & (!ase_macb3_12v15)) ||
                    ((!ase_macb0_12v15) & (!ase_macb1_12v15) & (!ase_macb2_12v15) & (!ase_macb3_12v15)) ;



`ifdef LP_ABV_ON15
// psl15 default clock15 = (posedge pclk15);

// Cover15 a condition in which SMC15 is powered15 down
// and again15 powered15 up while UART15 is going15 into POWER15 down
// state or UART15 is already in POWER15 DOWN15 state
// psl15 cover_overlapping_smc_urt_115:
//    cover{fell15(pwr1_on_urt15);[*];fell15(pwr1_on_smc15);[*];
//    rose15(pwr1_on_smc15);[*];rose15(pwr1_on_urt15)};
//
// Cover15 a condition in which UART15 is powered15 down
// and again15 powered15 up while SMC15 is going15 into POWER15 down
// state or SMC15 is already in POWER15 DOWN15 state
// psl15 cover_overlapping_smc_urt_215:
//    cover{fell15(pwr1_on_smc15);[*];fell15(pwr1_on_urt15);[*];
//    rose15(pwr1_on_urt15);[*];rose15(pwr1_on_smc15)};
//


// Power15 Down15 UART15
// This15 gets15 triggered on rising15 edge of Gate15 signal15 for
// UART15 (gate_clk_urt15). In a next cycle after gate_clk_urt15,
// Isolate15 UART15(isolate_urt15) signal15 become15 HIGH15 (active).
// In 2nd cycle after gate_clk_urt15 becomes HIGH15, RESET15 for NON15
// SRPG15 FFs15(rstn_non_srpg_urt15) and POWER115 for UART15(pwr1_on_urt15) should 
// go15 LOW15. 
// This15 completes15 a POWER15 DOWN15. 

sequence s_power_down_urt15;
      (gate_clk_urt15 & !isolate_urt15 & rstn_non_srpg_urt15 & pwr1_on_urt15) 
  ##1 (gate_clk_urt15 & isolate_urt15 & rstn_non_srpg_urt15 & pwr1_on_urt15) 
  ##3 (gate_clk_urt15 & isolate_urt15 & !rstn_non_srpg_urt15 & !pwr1_on_urt15);
endsequence


property p_power_down_urt15;
   @(posedge pclk15)
    $rose(gate_clk_urt15) |=> s_power_down_urt15;
endproperty

output_power_down_urt15:
  assert property (p_power_down_urt15);


// Power15 UP15 UART15
// Sequence starts with , Rising15 edge of pwr1_on_urt15.
// Two15 clock15 cycle after this, isolate_urt15 should become15 LOW15 
// On15 the following15 clk15 gate_clk_urt15 should go15 low15.
// 5 cycles15 after  Rising15 edge of pwr1_on_urt15, rstn_non_srpg_urt15
// should become15 HIGH15
sequence s_power_up_urt15;
##30 (pwr1_on_urt15 & !isolate_urt15 & gate_clk_urt15 & !rstn_non_srpg_urt15) 
##1 (pwr1_on_urt15 & !isolate_urt15 & !gate_clk_urt15 & !rstn_non_srpg_urt15) 
##2 (pwr1_on_urt15 & !isolate_urt15 & !gate_clk_urt15 & rstn_non_srpg_urt15);
endsequence

property p_power_up_urt15;
   @(posedge pclk15)
  disable iff(!nprst15)
    (!pwr1_on_urt15 ##1 pwr1_on_urt15) |=> s_power_up_urt15;
endproperty

output_power_up_urt15:
  assert property (p_power_up_urt15);


// Power15 Down15 SMC15
// This15 gets15 triggered on rising15 edge of Gate15 signal15 for
// SMC15 (gate_clk_smc15). In a next cycle after gate_clk_smc15,
// Isolate15 SMC15(isolate_smc15) signal15 become15 HIGH15 (active).
// In 2nd cycle after gate_clk_smc15 becomes HIGH15, RESET15 for NON15
// SRPG15 FFs15(rstn_non_srpg_smc15) and POWER115 for SMC15(pwr1_on_smc15) should 
// go15 LOW15. 
// This15 completes15 a POWER15 DOWN15. 

sequence s_power_down_smc15;
      (gate_clk_smc15 & !isolate_smc15 & rstn_non_srpg_smc15 & pwr1_on_smc15) 
  ##1 (gate_clk_smc15 & isolate_smc15 & rstn_non_srpg_smc15 & pwr1_on_smc15) 
  ##3 (gate_clk_smc15 & isolate_smc15 & !rstn_non_srpg_smc15 & !pwr1_on_smc15);
endsequence


property p_power_down_smc15;
   @(posedge pclk15)
    $rose(gate_clk_smc15) |=> s_power_down_smc15;
endproperty

output_power_down_smc15:
  assert property (p_power_down_smc15);


// Power15 UP15 SMC15
// Sequence starts with , Rising15 edge of pwr1_on_smc15.
// Two15 clock15 cycle after this, isolate_smc15 should become15 LOW15 
// On15 the following15 clk15 gate_clk_smc15 should go15 low15.
// 5 cycles15 after  Rising15 edge of pwr1_on_smc15, rstn_non_srpg_smc15
// should become15 HIGH15
sequence s_power_up_smc15;
##30 (pwr1_on_smc15 & !isolate_smc15 & gate_clk_smc15 & !rstn_non_srpg_smc15) 
##1 (pwr1_on_smc15 & !isolate_smc15 & !gate_clk_smc15 & !rstn_non_srpg_smc15) 
##2 (pwr1_on_smc15 & !isolate_smc15 & !gate_clk_smc15 & rstn_non_srpg_smc15);
endsequence

property p_power_up_smc15;
   @(posedge pclk15)
  disable iff(!nprst15)
    (!pwr1_on_smc15 ##1 pwr1_on_smc15) |=> s_power_up_smc15;
endproperty

output_power_up_smc15:
  assert property (p_power_up_smc15);


// COVER15 SMC15 POWER15 DOWN15 AND15 UP15
cover_power_down_up_smc15: cover property (@(posedge pclk15)
(s_power_down_smc15 ##[5:180] s_power_up_smc15));



// COVER15 UART15 POWER15 DOWN15 AND15 UP15
cover_power_down_up_urt15: cover property (@(posedge pclk15)
(s_power_down_urt15 ##[5:180] s_power_up_urt15));

cover_power_down_urt15: cover property (@(posedge pclk15)
(s_power_down_urt15));

cover_power_up_urt15: cover property (@(posedge pclk15)
(s_power_up_urt15));




`ifdef PCM_ABV_ON15
//------------------------------------------------------------------------------
// Power15 Controller15 Formal15 Verification15 component.  Each power15 domain has a 
// separate15 instantiation15
//------------------------------------------------------------------------------

// need to assume that CPU15 will leave15 a minimum time between powering15 down and 
// back up.  In this example15, 10clks has been selected.
// psl15 config_min_uart_pd_time15 : assume always {rose15(L1_ctrl_domain15[1])} |-> { L1_ctrl_domain15[1][*10] } abort15(~nprst15);
// psl15 config_min_uart_pu_time15 : assume always {fell15(L1_ctrl_domain15[1])} |-> { !L1_ctrl_domain15[1][*10] } abort15(~nprst15);
// psl15 config_min_smc_pd_time15 : assume always {rose15(L1_ctrl_domain15[2])} |-> { L1_ctrl_domain15[2][*10] } abort15(~nprst15);
// psl15 config_min_smc_pu_time15 : assume always {fell15(L1_ctrl_domain15[2])} |-> { !L1_ctrl_domain15[2][*10] } abort15(~nprst15);

// UART15 VCOMP15 parameters15
   defparam i_uart_vcomp_domain15.ENABLE_SAVE_RESTORE_EDGE15   = 1;
   defparam i_uart_vcomp_domain15.ENABLE_EXT_PWR_CNTRL15       = 1;
   defparam i_uart_vcomp_domain15.REF_CLK_DEFINED15            = 0;
   defparam i_uart_vcomp_domain15.MIN_SHUTOFF_CYCLES15         = 4;
   defparam i_uart_vcomp_domain15.MIN_RESTORE_TO_ISO_CYCLES15  = 0;
   defparam i_uart_vcomp_domain15.MIN_SAVE_TO_SHUTOFF_CYCLES15 = 1;


   vcomp_domain15 i_uart_vcomp_domain15
   ( .ref_clk15(pclk15),
     .start_lps15(L1_ctrl_domain15[1] || !rstn_non_srpg_urt15),
     .rst_n15(nprst15),
     .ext_power_down15(L1_ctrl_domain15[1]),
     .iso_en15(isolate_urt15),
     .save_edge15(save_edge_urt15),
     .restore_edge15(restore_edge_urt15),
     .domain_shut_off15(pwr1_off_urt15),
     .domain_clk15(!gate_clk_urt15 && pclk15)
   );


// SMC15 VCOMP15 parameters15
   defparam i_smc_vcomp_domain15.ENABLE_SAVE_RESTORE_EDGE15   = 1;
   defparam i_smc_vcomp_domain15.ENABLE_EXT_PWR_CNTRL15       = 1;
   defparam i_smc_vcomp_domain15.REF_CLK_DEFINED15            = 0;
   defparam i_smc_vcomp_domain15.MIN_SHUTOFF_CYCLES15         = 4;
   defparam i_smc_vcomp_domain15.MIN_RESTORE_TO_ISO_CYCLES15  = 0;
   defparam i_smc_vcomp_domain15.MIN_SAVE_TO_SHUTOFF_CYCLES15 = 1;


   vcomp_domain15 i_smc_vcomp_domain15
   ( .ref_clk15(pclk15),
     .start_lps15(L1_ctrl_domain15[2] || !rstn_non_srpg_smc15),
     .rst_n15(nprst15),
     .ext_power_down15(L1_ctrl_domain15[2]),
     .iso_en15(isolate_smc15),
     .save_edge15(save_edge_smc15),
     .restore_edge15(restore_edge_smc15),
     .domain_shut_off15(pwr1_off_smc15),
     .domain_clk15(!gate_clk_smc15 && pclk15)
   );

`endif

`endif



endmodule
