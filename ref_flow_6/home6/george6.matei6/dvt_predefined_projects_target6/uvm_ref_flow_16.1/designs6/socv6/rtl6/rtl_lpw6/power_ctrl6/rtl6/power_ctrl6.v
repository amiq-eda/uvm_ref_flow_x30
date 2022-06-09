//File6 name   : power_ctrl6.v
//Title6       : Power6 Control6 Module6
//Created6     : 1999
//Description6 : Top6 level of power6 controller6
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

module power_ctrl6 (


    // Clocks6 & Reset6
    pclk6,
    nprst6,
    // APB6 programming6 interface
    paddr6,
    psel6,
    penable6,
    pwrite6,
    pwdata6,
    prdata6,
    // mac6 i/f,
    macb3_wakeup6,
    macb2_wakeup6,
    macb1_wakeup6,
    macb0_wakeup6,
    // Scan6 
    scan_in6,
    scan_en6,
    scan_mode6,
    scan_out6,
    // Module6 control6 outputs6
    int_source_h6,
    // SMC6
    rstn_non_srpg_smc6,
    gate_clk_smc6,
    isolate_smc6,
    save_edge_smc6,
    restore_edge_smc6,
    pwr1_on_smc6,
    pwr2_on_smc6,
    pwr1_off_smc6,
    pwr2_off_smc6,
    // URT6
    rstn_non_srpg_urt6,
    gate_clk_urt6,
    isolate_urt6,
    save_edge_urt6,
    restore_edge_urt6,
    pwr1_on_urt6,
    pwr2_on_urt6,
    pwr1_off_urt6,      
    pwr2_off_urt6,
    // ETH06
    rstn_non_srpg_macb06,
    gate_clk_macb06,
    isolate_macb06,
    save_edge_macb06,
    restore_edge_macb06,
    pwr1_on_macb06,
    pwr2_on_macb06,
    pwr1_off_macb06,      
    pwr2_off_macb06,
    // ETH16
    rstn_non_srpg_macb16,
    gate_clk_macb16,
    isolate_macb16,
    save_edge_macb16,
    restore_edge_macb16,
    pwr1_on_macb16,
    pwr2_on_macb16,
    pwr1_off_macb16,      
    pwr2_off_macb16,
    // ETH26
    rstn_non_srpg_macb26,
    gate_clk_macb26,
    isolate_macb26,
    save_edge_macb26,
    restore_edge_macb26,
    pwr1_on_macb26,
    pwr2_on_macb26,
    pwr1_off_macb26,      
    pwr2_off_macb26,
    // ETH36
    rstn_non_srpg_macb36,
    gate_clk_macb36,
    isolate_macb36,
    save_edge_macb36,
    restore_edge_macb36,
    pwr1_on_macb36,
    pwr2_on_macb36,
    pwr1_off_macb36,      
    pwr2_off_macb36,
    // DMA6
    rstn_non_srpg_dma6,
    gate_clk_dma6,
    isolate_dma6,
    save_edge_dma6,
    restore_edge_dma6,
    pwr1_on_dma6,
    pwr2_on_dma6,
    pwr1_off_dma6,      
    pwr2_off_dma6,
    // CPU6
    rstn_non_srpg_cpu6,
    gate_clk_cpu6,
    isolate_cpu6,
    save_edge_cpu6,
    restore_edge_cpu6,
    pwr1_on_cpu6,
    pwr2_on_cpu6,
    pwr1_off_cpu6,      
    pwr2_off_cpu6,
    // ALUT6
    rstn_non_srpg_alut6,
    gate_clk_alut6,
    isolate_alut6,
    save_edge_alut6,
    restore_edge_alut6,
    pwr1_on_alut6,
    pwr2_on_alut6,
    pwr1_off_alut6,      
    pwr2_off_alut6,
    // MEM6
    rstn_non_srpg_mem6,
    gate_clk_mem6,
    isolate_mem6,
    save_edge_mem6,
    restore_edge_mem6,
    pwr1_on_mem6,
    pwr2_on_mem6,
    pwr1_off_mem6,      
    pwr2_off_mem6,
    // core6 dvfs6 transitions6
    core06v6,
    core08v6,
    core10v6,
    core12v6,
    pcm_macb_wakeup_int6,
    // mte6 signals6
    mte_smc_start6,
    mte_uart_start6,
    mte_smc_uart_start6,  
    mte_pm_smc_to_default_start6, 
    mte_pm_uart_to_default_start6,
    mte_pm_smc_uart_to_default_start6

  );

  parameter STATE_IDLE_12V6 = 4'b0001;
  parameter STATE_06V6 = 4'b0010;
  parameter STATE_08V6 = 4'b0100;
  parameter STATE_10V6 = 4'b1000;

    // Clocks6 & Reset6
    input pclk6;
    input nprst6;
    // APB6 programming6 interface
    input [31:0] paddr6;
    input psel6  ;
    input penable6;
    input pwrite6 ;
    input [31:0] pwdata6;
    output [31:0] prdata6;
    // mac6
    input macb3_wakeup6;
    input macb2_wakeup6;
    input macb1_wakeup6;
    input macb0_wakeup6;
    // Scan6 
    input scan_in6;
    input scan_en6;
    input scan_mode6;
    output scan_out6;
    // Module6 control6 outputs6
    input int_source_h6;
    // SMC6
    output rstn_non_srpg_smc6 ;
    output gate_clk_smc6   ;
    output isolate_smc6   ;
    output save_edge_smc6   ;
    output restore_edge_smc6   ;
    output pwr1_on_smc6   ;
    output pwr2_on_smc6   ;
    output pwr1_off_smc6  ;
    output pwr2_off_smc6  ;
    // URT6
    output rstn_non_srpg_urt6 ;
    output gate_clk_urt6      ;
    output isolate_urt6       ;
    output save_edge_urt6   ;
    output restore_edge_urt6   ;
    output pwr1_on_urt6       ;
    output pwr2_on_urt6       ;
    output pwr1_off_urt6      ;
    output pwr2_off_urt6      ;
    // ETH06
    output rstn_non_srpg_macb06 ;
    output gate_clk_macb06      ;
    output isolate_macb06       ;
    output save_edge_macb06   ;
    output restore_edge_macb06   ;
    output pwr1_on_macb06       ;
    output pwr2_on_macb06       ;
    output pwr1_off_macb06      ;
    output pwr2_off_macb06      ;
    // ETH16
    output rstn_non_srpg_macb16 ;
    output gate_clk_macb16      ;
    output isolate_macb16       ;
    output save_edge_macb16   ;
    output restore_edge_macb16   ;
    output pwr1_on_macb16       ;
    output pwr2_on_macb16       ;
    output pwr1_off_macb16      ;
    output pwr2_off_macb16      ;
    // ETH26
    output rstn_non_srpg_macb26 ;
    output gate_clk_macb26      ;
    output isolate_macb26       ;
    output save_edge_macb26   ;
    output restore_edge_macb26   ;
    output pwr1_on_macb26       ;
    output pwr2_on_macb26       ;
    output pwr1_off_macb26      ;
    output pwr2_off_macb26      ;
    // ETH36
    output rstn_non_srpg_macb36 ;
    output gate_clk_macb36      ;
    output isolate_macb36       ;
    output save_edge_macb36   ;
    output restore_edge_macb36   ;
    output pwr1_on_macb36       ;
    output pwr2_on_macb36       ;
    output pwr1_off_macb36      ;
    output pwr2_off_macb36      ;
    // DMA6
    output rstn_non_srpg_dma6 ;
    output gate_clk_dma6      ;
    output isolate_dma6       ;
    output save_edge_dma6   ;
    output restore_edge_dma6   ;
    output pwr1_on_dma6       ;
    output pwr2_on_dma6       ;
    output pwr1_off_dma6      ;
    output pwr2_off_dma6      ;
    // CPU6
    output rstn_non_srpg_cpu6 ;
    output gate_clk_cpu6      ;
    output isolate_cpu6       ;
    output save_edge_cpu6   ;
    output restore_edge_cpu6   ;
    output pwr1_on_cpu6       ;
    output pwr2_on_cpu6       ;
    output pwr1_off_cpu6      ;
    output pwr2_off_cpu6      ;
    // ALUT6
    output rstn_non_srpg_alut6 ;
    output gate_clk_alut6      ;
    output isolate_alut6       ;
    output save_edge_alut6   ;
    output restore_edge_alut6   ;
    output pwr1_on_alut6       ;
    output pwr2_on_alut6       ;
    output pwr1_off_alut6      ;
    output pwr2_off_alut6      ;
    // MEM6
    output rstn_non_srpg_mem6 ;
    output gate_clk_mem6      ;
    output isolate_mem6       ;
    output save_edge_mem6   ;
    output restore_edge_mem6   ;
    output pwr1_on_mem6       ;
    output pwr2_on_mem6       ;
    output pwr1_off_mem6      ;
    output pwr2_off_mem6      ;


   // core6 transitions6 o/p
    output core06v6;
    output core08v6;
    output core10v6;
    output core12v6;
    output pcm_macb_wakeup_int6 ;
    //mode mte6  signals6
    output mte_smc_start6;
    output mte_uart_start6;
    output mte_smc_uart_start6;  
    output mte_pm_smc_to_default_start6; 
    output mte_pm_uart_to_default_start6;
    output mte_pm_smc_uart_to_default_start6;

    reg mte_smc_start6;
    reg mte_uart_start6;
    reg mte_smc_uart_start6;  
    reg mte_pm_smc_to_default_start6; 
    reg mte_pm_uart_to_default_start6;
    reg mte_pm_smc_uart_to_default_start6;

    reg [31:0] prdata6;

  wire valid_reg_write6  ;
  wire valid_reg_read6   ;
  wire L1_ctrl_access6   ;
  wire L1_status_access6 ;
  wire pcm_int_mask_access6;
  wire pcm_int_status_access6;
  wire standby_mem06      ;
  wire standby_mem16      ;
  wire standby_mem26      ;
  wire standby_mem36      ;
  wire pwr1_off_mem06;
  wire pwr1_off_mem16;
  wire pwr1_off_mem26;
  wire pwr1_off_mem36;
  
  // Control6 signals6
  wire set_status_smc6   ;
  wire clr_status_smc6   ;
  wire set_status_urt6   ;
  wire clr_status_urt6   ;
  wire set_status_macb06   ;
  wire clr_status_macb06   ;
  wire set_status_macb16   ;
  wire clr_status_macb16   ;
  wire set_status_macb26   ;
  wire clr_status_macb26   ;
  wire set_status_macb36   ;
  wire clr_status_macb36   ;
  wire set_status_dma6   ;
  wire clr_status_dma6   ;
  wire set_status_cpu6   ;
  wire clr_status_cpu6   ;
  wire set_status_alut6   ;
  wire clr_status_alut6   ;
  wire set_status_mem6   ;
  wire clr_status_mem6   ;


  // Status and Control6 registers
  reg [31:0]  L1_status_reg6;
  reg  [31:0] L1_ctrl_reg6  ;
  reg  [31:0] L1_ctrl_domain6  ;
  reg L1_ctrl_cpu_off_reg6;
  reg [31:0]  pcm_mask_reg6;
  reg [31:0]  pcm_status_reg6;

  // Signals6 gated6 in scan_mode6
  //SMC6
  wire  rstn_non_srpg_smc_int6;
  wire  gate_clk_smc_int6    ;     
  wire  isolate_smc_int6    ;       
  wire save_edge_smc_int6;
  wire restore_edge_smc_int6;
  wire  pwr1_on_smc_int6    ;      
  wire  pwr2_on_smc_int6    ;      


  //URT6
  wire   rstn_non_srpg_urt_int6;
  wire   gate_clk_urt_int6     ;     
  wire   isolate_urt_int6      ;       
  wire save_edge_urt_int6;
  wire restore_edge_urt_int6;
  wire   pwr1_on_urt_int6      ;      
  wire   pwr2_on_urt_int6      ;      

  // ETH06
  wire   rstn_non_srpg_macb0_int6;
  wire   gate_clk_macb0_int6     ;     
  wire   isolate_macb0_int6      ;       
  wire save_edge_macb0_int6;
  wire restore_edge_macb0_int6;
  wire   pwr1_on_macb0_int6      ;      
  wire   pwr2_on_macb0_int6      ;      
  // ETH16
  wire   rstn_non_srpg_macb1_int6;
  wire   gate_clk_macb1_int6     ;     
  wire   isolate_macb1_int6      ;       
  wire save_edge_macb1_int6;
  wire restore_edge_macb1_int6;
  wire   pwr1_on_macb1_int6      ;      
  wire   pwr2_on_macb1_int6      ;      
  // ETH26
  wire   rstn_non_srpg_macb2_int6;
  wire   gate_clk_macb2_int6     ;     
  wire   isolate_macb2_int6      ;       
  wire save_edge_macb2_int6;
  wire restore_edge_macb2_int6;
  wire   pwr1_on_macb2_int6      ;      
  wire   pwr2_on_macb2_int6      ;      
  // ETH36
  wire   rstn_non_srpg_macb3_int6;
  wire   gate_clk_macb3_int6     ;     
  wire   isolate_macb3_int6      ;       
  wire save_edge_macb3_int6;
  wire restore_edge_macb3_int6;
  wire   pwr1_on_macb3_int6      ;      
  wire   pwr2_on_macb3_int6      ;      

  // DMA6
  wire   rstn_non_srpg_dma_int6;
  wire   gate_clk_dma_int6     ;     
  wire   isolate_dma_int6      ;       
  wire save_edge_dma_int6;
  wire restore_edge_dma_int6;
  wire   pwr1_on_dma_int6      ;      
  wire   pwr2_on_dma_int6      ;      

  // CPU6
  wire   rstn_non_srpg_cpu_int6;
  wire   gate_clk_cpu_int6     ;     
  wire   isolate_cpu_int6      ;       
  wire save_edge_cpu_int6;
  wire restore_edge_cpu_int6;
  wire   pwr1_on_cpu_int6      ;      
  wire   pwr2_on_cpu_int6      ;  
  wire L1_ctrl_cpu_off_p6;    

  reg save_alut_tmp6;
  // DFS6 sm6

  reg cpu_shutoff_ctrl6;

  reg mte_mac_off_start6, mte_mac012_start6, mte_mac013_start6, mte_mac023_start6, mte_mac123_start6;
  reg mte_mac01_start6, mte_mac02_start6, mte_mac03_start6, mte_mac12_start6, mte_mac13_start6, mte_mac23_start6;
  reg mte_mac0_start6, mte_mac1_start6, mte_mac2_start6, mte_mac3_start6;
  reg mte_sys_hibernate6 ;
  reg mte_dma_start6 ;
  reg mte_cpu_start6 ;
  reg mte_mac_off_sleep_start6, mte_mac012_sleep_start6, mte_mac013_sleep_start6, mte_mac023_sleep_start6, mte_mac123_sleep_start6;
  reg mte_mac01_sleep_start6, mte_mac02_sleep_start6, mte_mac03_sleep_start6, mte_mac12_sleep_start6, mte_mac13_sleep_start6, mte_mac23_sleep_start6;
  reg mte_mac0_sleep_start6, mte_mac1_sleep_start6, mte_mac2_sleep_start6, mte_mac3_sleep_start6;
  reg mte_dma_sleep_start6;
  reg mte_mac_off_to_default6, mte_mac012_to_default6, mte_mac013_to_default6, mte_mac023_to_default6, mte_mac123_to_default6;
  reg mte_mac01_to_default6, mte_mac02_to_default6, mte_mac03_to_default6, mte_mac12_to_default6, mte_mac13_to_default6, mte_mac23_to_default6;
  reg mte_mac0_to_default6, mte_mac1_to_default6, mte_mac2_to_default6, mte_mac3_to_default6;
  reg mte_dma_isolate_dis6;
  reg mte_cpu_isolate_dis6;
  reg mte_sys_hibernate_to_default6;


  // Latch6 the CPU6 SLEEP6 invocation6
  always @( posedge pclk6 or negedge nprst6) 
  begin
    if(!nprst6)
      L1_ctrl_cpu_off_reg6 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg6 <= L1_ctrl_domain6[8];
  end

  // Create6 a pulse6 for sleep6 detection6 
  assign L1_ctrl_cpu_off_p6 =  L1_ctrl_domain6[8] && !L1_ctrl_cpu_off_reg6;
  
  // CPU6 sleep6 contol6 logic 
  // Shut6 off6 CPU6 when L1_ctrl_cpu_off_p6 is set
  // wake6 cpu6 when any interrupt6 is seen6  
  always @( posedge pclk6 or negedge nprst6) 
  begin
    if(!nprst6)
     cpu_shutoff_ctrl6 <= 1'b0;
    else if(cpu_shutoff_ctrl6 && int_source_h6)
     cpu_shutoff_ctrl6 <= 1'b0;
    else if (L1_ctrl_cpu_off_p6)
     cpu_shutoff_ctrl6 <= 1'b1;
  end
 
  // instantiate6 power6 contol6  block for uart6
  power_ctrl_sm6 i_urt_power_ctrl_sm6(
    .pclk6(pclk6),
    .nprst6(nprst6),
    .L1_module_req6(L1_ctrl_domain6[1]),
    .set_status_module6(set_status_urt6),
    .clr_status_module6(clr_status_urt6),
    .rstn_non_srpg_module6(rstn_non_srpg_urt_int6),
    .gate_clk_module6(gate_clk_urt_int6),
    .isolate_module6(isolate_urt_int6),
    .save_edge6(save_edge_urt_int6),
    .restore_edge6(restore_edge_urt_int6),
    .pwr1_on6(pwr1_on_urt_int6),
    .pwr2_on6(pwr2_on_urt_int6)
    );
  

  // instantiate6 power6 contol6  block for smc6
  power_ctrl_sm6 i_smc_power_ctrl_sm6(
    .pclk6(pclk6),
    .nprst6(nprst6),
    .L1_module_req6(L1_ctrl_domain6[2]),
    .set_status_module6(set_status_smc6),
    .clr_status_module6(clr_status_smc6),
    .rstn_non_srpg_module6(rstn_non_srpg_smc_int6),
    .gate_clk_module6(gate_clk_smc_int6),
    .isolate_module6(isolate_smc_int6),
    .save_edge6(save_edge_smc_int6),
    .restore_edge6(restore_edge_smc_int6),
    .pwr1_on6(pwr1_on_smc_int6),
    .pwr2_on6(pwr2_on_smc_int6)
    );

  // power6 control6 for macb06
  power_ctrl_sm6 i_macb0_power_ctrl_sm6(
    .pclk6(pclk6),
    .nprst6(nprst6),
    .L1_module_req6(L1_ctrl_domain6[3]),
    .set_status_module6(set_status_macb06),
    .clr_status_module6(clr_status_macb06),
    .rstn_non_srpg_module6(rstn_non_srpg_macb0_int6),
    .gate_clk_module6(gate_clk_macb0_int6),
    .isolate_module6(isolate_macb0_int6),
    .save_edge6(save_edge_macb0_int6),
    .restore_edge6(restore_edge_macb0_int6),
    .pwr1_on6(pwr1_on_macb0_int6),
    .pwr2_on6(pwr2_on_macb0_int6)
    );
  // power6 control6 for macb16
  power_ctrl_sm6 i_macb1_power_ctrl_sm6(
    .pclk6(pclk6),
    .nprst6(nprst6),
    .L1_module_req6(L1_ctrl_domain6[4]),
    .set_status_module6(set_status_macb16),
    .clr_status_module6(clr_status_macb16),
    .rstn_non_srpg_module6(rstn_non_srpg_macb1_int6),
    .gate_clk_module6(gate_clk_macb1_int6),
    .isolate_module6(isolate_macb1_int6),
    .save_edge6(save_edge_macb1_int6),
    .restore_edge6(restore_edge_macb1_int6),
    .pwr1_on6(pwr1_on_macb1_int6),
    .pwr2_on6(pwr2_on_macb1_int6)
    );
  // power6 control6 for macb26
  power_ctrl_sm6 i_macb2_power_ctrl_sm6(
    .pclk6(pclk6),
    .nprst6(nprst6),
    .L1_module_req6(L1_ctrl_domain6[5]),
    .set_status_module6(set_status_macb26),
    .clr_status_module6(clr_status_macb26),
    .rstn_non_srpg_module6(rstn_non_srpg_macb2_int6),
    .gate_clk_module6(gate_clk_macb2_int6),
    .isolate_module6(isolate_macb2_int6),
    .save_edge6(save_edge_macb2_int6),
    .restore_edge6(restore_edge_macb2_int6),
    .pwr1_on6(pwr1_on_macb2_int6),
    .pwr2_on6(pwr2_on_macb2_int6)
    );
  // power6 control6 for macb36
  power_ctrl_sm6 i_macb3_power_ctrl_sm6(
    .pclk6(pclk6),
    .nprst6(nprst6),
    .L1_module_req6(L1_ctrl_domain6[6]),
    .set_status_module6(set_status_macb36),
    .clr_status_module6(clr_status_macb36),
    .rstn_non_srpg_module6(rstn_non_srpg_macb3_int6),
    .gate_clk_module6(gate_clk_macb3_int6),
    .isolate_module6(isolate_macb3_int6),
    .save_edge6(save_edge_macb3_int6),
    .restore_edge6(restore_edge_macb3_int6),
    .pwr1_on6(pwr1_on_macb3_int6),
    .pwr2_on6(pwr2_on_macb3_int6)
    );
  // power6 control6 for dma6
  power_ctrl_sm6 i_dma_power_ctrl_sm6(
    .pclk6(pclk6),
    .nprst6(nprst6),
    .L1_module_req6(L1_ctrl_domain6[7]),
    .set_status_module6(set_status_dma6),
    .clr_status_module6(clr_status_dma6),
    .rstn_non_srpg_module6(rstn_non_srpg_dma_int6),
    .gate_clk_module6(gate_clk_dma_int6),
    .isolate_module6(isolate_dma_int6),
    .save_edge6(save_edge_dma_int6),
    .restore_edge6(restore_edge_dma_int6),
    .pwr1_on6(pwr1_on_dma_int6),
    .pwr2_on6(pwr2_on_dma_int6)
    );
  // power6 control6 for CPU6
  power_ctrl_sm6 i_cpu_power_ctrl_sm6(
    .pclk6(pclk6),
    .nprst6(nprst6),
    .L1_module_req6(cpu_shutoff_ctrl6),
    .set_status_module6(set_status_cpu6),
    .clr_status_module6(clr_status_cpu6),
    .rstn_non_srpg_module6(rstn_non_srpg_cpu_int6),
    .gate_clk_module6(gate_clk_cpu_int6),
    .isolate_module6(isolate_cpu_int6),
    .save_edge6(save_edge_cpu_int6),
    .restore_edge6(restore_edge_cpu_int6),
    .pwr1_on6(pwr1_on_cpu_int6),
    .pwr2_on6(pwr2_on_cpu_int6)
    );

  assign valid_reg_write6 =  (psel6 && pwrite6 && penable6);
  assign valid_reg_read6  =  (psel6 && (!pwrite6) && penable6);

  assign L1_ctrl_access6  =  (paddr6[15:0] == 16'b0000000000000100); 
  assign L1_status_access6 = (paddr6[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access6 =   (paddr6[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access6 = (paddr6[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control6 and status register
  always @(*)
  begin  
    if(valid_reg_read6 && L1_ctrl_access6) 
      prdata6 = L1_ctrl_reg6;
    else if (valid_reg_read6 && L1_status_access6)
      prdata6 = L1_status_reg6;
    else if (valid_reg_read6 && pcm_int_mask_access6)
      prdata6 = pcm_mask_reg6;
    else if (valid_reg_read6 && pcm_int_status_access6)
      prdata6 = pcm_status_reg6;
    else 
      prdata6 = 0;
  end

  assign set_status_mem6 =  (set_status_macb06 && set_status_macb16 && set_status_macb26 &&
                            set_status_macb36 && set_status_dma6 && set_status_cpu6);

  assign clr_status_mem6 =  (clr_status_macb06 && clr_status_macb16 && clr_status_macb26 &&
                            clr_status_macb36 && clr_status_dma6 && clr_status_cpu6);

  assign set_status_alut6 = (set_status_macb06 && set_status_macb16 && set_status_macb26 && set_status_macb36);

  assign clr_status_alut6 = (clr_status_macb06 || clr_status_macb16 || clr_status_macb26  || clr_status_macb36);

  // Write accesses to the control6 and status register
 
  always @(posedge pclk6 or negedge nprst6)
  begin
    if (!nprst6) begin
      L1_ctrl_reg6   <= 0;
      L1_status_reg6 <= 0;
      pcm_mask_reg6 <= 0;
    end else begin
      // CTRL6 reg updates6
      if (valid_reg_write6 && L1_ctrl_access6) 
        L1_ctrl_reg6 <= pwdata6; // Writes6 to the ctrl6 reg
      if (valid_reg_write6 && pcm_int_mask_access6) 
        pcm_mask_reg6 <= pwdata6; // Writes6 to the ctrl6 reg

      if (set_status_urt6 == 1'b1)  
        L1_status_reg6[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt6 == 1'b1) 
        L1_status_reg6[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc6 == 1'b1) 
        L1_status_reg6[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc6 == 1'b1) 
        L1_status_reg6[2] <= 1'b0; // Clear the status bit

      if (set_status_macb06 == 1'b1)  
        L1_status_reg6[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb06 == 1'b1) 
        L1_status_reg6[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb16 == 1'b1)  
        L1_status_reg6[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb16 == 1'b1) 
        L1_status_reg6[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb26 == 1'b1)  
        L1_status_reg6[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb26 == 1'b1) 
        L1_status_reg6[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb36 == 1'b1)  
        L1_status_reg6[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb36 == 1'b1) 
        L1_status_reg6[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma6 == 1'b1)  
        L1_status_reg6[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma6 == 1'b1) 
        L1_status_reg6[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu6 == 1'b1)  
        L1_status_reg6[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu6 == 1'b1) 
        L1_status_reg6[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut6 == 1'b1)  
        L1_status_reg6[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut6 == 1'b1) 
        L1_status_reg6[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem6 == 1'b1)  
        L1_status_reg6[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem6 == 1'b1) 
        L1_status_reg6[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused6 bits of pcm_status_reg6 are tied6 to 0
  always @(posedge pclk6 or negedge nprst6)
  begin
    if (!nprst6)
      pcm_status_reg6[31:4] <= 'b0;
    else  
      pcm_status_reg6[31:4] <= pcm_status_reg6[31:4];
  end
  
  // interrupt6 only of h/w assisted6 wakeup
  // MAC6 3
  always @(posedge pclk6 or negedge nprst6)
  begin
    if(!nprst6)
      pcm_status_reg6[3] <= 1'b0;
    else if (valid_reg_write6 && pcm_int_status_access6) 
      pcm_status_reg6[3] <= pwdata6[3];
    else if (macb3_wakeup6 & ~pcm_mask_reg6[3])
      pcm_status_reg6[3] <= 1'b1;
    else if (valid_reg_read6 && pcm_int_status_access6) 
      pcm_status_reg6[3] <= 1'b0;
    else
      pcm_status_reg6[3] <= pcm_status_reg6[3];
  end  
   
  // MAC6 2
  always @(posedge pclk6 or negedge nprst6)
  begin
    if(!nprst6)
      pcm_status_reg6[2] <= 1'b0;
    else if (valid_reg_write6 && pcm_int_status_access6) 
      pcm_status_reg6[2] <= pwdata6[2];
    else if (macb2_wakeup6 & ~pcm_mask_reg6[2])
      pcm_status_reg6[2] <= 1'b1;
    else if (valid_reg_read6 && pcm_int_status_access6) 
      pcm_status_reg6[2] <= 1'b0;
    else
      pcm_status_reg6[2] <= pcm_status_reg6[2];
  end  

  // MAC6 1
  always @(posedge pclk6 or negedge nprst6)
  begin
    if(!nprst6)
      pcm_status_reg6[1] <= 1'b0;
    else if (valid_reg_write6 && pcm_int_status_access6) 
      pcm_status_reg6[1] <= pwdata6[1];
    else if (macb1_wakeup6 & ~pcm_mask_reg6[1])
      pcm_status_reg6[1] <= 1'b1;
    else if (valid_reg_read6 && pcm_int_status_access6) 
      pcm_status_reg6[1] <= 1'b0;
    else
      pcm_status_reg6[1] <= pcm_status_reg6[1];
  end  
   
  // MAC6 0
  always @(posedge pclk6 or negedge nprst6)
  begin
    if(!nprst6)
      pcm_status_reg6[0] <= 1'b0;
    else if (valid_reg_write6 && pcm_int_status_access6) 
      pcm_status_reg6[0] <= pwdata6[0];
    else if (macb0_wakeup6 & ~pcm_mask_reg6[0])
      pcm_status_reg6[0] <= 1'b1;
    else if (valid_reg_read6 && pcm_int_status_access6) 
      pcm_status_reg6[0] <= 1'b0;
    else
      pcm_status_reg6[0] <= pcm_status_reg6[0];
  end  

  assign pcm_macb_wakeup_int6 = |pcm_status_reg6;

  reg [31:0] L1_ctrl_reg16;
  always @(posedge pclk6 or negedge nprst6)
  begin
    if(!nprst6)
      L1_ctrl_reg16 <= 0;
    else
      L1_ctrl_reg16 <= L1_ctrl_reg6;
  end

  // Program6 mode decode
  always @(L1_ctrl_reg6 or L1_ctrl_reg16 or int_source_h6 or cpu_shutoff_ctrl6) begin
    mte_smc_start6 = 0;
    mte_uart_start6 = 0;
    mte_smc_uart_start6  = 0;
    mte_mac_off_start6  = 0;
    mte_mac012_start6 = 0;
    mte_mac013_start6 = 0;
    mte_mac023_start6 = 0;
    mte_mac123_start6 = 0;
    mte_mac01_start6 = 0;
    mte_mac02_start6 = 0;
    mte_mac03_start6 = 0;
    mte_mac12_start6 = 0;
    mte_mac13_start6 = 0;
    mte_mac23_start6 = 0;
    mte_mac0_start6 = 0;
    mte_mac1_start6 = 0;
    mte_mac2_start6 = 0;
    mte_mac3_start6 = 0;
    mte_sys_hibernate6 = 0 ;
    mte_dma_start6 = 0 ;
    mte_cpu_start6 = 0 ;

    mte_mac0_sleep_start6 = (L1_ctrl_reg6 ==  'h14) && (L1_ctrl_reg16 == 'h4 );
    mte_mac1_sleep_start6 = (L1_ctrl_reg6 ==  'h14) && (L1_ctrl_reg16 == 'h5 ); 
    mte_mac2_sleep_start6 = (L1_ctrl_reg6 ==  'h14) && (L1_ctrl_reg16 == 'h6 ); 
    mte_mac3_sleep_start6 = (L1_ctrl_reg6 ==  'h14) && (L1_ctrl_reg16 == 'h7 ); 
    mte_mac01_sleep_start6 = (L1_ctrl_reg6 ==  'h14) && (L1_ctrl_reg16 == 'h8 ); 
    mte_mac02_sleep_start6 = (L1_ctrl_reg6 ==  'h14) && (L1_ctrl_reg16 == 'h9 ); 
    mte_mac03_sleep_start6 = (L1_ctrl_reg6 ==  'h14) && (L1_ctrl_reg16 == 'hA ); 
    mte_mac12_sleep_start6 = (L1_ctrl_reg6 ==  'h14) && (L1_ctrl_reg16 == 'hB ); 
    mte_mac13_sleep_start6 = (L1_ctrl_reg6 ==  'h14) && (L1_ctrl_reg16 == 'hC ); 
    mte_mac23_sleep_start6 = (L1_ctrl_reg6 ==  'h14) && (L1_ctrl_reg16 == 'hD ); 
    mte_mac012_sleep_start6 = (L1_ctrl_reg6 ==  'h14) && (L1_ctrl_reg16 == 'hE ); 
    mte_mac013_sleep_start6 = (L1_ctrl_reg6 ==  'h14) && (L1_ctrl_reg16 == 'hF ); 
    mte_mac023_sleep_start6 = (L1_ctrl_reg6 ==  'h14) && (L1_ctrl_reg16 == 'h10 ); 
    mte_mac123_sleep_start6 = (L1_ctrl_reg6 ==  'h14) && (L1_ctrl_reg16 == 'h11 ); 
    mte_mac_off_sleep_start6 =  (L1_ctrl_reg6 == 'h14) && (L1_ctrl_reg16 == 'h12 );
    mte_dma_sleep_start6 =  (L1_ctrl_reg6 == 'h14) && (L1_ctrl_reg16 == 'h13 );

    mte_pm_uart_to_default_start6 = (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'h1);
    mte_pm_smc_to_default_start6 = (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'h2);
    mte_pm_smc_uart_to_default_start6 = (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'h3); 
    mte_mac0_to_default6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'h4); 
    mte_mac1_to_default6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'h5); 
    mte_mac2_to_default6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'h6); 
    mte_mac3_to_default6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'h7); 
    mte_mac01_to_default6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'h8); 
    mte_mac02_to_default6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'h9); 
    mte_mac03_to_default6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'hA); 
    mte_mac12_to_default6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'hB); 
    mte_mac13_to_default6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'hC); 
    mte_mac23_to_default6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'hD); 
    mte_mac012_to_default6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'hE); 
    mte_mac013_to_default6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'hF); 
    mte_mac023_to_default6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'h10); 
    mte_mac123_to_default6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'h11); 
    mte_mac_off_to_default6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'h12); 
    mte_dma_isolate_dis6 =  (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'h13); 
    mte_cpu_isolate_dis6 =  (int_source_h6) && (cpu_shutoff_ctrl6) && (L1_ctrl_reg6 != 'h15);
    mte_sys_hibernate_to_default6 = (L1_ctrl_reg6 == 32'h0) && (L1_ctrl_reg16 == 'h15); 

   
    if (L1_ctrl_reg16 == 'h0) begin // This6 check is to make mte_cpu_start6
                                   // is set only when you from default state 
      case (L1_ctrl_reg6)
        'h0 : L1_ctrl_domain6 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain6 = 32'h2; // PM_uart6
                mte_uart_start6 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain6 = 32'h4; // PM_smc6
                mte_smc_start6 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain6 = 32'h6; // PM_smc_uart6
                mte_smc_uart_start6 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain6 = 32'h8; //  PM_macb06
                mte_mac0_start6 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain6 = 32'h10; //  PM_macb16
                mte_mac1_start6 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain6 = 32'h20; //  PM_macb26
                mte_mac2_start6 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain6 = 32'h40; //  PM_macb36
                mte_mac3_start6 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain6 = 32'h18; //  PM_macb016
                mte_mac01_start6 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain6 = 32'h28; //  PM_macb026
                mte_mac02_start6 = 1;
              end
        'hA : begin  
                L1_ctrl_domain6 = 32'h48; //  PM_macb036
                mte_mac03_start6 = 1;
              end
        'hB : begin  
                L1_ctrl_domain6 = 32'h30; //  PM_macb126
                mte_mac12_start6 = 1;
              end
        'hC : begin  
                L1_ctrl_domain6 = 32'h50; //  PM_macb136
                mte_mac13_start6 = 1;
              end
        'hD : begin  
                L1_ctrl_domain6 = 32'h60; //  PM_macb236
                mte_mac23_start6 = 1;
              end
        'hE : begin  
                L1_ctrl_domain6 = 32'h38; //  PM_macb0126
                mte_mac012_start6 = 1;
              end
        'hF : begin  
                L1_ctrl_domain6 = 32'h58; //  PM_macb0136
                mte_mac013_start6 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain6 = 32'h68; //  PM_macb0236
                mte_mac023_start6 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain6 = 32'h70; //  PM_macb1236
                mte_mac123_start6 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain6 = 32'h78; //  PM_macb_off6
                mte_mac_off_start6 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain6 = 32'h80; //  PM_dma6
                mte_dma_start6 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain6 = 32'h100; //  PM_cpu_sleep6
                mte_cpu_start6 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain6 = 32'h1FE; //  PM_hibernate6
                mte_sys_hibernate6 = 1;
              end
         default: L1_ctrl_domain6 = 32'h0;
      endcase
    end
  end


  wire to_default6 = (L1_ctrl_reg6 == 0);

  // Scan6 mode gating6 of power6 and isolation6 control6 signals6
  //SMC6
  assign rstn_non_srpg_smc6  = (scan_mode6 == 1'b0) ? rstn_non_srpg_smc_int6 : 1'b1;  
  assign gate_clk_smc6       = (scan_mode6 == 1'b0) ? gate_clk_smc_int6 : 1'b0;     
  assign isolate_smc6        = (scan_mode6 == 1'b0) ? isolate_smc_int6 : 1'b0;      
  assign pwr1_on_smc6        = (scan_mode6 == 1'b0) ? pwr1_on_smc_int6 : 1'b1;       
  assign pwr2_on_smc6        = (scan_mode6 == 1'b0) ? pwr2_on_smc_int6 : 1'b1;       
  assign pwr1_off_smc6       = (scan_mode6 == 1'b0) ? (!pwr1_on_smc_int6) : 1'b0;       
  assign pwr2_off_smc6       = (scan_mode6 == 1'b0) ? (!pwr2_on_smc_int6) : 1'b0;       
  assign save_edge_smc6       = (scan_mode6 == 1'b0) ? (save_edge_smc_int6) : 1'b0;       
  assign restore_edge_smc6       = (scan_mode6 == 1'b0) ? (restore_edge_smc_int6) : 1'b0;       

  //URT6
  assign rstn_non_srpg_urt6  = (scan_mode6 == 1'b0) ?  rstn_non_srpg_urt_int6 : 1'b1;  
  assign gate_clk_urt6       = (scan_mode6 == 1'b0) ?  gate_clk_urt_int6      : 1'b0;     
  assign isolate_urt6        = (scan_mode6 == 1'b0) ?  isolate_urt_int6       : 1'b0;      
  assign pwr1_on_urt6        = (scan_mode6 == 1'b0) ?  pwr1_on_urt_int6       : 1'b1;       
  assign pwr2_on_urt6        = (scan_mode6 == 1'b0) ?  pwr2_on_urt_int6       : 1'b1;       
  assign pwr1_off_urt6       = (scan_mode6 == 1'b0) ?  (!pwr1_on_urt_int6)  : 1'b0;       
  assign pwr2_off_urt6       = (scan_mode6 == 1'b0) ?  (!pwr2_on_urt_int6)  : 1'b0;       
  assign save_edge_urt6       = (scan_mode6 == 1'b0) ? (save_edge_urt_int6) : 1'b0;       
  assign restore_edge_urt6       = (scan_mode6 == 1'b0) ? (restore_edge_urt_int6) : 1'b0;       

  //ETH06
  assign rstn_non_srpg_macb06 = (scan_mode6 == 1'b0) ?  rstn_non_srpg_macb0_int6 : 1'b1;  
  assign gate_clk_macb06       = (scan_mode6 == 1'b0) ?  gate_clk_macb0_int6      : 1'b0;     
  assign isolate_macb06        = (scan_mode6 == 1'b0) ?  isolate_macb0_int6       : 1'b0;      
  assign pwr1_on_macb06        = (scan_mode6 == 1'b0) ?  pwr1_on_macb0_int6       : 1'b1;       
  assign pwr2_on_macb06        = (scan_mode6 == 1'b0) ?  pwr2_on_macb0_int6       : 1'b1;       
  assign pwr1_off_macb06       = (scan_mode6 == 1'b0) ?  (!pwr1_on_macb0_int6)  : 1'b0;       
  assign pwr2_off_macb06       = (scan_mode6 == 1'b0) ?  (!pwr2_on_macb0_int6)  : 1'b0;       
  assign save_edge_macb06       = (scan_mode6 == 1'b0) ? (save_edge_macb0_int6) : 1'b0;       
  assign restore_edge_macb06       = (scan_mode6 == 1'b0) ? (restore_edge_macb0_int6) : 1'b0;       

  //ETH16
  assign rstn_non_srpg_macb16 = (scan_mode6 == 1'b0) ?  rstn_non_srpg_macb1_int6 : 1'b1;  
  assign gate_clk_macb16       = (scan_mode6 == 1'b0) ?  gate_clk_macb1_int6      : 1'b0;     
  assign isolate_macb16        = (scan_mode6 == 1'b0) ?  isolate_macb1_int6       : 1'b0;      
  assign pwr1_on_macb16        = (scan_mode6 == 1'b0) ?  pwr1_on_macb1_int6       : 1'b1;       
  assign pwr2_on_macb16        = (scan_mode6 == 1'b0) ?  pwr2_on_macb1_int6       : 1'b1;       
  assign pwr1_off_macb16       = (scan_mode6 == 1'b0) ?  (!pwr1_on_macb1_int6)  : 1'b0;       
  assign pwr2_off_macb16       = (scan_mode6 == 1'b0) ?  (!pwr2_on_macb1_int6)  : 1'b0;       
  assign save_edge_macb16       = (scan_mode6 == 1'b0) ? (save_edge_macb1_int6) : 1'b0;       
  assign restore_edge_macb16       = (scan_mode6 == 1'b0) ? (restore_edge_macb1_int6) : 1'b0;       

  //ETH26
  assign rstn_non_srpg_macb26 = (scan_mode6 == 1'b0) ?  rstn_non_srpg_macb2_int6 : 1'b1;  
  assign gate_clk_macb26       = (scan_mode6 == 1'b0) ?  gate_clk_macb2_int6      : 1'b0;     
  assign isolate_macb26        = (scan_mode6 == 1'b0) ?  isolate_macb2_int6       : 1'b0;      
  assign pwr1_on_macb26        = (scan_mode6 == 1'b0) ?  pwr1_on_macb2_int6       : 1'b1;       
  assign pwr2_on_macb26        = (scan_mode6 == 1'b0) ?  pwr2_on_macb2_int6       : 1'b1;       
  assign pwr1_off_macb26       = (scan_mode6 == 1'b0) ?  (!pwr1_on_macb2_int6)  : 1'b0;       
  assign pwr2_off_macb26       = (scan_mode6 == 1'b0) ?  (!pwr2_on_macb2_int6)  : 1'b0;       
  assign save_edge_macb26       = (scan_mode6 == 1'b0) ? (save_edge_macb2_int6) : 1'b0;       
  assign restore_edge_macb26       = (scan_mode6 == 1'b0) ? (restore_edge_macb2_int6) : 1'b0;       

  //ETH36
  assign rstn_non_srpg_macb36 = (scan_mode6 == 1'b0) ?  rstn_non_srpg_macb3_int6 : 1'b1;  
  assign gate_clk_macb36       = (scan_mode6 == 1'b0) ?  gate_clk_macb3_int6      : 1'b0;     
  assign isolate_macb36        = (scan_mode6 == 1'b0) ?  isolate_macb3_int6       : 1'b0;      
  assign pwr1_on_macb36        = (scan_mode6 == 1'b0) ?  pwr1_on_macb3_int6       : 1'b1;       
  assign pwr2_on_macb36        = (scan_mode6 == 1'b0) ?  pwr2_on_macb3_int6       : 1'b1;       
  assign pwr1_off_macb36       = (scan_mode6 == 1'b0) ?  (!pwr1_on_macb3_int6)  : 1'b0;       
  assign pwr2_off_macb36       = (scan_mode6 == 1'b0) ?  (!pwr2_on_macb3_int6)  : 1'b0;       
  assign save_edge_macb36       = (scan_mode6 == 1'b0) ? (save_edge_macb3_int6) : 1'b0;       
  assign restore_edge_macb36       = (scan_mode6 == 1'b0) ? (restore_edge_macb3_int6) : 1'b0;       

  // MEM6
  assign rstn_non_srpg_mem6 =   (rstn_non_srpg_macb06 && rstn_non_srpg_macb16 && rstn_non_srpg_macb26 &&
                                rstn_non_srpg_macb36 && rstn_non_srpg_dma6 && rstn_non_srpg_cpu6 && rstn_non_srpg_urt6 &&
                                rstn_non_srpg_smc6);

  assign gate_clk_mem6 =  (gate_clk_macb06 && gate_clk_macb16 && gate_clk_macb26 &&
                            gate_clk_macb36 && gate_clk_dma6 && gate_clk_cpu6 && gate_clk_urt6 && gate_clk_smc6);

  assign isolate_mem6  = (isolate_macb06 && isolate_macb16 && isolate_macb26 &&
                         isolate_macb36 && isolate_dma6 && isolate_cpu6 && isolate_urt6 && isolate_smc6);


  assign pwr1_on_mem6        =   ~pwr1_off_mem6;

  assign pwr2_on_mem6        =   ~pwr2_off_mem6;

  assign pwr1_off_mem6       =  (pwr1_off_macb06 && pwr1_off_macb16 && pwr1_off_macb26 &&
                                 pwr1_off_macb36 && pwr1_off_dma6 && pwr1_off_cpu6 && pwr1_off_urt6 && pwr1_off_smc6);


  assign pwr2_off_mem6       =  (pwr2_off_macb06 && pwr2_off_macb16 && pwr2_off_macb26 &&
                                pwr2_off_macb36 && pwr2_off_dma6 && pwr2_off_cpu6 && pwr2_off_urt6 && pwr2_off_smc6);

  assign save_edge_mem6      =  (save_edge_macb06 && save_edge_macb16 && save_edge_macb26 &&
                                save_edge_macb36 && save_edge_dma6 && save_edge_cpu6 && save_edge_smc6 && save_edge_urt6);

  assign restore_edge_mem6   =  (restore_edge_macb06 && restore_edge_macb16 && restore_edge_macb26  &&
                                restore_edge_macb36 && restore_edge_dma6 && restore_edge_cpu6 && restore_edge_urt6 &&
                                restore_edge_smc6);

  assign standby_mem06 = pwr1_off_macb06 && (~ (pwr1_off_macb06 && pwr1_off_macb16 && pwr1_off_macb26 && pwr1_off_macb36 && pwr1_off_urt6 && pwr1_off_smc6 && pwr1_off_dma6 && pwr1_off_cpu6));
  assign standby_mem16 = pwr1_off_macb16 && (~ (pwr1_off_macb06 && pwr1_off_macb16 && pwr1_off_macb26 && pwr1_off_macb36 && pwr1_off_urt6 && pwr1_off_smc6 && pwr1_off_dma6 && pwr1_off_cpu6));
  assign standby_mem26 = pwr1_off_macb26 && (~ (pwr1_off_macb06 && pwr1_off_macb16 && pwr1_off_macb26 && pwr1_off_macb36 && pwr1_off_urt6 && pwr1_off_smc6 && pwr1_off_dma6 && pwr1_off_cpu6));
  assign standby_mem36 = pwr1_off_macb36 && (~ (pwr1_off_macb06 && pwr1_off_macb16 && pwr1_off_macb26 && pwr1_off_macb36 && pwr1_off_urt6 && pwr1_off_smc6 && pwr1_off_dma6 && pwr1_off_cpu6));

  assign pwr1_off_mem06 = pwr1_off_mem6;
  assign pwr1_off_mem16 = pwr1_off_mem6;
  assign pwr1_off_mem26 = pwr1_off_mem6;
  assign pwr1_off_mem36 = pwr1_off_mem6;

  assign rstn_non_srpg_alut6  =  (rstn_non_srpg_macb06 && rstn_non_srpg_macb16 && rstn_non_srpg_macb26 && rstn_non_srpg_macb36);


   assign gate_clk_alut6       =  (gate_clk_macb06 && gate_clk_macb16 && gate_clk_macb26 && gate_clk_macb36);


    assign isolate_alut6        =  (isolate_macb06 && isolate_macb16 && isolate_macb26 && isolate_macb36);


    assign pwr1_on_alut6        =  (pwr1_on_macb06 || pwr1_on_macb16 || pwr1_on_macb26 || pwr1_on_macb36);


    assign pwr2_on_alut6        =  (pwr2_on_macb06 || pwr2_on_macb16 || pwr2_on_macb26 || pwr2_on_macb36);


    assign pwr1_off_alut6       =  (pwr1_off_macb06 && pwr1_off_macb16 && pwr1_off_macb26 && pwr1_off_macb36);


    assign pwr2_off_alut6       =  (pwr2_off_macb06 && pwr2_off_macb16 && pwr2_off_macb26 && pwr2_off_macb36);


    assign save_edge_alut6      =  (save_edge_macb06 && save_edge_macb16 && save_edge_macb26 && save_edge_macb36);


    assign restore_edge_alut6   =  (restore_edge_macb06 || restore_edge_macb16 || restore_edge_macb26 ||
                                   restore_edge_macb36) && save_alut_tmp6;

     // alut6 power6 off6 detection6
  always @(posedge pclk6 or negedge nprst6) begin
    if (!nprst6) 
       save_alut_tmp6 <= 0;
    else if (restore_edge_alut6)
       save_alut_tmp6 <= 0;
    else if (save_edge_alut6)
       save_alut_tmp6 <= 1;
  end

  //DMA6
  assign rstn_non_srpg_dma6 = (scan_mode6 == 1'b0) ?  rstn_non_srpg_dma_int6 : 1'b1;  
  assign gate_clk_dma6       = (scan_mode6 == 1'b0) ?  gate_clk_dma_int6      : 1'b0;     
  assign isolate_dma6        = (scan_mode6 == 1'b0) ?  isolate_dma_int6       : 1'b0;      
  assign pwr1_on_dma6        = (scan_mode6 == 1'b0) ?  pwr1_on_dma_int6       : 1'b1;       
  assign pwr2_on_dma6        = (scan_mode6 == 1'b0) ?  pwr2_on_dma_int6       : 1'b1;       
  assign pwr1_off_dma6       = (scan_mode6 == 1'b0) ?  (!pwr1_on_dma_int6)  : 1'b0;       
  assign pwr2_off_dma6       = (scan_mode6 == 1'b0) ?  (!pwr2_on_dma_int6)  : 1'b0;       
  assign save_edge_dma6       = (scan_mode6 == 1'b0) ? (save_edge_dma_int6) : 1'b0;       
  assign restore_edge_dma6       = (scan_mode6 == 1'b0) ? (restore_edge_dma_int6) : 1'b0;       

  //CPU6
  assign rstn_non_srpg_cpu6 = (scan_mode6 == 1'b0) ?  rstn_non_srpg_cpu_int6 : 1'b1;  
  assign gate_clk_cpu6       = (scan_mode6 == 1'b0) ?  gate_clk_cpu_int6      : 1'b0;     
  assign isolate_cpu6        = (scan_mode6 == 1'b0) ?  isolate_cpu_int6       : 1'b0;      
  assign pwr1_on_cpu6        = (scan_mode6 == 1'b0) ?  pwr1_on_cpu_int6       : 1'b1;       
  assign pwr2_on_cpu6        = (scan_mode6 == 1'b0) ?  pwr2_on_cpu_int6       : 1'b1;       
  assign pwr1_off_cpu6       = (scan_mode6 == 1'b0) ?  (!pwr1_on_cpu_int6)  : 1'b0;       
  assign pwr2_off_cpu6       = (scan_mode6 == 1'b0) ?  (!pwr2_on_cpu_int6)  : 1'b0;       
  assign save_edge_cpu6       = (scan_mode6 == 1'b0) ? (save_edge_cpu_int6) : 1'b0;       
  assign restore_edge_cpu6       = (scan_mode6 == 1'b0) ? (restore_edge_cpu_int6) : 1'b0;       



  // ASE6

   reg ase_core_12v6, ase_core_10v6, ase_core_08v6, ase_core_06v6;
   reg ase_macb0_12v6,ase_macb1_12v6,ase_macb2_12v6,ase_macb3_12v6;

    // core6 ase6

    // core6 at 1.0 v if (smc6 off6, urt6 off6, macb06 off6, macb16 off6, macb26 off6, macb36 off6
   // core6 at 0.8v if (mac01off6, macb02off6, macb03off6, macb12off6, mac13off6, mac23off6,
   // core6 at 0.6v if (mac012off6, mac013off6, mac023off6, mac123off6, mac0123off6
    // else core6 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb06 && pwr1_off_macb16 && pwr1_off_macb26 && pwr1_off_macb36) || // all mac6 off6
       (pwr1_off_macb36 && pwr1_off_macb26 && pwr1_off_macb16) || // mac123off6 
       (pwr1_off_macb36 && pwr1_off_macb26 && pwr1_off_macb06) || // mac023off6 
       (pwr1_off_macb36 && pwr1_off_macb16 && pwr1_off_macb06) || // mac013off6 
       (pwr1_off_macb26 && pwr1_off_macb16 && pwr1_off_macb06) )  // mac012off6 
       begin
         ase_core_12v6 = 0;
         ase_core_10v6 = 0;
         ase_core_08v6 = 0;
         ase_core_06v6 = 1;
       end
     else if( (pwr1_off_macb26 && pwr1_off_macb36) || // mac236 off6
         (pwr1_off_macb36 && pwr1_off_macb16) || // mac13off6 
         (pwr1_off_macb16 && pwr1_off_macb26) || // mac12off6 
         (pwr1_off_macb36 && pwr1_off_macb06) || // mac03off6 
         (pwr1_off_macb26 && pwr1_off_macb06) || // mac02off6 
         (pwr1_off_macb16 && pwr1_off_macb06))  // mac01off6 
       begin
         ase_core_12v6 = 0;
         ase_core_10v6 = 0;
         ase_core_08v6 = 1;
         ase_core_06v6 = 0;
       end
     else if( (pwr1_off_smc6) || // smc6 off6
         (pwr1_off_macb06 ) || // mac0off6 
         (pwr1_off_macb16 ) || // mac1off6 
         (pwr1_off_macb26 ) || // mac2off6 
         (pwr1_off_macb36 ))  // mac3off6 
       begin
         ase_core_12v6 = 0;
         ase_core_10v6 = 1;
         ase_core_08v6 = 0;
         ase_core_06v6 = 0;
       end
     else if (pwr1_off_urt6)
       begin
         ase_core_12v6 = 1;
         ase_core_10v6 = 0;
         ase_core_08v6 = 0;
         ase_core_06v6 = 0;
       end
     else
       begin
         ase_core_12v6 = 1;
         ase_core_10v6 = 0;
         ase_core_08v6 = 0;
         ase_core_06v6 = 0;
       end
   end


   // cpu6
   // cpu6 @ 1.0v when macoff6, 
   // 
   reg ase_cpu_10v6, ase_cpu_12v6;
   always @(*) begin
    if(pwr1_off_cpu6) begin
     ase_cpu_12v6 = 1'b0;
     ase_cpu_10v6 = 1'b0;
    end
    else if(pwr1_off_macb06 || pwr1_off_macb16 || pwr1_off_macb26 || pwr1_off_macb36)
    begin
     ase_cpu_12v6 = 1'b0;
     ase_cpu_10v6 = 1'b1;
    end
    else
    begin
     ase_cpu_12v6 = 1'b1;
     ase_cpu_10v6 = 1'b0;
    end
   end

   // dma6
   // dma6 @v16.0 for macoff6, 

   reg ase_dma_10v6, ase_dma_12v6;
   always @(*) begin
    if(pwr1_off_dma6) begin
     ase_dma_12v6 = 1'b0;
     ase_dma_10v6 = 1'b0;
    end
    else if(pwr1_off_macb06 || pwr1_off_macb16 || pwr1_off_macb26 || pwr1_off_macb36)
    begin
     ase_dma_12v6 = 1'b0;
     ase_dma_10v6 = 1'b1;
    end
    else
    begin
     ase_dma_12v6 = 1'b1;
     ase_dma_10v6 = 1'b0;
    end
   end

   // alut6
   // @ v16.0 for macoff6

   reg ase_alut_10v6, ase_alut_12v6;
   always @(*) begin
    if(pwr1_off_alut6) begin
     ase_alut_12v6 = 1'b0;
     ase_alut_10v6 = 1'b0;
    end
    else if(pwr1_off_macb06 || pwr1_off_macb16 || pwr1_off_macb26 || pwr1_off_macb36)
    begin
     ase_alut_12v6 = 1'b0;
     ase_alut_10v6 = 1'b1;
    end
    else
    begin
     ase_alut_12v6 = 1'b1;
     ase_alut_10v6 = 1'b0;
    end
   end




   reg ase_uart_12v6;
   reg ase_uart_10v6;
   reg ase_uart_08v6;
   reg ase_uart_06v6;

   reg ase_smc_12v6;


   always @(*) begin
     if(pwr1_off_urt6) begin // uart6 off6
       ase_uart_08v6 = 1'b0;
       ase_uart_06v6 = 1'b0;
       ase_uart_10v6 = 1'b0;
       ase_uart_12v6 = 1'b0;
     end 
     else if( (pwr1_off_macb06 && pwr1_off_macb16 && pwr1_off_macb26 && pwr1_off_macb36) || // all mac6 off6
       (pwr1_off_macb36 && pwr1_off_macb26 && pwr1_off_macb16) || // mac123off6 
       (pwr1_off_macb36 && pwr1_off_macb26 && pwr1_off_macb06) || // mac023off6 
       (pwr1_off_macb36 && pwr1_off_macb16 && pwr1_off_macb06) || // mac013off6 
       (pwr1_off_macb26 && pwr1_off_macb16 && pwr1_off_macb06) )  // mac012off6 
     begin
       ase_uart_06v6 = 1'b1;
       ase_uart_08v6 = 1'b0;
       ase_uart_10v6 = 1'b0;
       ase_uart_12v6 = 1'b0;
     end
     else if( (pwr1_off_macb26 && pwr1_off_macb36) || // mac236 off6
         (pwr1_off_macb36 && pwr1_off_macb16) || // mac13off6 
         (pwr1_off_macb16 && pwr1_off_macb26) || // mac12off6 
         (pwr1_off_macb36 && pwr1_off_macb06) || // mac03off6 
         (pwr1_off_macb16 && pwr1_off_macb06))  // mac01off6  
     begin
       ase_uart_06v6 = 1'b0;
       ase_uart_08v6 = 1'b1;
       ase_uart_10v6 = 1'b0;
       ase_uart_12v6 = 1'b0;
     end
     else if (pwr1_off_smc6 || pwr1_off_macb06 || pwr1_off_macb16 || pwr1_off_macb26 || pwr1_off_macb36) begin // smc6 off6
       ase_uart_08v6 = 1'b0;
       ase_uart_06v6 = 1'b0;
       ase_uart_10v6 = 1'b1;
       ase_uart_12v6 = 1'b0;
     end 
     else begin
       ase_uart_08v6 = 1'b0;
       ase_uart_06v6 = 1'b0;
       ase_uart_10v6 = 1'b0;
       ase_uart_12v6 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc6) begin
     if (pwr1_off_smc6)  // smc6 off6
       ase_smc_12v6 = 1'b0;
    else
       ase_smc_12v6 = 1'b1;
   end

   
   always @(pwr1_off_macb06) begin
     if (pwr1_off_macb06) // macb06 off6
       ase_macb0_12v6 = 1'b0;
     else
       ase_macb0_12v6 = 1'b1;
   end

   always @(pwr1_off_macb16) begin
     if (pwr1_off_macb16) // macb16 off6
       ase_macb1_12v6 = 1'b0;
     else
       ase_macb1_12v6 = 1'b1;
   end

   always @(pwr1_off_macb26) begin // macb26 off6
     if (pwr1_off_macb26) // macb26 off6
       ase_macb2_12v6 = 1'b0;
     else
       ase_macb2_12v6 = 1'b1;
   end

   always @(pwr1_off_macb36) begin // macb36 off6
     if (pwr1_off_macb36) // macb36 off6
       ase_macb3_12v6 = 1'b0;
     else
       ase_macb3_12v6 = 1'b1;
   end


   // core6 voltage6 for vco6
  assign core12v6 = ase_macb0_12v6 & ase_macb1_12v6 & ase_macb2_12v6 & ase_macb3_12v6;

  assign core10v6 =  (ase_macb0_12v6 & ase_macb1_12v6 & ase_macb2_12v6 & (!ase_macb3_12v6)) ||
                    (ase_macb0_12v6 & ase_macb1_12v6 & (!ase_macb2_12v6) & ase_macb3_12v6) ||
                    (ase_macb0_12v6 & (!ase_macb1_12v6) & ase_macb2_12v6 & ase_macb3_12v6) ||
                    ((!ase_macb0_12v6) & ase_macb1_12v6 & ase_macb2_12v6 & ase_macb3_12v6);

  assign core08v6 =  ((!ase_macb0_12v6) & (!ase_macb1_12v6) & (ase_macb2_12v6) & (ase_macb3_12v6)) ||
                    ((!ase_macb0_12v6) & (ase_macb1_12v6) & (!ase_macb2_12v6) & (ase_macb3_12v6)) ||
                    ((!ase_macb0_12v6) & (ase_macb1_12v6) & (ase_macb2_12v6) & (!ase_macb3_12v6)) ||
                    ((ase_macb0_12v6) & (!ase_macb1_12v6) & (!ase_macb2_12v6) & (ase_macb3_12v6)) ||
                    ((ase_macb0_12v6) & (!ase_macb1_12v6) & (ase_macb2_12v6) & (!ase_macb3_12v6)) ||
                    ((ase_macb0_12v6) & (ase_macb1_12v6) & (!ase_macb2_12v6) & (!ase_macb3_12v6));

  assign core06v6 =  ((!ase_macb0_12v6) & (!ase_macb1_12v6) & (!ase_macb2_12v6) & (ase_macb3_12v6)) ||
                    ((!ase_macb0_12v6) & (!ase_macb1_12v6) & (ase_macb2_12v6) & (!ase_macb3_12v6)) ||
                    ((!ase_macb0_12v6) & (ase_macb1_12v6) & (!ase_macb2_12v6) & (!ase_macb3_12v6)) ||
                    ((ase_macb0_12v6) & (!ase_macb1_12v6) & (!ase_macb2_12v6) & (!ase_macb3_12v6)) ||
                    ((!ase_macb0_12v6) & (!ase_macb1_12v6) & (!ase_macb2_12v6) & (!ase_macb3_12v6)) ;



`ifdef LP_ABV_ON6
// psl6 default clock6 = (posedge pclk6);

// Cover6 a condition in which SMC6 is powered6 down
// and again6 powered6 up while UART6 is going6 into POWER6 down
// state or UART6 is already in POWER6 DOWN6 state
// psl6 cover_overlapping_smc_urt_16:
//    cover{fell6(pwr1_on_urt6);[*];fell6(pwr1_on_smc6);[*];
//    rose6(pwr1_on_smc6);[*];rose6(pwr1_on_urt6)};
//
// Cover6 a condition in which UART6 is powered6 down
// and again6 powered6 up while SMC6 is going6 into POWER6 down
// state or SMC6 is already in POWER6 DOWN6 state
// psl6 cover_overlapping_smc_urt_26:
//    cover{fell6(pwr1_on_smc6);[*];fell6(pwr1_on_urt6);[*];
//    rose6(pwr1_on_urt6);[*];rose6(pwr1_on_smc6)};
//


// Power6 Down6 UART6
// This6 gets6 triggered on rising6 edge of Gate6 signal6 for
// UART6 (gate_clk_urt6). In a next cycle after gate_clk_urt6,
// Isolate6 UART6(isolate_urt6) signal6 become6 HIGH6 (active).
// In 2nd cycle after gate_clk_urt6 becomes HIGH6, RESET6 for NON6
// SRPG6 FFs6(rstn_non_srpg_urt6) and POWER16 for UART6(pwr1_on_urt6) should 
// go6 LOW6. 
// This6 completes6 a POWER6 DOWN6. 

sequence s_power_down_urt6;
      (gate_clk_urt6 & !isolate_urt6 & rstn_non_srpg_urt6 & pwr1_on_urt6) 
  ##1 (gate_clk_urt6 & isolate_urt6 & rstn_non_srpg_urt6 & pwr1_on_urt6) 
  ##3 (gate_clk_urt6 & isolate_urt6 & !rstn_non_srpg_urt6 & !pwr1_on_urt6);
endsequence


property p_power_down_urt6;
   @(posedge pclk6)
    $rose(gate_clk_urt6) |=> s_power_down_urt6;
endproperty

output_power_down_urt6:
  assert property (p_power_down_urt6);


// Power6 UP6 UART6
// Sequence starts with , Rising6 edge of pwr1_on_urt6.
// Two6 clock6 cycle after this, isolate_urt6 should become6 LOW6 
// On6 the following6 clk6 gate_clk_urt6 should go6 low6.
// 5 cycles6 after  Rising6 edge of pwr1_on_urt6, rstn_non_srpg_urt6
// should become6 HIGH6
sequence s_power_up_urt6;
##30 (pwr1_on_urt6 & !isolate_urt6 & gate_clk_urt6 & !rstn_non_srpg_urt6) 
##1 (pwr1_on_urt6 & !isolate_urt6 & !gate_clk_urt6 & !rstn_non_srpg_urt6) 
##2 (pwr1_on_urt6 & !isolate_urt6 & !gate_clk_urt6 & rstn_non_srpg_urt6);
endsequence

property p_power_up_urt6;
   @(posedge pclk6)
  disable iff(!nprst6)
    (!pwr1_on_urt6 ##1 pwr1_on_urt6) |=> s_power_up_urt6;
endproperty

output_power_up_urt6:
  assert property (p_power_up_urt6);


// Power6 Down6 SMC6
// This6 gets6 triggered on rising6 edge of Gate6 signal6 for
// SMC6 (gate_clk_smc6). In a next cycle after gate_clk_smc6,
// Isolate6 SMC6(isolate_smc6) signal6 become6 HIGH6 (active).
// In 2nd cycle after gate_clk_smc6 becomes HIGH6, RESET6 for NON6
// SRPG6 FFs6(rstn_non_srpg_smc6) and POWER16 for SMC6(pwr1_on_smc6) should 
// go6 LOW6. 
// This6 completes6 a POWER6 DOWN6. 

sequence s_power_down_smc6;
      (gate_clk_smc6 & !isolate_smc6 & rstn_non_srpg_smc6 & pwr1_on_smc6) 
  ##1 (gate_clk_smc6 & isolate_smc6 & rstn_non_srpg_smc6 & pwr1_on_smc6) 
  ##3 (gate_clk_smc6 & isolate_smc6 & !rstn_non_srpg_smc6 & !pwr1_on_smc6);
endsequence


property p_power_down_smc6;
   @(posedge pclk6)
    $rose(gate_clk_smc6) |=> s_power_down_smc6;
endproperty

output_power_down_smc6:
  assert property (p_power_down_smc6);


// Power6 UP6 SMC6
// Sequence starts with , Rising6 edge of pwr1_on_smc6.
// Two6 clock6 cycle after this, isolate_smc6 should become6 LOW6 
// On6 the following6 clk6 gate_clk_smc6 should go6 low6.
// 5 cycles6 after  Rising6 edge of pwr1_on_smc6, rstn_non_srpg_smc6
// should become6 HIGH6
sequence s_power_up_smc6;
##30 (pwr1_on_smc6 & !isolate_smc6 & gate_clk_smc6 & !rstn_non_srpg_smc6) 
##1 (pwr1_on_smc6 & !isolate_smc6 & !gate_clk_smc6 & !rstn_non_srpg_smc6) 
##2 (pwr1_on_smc6 & !isolate_smc6 & !gate_clk_smc6 & rstn_non_srpg_smc6);
endsequence

property p_power_up_smc6;
   @(posedge pclk6)
  disable iff(!nprst6)
    (!pwr1_on_smc6 ##1 pwr1_on_smc6) |=> s_power_up_smc6;
endproperty

output_power_up_smc6:
  assert property (p_power_up_smc6);


// COVER6 SMC6 POWER6 DOWN6 AND6 UP6
cover_power_down_up_smc6: cover property (@(posedge pclk6)
(s_power_down_smc6 ##[5:180] s_power_up_smc6));



// COVER6 UART6 POWER6 DOWN6 AND6 UP6
cover_power_down_up_urt6: cover property (@(posedge pclk6)
(s_power_down_urt6 ##[5:180] s_power_up_urt6));

cover_power_down_urt6: cover property (@(posedge pclk6)
(s_power_down_urt6));

cover_power_up_urt6: cover property (@(posedge pclk6)
(s_power_up_urt6));




`ifdef PCM_ABV_ON6
//------------------------------------------------------------------------------
// Power6 Controller6 Formal6 Verification6 component.  Each power6 domain has a 
// separate6 instantiation6
//------------------------------------------------------------------------------

// need to assume that CPU6 will leave6 a minimum time between powering6 down and 
// back up.  In this example6, 10clks has been selected.
// psl6 config_min_uart_pd_time6 : assume always {rose6(L1_ctrl_domain6[1])} |-> { L1_ctrl_domain6[1][*10] } abort6(~nprst6);
// psl6 config_min_uart_pu_time6 : assume always {fell6(L1_ctrl_domain6[1])} |-> { !L1_ctrl_domain6[1][*10] } abort6(~nprst6);
// psl6 config_min_smc_pd_time6 : assume always {rose6(L1_ctrl_domain6[2])} |-> { L1_ctrl_domain6[2][*10] } abort6(~nprst6);
// psl6 config_min_smc_pu_time6 : assume always {fell6(L1_ctrl_domain6[2])} |-> { !L1_ctrl_domain6[2][*10] } abort6(~nprst6);

// UART6 VCOMP6 parameters6
   defparam i_uart_vcomp_domain6.ENABLE_SAVE_RESTORE_EDGE6   = 1;
   defparam i_uart_vcomp_domain6.ENABLE_EXT_PWR_CNTRL6       = 1;
   defparam i_uart_vcomp_domain6.REF_CLK_DEFINED6            = 0;
   defparam i_uart_vcomp_domain6.MIN_SHUTOFF_CYCLES6         = 4;
   defparam i_uart_vcomp_domain6.MIN_RESTORE_TO_ISO_CYCLES6  = 0;
   defparam i_uart_vcomp_domain6.MIN_SAVE_TO_SHUTOFF_CYCLES6 = 1;


   vcomp_domain6 i_uart_vcomp_domain6
   ( .ref_clk6(pclk6),
     .start_lps6(L1_ctrl_domain6[1] || !rstn_non_srpg_urt6),
     .rst_n6(nprst6),
     .ext_power_down6(L1_ctrl_domain6[1]),
     .iso_en6(isolate_urt6),
     .save_edge6(save_edge_urt6),
     .restore_edge6(restore_edge_urt6),
     .domain_shut_off6(pwr1_off_urt6),
     .domain_clk6(!gate_clk_urt6 && pclk6)
   );


// SMC6 VCOMP6 parameters6
   defparam i_smc_vcomp_domain6.ENABLE_SAVE_RESTORE_EDGE6   = 1;
   defparam i_smc_vcomp_domain6.ENABLE_EXT_PWR_CNTRL6       = 1;
   defparam i_smc_vcomp_domain6.REF_CLK_DEFINED6            = 0;
   defparam i_smc_vcomp_domain6.MIN_SHUTOFF_CYCLES6         = 4;
   defparam i_smc_vcomp_domain6.MIN_RESTORE_TO_ISO_CYCLES6  = 0;
   defparam i_smc_vcomp_domain6.MIN_SAVE_TO_SHUTOFF_CYCLES6 = 1;


   vcomp_domain6 i_smc_vcomp_domain6
   ( .ref_clk6(pclk6),
     .start_lps6(L1_ctrl_domain6[2] || !rstn_non_srpg_smc6),
     .rst_n6(nprst6),
     .ext_power_down6(L1_ctrl_domain6[2]),
     .iso_en6(isolate_smc6),
     .save_edge6(save_edge_smc6),
     .restore_edge6(restore_edge_smc6),
     .domain_shut_off6(pwr1_off_smc6),
     .domain_clk6(!gate_clk_smc6 && pclk6)
   );

`endif

`endif



endmodule
