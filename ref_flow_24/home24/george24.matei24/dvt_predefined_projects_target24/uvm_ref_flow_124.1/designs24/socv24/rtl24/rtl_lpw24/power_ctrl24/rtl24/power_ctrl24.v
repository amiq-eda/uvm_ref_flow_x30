//File24 name   : power_ctrl24.v
//Title24       : Power24 Control24 Module24
//Created24     : 1999
//Description24 : Top24 level of power24 controller24
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

module power_ctrl24 (


    // Clocks24 & Reset24
    pclk24,
    nprst24,
    // APB24 programming24 interface
    paddr24,
    psel24,
    penable24,
    pwrite24,
    pwdata24,
    prdata24,
    // mac24 i/f,
    macb3_wakeup24,
    macb2_wakeup24,
    macb1_wakeup24,
    macb0_wakeup24,
    // Scan24 
    scan_in24,
    scan_en24,
    scan_mode24,
    scan_out24,
    // Module24 control24 outputs24
    int_source_h24,
    // SMC24
    rstn_non_srpg_smc24,
    gate_clk_smc24,
    isolate_smc24,
    save_edge_smc24,
    restore_edge_smc24,
    pwr1_on_smc24,
    pwr2_on_smc24,
    pwr1_off_smc24,
    pwr2_off_smc24,
    // URT24
    rstn_non_srpg_urt24,
    gate_clk_urt24,
    isolate_urt24,
    save_edge_urt24,
    restore_edge_urt24,
    pwr1_on_urt24,
    pwr2_on_urt24,
    pwr1_off_urt24,      
    pwr2_off_urt24,
    // ETH024
    rstn_non_srpg_macb024,
    gate_clk_macb024,
    isolate_macb024,
    save_edge_macb024,
    restore_edge_macb024,
    pwr1_on_macb024,
    pwr2_on_macb024,
    pwr1_off_macb024,      
    pwr2_off_macb024,
    // ETH124
    rstn_non_srpg_macb124,
    gate_clk_macb124,
    isolate_macb124,
    save_edge_macb124,
    restore_edge_macb124,
    pwr1_on_macb124,
    pwr2_on_macb124,
    pwr1_off_macb124,      
    pwr2_off_macb124,
    // ETH224
    rstn_non_srpg_macb224,
    gate_clk_macb224,
    isolate_macb224,
    save_edge_macb224,
    restore_edge_macb224,
    pwr1_on_macb224,
    pwr2_on_macb224,
    pwr1_off_macb224,      
    pwr2_off_macb224,
    // ETH324
    rstn_non_srpg_macb324,
    gate_clk_macb324,
    isolate_macb324,
    save_edge_macb324,
    restore_edge_macb324,
    pwr1_on_macb324,
    pwr2_on_macb324,
    pwr1_off_macb324,      
    pwr2_off_macb324,
    // DMA24
    rstn_non_srpg_dma24,
    gate_clk_dma24,
    isolate_dma24,
    save_edge_dma24,
    restore_edge_dma24,
    pwr1_on_dma24,
    pwr2_on_dma24,
    pwr1_off_dma24,      
    pwr2_off_dma24,
    // CPU24
    rstn_non_srpg_cpu24,
    gate_clk_cpu24,
    isolate_cpu24,
    save_edge_cpu24,
    restore_edge_cpu24,
    pwr1_on_cpu24,
    pwr2_on_cpu24,
    pwr1_off_cpu24,      
    pwr2_off_cpu24,
    // ALUT24
    rstn_non_srpg_alut24,
    gate_clk_alut24,
    isolate_alut24,
    save_edge_alut24,
    restore_edge_alut24,
    pwr1_on_alut24,
    pwr2_on_alut24,
    pwr1_off_alut24,      
    pwr2_off_alut24,
    // MEM24
    rstn_non_srpg_mem24,
    gate_clk_mem24,
    isolate_mem24,
    save_edge_mem24,
    restore_edge_mem24,
    pwr1_on_mem24,
    pwr2_on_mem24,
    pwr1_off_mem24,      
    pwr2_off_mem24,
    // core24 dvfs24 transitions24
    core06v24,
    core08v24,
    core10v24,
    core12v24,
    pcm_macb_wakeup_int24,
    // mte24 signals24
    mte_smc_start24,
    mte_uart_start24,
    mte_smc_uart_start24,  
    mte_pm_smc_to_default_start24, 
    mte_pm_uart_to_default_start24,
    mte_pm_smc_uart_to_default_start24

  );

  parameter STATE_IDLE_12V24 = 4'b0001;
  parameter STATE_06V24 = 4'b0010;
  parameter STATE_08V24 = 4'b0100;
  parameter STATE_10V24 = 4'b1000;

    // Clocks24 & Reset24
    input pclk24;
    input nprst24;
    // APB24 programming24 interface
    input [31:0] paddr24;
    input psel24  ;
    input penable24;
    input pwrite24 ;
    input [31:0] pwdata24;
    output [31:0] prdata24;
    // mac24
    input macb3_wakeup24;
    input macb2_wakeup24;
    input macb1_wakeup24;
    input macb0_wakeup24;
    // Scan24 
    input scan_in24;
    input scan_en24;
    input scan_mode24;
    output scan_out24;
    // Module24 control24 outputs24
    input int_source_h24;
    // SMC24
    output rstn_non_srpg_smc24 ;
    output gate_clk_smc24   ;
    output isolate_smc24   ;
    output save_edge_smc24   ;
    output restore_edge_smc24   ;
    output pwr1_on_smc24   ;
    output pwr2_on_smc24   ;
    output pwr1_off_smc24  ;
    output pwr2_off_smc24  ;
    // URT24
    output rstn_non_srpg_urt24 ;
    output gate_clk_urt24      ;
    output isolate_urt24       ;
    output save_edge_urt24   ;
    output restore_edge_urt24   ;
    output pwr1_on_urt24       ;
    output pwr2_on_urt24       ;
    output pwr1_off_urt24      ;
    output pwr2_off_urt24      ;
    // ETH024
    output rstn_non_srpg_macb024 ;
    output gate_clk_macb024      ;
    output isolate_macb024       ;
    output save_edge_macb024   ;
    output restore_edge_macb024   ;
    output pwr1_on_macb024       ;
    output pwr2_on_macb024       ;
    output pwr1_off_macb024      ;
    output pwr2_off_macb024      ;
    // ETH124
    output rstn_non_srpg_macb124 ;
    output gate_clk_macb124      ;
    output isolate_macb124       ;
    output save_edge_macb124   ;
    output restore_edge_macb124   ;
    output pwr1_on_macb124       ;
    output pwr2_on_macb124       ;
    output pwr1_off_macb124      ;
    output pwr2_off_macb124      ;
    // ETH224
    output rstn_non_srpg_macb224 ;
    output gate_clk_macb224      ;
    output isolate_macb224       ;
    output save_edge_macb224   ;
    output restore_edge_macb224   ;
    output pwr1_on_macb224       ;
    output pwr2_on_macb224       ;
    output pwr1_off_macb224      ;
    output pwr2_off_macb224      ;
    // ETH324
    output rstn_non_srpg_macb324 ;
    output gate_clk_macb324      ;
    output isolate_macb324       ;
    output save_edge_macb324   ;
    output restore_edge_macb324   ;
    output pwr1_on_macb324       ;
    output pwr2_on_macb324       ;
    output pwr1_off_macb324      ;
    output pwr2_off_macb324      ;
    // DMA24
    output rstn_non_srpg_dma24 ;
    output gate_clk_dma24      ;
    output isolate_dma24       ;
    output save_edge_dma24   ;
    output restore_edge_dma24   ;
    output pwr1_on_dma24       ;
    output pwr2_on_dma24       ;
    output pwr1_off_dma24      ;
    output pwr2_off_dma24      ;
    // CPU24
    output rstn_non_srpg_cpu24 ;
    output gate_clk_cpu24      ;
    output isolate_cpu24       ;
    output save_edge_cpu24   ;
    output restore_edge_cpu24   ;
    output pwr1_on_cpu24       ;
    output pwr2_on_cpu24       ;
    output pwr1_off_cpu24      ;
    output pwr2_off_cpu24      ;
    // ALUT24
    output rstn_non_srpg_alut24 ;
    output gate_clk_alut24      ;
    output isolate_alut24       ;
    output save_edge_alut24   ;
    output restore_edge_alut24   ;
    output pwr1_on_alut24       ;
    output pwr2_on_alut24       ;
    output pwr1_off_alut24      ;
    output pwr2_off_alut24      ;
    // MEM24
    output rstn_non_srpg_mem24 ;
    output gate_clk_mem24      ;
    output isolate_mem24       ;
    output save_edge_mem24   ;
    output restore_edge_mem24   ;
    output pwr1_on_mem24       ;
    output pwr2_on_mem24       ;
    output pwr1_off_mem24      ;
    output pwr2_off_mem24      ;


   // core24 transitions24 o/p
    output core06v24;
    output core08v24;
    output core10v24;
    output core12v24;
    output pcm_macb_wakeup_int24 ;
    //mode mte24  signals24
    output mte_smc_start24;
    output mte_uart_start24;
    output mte_smc_uart_start24;  
    output mte_pm_smc_to_default_start24; 
    output mte_pm_uart_to_default_start24;
    output mte_pm_smc_uart_to_default_start24;

    reg mte_smc_start24;
    reg mte_uart_start24;
    reg mte_smc_uart_start24;  
    reg mte_pm_smc_to_default_start24; 
    reg mte_pm_uart_to_default_start24;
    reg mte_pm_smc_uart_to_default_start24;

    reg [31:0] prdata24;

  wire valid_reg_write24  ;
  wire valid_reg_read24   ;
  wire L1_ctrl_access24   ;
  wire L1_status_access24 ;
  wire pcm_int_mask_access24;
  wire pcm_int_status_access24;
  wire standby_mem024      ;
  wire standby_mem124      ;
  wire standby_mem224      ;
  wire standby_mem324      ;
  wire pwr1_off_mem024;
  wire pwr1_off_mem124;
  wire pwr1_off_mem224;
  wire pwr1_off_mem324;
  
  // Control24 signals24
  wire set_status_smc24   ;
  wire clr_status_smc24   ;
  wire set_status_urt24   ;
  wire clr_status_urt24   ;
  wire set_status_macb024   ;
  wire clr_status_macb024   ;
  wire set_status_macb124   ;
  wire clr_status_macb124   ;
  wire set_status_macb224   ;
  wire clr_status_macb224   ;
  wire set_status_macb324   ;
  wire clr_status_macb324   ;
  wire set_status_dma24   ;
  wire clr_status_dma24   ;
  wire set_status_cpu24   ;
  wire clr_status_cpu24   ;
  wire set_status_alut24   ;
  wire clr_status_alut24   ;
  wire set_status_mem24   ;
  wire clr_status_mem24   ;


  // Status and Control24 registers
  reg [31:0]  L1_status_reg24;
  reg  [31:0] L1_ctrl_reg24  ;
  reg  [31:0] L1_ctrl_domain24  ;
  reg L1_ctrl_cpu_off_reg24;
  reg [31:0]  pcm_mask_reg24;
  reg [31:0]  pcm_status_reg24;

  // Signals24 gated24 in scan_mode24
  //SMC24
  wire  rstn_non_srpg_smc_int24;
  wire  gate_clk_smc_int24    ;     
  wire  isolate_smc_int24    ;       
  wire save_edge_smc_int24;
  wire restore_edge_smc_int24;
  wire  pwr1_on_smc_int24    ;      
  wire  pwr2_on_smc_int24    ;      


  //URT24
  wire   rstn_non_srpg_urt_int24;
  wire   gate_clk_urt_int24     ;     
  wire   isolate_urt_int24      ;       
  wire save_edge_urt_int24;
  wire restore_edge_urt_int24;
  wire   pwr1_on_urt_int24      ;      
  wire   pwr2_on_urt_int24      ;      

  // ETH024
  wire   rstn_non_srpg_macb0_int24;
  wire   gate_clk_macb0_int24     ;     
  wire   isolate_macb0_int24      ;       
  wire save_edge_macb0_int24;
  wire restore_edge_macb0_int24;
  wire   pwr1_on_macb0_int24      ;      
  wire   pwr2_on_macb0_int24      ;      
  // ETH124
  wire   rstn_non_srpg_macb1_int24;
  wire   gate_clk_macb1_int24     ;     
  wire   isolate_macb1_int24      ;       
  wire save_edge_macb1_int24;
  wire restore_edge_macb1_int24;
  wire   pwr1_on_macb1_int24      ;      
  wire   pwr2_on_macb1_int24      ;      
  // ETH224
  wire   rstn_non_srpg_macb2_int24;
  wire   gate_clk_macb2_int24     ;     
  wire   isolate_macb2_int24      ;       
  wire save_edge_macb2_int24;
  wire restore_edge_macb2_int24;
  wire   pwr1_on_macb2_int24      ;      
  wire   pwr2_on_macb2_int24      ;      
  // ETH324
  wire   rstn_non_srpg_macb3_int24;
  wire   gate_clk_macb3_int24     ;     
  wire   isolate_macb3_int24      ;       
  wire save_edge_macb3_int24;
  wire restore_edge_macb3_int24;
  wire   pwr1_on_macb3_int24      ;      
  wire   pwr2_on_macb3_int24      ;      

  // DMA24
  wire   rstn_non_srpg_dma_int24;
  wire   gate_clk_dma_int24     ;     
  wire   isolate_dma_int24      ;       
  wire save_edge_dma_int24;
  wire restore_edge_dma_int24;
  wire   pwr1_on_dma_int24      ;      
  wire   pwr2_on_dma_int24      ;      

  // CPU24
  wire   rstn_non_srpg_cpu_int24;
  wire   gate_clk_cpu_int24     ;     
  wire   isolate_cpu_int24      ;       
  wire save_edge_cpu_int24;
  wire restore_edge_cpu_int24;
  wire   pwr1_on_cpu_int24      ;      
  wire   pwr2_on_cpu_int24      ;  
  wire L1_ctrl_cpu_off_p24;    

  reg save_alut_tmp24;
  // DFS24 sm24

  reg cpu_shutoff_ctrl24;

  reg mte_mac_off_start24, mte_mac012_start24, mte_mac013_start24, mte_mac023_start24, mte_mac123_start24;
  reg mte_mac01_start24, mte_mac02_start24, mte_mac03_start24, mte_mac12_start24, mte_mac13_start24, mte_mac23_start24;
  reg mte_mac0_start24, mte_mac1_start24, mte_mac2_start24, mte_mac3_start24;
  reg mte_sys_hibernate24 ;
  reg mte_dma_start24 ;
  reg mte_cpu_start24 ;
  reg mte_mac_off_sleep_start24, mte_mac012_sleep_start24, mte_mac013_sleep_start24, mte_mac023_sleep_start24, mte_mac123_sleep_start24;
  reg mte_mac01_sleep_start24, mte_mac02_sleep_start24, mte_mac03_sleep_start24, mte_mac12_sleep_start24, mte_mac13_sleep_start24, mte_mac23_sleep_start24;
  reg mte_mac0_sleep_start24, mte_mac1_sleep_start24, mte_mac2_sleep_start24, mte_mac3_sleep_start24;
  reg mte_dma_sleep_start24;
  reg mte_mac_off_to_default24, mte_mac012_to_default24, mte_mac013_to_default24, mte_mac023_to_default24, mte_mac123_to_default24;
  reg mte_mac01_to_default24, mte_mac02_to_default24, mte_mac03_to_default24, mte_mac12_to_default24, mte_mac13_to_default24, mte_mac23_to_default24;
  reg mte_mac0_to_default24, mte_mac1_to_default24, mte_mac2_to_default24, mte_mac3_to_default24;
  reg mte_dma_isolate_dis24;
  reg mte_cpu_isolate_dis24;
  reg mte_sys_hibernate_to_default24;


  // Latch24 the CPU24 SLEEP24 invocation24
  always @( posedge pclk24 or negedge nprst24) 
  begin
    if(!nprst24)
      L1_ctrl_cpu_off_reg24 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg24 <= L1_ctrl_domain24[8];
  end

  // Create24 a pulse24 for sleep24 detection24 
  assign L1_ctrl_cpu_off_p24 =  L1_ctrl_domain24[8] && !L1_ctrl_cpu_off_reg24;
  
  // CPU24 sleep24 contol24 logic 
  // Shut24 off24 CPU24 when L1_ctrl_cpu_off_p24 is set
  // wake24 cpu24 when any interrupt24 is seen24  
  always @( posedge pclk24 or negedge nprst24) 
  begin
    if(!nprst24)
     cpu_shutoff_ctrl24 <= 1'b0;
    else if(cpu_shutoff_ctrl24 && int_source_h24)
     cpu_shutoff_ctrl24 <= 1'b0;
    else if (L1_ctrl_cpu_off_p24)
     cpu_shutoff_ctrl24 <= 1'b1;
  end
 
  // instantiate24 power24 contol24  block for uart24
  power_ctrl_sm24 i_urt_power_ctrl_sm24(
    .pclk24(pclk24),
    .nprst24(nprst24),
    .L1_module_req24(L1_ctrl_domain24[1]),
    .set_status_module24(set_status_urt24),
    .clr_status_module24(clr_status_urt24),
    .rstn_non_srpg_module24(rstn_non_srpg_urt_int24),
    .gate_clk_module24(gate_clk_urt_int24),
    .isolate_module24(isolate_urt_int24),
    .save_edge24(save_edge_urt_int24),
    .restore_edge24(restore_edge_urt_int24),
    .pwr1_on24(pwr1_on_urt_int24),
    .pwr2_on24(pwr2_on_urt_int24)
    );
  

  // instantiate24 power24 contol24  block for smc24
  power_ctrl_sm24 i_smc_power_ctrl_sm24(
    .pclk24(pclk24),
    .nprst24(nprst24),
    .L1_module_req24(L1_ctrl_domain24[2]),
    .set_status_module24(set_status_smc24),
    .clr_status_module24(clr_status_smc24),
    .rstn_non_srpg_module24(rstn_non_srpg_smc_int24),
    .gate_clk_module24(gate_clk_smc_int24),
    .isolate_module24(isolate_smc_int24),
    .save_edge24(save_edge_smc_int24),
    .restore_edge24(restore_edge_smc_int24),
    .pwr1_on24(pwr1_on_smc_int24),
    .pwr2_on24(pwr2_on_smc_int24)
    );

  // power24 control24 for macb024
  power_ctrl_sm24 i_macb0_power_ctrl_sm24(
    .pclk24(pclk24),
    .nprst24(nprst24),
    .L1_module_req24(L1_ctrl_domain24[3]),
    .set_status_module24(set_status_macb024),
    .clr_status_module24(clr_status_macb024),
    .rstn_non_srpg_module24(rstn_non_srpg_macb0_int24),
    .gate_clk_module24(gate_clk_macb0_int24),
    .isolate_module24(isolate_macb0_int24),
    .save_edge24(save_edge_macb0_int24),
    .restore_edge24(restore_edge_macb0_int24),
    .pwr1_on24(pwr1_on_macb0_int24),
    .pwr2_on24(pwr2_on_macb0_int24)
    );
  // power24 control24 for macb124
  power_ctrl_sm24 i_macb1_power_ctrl_sm24(
    .pclk24(pclk24),
    .nprst24(nprst24),
    .L1_module_req24(L1_ctrl_domain24[4]),
    .set_status_module24(set_status_macb124),
    .clr_status_module24(clr_status_macb124),
    .rstn_non_srpg_module24(rstn_non_srpg_macb1_int24),
    .gate_clk_module24(gate_clk_macb1_int24),
    .isolate_module24(isolate_macb1_int24),
    .save_edge24(save_edge_macb1_int24),
    .restore_edge24(restore_edge_macb1_int24),
    .pwr1_on24(pwr1_on_macb1_int24),
    .pwr2_on24(pwr2_on_macb1_int24)
    );
  // power24 control24 for macb224
  power_ctrl_sm24 i_macb2_power_ctrl_sm24(
    .pclk24(pclk24),
    .nprst24(nprst24),
    .L1_module_req24(L1_ctrl_domain24[5]),
    .set_status_module24(set_status_macb224),
    .clr_status_module24(clr_status_macb224),
    .rstn_non_srpg_module24(rstn_non_srpg_macb2_int24),
    .gate_clk_module24(gate_clk_macb2_int24),
    .isolate_module24(isolate_macb2_int24),
    .save_edge24(save_edge_macb2_int24),
    .restore_edge24(restore_edge_macb2_int24),
    .pwr1_on24(pwr1_on_macb2_int24),
    .pwr2_on24(pwr2_on_macb2_int24)
    );
  // power24 control24 for macb324
  power_ctrl_sm24 i_macb3_power_ctrl_sm24(
    .pclk24(pclk24),
    .nprst24(nprst24),
    .L1_module_req24(L1_ctrl_domain24[6]),
    .set_status_module24(set_status_macb324),
    .clr_status_module24(clr_status_macb324),
    .rstn_non_srpg_module24(rstn_non_srpg_macb3_int24),
    .gate_clk_module24(gate_clk_macb3_int24),
    .isolate_module24(isolate_macb3_int24),
    .save_edge24(save_edge_macb3_int24),
    .restore_edge24(restore_edge_macb3_int24),
    .pwr1_on24(pwr1_on_macb3_int24),
    .pwr2_on24(pwr2_on_macb3_int24)
    );
  // power24 control24 for dma24
  power_ctrl_sm24 i_dma_power_ctrl_sm24(
    .pclk24(pclk24),
    .nprst24(nprst24),
    .L1_module_req24(L1_ctrl_domain24[7]),
    .set_status_module24(set_status_dma24),
    .clr_status_module24(clr_status_dma24),
    .rstn_non_srpg_module24(rstn_non_srpg_dma_int24),
    .gate_clk_module24(gate_clk_dma_int24),
    .isolate_module24(isolate_dma_int24),
    .save_edge24(save_edge_dma_int24),
    .restore_edge24(restore_edge_dma_int24),
    .pwr1_on24(pwr1_on_dma_int24),
    .pwr2_on24(pwr2_on_dma_int24)
    );
  // power24 control24 for CPU24
  power_ctrl_sm24 i_cpu_power_ctrl_sm24(
    .pclk24(pclk24),
    .nprst24(nprst24),
    .L1_module_req24(cpu_shutoff_ctrl24),
    .set_status_module24(set_status_cpu24),
    .clr_status_module24(clr_status_cpu24),
    .rstn_non_srpg_module24(rstn_non_srpg_cpu_int24),
    .gate_clk_module24(gate_clk_cpu_int24),
    .isolate_module24(isolate_cpu_int24),
    .save_edge24(save_edge_cpu_int24),
    .restore_edge24(restore_edge_cpu_int24),
    .pwr1_on24(pwr1_on_cpu_int24),
    .pwr2_on24(pwr2_on_cpu_int24)
    );

  assign valid_reg_write24 =  (psel24 && pwrite24 && penable24);
  assign valid_reg_read24  =  (psel24 && (!pwrite24) && penable24);

  assign L1_ctrl_access24  =  (paddr24[15:0] == 16'b0000000000000100); 
  assign L1_status_access24 = (paddr24[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access24 =   (paddr24[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access24 = (paddr24[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control24 and status register
  always @(*)
  begin  
    if(valid_reg_read24 && L1_ctrl_access24) 
      prdata24 = L1_ctrl_reg24;
    else if (valid_reg_read24 && L1_status_access24)
      prdata24 = L1_status_reg24;
    else if (valid_reg_read24 && pcm_int_mask_access24)
      prdata24 = pcm_mask_reg24;
    else if (valid_reg_read24 && pcm_int_status_access24)
      prdata24 = pcm_status_reg24;
    else 
      prdata24 = 0;
  end

  assign set_status_mem24 =  (set_status_macb024 && set_status_macb124 && set_status_macb224 &&
                            set_status_macb324 && set_status_dma24 && set_status_cpu24);

  assign clr_status_mem24 =  (clr_status_macb024 && clr_status_macb124 && clr_status_macb224 &&
                            clr_status_macb324 && clr_status_dma24 && clr_status_cpu24);

  assign set_status_alut24 = (set_status_macb024 && set_status_macb124 && set_status_macb224 && set_status_macb324);

  assign clr_status_alut24 = (clr_status_macb024 || clr_status_macb124 || clr_status_macb224  || clr_status_macb324);

  // Write accesses to the control24 and status register
 
  always @(posedge pclk24 or negedge nprst24)
  begin
    if (!nprst24) begin
      L1_ctrl_reg24   <= 0;
      L1_status_reg24 <= 0;
      pcm_mask_reg24 <= 0;
    end else begin
      // CTRL24 reg updates24
      if (valid_reg_write24 && L1_ctrl_access24) 
        L1_ctrl_reg24 <= pwdata24; // Writes24 to the ctrl24 reg
      if (valid_reg_write24 && pcm_int_mask_access24) 
        pcm_mask_reg24 <= pwdata24; // Writes24 to the ctrl24 reg

      if (set_status_urt24 == 1'b1)  
        L1_status_reg24[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt24 == 1'b1) 
        L1_status_reg24[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc24 == 1'b1) 
        L1_status_reg24[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc24 == 1'b1) 
        L1_status_reg24[2] <= 1'b0; // Clear the status bit

      if (set_status_macb024 == 1'b1)  
        L1_status_reg24[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb024 == 1'b1) 
        L1_status_reg24[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb124 == 1'b1)  
        L1_status_reg24[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb124 == 1'b1) 
        L1_status_reg24[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb224 == 1'b1)  
        L1_status_reg24[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb224 == 1'b1) 
        L1_status_reg24[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb324 == 1'b1)  
        L1_status_reg24[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb324 == 1'b1) 
        L1_status_reg24[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma24 == 1'b1)  
        L1_status_reg24[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma24 == 1'b1) 
        L1_status_reg24[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu24 == 1'b1)  
        L1_status_reg24[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu24 == 1'b1) 
        L1_status_reg24[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut24 == 1'b1)  
        L1_status_reg24[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut24 == 1'b1) 
        L1_status_reg24[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem24 == 1'b1)  
        L1_status_reg24[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem24 == 1'b1) 
        L1_status_reg24[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused24 bits of pcm_status_reg24 are tied24 to 0
  always @(posedge pclk24 or negedge nprst24)
  begin
    if (!nprst24)
      pcm_status_reg24[31:4] <= 'b0;
    else  
      pcm_status_reg24[31:4] <= pcm_status_reg24[31:4];
  end
  
  // interrupt24 only of h/w assisted24 wakeup
  // MAC24 3
  always @(posedge pclk24 or negedge nprst24)
  begin
    if(!nprst24)
      pcm_status_reg24[3] <= 1'b0;
    else if (valid_reg_write24 && pcm_int_status_access24) 
      pcm_status_reg24[3] <= pwdata24[3];
    else if (macb3_wakeup24 & ~pcm_mask_reg24[3])
      pcm_status_reg24[3] <= 1'b1;
    else if (valid_reg_read24 && pcm_int_status_access24) 
      pcm_status_reg24[3] <= 1'b0;
    else
      pcm_status_reg24[3] <= pcm_status_reg24[3];
  end  
   
  // MAC24 2
  always @(posedge pclk24 or negedge nprst24)
  begin
    if(!nprst24)
      pcm_status_reg24[2] <= 1'b0;
    else if (valid_reg_write24 && pcm_int_status_access24) 
      pcm_status_reg24[2] <= pwdata24[2];
    else if (macb2_wakeup24 & ~pcm_mask_reg24[2])
      pcm_status_reg24[2] <= 1'b1;
    else if (valid_reg_read24 && pcm_int_status_access24) 
      pcm_status_reg24[2] <= 1'b0;
    else
      pcm_status_reg24[2] <= pcm_status_reg24[2];
  end  

  // MAC24 1
  always @(posedge pclk24 or negedge nprst24)
  begin
    if(!nprst24)
      pcm_status_reg24[1] <= 1'b0;
    else if (valid_reg_write24 && pcm_int_status_access24) 
      pcm_status_reg24[1] <= pwdata24[1];
    else if (macb1_wakeup24 & ~pcm_mask_reg24[1])
      pcm_status_reg24[1] <= 1'b1;
    else if (valid_reg_read24 && pcm_int_status_access24) 
      pcm_status_reg24[1] <= 1'b0;
    else
      pcm_status_reg24[1] <= pcm_status_reg24[1];
  end  
   
  // MAC24 0
  always @(posedge pclk24 or negedge nprst24)
  begin
    if(!nprst24)
      pcm_status_reg24[0] <= 1'b0;
    else if (valid_reg_write24 && pcm_int_status_access24) 
      pcm_status_reg24[0] <= pwdata24[0];
    else if (macb0_wakeup24 & ~pcm_mask_reg24[0])
      pcm_status_reg24[0] <= 1'b1;
    else if (valid_reg_read24 && pcm_int_status_access24) 
      pcm_status_reg24[0] <= 1'b0;
    else
      pcm_status_reg24[0] <= pcm_status_reg24[0];
  end  

  assign pcm_macb_wakeup_int24 = |pcm_status_reg24;

  reg [31:0] L1_ctrl_reg124;
  always @(posedge pclk24 or negedge nprst24)
  begin
    if(!nprst24)
      L1_ctrl_reg124 <= 0;
    else
      L1_ctrl_reg124 <= L1_ctrl_reg24;
  end

  // Program24 mode decode
  always @(L1_ctrl_reg24 or L1_ctrl_reg124 or int_source_h24 or cpu_shutoff_ctrl24) begin
    mte_smc_start24 = 0;
    mte_uart_start24 = 0;
    mte_smc_uart_start24  = 0;
    mte_mac_off_start24  = 0;
    mte_mac012_start24 = 0;
    mte_mac013_start24 = 0;
    mte_mac023_start24 = 0;
    mte_mac123_start24 = 0;
    mte_mac01_start24 = 0;
    mte_mac02_start24 = 0;
    mte_mac03_start24 = 0;
    mte_mac12_start24 = 0;
    mte_mac13_start24 = 0;
    mte_mac23_start24 = 0;
    mte_mac0_start24 = 0;
    mte_mac1_start24 = 0;
    mte_mac2_start24 = 0;
    mte_mac3_start24 = 0;
    mte_sys_hibernate24 = 0 ;
    mte_dma_start24 = 0 ;
    mte_cpu_start24 = 0 ;

    mte_mac0_sleep_start24 = (L1_ctrl_reg24 ==  'h14) && (L1_ctrl_reg124 == 'h4 );
    mte_mac1_sleep_start24 = (L1_ctrl_reg24 ==  'h14) && (L1_ctrl_reg124 == 'h5 ); 
    mte_mac2_sleep_start24 = (L1_ctrl_reg24 ==  'h14) && (L1_ctrl_reg124 == 'h6 ); 
    mte_mac3_sleep_start24 = (L1_ctrl_reg24 ==  'h14) && (L1_ctrl_reg124 == 'h7 ); 
    mte_mac01_sleep_start24 = (L1_ctrl_reg24 ==  'h14) && (L1_ctrl_reg124 == 'h8 ); 
    mte_mac02_sleep_start24 = (L1_ctrl_reg24 ==  'h14) && (L1_ctrl_reg124 == 'h9 ); 
    mte_mac03_sleep_start24 = (L1_ctrl_reg24 ==  'h14) && (L1_ctrl_reg124 == 'hA ); 
    mte_mac12_sleep_start24 = (L1_ctrl_reg24 ==  'h14) && (L1_ctrl_reg124 == 'hB ); 
    mte_mac13_sleep_start24 = (L1_ctrl_reg24 ==  'h14) && (L1_ctrl_reg124 == 'hC ); 
    mte_mac23_sleep_start24 = (L1_ctrl_reg24 ==  'h14) && (L1_ctrl_reg124 == 'hD ); 
    mte_mac012_sleep_start24 = (L1_ctrl_reg24 ==  'h14) && (L1_ctrl_reg124 == 'hE ); 
    mte_mac013_sleep_start24 = (L1_ctrl_reg24 ==  'h14) && (L1_ctrl_reg124 == 'hF ); 
    mte_mac023_sleep_start24 = (L1_ctrl_reg24 ==  'h14) && (L1_ctrl_reg124 == 'h10 ); 
    mte_mac123_sleep_start24 = (L1_ctrl_reg24 ==  'h14) && (L1_ctrl_reg124 == 'h11 ); 
    mte_mac_off_sleep_start24 =  (L1_ctrl_reg24 == 'h14) && (L1_ctrl_reg124 == 'h12 );
    mte_dma_sleep_start24 =  (L1_ctrl_reg24 == 'h14) && (L1_ctrl_reg124 == 'h13 );

    mte_pm_uart_to_default_start24 = (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'h1);
    mte_pm_smc_to_default_start24 = (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'h2);
    mte_pm_smc_uart_to_default_start24 = (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'h3); 
    mte_mac0_to_default24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'h4); 
    mte_mac1_to_default24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'h5); 
    mte_mac2_to_default24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'h6); 
    mte_mac3_to_default24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'h7); 
    mte_mac01_to_default24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'h8); 
    mte_mac02_to_default24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'h9); 
    mte_mac03_to_default24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'hA); 
    mte_mac12_to_default24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'hB); 
    mte_mac13_to_default24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'hC); 
    mte_mac23_to_default24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'hD); 
    mte_mac012_to_default24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'hE); 
    mte_mac013_to_default24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'hF); 
    mte_mac023_to_default24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'h10); 
    mte_mac123_to_default24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'h11); 
    mte_mac_off_to_default24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'h12); 
    mte_dma_isolate_dis24 =  (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'h13); 
    mte_cpu_isolate_dis24 =  (int_source_h24) && (cpu_shutoff_ctrl24) && (L1_ctrl_reg24 != 'h15);
    mte_sys_hibernate_to_default24 = (L1_ctrl_reg24 == 32'h0) && (L1_ctrl_reg124 == 'h15); 

   
    if (L1_ctrl_reg124 == 'h0) begin // This24 check is to make mte_cpu_start24
                                   // is set only when you from default state 
      case (L1_ctrl_reg24)
        'h0 : L1_ctrl_domain24 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain24 = 32'h2; // PM_uart24
                mte_uart_start24 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain24 = 32'h4; // PM_smc24
                mte_smc_start24 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain24 = 32'h6; // PM_smc_uart24
                mte_smc_uart_start24 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain24 = 32'h8; //  PM_macb024
                mte_mac0_start24 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain24 = 32'h10; //  PM_macb124
                mte_mac1_start24 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain24 = 32'h20; //  PM_macb224
                mte_mac2_start24 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain24 = 32'h40; //  PM_macb324
                mte_mac3_start24 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain24 = 32'h18; //  PM_macb0124
                mte_mac01_start24 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain24 = 32'h28; //  PM_macb0224
                mte_mac02_start24 = 1;
              end
        'hA : begin  
                L1_ctrl_domain24 = 32'h48; //  PM_macb0324
                mte_mac03_start24 = 1;
              end
        'hB : begin  
                L1_ctrl_domain24 = 32'h30; //  PM_macb1224
                mte_mac12_start24 = 1;
              end
        'hC : begin  
                L1_ctrl_domain24 = 32'h50; //  PM_macb1324
                mte_mac13_start24 = 1;
              end
        'hD : begin  
                L1_ctrl_domain24 = 32'h60; //  PM_macb2324
                mte_mac23_start24 = 1;
              end
        'hE : begin  
                L1_ctrl_domain24 = 32'h38; //  PM_macb01224
                mte_mac012_start24 = 1;
              end
        'hF : begin  
                L1_ctrl_domain24 = 32'h58; //  PM_macb01324
                mte_mac013_start24 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain24 = 32'h68; //  PM_macb02324
                mte_mac023_start24 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain24 = 32'h70; //  PM_macb12324
                mte_mac123_start24 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain24 = 32'h78; //  PM_macb_off24
                mte_mac_off_start24 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain24 = 32'h80; //  PM_dma24
                mte_dma_start24 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain24 = 32'h100; //  PM_cpu_sleep24
                mte_cpu_start24 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain24 = 32'h1FE; //  PM_hibernate24
                mte_sys_hibernate24 = 1;
              end
         default: L1_ctrl_domain24 = 32'h0;
      endcase
    end
  end


  wire to_default24 = (L1_ctrl_reg24 == 0);

  // Scan24 mode gating24 of power24 and isolation24 control24 signals24
  //SMC24
  assign rstn_non_srpg_smc24  = (scan_mode24 == 1'b0) ? rstn_non_srpg_smc_int24 : 1'b1;  
  assign gate_clk_smc24       = (scan_mode24 == 1'b0) ? gate_clk_smc_int24 : 1'b0;     
  assign isolate_smc24        = (scan_mode24 == 1'b0) ? isolate_smc_int24 : 1'b0;      
  assign pwr1_on_smc24        = (scan_mode24 == 1'b0) ? pwr1_on_smc_int24 : 1'b1;       
  assign pwr2_on_smc24        = (scan_mode24 == 1'b0) ? pwr2_on_smc_int24 : 1'b1;       
  assign pwr1_off_smc24       = (scan_mode24 == 1'b0) ? (!pwr1_on_smc_int24) : 1'b0;       
  assign pwr2_off_smc24       = (scan_mode24 == 1'b0) ? (!pwr2_on_smc_int24) : 1'b0;       
  assign save_edge_smc24       = (scan_mode24 == 1'b0) ? (save_edge_smc_int24) : 1'b0;       
  assign restore_edge_smc24       = (scan_mode24 == 1'b0) ? (restore_edge_smc_int24) : 1'b0;       

  //URT24
  assign rstn_non_srpg_urt24  = (scan_mode24 == 1'b0) ?  rstn_non_srpg_urt_int24 : 1'b1;  
  assign gate_clk_urt24       = (scan_mode24 == 1'b0) ?  gate_clk_urt_int24      : 1'b0;     
  assign isolate_urt24        = (scan_mode24 == 1'b0) ?  isolate_urt_int24       : 1'b0;      
  assign pwr1_on_urt24        = (scan_mode24 == 1'b0) ?  pwr1_on_urt_int24       : 1'b1;       
  assign pwr2_on_urt24        = (scan_mode24 == 1'b0) ?  pwr2_on_urt_int24       : 1'b1;       
  assign pwr1_off_urt24       = (scan_mode24 == 1'b0) ?  (!pwr1_on_urt_int24)  : 1'b0;       
  assign pwr2_off_urt24       = (scan_mode24 == 1'b0) ?  (!pwr2_on_urt_int24)  : 1'b0;       
  assign save_edge_urt24       = (scan_mode24 == 1'b0) ? (save_edge_urt_int24) : 1'b0;       
  assign restore_edge_urt24       = (scan_mode24 == 1'b0) ? (restore_edge_urt_int24) : 1'b0;       

  //ETH024
  assign rstn_non_srpg_macb024 = (scan_mode24 == 1'b0) ?  rstn_non_srpg_macb0_int24 : 1'b1;  
  assign gate_clk_macb024       = (scan_mode24 == 1'b0) ?  gate_clk_macb0_int24      : 1'b0;     
  assign isolate_macb024        = (scan_mode24 == 1'b0) ?  isolate_macb0_int24       : 1'b0;      
  assign pwr1_on_macb024        = (scan_mode24 == 1'b0) ?  pwr1_on_macb0_int24       : 1'b1;       
  assign pwr2_on_macb024        = (scan_mode24 == 1'b0) ?  pwr2_on_macb0_int24       : 1'b1;       
  assign pwr1_off_macb024       = (scan_mode24 == 1'b0) ?  (!pwr1_on_macb0_int24)  : 1'b0;       
  assign pwr2_off_macb024       = (scan_mode24 == 1'b0) ?  (!pwr2_on_macb0_int24)  : 1'b0;       
  assign save_edge_macb024       = (scan_mode24 == 1'b0) ? (save_edge_macb0_int24) : 1'b0;       
  assign restore_edge_macb024       = (scan_mode24 == 1'b0) ? (restore_edge_macb0_int24) : 1'b0;       

  //ETH124
  assign rstn_non_srpg_macb124 = (scan_mode24 == 1'b0) ?  rstn_non_srpg_macb1_int24 : 1'b1;  
  assign gate_clk_macb124       = (scan_mode24 == 1'b0) ?  gate_clk_macb1_int24      : 1'b0;     
  assign isolate_macb124        = (scan_mode24 == 1'b0) ?  isolate_macb1_int24       : 1'b0;      
  assign pwr1_on_macb124        = (scan_mode24 == 1'b0) ?  pwr1_on_macb1_int24       : 1'b1;       
  assign pwr2_on_macb124        = (scan_mode24 == 1'b0) ?  pwr2_on_macb1_int24       : 1'b1;       
  assign pwr1_off_macb124       = (scan_mode24 == 1'b0) ?  (!pwr1_on_macb1_int24)  : 1'b0;       
  assign pwr2_off_macb124       = (scan_mode24 == 1'b0) ?  (!pwr2_on_macb1_int24)  : 1'b0;       
  assign save_edge_macb124       = (scan_mode24 == 1'b0) ? (save_edge_macb1_int24) : 1'b0;       
  assign restore_edge_macb124       = (scan_mode24 == 1'b0) ? (restore_edge_macb1_int24) : 1'b0;       

  //ETH224
  assign rstn_non_srpg_macb224 = (scan_mode24 == 1'b0) ?  rstn_non_srpg_macb2_int24 : 1'b1;  
  assign gate_clk_macb224       = (scan_mode24 == 1'b0) ?  gate_clk_macb2_int24      : 1'b0;     
  assign isolate_macb224        = (scan_mode24 == 1'b0) ?  isolate_macb2_int24       : 1'b0;      
  assign pwr1_on_macb224        = (scan_mode24 == 1'b0) ?  pwr1_on_macb2_int24       : 1'b1;       
  assign pwr2_on_macb224        = (scan_mode24 == 1'b0) ?  pwr2_on_macb2_int24       : 1'b1;       
  assign pwr1_off_macb224       = (scan_mode24 == 1'b0) ?  (!pwr1_on_macb2_int24)  : 1'b0;       
  assign pwr2_off_macb224       = (scan_mode24 == 1'b0) ?  (!pwr2_on_macb2_int24)  : 1'b0;       
  assign save_edge_macb224       = (scan_mode24 == 1'b0) ? (save_edge_macb2_int24) : 1'b0;       
  assign restore_edge_macb224       = (scan_mode24 == 1'b0) ? (restore_edge_macb2_int24) : 1'b0;       

  //ETH324
  assign rstn_non_srpg_macb324 = (scan_mode24 == 1'b0) ?  rstn_non_srpg_macb3_int24 : 1'b1;  
  assign gate_clk_macb324       = (scan_mode24 == 1'b0) ?  gate_clk_macb3_int24      : 1'b0;     
  assign isolate_macb324        = (scan_mode24 == 1'b0) ?  isolate_macb3_int24       : 1'b0;      
  assign pwr1_on_macb324        = (scan_mode24 == 1'b0) ?  pwr1_on_macb3_int24       : 1'b1;       
  assign pwr2_on_macb324        = (scan_mode24 == 1'b0) ?  pwr2_on_macb3_int24       : 1'b1;       
  assign pwr1_off_macb324       = (scan_mode24 == 1'b0) ?  (!pwr1_on_macb3_int24)  : 1'b0;       
  assign pwr2_off_macb324       = (scan_mode24 == 1'b0) ?  (!pwr2_on_macb3_int24)  : 1'b0;       
  assign save_edge_macb324       = (scan_mode24 == 1'b0) ? (save_edge_macb3_int24) : 1'b0;       
  assign restore_edge_macb324       = (scan_mode24 == 1'b0) ? (restore_edge_macb3_int24) : 1'b0;       

  // MEM24
  assign rstn_non_srpg_mem24 =   (rstn_non_srpg_macb024 && rstn_non_srpg_macb124 && rstn_non_srpg_macb224 &&
                                rstn_non_srpg_macb324 && rstn_non_srpg_dma24 && rstn_non_srpg_cpu24 && rstn_non_srpg_urt24 &&
                                rstn_non_srpg_smc24);

  assign gate_clk_mem24 =  (gate_clk_macb024 && gate_clk_macb124 && gate_clk_macb224 &&
                            gate_clk_macb324 && gate_clk_dma24 && gate_clk_cpu24 && gate_clk_urt24 && gate_clk_smc24);

  assign isolate_mem24  = (isolate_macb024 && isolate_macb124 && isolate_macb224 &&
                         isolate_macb324 && isolate_dma24 && isolate_cpu24 && isolate_urt24 && isolate_smc24);


  assign pwr1_on_mem24        =   ~pwr1_off_mem24;

  assign pwr2_on_mem24        =   ~pwr2_off_mem24;

  assign pwr1_off_mem24       =  (pwr1_off_macb024 && pwr1_off_macb124 && pwr1_off_macb224 &&
                                 pwr1_off_macb324 && pwr1_off_dma24 && pwr1_off_cpu24 && pwr1_off_urt24 && pwr1_off_smc24);


  assign pwr2_off_mem24       =  (pwr2_off_macb024 && pwr2_off_macb124 && pwr2_off_macb224 &&
                                pwr2_off_macb324 && pwr2_off_dma24 && pwr2_off_cpu24 && pwr2_off_urt24 && pwr2_off_smc24);

  assign save_edge_mem24      =  (save_edge_macb024 && save_edge_macb124 && save_edge_macb224 &&
                                save_edge_macb324 && save_edge_dma24 && save_edge_cpu24 && save_edge_smc24 && save_edge_urt24);

  assign restore_edge_mem24   =  (restore_edge_macb024 && restore_edge_macb124 && restore_edge_macb224  &&
                                restore_edge_macb324 && restore_edge_dma24 && restore_edge_cpu24 && restore_edge_urt24 &&
                                restore_edge_smc24);

  assign standby_mem024 = pwr1_off_macb024 && (~ (pwr1_off_macb024 && pwr1_off_macb124 && pwr1_off_macb224 && pwr1_off_macb324 && pwr1_off_urt24 && pwr1_off_smc24 && pwr1_off_dma24 && pwr1_off_cpu24));
  assign standby_mem124 = pwr1_off_macb124 && (~ (pwr1_off_macb024 && pwr1_off_macb124 && pwr1_off_macb224 && pwr1_off_macb324 && pwr1_off_urt24 && pwr1_off_smc24 && pwr1_off_dma24 && pwr1_off_cpu24));
  assign standby_mem224 = pwr1_off_macb224 && (~ (pwr1_off_macb024 && pwr1_off_macb124 && pwr1_off_macb224 && pwr1_off_macb324 && pwr1_off_urt24 && pwr1_off_smc24 && pwr1_off_dma24 && pwr1_off_cpu24));
  assign standby_mem324 = pwr1_off_macb324 && (~ (pwr1_off_macb024 && pwr1_off_macb124 && pwr1_off_macb224 && pwr1_off_macb324 && pwr1_off_urt24 && pwr1_off_smc24 && pwr1_off_dma24 && pwr1_off_cpu24));

  assign pwr1_off_mem024 = pwr1_off_mem24;
  assign pwr1_off_mem124 = pwr1_off_mem24;
  assign pwr1_off_mem224 = pwr1_off_mem24;
  assign pwr1_off_mem324 = pwr1_off_mem24;

  assign rstn_non_srpg_alut24  =  (rstn_non_srpg_macb024 && rstn_non_srpg_macb124 && rstn_non_srpg_macb224 && rstn_non_srpg_macb324);


   assign gate_clk_alut24       =  (gate_clk_macb024 && gate_clk_macb124 && gate_clk_macb224 && gate_clk_macb324);


    assign isolate_alut24        =  (isolate_macb024 && isolate_macb124 && isolate_macb224 && isolate_macb324);


    assign pwr1_on_alut24        =  (pwr1_on_macb024 || pwr1_on_macb124 || pwr1_on_macb224 || pwr1_on_macb324);


    assign pwr2_on_alut24        =  (pwr2_on_macb024 || pwr2_on_macb124 || pwr2_on_macb224 || pwr2_on_macb324);


    assign pwr1_off_alut24       =  (pwr1_off_macb024 && pwr1_off_macb124 && pwr1_off_macb224 && pwr1_off_macb324);


    assign pwr2_off_alut24       =  (pwr2_off_macb024 && pwr2_off_macb124 && pwr2_off_macb224 && pwr2_off_macb324);


    assign save_edge_alut24      =  (save_edge_macb024 && save_edge_macb124 && save_edge_macb224 && save_edge_macb324);


    assign restore_edge_alut24   =  (restore_edge_macb024 || restore_edge_macb124 || restore_edge_macb224 ||
                                   restore_edge_macb324) && save_alut_tmp24;

     // alut24 power24 off24 detection24
  always @(posedge pclk24 or negedge nprst24) begin
    if (!nprst24) 
       save_alut_tmp24 <= 0;
    else if (restore_edge_alut24)
       save_alut_tmp24 <= 0;
    else if (save_edge_alut24)
       save_alut_tmp24 <= 1;
  end

  //DMA24
  assign rstn_non_srpg_dma24 = (scan_mode24 == 1'b0) ?  rstn_non_srpg_dma_int24 : 1'b1;  
  assign gate_clk_dma24       = (scan_mode24 == 1'b0) ?  gate_clk_dma_int24      : 1'b0;     
  assign isolate_dma24        = (scan_mode24 == 1'b0) ?  isolate_dma_int24       : 1'b0;      
  assign pwr1_on_dma24        = (scan_mode24 == 1'b0) ?  pwr1_on_dma_int24       : 1'b1;       
  assign pwr2_on_dma24        = (scan_mode24 == 1'b0) ?  pwr2_on_dma_int24       : 1'b1;       
  assign pwr1_off_dma24       = (scan_mode24 == 1'b0) ?  (!pwr1_on_dma_int24)  : 1'b0;       
  assign pwr2_off_dma24       = (scan_mode24 == 1'b0) ?  (!pwr2_on_dma_int24)  : 1'b0;       
  assign save_edge_dma24       = (scan_mode24 == 1'b0) ? (save_edge_dma_int24) : 1'b0;       
  assign restore_edge_dma24       = (scan_mode24 == 1'b0) ? (restore_edge_dma_int24) : 1'b0;       

  //CPU24
  assign rstn_non_srpg_cpu24 = (scan_mode24 == 1'b0) ?  rstn_non_srpg_cpu_int24 : 1'b1;  
  assign gate_clk_cpu24       = (scan_mode24 == 1'b0) ?  gate_clk_cpu_int24      : 1'b0;     
  assign isolate_cpu24        = (scan_mode24 == 1'b0) ?  isolate_cpu_int24       : 1'b0;      
  assign pwr1_on_cpu24        = (scan_mode24 == 1'b0) ?  pwr1_on_cpu_int24       : 1'b1;       
  assign pwr2_on_cpu24        = (scan_mode24 == 1'b0) ?  pwr2_on_cpu_int24       : 1'b1;       
  assign pwr1_off_cpu24       = (scan_mode24 == 1'b0) ?  (!pwr1_on_cpu_int24)  : 1'b0;       
  assign pwr2_off_cpu24       = (scan_mode24 == 1'b0) ?  (!pwr2_on_cpu_int24)  : 1'b0;       
  assign save_edge_cpu24       = (scan_mode24 == 1'b0) ? (save_edge_cpu_int24) : 1'b0;       
  assign restore_edge_cpu24       = (scan_mode24 == 1'b0) ? (restore_edge_cpu_int24) : 1'b0;       



  // ASE24

   reg ase_core_12v24, ase_core_10v24, ase_core_08v24, ase_core_06v24;
   reg ase_macb0_12v24,ase_macb1_12v24,ase_macb2_12v24,ase_macb3_12v24;

    // core24 ase24

    // core24 at 1.0 v if (smc24 off24, urt24 off24, macb024 off24, macb124 off24, macb224 off24, macb324 off24
   // core24 at 0.8v if (mac01off24, macb02off24, macb03off24, macb12off24, mac13off24, mac23off24,
   // core24 at 0.6v if (mac012off24, mac013off24, mac023off24, mac123off24, mac0123off24
    // else core24 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb024 && pwr1_off_macb124 && pwr1_off_macb224 && pwr1_off_macb324) || // all mac24 off24
       (pwr1_off_macb324 && pwr1_off_macb224 && pwr1_off_macb124) || // mac123off24 
       (pwr1_off_macb324 && pwr1_off_macb224 && pwr1_off_macb024) || // mac023off24 
       (pwr1_off_macb324 && pwr1_off_macb124 && pwr1_off_macb024) || // mac013off24 
       (pwr1_off_macb224 && pwr1_off_macb124 && pwr1_off_macb024) )  // mac012off24 
       begin
         ase_core_12v24 = 0;
         ase_core_10v24 = 0;
         ase_core_08v24 = 0;
         ase_core_06v24 = 1;
       end
     else if( (pwr1_off_macb224 && pwr1_off_macb324) || // mac2324 off24
         (pwr1_off_macb324 && pwr1_off_macb124) || // mac13off24 
         (pwr1_off_macb124 && pwr1_off_macb224) || // mac12off24 
         (pwr1_off_macb324 && pwr1_off_macb024) || // mac03off24 
         (pwr1_off_macb224 && pwr1_off_macb024) || // mac02off24 
         (pwr1_off_macb124 && pwr1_off_macb024))  // mac01off24 
       begin
         ase_core_12v24 = 0;
         ase_core_10v24 = 0;
         ase_core_08v24 = 1;
         ase_core_06v24 = 0;
       end
     else if( (pwr1_off_smc24) || // smc24 off24
         (pwr1_off_macb024 ) || // mac0off24 
         (pwr1_off_macb124 ) || // mac1off24 
         (pwr1_off_macb224 ) || // mac2off24 
         (pwr1_off_macb324 ))  // mac3off24 
       begin
         ase_core_12v24 = 0;
         ase_core_10v24 = 1;
         ase_core_08v24 = 0;
         ase_core_06v24 = 0;
       end
     else if (pwr1_off_urt24)
       begin
         ase_core_12v24 = 1;
         ase_core_10v24 = 0;
         ase_core_08v24 = 0;
         ase_core_06v24 = 0;
       end
     else
       begin
         ase_core_12v24 = 1;
         ase_core_10v24 = 0;
         ase_core_08v24 = 0;
         ase_core_06v24 = 0;
       end
   end


   // cpu24
   // cpu24 @ 1.0v when macoff24, 
   // 
   reg ase_cpu_10v24, ase_cpu_12v24;
   always @(*) begin
    if(pwr1_off_cpu24) begin
     ase_cpu_12v24 = 1'b0;
     ase_cpu_10v24 = 1'b0;
    end
    else if(pwr1_off_macb024 || pwr1_off_macb124 || pwr1_off_macb224 || pwr1_off_macb324)
    begin
     ase_cpu_12v24 = 1'b0;
     ase_cpu_10v24 = 1'b1;
    end
    else
    begin
     ase_cpu_12v24 = 1'b1;
     ase_cpu_10v24 = 1'b0;
    end
   end

   // dma24
   // dma24 @v124.0 for macoff24, 

   reg ase_dma_10v24, ase_dma_12v24;
   always @(*) begin
    if(pwr1_off_dma24) begin
     ase_dma_12v24 = 1'b0;
     ase_dma_10v24 = 1'b0;
    end
    else if(pwr1_off_macb024 || pwr1_off_macb124 || pwr1_off_macb224 || pwr1_off_macb324)
    begin
     ase_dma_12v24 = 1'b0;
     ase_dma_10v24 = 1'b1;
    end
    else
    begin
     ase_dma_12v24 = 1'b1;
     ase_dma_10v24 = 1'b0;
    end
   end

   // alut24
   // @ v124.0 for macoff24

   reg ase_alut_10v24, ase_alut_12v24;
   always @(*) begin
    if(pwr1_off_alut24) begin
     ase_alut_12v24 = 1'b0;
     ase_alut_10v24 = 1'b0;
    end
    else if(pwr1_off_macb024 || pwr1_off_macb124 || pwr1_off_macb224 || pwr1_off_macb324)
    begin
     ase_alut_12v24 = 1'b0;
     ase_alut_10v24 = 1'b1;
    end
    else
    begin
     ase_alut_12v24 = 1'b1;
     ase_alut_10v24 = 1'b0;
    end
   end




   reg ase_uart_12v24;
   reg ase_uart_10v24;
   reg ase_uart_08v24;
   reg ase_uart_06v24;

   reg ase_smc_12v24;


   always @(*) begin
     if(pwr1_off_urt24) begin // uart24 off24
       ase_uart_08v24 = 1'b0;
       ase_uart_06v24 = 1'b0;
       ase_uart_10v24 = 1'b0;
       ase_uart_12v24 = 1'b0;
     end 
     else if( (pwr1_off_macb024 && pwr1_off_macb124 && pwr1_off_macb224 && pwr1_off_macb324) || // all mac24 off24
       (pwr1_off_macb324 && pwr1_off_macb224 && pwr1_off_macb124) || // mac123off24 
       (pwr1_off_macb324 && pwr1_off_macb224 && pwr1_off_macb024) || // mac023off24 
       (pwr1_off_macb324 && pwr1_off_macb124 && pwr1_off_macb024) || // mac013off24 
       (pwr1_off_macb224 && pwr1_off_macb124 && pwr1_off_macb024) )  // mac012off24 
     begin
       ase_uart_06v24 = 1'b1;
       ase_uart_08v24 = 1'b0;
       ase_uart_10v24 = 1'b0;
       ase_uart_12v24 = 1'b0;
     end
     else if( (pwr1_off_macb224 && pwr1_off_macb324) || // mac2324 off24
         (pwr1_off_macb324 && pwr1_off_macb124) || // mac13off24 
         (pwr1_off_macb124 && pwr1_off_macb224) || // mac12off24 
         (pwr1_off_macb324 && pwr1_off_macb024) || // mac03off24 
         (pwr1_off_macb124 && pwr1_off_macb024))  // mac01off24  
     begin
       ase_uart_06v24 = 1'b0;
       ase_uart_08v24 = 1'b1;
       ase_uart_10v24 = 1'b0;
       ase_uart_12v24 = 1'b0;
     end
     else if (pwr1_off_smc24 || pwr1_off_macb024 || pwr1_off_macb124 || pwr1_off_macb224 || pwr1_off_macb324) begin // smc24 off24
       ase_uart_08v24 = 1'b0;
       ase_uart_06v24 = 1'b0;
       ase_uart_10v24 = 1'b1;
       ase_uart_12v24 = 1'b0;
     end 
     else begin
       ase_uart_08v24 = 1'b0;
       ase_uart_06v24 = 1'b0;
       ase_uart_10v24 = 1'b0;
       ase_uart_12v24 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc24) begin
     if (pwr1_off_smc24)  // smc24 off24
       ase_smc_12v24 = 1'b0;
    else
       ase_smc_12v24 = 1'b1;
   end

   
   always @(pwr1_off_macb024) begin
     if (pwr1_off_macb024) // macb024 off24
       ase_macb0_12v24 = 1'b0;
     else
       ase_macb0_12v24 = 1'b1;
   end

   always @(pwr1_off_macb124) begin
     if (pwr1_off_macb124) // macb124 off24
       ase_macb1_12v24 = 1'b0;
     else
       ase_macb1_12v24 = 1'b1;
   end

   always @(pwr1_off_macb224) begin // macb224 off24
     if (pwr1_off_macb224) // macb224 off24
       ase_macb2_12v24 = 1'b0;
     else
       ase_macb2_12v24 = 1'b1;
   end

   always @(pwr1_off_macb324) begin // macb324 off24
     if (pwr1_off_macb324) // macb324 off24
       ase_macb3_12v24 = 1'b0;
     else
       ase_macb3_12v24 = 1'b1;
   end


   // core24 voltage24 for vco24
  assign core12v24 = ase_macb0_12v24 & ase_macb1_12v24 & ase_macb2_12v24 & ase_macb3_12v24;

  assign core10v24 =  (ase_macb0_12v24 & ase_macb1_12v24 & ase_macb2_12v24 & (!ase_macb3_12v24)) ||
                    (ase_macb0_12v24 & ase_macb1_12v24 & (!ase_macb2_12v24) & ase_macb3_12v24) ||
                    (ase_macb0_12v24 & (!ase_macb1_12v24) & ase_macb2_12v24 & ase_macb3_12v24) ||
                    ((!ase_macb0_12v24) & ase_macb1_12v24 & ase_macb2_12v24 & ase_macb3_12v24);

  assign core08v24 =  ((!ase_macb0_12v24) & (!ase_macb1_12v24) & (ase_macb2_12v24) & (ase_macb3_12v24)) ||
                    ((!ase_macb0_12v24) & (ase_macb1_12v24) & (!ase_macb2_12v24) & (ase_macb3_12v24)) ||
                    ((!ase_macb0_12v24) & (ase_macb1_12v24) & (ase_macb2_12v24) & (!ase_macb3_12v24)) ||
                    ((ase_macb0_12v24) & (!ase_macb1_12v24) & (!ase_macb2_12v24) & (ase_macb3_12v24)) ||
                    ((ase_macb0_12v24) & (!ase_macb1_12v24) & (ase_macb2_12v24) & (!ase_macb3_12v24)) ||
                    ((ase_macb0_12v24) & (ase_macb1_12v24) & (!ase_macb2_12v24) & (!ase_macb3_12v24));

  assign core06v24 =  ((!ase_macb0_12v24) & (!ase_macb1_12v24) & (!ase_macb2_12v24) & (ase_macb3_12v24)) ||
                    ((!ase_macb0_12v24) & (!ase_macb1_12v24) & (ase_macb2_12v24) & (!ase_macb3_12v24)) ||
                    ((!ase_macb0_12v24) & (ase_macb1_12v24) & (!ase_macb2_12v24) & (!ase_macb3_12v24)) ||
                    ((ase_macb0_12v24) & (!ase_macb1_12v24) & (!ase_macb2_12v24) & (!ase_macb3_12v24)) ||
                    ((!ase_macb0_12v24) & (!ase_macb1_12v24) & (!ase_macb2_12v24) & (!ase_macb3_12v24)) ;



`ifdef LP_ABV_ON24
// psl24 default clock24 = (posedge pclk24);

// Cover24 a condition in which SMC24 is powered24 down
// and again24 powered24 up while UART24 is going24 into POWER24 down
// state or UART24 is already in POWER24 DOWN24 state
// psl24 cover_overlapping_smc_urt_124:
//    cover{fell24(pwr1_on_urt24);[*];fell24(pwr1_on_smc24);[*];
//    rose24(pwr1_on_smc24);[*];rose24(pwr1_on_urt24)};
//
// Cover24 a condition in which UART24 is powered24 down
// and again24 powered24 up while SMC24 is going24 into POWER24 down
// state or SMC24 is already in POWER24 DOWN24 state
// psl24 cover_overlapping_smc_urt_224:
//    cover{fell24(pwr1_on_smc24);[*];fell24(pwr1_on_urt24);[*];
//    rose24(pwr1_on_urt24);[*];rose24(pwr1_on_smc24)};
//


// Power24 Down24 UART24
// This24 gets24 triggered on rising24 edge of Gate24 signal24 for
// UART24 (gate_clk_urt24). In a next cycle after gate_clk_urt24,
// Isolate24 UART24(isolate_urt24) signal24 become24 HIGH24 (active).
// In 2nd cycle after gate_clk_urt24 becomes HIGH24, RESET24 for NON24
// SRPG24 FFs24(rstn_non_srpg_urt24) and POWER124 for UART24(pwr1_on_urt24) should 
// go24 LOW24. 
// This24 completes24 a POWER24 DOWN24. 

sequence s_power_down_urt24;
      (gate_clk_urt24 & !isolate_urt24 & rstn_non_srpg_urt24 & pwr1_on_urt24) 
  ##1 (gate_clk_urt24 & isolate_urt24 & rstn_non_srpg_urt24 & pwr1_on_urt24) 
  ##3 (gate_clk_urt24 & isolate_urt24 & !rstn_non_srpg_urt24 & !pwr1_on_urt24);
endsequence


property p_power_down_urt24;
   @(posedge pclk24)
    $rose(gate_clk_urt24) |=> s_power_down_urt24;
endproperty

output_power_down_urt24:
  assert property (p_power_down_urt24);


// Power24 UP24 UART24
// Sequence starts with , Rising24 edge of pwr1_on_urt24.
// Two24 clock24 cycle after this, isolate_urt24 should become24 LOW24 
// On24 the following24 clk24 gate_clk_urt24 should go24 low24.
// 5 cycles24 after  Rising24 edge of pwr1_on_urt24, rstn_non_srpg_urt24
// should become24 HIGH24
sequence s_power_up_urt24;
##30 (pwr1_on_urt24 & !isolate_urt24 & gate_clk_urt24 & !rstn_non_srpg_urt24) 
##1 (pwr1_on_urt24 & !isolate_urt24 & !gate_clk_urt24 & !rstn_non_srpg_urt24) 
##2 (pwr1_on_urt24 & !isolate_urt24 & !gate_clk_urt24 & rstn_non_srpg_urt24);
endsequence

property p_power_up_urt24;
   @(posedge pclk24)
  disable iff(!nprst24)
    (!pwr1_on_urt24 ##1 pwr1_on_urt24) |=> s_power_up_urt24;
endproperty

output_power_up_urt24:
  assert property (p_power_up_urt24);


// Power24 Down24 SMC24
// This24 gets24 triggered on rising24 edge of Gate24 signal24 for
// SMC24 (gate_clk_smc24). In a next cycle after gate_clk_smc24,
// Isolate24 SMC24(isolate_smc24) signal24 become24 HIGH24 (active).
// In 2nd cycle after gate_clk_smc24 becomes HIGH24, RESET24 for NON24
// SRPG24 FFs24(rstn_non_srpg_smc24) and POWER124 for SMC24(pwr1_on_smc24) should 
// go24 LOW24. 
// This24 completes24 a POWER24 DOWN24. 

sequence s_power_down_smc24;
      (gate_clk_smc24 & !isolate_smc24 & rstn_non_srpg_smc24 & pwr1_on_smc24) 
  ##1 (gate_clk_smc24 & isolate_smc24 & rstn_non_srpg_smc24 & pwr1_on_smc24) 
  ##3 (gate_clk_smc24 & isolate_smc24 & !rstn_non_srpg_smc24 & !pwr1_on_smc24);
endsequence


property p_power_down_smc24;
   @(posedge pclk24)
    $rose(gate_clk_smc24) |=> s_power_down_smc24;
endproperty

output_power_down_smc24:
  assert property (p_power_down_smc24);


// Power24 UP24 SMC24
// Sequence starts with , Rising24 edge of pwr1_on_smc24.
// Two24 clock24 cycle after this, isolate_smc24 should become24 LOW24 
// On24 the following24 clk24 gate_clk_smc24 should go24 low24.
// 5 cycles24 after  Rising24 edge of pwr1_on_smc24, rstn_non_srpg_smc24
// should become24 HIGH24
sequence s_power_up_smc24;
##30 (pwr1_on_smc24 & !isolate_smc24 & gate_clk_smc24 & !rstn_non_srpg_smc24) 
##1 (pwr1_on_smc24 & !isolate_smc24 & !gate_clk_smc24 & !rstn_non_srpg_smc24) 
##2 (pwr1_on_smc24 & !isolate_smc24 & !gate_clk_smc24 & rstn_non_srpg_smc24);
endsequence

property p_power_up_smc24;
   @(posedge pclk24)
  disable iff(!nprst24)
    (!pwr1_on_smc24 ##1 pwr1_on_smc24) |=> s_power_up_smc24;
endproperty

output_power_up_smc24:
  assert property (p_power_up_smc24);


// COVER24 SMC24 POWER24 DOWN24 AND24 UP24
cover_power_down_up_smc24: cover property (@(posedge pclk24)
(s_power_down_smc24 ##[5:180] s_power_up_smc24));



// COVER24 UART24 POWER24 DOWN24 AND24 UP24
cover_power_down_up_urt24: cover property (@(posedge pclk24)
(s_power_down_urt24 ##[5:180] s_power_up_urt24));

cover_power_down_urt24: cover property (@(posedge pclk24)
(s_power_down_urt24));

cover_power_up_urt24: cover property (@(posedge pclk24)
(s_power_up_urt24));




`ifdef PCM_ABV_ON24
//------------------------------------------------------------------------------
// Power24 Controller24 Formal24 Verification24 component.  Each power24 domain has a 
// separate24 instantiation24
//------------------------------------------------------------------------------

// need to assume that CPU24 will leave24 a minimum time between powering24 down and 
// back up.  In this example24, 10clks has been selected.
// psl24 config_min_uart_pd_time24 : assume always {rose24(L1_ctrl_domain24[1])} |-> { L1_ctrl_domain24[1][*10] } abort24(~nprst24);
// psl24 config_min_uart_pu_time24 : assume always {fell24(L1_ctrl_domain24[1])} |-> { !L1_ctrl_domain24[1][*10] } abort24(~nprst24);
// psl24 config_min_smc_pd_time24 : assume always {rose24(L1_ctrl_domain24[2])} |-> { L1_ctrl_domain24[2][*10] } abort24(~nprst24);
// psl24 config_min_smc_pu_time24 : assume always {fell24(L1_ctrl_domain24[2])} |-> { !L1_ctrl_domain24[2][*10] } abort24(~nprst24);

// UART24 VCOMP24 parameters24
   defparam i_uart_vcomp_domain24.ENABLE_SAVE_RESTORE_EDGE24   = 1;
   defparam i_uart_vcomp_domain24.ENABLE_EXT_PWR_CNTRL24       = 1;
   defparam i_uart_vcomp_domain24.REF_CLK_DEFINED24            = 0;
   defparam i_uart_vcomp_domain24.MIN_SHUTOFF_CYCLES24         = 4;
   defparam i_uart_vcomp_domain24.MIN_RESTORE_TO_ISO_CYCLES24  = 0;
   defparam i_uart_vcomp_domain24.MIN_SAVE_TO_SHUTOFF_CYCLES24 = 1;


   vcomp_domain24 i_uart_vcomp_domain24
   ( .ref_clk24(pclk24),
     .start_lps24(L1_ctrl_domain24[1] || !rstn_non_srpg_urt24),
     .rst_n24(nprst24),
     .ext_power_down24(L1_ctrl_domain24[1]),
     .iso_en24(isolate_urt24),
     .save_edge24(save_edge_urt24),
     .restore_edge24(restore_edge_urt24),
     .domain_shut_off24(pwr1_off_urt24),
     .domain_clk24(!gate_clk_urt24 && pclk24)
   );


// SMC24 VCOMP24 parameters24
   defparam i_smc_vcomp_domain24.ENABLE_SAVE_RESTORE_EDGE24   = 1;
   defparam i_smc_vcomp_domain24.ENABLE_EXT_PWR_CNTRL24       = 1;
   defparam i_smc_vcomp_domain24.REF_CLK_DEFINED24            = 0;
   defparam i_smc_vcomp_domain24.MIN_SHUTOFF_CYCLES24         = 4;
   defparam i_smc_vcomp_domain24.MIN_RESTORE_TO_ISO_CYCLES24  = 0;
   defparam i_smc_vcomp_domain24.MIN_SAVE_TO_SHUTOFF_CYCLES24 = 1;


   vcomp_domain24 i_smc_vcomp_domain24
   ( .ref_clk24(pclk24),
     .start_lps24(L1_ctrl_domain24[2] || !rstn_non_srpg_smc24),
     .rst_n24(nprst24),
     .ext_power_down24(L1_ctrl_domain24[2]),
     .iso_en24(isolate_smc24),
     .save_edge24(save_edge_smc24),
     .restore_edge24(restore_edge_smc24),
     .domain_shut_off24(pwr1_off_smc24),
     .domain_clk24(!gate_clk_smc24 && pclk24)
   );

`endif

`endif



endmodule
