//File8 name   : power_ctrl8.v
//Title8       : Power8 Control8 Module8
//Created8     : 1999
//Description8 : Top8 level of power8 controller8
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

module power_ctrl8 (


    // Clocks8 & Reset8
    pclk8,
    nprst8,
    // APB8 programming8 interface
    paddr8,
    psel8,
    penable8,
    pwrite8,
    pwdata8,
    prdata8,
    // mac8 i/f,
    macb3_wakeup8,
    macb2_wakeup8,
    macb1_wakeup8,
    macb0_wakeup8,
    // Scan8 
    scan_in8,
    scan_en8,
    scan_mode8,
    scan_out8,
    // Module8 control8 outputs8
    int_source_h8,
    // SMC8
    rstn_non_srpg_smc8,
    gate_clk_smc8,
    isolate_smc8,
    save_edge_smc8,
    restore_edge_smc8,
    pwr1_on_smc8,
    pwr2_on_smc8,
    pwr1_off_smc8,
    pwr2_off_smc8,
    // URT8
    rstn_non_srpg_urt8,
    gate_clk_urt8,
    isolate_urt8,
    save_edge_urt8,
    restore_edge_urt8,
    pwr1_on_urt8,
    pwr2_on_urt8,
    pwr1_off_urt8,      
    pwr2_off_urt8,
    // ETH08
    rstn_non_srpg_macb08,
    gate_clk_macb08,
    isolate_macb08,
    save_edge_macb08,
    restore_edge_macb08,
    pwr1_on_macb08,
    pwr2_on_macb08,
    pwr1_off_macb08,      
    pwr2_off_macb08,
    // ETH18
    rstn_non_srpg_macb18,
    gate_clk_macb18,
    isolate_macb18,
    save_edge_macb18,
    restore_edge_macb18,
    pwr1_on_macb18,
    pwr2_on_macb18,
    pwr1_off_macb18,      
    pwr2_off_macb18,
    // ETH28
    rstn_non_srpg_macb28,
    gate_clk_macb28,
    isolate_macb28,
    save_edge_macb28,
    restore_edge_macb28,
    pwr1_on_macb28,
    pwr2_on_macb28,
    pwr1_off_macb28,      
    pwr2_off_macb28,
    // ETH38
    rstn_non_srpg_macb38,
    gate_clk_macb38,
    isolate_macb38,
    save_edge_macb38,
    restore_edge_macb38,
    pwr1_on_macb38,
    pwr2_on_macb38,
    pwr1_off_macb38,      
    pwr2_off_macb38,
    // DMA8
    rstn_non_srpg_dma8,
    gate_clk_dma8,
    isolate_dma8,
    save_edge_dma8,
    restore_edge_dma8,
    pwr1_on_dma8,
    pwr2_on_dma8,
    pwr1_off_dma8,      
    pwr2_off_dma8,
    // CPU8
    rstn_non_srpg_cpu8,
    gate_clk_cpu8,
    isolate_cpu8,
    save_edge_cpu8,
    restore_edge_cpu8,
    pwr1_on_cpu8,
    pwr2_on_cpu8,
    pwr1_off_cpu8,      
    pwr2_off_cpu8,
    // ALUT8
    rstn_non_srpg_alut8,
    gate_clk_alut8,
    isolate_alut8,
    save_edge_alut8,
    restore_edge_alut8,
    pwr1_on_alut8,
    pwr2_on_alut8,
    pwr1_off_alut8,      
    pwr2_off_alut8,
    // MEM8
    rstn_non_srpg_mem8,
    gate_clk_mem8,
    isolate_mem8,
    save_edge_mem8,
    restore_edge_mem8,
    pwr1_on_mem8,
    pwr2_on_mem8,
    pwr1_off_mem8,      
    pwr2_off_mem8,
    // core8 dvfs8 transitions8
    core06v8,
    core08v8,
    core10v8,
    core12v8,
    pcm_macb_wakeup_int8,
    // mte8 signals8
    mte_smc_start8,
    mte_uart_start8,
    mte_smc_uart_start8,  
    mte_pm_smc_to_default_start8, 
    mte_pm_uart_to_default_start8,
    mte_pm_smc_uart_to_default_start8

  );

  parameter STATE_IDLE_12V8 = 4'b0001;
  parameter STATE_06V8 = 4'b0010;
  parameter STATE_08V8 = 4'b0100;
  parameter STATE_10V8 = 4'b1000;

    // Clocks8 & Reset8
    input pclk8;
    input nprst8;
    // APB8 programming8 interface
    input [31:0] paddr8;
    input psel8  ;
    input penable8;
    input pwrite8 ;
    input [31:0] pwdata8;
    output [31:0] prdata8;
    // mac8
    input macb3_wakeup8;
    input macb2_wakeup8;
    input macb1_wakeup8;
    input macb0_wakeup8;
    // Scan8 
    input scan_in8;
    input scan_en8;
    input scan_mode8;
    output scan_out8;
    // Module8 control8 outputs8
    input int_source_h8;
    // SMC8
    output rstn_non_srpg_smc8 ;
    output gate_clk_smc8   ;
    output isolate_smc8   ;
    output save_edge_smc8   ;
    output restore_edge_smc8   ;
    output pwr1_on_smc8   ;
    output pwr2_on_smc8   ;
    output pwr1_off_smc8  ;
    output pwr2_off_smc8  ;
    // URT8
    output rstn_non_srpg_urt8 ;
    output gate_clk_urt8      ;
    output isolate_urt8       ;
    output save_edge_urt8   ;
    output restore_edge_urt8   ;
    output pwr1_on_urt8       ;
    output pwr2_on_urt8       ;
    output pwr1_off_urt8      ;
    output pwr2_off_urt8      ;
    // ETH08
    output rstn_non_srpg_macb08 ;
    output gate_clk_macb08      ;
    output isolate_macb08       ;
    output save_edge_macb08   ;
    output restore_edge_macb08   ;
    output pwr1_on_macb08       ;
    output pwr2_on_macb08       ;
    output pwr1_off_macb08      ;
    output pwr2_off_macb08      ;
    // ETH18
    output rstn_non_srpg_macb18 ;
    output gate_clk_macb18      ;
    output isolate_macb18       ;
    output save_edge_macb18   ;
    output restore_edge_macb18   ;
    output pwr1_on_macb18       ;
    output pwr2_on_macb18       ;
    output pwr1_off_macb18      ;
    output pwr2_off_macb18      ;
    // ETH28
    output rstn_non_srpg_macb28 ;
    output gate_clk_macb28      ;
    output isolate_macb28       ;
    output save_edge_macb28   ;
    output restore_edge_macb28   ;
    output pwr1_on_macb28       ;
    output pwr2_on_macb28       ;
    output pwr1_off_macb28      ;
    output pwr2_off_macb28      ;
    // ETH38
    output rstn_non_srpg_macb38 ;
    output gate_clk_macb38      ;
    output isolate_macb38       ;
    output save_edge_macb38   ;
    output restore_edge_macb38   ;
    output pwr1_on_macb38       ;
    output pwr2_on_macb38       ;
    output pwr1_off_macb38      ;
    output pwr2_off_macb38      ;
    // DMA8
    output rstn_non_srpg_dma8 ;
    output gate_clk_dma8      ;
    output isolate_dma8       ;
    output save_edge_dma8   ;
    output restore_edge_dma8   ;
    output pwr1_on_dma8       ;
    output pwr2_on_dma8       ;
    output pwr1_off_dma8      ;
    output pwr2_off_dma8      ;
    // CPU8
    output rstn_non_srpg_cpu8 ;
    output gate_clk_cpu8      ;
    output isolate_cpu8       ;
    output save_edge_cpu8   ;
    output restore_edge_cpu8   ;
    output pwr1_on_cpu8       ;
    output pwr2_on_cpu8       ;
    output pwr1_off_cpu8      ;
    output pwr2_off_cpu8      ;
    // ALUT8
    output rstn_non_srpg_alut8 ;
    output gate_clk_alut8      ;
    output isolate_alut8       ;
    output save_edge_alut8   ;
    output restore_edge_alut8   ;
    output pwr1_on_alut8       ;
    output pwr2_on_alut8       ;
    output pwr1_off_alut8      ;
    output pwr2_off_alut8      ;
    // MEM8
    output rstn_non_srpg_mem8 ;
    output gate_clk_mem8      ;
    output isolate_mem8       ;
    output save_edge_mem8   ;
    output restore_edge_mem8   ;
    output pwr1_on_mem8       ;
    output pwr2_on_mem8       ;
    output pwr1_off_mem8      ;
    output pwr2_off_mem8      ;


   // core8 transitions8 o/p
    output core06v8;
    output core08v8;
    output core10v8;
    output core12v8;
    output pcm_macb_wakeup_int8 ;
    //mode mte8  signals8
    output mte_smc_start8;
    output mte_uart_start8;
    output mte_smc_uart_start8;  
    output mte_pm_smc_to_default_start8; 
    output mte_pm_uart_to_default_start8;
    output mte_pm_smc_uart_to_default_start8;

    reg mte_smc_start8;
    reg mte_uart_start8;
    reg mte_smc_uart_start8;  
    reg mte_pm_smc_to_default_start8; 
    reg mte_pm_uart_to_default_start8;
    reg mte_pm_smc_uart_to_default_start8;

    reg [31:0] prdata8;

  wire valid_reg_write8  ;
  wire valid_reg_read8   ;
  wire L1_ctrl_access8   ;
  wire L1_status_access8 ;
  wire pcm_int_mask_access8;
  wire pcm_int_status_access8;
  wire standby_mem08      ;
  wire standby_mem18      ;
  wire standby_mem28      ;
  wire standby_mem38      ;
  wire pwr1_off_mem08;
  wire pwr1_off_mem18;
  wire pwr1_off_mem28;
  wire pwr1_off_mem38;
  
  // Control8 signals8
  wire set_status_smc8   ;
  wire clr_status_smc8   ;
  wire set_status_urt8   ;
  wire clr_status_urt8   ;
  wire set_status_macb08   ;
  wire clr_status_macb08   ;
  wire set_status_macb18   ;
  wire clr_status_macb18   ;
  wire set_status_macb28   ;
  wire clr_status_macb28   ;
  wire set_status_macb38   ;
  wire clr_status_macb38   ;
  wire set_status_dma8   ;
  wire clr_status_dma8   ;
  wire set_status_cpu8   ;
  wire clr_status_cpu8   ;
  wire set_status_alut8   ;
  wire clr_status_alut8   ;
  wire set_status_mem8   ;
  wire clr_status_mem8   ;


  // Status and Control8 registers
  reg [31:0]  L1_status_reg8;
  reg  [31:0] L1_ctrl_reg8  ;
  reg  [31:0] L1_ctrl_domain8  ;
  reg L1_ctrl_cpu_off_reg8;
  reg [31:0]  pcm_mask_reg8;
  reg [31:0]  pcm_status_reg8;

  // Signals8 gated8 in scan_mode8
  //SMC8
  wire  rstn_non_srpg_smc_int8;
  wire  gate_clk_smc_int8    ;     
  wire  isolate_smc_int8    ;       
  wire save_edge_smc_int8;
  wire restore_edge_smc_int8;
  wire  pwr1_on_smc_int8    ;      
  wire  pwr2_on_smc_int8    ;      


  //URT8
  wire   rstn_non_srpg_urt_int8;
  wire   gate_clk_urt_int8     ;     
  wire   isolate_urt_int8      ;       
  wire save_edge_urt_int8;
  wire restore_edge_urt_int8;
  wire   pwr1_on_urt_int8      ;      
  wire   pwr2_on_urt_int8      ;      

  // ETH08
  wire   rstn_non_srpg_macb0_int8;
  wire   gate_clk_macb0_int8     ;     
  wire   isolate_macb0_int8      ;       
  wire save_edge_macb0_int8;
  wire restore_edge_macb0_int8;
  wire   pwr1_on_macb0_int8      ;      
  wire   pwr2_on_macb0_int8      ;      
  // ETH18
  wire   rstn_non_srpg_macb1_int8;
  wire   gate_clk_macb1_int8     ;     
  wire   isolate_macb1_int8      ;       
  wire save_edge_macb1_int8;
  wire restore_edge_macb1_int8;
  wire   pwr1_on_macb1_int8      ;      
  wire   pwr2_on_macb1_int8      ;      
  // ETH28
  wire   rstn_non_srpg_macb2_int8;
  wire   gate_clk_macb2_int8     ;     
  wire   isolate_macb2_int8      ;       
  wire save_edge_macb2_int8;
  wire restore_edge_macb2_int8;
  wire   pwr1_on_macb2_int8      ;      
  wire   pwr2_on_macb2_int8      ;      
  // ETH38
  wire   rstn_non_srpg_macb3_int8;
  wire   gate_clk_macb3_int8     ;     
  wire   isolate_macb3_int8      ;       
  wire save_edge_macb3_int8;
  wire restore_edge_macb3_int8;
  wire   pwr1_on_macb3_int8      ;      
  wire   pwr2_on_macb3_int8      ;      

  // DMA8
  wire   rstn_non_srpg_dma_int8;
  wire   gate_clk_dma_int8     ;     
  wire   isolate_dma_int8      ;       
  wire save_edge_dma_int8;
  wire restore_edge_dma_int8;
  wire   pwr1_on_dma_int8      ;      
  wire   pwr2_on_dma_int8      ;      

  // CPU8
  wire   rstn_non_srpg_cpu_int8;
  wire   gate_clk_cpu_int8     ;     
  wire   isolate_cpu_int8      ;       
  wire save_edge_cpu_int8;
  wire restore_edge_cpu_int8;
  wire   pwr1_on_cpu_int8      ;      
  wire   pwr2_on_cpu_int8      ;  
  wire L1_ctrl_cpu_off_p8;    

  reg save_alut_tmp8;
  // DFS8 sm8

  reg cpu_shutoff_ctrl8;

  reg mte_mac_off_start8, mte_mac012_start8, mte_mac013_start8, mte_mac023_start8, mte_mac123_start8;
  reg mte_mac01_start8, mte_mac02_start8, mte_mac03_start8, mte_mac12_start8, mte_mac13_start8, mte_mac23_start8;
  reg mte_mac0_start8, mte_mac1_start8, mte_mac2_start8, mte_mac3_start8;
  reg mte_sys_hibernate8 ;
  reg mte_dma_start8 ;
  reg mte_cpu_start8 ;
  reg mte_mac_off_sleep_start8, mte_mac012_sleep_start8, mte_mac013_sleep_start8, mte_mac023_sleep_start8, mte_mac123_sleep_start8;
  reg mte_mac01_sleep_start8, mte_mac02_sleep_start8, mte_mac03_sleep_start8, mte_mac12_sleep_start8, mte_mac13_sleep_start8, mte_mac23_sleep_start8;
  reg mte_mac0_sleep_start8, mte_mac1_sleep_start8, mte_mac2_sleep_start8, mte_mac3_sleep_start8;
  reg mte_dma_sleep_start8;
  reg mte_mac_off_to_default8, mte_mac012_to_default8, mte_mac013_to_default8, mte_mac023_to_default8, mte_mac123_to_default8;
  reg mte_mac01_to_default8, mte_mac02_to_default8, mte_mac03_to_default8, mte_mac12_to_default8, mte_mac13_to_default8, mte_mac23_to_default8;
  reg mte_mac0_to_default8, mte_mac1_to_default8, mte_mac2_to_default8, mte_mac3_to_default8;
  reg mte_dma_isolate_dis8;
  reg mte_cpu_isolate_dis8;
  reg mte_sys_hibernate_to_default8;


  // Latch8 the CPU8 SLEEP8 invocation8
  always @( posedge pclk8 or negedge nprst8) 
  begin
    if(!nprst8)
      L1_ctrl_cpu_off_reg8 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg8 <= L1_ctrl_domain8[8];
  end

  // Create8 a pulse8 for sleep8 detection8 
  assign L1_ctrl_cpu_off_p8 =  L1_ctrl_domain8[8] && !L1_ctrl_cpu_off_reg8;
  
  // CPU8 sleep8 contol8 logic 
  // Shut8 off8 CPU8 when L1_ctrl_cpu_off_p8 is set
  // wake8 cpu8 when any interrupt8 is seen8  
  always @( posedge pclk8 or negedge nprst8) 
  begin
    if(!nprst8)
     cpu_shutoff_ctrl8 <= 1'b0;
    else if(cpu_shutoff_ctrl8 && int_source_h8)
     cpu_shutoff_ctrl8 <= 1'b0;
    else if (L1_ctrl_cpu_off_p8)
     cpu_shutoff_ctrl8 <= 1'b1;
  end
 
  // instantiate8 power8 contol8  block for uart8
  power_ctrl_sm8 i_urt_power_ctrl_sm8(
    .pclk8(pclk8),
    .nprst8(nprst8),
    .L1_module_req8(L1_ctrl_domain8[1]),
    .set_status_module8(set_status_urt8),
    .clr_status_module8(clr_status_urt8),
    .rstn_non_srpg_module8(rstn_non_srpg_urt_int8),
    .gate_clk_module8(gate_clk_urt_int8),
    .isolate_module8(isolate_urt_int8),
    .save_edge8(save_edge_urt_int8),
    .restore_edge8(restore_edge_urt_int8),
    .pwr1_on8(pwr1_on_urt_int8),
    .pwr2_on8(pwr2_on_urt_int8)
    );
  

  // instantiate8 power8 contol8  block for smc8
  power_ctrl_sm8 i_smc_power_ctrl_sm8(
    .pclk8(pclk8),
    .nprst8(nprst8),
    .L1_module_req8(L1_ctrl_domain8[2]),
    .set_status_module8(set_status_smc8),
    .clr_status_module8(clr_status_smc8),
    .rstn_non_srpg_module8(rstn_non_srpg_smc_int8),
    .gate_clk_module8(gate_clk_smc_int8),
    .isolate_module8(isolate_smc_int8),
    .save_edge8(save_edge_smc_int8),
    .restore_edge8(restore_edge_smc_int8),
    .pwr1_on8(pwr1_on_smc_int8),
    .pwr2_on8(pwr2_on_smc_int8)
    );

  // power8 control8 for macb08
  power_ctrl_sm8 i_macb0_power_ctrl_sm8(
    .pclk8(pclk8),
    .nprst8(nprst8),
    .L1_module_req8(L1_ctrl_domain8[3]),
    .set_status_module8(set_status_macb08),
    .clr_status_module8(clr_status_macb08),
    .rstn_non_srpg_module8(rstn_non_srpg_macb0_int8),
    .gate_clk_module8(gate_clk_macb0_int8),
    .isolate_module8(isolate_macb0_int8),
    .save_edge8(save_edge_macb0_int8),
    .restore_edge8(restore_edge_macb0_int8),
    .pwr1_on8(pwr1_on_macb0_int8),
    .pwr2_on8(pwr2_on_macb0_int8)
    );
  // power8 control8 for macb18
  power_ctrl_sm8 i_macb1_power_ctrl_sm8(
    .pclk8(pclk8),
    .nprst8(nprst8),
    .L1_module_req8(L1_ctrl_domain8[4]),
    .set_status_module8(set_status_macb18),
    .clr_status_module8(clr_status_macb18),
    .rstn_non_srpg_module8(rstn_non_srpg_macb1_int8),
    .gate_clk_module8(gate_clk_macb1_int8),
    .isolate_module8(isolate_macb1_int8),
    .save_edge8(save_edge_macb1_int8),
    .restore_edge8(restore_edge_macb1_int8),
    .pwr1_on8(pwr1_on_macb1_int8),
    .pwr2_on8(pwr2_on_macb1_int8)
    );
  // power8 control8 for macb28
  power_ctrl_sm8 i_macb2_power_ctrl_sm8(
    .pclk8(pclk8),
    .nprst8(nprst8),
    .L1_module_req8(L1_ctrl_domain8[5]),
    .set_status_module8(set_status_macb28),
    .clr_status_module8(clr_status_macb28),
    .rstn_non_srpg_module8(rstn_non_srpg_macb2_int8),
    .gate_clk_module8(gate_clk_macb2_int8),
    .isolate_module8(isolate_macb2_int8),
    .save_edge8(save_edge_macb2_int8),
    .restore_edge8(restore_edge_macb2_int8),
    .pwr1_on8(pwr1_on_macb2_int8),
    .pwr2_on8(pwr2_on_macb2_int8)
    );
  // power8 control8 for macb38
  power_ctrl_sm8 i_macb3_power_ctrl_sm8(
    .pclk8(pclk8),
    .nprst8(nprst8),
    .L1_module_req8(L1_ctrl_domain8[6]),
    .set_status_module8(set_status_macb38),
    .clr_status_module8(clr_status_macb38),
    .rstn_non_srpg_module8(rstn_non_srpg_macb3_int8),
    .gate_clk_module8(gate_clk_macb3_int8),
    .isolate_module8(isolate_macb3_int8),
    .save_edge8(save_edge_macb3_int8),
    .restore_edge8(restore_edge_macb3_int8),
    .pwr1_on8(pwr1_on_macb3_int8),
    .pwr2_on8(pwr2_on_macb3_int8)
    );
  // power8 control8 for dma8
  power_ctrl_sm8 i_dma_power_ctrl_sm8(
    .pclk8(pclk8),
    .nprst8(nprst8),
    .L1_module_req8(L1_ctrl_domain8[7]),
    .set_status_module8(set_status_dma8),
    .clr_status_module8(clr_status_dma8),
    .rstn_non_srpg_module8(rstn_non_srpg_dma_int8),
    .gate_clk_module8(gate_clk_dma_int8),
    .isolate_module8(isolate_dma_int8),
    .save_edge8(save_edge_dma_int8),
    .restore_edge8(restore_edge_dma_int8),
    .pwr1_on8(pwr1_on_dma_int8),
    .pwr2_on8(pwr2_on_dma_int8)
    );
  // power8 control8 for CPU8
  power_ctrl_sm8 i_cpu_power_ctrl_sm8(
    .pclk8(pclk8),
    .nprst8(nprst8),
    .L1_module_req8(cpu_shutoff_ctrl8),
    .set_status_module8(set_status_cpu8),
    .clr_status_module8(clr_status_cpu8),
    .rstn_non_srpg_module8(rstn_non_srpg_cpu_int8),
    .gate_clk_module8(gate_clk_cpu_int8),
    .isolate_module8(isolate_cpu_int8),
    .save_edge8(save_edge_cpu_int8),
    .restore_edge8(restore_edge_cpu_int8),
    .pwr1_on8(pwr1_on_cpu_int8),
    .pwr2_on8(pwr2_on_cpu_int8)
    );

  assign valid_reg_write8 =  (psel8 && pwrite8 && penable8);
  assign valid_reg_read8  =  (psel8 && (!pwrite8) && penable8);

  assign L1_ctrl_access8  =  (paddr8[15:0] == 16'b0000000000000100); 
  assign L1_status_access8 = (paddr8[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access8 =   (paddr8[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access8 = (paddr8[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control8 and status register
  always @(*)
  begin  
    if(valid_reg_read8 && L1_ctrl_access8) 
      prdata8 = L1_ctrl_reg8;
    else if (valid_reg_read8 && L1_status_access8)
      prdata8 = L1_status_reg8;
    else if (valid_reg_read8 && pcm_int_mask_access8)
      prdata8 = pcm_mask_reg8;
    else if (valid_reg_read8 && pcm_int_status_access8)
      prdata8 = pcm_status_reg8;
    else 
      prdata8 = 0;
  end

  assign set_status_mem8 =  (set_status_macb08 && set_status_macb18 && set_status_macb28 &&
                            set_status_macb38 && set_status_dma8 && set_status_cpu8);

  assign clr_status_mem8 =  (clr_status_macb08 && clr_status_macb18 && clr_status_macb28 &&
                            clr_status_macb38 && clr_status_dma8 && clr_status_cpu8);

  assign set_status_alut8 = (set_status_macb08 && set_status_macb18 && set_status_macb28 && set_status_macb38);

  assign clr_status_alut8 = (clr_status_macb08 || clr_status_macb18 || clr_status_macb28  || clr_status_macb38);

  // Write accesses to the control8 and status register
 
  always @(posedge pclk8 or negedge nprst8)
  begin
    if (!nprst8) begin
      L1_ctrl_reg8   <= 0;
      L1_status_reg8 <= 0;
      pcm_mask_reg8 <= 0;
    end else begin
      // CTRL8 reg updates8
      if (valid_reg_write8 && L1_ctrl_access8) 
        L1_ctrl_reg8 <= pwdata8; // Writes8 to the ctrl8 reg
      if (valid_reg_write8 && pcm_int_mask_access8) 
        pcm_mask_reg8 <= pwdata8; // Writes8 to the ctrl8 reg

      if (set_status_urt8 == 1'b1)  
        L1_status_reg8[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt8 == 1'b1) 
        L1_status_reg8[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc8 == 1'b1) 
        L1_status_reg8[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc8 == 1'b1) 
        L1_status_reg8[2] <= 1'b0; // Clear the status bit

      if (set_status_macb08 == 1'b1)  
        L1_status_reg8[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb08 == 1'b1) 
        L1_status_reg8[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb18 == 1'b1)  
        L1_status_reg8[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb18 == 1'b1) 
        L1_status_reg8[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb28 == 1'b1)  
        L1_status_reg8[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb28 == 1'b1) 
        L1_status_reg8[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb38 == 1'b1)  
        L1_status_reg8[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb38 == 1'b1) 
        L1_status_reg8[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma8 == 1'b1)  
        L1_status_reg8[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma8 == 1'b1) 
        L1_status_reg8[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu8 == 1'b1)  
        L1_status_reg8[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu8 == 1'b1) 
        L1_status_reg8[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut8 == 1'b1)  
        L1_status_reg8[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut8 == 1'b1) 
        L1_status_reg8[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem8 == 1'b1)  
        L1_status_reg8[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem8 == 1'b1) 
        L1_status_reg8[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused8 bits of pcm_status_reg8 are tied8 to 0
  always @(posedge pclk8 or negedge nprst8)
  begin
    if (!nprst8)
      pcm_status_reg8[31:4] <= 'b0;
    else  
      pcm_status_reg8[31:4] <= pcm_status_reg8[31:4];
  end
  
  // interrupt8 only of h/w assisted8 wakeup
  // MAC8 3
  always @(posedge pclk8 or negedge nprst8)
  begin
    if(!nprst8)
      pcm_status_reg8[3] <= 1'b0;
    else if (valid_reg_write8 && pcm_int_status_access8) 
      pcm_status_reg8[3] <= pwdata8[3];
    else if (macb3_wakeup8 & ~pcm_mask_reg8[3])
      pcm_status_reg8[3] <= 1'b1;
    else if (valid_reg_read8 && pcm_int_status_access8) 
      pcm_status_reg8[3] <= 1'b0;
    else
      pcm_status_reg8[3] <= pcm_status_reg8[3];
  end  
   
  // MAC8 2
  always @(posedge pclk8 or negedge nprst8)
  begin
    if(!nprst8)
      pcm_status_reg8[2] <= 1'b0;
    else if (valid_reg_write8 && pcm_int_status_access8) 
      pcm_status_reg8[2] <= pwdata8[2];
    else if (macb2_wakeup8 & ~pcm_mask_reg8[2])
      pcm_status_reg8[2] <= 1'b1;
    else if (valid_reg_read8 && pcm_int_status_access8) 
      pcm_status_reg8[2] <= 1'b0;
    else
      pcm_status_reg8[2] <= pcm_status_reg8[2];
  end  

  // MAC8 1
  always @(posedge pclk8 or negedge nprst8)
  begin
    if(!nprst8)
      pcm_status_reg8[1] <= 1'b0;
    else if (valid_reg_write8 && pcm_int_status_access8) 
      pcm_status_reg8[1] <= pwdata8[1];
    else if (macb1_wakeup8 & ~pcm_mask_reg8[1])
      pcm_status_reg8[1] <= 1'b1;
    else if (valid_reg_read8 && pcm_int_status_access8) 
      pcm_status_reg8[1] <= 1'b0;
    else
      pcm_status_reg8[1] <= pcm_status_reg8[1];
  end  
   
  // MAC8 0
  always @(posedge pclk8 or negedge nprst8)
  begin
    if(!nprst8)
      pcm_status_reg8[0] <= 1'b0;
    else if (valid_reg_write8 && pcm_int_status_access8) 
      pcm_status_reg8[0] <= pwdata8[0];
    else if (macb0_wakeup8 & ~pcm_mask_reg8[0])
      pcm_status_reg8[0] <= 1'b1;
    else if (valid_reg_read8 && pcm_int_status_access8) 
      pcm_status_reg8[0] <= 1'b0;
    else
      pcm_status_reg8[0] <= pcm_status_reg8[0];
  end  

  assign pcm_macb_wakeup_int8 = |pcm_status_reg8;

  reg [31:0] L1_ctrl_reg18;
  always @(posedge pclk8 or negedge nprst8)
  begin
    if(!nprst8)
      L1_ctrl_reg18 <= 0;
    else
      L1_ctrl_reg18 <= L1_ctrl_reg8;
  end

  // Program8 mode decode
  always @(L1_ctrl_reg8 or L1_ctrl_reg18 or int_source_h8 or cpu_shutoff_ctrl8) begin
    mte_smc_start8 = 0;
    mte_uart_start8 = 0;
    mte_smc_uart_start8  = 0;
    mte_mac_off_start8  = 0;
    mte_mac012_start8 = 0;
    mte_mac013_start8 = 0;
    mte_mac023_start8 = 0;
    mte_mac123_start8 = 0;
    mte_mac01_start8 = 0;
    mte_mac02_start8 = 0;
    mte_mac03_start8 = 0;
    mte_mac12_start8 = 0;
    mte_mac13_start8 = 0;
    mte_mac23_start8 = 0;
    mte_mac0_start8 = 0;
    mte_mac1_start8 = 0;
    mte_mac2_start8 = 0;
    mte_mac3_start8 = 0;
    mte_sys_hibernate8 = 0 ;
    mte_dma_start8 = 0 ;
    mte_cpu_start8 = 0 ;

    mte_mac0_sleep_start8 = (L1_ctrl_reg8 ==  'h14) && (L1_ctrl_reg18 == 'h4 );
    mte_mac1_sleep_start8 = (L1_ctrl_reg8 ==  'h14) && (L1_ctrl_reg18 == 'h5 ); 
    mte_mac2_sleep_start8 = (L1_ctrl_reg8 ==  'h14) && (L1_ctrl_reg18 == 'h6 ); 
    mte_mac3_sleep_start8 = (L1_ctrl_reg8 ==  'h14) && (L1_ctrl_reg18 == 'h7 ); 
    mte_mac01_sleep_start8 = (L1_ctrl_reg8 ==  'h14) && (L1_ctrl_reg18 == 'h8 ); 
    mte_mac02_sleep_start8 = (L1_ctrl_reg8 ==  'h14) && (L1_ctrl_reg18 == 'h9 ); 
    mte_mac03_sleep_start8 = (L1_ctrl_reg8 ==  'h14) && (L1_ctrl_reg18 == 'hA ); 
    mte_mac12_sleep_start8 = (L1_ctrl_reg8 ==  'h14) && (L1_ctrl_reg18 == 'hB ); 
    mte_mac13_sleep_start8 = (L1_ctrl_reg8 ==  'h14) && (L1_ctrl_reg18 == 'hC ); 
    mte_mac23_sleep_start8 = (L1_ctrl_reg8 ==  'h14) && (L1_ctrl_reg18 == 'hD ); 
    mte_mac012_sleep_start8 = (L1_ctrl_reg8 ==  'h14) && (L1_ctrl_reg18 == 'hE ); 
    mte_mac013_sleep_start8 = (L1_ctrl_reg8 ==  'h14) && (L1_ctrl_reg18 == 'hF ); 
    mte_mac023_sleep_start8 = (L1_ctrl_reg8 ==  'h14) && (L1_ctrl_reg18 == 'h10 ); 
    mte_mac123_sleep_start8 = (L1_ctrl_reg8 ==  'h14) && (L1_ctrl_reg18 == 'h11 ); 
    mte_mac_off_sleep_start8 =  (L1_ctrl_reg8 == 'h14) && (L1_ctrl_reg18 == 'h12 );
    mte_dma_sleep_start8 =  (L1_ctrl_reg8 == 'h14) && (L1_ctrl_reg18 == 'h13 );

    mte_pm_uart_to_default_start8 = (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'h1);
    mte_pm_smc_to_default_start8 = (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'h2);
    mte_pm_smc_uart_to_default_start8 = (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'h3); 
    mte_mac0_to_default8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'h4); 
    mte_mac1_to_default8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'h5); 
    mte_mac2_to_default8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'h6); 
    mte_mac3_to_default8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'h7); 
    mte_mac01_to_default8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'h8); 
    mte_mac02_to_default8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'h9); 
    mte_mac03_to_default8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'hA); 
    mte_mac12_to_default8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'hB); 
    mte_mac13_to_default8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'hC); 
    mte_mac23_to_default8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'hD); 
    mte_mac012_to_default8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'hE); 
    mte_mac013_to_default8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'hF); 
    mte_mac023_to_default8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'h10); 
    mte_mac123_to_default8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'h11); 
    mte_mac_off_to_default8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'h12); 
    mte_dma_isolate_dis8 =  (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'h13); 
    mte_cpu_isolate_dis8 =  (int_source_h8) && (cpu_shutoff_ctrl8) && (L1_ctrl_reg8 != 'h15);
    mte_sys_hibernate_to_default8 = (L1_ctrl_reg8 == 32'h0) && (L1_ctrl_reg18 == 'h15); 

   
    if (L1_ctrl_reg18 == 'h0) begin // This8 check is to make mte_cpu_start8
                                   // is set only when you from default state 
      case (L1_ctrl_reg8)
        'h0 : L1_ctrl_domain8 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain8 = 32'h2; // PM_uart8
                mte_uart_start8 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain8 = 32'h4; // PM_smc8
                mte_smc_start8 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain8 = 32'h6; // PM_smc_uart8
                mte_smc_uart_start8 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain8 = 32'h8; //  PM_macb08
                mte_mac0_start8 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain8 = 32'h10; //  PM_macb18
                mte_mac1_start8 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain8 = 32'h20; //  PM_macb28
                mte_mac2_start8 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain8 = 32'h40; //  PM_macb38
                mte_mac3_start8 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain8 = 32'h18; //  PM_macb018
                mte_mac01_start8 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain8 = 32'h28; //  PM_macb028
                mte_mac02_start8 = 1;
              end
        'hA : begin  
                L1_ctrl_domain8 = 32'h48; //  PM_macb038
                mte_mac03_start8 = 1;
              end
        'hB : begin  
                L1_ctrl_domain8 = 32'h30; //  PM_macb128
                mte_mac12_start8 = 1;
              end
        'hC : begin  
                L1_ctrl_domain8 = 32'h50; //  PM_macb138
                mte_mac13_start8 = 1;
              end
        'hD : begin  
                L1_ctrl_domain8 = 32'h60; //  PM_macb238
                mte_mac23_start8 = 1;
              end
        'hE : begin  
                L1_ctrl_domain8 = 32'h38; //  PM_macb0128
                mte_mac012_start8 = 1;
              end
        'hF : begin  
                L1_ctrl_domain8 = 32'h58; //  PM_macb0138
                mte_mac013_start8 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain8 = 32'h68; //  PM_macb0238
                mte_mac023_start8 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain8 = 32'h70; //  PM_macb1238
                mte_mac123_start8 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain8 = 32'h78; //  PM_macb_off8
                mte_mac_off_start8 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain8 = 32'h80; //  PM_dma8
                mte_dma_start8 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain8 = 32'h100; //  PM_cpu_sleep8
                mte_cpu_start8 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain8 = 32'h1FE; //  PM_hibernate8
                mte_sys_hibernate8 = 1;
              end
         default: L1_ctrl_domain8 = 32'h0;
      endcase
    end
  end


  wire to_default8 = (L1_ctrl_reg8 == 0);

  // Scan8 mode gating8 of power8 and isolation8 control8 signals8
  //SMC8
  assign rstn_non_srpg_smc8  = (scan_mode8 == 1'b0) ? rstn_non_srpg_smc_int8 : 1'b1;  
  assign gate_clk_smc8       = (scan_mode8 == 1'b0) ? gate_clk_smc_int8 : 1'b0;     
  assign isolate_smc8        = (scan_mode8 == 1'b0) ? isolate_smc_int8 : 1'b0;      
  assign pwr1_on_smc8        = (scan_mode8 == 1'b0) ? pwr1_on_smc_int8 : 1'b1;       
  assign pwr2_on_smc8        = (scan_mode8 == 1'b0) ? pwr2_on_smc_int8 : 1'b1;       
  assign pwr1_off_smc8       = (scan_mode8 == 1'b0) ? (!pwr1_on_smc_int8) : 1'b0;       
  assign pwr2_off_smc8       = (scan_mode8 == 1'b0) ? (!pwr2_on_smc_int8) : 1'b0;       
  assign save_edge_smc8       = (scan_mode8 == 1'b0) ? (save_edge_smc_int8) : 1'b0;       
  assign restore_edge_smc8       = (scan_mode8 == 1'b0) ? (restore_edge_smc_int8) : 1'b0;       

  //URT8
  assign rstn_non_srpg_urt8  = (scan_mode8 == 1'b0) ?  rstn_non_srpg_urt_int8 : 1'b1;  
  assign gate_clk_urt8       = (scan_mode8 == 1'b0) ?  gate_clk_urt_int8      : 1'b0;     
  assign isolate_urt8        = (scan_mode8 == 1'b0) ?  isolate_urt_int8       : 1'b0;      
  assign pwr1_on_urt8        = (scan_mode8 == 1'b0) ?  pwr1_on_urt_int8       : 1'b1;       
  assign pwr2_on_urt8        = (scan_mode8 == 1'b0) ?  pwr2_on_urt_int8       : 1'b1;       
  assign pwr1_off_urt8       = (scan_mode8 == 1'b0) ?  (!pwr1_on_urt_int8)  : 1'b0;       
  assign pwr2_off_urt8       = (scan_mode8 == 1'b0) ?  (!pwr2_on_urt_int8)  : 1'b0;       
  assign save_edge_urt8       = (scan_mode8 == 1'b0) ? (save_edge_urt_int8) : 1'b0;       
  assign restore_edge_urt8       = (scan_mode8 == 1'b0) ? (restore_edge_urt_int8) : 1'b0;       

  //ETH08
  assign rstn_non_srpg_macb08 = (scan_mode8 == 1'b0) ?  rstn_non_srpg_macb0_int8 : 1'b1;  
  assign gate_clk_macb08       = (scan_mode8 == 1'b0) ?  gate_clk_macb0_int8      : 1'b0;     
  assign isolate_macb08        = (scan_mode8 == 1'b0) ?  isolate_macb0_int8       : 1'b0;      
  assign pwr1_on_macb08        = (scan_mode8 == 1'b0) ?  pwr1_on_macb0_int8       : 1'b1;       
  assign pwr2_on_macb08        = (scan_mode8 == 1'b0) ?  pwr2_on_macb0_int8       : 1'b1;       
  assign pwr1_off_macb08       = (scan_mode8 == 1'b0) ?  (!pwr1_on_macb0_int8)  : 1'b0;       
  assign pwr2_off_macb08       = (scan_mode8 == 1'b0) ?  (!pwr2_on_macb0_int8)  : 1'b0;       
  assign save_edge_macb08       = (scan_mode8 == 1'b0) ? (save_edge_macb0_int8) : 1'b0;       
  assign restore_edge_macb08       = (scan_mode8 == 1'b0) ? (restore_edge_macb0_int8) : 1'b0;       

  //ETH18
  assign rstn_non_srpg_macb18 = (scan_mode8 == 1'b0) ?  rstn_non_srpg_macb1_int8 : 1'b1;  
  assign gate_clk_macb18       = (scan_mode8 == 1'b0) ?  gate_clk_macb1_int8      : 1'b0;     
  assign isolate_macb18        = (scan_mode8 == 1'b0) ?  isolate_macb1_int8       : 1'b0;      
  assign pwr1_on_macb18        = (scan_mode8 == 1'b0) ?  pwr1_on_macb1_int8       : 1'b1;       
  assign pwr2_on_macb18        = (scan_mode8 == 1'b0) ?  pwr2_on_macb1_int8       : 1'b1;       
  assign pwr1_off_macb18       = (scan_mode8 == 1'b0) ?  (!pwr1_on_macb1_int8)  : 1'b0;       
  assign pwr2_off_macb18       = (scan_mode8 == 1'b0) ?  (!pwr2_on_macb1_int8)  : 1'b0;       
  assign save_edge_macb18       = (scan_mode8 == 1'b0) ? (save_edge_macb1_int8) : 1'b0;       
  assign restore_edge_macb18       = (scan_mode8 == 1'b0) ? (restore_edge_macb1_int8) : 1'b0;       

  //ETH28
  assign rstn_non_srpg_macb28 = (scan_mode8 == 1'b0) ?  rstn_non_srpg_macb2_int8 : 1'b1;  
  assign gate_clk_macb28       = (scan_mode8 == 1'b0) ?  gate_clk_macb2_int8      : 1'b0;     
  assign isolate_macb28        = (scan_mode8 == 1'b0) ?  isolate_macb2_int8       : 1'b0;      
  assign pwr1_on_macb28        = (scan_mode8 == 1'b0) ?  pwr1_on_macb2_int8       : 1'b1;       
  assign pwr2_on_macb28        = (scan_mode8 == 1'b0) ?  pwr2_on_macb2_int8       : 1'b1;       
  assign pwr1_off_macb28       = (scan_mode8 == 1'b0) ?  (!pwr1_on_macb2_int8)  : 1'b0;       
  assign pwr2_off_macb28       = (scan_mode8 == 1'b0) ?  (!pwr2_on_macb2_int8)  : 1'b0;       
  assign save_edge_macb28       = (scan_mode8 == 1'b0) ? (save_edge_macb2_int8) : 1'b0;       
  assign restore_edge_macb28       = (scan_mode8 == 1'b0) ? (restore_edge_macb2_int8) : 1'b0;       

  //ETH38
  assign rstn_non_srpg_macb38 = (scan_mode8 == 1'b0) ?  rstn_non_srpg_macb3_int8 : 1'b1;  
  assign gate_clk_macb38       = (scan_mode8 == 1'b0) ?  gate_clk_macb3_int8      : 1'b0;     
  assign isolate_macb38        = (scan_mode8 == 1'b0) ?  isolate_macb3_int8       : 1'b0;      
  assign pwr1_on_macb38        = (scan_mode8 == 1'b0) ?  pwr1_on_macb3_int8       : 1'b1;       
  assign pwr2_on_macb38        = (scan_mode8 == 1'b0) ?  pwr2_on_macb3_int8       : 1'b1;       
  assign pwr1_off_macb38       = (scan_mode8 == 1'b0) ?  (!pwr1_on_macb3_int8)  : 1'b0;       
  assign pwr2_off_macb38       = (scan_mode8 == 1'b0) ?  (!pwr2_on_macb3_int8)  : 1'b0;       
  assign save_edge_macb38       = (scan_mode8 == 1'b0) ? (save_edge_macb3_int8) : 1'b0;       
  assign restore_edge_macb38       = (scan_mode8 == 1'b0) ? (restore_edge_macb3_int8) : 1'b0;       

  // MEM8
  assign rstn_non_srpg_mem8 =   (rstn_non_srpg_macb08 && rstn_non_srpg_macb18 && rstn_non_srpg_macb28 &&
                                rstn_non_srpg_macb38 && rstn_non_srpg_dma8 && rstn_non_srpg_cpu8 && rstn_non_srpg_urt8 &&
                                rstn_non_srpg_smc8);

  assign gate_clk_mem8 =  (gate_clk_macb08 && gate_clk_macb18 && gate_clk_macb28 &&
                            gate_clk_macb38 && gate_clk_dma8 && gate_clk_cpu8 && gate_clk_urt8 && gate_clk_smc8);

  assign isolate_mem8  = (isolate_macb08 && isolate_macb18 && isolate_macb28 &&
                         isolate_macb38 && isolate_dma8 && isolate_cpu8 && isolate_urt8 && isolate_smc8);


  assign pwr1_on_mem8        =   ~pwr1_off_mem8;

  assign pwr2_on_mem8        =   ~pwr2_off_mem8;

  assign pwr1_off_mem8       =  (pwr1_off_macb08 && pwr1_off_macb18 && pwr1_off_macb28 &&
                                 pwr1_off_macb38 && pwr1_off_dma8 && pwr1_off_cpu8 && pwr1_off_urt8 && pwr1_off_smc8);


  assign pwr2_off_mem8       =  (pwr2_off_macb08 && pwr2_off_macb18 && pwr2_off_macb28 &&
                                pwr2_off_macb38 && pwr2_off_dma8 && pwr2_off_cpu8 && pwr2_off_urt8 && pwr2_off_smc8);

  assign save_edge_mem8      =  (save_edge_macb08 && save_edge_macb18 && save_edge_macb28 &&
                                save_edge_macb38 && save_edge_dma8 && save_edge_cpu8 && save_edge_smc8 && save_edge_urt8);

  assign restore_edge_mem8   =  (restore_edge_macb08 && restore_edge_macb18 && restore_edge_macb28  &&
                                restore_edge_macb38 && restore_edge_dma8 && restore_edge_cpu8 && restore_edge_urt8 &&
                                restore_edge_smc8);

  assign standby_mem08 = pwr1_off_macb08 && (~ (pwr1_off_macb08 && pwr1_off_macb18 && pwr1_off_macb28 && pwr1_off_macb38 && pwr1_off_urt8 && pwr1_off_smc8 && pwr1_off_dma8 && pwr1_off_cpu8));
  assign standby_mem18 = pwr1_off_macb18 && (~ (pwr1_off_macb08 && pwr1_off_macb18 && pwr1_off_macb28 && pwr1_off_macb38 && pwr1_off_urt8 && pwr1_off_smc8 && pwr1_off_dma8 && pwr1_off_cpu8));
  assign standby_mem28 = pwr1_off_macb28 && (~ (pwr1_off_macb08 && pwr1_off_macb18 && pwr1_off_macb28 && pwr1_off_macb38 && pwr1_off_urt8 && pwr1_off_smc8 && pwr1_off_dma8 && pwr1_off_cpu8));
  assign standby_mem38 = pwr1_off_macb38 && (~ (pwr1_off_macb08 && pwr1_off_macb18 && pwr1_off_macb28 && pwr1_off_macb38 && pwr1_off_urt8 && pwr1_off_smc8 && pwr1_off_dma8 && pwr1_off_cpu8));

  assign pwr1_off_mem08 = pwr1_off_mem8;
  assign pwr1_off_mem18 = pwr1_off_mem8;
  assign pwr1_off_mem28 = pwr1_off_mem8;
  assign pwr1_off_mem38 = pwr1_off_mem8;

  assign rstn_non_srpg_alut8  =  (rstn_non_srpg_macb08 && rstn_non_srpg_macb18 && rstn_non_srpg_macb28 && rstn_non_srpg_macb38);


   assign gate_clk_alut8       =  (gate_clk_macb08 && gate_clk_macb18 && gate_clk_macb28 && gate_clk_macb38);


    assign isolate_alut8        =  (isolate_macb08 && isolate_macb18 && isolate_macb28 && isolate_macb38);


    assign pwr1_on_alut8        =  (pwr1_on_macb08 || pwr1_on_macb18 || pwr1_on_macb28 || pwr1_on_macb38);


    assign pwr2_on_alut8        =  (pwr2_on_macb08 || pwr2_on_macb18 || pwr2_on_macb28 || pwr2_on_macb38);


    assign pwr1_off_alut8       =  (pwr1_off_macb08 && pwr1_off_macb18 && pwr1_off_macb28 && pwr1_off_macb38);


    assign pwr2_off_alut8       =  (pwr2_off_macb08 && pwr2_off_macb18 && pwr2_off_macb28 && pwr2_off_macb38);


    assign save_edge_alut8      =  (save_edge_macb08 && save_edge_macb18 && save_edge_macb28 && save_edge_macb38);


    assign restore_edge_alut8   =  (restore_edge_macb08 || restore_edge_macb18 || restore_edge_macb28 ||
                                   restore_edge_macb38) && save_alut_tmp8;

     // alut8 power8 off8 detection8
  always @(posedge pclk8 or negedge nprst8) begin
    if (!nprst8) 
       save_alut_tmp8 <= 0;
    else if (restore_edge_alut8)
       save_alut_tmp8 <= 0;
    else if (save_edge_alut8)
       save_alut_tmp8 <= 1;
  end

  //DMA8
  assign rstn_non_srpg_dma8 = (scan_mode8 == 1'b0) ?  rstn_non_srpg_dma_int8 : 1'b1;  
  assign gate_clk_dma8       = (scan_mode8 == 1'b0) ?  gate_clk_dma_int8      : 1'b0;     
  assign isolate_dma8        = (scan_mode8 == 1'b0) ?  isolate_dma_int8       : 1'b0;      
  assign pwr1_on_dma8        = (scan_mode8 == 1'b0) ?  pwr1_on_dma_int8       : 1'b1;       
  assign pwr2_on_dma8        = (scan_mode8 == 1'b0) ?  pwr2_on_dma_int8       : 1'b1;       
  assign pwr1_off_dma8       = (scan_mode8 == 1'b0) ?  (!pwr1_on_dma_int8)  : 1'b0;       
  assign pwr2_off_dma8       = (scan_mode8 == 1'b0) ?  (!pwr2_on_dma_int8)  : 1'b0;       
  assign save_edge_dma8       = (scan_mode8 == 1'b0) ? (save_edge_dma_int8) : 1'b0;       
  assign restore_edge_dma8       = (scan_mode8 == 1'b0) ? (restore_edge_dma_int8) : 1'b0;       

  //CPU8
  assign rstn_non_srpg_cpu8 = (scan_mode8 == 1'b0) ?  rstn_non_srpg_cpu_int8 : 1'b1;  
  assign gate_clk_cpu8       = (scan_mode8 == 1'b0) ?  gate_clk_cpu_int8      : 1'b0;     
  assign isolate_cpu8        = (scan_mode8 == 1'b0) ?  isolate_cpu_int8       : 1'b0;      
  assign pwr1_on_cpu8        = (scan_mode8 == 1'b0) ?  pwr1_on_cpu_int8       : 1'b1;       
  assign pwr2_on_cpu8        = (scan_mode8 == 1'b0) ?  pwr2_on_cpu_int8       : 1'b1;       
  assign pwr1_off_cpu8       = (scan_mode8 == 1'b0) ?  (!pwr1_on_cpu_int8)  : 1'b0;       
  assign pwr2_off_cpu8       = (scan_mode8 == 1'b0) ?  (!pwr2_on_cpu_int8)  : 1'b0;       
  assign save_edge_cpu8       = (scan_mode8 == 1'b0) ? (save_edge_cpu_int8) : 1'b0;       
  assign restore_edge_cpu8       = (scan_mode8 == 1'b0) ? (restore_edge_cpu_int8) : 1'b0;       



  // ASE8

   reg ase_core_12v8, ase_core_10v8, ase_core_08v8, ase_core_06v8;
   reg ase_macb0_12v8,ase_macb1_12v8,ase_macb2_12v8,ase_macb3_12v8;

    // core8 ase8

    // core8 at 1.0 v if (smc8 off8, urt8 off8, macb08 off8, macb18 off8, macb28 off8, macb38 off8
   // core8 at 0.8v if (mac01off8, macb02off8, macb03off8, macb12off8, mac13off8, mac23off8,
   // core8 at 0.6v if (mac012off8, mac013off8, mac023off8, mac123off8, mac0123off8
    // else core8 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb08 && pwr1_off_macb18 && pwr1_off_macb28 && pwr1_off_macb38) || // all mac8 off8
       (pwr1_off_macb38 && pwr1_off_macb28 && pwr1_off_macb18) || // mac123off8 
       (pwr1_off_macb38 && pwr1_off_macb28 && pwr1_off_macb08) || // mac023off8 
       (pwr1_off_macb38 && pwr1_off_macb18 && pwr1_off_macb08) || // mac013off8 
       (pwr1_off_macb28 && pwr1_off_macb18 && pwr1_off_macb08) )  // mac012off8 
       begin
         ase_core_12v8 = 0;
         ase_core_10v8 = 0;
         ase_core_08v8 = 0;
         ase_core_06v8 = 1;
       end
     else if( (pwr1_off_macb28 && pwr1_off_macb38) || // mac238 off8
         (pwr1_off_macb38 && pwr1_off_macb18) || // mac13off8 
         (pwr1_off_macb18 && pwr1_off_macb28) || // mac12off8 
         (pwr1_off_macb38 && pwr1_off_macb08) || // mac03off8 
         (pwr1_off_macb28 && pwr1_off_macb08) || // mac02off8 
         (pwr1_off_macb18 && pwr1_off_macb08))  // mac01off8 
       begin
         ase_core_12v8 = 0;
         ase_core_10v8 = 0;
         ase_core_08v8 = 1;
         ase_core_06v8 = 0;
       end
     else if( (pwr1_off_smc8) || // smc8 off8
         (pwr1_off_macb08 ) || // mac0off8 
         (pwr1_off_macb18 ) || // mac1off8 
         (pwr1_off_macb28 ) || // mac2off8 
         (pwr1_off_macb38 ))  // mac3off8 
       begin
         ase_core_12v8 = 0;
         ase_core_10v8 = 1;
         ase_core_08v8 = 0;
         ase_core_06v8 = 0;
       end
     else if (pwr1_off_urt8)
       begin
         ase_core_12v8 = 1;
         ase_core_10v8 = 0;
         ase_core_08v8 = 0;
         ase_core_06v8 = 0;
       end
     else
       begin
         ase_core_12v8 = 1;
         ase_core_10v8 = 0;
         ase_core_08v8 = 0;
         ase_core_06v8 = 0;
       end
   end


   // cpu8
   // cpu8 @ 1.0v when macoff8, 
   // 
   reg ase_cpu_10v8, ase_cpu_12v8;
   always @(*) begin
    if(pwr1_off_cpu8) begin
     ase_cpu_12v8 = 1'b0;
     ase_cpu_10v8 = 1'b0;
    end
    else if(pwr1_off_macb08 || pwr1_off_macb18 || pwr1_off_macb28 || pwr1_off_macb38)
    begin
     ase_cpu_12v8 = 1'b0;
     ase_cpu_10v8 = 1'b1;
    end
    else
    begin
     ase_cpu_12v8 = 1'b1;
     ase_cpu_10v8 = 1'b0;
    end
   end

   // dma8
   // dma8 @v18.0 for macoff8, 

   reg ase_dma_10v8, ase_dma_12v8;
   always @(*) begin
    if(pwr1_off_dma8) begin
     ase_dma_12v8 = 1'b0;
     ase_dma_10v8 = 1'b0;
    end
    else if(pwr1_off_macb08 || pwr1_off_macb18 || pwr1_off_macb28 || pwr1_off_macb38)
    begin
     ase_dma_12v8 = 1'b0;
     ase_dma_10v8 = 1'b1;
    end
    else
    begin
     ase_dma_12v8 = 1'b1;
     ase_dma_10v8 = 1'b0;
    end
   end

   // alut8
   // @ v18.0 for macoff8

   reg ase_alut_10v8, ase_alut_12v8;
   always @(*) begin
    if(pwr1_off_alut8) begin
     ase_alut_12v8 = 1'b0;
     ase_alut_10v8 = 1'b0;
    end
    else if(pwr1_off_macb08 || pwr1_off_macb18 || pwr1_off_macb28 || pwr1_off_macb38)
    begin
     ase_alut_12v8 = 1'b0;
     ase_alut_10v8 = 1'b1;
    end
    else
    begin
     ase_alut_12v8 = 1'b1;
     ase_alut_10v8 = 1'b0;
    end
   end




   reg ase_uart_12v8;
   reg ase_uart_10v8;
   reg ase_uart_08v8;
   reg ase_uart_06v8;

   reg ase_smc_12v8;


   always @(*) begin
     if(pwr1_off_urt8) begin // uart8 off8
       ase_uart_08v8 = 1'b0;
       ase_uart_06v8 = 1'b0;
       ase_uart_10v8 = 1'b0;
       ase_uart_12v8 = 1'b0;
     end 
     else if( (pwr1_off_macb08 && pwr1_off_macb18 && pwr1_off_macb28 && pwr1_off_macb38) || // all mac8 off8
       (pwr1_off_macb38 && pwr1_off_macb28 && pwr1_off_macb18) || // mac123off8 
       (pwr1_off_macb38 && pwr1_off_macb28 && pwr1_off_macb08) || // mac023off8 
       (pwr1_off_macb38 && pwr1_off_macb18 && pwr1_off_macb08) || // mac013off8 
       (pwr1_off_macb28 && pwr1_off_macb18 && pwr1_off_macb08) )  // mac012off8 
     begin
       ase_uart_06v8 = 1'b1;
       ase_uart_08v8 = 1'b0;
       ase_uart_10v8 = 1'b0;
       ase_uart_12v8 = 1'b0;
     end
     else if( (pwr1_off_macb28 && pwr1_off_macb38) || // mac238 off8
         (pwr1_off_macb38 && pwr1_off_macb18) || // mac13off8 
         (pwr1_off_macb18 && pwr1_off_macb28) || // mac12off8 
         (pwr1_off_macb38 && pwr1_off_macb08) || // mac03off8 
         (pwr1_off_macb18 && pwr1_off_macb08))  // mac01off8  
     begin
       ase_uart_06v8 = 1'b0;
       ase_uart_08v8 = 1'b1;
       ase_uart_10v8 = 1'b0;
       ase_uart_12v8 = 1'b0;
     end
     else if (pwr1_off_smc8 || pwr1_off_macb08 || pwr1_off_macb18 || pwr1_off_macb28 || pwr1_off_macb38) begin // smc8 off8
       ase_uart_08v8 = 1'b0;
       ase_uart_06v8 = 1'b0;
       ase_uart_10v8 = 1'b1;
       ase_uart_12v8 = 1'b0;
     end 
     else begin
       ase_uart_08v8 = 1'b0;
       ase_uart_06v8 = 1'b0;
       ase_uart_10v8 = 1'b0;
       ase_uart_12v8 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc8) begin
     if (pwr1_off_smc8)  // smc8 off8
       ase_smc_12v8 = 1'b0;
    else
       ase_smc_12v8 = 1'b1;
   end

   
   always @(pwr1_off_macb08) begin
     if (pwr1_off_macb08) // macb08 off8
       ase_macb0_12v8 = 1'b0;
     else
       ase_macb0_12v8 = 1'b1;
   end

   always @(pwr1_off_macb18) begin
     if (pwr1_off_macb18) // macb18 off8
       ase_macb1_12v8 = 1'b0;
     else
       ase_macb1_12v8 = 1'b1;
   end

   always @(pwr1_off_macb28) begin // macb28 off8
     if (pwr1_off_macb28) // macb28 off8
       ase_macb2_12v8 = 1'b0;
     else
       ase_macb2_12v8 = 1'b1;
   end

   always @(pwr1_off_macb38) begin // macb38 off8
     if (pwr1_off_macb38) // macb38 off8
       ase_macb3_12v8 = 1'b0;
     else
       ase_macb3_12v8 = 1'b1;
   end


   // core8 voltage8 for vco8
  assign core12v8 = ase_macb0_12v8 & ase_macb1_12v8 & ase_macb2_12v8 & ase_macb3_12v8;

  assign core10v8 =  (ase_macb0_12v8 & ase_macb1_12v8 & ase_macb2_12v8 & (!ase_macb3_12v8)) ||
                    (ase_macb0_12v8 & ase_macb1_12v8 & (!ase_macb2_12v8) & ase_macb3_12v8) ||
                    (ase_macb0_12v8 & (!ase_macb1_12v8) & ase_macb2_12v8 & ase_macb3_12v8) ||
                    ((!ase_macb0_12v8) & ase_macb1_12v8 & ase_macb2_12v8 & ase_macb3_12v8);

  assign core08v8 =  ((!ase_macb0_12v8) & (!ase_macb1_12v8) & (ase_macb2_12v8) & (ase_macb3_12v8)) ||
                    ((!ase_macb0_12v8) & (ase_macb1_12v8) & (!ase_macb2_12v8) & (ase_macb3_12v8)) ||
                    ((!ase_macb0_12v8) & (ase_macb1_12v8) & (ase_macb2_12v8) & (!ase_macb3_12v8)) ||
                    ((ase_macb0_12v8) & (!ase_macb1_12v8) & (!ase_macb2_12v8) & (ase_macb3_12v8)) ||
                    ((ase_macb0_12v8) & (!ase_macb1_12v8) & (ase_macb2_12v8) & (!ase_macb3_12v8)) ||
                    ((ase_macb0_12v8) & (ase_macb1_12v8) & (!ase_macb2_12v8) & (!ase_macb3_12v8));

  assign core06v8 =  ((!ase_macb0_12v8) & (!ase_macb1_12v8) & (!ase_macb2_12v8) & (ase_macb3_12v8)) ||
                    ((!ase_macb0_12v8) & (!ase_macb1_12v8) & (ase_macb2_12v8) & (!ase_macb3_12v8)) ||
                    ((!ase_macb0_12v8) & (ase_macb1_12v8) & (!ase_macb2_12v8) & (!ase_macb3_12v8)) ||
                    ((ase_macb0_12v8) & (!ase_macb1_12v8) & (!ase_macb2_12v8) & (!ase_macb3_12v8)) ||
                    ((!ase_macb0_12v8) & (!ase_macb1_12v8) & (!ase_macb2_12v8) & (!ase_macb3_12v8)) ;



`ifdef LP_ABV_ON8
// psl8 default clock8 = (posedge pclk8);

// Cover8 a condition in which SMC8 is powered8 down
// and again8 powered8 up while UART8 is going8 into POWER8 down
// state or UART8 is already in POWER8 DOWN8 state
// psl8 cover_overlapping_smc_urt_18:
//    cover{fell8(pwr1_on_urt8);[*];fell8(pwr1_on_smc8);[*];
//    rose8(pwr1_on_smc8);[*];rose8(pwr1_on_urt8)};
//
// Cover8 a condition in which UART8 is powered8 down
// and again8 powered8 up while SMC8 is going8 into POWER8 down
// state or SMC8 is already in POWER8 DOWN8 state
// psl8 cover_overlapping_smc_urt_28:
//    cover{fell8(pwr1_on_smc8);[*];fell8(pwr1_on_urt8);[*];
//    rose8(pwr1_on_urt8);[*];rose8(pwr1_on_smc8)};
//


// Power8 Down8 UART8
// This8 gets8 triggered on rising8 edge of Gate8 signal8 for
// UART8 (gate_clk_urt8). In a next cycle after gate_clk_urt8,
// Isolate8 UART8(isolate_urt8) signal8 become8 HIGH8 (active).
// In 2nd cycle after gate_clk_urt8 becomes HIGH8, RESET8 for NON8
// SRPG8 FFs8(rstn_non_srpg_urt8) and POWER18 for UART8(pwr1_on_urt8) should 
// go8 LOW8. 
// This8 completes8 a POWER8 DOWN8. 

sequence s_power_down_urt8;
      (gate_clk_urt8 & !isolate_urt8 & rstn_non_srpg_urt8 & pwr1_on_urt8) 
  ##1 (gate_clk_urt8 & isolate_urt8 & rstn_non_srpg_urt8 & pwr1_on_urt8) 
  ##3 (gate_clk_urt8 & isolate_urt8 & !rstn_non_srpg_urt8 & !pwr1_on_urt8);
endsequence


property p_power_down_urt8;
   @(posedge pclk8)
    $rose(gate_clk_urt8) |=> s_power_down_urt8;
endproperty

output_power_down_urt8:
  assert property (p_power_down_urt8);


// Power8 UP8 UART8
// Sequence starts with , Rising8 edge of pwr1_on_urt8.
// Two8 clock8 cycle after this, isolate_urt8 should become8 LOW8 
// On8 the following8 clk8 gate_clk_urt8 should go8 low8.
// 5 cycles8 after  Rising8 edge of pwr1_on_urt8, rstn_non_srpg_urt8
// should become8 HIGH8
sequence s_power_up_urt8;
##30 (pwr1_on_urt8 & !isolate_urt8 & gate_clk_urt8 & !rstn_non_srpg_urt8) 
##1 (pwr1_on_urt8 & !isolate_urt8 & !gate_clk_urt8 & !rstn_non_srpg_urt8) 
##2 (pwr1_on_urt8 & !isolate_urt8 & !gate_clk_urt8 & rstn_non_srpg_urt8);
endsequence

property p_power_up_urt8;
   @(posedge pclk8)
  disable iff(!nprst8)
    (!pwr1_on_urt8 ##1 pwr1_on_urt8) |=> s_power_up_urt8;
endproperty

output_power_up_urt8:
  assert property (p_power_up_urt8);


// Power8 Down8 SMC8
// This8 gets8 triggered on rising8 edge of Gate8 signal8 for
// SMC8 (gate_clk_smc8). In a next cycle after gate_clk_smc8,
// Isolate8 SMC8(isolate_smc8) signal8 become8 HIGH8 (active).
// In 2nd cycle after gate_clk_smc8 becomes HIGH8, RESET8 for NON8
// SRPG8 FFs8(rstn_non_srpg_smc8) and POWER18 for SMC8(pwr1_on_smc8) should 
// go8 LOW8. 
// This8 completes8 a POWER8 DOWN8. 

sequence s_power_down_smc8;
      (gate_clk_smc8 & !isolate_smc8 & rstn_non_srpg_smc8 & pwr1_on_smc8) 
  ##1 (gate_clk_smc8 & isolate_smc8 & rstn_non_srpg_smc8 & pwr1_on_smc8) 
  ##3 (gate_clk_smc8 & isolate_smc8 & !rstn_non_srpg_smc8 & !pwr1_on_smc8);
endsequence


property p_power_down_smc8;
   @(posedge pclk8)
    $rose(gate_clk_smc8) |=> s_power_down_smc8;
endproperty

output_power_down_smc8:
  assert property (p_power_down_smc8);


// Power8 UP8 SMC8
// Sequence starts with , Rising8 edge of pwr1_on_smc8.
// Two8 clock8 cycle after this, isolate_smc8 should become8 LOW8 
// On8 the following8 clk8 gate_clk_smc8 should go8 low8.
// 5 cycles8 after  Rising8 edge of pwr1_on_smc8, rstn_non_srpg_smc8
// should become8 HIGH8
sequence s_power_up_smc8;
##30 (pwr1_on_smc8 & !isolate_smc8 & gate_clk_smc8 & !rstn_non_srpg_smc8) 
##1 (pwr1_on_smc8 & !isolate_smc8 & !gate_clk_smc8 & !rstn_non_srpg_smc8) 
##2 (pwr1_on_smc8 & !isolate_smc8 & !gate_clk_smc8 & rstn_non_srpg_smc8);
endsequence

property p_power_up_smc8;
   @(posedge pclk8)
  disable iff(!nprst8)
    (!pwr1_on_smc8 ##1 pwr1_on_smc8) |=> s_power_up_smc8;
endproperty

output_power_up_smc8:
  assert property (p_power_up_smc8);


// COVER8 SMC8 POWER8 DOWN8 AND8 UP8
cover_power_down_up_smc8: cover property (@(posedge pclk8)
(s_power_down_smc8 ##[5:180] s_power_up_smc8));



// COVER8 UART8 POWER8 DOWN8 AND8 UP8
cover_power_down_up_urt8: cover property (@(posedge pclk8)
(s_power_down_urt8 ##[5:180] s_power_up_urt8));

cover_power_down_urt8: cover property (@(posedge pclk8)
(s_power_down_urt8));

cover_power_up_urt8: cover property (@(posedge pclk8)
(s_power_up_urt8));




`ifdef PCM_ABV_ON8
//------------------------------------------------------------------------------
// Power8 Controller8 Formal8 Verification8 component.  Each power8 domain has a 
// separate8 instantiation8
//------------------------------------------------------------------------------

// need to assume that CPU8 will leave8 a minimum time between powering8 down and 
// back up.  In this example8, 10clks has been selected.
// psl8 config_min_uart_pd_time8 : assume always {rose8(L1_ctrl_domain8[1])} |-> { L1_ctrl_domain8[1][*10] } abort8(~nprst8);
// psl8 config_min_uart_pu_time8 : assume always {fell8(L1_ctrl_domain8[1])} |-> { !L1_ctrl_domain8[1][*10] } abort8(~nprst8);
// psl8 config_min_smc_pd_time8 : assume always {rose8(L1_ctrl_domain8[2])} |-> { L1_ctrl_domain8[2][*10] } abort8(~nprst8);
// psl8 config_min_smc_pu_time8 : assume always {fell8(L1_ctrl_domain8[2])} |-> { !L1_ctrl_domain8[2][*10] } abort8(~nprst8);

// UART8 VCOMP8 parameters8
   defparam i_uart_vcomp_domain8.ENABLE_SAVE_RESTORE_EDGE8   = 1;
   defparam i_uart_vcomp_domain8.ENABLE_EXT_PWR_CNTRL8       = 1;
   defparam i_uart_vcomp_domain8.REF_CLK_DEFINED8            = 0;
   defparam i_uart_vcomp_domain8.MIN_SHUTOFF_CYCLES8         = 4;
   defparam i_uart_vcomp_domain8.MIN_RESTORE_TO_ISO_CYCLES8  = 0;
   defparam i_uart_vcomp_domain8.MIN_SAVE_TO_SHUTOFF_CYCLES8 = 1;


   vcomp_domain8 i_uart_vcomp_domain8
   ( .ref_clk8(pclk8),
     .start_lps8(L1_ctrl_domain8[1] || !rstn_non_srpg_urt8),
     .rst_n8(nprst8),
     .ext_power_down8(L1_ctrl_domain8[1]),
     .iso_en8(isolate_urt8),
     .save_edge8(save_edge_urt8),
     .restore_edge8(restore_edge_urt8),
     .domain_shut_off8(pwr1_off_urt8),
     .domain_clk8(!gate_clk_urt8 && pclk8)
   );


// SMC8 VCOMP8 parameters8
   defparam i_smc_vcomp_domain8.ENABLE_SAVE_RESTORE_EDGE8   = 1;
   defparam i_smc_vcomp_domain8.ENABLE_EXT_PWR_CNTRL8       = 1;
   defparam i_smc_vcomp_domain8.REF_CLK_DEFINED8            = 0;
   defparam i_smc_vcomp_domain8.MIN_SHUTOFF_CYCLES8         = 4;
   defparam i_smc_vcomp_domain8.MIN_RESTORE_TO_ISO_CYCLES8  = 0;
   defparam i_smc_vcomp_domain8.MIN_SAVE_TO_SHUTOFF_CYCLES8 = 1;


   vcomp_domain8 i_smc_vcomp_domain8
   ( .ref_clk8(pclk8),
     .start_lps8(L1_ctrl_domain8[2] || !rstn_non_srpg_smc8),
     .rst_n8(nprst8),
     .ext_power_down8(L1_ctrl_domain8[2]),
     .iso_en8(isolate_smc8),
     .save_edge8(save_edge_smc8),
     .restore_edge8(restore_edge_smc8),
     .domain_shut_off8(pwr1_off_smc8),
     .domain_clk8(!gate_clk_smc8 && pclk8)
   );

`endif

`endif



endmodule
