//File16 name   : power_ctrl16.v
//Title16       : Power16 Control16 Module16
//Created16     : 1999
//Description16 : Top16 level of power16 controller16
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

module power_ctrl16 (


    // Clocks16 & Reset16
    pclk16,
    nprst16,
    // APB16 programming16 interface
    paddr16,
    psel16,
    penable16,
    pwrite16,
    pwdata16,
    prdata16,
    // mac16 i/f,
    macb3_wakeup16,
    macb2_wakeup16,
    macb1_wakeup16,
    macb0_wakeup16,
    // Scan16 
    scan_in16,
    scan_en16,
    scan_mode16,
    scan_out16,
    // Module16 control16 outputs16
    int_source_h16,
    // SMC16
    rstn_non_srpg_smc16,
    gate_clk_smc16,
    isolate_smc16,
    save_edge_smc16,
    restore_edge_smc16,
    pwr1_on_smc16,
    pwr2_on_smc16,
    pwr1_off_smc16,
    pwr2_off_smc16,
    // URT16
    rstn_non_srpg_urt16,
    gate_clk_urt16,
    isolate_urt16,
    save_edge_urt16,
    restore_edge_urt16,
    pwr1_on_urt16,
    pwr2_on_urt16,
    pwr1_off_urt16,      
    pwr2_off_urt16,
    // ETH016
    rstn_non_srpg_macb016,
    gate_clk_macb016,
    isolate_macb016,
    save_edge_macb016,
    restore_edge_macb016,
    pwr1_on_macb016,
    pwr2_on_macb016,
    pwr1_off_macb016,      
    pwr2_off_macb016,
    // ETH116
    rstn_non_srpg_macb116,
    gate_clk_macb116,
    isolate_macb116,
    save_edge_macb116,
    restore_edge_macb116,
    pwr1_on_macb116,
    pwr2_on_macb116,
    pwr1_off_macb116,      
    pwr2_off_macb116,
    // ETH216
    rstn_non_srpg_macb216,
    gate_clk_macb216,
    isolate_macb216,
    save_edge_macb216,
    restore_edge_macb216,
    pwr1_on_macb216,
    pwr2_on_macb216,
    pwr1_off_macb216,      
    pwr2_off_macb216,
    // ETH316
    rstn_non_srpg_macb316,
    gate_clk_macb316,
    isolate_macb316,
    save_edge_macb316,
    restore_edge_macb316,
    pwr1_on_macb316,
    pwr2_on_macb316,
    pwr1_off_macb316,      
    pwr2_off_macb316,
    // DMA16
    rstn_non_srpg_dma16,
    gate_clk_dma16,
    isolate_dma16,
    save_edge_dma16,
    restore_edge_dma16,
    pwr1_on_dma16,
    pwr2_on_dma16,
    pwr1_off_dma16,      
    pwr2_off_dma16,
    // CPU16
    rstn_non_srpg_cpu16,
    gate_clk_cpu16,
    isolate_cpu16,
    save_edge_cpu16,
    restore_edge_cpu16,
    pwr1_on_cpu16,
    pwr2_on_cpu16,
    pwr1_off_cpu16,      
    pwr2_off_cpu16,
    // ALUT16
    rstn_non_srpg_alut16,
    gate_clk_alut16,
    isolate_alut16,
    save_edge_alut16,
    restore_edge_alut16,
    pwr1_on_alut16,
    pwr2_on_alut16,
    pwr1_off_alut16,      
    pwr2_off_alut16,
    // MEM16
    rstn_non_srpg_mem16,
    gate_clk_mem16,
    isolate_mem16,
    save_edge_mem16,
    restore_edge_mem16,
    pwr1_on_mem16,
    pwr2_on_mem16,
    pwr1_off_mem16,      
    pwr2_off_mem16,
    // core16 dvfs16 transitions16
    core06v16,
    core08v16,
    core10v16,
    core12v16,
    pcm_macb_wakeup_int16,
    // mte16 signals16
    mte_smc_start16,
    mte_uart_start16,
    mte_smc_uart_start16,  
    mte_pm_smc_to_default_start16, 
    mte_pm_uart_to_default_start16,
    mte_pm_smc_uart_to_default_start16

  );

  parameter STATE_IDLE_12V16 = 4'b0001;
  parameter STATE_06V16 = 4'b0010;
  parameter STATE_08V16 = 4'b0100;
  parameter STATE_10V16 = 4'b1000;

    // Clocks16 & Reset16
    input pclk16;
    input nprst16;
    // APB16 programming16 interface
    input [31:0] paddr16;
    input psel16  ;
    input penable16;
    input pwrite16 ;
    input [31:0] pwdata16;
    output [31:0] prdata16;
    // mac16
    input macb3_wakeup16;
    input macb2_wakeup16;
    input macb1_wakeup16;
    input macb0_wakeup16;
    // Scan16 
    input scan_in16;
    input scan_en16;
    input scan_mode16;
    output scan_out16;
    // Module16 control16 outputs16
    input int_source_h16;
    // SMC16
    output rstn_non_srpg_smc16 ;
    output gate_clk_smc16   ;
    output isolate_smc16   ;
    output save_edge_smc16   ;
    output restore_edge_smc16   ;
    output pwr1_on_smc16   ;
    output pwr2_on_smc16   ;
    output pwr1_off_smc16  ;
    output pwr2_off_smc16  ;
    // URT16
    output rstn_non_srpg_urt16 ;
    output gate_clk_urt16      ;
    output isolate_urt16       ;
    output save_edge_urt16   ;
    output restore_edge_urt16   ;
    output pwr1_on_urt16       ;
    output pwr2_on_urt16       ;
    output pwr1_off_urt16      ;
    output pwr2_off_urt16      ;
    // ETH016
    output rstn_non_srpg_macb016 ;
    output gate_clk_macb016      ;
    output isolate_macb016       ;
    output save_edge_macb016   ;
    output restore_edge_macb016   ;
    output pwr1_on_macb016       ;
    output pwr2_on_macb016       ;
    output pwr1_off_macb016      ;
    output pwr2_off_macb016      ;
    // ETH116
    output rstn_non_srpg_macb116 ;
    output gate_clk_macb116      ;
    output isolate_macb116       ;
    output save_edge_macb116   ;
    output restore_edge_macb116   ;
    output pwr1_on_macb116       ;
    output pwr2_on_macb116       ;
    output pwr1_off_macb116      ;
    output pwr2_off_macb116      ;
    // ETH216
    output rstn_non_srpg_macb216 ;
    output gate_clk_macb216      ;
    output isolate_macb216       ;
    output save_edge_macb216   ;
    output restore_edge_macb216   ;
    output pwr1_on_macb216       ;
    output pwr2_on_macb216       ;
    output pwr1_off_macb216      ;
    output pwr2_off_macb216      ;
    // ETH316
    output rstn_non_srpg_macb316 ;
    output gate_clk_macb316      ;
    output isolate_macb316       ;
    output save_edge_macb316   ;
    output restore_edge_macb316   ;
    output pwr1_on_macb316       ;
    output pwr2_on_macb316       ;
    output pwr1_off_macb316      ;
    output pwr2_off_macb316      ;
    // DMA16
    output rstn_non_srpg_dma16 ;
    output gate_clk_dma16      ;
    output isolate_dma16       ;
    output save_edge_dma16   ;
    output restore_edge_dma16   ;
    output pwr1_on_dma16       ;
    output pwr2_on_dma16       ;
    output pwr1_off_dma16      ;
    output pwr2_off_dma16      ;
    // CPU16
    output rstn_non_srpg_cpu16 ;
    output gate_clk_cpu16      ;
    output isolate_cpu16       ;
    output save_edge_cpu16   ;
    output restore_edge_cpu16   ;
    output pwr1_on_cpu16       ;
    output pwr2_on_cpu16       ;
    output pwr1_off_cpu16      ;
    output pwr2_off_cpu16      ;
    // ALUT16
    output rstn_non_srpg_alut16 ;
    output gate_clk_alut16      ;
    output isolate_alut16       ;
    output save_edge_alut16   ;
    output restore_edge_alut16   ;
    output pwr1_on_alut16       ;
    output pwr2_on_alut16       ;
    output pwr1_off_alut16      ;
    output pwr2_off_alut16      ;
    // MEM16
    output rstn_non_srpg_mem16 ;
    output gate_clk_mem16      ;
    output isolate_mem16       ;
    output save_edge_mem16   ;
    output restore_edge_mem16   ;
    output pwr1_on_mem16       ;
    output pwr2_on_mem16       ;
    output pwr1_off_mem16      ;
    output pwr2_off_mem16      ;


   // core16 transitions16 o/p
    output core06v16;
    output core08v16;
    output core10v16;
    output core12v16;
    output pcm_macb_wakeup_int16 ;
    //mode mte16  signals16
    output mte_smc_start16;
    output mte_uart_start16;
    output mte_smc_uart_start16;  
    output mte_pm_smc_to_default_start16; 
    output mte_pm_uart_to_default_start16;
    output mte_pm_smc_uart_to_default_start16;

    reg mte_smc_start16;
    reg mte_uart_start16;
    reg mte_smc_uart_start16;  
    reg mte_pm_smc_to_default_start16; 
    reg mte_pm_uart_to_default_start16;
    reg mte_pm_smc_uart_to_default_start16;

    reg [31:0] prdata16;

  wire valid_reg_write16  ;
  wire valid_reg_read16   ;
  wire L1_ctrl_access16   ;
  wire L1_status_access16 ;
  wire pcm_int_mask_access16;
  wire pcm_int_status_access16;
  wire standby_mem016      ;
  wire standby_mem116      ;
  wire standby_mem216      ;
  wire standby_mem316      ;
  wire pwr1_off_mem016;
  wire pwr1_off_mem116;
  wire pwr1_off_mem216;
  wire pwr1_off_mem316;
  
  // Control16 signals16
  wire set_status_smc16   ;
  wire clr_status_smc16   ;
  wire set_status_urt16   ;
  wire clr_status_urt16   ;
  wire set_status_macb016   ;
  wire clr_status_macb016   ;
  wire set_status_macb116   ;
  wire clr_status_macb116   ;
  wire set_status_macb216   ;
  wire clr_status_macb216   ;
  wire set_status_macb316   ;
  wire clr_status_macb316   ;
  wire set_status_dma16   ;
  wire clr_status_dma16   ;
  wire set_status_cpu16   ;
  wire clr_status_cpu16   ;
  wire set_status_alut16   ;
  wire clr_status_alut16   ;
  wire set_status_mem16   ;
  wire clr_status_mem16   ;


  // Status and Control16 registers
  reg [31:0]  L1_status_reg16;
  reg  [31:0] L1_ctrl_reg16  ;
  reg  [31:0] L1_ctrl_domain16  ;
  reg L1_ctrl_cpu_off_reg16;
  reg [31:0]  pcm_mask_reg16;
  reg [31:0]  pcm_status_reg16;

  // Signals16 gated16 in scan_mode16
  //SMC16
  wire  rstn_non_srpg_smc_int16;
  wire  gate_clk_smc_int16    ;     
  wire  isolate_smc_int16    ;       
  wire save_edge_smc_int16;
  wire restore_edge_smc_int16;
  wire  pwr1_on_smc_int16    ;      
  wire  pwr2_on_smc_int16    ;      


  //URT16
  wire   rstn_non_srpg_urt_int16;
  wire   gate_clk_urt_int16     ;     
  wire   isolate_urt_int16      ;       
  wire save_edge_urt_int16;
  wire restore_edge_urt_int16;
  wire   pwr1_on_urt_int16      ;      
  wire   pwr2_on_urt_int16      ;      

  // ETH016
  wire   rstn_non_srpg_macb0_int16;
  wire   gate_clk_macb0_int16     ;     
  wire   isolate_macb0_int16      ;       
  wire save_edge_macb0_int16;
  wire restore_edge_macb0_int16;
  wire   pwr1_on_macb0_int16      ;      
  wire   pwr2_on_macb0_int16      ;      
  // ETH116
  wire   rstn_non_srpg_macb1_int16;
  wire   gate_clk_macb1_int16     ;     
  wire   isolate_macb1_int16      ;       
  wire save_edge_macb1_int16;
  wire restore_edge_macb1_int16;
  wire   pwr1_on_macb1_int16      ;      
  wire   pwr2_on_macb1_int16      ;      
  // ETH216
  wire   rstn_non_srpg_macb2_int16;
  wire   gate_clk_macb2_int16     ;     
  wire   isolate_macb2_int16      ;       
  wire save_edge_macb2_int16;
  wire restore_edge_macb2_int16;
  wire   pwr1_on_macb2_int16      ;      
  wire   pwr2_on_macb2_int16      ;      
  // ETH316
  wire   rstn_non_srpg_macb3_int16;
  wire   gate_clk_macb3_int16     ;     
  wire   isolate_macb3_int16      ;       
  wire save_edge_macb3_int16;
  wire restore_edge_macb3_int16;
  wire   pwr1_on_macb3_int16      ;      
  wire   pwr2_on_macb3_int16      ;      

  // DMA16
  wire   rstn_non_srpg_dma_int16;
  wire   gate_clk_dma_int16     ;     
  wire   isolate_dma_int16      ;       
  wire save_edge_dma_int16;
  wire restore_edge_dma_int16;
  wire   pwr1_on_dma_int16      ;      
  wire   pwr2_on_dma_int16      ;      

  // CPU16
  wire   rstn_non_srpg_cpu_int16;
  wire   gate_clk_cpu_int16     ;     
  wire   isolate_cpu_int16      ;       
  wire save_edge_cpu_int16;
  wire restore_edge_cpu_int16;
  wire   pwr1_on_cpu_int16      ;      
  wire   pwr2_on_cpu_int16      ;  
  wire L1_ctrl_cpu_off_p16;    

  reg save_alut_tmp16;
  // DFS16 sm16

  reg cpu_shutoff_ctrl16;

  reg mte_mac_off_start16, mte_mac012_start16, mte_mac013_start16, mte_mac023_start16, mte_mac123_start16;
  reg mte_mac01_start16, mte_mac02_start16, mte_mac03_start16, mte_mac12_start16, mte_mac13_start16, mte_mac23_start16;
  reg mte_mac0_start16, mte_mac1_start16, mte_mac2_start16, mte_mac3_start16;
  reg mte_sys_hibernate16 ;
  reg mte_dma_start16 ;
  reg mte_cpu_start16 ;
  reg mte_mac_off_sleep_start16, mte_mac012_sleep_start16, mte_mac013_sleep_start16, mte_mac023_sleep_start16, mte_mac123_sleep_start16;
  reg mte_mac01_sleep_start16, mte_mac02_sleep_start16, mte_mac03_sleep_start16, mte_mac12_sleep_start16, mte_mac13_sleep_start16, mte_mac23_sleep_start16;
  reg mte_mac0_sleep_start16, mte_mac1_sleep_start16, mte_mac2_sleep_start16, mte_mac3_sleep_start16;
  reg mte_dma_sleep_start16;
  reg mte_mac_off_to_default16, mte_mac012_to_default16, mte_mac013_to_default16, mte_mac023_to_default16, mte_mac123_to_default16;
  reg mte_mac01_to_default16, mte_mac02_to_default16, mte_mac03_to_default16, mte_mac12_to_default16, mte_mac13_to_default16, mte_mac23_to_default16;
  reg mte_mac0_to_default16, mte_mac1_to_default16, mte_mac2_to_default16, mte_mac3_to_default16;
  reg mte_dma_isolate_dis16;
  reg mte_cpu_isolate_dis16;
  reg mte_sys_hibernate_to_default16;


  // Latch16 the CPU16 SLEEP16 invocation16
  always @( posedge pclk16 or negedge nprst16) 
  begin
    if(!nprst16)
      L1_ctrl_cpu_off_reg16 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg16 <= L1_ctrl_domain16[8];
  end

  // Create16 a pulse16 for sleep16 detection16 
  assign L1_ctrl_cpu_off_p16 =  L1_ctrl_domain16[8] && !L1_ctrl_cpu_off_reg16;
  
  // CPU16 sleep16 contol16 logic 
  // Shut16 off16 CPU16 when L1_ctrl_cpu_off_p16 is set
  // wake16 cpu16 when any interrupt16 is seen16  
  always @( posedge pclk16 or negedge nprst16) 
  begin
    if(!nprst16)
     cpu_shutoff_ctrl16 <= 1'b0;
    else if(cpu_shutoff_ctrl16 && int_source_h16)
     cpu_shutoff_ctrl16 <= 1'b0;
    else if (L1_ctrl_cpu_off_p16)
     cpu_shutoff_ctrl16 <= 1'b1;
  end
 
  // instantiate16 power16 contol16  block for uart16
  power_ctrl_sm16 i_urt_power_ctrl_sm16(
    .pclk16(pclk16),
    .nprst16(nprst16),
    .L1_module_req16(L1_ctrl_domain16[1]),
    .set_status_module16(set_status_urt16),
    .clr_status_module16(clr_status_urt16),
    .rstn_non_srpg_module16(rstn_non_srpg_urt_int16),
    .gate_clk_module16(gate_clk_urt_int16),
    .isolate_module16(isolate_urt_int16),
    .save_edge16(save_edge_urt_int16),
    .restore_edge16(restore_edge_urt_int16),
    .pwr1_on16(pwr1_on_urt_int16),
    .pwr2_on16(pwr2_on_urt_int16)
    );
  

  // instantiate16 power16 contol16  block for smc16
  power_ctrl_sm16 i_smc_power_ctrl_sm16(
    .pclk16(pclk16),
    .nprst16(nprst16),
    .L1_module_req16(L1_ctrl_domain16[2]),
    .set_status_module16(set_status_smc16),
    .clr_status_module16(clr_status_smc16),
    .rstn_non_srpg_module16(rstn_non_srpg_smc_int16),
    .gate_clk_module16(gate_clk_smc_int16),
    .isolate_module16(isolate_smc_int16),
    .save_edge16(save_edge_smc_int16),
    .restore_edge16(restore_edge_smc_int16),
    .pwr1_on16(pwr1_on_smc_int16),
    .pwr2_on16(pwr2_on_smc_int16)
    );

  // power16 control16 for macb016
  power_ctrl_sm16 i_macb0_power_ctrl_sm16(
    .pclk16(pclk16),
    .nprst16(nprst16),
    .L1_module_req16(L1_ctrl_domain16[3]),
    .set_status_module16(set_status_macb016),
    .clr_status_module16(clr_status_macb016),
    .rstn_non_srpg_module16(rstn_non_srpg_macb0_int16),
    .gate_clk_module16(gate_clk_macb0_int16),
    .isolate_module16(isolate_macb0_int16),
    .save_edge16(save_edge_macb0_int16),
    .restore_edge16(restore_edge_macb0_int16),
    .pwr1_on16(pwr1_on_macb0_int16),
    .pwr2_on16(pwr2_on_macb0_int16)
    );
  // power16 control16 for macb116
  power_ctrl_sm16 i_macb1_power_ctrl_sm16(
    .pclk16(pclk16),
    .nprst16(nprst16),
    .L1_module_req16(L1_ctrl_domain16[4]),
    .set_status_module16(set_status_macb116),
    .clr_status_module16(clr_status_macb116),
    .rstn_non_srpg_module16(rstn_non_srpg_macb1_int16),
    .gate_clk_module16(gate_clk_macb1_int16),
    .isolate_module16(isolate_macb1_int16),
    .save_edge16(save_edge_macb1_int16),
    .restore_edge16(restore_edge_macb1_int16),
    .pwr1_on16(pwr1_on_macb1_int16),
    .pwr2_on16(pwr2_on_macb1_int16)
    );
  // power16 control16 for macb216
  power_ctrl_sm16 i_macb2_power_ctrl_sm16(
    .pclk16(pclk16),
    .nprst16(nprst16),
    .L1_module_req16(L1_ctrl_domain16[5]),
    .set_status_module16(set_status_macb216),
    .clr_status_module16(clr_status_macb216),
    .rstn_non_srpg_module16(rstn_non_srpg_macb2_int16),
    .gate_clk_module16(gate_clk_macb2_int16),
    .isolate_module16(isolate_macb2_int16),
    .save_edge16(save_edge_macb2_int16),
    .restore_edge16(restore_edge_macb2_int16),
    .pwr1_on16(pwr1_on_macb2_int16),
    .pwr2_on16(pwr2_on_macb2_int16)
    );
  // power16 control16 for macb316
  power_ctrl_sm16 i_macb3_power_ctrl_sm16(
    .pclk16(pclk16),
    .nprst16(nprst16),
    .L1_module_req16(L1_ctrl_domain16[6]),
    .set_status_module16(set_status_macb316),
    .clr_status_module16(clr_status_macb316),
    .rstn_non_srpg_module16(rstn_non_srpg_macb3_int16),
    .gate_clk_module16(gate_clk_macb3_int16),
    .isolate_module16(isolate_macb3_int16),
    .save_edge16(save_edge_macb3_int16),
    .restore_edge16(restore_edge_macb3_int16),
    .pwr1_on16(pwr1_on_macb3_int16),
    .pwr2_on16(pwr2_on_macb3_int16)
    );
  // power16 control16 for dma16
  power_ctrl_sm16 i_dma_power_ctrl_sm16(
    .pclk16(pclk16),
    .nprst16(nprst16),
    .L1_module_req16(L1_ctrl_domain16[7]),
    .set_status_module16(set_status_dma16),
    .clr_status_module16(clr_status_dma16),
    .rstn_non_srpg_module16(rstn_non_srpg_dma_int16),
    .gate_clk_module16(gate_clk_dma_int16),
    .isolate_module16(isolate_dma_int16),
    .save_edge16(save_edge_dma_int16),
    .restore_edge16(restore_edge_dma_int16),
    .pwr1_on16(pwr1_on_dma_int16),
    .pwr2_on16(pwr2_on_dma_int16)
    );
  // power16 control16 for CPU16
  power_ctrl_sm16 i_cpu_power_ctrl_sm16(
    .pclk16(pclk16),
    .nprst16(nprst16),
    .L1_module_req16(cpu_shutoff_ctrl16),
    .set_status_module16(set_status_cpu16),
    .clr_status_module16(clr_status_cpu16),
    .rstn_non_srpg_module16(rstn_non_srpg_cpu_int16),
    .gate_clk_module16(gate_clk_cpu_int16),
    .isolate_module16(isolate_cpu_int16),
    .save_edge16(save_edge_cpu_int16),
    .restore_edge16(restore_edge_cpu_int16),
    .pwr1_on16(pwr1_on_cpu_int16),
    .pwr2_on16(pwr2_on_cpu_int16)
    );

  assign valid_reg_write16 =  (psel16 && pwrite16 && penable16);
  assign valid_reg_read16  =  (psel16 && (!pwrite16) && penable16);

  assign L1_ctrl_access16  =  (paddr16[15:0] == 16'b0000000000000100); 
  assign L1_status_access16 = (paddr16[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access16 =   (paddr16[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access16 = (paddr16[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control16 and status register
  always @(*)
  begin  
    if(valid_reg_read16 && L1_ctrl_access16) 
      prdata16 = L1_ctrl_reg16;
    else if (valid_reg_read16 && L1_status_access16)
      prdata16 = L1_status_reg16;
    else if (valid_reg_read16 && pcm_int_mask_access16)
      prdata16 = pcm_mask_reg16;
    else if (valid_reg_read16 && pcm_int_status_access16)
      prdata16 = pcm_status_reg16;
    else 
      prdata16 = 0;
  end

  assign set_status_mem16 =  (set_status_macb016 && set_status_macb116 && set_status_macb216 &&
                            set_status_macb316 && set_status_dma16 && set_status_cpu16);

  assign clr_status_mem16 =  (clr_status_macb016 && clr_status_macb116 && clr_status_macb216 &&
                            clr_status_macb316 && clr_status_dma16 && clr_status_cpu16);

  assign set_status_alut16 = (set_status_macb016 && set_status_macb116 && set_status_macb216 && set_status_macb316);

  assign clr_status_alut16 = (clr_status_macb016 || clr_status_macb116 || clr_status_macb216  || clr_status_macb316);

  // Write accesses to the control16 and status register
 
  always @(posedge pclk16 or negedge nprst16)
  begin
    if (!nprst16) begin
      L1_ctrl_reg16   <= 0;
      L1_status_reg16 <= 0;
      pcm_mask_reg16 <= 0;
    end else begin
      // CTRL16 reg updates16
      if (valid_reg_write16 && L1_ctrl_access16) 
        L1_ctrl_reg16 <= pwdata16; // Writes16 to the ctrl16 reg
      if (valid_reg_write16 && pcm_int_mask_access16) 
        pcm_mask_reg16 <= pwdata16; // Writes16 to the ctrl16 reg

      if (set_status_urt16 == 1'b1)  
        L1_status_reg16[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt16 == 1'b1) 
        L1_status_reg16[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc16 == 1'b1) 
        L1_status_reg16[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc16 == 1'b1) 
        L1_status_reg16[2] <= 1'b0; // Clear the status bit

      if (set_status_macb016 == 1'b1)  
        L1_status_reg16[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb016 == 1'b1) 
        L1_status_reg16[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb116 == 1'b1)  
        L1_status_reg16[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb116 == 1'b1) 
        L1_status_reg16[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb216 == 1'b1)  
        L1_status_reg16[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb216 == 1'b1) 
        L1_status_reg16[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb316 == 1'b1)  
        L1_status_reg16[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb316 == 1'b1) 
        L1_status_reg16[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma16 == 1'b1)  
        L1_status_reg16[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma16 == 1'b1) 
        L1_status_reg16[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu16 == 1'b1)  
        L1_status_reg16[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu16 == 1'b1) 
        L1_status_reg16[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut16 == 1'b1)  
        L1_status_reg16[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut16 == 1'b1) 
        L1_status_reg16[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem16 == 1'b1)  
        L1_status_reg16[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem16 == 1'b1) 
        L1_status_reg16[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused16 bits of pcm_status_reg16 are tied16 to 0
  always @(posedge pclk16 or negedge nprst16)
  begin
    if (!nprst16)
      pcm_status_reg16[31:4] <= 'b0;
    else  
      pcm_status_reg16[31:4] <= pcm_status_reg16[31:4];
  end
  
  // interrupt16 only of h/w assisted16 wakeup
  // MAC16 3
  always @(posedge pclk16 or negedge nprst16)
  begin
    if(!nprst16)
      pcm_status_reg16[3] <= 1'b0;
    else if (valid_reg_write16 && pcm_int_status_access16) 
      pcm_status_reg16[3] <= pwdata16[3];
    else if (macb3_wakeup16 & ~pcm_mask_reg16[3])
      pcm_status_reg16[3] <= 1'b1;
    else if (valid_reg_read16 && pcm_int_status_access16) 
      pcm_status_reg16[3] <= 1'b0;
    else
      pcm_status_reg16[3] <= pcm_status_reg16[3];
  end  
   
  // MAC16 2
  always @(posedge pclk16 or negedge nprst16)
  begin
    if(!nprst16)
      pcm_status_reg16[2] <= 1'b0;
    else if (valid_reg_write16 && pcm_int_status_access16) 
      pcm_status_reg16[2] <= pwdata16[2];
    else if (macb2_wakeup16 & ~pcm_mask_reg16[2])
      pcm_status_reg16[2] <= 1'b1;
    else if (valid_reg_read16 && pcm_int_status_access16) 
      pcm_status_reg16[2] <= 1'b0;
    else
      pcm_status_reg16[2] <= pcm_status_reg16[2];
  end  

  // MAC16 1
  always @(posedge pclk16 or negedge nprst16)
  begin
    if(!nprst16)
      pcm_status_reg16[1] <= 1'b0;
    else if (valid_reg_write16 && pcm_int_status_access16) 
      pcm_status_reg16[1] <= pwdata16[1];
    else if (macb1_wakeup16 & ~pcm_mask_reg16[1])
      pcm_status_reg16[1] <= 1'b1;
    else if (valid_reg_read16 && pcm_int_status_access16) 
      pcm_status_reg16[1] <= 1'b0;
    else
      pcm_status_reg16[1] <= pcm_status_reg16[1];
  end  
   
  // MAC16 0
  always @(posedge pclk16 or negedge nprst16)
  begin
    if(!nprst16)
      pcm_status_reg16[0] <= 1'b0;
    else if (valid_reg_write16 && pcm_int_status_access16) 
      pcm_status_reg16[0] <= pwdata16[0];
    else if (macb0_wakeup16 & ~pcm_mask_reg16[0])
      pcm_status_reg16[0] <= 1'b1;
    else if (valid_reg_read16 && pcm_int_status_access16) 
      pcm_status_reg16[0] <= 1'b0;
    else
      pcm_status_reg16[0] <= pcm_status_reg16[0];
  end  

  assign pcm_macb_wakeup_int16 = |pcm_status_reg16;

  reg [31:0] L1_ctrl_reg116;
  always @(posedge pclk16 or negedge nprst16)
  begin
    if(!nprst16)
      L1_ctrl_reg116 <= 0;
    else
      L1_ctrl_reg116 <= L1_ctrl_reg16;
  end

  // Program16 mode decode
  always @(L1_ctrl_reg16 or L1_ctrl_reg116 or int_source_h16 or cpu_shutoff_ctrl16) begin
    mte_smc_start16 = 0;
    mte_uart_start16 = 0;
    mte_smc_uart_start16  = 0;
    mte_mac_off_start16  = 0;
    mte_mac012_start16 = 0;
    mte_mac013_start16 = 0;
    mte_mac023_start16 = 0;
    mte_mac123_start16 = 0;
    mte_mac01_start16 = 0;
    mte_mac02_start16 = 0;
    mte_mac03_start16 = 0;
    mte_mac12_start16 = 0;
    mte_mac13_start16 = 0;
    mte_mac23_start16 = 0;
    mte_mac0_start16 = 0;
    mte_mac1_start16 = 0;
    mte_mac2_start16 = 0;
    mte_mac3_start16 = 0;
    mte_sys_hibernate16 = 0 ;
    mte_dma_start16 = 0 ;
    mte_cpu_start16 = 0 ;

    mte_mac0_sleep_start16 = (L1_ctrl_reg16 ==  'h14) && (L1_ctrl_reg116 == 'h4 );
    mte_mac1_sleep_start16 = (L1_ctrl_reg16 ==  'h14) && (L1_ctrl_reg116 == 'h5 ); 
    mte_mac2_sleep_start16 = (L1_ctrl_reg16 ==  'h14) && (L1_ctrl_reg116 == 'h6 ); 
    mte_mac3_sleep_start16 = (L1_ctrl_reg16 ==  'h14) && (L1_ctrl_reg116 == 'h7 ); 
    mte_mac01_sleep_start16 = (L1_ctrl_reg16 ==  'h14) && (L1_ctrl_reg116 == 'h8 ); 
    mte_mac02_sleep_start16 = (L1_ctrl_reg16 ==  'h14) && (L1_ctrl_reg116 == 'h9 ); 
    mte_mac03_sleep_start16 = (L1_ctrl_reg16 ==  'h14) && (L1_ctrl_reg116 == 'hA ); 
    mte_mac12_sleep_start16 = (L1_ctrl_reg16 ==  'h14) && (L1_ctrl_reg116 == 'hB ); 
    mte_mac13_sleep_start16 = (L1_ctrl_reg16 ==  'h14) && (L1_ctrl_reg116 == 'hC ); 
    mte_mac23_sleep_start16 = (L1_ctrl_reg16 ==  'h14) && (L1_ctrl_reg116 == 'hD ); 
    mte_mac012_sleep_start16 = (L1_ctrl_reg16 ==  'h14) && (L1_ctrl_reg116 == 'hE ); 
    mte_mac013_sleep_start16 = (L1_ctrl_reg16 ==  'h14) && (L1_ctrl_reg116 == 'hF ); 
    mte_mac023_sleep_start16 = (L1_ctrl_reg16 ==  'h14) && (L1_ctrl_reg116 == 'h10 ); 
    mte_mac123_sleep_start16 = (L1_ctrl_reg16 ==  'h14) && (L1_ctrl_reg116 == 'h11 ); 
    mte_mac_off_sleep_start16 =  (L1_ctrl_reg16 == 'h14) && (L1_ctrl_reg116 == 'h12 );
    mte_dma_sleep_start16 =  (L1_ctrl_reg16 == 'h14) && (L1_ctrl_reg116 == 'h13 );

    mte_pm_uart_to_default_start16 = (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'h1);
    mte_pm_smc_to_default_start16 = (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'h2);
    mte_pm_smc_uart_to_default_start16 = (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'h3); 
    mte_mac0_to_default16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'h4); 
    mte_mac1_to_default16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'h5); 
    mte_mac2_to_default16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'h6); 
    mte_mac3_to_default16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'h7); 
    mte_mac01_to_default16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'h8); 
    mte_mac02_to_default16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'h9); 
    mte_mac03_to_default16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'hA); 
    mte_mac12_to_default16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'hB); 
    mte_mac13_to_default16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'hC); 
    mte_mac23_to_default16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'hD); 
    mte_mac012_to_default16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'hE); 
    mte_mac013_to_default16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'hF); 
    mte_mac023_to_default16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'h10); 
    mte_mac123_to_default16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'h11); 
    mte_mac_off_to_default16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'h12); 
    mte_dma_isolate_dis16 =  (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'h13); 
    mte_cpu_isolate_dis16 =  (int_source_h16) && (cpu_shutoff_ctrl16) && (L1_ctrl_reg16 != 'h15);
    mte_sys_hibernate_to_default16 = (L1_ctrl_reg16 == 32'h0) && (L1_ctrl_reg116 == 'h15); 

   
    if (L1_ctrl_reg116 == 'h0) begin // This16 check is to make mte_cpu_start16
                                   // is set only when you from default state 
      case (L1_ctrl_reg16)
        'h0 : L1_ctrl_domain16 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain16 = 32'h2; // PM_uart16
                mte_uart_start16 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain16 = 32'h4; // PM_smc16
                mte_smc_start16 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain16 = 32'h6; // PM_smc_uart16
                mte_smc_uart_start16 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain16 = 32'h8; //  PM_macb016
                mte_mac0_start16 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain16 = 32'h10; //  PM_macb116
                mte_mac1_start16 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain16 = 32'h20; //  PM_macb216
                mte_mac2_start16 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain16 = 32'h40; //  PM_macb316
                mte_mac3_start16 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain16 = 32'h18; //  PM_macb0116
                mte_mac01_start16 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain16 = 32'h28; //  PM_macb0216
                mte_mac02_start16 = 1;
              end
        'hA : begin  
                L1_ctrl_domain16 = 32'h48; //  PM_macb0316
                mte_mac03_start16 = 1;
              end
        'hB : begin  
                L1_ctrl_domain16 = 32'h30; //  PM_macb1216
                mte_mac12_start16 = 1;
              end
        'hC : begin  
                L1_ctrl_domain16 = 32'h50; //  PM_macb1316
                mte_mac13_start16 = 1;
              end
        'hD : begin  
                L1_ctrl_domain16 = 32'h60; //  PM_macb2316
                mte_mac23_start16 = 1;
              end
        'hE : begin  
                L1_ctrl_domain16 = 32'h38; //  PM_macb01216
                mte_mac012_start16 = 1;
              end
        'hF : begin  
                L1_ctrl_domain16 = 32'h58; //  PM_macb01316
                mte_mac013_start16 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain16 = 32'h68; //  PM_macb02316
                mte_mac023_start16 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain16 = 32'h70; //  PM_macb12316
                mte_mac123_start16 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain16 = 32'h78; //  PM_macb_off16
                mte_mac_off_start16 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain16 = 32'h80; //  PM_dma16
                mte_dma_start16 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain16 = 32'h100; //  PM_cpu_sleep16
                mte_cpu_start16 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain16 = 32'h1FE; //  PM_hibernate16
                mte_sys_hibernate16 = 1;
              end
         default: L1_ctrl_domain16 = 32'h0;
      endcase
    end
  end


  wire to_default16 = (L1_ctrl_reg16 == 0);

  // Scan16 mode gating16 of power16 and isolation16 control16 signals16
  //SMC16
  assign rstn_non_srpg_smc16  = (scan_mode16 == 1'b0) ? rstn_non_srpg_smc_int16 : 1'b1;  
  assign gate_clk_smc16       = (scan_mode16 == 1'b0) ? gate_clk_smc_int16 : 1'b0;     
  assign isolate_smc16        = (scan_mode16 == 1'b0) ? isolate_smc_int16 : 1'b0;      
  assign pwr1_on_smc16        = (scan_mode16 == 1'b0) ? pwr1_on_smc_int16 : 1'b1;       
  assign pwr2_on_smc16        = (scan_mode16 == 1'b0) ? pwr2_on_smc_int16 : 1'b1;       
  assign pwr1_off_smc16       = (scan_mode16 == 1'b0) ? (!pwr1_on_smc_int16) : 1'b0;       
  assign pwr2_off_smc16       = (scan_mode16 == 1'b0) ? (!pwr2_on_smc_int16) : 1'b0;       
  assign save_edge_smc16       = (scan_mode16 == 1'b0) ? (save_edge_smc_int16) : 1'b0;       
  assign restore_edge_smc16       = (scan_mode16 == 1'b0) ? (restore_edge_smc_int16) : 1'b0;       

  //URT16
  assign rstn_non_srpg_urt16  = (scan_mode16 == 1'b0) ?  rstn_non_srpg_urt_int16 : 1'b1;  
  assign gate_clk_urt16       = (scan_mode16 == 1'b0) ?  gate_clk_urt_int16      : 1'b0;     
  assign isolate_urt16        = (scan_mode16 == 1'b0) ?  isolate_urt_int16       : 1'b0;      
  assign pwr1_on_urt16        = (scan_mode16 == 1'b0) ?  pwr1_on_urt_int16       : 1'b1;       
  assign pwr2_on_urt16        = (scan_mode16 == 1'b0) ?  pwr2_on_urt_int16       : 1'b1;       
  assign pwr1_off_urt16       = (scan_mode16 == 1'b0) ?  (!pwr1_on_urt_int16)  : 1'b0;       
  assign pwr2_off_urt16       = (scan_mode16 == 1'b0) ?  (!pwr2_on_urt_int16)  : 1'b0;       
  assign save_edge_urt16       = (scan_mode16 == 1'b0) ? (save_edge_urt_int16) : 1'b0;       
  assign restore_edge_urt16       = (scan_mode16 == 1'b0) ? (restore_edge_urt_int16) : 1'b0;       

  //ETH016
  assign rstn_non_srpg_macb016 = (scan_mode16 == 1'b0) ?  rstn_non_srpg_macb0_int16 : 1'b1;  
  assign gate_clk_macb016       = (scan_mode16 == 1'b0) ?  gate_clk_macb0_int16      : 1'b0;     
  assign isolate_macb016        = (scan_mode16 == 1'b0) ?  isolate_macb0_int16       : 1'b0;      
  assign pwr1_on_macb016        = (scan_mode16 == 1'b0) ?  pwr1_on_macb0_int16       : 1'b1;       
  assign pwr2_on_macb016        = (scan_mode16 == 1'b0) ?  pwr2_on_macb0_int16       : 1'b1;       
  assign pwr1_off_macb016       = (scan_mode16 == 1'b0) ?  (!pwr1_on_macb0_int16)  : 1'b0;       
  assign pwr2_off_macb016       = (scan_mode16 == 1'b0) ?  (!pwr2_on_macb0_int16)  : 1'b0;       
  assign save_edge_macb016       = (scan_mode16 == 1'b0) ? (save_edge_macb0_int16) : 1'b0;       
  assign restore_edge_macb016       = (scan_mode16 == 1'b0) ? (restore_edge_macb0_int16) : 1'b0;       

  //ETH116
  assign rstn_non_srpg_macb116 = (scan_mode16 == 1'b0) ?  rstn_non_srpg_macb1_int16 : 1'b1;  
  assign gate_clk_macb116       = (scan_mode16 == 1'b0) ?  gate_clk_macb1_int16      : 1'b0;     
  assign isolate_macb116        = (scan_mode16 == 1'b0) ?  isolate_macb1_int16       : 1'b0;      
  assign pwr1_on_macb116        = (scan_mode16 == 1'b0) ?  pwr1_on_macb1_int16       : 1'b1;       
  assign pwr2_on_macb116        = (scan_mode16 == 1'b0) ?  pwr2_on_macb1_int16       : 1'b1;       
  assign pwr1_off_macb116       = (scan_mode16 == 1'b0) ?  (!pwr1_on_macb1_int16)  : 1'b0;       
  assign pwr2_off_macb116       = (scan_mode16 == 1'b0) ?  (!pwr2_on_macb1_int16)  : 1'b0;       
  assign save_edge_macb116       = (scan_mode16 == 1'b0) ? (save_edge_macb1_int16) : 1'b0;       
  assign restore_edge_macb116       = (scan_mode16 == 1'b0) ? (restore_edge_macb1_int16) : 1'b0;       

  //ETH216
  assign rstn_non_srpg_macb216 = (scan_mode16 == 1'b0) ?  rstn_non_srpg_macb2_int16 : 1'b1;  
  assign gate_clk_macb216       = (scan_mode16 == 1'b0) ?  gate_clk_macb2_int16      : 1'b0;     
  assign isolate_macb216        = (scan_mode16 == 1'b0) ?  isolate_macb2_int16       : 1'b0;      
  assign pwr1_on_macb216        = (scan_mode16 == 1'b0) ?  pwr1_on_macb2_int16       : 1'b1;       
  assign pwr2_on_macb216        = (scan_mode16 == 1'b0) ?  pwr2_on_macb2_int16       : 1'b1;       
  assign pwr1_off_macb216       = (scan_mode16 == 1'b0) ?  (!pwr1_on_macb2_int16)  : 1'b0;       
  assign pwr2_off_macb216       = (scan_mode16 == 1'b0) ?  (!pwr2_on_macb2_int16)  : 1'b0;       
  assign save_edge_macb216       = (scan_mode16 == 1'b0) ? (save_edge_macb2_int16) : 1'b0;       
  assign restore_edge_macb216       = (scan_mode16 == 1'b0) ? (restore_edge_macb2_int16) : 1'b0;       

  //ETH316
  assign rstn_non_srpg_macb316 = (scan_mode16 == 1'b0) ?  rstn_non_srpg_macb3_int16 : 1'b1;  
  assign gate_clk_macb316       = (scan_mode16 == 1'b0) ?  gate_clk_macb3_int16      : 1'b0;     
  assign isolate_macb316        = (scan_mode16 == 1'b0) ?  isolate_macb3_int16       : 1'b0;      
  assign pwr1_on_macb316        = (scan_mode16 == 1'b0) ?  pwr1_on_macb3_int16       : 1'b1;       
  assign pwr2_on_macb316        = (scan_mode16 == 1'b0) ?  pwr2_on_macb3_int16       : 1'b1;       
  assign pwr1_off_macb316       = (scan_mode16 == 1'b0) ?  (!pwr1_on_macb3_int16)  : 1'b0;       
  assign pwr2_off_macb316       = (scan_mode16 == 1'b0) ?  (!pwr2_on_macb3_int16)  : 1'b0;       
  assign save_edge_macb316       = (scan_mode16 == 1'b0) ? (save_edge_macb3_int16) : 1'b0;       
  assign restore_edge_macb316       = (scan_mode16 == 1'b0) ? (restore_edge_macb3_int16) : 1'b0;       

  // MEM16
  assign rstn_non_srpg_mem16 =   (rstn_non_srpg_macb016 && rstn_non_srpg_macb116 && rstn_non_srpg_macb216 &&
                                rstn_non_srpg_macb316 && rstn_non_srpg_dma16 && rstn_non_srpg_cpu16 && rstn_non_srpg_urt16 &&
                                rstn_non_srpg_smc16);

  assign gate_clk_mem16 =  (gate_clk_macb016 && gate_clk_macb116 && gate_clk_macb216 &&
                            gate_clk_macb316 && gate_clk_dma16 && gate_clk_cpu16 && gate_clk_urt16 && gate_clk_smc16);

  assign isolate_mem16  = (isolate_macb016 && isolate_macb116 && isolate_macb216 &&
                         isolate_macb316 && isolate_dma16 && isolate_cpu16 && isolate_urt16 && isolate_smc16);


  assign pwr1_on_mem16        =   ~pwr1_off_mem16;

  assign pwr2_on_mem16        =   ~pwr2_off_mem16;

  assign pwr1_off_mem16       =  (pwr1_off_macb016 && pwr1_off_macb116 && pwr1_off_macb216 &&
                                 pwr1_off_macb316 && pwr1_off_dma16 && pwr1_off_cpu16 && pwr1_off_urt16 && pwr1_off_smc16);


  assign pwr2_off_mem16       =  (pwr2_off_macb016 && pwr2_off_macb116 && pwr2_off_macb216 &&
                                pwr2_off_macb316 && pwr2_off_dma16 && pwr2_off_cpu16 && pwr2_off_urt16 && pwr2_off_smc16);

  assign save_edge_mem16      =  (save_edge_macb016 && save_edge_macb116 && save_edge_macb216 &&
                                save_edge_macb316 && save_edge_dma16 && save_edge_cpu16 && save_edge_smc16 && save_edge_urt16);

  assign restore_edge_mem16   =  (restore_edge_macb016 && restore_edge_macb116 && restore_edge_macb216  &&
                                restore_edge_macb316 && restore_edge_dma16 && restore_edge_cpu16 && restore_edge_urt16 &&
                                restore_edge_smc16);

  assign standby_mem016 = pwr1_off_macb016 && (~ (pwr1_off_macb016 && pwr1_off_macb116 && pwr1_off_macb216 && pwr1_off_macb316 && pwr1_off_urt16 && pwr1_off_smc16 && pwr1_off_dma16 && pwr1_off_cpu16));
  assign standby_mem116 = pwr1_off_macb116 && (~ (pwr1_off_macb016 && pwr1_off_macb116 && pwr1_off_macb216 && pwr1_off_macb316 && pwr1_off_urt16 && pwr1_off_smc16 && pwr1_off_dma16 && pwr1_off_cpu16));
  assign standby_mem216 = pwr1_off_macb216 && (~ (pwr1_off_macb016 && pwr1_off_macb116 && pwr1_off_macb216 && pwr1_off_macb316 && pwr1_off_urt16 && pwr1_off_smc16 && pwr1_off_dma16 && pwr1_off_cpu16));
  assign standby_mem316 = pwr1_off_macb316 && (~ (pwr1_off_macb016 && pwr1_off_macb116 && pwr1_off_macb216 && pwr1_off_macb316 && pwr1_off_urt16 && pwr1_off_smc16 && pwr1_off_dma16 && pwr1_off_cpu16));

  assign pwr1_off_mem016 = pwr1_off_mem16;
  assign pwr1_off_mem116 = pwr1_off_mem16;
  assign pwr1_off_mem216 = pwr1_off_mem16;
  assign pwr1_off_mem316 = pwr1_off_mem16;

  assign rstn_non_srpg_alut16  =  (rstn_non_srpg_macb016 && rstn_non_srpg_macb116 && rstn_non_srpg_macb216 && rstn_non_srpg_macb316);


   assign gate_clk_alut16       =  (gate_clk_macb016 && gate_clk_macb116 && gate_clk_macb216 && gate_clk_macb316);


    assign isolate_alut16        =  (isolate_macb016 && isolate_macb116 && isolate_macb216 && isolate_macb316);


    assign pwr1_on_alut16        =  (pwr1_on_macb016 || pwr1_on_macb116 || pwr1_on_macb216 || pwr1_on_macb316);


    assign pwr2_on_alut16        =  (pwr2_on_macb016 || pwr2_on_macb116 || pwr2_on_macb216 || pwr2_on_macb316);


    assign pwr1_off_alut16       =  (pwr1_off_macb016 && pwr1_off_macb116 && pwr1_off_macb216 && pwr1_off_macb316);


    assign pwr2_off_alut16       =  (pwr2_off_macb016 && pwr2_off_macb116 && pwr2_off_macb216 && pwr2_off_macb316);


    assign save_edge_alut16      =  (save_edge_macb016 && save_edge_macb116 && save_edge_macb216 && save_edge_macb316);


    assign restore_edge_alut16   =  (restore_edge_macb016 || restore_edge_macb116 || restore_edge_macb216 ||
                                   restore_edge_macb316) && save_alut_tmp16;

     // alut16 power16 off16 detection16
  always @(posedge pclk16 or negedge nprst16) begin
    if (!nprst16) 
       save_alut_tmp16 <= 0;
    else if (restore_edge_alut16)
       save_alut_tmp16 <= 0;
    else if (save_edge_alut16)
       save_alut_tmp16 <= 1;
  end

  //DMA16
  assign rstn_non_srpg_dma16 = (scan_mode16 == 1'b0) ?  rstn_non_srpg_dma_int16 : 1'b1;  
  assign gate_clk_dma16       = (scan_mode16 == 1'b0) ?  gate_clk_dma_int16      : 1'b0;     
  assign isolate_dma16        = (scan_mode16 == 1'b0) ?  isolate_dma_int16       : 1'b0;      
  assign pwr1_on_dma16        = (scan_mode16 == 1'b0) ?  pwr1_on_dma_int16       : 1'b1;       
  assign pwr2_on_dma16        = (scan_mode16 == 1'b0) ?  pwr2_on_dma_int16       : 1'b1;       
  assign pwr1_off_dma16       = (scan_mode16 == 1'b0) ?  (!pwr1_on_dma_int16)  : 1'b0;       
  assign pwr2_off_dma16       = (scan_mode16 == 1'b0) ?  (!pwr2_on_dma_int16)  : 1'b0;       
  assign save_edge_dma16       = (scan_mode16 == 1'b0) ? (save_edge_dma_int16) : 1'b0;       
  assign restore_edge_dma16       = (scan_mode16 == 1'b0) ? (restore_edge_dma_int16) : 1'b0;       

  //CPU16
  assign rstn_non_srpg_cpu16 = (scan_mode16 == 1'b0) ?  rstn_non_srpg_cpu_int16 : 1'b1;  
  assign gate_clk_cpu16       = (scan_mode16 == 1'b0) ?  gate_clk_cpu_int16      : 1'b0;     
  assign isolate_cpu16        = (scan_mode16 == 1'b0) ?  isolate_cpu_int16       : 1'b0;      
  assign pwr1_on_cpu16        = (scan_mode16 == 1'b0) ?  pwr1_on_cpu_int16       : 1'b1;       
  assign pwr2_on_cpu16        = (scan_mode16 == 1'b0) ?  pwr2_on_cpu_int16       : 1'b1;       
  assign pwr1_off_cpu16       = (scan_mode16 == 1'b0) ?  (!pwr1_on_cpu_int16)  : 1'b0;       
  assign pwr2_off_cpu16       = (scan_mode16 == 1'b0) ?  (!pwr2_on_cpu_int16)  : 1'b0;       
  assign save_edge_cpu16       = (scan_mode16 == 1'b0) ? (save_edge_cpu_int16) : 1'b0;       
  assign restore_edge_cpu16       = (scan_mode16 == 1'b0) ? (restore_edge_cpu_int16) : 1'b0;       



  // ASE16

   reg ase_core_12v16, ase_core_10v16, ase_core_08v16, ase_core_06v16;
   reg ase_macb0_12v16,ase_macb1_12v16,ase_macb2_12v16,ase_macb3_12v16;

    // core16 ase16

    // core16 at 1.0 v if (smc16 off16, urt16 off16, macb016 off16, macb116 off16, macb216 off16, macb316 off16
   // core16 at 0.8v if (mac01off16, macb02off16, macb03off16, macb12off16, mac13off16, mac23off16,
   // core16 at 0.6v if (mac012off16, mac013off16, mac023off16, mac123off16, mac0123off16
    // else core16 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb016 && pwr1_off_macb116 && pwr1_off_macb216 && pwr1_off_macb316) || // all mac16 off16
       (pwr1_off_macb316 && pwr1_off_macb216 && pwr1_off_macb116) || // mac123off16 
       (pwr1_off_macb316 && pwr1_off_macb216 && pwr1_off_macb016) || // mac023off16 
       (pwr1_off_macb316 && pwr1_off_macb116 && pwr1_off_macb016) || // mac013off16 
       (pwr1_off_macb216 && pwr1_off_macb116 && pwr1_off_macb016) )  // mac012off16 
       begin
         ase_core_12v16 = 0;
         ase_core_10v16 = 0;
         ase_core_08v16 = 0;
         ase_core_06v16 = 1;
       end
     else if( (pwr1_off_macb216 && pwr1_off_macb316) || // mac2316 off16
         (pwr1_off_macb316 && pwr1_off_macb116) || // mac13off16 
         (pwr1_off_macb116 && pwr1_off_macb216) || // mac12off16 
         (pwr1_off_macb316 && pwr1_off_macb016) || // mac03off16 
         (pwr1_off_macb216 && pwr1_off_macb016) || // mac02off16 
         (pwr1_off_macb116 && pwr1_off_macb016))  // mac01off16 
       begin
         ase_core_12v16 = 0;
         ase_core_10v16 = 0;
         ase_core_08v16 = 1;
         ase_core_06v16 = 0;
       end
     else if( (pwr1_off_smc16) || // smc16 off16
         (pwr1_off_macb016 ) || // mac0off16 
         (pwr1_off_macb116 ) || // mac1off16 
         (pwr1_off_macb216 ) || // mac2off16 
         (pwr1_off_macb316 ))  // mac3off16 
       begin
         ase_core_12v16 = 0;
         ase_core_10v16 = 1;
         ase_core_08v16 = 0;
         ase_core_06v16 = 0;
       end
     else if (pwr1_off_urt16)
       begin
         ase_core_12v16 = 1;
         ase_core_10v16 = 0;
         ase_core_08v16 = 0;
         ase_core_06v16 = 0;
       end
     else
       begin
         ase_core_12v16 = 1;
         ase_core_10v16 = 0;
         ase_core_08v16 = 0;
         ase_core_06v16 = 0;
       end
   end


   // cpu16
   // cpu16 @ 1.0v when macoff16, 
   // 
   reg ase_cpu_10v16, ase_cpu_12v16;
   always @(*) begin
    if(pwr1_off_cpu16) begin
     ase_cpu_12v16 = 1'b0;
     ase_cpu_10v16 = 1'b0;
    end
    else if(pwr1_off_macb016 || pwr1_off_macb116 || pwr1_off_macb216 || pwr1_off_macb316)
    begin
     ase_cpu_12v16 = 1'b0;
     ase_cpu_10v16 = 1'b1;
    end
    else
    begin
     ase_cpu_12v16 = 1'b1;
     ase_cpu_10v16 = 1'b0;
    end
   end

   // dma16
   // dma16 @v116.0 for macoff16, 

   reg ase_dma_10v16, ase_dma_12v16;
   always @(*) begin
    if(pwr1_off_dma16) begin
     ase_dma_12v16 = 1'b0;
     ase_dma_10v16 = 1'b0;
    end
    else if(pwr1_off_macb016 || pwr1_off_macb116 || pwr1_off_macb216 || pwr1_off_macb316)
    begin
     ase_dma_12v16 = 1'b0;
     ase_dma_10v16 = 1'b1;
    end
    else
    begin
     ase_dma_12v16 = 1'b1;
     ase_dma_10v16 = 1'b0;
    end
   end

   // alut16
   // @ v116.0 for macoff16

   reg ase_alut_10v16, ase_alut_12v16;
   always @(*) begin
    if(pwr1_off_alut16) begin
     ase_alut_12v16 = 1'b0;
     ase_alut_10v16 = 1'b0;
    end
    else if(pwr1_off_macb016 || pwr1_off_macb116 || pwr1_off_macb216 || pwr1_off_macb316)
    begin
     ase_alut_12v16 = 1'b0;
     ase_alut_10v16 = 1'b1;
    end
    else
    begin
     ase_alut_12v16 = 1'b1;
     ase_alut_10v16 = 1'b0;
    end
   end




   reg ase_uart_12v16;
   reg ase_uart_10v16;
   reg ase_uart_08v16;
   reg ase_uart_06v16;

   reg ase_smc_12v16;


   always @(*) begin
     if(pwr1_off_urt16) begin // uart16 off16
       ase_uart_08v16 = 1'b0;
       ase_uart_06v16 = 1'b0;
       ase_uart_10v16 = 1'b0;
       ase_uart_12v16 = 1'b0;
     end 
     else if( (pwr1_off_macb016 && pwr1_off_macb116 && pwr1_off_macb216 && pwr1_off_macb316) || // all mac16 off16
       (pwr1_off_macb316 && pwr1_off_macb216 && pwr1_off_macb116) || // mac123off16 
       (pwr1_off_macb316 && pwr1_off_macb216 && pwr1_off_macb016) || // mac023off16 
       (pwr1_off_macb316 && pwr1_off_macb116 && pwr1_off_macb016) || // mac013off16 
       (pwr1_off_macb216 && pwr1_off_macb116 && pwr1_off_macb016) )  // mac012off16 
     begin
       ase_uart_06v16 = 1'b1;
       ase_uart_08v16 = 1'b0;
       ase_uart_10v16 = 1'b0;
       ase_uart_12v16 = 1'b0;
     end
     else if( (pwr1_off_macb216 && pwr1_off_macb316) || // mac2316 off16
         (pwr1_off_macb316 && pwr1_off_macb116) || // mac13off16 
         (pwr1_off_macb116 && pwr1_off_macb216) || // mac12off16 
         (pwr1_off_macb316 && pwr1_off_macb016) || // mac03off16 
         (pwr1_off_macb116 && pwr1_off_macb016))  // mac01off16  
     begin
       ase_uart_06v16 = 1'b0;
       ase_uart_08v16 = 1'b1;
       ase_uart_10v16 = 1'b0;
       ase_uart_12v16 = 1'b0;
     end
     else if (pwr1_off_smc16 || pwr1_off_macb016 || pwr1_off_macb116 || pwr1_off_macb216 || pwr1_off_macb316) begin // smc16 off16
       ase_uart_08v16 = 1'b0;
       ase_uart_06v16 = 1'b0;
       ase_uart_10v16 = 1'b1;
       ase_uart_12v16 = 1'b0;
     end 
     else begin
       ase_uart_08v16 = 1'b0;
       ase_uart_06v16 = 1'b0;
       ase_uart_10v16 = 1'b0;
       ase_uart_12v16 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc16) begin
     if (pwr1_off_smc16)  // smc16 off16
       ase_smc_12v16 = 1'b0;
    else
       ase_smc_12v16 = 1'b1;
   end

   
   always @(pwr1_off_macb016) begin
     if (pwr1_off_macb016) // macb016 off16
       ase_macb0_12v16 = 1'b0;
     else
       ase_macb0_12v16 = 1'b1;
   end

   always @(pwr1_off_macb116) begin
     if (pwr1_off_macb116) // macb116 off16
       ase_macb1_12v16 = 1'b0;
     else
       ase_macb1_12v16 = 1'b1;
   end

   always @(pwr1_off_macb216) begin // macb216 off16
     if (pwr1_off_macb216) // macb216 off16
       ase_macb2_12v16 = 1'b0;
     else
       ase_macb2_12v16 = 1'b1;
   end

   always @(pwr1_off_macb316) begin // macb316 off16
     if (pwr1_off_macb316) // macb316 off16
       ase_macb3_12v16 = 1'b0;
     else
       ase_macb3_12v16 = 1'b1;
   end


   // core16 voltage16 for vco16
  assign core12v16 = ase_macb0_12v16 & ase_macb1_12v16 & ase_macb2_12v16 & ase_macb3_12v16;

  assign core10v16 =  (ase_macb0_12v16 & ase_macb1_12v16 & ase_macb2_12v16 & (!ase_macb3_12v16)) ||
                    (ase_macb0_12v16 & ase_macb1_12v16 & (!ase_macb2_12v16) & ase_macb3_12v16) ||
                    (ase_macb0_12v16 & (!ase_macb1_12v16) & ase_macb2_12v16 & ase_macb3_12v16) ||
                    ((!ase_macb0_12v16) & ase_macb1_12v16 & ase_macb2_12v16 & ase_macb3_12v16);

  assign core08v16 =  ((!ase_macb0_12v16) & (!ase_macb1_12v16) & (ase_macb2_12v16) & (ase_macb3_12v16)) ||
                    ((!ase_macb0_12v16) & (ase_macb1_12v16) & (!ase_macb2_12v16) & (ase_macb3_12v16)) ||
                    ((!ase_macb0_12v16) & (ase_macb1_12v16) & (ase_macb2_12v16) & (!ase_macb3_12v16)) ||
                    ((ase_macb0_12v16) & (!ase_macb1_12v16) & (!ase_macb2_12v16) & (ase_macb3_12v16)) ||
                    ((ase_macb0_12v16) & (!ase_macb1_12v16) & (ase_macb2_12v16) & (!ase_macb3_12v16)) ||
                    ((ase_macb0_12v16) & (ase_macb1_12v16) & (!ase_macb2_12v16) & (!ase_macb3_12v16));

  assign core06v16 =  ((!ase_macb0_12v16) & (!ase_macb1_12v16) & (!ase_macb2_12v16) & (ase_macb3_12v16)) ||
                    ((!ase_macb0_12v16) & (!ase_macb1_12v16) & (ase_macb2_12v16) & (!ase_macb3_12v16)) ||
                    ((!ase_macb0_12v16) & (ase_macb1_12v16) & (!ase_macb2_12v16) & (!ase_macb3_12v16)) ||
                    ((ase_macb0_12v16) & (!ase_macb1_12v16) & (!ase_macb2_12v16) & (!ase_macb3_12v16)) ||
                    ((!ase_macb0_12v16) & (!ase_macb1_12v16) & (!ase_macb2_12v16) & (!ase_macb3_12v16)) ;



`ifdef LP_ABV_ON16
// psl16 default clock16 = (posedge pclk16);

// Cover16 a condition in which SMC16 is powered16 down
// and again16 powered16 up while UART16 is going16 into POWER16 down
// state or UART16 is already in POWER16 DOWN16 state
// psl16 cover_overlapping_smc_urt_116:
//    cover{fell16(pwr1_on_urt16);[*];fell16(pwr1_on_smc16);[*];
//    rose16(pwr1_on_smc16);[*];rose16(pwr1_on_urt16)};
//
// Cover16 a condition in which UART16 is powered16 down
// and again16 powered16 up while SMC16 is going16 into POWER16 down
// state or SMC16 is already in POWER16 DOWN16 state
// psl16 cover_overlapping_smc_urt_216:
//    cover{fell16(pwr1_on_smc16);[*];fell16(pwr1_on_urt16);[*];
//    rose16(pwr1_on_urt16);[*];rose16(pwr1_on_smc16)};
//


// Power16 Down16 UART16
// This16 gets16 triggered on rising16 edge of Gate16 signal16 for
// UART16 (gate_clk_urt16). In a next cycle after gate_clk_urt16,
// Isolate16 UART16(isolate_urt16) signal16 become16 HIGH16 (active).
// In 2nd cycle after gate_clk_urt16 becomes HIGH16, RESET16 for NON16
// SRPG16 FFs16(rstn_non_srpg_urt16) and POWER116 for UART16(pwr1_on_urt16) should 
// go16 LOW16. 
// This16 completes16 a POWER16 DOWN16. 

sequence s_power_down_urt16;
      (gate_clk_urt16 & !isolate_urt16 & rstn_non_srpg_urt16 & pwr1_on_urt16) 
  ##1 (gate_clk_urt16 & isolate_urt16 & rstn_non_srpg_urt16 & pwr1_on_urt16) 
  ##3 (gate_clk_urt16 & isolate_urt16 & !rstn_non_srpg_urt16 & !pwr1_on_urt16);
endsequence


property p_power_down_urt16;
   @(posedge pclk16)
    $rose(gate_clk_urt16) |=> s_power_down_urt16;
endproperty

output_power_down_urt16:
  assert property (p_power_down_urt16);


// Power16 UP16 UART16
// Sequence starts with , Rising16 edge of pwr1_on_urt16.
// Two16 clock16 cycle after this, isolate_urt16 should become16 LOW16 
// On16 the following16 clk16 gate_clk_urt16 should go16 low16.
// 5 cycles16 after  Rising16 edge of pwr1_on_urt16, rstn_non_srpg_urt16
// should become16 HIGH16
sequence s_power_up_urt16;
##30 (pwr1_on_urt16 & !isolate_urt16 & gate_clk_urt16 & !rstn_non_srpg_urt16) 
##1 (pwr1_on_urt16 & !isolate_urt16 & !gate_clk_urt16 & !rstn_non_srpg_urt16) 
##2 (pwr1_on_urt16 & !isolate_urt16 & !gate_clk_urt16 & rstn_non_srpg_urt16);
endsequence

property p_power_up_urt16;
   @(posedge pclk16)
  disable iff(!nprst16)
    (!pwr1_on_urt16 ##1 pwr1_on_urt16) |=> s_power_up_urt16;
endproperty

output_power_up_urt16:
  assert property (p_power_up_urt16);


// Power16 Down16 SMC16
// This16 gets16 triggered on rising16 edge of Gate16 signal16 for
// SMC16 (gate_clk_smc16). In a next cycle after gate_clk_smc16,
// Isolate16 SMC16(isolate_smc16) signal16 become16 HIGH16 (active).
// In 2nd cycle after gate_clk_smc16 becomes HIGH16, RESET16 for NON16
// SRPG16 FFs16(rstn_non_srpg_smc16) and POWER116 for SMC16(pwr1_on_smc16) should 
// go16 LOW16. 
// This16 completes16 a POWER16 DOWN16. 

sequence s_power_down_smc16;
      (gate_clk_smc16 & !isolate_smc16 & rstn_non_srpg_smc16 & pwr1_on_smc16) 
  ##1 (gate_clk_smc16 & isolate_smc16 & rstn_non_srpg_smc16 & pwr1_on_smc16) 
  ##3 (gate_clk_smc16 & isolate_smc16 & !rstn_non_srpg_smc16 & !pwr1_on_smc16);
endsequence


property p_power_down_smc16;
   @(posedge pclk16)
    $rose(gate_clk_smc16) |=> s_power_down_smc16;
endproperty

output_power_down_smc16:
  assert property (p_power_down_smc16);


// Power16 UP16 SMC16
// Sequence starts with , Rising16 edge of pwr1_on_smc16.
// Two16 clock16 cycle after this, isolate_smc16 should become16 LOW16 
// On16 the following16 clk16 gate_clk_smc16 should go16 low16.
// 5 cycles16 after  Rising16 edge of pwr1_on_smc16, rstn_non_srpg_smc16
// should become16 HIGH16
sequence s_power_up_smc16;
##30 (pwr1_on_smc16 & !isolate_smc16 & gate_clk_smc16 & !rstn_non_srpg_smc16) 
##1 (pwr1_on_smc16 & !isolate_smc16 & !gate_clk_smc16 & !rstn_non_srpg_smc16) 
##2 (pwr1_on_smc16 & !isolate_smc16 & !gate_clk_smc16 & rstn_non_srpg_smc16);
endsequence

property p_power_up_smc16;
   @(posedge pclk16)
  disable iff(!nprst16)
    (!pwr1_on_smc16 ##1 pwr1_on_smc16) |=> s_power_up_smc16;
endproperty

output_power_up_smc16:
  assert property (p_power_up_smc16);


// COVER16 SMC16 POWER16 DOWN16 AND16 UP16
cover_power_down_up_smc16: cover property (@(posedge pclk16)
(s_power_down_smc16 ##[5:180] s_power_up_smc16));



// COVER16 UART16 POWER16 DOWN16 AND16 UP16
cover_power_down_up_urt16: cover property (@(posedge pclk16)
(s_power_down_urt16 ##[5:180] s_power_up_urt16));

cover_power_down_urt16: cover property (@(posedge pclk16)
(s_power_down_urt16));

cover_power_up_urt16: cover property (@(posedge pclk16)
(s_power_up_urt16));




`ifdef PCM_ABV_ON16
//------------------------------------------------------------------------------
// Power16 Controller16 Formal16 Verification16 component.  Each power16 domain has a 
// separate16 instantiation16
//------------------------------------------------------------------------------

// need to assume that CPU16 will leave16 a minimum time between powering16 down and 
// back up.  In this example16, 10clks has been selected.
// psl16 config_min_uart_pd_time16 : assume always {rose16(L1_ctrl_domain16[1])} |-> { L1_ctrl_domain16[1][*10] } abort16(~nprst16);
// psl16 config_min_uart_pu_time16 : assume always {fell16(L1_ctrl_domain16[1])} |-> { !L1_ctrl_domain16[1][*10] } abort16(~nprst16);
// psl16 config_min_smc_pd_time16 : assume always {rose16(L1_ctrl_domain16[2])} |-> { L1_ctrl_domain16[2][*10] } abort16(~nprst16);
// psl16 config_min_smc_pu_time16 : assume always {fell16(L1_ctrl_domain16[2])} |-> { !L1_ctrl_domain16[2][*10] } abort16(~nprst16);

// UART16 VCOMP16 parameters16
   defparam i_uart_vcomp_domain16.ENABLE_SAVE_RESTORE_EDGE16   = 1;
   defparam i_uart_vcomp_domain16.ENABLE_EXT_PWR_CNTRL16       = 1;
   defparam i_uart_vcomp_domain16.REF_CLK_DEFINED16            = 0;
   defparam i_uart_vcomp_domain16.MIN_SHUTOFF_CYCLES16         = 4;
   defparam i_uart_vcomp_domain16.MIN_RESTORE_TO_ISO_CYCLES16  = 0;
   defparam i_uart_vcomp_domain16.MIN_SAVE_TO_SHUTOFF_CYCLES16 = 1;


   vcomp_domain16 i_uart_vcomp_domain16
   ( .ref_clk16(pclk16),
     .start_lps16(L1_ctrl_domain16[1] || !rstn_non_srpg_urt16),
     .rst_n16(nprst16),
     .ext_power_down16(L1_ctrl_domain16[1]),
     .iso_en16(isolate_urt16),
     .save_edge16(save_edge_urt16),
     .restore_edge16(restore_edge_urt16),
     .domain_shut_off16(pwr1_off_urt16),
     .domain_clk16(!gate_clk_urt16 && pclk16)
   );


// SMC16 VCOMP16 parameters16
   defparam i_smc_vcomp_domain16.ENABLE_SAVE_RESTORE_EDGE16   = 1;
   defparam i_smc_vcomp_domain16.ENABLE_EXT_PWR_CNTRL16       = 1;
   defparam i_smc_vcomp_domain16.REF_CLK_DEFINED16            = 0;
   defparam i_smc_vcomp_domain16.MIN_SHUTOFF_CYCLES16         = 4;
   defparam i_smc_vcomp_domain16.MIN_RESTORE_TO_ISO_CYCLES16  = 0;
   defparam i_smc_vcomp_domain16.MIN_SAVE_TO_SHUTOFF_CYCLES16 = 1;


   vcomp_domain16 i_smc_vcomp_domain16
   ( .ref_clk16(pclk16),
     .start_lps16(L1_ctrl_domain16[2] || !rstn_non_srpg_smc16),
     .rst_n16(nprst16),
     .ext_power_down16(L1_ctrl_domain16[2]),
     .iso_en16(isolate_smc16),
     .save_edge16(save_edge_smc16),
     .restore_edge16(restore_edge_smc16),
     .domain_shut_off16(pwr1_off_smc16),
     .domain_clk16(!gate_clk_smc16 && pclk16)
   );

`endif

`endif



endmodule
