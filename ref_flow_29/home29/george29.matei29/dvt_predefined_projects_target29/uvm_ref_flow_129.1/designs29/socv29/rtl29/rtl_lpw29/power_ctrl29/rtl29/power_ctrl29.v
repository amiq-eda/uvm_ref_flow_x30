//File29 name   : power_ctrl29.v
//Title29       : Power29 Control29 Module29
//Created29     : 1999
//Description29 : Top29 level of power29 controller29
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

module power_ctrl29 (


    // Clocks29 & Reset29
    pclk29,
    nprst29,
    // APB29 programming29 interface
    paddr29,
    psel29,
    penable29,
    pwrite29,
    pwdata29,
    prdata29,
    // mac29 i/f,
    macb3_wakeup29,
    macb2_wakeup29,
    macb1_wakeup29,
    macb0_wakeup29,
    // Scan29 
    scan_in29,
    scan_en29,
    scan_mode29,
    scan_out29,
    // Module29 control29 outputs29
    int_source_h29,
    // SMC29
    rstn_non_srpg_smc29,
    gate_clk_smc29,
    isolate_smc29,
    save_edge_smc29,
    restore_edge_smc29,
    pwr1_on_smc29,
    pwr2_on_smc29,
    pwr1_off_smc29,
    pwr2_off_smc29,
    // URT29
    rstn_non_srpg_urt29,
    gate_clk_urt29,
    isolate_urt29,
    save_edge_urt29,
    restore_edge_urt29,
    pwr1_on_urt29,
    pwr2_on_urt29,
    pwr1_off_urt29,      
    pwr2_off_urt29,
    // ETH029
    rstn_non_srpg_macb029,
    gate_clk_macb029,
    isolate_macb029,
    save_edge_macb029,
    restore_edge_macb029,
    pwr1_on_macb029,
    pwr2_on_macb029,
    pwr1_off_macb029,      
    pwr2_off_macb029,
    // ETH129
    rstn_non_srpg_macb129,
    gate_clk_macb129,
    isolate_macb129,
    save_edge_macb129,
    restore_edge_macb129,
    pwr1_on_macb129,
    pwr2_on_macb129,
    pwr1_off_macb129,      
    pwr2_off_macb129,
    // ETH229
    rstn_non_srpg_macb229,
    gate_clk_macb229,
    isolate_macb229,
    save_edge_macb229,
    restore_edge_macb229,
    pwr1_on_macb229,
    pwr2_on_macb229,
    pwr1_off_macb229,      
    pwr2_off_macb229,
    // ETH329
    rstn_non_srpg_macb329,
    gate_clk_macb329,
    isolate_macb329,
    save_edge_macb329,
    restore_edge_macb329,
    pwr1_on_macb329,
    pwr2_on_macb329,
    pwr1_off_macb329,      
    pwr2_off_macb329,
    // DMA29
    rstn_non_srpg_dma29,
    gate_clk_dma29,
    isolate_dma29,
    save_edge_dma29,
    restore_edge_dma29,
    pwr1_on_dma29,
    pwr2_on_dma29,
    pwr1_off_dma29,      
    pwr2_off_dma29,
    // CPU29
    rstn_non_srpg_cpu29,
    gate_clk_cpu29,
    isolate_cpu29,
    save_edge_cpu29,
    restore_edge_cpu29,
    pwr1_on_cpu29,
    pwr2_on_cpu29,
    pwr1_off_cpu29,      
    pwr2_off_cpu29,
    // ALUT29
    rstn_non_srpg_alut29,
    gate_clk_alut29,
    isolate_alut29,
    save_edge_alut29,
    restore_edge_alut29,
    pwr1_on_alut29,
    pwr2_on_alut29,
    pwr1_off_alut29,      
    pwr2_off_alut29,
    // MEM29
    rstn_non_srpg_mem29,
    gate_clk_mem29,
    isolate_mem29,
    save_edge_mem29,
    restore_edge_mem29,
    pwr1_on_mem29,
    pwr2_on_mem29,
    pwr1_off_mem29,      
    pwr2_off_mem29,
    // core29 dvfs29 transitions29
    core06v29,
    core08v29,
    core10v29,
    core12v29,
    pcm_macb_wakeup_int29,
    // mte29 signals29
    mte_smc_start29,
    mte_uart_start29,
    mte_smc_uart_start29,  
    mte_pm_smc_to_default_start29, 
    mte_pm_uart_to_default_start29,
    mte_pm_smc_uart_to_default_start29

  );

  parameter STATE_IDLE_12V29 = 4'b0001;
  parameter STATE_06V29 = 4'b0010;
  parameter STATE_08V29 = 4'b0100;
  parameter STATE_10V29 = 4'b1000;

    // Clocks29 & Reset29
    input pclk29;
    input nprst29;
    // APB29 programming29 interface
    input [31:0] paddr29;
    input psel29  ;
    input penable29;
    input pwrite29 ;
    input [31:0] pwdata29;
    output [31:0] prdata29;
    // mac29
    input macb3_wakeup29;
    input macb2_wakeup29;
    input macb1_wakeup29;
    input macb0_wakeup29;
    // Scan29 
    input scan_in29;
    input scan_en29;
    input scan_mode29;
    output scan_out29;
    // Module29 control29 outputs29
    input int_source_h29;
    // SMC29
    output rstn_non_srpg_smc29 ;
    output gate_clk_smc29   ;
    output isolate_smc29   ;
    output save_edge_smc29   ;
    output restore_edge_smc29   ;
    output pwr1_on_smc29   ;
    output pwr2_on_smc29   ;
    output pwr1_off_smc29  ;
    output pwr2_off_smc29  ;
    // URT29
    output rstn_non_srpg_urt29 ;
    output gate_clk_urt29      ;
    output isolate_urt29       ;
    output save_edge_urt29   ;
    output restore_edge_urt29   ;
    output pwr1_on_urt29       ;
    output pwr2_on_urt29       ;
    output pwr1_off_urt29      ;
    output pwr2_off_urt29      ;
    // ETH029
    output rstn_non_srpg_macb029 ;
    output gate_clk_macb029      ;
    output isolate_macb029       ;
    output save_edge_macb029   ;
    output restore_edge_macb029   ;
    output pwr1_on_macb029       ;
    output pwr2_on_macb029       ;
    output pwr1_off_macb029      ;
    output pwr2_off_macb029      ;
    // ETH129
    output rstn_non_srpg_macb129 ;
    output gate_clk_macb129      ;
    output isolate_macb129       ;
    output save_edge_macb129   ;
    output restore_edge_macb129   ;
    output pwr1_on_macb129       ;
    output pwr2_on_macb129       ;
    output pwr1_off_macb129      ;
    output pwr2_off_macb129      ;
    // ETH229
    output rstn_non_srpg_macb229 ;
    output gate_clk_macb229      ;
    output isolate_macb229       ;
    output save_edge_macb229   ;
    output restore_edge_macb229   ;
    output pwr1_on_macb229       ;
    output pwr2_on_macb229       ;
    output pwr1_off_macb229      ;
    output pwr2_off_macb229      ;
    // ETH329
    output rstn_non_srpg_macb329 ;
    output gate_clk_macb329      ;
    output isolate_macb329       ;
    output save_edge_macb329   ;
    output restore_edge_macb329   ;
    output pwr1_on_macb329       ;
    output pwr2_on_macb329       ;
    output pwr1_off_macb329      ;
    output pwr2_off_macb329      ;
    // DMA29
    output rstn_non_srpg_dma29 ;
    output gate_clk_dma29      ;
    output isolate_dma29       ;
    output save_edge_dma29   ;
    output restore_edge_dma29   ;
    output pwr1_on_dma29       ;
    output pwr2_on_dma29       ;
    output pwr1_off_dma29      ;
    output pwr2_off_dma29      ;
    // CPU29
    output rstn_non_srpg_cpu29 ;
    output gate_clk_cpu29      ;
    output isolate_cpu29       ;
    output save_edge_cpu29   ;
    output restore_edge_cpu29   ;
    output pwr1_on_cpu29       ;
    output pwr2_on_cpu29       ;
    output pwr1_off_cpu29      ;
    output pwr2_off_cpu29      ;
    // ALUT29
    output rstn_non_srpg_alut29 ;
    output gate_clk_alut29      ;
    output isolate_alut29       ;
    output save_edge_alut29   ;
    output restore_edge_alut29   ;
    output pwr1_on_alut29       ;
    output pwr2_on_alut29       ;
    output pwr1_off_alut29      ;
    output pwr2_off_alut29      ;
    // MEM29
    output rstn_non_srpg_mem29 ;
    output gate_clk_mem29      ;
    output isolate_mem29       ;
    output save_edge_mem29   ;
    output restore_edge_mem29   ;
    output pwr1_on_mem29       ;
    output pwr2_on_mem29       ;
    output pwr1_off_mem29      ;
    output pwr2_off_mem29      ;


   // core29 transitions29 o/p
    output core06v29;
    output core08v29;
    output core10v29;
    output core12v29;
    output pcm_macb_wakeup_int29 ;
    //mode mte29  signals29
    output mte_smc_start29;
    output mte_uart_start29;
    output mte_smc_uart_start29;  
    output mte_pm_smc_to_default_start29; 
    output mte_pm_uart_to_default_start29;
    output mte_pm_smc_uart_to_default_start29;

    reg mte_smc_start29;
    reg mte_uart_start29;
    reg mte_smc_uart_start29;  
    reg mte_pm_smc_to_default_start29; 
    reg mte_pm_uart_to_default_start29;
    reg mte_pm_smc_uart_to_default_start29;

    reg [31:0] prdata29;

  wire valid_reg_write29  ;
  wire valid_reg_read29   ;
  wire L1_ctrl_access29   ;
  wire L1_status_access29 ;
  wire pcm_int_mask_access29;
  wire pcm_int_status_access29;
  wire standby_mem029      ;
  wire standby_mem129      ;
  wire standby_mem229      ;
  wire standby_mem329      ;
  wire pwr1_off_mem029;
  wire pwr1_off_mem129;
  wire pwr1_off_mem229;
  wire pwr1_off_mem329;
  
  // Control29 signals29
  wire set_status_smc29   ;
  wire clr_status_smc29   ;
  wire set_status_urt29   ;
  wire clr_status_urt29   ;
  wire set_status_macb029   ;
  wire clr_status_macb029   ;
  wire set_status_macb129   ;
  wire clr_status_macb129   ;
  wire set_status_macb229   ;
  wire clr_status_macb229   ;
  wire set_status_macb329   ;
  wire clr_status_macb329   ;
  wire set_status_dma29   ;
  wire clr_status_dma29   ;
  wire set_status_cpu29   ;
  wire clr_status_cpu29   ;
  wire set_status_alut29   ;
  wire clr_status_alut29   ;
  wire set_status_mem29   ;
  wire clr_status_mem29   ;


  // Status and Control29 registers
  reg [31:0]  L1_status_reg29;
  reg  [31:0] L1_ctrl_reg29  ;
  reg  [31:0] L1_ctrl_domain29  ;
  reg L1_ctrl_cpu_off_reg29;
  reg [31:0]  pcm_mask_reg29;
  reg [31:0]  pcm_status_reg29;

  // Signals29 gated29 in scan_mode29
  //SMC29
  wire  rstn_non_srpg_smc_int29;
  wire  gate_clk_smc_int29    ;     
  wire  isolate_smc_int29    ;       
  wire save_edge_smc_int29;
  wire restore_edge_smc_int29;
  wire  pwr1_on_smc_int29    ;      
  wire  pwr2_on_smc_int29    ;      


  //URT29
  wire   rstn_non_srpg_urt_int29;
  wire   gate_clk_urt_int29     ;     
  wire   isolate_urt_int29      ;       
  wire save_edge_urt_int29;
  wire restore_edge_urt_int29;
  wire   pwr1_on_urt_int29      ;      
  wire   pwr2_on_urt_int29      ;      

  // ETH029
  wire   rstn_non_srpg_macb0_int29;
  wire   gate_clk_macb0_int29     ;     
  wire   isolate_macb0_int29      ;       
  wire save_edge_macb0_int29;
  wire restore_edge_macb0_int29;
  wire   pwr1_on_macb0_int29      ;      
  wire   pwr2_on_macb0_int29      ;      
  // ETH129
  wire   rstn_non_srpg_macb1_int29;
  wire   gate_clk_macb1_int29     ;     
  wire   isolate_macb1_int29      ;       
  wire save_edge_macb1_int29;
  wire restore_edge_macb1_int29;
  wire   pwr1_on_macb1_int29      ;      
  wire   pwr2_on_macb1_int29      ;      
  // ETH229
  wire   rstn_non_srpg_macb2_int29;
  wire   gate_clk_macb2_int29     ;     
  wire   isolate_macb2_int29      ;       
  wire save_edge_macb2_int29;
  wire restore_edge_macb2_int29;
  wire   pwr1_on_macb2_int29      ;      
  wire   pwr2_on_macb2_int29      ;      
  // ETH329
  wire   rstn_non_srpg_macb3_int29;
  wire   gate_clk_macb3_int29     ;     
  wire   isolate_macb3_int29      ;       
  wire save_edge_macb3_int29;
  wire restore_edge_macb3_int29;
  wire   pwr1_on_macb3_int29      ;      
  wire   pwr2_on_macb3_int29      ;      

  // DMA29
  wire   rstn_non_srpg_dma_int29;
  wire   gate_clk_dma_int29     ;     
  wire   isolate_dma_int29      ;       
  wire save_edge_dma_int29;
  wire restore_edge_dma_int29;
  wire   pwr1_on_dma_int29      ;      
  wire   pwr2_on_dma_int29      ;      

  // CPU29
  wire   rstn_non_srpg_cpu_int29;
  wire   gate_clk_cpu_int29     ;     
  wire   isolate_cpu_int29      ;       
  wire save_edge_cpu_int29;
  wire restore_edge_cpu_int29;
  wire   pwr1_on_cpu_int29      ;      
  wire   pwr2_on_cpu_int29      ;  
  wire L1_ctrl_cpu_off_p29;    

  reg save_alut_tmp29;
  // DFS29 sm29

  reg cpu_shutoff_ctrl29;

  reg mte_mac_off_start29, mte_mac012_start29, mte_mac013_start29, mte_mac023_start29, mte_mac123_start29;
  reg mte_mac01_start29, mte_mac02_start29, mte_mac03_start29, mte_mac12_start29, mte_mac13_start29, mte_mac23_start29;
  reg mte_mac0_start29, mte_mac1_start29, mte_mac2_start29, mte_mac3_start29;
  reg mte_sys_hibernate29 ;
  reg mte_dma_start29 ;
  reg mte_cpu_start29 ;
  reg mte_mac_off_sleep_start29, mte_mac012_sleep_start29, mte_mac013_sleep_start29, mte_mac023_sleep_start29, mte_mac123_sleep_start29;
  reg mte_mac01_sleep_start29, mte_mac02_sleep_start29, mte_mac03_sleep_start29, mte_mac12_sleep_start29, mte_mac13_sleep_start29, mte_mac23_sleep_start29;
  reg mte_mac0_sleep_start29, mte_mac1_sleep_start29, mte_mac2_sleep_start29, mte_mac3_sleep_start29;
  reg mte_dma_sleep_start29;
  reg mte_mac_off_to_default29, mte_mac012_to_default29, mte_mac013_to_default29, mte_mac023_to_default29, mte_mac123_to_default29;
  reg mte_mac01_to_default29, mte_mac02_to_default29, mte_mac03_to_default29, mte_mac12_to_default29, mte_mac13_to_default29, mte_mac23_to_default29;
  reg mte_mac0_to_default29, mte_mac1_to_default29, mte_mac2_to_default29, mte_mac3_to_default29;
  reg mte_dma_isolate_dis29;
  reg mte_cpu_isolate_dis29;
  reg mte_sys_hibernate_to_default29;


  // Latch29 the CPU29 SLEEP29 invocation29
  always @( posedge pclk29 or negedge nprst29) 
  begin
    if(!nprst29)
      L1_ctrl_cpu_off_reg29 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg29 <= L1_ctrl_domain29[8];
  end

  // Create29 a pulse29 for sleep29 detection29 
  assign L1_ctrl_cpu_off_p29 =  L1_ctrl_domain29[8] && !L1_ctrl_cpu_off_reg29;
  
  // CPU29 sleep29 contol29 logic 
  // Shut29 off29 CPU29 when L1_ctrl_cpu_off_p29 is set
  // wake29 cpu29 when any interrupt29 is seen29  
  always @( posedge pclk29 or negedge nprst29) 
  begin
    if(!nprst29)
     cpu_shutoff_ctrl29 <= 1'b0;
    else if(cpu_shutoff_ctrl29 && int_source_h29)
     cpu_shutoff_ctrl29 <= 1'b0;
    else if (L1_ctrl_cpu_off_p29)
     cpu_shutoff_ctrl29 <= 1'b1;
  end
 
  // instantiate29 power29 contol29  block for uart29
  power_ctrl_sm29 i_urt_power_ctrl_sm29(
    .pclk29(pclk29),
    .nprst29(nprst29),
    .L1_module_req29(L1_ctrl_domain29[1]),
    .set_status_module29(set_status_urt29),
    .clr_status_module29(clr_status_urt29),
    .rstn_non_srpg_module29(rstn_non_srpg_urt_int29),
    .gate_clk_module29(gate_clk_urt_int29),
    .isolate_module29(isolate_urt_int29),
    .save_edge29(save_edge_urt_int29),
    .restore_edge29(restore_edge_urt_int29),
    .pwr1_on29(pwr1_on_urt_int29),
    .pwr2_on29(pwr2_on_urt_int29)
    );
  

  // instantiate29 power29 contol29  block for smc29
  power_ctrl_sm29 i_smc_power_ctrl_sm29(
    .pclk29(pclk29),
    .nprst29(nprst29),
    .L1_module_req29(L1_ctrl_domain29[2]),
    .set_status_module29(set_status_smc29),
    .clr_status_module29(clr_status_smc29),
    .rstn_non_srpg_module29(rstn_non_srpg_smc_int29),
    .gate_clk_module29(gate_clk_smc_int29),
    .isolate_module29(isolate_smc_int29),
    .save_edge29(save_edge_smc_int29),
    .restore_edge29(restore_edge_smc_int29),
    .pwr1_on29(pwr1_on_smc_int29),
    .pwr2_on29(pwr2_on_smc_int29)
    );

  // power29 control29 for macb029
  power_ctrl_sm29 i_macb0_power_ctrl_sm29(
    .pclk29(pclk29),
    .nprst29(nprst29),
    .L1_module_req29(L1_ctrl_domain29[3]),
    .set_status_module29(set_status_macb029),
    .clr_status_module29(clr_status_macb029),
    .rstn_non_srpg_module29(rstn_non_srpg_macb0_int29),
    .gate_clk_module29(gate_clk_macb0_int29),
    .isolate_module29(isolate_macb0_int29),
    .save_edge29(save_edge_macb0_int29),
    .restore_edge29(restore_edge_macb0_int29),
    .pwr1_on29(pwr1_on_macb0_int29),
    .pwr2_on29(pwr2_on_macb0_int29)
    );
  // power29 control29 for macb129
  power_ctrl_sm29 i_macb1_power_ctrl_sm29(
    .pclk29(pclk29),
    .nprst29(nprst29),
    .L1_module_req29(L1_ctrl_domain29[4]),
    .set_status_module29(set_status_macb129),
    .clr_status_module29(clr_status_macb129),
    .rstn_non_srpg_module29(rstn_non_srpg_macb1_int29),
    .gate_clk_module29(gate_clk_macb1_int29),
    .isolate_module29(isolate_macb1_int29),
    .save_edge29(save_edge_macb1_int29),
    .restore_edge29(restore_edge_macb1_int29),
    .pwr1_on29(pwr1_on_macb1_int29),
    .pwr2_on29(pwr2_on_macb1_int29)
    );
  // power29 control29 for macb229
  power_ctrl_sm29 i_macb2_power_ctrl_sm29(
    .pclk29(pclk29),
    .nprst29(nprst29),
    .L1_module_req29(L1_ctrl_domain29[5]),
    .set_status_module29(set_status_macb229),
    .clr_status_module29(clr_status_macb229),
    .rstn_non_srpg_module29(rstn_non_srpg_macb2_int29),
    .gate_clk_module29(gate_clk_macb2_int29),
    .isolate_module29(isolate_macb2_int29),
    .save_edge29(save_edge_macb2_int29),
    .restore_edge29(restore_edge_macb2_int29),
    .pwr1_on29(pwr1_on_macb2_int29),
    .pwr2_on29(pwr2_on_macb2_int29)
    );
  // power29 control29 for macb329
  power_ctrl_sm29 i_macb3_power_ctrl_sm29(
    .pclk29(pclk29),
    .nprst29(nprst29),
    .L1_module_req29(L1_ctrl_domain29[6]),
    .set_status_module29(set_status_macb329),
    .clr_status_module29(clr_status_macb329),
    .rstn_non_srpg_module29(rstn_non_srpg_macb3_int29),
    .gate_clk_module29(gate_clk_macb3_int29),
    .isolate_module29(isolate_macb3_int29),
    .save_edge29(save_edge_macb3_int29),
    .restore_edge29(restore_edge_macb3_int29),
    .pwr1_on29(pwr1_on_macb3_int29),
    .pwr2_on29(pwr2_on_macb3_int29)
    );
  // power29 control29 for dma29
  power_ctrl_sm29 i_dma_power_ctrl_sm29(
    .pclk29(pclk29),
    .nprst29(nprst29),
    .L1_module_req29(L1_ctrl_domain29[7]),
    .set_status_module29(set_status_dma29),
    .clr_status_module29(clr_status_dma29),
    .rstn_non_srpg_module29(rstn_non_srpg_dma_int29),
    .gate_clk_module29(gate_clk_dma_int29),
    .isolate_module29(isolate_dma_int29),
    .save_edge29(save_edge_dma_int29),
    .restore_edge29(restore_edge_dma_int29),
    .pwr1_on29(pwr1_on_dma_int29),
    .pwr2_on29(pwr2_on_dma_int29)
    );
  // power29 control29 for CPU29
  power_ctrl_sm29 i_cpu_power_ctrl_sm29(
    .pclk29(pclk29),
    .nprst29(nprst29),
    .L1_module_req29(cpu_shutoff_ctrl29),
    .set_status_module29(set_status_cpu29),
    .clr_status_module29(clr_status_cpu29),
    .rstn_non_srpg_module29(rstn_non_srpg_cpu_int29),
    .gate_clk_module29(gate_clk_cpu_int29),
    .isolate_module29(isolate_cpu_int29),
    .save_edge29(save_edge_cpu_int29),
    .restore_edge29(restore_edge_cpu_int29),
    .pwr1_on29(pwr1_on_cpu_int29),
    .pwr2_on29(pwr2_on_cpu_int29)
    );

  assign valid_reg_write29 =  (psel29 && pwrite29 && penable29);
  assign valid_reg_read29  =  (psel29 && (!pwrite29) && penable29);

  assign L1_ctrl_access29  =  (paddr29[15:0] == 16'b0000000000000100); 
  assign L1_status_access29 = (paddr29[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access29 =   (paddr29[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access29 = (paddr29[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control29 and status register
  always @(*)
  begin  
    if(valid_reg_read29 && L1_ctrl_access29) 
      prdata29 = L1_ctrl_reg29;
    else if (valid_reg_read29 && L1_status_access29)
      prdata29 = L1_status_reg29;
    else if (valid_reg_read29 && pcm_int_mask_access29)
      prdata29 = pcm_mask_reg29;
    else if (valid_reg_read29 && pcm_int_status_access29)
      prdata29 = pcm_status_reg29;
    else 
      prdata29 = 0;
  end

  assign set_status_mem29 =  (set_status_macb029 && set_status_macb129 && set_status_macb229 &&
                            set_status_macb329 && set_status_dma29 && set_status_cpu29);

  assign clr_status_mem29 =  (clr_status_macb029 && clr_status_macb129 && clr_status_macb229 &&
                            clr_status_macb329 && clr_status_dma29 && clr_status_cpu29);

  assign set_status_alut29 = (set_status_macb029 && set_status_macb129 && set_status_macb229 && set_status_macb329);

  assign clr_status_alut29 = (clr_status_macb029 || clr_status_macb129 || clr_status_macb229  || clr_status_macb329);

  // Write accesses to the control29 and status register
 
  always @(posedge pclk29 or negedge nprst29)
  begin
    if (!nprst29) begin
      L1_ctrl_reg29   <= 0;
      L1_status_reg29 <= 0;
      pcm_mask_reg29 <= 0;
    end else begin
      // CTRL29 reg updates29
      if (valid_reg_write29 && L1_ctrl_access29) 
        L1_ctrl_reg29 <= pwdata29; // Writes29 to the ctrl29 reg
      if (valid_reg_write29 && pcm_int_mask_access29) 
        pcm_mask_reg29 <= pwdata29; // Writes29 to the ctrl29 reg

      if (set_status_urt29 == 1'b1)  
        L1_status_reg29[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt29 == 1'b1) 
        L1_status_reg29[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc29 == 1'b1) 
        L1_status_reg29[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc29 == 1'b1) 
        L1_status_reg29[2] <= 1'b0; // Clear the status bit

      if (set_status_macb029 == 1'b1)  
        L1_status_reg29[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb029 == 1'b1) 
        L1_status_reg29[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb129 == 1'b1)  
        L1_status_reg29[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb129 == 1'b1) 
        L1_status_reg29[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb229 == 1'b1)  
        L1_status_reg29[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb229 == 1'b1) 
        L1_status_reg29[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb329 == 1'b1)  
        L1_status_reg29[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb329 == 1'b1) 
        L1_status_reg29[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma29 == 1'b1)  
        L1_status_reg29[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma29 == 1'b1) 
        L1_status_reg29[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu29 == 1'b1)  
        L1_status_reg29[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu29 == 1'b1) 
        L1_status_reg29[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut29 == 1'b1)  
        L1_status_reg29[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut29 == 1'b1) 
        L1_status_reg29[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem29 == 1'b1)  
        L1_status_reg29[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem29 == 1'b1) 
        L1_status_reg29[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused29 bits of pcm_status_reg29 are tied29 to 0
  always @(posedge pclk29 or negedge nprst29)
  begin
    if (!nprst29)
      pcm_status_reg29[31:4] <= 'b0;
    else  
      pcm_status_reg29[31:4] <= pcm_status_reg29[31:4];
  end
  
  // interrupt29 only of h/w assisted29 wakeup
  // MAC29 3
  always @(posedge pclk29 or negedge nprst29)
  begin
    if(!nprst29)
      pcm_status_reg29[3] <= 1'b0;
    else if (valid_reg_write29 && pcm_int_status_access29) 
      pcm_status_reg29[3] <= pwdata29[3];
    else if (macb3_wakeup29 & ~pcm_mask_reg29[3])
      pcm_status_reg29[3] <= 1'b1;
    else if (valid_reg_read29 && pcm_int_status_access29) 
      pcm_status_reg29[3] <= 1'b0;
    else
      pcm_status_reg29[3] <= pcm_status_reg29[3];
  end  
   
  // MAC29 2
  always @(posedge pclk29 or negedge nprst29)
  begin
    if(!nprst29)
      pcm_status_reg29[2] <= 1'b0;
    else if (valid_reg_write29 && pcm_int_status_access29) 
      pcm_status_reg29[2] <= pwdata29[2];
    else if (macb2_wakeup29 & ~pcm_mask_reg29[2])
      pcm_status_reg29[2] <= 1'b1;
    else if (valid_reg_read29 && pcm_int_status_access29) 
      pcm_status_reg29[2] <= 1'b0;
    else
      pcm_status_reg29[2] <= pcm_status_reg29[2];
  end  

  // MAC29 1
  always @(posedge pclk29 or negedge nprst29)
  begin
    if(!nprst29)
      pcm_status_reg29[1] <= 1'b0;
    else if (valid_reg_write29 && pcm_int_status_access29) 
      pcm_status_reg29[1] <= pwdata29[1];
    else if (macb1_wakeup29 & ~pcm_mask_reg29[1])
      pcm_status_reg29[1] <= 1'b1;
    else if (valid_reg_read29 && pcm_int_status_access29) 
      pcm_status_reg29[1] <= 1'b0;
    else
      pcm_status_reg29[1] <= pcm_status_reg29[1];
  end  
   
  // MAC29 0
  always @(posedge pclk29 or negedge nprst29)
  begin
    if(!nprst29)
      pcm_status_reg29[0] <= 1'b0;
    else if (valid_reg_write29 && pcm_int_status_access29) 
      pcm_status_reg29[0] <= pwdata29[0];
    else if (macb0_wakeup29 & ~pcm_mask_reg29[0])
      pcm_status_reg29[0] <= 1'b1;
    else if (valid_reg_read29 && pcm_int_status_access29) 
      pcm_status_reg29[0] <= 1'b0;
    else
      pcm_status_reg29[0] <= pcm_status_reg29[0];
  end  

  assign pcm_macb_wakeup_int29 = |pcm_status_reg29;

  reg [31:0] L1_ctrl_reg129;
  always @(posedge pclk29 or negedge nprst29)
  begin
    if(!nprst29)
      L1_ctrl_reg129 <= 0;
    else
      L1_ctrl_reg129 <= L1_ctrl_reg29;
  end

  // Program29 mode decode
  always @(L1_ctrl_reg29 or L1_ctrl_reg129 or int_source_h29 or cpu_shutoff_ctrl29) begin
    mte_smc_start29 = 0;
    mte_uart_start29 = 0;
    mte_smc_uart_start29  = 0;
    mte_mac_off_start29  = 0;
    mte_mac012_start29 = 0;
    mte_mac013_start29 = 0;
    mte_mac023_start29 = 0;
    mte_mac123_start29 = 0;
    mte_mac01_start29 = 0;
    mte_mac02_start29 = 0;
    mte_mac03_start29 = 0;
    mte_mac12_start29 = 0;
    mte_mac13_start29 = 0;
    mte_mac23_start29 = 0;
    mte_mac0_start29 = 0;
    mte_mac1_start29 = 0;
    mte_mac2_start29 = 0;
    mte_mac3_start29 = 0;
    mte_sys_hibernate29 = 0 ;
    mte_dma_start29 = 0 ;
    mte_cpu_start29 = 0 ;

    mte_mac0_sleep_start29 = (L1_ctrl_reg29 ==  'h14) && (L1_ctrl_reg129 == 'h4 );
    mte_mac1_sleep_start29 = (L1_ctrl_reg29 ==  'h14) && (L1_ctrl_reg129 == 'h5 ); 
    mte_mac2_sleep_start29 = (L1_ctrl_reg29 ==  'h14) && (L1_ctrl_reg129 == 'h6 ); 
    mte_mac3_sleep_start29 = (L1_ctrl_reg29 ==  'h14) && (L1_ctrl_reg129 == 'h7 ); 
    mte_mac01_sleep_start29 = (L1_ctrl_reg29 ==  'h14) && (L1_ctrl_reg129 == 'h8 ); 
    mte_mac02_sleep_start29 = (L1_ctrl_reg29 ==  'h14) && (L1_ctrl_reg129 == 'h9 ); 
    mte_mac03_sleep_start29 = (L1_ctrl_reg29 ==  'h14) && (L1_ctrl_reg129 == 'hA ); 
    mte_mac12_sleep_start29 = (L1_ctrl_reg29 ==  'h14) && (L1_ctrl_reg129 == 'hB ); 
    mte_mac13_sleep_start29 = (L1_ctrl_reg29 ==  'h14) && (L1_ctrl_reg129 == 'hC ); 
    mte_mac23_sleep_start29 = (L1_ctrl_reg29 ==  'h14) && (L1_ctrl_reg129 == 'hD ); 
    mte_mac012_sleep_start29 = (L1_ctrl_reg29 ==  'h14) && (L1_ctrl_reg129 == 'hE ); 
    mte_mac013_sleep_start29 = (L1_ctrl_reg29 ==  'h14) && (L1_ctrl_reg129 == 'hF ); 
    mte_mac023_sleep_start29 = (L1_ctrl_reg29 ==  'h14) && (L1_ctrl_reg129 == 'h10 ); 
    mte_mac123_sleep_start29 = (L1_ctrl_reg29 ==  'h14) && (L1_ctrl_reg129 == 'h11 ); 
    mte_mac_off_sleep_start29 =  (L1_ctrl_reg29 == 'h14) && (L1_ctrl_reg129 == 'h12 );
    mte_dma_sleep_start29 =  (L1_ctrl_reg29 == 'h14) && (L1_ctrl_reg129 == 'h13 );

    mte_pm_uart_to_default_start29 = (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'h1);
    mte_pm_smc_to_default_start29 = (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'h2);
    mte_pm_smc_uart_to_default_start29 = (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'h3); 
    mte_mac0_to_default29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'h4); 
    mte_mac1_to_default29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'h5); 
    mte_mac2_to_default29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'h6); 
    mte_mac3_to_default29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'h7); 
    mte_mac01_to_default29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'h8); 
    mte_mac02_to_default29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'h9); 
    mte_mac03_to_default29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'hA); 
    mte_mac12_to_default29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'hB); 
    mte_mac13_to_default29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'hC); 
    mte_mac23_to_default29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'hD); 
    mte_mac012_to_default29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'hE); 
    mte_mac013_to_default29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'hF); 
    mte_mac023_to_default29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'h10); 
    mte_mac123_to_default29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'h11); 
    mte_mac_off_to_default29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'h12); 
    mte_dma_isolate_dis29 =  (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'h13); 
    mte_cpu_isolate_dis29 =  (int_source_h29) && (cpu_shutoff_ctrl29) && (L1_ctrl_reg29 != 'h15);
    mte_sys_hibernate_to_default29 = (L1_ctrl_reg29 == 32'h0) && (L1_ctrl_reg129 == 'h15); 

   
    if (L1_ctrl_reg129 == 'h0) begin // This29 check is to make mte_cpu_start29
                                   // is set only when you from default state 
      case (L1_ctrl_reg29)
        'h0 : L1_ctrl_domain29 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain29 = 32'h2; // PM_uart29
                mte_uart_start29 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain29 = 32'h4; // PM_smc29
                mte_smc_start29 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain29 = 32'h6; // PM_smc_uart29
                mte_smc_uart_start29 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain29 = 32'h8; //  PM_macb029
                mte_mac0_start29 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain29 = 32'h10; //  PM_macb129
                mte_mac1_start29 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain29 = 32'h20; //  PM_macb229
                mte_mac2_start29 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain29 = 32'h40; //  PM_macb329
                mte_mac3_start29 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain29 = 32'h18; //  PM_macb0129
                mte_mac01_start29 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain29 = 32'h28; //  PM_macb0229
                mte_mac02_start29 = 1;
              end
        'hA : begin  
                L1_ctrl_domain29 = 32'h48; //  PM_macb0329
                mte_mac03_start29 = 1;
              end
        'hB : begin  
                L1_ctrl_domain29 = 32'h30; //  PM_macb1229
                mte_mac12_start29 = 1;
              end
        'hC : begin  
                L1_ctrl_domain29 = 32'h50; //  PM_macb1329
                mte_mac13_start29 = 1;
              end
        'hD : begin  
                L1_ctrl_domain29 = 32'h60; //  PM_macb2329
                mte_mac23_start29 = 1;
              end
        'hE : begin  
                L1_ctrl_domain29 = 32'h38; //  PM_macb01229
                mte_mac012_start29 = 1;
              end
        'hF : begin  
                L1_ctrl_domain29 = 32'h58; //  PM_macb01329
                mte_mac013_start29 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain29 = 32'h68; //  PM_macb02329
                mte_mac023_start29 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain29 = 32'h70; //  PM_macb12329
                mte_mac123_start29 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain29 = 32'h78; //  PM_macb_off29
                mte_mac_off_start29 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain29 = 32'h80; //  PM_dma29
                mte_dma_start29 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain29 = 32'h100; //  PM_cpu_sleep29
                mte_cpu_start29 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain29 = 32'h1FE; //  PM_hibernate29
                mte_sys_hibernate29 = 1;
              end
         default: L1_ctrl_domain29 = 32'h0;
      endcase
    end
  end


  wire to_default29 = (L1_ctrl_reg29 == 0);

  // Scan29 mode gating29 of power29 and isolation29 control29 signals29
  //SMC29
  assign rstn_non_srpg_smc29  = (scan_mode29 == 1'b0) ? rstn_non_srpg_smc_int29 : 1'b1;  
  assign gate_clk_smc29       = (scan_mode29 == 1'b0) ? gate_clk_smc_int29 : 1'b0;     
  assign isolate_smc29        = (scan_mode29 == 1'b0) ? isolate_smc_int29 : 1'b0;      
  assign pwr1_on_smc29        = (scan_mode29 == 1'b0) ? pwr1_on_smc_int29 : 1'b1;       
  assign pwr2_on_smc29        = (scan_mode29 == 1'b0) ? pwr2_on_smc_int29 : 1'b1;       
  assign pwr1_off_smc29       = (scan_mode29 == 1'b0) ? (!pwr1_on_smc_int29) : 1'b0;       
  assign pwr2_off_smc29       = (scan_mode29 == 1'b0) ? (!pwr2_on_smc_int29) : 1'b0;       
  assign save_edge_smc29       = (scan_mode29 == 1'b0) ? (save_edge_smc_int29) : 1'b0;       
  assign restore_edge_smc29       = (scan_mode29 == 1'b0) ? (restore_edge_smc_int29) : 1'b0;       

  //URT29
  assign rstn_non_srpg_urt29  = (scan_mode29 == 1'b0) ?  rstn_non_srpg_urt_int29 : 1'b1;  
  assign gate_clk_urt29       = (scan_mode29 == 1'b0) ?  gate_clk_urt_int29      : 1'b0;     
  assign isolate_urt29        = (scan_mode29 == 1'b0) ?  isolate_urt_int29       : 1'b0;      
  assign pwr1_on_urt29        = (scan_mode29 == 1'b0) ?  pwr1_on_urt_int29       : 1'b1;       
  assign pwr2_on_urt29        = (scan_mode29 == 1'b0) ?  pwr2_on_urt_int29       : 1'b1;       
  assign pwr1_off_urt29       = (scan_mode29 == 1'b0) ?  (!pwr1_on_urt_int29)  : 1'b0;       
  assign pwr2_off_urt29       = (scan_mode29 == 1'b0) ?  (!pwr2_on_urt_int29)  : 1'b0;       
  assign save_edge_urt29       = (scan_mode29 == 1'b0) ? (save_edge_urt_int29) : 1'b0;       
  assign restore_edge_urt29       = (scan_mode29 == 1'b0) ? (restore_edge_urt_int29) : 1'b0;       

  //ETH029
  assign rstn_non_srpg_macb029 = (scan_mode29 == 1'b0) ?  rstn_non_srpg_macb0_int29 : 1'b1;  
  assign gate_clk_macb029       = (scan_mode29 == 1'b0) ?  gate_clk_macb0_int29      : 1'b0;     
  assign isolate_macb029        = (scan_mode29 == 1'b0) ?  isolate_macb0_int29       : 1'b0;      
  assign pwr1_on_macb029        = (scan_mode29 == 1'b0) ?  pwr1_on_macb0_int29       : 1'b1;       
  assign pwr2_on_macb029        = (scan_mode29 == 1'b0) ?  pwr2_on_macb0_int29       : 1'b1;       
  assign pwr1_off_macb029       = (scan_mode29 == 1'b0) ?  (!pwr1_on_macb0_int29)  : 1'b0;       
  assign pwr2_off_macb029       = (scan_mode29 == 1'b0) ?  (!pwr2_on_macb0_int29)  : 1'b0;       
  assign save_edge_macb029       = (scan_mode29 == 1'b0) ? (save_edge_macb0_int29) : 1'b0;       
  assign restore_edge_macb029       = (scan_mode29 == 1'b0) ? (restore_edge_macb0_int29) : 1'b0;       

  //ETH129
  assign rstn_non_srpg_macb129 = (scan_mode29 == 1'b0) ?  rstn_non_srpg_macb1_int29 : 1'b1;  
  assign gate_clk_macb129       = (scan_mode29 == 1'b0) ?  gate_clk_macb1_int29      : 1'b0;     
  assign isolate_macb129        = (scan_mode29 == 1'b0) ?  isolate_macb1_int29       : 1'b0;      
  assign pwr1_on_macb129        = (scan_mode29 == 1'b0) ?  pwr1_on_macb1_int29       : 1'b1;       
  assign pwr2_on_macb129        = (scan_mode29 == 1'b0) ?  pwr2_on_macb1_int29       : 1'b1;       
  assign pwr1_off_macb129       = (scan_mode29 == 1'b0) ?  (!pwr1_on_macb1_int29)  : 1'b0;       
  assign pwr2_off_macb129       = (scan_mode29 == 1'b0) ?  (!pwr2_on_macb1_int29)  : 1'b0;       
  assign save_edge_macb129       = (scan_mode29 == 1'b0) ? (save_edge_macb1_int29) : 1'b0;       
  assign restore_edge_macb129       = (scan_mode29 == 1'b0) ? (restore_edge_macb1_int29) : 1'b0;       

  //ETH229
  assign rstn_non_srpg_macb229 = (scan_mode29 == 1'b0) ?  rstn_non_srpg_macb2_int29 : 1'b1;  
  assign gate_clk_macb229       = (scan_mode29 == 1'b0) ?  gate_clk_macb2_int29      : 1'b0;     
  assign isolate_macb229        = (scan_mode29 == 1'b0) ?  isolate_macb2_int29       : 1'b0;      
  assign pwr1_on_macb229        = (scan_mode29 == 1'b0) ?  pwr1_on_macb2_int29       : 1'b1;       
  assign pwr2_on_macb229        = (scan_mode29 == 1'b0) ?  pwr2_on_macb2_int29       : 1'b1;       
  assign pwr1_off_macb229       = (scan_mode29 == 1'b0) ?  (!pwr1_on_macb2_int29)  : 1'b0;       
  assign pwr2_off_macb229       = (scan_mode29 == 1'b0) ?  (!pwr2_on_macb2_int29)  : 1'b0;       
  assign save_edge_macb229       = (scan_mode29 == 1'b0) ? (save_edge_macb2_int29) : 1'b0;       
  assign restore_edge_macb229       = (scan_mode29 == 1'b0) ? (restore_edge_macb2_int29) : 1'b0;       

  //ETH329
  assign rstn_non_srpg_macb329 = (scan_mode29 == 1'b0) ?  rstn_non_srpg_macb3_int29 : 1'b1;  
  assign gate_clk_macb329       = (scan_mode29 == 1'b0) ?  gate_clk_macb3_int29      : 1'b0;     
  assign isolate_macb329        = (scan_mode29 == 1'b0) ?  isolate_macb3_int29       : 1'b0;      
  assign pwr1_on_macb329        = (scan_mode29 == 1'b0) ?  pwr1_on_macb3_int29       : 1'b1;       
  assign pwr2_on_macb329        = (scan_mode29 == 1'b0) ?  pwr2_on_macb3_int29       : 1'b1;       
  assign pwr1_off_macb329       = (scan_mode29 == 1'b0) ?  (!pwr1_on_macb3_int29)  : 1'b0;       
  assign pwr2_off_macb329       = (scan_mode29 == 1'b0) ?  (!pwr2_on_macb3_int29)  : 1'b0;       
  assign save_edge_macb329       = (scan_mode29 == 1'b0) ? (save_edge_macb3_int29) : 1'b0;       
  assign restore_edge_macb329       = (scan_mode29 == 1'b0) ? (restore_edge_macb3_int29) : 1'b0;       

  // MEM29
  assign rstn_non_srpg_mem29 =   (rstn_non_srpg_macb029 && rstn_non_srpg_macb129 && rstn_non_srpg_macb229 &&
                                rstn_non_srpg_macb329 && rstn_non_srpg_dma29 && rstn_non_srpg_cpu29 && rstn_non_srpg_urt29 &&
                                rstn_non_srpg_smc29);

  assign gate_clk_mem29 =  (gate_clk_macb029 && gate_clk_macb129 && gate_clk_macb229 &&
                            gate_clk_macb329 && gate_clk_dma29 && gate_clk_cpu29 && gate_clk_urt29 && gate_clk_smc29);

  assign isolate_mem29  = (isolate_macb029 && isolate_macb129 && isolate_macb229 &&
                         isolate_macb329 && isolate_dma29 && isolate_cpu29 && isolate_urt29 && isolate_smc29);


  assign pwr1_on_mem29        =   ~pwr1_off_mem29;

  assign pwr2_on_mem29        =   ~pwr2_off_mem29;

  assign pwr1_off_mem29       =  (pwr1_off_macb029 && pwr1_off_macb129 && pwr1_off_macb229 &&
                                 pwr1_off_macb329 && pwr1_off_dma29 && pwr1_off_cpu29 && pwr1_off_urt29 && pwr1_off_smc29);


  assign pwr2_off_mem29       =  (pwr2_off_macb029 && pwr2_off_macb129 && pwr2_off_macb229 &&
                                pwr2_off_macb329 && pwr2_off_dma29 && pwr2_off_cpu29 && pwr2_off_urt29 && pwr2_off_smc29);

  assign save_edge_mem29      =  (save_edge_macb029 && save_edge_macb129 && save_edge_macb229 &&
                                save_edge_macb329 && save_edge_dma29 && save_edge_cpu29 && save_edge_smc29 && save_edge_urt29);

  assign restore_edge_mem29   =  (restore_edge_macb029 && restore_edge_macb129 && restore_edge_macb229  &&
                                restore_edge_macb329 && restore_edge_dma29 && restore_edge_cpu29 && restore_edge_urt29 &&
                                restore_edge_smc29);

  assign standby_mem029 = pwr1_off_macb029 && (~ (pwr1_off_macb029 && pwr1_off_macb129 && pwr1_off_macb229 && pwr1_off_macb329 && pwr1_off_urt29 && pwr1_off_smc29 && pwr1_off_dma29 && pwr1_off_cpu29));
  assign standby_mem129 = pwr1_off_macb129 && (~ (pwr1_off_macb029 && pwr1_off_macb129 && pwr1_off_macb229 && pwr1_off_macb329 && pwr1_off_urt29 && pwr1_off_smc29 && pwr1_off_dma29 && pwr1_off_cpu29));
  assign standby_mem229 = pwr1_off_macb229 && (~ (pwr1_off_macb029 && pwr1_off_macb129 && pwr1_off_macb229 && pwr1_off_macb329 && pwr1_off_urt29 && pwr1_off_smc29 && pwr1_off_dma29 && pwr1_off_cpu29));
  assign standby_mem329 = pwr1_off_macb329 && (~ (pwr1_off_macb029 && pwr1_off_macb129 && pwr1_off_macb229 && pwr1_off_macb329 && pwr1_off_urt29 && pwr1_off_smc29 && pwr1_off_dma29 && pwr1_off_cpu29));

  assign pwr1_off_mem029 = pwr1_off_mem29;
  assign pwr1_off_mem129 = pwr1_off_mem29;
  assign pwr1_off_mem229 = pwr1_off_mem29;
  assign pwr1_off_mem329 = pwr1_off_mem29;

  assign rstn_non_srpg_alut29  =  (rstn_non_srpg_macb029 && rstn_non_srpg_macb129 && rstn_non_srpg_macb229 && rstn_non_srpg_macb329);


   assign gate_clk_alut29       =  (gate_clk_macb029 && gate_clk_macb129 && gate_clk_macb229 && gate_clk_macb329);


    assign isolate_alut29        =  (isolate_macb029 && isolate_macb129 && isolate_macb229 && isolate_macb329);


    assign pwr1_on_alut29        =  (pwr1_on_macb029 || pwr1_on_macb129 || pwr1_on_macb229 || pwr1_on_macb329);


    assign pwr2_on_alut29        =  (pwr2_on_macb029 || pwr2_on_macb129 || pwr2_on_macb229 || pwr2_on_macb329);


    assign pwr1_off_alut29       =  (pwr1_off_macb029 && pwr1_off_macb129 && pwr1_off_macb229 && pwr1_off_macb329);


    assign pwr2_off_alut29       =  (pwr2_off_macb029 && pwr2_off_macb129 && pwr2_off_macb229 && pwr2_off_macb329);


    assign save_edge_alut29      =  (save_edge_macb029 && save_edge_macb129 && save_edge_macb229 && save_edge_macb329);


    assign restore_edge_alut29   =  (restore_edge_macb029 || restore_edge_macb129 || restore_edge_macb229 ||
                                   restore_edge_macb329) && save_alut_tmp29;

     // alut29 power29 off29 detection29
  always @(posedge pclk29 or negedge nprst29) begin
    if (!nprst29) 
       save_alut_tmp29 <= 0;
    else if (restore_edge_alut29)
       save_alut_tmp29 <= 0;
    else if (save_edge_alut29)
       save_alut_tmp29 <= 1;
  end

  //DMA29
  assign rstn_non_srpg_dma29 = (scan_mode29 == 1'b0) ?  rstn_non_srpg_dma_int29 : 1'b1;  
  assign gate_clk_dma29       = (scan_mode29 == 1'b0) ?  gate_clk_dma_int29      : 1'b0;     
  assign isolate_dma29        = (scan_mode29 == 1'b0) ?  isolate_dma_int29       : 1'b0;      
  assign pwr1_on_dma29        = (scan_mode29 == 1'b0) ?  pwr1_on_dma_int29       : 1'b1;       
  assign pwr2_on_dma29        = (scan_mode29 == 1'b0) ?  pwr2_on_dma_int29       : 1'b1;       
  assign pwr1_off_dma29       = (scan_mode29 == 1'b0) ?  (!pwr1_on_dma_int29)  : 1'b0;       
  assign pwr2_off_dma29       = (scan_mode29 == 1'b0) ?  (!pwr2_on_dma_int29)  : 1'b0;       
  assign save_edge_dma29       = (scan_mode29 == 1'b0) ? (save_edge_dma_int29) : 1'b0;       
  assign restore_edge_dma29       = (scan_mode29 == 1'b0) ? (restore_edge_dma_int29) : 1'b0;       

  //CPU29
  assign rstn_non_srpg_cpu29 = (scan_mode29 == 1'b0) ?  rstn_non_srpg_cpu_int29 : 1'b1;  
  assign gate_clk_cpu29       = (scan_mode29 == 1'b0) ?  gate_clk_cpu_int29      : 1'b0;     
  assign isolate_cpu29        = (scan_mode29 == 1'b0) ?  isolate_cpu_int29       : 1'b0;      
  assign pwr1_on_cpu29        = (scan_mode29 == 1'b0) ?  pwr1_on_cpu_int29       : 1'b1;       
  assign pwr2_on_cpu29        = (scan_mode29 == 1'b0) ?  pwr2_on_cpu_int29       : 1'b1;       
  assign pwr1_off_cpu29       = (scan_mode29 == 1'b0) ?  (!pwr1_on_cpu_int29)  : 1'b0;       
  assign pwr2_off_cpu29       = (scan_mode29 == 1'b0) ?  (!pwr2_on_cpu_int29)  : 1'b0;       
  assign save_edge_cpu29       = (scan_mode29 == 1'b0) ? (save_edge_cpu_int29) : 1'b0;       
  assign restore_edge_cpu29       = (scan_mode29 == 1'b0) ? (restore_edge_cpu_int29) : 1'b0;       



  // ASE29

   reg ase_core_12v29, ase_core_10v29, ase_core_08v29, ase_core_06v29;
   reg ase_macb0_12v29,ase_macb1_12v29,ase_macb2_12v29,ase_macb3_12v29;

    // core29 ase29

    // core29 at 1.0 v if (smc29 off29, urt29 off29, macb029 off29, macb129 off29, macb229 off29, macb329 off29
   // core29 at 0.8v if (mac01off29, macb02off29, macb03off29, macb12off29, mac13off29, mac23off29,
   // core29 at 0.6v if (mac012off29, mac013off29, mac023off29, mac123off29, mac0123off29
    // else core29 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb029 && pwr1_off_macb129 && pwr1_off_macb229 && pwr1_off_macb329) || // all mac29 off29
       (pwr1_off_macb329 && pwr1_off_macb229 && pwr1_off_macb129) || // mac123off29 
       (pwr1_off_macb329 && pwr1_off_macb229 && pwr1_off_macb029) || // mac023off29 
       (pwr1_off_macb329 && pwr1_off_macb129 && pwr1_off_macb029) || // mac013off29 
       (pwr1_off_macb229 && pwr1_off_macb129 && pwr1_off_macb029) )  // mac012off29 
       begin
         ase_core_12v29 = 0;
         ase_core_10v29 = 0;
         ase_core_08v29 = 0;
         ase_core_06v29 = 1;
       end
     else if( (pwr1_off_macb229 && pwr1_off_macb329) || // mac2329 off29
         (pwr1_off_macb329 && pwr1_off_macb129) || // mac13off29 
         (pwr1_off_macb129 && pwr1_off_macb229) || // mac12off29 
         (pwr1_off_macb329 && pwr1_off_macb029) || // mac03off29 
         (pwr1_off_macb229 && pwr1_off_macb029) || // mac02off29 
         (pwr1_off_macb129 && pwr1_off_macb029))  // mac01off29 
       begin
         ase_core_12v29 = 0;
         ase_core_10v29 = 0;
         ase_core_08v29 = 1;
         ase_core_06v29 = 0;
       end
     else if( (pwr1_off_smc29) || // smc29 off29
         (pwr1_off_macb029 ) || // mac0off29 
         (pwr1_off_macb129 ) || // mac1off29 
         (pwr1_off_macb229 ) || // mac2off29 
         (pwr1_off_macb329 ))  // mac3off29 
       begin
         ase_core_12v29 = 0;
         ase_core_10v29 = 1;
         ase_core_08v29 = 0;
         ase_core_06v29 = 0;
       end
     else if (pwr1_off_urt29)
       begin
         ase_core_12v29 = 1;
         ase_core_10v29 = 0;
         ase_core_08v29 = 0;
         ase_core_06v29 = 0;
       end
     else
       begin
         ase_core_12v29 = 1;
         ase_core_10v29 = 0;
         ase_core_08v29 = 0;
         ase_core_06v29 = 0;
       end
   end


   // cpu29
   // cpu29 @ 1.0v when macoff29, 
   // 
   reg ase_cpu_10v29, ase_cpu_12v29;
   always @(*) begin
    if(pwr1_off_cpu29) begin
     ase_cpu_12v29 = 1'b0;
     ase_cpu_10v29 = 1'b0;
    end
    else if(pwr1_off_macb029 || pwr1_off_macb129 || pwr1_off_macb229 || pwr1_off_macb329)
    begin
     ase_cpu_12v29 = 1'b0;
     ase_cpu_10v29 = 1'b1;
    end
    else
    begin
     ase_cpu_12v29 = 1'b1;
     ase_cpu_10v29 = 1'b0;
    end
   end

   // dma29
   // dma29 @v129.0 for macoff29, 

   reg ase_dma_10v29, ase_dma_12v29;
   always @(*) begin
    if(pwr1_off_dma29) begin
     ase_dma_12v29 = 1'b0;
     ase_dma_10v29 = 1'b0;
    end
    else if(pwr1_off_macb029 || pwr1_off_macb129 || pwr1_off_macb229 || pwr1_off_macb329)
    begin
     ase_dma_12v29 = 1'b0;
     ase_dma_10v29 = 1'b1;
    end
    else
    begin
     ase_dma_12v29 = 1'b1;
     ase_dma_10v29 = 1'b0;
    end
   end

   // alut29
   // @ v129.0 for macoff29

   reg ase_alut_10v29, ase_alut_12v29;
   always @(*) begin
    if(pwr1_off_alut29) begin
     ase_alut_12v29 = 1'b0;
     ase_alut_10v29 = 1'b0;
    end
    else if(pwr1_off_macb029 || pwr1_off_macb129 || pwr1_off_macb229 || pwr1_off_macb329)
    begin
     ase_alut_12v29 = 1'b0;
     ase_alut_10v29 = 1'b1;
    end
    else
    begin
     ase_alut_12v29 = 1'b1;
     ase_alut_10v29 = 1'b0;
    end
   end




   reg ase_uart_12v29;
   reg ase_uart_10v29;
   reg ase_uart_08v29;
   reg ase_uart_06v29;

   reg ase_smc_12v29;


   always @(*) begin
     if(pwr1_off_urt29) begin // uart29 off29
       ase_uart_08v29 = 1'b0;
       ase_uart_06v29 = 1'b0;
       ase_uart_10v29 = 1'b0;
       ase_uart_12v29 = 1'b0;
     end 
     else if( (pwr1_off_macb029 && pwr1_off_macb129 && pwr1_off_macb229 && pwr1_off_macb329) || // all mac29 off29
       (pwr1_off_macb329 && pwr1_off_macb229 && pwr1_off_macb129) || // mac123off29 
       (pwr1_off_macb329 && pwr1_off_macb229 && pwr1_off_macb029) || // mac023off29 
       (pwr1_off_macb329 && pwr1_off_macb129 && pwr1_off_macb029) || // mac013off29 
       (pwr1_off_macb229 && pwr1_off_macb129 && pwr1_off_macb029) )  // mac012off29 
     begin
       ase_uart_06v29 = 1'b1;
       ase_uart_08v29 = 1'b0;
       ase_uart_10v29 = 1'b0;
       ase_uart_12v29 = 1'b0;
     end
     else if( (pwr1_off_macb229 && pwr1_off_macb329) || // mac2329 off29
         (pwr1_off_macb329 && pwr1_off_macb129) || // mac13off29 
         (pwr1_off_macb129 && pwr1_off_macb229) || // mac12off29 
         (pwr1_off_macb329 && pwr1_off_macb029) || // mac03off29 
         (pwr1_off_macb129 && pwr1_off_macb029))  // mac01off29  
     begin
       ase_uart_06v29 = 1'b0;
       ase_uart_08v29 = 1'b1;
       ase_uart_10v29 = 1'b0;
       ase_uart_12v29 = 1'b0;
     end
     else if (pwr1_off_smc29 || pwr1_off_macb029 || pwr1_off_macb129 || pwr1_off_macb229 || pwr1_off_macb329) begin // smc29 off29
       ase_uart_08v29 = 1'b0;
       ase_uart_06v29 = 1'b0;
       ase_uart_10v29 = 1'b1;
       ase_uart_12v29 = 1'b0;
     end 
     else begin
       ase_uart_08v29 = 1'b0;
       ase_uart_06v29 = 1'b0;
       ase_uart_10v29 = 1'b0;
       ase_uart_12v29 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc29) begin
     if (pwr1_off_smc29)  // smc29 off29
       ase_smc_12v29 = 1'b0;
    else
       ase_smc_12v29 = 1'b1;
   end

   
   always @(pwr1_off_macb029) begin
     if (pwr1_off_macb029) // macb029 off29
       ase_macb0_12v29 = 1'b0;
     else
       ase_macb0_12v29 = 1'b1;
   end

   always @(pwr1_off_macb129) begin
     if (pwr1_off_macb129) // macb129 off29
       ase_macb1_12v29 = 1'b0;
     else
       ase_macb1_12v29 = 1'b1;
   end

   always @(pwr1_off_macb229) begin // macb229 off29
     if (pwr1_off_macb229) // macb229 off29
       ase_macb2_12v29 = 1'b0;
     else
       ase_macb2_12v29 = 1'b1;
   end

   always @(pwr1_off_macb329) begin // macb329 off29
     if (pwr1_off_macb329) // macb329 off29
       ase_macb3_12v29 = 1'b0;
     else
       ase_macb3_12v29 = 1'b1;
   end


   // core29 voltage29 for vco29
  assign core12v29 = ase_macb0_12v29 & ase_macb1_12v29 & ase_macb2_12v29 & ase_macb3_12v29;

  assign core10v29 =  (ase_macb0_12v29 & ase_macb1_12v29 & ase_macb2_12v29 & (!ase_macb3_12v29)) ||
                    (ase_macb0_12v29 & ase_macb1_12v29 & (!ase_macb2_12v29) & ase_macb3_12v29) ||
                    (ase_macb0_12v29 & (!ase_macb1_12v29) & ase_macb2_12v29 & ase_macb3_12v29) ||
                    ((!ase_macb0_12v29) & ase_macb1_12v29 & ase_macb2_12v29 & ase_macb3_12v29);

  assign core08v29 =  ((!ase_macb0_12v29) & (!ase_macb1_12v29) & (ase_macb2_12v29) & (ase_macb3_12v29)) ||
                    ((!ase_macb0_12v29) & (ase_macb1_12v29) & (!ase_macb2_12v29) & (ase_macb3_12v29)) ||
                    ((!ase_macb0_12v29) & (ase_macb1_12v29) & (ase_macb2_12v29) & (!ase_macb3_12v29)) ||
                    ((ase_macb0_12v29) & (!ase_macb1_12v29) & (!ase_macb2_12v29) & (ase_macb3_12v29)) ||
                    ((ase_macb0_12v29) & (!ase_macb1_12v29) & (ase_macb2_12v29) & (!ase_macb3_12v29)) ||
                    ((ase_macb0_12v29) & (ase_macb1_12v29) & (!ase_macb2_12v29) & (!ase_macb3_12v29));

  assign core06v29 =  ((!ase_macb0_12v29) & (!ase_macb1_12v29) & (!ase_macb2_12v29) & (ase_macb3_12v29)) ||
                    ((!ase_macb0_12v29) & (!ase_macb1_12v29) & (ase_macb2_12v29) & (!ase_macb3_12v29)) ||
                    ((!ase_macb0_12v29) & (ase_macb1_12v29) & (!ase_macb2_12v29) & (!ase_macb3_12v29)) ||
                    ((ase_macb0_12v29) & (!ase_macb1_12v29) & (!ase_macb2_12v29) & (!ase_macb3_12v29)) ||
                    ((!ase_macb0_12v29) & (!ase_macb1_12v29) & (!ase_macb2_12v29) & (!ase_macb3_12v29)) ;



`ifdef LP_ABV_ON29
// psl29 default clock29 = (posedge pclk29);

// Cover29 a condition in which SMC29 is powered29 down
// and again29 powered29 up while UART29 is going29 into POWER29 down
// state or UART29 is already in POWER29 DOWN29 state
// psl29 cover_overlapping_smc_urt_129:
//    cover{fell29(pwr1_on_urt29);[*];fell29(pwr1_on_smc29);[*];
//    rose29(pwr1_on_smc29);[*];rose29(pwr1_on_urt29)};
//
// Cover29 a condition in which UART29 is powered29 down
// and again29 powered29 up while SMC29 is going29 into POWER29 down
// state or SMC29 is already in POWER29 DOWN29 state
// psl29 cover_overlapping_smc_urt_229:
//    cover{fell29(pwr1_on_smc29);[*];fell29(pwr1_on_urt29);[*];
//    rose29(pwr1_on_urt29);[*];rose29(pwr1_on_smc29)};
//


// Power29 Down29 UART29
// This29 gets29 triggered on rising29 edge of Gate29 signal29 for
// UART29 (gate_clk_urt29). In a next cycle after gate_clk_urt29,
// Isolate29 UART29(isolate_urt29) signal29 become29 HIGH29 (active).
// In 2nd cycle after gate_clk_urt29 becomes HIGH29, RESET29 for NON29
// SRPG29 FFs29(rstn_non_srpg_urt29) and POWER129 for UART29(pwr1_on_urt29) should 
// go29 LOW29. 
// This29 completes29 a POWER29 DOWN29. 

sequence s_power_down_urt29;
      (gate_clk_urt29 & !isolate_urt29 & rstn_non_srpg_urt29 & pwr1_on_urt29) 
  ##1 (gate_clk_urt29 & isolate_urt29 & rstn_non_srpg_urt29 & pwr1_on_urt29) 
  ##3 (gate_clk_urt29 & isolate_urt29 & !rstn_non_srpg_urt29 & !pwr1_on_urt29);
endsequence


property p_power_down_urt29;
   @(posedge pclk29)
    $rose(gate_clk_urt29) |=> s_power_down_urt29;
endproperty

output_power_down_urt29:
  assert property (p_power_down_urt29);


// Power29 UP29 UART29
// Sequence starts with , Rising29 edge of pwr1_on_urt29.
// Two29 clock29 cycle after this, isolate_urt29 should become29 LOW29 
// On29 the following29 clk29 gate_clk_urt29 should go29 low29.
// 5 cycles29 after  Rising29 edge of pwr1_on_urt29, rstn_non_srpg_urt29
// should become29 HIGH29
sequence s_power_up_urt29;
##30 (pwr1_on_urt29 & !isolate_urt29 & gate_clk_urt29 & !rstn_non_srpg_urt29) 
##1 (pwr1_on_urt29 & !isolate_urt29 & !gate_clk_urt29 & !rstn_non_srpg_urt29) 
##2 (pwr1_on_urt29 & !isolate_urt29 & !gate_clk_urt29 & rstn_non_srpg_urt29);
endsequence

property p_power_up_urt29;
   @(posedge pclk29)
  disable iff(!nprst29)
    (!pwr1_on_urt29 ##1 pwr1_on_urt29) |=> s_power_up_urt29;
endproperty

output_power_up_urt29:
  assert property (p_power_up_urt29);


// Power29 Down29 SMC29
// This29 gets29 triggered on rising29 edge of Gate29 signal29 for
// SMC29 (gate_clk_smc29). In a next cycle after gate_clk_smc29,
// Isolate29 SMC29(isolate_smc29) signal29 become29 HIGH29 (active).
// In 2nd cycle after gate_clk_smc29 becomes HIGH29, RESET29 for NON29
// SRPG29 FFs29(rstn_non_srpg_smc29) and POWER129 for SMC29(pwr1_on_smc29) should 
// go29 LOW29. 
// This29 completes29 a POWER29 DOWN29. 

sequence s_power_down_smc29;
      (gate_clk_smc29 & !isolate_smc29 & rstn_non_srpg_smc29 & pwr1_on_smc29) 
  ##1 (gate_clk_smc29 & isolate_smc29 & rstn_non_srpg_smc29 & pwr1_on_smc29) 
  ##3 (gate_clk_smc29 & isolate_smc29 & !rstn_non_srpg_smc29 & !pwr1_on_smc29);
endsequence


property p_power_down_smc29;
   @(posedge pclk29)
    $rose(gate_clk_smc29) |=> s_power_down_smc29;
endproperty

output_power_down_smc29:
  assert property (p_power_down_smc29);


// Power29 UP29 SMC29
// Sequence starts with , Rising29 edge of pwr1_on_smc29.
// Two29 clock29 cycle after this, isolate_smc29 should become29 LOW29 
// On29 the following29 clk29 gate_clk_smc29 should go29 low29.
// 5 cycles29 after  Rising29 edge of pwr1_on_smc29, rstn_non_srpg_smc29
// should become29 HIGH29
sequence s_power_up_smc29;
##30 (pwr1_on_smc29 & !isolate_smc29 & gate_clk_smc29 & !rstn_non_srpg_smc29) 
##1 (pwr1_on_smc29 & !isolate_smc29 & !gate_clk_smc29 & !rstn_non_srpg_smc29) 
##2 (pwr1_on_smc29 & !isolate_smc29 & !gate_clk_smc29 & rstn_non_srpg_smc29);
endsequence

property p_power_up_smc29;
   @(posedge pclk29)
  disable iff(!nprst29)
    (!pwr1_on_smc29 ##1 pwr1_on_smc29) |=> s_power_up_smc29;
endproperty

output_power_up_smc29:
  assert property (p_power_up_smc29);


// COVER29 SMC29 POWER29 DOWN29 AND29 UP29
cover_power_down_up_smc29: cover property (@(posedge pclk29)
(s_power_down_smc29 ##[5:180] s_power_up_smc29));



// COVER29 UART29 POWER29 DOWN29 AND29 UP29
cover_power_down_up_urt29: cover property (@(posedge pclk29)
(s_power_down_urt29 ##[5:180] s_power_up_urt29));

cover_power_down_urt29: cover property (@(posedge pclk29)
(s_power_down_urt29));

cover_power_up_urt29: cover property (@(posedge pclk29)
(s_power_up_urt29));




`ifdef PCM_ABV_ON29
//------------------------------------------------------------------------------
// Power29 Controller29 Formal29 Verification29 component.  Each power29 domain has a 
// separate29 instantiation29
//------------------------------------------------------------------------------

// need to assume that CPU29 will leave29 a minimum time between powering29 down and 
// back up.  In this example29, 10clks has been selected.
// psl29 config_min_uart_pd_time29 : assume always {rose29(L1_ctrl_domain29[1])} |-> { L1_ctrl_domain29[1][*10] } abort29(~nprst29);
// psl29 config_min_uart_pu_time29 : assume always {fell29(L1_ctrl_domain29[1])} |-> { !L1_ctrl_domain29[1][*10] } abort29(~nprst29);
// psl29 config_min_smc_pd_time29 : assume always {rose29(L1_ctrl_domain29[2])} |-> { L1_ctrl_domain29[2][*10] } abort29(~nprst29);
// psl29 config_min_smc_pu_time29 : assume always {fell29(L1_ctrl_domain29[2])} |-> { !L1_ctrl_domain29[2][*10] } abort29(~nprst29);

// UART29 VCOMP29 parameters29
   defparam i_uart_vcomp_domain29.ENABLE_SAVE_RESTORE_EDGE29   = 1;
   defparam i_uart_vcomp_domain29.ENABLE_EXT_PWR_CNTRL29       = 1;
   defparam i_uart_vcomp_domain29.REF_CLK_DEFINED29            = 0;
   defparam i_uart_vcomp_domain29.MIN_SHUTOFF_CYCLES29         = 4;
   defparam i_uart_vcomp_domain29.MIN_RESTORE_TO_ISO_CYCLES29  = 0;
   defparam i_uart_vcomp_domain29.MIN_SAVE_TO_SHUTOFF_CYCLES29 = 1;


   vcomp_domain29 i_uart_vcomp_domain29
   ( .ref_clk29(pclk29),
     .start_lps29(L1_ctrl_domain29[1] || !rstn_non_srpg_urt29),
     .rst_n29(nprst29),
     .ext_power_down29(L1_ctrl_domain29[1]),
     .iso_en29(isolate_urt29),
     .save_edge29(save_edge_urt29),
     .restore_edge29(restore_edge_urt29),
     .domain_shut_off29(pwr1_off_urt29),
     .domain_clk29(!gate_clk_urt29 && pclk29)
   );


// SMC29 VCOMP29 parameters29
   defparam i_smc_vcomp_domain29.ENABLE_SAVE_RESTORE_EDGE29   = 1;
   defparam i_smc_vcomp_domain29.ENABLE_EXT_PWR_CNTRL29       = 1;
   defparam i_smc_vcomp_domain29.REF_CLK_DEFINED29            = 0;
   defparam i_smc_vcomp_domain29.MIN_SHUTOFF_CYCLES29         = 4;
   defparam i_smc_vcomp_domain29.MIN_RESTORE_TO_ISO_CYCLES29  = 0;
   defparam i_smc_vcomp_domain29.MIN_SAVE_TO_SHUTOFF_CYCLES29 = 1;


   vcomp_domain29 i_smc_vcomp_domain29
   ( .ref_clk29(pclk29),
     .start_lps29(L1_ctrl_domain29[2] || !rstn_non_srpg_smc29),
     .rst_n29(nprst29),
     .ext_power_down29(L1_ctrl_domain29[2]),
     .iso_en29(isolate_smc29),
     .save_edge29(save_edge_smc29),
     .restore_edge29(restore_edge_smc29),
     .domain_shut_off29(pwr1_off_smc29),
     .domain_clk29(!gate_clk_smc29 && pclk29)
   );

`endif

`endif



endmodule
