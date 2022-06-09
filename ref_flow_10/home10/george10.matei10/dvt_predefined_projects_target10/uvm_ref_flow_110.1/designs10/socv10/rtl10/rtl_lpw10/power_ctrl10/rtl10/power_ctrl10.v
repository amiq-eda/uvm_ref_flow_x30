//File10 name   : power_ctrl10.v
//Title10       : Power10 Control10 Module10
//Created10     : 1999
//Description10 : Top10 level of power10 controller10
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

module power_ctrl10 (


    // Clocks10 & Reset10
    pclk10,
    nprst10,
    // APB10 programming10 interface
    paddr10,
    psel10,
    penable10,
    pwrite10,
    pwdata10,
    prdata10,
    // mac10 i/f,
    macb3_wakeup10,
    macb2_wakeup10,
    macb1_wakeup10,
    macb0_wakeup10,
    // Scan10 
    scan_in10,
    scan_en10,
    scan_mode10,
    scan_out10,
    // Module10 control10 outputs10
    int_source_h10,
    // SMC10
    rstn_non_srpg_smc10,
    gate_clk_smc10,
    isolate_smc10,
    save_edge_smc10,
    restore_edge_smc10,
    pwr1_on_smc10,
    pwr2_on_smc10,
    pwr1_off_smc10,
    pwr2_off_smc10,
    // URT10
    rstn_non_srpg_urt10,
    gate_clk_urt10,
    isolate_urt10,
    save_edge_urt10,
    restore_edge_urt10,
    pwr1_on_urt10,
    pwr2_on_urt10,
    pwr1_off_urt10,      
    pwr2_off_urt10,
    // ETH010
    rstn_non_srpg_macb010,
    gate_clk_macb010,
    isolate_macb010,
    save_edge_macb010,
    restore_edge_macb010,
    pwr1_on_macb010,
    pwr2_on_macb010,
    pwr1_off_macb010,      
    pwr2_off_macb010,
    // ETH110
    rstn_non_srpg_macb110,
    gate_clk_macb110,
    isolate_macb110,
    save_edge_macb110,
    restore_edge_macb110,
    pwr1_on_macb110,
    pwr2_on_macb110,
    pwr1_off_macb110,      
    pwr2_off_macb110,
    // ETH210
    rstn_non_srpg_macb210,
    gate_clk_macb210,
    isolate_macb210,
    save_edge_macb210,
    restore_edge_macb210,
    pwr1_on_macb210,
    pwr2_on_macb210,
    pwr1_off_macb210,      
    pwr2_off_macb210,
    // ETH310
    rstn_non_srpg_macb310,
    gate_clk_macb310,
    isolate_macb310,
    save_edge_macb310,
    restore_edge_macb310,
    pwr1_on_macb310,
    pwr2_on_macb310,
    pwr1_off_macb310,      
    pwr2_off_macb310,
    // DMA10
    rstn_non_srpg_dma10,
    gate_clk_dma10,
    isolate_dma10,
    save_edge_dma10,
    restore_edge_dma10,
    pwr1_on_dma10,
    pwr2_on_dma10,
    pwr1_off_dma10,      
    pwr2_off_dma10,
    // CPU10
    rstn_non_srpg_cpu10,
    gate_clk_cpu10,
    isolate_cpu10,
    save_edge_cpu10,
    restore_edge_cpu10,
    pwr1_on_cpu10,
    pwr2_on_cpu10,
    pwr1_off_cpu10,      
    pwr2_off_cpu10,
    // ALUT10
    rstn_non_srpg_alut10,
    gate_clk_alut10,
    isolate_alut10,
    save_edge_alut10,
    restore_edge_alut10,
    pwr1_on_alut10,
    pwr2_on_alut10,
    pwr1_off_alut10,      
    pwr2_off_alut10,
    // MEM10
    rstn_non_srpg_mem10,
    gate_clk_mem10,
    isolate_mem10,
    save_edge_mem10,
    restore_edge_mem10,
    pwr1_on_mem10,
    pwr2_on_mem10,
    pwr1_off_mem10,      
    pwr2_off_mem10,
    // core10 dvfs10 transitions10
    core06v10,
    core08v10,
    core10v10,
    core12v10,
    pcm_macb_wakeup_int10,
    // mte10 signals10
    mte_smc_start10,
    mte_uart_start10,
    mte_smc_uart_start10,  
    mte_pm_smc_to_default_start10, 
    mte_pm_uart_to_default_start10,
    mte_pm_smc_uart_to_default_start10

  );

  parameter STATE_IDLE_12V10 = 4'b0001;
  parameter STATE_06V10 = 4'b0010;
  parameter STATE_08V10 = 4'b0100;
  parameter STATE_10V10 = 4'b1000;

    // Clocks10 & Reset10
    input pclk10;
    input nprst10;
    // APB10 programming10 interface
    input [31:0] paddr10;
    input psel10  ;
    input penable10;
    input pwrite10 ;
    input [31:0] pwdata10;
    output [31:0] prdata10;
    // mac10
    input macb3_wakeup10;
    input macb2_wakeup10;
    input macb1_wakeup10;
    input macb0_wakeup10;
    // Scan10 
    input scan_in10;
    input scan_en10;
    input scan_mode10;
    output scan_out10;
    // Module10 control10 outputs10
    input int_source_h10;
    // SMC10
    output rstn_non_srpg_smc10 ;
    output gate_clk_smc10   ;
    output isolate_smc10   ;
    output save_edge_smc10   ;
    output restore_edge_smc10   ;
    output pwr1_on_smc10   ;
    output pwr2_on_smc10   ;
    output pwr1_off_smc10  ;
    output pwr2_off_smc10  ;
    // URT10
    output rstn_non_srpg_urt10 ;
    output gate_clk_urt10      ;
    output isolate_urt10       ;
    output save_edge_urt10   ;
    output restore_edge_urt10   ;
    output pwr1_on_urt10       ;
    output pwr2_on_urt10       ;
    output pwr1_off_urt10      ;
    output pwr2_off_urt10      ;
    // ETH010
    output rstn_non_srpg_macb010 ;
    output gate_clk_macb010      ;
    output isolate_macb010       ;
    output save_edge_macb010   ;
    output restore_edge_macb010   ;
    output pwr1_on_macb010       ;
    output pwr2_on_macb010       ;
    output pwr1_off_macb010      ;
    output pwr2_off_macb010      ;
    // ETH110
    output rstn_non_srpg_macb110 ;
    output gate_clk_macb110      ;
    output isolate_macb110       ;
    output save_edge_macb110   ;
    output restore_edge_macb110   ;
    output pwr1_on_macb110       ;
    output pwr2_on_macb110       ;
    output pwr1_off_macb110      ;
    output pwr2_off_macb110      ;
    // ETH210
    output rstn_non_srpg_macb210 ;
    output gate_clk_macb210      ;
    output isolate_macb210       ;
    output save_edge_macb210   ;
    output restore_edge_macb210   ;
    output pwr1_on_macb210       ;
    output pwr2_on_macb210       ;
    output pwr1_off_macb210      ;
    output pwr2_off_macb210      ;
    // ETH310
    output rstn_non_srpg_macb310 ;
    output gate_clk_macb310      ;
    output isolate_macb310       ;
    output save_edge_macb310   ;
    output restore_edge_macb310   ;
    output pwr1_on_macb310       ;
    output pwr2_on_macb310       ;
    output pwr1_off_macb310      ;
    output pwr2_off_macb310      ;
    // DMA10
    output rstn_non_srpg_dma10 ;
    output gate_clk_dma10      ;
    output isolate_dma10       ;
    output save_edge_dma10   ;
    output restore_edge_dma10   ;
    output pwr1_on_dma10       ;
    output pwr2_on_dma10       ;
    output pwr1_off_dma10      ;
    output pwr2_off_dma10      ;
    // CPU10
    output rstn_non_srpg_cpu10 ;
    output gate_clk_cpu10      ;
    output isolate_cpu10       ;
    output save_edge_cpu10   ;
    output restore_edge_cpu10   ;
    output pwr1_on_cpu10       ;
    output pwr2_on_cpu10       ;
    output pwr1_off_cpu10      ;
    output pwr2_off_cpu10      ;
    // ALUT10
    output rstn_non_srpg_alut10 ;
    output gate_clk_alut10      ;
    output isolate_alut10       ;
    output save_edge_alut10   ;
    output restore_edge_alut10   ;
    output pwr1_on_alut10       ;
    output pwr2_on_alut10       ;
    output pwr1_off_alut10      ;
    output pwr2_off_alut10      ;
    // MEM10
    output rstn_non_srpg_mem10 ;
    output gate_clk_mem10      ;
    output isolate_mem10       ;
    output save_edge_mem10   ;
    output restore_edge_mem10   ;
    output pwr1_on_mem10       ;
    output pwr2_on_mem10       ;
    output pwr1_off_mem10      ;
    output pwr2_off_mem10      ;


   // core10 transitions10 o/p
    output core06v10;
    output core08v10;
    output core10v10;
    output core12v10;
    output pcm_macb_wakeup_int10 ;
    //mode mte10  signals10
    output mte_smc_start10;
    output mte_uart_start10;
    output mte_smc_uart_start10;  
    output mte_pm_smc_to_default_start10; 
    output mte_pm_uart_to_default_start10;
    output mte_pm_smc_uart_to_default_start10;

    reg mte_smc_start10;
    reg mte_uart_start10;
    reg mte_smc_uart_start10;  
    reg mte_pm_smc_to_default_start10; 
    reg mte_pm_uart_to_default_start10;
    reg mte_pm_smc_uart_to_default_start10;

    reg [31:0] prdata10;

  wire valid_reg_write10  ;
  wire valid_reg_read10   ;
  wire L1_ctrl_access10   ;
  wire L1_status_access10 ;
  wire pcm_int_mask_access10;
  wire pcm_int_status_access10;
  wire standby_mem010      ;
  wire standby_mem110      ;
  wire standby_mem210      ;
  wire standby_mem310      ;
  wire pwr1_off_mem010;
  wire pwr1_off_mem110;
  wire pwr1_off_mem210;
  wire pwr1_off_mem310;
  
  // Control10 signals10
  wire set_status_smc10   ;
  wire clr_status_smc10   ;
  wire set_status_urt10   ;
  wire clr_status_urt10   ;
  wire set_status_macb010   ;
  wire clr_status_macb010   ;
  wire set_status_macb110   ;
  wire clr_status_macb110   ;
  wire set_status_macb210   ;
  wire clr_status_macb210   ;
  wire set_status_macb310   ;
  wire clr_status_macb310   ;
  wire set_status_dma10   ;
  wire clr_status_dma10   ;
  wire set_status_cpu10   ;
  wire clr_status_cpu10   ;
  wire set_status_alut10   ;
  wire clr_status_alut10   ;
  wire set_status_mem10   ;
  wire clr_status_mem10   ;


  // Status and Control10 registers
  reg [31:0]  L1_status_reg10;
  reg  [31:0] L1_ctrl_reg10  ;
  reg  [31:0] L1_ctrl_domain10  ;
  reg L1_ctrl_cpu_off_reg10;
  reg [31:0]  pcm_mask_reg10;
  reg [31:0]  pcm_status_reg10;

  // Signals10 gated10 in scan_mode10
  //SMC10
  wire  rstn_non_srpg_smc_int10;
  wire  gate_clk_smc_int10    ;     
  wire  isolate_smc_int10    ;       
  wire save_edge_smc_int10;
  wire restore_edge_smc_int10;
  wire  pwr1_on_smc_int10    ;      
  wire  pwr2_on_smc_int10    ;      


  //URT10
  wire   rstn_non_srpg_urt_int10;
  wire   gate_clk_urt_int10     ;     
  wire   isolate_urt_int10      ;       
  wire save_edge_urt_int10;
  wire restore_edge_urt_int10;
  wire   pwr1_on_urt_int10      ;      
  wire   pwr2_on_urt_int10      ;      

  // ETH010
  wire   rstn_non_srpg_macb0_int10;
  wire   gate_clk_macb0_int10     ;     
  wire   isolate_macb0_int10      ;       
  wire save_edge_macb0_int10;
  wire restore_edge_macb0_int10;
  wire   pwr1_on_macb0_int10      ;      
  wire   pwr2_on_macb0_int10      ;      
  // ETH110
  wire   rstn_non_srpg_macb1_int10;
  wire   gate_clk_macb1_int10     ;     
  wire   isolate_macb1_int10      ;       
  wire save_edge_macb1_int10;
  wire restore_edge_macb1_int10;
  wire   pwr1_on_macb1_int10      ;      
  wire   pwr2_on_macb1_int10      ;      
  // ETH210
  wire   rstn_non_srpg_macb2_int10;
  wire   gate_clk_macb2_int10     ;     
  wire   isolate_macb2_int10      ;       
  wire save_edge_macb2_int10;
  wire restore_edge_macb2_int10;
  wire   pwr1_on_macb2_int10      ;      
  wire   pwr2_on_macb2_int10      ;      
  // ETH310
  wire   rstn_non_srpg_macb3_int10;
  wire   gate_clk_macb3_int10     ;     
  wire   isolate_macb3_int10      ;       
  wire save_edge_macb3_int10;
  wire restore_edge_macb3_int10;
  wire   pwr1_on_macb3_int10      ;      
  wire   pwr2_on_macb3_int10      ;      

  // DMA10
  wire   rstn_non_srpg_dma_int10;
  wire   gate_clk_dma_int10     ;     
  wire   isolate_dma_int10      ;       
  wire save_edge_dma_int10;
  wire restore_edge_dma_int10;
  wire   pwr1_on_dma_int10      ;      
  wire   pwr2_on_dma_int10      ;      

  // CPU10
  wire   rstn_non_srpg_cpu_int10;
  wire   gate_clk_cpu_int10     ;     
  wire   isolate_cpu_int10      ;       
  wire save_edge_cpu_int10;
  wire restore_edge_cpu_int10;
  wire   pwr1_on_cpu_int10      ;      
  wire   pwr2_on_cpu_int10      ;  
  wire L1_ctrl_cpu_off_p10;    

  reg save_alut_tmp10;
  // DFS10 sm10

  reg cpu_shutoff_ctrl10;

  reg mte_mac_off_start10, mte_mac012_start10, mte_mac013_start10, mte_mac023_start10, mte_mac123_start10;
  reg mte_mac01_start10, mte_mac02_start10, mte_mac03_start10, mte_mac12_start10, mte_mac13_start10, mte_mac23_start10;
  reg mte_mac0_start10, mte_mac1_start10, mte_mac2_start10, mte_mac3_start10;
  reg mte_sys_hibernate10 ;
  reg mte_dma_start10 ;
  reg mte_cpu_start10 ;
  reg mte_mac_off_sleep_start10, mte_mac012_sleep_start10, mte_mac013_sleep_start10, mte_mac023_sleep_start10, mte_mac123_sleep_start10;
  reg mte_mac01_sleep_start10, mte_mac02_sleep_start10, mte_mac03_sleep_start10, mte_mac12_sleep_start10, mte_mac13_sleep_start10, mte_mac23_sleep_start10;
  reg mte_mac0_sleep_start10, mte_mac1_sleep_start10, mte_mac2_sleep_start10, mte_mac3_sleep_start10;
  reg mte_dma_sleep_start10;
  reg mte_mac_off_to_default10, mte_mac012_to_default10, mte_mac013_to_default10, mte_mac023_to_default10, mte_mac123_to_default10;
  reg mte_mac01_to_default10, mte_mac02_to_default10, mte_mac03_to_default10, mte_mac12_to_default10, mte_mac13_to_default10, mte_mac23_to_default10;
  reg mte_mac0_to_default10, mte_mac1_to_default10, mte_mac2_to_default10, mte_mac3_to_default10;
  reg mte_dma_isolate_dis10;
  reg mte_cpu_isolate_dis10;
  reg mte_sys_hibernate_to_default10;


  // Latch10 the CPU10 SLEEP10 invocation10
  always @( posedge pclk10 or negedge nprst10) 
  begin
    if(!nprst10)
      L1_ctrl_cpu_off_reg10 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg10 <= L1_ctrl_domain10[8];
  end

  // Create10 a pulse10 for sleep10 detection10 
  assign L1_ctrl_cpu_off_p10 =  L1_ctrl_domain10[8] && !L1_ctrl_cpu_off_reg10;
  
  // CPU10 sleep10 contol10 logic 
  // Shut10 off10 CPU10 when L1_ctrl_cpu_off_p10 is set
  // wake10 cpu10 when any interrupt10 is seen10  
  always @( posedge pclk10 or negedge nprst10) 
  begin
    if(!nprst10)
     cpu_shutoff_ctrl10 <= 1'b0;
    else if(cpu_shutoff_ctrl10 && int_source_h10)
     cpu_shutoff_ctrl10 <= 1'b0;
    else if (L1_ctrl_cpu_off_p10)
     cpu_shutoff_ctrl10 <= 1'b1;
  end
 
  // instantiate10 power10 contol10  block for uart10
  power_ctrl_sm10 i_urt_power_ctrl_sm10(
    .pclk10(pclk10),
    .nprst10(nprst10),
    .L1_module_req10(L1_ctrl_domain10[1]),
    .set_status_module10(set_status_urt10),
    .clr_status_module10(clr_status_urt10),
    .rstn_non_srpg_module10(rstn_non_srpg_urt_int10),
    .gate_clk_module10(gate_clk_urt_int10),
    .isolate_module10(isolate_urt_int10),
    .save_edge10(save_edge_urt_int10),
    .restore_edge10(restore_edge_urt_int10),
    .pwr1_on10(pwr1_on_urt_int10),
    .pwr2_on10(pwr2_on_urt_int10)
    );
  

  // instantiate10 power10 contol10  block for smc10
  power_ctrl_sm10 i_smc_power_ctrl_sm10(
    .pclk10(pclk10),
    .nprst10(nprst10),
    .L1_module_req10(L1_ctrl_domain10[2]),
    .set_status_module10(set_status_smc10),
    .clr_status_module10(clr_status_smc10),
    .rstn_non_srpg_module10(rstn_non_srpg_smc_int10),
    .gate_clk_module10(gate_clk_smc_int10),
    .isolate_module10(isolate_smc_int10),
    .save_edge10(save_edge_smc_int10),
    .restore_edge10(restore_edge_smc_int10),
    .pwr1_on10(pwr1_on_smc_int10),
    .pwr2_on10(pwr2_on_smc_int10)
    );

  // power10 control10 for macb010
  power_ctrl_sm10 i_macb0_power_ctrl_sm10(
    .pclk10(pclk10),
    .nprst10(nprst10),
    .L1_module_req10(L1_ctrl_domain10[3]),
    .set_status_module10(set_status_macb010),
    .clr_status_module10(clr_status_macb010),
    .rstn_non_srpg_module10(rstn_non_srpg_macb0_int10),
    .gate_clk_module10(gate_clk_macb0_int10),
    .isolate_module10(isolate_macb0_int10),
    .save_edge10(save_edge_macb0_int10),
    .restore_edge10(restore_edge_macb0_int10),
    .pwr1_on10(pwr1_on_macb0_int10),
    .pwr2_on10(pwr2_on_macb0_int10)
    );
  // power10 control10 for macb110
  power_ctrl_sm10 i_macb1_power_ctrl_sm10(
    .pclk10(pclk10),
    .nprst10(nprst10),
    .L1_module_req10(L1_ctrl_domain10[4]),
    .set_status_module10(set_status_macb110),
    .clr_status_module10(clr_status_macb110),
    .rstn_non_srpg_module10(rstn_non_srpg_macb1_int10),
    .gate_clk_module10(gate_clk_macb1_int10),
    .isolate_module10(isolate_macb1_int10),
    .save_edge10(save_edge_macb1_int10),
    .restore_edge10(restore_edge_macb1_int10),
    .pwr1_on10(pwr1_on_macb1_int10),
    .pwr2_on10(pwr2_on_macb1_int10)
    );
  // power10 control10 for macb210
  power_ctrl_sm10 i_macb2_power_ctrl_sm10(
    .pclk10(pclk10),
    .nprst10(nprst10),
    .L1_module_req10(L1_ctrl_domain10[5]),
    .set_status_module10(set_status_macb210),
    .clr_status_module10(clr_status_macb210),
    .rstn_non_srpg_module10(rstn_non_srpg_macb2_int10),
    .gate_clk_module10(gate_clk_macb2_int10),
    .isolate_module10(isolate_macb2_int10),
    .save_edge10(save_edge_macb2_int10),
    .restore_edge10(restore_edge_macb2_int10),
    .pwr1_on10(pwr1_on_macb2_int10),
    .pwr2_on10(pwr2_on_macb2_int10)
    );
  // power10 control10 for macb310
  power_ctrl_sm10 i_macb3_power_ctrl_sm10(
    .pclk10(pclk10),
    .nprst10(nprst10),
    .L1_module_req10(L1_ctrl_domain10[6]),
    .set_status_module10(set_status_macb310),
    .clr_status_module10(clr_status_macb310),
    .rstn_non_srpg_module10(rstn_non_srpg_macb3_int10),
    .gate_clk_module10(gate_clk_macb3_int10),
    .isolate_module10(isolate_macb3_int10),
    .save_edge10(save_edge_macb3_int10),
    .restore_edge10(restore_edge_macb3_int10),
    .pwr1_on10(pwr1_on_macb3_int10),
    .pwr2_on10(pwr2_on_macb3_int10)
    );
  // power10 control10 for dma10
  power_ctrl_sm10 i_dma_power_ctrl_sm10(
    .pclk10(pclk10),
    .nprst10(nprst10),
    .L1_module_req10(L1_ctrl_domain10[7]),
    .set_status_module10(set_status_dma10),
    .clr_status_module10(clr_status_dma10),
    .rstn_non_srpg_module10(rstn_non_srpg_dma_int10),
    .gate_clk_module10(gate_clk_dma_int10),
    .isolate_module10(isolate_dma_int10),
    .save_edge10(save_edge_dma_int10),
    .restore_edge10(restore_edge_dma_int10),
    .pwr1_on10(pwr1_on_dma_int10),
    .pwr2_on10(pwr2_on_dma_int10)
    );
  // power10 control10 for CPU10
  power_ctrl_sm10 i_cpu_power_ctrl_sm10(
    .pclk10(pclk10),
    .nprst10(nprst10),
    .L1_module_req10(cpu_shutoff_ctrl10),
    .set_status_module10(set_status_cpu10),
    .clr_status_module10(clr_status_cpu10),
    .rstn_non_srpg_module10(rstn_non_srpg_cpu_int10),
    .gate_clk_module10(gate_clk_cpu_int10),
    .isolate_module10(isolate_cpu_int10),
    .save_edge10(save_edge_cpu_int10),
    .restore_edge10(restore_edge_cpu_int10),
    .pwr1_on10(pwr1_on_cpu_int10),
    .pwr2_on10(pwr2_on_cpu_int10)
    );

  assign valid_reg_write10 =  (psel10 && pwrite10 && penable10);
  assign valid_reg_read10  =  (psel10 && (!pwrite10) && penable10);

  assign L1_ctrl_access10  =  (paddr10[15:0] == 16'b0000000000000100); 
  assign L1_status_access10 = (paddr10[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access10 =   (paddr10[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access10 = (paddr10[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control10 and status register
  always @(*)
  begin  
    if(valid_reg_read10 && L1_ctrl_access10) 
      prdata10 = L1_ctrl_reg10;
    else if (valid_reg_read10 && L1_status_access10)
      prdata10 = L1_status_reg10;
    else if (valid_reg_read10 && pcm_int_mask_access10)
      prdata10 = pcm_mask_reg10;
    else if (valid_reg_read10 && pcm_int_status_access10)
      prdata10 = pcm_status_reg10;
    else 
      prdata10 = 0;
  end

  assign set_status_mem10 =  (set_status_macb010 && set_status_macb110 && set_status_macb210 &&
                            set_status_macb310 && set_status_dma10 && set_status_cpu10);

  assign clr_status_mem10 =  (clr_status_macb010 && clr_status_macb110 && clr_status_macb210 &&
                            clr_status_macb310 && clr_status_dma10 && clr_status_cpu10);

  assign set_status_alut10 = (set_status_macb010 && set_status_macb110 && set_status_macb210 && set_status_macb310);

  assign clr_status_alut10 = (clr_status_macb010 || clr_status_macb110 || clr_status_macb210  || clr_status_macb310);

  // Write accesses to the control10 and status register
 
  always @(posedge pclk10 or negedge nprst10)
  begin
    if (!nprst10) begin
      L1_ctrl_reg10   <= 0;
      L1_status_reg10 <= 0;
      pcm_mask_reg10 <= 0;
    end else begin
      // CTRL10 reg updates10
      if (valid_reg_write10 && L1_ctrl_access10) 
        L1_ctrl_reg10 <= pwdata10; // Writes10 to the ctrl10 reg
      if (valid_reg_write10 && pcm_int_mask_access10) 
        pcm_mask_reg10 <= pwdata10; // Writes10 to the ctrl10 reg

      if (set_status_urt10 == 1'b1)  
        L1_status_reg10[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt10 == 1'b1) 
        L1_status_reg10[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc10 == 1'b1) 
        L1_status_reg10[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc10 == 1'b1) 
        L1_status_reg10[2] <= 1'b0; // Clear the status bit

      if (set_status_macb010 == 1'b1)  
        L1_status_reg10[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb010 == 1'b1) 
        L1_status_reg10[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb110 == 1'b1)  
        L1_status_reg10[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb110 == 1'b1) 
        L1_status_reg10[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb210 == 1'b1)  
        L1_status_reg10[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb210 == 1'b1) 
        L1_status_reg10[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb310 == 1'b1)  
        L1_status_reg10[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb310 == 1'b1) 
        L1_status_reg10[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma10 == 1'b1)  
        L1_status_reg10[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma10 == 1'b1) 
        L1_status_reg10[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu10 == 1'b1)  
        L1_status_reg10[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu10 == 1'b1) 
        L1_status_reg10[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut10 == 1'b1)  
        L1_status_reg10[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut10 == 1'b1) 
        L1_status_reg10[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem10 == 1'b1)  
        L1_status_reg10[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem10 == 1'b1) 
        L1_status_reg10[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused10 bits of pcm_status_reg10 are tied10 to 0
  always @(posedge pclk10 or negedge nprst10)
  begin
    if (!nprst10)
      pcm_status_reg10[31:4] <= 'b0;
    else  
      pcm_status_reg10[31:4] <= pcm_status_reg10[31:4];
  end
  
  // interrupt10 only of h/w assisted10 wakeup
  // MAC10 3
  always @(posedge pclk10 or negedge nprst10)
  begin
    if(!nprst10)
      pcm_status_reg10[3] <= 1'b0;
    else if (valid_reg_write10 && pcm_int_status_access10) 
      pcm_status_reg10[3] <= pwdata10[3];
    else if (macb3_wakeup10 & ~pcm_mask_reg10[3])
      pcm_status_reg10[3] <= 1'b1;
    else if (valid_reg_read10 && pcm_int_status_access10) 
      pcm_status_reg10[3] <= 1'b0;
    else
      pcm_status_reg10[3] <= pcm_status_reg10[3];
  end  
   
  // MAC10 2
  always @(posedge pclk10 or negedge nprst10)
  begin
    if(!nprst10)
      pcm_status_reg10[2] <= 1'b0;
    else if (valid_reg_write10 && pcm_int_status_access10) 
      pcm_status_reg10[2] <= pwdata10[2];
    else if (macb2_wakeup10 & ~pcm_mask_reg10[2])
      pcm_status_reg10[2] <= 1'b1;
    else if (valid_reg_read10 && pcm_int_status_access10) 
      pcm_status_reg10[2] <= 1'b0;
    else
      pcm_status_reg10[2] <= pcm_status_reg10[2];
  end  

  // MAC10 1
  always @(posedge pclk10 or negedge nprst10)
  begin
    if(!nprst10)
      pcm_status_reg10[1] <= 1'b0;
    else if (valid_reg_write10 && pcm_int_status_access10) 
      pcm_status_reg10[1] <= pwdata10[1];
    else if (macb1_wakeup10 & ~pcm_mask_reg10[1])
      pcm_status_reg10[1] <= 1'b1;
    else if (valid_reg_read10 && pcm_int_status_access10) 
      pcm_status_reg10[1] <= 1'b0;
    else
      pcm_status_reg10[1] <= pcm_status_reg10[1];
  end  
   
  // MAC10 0
  always @(posedge pclk10 or negedge nprst10)
  begin
    if(!nprst10)
      pcm_status_reg10[0] <= 1'b0;
    else if (valid_reg_write10 && pcm_int_status_access10) 
      pcm_status_reg10[0] <= pwdata10[0];
    else if (macb0_wakeup10 & ~pcm_mask_reg10[0])
      pcm_status_reg10[0] <= 1'b1;
    else if (valid_reg_read10 && pcm_int_status_access10) 
      pcm_status_reg10[0] <= 1'b0;
    else
      pcm_status_reg10[0] <= pcm_status_reg10[0];
  end  

  assign pcm_macb_wakeup_int10 = |pcm_status_reg10;

  reg [31:0] L1_ctrl_reg110;
  always @(posedge pclk10 or negedge nprst10)
  begin
    if(!nprst10)
      L1_ctrl_reg110 <= 0;
    else
      L1_ctrl_reg110 <= L1_ctrl_reg10;
  end

  // Program10 mode decode
  always @(L1_ctrl_reg10 or L1_ctrl_reg110 or int_source_h10 or cpu_shutoff_ctrl10) begin
    mte_smc_start10 = 0;
    mte_uart_start10 = 0;
    mte_smc_uart_start10  = 0;
    mte_mac_off_start10  = 0;
    mte_mac012_start10 = 0;
    mte_mac013_start10 = 0;
    mte_mac023_start10 = 0;
    mte_mac123_start10 = 0;
    mte_mac01_start10 = 0;
    mte_mac02_start10 = 0;
    mte_mac03_start10 = 0;
    mte_mac12_start10 = 0;
    mte_mac13_start10 = 0;
    mte_mac23_start10 = 0;
    mte_mac0_start10 = 0;
    mte_mac1_start10 = 0;
    mte_mac2_start10 = 0;
    mte_mac3_start10 = 0;
    mte_sys_hibernate10 = 0 ;
    mte_dma_start10 = 0 ;
    mte_cpu_start10 = 0 ;

    mte_mac0_sleep_start10 = (L1_ctrl_reg10 ==  'h14) && (L1_ctrl_reg110 == 'h4 );
    mte_mac1_sleep_start10 = (L1_ctrl_reg10 ==  'h14) && (L1_ctrl_reg110 == 'h5 ); 
    mte_mac2_sleep_start10 = (L1_ctrl_reg10 ==  'h14) && (L1_ctrl_reg110 == 'h6 ); 
    mte_mac3_sleep_start10 = (L1_ctrl_reg10 ==  'h14) && (L1_ctrl_reg110 == 'h7 ); 
    mte_mac01_sleep_start10 = (L1_ctrl_reg10 ==  'h14) && (L1_ctrl_reg110 == 'h8 ); 
    mte_mac02_sleep_start10 = (L1_ctrl_reg10 ==  'h14) && (L1_ctrl_reg110 == 'h9 ); 
    mte_mac03_sleep_start10 = (L1_ctrl_reg10 ==  'h14) && (L1_ctrl_reg110 == 'hA ); 
    mte_mac12_sleep_start10 = (L1_ctrl_reg10 ==  'h14) && (L1_ctrl_reg110 == 'hB ); 
    mte_mac13_sleep_start10 = (L1_ctrl_reg10 ==  'h14) && (L1_ctrl_reg110 == 'hC ); 
    mte_mac23_sleep_start10 = (L1_ctrl_reg10 ==  'h14) && (L1_ctrl_reg110 == 'hD ); 
    mte_mac012_sleep_start10 = (L1_ctrl_reg10 ==  'h14) && (L1_ctrl_reg110 == 'hE ); 
    mte_mac013_sleep_start10 = (L1_ctrl_reg10 ==  'h14) && (L1_ctrl_reg110 == 'hF ); 
    mte_mac023_sleep_start10 = (L1_ctrl_reg10 ==  'h14) && (L1_ctrl_reg110 == 'h10 ); 
    mte_mac123_sleep_start10 = (L1_ctrl_reg10 ==  'h14) && (L1_ctrl_reg110 == 'h11 ); 
    mte_mac_off_sleep_start10 =  (L1_ctrl_reg10 == 'h14) && (L1_ctrl_reg110 == 'h12 );
    mte_dma_sleep_start10 =  (L1_ctrl_reg10 == 'h14) && (L1_ctrl_reg110 == 'h13 );

    mte_pm_uart_to_default_start10 = (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'h1);
    mte_pm_smc_to_default_start10 = (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'h2);
    mte_pm_smc_uart_to_default_start10 = (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'h3); 
    mte_mac0_to_default10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'h4); 
    mte_mac1_to_default10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'h5); 
    mte_mac2_to_default10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'h6); 
    mte_mac3_to_default10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'h7); 
    mte_mac01_to_default10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'h8); 
    mte_mac02_to_default10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'h9); 
    mte_mac03_to_default10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'hA); 
    mte_mac12_to_default10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'hB); 
    mte_mac13_to_default10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'hC); 
    mte_mac23_to_default10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'hD); 
    mte_mac012_to_default10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'hE); 
    mte_mac013_to_default10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'hF); 
    mte_mac023_to_default10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'h10); 
    mte_mac123_to_default10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'h11); 
    mte_mac_off_to_default10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'h12); 
    mte_dma_isolate_dis10 =  (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'h13); 
    mte_cpu_isolate_dis10 =  (int_source_h10) && (cpu_shutoff_ctrl10) && (L1_ctrl_reg10 != 'h15);
    mte_sys_hibernate_to_default10 = (L1_ctrl_reg10 == 32'h0) && (L1_ctrl_reg110 == 'h15); 

   
    if (L1_ctrl_reg110 == 'h0) begin // This10 check is to make mte_cpu_start10
                                   // is set only when you from default state 
      case (L1_ctrl_reg10)
        'h0 : L1_ctrl_domain10 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain10 = 32'h2; // PM_uart10
                mte_uart_start10 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain10 = 32'h4; // PM_smc10
                mte_smc_start10 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain10 = 32'h6; // PM_smc_uart10
                mte_smc_uart_start10 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain10 = 32'h8; //  PM_macb010
                mte_mac0_start10 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain10 = 32'h10; //  PM_macb110
                mte_mac1_start10 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain10 = 32'h20; //  PM_macb210
                mte_mac2_start10 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain10 = 32'h40; //  PM_macb310
                mte_mac3_start10 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain10 = 32'h18; //  PM_macb0110
                mte_mac01_start10 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain10 = 32'h28; //  PM_macb0210
                mte_mac02_start10 = 1;
              end
        'hA : begin  
                L1_ctrl_domain10 = 32'h48; //  PM_macb0310
                mte_mac03_start10 = 1;
              end
        'hB : begin  
                L1_ctrl_domain10 = 32'h30; //  PM_macb1210
                mte_mac12_start10 = 1;
              end
        'hC : begin  
                L1_ctrl_domain10 = 32'h50; //  PM_macb1310
                mte_mac13_start10 = 1;
              end
        'hD : begin  
                L1_ctrl_domain10 = 32'h60; //  PM_macb2310
                mte_mac23_start10 = 1;
              end
        'hE : begin  
                L1_ctrl_domain10 = 32'h38; //  PM_macb01210
                mte_mac012_start10 = 1;
              end
        'hF : begin  
                L1_ctrl_domain10 = 32'h58; //  PM_macb01310
                mte_mac013_start10 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain10 = 32'h68; //  PM_macb02310
                mte_mac023_start10 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain10 = 32'h70; //  PM_macb12310
                mte_mac123_start10 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain10 = 32'h78; //  PM_macb_off10
                mte_mac_off_start10 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain10 = 32'h80; //  PM_dma10
                mte_dma_start10 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain10 = 32'h100; //  PM_cpu_sleep10
                mte_cpu_start10 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain10 = 32'h1FE; //  PM_hibernate10
                mte_sys_hibernate10 = 1;
              end
         default: L1_ctrl_domain10 = 32'h0;
      endcase
    end
  end


  wire to_default10 = (L1_ctrl_reg10 == 0);

  // Scan10 mode gating10 of power10 and isolation10 control10 signals10
  //SMC10
  assign rstn_non_srpg_smc10  = (scan_mode10 == 1'b0) ? rstn_non_srpg_smc_int10 : 1'b1;  
  assign gate_clk_smc10       = (scan_mode10 == 1'b0) ? gate_clk_smc_int10 : 1'b0;     
  assign isolate_smc10        = (scan_mode10 == 1'b0) ? isolate_smc_int10 : 1'b0;      
  assign pwr1_on_smc10        = (scan_mode10 == 1'b0) ? pwr1_on_smc_int10 : 1'b1;       
  assign pwr2_on_smc10        = (scan_mode10 == 1'b0) ? pwr2_on_smc_int10 : 1'b1;       
  assign pwr1_off_smc10       = (scan_mode10 == 1'b0) ? (!pwr1_on_smc_int10) : 1'b0;       
  assign pwr2_off_smc10       = (scan_mode10 == 1'b0) ? (!pwr2_on_smc_int10) : 1'b0;       
  assign save_edge_smc10       = (scan_mode10 == 1'b0) ? (save_edge_smc_int10) : 1'b0;       
  assign restore_edge_smc10       = (scan_mode10 == 1'b0) ? (restore_edge_smc_int10) : 1'b0;       

  //URT10
  assign rstn_non_srpg_urt10  = (scan_mode10 == 1'b0) ?  rstn_non_srpg_urt_int10 : 1'b1;  
  assign gate_clk_urt10       = (scan_mode10 == 1'b0) ?  gate_clk_urt_int10      : 1'b0;     
  assign isolate_urt10        = (scan_mode10 == 1'b0) ?  isolate_urt_int10       : 1'b0;      
  assign pwr1_on_urt10        = (scan_mode10 == 1'b0) ?  pwr1_on_urt_int10       : 1'b1;       
  assign pwr2_on_urt10        = (scan_mode10 == 1'b0) ?  pwr2_on_urt_int10       : 1'b1;       
  assign pwr1_off_urt10       = (scan_mode10 == 1'b0) ?  (!pwr1_on_urt_int10)  : 1'b0;       
  assign pwr2_off_urt10       = (scan_mode10 == 1'b0) ?  (!pwr2_on_urt_int10)  : 1'b0;       
  assign save_edge_urt10       = (scan_mode10 == 1'b0) ? (save_edge_urt_int10) : 1'b0;       
  assign restore_edge_urt10       = (scan_mode10 == 1'b0) ? (restore_edge_urt_int10) : 1'b0;       

  //ETH010
  assign rstn_non_srpg_macb010 = (scan_mode10 == 1'b0) ?  rstn_non_srpg_macb0_int10 : 1'b1;  
  assign gate_clk_macb010       = (scan_mode10 == 1'b0) ?  gate_clk_macb0_int10      : 1'b0;     
  assign isolate_macb010        = (scan_mode10 == 1'b0) ?  isolate_macb0_int10       : 1'b0;      
  assign pwr1_on_macb010        = (scan_mode10 == 1'b0) ?  pwr1_on_macb0_int10       : 1'b1;       
  assign pwr2_on_macb010        = (scan_mode10 == 1'b0) ?  pwr2_on_macb0_int10       : 1'b1;       
  assign pwr1_off_macb010       = (scan_mode10 == 1'b0) ?  (!pwr1_on_macb0_int10)  : 1'b0;       
  assign pwr2_off_macb010       = (scan_mode10 == 1'b0) ?  (!pwr2_on_macb0_int10)  : 1'b0;       
  assign save_edge_macb010       = (scan_mode10 == 1'b0) ? (save_edge_macb0_int10) : 1'b0;       
  assign restore_edge_macb010       = (scan_mode10 == 1'b0) ? (restore_edge_macb0_int10) : 1'b0;       

  //ETH110
  assign rstn_non_srpg_macb110 = (scan_mode10 == 1'b0) ?  rstn_non_srpg_macb1_int10 : 1'b1;  
  assign gate_clk_macb110       = (scan_mode10 == 1'b0) ?  gate_clk_macb1_int10      : 1'b0;     
  assign isolate_macb110        = (scan_mode10 == 1'b0) ?  isolate_macb1_int10       : 1'b0;      
  assign pwr1_on_macb110        = (scan_mode10 == 1'b0) ?  pwr1_on_macb1_int10       : 1'b1;       
  assign pwr2_on_macb110        = (scan_mode10 == 1'b0) ?  pwr2_on_macb1_int10       : 1'b1;       
  assign pwr1_off_macb110       = (scan_mode10 == 1'b0) ?  (!pwr1_on_macb1_int10)  : 1'b0;       
  assign pwr2_off_macb110       = (scan_mode10 == 1'b0) ?  (!pwr2_on_macb1_int10)  : 1'b0;       
  assign save_edge_macb110       = (scan_mode10 == 1'b0) ? (save_edge_macb1_int10) : 1'b0;       
  assign restore_edge_macb110       = (scan_mode10 == 1'b0) ? (restore_edge_macb1_int10) : 1'b0;       

  //ETH210
  assign rstn_non_srpg_macb210 = (scan_mode10 == 1'b0) ?  rstn_non_srpg_macb2_int10 : 1'b1;  
  assign gate_clk_macb210       = (scan_mode10 == 1'b0) ?  gate_clk_macb2_int10      : 1'b0;     
  assign isolate_macb210        = (scan_mode10 == 1'b0) ?  isolate_macb2_int10       : 1'b0;      
  assign pwr1_on_macb210        = (scan_mode10 == 1'b0) ?  pwr1_on_macb2_int10       : 1'b1;       
  assign pwr2_on_macb210        = (scan_mode10 == 1'b0) ?  pwr2_on_macb2_int10       : 1'b1;       
  assign pwr1_off_macb210       = (scan_mode10 == 1'b0) ?  (!pwr1_on_macb2_int10)  : 1'b0;       
  assign pwr2_off_macb210       = (scan_mode10 == 1'b0) ?  (!pwr2_on_macb2_int10)  : 1'b0;       
  assign save_edge_macb210       = (scan_mode10 == 1'b0) ? (save_edge_macb2_int10) : 1'b0;       
  assign restore_edge_macb210       = (scan_mode10 == 1'b0) ? (restore_edge_macb2_int10) : 1'b0;       

  //ETH310
  assign rstn_non_srpg_macb310 = (scan_mode10 == 1'b0) ?  rstn_non_srpg_macb3_int10 : 1'b1;  
  assign gate_clk_macb310       = (scan_mode10 == 1'b0) ?  gate_clk_macb3_int10      : 1'b0;     
  assign isolate_macb310        = (scan_mode10 == 1'b0) ?  isolate_macb3_int10       : 1'b0;      
  assign pwr1_on_macb310        = (scan_mode10 == 1'b0) ?  pwr1_on_macb3_int10       : 1'b1;       
  assign pwr2_on_macb310        = (scan_mode10 == 1'b0) ?  pwr2_on_macb3_int10       : 1'b1;       
  assign pwr1_off_macb310       = (scan_mode10 == 1'b0) ?  (!pwr1_on_macb3_int10)  : 1'b0;       
  assign pwr2_off_macb310       = (scan_mode10 == 1'b0) ?  (!pwr2_on_macb3_int10)  : 1'b0;       
  assign save_edge_macb310       = (scan_mode10 == 1'b0) ? (save_edge_macb3_int10) : 1'b0;       
  assign restore_edge_macb310       = (scan_mode10 == 1'b0) ? (restore_edge_macb3_int10) : 1'b0;       

  // MEM10
  assign rstn_non_srpg_mem10 =   (rstn_non_srpg_macb010 && rstn_non_srpg_macb110 && rstn_non_srpg_macb210 &&
                                rstn_non_srpg_macb310 && rstn_non_srpg_dma10 && rstn_non_srpg_cpu10 && rstn_non_srpg_urt10 &&
                                rstn_non_srpg_smc10);

  assign gate_clk_mem10 =  (gate_clk_macb010 && gate_clk_macb110 && gate_clk_macb210 &&
                            gate_clk_macb310 && gate_clk_dma10 && gate_clk_cpu10 && gate_clk_urt10 && gate_clk_smc10);

  assign isolate_mem10  = (isolate_macb010 && isolate_macb110 && isolate_macb210 &&
                         isolate_macb310 && isolate_dma10 && isolate_cpu10 && isolate_urt10 && isolate_smc10);


  assign pwr1_on_mem10        =   ~pwr1_off_mem10;

  assign pwr2_on_mem10        =   ~pwr2_off_mem10;

  assign pwr1_off_mem10       =  (pwr1_off_macb010 && pwr1_off_macb110 && pwr1_off_macb210 &&
                                 pwr1_off_macb310 && pwr1_off_dma10 && pwr1_off_cpu10 && pwr1_off_urt10 && pwr1_off_smc10);


  assign pwr2_off_mem10       =  (pwr2_off_macb010 && pwr2_off_macb110 && pwr2_off_macb210 &&
                                pwr2_off_macb310 && pwr2_off_dma10 && pwr2_off_cpu10 && pwr2_off_urt10 && pwr2_off_smc10);

  assign save_edge_mem10      =  (save_edge_macb010 && save_edge_macb110 && save_edge_macb210 &&
                                save_edge_macb310 && save_edge_dma10 && save_edge_cpu10 && save_edge_smc10 && save_edge_urt10);

  assign restore_edge_mem10   =  (restore_edge_macb010 && restore_edge_macb110 && restore_edge_macb210  &&
                                restore_edge_macb310 && restore_edge_dma10 && restore_edge_cpu10 && restore_edge_urt10 &&
                                restore_edge_smc10);

  assign standby_mem010 = pwr1_off_macb010 && (~ (pwr1_off_macb010 && pwr1_off_macb110 && pwr1_off_macb210 && pwr1_off_macb310 && pwr1_off_urt10 && pwr1_off_smc10 && pwr1_off_dma10 && pwr1_off_cpu10));
  assign standby_mem110 = pwr1_off_macb110 && (~ (pwr1_off_macb010 && pwr1_off_macb110 && pwr1_off_macb210 && pwr1_off_macb310 && pwr1_off_urt10 && pwr1_off_smc10 && pwr1_off_dma10 && pwr1_off_cpu10));
  assign standby_mem210 = pwr1_off_macb210 && (~ (pwr1_off_macb010 && pwr1_off_macb110 && pwr1_off_macb210 && pwr1_off_macb310 && pwr1_off_urt10 && pwr1_off_smc10 && pwr1_off_dma10 && pwr1_off_cpu10));
  assign standby_mem310 = pwr1_off_macb310 && (~ (pwr1_off_macb010 && pwr1_off_macb110 && pwr1_off_macb210 && pwr1_off_macb310 && pwr1_off_urt10 && pwr1_off_smc10 && pwr1_off_dma10 && pwr1_off_cpu10));

  assign pwr1_off_mem010 = pwr1_off_mem10;
  assign pwr1_off_mem110 = pwr1_off_mem10;
  assign pwr1_off_mem210 = pwr1_off_mem10;
  assign pwr1_off_mem310 = pwr1_off_mem10;

  assign rstn_non_srpg_alut10  =  (rstn_non_srpg_macb010 && rstn_non_srpg_macb110 && rstn_non_srpg_macb210 && rstn_non_srpg_macb310);


   assign gate_clk_alut10       =  (gate_clk_macb010 && gate_clk_macb110 && gate_clk_macb210 && gate_clk_macb310);


    assign isolate_alut10        =  (isolate_macb010 && isolate_macb110 && isolate_macb210 && isolate_macb310);


    assign pwr1_on_alut10        =  (pwr1_on_macb010 || pwr1_on_macb110 || pwr1_on_macb210 || pwr1_on_macb310);


    assign pwr2_on_alut10        =  (pwr2_on_macb010 || pwr2_on_macb110 || pwr2_on_macb210 || pwr2_on_macb310);


    assign pwr1_off_alut10       =  (pwr1_off_macb010 && pwr1_off_macb110 && pwr1_off_macb210 && pwr1_off_macb310);


    assign pwr2_off_alut10       =  (pwr2_off_macb010 && pwr2_off_macb110 && pwr2_off_macb210 && pwr2_off_macb310);


    assign save_edge_alut10      =  (save_edge_macb010 && save_edge_macb110 && save_edge_macb210 && save_edge_macb310);


    assign restore_edge_alut10   =  (restore_edge_macb010 || restore_edge_macb110 || restore_edge_macb210 ||
                                   restore_edge_macb310) && save_alut_tmp10;

     // alut10 power10 off10 detection10
  always @(posedge pclk10 or negedge nprst10) begin
    if (!nprst10) 
       save_alut_tmp10 <= 0;
    else if (restore_edge_alut10)
       save_alut_tmp10 <= 0;
    else if (save_edge_alut10)
       save_alut_tmp10 <= 1;
  end

  //DMA10
  assign rstn_non_srpg_dma10 = (scan_mode10 == 1'b0) ?  rstn_non_srpg_dma_int10 : 1'b1;  
  assign gate_clk_dma10       = (scan_mode10 == 1'b0) ?  gate_clk_dma_int10      : 1'b0;     
  assign isolate_dma10        = (scan_mode10 == 1'b0) ?  isolate_dma_int10       : 1'b0;      
  assign pwr1_on_dma10        = (scan_mode10 == 1'b0) ?  pwr1_on_dma_int10       : 1'b1;       
  assign pwr2_on_dma10        = (scan_mode10 == 1'b0) ?  pwr2_on_dma_int10       : 1'b1;       
  assign pwr1_off_dma10       = (scan_mode10 == 1'b0) ?  (!pwr1_on_dma_int10)  : 1'b0;       
  assign pwr2_off_dma10       = (scan_mode10 == 1'b0) ?  (!pwr2_on_dma_int10)  : 1'b0;       
  assign save_edge_dma10       = (scan_mode10 == 1'b0) ? (save_edge_dma_int10) : 1'b0;       
  assign restore_edge_dma10       = (scan_mode10 == 1'b0) ? (restore_edge_dma_int10) : 1'b0;       

  //CPU10
  assign rstn_non_srpg_cpu10 = (scan_mode10 == 1'b0) ?  rstn_non_srpg_cpu_int10 : 1'b1;  
  assign gate_clk_cpu10       = (scan_mode10 == 1'b0) ?  gate_clk_cpu_int10      : 1'b0;     
  assign isolate_cpu10        = (scan_mode10 == 1'b0) ?  isolate_cpu_int10       : 1'b0;      
  assign pwr1_on_cpu10        = (scan_mode10 == 1'b0) ?  pwr1_on_cpu_int10       : 1'b1;       
  assign pwr2_on_cpu10        = (scan_mode10 == 1'b0) ?  pwr2_on_cpu_int10       : 1'b1;       
  assign pwr1_off_cpu10       = (scan_mode10 == 1'b0) ?  (!pwr1_on_cpu_int10)  : 1'b0;       
  assign pwr2_off_cpu10       = (scan_mode10 == 1'b0) ?  (!pwr2_on_cpu_int10)  : 1'b0;       
  assign save_edge_cpu10       = (scan_mode10 == 1'b0) ? (save_edge_cpu_int10) : 1'b0;       
  assign restore_edge_cpu10       = (scan_mode10 == 1'b0) ? (restore_edge_cpu_int10) : 1'b0;       



  // ASE10

   reg ase_core_12v10, ase_core_10v10, ase_core_08v10, ase_core_06v10;
   reg ase_macb0_12v10,ase_macb1_12v10,ase_macb2_12v10,ase_macb3_12v10;

    // core10 ase10

    // core10 at 1.0 v if (smc10 off10, urt10 off10, macb010 off10, macb110 off10, macb210 off10, macb310 off10
   // core10 at 0.8v if (mac01off10, macb02off10, macb03off10, macb12off10, mac13off10, mac23off10,
   // core10 at 0.6v if (mac012off10, mac013off10, mac023off10, mac123off10, mac0123off10
    // else core10 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb010 && pwr1_off_macb110 && pwr1_off_macb210 && pwr1_off_macb310) || // all mac10 off10
       (pwr1_off_macb310 && pwr1_off_macb210 && pwr1_off_macb110) || // mac123off10 
       (pwr1_off_macb310 && pwr1_off_macb210 && pwr1_off_macb010) || // mac023off10 
       (pwr1_off_macb310 && pwr1_off_macb110 && pwr1_off_macb010) || // mac013off10 
       (pwr1_off_macb210 && pwr1_off_macb110 && pwr1_off_macb010) )  // mac012off10 
       begin
         ase_core_12v10 = 0;
         ase_core_10v10 = 0;
         ase_core_08v10 = 0;
         ase_core_06v10 = 1;
       end
     else if( (pwr1_off_macb210 && pwr1_off_macb310) || // mac2310 off10
         (pwr1_off_macb310 && pwr1_off_macb110) || // mac13off10 
         (pwr1_off_macb110 && pwr1_off_macb210) || // mac12off10 
         (pwr1_off_macb310 && pwr1_off_macb010) || // mac03off10 
         (pwr1_off_macb210 && pwr1_off_macb010) || // mac02off10 
         (pwr1_off_macb110 && pwr1_off_macb010))  // mac01off10 
       begin
         ase_core_12v10 = 0;
         ase_core_10v10 = 0;
         ase_core_08v10 = 1;
         ase_core_06v10 = 0;
       end
     else if( (pwr1_off_smc10) || // smc10 off10
         (pwr1_off_macb010 ) || // mac0off10 
         (pwr1_off_macb110 ) || // mac1off10 
         (pwr1_off_macb210 ) || // mac2off10 
         (pwr1_off_macb310 ))  // mac3off10 
       begin
         ase_core_12v10 = 0;
         ase_core_10v10 = 1;
         ase_core_08v10 = 0;
         ase_core_06v10 = 0;
       end
     else if (pwr1_off_urt10)
       begin
         ase_core_12v10 = 1;
         ase_core_10v10 = 0;
         ase_core_08v10 = 0;
         ase_core_06v10 = 0;
       end
     else
       begin
         ase_core_12v10 = 1;
         ase_core_10v10 = 0;
         ase_core_08v10 = 0;
         ase_core_06v10 = 0;
       end
   end


   // cpu10
   // cpu10 @ 1.0v when macoff10, 
   // 
   reg ase_cpu_10v10, ase_cpu_12v10;
   always @(*) begin
    if(pwr1_off_cpu10) begin
     ase_cpu_12v10 = 1'b0;
     ase_cpu_10v10 = 1'b0;
    end
    else if(pwr1_off_macb010 || pwr1_off_macb110 || pwr1_off_macb210 || pwr1_off_macb310)
    begin
     ase_cpu_12v10 = 1'b0;
     ase_cpu_10v10 = 1'b1;
    end
    else
    begin
     ase_cpu_12v10 = 1'b1;
     ase_cpu_10v10 = 1'b0;
    end
   end

   // dma10
   // dma10 @v110.0 for macoff10, 

   reg ase_dma_10v10, ase_dma_12v10;
   always @(*) begin
    if(pwr1_off_dma10) begin
     ase_dma_12v10 = 1'b0;
     ase_dma_10v10 = 1'b0;
    end
    else if(pwr1_off_macb010 || pwr1_off_macb110 || pwr1_off_macb210 || pwr1_off_macb310)
    begin
     ase_dma_12v10 = 1'b0;
     ase_dma_10v10 = 1'b1;
    end
    else
    begin
     ase_dma_12v10 = 1'b1;
     ase_dma_10v10 = 1'b0;
    end
   end

   // alut10
   // @ v110.0 for macoff10

   reg ase_alut_10v10, ase_alut_12v10;
   always @(*) begin
    if(pwr1_off_alut10) begin
     ase_alut_12v10 = 1'b0;
     ase_alut_10v10 = 1'b0;
    end
    else if(pwr1_off_macb010 || pwr1_off_macb110 || pwr1_off_macb210 || pwr1_off_macb310)
    begin
     ase_alut_12v10 = 1'b0;
     ase_alut_10v10 = 1'b1;
    end
    else
    begin
     ase_alut_12v10 = 1'b1;
     ase_alut_10v10 = 1'b0;
    end
   end




   reg ase_uart_12v10;
   reg ase_uart_10v10;
   reg ase_uart_08v10;
   reg ase_uart_06v10;

   reg ase_smc_12v10;


   always @(*) begin
     if(pwr1_off_urt10) begin // uart10 off10
       ase_uart_08v10 = 1'b0;
       ase_uart_06v10 = 1'b0;
       ase_uart_10v10 = 1'b0;
       ase_uart_12v10 = 1'b0;
     end 
     else if( (pwr1_off_macb010 && pwr1_off_macb110 && pwr1_off_macb210 && pwr1_off_macb310) || // all mac10 off10
       (pwr1_off_macb310 && pwr1_off_macb210 && pwr1_off_macb110) || // mac123off10 
       (pwr1_off_macb310 && pwr1_off_macb210 && pwr1_off_macb010) || // mac023off10 
       (pwr1_off_macb310 && pwr1_off_macb110 && pwr1_off_macb010) || // mac013off10 
       (pwr1_off_macb210 && pwr1_off_macb110 && pwr1_off_macb010) )  // mac012off10 
     begin
       ase_uart_06v10 = 1'b1;
       ase_uart_08v10 = 1'b0;
       ase_uart_10v10 = 1'b0;
       ase_uart_12v10 = 1'b0;
     end
     else if( (pwr1_off_macb210 && pwr1_off_macb310) || // mac2310 off10
         (pwr1_off_macb310 && pwr1_off_macb110) || // mac13off10 
         (pwr1_off_macb110 && pwr1_off_macb210) || // mac12off10 
         (pwr1_off_macb310 && pwr1_off_macb010) || // mac03off10 
         (pwr1_off_macb110 && pwr1_off_macb010))  // mac01off10  
     begin
       ase_uart_06v10 = 1'b0;
       ase_uart_08v10 = 1'b1;
       ase_uart_10v10 = 1'b0;
       ase_uart_12v10 = 1'b0;
     end
     else if (pwr1_off_smc10 || pwr1_off_macb010 || pwr1_off_macb110 || pwr1_off_macb210 || pwr1_off_macb310) begin // smc10 off10
       ase_uart_08v10 = 1'b0;
       ase_uart_06v10 = 1'b0;
       ase_uart_10v10 = 1'b1;
       ase_uart_12v10 = 1'b0;
     end 
     else begin
       ase_uart_08v10 = 1'b0;
       ase_uart_06v10 = 1'b0;
       ase_uart_10v10 = 1'b0;
       ase_uart_12v10 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc10) begin
     if (pwr1_off_smc10)  // smc10 off10
       ase_smc_12v10 = 1'b0;
    else
       ase_smc_12v10 = 1'b1;
   end

   
   always @(pwr1_off_macb010) begin
     if (pwr1_off_macb010) // macb010 off10
       ase_macb0_12v10 = 1'b0;
     else
       ase_macb0_12v10 = 1'b1;
   end

   always @(pwr1_off_macb110) begin
     if (pwr1_off_macb110) // macb110 off10
       ase_macb1_12v10 = 1'b0;
     else
       ase_macb1_12v10 = 1'b1;
   end

   always @(pwr1_off_macb210) begin // macb210 off10
     if (pwr1_off_macb210) // macb210 off10
       ase_macb2_12v10 = 1'b0;
     else
       ase_macb2_12v10 = 1'b1;
   end

   always @(pwr1_off_macb310) begin // macb310 off10
     if (pwr1_off_macb310) // macb310 off10
       ase_macb3_12v10 = 1'b0;
     else
       ase_macb3_12v10 = 1'b1;
   end


   // core10 voltage10 for vco10
  assign core12v10 = ase_macb0_12v10 & ase_macb1_12v10 & ase_macb2_12v10 & ase_macb3_12v10;

  assign core10v10 =  (ase_macb0_12v10 & ase_macb1_12v10 & ase_macb2_12v10 & (!ase_macb3_12v10)) ||
                    (ase_macb0_12v10 & ase_macb1_12v10 & (!ase_macb2_12v10) & ase_macb3_12v10) ||
                    (ase_macb0_12v10 & (!ase_macb1_12v10) & ase_macb2_12v10 & ase_macb3_12v10) ||
                    ((!ase_macb0_12v10) & ase_macb1_12v10 & ase_macb2_12v10 & ase_macb3_12v10);

  assign core08v10 =  ((!ase_macb0_12v10) & (!ase_macb1_12v10) & (ase_macb2_12v10) & (ase_macb3_12v10)) ||
                    ((!ase_macb0_12v10) & (ase_macb1_12v10) & (!ase_macb2_12v10) & (ase_macb3_12v10)) ||
                    ((!ase_macb0_12v10) & (ase_macb1_12v10) & (ase_macb2_12v10) & (!ase_macb3_12v10)) ||
                    ((ase_macb0_12v10) & (!ase_macb1_12v10) & (!ase_macb2_12v10) & (ase_macb3_12v10)) ||
                    ((ase_macb0_12v10) & (!ase_macb1_12v10) & (ase_macb2_12v10) & (!ase_macb3_12v10)) ||
                    ((ase_macb0_12v10) & (ase_macb1_12v10) & (!ase_macb2_12v10) & (!ase_macb3_12v10));

  assign core06v10 =  ((!ase_macb0_12v10) & (!ase_macb1_12v10) & (!ase_macb2_12v10) & (ase_macb3_12v10)) ||
                    ((!ase_macb0_12v10) & (!ase_macb1_12v10) & (ase_macb2_12v10) & (!ase_macb3_12v10)) ||
                    ((!ase_macb0_12v10) & (ase_macb1_12v10) & (!ase_macb2_12v10) & (!ase_macb3_12v10)) ||
                    ((ase_macb0_12v10) & (!ase_macb1_12v10) & (!ase_macb2_12v10) & (!ase_macb3_12v10)) ||
                    ((!ase_macb0_12v10) & (!ase_macb1_12v10) & (!ase_macb2_12v10) & (!ase_macb3_12v10)) ;



`ifdef LP_ABV_ON10
// psl10 default clock10 = (posedge pclk10);

// Cover10 a condition in which SMC10 is powered10 down
// and again10 powered10 up while UART10 is going10 into POWER10 down
// state or UART10 is already in POWER10 DOWN10 state
// psl10 cover_overlapping_smc_urt_110:
//    cover{fell10(pwr1_on_urt10);[*];fell10(pwr1_on_smc10);[*];
//    rose10(pwr1_on_smc10);[*];rose10(pwr1_on_urt10)};
//
// Cover10 a condition in which UART10 is powered10 down
// and again10 powered10 up while SMC10 is going10 into POWER10 down
// state or SMC10 is already in POWER10 DOWN10 state
// psl10 cover_overlapping_smc_urt_210:
//    cover{fell10(pwr1_on_smc10);[*];fell10(pwr1_on_urt10);[*];
//    rose10(pwr1_on_urt10);[*];rose10(pwr1_on_smc10)};
//


// Power10 Down10 UART10
// This10 gets10 triggered on rising10 edge of Gate10 signal10 for
// UART10 (gate_clk_urt10). In a next cycle after gate_clk_urt10,
// Isolate10 UART10(isolate_urt10) signal10 become10 HIGH10 (active).
// In 2nd cycle after gate_clk_urt10 becomes HIGH10, RESET10 for NON10
// SRPG10 FFs10(rstn_non_srpg_urt10) and POWER110 for UART10(pwr1_on_urt10) should 
// go10 LOW10. 
// This10 completes10 a POWER10 DOWN10. 

sequence s_power_down_urt10;
      (gate_clk_urt10 & !isolate_urt10 & rstn_non_srpg_urt10 & pwr1_on_urt10) 
  ##1 (gate_clk_urt10 & isolate_urt10 & rstn_non_srpg_urt10 & pwr1_on_urt10) 
  ##3 (gate_clk_urt10 & isolate_urt10 & !rstn_non_srpg_urt10 & !pwr1_on_urt10);
endsequence


property p_power_down_urt10;
   @(posedge pclk10)
    $rose(gate_clk_urt10) |=> s_power_down_urt10;
endproperty

output_power_down_urt10:
  assert property (p_power_down_urt10);


// Power10 UP10 UART10
// Sequence starts with , Rising10 edge of pwr1_on_urt10.
// Two10 clock10 cycle after this, isolate_urt10 should become10 LOW10 
// On10 the following10 clk10 gate_clk_urt10 should go10 low10.
// 5 cycles10 after  Rising10 edge of pwr1_on_urt10, rstn_non_srpg_urt10
// should become10 HIGH10
sequence s_power_up_urt10;
##30 (pwr1_on_urt10 & !isolate_urt10 & gate_clk_urt10 & !rstn_non_srpg_urt10) 
##1 (pwr1_on_urt10 & !isolate_urt10 & !gate_clk_urt10 & !rstn_non_srpg_urt10) 
##2 (pwr1_on_urt10 & !isolate_urt10 & !gate_clk_urt10 & rstn_non_srpg_urt10);
endsequence

property p_power_up_urt10;
   @(posedge pclk10)
  disable iff(!nprst10)
    (!pwr1_on_urt10 ##1 pwr1_on_urt10) |=> s_power_up_urt10;
endproperty

output_power_up_urt10:
  assert property (p_power_up_urt10);


// Power10 Down10 SMC10
// This10 gets10 triggered on rising10 edge of Gate10 signal10 for
// SMC10 (gate_clk_smc10). In a next cycle after gate_clk_smc10,
// Isolate10 SMC10(isolate_smc10) signal10 become10 HIGH10 (active).
// In 2nd cycle after gate_clk_smc10 becomes HIGH10, RESET10 for NON10
// SRPG10 FFs10(rstn_non_srpg_smc10) and POWER110 for SMC10(pwr1_on_smc10) should 
// go10 LOW10. 
// This10 completes10 a POWER10 DOWN10. 

sequence s_power_down_smc10;
      (gate_clk_smc10 & !isolate_smc10 & rstn_non_srpg_smc10 & pwr1_on_smc10) 
  ##1 (gate_clk_smc10 & isolate_smc10 & rstn_non_srpg_smc10 & pwr1_on_smc10) 
  ##3 (gate_clk_smc10 & isolate_smc10 & !rstn_non_srpg_smc10 & !pwr1_on_smc10);
endsequence


property p_power_down_smc10;
   @(posedge pclk10)
    $rose(gate_clk_smc10) |=> s_power_down_smc10;
endproperty

output_power_down_smc10:
  assert property (p_power_down_smc10);


// Power10 UP10 SMC10
// Sequence starts with , Rising10 edge of pwr1_on_smc10.
// Two10 clock10 cycle after this, isolate_smc10 should become10 LOW10 
// On10 the following10 clk10 gate_clk_smc10 should go10 low10.
// 5 cycles10 after  Rising10 edge of pwr1_on_smc10, rstn_non_srpg_smc10
// should become10 HIGH10
sequence s_power_up_smc10;
##30 (pwr1_on_smc10 & !isolate_smc10 & gate_clk_smc10 & !rstn_non_srpg_smc10) 
##1 (pwr1_on_smc10 & !isolate_smc10 & !gate_clk_smc10 & !rstn_non_srpg_smc10) 
##2 (pwr1_on_smc10 & !isolate_smc10 & !gate_clk_smc10 & rstn_non_srpg_smc10);
endsequence

property p_power_up_smc10;
   @(posedge pclk10)
  disable iff(!nprst10)
    (!pwr1_on_smc10 ##1 pwr1_on_smc10) |=> s_power_up_smc10;
endproperty

output_power_up_smc10:
  assert property (p_power_up_smc10);


// COVER10 SMC10 POWER10 DOWN10 AND10 UP10
cover_power_down_up_smc10: cover property (@(posedge pclk10)
(s_power_down_smc10 ##[5:180] s_power_up_smc10));



// COVER10 UART10 POWER10 DOWN10 AND10 UP10
cover_power_down_up_urt10: cover property (@(posedge pclk10)
(s_power_down_urt10 ##[5:180] s_power_up_urt10));

cover_power_down_urt10: cover property (@(posedge pclk10)
(s_power_down_urt10));

cover_power_up_urt10: cover property (@(posedge pclk10)
(s_power_up_urt10));




`ifdef PCM_ABV_ON10
//------------------------------------------------------------------------------
// Power10 Controller10 Formal10 Verification10 component.  Each power10 domain has a 
// separate10 instantiation10
//------------------------------------------------------------------------------

// need to assume that CPU10 will leave10 a minimum time between powering10 down and 
// back up.  In this example10, 10clks has been selected.
// psl10 config_min_uart_pd_time10 : assume always {rose10(L1_ctrl_domain10[1])} |-> { L1_ctrl_domain10[1][*10] } abort10(~nprst10);
// psl10 config_min_uart_pu_time10 : assume always {fell10(L1_ctrl_domain10[1])} |-> { !L1_ctrl_domain10[1][*10] } abort10(~nprst10);
// psl10 config_min_smc_pd_time10 : assume always {rose10(L1_ctrl_domain10[2])} |-> { L1_ctrl_domain10[2][*10] } abort10(~nprst10);
// psl10 config_min_smc_pu_time10 : assume always {fell10(L1_ctrl_domain10[2])} |-> { !L1_ctrl_domain10[2][*10] } abort10(~nprst10);

// UART10 VCOMP10 parameters10
   defparam i_uart_vcomp_domain10.ENABLE_SAVE_RESTORE_EDGE10   = 1;
   defparam i_uart_vcomp_domain10.ENABLE_EXT_PWR_CNTRL10       = 1;
   defparam i_uart_vcomp_domain10.REF_CLK_DEFINED10            = 0;
   defparam i_uart_vcomp_domain10.MIN_SHUTOFF_CYCLES10         = 4;
   defparam i_uart_vcomp_domain10.MIN_RESTORE_TO_ISO_CYCLES10  = 0;
   defparam i_uart_vcomp_domain10.MIN_SAVE_TO_SHUTOFF_CYCLES10 = 1;


   vcomp_domain10 i_uart_vcomp_domain10
   ( .ref_clk10(pclk10),
     .start_lps10(L1_ctrl_domain10[1] || !rstn_non_srpg_urt10),
     .rst_n10(nprst10),
     .ext_power_down10(L1_ctrl_domain10[1]),
     .iso_en10(isolate_urt10),
     .save_edge10(save_edge_urt10),
     .restore_edge10(restore_edge_urt10),
     .domain_shut_off10(pwr1_off_urt10),
     .domain_clk10(!gate_clk_urt10 && pclk10)
   );


// SMC10 VCOMP10 parameters10
   defparam i_smc_vcomp_domain10.ENABLE_SAVE_RESTORE_EDGE10   = 1;
   defparam i_smc_vcomp_domain10.ENABLE_EXT_PWR_CNTRL10       = 1;
   defparam i_smc_vcomp_domain10.REF_CLK_DEFINED10            = 0;
   defparam i_smc_vcomp_domain10.MIN_SHUTOFF_CYCLES10         = 4;
   defparam i_smc_vcomp_domain10.MIN_RESTORE_TO_ISO_CYCLES10  = 0;
   defparam i_smc_vcomp_domain10.MIN_SAVE_TO_SHUTOFF_CYCLES10 = 1;


   vcomp_domain10 i_smc_vcomp_domain10
   ( .ref_clk10(pclk10),
     .start_lps10(L1_ctrl_domain10[2] || !rstn_non_srpg_smc10),
     .rst_n10(nprst10),
     .ext_power_down10(L1_ctrl_domain10[2]),
     .iso_en10(isolate_smc10),
     .save_edge10(save_edge_smc10),
     .restore_edge10(restore_edge_smc10),
     .domain_shut_off10(pwr1_off_smc10),
     .domain_clk10(!gate_clk_smc10 && pclk10)
   );

`endif

`endif



endmodule
