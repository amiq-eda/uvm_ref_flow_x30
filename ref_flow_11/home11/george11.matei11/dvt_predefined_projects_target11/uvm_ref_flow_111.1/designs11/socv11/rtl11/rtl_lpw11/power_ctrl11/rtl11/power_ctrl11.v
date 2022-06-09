//File11 name   : power_ctrl11.v
//Title11       : Power11 Control11 Module11
//Created11     : 1999
//Description11 : Top11 level of power11 controller11
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

module power_ctrl11 (


    // Clocks11 & Reset11
    pclk11,
    nprst11,
    // APB11 programming11 interface
    paddr11,
    psel11,
    penable11,
    pwrite11,
    pwdata11,
    prdata11,
    // mac11 i/f,
    macb3_wakeup11,
    macb2_wakeup11,
    macb1_wakeup11,
    macb0_wakeup11,
    // Scan11 
    scan_in11,
    scan_en11,
    scan_mode11,
    scan_out11,
    // Module11 control11 outputs11
    int_source_h11,
    // SMC11
    rstn_non_srpg_smc11,
    gate_clk_smc11,
    isolate_smc11,
    save_edge_smc11,
    restore_edge_smc11,
    pwr1_on_smc11,
    pwr2_on_smc11,
    pwr1_off_smc11,
    pwr2_off_smc11,
    // URT11
    rstn_non_srpg_urt11,
    gate_clk_urt11,
    isolate_urt11,
    save_edge_urt11,
    restore_edge_urt11,
    pwr1_on_urt11,
    pwr2_on_urt11,
    pwr1_off_urt11,      
    pwr2_off_urt11,
    // ETH011
    rstn_non_srpg_macb011,
    gate_clk_macb011,
    isolate_macb011,
    save_edge_macb011,
    restore_edge_macb011,
    pwr1_on_macb011,
    pwr2_on_macb011,
    pwr1_off_macb011,      
    pwr2_off_macb011,
    // ETH111
    rstn_non_srpg_macb111,
    gate_clk_macb111,
    isolate_macb111,
    save_edge_macb111,
    restore_edge_macb111,
    pwr1_on_macb111,
    pwr2_on_macb111,
    pwr1_off_macb111,      
    pwr2_off_macb111,
    // ETH211
    rstn_non_srpg_macb211,
    gate_clk_macb211,
    isolate_macb211,
    save_edge_macb211,
    restore_edge_macb211,
    pwr1_on_macb211,
    pwr2_on_macb211,
    pwr1_off_macb211,      
    pwr2_off_macb211,
    // ETH311
    rstn_non_srpg_macb311,
    gate_clk_macb311,
    isolate_macb311,
    save_edge_macb311,
    restore_edge_macb311,
    pwr1_on_macb311,
    pwr2_on_macb311,
    pwr1_off_macb311,      
    pwr2_off_macb311,
    // DMA11
    rstn_non_srpg_dma11,
    gate_clk_dma11,
    isolate_dma11,
    save_edge_dma11,
    restore_edge_dma11,
    pwr1_on_dma11,
    pwr2_on_dma11,
    pwr1_off_dma11,      
    pwr2_off_dma11,
    // CPU11
    rstn_non_srpg_cpu11,
    gate_clk_cpu11,
    isolate_cpu11,
    save_edge_cpu11,
    restore_edge_cpu11,
    pwr1_on_cpu11,
    pwr2_on_cpu11,
    pwr1_off_cpu11,      
    pwr2_off_cpu11,
    // ALUT11
    rstn_non_srpg_alut11,
    gate_clk_alut11,
    isolate_alut11,
    save_edge_alut11,
    restore_edge_alut11,
    pwr1_on_alut11,
    pwr2_on_alut11,
    pwr1_off_alut11,      
    pwr2_off_alut11,
    // MEM11
    rstn_non_srpg_mem11,
    gate_clk_mem11,
    isolate_mem11,
    save_edge_mem11,
    restore_edge_mem11,
    pwr1_on_mem11,
    pwr2_on_mem11,
    pwr1_off_mem11,      
    pwr2_off_mem11,
    // core11 dvfs11 transitions11
    core06v11,
    core08v11,
    core10v11,
    core12v11,
    pcm_macb_wakeup_int11,
    // mte11 signals11
    mte_smc_start11,
    mte_uart_start11,
    mte_smc_uart_start11,  
    mte_pm_smc_to_default_start11, 
    mte_pm_uart_to_default_start11,
    mte_pm_smc_uart_to_default_start11

  );

  parameter STATE_IDLE_12V11 = 4'b0001;
  parameter STATE_06V11 = 4'b0010;
  parameter STATE_08V11 = 4'b0100;
  parameter STATE_10V11 = 4'b1000;

    // Clocks11 & Reset11
    input pclk11;
    input nprst11;
    // APB11 programming11 interface
    input [31:0] paddr11;
    input psel11  ;
    input penable11;
    input pwrite11 ;
    input [31:0] pwdata11;
    output [31:0] prdata11;
    // mac11
    input macb3_wakeup11;
    input macb2_wakeup11;
    input macb1_wakeup11;
    input macb0_wakeup11;
    // Scan11 
    input scan_in11;
    input scan_en11;
    input scan_mode11;
    output scan_out11;
    // Module11 control11 outputs11
    input int_source_h11;
    // SMC11
    output rstn_non_srpg_smc11 ;
    output gate_clk_smc11   ;
    output isolate_smc11   ;
    output save_edge_smc11   ;
    output restore_edge_smc11   ;
    output pwr1_on_smc11   ;
    output pwr2_on_smc11   ;
    output pwr1_off_smc11  ;
    output pwr2_off_smc11  ;
    // URT11
    output rstn_non_srpg_urt11 ;
    output gate_clk_urt11      ;
    output isolate_urt11       ;
    output save_edge_urt11   ;
    output restore_edge_urt11   ;
    output pwr1_on_urt11       ;
    output pwr2_on_urt11       ;
    output pwr1_off_urt11      ;
    output pwr2_off_urt11      ;
    // ETH011
    output rstn_non_srpg_macb011 ;
    output gate_clk_macb011      ;
    output isolate_macb011       ;
    output save_edge_macb011   ;
    output restore_edge_macb011   ;
    output pwr1_on_macb011       ;
    output pwr2_on_macb011       ;
    output pwr1_off_macb011      ;
    output pwr2_off_macb011      ;
    // ETH111
    output rstn_non_srpg_macb111 ;
    output gate_clk_macb111      ;
    output isolate_macb111       ;
    output save_edge_macb111   ;
    output restore_edge_macb111   ;
    output pwr1_on_macb111       ;
    output pwr2_on_macb111       ;
    output pwr1_off_macb111      ;
    output pwr2_off_macb111      ;
    // ETH211
    output rstn_non_srpg_macb211 ;
    output gate_clk_macb211      ;
    output isolate_macb211       ;
    output save_edge_macb211   ;
    output restore_edge_macb211   ;
    output pwr1_on_macb211       ;
    output pwr2_on_macb211       ;
    output pwr1_off_macb211      ;
    output pwr2_off_macb211      ;
    // ETH311
    output rstn_non_srpg_macb311 ;
    output gate_clk_macb311      ;
    output isolate_macb311       ;
    output save_edge_macb311   ;
    output restore_edge_macb311   ;
    output pwr1_on_macb311       ;
    output pwr2_on_macb311       ;
    output pwr1_off_macb311      ;
    output pwr2_off_macb311      ;
    // DMA11
    output rstn_non_srpg_dma11 ;
    output gate_clk_dma11      ;
    output isolate_dma11       ;
    output save_edge_dma11   ;
    output restore_edge_dma11   ;
    output pwr1_on_dma11       ;
    output pwr2_on_dma11       ;
    output pwr1_off_dma11      ;
    output pwr2_off_dma11      ;
    // CPU11
    output rstn_non_srpg_cpu11 ;
    output gate_clk_cpu11      ;
    output isolate_cpu11       ;
    output save_edge_cpu11   ;
    output restore_edge_cpu11   ;
    output pwr1_on_cpu11       ;
    output pwr2_on_cpu11       ;
    output pwr1_off_cpu11      ;
    output pwr2_off_cpu11      ;
    // ALUT11
    output rstn_non_srpg_alut11 ;
    output gate_clk_alut11      ;
    output isolate_alut11       ;
    output save_edge_alut11   ;
    output restore_edge_alut11   ;
    output pwr1_on_alut11       ;
    output pwr2_on_alut11       ;
    output pwr1_off_alut11      ;
    output pwr2_off_alut11      ;
    // MEM11
    output rstn_non_srpg_mem11 ;
    output gate_clk_mem11      ;
    output isolate_mem11       ;
    output save_edge_mem11   ;
    output restore_edge_mem11   ;
    output pwr1_on_mem11       ;
    output pwr2_on_mem11       ;
    output pwr1_off_mem11      ;
    output pwr2_off_mem11      ;


   // core11 transitions11 o/p
    output core06v11;
    output core08v11;
    output core10v11;
    output core12v11;
    output pcm_macb_wakeup_int11 ;
    //mode mte11  signals11
    output mte_smc_start11;
    output mte_uart_start11;
    output mte_smc_uart_start11;  
    output mte_pm_smc_to_default_start11; 
    output mte_pm_uart_to_default_start11;
    output mte_pm_smc_uart_to_default_start11;

    reg mte_smc_start11;
    reg mte_uart_start11;
    reg mte_smc_uart_start11;  
    reg mte_pm_smc_to_default_start11; 
    reg mte_pm_uart_to_default_start11;
    reg mte_pm_smc_uart_to_default_start11;

    reg [31:0] prdata11;

  wire valid_reg_write11  ;
  wire valid_reg_read11   ;
  wire L1_ctrl_access11   ;
  wire L1_status_access11 ;
  wire pcm_int_mask_access11;
  wire pcm_int_status_access11;
  wire standby_mem011      ;
  wire standby_mem111      ;
  wire standby_mem211      ;
  wire standby_mem311      ;
  wire pwr1_off_mem011;
  wire pwr1_off_mem111;
  wire pwr1_off_mem211;
  wire pwr1_off_mem311;
  
  // Control11 signals11
  wire set_status_smc11   ;
  wire clr_status_smc11   ;
  wire set_status_urt11   ;
  wire clr_status_urt11   ;
  wire set_status_macb011   ;
  wire clr_status_macb011   ;
  wire set_status_macb111   ;
  wire clr_status_macb111   ;
  wire set_status_macb211   ;
  wire clr_status_macb211   ;
  wire set_status_macb311   ;
  wire clr_status_macb311   ;
  wire set_status_dma11   ;
  wire clr_status_dma11   ;
  wire set_status_cpu11   ;
  wire clr_status_cpu11   ;
  wire set_status_alut11   ;
  wire clr_status_alut11   ;
  wire set_status_mem11   ;
  wire clr_status_mem11   ;


  // Status and Control11 registers
  reg [31:0]  L1_status_reg11;
  reg  [31:0] L1_ctrl_reg11  ;
  reg  [31:0] L1_ctrl_domain11  ;
  reg L1_ctrl_cpu_off_reg11;
  reg [31:0]  pcm_mask_reg11;
  reg [31:0]  pcm_status_reg11;

  // Signals11 gated11 in scan_mode11
  //SMC11
  wire  rstn_non_srpg_smc_int11;
  wire  gate_clk_smc_int11    ;     
  wire  isolate_smc_int11    ;       
  wire save_edge_smc_int11;
  wire restore_edge_smc_int11;
  wire  pwr1_on_smc_int11    ;      
  wire  pwr2_on_smc_int11    ;      


  //URT11
  wire   rstn_non_srpg_urt_int11;
  wire   gate_clk_urt_int11     ;     
  wire   isolate_urt_int11      ;       
  wire save_edge_urt_int11;
  wire restore_edge_urt_int11;
  wire   pwr1_on_urt_int11      ;      
  wire   pwr2_on_urt_int11      ;      

  // ETH011
  wire   rstn_non_srpg_macb0_int11;
  wire   gate_clk_macb0_int11     ;     
  wire   isolate_macb0_int11      ;       
  wire save_edge_macb0_int11;
  wire restore_edge_macb0_int11;
  wire   pwr1_on_macb0_int11      ;      
  wire   pwr2_on_macb0_int11      ;      
  // ETH111
  wire   rstn_non_srpg_macb1_int11;
  wire   gate_clk_macb1_int11     ;     
  wire   isolate_macb1_int11      ;       
  wire save_edge_macb1_int11;
  wire restore_edge_macb1_int11;
  wire   pwr1_on_macb1_int11      ;      
  wire   pwr2_on_macb1_int11      ;      
  // ETH211
  wire   rstn_non_srpg_macb2_int11;
  wire   gate_clk_macb2_int11     ;     
  wire   isolate_macb2_int11      ;       
  wire save_edge_macb2_int11;
  wire restore_edge_macb2_int11;
  wire   pwr1_on_macb2_int11      ;      
  wire   pwr2_on_macb2_int11      ;      
  // ETH311
  wire   rstn_non_srpg_macb3_int11;
  wire   gate_clk_macb3_int11     ;     
  wire   isolate_macb3_int11      ;       
  wire save_edge_macb3_int11;
  wire restore_edge_macb3_int11;
  wire   pwr1_on_macb3_int11      ;      
  wire   pwr2_on_macb3_int11      ;      

  // DMA11
  wire   rstn_non_srpg_dma_int11;
  wire   gate_clk_dma_int11     ;     
  wire   isolate_dma_int11      ;       
  wire save_edge_dma_int11;
  wire restore_edge_dma_int11;
  wire   pwr1_on_dma_int11      ;      
  wire   pwr2_on_dma_int11      ;      

  // CPU11
  wire   rstn_non_srpg_cpu_int11;
  wire   gate_clk_cpu_int11     ;     
  wire   isolate_cpu_int11      ;       
  wire save_edge_cpu_int11;
  wire restore_edge_cpu_int11;
  wire   pwr1_on_cpu_int11      ;      
  wire   pwr2_on_cpu_int11      ;  
  wire L1_ctrl_cpu_off_p11;    

  reg save_alut_tmp11;
  // DFS11 sm11

  reg cpu_shutoff_ctrl11;

  reg mte_mac_off_start11, mte_mac012_start11, mte_mac013_start11, mte_mac023_start11, mte_mac123_start11;
  reg mte_mac01_start11, mte_mac02_start11, mte_mac03_start11, mte_mac12_start11, mte_mac13_start11, mte_mac23_start11;
  reg mte_mac0_start11, mte_mac1_start11, mte_mac2_start11, mte_mac3_start11;
  reg mte_sys_hibernate11 ;
  reg mte_dma_start11 ;
  reg mte_cpu_start11 ;
  reg mte_mac_off_sleep_start11, mte_mac012_sleep_start11, mte_mac013_sleep_start11, mte_mac023_sleep_start11, mte_mac123_sleep_start11;
  reg mte_mac01_sleep_start11, mte_mac02_sleep_start11, mte_mac03_sleep_start11, mte_mac12_sleep_start11, mte_mac13_sleep_start11, mte_mac23_sleep_start11;
  reg mte_mac0_sleep_start11, mte_mac1_sleep_start11, mte_mac2_sleep_start11, mte_mac3_sleep_start11;
  reg mte_dma_sleep_start11;
  reg mte_mac_off_to_default11, mte_mac012_to_default11, mte_mac013_to_default11, mte_mac023_to_default11, mte_mac123_to_default11;
  reg mte_mac01_to_default11, mte_mac02_to_default11, mte_mac03_to_default11, mte_mac12_to_default11, mte_mac13_to_default11, mte_mac23_to_default11;
  reg mte_mac0_to_default11, mte_mac1_to_default11, mte_mac2_to_default11, mte_mac3_to_default11;
  reg mte_dma_isolate_dis11;
  reg mte_cpu_isolate_dis11;
  reg mte_sys_hibernate_to_default11;


  // Latch11 the CPU11 SLEEP11 invocation11
  always @( posedge pclk11 or negedge nprst11) 
  begin
    if(!nprst11)
      L1_ctrl_cpu_off_reg11 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg11 <= L1_ctrl_domain11[8];
  end

  // Create11 a pulse11 for sleep11 detection11 
  assign L1_ctrl_cpu_off_p11 =  L1_ctrl_domain11[8] && !L1_ctrl_cpu_off_reg11;
  
  // CPU11 sleep11 contol11 logic 
  // Shut11 off11 CPU11 when L1_ctrl_cpu_off_p11 is set
  // wake11 cpu11 when any interrupt11 is seen11  
  always @( posedge pclk11 or negedge nprst11) 
  begin
    if(!nprst11)
     cpu_shutoff_ctrl11 <= 1'b0;
    else if(cpu_shutoff_ctrl11 && int_source_h11)
     cpu_shutoff_ctrl11 <= 1'b0;
    else if (L1_ctrl_cpu_off_p11)
     cpu_shutoff_ctrl11 <= 1'b1;
  end
 
  // instantiate11 power11 contol11  block for uart11
  power_ctrl_sm11 i_urt_power_ctrl_sm11(
    .pclk11(pclk11),
    .nprst11(nprst11),
    .L1_module_req11(L1_ctrl_domain11[1]),
    .set_status_module11(set_status_urt11),
    .clr_status_module11(clr_status_urt11),
    .rstn_non_srpg_module11(rstn_non_srpg_urt_int11),
    .gate_clk_module11(gate_clk_urt_int11),
    .isolate_module11(isolate_urt_int11),
    .save_edge11(save_edge_urt_int11),
    .restore_edge11(restore_edge_urt_int11),
    .pwr1_on11(pwr1_on_urt_int11),
    .pwr2_on11(pwr2_on_urt_int11)
    );
  

  // instantiate11 power11 contol11  block for smc11
  power_ctrl_sm11 i_smc_power_ctrl_sm11(
    .pclk11(pclk11),
    .nprst11(nprst11),
    .L1_module_req11(L1_ctrl_domain11[2]),
    .set_status_module11(set_status_smc11),
    .clr_status_module11(clr_status_smc11),
    .rstn_non_srpg_module11(rstn_non_srpg_smc_int11),
    .gate_clk_module11(gate_clk_smc_int11),
    .isolate_module11(isolate_smc_int11),
    .save_edge11(save_edge_smc_int11),
    .restore_edge11(restore_edge_smc_int11),
    .pwr1_on11(pwr1_on_smc_int11),
    .pwr2_on11(pwr2_on_smc_int11)
    );

  // power11 control11 for macb011
  power_ctrl_sm11 i_macb0_power_ctrl_sm11(
    .pclk11(pclk11),
    .nprst11(nprst11),
    .L1_module_req11(L1_ctrl_domain11[3]),
    .set_status_module11(set_status_macb011),
    .clr_status_module11(clr_status_macb011),
    .rstn_non_srpg_module11(rstn_non_srpg_macb0_int11),
    .gate_clk_module11(gate_clk_macb0_int11),
    .isolate_module11(isolate_macb0_int11),
    .save_edge11(save_edge_macb0_int11),
    .restore_edge11(restore_edge_macb0_int11),
    .pwr1_on11(pwr1_on_macb0_int11),
    .pwr2_on11(pwr2_on_macb0_int11)
    );
  // power11 control11 for macb111
  power_ctrl_sm11 i_macb1_power_ctrl_sm11(
    .pclk11(pclk11),
    .nprst11(nprst11),
    .L1_module_req11(L1_ctrl_domain11[4]),
    .set_status_module11(set_status_macb111),
    .clr_status_module11(clr_status_macb111),
    .rstn_non_srpg_module11(rstn_non_srpg_macb1_int11),
    .gate_clk_module11(gate_clk_macb1_int11),
    .isolate_module11(isolate_macb1_int11),
    .save_edge11(save_edge_macb1_int11),
    .restore_edge11(restore_edge_macb1_int11),
    .pwr1_on11(pwr1_on_macb1_int11),
    .pwr2_on11(pwr2_on_macb1_int11)
    );
  // power11 control11 for macb211
  power_ctrl_sm11 i_macb2_power_ctrl_sm11(
    .pclk11(pclk11),
    .nprst11(nprst11),
    .L1_module_req11(L1_ctrl_domain11[5]),
    .set_status_module11(set_status_macb211),
    .clr_status_module11(clr_status_macb211),
    .rstn_non_srpg_module11(rstn_non_srpg_macb2_int11),
    .gate_clk_module11(gate_clk_macb2_int11),
    .isolate_module11(isolate_macb2_int11),
    .save_edge11(save_edge_macb2_int11),
    .restore_edge11(restore_edge_macb2_int11),
    .pwr1_on11(pwr1_on_macb2_int11),
    .pwr2_on11(pwr2_on_macb2_int11)
    );
  // power11 control11 for macb311
  power_ctrl_sm11 i_macb3_power_ctrl_sm11(
    .pclk11(pclk11),
    .nprst11(nprst11),
    .L1_module_req11(L1_ctrl_domain11[6]),
    .set_status_module11(set_status_macb311),
    .clr_status_module11(clr_status_macb311),
    .rstn_non_srpg_module11(rstn_non_srpg_macb3_int11),
    .gate_clk_module11(gate_clk_macb3_int11),
    .isolate_module11(isolate_macb3_int11),
    .save_edge11(save_edge_macb3_int11),
    .restore_edge11(restore_edge_macb3_int11),
    .pwr1_on11(pwr1_on_macb3_int11),
    .pwr2_on11(pwr2_on_macb3_int11)
    );
  // power11 control11 for dma11
  power_ctrl_sm11 i_dma_power_ctrl_sm11(
    .pclk11(pclk11),
    .nprst11(nprst11),
    .L1_module_req11(L1_ctrl_domain11[7]),
    .set_status_module11(set_status_dma11),
    .clr_status_module11(clr_status_dma11),
    .rstn_non_srpg_module11(rstn_non_srpg_dma_int11),
    .gate_clk_module11(gate_clk_dma_int11),
    .isolate_module11(isolate_dma_int11),
    .save_edge11(save_edge_dma_int11),
    .restore_edge11(restore_edge_dma_int11),
    .pwr1_on11(pwr1_on_dma_int11),
    .pwr2_on11(pwr2_on_dma_int11)
    );
  // power11 control11 for CPU11
  power_ctrl_sm11 i_cpu_power_ctrl_sm11(
    .pclk11(pclk11),
    .nprst11(nprst11),
    .L1_module_req11(cpu_shutoff_ctrl11),
    .set_status_module11(set_status_cpu11),
    .clr_status_module11(clr_status_cpu11),
    .rstn_non_srpg_module11(rstn_non_srpg_cpu_int11),
    .gate_clk_module11(gate_clk_cpu_int11),
    .isolate_module11(isolate_cpu_int11),
    .save_edge11(save_edge_cpu_int11),
    .restore_edge11(restore_edge_cpu_int11),
    .pwr1_on11(pwr1_on_cpu_int11),
    .pwr2_on11(pwr2_on_cpu_int11)
    );

  assign valid_reg_write11 =  (psel11 && pwrite11 && penable11);
  assign valid_reg_read11  =  (psel11 && (!pwrite11) && penable11);

  assign L1_ctrl_access11  =  (paddr11[15:0] == 16'b0000000000000100); 
  assign L1_status_access11 = (paddr11[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access11 =   (paddr11[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access11 = (paddr11[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control11 and status register
  always @(*)
  begin  
    if(valid_reg_read11 && L1_ctrl_access11) 
      prdata11 = L1_ctrl_reg11;
    else if (valid_reg_read11 && L1_status_access11)
      prdata11 = L1_status_reg11;
    else if (valid_reg_read11 && pcm_int_mask_access11)
      prdata11 = pcm_mask_reg11;
    else if (valid_reg_read11 && pcm_int_status_access11)
      prdata11 = pcm_status_reg11;
    else 
      prdata11 = 0;
  end

  assign set_status_mem11 =  (set_status_macb011 && set_status_macb111 && set_status_macb211 &&
                            set_status_macb311 && set_status_dma11 && set_status_cpu11);

  assign clr_status_mem11 =  (clr_status_macb011 && clr_status_macb111 && clr_status_macb211 &&
                            clr_status_macb311 && clr_status_dma11 && clr_status_cpu11);

  assign set_status_alut11 = (set_status_macb011 && set_status_macb111 && set_status_macb211 && set_status_macb311);

  assign clr_status_alut11 = (clr_status_macb011 || clr_status_macb111 || clr_status_macb211  || clr_status_macb311);

  // Write accesses to the control11 and status register
 
  always @(posedge pclk11 or negedge nprst11)
  begin
    if (!nprst11) begin
      L1_ctrl_reg11   <= 0;
      L1_status_reg11 <= 0;
      pcm_mask_reg11 <= 0;
    end else begin
      // CTRL11 reg updates11
      if (valid_reg_write11 && L1_ctrl_access11) 
        L1_ctrl_reg11 <= pwdata11; // Writes11 to the ctrl11 reg
      if (valid_reg_write11 && pcm_int_mask_access11) 
        pcm_mask_reg11 <= pwdata11; // Writes11 to the ctrl11 reg

      if (set_status_urt11 == 1'b1)  
        L1_status_reg11[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt11 == 1'b1) 
        L1_status_reg11[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc11 == 1'b1) 
        L1_status_reg11[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc11 == 1'b1) 
        L1_status_reg11[2] <= 1'b0; // Clear the status bit

      if (set_status_macb011 == 1'b1)  
        L1_status_reg11[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb011 == 1'b1) 
        L1_status_reg11[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb111 == 1'b1)  
        L1_status_reg11[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb111 == 1'b1) 
        L1_status_reg11[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb211 == 1'b1)  
        L1_status_reg11[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb211 == 1'b1) 
        L1_status_reg11[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb311 == 1'b1)  
        L1_status_reg11[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb311 == 1'b1) 
        L1_status_reg11[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma11 == 1'b1)  
        L1_status_reg11[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma11 == 1'b1) 
        L1_status_reg11[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu11 == 1'b1)  
        L1_status_reg11[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu11 == 1'b1) 
        L1_status_reg11[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut11 == 1'b1)  
        L1_status_reg11[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut11 == 1'b1) 
        L1_status_reg11[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem11 == 1'b1)  
        L1_status_reg11[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem11 == 1'b1) 
        L1_status_reg11[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused11 bits of pcm_status_reg11 are tied11 to 0
  always @(posedge pclk11 or negedge nprst11)
  begin
    if (!nprst11)
      pcm_status_reg11[31:4] <= 'b0;
    else  
      pcm_status_reg11[31:4] <= pcm_status_reg11[31:4];
  end
  
  // interrupt11 only of h/w assisted11 wakeup
  // MAC11 3
  always @(posedge pclk11 or negedge nprst11)
  begin
    if(!nprst11)
      pcm_status_reg11[3] <= 1'b0;
    else if (valid_reg_write11 && pcm_int_status_access11) 
      pcm_status_reg11[3] <= pwdata11[3];
    else if (macb3_wakeup11 & ~pcm_mask_reg11[3])
      pcm_status_reg11[3] <= 1'b1;
    else if (valid_reg_read11 && pcm_int_status_access11) 
      pcm_status_reg11[3] <= 1'b0;
    else
      pcm_status_reg11[3] <= pcm_status_reg11[3];
  end  
   
  // MAC11 2
  always @(posedge pclk11 or negedge nprst11)
  begin
    if(!nprst11)
      pcm_status_reg11[2] <= 1'b0;
    else if (valid_reg_write11 && pcm_int_status_access11) 
      pcm_status_reg11[2] <= pwdata11[2];
    else if (macb2_wakeup11 & ~pcm_mask_reg11[2])
      pcm_status_reg11[2] <= 1'b1;
    else if (valid_reg_read11 && pcm_int_status_access11) 
      pcm_status_reg11[2] <= 1'b0;
    else
      pcm_status_reg11[2] <= pcm_status_reg11[2];
  end  

  // MAC11 1
  always @(posedge pclk11 or negedge nprst11)
  begin
    if(!nprst11)
      pcm_status_reg11[1] <= 1'b0;
    else if (valid_reg_write11 && pcm_int_status_access11) 
      pcm_status_reg11[1] <= pwdata11[1];
    else if (macb1_wakeup11 & ~pcm_mask_reg11[1])
      pcm_status_reg11[1] <= 1'b1;
    else if (valid_reg_read11 && pcm_int_status_access11) 
      pcm_status_reg11[1] <= 1'b0;
    else
      pcm_status_reg11[1] <= pcm_status_reg11[1];
  end  
   
  // MAC11 0
  always @(posedge pclk11 or negedge nprst11)
  begin
    if(!nprst11)
      pcm_status_reg11[0] <= 1'b0;
    else if (valid_reg_write11 && pcm_int_status_access11) 
      pcm_status_reg11[0] <= pwdata11[0];
    else if (macb0_wakeup11 & ~pcm_mask_reg11[0])
      pcm_status_reg11[0] <= 1'b1;
    else if (valid_reg_read11 && pcm_int_status_access11) 
      pcm_status_reg11[0] <= 1'b0;
    else
      pcm_status_reg11[0] <= pcm_status_reg11[0];
  end  

  assign pcm_macb_wakeup_int11 = |pcm_status_reg11;

  reg [31:0] L1_ctrl_reg111;
  always @(posedge pclk11 or negedge nprst11)
  begin
    if(!nprst11)
      L1_ctrl_reg111 <= 0;
    else
      L1_ctrl_reg111 <= L1_ctrl_reg11;
  end

  // Program11 mode decode
  always @(L1_ctrl_reg11 or L1_ctrl_reg111 or int_source_h11 or cpu_shutoff_ctrl11) begin
    mte_smc_start11 = 0;
    mte_uart_start11 = 0;
    mte_smc_uart_start11  = 0;
    mte_mac_off_start11  = 0;
    mte_mac012_start11 = 0;
    mte_mac013_start11 = 0;
    mte_mac023_start11 = 0;
    mte_mac123_start11 = 0;
    mte_mac01_start11 = 0;
    mte_mac02_start11 = 0;
    mte_mac03_start11 = 0;
    mte_mac12_start11 = 0;
    mte_mac13_start11 = 0;
    mte_mac23_start11 = 0;
    mte_mac0_start11 = 0;
    mte_mac1_start11 = 0;
    mte_mac2_start11 = 0;
    mte_mac3_start11 = 0;
    mte_sys_hibernate11 = 0 ;
    mte_dma_start11 = 0 ;
    mte_cpu_start11 = 0 ;

    mte_mac0_sleep_start11 = (L1_ctrl_reg11 ==  'h14) && (L1_ctrl_reg111 == 'h4 );
    mte_mac1_sleep_start11 = (L1_ctrl_reg11 ==  'h14) && (L1_ctrl_reg111 == 'h5 ); 
    mte_mac2_sleep_start11 = (L1_ctrl_reg11 ==  'h14) && (L1_ctrl_reg111 == 'h6 ); 
    mte_mac3_sleep_start11 = (L1_ctrl_reg11 ==  'h14) && (L1_ctrl_reg111 == 'h7 ); 
    mte_mac01_sleep_start11 = (L1_ctrl_reg11 ==  'h14) && (L1_ctrl_reg111 == 'h8 ); 
    mte_mac02_sleep_start11 = (L1_ctrl_reg11 ==  'h14) && (L1_ctrl_reg111 == 'h9 ); 
    mte_mac03_sleep_start11 = (L1_ctrl_reg11 ==  'h14) && (L1_ctrl_reg111 == 'hA ); 
    mte_mac12_sleep_start11 = (L1_ctrl_reg11 ==  'h14) && (L1_ctrl_reg111 == 'hB ); 
    mte_mac13_sleep_start11 = (L1_ctrl_reg11 ==  'h14) && (L1_ctrl_reg111 == 'hC ); 
    mte_mac23_sleep_start11 = (L1_ctrl_reg11 ==  'h14) && (L1_ctrl_reg111 == 'hD ); 
    mte_mac012_sleep_start11 = (L1_ctrl_reg11 ==  'h14) && (L1_ctrl_reg111 == 'hE ); 
    mte_mac013_sleep_start11 = (L1_ctrl_reg11 ==  'h14) && (L1_ctrl_reg111 == 'hF ); 
    mte_mac023_sleep_start11 = (L1_ctrl_reg11 ==  'h14) && (L1_ctrl_reg111 == 'h10 ); 
    mte_mac123_sleep_start11 = (L1_ctrl_reg11 ==  'h14) && (L1_ctrl_reg111 == 'h11 ); 
    mte_mac_off_sleep_start11 =  (L1_ctrl_reg11 == 'h14) && (L1_ctrl_reg111 == 'h12 );
    mte_dma_sleep_start11 =  (L1_ctrl_reg11 == 'h14) && (L1_ctrl_reg111 == 'h13 );

    mte_pm_uart_to_default_start11 = (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'h1);
    mte_pm_smc_to_default_start11 = (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'h2);
    mte_pm_smc_uart_to_default_start11 = (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'h3); 
    mte_mac0_to_default11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'h4); 
    mte_mac1_to_default11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'h5); 
    mte_mac2_to_default11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'h6); 
    mte_mac3_to_default11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'h7); 
    mte_mac01_to_default11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'h8); 
    mte_mac02_to_default11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'h9); 
    mte_mac03_to_default11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'hA); 
    mte_mac12_to_default11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'hB); 
    mte_mac13_to_default11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'hC); 
    mte_mac23_to_default11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'hD); 
    mte_mac012_to_default11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'hE); 
    mte_mac013_to_default11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'hF); 
    mte_mac023_to_default11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'h10); 
    mte_mac123_to_default11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'h11); 
    mte_mac_off_to_default11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'h12); 
    mte_dma_isolate_dis11 =  (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'h13); 
    mte_cpu_isolate_dis11 =  (int_source_h11) && (cpu_shutoff_ctrl11) && (L1_ctrl_reg11 != 'h15);
    mte_sys_hibernate_to_default11 = (L1_ctrl_reg11 == 32'h0) && (L1_ctrl_reg111 == 'h15); 

   
    if (L1_ctrl_reg111 == 'h0) begin // This11 check is to make mte_cpu_start11
                                   // is set only when you from default state 
      case (L1_ctrl_reg11)
        'h0 : L1_ctrl_domain11 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain11 = 32'h2; // PM_uart11
                mte_uart_start11 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain11 = 32'h4; // PM_smc11
                mte_smc_start11 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain11 = 32'h6; // PM_smc_uart11
                mte_smc_uart_start11 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain11 = 32'h8; //  PM_macb011
                mte_mac0_start11 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain11 = 32'h10; //  PM_macb111
                mte_mac1_start11 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain11 = 32'h20; //  PM_macb211
                mte_mac2_start11 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain11 = 32'h40; //  PM_macb311
                mte_mac3_start11 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain11 = 32'h18; //  PM_macb0111
                mte_mac01_start11 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain11 = 32'h28; //  PM_macb0211
                mte_mac02_start11 = 1;
              end
        'hA : begin  
                L1_ctrl_domain11 = 32'h48; //  PM_macb0311
                mte_mac03_start11 = 1;
              end
        'hB : begin  
                L1_ctrl_domain11 = 32'h30; //  PM_macb1211
                mte_mac12_start11 = 1;
              end
        'hC : begin  
                L1_ctrl_domain11 = 32'h50; //  PM_macb1311
                mte_mac13_start11 = 1;
              end
        'hD : begin  
                L1_ctrl_domain11 = 32'h60; //  PM_macb2311
                mte_mac23_start11 = 1;
              end
        'hE : begin  
                L1_ctrl_domain11 = 32'h38; //  PM_macb01211
                mte_mac012_start11 = 1;
              end
        'hF : begin  
                L1_ctrl_domain11 = 32'h58; //  PM_macb01311
                mte_mac013_start11 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain11 = 32'h68; //  PM_macb02311
                mte_mac023_start11 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain11 = 32'h70; //  PM_macb12311
                mte_mac123_start11 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain11 = 32'h78; //  PM_macb_off11
                mte_mac_off_start11 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain11 = 32'h80; //  PM_dma11
                mte_dma_start11 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain11 = 32'h100; //  PM_cpu_sleep11
                mte_cpu_start11 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain11 = 32'h1FE; //  PM_hibernate11
                mte_sys_hibernate11 = 1;
              end
         default: L1_ctrl_domain11 = 32'h0;
      endcase
    end
  end


  wire to_default11 = (L1_ctrl_reg11 == 0);

  // Scan11 mode gating11 of power11 and isolation11 control11 signals11
  //SMC11
  assign rstn_non_srpg_smc11  = (scan_mode11 == 1'b0) ? rstn_non_srpg_smc_int11 : 1'b1;  
  assign gate_clk_smc11       = (scan_mode11 == 1'b0) ? gate_clk_smc_int11 : 1'b0;     
  assign isolate_smc11        = (scan_mode11 == 1'b0) ? isolate_smc_int11 : 1'b0;      
  assign pwr1_on_smc11        = (scan_mode11 == 1'b0) ? pwr1_on_smc_int11 : 1'b1;       
  assign pwr2_on_smc11        = (scan_mode11 == 1'b0) ? pwr2_on_smc_int11 : 1'b1;       
  assign pwr1_off_smc11       = (scan_mode11 == 1'b0) ? (!pwr1_on_smc_int11) : 1'b0;       
  assign pwr2_off_smc11       = (scan_mode11 == 1'b0) ? (!pwr2_on_smc_int11) : 1'b0;       
  assign save_edge_smc11       = (scan_mode11 == 1'b0) ? (save_edge_smc_int11) : 1'b0;       
  assign restore_edge_smc11       = (scan_mode11 == 1'b0) ? (restore_edge_smc_int11) : 1'b0;       

  //URT11
  assign rstn_non_srpg_urt11  = (scan_mode11 == 1'b0) ?  rstn_non_srpg_urt_int11 : 1'b1;  
  assign gate_clk_urt11       = (scan_mode11 == 1'b0) ?  gate_clk_urt_int11      : 1'b0;     
  assign isolate_urt11        = (scan_mode11 == 1'b0) ?  isolate_urt_int11       : 1'b0;      
  assign pwr1_on_urt11        = (scan_mode11 == 1'b0) ?  pwr1_on_urt_int11       : 1'b1;       
  assign pwr2_on_urt11        = (scan_mode11 == 1'b0) ?  pwr2_on_urt_int11       : 1'b1;       
  assign pwr1_off_urt11       = (scan_mode11 == 1'b0) ?  (!pwr1_on_urt_int11)  : 1'b0;       
  assign pwr2_off_urt11       = (scan_mode11 == 1'b0) ?  (!pwr2_on_urt_int11)  : 1'b0;       
  assign save_edge_urt11       = (scan_mode11 == 1'b0) ? (save_edge_urt_int11) : 1'b0;       
  assign restore_edge_urt11       = (scan_mode11 == 1'b0) ? (restore_edge_urt_int11) : 1'b0;       

  //ETH011
  assign rstn_non_srpg_macb011 = (scan_mode11 == 1'b0) ?  rstn_non_srpg_macb0_int11 : 1'b1;  
  assign gate_clk_macb011       = (scan_mode11 == 1'b0) ?  gate_clk_macb0_int11      : 1'b0;     
  assign isolate_macb011        = (scan_mode11 == 1'b0) ?  isolate_macb0_int11       : 1'b0;      
  assign pwr1_on_macb011        = (scan_mode11 == 1'b0) ?  pwr1_on_macb0_int11       : 1'b1;       
  assign pwr2_on_macb011        = (scan_mode11 == 1'b0) ?  pwr2_on_macb0_int11       : 1'b1;       
  assign pwr1_off_macb011       = (scan_mode11 == 1'b0) ?  (!pwr1_on_macb0_int11)  : 1'b0;       
  assign pwr2_off_macb011       = (scan_mode11 == 1'b0) ?  (!pwr2_on_macb0_int11)  : 1'b0;       
  assign save_edge_macb011       = (scan_mode11 == 1'b0) ? (save_edge_macb0_int11) : 1'b0;       
  assign restore_edge_macb011       = (scan_mode11 == 1'b0) ? (restore_edge_macb0_int11) : 1'b0;       

  //ETH111
  assign rstn_non_srpg_macb111 = (scan_mode11 == 1'b0) ?  rstn_non_srpg_macb1_int11 : 1'b1;  
  assign gate_clk_macb111       = (scan_mode11 == 1'b0) ?  gate_clk_macb1_int11      : 1'b0;     
  assign isolate_macb111        = (scan_mode11 == 1'b0) ?  isolate_macb1_int11       : 1'b0;      
  assign pwr1_on_macb111        = (scan_mode11 == 1'b0) ?  pwr1_on_macb1_int11       : 1'b1;       
  assign pwr2_on_macb111        = (scan_mode11 == 1'b0) ?  pwr2_on_macb1_int11       : 1'b1;       
  assign pwr1_off_macb111       = (scan_mode11 == 1'b0) ?  (!pwr1_on_macb1_int11)  : 1'b0;       
  assign pwr2_off_macb111       = (scan_mode11 == 1'b0) ?  (!pwr2_on_macb1_int11)  : 1'b0;       
  assign save_edge_macb111       = (scan_mode11 == 1'b0) ? (save_edge_macb1_int11) : 1'b0;       
  assign restore_edge_macb111       = (scan_mode11 == 1'b0) ? (restore_edge_macb1_int11) : 1'b0;       

  //ETH211
  assign rstn_non_srpg_macb211 = (scan_mode11 == 1'b0) ?  rstn_non_srpg_macb2_int11 : 1'b1;  
  assign gate_clk_macb211       = (scan_mode11 == 1'b0) ?  gate_clk_macb2_int11      : 1'b0;     
  assign isolate_macb211        = (scan_mode11 == 1'b0) ?  isolate_macb2_int11       : 1'b0;      
  assign pwr1_on_macb211        = (scan_mode11 == 1'b0) ?  pwr1_on_macb2_int11       : 1'b1;       
  assign pwr2_on_macb211        = (scan_mode11 == 1'b0) ?  pwr2_on_macb2_int11       : 1'b1;       
  assign pwr1_off_macb211       = (scan_mode11 == 1'b0) ?  (!pwr1_on_macb2_int11)  : 1'b0;       
  assign pwr2_off_macb211       = (scan_mode11 == 1'b0) ?  (!pwr2_on_macb2_int11)  : 1'b0;       
  assign save_edge_macb211       = (scan_mode11 == 1'b0) ? (save_edge_macb2_int11) : 1'b0;       
  assign restore_edge_macb211       = (scan_mode11 == 1'b0) ? (restore_edge_macb2_int11) : 1'b0;       

  //ETH311
  assign rstn_non_srpg_macb311 = (scan_mode11 == 1'b0) ?  rstn_non_srpg_macb3_int11 : 1'b1;  
  assign gate_clk_macb311       = (scan_mode11 == 1'b0) ?  gate_clk_macb3_int11      : 1'b0;     
  assign isolate_macb311        = (scan_mode11 == 1'b0) ?  isolate_macb3_int11       : 1'b0;      
  assign pwr1_on_macb311        = (scan_mode11 == 1'b0) ?  pwr1_on_macb3_int11       : 1'b1;       
  assign pwr2_on_macb311        = (scan_mode11 == 1'b0) ?  pwr2_on_macb3_int11       : 1'b1;       
  assign pwr1_off_macb311       = (scan_mode11 == 1'b0) ?  (!pwr1_on_macb3_int11)  : 1'b0;       
  assign pwr2_off_macb311       = (scan_mode11 == 1'b0) ?  (!pwr2_on_macb3_int11)  : 1'b0;       
  assign save_edge_macb311       = (scan_mode11 == 1'b0) ? (save_edge_macb3_int11) : 1'b0;       
  assign restore_edge_macb311       = (scan_mode11 == 1'b0) ? (restore_edge_macb3_int11) : 1'b0;       

  // MEM11
  assign rstn_non_srpg_mem11 =   (rstn_non_srpg_macb011 && rstn_non_srpg_macb111 && rstn_non_srpg_macb211 &&
                                rstn_non_srpg_macb311 && rstn_non_srpg_dma11 && rstn_non_srpg_cpu11 && rstn_non_srpg_urt11 &&
                                rstn_non_srpg_smc11);

  assign gate_clk_mem11 =  (gate_clk_macb011 && gate_clk_macb111 && gate_clk_macb211 &&
                            gate_clk_macb311 && gate_clk_dma11 && gate_clk_cpu11 && gate_clk_urt11 && gate_clk_smc11);

  assign isolate_mem11  = (isolate_macb011 && isolate_macb111 && isolate_macb211 &&
                         isolate_macb311 && isolate_dma11 && isolate_cpu11 && isolate_urt11 && isolate_smc11);


  assign pwr1_on_mem11        =   ~pwr1_off_mem11;

  assign pwr2_on_mem11        =   ~pwr2_off_mem11;

  assign pwr1_off_mem11       =  (pwr1_off_macb011 && pwr1_off_macb111 && pwr1_off_macb211 &&
                                 pwr1_off_macb311 && pwr1_off_dma11 && pwr1_off_cpu11 && pwr1_off_urt11 && pwr1_off_smc11);


  assign pwr2_off_mem11       =  (pwr2_off_macb011 && pwr2_off_macb111 && pwr2_off_macb211 &&
                                pwr2_off_macb311 && pwr2_off_dma11 && pwr2_off_cpu11 && pwr2_off_urt11 && pwr2_off_smc11);

  assign save_edge_mem11      =  (save_edge_macb011 && save_edge_macb111 && save_edge_macb211 &&
                                save_edge_macb311 && save_edge_dma11 && save_edge_cpu11 && save_edge_smc11 && save_edge_urt11);

  assign restore_edge_mem11   =  (restore_edge_macb011 && restore_edge_macb111 && restore_edge_macb211  &&
                                restore_edge_macb311 && restore_edge_dma11 && restore_edge_cpu11 && restore_edge_urt11 &&
                                restore_edge_smc11);

  assign standby_mem011 = pwr1_off_macb011 && (~ (pwr1_off_macb011 && pwr1_off_macb111 && pwr1_off_macb211 && pwr1_off_macb311 && pwr1_off_urt11 && pwr1_off_smc11 && pwr1_off_dma11 && pwr1_off_cpu11));
  assign standby_mem111 = pwr1_off_macb111 && (~ (pwr1_off_macb011 && pwr1_off_macb111 && pwr1_off_macb211 && pwr1_off_macb311 && pwr1_off_urt11 && pwr1_off_smc11 && pwr1_off_dma11 && pwr1_off_cpu11));
  assign standby_mem211 = pwr1_off_macb211 && (~ (pwr1_off_macb011 && pwr1_off_macb111 && pwr1_off_macb211 && pwr1_off_macb311 && pwr1_off_urt11 && pwr1_off_smc11 && pwr1_off_dma11 && pwr1_off_cpu11));
  assign standby_mem311 = pwr1_off_macb311 && (~ (pwr1_off_macb011 && pwr1_off_macb111 && pwr1_off_macb211 && pwr1_off_macb311 && pwr1_off_urt11 && pwr1_off_smc11 && pwr1_off_dma11 && pwr1_off_cpu11));

  assign pwr1_off_mem011 = pwr1_off_mem11;
  assign pwr1_off_mem111 = pwr1_off_mem11;
  assign pwr1_off_mem211 = pwr1_off_mem11;
  assign pwr1_off_mem311 = pwr1_off_mem11;

  assign rstn_non_srpg_alut11  =  (rstn_non_srpg_macb011 && rstn_non_srpg_macb111 && rstn_non_srpg_macb211 && rstn_non_srpg_macb311);


   assign gate_clk_alut11       =  (gate_clk_macb011 && gate_clk_macb111 && gate_clk_macb211 && gate_clk_macb311);


    assign isolate_alut11        =  (isolate_macb011 && isolate_macb111 && isolate_macb211 && isolate_macb311);


    assign pwr1_on_alut11        =  (pwr1_on_macb011 || pwr1_on_macb111 || pwr1_on_macb211 || pwr1_on_macb311);


    assign pwr2_on_alut11        =  (pwr2_on_macb011 || pwr2_on_macb111 || pwr2_on_macb211 || pwr2_on_macb311);


    assign pwr1_off_alut11       =  (pwr1_off_macb011 && pwr1_off_macb111 && pwr1_off_macb211 && pwr1_off_macb311);


    assign pwr2_off_alut11       =  (pwr2_off_macb011 && pwr2_off_macb111 && pwr2_off_macb211 && pwr2_off_macb311);


    assign save_edge_alut11      =  (save_edge_macb011 && save_edge_macb111 && save_edge_macb211 && save_edge_macb311);


    assign restore_edge_alut11   =  (restore_edge_macb011 || restore_edge_macb111 || restore_edge_macb211 ||
                                   restore_edge_macb311) && save_alut_tmp11;

     // alut11 power11 off11 detection11
  always @(posedge pclk11 or negedge nprst11) begin
    if (!nprst11) 
       save_alut_tmp11 <= 0;
    else if (restore_edge_alut11)
       save_alut_tmp11 <= 0;
    else if (save_edge_alut11)
       save_alut_tmp11 <= 1;
  end

  //DMA11
  assign rstn_non_srpg_dma11 = (scan_mode11 == 1'b0) ?  rstn_non_srpg_dma_int11 : 1'b1;  
  assign gate_clk_dma11       = (scan_mode11 == 1'b0) ?  gate_clk_dma_int11      : 1'b0;     
  assign isolate_dma11        = (scan_mode11 == 1'b0) ?  isolate_dma_int11       : 1'b0;      
  assign pwr1_on_dma11        = (scan_mode11 == 1'b0) ?  pwr1_on_dma_int11       : 1'b1;       
  assign pwr2_on_dma11        = (scan_mode11 == 1'b0) ?  pwr2_on_dma_int11       : 1'b1;       
  assign pwr1_off_dma11       = (scan_mode11 == 1'b0) ?  (!pwr1_on_dma_int11)  : 1'b0;       
  assign pwr2_off_dma11       = (scan_mode11 == 1'b0) ?  (!pwr2_on_dma_int11)  : 1'b0;       
  assign save_edge_dma11       = (scan_mode11 == 1'b0) ? (save_edge_dma_int11) : 1'b0;       
  assign restore_edge_dma11       = (scan_mode11 == 1'b0) ? (restore_edge_dma_int11) : 1'b0;       

  //CPU11
  assign rstn_non_srpg_cpu11 = (scan_mode11 == 1'b0) ?  rstn_non_srpg_cpu_int11 : 1'b1;  
  assign gate_clk_cpu11       = (scan_mode11 == 1'b0) ?  gate_clk_cpu_int11      : 1'b0;     
  assign isolate_cpu11        = (scan_mode11 == 1'b0) ?  isolate_cpu_int11       : 1'b0;      
  assign pwr1_on_cpu11        = (scan_mode11 == 1'b0) ?  pwr1_on_cpu_int11       : 1'b1;       
  assign pwr2_on_cpu11        = (scan_mode11 == 1'b0) ?  pwr2_on_cpu_int11       : 1'b1;       
  assign pwr1_off_cpu11       = (scan_mode11 == 1'b0) ?  (!pwr1_on_cpu_int11)  : 1'b0;       
  assign pwr2_off_cpu11       = (scan_mode11 == 1'b0) ?  (!pwr2_on_cpu_int11)  : 1'b0;       
  assign save_edge_cpu11       = (scan_mode11 == 1'b0) ? (save_edge_cpu_int11) : 1'b0;       
  assign restore_edge_cpu11       = (scan_mode11 == 1'b0) ? (restore_edge_cpu_int11) : 1'b0;       



  // ASE11

   reg ase_core_12v11, ase_core_10v11, ase_core_08v11, ase_core_06v11;
   reg ase_macb0_12v11,ase_macb1_12v11,ase_macb2_12v11,ase_macb3_12v11;

    // core11 ase11

    // core11 at 1.0 v if (smc11 off11, urt11 off11, macb011 off11, macb111 off11, macb211 off11, macb311 off11
   // core11 at 0.8v if (mac01off11, macb02off11, macb03off11, macb12off11, mac13off11, mac23off11,
   // core11 at 0.6v if (mac012off11, mac013off11, mac023off11, mac123off11, mac0123off11
    // else core11 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb011 && pwr1_off_macb111 && pwr1_off_macb211 && pwr1_off_macb311) || // all mac11 off11
       (pwr1_off_macb311 && pwr1_off_macb211 && pwr1_off_macb111) || // mac123off11 
       (pwr1_off_macb311 && pwr1_off_macb211 && pwr1_off_macb011) || // mac023off11 
       (pwr1_off_macb311 && pwr1_off_macb111 && pwr1_off_macb011) || // mac013off11 
       (pwr1_off_macb211 && pwr1_off_macb111 && pwr1_off_macb011) )  // mac012off11 
       begin
         ase_core_12v11 = 0;
         ase_core_10v11 = 0;
         ase_core_08v11 = 0;
         ase_core_06v11 = 1;
       end
     else if( (pwr1_off_macb211 && pwr1_off_macb311) || // mac2311 off11
         (pwr1_off_macb311 && pwr1_off_macb111) || // mac13off11 
         (pwr1_off_macb111 && pwr1_off_macb211) || // mac12off11 
         (pwr1_off_macb311 && pwr1_off_macb011) || // mac03off11 
         (pwr1_off_macb211 && pwr1_off_macb011) || // mac02off11 
         (pwr1_off_macb111 && pwr1_off_macb011))  // mac01off11 
       begin
         ase_core_12v11 = 0;
         ase_core_10v11 = 0;
         ase_core_08v11 = 1;
         ase_core_06v11 = 0;
       end
     else if( (pwr1_off_smc11) || // smc11 off11
         (pwr1_off_macb011 ) || // mac0off11 
         (pwr1_off_macb111 ) || // mac1off11 
         (pwr1_off_macb211 ) || // mac2off11 
         (pwr1_off_macb311 ))  // mac3off11 
       begin
         ase_core_12v11 = 0;
         ase_core_10v11 = 1;
         ase_core_08v11 = 0;
         ase_core_06v11 = 0;
       end
     else if (pwr1_off_urt11)
       begin
         ase_core_12v11 = 1;
         ase_core_10v11 = 0;
         ase_core_08v11 = 0;
         ase_core_06v11 = 0;
       end
     else
       begin
         ase_core_12v11 = 1;
         ase_core_10v11 = 0;
         ase_core_08v11 = 0;
         ase_core_06v11 = 0;
       end
   end


   // cpu11
   // cpu11 @ 1.0v when macoff11, 
   // 
   reg ase_cpu_10v11, ase_cpu_12v11;
   always @(*) begin
    if(pwr1_off_cpu11) begin
     ase_cpu_12v11 = 1'b0;
     ase_cpu_10v11 = 1'b0;
    end
    else if(pwr1_off_macb011 || pwr1_off_macb111 || pwr1_off_macb211 || pwr1_off_macb311)
    begin
     ase_cpu_12v11 = 1'b0;
     ase_cpu_10v11 = 1'b1;
    end
    else
    begin
     ase_cpu_12v11 = 1'b1;
     ase_cpu_10v11 = 1'b0;
    end
   end

   // dma11
   // dma11 @v111.0 for macoff11, 

   reg ase_dma_10v11, ase_dma_12v11;
   always @(*) begin
    if(pwr1_off_dma11) begin
     ase_dma_12v11 = 1'b0;
     ase_dma_10v11 = 1'b0;
    end
    else if(pwr1_off_macb011 || pwr1_off_macb111 || pwr1_off_macb211 || pwr1_off_macb311)
    begin
     ase_dma_12v11 = 1'b0;
     ase_dma_10v11 = 1'b1;
    end
    else
    begin
     ase_dma_12v11 = 1'b1;
     ase_dma_10v11 = 1'b0;
    end
   end

   // alut11
   // @ v111.0 for macoff11

   reg ase_alut_10v11, ase_alut_12v11;
   always @(*) begin
    if(pwr1_off_alut11) begin
     ase_alut_12v11 = 1'b0;
     ase_alut_10v11 = 1'b0;
    end
    else if(pwr1_off_macb011 || pwr1_off_macb111 || pwr1_off_macb211 || pwr1_off_macb311)
    begin
     ase_alut_12v11 = 1'b0;
     ase_alut_10v11 = 1'b1;
    end
    else
    begin
     ase_alut_12v11 = 1'b1;
     ase_alut_10v11 = 1'b0;
    end
   end




   reg ase_uart_12v11;
   reg ase_uart_10v11;
   reg ase_uart_08v11;
   reg ase_uart_06v11;

   reg ase_smc_12v11;


   always @(*) begin
     if(pwr1_off_urt11) begin // uart11 off11
       ase_uart_08v11 = 1'b0;
       ase_uart_06v11 = 1'b0;
       ase_uart_10v11 = 1'b0;
       ase_uart_12v11 = 1'b0;
     end 
     else if( (pwr1_off_macb011 && pwr1_off_macb111 && pwr1_off_macb211 && pwr1_off_macb311) || // all mac11 off11
       (pwr1_off_macb311 && pwr1_off_macb211 && pwr1_off_macb111) || // mac123off11 
       (pwr1_off_macb311 && pwr1_off_macb211 && pwr1_off_macb011) || // mac023off11 
       (pwr1_off_macb311 && pwr1_off_macb111 && pwr1_off_macb011) || // mac013off11 
       (pwr1_off_macb211 && pwr1_off_macb111 && pwr1_off_macb011) )  // mac012off11 
     begin
       ase_uart_06v11 = 1'b1;
       ase_uart_08v11 = 1'b0;
       ase_uart_10v11 = 1'b0;
       ase_uart_12v11 = 1'b0;
     end
     else if( (pwr1_off_macb211 && pwr1_off_macb311) || // mac2311 off11
         (pwr1_off_macb311 && pwr1_off_macb111) || // mac13off11 
         (pwr1_off_macb111 && pwr1_off_macb211) || // mac12off11 
         (pwr1_off_macb311 && pwr1_off_macb011) || // mac03off11 
         (pwr1_off_macb111 && pwr1_off_macb011))  // mac01off11  
     begin
       ase_uart_06v11 = 1'b0;
       ase_uart_08v11 = 1'b1;
       ase_uart_10v11 = 1'b0;
       ase_uart_12v11 = 1'b0;
     end
     else if (pwr1_off_smc11 || pwr1_off_macb011 || pwr1_off_macb111 || pwr1_off_macb211 || pwr1_off_macb311) begin // smc11 off11
       ase_uart_08v11 = 1'b0;
       ase_uart_06v11 = 1'b0;
       ase_uart_10v11 = 1'b1;
       ase_uart_12v11 = 1'b0;
     end 
     else begin
       ase_uart_08v11 = 1'b0;
       ase_uart_06v11 = 1'b0;
       ase_uart_10v11 = 1'b0;
       ase_uart_12v11 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc11) begin
     if (pwr1_off_smc11)  // smc11 off11
       ase_smc_12v11 = 1'b0;
    else
       ase_smc_12v11 = 1'b1;
   end

   
   always @(pwr1_off_macb011) begin
     if (pwr1_off_macb011) // macb011 off11
       ase_macb0_12v11 = 1'b0;
     else
       ase_macb0_12v11 = 1'b1;
   end

   always @(pwr1_off_macb111) begin
     if (pwr1_off_macb111) // macb111 off11
       ase_macb1_12v11 = 1'b0;
     else
       ase_macb1_12v11 = 1'b1;
   end

   always @(pwr1_off_macb211) begin // macb211 off11
     if (pwr1_off_macb211) // macb211 off11
       ase_macb2_12v11 = 1'b0;
     else
       ase_macb2_12v11 = 1'b1;
   end

   always @(pwr1_off_macb311) begin // macb311 off11
     if (pwr1_off_macb311) // macb311 off11
       ase_macb3_12v11 = 1'b0;
     else
       ase_macb3_12v11 = 1'b1;
   end


   // core11 voltage11 for vco11
  assign core12v11 = ase_macb0_12v11 & ase_macb1_12v11 & ase_macb2_12v11 & ase_macb3_12v11;

  assign core10v11 =  (ase_macb0_12v11 & ase_macb1_12v11 & ase_macb2_12v11 & (!ase_macb3_12v11)) ||
                    (ase_macb0_12v11 & ase_macb1_12v11 & (!ase_macb2_12v11) & ase_macb3_12v11) ||
                    (ase_macb0_12v11 & (!ase_macb1_12v11) & ase_macb2_12v11 & ase_macb3_12v11) ||
                    ((!ase_macb0_12v11) & ase_macb1_12v11 & ase_macb2_12v11 & ase_macb3_12v11);

  assign core08v11 =  ((!ase_macb0_12v11) & (!ase_macb1_12v11) & (ase_macb2_12v11) & (ase_macb3_12v11)) ||
                    ((!ase_macb0_12v11) & (ase_macb1_12v11) & (!ase_macb2_12v11) & (ase_macb3_12v11)) ||
                    ((!ase_macb0_12v11) & (ase_macb1_12v11) & (ase_macb2_12v11) & (!ase_macb3_12v11)) ||
                    ((ase_macb0_12v11) & (!ase_macb1_12v11) & (!ase_macb2_12v11) & (ase_macb3_12v11)) ||
                    ((ase_macb0_12v11) & (!ase_macb1_12v11) & (ase_macb2_12v11) & (!ase_macb3_12v11)) ||
                    ((ase_macb0_12v11) & (ase_macb1_12v11) & (!ase_macb2_12v11) & (!ase_macb3_12v11));

  assign core06v11 =  ((!ase_macb0_12v11) & (!ase_macb1_12v11) & (!ase_macb2_12v11) & (ase_macb3_12v11)) ||
                    ((!ase_macb0_12v11) & (!ase_macb1_12v11) & (ase_macb2_12v11) & (!ase_macb3_12v11)) ||
                    ((!ase_macb0_12v11) & (ase_macb1_12v11) & (!ase_macb2_12v11) & (!ase_macb3_12v11)) ||
                    ((ase_macb0_12v11) & (!ase_macb1_12v11) & (!ase_macb2_12v11) & (!ase_macb3_12v11)) ||
                    ((!ase_macb0_12v11) & (!ase_macb1_12v11) & (!ase_macb2_12v11) & (!ase_macb3_12v11)) ;



`ifdef LP_ABV_ON11
// psl11 default clock11 = (posedge pclk11);

// Cover11 a condition in which SMC11 is powered11 down
// and again11 powered11 up while UART11 is going11 into POWER11 down
// state or UART11 is already in POWER11 DOWN11 state
// psl11 cover_overlapping_smc_urt_111:
//    cover{fell11(pwr1_on_urt11);[*];fell11(pwr1_on_smc11);[*];
//    rose11(pwr1_on_smc11);[*];rose11(pwr1_on_urt11)};
//
// Cover11 a condition in which UART11 is powered11 down
// and again11 powered11 up while SMC11 is going11 into POWER11 down
// state or SMC11 is already in POWER11 DOWN11 state
// psl11 cover_overlapping_smc_urt_211:
//    cover{fell11(pwr1_on_smc11);[*];fell11(pwr1_on_urt11);[*];
//    rose11(pwr1_on_urt11);[*];rose11(pwr1_on_smc11)};
//


// Power11 Down11 UART11
// This11 gets11 triggered on rising11 edge of Gate11 signal11 for
// UART11 (gate_clk_urt11). In a next cycle after gate_clk_urt11,
// Isolate11 UART11(isolate_urt11) signal11 become11 HIGH11 (active).
// In 2nd cycle after gate_clk_urt11 becomes HIGH11, RESET11 for NON11
// SRPG11 FFs11(rstn_non_srpg_urt11) and POWER111 for UART11(pwr1_on_urt11) should 
// go11 LOW11. 
// This11 completes11 a POWER11 DOWN11. 

sequence s_power_down_urt11;
      (gate_clk_urt11 & !isolate_urt11 & rstn_non_srpg_urt11 & pwr1_on_urt11) 
  ##1 (gate_clk_urt11 & isolate_urt11 & rstn_non_srpg_urt11 & pwr1_on_urt11) 
  ##3 (gate_clk_urt11 & isolate_urt11 & !rstn_non_srpg_urt11 & !pwr1_on_urt11);
endsequence


property p_power_down_urt11;
   @(posedge pclk11)
    $rose(gate_clk_urt11) |=> s_power_down_urt11;
endproperty

output_power_down_urt11:
  assert property (p_power_down_urt11);


// Power11 UP11 UART11
// Sequence starts with , Rising11 edge of pwr1_on_urt11.
// Two11 clock11 cycle after this, isolate_urt11 should become11 LOW11 
// On11 the following11 clk11 gate_clk_urt11 should go11 low11.
// 5 cycles11 after  Rising11 edge of pwr1_on_urt11, rstn_non_srpg_urt11
// should become11 HIGH11
sequence s_power_up_urt11;
##30 (pwr1_on_urt11 & !isolate_urt11 & gate_clk_urt11 & !rstn_non_srpg_urt11) 
##1 (pwr1_on_urt11 & !isolate_urt11 & !gate_clk_urt11 & !rstn_non_srpg_urt11) 
##2 (pwr1_on_urt11 & !isolate_urt11 & !gate_clk_urt11 & rstn_non_srpg_urt11);
endsequence

property p_power_up_urt11;
   @(posedge pclk11)
  disable iff(!nprst11)
    (!pwr1_on_urt11 ##1 pwr1_on_urt11) |=> s_power_up_urt11;
endproperty

output_power_up_urt11:
  assert property (p_power_up_urt11);


// Power11 Down11 SMC11
// This11 gets11 triggered on rising11 edge of Gate11 signal11 for
// SMC11 (gate_clk_smc11). In a next cycle after gate_clk_smc11,
// Isolate11 SMC11(isolate_smc11) signal11 become11 HIGH11 (active).
// In 2nd cycle after gate_clk_smc11 becomes HIGH11, RESET11 for NON11
// SRPG11 FFs11(rstn_non_srpg_smc11) and POWER111 for SMC11(pwr1_on_smc11) should 
// go11 LOW11. 
// This11 completes11 a POWER11 DOWN11. 

sequence s_power_down_smc11;
      (gate_clk_smc11 & !isolate_smc11 & rstn_non_srpg_smc11 & pwr1_on_smc11) 
  ##1 (gate_clk_smc11 & isolate_smc11 & rstn_non_srpg_smc11 & pwr1_on_smc11) 
  ##3 (gate_clk_smc11 & isolate_smc11 & !rstn_non_srpg_smc11 & !pwr1_on_smc11);
endsequence


property p_power_down_smc11;
   @(posedge pclk11)
    $rose(gate_clk_smc11) |=> s_power_down_smc11;
endproperty

output_power_down_smc11:
  assert property (p_power_down_smc11);


// Power11 UP11 SMC11
// Sequence starts with , Rising11 edge of pwr1_on_smc11.
// Two11 clock11 cycle after this, isolate_smc11 should become11 LOW11 
// On11 the following11 clk11 gate_clk_smc11 should go11 low11.
// 5 cycles11 after  Rising11 edge of pwr1_on_smc11, rstn_non_srpg_smc11
// should become11 HIGH11
sequence s_power_up_smc11;
##30 (pwr1_on_smc11 & !isolate_smc11 & gate_clk_smc11 & !rstn_non_srpg_smc11) 
##1 (pwr1_on_smc11 & !isolate_smc11 & !gate_clk_smc11 & !rstn_non_srpg_smc11) 
##2 (pwr1_on_smc11 & !isolate_smc11 & !gate_clk_smc11 & rstn_non_srpg_smc11);
endsequence

property p_power_up_smc11;
   @(posedge pclk11)
  disable iff(!nprst11)
    (!pwr1_on_smc11 ##1 pwr1_on_smc11) |=> s_power_up_smc11;
endproperty

output_power_up_smc11:
  assert property (p_power_up_smc11);


// COVER11 SMC11 POWER11 DOWN11 AND11 UP11
cover_power_down_up_smc11: cover property (@(posedge pclk11)
(s_power_down_smc11 ##[5:180] s_power_up_smc11));



// COVER11 UART11 POWER11 DOWN11 AND11 UP11
cover_power_down_up_urt11: cover property (@(posedge pclk11)
(s_power_down_urt11 ##[5:180] s_power_up_urt11));

cover_power_down_urt11: cover property (@(posedge pclk11)
(s_power_down_urt11));

cover_power_up_urt11: cover property (@(posedge pclk11)
(s_power_up_urt11));




`ifdef PCM_ABV_ON11
//------------------------------------------------------------------------------
// Power11 Controller11 Formal11 Verification11 component.  Each power11 domain has a 
// separate11 instantiation11
//------------------------------------------------------------------------------

// need to assume that CPU11 will leave11 a minimum time between powering11 down and 
// back up.  In this example11, 10clks has been selected.
// psl11 config_min_uart_pd_time11 : assume always {rose11(L1_ctrl_domain11[1])} |-> { L1_ctrl_domain11[1][*10] } abort11(~nprst11);
// psl11 config_min_uart_pu_time11 : assume always {fell11(L1_ctrl_domain11[1])} |-> { !L1_ctrl_domain11[1][*10] } abort11(~nprst11);
// psl11 config_min_smc_pd_time11 : assume always {rose11(L1_ctrl_domain11[2])} |-> { L1_ctrl_domain11[2][*10] } abort11(~nprst11);
// psl11 config_min_smc_pu_time11 : assume always {fell11(L1_ctrl_domain11[2])} |-> { !L1_ctrl_domain11[2][*10] } abort11(~nprst11);

// UART11 VCOMP11 parameters11
   defparam i_uart_vcomp_domain11.ENABLE_SAVE_RESTORE_EDGE11   = 1;
   defparam i_uart_vcomp_domain11.ENABLE_EXT_PWR_CNTRL11       = 1;
   defparam i_uart_vcomp_domain11.REF_CLK_DEFINED11            = 0;
   defparam i_uart_vcomp_domain11.MIN_SHUTOFF_CYCLES11         = 4;
   defparam i_uart_vcomp_domain11.MIN_RESTORE_TO_ISO_CYCLES11  = 0;
   defparam i_uart_vcomp_domain11.MIN_SAVE_TO_SHUTOFF_CYCLES11 = 1;


   vcomp_domain11 i_uart_vcomp_domain11
   ( .ref_clk11(pclk11),
     .start_lps11(L1_ctrl_domain11[1] || !rstn_non_srpg_urt11),
     .rst_n11(nprst11),
     .ext_power_down11(L1_ctrl_domain11[1]),
     .iso_en11(isolate_urt11),
     .save_edge11(save_edge_urt11),
     .restore_edge11(restore_edge_urt11),
     .domain_shut_off11(pwr1_off_urt11),
     .domain_clk11(!gate_clk_urt11 && pclk11)
   );


// SMC11 VCOMP11 parameters11
   defparam i_smc_vcomp_domain11.ENABLE_SAVE_RESTORE_EDGE11   = 1;
   defparam i_smc_vcomp_domain11.ENABLE_EXT_PWR_CNTRL11       = 1;
   defparam i_smc_vcomp_domain11.REF_CLK_DEFINED11            = 0;
   defparam i_smc_vcomp_domain11.MIN_SHUTOFF_CYCLES11         = 4;
   defparam i_smc_vcomp_domain11.MIN_RESTORE_TO_ISO_CYCLES11  = 0;
   defparam i_smc_vcomp_domain11.MIN_SAVE_TO_SHUTOFF_CYCLES11 = 1;


   vcomp_domain11 i_smc_vcomp_domain11
   ( .ref_clk11(pclk11),
     .start_lps11(L1_ctrl_domain11[2] || !rstn_non_srpg_smc11),
     .rst_n11(nprst11),
     .ext_power_down11(L1_ctrl_domain11[2]),
     .iso_en11(isolate_smc11),
     .save_edge11(save_edge_smc11),
     .restore_edge11(restore_edge_smc11),
     .domain_shut_off11(pwr1_off_smc11),
     .domain_clk11(!gate_clk_smc11 && pclk11)
   );

`endif

`endif



endmodule
