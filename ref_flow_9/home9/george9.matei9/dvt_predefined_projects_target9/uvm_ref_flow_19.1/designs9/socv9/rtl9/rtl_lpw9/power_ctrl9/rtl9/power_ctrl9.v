//File9 name   : power_ctrl9.v
//Title9       : Power9 Control9 Module9
//Created9     : 1999
//Description9 : Top9 level of power9 controller9
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

module power_ctrl9 (


    // Clocks9 & Reset9
    pclk9,
    nprst9,
    // APB9 programming9 interface
    paddr9,
    psel9,
    penable9,
    pwrite9,
    pwdata9,
    prdata9,
    // mac9 i/f,
    macb3_wakeup9,
    macb2_wakeup9,
    macb1_wakeup9,
    macb0_wakeup9,
    // Scan9 
    scan_in9,
    scan_en9,
    scan_mode9,
    scan_out9,
    // Module9 control9 outputs9
    int_source_h9,
    // SMC9
    rstn_non_srpg_smc9,
    gate_clk_smc9,
    isolate_smc9,
    save_edge_smc9,
    restore_edge_smc9,
    pwr1_on_smc9,
    pwr2_on_smc9,
    pwr1_off_smc9,
    pwr2_off_smc9,
    // URT9
    rstn_non_srpg_urt9,
    gate_clk_urt9,
    isolate_urt9,
    save_edge_urt9,
    restore_edge_urt9,
    pwr1_on_urt9,
    pwr2_on_urt9,
    pwr1_off_urt9,      
    pwr2_off_urt9,
    // ETH09
    rstn_non_srpg_macb09,
    gate_clk_macb09,
    isolate_macb09,
    save_edge_macb09,
    restore_edge_macb09,
    pwr1_on_macb09,
    pwr2_on_macb09,
    pwr1_off_macb09,      
    pwr2_off_macb09,
    // ETH19
    rstn_non_srpg_macb19,
    gate_clk_macb19,
    isolate_macb19,
    save_edge_macb19,
    restore_edge_macb19,
    pwr1_on_macb19,
    pwr2_on_macb19,
    pwr1_off_macb19,      
    pwr2_off_macb19,
    // ETH29
    rstn_non_srpg_macb29,
    gate_clk_macb29,
    isolate_macb29,
    save_edge_macb29,
    restore_edge_macb29,
    pwr1_on_macb29,
    pwr2_on_macb29,
    pwr1_off_macb29,      
    pwr2_off_macb29,
    // ETH39
    rstn_non_srpg_macb39,
    gate_clk_macb39,
    isolate_macb39,
    save_edge_macb39,
    restore_edge_macb39,
    pwr1_on_macb39,
    pwr2_on_macb39,
    pwr1_off_macb39,      
    pwr2_off_macb39,
    // DMA9
    rstn_non_srpg_dma9,
    gate_clk_dma9,
    isolate_dma9,
    save_edge_dma9,
    restore_edge_dma9,
    pwr1_on_dma9,
    pwr2_on_dma9,
    pwr1_off_dma9,      
    pwr2_off_dma9,
    // CPU9
    rstn_non_srpg_cpu9,
    gate_clk_cpu9,
    isolate_cpu9,
    save_edge_cpu9,
    restore_edge_cpu9,
    pwr1_on_cpu9,
    pwr2_on_cpu9,
    pwr1_off_cpu9,      
    pwr2_off_cpu9,
    // ALUT9
    rstn_non_srpg_alut9,
    gate_clk_alut9,
    isolate_alut9,
    save_edge_alut9,
    restore_edge_alut9,
    pwr1_on_alut9,
    pwr2_on_alut9,
    pwr1_off_alut9,      
    pwr2_off_alut9,
    // MEM9
    rstn_non_srpg_mem9,
    gate_clk_mem9,
    isolate_mem9,
    save_edge_mem9,
    restore_edge_mem9,
    pwr1_on_mem9,
    pwr2_on_mem9,
    pwr1_off_mem9,      
    pwr2_off_mem9,
    // core9 dvfs9 transitions9
    core06v9,
    core08v9,
    core10v9,
    core12v9,
    pcm_macb_wakeup_int9,
    // mte9 signals9
    mte_smc_start9,
    mte_uart_start9,
    mte_smc_uart_start9,  
    mte_pm_smc_to_default_start9, 
    mte_pm_uart_to_default_start9,
    mte_pm_smc_uart_to_default_start9

  );

  parameter STATE_IDLE_12V9 = 4'b0001;
  parameter STATE_06V9 = 4'b0010;
  parameter STATE_08V9 = 4'b0100;
  parameter STATE_10V9 = 4'b1000;

    // Clocks9 & Reset9
    input pclk9;
    input nprst9;
    // APB9 programming9 interface
    input [31:0] paddr9;
    input psel9  ;
    input penable9;
    input pwrite9 ;
    input [31:0] pwdata9;
    output [31:0] prdata9;
    // mac9
    input macb3_wakeup9;
    input macb2_wakeup9;
    input macb1_wakeup9;
    input macb0_wakeup9;
    // Scan9 
    input scan_in9;
    input scan_en9;
    input scan_mode9;
    output scan_out9;
    // Module9 control9 outputs9
    input int_source_h9;
    // SMC9
    output rstn_non_srpg_smc9 ;
    output gate_clk_smc9   ;
    output isolate_smc9   ;
    output save_edge_smc9   ;
    output restore_edge_smc9   ;
    output pwr1_on_smc9   ;
    output pwr2_on_smc9   ;
    output pwr1_off_smc9  ;
    output pwr2_off_smc9  ;
    // URT9
    output rstn_non_srpg_urt9 ;
    output gate_clk_urt9      ;
    output isolate_urt9       ;
    output save_edge_urt9   ;
    output restore_edge_urt9   ;
    output pwr1_on_urt9       ;
    output pwr2_on_urt9       ;
    output pwr1_off_urt9      ;
    output pwr2_off_urt9      ;
    // ETH09
    output rstn_non_srpg_macb09 ;
    output gate_clk_macb09      ;
    output isolate_macb09       ;
    output save_edge_macb09   ;
    output restore_edge_macb09   ;
    output pwr1_on_macb09       ;
    output pwr2_on_macb09       ;
    output pwr1_off_macb09      ;
    output pwr2_off_macb09      ;
    // ETH19
    output rstn_non_srpg_macb19 ;
    output gate_clk_macb19      ;
    output isolate_macb19       ;
    output save_edge_macb19   ;
    output restore_edge_macb19   ;
    output pwr1_on_macb19       ;
    output pwr2_on_macb19       ;
    output pwr1_off_macb19      ;
    output pwr2_off_macb19      ;
    // ETH29
    output rstn_non_srpg_macb29 ;
    output gate_clk_macb29      ;
    output isolate_macb29       ;
    output save_edge_macb29   ;
    output restore_edge_macb29   ;
    output pwr1_on_macb29       ;
    output pwr2_on_macb29       ;
    output pwr1_off_macb29      ;
    output pwr2_off_macb29      ;
    // ETH39
    output rstn_non_srpg_macb39 ;
    output gate_clk_macb39      ;
    output isolate_macb39       ;
    output save_edge_macb39   ;
    output restore_edge_macb39   ;
    output pwr1_on_macb39       ;
    output pwr2_on_macb39       ;
    output pwr1_off_macb39      ;
    output pwr2_off_macb39      ;
    // DMA9
    output rstn_non_srpg_dma9 ;
    output gate_clk_dma9      ;
    output isolate_dma9       ;
    output save_edge_dma9   ;
    output restore_edge_dma9   ;
    output pwr1_on_dma9       ;
    output pwr2_on_dma9       ;
    output pwr1_off_dma9      ;
    output pwr2_off_dma9      ;
    // CPU9
    output rstn_non_srpg_cpu9 ;
    output gate_clk_cpu9      ;
    output isolate_cpu9       ;
    output save_edge_cpu9   ;
    output restore_edge_cpu9   ;
    output pwr1_on_cpu9       ;
    output pwr2_on_cpu9       ;
    output pwr1_off_cpu9      ;
    output pwr2_off_cpu9      ;
    // ALUT9
    output rstn_non_srpg_alut9 ;
    output gate_clk_alut9      ;
    output isolate_alut9       ;
    output save_edge_alut9   ;
    output restore_edge_alut9   ;
    output pwr1_on_alut9       ;
    output pwr2_on_alut9       ;
    output pwr1_off_alut9      ;
    output pwr2_off_alut9      ;
    // MEM9
    output rstn_non_srpg_mem9 ;
    output gate_clk_mem9      ;
    output isolate_mem9       ;
    output save_edge_mem9   ;
    output restore_edge_mem9   ;
    output pwr1_on_mem9       ;
    output pwr2_on_mem9       ;
    output pwr1_off_mem9      ;
    output pwr2_off_mem9      ;


   // core9 transitions9 o/p
    output core06v9;
    output core08v9;
    output core10v9;
    output core12v9;
    output pcm_macb_wakeup_int9 ;
    //mode mte9  signals9
    output mte_smc_start9;
    output mte_uart_start9;
    output mte_smc_uart_start9;  
    output mte_pm_smc_to_default_start9; 
    output mte_pm_uart_to_default_start9;
    output mte_pm_smc_uart_to_default_start9;

    reg mte_smc_start9;
    reg mte_uart_start9;
    reg mte_smc_uart_start9;  
    reg mte_pm_smc_to_default_start9; 
    reg mte_pm_uart_to_default_start9;
    reg mte_pm_smc_uart_to_default_start9;

    reg [31:0] prdata9;

  wire valid_reg_write9  ;
  wire valid_reg_read9   ;
  wire L1_ctrl_access9   ;
  wire L1_status_access9 ;
  wire pcm_int_mask_access9;
  wire pcm_int_status_access9;
  wire standby_mem09      ;
  wire standby_mem19      ;
  wire standby_mem29      ;
  wire standby_mem39      ;
  wire pwr1_off_mem09;
  wire pwr1_off_mem19;
  wire pwr1_off_mem29;
  wire pwr1_off_mem39;
  
  // Control9 signals9
  wire set_status_smc9   ;
  wire clr_status_smc9   ;
  wire set_status_urt9   ;
  wire clr_status_urt9   ;
  wire set_status_macb09   ;
  wire clr_status_macb09   ;
  wire set_status_macb19   ;
  wire clr_status_macb19   ;
  wire set_status_macb29   ;
  wire clr_status_macb29   ;
  wire set_status_macb39   ;
  wire clr_status_macb39   ;
  wire set_status_dma9   ;
  wire clr_status_dma9   ;
  wire set_status_cpu9   ;
  wire clr_status_cpu9   ;
  wire set_status_alut9   ;
  wire clr_status_alut9   ;
  wire set_status_mem9   ;
  wire clr_status_mem9   ;


  // Status and Control9 registers
  reg [31:0]  L1_status_reg9;
  reg  [31:0] L1_ctrl_reg9  ;
  reg  [31:0] L1_ctrl_domain9  ;
  reg L1_ctrl_cpu_off_reg9;
  reg [31:0]  pcm_mask_reg9;
  reg [31:0]  pcm_status_reg9;

  // Signals9 gated9 in scan_mode9
  //SMC9
  wire  rstn_non_srpg_smc_int9;
  wire  gate_clk_smc_int9    ;     
  wire  isolate_smc_int9    ;       
  wire save_edge_smc_int9;
  wire restore_edge_smc_int9;
  wire  pwr1_on_smc_int9    ;      
  wire  pwr2_on_smc_int9    ;      


  //URT9
  wire   rstn_non_srpg_urt_int9;
  wire   gate_clk_urt_int9     ;     
  wire   isolate_urt_int9      ;       
  wire save_edge_urt_int9;
  wire restore_edge_urt_int9;
  wire   pwr1_on_urt_int9      ;      
  wire   pwr2_on_urt_int9      ;      

  // ETH09
  wire   rstn_non_srpg_macb0_int9;
  wire   gate_clk_macb0_int9     ;     
  wire   isolate_macb0_int9      ;       
  wire save_edge_macb0_int9;
  wire restore_edge_macb0_int9;
  wire   pwr1_on_macb0_int9      ;      
  wire   pwr2_on_macb0_int9      ;      
  // ETH19
  wire   rstn_non_srpg_macb1_int9;
  wire   gate_clk_macb1_int9     ;     
  wire   isolate_macb1_int9      ;       
  wire save_edge_macb1_int9;
  wire restore_edge_macb1_int9;
  wire   pwr1_on_macb1_int9      ;      
  wire   pwr2_on_macb1_int9      ;      
  // ETH29
  wire   rstn_non_srpg_macb2_int9;
  wire   gate_clk_macb2_int9     ;     
  wire   isolate_macb2_int9      ;       
  wire save_edge_macb2_int9;
  wire restore_edge_macb2_int9;
  wire   pwr1_on_macb2_int9      ;      
  wire   pwr2_on_macb2_int9      ;      
  // ETH39
  wire   rstn_non_srpg_macb3_int9;
  wire   gate_clk_macb3_int9     ;     
  wire   isolate_macb3_int9      ;       
  wire save_edge_macb3_int9;
  wire restore_edge_macb3_int9;
  wire   pwr1_on_macb3_int9      ;      
  wire   pwr2_on_macb3_int9      ;      

  // DMA9
  wire   rstn_non_srpg_dma_int9;
  wire   gate_clk_dma_int9     ;     
  wire   isolate_dma_int9      ;       
  wire save_edge_dma_int9;
  wire restore_edge_dma_int9;
  wire   pwr1_on_dma_int9      ;      
  wire   pwr2_on_dma_int9      ;      

  // CPU9
  wire   rstn_non_srpg_cpu_int9;
  wire   gate_clk_cpu_int9     ;     
  wire   isolate_cpu_int9      ;       
  wire save_edge_cpu_int9;
  wire restore_edge_cpu_int9;
  wire   pwr1_on_cpu_int9      ;      
  wire   pwr2_on_cpu_int9      ;  
  wire L1_ctrl_cpu_off_p9;    

  reg save_alut_tmp9;
  // DFS9 sm9

  reg cpu_shutoff_ctrl9;

  reg mte_mac_off_start9, mte_mac012_start9, mte_mac013_start9, mte_mac023_start9, mte_mac123_start9;
  reg mte_mac01_start9, mte_mac02_start9, mte_mac03_start9, mte_mac12_start9, mte_mac13_start9, mte_mac23_start9;
  reg mte_mac0_start9, mte_mac1_start9, mte_mac2_start9, mte_mac3_start9;
  reg mte_sys_hibernate9 ;
  reg mte_dma_start9 ;
  reg mte_cpu_start9 ;
  reg mte_mac_off_sleep_start9, mte_mac012_sleep_start9, mte_mac013_sleep_start9, mte_mac023_sleep_start9, mte_mac123_sleep_start9;
  reg mte_mac01_sleep_start9, mte_mac02_sleep_start9, mte_mac03_sleep_start9, mte_mac12_sleep_start9, mte_mac13_sleep_start9, mte_mac23_sleep_start9;
  reg mte_mac0_sleep_start9, mte_mac1_sleep_start9, mte_mac2_sleep_start9, mte_mac3_sleep_start9;
  reg mte_dma_sleep_start9;
  reg mte_mac_off_to_default9, mte_mac012_to_default9, mte_mac013_to_default9, mte_mac023_to_default9, mte_mac123_to_default9;
  reg mte_mac01_to_default9, mte_mac02_to_default9, mte_mac03_to_default9, mte_mac12_to_default9, mte_mac13_to_default9, mte_mac23_to_default9;
  reg mte_mac0_to_default9, mte_mac1_to_default9, mte_mac2_to_default9, mte_mac3_to_default9;
  reg mte_dma_isolate_dis9;
  reg mte_cpu_isolate_dis9;
  reg mte_sys_hibernate_to_default9;


  // Latch9 the CPU9 SLEEP9 invocation9
  always @( posedge pclk9 or negedge nprst9) 
  begin
    if(!nprst9)
      L1_ctrl_cpu_off_reg9 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg9 <= L1_ctrl_domain9[8];
  end

  // Create9 a pulse9 for sleep9 detection9 
  assign L1_ctrl_cpu_off_p9 =  L1_ctrl_domain9[8] && !L1_ctrl_cpu_off_reg9;
  
  // CPU9 sleep9 contol9 logic 
  // Shut9 off9 CPU9 when L1_ctrl_cpu_off_p9 is set
  // wake9 cpu9 when any interrupt9 is seen9  
  always @( posedge pclk9 or negedge nprst9) 
  begin
    if(!nprst9)
     cpu_shutoff_ctrl9 <= 1'b0;
    else if(cpu_shutoff_ctrl9 && int_source_h9)
     cpu_shutoff_ctrl9 <= 1'b0;
    else if (L1_ctrl_cpu_off_p9)
     cpu_shutoff_ctrl9 <= 1'b1;
  end
 
  // instantiate9 power9 contol9  block for uart9
  power_ctrl_sm9 i_urt_power_ctrl_sm9(
    .pclk9(pclk9),
    .nprst9(nprst9),
    .L1_module_req9(L1_ctrl_domain9[1]),
    .set_status_module9(set_status_urt9),
    .clr_status_module9(clr_status_urt9),
    .rstn_non_srpg_module9(rstn_non_srpg_urt_int9),
    .gate_clk_module9(gate_clk_urt_int9),
    .isolate_module9(isolate_urt_int9),
    .save_edge9(save_edge_urt_int9),
    .restore_edge9(restore_edge_urt_int9),
    .pwr1_on9(pwr1_on_urt_int9),
    .pwr2_on9(pwr2_on_urt_int9)
    );
  

  // instantiate9 power9 contol9  block for smc9
  power_ctrl_sm9 i_smc_power_ctrl_sm9(
    .pclk9(pclk9),
    .nprst9(nprst9),
    .L1_module_req9(L1_ctrl_domain9[2]),
    .set_status_module9(set_status_smc9),
    .clr_status_module9(clr_status_smc9),
    .rstn_non_srpg_module9(rstn_non_srpg_smc_int9),
    .gate_clk_module9(gate_clk_smc_int9),
    .isolate_module9(isolate_smc_int9),
    .save_edge9(save_edge_smc_int9),
    .restore_edge9(restore_edge_smc_int9),
    .pwr1_on9(pwr1_on_smc_int9),
    .pwr2_on9(pwr2_on_smc_int9)
    );

  // power9 control9 for macb09
  power_ctrl_sm9 i_macb0_power_ctrl_sm9(
    .pclk9(pclk9),
    .nprst9(nprst9),
    .L1_module_req9(L1_ctrl_domain9[3]),
    .set_status_module9(set_status_macb09),
    .clr_status_module9(clr_status_macb09),
    .rstn_non_srpg_module9(rstn_non_srpg_macb0_int9),
    .gate_clk_module9(gate_clk_macb0_int9),
    .isolate_module9(isolate_macb0_int9),
    .save_edge9(save_edge_macb0_int9),
    .restore_edge9(restore_edge_macb0_int9),
    .pwr1_on9(pwr1_on_macb0_int9),
    .pwr2_on9(pwr2_on_macb0_int9)
    );
  // power9 control9 for macb19
  power_ctrl_sm9 i_macb1_power_ctrl_sm9(
    .pclk9(pclk9),
    .nprst9(nprst9),
    .L1_module_req9(L1_ctrl_domain9[4]),
    .set_status_module9(set_status_macb19),
    .clr_status_module9(clr_status_macb19),
    .rstn_non_srpg_module9(rstn_non_srpg_macb1_int9),
    .gate_clk_module9(gate_clk_macb1_int9),
    .isolate_module9(isolate_macb1_int9),
    .save_edge9(save_edge_macb1_int9),
    .restore_edge9(restore_edge_macb1_int9),
    .pwr1_on9(pwr1_on_macb1_int9),
    .pwr2_on9(pwr2_on_macb1_int9)
    );
  // power9 control9 for macb29
  power_ctrl_sm9 i_macb2_power_ctrl_sm9(
    .pclk9(pclk9),
    .nprst9(nprst9),
    .L1_module_req9(L1_ctrl_domain9[5]),
    .set_status_module9(set_status_macb29),
    .clr_status_module9(clr_status_macb29),
    .rstn_non_srpg_module9(rstn_non_srpg_macb2_int9),
    .gate_clk_module9(gate_clk_macb2_int9),
    .isolate_module9(isolate_macb2_int9),
    .save_edge9(save_edge_macb2_int9),
    .restore_edge9(restore_edge_macb2_int9),
    .pwr1_on9(pwr1_on_macb2_int9),
    .pwr2_on9(pwr2_on_macb2_int9)
    );
  // power9 control9 for macb39
  power_ctrl_sm9 i_macb3_power_ctrl_sm9(
    .pclk9(pclk9),
    .nprst9(nprst9),
    .L1_module_req9(L1_ctrl_domain9[6]),
    .set_status_module9(set_status_macb39),
    .clr_status_module9(clr_status_macb39),
    .rstn_non_srpg_module9(rstn_non_srpg_macb3_int9),
    .gate_clk_module9(gate_clk_macb3_int9),
    .isolate_module9(isolate_macb3_int9),
    .save_edge9(save_edge_macb3_int9),
    .restore_edge9(restore_edge_macb3_int9),
    .pwr1_on9(pwr1_on_macb3_int9),
    .pwr2_on9(pwr2_on_macb3_int9)
    );
  // power9 control9 for dma9
  power_ctrl_sm9 i_dma_power_ctrl_sm9(
    .pclk9(pclk9),
    .nprst9(nprst9),
    .L1_module_req9(L1_ctrl_domain9[7]),
    .set_status_module9(set_status_dma9),
    .clr_status_module9(clr_status_dma9),
    .rstn_non_srpg_module9(rstn_non_srpg_dma_int9),
    .gate_clk_module9(gate_clk_dma_int9),
    .isolate_module9(isolate_dma_int9),
    .save_edge9(save_edge_dma_int9),
    .restore_edge9(restore_edge_dma_int9),
    .pwr1_on9(pwr1_on_dma_int9),
    .pwr2_on9(pwr2_on_dma_int9)
    );
  // power9 control9 for CPU9
  power_ctrl_sm9 i_cpu_power_ctrl_sm9(
    .pclk9(pclk9),
    .nprst9(nprst9),
    .L1_module_req9(cpu_shutoff_ctrl9),
    .set_status_module9(set_status_cpu9),
    .clr_status_module9(clr_status_cpu9),
    .rstn_non_srpg_module9(rstn_non_srpg_cpu_int9),
    .gate_clk_module9(gate_clk_cpu_int9),
    .isolate_module9(isolate_cpu_int9),
    .save_edge9(save_edge_cpu_int9),
    .restore_edge9(restore_edge_cpu_int9),
    .pwr1_on9(pwr1_on_cpu_int9),
    .pwr2_on9(pwr2_on_cpu_int9)
    );

  assign valid_reg_write9 =  (psel9 && pwrite9 && penable9);
  assign valid_reg_read9  =  (psel9 && (!pwrite9) && penable9);

  assign L1_ctrl_access9  =  (paddr9[15:0] == 16'b0000000000000100); 
  assign L1_status_access9 = (paddr9[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access9 =   (paddr9[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access9 = (paddr9[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control9 and status register
  always @(*)
  begin  
    if(valid_reg_read9 && L1_ctrl_access9) 
      prdata9 = L1_ctrl_reg9;
    else if (valid_reg_read9 && L1_status_access9)
      prdata9 = L1_status_reg9;
    else if (valid_reg_read9 && pcm_int_mask_access9)
      prdata9 = pcm_mask_reg9;
    else if (valid_reg_read9 && pcm_int_status_access9)
      prdata9 = pcm_status_reg9;
    else 
      prdata9 = 0;
  end

  assign set_status_mem9 =  (set_status_macb09 && set_status_macb19 && set_status_macb29 &&
                            set_status_macb39 && set_status_dma9 && set_status_cpu9);

  assign clr_status_mem9 =  (clr_status_macb09 && clr_status_macb19 && clr_status_macb29 &&
                            clr_status_macb39 && clr_status_dma9 && clr_status_cpu9);

  assign set_status_alut9 = (set_status_macb09 && set_status_macb19 && set_status_macb29 && set_status_macb39);

  assign clr_status_alut9 = (clr_status_macb09 || clr_status_macb19 || clr_status_macb29  || clr_status_macb39);

  // Write accesses to the control9 and status register
 
  always @(posedge pclk9 or negedge nprst9)
  begin
    if (!nprst9) begin
      L1_ctrl_reg9   <= 0;
      L1_status_reg9 <= 0;
      pcm_mask_reg9 <= 0;
    end else begin
      // CTRL9 reg updates9
      if (valid_reg_write9 && L1_ctrl_access9) 
        L1_ctrl_reg9 <= pwdata9; // Writes9 to the ctrl9 reg
      if (valid_reg_write9 && pcm_int_mask_access9) 
        pcm_mask_reg9 <= pwdata9; // Writes9 to the ctrl9 reg

      if (set_status_urt9 == 1'b1)  
        L1_status_reg9[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt9 == 1'b1) 
        L1_status_reg9[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc9 == 1'b1) 
        L1_status_reg9[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc9 == 1'b1) 
        L1_status_reg9[2] <= 1'b0; // Clear the status bit

      if (set_status_macb09 == 1'b1)  
        L1_status_reg9[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb09 == 1'b1) 
        L1_status_reg9[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb19 == 1'b1)  
        L1_status_reg9[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb19 == 1'b1) 
        L1_status_reg9[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb29 == 1'b1)  
        L1_status_reg9[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb29 == 1'b1) 
        L1_status_reg9[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb39 == 1'b1)  
        L1_status_reg9[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb39 == 1'b1) 
        L1_status_reg9[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma9 == 1'b1)  
        L1_status_reg9[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma9 == 1'b1) 
        L1_status_reg9[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu9 == 1'b1)  
        L1_status_reg9[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu9 == 1'b1) 
        L1_status_reg9[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut9 == 1'b1)  
        L1_status_reg9[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut9 == 1'b1) 
        L1_status_reg9[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem9 == 1'b1)  
        L1_status_reg9[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem9 == 1'b1) 
        L1_status_reg9[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused9 bits of pcm_status_reg9 are tied9 to 0
  always @(posedge pclk9 or negedge nprst9)
  begin
    if (!nprst9)
      pcm_status_reg9[31:4] <= 'b0;
    else  
      pcm_status_reg9[31:4] <= pcm_status_reg9[31:4];
  end
  
  // interrupt9 only of h/w assisted9 wakeup
  // MAC9 3
  always @(posedge pclk9 or negedge nprst9)
  begin
    if(!nprst9)
      pcm_status_reg9[3] <= 1'b0;
    else if (valid_reg_write9 && pcm_int_status_access9) 
      pcm_status_reg9[3] <= pwdata9[3];
    else if (macb3_wakeup9 & ~pcm_mask_reg9[3])
      pcm_status_reg9[3] <= 1'b1;
    else if (valid_reg_read9 && pcm_int_status_access9) 
      pcm_status_reg9[3] <= 1'b0;
    else
      pcm_status_reg9[3] <= pcm_status_reg9[3];
  end  
   
  // MAC9 2
  always @(posedge pclk9 or negedge nprst9)
  begin
    if(!nprst9)
      pcm_status_reg9[2] <= 1'b0;
    else if (valid_reg_write9 && pcm_int_status_access9) 
      pcm_status_reg9[2] <= pwdata9[2];
    else if (macb2_wakeup9 & ~pcm_mask_reg9[2])
      pcm_status_reg9[2] <= 1'b1;
    else if (valid_reg_read9 && pcm_int_status_access9) 
      pcm_status_reg9[2] <= 1'b0;
    else
      pcm_status_reg9[2] <= pcm_status_reg9[2];
  end  

  // MAC9 1
  always @(posedge pclk9 or negedge nprst9)
  begin
    if(!nprst9)
      pcm_status_reg9[1] <= 1'b0;
    else if (valid_reg_write9 && pcm_int_status_access9) 
      pcm_status_reg9[1] <= pwdata9[1];
    else if (macb1_wakeup9 & ~pcm_mask_reg9[1])
      pcm_status_reg9[1] <= 1'b1;
    else if (valid_reg_read9 && pcm_int_status_access9) 
      pcm_status_reg9[1] <= 1'b0;
    else
      pcm_status_reg9[1] <= pcm_status_reg9[1];
  end  
   
  // MAC9 0
  always @(posedge pclk9 or negedge nprst9)
  begin
    if(!nprst9)
      pcm_status_reg9[0] <= 1'b0;
    else if (valid_reg_write9 && pcm_int_status_access9) 
      pcm_status_reg9[0] <= pwdata9[0];
    else if (macb0_wakeup9 & ~pcm_mask_reg9[0])
      pcm_status_reg9[0] <= 1'b1;
    else if (valid_reg_read9 && pcm_int_status_access9) 
      pcm_status_reg9[0] <= 1'b0;
    else
      pcm_status_reg9[0] <= pcm_status_reg9[0];
  end  

  assign pcm_macb_wakeup_int9 = |pcm_status_reg9;

  reg [31:0] L1_ctrl_reg19;
  always @(posedge pclk9 or negedge nprst9)
  begin
    if(!nprst9)
      L1_ctrl_reg19 <= 0;
    else
      L1_ctrl_reg19 <= L1_ctrl_reg9;
  end

  // Program9 mode decode
  always @(L1_ctrl_reg9 or L1_ctrl_reg19 or int_source_h9 or cpu_shutoff_ctrl9) begin
    mte_smc_start9 = 0;
    mte_uart_start9 = 0;
    mte_smc_uart_start9  = 0;
    mte_mac_off_start9  = 0;
    mte_mac012_start9 = 0;
    mte_mac013_start9 = 0;
    mte_mac023_start9 = 0;
    mte_mac123_start9 = 0;
    mte_mac01_start9 = 0;
    mte_mac02_start9 = 0;
    mte_mac03_start9 = 0;
    mte_mac12_start9 = 0;
    mte_mac13_start9 = 0;
    mte_mac23_start9 = 0;
    mte_mac0_start9 = 0;
    mte_mac1_start9 = 0;
    mte_mac2_start9 = 0;
    mte_mac3_start9 = 0;
    mte_sys_hibernate9 = 0 ;
    mte_dma_start9 = 0 ;
    mte_cpu_start9 = 0 ;

    mte_mac0_sleep_start9 = (L1_ctrl_reg9 ==  'h14) && (L1_ctrl_reg19 == 'h4 );
    mte_mac1_sleep_start9 = (L1_ctrl_reg9 ==  'h14) && (L1_ctrl_reg19 == 'h5 ); 
    mte_mac2_sleep_start9 = (L1_ctrl_reg9 ==  'h14) && (L1_ctrl_reg19 == 'h6 ); 
    mte_mac3_sleep_start9 = (L1_ctrl_reg9 ==  'h14) && (L1_ctrl_reg19 == 'h7 ); 
    mte_mac01_sleep_start9 = (L1_ctrl_reg9 ==  'h14) && (L1_ctrl_reg19 == 'h8 ); 
    mte_mac02_sleep_start9 = (L1_ctrl_reg9 ==  'h14) && (L1_ctrl_reg19 == 'h9 ); 
    mte_mac03_sleep_start9 = (L1_ctrl_reg9 ==  'h14) && (L1_ctrl_reg19 == 'hA ); 
    mte_mac12_sleep_start9 = (L1_ctrl_reg9 ==  'h14) && (L1_ctrl_reg19 == 'hB ); 
    mte_mac13_sleep_start9 = (L1_ctrl_reg9 ==  'h14) && (L1_ctrl_reg19 == 'hC ); 
    mte_mac23_sleep_start9 = (L1_ctrl_reg9 ==  'h14) && (L1_ctrl_reg19 == 'hD ); 
    mte_mac012_sleep_start9 = (L1_ctrl_reg9 ==  'h14) && (L1_ctrl_reg19 == 'hE ); 
    mte_mac013_sleep_start9 = (L1_ctrl_reg9 ==  'h14) && (L1_ctrl_reg19 == 'hF ); 
    mte_mac023_sleep_start9 = (L1_ctrl_reg9 ==  'h14) && (L1_ctrl_reg19 == 'h10 ); 
    mte_mac123_sleep_start9 = (L1_ctrl_reg9 ==  'h14) && (L1_ctrl_reg19 == 'h11 ); 
    mte_mac_off_sleep_start9 =  (L1_ctrl_reg9 == 'h14) && (L1_ctrl_reg19 == 'h12 );
    mte_dma_sleep_start9 =  (L1_ctrl_reg9 == 'h14) && (L1_ctrl_reg19 == 'h13 );

    mte_pm_uart_to_default_start9 = (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'h1);
    mte_pm_smc_to_default_start9 = (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'h2);
    mte_pm_smc_uart_to_default_start9 = (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'h3); 
    mte_mac0_to_default9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'h4); 
    mte_mac1_to_default9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'h5); 
    mte_mac2_to_default9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'h6); 
    mte_mac3_to_default9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'h7); 
    mte_mac01_to_default9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'h8); 
    mte_mac02_to_default9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'h9); 
    mte_mac03_to_default9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'hA); 
    mte_mac12_to_default9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'hB); 
    mte_mac13_to_default9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'hC); 
    mte_mac23_to_default9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'hD); 
    mte_mac012_to_default9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'hE); 
    mte_mac013_to_default9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'hF); 
    mte_mac023_to_default9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'h10); 
    mte_mac123_to_default9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'h11); 
    mte_mac_off_to_default9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'h12); 
    mte_dma_isolate_dis9 =  (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'h13); 
    mte_cpu_isolate_dis9 =  (int_source_h9) && (cpu_shutoff_ctrl9) && (L1_ctrl_reg9 != 'h15);
    mte_sys_hibernate_to_default9 = (L1_ctrl_reg9 == 32'h0) && (L1_ctrl_reg19 == 'h15); 

   
    if (L1_ctrl_reg19 == 'h0) begin // This9 check is to make mte_cpu_start9
                                   // is set only when you from default state 
      case (L1_ctrl_reg9)
        'h0 : L1_ctrl_domain9 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain9 = 32'h2; // PM_uart9
                mte_uart_start9 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain9 = 32'h4; // PM_smc9
                mte_smc_start9 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain9 = 32'h6; // PM_smc_uart9
                mte_smc_uart_start9 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain9 = 32'h8; //  PM_macb09
                mte_mac0_start9 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain9 = 32'h10; //  PM_macb19
                mte_mac1_start9 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain9 = 32'h20; //  PM_macb29
                mte_mac2_start9 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain9 = 32'h40; //  PM_macb39
                mte_mac3_start9 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain9 = 32'h18; //  PM_macb019
                mte_mac01_start9 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain9 = 32'h28; //  PM_macb029
                mte_mac02_start9 = 1;
              end
        'hA : begin  
                L1_ctrl_domain9 = 32'h48; //  PM_macb039
                mte_mac03_start9 = 1;
              end
        'hB : begin  
                L1_ctrl_domain9 = 32'h30; //  PM_macb129
                mte_mac12_start9 = 1;
              end
        'hC : begin  
                L1_ctrl_domain9 = 32'h50; //  PM_macb139
                mte_mac13_start9 = 1;
              end
        'hD : begin  
                L1_ctrl_domain9 = 32'h60; //  PM_macb239
                mte_mac23_start9 = 1;
              end
        'hE : begin  
                L1_ctrl_domain9 = 32'h38; //  PM_macb0129
                mte_mac012_start9 = 1;
              end
        'hF : begin  
                L1_ctrl_domain9 = 32'h58; //  PM_macb0139
                mte_mac013_start9 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain9 = 32'h68; //  PM_macb0239
                mte_mac023_start9 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain9 = 32'h70; //  PM_macb1239
                mte_mac123_start9 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain9 = 32'h78; //  PM_macb_off9
                mte_mac_off_start9 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain9 = 32'h80; //  PM_dma9
                mte_dma_start9 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain9 = 32'h100; //  PM_cpu_sleep9
                mte_cpu_start9 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain9 = 32'h1FE; //  PM_hibernate9
                mte_sys_hibernate9 = 1;
              end
         default: L1_ctrl_domain9 = 32'h0;
      endcase
    end
  end


  wire to_default9 = (L1_ctrl_reg9 == 0);

  // Scan9 mode gating9 of power9 and isolation9 control9 signals9
  //SMC9
  assign rstn_non_srpg_smc9  = (scan_mode9 == 1'b0) ? rstn_non_srpg_smc_int9 : 1'b1;  
  assign gate_clk_smc9       = (scan_mode9 == 1'b0) ? gate_clk_smc_int9 : 1'b0;     
  assign isolate_smc9        = (scan_mode9 == 1'b0) ? isolate_smc_int9 : 1'b0;      
  assign pwr1_on_smc9        = (scan_mode9 == 1'b0) ? pwr1_on_smc_int9 : 1'b1;       
  assign pwr2_on_smc9        = (scan_mode9 == 1'b0) ? pwr2_on_smc_int9 : 1'b1;       
  assign pwr1_off_smc9       = (scan_mode9 == 1'b0) ? (!pwr1_on_smc_int9) : 1'b0;       
  assign pwr2_off_smc9       = (scan_mode9 == 1'b0) ? (!pwr2_on_smc_int9) : 1'b0;       
  assign save_edge_smc9       = (scan_mode9 == 1'b0) ? (save_edge_smc_int9) : 1'b0;       
  assign restore_edge_smc9       = (scan_mode9 == 1'b0) ? (restore_edge_smc_int9) : 1'b0;       

  //URT9
  assign rstn_non_srpg_urt9  = (scan_mode9 == 1'b0) ?  rstn_non_srpg_urt_int9 : 1'b1;  
  assign gate_clk_urt9       = (scan_mode9 == 1'b0) ?  gate_clk_urt_int9      : 1'b0;     
  assign isolate_urt9        = (scan_mode9 == 1'b0) ?  isolate_urt_int9       : 1'b0;      
  assign pwr1_on_urt9        = (scan_mode9 == 1'b0) ?  pwr1_on_urt_int9       : 1'b1;       
  assign pwr2_on_urt9        = (scan_mode9 == 1'b0) ?  pwr2_on_urt_int9       : 1'b1;       
  assign pwr1_off_urt9       = (scan_mode9 == 1'b0) ?  (!pwr1_on_urt_int9)  : 1'b0;       
  assign pwr2_off_urt9       = (scan_mode9 == 1'b0) ?  (!pwr2_on_urt_int9)  : 1'b0;       
  assign save_edge_urt9       = (scan_mode9 == 1'b0) ? (save_edge_urt_int9) : 1'b0;       
  assign restore_edge_urt9       = (scan_mode9 == 1'b0) ? (restore_edge_urt_int9) : 1'b0;       

  //ETH09
  assign rstn_non_srpg_macb09 = (scan_mode9 == 1'b0) ?  rstn_non_srpg_macb0_int9 : 1'b1;  
  assign gate_clk_macb09       = (scan_mode9 == 1'b0) ?  gate_clk_macb0_int9      : 1'b0;     
  assign isolate_macb09        = (scan_mode9 == 1'b0) ?  isolate_macb0_int9       : 1'b0;      
  assign pwr1_on_macb09        = (scan_mode9 == 1'b0) ?  pwr1_on_macb0_int9       : 1'b1;       
  assign pwr2_on_macb09        = (scan_mode9 == 1'b0) ?  pwr2_on_macb0_int9       : 1'b1;       
  assign pwr1_off_macb09       = (scan_mode9 == 1'b0) ?  (!pwr1_on_macb0_int9)  : 1'b0;       
  assign pwr2_off_macb09       = (scan_mode9 == 1'b0) ?  (!pwr2_on_macb0_int9)  : 1'b0;       
  assign save_edge_macb09       = (scan_mode9 == 1'b0) ? (save_edge_macb0_int9) : 1'b0;       
  assign restore_edge_macb09       = (scan_mode9 == 1'b0) ? (restore_edge_macb0_int9) : 1'b0;       

  //ETH19
  assign rstn_non_srpg_macb19 = (scan_mode9 == 1'b0) ?  rstn_non_srpg_macb1_int9 : 1'b1;  
  assign gate_clk_macb19       = (scan_mode9 == 1'b0) ?  gate_clk_macb1_int9      : 1'b0;     
  assign isolate_macb19        = (scan_mode9 == 1'b0) ?  isolate_macb1_int9       : 1'b0;      
  assign pwr1_on_macb19        = (scan_mode9 == 1'b0) ?  pwr1_on_macb1_int9       : 1'b1;       
  assign pwr2_on_macb19        = (scan_mode9 == 1'b0) ?  pwr2_on_macb1_int9       : 1'b1;       
  assign pwr1_off_macb19       = (scan_mode9 == 1'b0) ?  (!pwr1_on_macb1_int9)  : 1'b0;       
  assign pwr2_off_macb19       = (scan_mode9 == 1'b0) ?  (!pwr2_on_macb1_int9)  : 1'b0;       
  assign save_edge_macb19       = (scan_mode9 == 1'b0) ? (save_edge_macb1_int9) : 1'b0;       
  assign restore_edge_macb19       = (scan_mode9 == 1'b0) ? (restore_edge_macb1_int9) : 1'b0;       

  //ETH29
  assign rstn_non_srpg_macb29 = (scan_mode9 == 1'b0) ?  rstn_non_srpg_macb2_int9 : 1'b1;  
  assign gate_clk_macb29       = (scan_mode9 == 1'b0) ?  gate_clk_macb2_int9      : 1'b0;     
  assign isolate_macb29        = (scan_mode9 == 1'b0) ?  isolate_macb2_int9       : 1'b0;      
  assign pwr1_on_macb29        = (scan_mode9 == 1'b0) ?  pwr1_on_macb2_int9       : 1'b1;       
  assign pwr2_on_macb29        = (scan_mode9 == 1'b0) ?  pwr2_on_macb2_int9       : 1'b1;       
  assign pwr1_off_macb29       = (scan_mode9 == 1'b0) ?  (!pwr1_on_macb2_int9)  : 1'b0;       
  assign pwr2_off_macb29       = (scan_mode9 == 1'b0) ?  (!pwr2_on_macb2_int9)  : 1'b0;       
  assign save_edge_macb29       = (scan_mode9 == 1'b0) ? (save_edge_macb2_int9) : 1'b0;       
  assign restore_edge_macb29       = (scan_mode9 == 1'b0) ? (restore_edge_macb2_int9) : 1'b0;       

  //ETH39
  assign rstn_non_srpg_macb39 = (scan_mode9 == 1'b0) ?  rstn_non_srpg_macb3_int9 : 1'b1;  
  assign gate_clk_macb39       = (scan_mode9 == 1'b0) ?  gate_clk_macb3_int9      : 1'b0;     
  assign isolate_macb39        = (scan_mode9 == 1'b0) ?  isolate_macb3_int9       : 1'b0;      
  assign pwr1_on_macb39        = (scan_mode9 == 1'b0) ?  pwr1_on_macb3_int9       : 1'b1;       
  assign pwr2_on_macb39        = (scan_mode9 == 1'b0) ?  pwr2_on_macb3_int9       : 1'b1;       
  assign pwr1_off_macb39       = (scan_mode9 == 1'b0) ?  (!pwr1_on_macb3_int9)  : 1'b0;       
  assign pwr2_off_macb39       = (scan_mode9 == 1'b0) ?  (!pwr2_on_macb3_int9)  : 1'b0;       
  assign save_edge_macb39       = (scan_mode9 == 1'b0) ? (save_edge_macb3_int9) : 1'b0;       
  assign restore_edge_macb39       = (scan_mode9 == 1'b0) ? (restore_edge_macb3_int9) : 1'b0;       

  // MEM9
  assign rstn_non_srpg_mem9 =   (rstn_non_srpg_macb09 && rstn_non_srpg_macb19 && rstn_non_srpg_macb29 &&
                                rstn_non_srpg_macb39 && rstn_non_srpg_dma9 && rstn_non_srpg_cpu9 && rstn_non_srpg_urt9 &&
                                rstn_non_srpg_smc9);

  assign gate_clk_mem9 =  (gate_clk_macb09 && gate_clk_macb19 && gate_clk_macb29 &&
                            gate_clk_macb39 && gate_clk_dma9 && gate_clk_cpu9 && gate_clk_urt9 && gate_clk_smc9);

  assign isolate_mem9  = (isolate_macb09 && isolate_macb19 && isolate_macb29 &&
                         isolate_macb39 && isolate_dma9 && isolate_cpu9 && isolate_urt9 && isolate_smc9);


  assign pwr1_on_mem9        =   ~pwr1_off_mem9;

  assign pwr2_on_mem9        =   ~pwr2_off_mem9;

  assign pwr1_off_mem9       =  (pwr1_off_macb09 && pwr1_off_macb19 && pwr1_off_macb29 &&
                                 pwr1_off_macb39 && pwr1_off_dma9 && pwr1_off_cpu9 && pwr1_off_urt9 && pwr1_off_smc9);


  assign pwr2_off_mem9       =  (pwr2_off_macb09 && pwr2_off_macb19 && pwr2_off_macb29 &&
                                pwr2_off_macb39 && pwr2_off_dma9 && pwr2_off_cpu9 && pwr2_off_urt9 && pwr2_off_smc9);

  assign save_edge_mem9      =  (save_edge_macb09 && save_edge_macb19 && save_edge_macb29 &&
                                save_edge_macb39 && save_edge_dma9 && save_edge_cpu9 && save_edge_smc9 && save_edge_urt9);

  assign restore_edge_mem9   =  (restore_edge_macb09 && restore_edge_macb19 && restore_edge_macb29  &&
                                restore_edge_macb39 && restore_edge_dma9 && restore_edge_cpu9 && restore_edge_urt9 &&
                                restore_edge_smc9);

  assign standby_mem09 = pwr1_off_macb09 && (~ (pwr1_off_macb09 && pwr1_off_macb19 && pwr1_off_macb29 && pwr1_off_macb39 && pwr1_off_urt9 && pwr1_off_smc9 && pwr1_off_dma9 && pwr1_off_cpu9));
  assign standby_mem19 = pwr1_off_macb19 && (~ (pwr1_off_macb09 && pwr1_off_macb19 && pwr1_off_macb29 && pwr1_off_macb39 && pwr1_off_urt9 && pwr1_off_smc9 && pwr1_off_dma9 && pwr1_off_cpu9));
  assign standby_mem29 = pwr1_off_macb29 && (~ (pwr1_off_macb09 && pwr1_off_macb19 && pwr1_off_macb29 && pwr1_off_macb39 && pwr1_off_urt9 && pwr1_off_smc9 && pwr1_off_dma9 && pwr1_off_cpu9));
  assign standby_mem39 = pwr1_off_macb39 && (~ (pwr1_off_macb09 && pwr1_off_macb19 && pwr1_off_macb29 && pwr1_off_macb39 && pwr1_off_urt9 && pwr1_off_smc9 && pwr1_off_dma9 && pwr1_off_cpu9));

  assign pwr1_off_mem09 = pwr1_off_mem9;
  assign pwr1_off_mem19 = pwr1_off_mem9;
  assign pwr1_off_mem29 = pwr1_off_mem9;
  assign pwr1_off_mem39 = pwr1_off_mem9;

  assign rstn_non_srpg_alut9  =  (rstn_non_srpg_macb09 && rstn_non_srpg_macb19 && rstn_non_srpg_macb29 && rstn_non_srpg_macb39);


   assign gate_clk_alut9       =  (gate_clk_macb09 && gate_clk_macb19 && gate_clk_macb29 && gate_clk_macb39);


    assign isolate_alut9        =  (isolate_macb09 && isolate_macb19 && isolate_macb29 && isolate_macb39);


    assign pwr1_on_alut9        =  (pwr1_on_macb09 || pwr1_on_macb19 || pwr1_on_macb29 || pwr1_on_macb39);


    assign pwr2_on_alut9        =  (pwr2_on_macb09 || pwr2_on_macb19 || pwr2_on_macb29 || pwr2_on_macb39);


    assign pwr1_off_alut9       =  (pwr1_off_macb09 && pwr1_off_macb19 && pwr1_off_macb29 && pwr1_off_macb39);


    assign pwr2_off_alut9       =  (pwr2_off_macb09 && pwr2_off_macb19 && pwr2_off_macb29 && pwr2_off_macb39);


    assign save_edge_alut9      =  (save_edge_macb09 && save_edge_macb19 && save_edge_macb29 && save_edge_macb39);


    assign restore_edge_alut9   =  (restore_edge_macb09 || restore_edge_macb19 || restore_edge_macb29 ||
                                   restore_edge_macb39) && save_alut_tmp9;

     // alut9 power9 off9 detection9
  always @(posedge pclk9 or negedge nprst9) begin
    if (!nprst9) 
       save_alut_tmp9 <= 0;
    else if (restore_edge_alut9)
       save_alut_tmp9 <= 0;
    else if (save_edge_alut9)
       save_alut_tmp9 <= 1;
  end

  //DMA9
  assign rstn_non_srpg_dma9 = (scan_mode9 == 1'b0) ?  rstn_non_srpg_dma_int9 : 1'b1;  
  assign gate_clk_dma9       = (scan_mode9 == 1'b0) ?  gate_clk_dma_int9      : 1'b0;     
  assign isolate_dma9        = (scan_mode9 == 1'b0) ?  isolate_dma_int9       : 1'b0;      
  assign pwr1_on_dma9        = (scan_mode9 == 1'b0) ?  pwr1_on_dma_int9       : 1'b1;       
  assign pwr2_on_dma9        = (scan_mode9 == 1'b0) ?  pwr2_on_dma_int9       : 1'b1;       
  assign pwr1_off_dma9       = (scan_mode9 == 1'b0) ?  (!pwr1_on_dma_int9)  : 1'b0;       
  assign pwr2_off_dma9       = (scan_mode9 == 1'b0) ?  (!pwr2_on_dma_int9)  : 1'b0;       
  assign save_edge_dma9       = (scan_mode9 == 1'b0) ? (save_edge_dma_int9) : 1'b0;       
  assign restore_edge_dma9       = (scan_mode9 == 1'b0) ? (restore_edge_dma_int9) : 1'b0;       

  //CPU9
  assign rstn_non_srpg_cpu9 = (scan_mode9 == 1'b0) ?  rstn_non_srpg_cpu_int9 : 1'b1;  
  assign gate_clk_cpu9       = (scan_mode9 == 1'b0) ?  gate_clk_cpu_int9      : 1'b0;     
  assign isolate_cpu9        = (scan_mode9 == 1'b0) ?  isolate_cpu_int9       : 1'b0;      
  assign pwr1_on_cpu9        = (scan_mode9 == 1'b0) ?  pwr1_on_cpu_int9       : 1'b1;       
  assign pwr2_on_cpu9        = (scan_mode9 == 1'b0) ?  pwr2_on_cpu_int9       : 1'b1;       
  assign pwr1_off_cpu9       = (scan_mode9 == 1'b0) ?  (!pwr1_on_cpu_int9)  : 1'b0;       
  assign pwr2_off_cpu9       = (scan_mode9 == 1'b0) ?  (!pwr2_on_cpu_int9)  : 1'b0;       
  assign save_edge_cpu9       = (scan_mode9 == 1'b0) ? (save_edge_cpu_int9) : 1'b0;       
  assign restore_edge_cpu9       = (scan_mode9 == 1'b0) ? (restore_edge_cpu_int9) : 1'b0;       



  // ASE9

   reg ase_core_12v9, ase_core_10v9, ase_core_08v9, ase_core_06v9;
   reg ase_macb0_12v9,ase_macb1_12v9,ase_macb2_12v9,ase_macb3_12v9;

    // core9 ase9

    // core9 at 1.0 v if (smc9 off9, urt9 off9, macb09 off9, macb19 off9, macb29 off9, macb39 off9
   // core9 at 0.8v if (mac01off9, macb02off9, macb03off9, macb12off9, mac13off9, mac23off9,
   // core9 at 0.6v if (mac012off9, mac013off9, mac023off9, mac123off9, mac0123off9
    // else core9 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb09 && pwr1_off_macb19 && pwr1_off_macb29 && pwr1_off_macb39) || // all mac9 off9
       (pwr1_off_macb39 && pwr1_off_macb29 && pwr1_off_macb19) || // mac123off9 
       (pwr1_off_macb39 && pwr1_off_macb29 && pwr1_off_macb09) || // mac023off9 
       (pwr1_off_macb39 && pwr1_off_macb19 && pwr1_off_macb09) || // mac013off9 
       (pwr1_off_macb29 && pwr1_off_macb19 && pwr1_off_macb09) )  // mac012off9 
       begin
         ase_core_12v9 = 0;
         ase_core_10v9 = 0;
         ase_core_08v9 = 0;
         ase_core_06v9 = 1;
       end
     else if( (pwr1_off_macb29 && pwr1_off_macb39) || // mac239 off9
         (pwr1_off_macb39 && pwr1_off_macb19) || // mac13off9 
         (pwr1_off_macb19 && pwr1_off_macb29) || // mac12off9 
         (pwr1_off_macb39 && pwr1_off_macb09) || // mac03off9 
         (pwr1_off_macb29 && pwr1_off_macb09) || // mac02off9 
         (pwr1_off_macb19 && pwr1_off_macb09))  // mac01off9 
       begin
         ase_core_12v9 = 0;
         ase_core_10v9 = 0;
         ase_core_08v9 = 1;
         ase_core_06v9 = 0;
       end
     else if( (pwr1_off_smc9) || // smc9 off9
         (pwr1_off_macb09 ) || // mac0off9 
         (pwr1_off_macb19 ) || // mac1off9 
         (pwr1_off_macb29 ) || // mac2off9 
         (pwr1_off_macb39 ))  // mac3off9 
       begin
         ase_core_12v9 = 0;
         ase_core_10v9 = 1;
         ase_core_08v9 = 0;
         ase_core_06v9 = 0;
       end
     else if (pwr1_off_urt9)
       begin
         ase_core_12v9 = 1;
         ase_core_10v9 = 0;
         ase_core_08v9 = 0;
         ase_core_06v9 = 0;
       end
     else
       begin
         ase_core_12v9 = 1;
         ase_core_10v9 = 0;
         ase_core_08v9 = 0;
         ase_core_06v9 = 0;
       end
   end


   // cpu9
   // cpu9 @ 1.0v when macoff9, 
   // 
   reg ase_cpu_10v9, ase_cpu_12v9;
   always @(*) begin
    if(pwr1_off_cpu9) begin
     ase_cpu_12v9 = 1'b0;
     ase_cpu_10v9 = 1'b0;
    end
    else if(pwr1_off_macb09 || pwr1_off_macb19 || pwr1_off_macb29 || pwr1_off_macb39)
    begin
     ase_cpu_12v9 = 1'b0;
     ase_cpu_10v9 = 1'b1;
    end
    else
    begin
     ase_cpu_12v9 = 1'b1;
     ase_cpu_10v9 = 1'b0;
    end
   end

   // dma9
   // dma9 @v19.0 for macoff9, 

   reg ase_dma_10v9, ase_dma_12v9;
   always @(*) begin
    if(pwr1_off_dma9) begin
     ase_dma_12v9 = 1'b0;
     ase_dma_10v9 = 1'b0;
    end
    else if(pwr1_off_macb09 || pwr1_off_macb19 || pwr1_off_macb29 || pwr1_off_macb39)
    begin
     ase_dma_12v9 = 1'b0;
     ase_dma_10v9 = 1'b1;
    end
    else
    begin
     ase_dma_12v9 = 1'b1;
     ase_dma_10v9 = 1'b0;
    end
   end

   // alut9
   // @ v19.0 for macoff9

   reg ase_alut_10v9, ase_alut_12v9;
   always @(*) begin
    if(pwr1_off_alut9) begin
     ase_alut_12v9 = 1'b0;
     ase_alut_10v9 = 1'b0;
    end
    else if(pwr1_off_macb09 || pwr1_off_macb19 || pwr1_off_macb29 || pwr1_off_macb39)
    begin
     ase_alut_12v9 = 1'b0;
     ase_alut_10v9 = 1'b1;
    end
    else
    begin
     ase_alut_12v9 = 1'b1;
     ase_alut_10v9 = 1'b0;
    end
   end




   reg ase_uart_12v9;
   reg ase_uart_10v9;
   reg ase_uart_08v9;
   reg ase_uart_06v9;

   reg ase_smc_12v9;


   always @(*) begin
     if(pwr1_off_urt9) begin // uart9 off9
       ase_uart_08v9 = 1'b0;
       ase_uart_06v9 = 1'b0;
       ase_uart_10v9 = 1'b0;
       ase_uart_12v9 = 1'b0;
     end 
     else if( (pwr1_off_macb09 && pwr1_off_macb19 && pwr1_off_macb29 && pwr1_off_macb39) || // all mac9 off9
       (pwr1_off_macb39 && pwr1_off_macb29 && pwr1_off_macb19) || // mac123off9 
       (pwr1_off_macb39 && pwr1_off_macb29 && pwr1_off_macb09) || // mac023off9 
       (pwr1_off_macb39 && pwr1_off_macb19 && pwr1_off_macb09) || // mac013off9 
       (pwr1_off_macb29 && pwr1_off_macb19 && pwr1_off_macb09) )  // mac012off9 
     begin
       ase_uart_06v9 = 1'b1;
       ase_uart_08v9 = 1'b0;
       ase_uart_10v9 = 1'b0;
       ase_uart_12v9 = 1'b0;
     end
     else if( (pwr1_off_macb29 && pwr1_off_macb39) || // mac239 off9
         (pwr1_off_macb39 && pwr1_off_macb19) || // mac13off9 
         (pwr1_off_macb19 && pwr1_off_macb29) || // mac12off9 
         (pwr1_off_macb39 && pwr1_off_macb09) || // mac03off9 
         (pwr1_off_macb19 && pwr1_off_macb09))  // mac01off9  
     begin
       ase_uart_06v9 = 1'b0;
       ase_uart_08v9 = 1'b1;
       ase_uart_10v9 = 1'b0;
       ase_uart_12v9 = 1'b0;
     end
     else if (pwr1_off_smc9 || pwr1_off_macb09 || pwr1_off_macb19 || pwr1_off_macb29 || pwr1_off_macb39) begin // smc9 off9
       ase_uart_08v9 = 1'b0;
       ase_uart_06v9 = 1'b0;
       ase_uart_10v9 = 1'b1;
       ase_uart_12v9 = 1'b0;
     end 
     else begin
       ase_uart_08v9 = 1'b0;
       ase_uart_06v9 = 1'b0;
       ase_uart_10v9 = 1'b0;
       ase_uart_12v9 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc9) begin
     if (pwr1_off_smc9)  // smc9 off9
       ase_smc_12v9 = 1'b0;
    else
       ase_smc_12v9 = 1'b1;
   end

   
   always @(pwr1_off_macb09) begin
     if (pwr1_off_macb09) // macb09 off9
       ase_macb0_12v9 = 1'b0;
     else
       ase_macb0_12v9 = 1'b1;
   end

   always @(pwr1_off_macb19) begin
     if (pwr1_off_macb19) // macb19 off9
       ase_macb1_12v9 = 1'b0;
     else
       ase_macb1_12v9 = 1'b1;
   end

   always @(pwr1_off_macb29) begin // macb29 off9
     if (pwr1_off_macb29) // macb29 off9
       ase_macb2_12v9 = 1'b0;
     else
       ase_macb2_12v9 = 1'b1;
   end

   always @(pwr1_off_macb39) begin // macb39 off9
     if (pwr1_off_macb39) // macb39 off9
       ase_macb3_12v9 = 1'b0;
     else
       ase_macb3_12v9 = 1'b1;
   end


   // core9 voltage9 for vco9
  assign core12v9 = ase_macb0_12v9 & ase_macb1_12v9 & ase_macb2_12v9 & ase_macb3_12v9;

  assign core10v9 =  (ase_macb0_12v9 & ase_macb1_12v9 & ase_macb2_12v9 & (!ase_macb3_12v9)) ||
                    (ase_macb0_12v9 & ase_macb1_12v9 & (!ase_macb2_12v9) & ase_macb3_12v9) ||
                    (ase_macb0_12v9 & (!ase_macb1_12v9) & ase_macb2_12v9 & ase_macb3_12v9) ||
                    ((!ase_macb0_12v9) & ase_macb1_12v9 & ase_macb2_12v9 & ase_macb3_12v9);

  assign core08v9 =  ((!ase_macb0_12v9) & (!ase_macb1_12v9) & (ase_macb2_12v9) & (ase_macb3_12v9)) ||
                    ((!ase_macb0_12v9) & (ase_macb1_12v9) & (!ase_macb2_12v9) & (ase_macb3_12v9)) ||
                    ((!ase_macb0_12v9) & (ase_macb1_12v9) & (ase_macb2_12v9) & (!ase_macb3_12v9)) ||
                    ((ase_macb0_12v9) & (!ase_macb1_12v9) & (!ase_macb2_12v9) & (ase_macb3_12v9)) ||
                    ((ase_macb0_12v9) & (!ase_macb1_12v9) & (ase_macb2_12v9) & (!ase_macb3_12v9)) ||
                    ((ase_macb0_12v9) & (ase_macb1_12v9) & (!ase_macb2_12v9) & (!ase_macb3_12v9));

  assign core06v9 =  ((!ase_macb0_12v9) & (!ase_macb1_12v9) & (!ase_macb2_12v9) & (ase_macb3_12v9)) ||
                    ((!ase_macb0_12v9) & (!ase_macb1_12v9) & (ase_macb2_12v9) & (!ase_macb3_12v9)) ||
                    ((!ase_macb0_12v9) & (ase_macb1_12v9) & (!ase_macb2_12v9) & (!ase_macb3_12v9)) ||
                    ((ase_macb0_12v9) & (!ase_macb1_12v9) & (!ase_macb2_12v9) & (!ase_macb3_12v9)) ||
                    ((!ase_macb0_12v9) & (!ase_macb1_12v9) & (!ase_macb2_12v9) & (!ase_macb3_12v9)) ;



`ifdef LP_ABV_ON9
// psl9 default clock9 = (posedge pclk9);

// Cover9 a condition in which SMC9 is powered9 down
// and again9 powered9 up while UART9 is going9 into POWER9 down
// state or UART9 is already in POWER9 DOWN9 state
// psl9 cover_overlapping_smc_urt_19:
//    cover{fell9(pwr1_on_urt9);[*];fell9(pwr1_on_smc9);[*];
//    rose9(pwr1_on_smc9);[*];rose9(pwr1_on_urt9)};
//
// Cover9 a condition in which UART9 is powered9 down
// and again9 powered9 up while SMC9 is going9 into POWER9 down
// state or SMC9 is already in POWER9 DOWN9 state
// psl9 cover_overlapping_smc_urt_29:
//    cover{fell9(pwr1_on_smc9);[*];fell9(pwr1_on_urt9);[*];
//    rose9(pwr1_on_urt9);[*];rose9(pwr1_on_smc9)};
//


// Power9 Down9 UART9
// This9 gets9 triggered on rising9 edge of Gate9 signal9 for
// UART9 (gate_clk_urt9). In a next cycle after gate_clk_urt9,
// Isolate9 UART9(isolate_urt9) signal9 become9 HIGH9 (active).
// In 2nd cycle after gate_clk_urt9 becomes HIGH9, RESET9 for NON9
// SRPG9 FFs9(rstn_non_srpg_urt9) and POWER19 for UART9(pwr1_on_urt9) should 
// go9 LOW9. 
// This9 completes9 a POWER9 DOWN9. 

sequence s_power_down_urt9;
      (gate_clk_urt9 & !isolate_urt9 & rstn_non_srpg_urt9 & pwr1_on_urt9) 
  ##1 (gate_clk_urt9 & isolate_urt9 & rstn_non_srpg_urt9 & pwr1_on_urt9) 
  ##3 (gate_clk_urt9 & isolate_urt9 & !rstn_non_srpg_urt9 & !pwr1_on_urt9);
endsequence


property p_power_down_urt9;
   @(posedge pclk9)
    $rose(gate_clk_urt9) |=> s_power_down_urt9;
endproperty

output_power_down_urt9:
  assert property (p_power_down_urt9);


// Power9 UP9 UART9
// Sequence starts with , Rising9 edge of pwr1_on_urt9.
// Two9 clock9 cycle after this, isolate_urt9 should become9 LOW9 
// On9 the following9 clk9 gate_clk_urt9 should go9 low9.
// 5 cycles9 after  Rising9 edge of pwr1_on_urt9, rstn_non_srpg_urt9
// should become9 HIGH9
sequence s_power_up_urt9;
##30 (pwr1_on_urt9 & !isolate_urt9 & gate_clk_urt9 & !rstn_non_srpg_urt9) 
##1 (pwr1_on_urt9 & !isolate_urt9 & !gate_clk_urt9 & !rstn_non_srpg_urt9) 
##2 (pwr1_on_urt9 & !isolate_urt9 & !gate_clk_urt9 & rstn_non_srpg_urt9);
endsequence

property p_power_up_urt9;
   @(posedge pclk9)
  disable iff(!nprst9)
    (!pwr1_on_urt9 ##1 pwr1_on_urt9) |=> s_power_up_urt9;
endproperty

output_power_up_urt9:
  assert property (p_power_up_urt9);


// Power9 Down9 SMC9
// This9 gets9 triggered on rising9 edge of Gate9 signal9 for
// SMC9 (gate_clk_smc9). In a next cycle after gate_clk_smc9,
// Isolate9 SMC9(isolate_smc9) signal9 become9 HIGH9 (active).
// In 2nd cycle after gate_clk_smc9 becomes HIGH9, RESET9 for NON9
// SRPG9 FFs9(rstn_non_srpg_smc9) and POWER19 for SMC9(pwr1_on_smc9) should 
// go9 LOW9. 
// This9 completes9 a POWER9 DOWN9. 

sequence s_power_down_smc9;
      (gate_clk_smc9 & !isolate_smc9 & rstn_non_srpg_smc9 & pwr1_on_smc9) 
  ##1 (gate_clk_smc9 & isolate_smc9 & rstn_non_srpg_smc9 & pwr1_on_smc9) 
  ##3 (gate_clk_smc9 & isolate_smc9 & !rstn_non_srpg_smc9 & !pwr1_on_smc9);
endsequence


property p_power_down_smc9;
   @(posedge pclk9)
    $rose(gate_clk_smc9) |=> s_power_down_smc9;
endproperty

output_power_down_smc9:
  assert property (p_power_down_smc9);


// Power9 UP9 SMC9
// Sequence starts with , Rising9 edge of pwr1_on_smc9.
// Two9 clock9 cycle after this, isolate_smc9 should become9 LOW9 
// On9 the following9 clk9 gate_clk_smc9 should go9 low9.
// 5 cycles9 after  Rising9 edge of pwr1_on_smc9, rstn_non_srpg_smc9
// should become9 HIGH9
sequence s_power_up_smc9;
##30 (pwr1_on_smc9 & !isolate_smc9 & gate_clk_smc9 & !rstn_non_srpg_smc9) 
##1 (pwr1_on_smc9 & !isolate_smc9 & !gate_clk_smc9 & !rstn_non_srpg_smc9) 
##2 (pwr1_on_smc9 & !isolate_smc9 & !gate_clk_smc9 & rstn_non_srpg_smc9);
endsequence

property p_power_up_smc9;
   @(posedge pclk9)
  disable iff(!nprst9)
    (!pwr1_on_smc9 ##1 pwr1_on_smc9) |=> s_power_up_smc9;
endproperty

output_power_up_smc9:
  assert property (p_power_up_smc9);


// COVER9 SMC9 POWER9 DOWN9 AND9 UP9
cover_power_down_up_smc9: cover property (@(posedge pclk9)
(s_power_down_smc9 ##[5:180] s_power_up_smc9));



// COVER9 UART9 POWER9 DOWN9 AND9 UP9
cover_power_down_up_urt9: cover property (@(posedge pclk9)
(s_power_down_urt9 ##[5:180] s_power_up_urt9));

cover_power_down_urt9: cover property (@(posedge pclk9)
(s_power_down_urt9));

cover_power_up_urt9: cover property (@(posedge pclk9)
(s_power_up_urt9));




`ifdef PCM_ABV_ON9
//------------------------------------------------------------------------------
// Power9 Controller9 Formal9 Verification9 component.  Each power9 domain has a 
// separate9 instantiation9
//------------------------------------------------------------------------------

// need to assume that CPU9 will leave9 a minimum time between powering9 down and 
// back up.  In this example9, 10clks has been selected.
// psl9 config_min_uart_pd_time9 : assume always {rose9(L1_ctrl_domain9[1])} |-> { L1_ctrl_domain9[1][*10] } abort9(~nprst9);
// psl9 config_min_uart_pu_time9 : assume always {fell9(L1_ctrl_domain9[1])} |-> { !L1_ctrl_domain9[1][*10] } abort9(~nprst9);
// psl9 config_min_smc_pd_time9 : assume always {rose9(L1_ctrl_domain9[2])} |-> { L1_ctrl_domain9[2][*10] } abort9(~nprst9);
// psl9 config_min_smc_pu_time9 : assume always {fell9(L1_ctrl_domain9[2])} |-> { !L1_ctrl_domain9[2][*10] } abort9(~nprst9);

// UART9 VCOMP9 parameters9
   defparam i_uart_vcomp_domain9.ENABLE_SAVE_RESTORE_EDGE9   = 1;
   defparam i_uart_vcomp_domain9.ENABLE_EXT_PWR_CNTRL9       = 1;
   defparam i_uart_vcomp_domain9.REF_CLK_DEFINED9            = 0;
   defparam i_uart_vcomp_domain9.MIN_SHUTOFF_CYCLES9         = 4;
   defparam i_uart_vcomp_domain9.MIN_RESTORE_TO_ISO_CYCLES9  = 0;
   defparam i_uart_vcomp_domain9.MIN_SAVE_TO_SHUTOFF_CYCLES9 = 1;


   vcomp_domain9 i_uart_vcomp_domain9
   ( .ref_clk9(pclk9),
     .start_lps9(L1_ctrl_domain9[1] || !rstn_non_srpg_urt9),
     .rst_n9(nprst9),
     .ext_power_down9(L1_ctrl_domain9[1]),
     .iso_en9(isolate_urt9),
     .save_edge9(save_edge_urt9),
     .restore_edge9(restore_edge_urt9),
     .domain_shut_off9(pwr1_off_urt9),
     .domain_clk9(!gate_clk_urt9 && pclk9)
   );


// SMC9 VCOMP9 parameters9
   defparam i_smc_vcomp_domain9.ENABLE_SAVE_RESTORE_EDGE9   = 1;
   defparam i_smc_vcomp_domain9.ENABLE_EXT_PWR_CNTRL9       = 1;
   defparam i_smc_vcomp_domain9.REF_CLK_DEFINED9            = 0;
   defparam i_smc_vcomp_domain9.MIN_SHUTOFF_CYCLES9         = 4;
   defparam i_smc_vcomp_domain9.MIN_RESTORE_TO_ISO_CYCLES9  = 0;
   defparam i_smc_vcomp_domain9.MIN_SAVE_TO_SHUTOFF_CYCLES9 = 1;


   vcomp_domain9 i_smc_vcomp_domain9
   ( .ref_clk9(pclk9),
     .start_lps9(L1_ctrl_domain9[2] || !rstn_non_srpg_smc9),
     .rst_n9(nprst9),
     .ext_power_down9(L1_ctrl_domain9[2]),
     .iso_en9(isolate_smc9),
     .save_edge9(save_edge_smc9),
     .restore_edge9(restore_edge_smc9),
     .domain_shut_off9(pwr1_off_smc9),
     .domain_clk9(!gate_clk_smc9 && pclk9)
   );

`endif

`endif



endmodule
