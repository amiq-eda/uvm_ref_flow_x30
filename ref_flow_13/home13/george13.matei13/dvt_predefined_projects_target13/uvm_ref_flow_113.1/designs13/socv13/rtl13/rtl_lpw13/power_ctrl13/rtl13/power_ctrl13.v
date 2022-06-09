//File13 name   : power_ctrl13.v
//Title13       : Power13 Control13 Module13
//Created13     : 1999
//Description13 : Top13 level of power13 controller13
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

module power_ctrl13 (


    // Clocks13 & Reset13
    pclk13,
    nprst13,
    // APB13 programming13 interface
    paddr13,
    psel13,
    penable13,
    pwrite13,
    pwdata13,
    prdata13,
    // mac13 i/f,
    macb3_wakeup13,
    macb2_wakeup13,
    macb1_wakeup13,
    macb0_wakeup13,
    // Scan13 
    scan_in13,
    scan_en13,
    scan_mode13,
    scan_out13,
    // Module13 control13 outputs13
    int_source_h13,
    // SMC13
    rstn_non_srpg_smc13,
    gate_clk_smc13,
    isolate_smc13,
    save_edge_smc13,
    restore_edge_smc13,
    pwr1_on_smc13,
    pwr2_on_smc13,
    pwr1_off_smc13,
    pwr2_off_smc13,
    // URT13
    rstn_non_srpg_urt13,
    gate_clk_urt13,
    isolate_urt13,
    save_edge_urt13,
    restore_edge_urt13,
    pwr1_on_urt13,
    pwr2_on_urt13,
    pwr1_off_urt13,      
    pwr2_off_urt13,
    // ETH013
    rstn_non_srpg_macb013,
    gate_clk_macb013,
    isolate_macb013,
    save_edge_macb013,
    restore_edge_macb013,
    pwr1_on_macb013,
    pwr2_on_macb013,
    pwr1_off_macb013,      
    pwr2_off_macb013,
    // ETH113
    rstn_non_srpg_macb113,
    gate_clk_macb113,
    isolate_macb113,
    save_edge_macb113,
    restore_edge_macb113,
    pwr1_on_macb113,
    pwr2_on_macb113,
    pwr1_off_macb113,      
    pwr2_off_macb113,
    // ETH213
    rstn_non_srpg_macb213,
    gate_clk_macb213,
    isolate_macb213,
    save_edge_macb213,
    restore_edge_macb213,
    pwr1_on_macb213,
    pwr2_on_macb213,
    pwr1_off_macb213,      
    pwr2_off_macb213,
    // ETH313
    rstn_non_srpg_macb313,
    gate_clk_macb313,
    isolate_macb313,
    save_edge_macb313,
    restore_edge_macb313,
    pwr1_on_macb313,
    pwr2_on_macb313,
    pwr1_off_macb313,      
    pwr2_off_macb313,
    // DMA13
    rstn_non_srpg_dma13,
    gate_clk_dma13,
    isolate_dma13,
    save_edge_dma13,
    restore_edge_dma13,
    pwr1_on_dma13,
    pwr2_on_dma13,
    pwr1_off_dma13,      
    pwr2_off_dma13,
    // CPU13
    rstn_non_srpg_cpu13,
    gate_clk_cpu13,
    isolate_cpu13,
    save_edge_cpu13,
    restore_edge_cpu13,
    pwr1_on_cpu13,
    pwr2_on_cpu13,
    pwr1_off_cpu13,      
    pwr2_off_cpu13,
    // ALUT13
    rstn_non_srpg_alut13,
    gate_clk_alut13,
    isolate_alut13,
    save_edge_alut13,
    restore_edge_alut13,
    pwr1_on_alut13,
    pwr2_on_alut13,
    pwr1_off_alut13,      
    pwr2_off_alut13,
    // MEM13
    rstn_non_srpg_mem13,
    gate_clk_mem13,
    isolate_mem13,
    save_edge_mem13,
    restore_edge_mem13,
    pwr1_on_mem13,
    pwr2_on_mem13,
    pwr1_off_mem13,      
    pwr2_off_mem13,
    // core13 dvfs13 transitions13
    core06v13,
    core08v13,
    core10v13,
    core12v13,
    pcm_macb_wakeup_int13,
    // mte13 signals13
    mte_smc_start13,
    mte_uart_start13,
    mte_smc_uart_start13,  
    mte_pm_smc_to_default_start13, 
    mte_pm_uart_to_default_start13,
    mte_pm_smc_uart_to_default_start13

  );

  parameter STATE_IDLE_12V13 = 4'b0001;
  parameter STATE_06V13 = 4'b0010;
  parameter STATE_08V13 = 4'b0100;
  parameter STATE_10V13 = 4'b1000;

    // Clocks13 & Reset13
    input pclk13;
    input nprst13;
    // APB13 programming13 interface
    input [31:0] paddr13;
    input psel13  ;
    input penable13;
    input pwrite13 ;
    input [31:0] pwdata13;
    output [31:0] prdata13;
    // mac13
    input macb3_wakeup13;
    input macb2_wakeup13;
    input macb1_wakeup13;
    input macb0_wakeup13;
    // Scan13 
    input scan_in13;
    input scan_en13;
    input scan_mode13;
    output scan_out13;
    // Module13 control13 outputs13
    input int_source_h13;
    // SMC13
    output rstn_non_srpg_smc13 ;
    output gate_clk_smc13   ;
    output isolate_smc13   ;
    output save_edge_smc13   ;
    output restore_edge_smc13   ;
    output pwr1_on_smc13   ;
    output pwr2_on_smc13   ;
    output pwr1_off_smc13  ;
    output pwr2_off_smc13  ;
    // URT13
    output rstn_non_srpg_urt13 ;
    output gate_clk_urt13      ;
    output isolate_urt13       ;
    output save_edge_urt13   ;
    output restore_edge_urt13   ;
    output pwr1_on_urt13       ;
    output pwr2_on_urt13       ;
    output pwr1_off_urt13      ;
    output pwr2_off_urt13      ;
    // ETH013
    output rstn_non_srpg_macb013 ;
    output gate_clk_macb013      ;
    output isolate_macb013       ;
    output save_edge_macb013   ;
    output restore_edge_macb013   ;
    output pwr1_on_macb013       ;
    output pwr2_on_macb013       ;
    output pwr1_off_macb013      ;
    output pwr2_off_macb013      ;
    // ETH113
    output rstn_non_srpg_macb113 ;
    output gate_clk_macb113      ;
    output isolate_macb113       ;
    output save_edge_macb113   ;
    output restore_edge_macb113   ;
    output pwr1_on_macb113       ;
    output pwr2_on_macb113       ;
    output pwr1_off_macb113      ;
    output pwr2_off_macb113      ;
    // ETH213
    output rstn_non_srpg_macb213 ;
    output gate_clk_macb213      ;
    output isolate_macb213       ;
    output save_edge_macb213   ;
    output restore_edge_macb213   ;
    output pwr1_on_macb213       ;
    output pwr2_on_macb213       ;
    output pwr1_off_macb213      ;
    output pwr2_off_macb213      ;
    // ETH313
    output rstn_non_srpg_macb313 ;
    output gate_clk_macb313      ;
    output isolate_macb313       ;
    output save_edge_macb313   ;
    output restore_edge_macb313   ;
    output pwr1_on_macb313       ;
    output pwr2_on_macb313       ;
    output pwr1_off_macb313      ;
    output pwr2_off_macb313      ;
    // DMA13
    output rstn_non_srpg_dma13 ;
    output gate_clk_dma13      ;
    output isolate_dma13       ;
    output save_edge_dma13   ;
    output restore_edge_dma13   ;
    output pwr1_on_dma13       ;
    output pwr2_on_dma13       ;
    output pwr1_off_dma13      ;
    output pwr2_off_dma13      ;
    // CPU13
    output rstn_non_srpg_cpu13 ;
    output gate_clk_cpu13      ;
    output isolate_cpu13       ;
    output save_edge_cpu13   ;
    output restore_edge_cpu13   ;
    output pwr1_on_cpu13       ;
    output pwr2_on_cpu13       ;
    output pwr1_off_cpu13      ;
    output pwr2_off_cpu13      ;
    // ALUT13
    output rstn_non_srpg_alut13 ;
    output gate_clk_alut13      ;
    output isolate_alut13       ;
    output save_edge_alut13   ;
    output restore_edge_alut13   ;
    output pwr1_on_alut13       ;
    output pwr2_on_alut13       ;
    output pwr1_off_alut13      ;
    output pwr2_off_alut13      ;
    // MEM13
    output rstn_non_srpg_mem13 ;
    output gate_clk_mem13      ;
    output isolate_mem13       ;
    output save_edge_mem13   ;
    output restore_edge_mem13   ;
    output pwr1_on_mem13       ;
    output pwr2_on_mem13       ;
    output pwr1_off_mem13      ;
    output pwr2_off_mem13      ;


   // core13 transitions13 o/p
    output core06v13;
    output core08v13;
    output core10v13;
    output core12v13;
    output pcm_macb_wakeup_int13 ;
    //mode mte13  signals13
    output mte_smc_start13;
    output mte_uart_start13;
    output mte_smc_uart_start13;  
    output mte_pm_smc_to_default_start13; 
    output mte_pm_uart_to_default_start13;
    output mte_pm_smc_uart_to_default_start13;

    reg mte_smc_start13;
    reg mte_uart_start13;
    reg mte_smc_uart_start13;  
    reg mte_pm_smc_to_default_start13; 
    reg mte_pm_uart_to_default_start13;
    reg mte_pm_smc_uart_to_default_start13;

    reg [31:0] prdata13;

  wire valid_reg_write13  ;
  wire valid_reg_read13   ;
  wire L1_ctrl_access13   ;
  wire L1_status_access13 ;
  wire pcm_int_mask_access13;
  wire pcm_int_status_access13;
  wire standby_mem013      ;
  wire standby_mem113      ;
  wire standby_mem213      ;
  wire standby_mem313      ;
  wire pwr1_off_mem013;
  wire pwr1_off_mem113;
  wire pwr1_off_mem213;
  wire pwr1_off_mem313;
  
  // Control13 signals13
  wire set_status_smc13   ;
  wire clr_status_smc13   ;
  wire set_status_urt13   ;
  wire clr_status_urt13   ;
  wire set_status_macb013   ;
  wire clr_status_macb013   ;
  wire set_status_macb113   ;
  wire clr_status_macb113   ;
  wire set_status_macb213   ;
  wire clr_status_macb213   ;
  wire set_status_macb313   ;
  wire clr_status_macb313   ;
  wire set_status_dma13   ;
  wire clr_status_dma13   ;
  wire set_status_cpu13   ;
  wire clr_status_cpu13   ;
  wire set_status_alut13   ;
  wire clr_status_alut13   ;
  wire set_status_mem13   ;
  wire clr_status_mem13   ;


  // Status and Control13 registers
  reg [31:0]  L1_status_reg13;
  reg  [31:0] L1_ctrl_reg13  ;
  reg  [31:0] L1_ctrl_domain13  ;
  reg L1_ctrl_cpu_off_reg13;
  reg [31:0]  pcm_mask_reg13;
  reg [31:0]  pcm_status_reg13;

  // Signals13 gated13 in scan_mode13
  //SMC13
  wire  rstn_non_srpg_smc_int13;
  wire  gate_clk_smc_int13    ;     
  wire  isolate_smc_int13    ;       
  wire save_edge_smc_int13;
  wire restore_edge_smc_int13;
  wire  pwr1_on_smc_int13    ;      
  wire  pwr2_on_smc_int13    ;      


  //URT13
  wire   rstn_non_srpg_urt_int13;
  wire   gate_clk_urt_int13     ;     
  wire   isolate_urt_int13      ;       
  wire save_edge_urt_int13;
  wire restore_edge_urt_int13;
  wire   pwr1_on_urt_int13      ;      
  wire   pwr2_on_urt_int13      ;      

  // ETH013
  wire   rstn_non_srpg_macb0_int13;
  wire   gate_clk_macb0_int13     ;     
  wire   isolate_macb0_int13      ;       
  wire save_edge_macb0_int13;
  wire restore_edge_macb0_int13;
  wire   pwr1_on_macb0_int13      ;      
  wire   pwr2_on_macb0_int13      ;      
  // ETH113
  wire   rstn_non_srpg_macb1_int13;
  wire   gate_clk_macb1_int13     ;     
  wire   isolate_macb1_int13      ;       
  wire save_edge_macb1_int13;
  wire restore_edge_macb1_int13;
  wire   pwr1_on_macb1_int13      ;      
  wire   pwr2_on_macb1_int13      ;      
  // ETH213
  wire   rstn_non_srpg_macb2_int13;
  wire   gate_clk_macb2_int13     ;     
  wire   isolate_macb2_int13      ;       
  wire save_edge_macb2_int13;
  wire restore_edge_macb2_int13;
  wire   pwr1_on_macb2_int13      ;      
  wire   pwr2_on_macb2_int13      ;      
  // ETH313
  wire   rstn_non_srpg_macb3_int13;
  wire   gate_clk_macb3_int13     ;     
  wire   isolate_macb3_int13      ;       
  wire save_edge_macb3_int13;
  wire restore_edge_macb3_int13;
  wire   pwr1_on_macb3_int13      ;      
  wire   pwr2_on_macb3_int13      ;      

  // DMA13
  wire   rstn_non_srpg_dma_int13;
  wire   gate_clk_dma_int13     ;     
  wire   isolate_dma_int13      ;       
  wire save_edge_dma_int13;
  wire restore_edge_dma_int13;
  wire   pwr1_on_dma_int13      ;      
  wire   pwr2_on_dma_int13      ;      

  // CPU13
  wire   rstn_non_srpg_cpu_int13;
  wire   gate_clk_cpu_int13     ;     
  wire   isolate_cpu_int13      ;       
  wire save_edge_cpu_int13;
  wire restore_edge_cpu_int13;
  wire   pwr1_on_cpu_int13      ;      
  wire   pwr2_on_cpu_int13      ;  
  wire L1_ctrl_cpu_off_p13;    

  reg save_alut_tmp13;
  // DFS13 sm13

  reg cpu_shutoff_ctrl13;

  reg mte_mac_off_start13, mte_mac012_start13, mte_mac013_start13, mte_mac023_start13, mte_mac123_start13;
  reg mte_mac01_start13, mte_mac02_start13, mte_mac03_start13, mte_mac12_start13, mte_mac13_start13, mte_mac23_start13;
  reg mte_mac0_start13, mte_mac1_start13, mte_mac2_start13, mte_mac3_start13;
  reg mte_sys_hibernate13 ;
  reg mte_dma_start13 ;
  reg mte_cpu_start13 ;
  reg mte_mac_off_sleep_start13, mte_mac012_sleep_start13, mte_mac013_sleep_start13, mte_mac023_sleep_start13, mte_mac123_sleep_start13;
  reg mte_mac01_sleep_start13, mte_mac02_sleep_start13, mte_mac03_sleep_start13, mte_mac12_sleep_start13, mte_mac13_sleep_start13, mte_mac23_sleep_start13;
  reg mte_mac0_sleep_start13, mte_mac1_sleep_start13, mte_mac2_sleep_start13, mte_mac3_sleep_start13;
  reg mte_dma_sleep_start13;
  reg mte_mac_off_to_default13, mte_mac012_to_default13, mte_mac013_to_default13, mte_mac023_to_default13, mte_mac123_to_default13;
  reg mte_mac01_to_default13, mte_mac02_to_default13, mte_mac03_to_default13, mte_mac12_to_default13, mte_mac13_to_default13, mte_mac23_to_default13;
  reg mte_mac0_to_default13, mte_mac1_to_default13, mte_mac2_to_default13, mte_mac3_to_default13;
  reg mte_dma_isolate_dis13;
  reg mte_cpu_isolate_dis13;
  reg mte_sys_hibernate_to_default13;


  // Latch13 the CPU13 SLEEP13 invocation13
  always @( posedge pclk13 or negedge nprst13) 
  begin
    if(!nprst13)
      L1_ctrl_cpu_off_reg13 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg13 <= L1_ctrl_domain13[8];
  end

  // Create13 a pulse13 for sleep13 detection13 
  assign L1_ctrl_cpu_off_p13 =  L1_ctrl_domain13[8] && !L1_ctrl_cpu_off_reg13;
  
  // CPU13 sleep13 contol13 logic 
  // Shut13 off13 CPU13 when L1_ctrl_cpu_off_p13 is set
  // wake13 cpu13 when any interrupt13 is seen13  
  always @( posedge pclk13 or negedge nprst13) 
  begin
    if(!nprst13)
     cpu_shutoff_ctrl13 <= 1'b0;
    else if(cpu_shutoff_ctrl13 && int_source_h13)
     cpu_shutoff_ctrl13 <= 1'b0;
    else if (L1_ctrl_cpu_off_p13)
     cpu_shutoff_ctrl13 <= 1'b1;
  end
 
  // instantiate13 power13 contol13  block for uart13
  power_ctrl_sm13 i_urt_power_ctrl_sm13(
    .pclk13(pclk13),
    .nprst13(nprst13),
    .L1_module_req13(L1_ctrl_domain13[1]),
    .set_status_module13(set_status_urt13),
    .clr_status_module13(clr_status_urt13),
    .rstn_non_srpg_module13(rstn_non_srpg_urt_int13),
    .gate_clk_module13(gate_clk_urt_int13),
    .isolate_module13(isolate_urt_int13),
    .save_edge13(save_edge_urt_int13),
    .restore_edge13(restore_edge_urt_int13),
    .pwr1_on13(pwr1_on_urt_int13),
    .pwr2_on13(pwr2_on_urt_int13)
    );
  

  // instantiate13 power13 contol13  block for smc13
  power_ctrl_sm13 i_smc_power_ctrl_sm13(
    .pclk13(pclk13),
    .nprst13(nprst13),
    .L1_module_req13(L1_ctrl_domain13[2]),
    .set_status_module13(set_status_smc13),
    .clr_status_module13(clr_status_smc13),
    .rstn_non_srpg_module13(rstn_non_srpg_smc_int13),
    .gate_clk_module13(gate_clk_smc_int13),
    .isolate_module13(isolate_smc_int13),
    .save_edge13(save_edge_smc_int13),
    .restore_edge13(restore_edge_smc_int13),
    .pwr1_on13(pwr1_on_smc_int13),
    .pwr2_on13(pwr2_on_smc_int13)
    );

  // power13 control13 for macb013
  power_ctrl_sm13 i_macb0_power_ctrl_sm13(
    .pclk13(pclk13),
    .nprst13(nprst13),
    .L1_module_req13(L1_ctrl_domain13[3]),
    .set_status_module13(set_status_macb013),
    .clr_status_module13(clr_status_macb013),
    .rstn_non_srpg_module13(rstn_non_srpg_macb0_int13),
    .gate_clk_module13(gate_clk_macb0_int13),
    .isolate_module13(isolate_macb0_int13),
    .save_edge13(save_edge_macb0_int13),
    .restore_edge13(restore_edge_macb0_int13),
    .pwr1_on13(pwr1_on_macb0_int13),
    .pwr2_on13(pwr2_on_macb0_int13)
    );
  // power13 control13 for macb113
  power_ctrl_sm13 i_macb1_power_ctrl_sm13(
    .pclk13(pclk13),
    .nprst13(nprst13),
    .L1_module_req13(L1_ctrl_domain13[4]),
    .set_status_module13(set_status_macb113),
    .clr_status_module13(clr_status_macb113),
    .rstn_non_srpg_module13(rstn_non_srpg_macb1_int13),
    .gate_clk_module13(gate_clk_macb1_int13),
    .isolate_module13(isolate_macb1_int13),
    .save_edge13(save_edge_macb1_int13),
    .restore_edge13(restore_edge_macb1_int13),
    .pwr1_on13(pwr1_on_macb1_int13),
    .pwr2_on13(pwr2_on_macb1_int13)
    );
  // power13 control13 for macb213
  power_ctrl_sm13 i_macb2_power_ctrl_sm13(
    .pclk13(pclk13),
    .nprst13(nprst13),
    .L1_module_req13(L1_ctrl_domain13[5]),
    .set_status_module13(set_status_macb213),
    .clr_status_module13(clr_status_macb213),
    .rstn_non_srpg_module13(rstn_non_srpg_macb2_int13),
    .gate_clk_module13(gate_clk_macb2_int13),
    .isolate_module13(isolate_macb2_int13),
    .save_edge13(save_edge_macb2_int13),
    .restore_edge13(restore_edge_macb2_int13),
    .pwr1_on13(pwr1_on_macb2_int13),
    .pwr2_on13(pwr2_on_macb2_int13)
    );
  // power13 control13 for macb313
  power_ctrl_sm13 i_macb3_power_ctrl_sm13(
    .pclk13(pclk13),
    .nprst13(nprst13),
    .L1_module_req13(L1_ctrl_domain13[6]),
    .set_status_module13(set_status_macb313),
    .clr_status_module13(clr_status_macb313),
    .rstn_non_srpg_module13(rstn_non_srpg_macb3_int13),
    .gate_clk_module13(gate_clk_macb3_int13),
    .isolate_module13(isolate_macb3_int13),
    .save_edge13(save_edge_macb3_int13),
    .restore_edge13(restore_edge_macb3_int13),
    .pwr1_on13(pwr1_on_macb3_int13),
    .pwr2_on13(pwr2_on_macb3_int13)
    );
  // power13 control13 for dma13
  power_ctrl_sm13 i_dma_power_ctrl_sm13(
    .pclk13(pclk13),
    .nprst13(nprst13),
    .L1_module_req13(L1_ctrl_domain13[7]),
    .set_status_module13(set_status_dma13),
    .clr_status_module13(clr_status_dma13),
    .rstn_non_srpg_module13(rstn_non_srpg_dma_int13),
    .gate_clk_module13(gate_clk_dma_int13),
    .isolate_module13(isolate_dma_int13),
    .save_edge13(save_edge_dma_int13),
    .restore_edge13(restore_edge_dma_int13),
    .pwr1_on13(pwr1_on_dma_int13),
    .pwr2_on13(pwr2_on_dma_int13)
    );
  // power13 control13 for CPU13
  power_ctrl_sm13 i_cpu_power_ctrl_sm13(
    .pclk13(pclk13),
    .nprst13(nprst13),
    .L1_module_req13(cpu_shutoff_ctrl13),
    .set_status_module13(set_status_cpu13),
    .clr_status_module13(clr_status_cpu13),
    .rstn_non_srpg_module13(rstn_non_srpg_cpu_int13),
    .gate_clk_module13(gate_clk_cpu_int13),
    .isolate_module13(isolate_cpu_int13),
    .save_edge13(save_edge_cpu_int13),
    .restore_edge13(restore_edge_cpu_int13),
    .pwr1_on13(pwr1_on_cpu_int13),
    .pwr2_on13(pwr2_on_cpu_int13)
    );

  assign valid_reg_write13 =  (psel13 && pwrite13 && penable13);
  assign valid_reg_read13  =  (psel13 && (!pwrite13) && penable13);

  assign L1_ctrl_access13  =  (paddr13[15:0] == 16'b0000000000000100); 
  assign L1_status_access13 = (paddr13[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access13 =   (paddr13[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access13 = (paddr13[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control13 and status register
  always @(*)
  begin  
    if(valid_reg_read13 && L1_ctrl_access13) 
      prdata13 = L1_ctrl_reg13;
    else if (valid_reg_read13 && L1_status_access13)
      prdata13 = L1_status_reg13;
    else if (valid_reg_read13 && pcm_int_mask_access13)
      prdata13 = pcm_mask_reg13;
    else if (valid_reg_read13 && pcm_int_status_access13)
      prdata13 = pcm_status_reg13;
    else 
      prdata13 = 0;
  end

  assign set_status_mem13 =  (set_status_macb013 && set_status_macb113 && set_status_macb213 &&
                            set_status_macb313 && set_status_dma13 && set_status_cpu13);

  assign clr_status_mem13 =  (clr_status_macb013 && clr_status_macb113 && clr_status_macb213 &&
                            clr_status_macb313 && clr_status_dma13 && clr_status_cpu13);

  assign set_status_alut13 = (set_status_macb013 && set_status_macb113 && set_status_macb213 && set_status_macb313);

  assign clr_status_alut13 = (clr_status_macb013 || clr_status_macb113 || clr_status_macb213  || clr_status_macb313);

  // Write accesses to the control13 and status register
 
  always @(posedge pclk13 or negedge nprst13)
  begin
    if (!nprst13) begin
      L1_ctrl_reg13   <= 0;
      L1_status_reg13 <= 0;
      pcm_mask_reg13 <= 0;
    end else begin
      // CTRL13 reg updates13
      if (valid_reg_write13 && L1_ctrl_access13) 
        L1_ctrl_reg13 <= pwdata13; // Writes13 to the ctrl13 reg
      if (valid_reg_write13 && pcm_int_mask_access13) 
        pcm_mask_reg13 <= pwdata13; // Writes13 to the ctrl13 reg

      if (set_status_urt13 == 1'b1)  
        L1_status_reg13[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt13 == 1'b1) 
        L1_status_reg13[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc13 == 1'b1) 
        L1_status_reg13[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc13 == 1'b1) 
        L1_status_reg13[2] <= 1'b0; // Clear the status bit

      if (set_status_macb013 == 1'b1)  
        L1_status_reg13[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb013 == 1'b1) 
        L1_status_reg13[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb113 == 1'b1)  
        L1_status_reg13[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb113 == 1'b1) 
        L1_status_reg13[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb213 == 1'b1)  
        L1_status_reg13[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb213 == 1'b1) 
        L1_status_reg13[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb313 == 1'b1)  
        L1_status_reg13[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb313 == 1'b1) 
        L1_status_reg13[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma13 == 1'b1)  
        L1_status_reg13[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma13 == 1'b1) 
        L1_status_reg13[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu13 == 1'b1)  
        L1_status_reg13[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu13 == 1'b1) 
        L1_status_reg13[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut13 == 1'b1)  
        L1_status_reg13[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut13 == 1'b1) 
        L1_status_reg13[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem13 == 1'b1)  
        L1_status_reg13[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem13 == 1'b1) 
        L1_status_reg13[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused13 bits of pcm_status_reg13 are tied13 to 0
  always @(posedge pclk13 or negedge nprst13)
  begin
    if (!nprst13)
      pcm_status_reg13[31:4] <= 'b0;
    else  
      pcm_status_reg13[31:4] <= pcm_status_reg13[31:4];
  end
  
  // interrupt13 only of h/w assisted13 wakeup
  // MAC13 3
  always @(posedge pclk13 or negedge nprst13)
  begin
    if(!nprst13)
      pcm_status_reg13[3] <= 1'b0;
    else if (valid_reg_write13 && pcm_int_status_access13) 
      pcm_status_reg13[3] <= pwdata13[3];
    else if (macb3_wakeup13 & ~pcm_mask_reg13[3])
      pcm_status_reg13[3] <= 1'b1;
    else if (valid_reg_read13 && pcm_int_status_access13) 
      pcm_status_reg13[3] <= 1'b0;
    else
      pcm_status_reg13[3] <= pcm_status_reg13[3];
  end  
   
  // MAC13 2
  always @(posedge pclk13 or negedge nprst13)
  begin
    if(!nprst13)
      pcm_status_reg13[2] <= 1'b0;
    else if (valid_reg_write13 && pcm_int_status_access13) 
      pcm_status_reg13[2] <= pwdata13[2];
    else if (macb2_wakeup13 & ~pcm_mask_reg13[2])
      pcm_status_reg13[2] <= 1'b1;
    else if (valid_reg_read13 && pcm_int_status_access13) 
      pcm_status_reg13[2] <= 1'b0;
    else
      pcm_status_reg13[2] <= pcm_status_reg13[2];
  end  

  // MAC13 1
  always @(posedge pclk13 or negedge nprst13)
  begin
    if(!nprst13)
      pcm_status_reg13[1] <= 1'b0;
    else if (valid_reg_write13 && pcm_int_status_access13) 
      pcm_status_reg13[1] <= pwdata13[1];
    else if (macb1_wakeup13 & ~pcm_mask_reg13[1])
      pcm_status_reg13[1] <= 1'b1;
    else if (valid_reg_read13 && pcm_int_status_access13) 
      pcm_status_reg13[1] <= 1'b0;
    else
      pcm_status_reg13[1] <= pcm_status_reg13[1];
  end  
   
  // MAC13 0
  always @(posedge pclk13 or negedge nprst13)
  begin
    if(!nprst13)
      pcm_status_reg13[0] <= 1'b0;
    else if (valid_reg_write13 && pcm_int_status_access13) 
      pcm_status_reg13[0] <= pwdata13[0];
    else if (macb0_wakeup13 & ~pcm_mask_reg13[0])
      pcm_status_reg13[0] <= 1'b1;
    else if (valid_reg_read13 && pcm_int_status_access13) 
      pcm_status_reg13[0] <= 1'b0;
    else
      pcm_status_reg13[0] <= pcm_status_reg13[0];
  end  

  assign pcm_macb_wakeup_int13 = |pcm_status_reg13;

  reg [31:0] L1_ctrl_reg113;
  always @(posedge pclk13 or negedge nprst13)
  begin
    if(!nprst13)
      L1_ctrl_reg113 <= 0;
    else
      L1_ctrl_reg113 <= L1_ctrl_reg13;
  end

  // Program13 mode decode
  always @(L1_ctrl_reg13 or L1_ctrl_reg113 or int_source_h13 or cpu_shutoff_ctrl13) begin
    mte_smc_start13 = 0;
    mte_uart_start13 = 0;
    mte_smc_uart_start13  = 0;
    mte_mac_off_start13  = 0;
    mte_mac012_start13 = 0;
    mte_mac013_start13 = 0;
    mte_mac023_start13 = 0;
    mte_mac123_start13 = 0;
    mte_mac01_start13 = 0;
    mte_mac02_start13 = 0;
    mte_mac03_start13 = 0;
    mte_mac12_start13 = 0;
    mte_mac13_start13 = 0;
    mte_mac23_start13 = 0;
    mte_mac0_start13 = 0;
    mte_mac1_start13 = 0;
    mte_mac2_start13 = 0;
    mte_mac3_start13 = 0;
    mte_sys_hibernate13 = 0 ;
    mte_dma_start13 = 0 ;
    mte_cpu_start13 = 0 ;

    mte_mac0_sleep_start13 = (L1_ctrl_reg13 ==  'h14) && (L1_ctrl_reg113 == 'h4 );
    mte_mac1_sleep_start13 = (L1_ctrl_reg13 ==  'h14) && (L1_ctrl_reg113 == 'h5 ); 
    mte_mac2_sleep_start13 = (L1_ctrl_reg13 ==  'h14) && (L1_ctrl_reg113 == 'h6 ); 
    mte_mac3_sleep_start13 = (L1_ctrl_reg13 ==  'h14) && (L1_ctrl_reg113 == 'h7 ); 
    mte_mac01_sleep_start13 = (L1_ctrl_reg13 ==  'h14) && (L1_ctrl_reg113 == 'h8 ); 
    mte_mac02_sleep_start13 = (L1_ctrl_reg13 ==  'h14) && (L1_ctrl_reg113 == 'h9 ); 
    mte_mac03_sleep_start13 = (L1_ctrl_reg13 ==  'h14) && (L1_ctrl_reg113 == 'hA ); 
    mte_mac12_sleep_start13 = (L1_ctrl_reg13 ==  'h14) && (L1_ctrl_reg113 == 'hB ); 
    mte_mac13_sleep_start13 = (L1_ctrl_reg13 ==  'h14) && (L1_ctrl_reg113 == 'hC ); 
    mte_mac23_sleep_start13 = (L1_ctrl_reg13 ==  'h14) && (L1_ctrl_reg113 == 'hD ); 
    mte_mac012_sleep_start13 = (L1_ctrl_reg13 ==  'h14) && (L1_ctrl_reg113 == 'hE ); 
    mte_mac013_sleep_start13 = (L1_ctrl_reg13 ==  'h14) && (L1_ctrl_reg113 == 'hF ); 
    mte_mac023_sleep_start13 = (L1_ctrl_reg13 ==  'h14) && (L1_ctrl_reg113 == 'h10 ); 
    mte_mac123_sleep_start13 = (L1_ctrl_reg13 ==  'h14) && (L1_ctrl_reg113 == 'h11 ); 
    mte_mac_off_sleep_start13 =  (L1_ctrl_reg13 == 'h14) && (L1_ctrl_reg113 == 'h12 );
    mte_dma_sleep_start13 =  (L1_ctrl_reg13 == 'h14) && (L1_ctrl_reg113 == 'h13 );

    mte_pm_uart_to_default_start13 = (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'h1);
    mte_pm_smc_to_default_start13 = (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'h2);
    mte_pm_smc_uart_to_default_start13 = (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'h3); 
    mte_mac0_to_default13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'h4); 
    mte_mac1_to_default13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'h5); 
    mte_mac2_to_default13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'h6); 
    mte_mac3_to_default13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'h7); 
    mte_mac01_to_default13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'h8); 
    mte_mac02_to_default13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'h9); 
    mte_mac03_to_default13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'hA); 
    mte_mac12_to_default13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'hB); 
    mte_mac13_to_default13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'hC); 
    mte_mac23_to_default13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'hD); 
    mte_mac012_to_default13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'hE); 
    mte_mac013_to_default13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'hF); 
    mte_mac023_to_default13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'h10); 
    mte_mac123_to_default13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'h11); 
    mte_mac_off_to_default13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'h12); 
    mte_dma_isolate_dis13 =  (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'h13); 
    mte_cpu_isolate_dis13 =  (int_source_h13) && (cpu_shutoff_ctrl13) && (L1_ctrl_reg13 != 'h15);
    mte_sys_hibernate_to_default13 = (L1_ctrl_reg13 == 32'h0) && (L1_ctrl_reg113 == 'h15); 

   
    if (L1_ctrl_reg113 == 'h0) begin // This13 check is to make mte_cpu_start13
                                   // is set only when you from default state 
      case (L1_ctrl_reg13)
        'h0 : L1_ctrl_domain13 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain13 = 32'h2; // PM_uart13
                mte_uart_start13 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain13 = 32'h4; // PM_smc13
                mte_smc_start13 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain13 = 32'h6; // PM_smc_uart13
                mte_smc_uart_start13 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain13 = 32'h8; //  PM_macb013
                mte_mac0_start13 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain13 = 32'h10; //  PM_macb113
                mte_mac1_start13 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain13 = 32'h20; //  PM_macb213
                mte_mac2_start13 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain13 = 32'h40; //  PM_macb313
                mte_mac3_start13 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain13 = 32'h18; //  PM_macb0113
                mte_mac01_start13 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain13 = 32'h28; //  PM_macb0213
                mte_mac02_start13 = 1;
              end
        'hA : begin  
                L1_ctrl_domain13 = 32'h48; //  PM_macb0313
                mte_mac03_start13 = 1;
              end
        'hB : begin  
                L1_ctrl_domain13 = 32'h30; //  PM_macb1213
                mte_mac12_start13 = 1;
              end
        'hC : begin  
                L1_ctrl_domain13 = 32'h50; //  PM_macb1313
                mte_mac13_start13 = 1;
              end
        'hD : begin  
                L1_ctrl_domain13 = 32'h60; //  PM_macb2313
                mte_mac23_start13 = 1;
              end
        'hE : begin  
                L1_ctrl_domain13 = 32'h38; //  PM_macb01213
                mte_mac012_start13 = 1;
              end
        'hF : begin  
                L1_ctrl_domain13 = 32'h58; //  PM_macb01313
                mte_mac013_start13 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain13 = 32'h68; //  PM_macb02313
                mte_mac023_start13 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain13 = 32'h70; //  PM_macb12313
                mte_mac123_start13 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain13 = 32'h78; //  PM_macb_off13
                mte_mac_off_start13 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain13 = 32'h80; //  PM_dma13
                mte_dma_start13 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain13 = 32'h100; //  PM_cpu_sleep13
                mte_cpu_start13 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain13 = 32'h1FE; //  PM_hibernate13
                mte_sys_hibernate13 = 1;
              end
         default: L1_ctrl_domain13 = 32'h0;
      endcase
    end
  end


  wire to_default13 = (L1_ctrl_reg13 == 0);

  // Scan13 mode gating13 of power13 and isolation13 control13 signals13
  //SMC13
  assign rstn_non_srpg_smc13  = (scan_mode13 == 1'b0) ? rstn_non_srpg_smc_int13 : 1'b1;  
  assign gate_clk_smc13       = (scan_mode13 == 1'b0) ? gate_clk_smc_int13 : 1'b0;     
  assign isolate_smc13        = (scan_mode13 == 1'b0) ? isolate_smc_int13 : 1'b0;      
  assign pwr1_on_smc13        = (scan_mode13 == 1'b0) ? pwr1_on_smc_int13 : 1'b1;       
  assign pwr2_on_smc13        = (scan_mode13 == 1'b0) ? pwr2_on_smc_int13 : 1'b1;       
  assign pwr1_off_smc13       = (scan_mode13 == 1'b0) ? (!pwr1_on_smc_int13) : 1'b0;       
  assign pwr2_off_smc13       = (scan_mode13 == 1'b0) ? (!pwr2_on_smc_int13) : 1'b0;       
  assign save_edge_smc13       = (scan_mode13 == 1'b0) ? (save_edge_smc_int13) : 1'b0;       
  assign restore_edge_smc13       = (scan_mode13 == 1'b0) ? (restore_edge_smc_int13) : 1'b0;       

  //URT13
  assign rstn_non_srpg_urt13  = (scan_mode13 == 1'b0) ?  rstn_non_srpg_urt_int13 : 1'b1;  
  assign gate_clk_urt13       = (scan_mode13 == 1'b0) ?  gate_clk_urt_int13      : 1'b0;     
  assign isolate_urt13        = (scan_mode13 == 1'b0) ?  isolate_urt_int13       : 1'b0;      
  assign pwr1_on_urt13        = (scan_mode13 == 1'b0) ?  pwr1_on_urt_int13       : 1'b1;       
  assign pwr2_on_urt13        = (scan_mode13 == 1'b0) ?  pwr2_on_urt_int13       : 1'b1;       
  assign pwr1_off_urt13       = (scan_mode13 == 1'b0) ?  (!pwr1_on_urt_int13)  : 1'b0;       
  assign pwr2_off_urt13       = (scan_mode13 == 1'b0) ?  (!pwr2_on_urt_int13)  : 1'b0;       
  assign save_edge_urt13       = (scan_mode13 == 1'b0) ? (save_edge_urt_int13) : 1'b0;       
  assign restore_edge_urt13       = (scan_mode13 == 1'b0) ? (restore_edge_urt_int13) : 1'b0;       

  //ETH013
  assign rstn_non_srpg_macb013 = (scan_mode13 == 1'b0) ?  rstn_non_srpg_macb0_int13 : 1'b1;  
  assign gate_clk_macb013       = (scan_mode13 == 1'b0) ?  gate_clk_macb0_int13      : 1'b0;     
  assign isolate_macb013        = (scan_mode13 == 1'b0) ?  isolate_macb0_int13       : 1'b0;      
  assign pwr1_on_macb013        = (scan_mode13 == 1'b0) ?  pwr1_on_macb0_int13       : 1'b1;       
  assign pwr2_on_macb013        = (scan_mode13 == 1'b0) ?  pwr2_on_macb0_int13       : 1'b1;       
  assign pwr1_off_macb013       = (scan_mode13 == 1'b0) ?  (!pwr1_on_macb0_int13)  : 1'b0;       
  assign pwr2_off_macb013       = (scan_mode13 == 1'b0) ?  (!pwr2_on_macb0_int13)  : 1'b0;       
  assign save_edge_macb013       = (scan_mode13 == 1'b0) ? (save_edge_macb0_int13) : 1'b0;       
  assign restore_edge_macb013       = (scan_mode13 == 1'b0) ? (restore_edge_macb0_int13) : 1'b0;       

  //ETH113
  assign rstn_non_srpg_macb113 = (scan_mode13 == 1'b0) ?  rstn_non_srpg_macb1_int13 : 1'b1;  
  assign gate_clk_macb113       = (scan_mode13 == 1'b0) ?  gate_clk_macb1_int13      : 1'b0;     
  assign isolate_macb113        = (scan_mode13 == 1'b0) ?  isolate_macb1_int13       : 1'b0;      
  assign pwr1_on_macb113        = (scan_mode13 == 1'b0) ?  pwr1_on_macb1_int13       : 1'b1;       
  assign pwr2_on_macb113        = (scan_mode13 == 1'b0) ?  pwr2_on_macb1_int13       : 1'b1;       
  assign pwr1_off_macb113       = (scan_mode13 == 1'b0) ?  (!pwr1_on_macb1_int13)  : 1'b0;       
  assign pwr2_off_macb113       = (scan_mode13 == 1'b0) ?  (!pwr2_on_macb1_int13)  : 1'b0;       
  assign save_edge_macb113       = (scan_mode13 == 1'b0) ? (save_edge_macb1_int13) : 1'b0;       
  assign restore_edge_macb113       = (scan_mode13 == 1'b0) ? (restore_edge_macb1_int13) : 1'b0;       

  //ETH213
  assign rstn_non_srpg_macb213 = (scan_mode13 == 1'b0) ?  rstn_non_srpg_macb2_int13 : 1'b1;  
  assign gate_clk_macb213       = (scan_mode13 == 1'b0) ?  gate_clk_macb2_int13      : 1'b0;     
  assign isolate_macb213        = (scan_mode13 == 1'b0) ?  isolate_macb2_int13       : 1'b0;      
  assign pwr1_on_macb213        = (scan_mode13 == 1'b0) ?  pwr1_on_macb2_int13       : 1'b1;       
  assign pwr2_on_macb213        = (scan_mode13 == 1'b0) ?  pwr2_on_macb2_int13       : 1'b1;       
  assign pwr1_off_macb213       = (scan_mode13 == 1'b0) ?  (!pwr1_on_macb2_int13)  : 1'b0;       
  assign pwr2_off_macb213       = (scan_mode13 == 1'b0) ?  (!pwr2_on_macb2_int13)  : 1'b0;       
  assign save_edge_macb213       = (scan_mode13 == 1'b0) ? (save_edge_macb2_int13) : 1'b0;       
  assign restore_edge_macb213       = (scan_mode13 == 1'b0) ? (restore_edge_macb2_int13) : 1'b0;       

  //ETH313
  assign rstn_non_srpg_macb313 = (scan_mode13 == 1'b0) ?  rstn_non_srpg_macb3_int13 : 1'b1;  
  assign gate_clk_macb313       = (scan_mode13 == 1'b0) ?  gate_clk_macb3_int13      : 1'b0;     
  assign isolate_macb313        = (scan_mode13 == 1'b0) ?  isolate_macb3_int13       : 1'b0;      
  assign pwr1_on_macb313        = (scan_mode13 == 1'b0) ?  pwr1_on_macb3_int13       : 1'b1;       
  assign pwr2_on_macb313        = (scan_mode13 == 1'b0) ?  pwr2_on_macb3_int13       : 1'b1;       
  assign pwr1_off_macb313       = (scan_mode13 == 1'b0) ?  (!pwr1_on_macb3_int13)  : 1'b0;       
  assign pwr2_off_macb313       = (scan_mode13 == 1'b0) ?  (!pwr2_on_macb3_int13)  : 1'b0;       
  assign save_edge_macb313       = (scan_mode13 == 1'b0) ? (save_edge_macb3_int13) : 1'b0;       
  assign restore_edge_macb313       = (scan_mode13 == 1'b0) ? (restore_edge_macb3_int13) : 1'b0;       

  // MEM13
  assign rstn_non_srpg_mem13 =   (rstn_non_srpg_macb013 && rstn_non_srpg_macb113 && rstn_non_srpg_macb213 &&
                                rstn_non_srpg_macb313 && rstn_non_srpg_dma13 && rstn_non_srpg_cpu13 && rstn_non_srpg_urt13 &&
                                rstn_non_srpg_smc13);

  assign gate_clk_mem13 =  (gate_clk_macb013 && gate_clk_macb113 && gate_clk_macb213 &&
                            gate_clk_macb313 && gate_clk_dma13 && gate_clk_cpu13 && gate_clk_urt13 && gate_clk_smc13);

  assign isolate_mem13  = (isolate_macb013 && isolate_macb113 && isolate_macb213 &&
                         isolate_macb313 && isolate_dma13 && isolate_cpu13 && isolate_urt13 && isolate_smc13);


  assign pwr1_on_mem13        =   ~pwr1_off_mem13;

  assign pwr2_on_mem13        =   ~pwr2_off_mem13;

  assign pwr1_off_mem13       =  (pwr1_off_macb013 && pwr1_off_macb113 && pwr1_off_macb213 &&
                                 pwr1_off_macb313 && pwr1_off_dma13 && pwr1_off_cpu13 && pwr1_off_urt13 && pwr1_off_smc13);


  assign pwr2_off_mem13       =  (pwr2_off_macb013 && pwr2_off_macb113 && pwr2_off_macb213 &&
                                pwr2_off_macb313 && pwr2_off_dma13 && pwr2_off_cpu13 && pwr2_off_urt13 && pwr2_off_smc13);

  assign save_edge_mem13      =  (save_edge_macb013 && save_edge_macb113 && save_edge_macb213 &&
                                save_edge_macb313 && save_edge_dma13 && save_edge_cpu13 && save_edge_smc13 && save_edge_urt13);

  assign restore_edge_mem13   =  (restore_edge_macb013 && restore_edge_macb113 && restore_edge_macb213  &&
                                restore_edge_macb313 && restore_edge_dma13 && restore_edge_cpu13 && restore_edge_urt13 &&
                                restore_edge_smc13);

  assign standby_mem013 = pwr1_off_macb013 && (~ (pwr1_off_macb013 && pwr1_off_macb113 && pwr1_off_macb213 && pwr1_off_macb313 && pwr1_off_urt13 && pwr1_off_smc13 && pwr1_off_dma13 && pwr1_off_cpu13));
  assign standby_mem113 = pwr1_off_macb113 && (~ (pwr1_off_macb013 && pwr1_off_macb113 && pwr1_off_macb213 && pwr1_off_macb313 && pwr1_off_urt13 && pwr1_off_smc13 && pwr1_off_dma13 && pwr1_off_cpu13));
  assign standby_mem213 = pwr1_off_macb213 && (~ (pwr1_off_macb013 && pwr1_off_macb113 && pwr1_off_macb213 && pwr1_off_macb313 && pwr1_off_urt13 && pwr1_off_smc13 && pwr1_off_dma13 && pwr1_off_cpu13));
  assign standby_mem313 = pwr1_off_macb313 && (~ (pwr1_off_macb013 && pwr1_off_macb113 && pwr1_off_macb213 && pwr1_off_macb313 && pwr1_off_urt13 && pwr1_off_smc13 && pwr1_off_dma13 && pwr1_off_cpu13));

  assign pwr1_off_mem013 = pwr1_off_mem13;
  assign pwr1_off_mem113 = pwr1_off_mem13;
  assign pwr1_off_mem213 = pwr1_off_mem13;
  assign pwr1_off_mem313 = pwr1_off_mem13;

  assign rstn_non_srpg_alut13  =  (rstn_non_srpg_macb013 && rstn_non_srpg_macb113 && rstn_non_srpg_macb213 && rstn_non_srpg_macb313);


   assign gate_clk_alut13       =  (gate_clk_macb013 && gate_clk_macb113 && gate_clk_macb213 && gate_clk_macb313);


    assign isolate_alut13        =  (isolate_macb013 && isolate_macb113 && isolate_macb213 && isolate_macb313);


    assign pwr1_on_alut13        =  (pwr1_on_macb013 || pwr1_on_macb113 || pwr1_on_macb213 || pwr1_on_macb313);


    assign pwr2_on_alut13        =  (pwr2_on_macb013 || pwr2_on_macb113 || pwr2_on_macb213 || pwr2_on_macb313);


    assign pwr1_off_alut13       =  (pwr1_off_macb013 && pwr1_off_macb113 && pwr1_off_macb213 && pwr1_off_macb313);


    assign pwr2_off_alut13       =  (pwr2_off_macb013 && pwr2_off_macb113 && pwr2_off_macb213 && pwr2_off_macb313);


    assign save_edge_alut13      =  (save_edge_macb013 && save_edge_macb113 && save_edge_macb213 && save_edge_macb313);


    assign restore_edge_alut13   =  (restore_edge_macb013 || restore_edge_macb113 || restore_edge_macb213 ||
                                   restore_edge_macb313) && save_alut_tmp13;

     // alut13 power13 off13 detection13
  always @(posedge pclk13 or negedge nprst13) begin
    if (!nprst13) 
       save_alut_tmp13 <= 0;
    else if (restore_edge_alut13)
       save_alut_tmp13 <= 0;
    else if (save_edge_alut13)
       save_alut_tmp13 <= 1;
  end

  //DMA13
  assign rstn_non_srpg_dma13 = (scan_mode13 == 1'b0) ?  rstn_non_srpg_dma_int13 : 1'b1;  
  assign gate_clk_dma13       = (scan_mode13 == 1'b0) ?  gate_clk_dma_int13      : 1'b0;     
  assign isolate_dma13        = (scan_mode13 == 1'b0) ?  isolate_dma_int13       : 1'b0;      
  assign pwr1_on_dma13        = (scan_mode13 == 1'b0) ?  pwr1_on_dma_int13       : 1'b1;       
  assign pwr2_on_dma13        = (scan_mode13 == 1'b0) ?  pwr2_on_dma_int13       : 1'b1;       
  assign pwr1_off_dma13       = (scan_mode13 == 1'b0) ?  (!pwr1_on_dma_int13)  : 1'b0;       
  assign pwr2_off_dma13       = (scan_mode13 == 1'b0) ?  (!pwr2_on_dma_int13)  : 1'b0;       
  assign save_edge_dma13       = (scan_mode13 == 1'b0) ? (save_edge_dma_int13) : 1'b0;       
  assign restore_edge_dma13       = (scan_mode13 == 1'b0) ? (restore_edge_dma_int13) : 1'b0;       

  //CPU13
  assign rstn_non_srpg_cpu13 = (scan_mode13 == 1'b0) ?  rstn_non_srpg_cpu_int13 : 1'b1;  
  assign gate_clk_cpu13       = (scan_mode13 == 1'b0) ?  gate_clk_cpu_int13      : 1'b0;     
  assign isolate_cpu13        = (scan_mode13 == 1'b0) ?  isolate_cpu_int13       : 1'b0;      
  assign pwr1_on_cpu13        = (scan_mode13 == 1'b0) ?  pwr1_on_cpu_int13       : 1'b1;       
  assign pwr2_on_cpu13        = (scan_mode13 == 1'b0) ?  pwr2_on_cpu_int13       : 1'b1;       
  assign pwr1_off_cpu13       = (scan_mode13 == 1'b0) ?  (!pwr1_on_cpu_int13)  : 1'b0;       
  assign pwr2_off_cpu13       = (scan_mode13 == 1'b0) ?  (!pwr2_on_cpu_int13)  : 1'b0;       
  assign save_edge_cpu13       = (scan_mode13 == 1'b0) ? (save_edge_cpu_int13) : 1'b0;       
  assign restore_edge_cpu13       = (scan_mode13 == 1'b0) ? (restore_edge_cpu_int13) : 1'b0;       



  // ASE13

   reg ase_core_12v13, ase_core_10v13, ase_core_08v13, ase_core_06v13;
   reg ase_macb0_12v13,ase_macb1_12v13,ase_macb2_12v13,ase_macb3_12v13;

    // core13 ase13

    // core13 at 1.0 v if (smc13 off13, urt13 off13, macb013 off13, macb113 off13, macb213 off13, macb313 off13
   // core13 at 0.8v if (mac01off13, macb02off13, macb03off13, macb12off13, mac13off13, mac23off13,
   // core13 at 0.6v if (mac012off13, mac013off13, mac023off13, mac123off13, mac0123off13
    // else core13 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb013 && pwr1_off_macb113 && pwr1_off_macb213 && pwr1_off_macb313) || // all mac13 off13
       (pwr1_off_macb313 && pwr1_off_macb213 && pwr1_off_macb113) || // mac123off13 
       (pwr1_off_macb313 && pwr1_off_macb213 && pwr1_off_macb013) || // mac023off13 
       (pwr1_off_macb313 && pwr1_off_macb113 && pwr1_off_macb013) || // mac013off13 
       (pwr1_off_macb213 && pwr1_off_macb113 && pwr1_off_macb013) )  // mac012off13 
       begin
         ase_core_12v13 = 0;
         ase_core_10v13 = 0;
         ase_core_08v13 = 0;
         ase_core_06v13 = 1;
       end
     else if( (pwr1_off_macb213 && pwr1_off_macb313) || // mac2313 off13
         (pwr1_off_macb313 && pwr1_off_macb113) || // mac13off13 
         (pwr1_off_macb113 && pwr1_off_macb213) || // mac12off13 
         (pwr1_off_macb313 && pwr1_off_macb013) || // mac03off13 
         (pwr1_off_macb213 && pwr1_off_macb013) || // mac02off13 
         (pwr1_off_macb113 && pwr1_off_macb013))  // mac01off13 
       begin
         ase_core_12v13 = 0;
         ase_core_10v13 = 0;
         ase_core_08v13 = 1;
         ase_core_06v13 = 0;
       end
     else if( (pwr1_off_smc13) || // smc13 off13
         (pwr1_off_macb013 ) || // mac0off13 
         (pwr1_off_macb113 ) || // mac1off13 
         (pwr1_off_macb213 ) || // mac2off13 
         (pwr1_off_macb313 ))  // mac3off13 
       begin
         ase_core_12v13 = 0;
         ase_core_10v13 = 1;
         ase_core_08v13 = 0;
         ase_core_06v13 = 0;
       end
     else if (pwr1_off_urt13)
       begin
         ase_core_12v13 = 1;
         ase_core_10v13 = 0;
         ase_core_08v13 = 0;
         ase_core_06v13 = 0;
       end
     else
       begin
         ase_core_12v13 = 1;
         ase_core_10v13 = 0;
         ase_core_08v13 = 0;
         ase_core_06v13 = 0;
       end
   end


   // cpu13
   // cpu13 @ 1.0v when macoff13, 
   // 
   reg ase_cpu_10v13, ase_cpu_12v13;
   always @(*) begin
    if(pwr1_off_cpu13) begin
     ase_cpu_12v13 = 1'b0;
     ase_cpu_10v13 = 1'b0;
    end
    else if(pwr1_off_macb013 || pwr1_off_macb113 || pwr1_off_macb213 || pwr1_off_macb313)
    begin
     ase_cpu_12v13 = 1'b0;
     ase_cpu_10v13 = 1'b1;
    end
    else
    begin
     ase_cpu_12v13 = 1'b1;
     ase_cpu_10v13 = 1'b0;
    end
   end

   // dma13
   // dma13 @v113.0 for macoff13, 

   reg ase_dma_10v13, ase_dma_12v13;
   always @(*) begin
    if(pwr1_off_dma13) begin
     ase_dma_12v13 = 1'b0;
     ase_dma_10v13 = 1'b0;
    end
    else if(pwr1_off_macb013 || pwr1_off_macb113 || pwr1_off_macb213 || pwr1_off_macb313)
    begin
     ase_dma_12v13 = 1'b0;
     ase_dma_10v13 = 1'b1;
    end
    else
    begin
     ase_dma_12v13 = 1'b1;
     ase_dma_10v13 = 1'b0;
    end
   end

   // alut13
   // @ v113.0 for macoff13

   reg ase_alut_10v13, ase_alut_12v13;
   always @(*) begin
    if(pwr1_off_alut13) begin
     ase_alut_12v13 = 1'b0;
     ase_alut_10v13 = 1'b0;
    end
    else if(pwr1_off_macb013 || pwr1_off_macb113 || pwr1_off_macb213 || pwr1_off_macb313)
    begin
     ase_alut_12v13 = 1'b0;
     ase_alut_10v13 = 1'b1;
    end
    else
    begin
     ase_alut_12v13 = 1'b1;
     ase_alut_10v13 = 1'b0;
    end
   end




   reg ase_uart_12v13;
   reg ase_uart_10v13;
   reg ase_uart_08v13;
   reg ase_uart_06v13;

   reg ase_smc_12v13;


   always @(*) begin
     if(pwr1_off_urt13) begin // uart13 off13
       ase_uart_08v13 = 1'b0;
       ase_uart_06v13 = 1'b0;
       ase_uart_10v13 = 1'b0;
       ase_uart_12v13 = 1'b0;
     end 
     else if( (pwr1_off_macb013 && pwr1_off_macb113 && pwr1_off_macb213 && pwr1_off_macb313) || // all mac13 off13
       (pwr1_off_macb313 && pwr1_off_macb213 && pwr1_off_macb113) || // mac123off13 
       (pwr1_off_macb313 && pwr1_off_macb213 && pwr1_off_macb013) || // mac023off13 
       (pwr1_off_macb313 && pwr1_off_macb113 && pwr1_off_macb013) || // mac013off13 
       (pwr1_off_macb213 && pwr1_off_macb113 && pwr1_off_macb013) )  // mac012off13 
     begin
       ase_uart_06v13 = 1'b1;
       ase_uart_08v13 = 1'b0;
       ase_uart_10v13 = 1'b0;
       ase_uart_12v13 = 1'b0;
     end
     else if( (pwr1_off_macb213 && pwr1_off_macb313) || // mac2313 off13
         (pwr1_off_macb313 && pwr1_off_macb113) || // mac13off13 
         (pwr1_off_macb113 && pwr1_off_macb213) || // mac12off13 
         (pwr1_off_macb313 && pwr1_off_macb013) || // mac03off13 
         (pwr1_off_macb113 && pwr1_off_macb013))  // mac01off13  
     begin
       ase_uart_06v13 = 1'b0;
       ase_uart_08v13 = 1'b1;
       ase_uart_10v13 = 1'b0;
       ase_uart_12v13 = 1'b0;
     end
     else if (pwr1_off_smc13 || pwr1_off_macb013 || pwr1_off_macb113 || pwr1_off_macb213 || pwr1_off_macb313) begin // smc13 off13
       ase_uart_08v13 = 1'b0;
       ase_uart_06v13 = 1'b0;
       ase_uart_10v13 = 1'b1;
       ase_uart_12v13 = 1'b0;
     end 
     else begin
       ase_uart_08v13 = 1'b0;
       ase_uart_06v13 = 1'b0;
       ase_uart_10v13 = 1'b0;
       ase_uart_12v13 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc13) begin
     if (pwr1_off_smc13)  // smc13 off13
       ase_smc_12v13 = 1'b0;
    else
       ase_smc_12v13 = 1'b1;
   end

   
   always @(pwr1_off_macb013) begin
     if (pwr1_off_macb013) // macb013 off13
       ase_macb0_12v13 = 1'b0;
     else
       ase_macb0_12v13 = 1'b1;
   end

   always @(pwr1_off_macb113) begin
     if (pwr1_off_macb113) // macb113 off13
       ase_macb1_12v13 = 1'b0;
     else
       ase_macb1_12v13 = 1'b1;
   end

   always @(pwr1_off_macb213) begin // macb213 off13
     if (pwr1_off_macb213) // macb213 off13
       ase_macb2_12v13 = 1'b0;
     else
       ase_macb2_12v13 = 1'b1;
   end

   always @(pwr1_off_macb313) begin // macb313 off13
     if (pwr1_off_macb313) // macb313 off13
       ase_macb3_12v13 = 1'b0;
     else
       ase_macb3_12v13 = 1'b1;
   end


   // core13 voltage13 for vco13
  assign core12v13 = ase_macb0_12v13 & ase_macb1_12v13 & ase_macb2_12v13 & ase_macb3_12v13;

  assign core10v13 =  (ase_macb0_12v13 & ase_macb1_12v13 & ase_macb2_12v13 & (!ase_macb3_12v13)) ||
                    (ase_macb0_12v13 & ase_macb1_12v13 & (!ase_macb2_12v13) & ase_macb3_12v13) ||
                    (ase_macb0_12v13 & (!ase_macb1_12v13) & ase_macb2_12v13 & ase_macb3_12v13) ||
                    ((!ase_macb0_12v13) & ase_macb1_12v13 & ase_macb2_12v13 & ase_macb3_12v13);

  assign core08v13 =  ((!ase_macb0_12v13) & (!ase_macb1_12v13) & (ase_macb2_12v13) & (ase_macb3_12v13)) ||
                    ((!ase_macb0_12v13) & (ase_macb1_12v13) & (!ase_macb2_12v13) & (ase_macb3_12v13)) ||
                    ((!ase_macb0_12v13) & (ase_macb1_12v13) & (ase_macb2_12v13) & (!ase_macb3_12v13)) ||
                    ((ase_macb0_12v13) & (!ase_macb1_12v13) & (!ase_macb2_12v13) & (ase_macb3_12v13)) ||
                    ((ase_macb0_12v13) & (!ase_macb1_12v13) & (ase_macb2_12v13) & (!ase_macb3_12v13)) ||
                    ((ase_macb0_12v13) & (ase_macb1_12v13) & (!ase_macb2_12v13) & (!ase_macb3_12v13));

  assign core06v13 =  ((!ase_macb0_12v13) & (!ase_macb1_12v13) & (!ase_macb2_12v13) & (ase_macb3_12v13)) ||
                    ((!ase_macb0_12v13) & (!ase_macb1_12v13) & (ase_macb2_12v13) & (!ase_macb3_12v13)) ||
                    ((!ase_macb0_12v13) & (ase_macb1_12v13) & (!ase_macb2_12v13) & (!ase_macb3_12v13)) ||
                    ((ase_macb0_12v13) & (!ase_macb1_12v13) & (!ase_macb2_12v13) & (!ase_macb3_12v13)) ||
                    ((!ase_macb0_12v13) & (!ase_macb1_12v13) & (!ase_macb2_12v13) & (!ase_macb3_12v13)) ;



`ifdef LP_ABV_ON13
// psl13 default clock13 = (posedge pclk13);

// Cover13 a condition in which SMC13 is powered13 down
// and again13 powered13 up while UART13 is going13 into POWER13 down
// state or UART13 is already in POWER13 DOWN13 state
// psl13 cover_overlapping_smc_urt_113:
//    cover{fell13(pwr1_on_urt13);[*];fell13(pwr1_on_smc13);[*];
//    rose13(pwr1_on_smc13);[*];rose13(pwr1_on_urt13)};
//
// Cover13 a condition in which UART13 is powered13 down
// and again13 powered13 up while SMC13 is going13 into POWER13 down
// state or SMC13 is already in POWER13 DOWN13 state
// psl13 cover_overlapping_smc_urt_213:
//    cover{fell13(pwr1_on_smc13);[*];fell13(pwr1_on_urt13);[*];
//    rose13(pwr1_on_urt13);[*];rose13(pwr1_on_smc13)};
//


// Power13 Down13 UART13
// This13 gets13 triggered on rising13 edge of Gate13 signal13 for
// UART13 (gate_clk_urt13). In a next cycle after gate_clk_urt13,
// Isolate13 UART13(isolate_urt13) signal13 become13 HIGH13 (active).
// In 2nd cycle after gate_clk_urt13 becomes HIGH13, RESET13 for NON13
// SRPG13 FFs13(rstn_non_srpg_urt13) and POWER113 for UART13(pwr1_on_urt13) should 
// go13 LOW13. 
// This13 completes13 a POWER13 DOWN13. 

sequence s_power_down_urt13;
      (gate_clk_urt13 & !isolate_urt13 & rstn_non_srpg_urt13 & pwr1_on_urt13) 
  ##1 (gate_clk_urt13 & isolate_urt13 & rstn_non_srpg_urt13 & pwr1_on_urt13) 
  ##3 (gate_clk_urt13 & isolate_urt13 & !rstn_non_srpg_urt13 & !pwr1_on_urt13);
endsequence


property p_power_down_urt13;
   @(posedge pclk13)
    $rose(gate_clk_urt13) |=> s_power_down_urt13;
endproperty

output_power_down_urt13:
  assert property (p_power_down_urt13);


// Power13 UP13 UART13
// Sequence starts with , Rising13 edge of pwr1_on_urt13.
// Two13 clock13 cycle after this, isolate_urt13 should become13 LOW13 
// On13 the following13 clk13 gate_clk_urt13 should go13 low13.
// 5 cycles13 after  Rising13 edge of pwr1_on_urt13, rstn_non_srpg_urt13
// should become13 HIGH13
sequence s_power_up_urt13;
##30 (pwr1_on_urt13 & !isolate_urt13 & gate_clk_urt13 & !rstn_non_srpg_urt13) 
##1 (pwr1_on_urt13 & !isolate_urt13 & !gate_clk_urt13 & !rstn_non_srpg_urt13) 
##2 (pwr1_on_urt13 & !isolate_urt13 & !gate_clk_urt13 & rstn_non_srpg_urt13);
endsequence

property p_power_up_urt13;
   @(posedge pclk13)
  disable iff(!nprst13)
    (!pwr1_on_urt13 ##1 pwr1_on_urt13) |=> s_power_up_urt13;
endproperty

output_power_up_urt13:
  assert property (p_power_up_urt13);


// Power13 Down13 SMC13
// This13 gets13 triggered on rising13 edge of Gate13 signal13 for
// SMC13 (gate_clk_smc13). In a next cycle after gate_clk_smc13,
// Isolate13 SMC13(isolate_smc13) signal13 become13 HIGH13 (active).
// In 2nd cycle after gate_clk_smc13 becomes HIGH13, RESET13 for NON13
// SRPG13 FFs13(rstn_non_srpg_smc13) and POWER113 for SMC13(pwr1_on_smc13) should 
// go13 LOW13. 
// This13 completes13 a POWER13 DOWN13. 

sequence s_power_down_smc13;
      (gate_clk_smc13 & !isolate_smc13 & rstn_non_srpg_smc13 & pwr1_on_smc13) 
  ##1 (gate_clk_smc13 & isolate_smc13 & rstn_non_srpg_smc13 & pwr1_on_smc13) 
  ##3 (gate_clk_smc13 & isolate_smc13 & !rstn_non_srpg_smc13 & !pwr1_on_smc13);
endsequence


property p_power_down_smc13;
   @(posedge pclk13)
    $rose(gate_clk_smc13) |=> s_power_down_smc13;
endproperty

output_power_down_smc13:
  assert property (p_power_down_smc13);


// Power13 UP13 SMC13
// Sequence starts with , Rising13 edge of pwr1_on_smc13.
// Two13 clock13 cycle after this, isolate_smc13 should become13 LOW13 
// On13 the following13 clk13 gate_clk_smc13 should go13 low13.
// 5 cycles13 after  Rising13 edge of pwr1_on_smc13, rstn_non_srpg_smc13
// should become13 HIGH13
sequence s_power_up_smc13;
##30 (pwr1_on_smc13 & !isolate_smc13 & gate_clk_smc13 & !rstn_non_srpg_smc13) 
##1 (pwr1_on_smc13 & !isolate_smc13 & !gate_clk_smc13 & !rstn_non_srpg_smc13) 
##2 (pwr1_on_smc13 & !isolate_smc13 & !gate_clk_smc13 & rstn_non_srpg_smc13);
endsequence

property p_power_up_smc13;
   @(posedge pclk13)
  disable iff(!nprst13)
    (!pwr1_on_smc13 ##1 pwr1_on_smc13) |=> s_power_up_smc13;
endproperty

output_power_up_smc13:
  assert property (p_power_up_smc13);


// COVER13 SMC13 POWER13 DOWN13 AND13 UP13
cover_power_down_up_smc13: cover property (@(posedge pclk13)
(s_power_down_smc13 ##[5:180] s_power_up_smc13));



// COVER13 UART13 POWER13 DOWN13 AND13 UP13
cover_power_down_up_urt13: cover property (@(posedge pclk13)
(s_power_down_urt13 ##[5:180] s_power_up_urt13));

cover_power_down_urt13: cover property (@(posedge pclk13)
(s_power_down_urt13));

cover_power_up_urt13: cover property (@(posedge pclk13)
(s_power_up_urt13));




`ifdef PCM_ABV_ON13
//------------------------------------------------------------------------------
// Power13 Controller13 Formal13 Verification13 component.  Each power13 domain has a 
// separate13 instantiation13
//------------------------------------------------------------------------------

// need to assume that CPU13 will leave13 a minimum time between powering13 down and 
// back up.  In this example13, 10clks has been selected.
// psl13 config_min_uart_pd_time13 : assume always {rose13(L1_ctrl_domain13[1])} |-> { L1_ctrl_domain13[1][*10] } abort13(~nprst13);
// psl13 config_min_uart_pu_time13 : assume always {fell13(L1_ctrl_domain13[1])} |-> { !L1_ctrl_domain13[1][*10] } abort13(~nprst13);
// psl13 config_min_smc_pd_time13 : assume always {rose13(L1_ctrl_domain13[2])} |-> { L1_ctrl_domain13[2][*10] } abort13(~nprst13);
// psl13 config_min_smc_pu_time13 : assume always {fell13(L1_ctrl_domain13[2])} |-> { !L1_ctrl_domain13[2][*10] } abort13(~nprst13);

// UART13 VCOMP13 parameters13
   defparam i_uart_vcomp_domain13.ENABLE_SAVE_RESTORE_EDGE13   = 1;
   defparam i_uart_vcomp_domain13.ENABLE_EXT_PWR_CNTRL13       = 1;
   defparam i_uart_vcomp_domain13.REF_CLK_DEFINED13            = 0;
   defparam i_uart_vcomp_domain13.MIN_SHUTOFF_CYCLES13         = 4;
   defparam i_uart_vcomp_domain13.MIN_RESTORE_TO_ISO_CYCLES13  = 0;
   defparam i_uart_vcomp_domain13.MIN_SAVE_TO_SHUTOFF_CYCLES13 = 1;


   vcomp_domain13 i_uart_vcomp_domain13
   ( .ref_clk13(pclk13),
     .start_lps13(L1_ctrl_domain13[1] || !rstn_non_srpg_urt13),
     .rst_n13(nprst13),
     .ext_power_down13(L1_ctrl_domain13[1]),
     .iso_en13(isolate_urt13),
     .save_edge13(save_edge_urt13),
     .restore_edge13(restore_edge_urt13),
     .domain_shut_off13(pwr1_off_urt13),
     .domain_clk13(!gate_clk_urt13 && pclk13)
   );


// SMC13 VCOMP13 parameters13
   defparam i_smc_vcomp_domain13.ENABLE_SAVE_RESTORE_EDGE13   = 1;
   defparam i_smc_vcomp_domain13.ENABLE_EXT_PWR_CNTRL13       = 1;
   defparam i_smc_vcomp_domain13.REF_CLK_DEFINED13            = 0;
   defparam i_smc_vcomp_domain13.MIN_SHUTOFF_CYCLES13         = 4;
   defparam i_smc_vcomp_domain13.MIN_RESTORE_TO_ISO_CYCLES13  = 0;
   defparam i_smc_vcomp_domain13.MIN_SAVE_TO_SHUTOFF_CYCLES13 = 1;


   vcomp_domain13 i_smc_vcomp_domain13
   ( .ref_clk13(pclk13),
     .start_lps13(L1_ctrl_domain13[2] || !rstn_non_srpg_smc13),
     .rst_n13(nprst13),
     .ext_power_down13(L1_ctrl_domain13[2]),
     .iso_en13(isolate_smc13),
     .save_edge13(save_edge_smc13),
     .restore_edge13(restore_edge_smc13),
     .domain_shut_off13(pwr1_off_smc13),
     .domain_clk13(!gate_clk_smc13 && pclk13)
   );

`endif

`endif



endmodule
