//File23 name   : power_ctrl23.v
//Title23       : Power23 Control23 Module23
//Created23     : 1999
//Description23 : Top23 level of power23 controller23
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

module power_ctrl23 (


    // Clocks23 & Reset23
    pclk23,
    nprst23,
    // APB23 programming23 interface
    paddr23,
    psel23,
    penable23,
    pwrite23,
    pwdata23,
    prdata23,
    // mac23 i/f,
    macb3_wakeup23,
    macb2_wakeup23,
    macb1_wakeup23,
    macb0_wakeup23,
    // Scan23 
    scan_in23,
    scan_en23,
    scan_mode23,
    scan_out23,
    // Module23 control23 outputs23
    int_source_h23,
    // SMC23
    rstn_non_srpg_smc23,
    gate_clk_smc23,
    isolate_smc23,
    save_edge_smc23,
    restore_edge_smc23,
    pwr1_on_smc23,
    pwr2_on_smc23,
    pwr1_off_smc23,
    pwr2_off_smc23,
    // URT23
    rstn_non_srpg_urt23,
    gate_clk_urt23,
    isolate_urt23,
    save_edge_urt23,
    restore_edge_urt23,
    pwr1_on_urt23,
    pwr2_on_urt23,
    pwr1_off_urt23,      
    pwr2_off_urt23,
    // ETH023
    rstn_non_srpg_macb023,
    gate_clk_macb023,
    isolate_macb023,
    save_edge_macb023,
    restore_edge_macb023,
    pwr1_on_macb023,
    pwr2_on_macb023,
    pwr1_off_macb023,      
    pwr2_off_macb023,
    // ETH123
    rstn_non_srpg_macb123,
    gate_clk_macb123,
    isolate_macb123,
    save_edge_macb123,
    restore_edge_macb123,
    pwr1_on_macb123,
    pwr2_on_macb123,
    pwr1_off_macb123,      
    pwr2_off_macb123,
    // ETH223
    rstn_non_srpg_macb223,
    gate_clk_macb223,
    isolate_macb223,
    save_edge_macb223,
    restore_edge_macb223,
    pwr1_on_macb223,
    pwr2_on_macb223,
    pwr1_off_macb223,      
    pwr2_off_macb223,
    // ETH323
    rstn_non_srpg_macb323,
    gate_clk_macb323,
    isolate_macb323,
    save_edge_macb323,
    restore_edge_macb323,
    pwr1_on_macb323,
    pwr2_on_macb323,
    pwr1_off_macb323,      
    pwr2_off_macb323,
    // DMA23
    rstn_non_srpg_dma23,
    gate_clk_dma23,
    isolate_dma23,
    save_edge_dma23,
    restore_edge_dma23,
    pwr1_on_dma23,
    pwr2_on_dma23,
    pwr1_off_dma23,      
    pwr2_off_dma23,
    // CPU23
    rstn_non_srpg_cpu23,
    gate_clk_cpu23,
    isolate_cpu23,
    save_edge_cpu23,
    restore_edge_cpu23,
    pwr1_on_cpu23,
    pwr2_on_cpu23,
    pwr1_off_cpu23,      
    pwr2_off_cpu23,
    // ALUT23
    rstn_non_srpg_alut23,
    gate_clk_alut23,
    isolate_alut23,
    save_edge_alut23,
    restore_edge_alut23,
    pwr1_on_alut23,
    pwr2_on_alut23,
    pwr1_off_alut23,      
    pwr2_off_alut23,
    // MEM23
    rstn_non_srpg_mem23,
    gate_clk_mem23,
    isolate_mem23,
    save_edge_mem23,
    restore_edge_mem23,
    pwr1_on_mem23,
    pwr2_on_mem23,
    pwr1_off_mem23,      
    pwr2_off_mem23,
    // core23 dvfs23 transitions23
    core06v23,
    core08v23,
    core10v23,
    core12v23,
    pcm_macb_wakeup_int23,
    // mte23 signals23
    mte_smc_start23,
    mte_uart_start23,
    mte_smc_uart_start23,  
    mte_pm_smc_to_default_start23, 
    mte_pm_uart_to_default_start23,
    mte_pm_smc_uart_to_default_start23

  );

  parameter STATE_IDLE_12V23 = 4'b0001;
  parameter STATE_06V23 = 4'b0010;
  parameter STATE_08V23 = 4'b0100;
  parameter STATE_10V23 = 4'b1000;

    // Clocks23 & Reset23
    input pclk23;
    input nprst23;
    // APB23 programming23 interface
    input [31:0] paddr23;
    input psel23  ;
    input penable23;
    input pwrite23 ;
    input [31:0] pwdata23;
    output [31:0] prdata23;
    // mac23
    input macb3_wakeup23;
    input macb2_wakeup23;
    input macb1_wakeup23;
    input macb0_wakeup23;
    // Scan23 
    input scan_in23;
    input scan_en23;
    input scan_mode23;
    output scan_out23;
    // Module23 control23 outputs23
    input int_source_h23;
    // SMC23
    output rstn_non_srpg_smc23 ;
    output gate_clk_smc23   ;
    output isolate_smc23   ;
    output save_edge_smc23   ;
    output restore_edge_smc23   ;
    output pwr1_on_smc23   ;
    output pwr2_on_smc23   ;
    output pwr1_off_smc23  ;
    output pwr2_off_smc23  ;
    // URT23
    output rstn_non_srpg_urt23 ;
    output gate_clk_urt23      ;
    output isolate_urt23       ;
    output save_edge_urt23   ;
    output restore_edge_urt23   ;
    output pwr1_on_urt23       ;
    output pwr2_on_urt23       ;
    output pwr1_off_urt23      ;
    output pwr2_off_urt23      ;
    // ETH023
    output rstn_non_srpg_macb023 ;
    output gate_clk_macb023      ;
    output isolate_macb023       ;
    output save_edge_macb023   ;
    output restore_edge_macb023   ;
    output pwr1_on_macb023       ;
    output pwr2_on_macb023       ;
    output pwr1_off_macb023      ;
    output pwr2_off_macb023      ;
    // ETH123
    output rstn_non_srpg_macb123 ;
    output gate_clk_macb123      ;
    output isolate_macb123       ;
    output save_edge_macb123   ;
    output restore_edge_macb123   ;
    output pwr1_on_macb123       ;
    output pwr2_on_macb123       ;
    output pwr1_off_macb123      ;
    output pwr2_off_macb123      ;
    // ETH223
    output rstn_non_srpg_macb223 ;
    output gate_clk_macb223      ;
    output isolate_macb223       ;
    output save_edge_macb223   ;
    output restore_edge_macb223   ;
    output pwr1_on_macb223       ;
    output pwr2_on_macb223       ;
    output pwr1_off_macb223      ;
    output pwr2_off_macb223      ;
    // ETH323
    output rstn_non_srpg_macb323 ;
    output gate_clk_macb323      ;
    output isolate_macb323       ;
    output save_edge_macb323   ;
    output restore_edge_macb323   ;
    output pwr1_on_macb323       ;
    output pwr2_on_macb323       ;
    output pwr1_off_macb323      ;
    output pwr2_off_macb323      ;
    // DMA23
    output rstn_non_srpg_dma23 ;
    output gate_clk_dma23      ;
    output isolate_dma23       ;
    output save_edge_dma23   ;
    output restore_edge_dma23   ;
    output pwr1_on_dma23       ;
    output pwr2_on_dma23       ;
    output pwr1_off_dma23      ;
    output pwr2_off_dma23      ;
    // CPU23
    output rstn_non_srpg_cpu23 ;
    output gate_clk_cpu23      ;
    output isolate_cpu23       ;
    output save_edge_cpu23   ;
    output restore_edge_cpu23   ;
    output pwr1_on_cpu23       ;
    output pwr2_on_cpu23       ;
    output pwr1_off_cpu23      ;
    output pwr2_off_cpu23      ;
    // ALUT23
    output rstn_non_srpg_alut23 ;
    output gate_clk_alut23      ;
    output isolate_alut23       ;
    output save_edge_alut23   ;
    output restore_edge_alut23   ;
    output pwr1_on_alut23       ;
    output pwr2_on_alut23       ;
    output pwr1_off_alut23      ;
    output pwr2_off_alut23      ;
    // MEM23
    output rstn_non_srpg_mem23 ;
    output gate_clk_mem23      ;
    output isolate_mem23       ;
    output save_edge_mem23   ;
    output restore_edge_mem23   ;
    output pwr1_on_mem23       ;
    output pwr2_on_mem23       ;
    output pwr1_off_mem23      ;
    output pwr2_off_mem23      ;


   // core23 transitions23 o/p
    output core06v23;
    output core08v23;
    output core10v23;
    output core12v23;
    output pcm_macb_wakeup_int23 ;
    //mode mte23  signals23
    output mte_smc_start23;
    output mte_uart_start23;
    output mte_smc_uart_start23;  
    output mte_pm_smc_to_default_start23; 
    output mte_pm_uart_to_default_start23;
    output mte_pm_smc_uart_to_default_start23;

    reg mte_smc_start23;
    reg mte_uart_start23;
    reg mte_smc_uart_start23;  
    reg mte_pm_smc_to_default_start23; 
    reg mte_pm_uart_to_default_start23;
    reg mte_pm_smc_uart_to_default_start23;

    reg [31:0] prdata23;

  wire valid_reg_write23  ;
  wire valid_reg_read23   ;
  wire L1_ctrl_access23   ;
  wire L1_status_access23 ;
  wire pcm_int_mask_access23;
  wire pcm_int_status_access23;
  wire standby_mem023      ;
  wire standby_mem123      ;
  wire standby_mem223      ;
  wire standby_mem323      ;
  wire pwr1_off_mem023;
  wire pwr1_off_mem123;
  wire pwr1_off_mem223;
  wire pwr1_off_mem323;
  
  // Control23 signals23
  wire set_status_smc23   ;
  wire clr_status_smc23   ;
  wire set_status_urt23   ;
  wire clr_status_urt23   ;
  wire set_status_macb023   ;
  wire clr_status_macb023   ;
  wire set_status_macb123   ;
  wire clr_status_macb123   ;
  wire set_status_macb223   ;
  wire clr_status_macb223   ;
  wire set_status_macb323   ;
  wire clr_status_macb323   ;
  wire set_status_dma23   ;
  wire clr_status_dma23   ;
  wire set_status_cpu23   ;
  wire clr_status_cpu23   ;
  wire set_status_alut23   ;
  wire clr_status_alut23   ;
  wire set_status_mem23   ;
  wire clr_status_mem23   ;


  // Status and Control23 registers
  reg [31:0]  L1_status_reg23;
  reg  [31:0] L1_ctrl_reg23  ;
  reg  [31:0] L1_ctrl_domain23  ;
  reg L1_ctrl_cpu_off_reg23;
  reg [31:0]  pcm_mask_reg23;
  reg [31:0]  pcm_status_reg23;

  // Signals23 gated23 in scan_mode23
  //SMC23
  wire  rstn_non_srpg_smc_int23;
  wire  gate_clk_smc_int23    ;     
  wire  isolate_smc_int23    ;       
  wire save_edge_smc_int23;
  wire restore_edge_smc_int23;
  wire  pwr1_on_smc_int23    ;      
  wire  pwr2_on_smc_int23    ;      


  //URT23
  wire   rstn_non_srpg_urt_int23;
  wire   gate_clk_urt_int23     ;     
  wire   isolate_urt_int23      ;       
  wire save_edge_urt_int23;
  wire restore_edge_urt_int23;
  wire   pwr1_on_urt_int23      ;      
  wire   pwr2_on_urt_int23      ;      

  // ETH023
  wire   rstn_non_srpg_macb0_int23;
  wire   gate_clk_macb0_int23     ;     
  wire   isolate_macb0_int23      ;       
  wire save_edge_macb0_int23;
  wire restore_edge_macb0_int23;
  wire   pwr1_on_macb0_int23      ;      
  wire   pwr2_on_macb0_int23      ;      
  // ETH123
  wire   rstn_non_srpg_macb1_int23;
  wire   gate_clk_macb1_int23     ;     
  wire   isolate_macb1_int23      ;       
  wire save_edge_macb1_int23;
  wire restore_edge_macb1_int23;
  wire   pwr1_on_macb1_int23      ;      
  wire   pwr2_on_macb1_int23      ;      
  // ETH223
  wire   rstn_non_srpg_macb2_int23;
  wire   gate_clk_macb2_int23     ;     
  wire   isolate_macb2_int23      ;       
  wire save_edge_macb2_int23;
  wire restore_edge_macb2_int23;
  wire   pwr1_on_macb2_int23      ;      
  wire   pwr2_on_macb2_int23      ;      
  // ETH323
  wire   rstn_non_srpg_macb3_int23;
  wire   gate_clk_macb3_int23     ;     
  wire   isolate_macb3_int23      ;       
  wire save_edge_macb3_int23;
  wire restore_edge_macb3_int23;
  wire   pwr1_on_macb3_int23      ;      
  wire   pwr2_on_macb3_int23      ;      

  // DMA23
  wire   rstn_non_srpg_dma_int23;
  wire   gate_clk_dma_int23     ;     
  wire   isolate_dma_int23      ;       
  wire save_edge_dma_int23;
  wire restore_edge_dma_int23;
  wire   pwr1_on_dma_int23      ;      
  wire   pwr2_on_dma_int23      ;      

  // CPU23
  wire   rstn_non_srpg_cpu_int23;
  wire   gate_clk_cpu_int23     ;     
  wire   isolate_cpu_int23      ;       
  wire save_edge_cpu_int23;
  wire restore_edge_cpu_int23;
  wire   pwr1_on_cpu_int23      ;      
  wire   pwr2_on_cpu_int23      ;  
  wire L1_ctrl_cpu_off_p23;    

  reg save_alut_tmp23;
  // DFS23 sm23

  reg cpu_shutoff_ctrl23;

  reg mte_mac_off_start23, mte_mac012_start23, mte_mac013_start23, mte_mac023_start23, mte_mac123_start23;
  reg mte_mac01_start23, mte_mac02_start23, mte_mac03_start23, mte_mac12_start23, mte_mac13_start23, mte_mac23_start23;
  reg mte_mac0_start23, mte_mac1_start23, mte_mac2_start23, mte_mac3_start23;
  reg mte_sys_hibernate23 ;
  reg mte_dma_start23 ;
  reg mte_cpu_start23 ;
  reg mte_mac_off_sleep_start23, mte_mac012_sleep_start23, mte_mac013_sleep_start23, mte_mac023_sleep_start23, mte_mac123_sleep_start23;
  reg mte_mac01_sleep_start23, mte_mac02_sleep_start23, mte_mac03_sleep_start23, mte_mac12_sleep_start23, mte_mac13_sleep_start23, mte_mac23_sleep_start23;
  reg mte_mac0_sleep_start23, mte_mac1_sleep_start23, mte_mac2_sleep_start23, mte_mac3_sleep_start23;
  reg mte_dma_sleep_start23;
  reg mte_mac_off_to_default23, mte_mac012_to_default23, mte_mac013_to_default23, mte_mac023_to_default23, mte_mac123_to_default23;
  reg mte_mac01_to_default23, mte_mac02_to_default23, mte_mac03_to_default23, mte_mac12_to_default23, mte_mac13_to_default23, mte_mac23_to_default23;
  reg mte_mac0_to_default23, mte_mac1_to_default23, mte_mac2_to_default23, mte_mac3_to_default23;
  reg mte_dma_isolate_dis23;
  reg mte_cpu_isolate_dis23;
  reg mte_sys_hibernate_to_default23;


  // Latch23 the CPU23 SLEEP23 invocation23
  always @( posedge pclk23 or negedge nprst23) 
  begin
    if(!nprst23)
      L1_ctrl_cpu_off_reg23 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg23 <= L1_ctrl_domain23[8];
  end

  // Create23 a pulse23 for sleep23 detection23 
  assign L1_ctrl_cpu_off_p23 =  L1_ctrl_domain23[8] && !L1_ctrl_cpu_off_reg23;
  
  // CPU23 sleep23 contol23 logic 
  // Shut23 off23 CPU23 when L1_ctrl_cpu_off_p23 is set
  // wake23 cpu23 when any interrupt23 is seen23  
  always @( posedge pclk23 or negedge nprst23) 
  begin
    if(!nprst23)
     cpu_shutoff_ctrl23 <= 1'b0;
    else if(cpu_shutoff_ctrl23 && int_source_h23)
     cpu_shutoff_ctrl23 <= 1'b0;
    else if (L1_ctrl_cpu_off_p23)
     cpu_shutoff_ctrl23 <= 1'b1;
  end
 
  // instantiate23 power23 contol23  block for uart23
  power_ctrl_sm23 i_urt_power_ctrl_sm23(
    .pclk23(pclk23),
    .nprst23(nprst23),
    .L1_module_req23(L1_ctrl_domain23[1]),
    .set_status_module23(set_status_urt23),
    .clr_status_module23(clr_status_urt23),
    .rstn_non_srpg_module23(rstn_non_srpg_urt_int23),
    .gate_clk_module23(gate_clk_urt_int23),
    .isolate_module23(isolate_urt_int23),
    .save_edge23(save_edge_urt_int23),
    .restore_edge23(restore_edge_urt_int23),
    .pwr1_on23(pwr1_on_urt_int23),
    .pwr2_on23(pwr2_on_urt_int23)
    );
  

  // instantiate23 power23 contol23  block for smc23
  power_ctrl_sm23 i_smc_power_ctrl_sm23(
    .pclk23(pclk23),
    .nprst23(nprst23),
    .L1_module_req23(L1_ctrl_domain23[2]),
    .set_status_module23(set_status_smc23),
    .clr_status_module23(clr_status_smc23),
    .rstn_non_srpg_module23(rstn_non_srpg_smc_int23),
    .gate_clk_module23(gate_clk_smc_int23),
    .isolate_module23(isolate_smc_int23),
    .save_edge23(save_edge_smc_int23),
    .restore_edge23(restore_edge_smc_int23),
    .pwr1_on23(pwr1_on_smc_int23),
    .pwr2_on23(pwr2_on_smc_int23)
    );

  // power23 control23 for macb023
  power_ctrl_sm23 i_macb0_power_ctrl_sm23(
    .pclk23(pclk23),
    .nprst23(nprst23),
    .L1_module_req23(L1_ctrl_domain23[3]),
    .set_status_module23(set_status_macb023),
    .clr_status_module23(clr_status_macb023),
    .rstn_non_srpg_module23(rstn_non_srpg_macb0_int23),
    .gate_clk_module23(gate_clk_macb0_int23),
    .isolate_module23(isolate_macb0_int23),
    .save_edge23(save_edge_macb0_int23),
    .restore_edge23(restore_edge_macb0_int23),
    .pwr1_on23(pwr1_on_macb0_int23),
    .pwr2_on23(pwr2_on_macb0_int23)
    );
  // power23 control23 for macb123
  power_ctrl_sm23 i_macb1_power_ctrl_sm23(
    .pclk23(pclk23),
    .nprst23(nprst23),
    .L1_module_req23(L1_ctrl_domain23[4]),
    .set_status_module23(set_status_macb123),
    .clr_status_module23(clr_status_macb123),
    .rstn_non_srpg_module23(rstn_non_srpg_macb1_int23),
    .gate_clk_module23(gate_clk_macb1_int23),
    .isolate_module23(isolate_macb1_int23),
    .save_edge23(save_edge_macb1_int23),
    .restore_edge23(restore_edge_macb1_int23),
    .pwr1_on23(pwr1_on_macb1_int23),
    .pwr2_on23(pwr2_on_macb1_int23)
    );
  // power23 control23 for macb223
  power_ctrl_sm23 i_macb2_power_ctrl_sm23(
    .pclk23(pclk23),
    .nprst23(nprst23),
    .L1_module_req23(L1_ctrl_domain23[5]),
    .set_status_module23(set_status_macb223),
    .clr_status_module23(clr_status_macb223),
    .rstn_non_srpg_module23(rstn_non_srpg_macb2_int23),
    .gate_clk_module23(gate_clk_macb2_int23),
    .isolate_module23(isolate_macb2_int23),
    .save_edge23(save_edge_macb2_int23),
    .restore_edge23(restore_edge_macb2_int23),
    .pwr1_on23(pwr1_on_macb2_int23),
    .pwr2_on23(pwr2_on_macb2_int23)
    );
  // power23 control23 for macb323
  power_ctrl_sm23 i_macb3_power_ctrl_sm23(
    .pclk23(pclk23),
    .nprst23(nprst23),
    .L1_module_req23(L1_ctrl_domain23[6]),
    .set_status_module23(set_status_macb323),
    .clr_status_module23(clr_status_macb323),
    .rstn_non_srpg_module23(rstn_non_srpg_macb3_int23),
    .gate_clk_module23(gate_clk_macb3_int23),
    .isolate_module23(isolate_macb3_int23),
    .save_edge23(save_edge_macb3_int23),
    .restore_edge23(restore_edge_macb3_int23),
    .pwr1_on23(pwr1_on_macb3_int23),
    .pwr2_on23(pwr2_on_macb3_int23)
    );
  // power23 control23 for dma23
  power_ctrl_sm23 i_dma_power_ctrl_sm23(
    .pclk23(pclk23),
    .nprst23(nprst23),
    .L1_module_req23(L1_ctrl_domain23[7]),
    .set_status_module23(set_status_dma23),
    .clr_status_module23(clr_status_dma23),
    .rstn_non_srpg_module23(rstn_non_srpg_dma_int23),
    .gate_clk_module23(gate_clk_dma_int23),
    .isolate_module23(isolate_dma_int23),
    .save_edge23(save_edge_dma_int23),
    .restore_edge23(restore_edge_dma_int23),
    .pwr1_on23(pwr1_on_dma_int23),
    .pwr2_on23(pwr2_on_dma_int23)
    );
  // power23 control23 for CPU23
  power_ctrl_sm23 i_cpu_power_ctrl_sm23(
    .pclk23(pclk23),
    .nprst23(nprst23),
    .L1_module_req23(cpu_shutoff_ctrl23),
    .set_status_module23(set_status_cpu23),
    .clr_status_module23(clr_status_cpu23),
    .rstn_non_srpg_module23(rstn_non_srpg_cpu_int23),
    .gate_clk_module23(gate_clk_cpu_int23),
    .isolate_module23(isolate_cpu_int23),
    .save_edge23(save_edge_cpu_int23),
    .restore_edge23(restore_edge_cpu_int23),
    .pwr1_on23(pwr1_on_cpu_int23),
    .pwr2_on23(pwr2_on_cpu_int23)
    );

  assign valid_reg_write23 =  (psel23 && pwrite23 && penable23);
  assign valid_reg_read23  =  (psel23 && (!pwrite23) && penable23);

  assign L1_ctrl_access23  =  (paddr23[15:0] == 16'b0000000000000100); 
  assign L1_status_access23 = (paddr23[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access23 =   (paddr23[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access23 = (paddr23[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control23 and status register
  always @(*)
  begin  
    if(valid_reg_read23 && L1_ctrl_access23) 
      prdata23 = L1_ctrl_reg23;
    else if (valid_reg_read23 && L1_status_access23)
      prdata23 = L1_status_reg23;
    else if (valid_reg_read23 && pcm_int_mask_access23)
      prdata23 = pcm_mask_reg23;
    else if (valid_reg_read23 && pcm_int_status_access23)
      prdata23 = pcm_status_reg23;
    else 
      prdata23 = 0;
  end

  assign set_status_mem23 =  (set_status_macb023 && set_status_macb123 && set_status_macb223 &&
                            set_status_macb323 && set_status_dma23 && set_status_cpu23);

  assign clr_status_mem23 =  (clr_status_macb023 && clr_status_macb123 && clr_status_macb223 &&
                            clr_status_macb323 && clr_status_dma23 && clr_status_cpu23);

  assign set_status_alut23 = (set_status_macb023 && set_status_macb123 && set_status_macb223 && set_status_macb323);

  assign clr_status_alut23 = (clr_status_macb023 || clr_status_macb123 || clr_status_macb223  || clr_status_macb323);

  // Write accesses to the control23 and status register
 
  always @(posedge pclk23 or negedge nprst23)
  begin
    if (!nprst23) begin
      L1_ctrl_reg23   <= 0;
      L1_status_reg23 <= 0;
      pcm_mask_reg23 <= 0;
    end else begin
      // CTRL23 reg updates23
      if (valid_reg_write23 && L1_ctrl_access23) 
        L1_ctrl_reg23 <= pwdata23; // Writes23 to the ctrl23 reg
      if (valid_reg_write23 && pcm_int_mask_access23) 
        pcm_mask_reg23 <= pwdata23; // Writes23 to the ctrl23 reg

      if (set_status_urt23 == 1'b1)  
        L1_status_reg23[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt23 == 1'b1) 
        L1_status_reg23[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc23 == 1'b1) 
        L1_status_reg23[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc23 == 1'b1) 
        L1_status_reg23[2] <= 1'b0; // Clear the status bit

      if (set_status_macb023 == 1'b1)  
        L1_status_reg23[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb023 == 1'b1) 
        L1_status_reg23[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb123 == 1'b1)  
        L1_status_reg23[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb123 == 1'b1) 
        L1_status_reg23[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb223 == 1'b1)  
        L1_status_reg23[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb223 == 1'b1) 
        L1_status_reg23[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb323 == 1'b1)  
        L1_status_reg23[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb323 == 1'b1) 
        L1_status_reg23[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma23 == 1'b1)  
        L1_status_reg23[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma23 == 1'b1) 
        L1_status_reg23[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu23 == 1'b1)  
        L1_status_reg23[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu23 == 1'b1) 
        L1_status_reg23[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut23 == 1'b1)  
        L1_status_reg23[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut23 == 1'b1) 
        L1_status_reg23[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem23 == 1'b1)  
        L1_status_reg23[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem23 == 1'b1) 
        L1_status_reg23[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused23 bits of pcm_status_reg23 are tied23 to 0
  always @(posedge pclk23 or negedge nprst23)
  begin
    if (!nprst23)
      pcm_status_reg23[31:4] <= 'b0;
    else  
      pcm_status_reg23[31:4] <= pcm_status_reg23[31:4];
  end
  
  // interrupt23 only of h/w assisted23 wakeup
  // MAC23 3
  always @(posedge pclk23 or negedge nprst23)
  begin
    if(!nprst23)
      pcm_status_reg23[3] <= 1'b0;
    else if (valid_reg_write23 && pcm_int_status_access23) 
      pcm_status_reg23[3] <= pwdata23[3];
    else if (macb3_wakeup23 & ~pcm_mask_reg23[3])
      pcm_status_reg23[3] <= 1'b1;
    else if (valid_reg_read23 && pcm_int_status_access23) 
      pcm_status_reg23[3] <= 1'b0;
    else
      pcm_status_reg23[3] <= pcm_status_reg23[3];
  end  
   
  // MAC23 2
  always @(posedge pclk23 or negedge nprst23)
  begin
    if(!nprst23)
      pcm_status_reg23[2] <= 1'b0;
    else if (valid_reg_write23 && pcm_int_status_access23) 
      pcm_status_reg23[2] <= pwdata23[2];
    else if (macb2_wakeup23 & ~pcm_mask_reg23[2])
      pcm_status_reg23[2] <= 1'b1;
    else if (valid_reg_read23 && pcm_int_status_access23) 
      pcm_status_reg23[2] <= 1'b0;
    else
      pcm_status_reg23[2] <= pcm_status_reg23[2];
  end  

  // MAC23 1
  always @(posedge pclk23 or negedge nprst23)
  begin
    if(!nprst23)
      pcm_status_reg23[1] <= 1'b0;
    else if (valid_reg_write23 && pcm_int_status_access23) 
      pcm_status_reg23[1] <= pwdata23[1];
    else if (macb1_wakeup23 & ~pcm_mask_reg23[1])
      pcm_status_reg23[1] <= 1'b1;
    else if (valid_reg_read23 && pcm_int_status_access23) 
      pcm_status_reg23[1] <= 1'b0;
    else
      pcm_status_reg23[1] <= pcm_status_reg23[1];
  end  
   
  // MAC23 0
  always @(posedge pclk23 or negedge nprst23)
  begin
    if(!nprst23)
      pcm_status_reg23[0] <= 1'b0;
    else if (valid_reg_write23 && pcm_int_status_access23) 
      pcm_status_reg23[0] <= pwdata23[0];
    else if (macb0_wakeup23 & ~pcm_mask_reg23[0])
      pcm_status_reg23[0] <= 1'b1;
    else if (valid_reg_read23 && pcm_int_status_access23) 
      pcm_status_reg23[0] <= 1'b0;
    else
      pcm_status_reg23[0] <= pcm_status_reg23[0];
  end  

  assign pcm_macb_wakeup_int23 = |pcm_status_reg23;

  reg [31:0] L1_ctrl_reg123;
  always @(posedge pclk23 or negedge nprst23)
  begin
    if(!nprst23)
      L1_ctrl_reg123 <= 0;
    else
      L1_ctrl_reg123 <= L1_ctrl_reg23;
  end

  // Program23 mode decode
  always @(L1_ctrl_reg23 or L1_ctrl_reg123 or int_source_h23 or cpu_shutoff_ctrl23) begin
    mte_smc_start23 = 0;
    mte_uart_start23 = 0;
    mte_smc_uart_start23  = 0;
    mte_mac_off_start23  = 0;
    mte_mac012_start23 = 0;
    mte_mac013_start23 = 0;
    mte_mac023_start23 = 0;
    mte_mac123_start23 = 0;
    mte_mac01_start23 = 0;
    mte_mac02_start23 = 0;
    mte_mac03_start23 = 0;
    mte_mac12_start23 = 0;
    mte_mac13_start23 = 0;
    mte_mac23_start23 = 0;
    mte_mac0_start23 = 0;
    mte_mac1_start23 = 0;
    mte_mac2_start23 = 0;
    mte_mac3_start23 = 0;
    mte_sys_hibernate23 = 0 ;
    mte_dma_start23 = 0 ;
    mte_cpu_start23 = 0 ;

    mte_mac0_sleep_start23 = (L1_ctrl_reg23 ==  'h14) && (L1_ctrl_reg123 == 'h4 );
    mte_mac1_sleep_start23 = (L1_ctrl_reg23 ==  'h14) && (L1_ctrl_reg123 == 'h5 ); 
    mte_mac2_sleep_start23 = (L1_ctrl_reg23 ==  'h14) && (L1_ctrl_reg123 == 'h6 ); 
    mte_mac3_sleep_start23 = (L1_ctrl_reg23 ==  'h14) && (L1_ctrl_reg123 == 'h7 ); 
    mte_mac01_sleep_start23 = (L1_ctrl_reg23 ==  'h14) && (L1_ctrl_reg123 == 'h8 ); 
    mte_mac02_sleep_start23 = (L1_ctrl_reg23 ==  'h14) && (L1_ctrl_reg123 == 'h9 ); 
    mte_mac03_sleep_start23 = (L1_ctrl_reg23 ==  'h14) && (L1_ctrl_reg123 == 'hA ); 
    mte_mac12_sleep_start23 = (L1_ctrl_reg23 ==  'h14) && (L1_ctrl_reg123 == 'hB ); 
    mte_mac13_sleep_start23 = (L1_ctrl_reg23 ==  'h14) && (L1_ctrl_reg123 == 'hC ); 
    mte_mac23_sleep_start23 = (L1_ctrl_reg23 ==  'h14) && (L1_ctrl_reg123 == 'hD ); 
    mte_mac012_sleep_start23 = (L1_ctrl_reg23 ==  'h14) && (L1_ctrl_reg123 == 'hE ); 
    mte_mac013_sleep_start23 = (L1_ctrl_reg23 ==  'h14) && (L1_ctrl_reg123 == 'hF ); 
    mte_mac023_sleep_start23 = (L1_ctrl_reg23 ==  'h14) && (L1_ctrl_reg123 == 'h10 ); 
    mte_mac123_sleep_start23 = (L1_ctrl_reg23 ==  'h14) && (L1_ctrl_reg123 == 'h11 ); 
    mte_mac_off_sleep_start23 =  (L1_ctrl_reg23 == 'h14) && (L1_ctrl_reg123 == 'h12 );
    mte_dma_sleep_start23 =  (L1_ctrl_reg23 == 'h14) && (L1_ctrl_reg123 == 'h13 );

    mte_pm_uart_to_default_start23 = (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'h1);
    mte_pm_smc_to_default_start23 = (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'h2);
    mte_pm_smc_uart_to_default_start23 = (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'h3); 
    mte_mac0_to_default23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'h4); 
    mte_mac1_to_default23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'h5); 
    mte_mac2_to_default23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'h6); 
    mte_mac3_to_default23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'h7); 
    mte_mac01_to_default23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'h8); 
    mte_mac02_to_default23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'h9); 
    mte_mac03_to_default23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'hA); 
    mte_mac12_to_default23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'hB); 
    mte_mac13_to_default23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'hC); 
    mte_mac23_to_default23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'hD); 
    mte_mac012_to_default23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'hE); 
    mte_mac013_to_default23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'hF); 
    mte_mac023_to_default23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'h10); 
    mte_mac123_to_default23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'h11); 
    mte_mac_off_to_default23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'h12); 
    mte_dma_isolate_dis23 =  (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'h13); 
    mte_cpu_isolate_dis23 =  (int_source_h23) && (cpu_shutoff_ctrl23) && (L1_ctrl_reg23 != 'h15);
    mte_sys_hibernate_to_default23 = (L1_ctrl_reg23 == 32'h0) && (L1_ctrl_reg123 == 'h15); 

   
    if (L1_ctrl_reg123 == 'h0) begin // This23 check is to make mte_cpu_start23
                                   // is set only when you from default state 
      case (L1_ctrl_reg23)
        'h0 : L1_ctrl_domain23 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain23 = 32'h2; // PM_uart23
                mte_uart_start23 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain23 = 32'h4; // PM_smc23
                mte_smc_start23 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain23 = 32'h6; // PM_smc_uart23
                mte_smc_uart_start23 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain23 = 32'h8; //  PM_macb023
                mte_mac0_start23 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain23 = 32'h10; //  PM_macb123
                mte_mac1_start23 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain23 = 32'h20; //  PM_macb223
                mte_mac2_start23 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain23 = 32'h40; //  PM_macb323
                mte_mac3_start23 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain23 = 32'h18; //  PM_macb0123
                mte_mac01_start23 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain23 = 32'h28; //  PM_macb0223
                mte_mac02_start23 = 1;
              end
        'hA : begin  
                L1_ctrl_domain23 = 32'h48; //  PM_macb0323
                mte_mac03_start23 = 1;
              end
        'hB : begin  
                L1_ctrl_domain23 = 32'h30; //  PM_macb1223
                mte_mac12_start23 = 1;
              end
        'hC : begin  
                L1_ctrl_domain23 = 32'h50; //  PM_macb1323
                mte_mac13_start23 = 1;
              end
        'hD : begin  
                L1_ctrl_domain23 = 32'h60; //  PM_macb2323
                mte_mac23_start23 = 1;
              end
        'hE : begin  
                L1_ctrl_domain23 = 32'h38; //  PM_macb01223
                mte_mac012_start23 = 1;
              end
        'hF : begin  
                L1_ctrl_domain23 = 32'h58; //  PM_macb01323
                mte_mac013_start23 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain23 = 32'h68; //  PM_macb02323
                mte_mac023_start23 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain23 = 32'h70; //  PM_macb12323
                mte_mac123_start23 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain23 = 32'h78; //  PM_macb_off23
                mte_mac_off_start23 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain23 = 32'h80; //  PM_dma23
                mte_dma_start23 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain23 = 32'h100; //  PM_cpu_sleep23
                mte_cpu_start23 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain23 = 32'h1FE; //  PM_hibernate23
                mte_sys_hibernate23 = 1;
              end
         default: L1_ctrl_domain23 = 32'h0;
      endcase
    end
  end


  wire to_default23 = (L1_ctrl_reg23 == 0);

  // Scan23 mode gating23 of power23 and isolation23 control23 signals23
  //SMC23
  assign rstn_non_srpg_smc23  = (scan_mode23 == 1'b0) ? rstn_non_srpg_smc_int23 : 1'b1;  
  assign gate_clk_smc23       = (scan_mode23 == 1'b0) ? gate_clk_smc_int23 : 1'b0;     
  assign isolate_smc23        = (scan_mode23 == 1'b0) ? isolate_smc_int23 : 1'b0;      
  assign pwr1_on_smc23        = (scan_mode23 == 1'b0) ? pwr1_on_smc_int23 : 1'b1;       
  assign pwr2_on_smc23        = (scan_mode23 == 1'b0) ? pwr2_on_smc_int23 : 1'b1;       
  assign pwr1_off_smc23       = (scan_mode23 == 1'b0) ? (!pwr1_on_smc_int23) : 1'b0;       
  assign pwr2_off_smc23       = (scan_mode23 == 1'b0) ? (!pwr2_on_smc_int23) : 1'b0;       
  assign save_edge_smc23       = (scan_mode23 == 1'b0) ? (save_edge_smc_int23) : 1'b0;       
  assign restore_edge_smc23       = (scan_mode23 == 1'b0) ? (restore_edge_smc_int23) : 1'b0;       

  //URT23
  assign rstn_non_srpg_urt23  = (scan_mode23 == 1'b0) ?  rstn_non_srpg_urt_int23 : 1'b1;  
  assign gate_clk_urt23       = (scan_mode23 == 1'b0) ?  gate_clk_urt_int23      : 1'b0;     
  assign isolate_urt23        = (scan_mode23 == 1'b0) ?  isolate_urt_int23       : 1'b0;      
  assign pwr1_on_urt23        = (scan_mode23 == 1'b0) ?  pwr1_on_urt_int23       : 1'b1;       
  assign pwr2_on_urt23        = (scan_mode23 == 1'b0) ?  pwr2_on_urt_int23       : 1'b1;       
  assign pwr1_off_urt23       = (scan_mode23 == 1'b0) ?  (!pwr1_on_urt_int23)  : 1'b0;       
  assign pwr2_off_urt23       = (scan_mode23 == 1'b0) ?  (!pwr2_on_urt_int23)  : 1'b0;       
  assign save_edge_urt23       = (scan_mode23 == 1'b0) ? (save_edge_urt_int23) : 1'b0;       
  assign restore_edge_urt23       = (scan_mode23 == 1'b0) ? (restore_edge_urt_int23) : 1'b0;       

  //ETH023
  assign rstn_non_srpg_macb023 = (scan_mode23 == 1'b0) ?  rstn_non_srpg_macb0_int23 : 1'b1;  
  assign gate_clk_macb023       = (scan_mode23 == 1'b0) ?  gate_clk_macb0_int23      : 1'b0;     
  assign isolate_macb023        = (scan_mode23 == 1'b0) ?  isolate_macb0_int23       : 1'b0;      
  assign pwr1_on_macb023        = (scan_mode23 == 1'b0) ?  pwr1_on_macb0_int23       : 1'b1;       
  assign pwr2_on_macb023        = (scan_mode23 == 1'b0) ?  pwr2_on_macb0_int23       : 1'b1;       
  assign pwr1_off_macb023       = (scan_mode23 == 1'b0) ?  (!pwr1_on_macb0_int23)  : 1'b0;       
  assign pwr2_off_macb023       = (scan_mode23 == 1'b0) ?  (!pwr2_on_macb0_int23)  : 1'b0;       
  assign save_edge_macb023       = (scan_mode23 == 1'b0) ? (save_edge_macb0_int23) : 1'b0;       
  assign restore_edge_macb023       = (scan_mode23 == 1'b0) ? (restore_edge_macb0_int23) : 1'b0;       

  //ETH123
  assign rstn_non_srpg_macb123 = (scan_mode23 == 1'b0) ?  rstn_non_srpg_macb1_int23 : 1'b1;  
  assign gate_clk_macb123       = (scan_mode23 == 1'b0) ?  gate_clk_macb1_int23      : 1'b0;     
  assign isolate_macb123        = (scan_mode23 == 1'b0) ?  isolate_macb1_int23       : 1'b0;      
  assign pwr1_on_macb123        = (scan_mode23 == 1'b0) ?  pwr1_on_macb1_int23       : 1'b1;       
  assign pwr2_on_macb123        = (scan_mode23 == 1'b0) ?  pwr2_on_macb1_int23       : 1'b1;       
  assign pwr1_off_macb123       = (scan_mode23 == 1'b0) ?  (!pwr1_on_macb1_int23)  : 1'b0;       
  assign pwr2_off_macb123       = (scan_mode23 == 1'b0) ?  (!pwr2_on_macb1_int23)  : 1'b0;       
  assign save_edge_macb123       = (scan_mode23 == 1'b0) ? (save_edge_macb1_int23) : 1'b0;       
  assign restore_edge_macb123       = (scan_mode23 == 1'b0) ? (restore_edge_macb1_int23) : 1'b0;       

  //ETH223
  assign rstn_non_srpg_macb223 = (scan_mode23 == 1'b0) ?  rstn_non_srpg_macb2_int23 : 1'b1;  
  assign gate_clk_macb223       = (scan_mode23 == 1'b0) ?  gate_clk_macb2_int23      : 1'b0;     
  assign isolate_macb223        = (scan_mode23 == 1'b0) ?  isolate_macb2_int23       : 1'b0;      
  assign pwr1_on_macb223        = (scan_mode23 == 1'b0) ?  pwr1_on_macb2_int23       : 1'b1;       
  assign pwr2_on_macb223        = (scan_mode23 == 1'b0) ?  pwr2_on_macb2_int23       : 1'b1;       
  assign pwr1_off_macb223       = (scan_mode23 == 1'b0) ?  (!pwr1_on_macb2_int23)  : 1'b0;       
  assign pwr2_off_macb223       = (scan_mode23 == 1'b0) ?  (!pwr2_on_macb2_int23)  : 1'b0;       
  assign save_edge_macb223       = (scan_mode23 == 1'b0) ? (save_edge_macb2_int23) : 1'b0;       
  assign restore_edge_macb223       = (scan_mode23 == 1'b0) ? (restore_edge_macb2_int23) : 1'b0;       

  //ETH323
  assign rstn_non_srpg_macb323 = (scan_mode23 == 1'b0) ?  rstn_non_srpg_macb3_int23 : 1'b1;  
  assign gate_clk_macb323       = (scan_mode23 == 1'b0) ?  gate_clk_macb3_int23      : 1'b0;     
  assign isolate_macb323        = (scan_mode23 == 1'b0) ?  isolate_macb3_int23       : 1'b0;      
  assign pwr1_on_macb323        = (scan_mode23 == 1'b0) ?  pwr1_on_macb3_int23       : 1'b1;       
  assign pwr2_on_macb323        = (scan_mode23 == 1'b0) ?  pwr2_on_macb3_int23       : 1'b1;       
  assign pwr1_off_macb323       = (scan_mode23 == 1'b0) ?  (!pwr1_on_macb3_int23)  : 1'b0;       
  assign pwr2_off_macb323       = (scan_mode23 == 1'b0) ?  (!pwr2_on_macb3_int23)  : 1'b0;       
  assign save_edge_macb323       = (scan_mode23 == 1'b0) ? (save_edge_macb3_int23) : 1'b0;       
  assign restore_edge_macb323       = (scan_mode23 == 1'b0) ? (restore_edge_macb3_int23) : 1'b0;       

  // MEM23
  assign rstn_non_srpg_mem23 =   (rstn_non_srpg_macb023 && rstn_non_srpg_macb123 && rstn_non_srpg_macb223 &&
                                rstn_non_srpg_macb323 && rstn_non_srpg_dma23 && rstn_non_srpg_cpu23 && rstn_non_srpg_urt23 &&
                                rstn_non_srpg_smc23);

  assign gate_clk_mem23 =  (gate_clk_macb023 && gate_clk_macb123 && gate_clk_macb223 &&
                            gate_clk_macb323 && gate_clk_dma23 && gate_clk_cpu23 && gate_clk_urt23 && gate_clk_smc23);

  assign isolate_mem23  = (isolate_macb023 && isolate_macb123 && isolate_macb223 &&
                         isolate_macb323 && isolate_dma23 && isolate_cpu23 && isolate_urt23 && isolate_smc23);


  assign pwr1_on_mem23        =   ~pwr1_off_mem23;

  assign pwr2_on_mem23        =   ~pwr2_off_mem23;

  assign pwr1_off_mem23       =  (pwr1_off_macb023 && pwr1_off_macb123 && pwr1_off_macb223 &&
                                 pwr1_off_macb323 && pwr1_off_dma23 && pwr1_off_cpu23 && pwr1_off_urt23 && pwr1_off_smc23);


  assign pwr2_off_mem23       =  (pwr2_off_macb023 && pwr2_off_macb123 && pwr2_off_macb223 &&
                                pwr2_off_macb323 && pwr2_off_dma23 && pwr2_off_cpu23 && pwr2_off_urt23 && pwr2_off_smc23);

  assign save_edge_mem23      =  (save_edge_macb023 && save_edge_macb123 && save_edge_macb223 &&
                                save_edge_macb323 && save_edge_dma23 && save_edge_cpu23 && save_edge_smc23 && save_edge_urt23);

  assign restore_edge_mem23   =  (restore_edge_macb023 && restore_edge_macb123 && restore_edge_macb223  &&
                                restore_edge_macb323 && restore_edge_dma23 && restore_edge_cpu23 && restore_edge_urt23 &&
                                restore_edge_smc23);

  assign standby_mem023 = pwr1_off_macb023 && (~ (pwr1_off_macb023 && pwr1_off_macb123 && pwr1_off_macb223 && pwr1_off_macb323 && pwr1_off_urt23 && pwr1_off_smc23 && pwr1_off_dma23 && pwr1_off_cpu23));
  assign standby_mem123 = pwr1_off_macb123 && (~ (pwr1_off_macb023 && pwr1_off_macb123 && pwr1_off_macb223 && pwr1_off_macb323 && pwr1_off_urt23 && pwr1_off_smc23 && pwr1_off_dma23 && pwr1_off_cpu23));
  assign standby_mem223 = pwr1_off_macb223 && (~ (pwr1_off_macb023 && pwr1_off_macb123 && pwr1_off_macb223 && pwr1_off_macb323 && pwr1_off_urt23 && pwr1_off_smc23 && pwr1_off_dma23 && pwr1_off_cpu23));
  assign standby_mem323 = pwr1_off_macb323 && (~ (pwr1_off_macb023 && pwr1_off_macb123 && pwr1_off_macb223 && pwr1_off_macb323 && pwr1_off_urt23 && pwr1_off_smc23 && pwr1_off_dma23 && pwr1_off_cpu23));

  assign pwr1_off_mem023 = pwr1_off_mem23;
  assign pwr1_off_mem123 = pwr1_off_mem23;
  assign pwr1_off_mem223 = pwr1_off_mem23;
  assign pwr1_off_mem323 = pwr1_off_mem23;

  assign rstn_non_srpg_alut23  =  (rstn_non_srpg_macb023 && rstn_non_srpg_macb123 && rstn_non_srpg_macb223 && rstn_non_srpg_macb323);


   assign gate_clk_alut23       =  (gate_clk_macb023 && gate_clk_macb123 && gate_clk_macb223 && gate_clk_macb323);


    assign isolate_alut23        =  (isolate_macb023 && isolate_macb123 && isolate_macb223 && isolate_macb323);


    assign pwr1_on_alut23        =  (pwr1_on_macb023 || pwr1_on_macb123 || pwr1_on_macb223 || pwr1_on_macb323);


    assign pwr2_on_alut23        =  (pwr2_on_macb023 || pwr2_on_macb123 || pwr2_on_macb223 || pwr2_on_macb323);


    assign pwr1_off_alut23       =  (pwr1_off_macb023 && pwr1_off_macb123 && pwr1_off_macb223 && pwr1_off_macb323);


    assign pwr2_off_alut23       =  (pwr2_off_macb023 && pwr2_off_macb123 && pwr2_off_macb223 && pwr2_off_macb323);


    assign save_edge_alut23      =  (save_edge_macb023 && save_edge_macb123 && save_edge_macb223 && save_edge_macb323);


    assign restore_edge_alut23   =  (restore_edge_macb023 || restore_edge_macb123 || restore_edge_macb223 ||
                                   restore_edge_macb323) && save_alut_tmp23;

     // alut23 power23 off23 detection23
  always @(posedge pclk23 or negedge nprst23) begin
    if (!nprst23) 
       save_alut_tmp23 <= 0;
    else if (restore_edge_alut23)
       save_alut_tmp23 <= 0;
    else if (save_edge_alut23)
       save_alut_tmp23 <= 1;
  end

  //DMA23
  assign rstn_non_srpg_dma23 = (scan_mode23 == 1'b0) ?  rstn_non_srpg_dma_int23 : 1'b1;  
  assign gate_clk_dma23       = (scan_mode23 == 1'b0) ?  gate_clk_dma_int23      : 1'b0;     
  assign isolate_dma23        = (scan_mode23 == 1'b0) ?  isolate_dma_int23       : 1'b0;      
  assign pwr1_on_dma23        = (scan_mode23 == 1'b0) ?  pwr1_on_dma_int23       : 1'b1;       
  assign pwr2_on_dma23        = (scan_mode23 == 1'b0) ?  pwr2_on_dma_int23       : 1'b1;       
  assign pwr1_off_dma23       = (scan_mode23 == 1'b0) ?  (!pwr1_on_dma_int23)  : 1'b0;       
  assign pwr2_off_dma23       = (scan_mode23 == 1'b0) ?  (!pwr2_on_dma_int23)  : 1'b0;       
  assign save_edge_dma23       = (scan_mode23 == 1'b0) ? (save_edge_dma_int23) : 1'b0;       
  assign restore_edge_dma23       = (scan_mode23 == 1'b0) ? (restore_edge_dma_int23) : 1'b0;       

  //CPU23
  assign rstn_non_srpg_cpu23 = (scan_mode23 == 1'b0) ?  rstn_non_srpg_cpu_int23 : 1'b1;  
  assign gate_clk_cpu23       = (scan_mode23 == 1'b0) ?  gate_clk_cpu_int23      : 1'b0;     
  assign isolate_cpu23        = (scan_mode23 == 1'b0) ?  isolate_cpu_int23       : 1'b0;      
  assign pwr1_on_cpu23        = (scan_mode23 == 1'b0) ?  pwr1_on_cpu_int23       : 1'b1;       
  assign pwr2_on_cpu23        = (scan_mode23 == 1'b0) ?  pwr2_on_cpu_int23       : 1'b1;       
  assign pwr1_off_cpu23       = (scan_mode23 == 1'b0) ?  (!pwr1_on_cpu_int23)  : 1'b0;       
  assign pwr2_off_cpu23       = (scan_mode23 == 1'b0) ?  (!pwr2_on_cpu_int23)  : 1'b0;       
  assign save_edge_cpu23       = (scan_mode23 == 1'b0) ? (save_edge_cpu_int23) : 1'b0;       
  assign restore_edge_cpu23       = (scan_mode23 == 1'b0) ? (restore_edge_cpu_int23) : 1'b0;       



  // ASE23

   reg ase_core_12v23, ase_core_10v23, ase_core_08v23, ase_core_06v23;
   reg ase_macb0_12v23,ase_macb1_12v23,ase_macb2_12v23,ase_macb3_12v23;

    // core23 ase23

    // core23 at 1.0 v if (smc23 off23, urt23 off23, macb023 off23, macb123 off23, macb223 off23, macb323 off23
   // core23 at 0.8v if (mac01off23, macb02off23, macb03off23, macb12off23, mac13off23, mac23off23,
   // core23 at 0.6v if (mac012off23, mac013off23, mac023off23, mac123off23, mac0123off23
    // else core23 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb023 && pwr1_off_macb123 && pwr1_off_macb223 && pwr1_off_macb323) || // all mac23 off23
       (pwr1_off_macb323 && pwr1_off_macb223 && pwr1_off_macb123) || // mac123off23 
       (pwr1_off_macb323 && pwr1_off_macb223 && pwr1_off_macb023) || // mac023off23 
       (pwr1_off_macb323 && pwr1_off_macb123 && pwr1_off_macb023) || // mac013off23 
       (pwr1_off_macb223 && pwr1_off_macb123 && pwr1_off_macb023) )  // mac012off23 
       begin
         ase_core_12v23 = 0;
         ase_core_10v23 = 0;
         ase_core_08v23 = 0;
         ase_core_06v23 = 1;
       end
     else if( (pwr1_off_macb223 && pwr1_off_macb323) || // mac2323 off23
         (pwr1_off_macb323 && pwr1_off_macb123) || // mac13off23 
         (pwr1_off_macb123 && pwr1_off_macb223) || // mac12off23 
         (pwr1_off_macb323 && pwr1_off_macb023) || // mac03off23 
         (pwr1_off_macb223 && pwr1_off_macb023) || // mac02off23 
         (pwr1_off_macb123 && pwr1_off_macb023))  // mac01off23 
       begin
         ase_core_12v23 = 0;
         ase_core_10v23 = 0;
         ase_core_08v23 = 1;
         ase_core_06v23 = 0;
       end
     else if( (pwr1_off_smc23) || // smc23 off23
         (pwr1_off_macb023 ) || // mac0off23 
         (pwr1_off_macb123 ) || // mac1off23 
         (pwr1_off_macb223 ) || // mac2off23 
         (pwr1_off_macb323 ))  // mac3off23 
       begin
         ase_core_12v23 = 0;
         ase_core_10v23 = 1;
         ase_core_08v23 = 0;
         ase_core_06v23 = 0;
       end
     else if (pwr1_off_urt23)
       begin
         ase_core_12v23 = 1;
         ase_core_10v23 = 0;
         ase_core_08v23 = 0;
         ase_core_06v23 = 0;
       end
     else
       begin
         ase_core_12v23 = 1;
         ase_core_10v23 = 0;
         ase_core_08v23 = 0;
         ase_core_06v23 = 0;
       end
   end


   // cpu23
   // cpu23 @ 1.0v when macoff23, 
   // 
   reg ase_cpu_10v23, ase_cpu_12v23;
   always @(*) begin
    if(pwr1_off_cpu23) begin
     ase_cpu_12v23 = 1'b0;
     ase_cpu_10v23 = 1'b0;
    end
    else if(pwr1_off_macb023 || pwr1_off_macb123 || pwr1_off_macb223 || pwr1_off_macb323)
    begin
     ase_cpu_12v23 = 1'b0;
     ase_cpu_10v23 = 1'b1;
    end
    else
    begin
     ase_cpu_12v23 = 1'b1;
     ase_cpu_10v23 = 1'b0;
    end
   end

   // dma23
   // dma23 @v123.0 for macoff23, 

   reg ase_dma_10v23, ase_dma_12v23;
   always @(*) begin
    if(pwr1_off_dma23) begin
     ase_dma_12v23 = 1'b0;
     ase_dma_10v23 = 1'b0;
    end
    else if(pwr1_off_macb023 || pwr1_off_macb123 || pwr1_off_macb223 || pwr1_off_macb323)
    begin
     ase_dma_12v23 = 1'b0;
     ase_dma_10v23 = 1'b1;
    end
    else
    begin
     ase_dma_12v23 = 1'b1;
     ase_dma_10v23 = 1'b0;
    end
   end

   // alut23
   // @ v123.0 for macoff23

   reg ase_alut_10v23, ase_alut_12v23;
   always @(*) begin
    if(pwr1_off_alut23) begin
     ase_alut_12v23 = 1'b0;
     ase_alut_10v23 = 1'b0;
    end
    else if(pwr1_off_macb023 || pwr1_off_macb123 || pwr1_off_macb223 || pwr1_off_macb323)
    begin
     ase_alut_12v23 = 1'b0;
     ase_alut_10v23 = 1'b1;
    end
    else
    begin
     ase_alut_12v23 = 1'b1;
     ase_alut_10v23 = 1'b0;
    end
   end




   reg ase_uart_12v23;
   reg ase_uart_10v23;
   reg ase_uart_08v23;
   reg ase_uart_06v23;

   reg ase_smc_12v23;


   always @(*) begin
     if(pwr1_off_urt23) begin // uart23 off23
       ase_uart_08v23 = 1'b0;
       ase_uart_06v23 = 1'b0;
       ase_uart_10v23 = 1'b0;
       ase_uart_12v23 = 1'b0;
     end 
     else if( (pwr1_off_macb023 && pwr1_off_macb123 && pwr1_off_macb223 && pwr1_off_macb323) || // all mac23 off23
       (pwr1_off_macb323 && pwr1_off_macb223 && pwr1_off_macb123) || // mac123off23 
       (pwr1_off_macb323 && pwr1_off_macb223 && pwr1_off_macb023) || // mac023off23 
       (pwr1_off_macb323 && pwr1_off_macb123 && pwr1_off_macb023) || // mac013off23 
       (pwr1_off_macb223 && pwr1_off_macb123 && pwr1_off_macb023) )  // mac012off23 
     begin
       ase_uart_06v23 = 1'b1;
       ase_uart_08v23 = 1'b0;
       ase_uart_10v23 = 1'b0;
       ase_uart_12v23 = 1'b0;
     end
     else if( (pwr1_off_macb223 && pwr1_off_macb323) || // mac2323 off23
         (pwr1_off_macb323 && pwr1_off_macb123) || // mac13off23 
         (pwr1_off_macb123 && pwr1_off_macb223) || // mac12off23 
         (pwr1_off_macb323 && pwr1_off_macb023) || // mac03off23 
         (pwr1_off_macb123 && pwr1_off_macb023))  // mac01off23  
     begin
       ase_uart_06v23 = 1'b0;
       ase_uart_08v23 = 1'b1;
       ase_uart_10v23 = 1'b0;
       ase_uart_12v23 = 1'b0;
     end
     else if (pwr1_off_smc23 || pwr1_off_macb023 || pwr1_off_macb123 || pwr1_off_macb223 || pwr1_off_macb323) begin // smc23 off23
       ase_uart_08v23 = 1'b0;
       ase_uart_06v23 = 1'b0;
       ase_uart_10v23 = 1'b1;
       ase_uart_12v23 = 1'b0;
     end 
     else begin
       ase_uart_08v23 = 1'b0;
       ase_uart_06v23 = 1'b0;
       ase_uart_10v23 = 1'b0;
       ase_uart_12v23 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc23) begin
     if (pwr1_off_smc23)  // smc23 off23
       ase_smc_12v23 = 1'b0;
    else
       ase_smc_12v23 = 1'b1;
   end

   
   always @(pwr1_off_macb023) begin
     if (pwr1_off_macb023) // macb023 off23
       ase_macb0_12v23 = 1'b0;
     else
       ase_macb0_12v23 = 1'b1;
   end

   always @(pwr1_off_macb123) begin
     if (pwr1_off_macb123) // macb123 off23
       ase_macb1_12v23 = 1'b0;
     else
       ase_macb1_12v23 = 1'b1;
   end

   always @(pwr1_off_macb223) begin // macb223 off23
     if (pwr1_off_macb223) // macb223 off23
       ase_macb2_12v23 = 1'b0;
     else
       ase_macb2_12v23 = 1'b1;
   end

   always @(pwr1_off_macb323) begin // macb323 off23
     if (pwr1_off_macb323) // macb323 off23
       ase_macb3_12v23 = 1'b0;
     else
       ase_macb3_12v23 = 1'b1;
   end


   // core23 voltage23 for vco23
  assign core12v23 = ase_macb0_12v23 & ase_macb1_12v23 & ase_macb2_12v23 & ase_macb3_12v23;

  assign core10v23 =  (ase_macb0_12v23 & ase_macb1_12v23 & ase_macb2_12v23 & (!ase_macb3_12v23)) ||
                    (ase_macb0_12v23 & ase_macb1_12v23 & (!ase_macb2_12v23) & ase_macb3_12v23) ||
                    (ase_macb0_12v23 & (!ase_macb1_12v23) & ase_macb2_12v23 & ase_macb3_12v23) ||
                    ((!ase_macb0_12v23) & ase_macb1_12v23 & ase_macb2_12v23 & ase_macb3_12v23);

  assign core08v23 =  ((!ase_macb0_12v23) & (!ase_macb1_12v23) & (ase_macb2_12v23) & (ase_macb3_12v23)) ||
                    ((!ase_macb0_12v23) & (ase_macb1_12v23) & (!ase_macb2_12v23) & (ase_macb3_12v23)) ||
                    ((!ase_macb0_12v23) & (ase_macb1_12v23) & (ase_macb2_12v23) & (!ase_macb3_12v23)) ||
                    ((ase_macb0_12v23) & (!ase_macb1_12v23) & (!ase_macb2_12v23) & (ase_macb3_12v23)) ||
                    ((ase_macb0_12v23) & (!ase_macb1_12v23) & (ase_macb2_12v23) & (!ase_macb3_12v23)) ||
                    ((ase_macb0_12v23) & (ase_macb1_12v23) & (!ase_macb2_12v23) & (!ase_macb3_12v23));

  assign core06v23 =  ((!ase_macb0_12v23) & (!ase_macb1_12v23) & (!ase_macb2_12v23) & (ase_macb3_12v23)) ||
                    ((!ase_macb0_12v23) & (!ase_macb1_12v23) & (ase_macb2_12v23) & (!ase_macb3_12v23)) ||
                    ((!ase_macb0_12v23) & (ase_macb1_12v23) & (!ase_macb2_12v23) & (!ase_macb3_12v23)) ||
                    ((ase_macb0_12v23) & (!ase_macb1_12v23) & (!ase_macb2_12v23) & (!ase_macb3_12v23)) ||
                    ((!ase_macb0_12v23) & (!ase_macb1_12v23) & (!ase_macb2_12v23) & (!ase_macb3_12v23)) ;



`ifdef LP_ABV_ON23
// psl23 default clock23 = (posedge pclk23);

// Cover23 a condition in which SMC23 is powered23 down
// and again23 powered23 up while UART23 is going23 into POWER23 down
// state or UART23 is already in POWER23 DOWN23 state
// psl23 cover_overlapping_smc_urt_123:
//    cover{fell23(pwr1_on_urt23);[*];fell23(pwr1_on_smc23);[*];
//    rose23(pwr1_on_smc23);[*];rose23(pwr1_on_urt23)};
//
// Cover23 a condition in which UART23 is powered23 down
// and again23 powered23 up while SMC23 is going23 into POWER23 down
// state or SMC23 is already in POWER23 DOWN23 state
// psl23 cover_overlapping_smc_urt_223:
//    cover{fell23(pwr1_on_smc23);[*];fell23(pwr1_on_urt23);[*];
//    rose23(pwr1_on_urt23);[*];rose23(pwr1_on_smc23)};
//


// Power23 Down23 UART23
// This23 gets23 triggered on rising23 edge of Gate23 signal23 for
// UART23 (gate_clk_urt23). In a next cycle after gate_clk_urt23,
// Isolate23 UART23(isolate_urt23) signal23 become23 HIGH23 (active).
// In 2nd cycle after gate_clk_urt23 becomes HIGH23, RESET23 for NON23
// SRPG23 FFs23(rstn_non_srpg_urt23) and POWER123 for UART23(pwr1_on_urt23) should 
// go23 LOW23. 
// This23 completes23 a POWER23 DOWN23. 

sequence s_power_down_urt23;
      (gate_clk_urt23 & !isolate_urt23 & rstn_non_srpg_urt23 & pwr1_on_urt23) 
  ##1 (gate_clk_urt23 & isolate_urt23 & rstn_non_srpg_urt23 & pwr1_on_urt23) 
  ##3 (gate_clk_urt23 & isolate_urt23 & !rstn_non_srpg_urt23 & !pwr1_on_urt23);
endsequence


property p_power_down_urt23;
   @(posedge pclk23)
    $rose(gate_clk_urt23) |=> s_power_down_urt23;
endproperty

output_power_down_urt23:
  assert property (p_power_down_urt23);


// Power23 UP23 UART23
// Sequence starts with , Rising23 edge of pwr1_on_urt23.
// Two23 clock23 cycle after this, isolate_urt23 should become23 LOW23 
// On23 the following23 clk23 gate_clk_urt23 should go23 low23.
// 5 cycles23 after  Rising23 edge of pwr1_on_urt23, rstn_non_srpg_urt23
// should become23 HIGH23
sequence s_power_up_urt23;
##30 (pwr1_on_urt23 & !isolate_urt23 & gate_clk_urt23 & !rstn_non_srpg_urt23) 
##1 (pwr1_on_urt23 & !isolate_urt23 & !gate_clk_urt23 & !rstn_non_srpg_urt23) 
##2 (pwr1_on_urt23 & !isolate_urt23 & !gate_clk_urt23 & rstn_non_srpg_urt23);
endsequence

property p_power_up_urt23;
   @(posedge pclk23)
  disable iff(!nprst23)
    (!pwr1_on_urt23 ##1 pwr1_on_urt23) |=> s_power_up_urt23;
endproperty

output_power_up_urt23:
  assert property (p_power_up_urt23);


// Power23 Down23 SMC23
// This23 gets23 triggered on rising23 edge of Gate23 signal23 for
// SMC23 (gate_clk_smc23). In a next cycle after gate_clk_smc23,
// Isolate23 SMC23(isolate_smc23) signal23 become23 HIGH23 (active).
// In 2nd cycle after gate_clk_smc23 becomes HIGH23, RESET23 for NON23
// SRPG23 FFs23(rstn_non_srpg_smc23) and POWER123 for SMC23(pwr1_on_smc23) should 
// go23 LOW23. 
// This23 completes23 a POWER23 DOWN23. 

sequence s_power_down_smc23;
      (gate_clk_smc23 & !isolate_smc23 & rstn_non_srpg_smc23 & pwr1_on_smc23) 
  ##1 (gate_clk_smc23 & isolate_smc23 & rstn_non_srpg_smc23 & pwr1_on_smc23) 
  ##3 (gate_clk_smc23 & isolate_smc23 & !rstn_non_srpg_smc23 & !pwr1_on_smc23);
endsequence


property p_power_down_smc23;
   @(posedge pclk23)
    $rose(gate_clk_smc23) |=> s_power_down_smc23;
endproperty

output_power_down_smc23:
  assert property (p_power_down_smc23);


// Power23 UP23 SMC23
// Sequence starts with , Rising23 edge of pwr1_on_smc23.
// Two23 clock23 cycle after this, isolate_smc23 should become23 LOW23 
// On23 the following23 clk23 gate_clk_smc23 should go23 low23.
// 5 cycles23 after  Rising23 edge of pwr1_on_smc23, rstn_non_srpg_smc23
// should become23 HIGH23
sequence s_power_up_smc23;
##30 (pwr1_on_smc23 & !isolate_smc23 & gate_clk_smc23 & !rstn_non_srpg_smc23) 
##1 (pwr1_on_smc23 & !isolate_smc23 & !gate_clk_smc23 & !rstn_non_srpg_smc23) 
##2 (pwr1_on_smc23 & !isolate_smc23 & !gate_clk_smc23 & rstn_non_srpg_smc23);
endsequence

property p_power_up_smc23;
   @(posedge pclk23)
  disable iff(!nprst23)
    (!pwr1_on_smc23 ##1 pwr1_on_smc23) |=> s_power_up_smc23;
endproperty

output_power_up_smc23:
  assert property (p_power_up_smc23);


// COVER23 SMC23 POWER23 DOWN23 AND23 UP23
cover_power_down_up_smc23: cover property (@(posedge pclk23)
(s_power_down_smc23 ##[5:180] s_power_up_smc23));



// COVER23 UART23 POWER23 DOWN23 AND23 UP23
cover_power_down_up_urt23: cover property (@(posedge pclk23)
(s_power_down_urt23 ##[5:180] s_power_up_urt23));

cover_power_down_urt23: cover property (@(posedge pclk23)
(s_power_down_urt23));

cover_power_up_urt23: cover property (@(posedge pclk23)
(s_power_up_urt23));




`ifdef PCM_ABV_ON23
//------------------------------------------------------------------------------
// Power23 Controller23 Formal23 Verification23 component.  Each power23 domain has a 
// separate23 instantiation23
//------------------------------------------------------------------------------

// need to assume that CPU23 will leave23 a minimum time between powering23 down and 
// back up.  In this example23, 10clks has been selected.
// psl23 config_min_uart_pd_time23 : assume always {rose23(L1_ctrl_domain23[1])} |-> { L1_ctrl_domain23[1][*10] } abort23(~nprst23);
// psl23 config_min_uart_pu_time23 : assume always {fell23(L1_ctrl_domain23[1])} |-> { !L1_ctrl_domain23[1][*10] } abort23(~nprst23);
// psl23 config_min_smc_pd_time23 : assume always {rose23(L1_ctrl_domain23[2])} |-> { L1_ctrl_domain23[2][*10] } abort23(~nprst23);
// psl23 config_min_smc_pu_time23 : assume always {fell23(L1_ctrl_domain23[2])} |-> { !L1_ctrl_domain23[2][*10] } abort23(~nprst23);

// UART23 VCOMP23 parameters23
   defparam i_uart_vcomp_domain23.ENABLE_SAVE_RESTORE_EDGE23   = 1;
   defparam i_uart_vcomp_domain23.ENABLE_EXT_PWR_CNTRL23       = 1;
   defparam i_uart_vcomp_domain23.REF_CLK_DEFINED23            = 0;
   defparam i_uart_vcomp_domain23.MIN_SHUTOFF_CYCLES23         = 4;
   defparam i_uart_vcomp_domain23.MIN_RESTORE_TO_ISO_CYCLES23  = 0;
   defparam i_uart_vcomp_domain23.MIN_SAVE_TO_SHUTOFF_CYCLES23 = 1;


   vcomp_domain23 i_uart_vcomp_domain23
   ( .ref_clk23(pclk23),
     .start_lps23(L1_ctrl_domain23[1] || !rstn_non_srpg_urt23),
     .rst_n23(nprst23),
     .ext_power_down23(L1_ctrl_domain23[1]),
     .iso_en23(isolate_urt23),
     .save_edge23(save_edge_urt23),
     .restore_edge23(restore_edge_urt23),
     .domain_shut_off23(pwr1_off_urt23),
     .domain_clk23(!gate_clk_urt23 && pclk23)
   );


// SMC23 VCOMP23 parameters23
   defparam i_smc_vcomp_domain23.ENABLE_SAVE_RESTORE_EDGE23   = 1;
   defparam i_smc_vcomp_domain23.ENABLE_EXT_PWR_CNTRL23       = 1;
   defparam i_smc_vcomp_domain23.REF_CLK_DEFINED23            = 0;
   defparam i_smc_vcomp_domain23.MIN_SHUTOFF_CYCLES23         = 4;
   defparam i_smc_vcomp_domain23.MIN_RESTORE_TO_ISO_CYCLES23  = 0;
   defparam i_smc_vcomp_domain23.MIN_SAVE_TO_SHUTOFF_CYCLES23 = 1;


   vcomp_domain23 i_smc_vcomp_domain23
   ( .ref_clk23(pclk23),
     .start_lps23(L1_ctrl_domain23[2] || !rstn_non_srpg_smc23),
     .rst_n23(nprst23),
     .ext_power_down23(L1_ctrl_domain23[2]),
     .iso_en23(isolate_smc23),
     .save_edge23(save_edge_smc23),
     .restore_edge23(restore_edge_smc23),
     .domain_shut_off23(pwr1_off_smc23),
     .domain_clk23(!gate_clk_smc23 && pclk23)
   );

`endif

`endif



endmodule
