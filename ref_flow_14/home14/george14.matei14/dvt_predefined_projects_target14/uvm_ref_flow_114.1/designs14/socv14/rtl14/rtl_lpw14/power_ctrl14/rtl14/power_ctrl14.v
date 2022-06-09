//File14 name   : power_ctrl14.v
//Title14       : Power14 Control14 Module14
//Created14     : 1999
//Description14 : Top14 level of power14 controller14
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

module power_ctrl14 (


    // Clocks14 & Reset14
    pclk14,
    nprst14,
    // APB14 programming14 interface
    paddr14,
    psel14,
    penable14,
    pwrite14,
    pwdata14,
    prdata14,
    // mac14 i/f,
    macb3_wakeup14,
    macb2_wakeup14,
    macb1_wakeup14,
    macb0_wakeup14,
    // Scan14 
    scan_in14,
    scan_en14,
    scan_mode14,
    scan_out14,
    // Module14 control14 outputs14
    int_source_h14,
    // SMC14
    rstn_non_srpg_smc14,
    gate_clk_smc14,
    isolate_smc14,
    save_edge_smc14,
    restore_edge_smc14,
    pwr1_on_smc14,
    pwr2_on_smc14,
    pwr1_off_smc14,
    pwr2_off_smc14,
    // URT14
    rstn_non_srpg_urt14,
    gate_clk_urt14,
    isolate_urt14,
    save_edge_urt14,
    restore_edge_urt14,
    pwr1_on_urt14,
    pwr2_on_urt14,
    pwr1_off_urt14,      
    pwr2_off_urt14,
    // ETH014
    rstn_non_srpg_macb014,
    gate_clk_macb014,
    isolate_macb014,
    save_edge_macb014,
    restore_edge_macb014,
    pwr1_on_macb014,
    pwr2_on_macb014,
    pwr1_off_macb014,      
    pwr2_off_macb014,
    // ETH114
    rstn_non_srpg_macb114,
    gate_clk_macb114,
    isolate_macb114,
    save_edge_macb114,
    restore_edge_macb114,
    pwr1_on_macb114,
    pwr2_on_macb114,
    pwr1_off_macb114,      
    pwr2_off_macb114,
    // ETH214
    rstn_non_srpg_macb214,
    gate_clk_macb214,
    isolate_macb214,
    save_edge_macb214,
    restore_edge_macb214,
    pwr1_on_macb214,
    pwr2_on_macb214,
    pwr1_off_macb214,      
    pwr2_off_macb214,
    // ETH314
    rstn_non_srpg_macb314,
    gate_clk_macb314,
    isolate_macb314,
    save_edge_macb314,
    restore_edge_macb314,
    pwr1_on_macb314,
    pwr2_on_macb314,
    pwr1_off_macb314,      
    pwr2_off_macb314,
    // DMA14
    rstn_non_srpg_dma14,
    gate_clk_dma14,
    isolate_dma14,
    save_edge_dma14,
    restore_edge_dma14,
    pwr1_on_dma14,
    pwr2_on_dma14,
    pwr1_off_dma14,      
    pwr2_off_dma14,
    // CPU14
    rstn_non_srpg_cpu14,
    gate_clk_cpu14,
    isolate_cpu14,
    save_edge_cpu14,
    restore_edge_cpu14,
    pwr1_on_cpu14,
    pwr2_on_cpu14,
    pwr1_off_cpu14,      
    pwr2_off_cpu14,
    // ALUT14
    rstn_non_srpg_alut14,
    gate_clk_alut14,
    isolate_alut14,
    save_edge_alut14,
    restore_edge_alut14,
    pwr1_on_alut14,
    pwr2_on_alut14,
    pwr1_off_alut14,      
    pwr2_off_alut14,
    // MEM14
    rstn_non_srpg_mem14,
    gate_clk_mem14,
    isolate_mem14,
    save_edge_mem14,
    restore_edge_mem14,
    pwr1_on_mem14,
    pwr2_on_mem14,
    pwr1_off_mem14,      
    pwr2_off_mem14,
    // core14 dvfs14 transitions14
    core06v14,
    core08v14,
    core10v14,
    core12v14,
    pcm_macb_wakeup_int14,
    // mte14 signals14
    mte_smc_start14,
    mte_uart_start14,
    mte_smc_uart_start14,  
    mte_pm_smc_to_default_start14, 
    mte_pm_uart_to_default_start14,
    mte_pm_smc_uart_to_default_start14

  );

  parameter STATE_IDLE_12V14 = 4'b0001;
  parameter STATE_06V14 = 4'b0010;
  parameter STATE_08V14 = 4'b0100;
  parameter STATE_10V14 = 4'b1000;

    // Clocks14 & Reset14
    input pclk14;
    input nprst14;
    // APB14 programming14 interface
    input [31:0] paddr14;
    input psel14  ;
    input penable14;
    input pwrite14 ;
    input [31:0] pwdata14;
    output [31:0] prdata14;
    // mac14
    input macb3_wakeup14;
    input macb2_wakeup14;
    input macb1_wakeup14;
    input macb0_wakeup14;
    // Scan14 
    input scan_in14;
    input scan_en14;
    input scan_mode14;
    output scan_out14;
    // Module14 control14 outputs14
    input int_source_h14;
    // SMC14
    output rstn_non_srpg_smc14 ;
    output gate_clk_smc14   ;
    output isolate_smc14   ;
    output save_edge_smc14   ;
    output restore_edge_smc14   ;
    output pwr1_on_smc14   ;
    output pwr2_on_smc14   ;
    output pwr1_off_smc14  ;
    output pwr2_off_smc14  ;
    // URT14
    output rstn_non_srpg_urt14 ;
    output gate_clk_urt14      ;
    output isolate_urt14       ;
    output save_edge_urt14   ;
    output restore_edge_urt14   ;
    output pwr1_on_urt14       ;
    output pwr2_on_urt14       ;
    output pwr1_off_urt14      ;
    output pwr2_off_urt14      ;
    // ETH014
    output rstn_non_srpg_macb014 ;
    output gate_clk_macb014      ;
    output isolate_macb014       ;
    output save_edge_macb014   ;
    output restore_edge_macb014   ;
    output pwr1_on_macb014       ;
    output pwr2_on_macb014       ;
    output pwr1_off_macb014      ;
    output pwr2_off_macb014      ;
    // ETH114
    output rstn_non_srpg_macb114 ;
    output gate_clk_macb114      ;
    output isolate_macb114       ;
    output save_edge_macb114   ;
    output restore_edge_macb114   ;
    output pwr1_on_macb114       ;
    output pwr2_on_macb114       ;
    output pwr1_off_macb114      ;
    output pwr2_off_macb114      ;
    // ETH214
    output rstn_non_srpg_macb214 ;
    output gate_clk_macb214      ;
    output isolate_macb214       ;
    output save_edge_macb214   ;
    output restore_edge_macb214   ;
    output pwr1_on_macb214       ;
    output pwr2_on_macb214       ;
    output pwr1_off_macb214      ;
    output pwr2_off_macb214      ;
    // ETH314
    output rstn_non_srpg_macb314 ;
    output gate_clk_macb314      ;
    output isolate_macb314       ;
    output save_edge_macb314   ;
    output restore_edge_macb314   ;
    output pwr1_on_macb314       ;
    output pwr2_on_macb314       ;
    output pwr1_off_macb314      ;
    output pwr2_off_macb314      ;
    // DMA14
    output rstn_non_srpg_dma14 ;
    output gate_clk_dma14      ;
    output isolate_dma14       ;
    output save_edge_dma14   ;
    output restore_edge_dma14   ;
    output pwr1_on_dma14       ;
    output pwr2_on_dma14       ;
    output pwr1_off_dma14      ;
    output pwr2_off_dma14      ;
    // CPU14
    output rstn_non_srpg_cpu14 ;
    output gate_clk_cpu14      ;
    output isolate_cpu14       ;
    output save_edge_cpu14   ;
    output restore_edge_cpu14   ;
    output pwr1_on_cpu14       ;
    output pwr2_on_cpu14       ;
    output pwr1_off_cpu14      ;
    output pwr2_off_cpu14      ;
    // ALUT14
    output rstn_non_srpg_alut14 ;
    output gate_clk_alut14      ;
    output isolate_alut14       ;
    output save_edge_alut14   ;
    output restore_edge_alut14   ;
    output pwr1_on_alut14       ;
    output pwr2_on_alut14       ;
    output pwr1_off_alut14      ;
    output pwr2_off_alut14      ;
    // MEM14
    output rstn_non_srpg_mem14 ;
    output gate_clk_mem14      ;
    output isolate_mem14       ;
    output save_edge_mem14   ;
    output restore_edge_mem14   ;
    output pwr1_on_mem14       ;
    output pwr2_on_mem14       ;
    output pwr1_off_mem14      ;
    output pwr2_off_mem14      ;


   // core14 transitions14 o/p
    output core06v14;
    output core08v14;
    output core10v14;
    output core12v14;
    output pcm_macb_wakeup_int14 ;
    //mode mte14  signals14
    output mte_smc_start14;
    output mte_uart_start14;
    output mte_smc_uart_start14;  
    output mte_pm_smc_to_default_start14; 
    output mte_pm_uart_to_default_start14;
    output mte_pm_smc_uart_to_default_start14;

    reg mte_smc_start14;
    reg mte_uart_start14;
    reg mte_smc_uart_start14;  
    reg mte_pm_smc_to_default_start14; 
    reg mte_pm_uart_to_default_start14;
    reg mte_pm_smc_uart_to_default_start14;

    reg [31:0] prdata14;

  wire valid_reg_write14  ;
  wire valid_reg_read14   ;
  wire L1_ctrl_access14   ;
  wire L1_status_access14 ;
  wire pcm_int_mask_access14;
  wire pcm_int_status_access14;
  wire standby_mem014      ;
  wire standby_mem114      ;
  wire standby_mem214      ;
  wire standby_mem314      ;
  wire pwr1_off_mem014;
  wire pwr1_off_mem114;
  wire pwr1_off_mem214;
  wire pwr1_off_mem314;
  
  // Control14 signals14
  wire set_status_smc14   ;
  wire clr_status_smc14   ;
  wire set_status_urt14   ;
  wire clr_status_urt14   ;
  wire set_status_macb014   ;
  wire clr_status_macb014   ;
  wire set_status_macb114   ;
  wire clr_status_macb114   ;
  wire set_status_macb214   ;
  wire clr_status_macb214   ;
  wire set_status_macb314   ;
  wire clr_status_macb314   ;
  wire set_status_dma14   ;
  wire clr_status_dma14   ;
  wire set_status_cpu14   ;
  wire clr_status_cpu14   ;
  wire set_status_alut14   ;
  wire clr_status_alut14   ;
  wire set_status_mem14   ;
  wire clr_status_mem14   ;


  // Status and Control14 registers
  reg [31:0]  L1_status_reg14;
  reg  [31:0] L1_ctrl_reg14  ;
  reg  [31:0] L1_ctrl_domain14  ;
  reg L1_ctrl_cpu_off_reg14;
  reg [31:0]  pcm_mask_reg14;
  reg [31:0]  pcm_status_reg14;

  // Signals14 gated14 in scan_mode14
  //SMC14
  wire  rstn_non_srpg_smc_int14;
  wire  gate_clk_smc_int14    ;     
  wire  isolate_smc_int14    ;       
  wire save_edge_smc_int14;
  wire restore_edge_smc_int14;
  wire  pwr1_on_smc_int14    ;      
  wire  pwr2_on_smc_int14    ;      


  //URT14
  wire   rstn_non_srpg_urt_int14;
  wire   gate_clk_urt_int14     ;     
  wire   isolate_urt_int14      ;       
  wire save_edge_urt_int14;
  wire restore_edge_urt_int14;
  wire   pwr1_on_urt_int14      ;      
  wire   pwr2_on_urt_int14      ;      

  // ETH014
  wire   rstn_non_srpg_macb0_int14;
  wire   gate_clk_macb0_int14     ;     
  wire   isolate_macb0_int14      ;       
  wire save_edge_macb0_int14;
  wire restore_edge_macb0_int14;
  wire   pwr1_on_macb0_int14      ;      
  wire   pwr2_on_macb0_int14      ;      
  // ETH114
  wire   rstn_non_srpg_macb1_int14;
  wire   gate_clk_macb1_int14     ;     
  wire   isolate_macb1_int14      ;       
  wire save_edge_macb1_int14;
  wire restore_edge_macb1_int14;
  wire   pwr1_on_macb1_int14      ;      
  wire   pwr2_on_macb1_int14      ;      
  // ETH214
  wire   rstn_non_srpg_macb2_int14;
  wire   gate_clk_macb2_int14     ;     
  wire   isolate_macb2_int14      ;       
  wire save_edge_macb2_int14;
  wire restore_edge_macb2_int14;
  wire   pwr1_on_macb2_int14      ;      
  wire   pwr2_on_macb2_int14      ;      
  // ETH314
  wire   rstn_non_srpg_macb3_int14;
  wire   gate_clk_macb3_int14     ;     
  wire   isolate_macb3_int14      ;       
  wire save_edge_macb3_int14;
  wire restore_edge_macb3_int14;
  wire   pwr1_on_macb3_int14      ;      
  wire   pwr2_on_macb3_int14      ;      

  // DMA14
  wire   rstn_non_srpg_dma_int14;
  wire   gate_clk_dma_int14     ;     
  wire   isolate_dma_int14      ;       
  wire save_edge_dma_int14;
  wire restore_edge_dma_int14;
  wire   pwr1_on_dma_int14      ;      
  wire   pwr2_on_dma_int14      ;      

  // CPU14
  wire   rstn_non_srpg_cpu_int14;
  wire   gate_clk_cpu_int14     ;     
  wire   isolate_cpu_int14      ;       
  wire save_edge_cpu_int14;
  wire restore_edge_cpu_int14;
  wire   pwr1_on_cpu_int14      ;      
  wire   pwr2_on_cpu_int14      ;  
  wire L1_ctrl_cpu_off_p14;    

  reg save_alut_tmp14;
  // DFS14 sm14

  reg cpu_shutoff_ctrl14;

  reg mte_mac_off_start14, mte_mac012_start14, mte_mac013_start14, mte_mac023_start14, mte_mac123_start14;
  reg mte_mac01_start14, mte_mac02_start14, mte_mac03_start14, mte_mac12_start14, mte_mac13_start14, mte_mac23_start14;
  reg mte_mac0_start14, mte_mac1_start14, mte_mac2_start14, mte_mac3_start14;
  reg mte_sys_hibernate14 ;
  reg mte_dma_start14 ;
  reg mte_cpu_start14 ;
  reg mte_mac_off_sleep_start14, mte_mac012_sleep_start14, mte_mac013_sleep_start14, mte_mac023_sleep_start14, mte_mac123_sleep_start14;
  reg mte_mac01_sleep_start14, mte_mac02_sleep_start14, mte_mac03_sleep_start14, mte_mac12_sleep_start14, mte_mac13_sleep_start14, mte_mac23_sleep_start14;
  reg mte_mac0_sleep_start14, mte_mac1_sleep_start14, mte_mac2_sleep_start14, mte_mac3_sleep_start14;
  reg mte_dma_sleep_start14;
  reg mte_mac_off_to_default14, mte_mac012_to_default14, mte_mac013_to_default14, mte_mac023_to_default14, mte_mac123_to_default14;
  reg mte_mac01_to_default14, mte_mac02_to_default14, mte_mac03_to_default14, mte_mac12_to_default14, mte_mac13_to_default14, mte_mac23_to_default14;
  reg mte_mac0_to_default14, mte_mac1_to_default14, mte_mac2_to_default14, mte_mac3_to_default14;
  reg mte_dma_isolate_dis14;
  reg mte_cpu_isolate_dis14;
  reg mte_sys_hibernate_to_default14;


  // Latch14 the CPU14 SLEEP14 invocation14
  always @( posedge pclk14 or negedge nprst14) 
  begin
    if(!nprst14)
      L1_ctrl_cpu_off_reg14 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg14 <= L1_ctrl_domain14[8];
  end

  // Create14 a pulse14 for sleep14 detection14 
  assign L1_ctrl_cpu_off_p14 =  L1_ctrl_domain14[8] && !L1_ctrl_cpu_off_reg14;
  
  // CPU14 sleep14 contol14 logic 
  // Shut14 off14 CPU14 when L1_ctrl_cpu_off_p14 is set
  // wake14 cpu14 when any interrupt14 is seen14  
  always @( posedge pclk14 or negedge nprst14) 
  begin
    if(!nprst14)
     cpu_shutoff_ctrl14 <= 1'b0;
    else if(cpu_shutoff_ctrl14 && int_source_h14)
     cpu_shutoff_ctrl14 <= 1'b0;
    else if (L1_ctrl_cpu_off_p14)
     cpu_shutoff_ctrl14 <= 1'b1;
  end
 
  // instantiate14 power14 contol14  block for uart14
  power_ctrl_sm14 i_urt_power_ctrl_sm14(
    .pclk14(pclk14),
    .nprst14(nprst14),
    .L1_module_req14(L1_ctrl_domain14[1]),
    .set_status_module14(set_status_urt14),
    .clr_status_module14(clr_status_urt14),
    .rstn_non_srpg_module14(rstn_non_srpg_urt_int14),
    .gate_clk_module14(gate_clk_urt_int14),
    .isolate_module14(isolate_urt_int14),
    .save_edge14(save_edge_urt_int14),
    .restore_edge14(restore_edge_urt_int14),
    .pwr1_on14(pwr1_on_urt_int14),
    .pwr2_on14(pwr2_on_urt_int14)
    );
  

  // instantiate14 power14 contol14  block for smc14
  power_ctrl_sm14 i_smc_power_ctrl_sm14(
    .pclk14(pclk14),
    .nprst14(nprst14),
    .L1_module_req14(L1_ctrl_domain14[2]),
    .set_status_module14(set_status_smc14),
    .clr_status_module14(clr_status_smc14),
    .rstn_non_srpg_module14(rstn_non_srpg_smc_int14),
    .gate_clk_module14(gate_clk_smc_int14),
    .isolate_module14(isolate_smc_int14),
    .save_edge14(save_edge_smc_int14),
    .restore_edge14(restore_edge_smc_int14),
    .pwr1_on14(pwr1_on_smc_int14),
    .pwr2_on14(pwr2_on_smc_int14)
    );

  // power14 control14 for macb014
  power_ctrl_sm14 i_macb0_power_ctrl_sm14(
    .pclk14(pclk14),
    .nprst14(nprst14),
    .L1_module_req14(L1_ctrl_domain14[3]),
    .set_status_module14(set_status_macb014),
    .clr_status_module14(clr_status_macb014),
    .rstn_non_srpg_module14(rstn_non_srpg_macb0_int14),
    .gate_clk_module14(gate_clk_macb0_int14),
    .isolate_module14(isolate_macb0_int14),
    .save_edge14(save_edge_macb0_int14),
    .restore_edge14(restore_edge_macb0_int14),
    .pwr1_on14(pwr1_on_macb0_int14),
    .pwr2_on14(pwr2_on_macb0_int14)
    );
  // power14 control14 for macb114
  power_ctrl_sm14 i_macb1_power_ctrl_sm14(
    .pclk14(pclk14),
    .nprst14(nprst14),
    .L1_module_req14(L1_ctrl_domain14[4]),
    .set_status_module14(set_status_macb114),
    .clr_status_module14(clr_status_macb114),
    .rstn_non_srpg_module14(rstn_non_srpg_macb1_int14),
    .gate_clk_module14(gate_clk_macb1_int14),
    .isolate_module14(isolate_macb1_int14),
    .save_edge14(save_edge_macb1_int14),
    .restore_edge14(restore_edge_macb1_int14),
    .pwr1_on14(pwr1_on_macb1_int14),
    .pwr2_on14(pwr2_on_macb1_int14)
    );
  // power14 control14 for macb214
  power_ctrl_sm14 i_macb2_power_ctrl_sm14(
    .pclk14(pclk14),
    .nprst14(nprst14),
    .L1_module_req14(L1_ctrl_domain14[5]),
    .set_status_module14(set_status_macb214),
    .clr_status_module14(clr_status_macb214),
    .rstn_non_srpg_module14(rstn_non_srpg_macb2_int14),
    .gate_clk_module14(gate_clk_macb2_int14),
    .isolate_module14(isolate_macb2_int14),
    .save_edge14(save_edge_macb2_int14),
    .restore_edge14(restore_edge_macb2_int14),
    .pwr1_on14(pwr1_on_macb2_int14),
    .pwr2_on14(pwr2_on_macb2_int14)
    );
  // power14 control14 for macb314
  power_ctrl_sm14 i_macb3_power_ctrl_sm14(
    .pclk14(pclk14),
    .nprst14(nprst14),
    .L1_module_req14(L1_ctrl_domain14[6]),
    .set_status_module14(set_status_macb314),
    .clr_status_module14(clr_status_macb314),
    .rstn_non_srpg_module14(rstn_non_srpg_macb3_int14),
    .gate_clk_module14(gate_clk_macb3_int14),
    .isolate_module14(isolate_macb3_int14),
    .save_edge14(save_edge_macb3_int14),
    .restore_edge14(restore_edge_macb3_int14),
    .pwr1_on14(pwr1_on_macb3_int14),
    .pwr2_on14(pwr2_on_macb3_int14)
    );
  // power14 control14 for dma14
  power_ctrl_sm14 i_dma_power_ctrl_sm14(
    .pclk14(pclk14),
    .nprst14(nprst14),
    .L1_module_req14(L1_ctrl_domain14[7]),
    .set_status_module14(set_status_dma14),
    .clr_status_module14(clr_status_dma14),
    .rstn_non_srpg_module14(rstn_non_srpg_dma_int14),
    .gate_clk_module14(gate_clk_dma_int14),
    .isolate_module14(isolate_dma_int14),
    .save_edge14(save_edge_dma_int14),
    .restore_edge14(restore_edge_dma_int14),
    .pwr1_on14(pwr1_on_dma_int14),
    .pwr2_on14(pwr2_on_dma_int14)
    );
  // power14 control14 for CPU14
  power_ctrl_sm14 i_cpu_power_ctrl_sm14(
    .pclk14(pclk14),
    .nprst14(nprst14),
    .L1_module_req14(cpu_shutoff_ctrl14),
    .set_status_module14(set_status_cpu14),
    .clr_status_module14(clr_status_cpu14),
    .rstn_non_srpg_module14(rstn_non_srpg_cpu_int14),
    .gate_clk_module14(gate_clk_cpu_int14),
    .isolate_module14(isolate_cpu_int14),
    .save_edge14(save_edge_cpu_int14),
    .restore_edge14(restore_edge_cpu_int14),
    .pwr1_on14(pwr1_on_cpu_int14),
    .pwr2_on14(pwr2_on_cpu_int14)
    );

  assign valid_reg_write14 =  (psel14 && pwrite14 && penable14);
  assign valid_reg_read14  =  (psel14 && (!pwrite14) && penable14);

  assign L1_ctrl_access14  =  (paddr14[15:0] == 16'b0000000000000100); 
  assign L1_status_access14 = (paddr14[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access14 =   (paddr14[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access14 = (paddr14[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control14 and status register
  always @(*)
  begin  
    if(valid_reg_read14 && L1_ctrl_access14) 
      prdata14 = L1_ctrl_reg14;
    else if (valid_reg_read14 && L1_status_access14)
      prdata14 = L1_status_reg14;
    else if (valid_reg_read14 && pcm_int_mask_access14)
      prdata14 = pcm_mask_reg14;
    else if (valid_reg_read14 && pcm_int_status_access14)
      prdata14 = pcm_status_reg14;
    else 
      prdata14 = 0;
  end

  assign set_status_mem14 =  (set_status_macb014 && set_status_macb114 && set_status_macb214 &&
                            set_status_macb314 && set_status_dma14 && set_status_cpu14);

  assign clr_status_mem14 =  (clr_status_macb014 && clr_status_macb114 && clr_status_macb214 &&
                            clr_status_macb314 && clr_status_dma14 && clr_status_cpu14);

  assign set_status_alut14 = (set_status_macb014 && set_status_macb114 && set_status_macb214 && set_status_macb314);

  assign clr_status_alut14 = (clr_status_macb014 || clr_status_macb114 || clr_status_macb214  || clr_status_macb314);

  // Write accesses to the control14 and status register
 
  always @(posedge pclk14 or negedge nprst14)
  begin
    if (!nprst14) begin
      L1_ctrl_reg14   <= 0;
      L1_status_reg14 <= 0;
      pcm_mask_reg14 <= 0;
    end else begin
      // CTRL14 reg updates14
      if (valid_reg_write14 && L1_ctrl_access14) 
        L1_ctrl_reg14 <= pwdata14; // Writes14 to the ctrl14 reg
      if (valid_reg_write14 && pcm_int_mask_access14) 
        pcm_mask_reg14 <= pwdata14; // Writes14 to the ctrl14 reg

      if (set_status_urt14 == 1'b1)  
        L1_status_reg14[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt14 == 1'b1) 
        L1_status_reg14[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc14 == 1'b1) 
        L1_status_reg14[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc14 == 1'b1) 
        L1_status_reg14[2] <= 1'b0; // Clear the status bit

      if (set_status_macb014 == 1'b1)  
        L1_status_reg14[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb014 == 1'b1) 
        L1_status_reg14[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb114 == 1'b1)  
        L1_status_reg14[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb114 == 1'b1) 
        L1_status_reg14[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb214 == 1'b1)  
        L1_status_reg14[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb214 == 1'b1) 
        L1_status_reg14[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb314 == 1'b1)  
        L1_status_reg14[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb314 == 1'b1) 
        L1_status_reg14[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma14 == 1'b1)  
        L1_status_reg14[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma14 == 1'b1) 
        L1_status_reg14[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu14 == 1'b1)  
        L1_status_reg14[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu14 == 1'b1) 
        L1_status_reg14[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut14 == 1'b1)  
        L1_status_reg14[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut14 == 1'b1) 
        L1_status_reg14[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem14 == 1'b1)  
        L1_status_reg14[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem14 == 1'b1) 
        L1_status_reg14[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused14 bits of pcm_status_reg14 are tied14 to 0
  always @(posedge pclk14 or negedge nprst14)
  begin
    if (!nprst14)
      pcm_status_reg14[31:4] <= 'b0;
    else  
      pcm_status_reg14[31:4] <= pcm_status_reg14[31:4];
  end
  
  // interrupt14 only of h/w assisted14 wakeup
  // MAC14 3
  always @(posedge pclk14 or negedge nprst14)
  begin
    if(!nprst14)
      pcm_status_reg14[3] <= 1'b0;
    else if (valid_reg_write14 && pcm_int_status_access14) 
      pcm_status_reg14[3] <= pwdata14[3];
    else if (macb3_wakeup14 & ~pcm_mask_reg14[3])
      pcm_status_reg14[3] <= 1'b1;
    else if (valid_reg_read14 && pcm_int_status_access14) 
      pcm_status_reg14[3] <= 1'b0;
    else
      pcm_status_reg14[3] <= pcm_status_reg14[3];
  end  
   
  // MAC14 2
  always @(posedge pclk14 or negedge nprst14)
  begin
    if(!nprst14)
      pcm_status_reg14[2] <= 1'b0;
    else if (valid_reg_write14 && pcm_int_status_access14) 
      pcm_status_reg14[2] <= pwdata14[2];
    else if (macb2_wakeup14 & ~pcm_mask_reg14[2])
      pcm_status_reg14[2] <= 1'b1;
    else if (valid_reg_read14 && pcm_int_status_access14) 
      pcm_status_reg14[2] <= 1'b0;
    else
      pcm_status_reg14[2] <= pcm_status_reg14[2];
  end  

  // MAC14 1
  always @(posedge pclk14 or negedge nprst14)
  begin
    if(!nprst14)
      pcm_status_reg14[1] <= 1'b0;
    else if (valid_reg_write14 && pcm_int_status_access14) 
      pcm_status_reg14[1] <= pwdata14[1];
    else if (macb1_wakeup14 & ~pcm_mask_reg14[1])
      pcm_status_reg14[1] <= 1'b1;
    else if (valid_reg_read14 && pcm_int_status_access14) 
      pcm_status_reg14[1] <= 1'b0;
    else
      pcm_status_reg14[1] <= pcm_status_reg14[1];
  end  
   
  // MAC14 0
  always @(posedge pclk14 or negedge nprst14)
  begin
    if(!nprst14)
      pcm_status_reg14[0] <= 1'b0;
    else if (valid_reg_write14 && pcm_int_status_access14) 
      pcm_status_reg14[0] <= pwdata14[0];
    else if (macb0_wakeup14 & ~pcm_mask_reg14[0])
      pcm_status_reg14[0] <= 1'b1;
    else if (valid_reg_read14 && pcm_int_status_access14) 
      pcm_status_reg14[0] <= 1'b0;
    else
      pcm_status_reg14[0] <= pcm_status_reg14[0];
  end  

  assign pcm_macb_wakeup_int14 = |pcm_status_reg14;

  reg [31:0] L1_ctrl_reg114;
  always @(posedge pclk14 or negedge nprst14)
  begin
    if(!nprst14)
      L1_ctrl_reg114 <= 0;
    else
      L1_ctrl_reg114 <= L1_ctrl_reg14;
  end

  // Program14 mode decode
  always @(L1_ctrl_reg14 or L1_ctrl_reg114 or int_source_h14 or cpu_shutoff_ctrl14) begin
    mte_smc_start14 = 0;
    mte_uart_start14 = 0;
    mte_smc_uart_start14  = 0;
    mte_mac_off_start14  = 0;
    mte_mac012_start14 = 0;
    mte_mac013_start14 = 0;
    mte_mac023_start14 = 0;
    mte_mac123_start14 = 0;
    mte_mac01_start14 = 0;
    mte_mac02_start14 = 0;
    mte_mac03_start14 = 0;
    mte_mac12_start14 = 0;
    mte_mac13_start14 = 0;
    mte_mac23_start14 = 0;
    mte_mac0_start14 = 0;
    mte_mac1_start14 = 0;
    mte_mac2_start14 = 0;
    mte_mac3_start14 = 0;
    mte_sys_hibernate14 = 0 ;
    mte_dma_start14 = 0 ;
    mte_cpu_start14 = 0 ;

    mte_mac0_sleep_start14 = (L1_ctrl_reg14 ==  'h14) && (L1_ctrl_reg114 == 'h4 );
    mte_mac1_sleep_start14 = (L1_ctrl_reg14 ==  'h14) && (L1_ctrl_reg114 == 'h5 ); 
    mte_mac2_sleep_start14 = (L1_ctrl_reg14 ==  'h14) && (L1_ctrl_reg114 == 'h6 ); 
    mte_mac3_sleep_start14 = (L1_ctrl_reg14 ==  'h14) && (L1_ctrl_reg114 == 'h7 ); 
    mte_mac01_sleep_start14 = (L1_ctrl_reg14 ==  'h14) && (L1_ctrl_reg114 == 'h8 ); 
    mte_mac02_sleep_start14 = (L1_ctrl_reg14 ==  'h14) && (L1_ctrl_reg114 == 'h9 ); 
    mte_mac03_sleep_start14 = (L1_ctrl_reg14 ==  'h14) && (L1_ctrl_reg114 == 'hA ); 
    mte_mac12_sleep_start14 = (L1_ctrl_reg14 ==  'h14) && (L1_ctrl_reg114 == 'hB ); 
    mte_mac13_sleep_start14 = (L1_ctrl_reg14 ==  'h14) && (L1_ctrl_reg114 == 'hC ); 
    mte_mac23_sleep_start14 = (L1_ctrl_reg14 ==  'h14) && (L1_ctrl_reg114 == 'hD ); 
    mte_mac012_sleep_start14 = (L1_ctrl_reg14 ==  'h14) && (L1_ctrl_reg114 == 'hE ); 
    mte_mac013_sleep_start14 = (L1_ctrl_reg14 ==  'h14) && (L1_ctrl_reg114 == 'hF ); 
    mte_mac023_sleep_start14 = (L1_ctrl_reg14 ==  'h14) && (L1_ctrl_reg114 == 'h10 ); 
    mte_mac123_sleep_start14 = (L1_ctrl_reg14 ==  'h14) && (L1_ctrl_reg114 == 'h11 ); 
    mte_mac_off_sleep_start14 =  (L1_ctrl_reg14 == 'h14) && (L1_ctrl_reg114 == 'h12 );
    mte_dma_sleep_start14 =  (L1_ctrl_reg14 == 'h14) && (L1_ctrl_reg114 == 'h13 );

    mte_pm_uart_to_default_start14 = (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'h1);
    mte_pm_smc_to_default_start14 = (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'h2);
    mte_pm_smc_uart_to_default_start14 = (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'h3); 
    mte_mac0_to_default14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'h4); 
    mte_mac1_to_default14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'h5); 
    mte_mac2_to_default14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'h6); 
    mte_mac3_to_default14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'h7); 
    mte_mac01_to_default14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'h8); 
    mte_mac02_to_default14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'h9); 
    mte_mac03_to_default14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'hA); 
    mte_mac12_to_default14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'hB); 
    mte_mac13_to_default14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'hC); 
    mte_mac23_to_default14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'hD); 
    mte_mac012_to_default14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'hE); 
    mte_mac013_to_default14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'hF); 
    mte_mac023_to_default14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'h10); 
    mte_mac123_to_default14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'h11); 
    mte_mac_off_to_default14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'h12); 
    mte_dma_isolate_dis14 =  (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'h13); 
    mte_cpu_isolate_dis14 =  (int_source_h14) && (cpu_shutoff_ctrl14) && (L1_ctrl_reg14 != 'h15);
    mte_sys_hibernate_to_default14 = (L1_ctrl_reg14 == 32'h0) && (L1_ctrl_reg114 == 'h15); 

   
    if (L1_ctrl_reg114 == 'h0) begin // This14 check is to make mte_cpu_start14
                                   // is set only when you from default state 
      case (L1_ctrl_reg14)
        'h0 : L1_ctrl_domain14 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain14 = 32'h2; // PM_uart14
                mte_uart_start14 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain14 = 32'h4; // PM_smc14
                mte_smc_start14 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain14 = 32'h6; // PM_smc_uart14
                mte_smc_uart_start14 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain14 = 32'h8; //  PM_macb014
                mte_mac0_start14 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain14 = 32'h10; //  PM_macb114
                mte_mac1_start14 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain14 = 32'h20; //  PM_macb214
                mte_mac2_start14 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain14 = 32'h40; //  PM_macb314
                mte_mac3_start14 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain14 = 32'h18; //  PM_macb0114
                mte_mac01_start14 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain14 = 32'h28; //  PM_macb0214
                mte_mac02_start14 = 1;
              end
        'hA : begin  
                L1_ctrl_domain14 = 32'h48; //  PM_macb0314
                mte_mac03_start14 = 1;
              end
        'hB : begin  
                L1_ctrl_domain14 = 32'h30; //  PM_macb1214
                mte_mac12_start14 = 1;
              end
        'hC : begin  
                L1_ctrl_domain14 = 32'h50; //  PM_macb1314
                mte_mac13_start14 = 1;
              end
        'hD : begin  
                L1_ctrl_domain14 = 32'h60; //  PM_macb2314
                mte_mac23_start14 = 1;
              end
        'hE : begin  
                L1_ctrl_domain14 = 32'h38; //  PM_macb01214
                mte_mac012_start14 = 1;
              end
        'hF : begin  
                L1_ctrl_domain14 = 32'h58; //  PM_macb01314
                mte_mac013_start14 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain14 = 32'h68; //  PM_macb02314
                mte_mac023_start14 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain14 = 32'h70; //  PM_macb12314
                mte_mac123_start14 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain14 = 32'h78; //  PM_macb_off14
                mte_mac_off_start14 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain14 = 32'h80; //  PM_dma14
                mte_dma_start14 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain14 = 32'h100; //  PM_cpu_sleep14
                mte_cpu_start14 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain14 = 32'h1FE; //  PM_hibernate14
                mte_sys_hibernate14 = 1;
              end
         default: L1_ctrl_domain14 = 32'h0;
      endcase
    end
  end


  wire to_default14 = (L1_ctrl_reg14 == 0);

  // Scan14 mode gating14 of power14 and isolation14 control14 signals14
  //SMC14
  assign rstn_non_srpg_smc14  = (scan_mode14 == 1'b0) ? rstn_non_srpg_smc_int14 : 1'b1;  
  assign gate_clk_smc14       = (scan_mode14 == 1'b0) ? gate_clk_smc_int14 : 1'b0;     
  assign isolate_smc14        = (scan_mode14 == 1'b0) ? isolate_smc_int14 : 1'b0;      
  assign pwr1_on_smc14        = (scan_mode14 == 1'b0) ? pwr1_on_smc_int14 : 1'b1;       
  assign pwr2_on_smc14        = (scan_mode14 == 1'b0) ? pwr2_on_smc_int14 : 1'b1;       
  assign pwr1_off_smc14       = (scan_mode14 == 1'b0) ? (!pwr1_on_smc_int14) : 1'b0;       
  assign pwr2_off_smc14       = (scan_mode14 == 1'b0) ? (!pwr2_on_smc_int14) : 1'b0;       
  assign save_edge_smc14       = (scan_mode14 == 1'b0) ? (save_edge_smc_int14) : 1'b0;       
  assign restore_edge_smc14       = (scan_mode14 == 1'b0) ? (restore_edge_smc_int14) : 1'b0;       

  //URT14
  assign rstn_non_srpg_urt14  = (scan_mode14 == 1'b0) ?  rstn_non_srpg_urt_int14 : 1'b1;  
  assign gate_clk_urt14       = (scan_mode14 == 1'b0) ?  gate_clk_urt_int14      : 1'b0;     
  assign isolate_urt14        = (scan_mode14 == 1'b0) ?  isolate_urt_int14       : 1'b0;      
  assign pwr1_on_urt14        = (scan_mode14 == 1'b0) ?  pwr1_on_urt_int14       : 1'b1;       
  assign pwr2_on_urt14        = (scan_mode14 == 1'b0) ?  pwr2_on_urt_int14       : 1'b1;       
  assign pwr1_off_urt14       = (scan_mode14 == 1'b0) ?  (!pwr1_on_urt_int14)  : 1'b0;       
  assign pwr2_off_urt14       = (scan_mode14 == 1'b0) ?  (!pwr2_on_urt_int14)  : 1'b0;       
  assign save_edge_urt14       = (scan_mode14 == 1'b0) ? (save_edge_urt_int14) : 1'b0;       
  assign restore_edge_urt14       = (scan_mode14 == 1'b0) ? (restore_edge_urt_int14) : 1'b0;       

  //ETH014
  assign rstn_non_srpg_macb014 = (scan_mode14 == 1'b0) ?  rstn_non_srpg_macb0_int14 : 1'b1;  
  assign gate_clk_macb014       = (scan_mode14 == 1'b0) ?  gate_clk_macb0_int14      : 1'b0;     
  assign isolate_macb014        = (scan_mode14 == 1'b0) ?  isolate_macb0_int14       : 1'b0;      
  assign pwr1_on_macb014        = (scan_mode14 == 1'b0) ?  pwr1_on_macb0_int14       : 1'b1;       
  assign pwr2_on_macb014        = (scan_mode14 == 1'b0) ?  pwr2_on_macb0_int14       : 1'b1;       
  assign pwr1_off_macb014       = (scan_mode14 == 1'b0) ?  (!pwr1_on_macb0_int14)  : 1'b0;       
  assign pwr2_off_macb014       = (scan_mode14 == 1'b0) ?  (!pwr2_on_macb0_int14)  : 1'b0;       
  assign save_edge_macb014       = (scan_mode14 == 1'b0) ? (save_edge_macb0_int14) : 1'b0;       
  assign restore_edge_macb014       = (scan_mode14 == 1'b0) ? (restore_edge_macb0_int14) : 1'b0;       

  //ETH114
  assign rstn_non_srpg_macb114 = (scan_mode14 == 1'b0) ?  rstn_non_srpg_macb1_int14 : 1'b1;  
  assign gate_clk_macb114       = (scan_mode14 == 1'b0) ?  gate_clk_macb1_int14      : 1'b0;     
  assign isolate_macb114        = (scan_mode14 == 1'b0) ?  isolate_macb1_int14       : 1'b0;      
  assign pwr1_on_macb114        = (scan_mode14 == 1'b0) ?  pwr1_on_macb1_int14       : 1'b1;       
  assign pwr2_on_macb114        = (scan_mode14 == 1'b0) ?  pwr2_on_macb1_int14       : 1'b1;       
  assign pwr1_off_macb114       = (scan_mode14 == 1'b0) ?  (!pwr1_on_macb1_int14)  : 1'b0;       
  assign pwr2_off_macb114       = (scan_mode14 == 1'b0) ?  (!pwr2_on_macb1_int14)  : 1'b0;       
  assign save_edge_macb114       = (scan_mode14 == 1'b0) ? (save_edge_macb1_int14) : 1'b0;       
  assign restore_edge_macb114       = (scan_mode14 == 1'b0) ? (restore_edge_macb1_int14) : 1'b0;       

  //ETH214
  assign rstn_non_srpg_macb214 = (scan_mode14 == 1'b0) ?  rstn_non_srpg_macb2_int14 : 1'b1;  
  assign gate_clk_macb214       = (scan_mode14 == 1'b0) ?  gate_clk_macb2_int14      : 1'b0;     
  assign isolate_macb214        = (scan_mode14 == 1'b0) ?  isolate_macb2_int14       : 1'b0;      
  assign pwr1_on_macb214        = (scan_mode14 == 1'b0) ?  pwr1_on_macb2_int14       : 1'b1;       
  assign pwr2_on_macb214        = (scan_mode14 == 1'b0) ?  pwr2_on_macb2_int14       : 1'b1;       
  assign pwr1_off_macb214       = (scan_mode14 == 1'b0) ?  (!pwr1_on_macb2_int14)  : 1'b0;       
  assign pwr2_off_macb214       = (scan_mode14 == 1'b0) ?  (!pwr2_on_macb2_int14)  : 1'b0;       
  assign save_edge_macb214       = (scan_mode14 == 1'b0) ? (save_edge_macb2_int14) : 1'b0;       
  assign restore_edge_macb214       = (scan_mode14 == 1'b0) ? (restore_edge_macb2_int14) : 1'b0;       

  //ETH314
  assign rstn_non_srpg_macb314 = (scan_mode14 == 1'b0) ?  rstn_non_srpg_macb3_int14 : 1'b1;  
  assign gate_clk_macb314       = (scan_mode14 == 1'b0) ?  gate_clk_macb3_int14      : 1'b0;     
  assign isolate_macb314        = (scan_mode14 == 1'b0) ?  isolate_macb3_int14       : 1'b0;      
  assign pwr1_on_macb314        = (scan_mode14 == 1'b0) ?  pwr1_on_macb3_int14       : 1'b1;       
  assign pwr2_on_macb314        = (scan_mode14 == 1'b0) ?  pwr2_on_macb3_int14       : 1'b1;       
  assign pwr1_off_macb314       = (scan_mode14 == 1'b0) ?  (!pwr1_on_macb3_int14)  : 1'b0;       
  assign pwr2_off_macb314       = (scan_mode14 == 1'b0) ?  (!pwr2_on_macb3_int14)  : 1'b0;       
  assign save_edge_macb314       = (scan_mode14 == 1'b0) ? (save_edge_macb3_int14) : 1'b0;       
  assign restore_edge_macb314       = (scan_mode14 == 1'b0) ? (restore_edge_macb3_int14) : 1'b0;       

  // MEM14
  assign rstn_non_srpg_mem14 =   (rstn_non_srpg_macb014 && rstn_non_srpg_macb114 && rstn_non_srpg_macb214 &&
                                rstn_non_srpg_macb314 && rstn_non_srpg_dma14 && rstn_non_srpg_cpu14 && rstn_non_srpg_urt14 &&
                                rstn_non_srpg_smc14);

  assign gate_clk_mem14 =  (gate_clk_macb014 && gate_clk_macb114 && gate_clk_macb214 &&
                            gate_clk_macb314 && gate_clk_dma14 && gate_clk_cpu14 && gate_clk_urt14 && gate_clk_smc14);

  assign isolate_mem14  = (isolate_macb014 && isolate_macb114 && isolate_macb214 &&
                         isolate_macb314 && isolate_dma14 && isolate_cpu14 && isolate_urt14 && isolate_smc14);


  assign pwr1_on_mem14        =   ~pwr1_off_mem14;

  assign pwr2_on_mem14        =   ~pwr2_off_mem14;

  assign pwr1_off_mem14       =  (pwr1_off_macb014 && pwr1_off_macb114 && pwr1_off_macb214 &&
                                 pwr1_off_macb314 && pwr1_off_dma14 && pwr1_off_cpu14 && pwr1_off_urt14 && pwr1_off_smc14);


  assign pwr2_off_mem14       =  (pwr2_off_macb014 && pwr2_off_macb114 && pwr2_off_macb214 &&
                                pwr2_off_macb314 && pwr2_off_dma14 && pwr2_off_cpu14 && pwr2_off_urt14 && pwr2_off_smc14);

  assign save_edge_mem14      =  (save_edge_macb014 && save_edge_macb114 && save_edge_macb214 &&
                                save_edge_macb314 && save_edge_dma14 && save_edge_cpu14 && save_edge_smc14 && save_edge_urt14);

  assign restore_edge_mem14   =  (restore_edge_macb014 && restore_edge_macb114 && restore_edge_macb214  &&
                                restore_edge_macb314 && restore_edge_dma14 && restore_edge_cpu14 && restore_edge_urt14 &&
                                restore_edge_smc14);

  assign standby_mem014 = pwr1_off_macb014 && (~ (pwr1_off_macb014 && pwr1_off_macb114 && pwr1_off_macb214 && pwr1_off_macb314 && pwr1_off_urt14 && pwr1_off_smc14 && pwr1_off_dma14 && pwr1_off_cpu14));
  assign standby_mem114 = pwr1_off_macb114 && (~ (pwr1_off_macb014 && pwr1_off_macb114 && pwr1_off_macb214 && pwr1_off_macb314 && pwr1_off_urt14 && pwr1_off_smc14 && pwr1_off_dma14 && pwr1_off_cpu14));
  assign standby_mem214 = pwr1_off_macb214 && (~ (pwr1_off_macb014 && pwr1_off_macb114 && pwr1_off_macb214 && pwr1_off_macb314 && pwr1_off_urt14 && pwr1_off_smc14 && pwr1_off_dma14 && pwr1_off_cpu14));
  assign standby_mem314 = pwr1_off_macb314 && (~ (pwr1_off_macb014 && pwr1_off_macb114 && pwr1_off_macb214 && pwr1_off_macb314 && pwr1_off_urt14 && pwr1_off_smc14 && pwr1_off_dma14 && pwr1_off_cpu14));

  assign pwr1_off_mem014 = pwr1_off_mem14;
  assign pwr1_off_mem114 = pwr1_off_mem14;
  assign pwr1_off_mem214 = pwr1_off_mem14;
  assign pwr1_off_mem314 = pwr1_off_mem14;

  assign rstn_non_srpg_alut14  =  (rstn_non_srpg_macb014 && rstn_non_srpg_macb114 && rstn_non_srpg_macb214 && rstn_non_srpg_macb314);


   assign gate_clk_alut14       =  (gate_clk_macb014 && gate_clk_macb114 && gate_clk_macb214 && gate_clk_macb314);


    assign isolate_alut14        =  (isolate_macb014 && isolate_macb114 && isolate_macb214 && isolate_macb314);


    assign pwr1_on_alut14        =  (pwr1_on_macb014 || pwr1_on_macb114 || pwr1_on_macb214 || pwr1_on_macb314);


    assign pwr2_on_alut14        =  (pwr2_on_macb014 || pwr2_on_macb114 || pwr2_on_macb214 || pwr2_on_macb314);


    assign pwr1_off_alut14       =  (pwr1_off_macb014 && pwr1_off_macb114 && pwr1_off_macb214 && pwr1_off_macb314);


    assign pwr2_off_alut14       =  (pwr2_off_macb014 && pwr2_off_macb114 && pwr2_off_macb214 && pwr2_off_macb314);


    assign save_edge_alut14      =  (save_edge_macb014 && save_edge_macb114 && save_edge_macb214 && save_edge_macb314);


    assign restore_edge_alut14   =  (restore_edge_macb014 || restore_edge_macb114 || restore_edge_macb214 ||
                                   restore_edge_macb314) && save_alut_tmp14;

     // alut14 power14 off14 detection14
  always @(posedge pclk14 or negedge nprst14) begin
    if (!nprst14) 
       save_alut_tmp14 <= 0;
    else if (restore_edge_alut14)
       save_alut_tmp14 <= 0;
    else if (save_edge_alut14)
       save_alut_tmp14 <= 1;
  end

  //DMA14
  assign rstn_non_srpg_dma14 = (scan_mode14 == 1'b0) ?  rstn_non_srpg_dma_int14 : 1'b1;  
  assign gate_clk_dma14       = (scan_mode14 == 1'b0) ?  gate_clk_dma_int14      : 1'b0;     
  assign isolate_dma14        = (scan_mode14 == 1'b0) ?  isolate_dma_int14       : 1'b0;      
  assign pwr1_on_dma14        = (scan_mode14 == 1'b0) ?  pwr1_on_dma_int14       : 1'b1;       
  assign pwr2_on_dma14        = (scan_mode14 == 1'b0) ?  pwr2_on_dma_int14       : 1'b1;       
  assign pwr1_off_dma14       = (scan_mode14 == 1'b0) ?  (!pwr1_on_dma_int14)  : 1'b0;       
  assign pwr2_off_dma14       = (scan_mode14 == 1'b0) ?  (!pwr2_on_dma_int14)  : 1'b0;       
  assign save_edge_dma14       = (scan_mode14 == 1'b0) ? (save_edge_dma_int14) : 1'b0;       
  assign restore_edge_dma14       = (scan_mode14 == 1'b0) ? (restore_edge_dma_int14) : 1'b0;       

  //CPU14
  assign rstn_non_srpg_cpu14 = (scan_mode14 == 1'b0) ?  rstn_non_srpg_cpu_int14 : 1'b1;  
  assign gate_clk_cpu14       = (scan_mode14 == 1'b0) ?  gate_clk_cpu_int14      : 1'b0;     
  assign isolate_cpu14        = (scan_mode14 == 1'b0) ?  isolate_cpu_int14       : 1'b0;      
  assign pwr1_on_cpu14        = (scan_mode14 == 1'b0) ?  pwr1_on_cpu_int14       : 1'b1;       
  assign pwr2_on_cpu14        = (scan_mode14 == 1'b0) ?  pwr2_on_cpu_int14       : 1'b1;       
  assign pwr1_off_cpu14       = (scan_mode14 == 1'b0) ?  (!pwr1_on_cpu_int14)  : 1'b0;       
  assign pwr2_off_cpu14       = (scan_mode14 == 1'b0) ?  (!pwr2_on_cpu_int14)  : 1'b0;       
  assign save_edge_cpu14       = (scan_mode14 == 1'b0) ? (save_edge_cpu_int14) : 1'b0;       
  assign restore_edge_cpu14       = (scan_mode14 == 1'b0) ? (restore_edge_cpu_int14) : 1'b0;       



  // ASE14

   reg ase_core_12v14, ase_core_10v14, ase_core_08v14, ase_core_06v14;
   reg ase_macb0_12v14,ase_macb1_12v14,ase_macb2_12v14,ase_macb3_12v14;

    // core14 ase14

    // core14 at 1.0 v if (smc14 off14, urt14 off14, macb014 off14, macb114 off14, macb214 off14, macb314 off14
   // core14 at 0.8v if (mac01off14, macb02off14, macb03off14, macb12off14, mac13off14, mac23off14,
   // core14 at 0.6v if (mac012off14, mac013off14, mac023off14, mac123off14, mac0123off14
    // else core14 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb014 && pwr1_off_macb114 && pwr1_off_macb214 && pwr1_off_macb314) || // all mac14 off14
       (pwr1_off_macb314 && pwr1_off_macb214 && pwr1_off_macb114) || // mac123off14 
       (pwr1_off_macb314 && pwr1_off_macb214 && pwr1_off_macb014) || // mac023off14 
       (pwr1_off_macb314 && pwr1_off_macb114 && pwr1_off_macb014) || // mac013off14 
       (pwr1_off_macb214 && pwr1_off_macb114 && pwr1_off_macb014) )  // mac012off14 
       begin
         ase_core_12v14 = 0;
         ase_core_10v14 = 0;
         ase_core_08v14 = 0;
         ase_core_06v14 = 1;
       end
     else if( (pwr1_off_macb214 && pwr1_off_macb314) || // mac2314 off14
         (pwr1_off_macb314 && pwr1_off_macb114) || // mac13off14 
         (pwr1_off_macb114 && pwr1_off_macb214) || // mac12off14 
         (pwr1_off_macb314 && pwr1_off_macb014) || // mac03off14 
         (pwr1_off_macb214 && pwr1_off_macb014) || // mac02off14 
         (pwr1_off_macb114 && pwr1_off_macb014))  // mac01off14 
       begin
         ase_core_12v14 = 0;
         ase_core_10v14 = 0;
         ase_core_08v14 = 1;
         ase_core_06v14 = 0;
       end
     else if( (pwr1_off_smc14) || // smc14 off14
         (pwr1_off_macb014 ) || // mac0off14 
         (pwr1_off_macb114 ) || // mac1off14 
         (pwr1_off_macb214 ) || // mac2off14 
         (pwr1_off_macb314 ))  // mac3off14 
       begin
         ase_core_12v14 = 0;
         ase_core_10v14 = 1;
         ase_core_08v14 = 0;
         ase_core_06v14 = 0;
       end
     else if (pwr1_off_urt14)
       begin
         ase_core_12v14 = 1;
         ase_core_10v14 = 0;
         ase_core_08v14 = 0;
         ase_core_06v14 = 0;
       end
     else
       begin
         ase_core_12v14 = 1;
         ase_core_10v14 = 0;
         ase_core_08v14 = 0;
         ase_core_06v14 = 0;
       end
   end


   // cpu14
   // cpu14 @ 1.0v when macoff14, 
   // 
   reg ase_cpu_10v14, ase_cpu_12v14;
   always @(*) begin
    if(pwr1_off_cpu14) begin
     ase_cpu_12v14 = 1'b0;
     ase_cpu_10v14 = 1'b0;
    end
    else if(pwr1_off_macb014 || pwr1_off_macb114 || pwr1_off_macb214 || pwr1_off_macb314)
    begin
     ase_cpu_12v14 = 1'b0;
     ase_cpu_10v14 = 1'b1;
    end
    else
    begin
     ase_cpu_12v14 = 1'b1;
     ase_cpu_10v14 = 1'b0;
    end
   end

   // dma14
   // dma14 @v114.0 for macoff14, 

   reg ase_dma_10v14, ase_dma_12v14;
   always @(*) begin
    if(pwr1_off_dma14) begin
     ase_dma_12v14 = 1'b0;
     ase_dma_10v14 = 1'b0;
    end
    else if(pwr1_off_macb014 || pwr1_off_macb114 || pwr1_off_macb214 || pwr1_off_macb314)
    begin
     ase_dma_12v14 = 1'b0;
     ase_dma_10v14 = 1'b1;
    end
    else
    begin
     ase_dma_12v14 = 1'b1;
     ase_dma_10v14 = 1'b0;
    end
   end

   // alut14
   // @ v114.0 for macoff14

   reg ase_alut_10v14, ase_alut_12v14;
   always @(*) begin
    if(pwr1_off_alut14) begin
     ase_alut_12v14 = 1'b0;
     ase_alut_10v14 = 1'b0;
    end
    else if(pwr1_off_macb014 || pwr1_off_macb114 || pwr1_off_macb214 || pwr1_off_macb314)
    begin
     ase_alut_12v14 = 1'b0;
     ase_alut_10v14 = 1'b1;
    end
    else
    begin
     ase_alut_12v14 = 1'b1;
     ase_alut_10v14 = 1'b0;
    end
   end




   reg ase_uart_12v14;
   reg ase_uart_10v14;
   reg ase_uart_08v14;
   reg ase_uart_06v14;

   reg ase_smc_12v14;


   always @(*) begin
     if(pwr1_off_urt14) begin // uart14 off14
       ase_uart_08v14 = 1'b0;
       ase_uart_06v14 = 1'b0;
       ase_uart_10v14 = 1'b0;
       ase_uart_12v14 = 1'b0;
     end 
     else if( (pwr1_off_macb014 && pwr1_off_macb114 && pwr1_off_macb214 && pwr1_off_macb314) || // all mac14 off14
       (pwr1_off_macb314 && pwr1_off_macb214 && pwr1_off_macb114) || // mac123off14 
       (pwr1_off_macb314 && pwr1_off_macb214 && pwr1_off_macb014) || // mac023off14 
       (pwr1_off_macb314 && pwr1_off_macb114 && pwr1_off_macb014) || // mac013off14 
       (pwr1_off_macb214 && pwr1_off_macb114 && pwr1_off_macb014) )  // mac012off14 
     begin
       ase_uart_06v14 = 1'b1;
       ase_uart_08v14 = 1'b0;
       ase_uart_10v14 = 1'b0;
       ase_uart_12v14 = 1'b0;
     end
     else if( (pwr1_off_macb214 && pwr1_off_macb314) || // mac2314 off14
         (pwr1_off_macb314 && pwr1_off_macb114) || // mac13off14 
         (pwr1_off_macb114 && pwr1_off_macb214) || // mac12off14 
         (pwr1_off_macb314 && pwr1_off_macb014) || // mac03off14 
         (pwr1_off_macb114 && pwr1_off_macb014))  // mac01off14  
     begin
       ase_uart_06v14 = 1'b0;
       ase_uart_08v14 = 1'b1;
       ase_uart_10v14 = 1'b0;
       ase_uart_12v14 = 1'b0;
     end
     else if (pwr1_off_smc14 || pwr1_off_macb014 || pwr1_off_macb114 || pwr1_off_macb214 || pwr1_off_macb314) begin // smc14 off14
       ase_uart_08v14 = 1'b0;
       ase_uart_06v14 = 1'b0;
       ase_uart_10v14 = 1'b1;
       ase_uart_12v14 = 1'b0;
     end 
     else begin
       ase_uart_08v14 = 1'b0;
       ase_uart_06v14 = 1'b0;
       ase_uart_10v14 = 1'b0;
       ase_uart_12v14 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc14) begin
     if (pwr1_off_smc14)  // smc14 off14
       ase_smc_12v14 = 1'b0;
    else
       ase_smc_12v14 = 1'b1;
   end

   
   always @(pwr1_off_macb014) begin
     if (pwr1_off_macb014) // macb014 off14
       ase_macb0_12v14 = 1'b0;
     else
       ase_macb0_12v14 = 1'b1;
   end

   always @(pwr1_off_macb114) begin
     if (pwr1_off_macb114) // macb114 off14
       ase_macb1_12v14 = 1'b0;
     else
       ase_macb1_12v14 = 1'b1;
   end

   always @(pwr1_off_macb214) begin // macb214 off14
     if (pwr1_off_macb214) // macb214 off14
       ase_macb2_12v14 = 1'b0;
     else
       ase_macb2_12v14 = 1'b1;
   end

   always @(pwr1_off_macb314) begin // macb314 off14
     if (pwr1_off_macb314) // macb314 off14
       ase_macb3_12v14 = 1'b0;
     else
       ase_macb3_12v14 = 1'b1;
   end


   // core14 voltage14 for vco14
  assign core12v14 = ase_macb0_12v14 & ase_macb1_12v14 & ase_macb2_12v14 & ase_macb3_12v14;

  assign core10v14 =  (ase_macb0_12v14 & ase_macb1_12v14 & ase_macb2_12v14 & (!ase_macb3_12v14)) ||
                    (ase_macb0_12v14 & ase_macb1_12v14 & (!ase_macb2_12v14) & ase_macb3_12v14) ||
                    (ase_macb0_12v14 & (!ase_macb1_12v14) & ase_macb2_12v14 & ase_macb3_12v14) ||
                    ((!ase_macb0_12v14) & ase_macb1_12v14 & ase_macb2_12v14 & ase_macb3_12v14);

  assign core08v14 =  ((!ase_macb0_12v14) & (!ase_macb1_12v14) & (ase_macb2_12v14) & (ase_macb3_12v14)) ||
                    ((!ase_macb0_12v14) & (ase_macb1_12v14) & (!ase_macb2_12v14) & (ase_macb3_12v14)) ||
                    ((!ase_macb0_12v14) & (ase_macb1_12v14) & (ase_macb2_12v14) & (!ase_macb3_12v14)) ||
                    ((ase_macb0_12v14) & (!ase_macb1_12v14) & (!ase_macb2_12v14) & (ase_macb3_12v14)) ||
                    ((ase_macb0_12v14) & (!ase_macb1_12v14) & (ase_macb2_12v14) & (!ase_macb3_12v14)) ||
                    ((ase_macb0_12v14) & (ase_macb1_12v14) & (!ase_macb2_12v14) & (!ase_macb3_12v14));

  assign core06v14 =  ((!ase_macb0_12v14) & (!ase_macb1_12v14) & (!ase_macb2_12v14) & (ase_macb3_12v14)) ||
                    ((!ase_macb0_12v14) & (!ase_macb1_12v14) & (ase_macb2_12v14) & (!ase_macb3_12v14)) ||
                    ((!ase_macb0_12v14) & (ase_macb1_12v14) & (!ase_macb2_12v14) & (!ase_macb3_12v14)) ||
                    ((ase_macb0_12v14) & (!ase_macb1_12v14) & (!ase_macb2_12v14) & (!ase_macb3_12v14)) ||
                    ((!ase_macb0_12v14) & (!ase_macb1_12v14) & (!ase_macb2_12v14) & (!ase_macb3_12v14)) ;



`ifdef LP_ABV_ON14
// psl14 default clock14 = (posedge pclk14);

// Cover14 a condition in which SMC14 is powered14 down
// and again14 powered14 up while UART14 is going14 into POWER14 down
// state or UART14 is already in POWER14 DOWN14 state
// psl14 cover_overlapping_smc_urt_114:
//    cover{fell14(pwr1_on_urt14);[*];fell14(pwr1_on_smc14);[*];
//    rose14(pwr1_on_smc14);[*];rose14(pwr1_on_urt14)};
//
// Cover14 a condition in which UART14 is powered14 down
// and again14 powered14 up while SMC14 is going14 into POWER14 down
// state or SMC14 is already in POWER14 DOWN14 state
// psl14 cover_overlapping_smc_urt_214:
//    cover{fell14(pwr1_on_smc14);[*];fell14(pwr1_on_urt14);[*];
//    rose14(pwr1_on_urt14);[*];rose14(pwr1_on_smc14)};
//


// Power14 Down14 UART14
// This14 gets14 triggered on rising14 edge of Gate14 signal14 for
// UART14 (gate_clk_urt14). In a next cycle after gate_clk_urt14,
// Isolate14 UART14(isolate_urt14) signal14 become14 HIGH14 (active).
// In 2nd cycle after gate_clk_urt14 becomes HIGH14, RESET14 for NON14
// SRPG14 FFs14(rstn_non_srpg_urt14) and POWER114 for UART14(pwr1_on_urt14) should 
// go14 LOW14. 
// This14 completes14 a POWER14 DOWN14. 

sequence s_power_down_urt14;
      (gate_clk_urt14 & !isolate_urt14 & rstn_non_srpg_urt14 & pwr1_on_urt14) 
  ##1 (gate_clk_urt14 & isolate_urt14 & rstn_non_srpg_urt14 & pwr1_on_urt14) 
  ##3 (gate_clk_urt14 & isolate_urt14 & !rstn_non_srpg_urt14 & !pwr1_on_urt14);
endsequence


property p_power_down_urt14;
   @(posedge pclk14)
    $rose(gate_clk_urt14) |=> s_power_down_urt14;
endproperty

output_power_down_urt14:
  assert property (p_power_down_urt14);


// Power14 UP14 UART14
// Sequence starts with , Rising14 edge of pwr1_on_urt14.
// Two14 clock14 cycle after this, isolate_urt14 should become14 LOW14 
// On14 the following14 clk14 gate_clk_urt14 should go14 low14.
// 5 cycles14 after  Rising14 edge of pwr1_on_urt14, rstn_non_srpg_urt14
// should become14 HIGH14
sequence s_power_up_urt14;
##30 (pwr1_on_urt14 & !isolate_urt14 & gate_clk_urt14 & !rstn_non_srpg_urt14) 
##1 (pwr1_on_urt14 & !isolate_urt14 & !gate_clk_urt14 & !rstn_non_srpg_urt14) 
##2 (pwr1_on_urt14 & !isolate_urt14 & !gate_clk_urt14 & rstn_non_srpg_urt14);
endsequence

property p_power_up_urt14;
   @(posedge pclk14)
  disable iff(!nprst14)
    (!pwr1_on_urt14 ##1 pwr1_on_urt14) |=> s_power_up_urt14;
endproperty

output_power_up_urt14:
  assert property (p_power_up_urt14);


// Power14 Down14 SMC14
// This14 gets14 triggered on rising14 edge of Gate14 signal14 for
// SMC14 (gate_clk_smc14). In a next cycle after gate_clk_smc14,
// Isolate14 SMC14(isolate_smc14) signal14 become14 HIGH14 (active).
// In 2nd cycle after gate_clk_smc14 becomes HIGH14, RESET14 for NON14
// SRPG14 FFs14(rstn_non_srpg_smc14) and POWER114 for SMC14(pwr1_on_smc14) should 
// go14 LOW14. 
// This14 completes14 a POWER14 DOWN14. 

sequence s_power_down_smc14;
      (gate_clk_smc14 & !isolate_smc14 & rstn_non_srpg_smc14 & pwr1_on_smc14) 
  ##1 (gate_clk_smc14 & isolate_smc14 & rstn_non_srpg_smc14 & pwr1_on_smc14) 
  ##3 (gate_clk_smc14 & isolate_smc14 & !rstn_non_srpg_smc14 & !pwr1_on_smc14);
endsequence


property p_power_down_smc14;
   @(posedge pclk14)
    $rose(gate_clk_smc14) |=> s_power_down_smc14;
endproperty

output_power_down_smc14:
  assert property (p_power_down_smc14);


// Power14 UP14 SMC14
// Sequence starts with , Rising14 edge of pwr1_on_smc14.
// Two14 clock14 cycle after this, isolate_smc14 should become14 LOW14 
// On14 the following14 clk14 gate_clk_smc14 should go14 low14.
// 5 cycles14 after  Rising14 edge of pwr1_on_smc14, rstn_non_srpg_smc14
// should become14 HIGH14
sequence s_power_up_smc14;
##30 (pwr1_on_smc14 & !isolate_smc14 & gate_clk_smc14 & !rstn_non_srpg_smc14) 
##1 (pwr1_on_smc14 & !isolate_smc14 & !gate_clk_smc14 & !rstn_non_srpg_smc14) 
##2 (pwr1_on_smc14 & !isolate_smc14 & !gate_clk_smc14 & rstn_non_srpg_smc14);
endsequence

property p_power_up_smc14;
   @(posedge pclk14)
  disable iff(!nprst14)
    (!pwr1_on_smc14 ##1 pwr1_on_smc14) |=> s_power_up_smc14;
endproperty

output_power_up_smc14:
  assert property (p_power_up_smc14);


// COVER14 SMC14 POWER14 DOWN14 AND14 UP14
cover_power_down_up_smc14: cover property (@(posedge pclk14)
(s_power_down_smc14 ##[5:180] s_power_up_smc14));



// COVER14 UART14 POWER14 DOWN14 AND14 UP14
cover_power_down_up_urt14: cover property (@(posedge pclk14)
(s_power_down_urt14 ##[5:180] s_power_up_urt14));

cover_power_down_urt14: cover property (@(posedge pclk14)
(s_power_down_urt14));

cover_power_up_urt14: cover property (@(posedge pclk14)
(s_power_up_urt14));




`ifdef PCM_ABV_ON14
//------------------------------------------------------------------------------
// Power14 Controller14 Formal14 Verification14 component.  Each power14 domain has a 
// separate14 instantiation14
//------------------------------------------------------------------------------

// need to assume that CPU14 will leave14 a minimum time between powering14 down and 
// back up.  In this example14, 10clks has been selected.
// psl14 config_min_uart_pd_time14 : assume always {rose14(L1_ctrl_domain14[1])} |-> { L1_ctrl_domain14[1][*10] } abort14(~nprst14);
// psl14 config_min_uart_pu_time14 : assume always {fell14(L1_ctrl_domain14[1])} |-> { !L1_ctrl_domain14[1][*10] } abort14(~nprst14);
// psl14 config_min_smc_pd_time14 : assume always {rose14(L1_ctrl_domain14[2])} |-> { L1_ctrl_domain14[2][*10] } abort14(~nprst14);
// psl14 config_min_smc_pu_time14 : assume always {fell14(L1_ctrl_domain14[2])} |-> { !L1_ctrl_domain14[2][*10] } abort14(~nprst14);

// UART14 VCOMP14 parameters14
   defparam i_uart_vcomp_domain14.ENABLE_SAVE_RESTORE_EDGE14   = 1;
   defparam i_uart_vcomp_domain14.ENABLE_EXT_PWR_CNTRL14       = 1;
   defparam i_uart_vcomp_domain14.REF_CLK_DEFINED14            = 0;
   defparam i_uart_vcomp_domain14.MIN_SHUTOFF_CYCLES14         = 4;
   defparam i_uart_vcomp_domain14.MIN_RESTORE_TO_ISO_CYCLES14  = 0;
   defparam i_uart_vcomp_domain14.MIN_SAVE_TO_SHUTOFF_CYCLES14 = 1;


   vcomp_domain14 i_uart_vcomp_domain14
   ( .ref_clk14(pclk14),
     .start_lps14(L1_ctrl_domain14[1] || !rstn_non_srpg_urt14),
     .rst_n14(nprst14),
     .ext_power_down14(L1_ctrl_domain14[1]),
     .iso_en14(isolate_urt14),
     .save_edge14(save_edge_urt14),
     .restore_edge14(restore_edge_urt14),
     .domain_shut_off14(pwr1_off_urt14),
     .domain_clk14(!gate_clk_urt14 && pclk14)
   );


// SMC14 VCOMP14 parameters14
   defparam i_smc_vcomp_domain14.ENABLE_SAVE_RESTORE_EDGE14   = 1;
   defparam i_smc_vcomp_domain14.ENABLE_EXT_PWR_CNTRL14       = 1;
   defparam i_smc_vcomp_domain14.REF_CLK_DEFINED14            = 0;
   defparam i_smc_vcomp_domain14.MIN_SHUTOFF_CYCLES14         = 4;
   defparam i_smc_vcomp_domain14.MIN_RESTORE_TO_ISO_CYCLES14  = 0;
   defparam i_smc_vcomp_domain14.MIN_SAVE_TO_SHUTOFF_CYCLES14 = 1;


   vcomp_domain14 i_smc_vcomp_domain14
   ( .ref_clk14(pclk14),
     .start_lps14(L1_ctrl_domain14[2] || !rstn_non_srpg_smc14),
     .rst_n14(nprst14),
     .ext_power_down14(L1_ctrl_domain14[2]),
     .iso_en14(isolate_smc14),
     .save_edge14(save_edge_smc14),
     .restore_edge14(restore_edge_smc14),
     .domain_shut_off14(pwr1_off_smc14),
     .domain_clk14(!gate_clk_smc14 && pclk14)
   );

`endif

`endif



endmodule
