//File20 name   : power_ctrl20.v
//Title20       : Power20 Control20 Module20
//Created20     : 1999
//Description20 : Top20 level of power20 controller20
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

module power_ctrl20 (


    // Clocks20 & Reset20
    pclk20,
    nprst20,
    // APB20 programming20 interface
    paddr20,
    psel20,
    penable20,
    pwrite20,
    pwdata20,
    prdata20,
    // mac20 i/f,
    macb3_wakeup20,
    macb2_wakeup20,
    macb1_wakeup20,
    macb0_wakeup20,
    // Scan20 
    scan_in20,
    scan_en20,
    scan_mode20,
    scan_out20,
    // Module20 control20 outputs20
    int_source_h20,
    // SMC20
    rstn_non_srpg_smc20,
    gate_clk_smc20,
    isolate_smc20,
    save_edge_smc20,
    restore_edge_smc20,
    pwr1_on_smc20,
    pwr2_on_smc20,
    pwr1_off_smc20,
    pwr2_off_smc20,
    // URT20
    rstn_non_srpg_urt20,
    gate_clk_urt20,
    isolate_urt20,
    save_edge_urt20,
    restore_edge_urt20,
    pwr1_on_urt20,
    pwr2_on_urt20,
    pwr1_off_urt20,      
    pwr2_off_urt20,
    // ETH020
    rstn_non_srpg_macb020,
    gate_clk_macb020,
    isolate_macb020,
    save_edge_macb020,
    restore_edge_macb020,
    pwr1_on_macb020,
    pwr2_on_macb020,
    pwr1_off_macb020,      
    pwr2_off_macb020,
    // ETH120
    rstn_non_srpg_macb120,
    gate_clk_macb120,
    isolate_macb120,
    save_edge_macb120,
    restore_edge_macb120,
    pwr1_on_macb120,
    pwr2_on_macb120,
    pwr1_off_macb120,      
    pwr2_off_macb120,
    // ETH220
    rstn_non_srpg_macb220,
    gate_clk_macb220,
    isolate_macb220,
    save_edge_macb220,
    restore_edge_macb220,
    pwr1_on_macb220,
    pwr2_on_macb220,
    pwr1_off_macb220,      
    pwr2_off_macb220,
    // ETH320
    rstn_non_srpg_macb320,
    gate_clk_macb320,
    isolate_macb320,
    save_edge_macb320,
    restore_edge_macb320,
    pwr1_on_macb320,
    pwr2_on_macb320,
    pwr1_off_macb320,      
    pwr2_off_macb320,
    // DMA20
    rstn_non_srpg_dma20,
    gate_clk_dma20,
    isolate_dma20,
    save_edge_dma20,
    restore_edge_dma20,
    pwr1_on_dma20,
    pwr2_on_dma20,
    pwr1_off_dma20,      
    pwr2_off_dma20,
    // CPU20
    rstn_non_srpg_cpu20,
    gate_clk_cpu20,
    isolate_cpu20,
    save_edge_cpu20,
    restore_edge_cpu20,
    pwr1_on_cpu20,
    pwr2_on_cpu20,
    pwr1_off_cpu20,      
    pwr2_off_cpu20,
    // ALUT20
    rstn_non_srpg_alut20,
    gate_clk_alut20,
    isolate_alut20,
    save_edge_alut20,
    restore_edge_alut20,
    pwr1_on_alut20,
    pwr2_on_alut20,
    pwr1_off_alut20,      
    pwr2_off_alut20,
    // MEM20
    rstn_non_srpg_mem20,
    gate_clk_mem20,
    isolate_mem20,
    save_edge_mem20,
    restore_edge_mem20,
    pwr1_on_mem20,
    pwr2_on_mem20,
    pwr1_off_mem20,      
    pwr2_off_mem20,
    // core20 dvfs20 transitions20
    core06v20,
    core08v20,
    core10v20,
    core12v20,
    pcm_macb_wakeup_int20,
    // mte20 signals20
    mte_smc_start20,
    mte_uart_start20,
    mte_smc_uart_start20,  
    mte_pm_smc_to_default_start20, 
    mte_pm_uart_to_default_start20,
    mte_pm_smc_uart_to_default_start20

  );

  parameter STATE_IDLE_12V20 = 4'b0001;
  parameter STATE_06V20 = 4'b0010;
  parameter STATE_08V20 = 4'b0100;
  parameter STATE_10V20 = 4'b1000;

    // Clocks20 & Reset20
    input pclk20;
    input nprst20;
    // APB20 programming20 interface
    input [31:0] paddr20;
    input psel20  ;
    input penable20;
    input pwrite20 ;
    input [31:0] pwdata20;
    output [31:0] prdata20;
    // mac20
    input macb3_wakeup20;
    input macb2_wakeup20;
    input macb1_wakeup20;
    input macb0_wakeup20;
    // Scan20 
    input scan_in20;
    input scan_en20;
    input scan_mode20;
    output scan_out20;
    // Module20 control20 outputs20
    input int_source_h20;
    // SMC20
    output rstn_non_srpg_smc20 ;
    output gate_clk_smc20   ;
    output isolate_smc20   ;
    output save_edge_smc20   ;
    output restore_edge_smc20   ;
    output pwr1_on_smc20   ;
    output pwr2_on_smc20   ;
    output pwr1_off_smc20  ;
    output pwr2_off_smc20  ;
    // URT20
    output rstn_non_srpg_urt20 ;
    output gate_clk_urt20      ;
    output isolate_urt20       ;
    output save_edge_urt20   ;
    output restore_edge_urt20   ;
    output pwr1_on_urt20       ;
    output pwr2_on_urt20       ;
    output pwr1_off_urt20      ;
    output pwr2_off_urt20      ;
    // ETH020
    output rstn_non_srpg_macb020 ;
    output gate_clk_macb020      ;
    output isolate_macb020       ;
    output save_edge_macb020   ;
    output restore_edge_macb020   ;
    output pwr1_on_macb020       ;
    output pwr2_on_macb020       ;
    output pwr1_off_macb020      ;
    output pwr2_off_macb020      ;
    // ETH120
    output rstn_non_srpg_macb120 ;
    output gate_clk_macb120      ;
    output isolate_macb120       ;
    output save_edge_macb120   ;
    output restore_edge_macb120   ;
    output pwr1_on_macb120       ;
    output pwr2_on_macb120       ;
    output pwr1_off_macb120      ;
    output pwr2_off_macb120      ;
    // ETH220
    output rstn_non_srpg_macb220 ;
    output gate_clk_macb220      ;
    output isolate_macb220       ;
    output save_edge_macb220   ;
    output restore_edge_macb220   ;
    output pwr1_on_macb220       ;
    output pwr2_on_macb220       ;
    output pwr1_off_macb220      ;
    output pwr2_off_macb220      ;
    // ETH320
    output rstn_non_srpg_macb320 ;
    output gate_clk_macb320      ;
    output isolate_macb320       ;
    output save_edge_macb320   ;
    output restore_edge_macb320   ;
    output pwr1_on_macb320       ;
    output pwr2_on_macb320       ;
    output pwr1_off_macb320      ;
    output pwr2_off_macb320      ;
    // DMA20
    output rstn_non_srpg_dma20 ;
    output gate_clk_dma20      ;
    output isolate_dma20       ;
    output save_edge_dma20   ;
    output restore_edge_dma20   ;
    output pwr1_on_dma20       ;
    output pwr2_on_dma20       ;
    output pwr1_off_dma20      ;
    output pwr2_off_dma20      ;
    // CPU20
    output rstn_non_srpg_cpu20 ;
    output gate_clk_cpu20      ;
    output isolate_cpu20       ;
    output save_edge_cpu20   ;
    output restore_edge_cpu20   ;
    output pwr1_on_cpu20       ;
    output pwr2_on_cpu20       ;
    output pwr1_off_cpu20      ;
    output pwr2_off_cpu20      ;
    // ALUT20
    output rstn_non_srpg_alut20 ;
    output gate_clk_alut20      ;
    output isolate_alut20       ;
    output save_edge_alut20   ;
    output restore_edge_alut20   ;
    output pwr1_on_alut20       ;
    output pwr2_on_alut20       ;
    output pwr1_off_alut20      ;
    output pwr2_off_alut20      ;
    // MEM20
    output rstn_non_srpg_mem20 ;
    output gate_clk_mem20      ;
    output isolate_mem20       ;
    output save_edge_mem20   ;
    output restore_edge_mem20   ;
    output pwr1_on_mem20       ;
    output pwr2_on_mem20       ;
    output pwr1_off_mem20      ;
    output pwr2_off_mem20      ;


   // core20 transitions20 o/p
    output core06v20;
    output core08v20;
    output core10v20;
    output core12v20;
    output pcm_macb_wakeup_int20 ;
    //mode mte20  signals20
    output mte_smc_start20;
    output mte_uart_start20;
    output mte_smc_uart_start20;  
    output mte_pm_smc_to_default_start20; 
    output mte_pm_uart_to_default_start20;
    output mte_pm_smc_uart_to_default_start20;

    reg mte_smc_start20;
    reg mte_uart_start20;
    reg mte_smc_uart_start20;  
    reg mte_pm_smc_to_default_start20; 
    reg mte_pm_uart_to_default_start20;
    reg mte_pm_smc_uart_to_default_start20;

    reg [31:0] prdata20;

  wire valid_reg_write20  ;
  wire valid_reg_read20   ;
  wire L1_ctrl_access20   ;
  wire L1_status_access20 ;
  wire pcm_int_mask_access20;
  wire pcm_int_status_access20;
  wire standby_mem020      ;
  wire standby_mem120      ;
  wire standby_mem220      ;
  wire standby_mem320      ;
  wire pwr1_off_mem020;
  wire pwr1_off_mem120;
  wire pwr1_off_mem220;
  wire pwr1_off_mem320;
  
  // Control20 signals20
  wire set_status_smc20   ;
  wire clr_status_smc20   ;
  wire set_status_urt20   ;
  wire clr_status_urt20   ;
  wire set_status_macb020   ;
  wire clr_status_macb020   ;
  wire set_status_macb120   ;
  wire clr_status_macb120   ;
  wire set_status_macb220   ;
  wire clr_status_macb220   ;
  wire set_status_macb320   ;
  wire clr_status_macb320   ;
  wire set_status_dma20   ;
  wire clr_status_dma20   ;
  wire set_status_cpu20   ;
  wire clr_status_cpu20   ;
  wire set_status_alut20   ;
  wire clr_status_alut20   ;
  wire set_status_mem20   ;
  wire clr_status_mem20   ;


  // Status and Control20 registers
  reg [31:0]  L1_status_reg20;
  reg  [31:0] L1_ctrl_reg20  ;
  reg  [31:0] L1_ctrl_domain20  ;
  reg L1_ctrl_cpu_off_reg20;
  reg [31:0]  pcm_mask_reg20;
  reg [31:0]  pcm_status_reg20;

  // Signals20 gated20 in scan_mode20
  //SMC20
  wire  rstn_non_srpg_smc_int20;
  wire  gate_clk_smc_int20    ;     
  wire  isolate_smc_int20    ;       
  wire save_edge_smc_int20;
  wire restore_edge_smc_int20;
  wire  pwr1_on_smc_int20    ;      
  wire  pwr2_on_smc_int20    ;      


  //URT20
  wire   rstn_non_srpg_urt_int20;
  wire   gate_clk_urt_int20     ;     
  wire   isolate_urt_int20      ;       
  wire save_edge_urt_int20;
  wire restore_edge_urt_int20;
  wire   pwr1_on_urt_int20      ;      
  wire   pwr2_on_urt_int20      ;      

  // ETH020
  wire   rstn_non_srpg_macb0_int20;
  wire   gate_clk_macb0_int20     ;     
  wire   isolate_macb0_int20      ;       
  wire save_edge_macb0_int20;
  wire restore_edge_macb0_int20;
  wire   pwr1_on_macb0_int20      ;      
  wire   pwr2_on_macb0_int20      ;      
  // ETH120
  wire   rstn_non_srpg_macb1_int20;
  wire   gate_clk_macb1_int20     ;     
  wire   isolate_macb1_int20      ;       
  wire save_edge_macb1_int20;
  wire restore_edge_macb1_int20;
  wire   pwr1_on_macb1_int20      ;      
  wire   pwr2_on_macb1_int20      ;      
  // ETH220
  wire   rstn_non_srpg_macb2_int20;
  wire   gate_clk_macb2_int20     ;     
  wire   isolate_macb2_int20      ;       
  wire save_edge_macb2_int20;
  wire restore_edge_macb2_int20;
  wire   pwr1_on_macb2_int20      ;      
  wire   pwr2_on_macb2_int20      ;      
  // ETH320
  wire   rstn_non_srpg_macb3_int20;
  wire   gate_clk_macb3_int20     ;     
  wire   isolate_macb3_int20      ;       
  wire save_edge_macb3_int20;
  wire restore_edge_macb3_int20;
  wire   pwr1_on_macb3_int20      ;      
  wire   pwr2_on_macb3_int20      ;      

  // DMA20
  wire   rstn_non_srpg_dma_int20;
  wire   gate_clk_dma_int20     ;     
  wire   isolate_dma_int20      ;       
  wire save_edge_dma_int20;
  wire restore_edge_dma_int20;
  wire   pwr1_on_dma_int20      ;      
  wire   pwr2_on_dma_int20      ;      

  // CPU20
  wire   rstn_non_srpg_cpu_int20;
  wire   gate_clk_cpu_int20     ;     
  wire   isolate_cpu_int20      ;       
  wire save_edge_cpu_int20;
  wire restore_edge_cpu_int20;
  wire   pwr1_on_cpu_int20      ;      
  wire   pwr2_on_cpu_int20      ;  
  wire L1_ctrl_cpu_off_p20;    

  reg save_alut_tmp20;
  // DFS20 sm20

  reg cpu_shutoff_ctrl20;

  reg mte_mac_off_start20, mte_mac012_start20, mte_mac013_start20, mte_mac023_start20, mte_mac123_start20;
  reg mte_mac01_start20, mte_mac02_start20, mte_mac03_start20, mte_mac12_start20, mte_mac13_start20, mte_mac23_start20;
  reg mte_mac0_start20, mte_mac1_start20, mte_mac2_start20, mte_mac3_start20;
  reg mte_sys_hibernate20 ;
  reg mte_dma_start20 ;
  reg mte_cpu_start20 ;
  reg mte_mac_off_sleep_start20, mte_mac012_sleep_start20, mte_mac013_sleep_start20, mte_mac023_sleep_start20, mte_mac123_sleep_start20;
  reg mte_mac01_sleep_start20, mte_mac02_sleep_start20, mte_mac03_sleep_start20, mte_mac12_sleep_start20, mte_mac13_sleep_start20, mte_mac23_sleep_start20;
  reg mte_mac0_sleep_start20, mte_mac1_sleep_start20, mte_mac2_sleep_start20, mte_mac3_sleep_start20;
  reg mte_dma_sleep_start20;
  reg mte_mac_off_to_default20, mte_mac012_to_default20, mte_mac013_to_default20, mte_mac023_to_default20, mte_mac123_to_default20;
  reg mte_mac01_to_default20, mte_mac02_to_default20, mte_mac03_to_default20, mte_mac12_to_default20, mte_mac13_to_default20, mte_mac23_to_default20;
  reg mte_mac0_to_default20, mte_mac1_to_default20, mte_mac2_to_default20, mte_mac3_to_default20;
  reg mte_dma_isolate_dis20;
  reg mte_cpu_isolate_dis20;
  reg mte_sys_hibernate_to_default20;


  // Latch20 the CPU20 SLEEP20 invocation20
  always @( posedge pclk20 or negedge nprst20) 
  begin
    if(!nprst20)
      L1_ctrl_cpu_off_reg20 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg20 <= L1_ctrl_domain20[8];
  end

  // Create20 a pulse20 for sleep20 detection20 
  assign L1_ctrl_cpu_off_p20 =  L1_ctrl_domain20[8] && !L1_ctrl_cpu_off_reg20;
  
  // CPU20 sleep20 contol20 logic 
  // Shut20 off20 CPU20 when L1_ctrl_cpu_off_p20 is set
  // wake20 cpu20 when any interrupt20 is seen20  
  always @( posedge pclk20 or negedge nprst20) 
  begin
    if(!nprst20)
     cpu_shutoff_ctrl20 <= 1'b0;
    else if(cpu_shutoff_ctrl20 && int_source_h20)
     cpu_shutoff_ctrl20 <= 1'b0;
    else if (L1_ctrl_cpu_off_p20)
     cpu_shutoff_ctrl20 <= 1'b1;
  end
 
  // instantiate20 power20 contol20  block for uart20
  power_ctrl_sm20 i_urt_power_ctrl_sm20(
    .pclk20(pclk20),
    .nprst20(nprst20),
    .L1_module_req20(L1_ctrl_domain20[1]),
    .set_status_module20(set_status_urt20),
    .clr_status_module20(clr_status_urt20),
    .rstn_non_srpg_module20(rstn_non_srpg_urt_int20),
    .gate_clk_module20(gate_clk_urt_int20),
    .isolate_module20(isolate_urt_int20),
    .save_edge20(save_edge_urt_int20),
    .restore_edge20(restore_edge_urt_int20),
    .pwr1_on20(pwr1_on_urt_int20),
    .pwr2_on20(pwr2_on_urt_int20)
    );
  

  // instantiate20 power20 contol20  block for smc20
  power_ctrl_sm20 i_smc_power_ctrl_sm20(
    .pclk20(pclk20),
    .nprst20(nprst20),
    .L1_module_req20(L1_ctrl_domain20[2]),
    .set_status_module20(set_status_smc20),
    .clr_status_module20(clr_status_smc20),
    .rstn_non_srpg_module20(rstn_non_srpg_smc_int20),
    .gate_clk_module20(gate_clk_smc_int20),
    .isolate_module20(isolate_smc_int20),
    .save_edge20(save_edge_smc_int20),
    .restore_edge20(restore_edge_smc_int20),
    .pwr1_on20(pwr1_on_smc_int20),
    .pwr2_on20(pwr2_on_smc_int20)
    );

  // power20 control20 for macb020
  power_ctrl_sm20 i_macb0_power_ctrl_sm20(
    .pclk20(pclk20),
    .nprst20(nprst20),
    .L1_module_req20(L1_ctrl_domain20[3]),
    .set_status_module20(set_status_macb020),
    .clr_status_module20(clr_status_macb020),
    .rstn_non_srpg_module20(rstn_non_srpg_macb0_int20),
    .gate_clk_module20(gate_clk_macb0_int20),
    .isolate_module20(isolate_macb0_int20),
    .save_edge20(save_edge_macb0_int20),
    .restore_edge20(restore_edge_macb0_int20),
    .pwr1_on20(pwr1_on_macb0_int20),
    .pwr2_on20(pwr2_on_macb0_int20)
    );
  // power20 control20 for macb120
  power_ctrl_sm20 i_macb1_power_ctrl_sm20(
    .pclk20(pclk20),
    .nprst20(nprst20),
    .L1_module_req20(L1_ctrl_domain20[4]),
    .set_status_module20(set_status_macb120),
    .clr_status_module20(clr_status_macb120),
    .rstn_non_srpg_module20(rstn_non_srpg_macb1_int20),
    .gate_clk_module20(gate_clk_macb1_int20),
    .isolate_module20(isolate_macb1_int20),
    .save_edge20(save_edge_macb1_int20),
    .restore_edge20(restore_edge_macb1_int20),
    .pwr1_on20(pwr1_on_macb1_int20),
    .pwr2_on20(pwr2_on_macb1_int20)
    );
  // power20 control20 for macb220
  power_ctrl_sm20 i_macb2_power_ctrl_sm20(
    .pclk20(pclk20),
    .nprst20(nprst20),
    .L1_module_req20(L1_ctrl_domain20[5]),
    .set_status_module20(set_status_macb220),
    .clr_status_module20(clr_status_macb220),
    .rstn_non_srpg_module20(rstn_non_srpg_macb2_int20),
    .gate_clk_module20(gate_clk_macb2_int20),
    .isolate_module20(isolate_macb2_int20),
    .save_edge20(save_edge_macb2_int20),
    .restore_edge20(restore_edge_macb2_int20),
    .pwr1_on20(pwr1_on_macb2_int20),
    .pwr2_on20(pwr2_on_macb2_int20)
    );
  // power20 control20 for macb320
  power_ctrl_sm20 i_macb3_power_ctrl_sm20(
    .pclk20(pclk20),
    .nprst20(nprst20),
    .L1_module_req20(L1_ctrl_domain20[6]),
    .set_status_module20(set_status_macb320),
    .clr_status_module20(clr_status_macb320),
    .rstn_non_srpg_module20(rstn_non_srpg_macb3_int20),
    .gate_clk_module20(gate_clk_macb3_int20),
    .isolate_module20(isolate_macb3_int20),
    .save_edge20(save_edge_macb3_int20),
    .restore_edge20(restore_edge_macb3_int20),
    .pwr1_on20(pwr1_on_macb3_int20),
    .pwr2_on20(pwr2_on_macb3_int20)
    );
  // power20 control20 for dma20
  power_ctrl_sm20 i_dma_power_ctrl_sm20(
    .pclk20(pclk20),
    .nprst20(nprst20),
    .L1_module_req20(L1_ctrl_domain20[7]),
    .set_status_module20(set_status_dma20),
    .clr_status_module20(clr_status_dma20),
    .rstn_non_srpg_module20(rstn_non_srpg_dma_int20),
    .gate_clk_module20(gate_clk_dma_int20),
    .isolate_module20(isolate_dma_int20),
    .save_edge20(save_edge_dma_int20),
    .restore_edge20(restore_edge_dma_int20),
    .pwr1_on20(pwr1_on_dma_int20),
    .pwr2_on20(pwr2_on_dma_int20)
    );
  // power20 control20 for CPU20
  power_ctrl_sm20 i_cpu_power_ctrl_sm20(
    .pclk20(pclk20),
    .nprst20(nprst20),
    .L1_module_req20(cpu_shutoff_ctrl20),
    .set_status_module20(set_status_cpu20),
    .clr_status_module20(clr_status_cpu20),
    .rstn_non_srpg_module20(rstn_non_srpg_cpu_int20),
    .gate_clk_module20(gate_clk_cpu_int20),
    .isolate_module20(isolate_cpu_int20),
    .save_edge20(save_edge_cpu_int20),
    .restore_edge20(restore_edge_cpu_int20),
    .pwr1_on20(pwr1_on_cpu_int20),
    .pwr2_on20(pwr2_on_cpu_int20)
    );

  assign valid_reg_write20 =  (psel20 && pwrite20 && penable20);
  assign valid_reg_read20  =  (psel20 && (!pwrite20) && penable20);

  assign L1_ctrl_access20  =  (paddr20[15:0] == 16'b0000000000000100); 
  assign L1_status_access20 = (paddr20[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access20 =   (paddr20[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access20 = (paddr20[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control20 and status register
  always @(*)
  begin  
    if(valid_reg_read20 && L1_ctrl_access20) 
      prdata20 = L1_ctrl_reg20;
    else if (valid_reg_read20 && L1_status_access20)
      prdata20 = L1_status_reg20;
    else if (valid_reg_read20 && pcm_int_mask_access20)
      prdata20 = pcm_mask_reg20;
    else if (valid_reg_read20 && pcm_int_status_access20)
      prdata20 = pcm_status_reg20;
    else 
      prdata20 = 0;
  end

  assign set_status_mem20 =  (set_status_macb020 && set_status_macb120 && set_status_macb220 &&
                            set_status_macb320 && set_status_dma20 && set_status_cpu20);

  assign clr_status_mem20 =  (clr_status_macb020 && clr_status_macb120 && clr_status_macb220 &&
                            clr_status_macb320 && clr_status_dma20 && clr_status_cpu20);

  assign set_status_alut20 = (set_status_macb020 && set_status_macb120 && set_status_macb220 && set_status_macb320);

  assign clr_status_alut20 = (clr_status_macb020 || clr_status_macb120 || clr_status_macb220  || clr_status_macb320);

  // Write accesses to the control20 and status register
 
  always @(posedge pclk20 or negedge nprst20)
  begin
    if (!nprst20) begin
      L1_ctrl_reg20   <= 0;
      L1_status_reg20 <= 0;
      pcm_mask_reg20 <= 0;
    end else begin
      // CTRL20 reg updates20
      if (valid_reg_write20 && L1_ctrl_access20) 
        L1_ctrl_reg20 <= pwdata20; // Writes20 to the ctrl20 reg
      if (valid_reg_write20 && pcm_int_mask_access20) 
        pcm_mask_reg20 <= pwdata20; // Writes20 to the ctrl20 reg

      if (set_status_urt20 == 1'b1)  
        L1_status_reg20[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt20 == 1'b1) 
        L1_status_reg20[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc20 == 1'b1) 
        L1_status_reg20[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc20 == 1'b1) 
        L1_status_reg20[2] <= 1'b0; // Clear the status bit

      if (set_status_macb020 == 1'b1)  
        L1_status_reg20[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb020 == 1'b1) 
        L1_status_reg20[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb120 == 1'b1)  
        L1_status_reg20[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb120 == 1'b1) 
        L1_status_reg20[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb220 == 1'b1)  
        L1_status_reg20[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb220 == 1'b1) 
        L1_status_reg20[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb320 == 1'b1)  
        L1_status_reg20[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb320 == 1'b1) 
        L1_status_reg20[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma20 == 1'b1)  
        L1_status_reg20[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma20 == 1'b1) 
        L1_status_reg20[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu20 == 1'b1)  
        L1_status_reg20[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu20 == 1'b1) 
        L1_status_reg20[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut20 == 1'b1)  
        L1_status_reg20[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut20 == 1'b1) 
        L1_status_reg20[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem20 == 1'b1)  
        L1_status_reg20[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem20 == 1'b1) 
        L1_status_reg20[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused20 bits of pcm_status_reg20 are tied20 to 0
  always @(posedge pclk20 or negedge nprst20)
  begin
    if (!nprst20)
      pcm_status_reg20[31:4] <= 'b0;
    else  
      pcm_status_reg20[31:4] <= pcm_status_reg20[31:4];
  end
  
  // interrupt20 only of h/w assisted20 wakeup
  // MAC20 3
  always @(posedge pclk20 or negedge nprst20)
  begin
    if(!nprst20)
      pcm_status_reg20[3] <= 1'b0;
    else if (valid_reg_write20 && pcm_int_status_access20) 
      pcm_status_reg20[3] <= pwdata20[3];
    else if (macb3_wakeup20 & ~pcm_mask_reg20[3])
      pcm_status_reg20[3] <= 1'b1;
    else if (valid_reg_read20 && pcm_int_status_access20) 
      pcm_status_reg20[3] <= 1'b0;
    else
      pcm_status_reg20[3] <= pcm_status_reg20[3];
  end  
   
  // MAC20 2
  always @(posedge pclk20 or negedge nprst20)
  begin
    if(!nprst20)
      pcm_status_reg20[2] <= 1'b0;
    else if (valid_reg_write20 && pcm_int_status_access20) 
      pcm_status_reg20[2] <= pwdata20[2];
    else if (macb2_wakeup20 & ~pcm_mask_reg20[2])
      pcm_status_reg20[2] <= 1'b1;
    else if (valid_reg_read20 && pcm_int_status_access20) 
      pcm_status_reg20[2] <= 1'b0;
    else
      pcm_status_reg20[2] <= pcm_status_reg20[2];
  end  

  // MAC20 1
  always @(posedge pclk20 or negedge nprst20)
  begin
    if(!nprst20)
      pcm_status_reg20[1] <= 1'b0;
    else if (valid_reg_write20 && pcm_int_status_access20) 
      pcm_status_reg20[1] <= pwdata20[1];
    else if (macb1_wakeup20 & ~pcm_mask_reg20[1])
      pcm_status_reg20[1] <= 1'b1;
    else if (valid_reg_read20 && pcm_int_status_access20) 
      pcm_status_reg20[1] <= 1'b0;
    else
      pcm_status_reg20[1] <= pcm_status_reg20[1];
  end  
   
  // MAC20 0
  always @(posedge pclk20 or negedge nprst20)
  begin
    if(!nprst20)
      pcm_status_reg20[0] <= 1'b0;
    else if (valid_reg_write20 && pcm_int_status_access20) 
      pcm_status_reg20[0] <= pwdata20[0];
    else if (macb0_wakeup20 & ~pcm_mask_reg20[0])
      pcm_status_reg20[0] <= 1'b1;
    else if (valid_reg_read20 && pcm_int_status_access20) 
      pcm_status_reg20[0] <= 1'b0;
    else
      pcm_status_reg20[0] <= pcm_status_reg20[0];
  end  

  assign pcm_macb_wakeup_int20 = |pcm_status_reg20;

  reg [31:0] L1_ctrl_reg120;
  always @(posedge pclk20 or negedge nprst20)
  begin
    if(!nprst20)
      L1_ctrl_reg120 <= 0;
    else
      L1_ctrl_reg120 <= L1_ctrl_reg20;
  end

  // Program20 mode decode
  always @(L1_ctrl_reg20 or L1_ctrl_reg120 or int_source_h20 or cpu_shutoff_ctrl20) begin
    mte_smc_start20 = 0;
    mte_uart_start20 = 0;
    mte_smc_uart_start20  = 0;
    mte_mac_off_start20  = 0;
    mte_mac012_start20 = 0;
    mte_mac013_start20 = 0;
    mte_mac023_start20 = 0;
    mte_mac123_start20 = 0;
    mte_mac01_start20 = 0;
    mte_mac02_start20 = 0;
    mte_mac03_start20 = 0;
    mte_mac12_start20 = 0;
    mte_mac13_start20 = 0;
    mte_mac23_start20 = 0;
    mte_mac0_start20 = 0;
    mte_mac1_start20 = 0;
    mte_mac2_start20 = 0;
    mte_mac3_start20 = 0;
    mte_sys_hibernate20 = 0 ;
    mte_dma_start20 = 0 ;
    mte_cpu_start20 = 0 ;

    mte_mac0_sleep_start20 = (L1_ctrl_reg20 ==  'h14) && (L1_ctrl_reg120 == 'h4 );
    mte_mac1_sleep_start20 = (L1_ctrl_reg20 ==  'h14) && (L1_ctrl_reg120 == 'h5 ); 
    mte_mac2_sleep_start20 = (L1_ctrl_reg20 ==  'h14) && (L1_ctrl_reg120 == 'h6 ); 
    mte_mac3_sleep_start20 = (L1_ctrl_reg20 ==  'h14) && (L1_ctrl_reg120 == 'h7 ); 
    mte_mac01_sleep_start20 = (L1_ctrl_reg20 ==  'h14) && (L1_ctrl_reg120 == 'h8 ); 
    mte_mac02_sleep_start20 = (L1_ctrl_reg20 ==  'h14) && (L1_ctrl_reg120 == 'h9 ); 
    mte_mac03_sleep_start20 = (L1_ctrl_reg20 ==  'h14) && (L1_ctrl_reg120 == 'hA ); 
    mte_mac12_sleep_start20 = (L1_ctrl_reg20 ==  'h14) && (L1_ctrl_reg120 == 'hB ); 
    mte_mac13_sleep_start20 = (L1_ctrl_reg20 ==  'h14) && (L1_ctrl_reg120 == 'hC ); 
    mte_mac23_sleep_start20 = (L1_ctrl_reg20 ==  'h14) && (L1_ctrl_reg120 == 'hD ); 
    mte_mac012_sleep_start20 = (L1_ctrl_reg20 ==  'h14) && (L1_ctrl_reg120 == 'hE ); 
    mte_mac013_sleep_start20 = (L1_ctrl_reg20 ==  'h14) && (L1_ctrl_reg120 == 'hF ); 
    mte_mac023_sleep_start20 = (L1_ctrl_reg20 ==  'h14) && (L1_ctrl_reg120 == 'h10 ); 
    mte_mac123_sleep_start20 = (L1_ctrl_reg20 ==  'h14) && (L1_ctrl_reg120 == 'h11 ); 
    mte_mac_off_sleep_start20 =  (L1_ctrl_reg20 == 'h14) && (L1_ctrl_reg120 == 'h12 );
    mte_dma_sleep_start20 =  (L1_ctrl_reg20 == 'h14) && (L1_ctrl_reg120 == 'h13 );

    mte_pm_uart_to_default_start20 = (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'h1);
    mte_pm_smc_to_default_start20 = (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'h2);
    mte_pm_smc_uart_to_default_start20 = (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'h3); 
    mte_mac0_to_default20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'h4); 
    mte_mac1_to_default20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'h5); 
    mte_mac2_to_default20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'h6); 
    mte_mac3_to_default20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'h7); 
    mte_mac01_to_default20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'h8); 
    mte_mac02_to_default20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'h9); 
    mte_mac03_to_default20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'hA); 
    mte_mac12_to_default20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'hB); 
    mte_mac13_to_default20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'hC); 
    mte_mac23_to_default20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'hD); 
    mte_mac012_to_default20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'hE); 
    mte_mac013_to_default20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'hF); 
    mte_mac023_to_default20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'h10); 
    mte_mac123_to_default20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'h11); 
    mte_mac_off_to_default20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'h12); 
    mte_dma_isolate_dis20 =  (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'h13); 
    mte_cpu_isolate_dis20 =  (int_source_h20) && (cpu_shutoff_ctrl20) && (L1_ctrl_reg20 != 'h15);
    mte_sys_hibernate_to_default20 = (L1_ctrl_reg20 == 32'h0) && (L1_ctrl_reg120 == 'h15); 

   
    if (L1_ctrl_reg120 == 'h0) begin // This20 check is to make mte_cpu_start20
                                   // is set only when you from default state 
      case (L1_ctrl_reg20)
        'h0 : L1_ctrl_domain20 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain20 = 32'h2; // PM_uart20
                mte_uart_start20 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain20 = 32'h4; // PM_smc20
                mte_smc_start20 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain20 = 32'h6; // PM_smc_uart20
                mte_smc_uart_start20 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain20 = 32'h8; //  PM_macb020
                mte_mac0_start20 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain20 = 32'h10; //  PM_macb120
                mte_mac1_start20 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain20 = 32'h20; //  PM_macb220
                mte_mac2_start20 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain20 = 32'h40; //  PM_macb320
                mte_mac3_start20 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain20 = 32'h18; //  PM_macb0120
                mte_mac01_start20 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain20 = 32'h28; //  PM_macb0220
                mte_mac02_start20 = 1;
              end
        'hA : begin  
                L1_ctrl_domain20 = 32'h48; //  PM_macb0320
                mte_mac03_start20 = 1;
              end
        'hB : begin  
                L1_ctrl_domain20 = 32'h30; //  PM_macb1220
                mte_mac12_start20 = 1;
              end
        'hC : begin  
                L1_ctrl_domain20 = 32'h50; //  PM_macb1320
                mte_mac13_start20 = 1;
              end
        'hD : begin  
                L1_ctrl_domain20 = 32'h60; //  PM_macb2320
                mte_mac23_start20 = 1;
              end
        'hE : begin  
                L1_ctrl_domain20 = 32'h38; //  PM_macb01220
                mte_mac012_start20 = 1;
              end
        'hF : begin  
                L1_ctrl_domain20 = 32'h58; //  PM_macb01320
                mte_mac013_start20 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain20 = 32'h68; //  PM_macb02320
                mte_mac023_start20 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain20 = 32'h70; //  PM_macb12320
                mte_mac123_start20 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain20 = 32'h78; //  PM_macb_off20
                mte_mac_off_start20 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain20 = 32'h80; //  PM_dma20
                mte_dma_start20 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain20 = 32'h100; //  PM_cpu_sleep20
                mte_cpu_start20 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain20 = 32'h1FE; //  PM_hibernate20
                mte_sys_hibernate20 = 1;
              end
         default: L1_ctrl_domain20 = 32'h0;
      endcase
    end
  end


  wire to_default20 = (L1_ctrl_reg20 == 0);

  // Scan20 mode gating20 of power20 and isolation20 control20 signals20
  //SMC20
  assign rstn_non_srpg_smc20  = (scan_mode20 == 1'b0) ? rstn_non_srpg_smc_int20 : 1'b1;  
  assign gate_clk_smc20       = (scan_mode20 == 1'b0) ? gate_clk_smc_int20 : 1'b0;     
  assign isolate_smc20        = (scan_mode20 == 1'b0) ? isolate_smc_int20 : 1'b0;      
  assign pwr1_on_smc20        = (scan_mode20 == 1'b0) ? pwr1_on_smc_int20 : 1'b1;       
  assign pwr2_on_smc20        = (scan_mode20 == 1'b0) ? pwr2_on_smc_int20 : 1'b1;       
  assign pwr1_off_smc20       = (scan_mode20 == 1'b0) ? (!pwr1_on_smc_int20) : 1'b0;       
  assign pwr2_off_smc20       = (scan_mode20 == 1'b0) ? (!pwr2_on_smc_int20) : 1'b0;       
  assign save_edge_smc20       = (scan_mode20 == 1'b0) ? (save_edge_smc_int20) : 1'b0;       
  assign restore_edge_smc20       = (scan_mode20 == 1'b0) ? (restore_edge_smc_int20) : 1'b0;       

  //URT20
  assign rstn_non_srpg_urt20  = (scan_mode20 == 1'b0) ?  rstn_non_srpg_urt_int20 : 1'b1;  
  assign gate_clk_urt20       = (scan_mode20 == 1'b0) ?  gate_clk_urt_int20      : 1'b0;     
  assign isolate_urt20        = (scan_mode20 == 1'b0) ?  isolate_urt_int20       : 1'b0;      
  assign pwr1_on_urt20        = (scan_mode20 == 1'b0) ?  pwr1_on_urt_int20       : 1'b1;       
  assign pwr2_on_urt20        = (scan_mode20 == 1'b0) ?  pwr2_on_urt_int20       : 1'b1;       
  assign pwr1_off_urt20       = (scan_mode20 == 1'b0) ?  (!pwr1_on_urt_int20)  : 1'b0;       
  assign pwr2_off_urt20       = (scan_mode20 == 1'b0) ?  (!pwr2_on_urt_int20)  : 1'b0;       
  assign save_edge_urt20       = (scan_mode20 == 1'b0) ? (save_edge_urt_int20) : 1'b0;       
  assign restore_edge_urt20       = (scan_mode20 == 1'b0) ? (restore_edge_urt_int20) : 1'b0;       

  //ETH020
  assign rstn_non_srpg_macb020 = (scan_mode20 == 1'b0) ?  rstn_non_srpg_macb0_int20 : 1'b1;  
  assign gate_clk_macb020       = (scan_mode20 == 1'b0) ?  gate_clk_macb0_int20      : 1'b0;     
  assign isolate_macb020        = (scan_mode20 == 1'b0) ?  isolate_macb0_int20       : 1'b0;      
  assign pwr1_on_macb020        = (scan_mode20 == 1'b0) ?  pwr1_on_macb0_int20       : 1'b1;       
  assign pwr2_on_macb020        = (scan_mode20 == 1'b0) ?  pwr2_on_macb0_int20       : 1'b1;       
  assign pwr1_off_macb020       = (scan_mode20 == 1'b0) ?  (!pwr1_on_macb0_int20)  : 1'b0;       
  assign pwr2_off_macb020       = (scan_mode20 == 1'b0) ?  (!pwr2_on_macb0_int20)  : 1'b0;       
  assign save_edge_macb020       = (scan_mode20 == 1'b0) ? (save_edge_macb0_int20) : 1'b0;       
  assign restore_edge_macb020       = (scan_mode20 == 1'b0) ? (restore_edge_macb0_int20) : 1'b0;       

  //ETH120
  assign rstn_non_srpg_macb120 = (scan_mode20 == 1'b0) ?  rstn_non_srpg_macb1_int20 : 1'b1;  
  assign gate_clk_macb120       = (scan_mode20 == 1'b0) ?  gate_clk_macb1_int20      : 1'b0;     
  assign isolate_macb120        = (scan_mode20 == 1'b0) ?  isolate_macb1_int20       : 1'b0;      
  assign pwr1_on_macb120        = (scan_mode20 == 1'b0) ?  pwr1_on_macb1_int20       : 1'b1;       
  assign pwr2_on_macb120        = (scan_mode20 == 1'b0) ?  pwr2_on_macb1_int20       : 1'b1;       
  assign pwr1_off_macb120       = (scan_mode20 == 1'b0) ?  (!pwr1_on_macb1_int20)  : 1'b0;       
  assign pwr2_off_macb120       = (scan_mode20 == 1'b0) ?  (!pwr2_on_macb1_int20)  : 1'b0;       
  assign save_edge_macb120       = (scan_mode20 == 1'b0) ? (save_edge_macb1_int20) : 1'b0;       
  assign restore_edge_macb120       = (scan_mode20 == 1'b0) ? (restore_edge_macb1_int20) : 1'b0;       

  //ETH220
  assign rstn_non_srpg_macb220 = (scan_mode20 == 1'b0) ?  rstn_non_srpg_macb2_int20 : 1'b1;  
  assign gate_clk_macb220       = (scan_mode20 == 1'b0) ?  gate_clk_macb2_int20      : 1'b0;     
  assign isolate_macb220        = (scan_mode20 == 1'b0) ?  isolate_macb2_int20       : 1'b0;      
  assign pwr1_on_macb220        = (scan_mode20 == 1'b0) ?  pwr1_on_macb2_int20       : 1'b1;       
  assign pwr2_on_macb220        = (scan_mode20 == 1'b0) ?  pwr2_on_macb2_int20       : 1'b1;       
  assign pwr1_off_macb220       = (scan_mode20 == 1'b0) ?  (!pwr1_on_macb2_int20)  : 1'b0;       
  assign pwr2_off_macb220       = (scan_mode20 == 1'b0) ?  (!pwr2_on_macb2_int20)  : 1'b0;       
  assign save_edge_macb220       = (scan_mode20 == 1'b0) ? (save_edge_macb2_int20) : 1'b0;       
  assign restore_edge_macb220       = (scan_mode20 == 1'b0) ? (restore_edge_macb2_int20) : 1'b0;       

  //ETH320
  assign rstn_non_srpg_macb320 = (scan_mode20 == 1'b0) ?  rstn_non_srpg_macb3_int20 : 1'b1;  
  assign gate_clk_macb320       = (scan_mode20 == 1'b0) ?  gate_clk_macb3_int20      : 1'b0;     
  assign isolate_macb320        = (scan_mode20 == 1'b0) ?  isolate_macb3_int20       : 1'b0;      
  assign pwr1_on_macb320        = (scan_mode20 == 1'b0) ?  pwr1_on_macb3_int20       : 1'b1;       
  assign pwr2_on_macb320        = (scan_mode20 == 1'b0) ?  pwr2_on_macb3_int20       : 1'b1;       
  assign pwr1_off_macb320       = (scan_mode20 == 1'b0) ?  (!pwr1_on_macb3_int20)  : 1'b0;       
  assign pwr2_off_macb320       = (scan_mode20 == 1'b0) ?  (!pwr2_on_macb3_int20)  : 1'b0;       
  assign save_edge_macb320       = (scan_mode20 == 1'b0) ? (save_edge_macb3_int20) : 1'b0;       
  assign restore_edge_macb320       = (scan_mode20 == 1'b0) ? (restore_edge_macb3_int20) : 1'b0;       

  // MEM20
  assign rstn_non_srpg_mem20 =   (rstn_non_srpg_macb020 && rstn_non_srpg_macb120 && rstn_non_srpg_macb220 &&
                                rstn_non_srpg_macb320 && rstn_non_srpg_dma20 && rstn_non_srpg_cpu20 && rstn_non_srpg_urt20 &&
                                rstn_non_srpg_smc20);

  assign gate_clk_mem20 =  (gate_clk_macb020 && gate_clk_macb120 && gate_clk_macb220 &&
                            gate_clk_macb320 && gate_clk_dma20 && gate_clk_cpu20 && gate_clk_urt20 && gate_clk_smc20);

  assign isolate_mem20  = (isolate_macb020 && isolate_macb120 && isolate_macb220 &&
                         isolate_macb320 && isolate_dma20 && isolate_cpu20 && isolate_urt20 && isolate_smc20);


  assign pwr1_on_mem20        =   ~pwr1_off_mem20;

  assign pwr2_on_mem20        =   ~pwr2_off_mem20;

  assign pwr1_off_mem20       =  (pwr1_off_macb020 && pwr1_off_macb120 && pwr1_off_macb220 &&
                                 pwr1_off_macb320 && pwr1_off_dma20 && pwr1_off_cpu20 && pwr1_off_urt20 && pwr1_off_smc20);


  assign pwr2_off_mem20       =  (pwr2_off_macb020 && pwr2_off_macb120 && pwr2_off_macb220 &&
                                pwr2_off_macb320 && pwr2_off_dma20 && pwr2_off_cpu20 && pwr2_off_urt20 && pwr2_off_smc20);

  assign save_edge_mem20      =  (save_edge_macb020 && save_edge_macb120 && save_edge_macb220 &&
                                save_edge_macb320 && save_edge_dma20 && save_edge_cpu20 && save_edge_smc20 && save_edge_urt20);

  assign restore_edge_mem20   =  (restore_edge_macb020 && restore_edge_macb120 && restore_edge_macb220  &&
                                restore_edge_macb320 && restore_edge_dma20 && restore_edge_cpu20 && restore_edge_urt20 &&
                                restore_edge_smc20);

  assign standby_mem020 = pwr1_off_macb020 && (~ (pwr1_off_macb020 && pwr1_off_macb120 && pwr1_off_macb220 && pwr1_off_macb320 && pwr1_off_urt20 && pwr1_off_smc20 && pwr1_off_dma20 && pwr1_off_cpu20));
  assign standby_mem120 = pwr1_off_macb120 && (~ (pwr1_off_macb020 && pwr1_off_macb120 && pwr1_off_macb220 && pwr1_off_macb320 && pwr1_off_urt20 && pwr1_off_smc20 && pwr1_off_dma20 && pwr1_off_cpu20));
  assign standby_mem220 = pwr1_off_macb220 && (~ (pwr1_off_macb020 && pwr1_off_macb120 && pwr1_off_macb220 && pwr1_off_macb320 && pwr1_off_urt20 && pwr1_off_smc20 && pwr1_off_dma20 && pwr1_off_cpu20));
  assign standby_mem320 = pwr1_off_macb320 && (~ (pwr1_off_macb020 && pwr1_off_macb120 && pwr1_off_macb220 && pwr1_off_macb320 && pwr1_off_urt20 && pwr1_off_smc20 && pwr1_off_dma20 && pwr1_off_cpu20));

  assign pwr1_off_mem020 = pwr1_off_mem20;
  assign pwr1_off_mem120 = pwr1_off_mem20;
  assign pwr1_off_mem220 = pwr1_off_mem20;
  assign pwr1_off_mem320 = pwr1_off_mem20;

  assign rstn_non_srpg_alut20  =  (rstn_non_srpg_macb020 && rstn_non_srpg_macb120 && rstn_non_srpg_macb220 && rstn_non_srpg_macb320);


   assign gate_clk_alut20       =  (gate_clk_macb020 && gate_clk_macb120 && gate_clk_macb220 && gate_clk_macb320);


    assign isolate_alut20        =  (isolate_macb020 && isolate_macb120 && isolate_macb220 && isolate_macb320);


    assign pwr1_on_alut20        =  (pwr1_on_macb020 || pwr1_on_macb120 || pwr1_on_macb220 || pwr1_on_macb320);


    assign pwr2_on_alut20        =  (pwr2_on_macb020 || pwr2_on_macb120 || pwr2_on_macb220 || pwr2_on_macb320);


    assign pwr1_off_alut20       =  (pwr1_off_macb020 && pwr1_off_macb120 && pwr1_off_macb220 && pwr1_off_macb320);


    assign pwr2_off_alut20       =  (pwr2_off_macb020 && pwr2_off_macb120 && pwr2_off_macb220 && pwr2_off_macb320);


    assign save_edge_alut20      =  (save_edge_macb020 && save_edge_macb120 && save_edge_macb220 && save_edge_macb320);


    assign restore_edge_alut20   =  (restore_edge_macb020 || restore_edge_macb120 || restore_edge_macb220 ||
                                   restore_edge_macb320) && save_alut_tmp20;

     // alut20 power20 off20 detection20
  always @(posedge pclk20 or negedge nprst20) begin
    if (!nprst20) 
       save_alut_tmp20 <= 0;
    else if (restore_edge_alut20)
       save_alut_tmp20 <= 0;
    else if (save_edge_alut20)
       save_alut_tmp20 <= 1;
  end

  //DMA20
  assign rstn_non_srpg_dma20 = (scan_mode20 == 1'b0) ?  rstn_non_srpg_dma_int20 : 1'b1;  
  assign gate_clk_dma20       = (scan_mode20 == 1'b0) ?  gate_clk_dma_int20      : 1'b0;     
  assign isolate_dma20        = (scan_mode20 == 1'b0) ?  isolate_dma_int20       : 1'b0;      
  assign pwr1_on_dma20        = (scan_mode20 == 1'b0) ?  pwr1_on_dma_int20       : 1'b1;       
  assign pwr2_on_dma20        = (scan_mode20 == 1'b0) ?  pwr2_on_dma_int20       : 1'b1;       
  assign pwr1_off_dma20       = (scan_mode20 == 1'b0) ?  (!pwr1_on_dma_int20)  : 1'b0;       
  assign pwr2_off_dma20       = (scan_mode20 == 1'b0) ?  (!pwr2_on_dma_int20)  : 1'b0;       
  assign save_edge_dma20       = (scan_mode20 == 1'b0) ? (save_edge_dma_int20) : 1'b0;       
  assign restore_edge_dma20       = (scan_mode20 == 1'b0) ? (restore_edge_dma_int20) : 1'b0;       

  //CPU20
  assign rstn_non_srpg_cpu20 = (scan_mode20 == 1'b0) ?  rstn_non_srpg_cpu_int20 : 1'b1;  
  assign gate_clk_cpu20       = (scan_mode20 == 1'b0) ?  gate_clk_cpu_int20      : 1'b0;     
  assign isolate_cpu20        = (scan_mode20 == 1'b0) ?  isolate_cpu_int20       : 1'b0;      
  assign pwr1_on_cpu20        = (scan_mode20 == 1'b0) ?  pwr1_on_cpu_int20       : 1'b1;       
  assign pwr2_on_cpu20        = (scan_mode20 == 1'b0) ?  pwr2_on_cpu_int20       : 1'b1;       
  assign pwr1_off_cpu20       = (scan_mode20 == 1'b0) ?  (!pwr1_on_cpu_int20)  : 1'b0;       
  assign pwr2_off_cpu20       = (scan_mode20 == 1'b0) ?  (!pwr2_on_cpu_int20)  : 1'b0;       
  assign save_edge_cpu20       = (scan_mode20 == 1'b0) ? (save_edge_cpu_int20) : 1'b0;       
  assign restore_edge_cpu20       = (scan_mode20 == 1'b0) ? (restore_edge_cpu_int20) : 1'b0;       



  // ASE20

   reg ase_core_12v20, ase_core_10v20, ase_core_08v20, ase_core_06v20;
   reg ase_macb0_12v20,ase_macb1_12v20,ase_macb2_12v20,ase_macb3_12v20;

    // core20 ase20

    // core20 at 1.0 v if (smc20 off20, urt20 off20, macb020 off20, macb120 off20, macb220 off20, macb320 off20
   // core20 at 0.8v if (mac01off20, macb02off20, macb03off20, macb12off20, mac13off20, mac23off20,
   // core20 at 0.6v if (mac012off20, mac013off20, mac023off20, mac123off20, mac0123off20
    // else core20 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb020 && pwr1_off_macb120 && pwr1_off_macb220 && pwr1_off_macb320) || // all mac20 off20
       (pwr1_off_macb320 && pwr1_off_macb220 && pwr1_off_macb120) || // mac123off20 
       (pwr1_off_macb320 && pwr1_off_macb220 && pwr1_off_macb020) || // mac023off20 
       (pwr1_off_macb320 && pwr1_off_macb120 && pwr1_off_macb020) || // mac013off20 
       (pwr1_off_macb220 && pwr1_off_macb120 && pwr1_off_macb020) )  // mac012off20 
       begin
         ase_core_12v20 = 0;
         ase_core_10v20 = 0;
         ase_core_08v20 = 0;
         ase_core_06v20 = 1;
       end
     else if( (pwr1_off_macb220 && pwr1_off_macb320) || // mac2320 off20
         (pwr1_off_macb320 && pwr1_off_macb120) || // mac13off20 
         (pwr1_off_macb120 && pwr1_off_macb220) || // mac12off20 
         (pwr1_off_macb320 && pwr1_off_macb020) || // mac03off20 
         (pwr1_off_macb220 && pwr1_off_macb020) || // mac02off20 
         (pwr1_off_macb120 && pwr1_off_macb020))  // mac01off20 
       begin
         ase_core_12v20 = 0;
         ase_core_10v20 = 0;
         ase_core_08v20 = 1;
         ase_core_06v20 = 0;
       end
     else if( (pwr1_off_smc20) || // smc20 off20
         (pwr1_off_macb020 ) || // mac0off20 
         (pwr1_off_macb120 ) || // mac1off20 
         (pwr1_off_macb220 ) || // mac2off20 
         (pwr1_off_macb320 ))  // mac3off20 
       begin
         ase_core_12v20 = 0;
         ase_core_10v20 = 1;
         ase_core_08v20 = 0;
         ase_core_06v20 = 0;
       end
     else if (pwr1_off_urt20)
       begin
         ase_core_12v20 = 1;
         ase_core_10v20 = 0;
         ase_core_08v20 = 0;
         ase_core_06v20 = 0;
       end
     else
       begin
         ase_core_12v20 = 1;
         ase_core_10v20 = 0;
         ase_core_08v20 = 0;
         ase_core_06v20 = 0;
       end
   end


   // cpu20
   // cpu20 @ 1.0v when macoff20, 
   // 
   reg ase_cpu_10v20, ase_cpu_12v20;
   always @(*) begin
    if(pwr1_off_cpu20) begin
     ase_cpu_12v20 = 1'b0;
     ase_cpu_10v20 = 1'b0;
    end
    else if(pwr1_off_macb020 || pwr1_off_macb120 || pwr1_off_macb220 || pwr1_off_macb320)
    begin
     ase_cpu_12v20 = 1'b0;
     ase_cpu_10v20 = 1'b1;
    end
    else
    begin
     ase_cpu_12v20 = 1'b1;
     ase_cpu_10v20 = 1'b0;
    end
   end

   // dma20
   // dma20 @v120.0 for macoff20, 

   reg ase_dma_10v20, ase_dma_12v20;
   always @(*) begin
    if(pwr1_off_dma20) begin
     ase_dma_12v20 = 1'b0;
     ase_dma_10v20 = 1'b0;
    end
    else if(pwr1_off_macb020 || pwr1_off_macb120 || pwr1_off_macb220 || pwr1_off_macb320)
    begin
     ase_dma_12v20 = 1'b0;
     ase_dma_10v20 = 1'b1;
    end
    else
    begin
     ase_dma_12v20 = 1'b1;
     ase_dma_10v20 = 1'b0;
    end
   end

   // alut20
   // @ v120.0 for macoff20

   reg ase_alut_10v20, ase_alut_12v20;
   always @(*) begin
    if(pwr1_off_alut20) begin
     ase_alut_12v20 = 1'b0;
     ase_alut_10v20 = 1'b0;
    end
    else if(pwr1_off_macb020 || pwr1_off_macb120 || pwr1_off_macb220 || pwr1_off_macb320)
    begin
     ase_alut_12v20 = 1'b0;
     ase_alut_10v20 = 1'b1;
    end
    else
    begin
     ase_alut_12v20 = 1'b1;
     ase_alut_10v20 = 1'b0;
    end
   end




   reg ase_uart_12v20;
   reg ase_uart_10v20;
   reg ase_uart_08v20;
   reg ase_uart_06v20;

   reg ase_smc_12v20;


   always @(*) begin
     if(pwr1_off_urt20) begin // uart20 off20
       ase_uart_08v20 = 1'b0;
       ase_uart_06v20 = 1'b0;
       ase_uart_10v20 = 1'b0;
       ase_uart_12v20 = 1'b0;
     end 
     else if( (pwr1_off_macb020 && pwr1_off_macb120 && pwr1_off_macb220 && pwr1_off_macb320) || // all mac20 off20
       (pwr1_off_macb320 && pwr1_off_macb220 && pwr1_off_macb120) || // mac123off20 
       (pwr1_off_macb320 && pwr1_off_macb220 && pwr1_off_macb020) || // mac023off20 
       (pwr1_off_macb320 && pwr1_off_macb120 && pwr1_off_macb020) || // mac013off20 
       (pwr1_off_macb220 && pwr1_off_macb120 && pwr1_off_macb020) )  // mac012off20 
     begin
       ase_uart_06v20 = 1'b1;
       ase_uart_08v20 = 1'b0;
       ase_uart_10v20 = 1'b0;
       ase_uart_12v20 = 1'b0;
     end
     else if( (pwr1_off_macb220 && pwr1_off_macb320) || // mac2320 off20
         (pwr1_off_macb320 && pwr1_off_macb120) || // mac13off20 
         (pwr1_off_macb120 && pwr1_off_macb220) || // mac12off20 
         (pwr1_off_macb320 && pwr1_off_macb020) || // mac03off20 
         (pwr1_off_macb120 && pwr1_off_macb020))  // mac01off20  
     begin
       ase_uart_06v20 = 1'b0;
       ase_uart_08v20 = 1'b1;
       ase_uart_10v20 = 1'b0;
       ase_uart_12v20 = 1'b0;
     end
     else if (pwr1_off_smc20 || pwr1_off_macb020 || pwr1_off_macb120 || pwr1_off_macb220 || pwr1_off_macb320) begin // smc20 off20
       ase_uart_08v20 = 1'b0;
       ase_uart_06v20 = 1'b0;
       ase_uart_10v20 = 1'b1;
       ase_uart_12v20 = 1'b0;
     end 
     else begin
       ase_uart_08v20 = 1'b0;
       ase_uart_06v20 = 1'b0;
       ase_uart_10v20 = 1'b0;
       ase_uart_12v20 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc20) begin
     if (pwr1_off_smc20)  // smc20 off20
       ase_smc_12v20 = 1'b0;
    else
       ase_smc_12v20 = 1'b1;
   end

   
   always @(pwr1_off_macb020) begin
     if (pwr1_off_macb020) // macb020 off20
       ase_macb0_12v20 = 1'b0;
     else
       ase_macb0_12v20 = 1'b1;
   end

   always @(pwr1_off_macb120) begin
     if (pwr1_off_macb120) // macb120 off20
       ase_macb1_12v20 = 1'b0;
     else
       ase_macb1_12v20 = 1'b1;
   end

   always @(pwr1_off_macb220) begin // macb220 off20
     if (pwr1_off_macb220) // macb220 off20
       ase_macb2_12v20 = 1'b0;
     else
       ase_macb2_12v20 = 1'b1;
   end

   always @(pwr1_off_macb320) begin // macb320 off20
     if (pwr1_off_macb320) // macb320 off20
       ase_macb3_12v20 = 1'b0;
     else
       ase_macb3_12v20 = 1'b1;
   end


   // core20 voltage20 for vco20
  assign core12v20 = ase_macb0_12v20 & ase_macb1_12v20 & ase_macb2_12v20 & ase_macb3_12v20;

  assign core10v20 =  (ase_macb0_12v20 & ase_macb1_12v20 & ase_macb2_12v20 & (!ase_macb3_12v20)) ||
                    (ase_macb0_12v20 & ase_macb1_12v20 & (!ase_macb2_12v20) & ase_macb3_12v20) ||
                    (ase_macb0_12v20 & (!ase_macb1_12v20) & ase_macb2_12v20 & ase_macb3_12v20) ||
                    ((!ase_macb0_12v20) & ase_macb1_12v20 & ase_macb2_12v20 & ase_macb3_12v20);

  assign core08v20 =  ((!ase_macb0_12v20) & (!ase_macb1_12v20) & (ase_macb2_12v20) & (ase_macb3_12v20)) ||
                    ((!ase_macb0_12v20) & (ase_macb1_12v20) & (!ase_macb2_12v20) & (ase_macb3_12v20)) ||
                    ((!ase_macb0_12v20) & (ase_macb1_12v20) & (ase_macb2_12v20) & (!ase_macb3_12v20)) ||
                    ((ase_macb0_12v20) & (!ase_macb1_12v20) & (!ase_macb2_12v20) & (ase_macb3_12v20)) ||
                    ((ase_macb0_12v20) & (!ase_macb1_12v20) & (ase_macb2_12v20) & (!ase_macb3_12v20)) ||
                    ((ase_macb0_12v20) & (ase_macb1_12v20) & (!ase_macb2_12v20) & (!ase_macb3_12v20));

  assign core06v20 =  ((!ase_macb0_12v20) & (!ase_macb1_12v20) & (!ase_macb2_12v20) & (ase_macb3_12v20)) ||
                    ((!ase_macb0_12v20) & (!ase_macb1_12v20) & (ase_macb2_12v20) & (!ase_macb3_12v20)) ||
                    ((!ase_macb0_12v20) & (ase_macb1_12v20) & (!ase_macb2_12v20) & (!ase_macb3_12v20)) ||
                    ((ase_macb0_12v20) & (!ase_macb1_12v20) & (!ase_macb2_12v20) & (!ase_macb3_12v20)) ||
                    ((!ase_macb0_12v20) & (!ase_macb1_12v20) & (!ase_macb2_12v20) & (!ase_macb3_12v20)) ;



`ifdef LP_ABV_ON20
// psl20 default clock20 = (posedge pclk20);

// Cover20 a condition in which SMC20 is powered20 down
// and again20 powered20 up while UART20 is going20 into POWER20 down
// state or UART20 is already in POWER20 DOWN20 state
// psl20 cover_overlapping_smc_urt_120:
//    cover{fell20(pwr1_on_urt20);[*];fell20(pwr1_on_smc20);[*];
//    rose20(pwr1_on_smc20);[*];rose20(pwr1_on_urt20)};
//
// Cover20 a condition in which UART20 is powered20 down
// and again20 powered20 up while SMC20 is going20 into POWER20 down
// state or SMC20 is already in POWER20 DOWN20 state
// psl20 cover_overlapping_smc_urt_220:
//    cover{fell20(pwr1_on_smc20);[*];fell20(pwr1_on_urt20);[*];
//    rose20(pwr1_on_urt20);[*];rose20(pwr1_on_smc20)};
//


// Power20 Down20 UART20
// This20 gets20 triggered on rising20 edge of Gate20 signal20 for
// UART20 (gate_clk_urt20). In a next cycle after gate_clk_urt20,
// Isolate20 UART20(isolate_urt20) signal20 become20 HIGH20 (active).
// In 2nd cycle after gate_clk_urt20 becomes HIGH20, RESET20 for NON20
// SRPG20 FFs20(rstn_non_srpg_urt20) and POWER120 for UART20(pwr1_on_urt20) should 
// go20 LOW20. 
// This20 completes20 a POWER20 DOWN20. 

sequence s_power_down_urt20;
      (gate_clk_urt20 & !isolate_urt20 & rstn_non_srpg_urt20 & pwr1_on_urt20) 
  ##1 (gate_clk_urt20 & isolate_urt20 & rstn_non_srpg_urt20 & pwr1_on_urt20) 
  ##3 (gate_clk_urt20 & isolate_urt20 & !rstn_non_srpg_urt20 & !pwr1_on_urt20);
endsequence


property p_power_down_urt20;
   @(posedge pclk20)
    $rose(gate_clk_urt20) |=> s_power_down_urt20;
endproperty

output_power_down_urt20:
  assert property (p_power_down_urt20);


// Power20 UP20 UART20
// Sequence starts with , Rising20 edge of pwr1_on_urt20.
// Two20 clock20 cycle after this, isolate_urt20 should become20 LOW20 
// On20 the following20 clk20 gate_clk_urt20 should go20 low20.
// 5 cycles20 after  Rising20 edge of pwr1_on_urt20, rstn_non_srpg_urt20
// should become20 HIGH20
sequence s_power_up_urt20;
##30 (pwr1_on_urt20 & !isolate_urt20 & gate_clk_urt20 & !rstn_non_srpg_urt20) 
##1 (pwr1_on_urt20 & !isolate_urt20 & !gate_clk_urt20 & !rstn_non_srpg_urt20) 
##2 (pwr1_on_urt20 & !isolate_urt20 & !gate_clk_urt20 & rstn_non_srpg_urt20);
endsequence

property p_power_up_urt20;
   @(posedge pclk20)
  disable iff(!nprst20)
    (!pwr1_on_urt20 ##1 pwr1_on_urt20) |=> s_power_up_urt20;
endproperty

output_power_up_urt20:
  assert property (p_power_up_urt20);


// Power20 Down20 SMC20
// This20 gets20 triggered on rising20 edge of Gate20 signal20 for
// SMC20 (gate_clk_smc20). In a next cycle after gate_clk_smc20,
// Isolate20 SMC20(isolate_smc20) signal20 become20 HIGH20 (active).
// In 2nd cycle after gate_clk_smc20 becomes HIGH20, RESET20 for NON20
// SRPG20 FFs20(rstn_non_srpg_smc20) and POWER120 for SMC20(pwr1_on_smc20) should 
// go20 LOW20. 
// This20 completes20 a POWER20 DOWN20. 

sequence s_power_down_smc20;
      (gate_clk_smc20 & !isolate_smc20 & rstn_non_srpg_smc20 & pwr1_on_smc20) 
  ##1 (gate_clk_smc20 & isolate_smc20 & rstn_non_srpg_smc20 & pwr1_on_smc20) 
  ##3 (gate_clk_smc20 & isolate_smc20 & !rstn_non_srpg_smc20 & !pwr1_on_smc20);
endsequence


property p_power_down_smc20;
   @(posedge pclk20)
    $rose(gate_clk_smc20) |=> s_power_down_smc20;
endproperty

output_power_down_smc20:
  assert property (p_power_down_smc20);


// Power20 UP20 SMC20
// Sequence starts with , Rising20 edge of pwr1_on_smc20.
// Two20 clock20 cycle after this, isolate_smc20 should become20 LOW20 
// On20 the following20 clk20 gate_clk_smc20 should go20 low20.
// 5 cycles20 after  Rising20 edge of pwr1_on_smc20, rstn_non_srpg_smc20
// should become20 HIGH20
sequence s_power_up_smc20;
##30 (pwr1_on_smc20 & !isolate_smc20 & gate_clk_smc20 & !rstn_non_srpg_smc20) 
##1 (pwr1_on_smc20 & !isolate_smc20 & !gate_clk_smc20 & !rstn_non_srpg_smc20) 
##2 (pwr1_on_smc20 & !isolate_smc20 & !gate_clk_smc20 & rstn_non_srpg_smc20);
endsequence

property p_power_up_smc20;
   @(posedge pclk20)
  disable iff(!nprst20)
    (!pwr1_on_smc20 ##1 pwr1_on_smc20) |=> s_power_up_smc20;
endproperty

output_power_up_smc20:
  assert property (p_power_up_smc20);


// COVER20 SMC20 POWER20 DOWN20 AND20 UP20
cover_power_down_up_smc20: cover property (@(posedge pclk20)
(s_power_down_smc20 ##[5:180] s_power_up_smc20));



// COVER20 UART20 POWER20 DOWN20 AND20 UP20
cover_power_down_up_urt20: cover property (@(posedge pclk20)
(s_power_down_urt20 ##[5:180] s_power_up_urt20));

cover_power_down_urt20: cover property (@(posedge pclk20)
(s_power_down_urt20));

cover_power_up_urt20: cover property (@(posedge pclk20)
(s_power_up_urt20));




`ifdef PCM_ABV_ON20
//------------------------------------------------------------------------------
// Power20 Controller20 Formal20 Verification20 component.  Each power20 domain has a 
// separate20 instantiation20
//------------------------------------------------------------------------------

// need to assume that CPU20 will leave20 a minimum time between powering20 down and 
// back up.  In this example20, 10clks has been selected.
// psl20 config_min_uart_pd_time20 : assume always {rose20(L1_ctrl_domain20[1])} |-> { L1_ctrl_domain20[1][*10] } abort20(~nprst20);
// psl20 config_min_uart_pu_time20 : assume always {fell20(L1_ctrl_domain20[1])} |-> { !L1_ctrl_domain20[1][*10] } abort20(~nprst20);
// psl20 config_min_smc_pd_time20 : assume always {rose20(L1_ctrl_domain20[2])} |-> { L1_ctrl_domain20[2][*10] } abort20(~nprst20);
// psl20 config_min_smc_pu_time20 : assume always {fell20(L1_ctrl_domain20[2])} |-> { !L1_ctrl_domain20[2][*10] } abort20(~nprst20);

// UART20 VCOMP20 parameters20
   defparam i_uart_vcomp_domain20.ENABLE_SAVE_RESTORE_EDGE20   = 1;
   defparam i_uart_vcomp_domain20.ENABLE_EXT_PWR_CNTRL20       = 1;
   defparam i_uart_vcomp_domain20.REF_CLK_DEFINED20            = 0;
   defparam i_uart_vcomp_domain20.MIN_SHUTOFF_CYCLES20         = 4;
   defparam i_uart_vcomp_domain20.MIN_RESTORE_TO_ISO_CYCLES20  = 0;
   defparam i_uart_vcomp_domain20.MIN_SAVE_TO_SHUTOFF_CYCLES20 = 1;


   vcomp_domain20 i_uart_vcomp_domain20
   ( .ref_clk20(pclk20),
     .start_lps20(L1_ctrl_domain20[1] || !rstn_non_srpg_urt20),
     .rst_n20(nprst20),
     .ext_power_down20(L1_ctrl_domain20[1]),
     .iso_en20(isolate_urt20),
     .save_edge20(save_edge_urt20),
     .restore_edge20(restore_edge_urt20),
     .domain_shut_off20(pwr1_off_urt20),
     .domain_clk20(!gate_clk_urt20 && pclk20)
   );


// SMC20 VCOMP20 parameters20
   defparam i_smc_vcomp_domain20.ENABLE_SAVE_RESTORE_EDGE20   = 1;
   defparam i_smc_vcomp_domain20.ENABLE_EXT_PWR_CNTRL20       = 1;
   defparam i_smc_vcomp_domain20.REF_CLK_DEFINED20            = 0;
   defparam i_smc_vcomp_domain20.MIN_SHUTOFF_CYCLES20         = 4;
   defparam i_smc_vcomp_domain20.MIN_RESTORE_TO_ISO_CYCLES20  = 0;
   defparam i_smc_vcomp_domain20.MIN_SAVE_TO_SHUTOFF_CYCLES20 = 1;


   vcomp_domain20 i_smc_vcomp_domain20
   ( .ref_clk20(pclk20),
     .start_lps20(L1_ctrl_domain20[2] || !rstn_non_srpg_smc20),
     .rst_n20(nprst20),
     .ext_power_down20(L1_ctrl_domain20[2]),
     .iso_en20(isolate_smc20),
     .save_edge20(save_edge_smc20),
     .restore_edge20(restore_edge_smc20),
     .domain_shut_off20(pwr1_off_smc20),
     .domain_clk20(!gate_clk_smc20 && pclk20)
   );

`endif

`endif



endmodule
