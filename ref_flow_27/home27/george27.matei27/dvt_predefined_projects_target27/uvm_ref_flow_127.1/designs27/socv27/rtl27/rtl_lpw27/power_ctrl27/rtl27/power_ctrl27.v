//File27 name   : power_ctrl27.v
//Title27       : Power27 Control27 Module27
//Created27     : 1999
//Description27 : Top27 level of power27 controller27
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

module power_ctrl27 (


    // Clocks27 & Reset27
    pclk27,
    nprst27,
    // APB27 programming27 interface
    paddr27,
    psel27,
    penable27,
    pwrite27,
    pwdata27,
    prdata27,
    // mac27 i/f,
    macb3_wakeup27,
    macb2_wakeup27,
    macb1_wakeup27,
    macb0_wakeup27,
    // Scan27 
    scan_in27,
    scan_en27,
    scan_mode27,
    scan_out27,
    // Module27 control27 outputs27
    int_source_h27,
    // SMC27
    rstn_non_srpg_smc27,
    gate_clk_smc27,
    isolate_smc27,
    save_edge_smc27,
    restore_edge_smc27,
    pwr1_on_smc27,
    pwr2_on_smc27,
    pwr1_off_smc27,
    pwr2_off_smc27,
    // URT27
    rstn_non_srpg_urt27,
    gate_clk_urt27,
    isolate_urt27,
    save_edge_urt27,
    restore_edge_urt27,
    pwr1_on_urt27,
    pwr2_on_urt27,
    pwr1_off_urt27,      
    pwr2_off_urt27,
    // ETH027
    rstn_non_srpg_macb027,
    gate_clk_macb027,
    isolate_macb027,
    save_edge_macb027,
    restore_edge_macb027,
    pwr1_on_macb027,
    pwr2_on_macb027,
    pwr1_off_macb027,      
    pwr2_off_macb027,
    // ETH127
    rstn_non_srpg_macb127,
    gate_clk_macb127,
    isolate_macb127,
    save_edge_macb127,
    restore_edge_macb127,
    pwr1_on_macb127,
    pwr2_on_macb127,
    pwr1_off_macb127,      
    pwr2_off_macb127,
    // ETH227
    rstn_non_srpg_macb227,
    gate_clk_macb227,
    isolate_macb227,
    save_edge_macb227,
    restore_edge_macb227,
    pwr1_on_macb227,
    pwr2_on_macb227,
    pwr1_off_macb227,      
    pwr2_off_macb227,
    // ETH327
    rstn_non_srpg_macb327,
    gate_clk_macb327,
    isolate_macb327,
    save_edge_macb327,
    restore_edge_macb327,
    pwr1_on_macb327,
    pwr2_on_macb327,
    pwr1_off_macb327,      
    pwr2_off_macb327,
    // DMA27
    rstn_non_srpg_dma27,
    gate_clk_dma27,
    isolate_dma27,
    save_edge_dma27,
    restore_edge_dma27,
    pwr1_on_dma27,
    pwr2_on_dma27,
    pwr1_off_dma27,      
    pwr2_off_dma27,
    // CPU27
    rstn_non_srpg_cpu27,
    gate_clk_cpu27,
    isolate_cpu27,
    save_edge_cpu27,
    restore_edge_cpu27,
    pwr1_on_cpu27,
    pwr2_on_cpu27,
    pwr1_off_cpu27,      
    pwr2_off_cpu27,
    // ALUT27
    rstn_non_srpg_alut27,
    gate_clk_alut27,
    isolate_alut27,
    save_edge_alut27,
    restore_edge_alut27,
    pwr1_on_alut27,
    pwr2_on_alut27,
    pwr1_off_alut27,      
    pwr2_off_alut27,
    // MEM27
    rstn_non_srpg_mem27,
    gate_clk_mem27,
    isolate_mem27,
    save_edge_mem27,
    restore_edge_mem27,
    pwr1_on_mem27,
    pwr2_on_mem27,
    pwr1_off_mem27,      
    pwr2_off_mem27,
    // core27 dvfs27 transitions27
    core06v27,
    core08v27,
    core10v27,
    core12v27,
    pcm_macb_wakeup_int27,
    // mte27 signals27
    mte_smc_start27,
    mte_uart_start27,
    mte_smc_uart_start27,  
    mte_pm_smc_to_default_start27, 
    mte_pm_uart_to_default_start27,
    mte_pm_smc_uart_to_default_start27

  );

  parameter STATE_IDLE_12V27 = 4'b0001;
  parameter STATE_06V27 = 4'b0010;
  parameter STATE_08V27 = 4'b0100;
  parameter STATE_10V27 = 4'b1000;

    // Clocks27 & Reset27
    input pclk27;
    input nprst27;
    // APB27 programming27 interface
    input [31:0] paddr27;
    input psel27  ;
    input penable27;
    input pwrite27 ;
    input [31:0] pwdata27;
    output [31:0] prdata27;
    // mac27
    input macb3_wakeup27;
    input macb2_wakeup27;
    input macb1_wakeup27;
    input macb0_wakeup27;
    // Scan27 
    input scan_in27;
    input scan_en27;
    input scan_mode27;
    output scan_out27;
    // Module27 control27 outputs27
    input int_source_h27;
    // SMC27
    output rstn_non_srpg_smc27 ;
    output gate_clk_smc27   ;
    output isolate_smc27   ;
    output save_edge_smc27   ;
    output restore_edge_smc27   ;
    output pwr1_on_smc27   ;
    output pwr2_on_smc27   ;
    output pwr1_off_smc27  ;
    output pwr2_off_smc27  ;
    // URT27
    output rstn_non_srpg_urt27 ;
    output gate_clk_urt27      ;
    output isolate_urt27       ;
    output save_edge_urt27   ;
    output restore_edge_urt27   ;
    output pwr1_on_urt27       ;
    output pwr2_on_urt27       ;
    output pwr1_off_urt27      ;
    output pwr2_off_urt27      ;
    // ETH027
    output rstn_non_srpg_macb027 ;
    output gate_clk_macb027      ;
    output isolate_macb027       ;
    output save_edge_macb027   ;
    output restore_edge_macb027   ;
    output pwr1_on_macb027       ;
    output pwr2_on_macb027       ;
    output pwr1_off_macb027      ;
    output pwr2_off_macb027      ;
    // ETH127
    output rstn_non_srpg_macb127 ;
    output gate_clk_macb127      ;
    output isolate_macb127       ;
    output save_edge_macb127   ;
    output restore_edge_macb127   ;
    output pwr1_on_macb127       ;
    output pwr2_on_macb127       ;
    output pwr1_off_macb127      ;
    output pwr2_off_macb127      ;
    // ETH227
    output rstn_non_srpg_macb227 ;
    output gate_clk_macb227      ;
    output isolate_macb227       ;
    output save_edge_macb227   ;
    output restore_edge_macb227   ;
    output pwr1_on_macb227       ;
    output pwr2_on_macb227       ;
    output pwr1_off_macb227      ;
    output pwr2_off_macb227      ;
    // ETH327
    output rstn_non_srpg_macb327 ;
    output gate_clk_macb327      ;
    output isolate_macb327       ;
    output save_edge_macb327   ;
    output restore_edge_macb327   ;
    output pwr1_on_macb327       ;
    output pwr2_on_macb327       ;
    output pwr1_off_macb327      ;
    output pwr2_off_macb327      ;
    // DMA27
    output rstn_non_srpg_dma27 ;
    output gate_clk_dma27      ;
    output isolate_dma27       ;
    output save_edge_dma27   ;
    output restore_edge_dma27   ;
    output pwr1_on_dma27       ;
    output pwr2_on_dma27       ;
    output pwr1_off_dma27      ;
    output pwr2_off_dma27      ;
    // CPU27
    output rstn_non_srpg_cpu27 ;
    output gate_clk_cpu27      ;
    output isolate_cpu27       ;
    output save_edge_cpu27   ;
    output restore_edge_cpu27   ;
    output pwr1_on_cpu27       ;
    output pwr2_on_cpu27       ;
    output pwr1_off_cpu27      ;
    output pwr2_off_cpu27      ;
    // ALUT27
    output rstn_non_srpg_alut27 ;
    output gate_clk_alut27      ;
    output isolate_alut27       ;
    output save_edge_alut27   ;
    output restore_edge_alut27   ;
    output pwr1_on_alut27       ;
    output pwr2_on_alut27       ;
    output pwr1_off_alut27      ;
    output pwr2_off_alut27      ;
    // MEM27
    output rstn_non_srpg_mem27 ;
    output gate_clk_mem27      ;
    output isolate_mem27       ;
    output save_edge_mem27   ;
    output restore_edge_mem27   ;
    output pwr1_on_mem27       ;
    output pwr2_on_mem27       ;
    output pwr1_off_mem27      ;
    output pwr2_off_mem27      ;


   // core27 transitions27 o/p
    output core06v27;
    output core08v27;
    output core10v27;
    output core12v27;
    output pcm_macb_wakeup_int27 ;
    //mode mte27  signals27
    output mte_smc_start27;
    output mte_uart_start27;
    output mte_smc_uart_start27;  
    output mte_pm_smc_to_default_start27; 
    output mte_pm_uart_to_default_start27;
    output mte_pm_smc_uart_to_default_start27;

    reg mte_smc_start27;
    reg mte_uart_start27;
    reg mte_smc_uart_start27;  
    reg mte_pm_smc_to_default_start27; 
    reg mte_pm_uart_to_default_start27;
    reg mte_pm_smc_uart_to_default_start27;

    reg [31:0] prdata27;

  wire valid_reg_write27  ;
  wire valid_reg_read27   ;
  wire L1_ctrl_access27   ;
  wire L1_status_access27 ;
  wire pcm_int_mask_access27;
  wire pcm_int_status_access27;
  wire standby_mem027      ;
  wire standby_mem127      ;
  wire standby_mem227      ;
  wire standby_mem327      ;
  wire pwr1_off_mem027;
  wire pwr1_off_mem127;
  wire pwr1_off_mem227;
  wire pwr1_off_mem327;
  
  // Control27 signals27
  wire set_status_smc27   ;
  wire clr_status_smc27   ;
  wire set_status_urt27   ;
  wire clr_status_urt27   ;
  wire set_status_macb027   ;
  wire clr_status_macb027   ;
  wire set_status_macb127   ;
  wire clr_status_macb127   ;
  wire set_status_macb227   ;
  wire clr_status_macb227   ;
  wire set_status_macb327   ;
  wire clr_status_macb327   ;
  wire set_status_dma27   ;
  wire clr_status_dma27   ;
  wire set_status_cpu27   ;
  wire clr_status_cpu27   ;
  wire set_status_alut27   ;
  wire clr_status_alut27   ;
  wire set_status_mem27   ;
  wire clr_status_mem27   ;


  // Status and Control27 registers
  reg [31:0]  L1_status_reg27;
  reg  [31:0] L1_ctrl_reg27  ;
  reg  [31:0] L1_ctrl_domain27  ;
  reg L1_ctrl_cpu_off_reg27;
  reg [31:0]  pcm_mask_reg27;
  reg [31:0]  pcm_status_reg27;

  // Signals27 gated27 in scan_mode27
  //SMC27
  wire  rstn_non_srpg_smc_int27;
  wire  gate_clk_smc_int27    ;     
  wire  isolate_smc_int27    ;       
  wire save_edge_smc_int27;
  wire restore_edge_smc_int27;
  wire  pwr1_on_smc_int27    ;      
  wire  pwr2_on_smc_int27    ;      


  //URT27
  wire   rstn_non_srpg_urt_int27;
  wire   gate_clk_urt_int27     ;     
  wire   isolate_urt_int27      ;       
  wire save_edge_urt_int27;
  wire restore_edge_urt_int27;
  wire   pwr1_on_urt_int27      ;      
  wire   pwr2_on_urt_int27      ;      

  // ETH027
  wire   rstn_non_srpg_macb0_int27;
  wire   gate_clk_macb0_int27     ;     
  wire   isolate_macb0_int27      ;       
  wire save_edge_macb0_int27;
  wire restore_edge_macb0_int27;
  wire   pwr1_on_macb0_int27      ;      
  wire   pwr2_on_macb0_int27      ;      
  // ETH127
  wire   rstn_non_srpg_macb1_int27;
  wire   gate_clk_macb1_int27     ;     
  wire   isolate_macb1_int27      ;       
  wire save_edge_macb1_int27;
  wire restore_edge_macb1_int27;
  wire   pwr1_on_macb1_int27      ;      
  wire   pwr2_on_macb1_int27      ;      
  // ETH227
  wire   rstn_non_srpg_macb2_int27;
  wire   gate_clk_macb2_int27     ;     
  wire   isolate_macb2_int27      ;       
  wire save_edge_macb2_int27;
  wire restore_edge_macb2_int27;
  wire   pwr1_on_macb2_int27      ;      
  wire   pwr2_on_macb2_int27      ;      
  // ETH327
  wire   rstn_non_srpg_macb3_int27;
  wire   gate_clk_macb3_int27     ;     
  wire   isolate_macb3_int27      ;       
  wire save_edge_macb3_int27;
  wire restore_edge_macb3_int27;
  wire   pwr1_on_macb3_int27      ;      
  wire   pwr2_on_macb3_int27      ;      

  // DMA27
  wire   rstn_non_srpg_dma_int27;
  wire   gate_clk_dma_int27     ;     
  wire   isolate_dma_int27      ;       
  wire save_edge_dma_int27;
  wire restore_edge_dma_int27;
  wire   pwr1_on_dma_int27      ;      
  wire   pwr2_on_dma_int27      ;      

  // CPU27
  wire   rstn_non_srpg_cpu_int27;
  wire   gate_clk_cpu_int27     ;     
  wire   isolate_cpu_int27      ;       
  wire save_edge_cpu_int27;
  wire restore_edge_cpu_int27;
  wire   pwr1_on_cpu_int27      ;      
  wire   pwr2_on_cpu_int27      ;  
  wire L1_ctrl_cpu_off_p27;    

  reg save_alut_tmp27;
  // DFS27 sm27

  reg cpu_shutoff_ctrl27;

  reg mte_mac_off_start27, mte_mac012_start27, mte_mac013_start27, mte_mac023_start27, mte_mac123_start27;
  reg mte_mac01_start27, mte_mac02_start27, mte_mac03_start27, mte_mac12_start27, mte_mac13_start27, mte_mac23_start27;
  reg mte_mac0_start27, mte_mac1_start27, mte_mac2_start27, mte_mac3_start27;
  reg mte_sys_hibernate27 ;
  reg mte_dma_start27 ;
  reg mte_cpu_start27 ;
  reg mte_mac_off_sleep_start27, mte_mac012_sleep_start27, mte_mac013_sleep_start27, mte_mac023_sleep_start27, mte_mac123_sleep_start27;
  reg mte_mac01_sleep_start27, mte_mac02_sleep_start27, mte_mac03_sleep_start27, mte_mac12_sleep_start27, mte_mac13_sleep_start27, mte_mac23_sleep_start27;
  reg mte_mac0_sleep_start27, mte_mac1_sleep_start27, mte_mac2_sleep_start27, mte_mac3_sleep_start27;
  reg mte_dma_sleep_start27;
  reg mte_mac_off_to_default27, mte_mac012_to_default27, mte_mac013_to_default27, mte_mac023_to_default27, mte_mac123_to_default27;
  reg mte_mac01_to_default27, mte_mac02_to_default27, mte_mac03_to_default27, mte_mac12_to_default27, mte_mac13_to_default27, mte_mac23_to_default27;
  reg mte_mac0_to_default27, mte_mac1_to_default27, mte_mac2_to_default27, mte_mac3_to_default27;
  reg mte_dma_isolate_dis27;
  reg mte_cpu_isolate_dis27;
  reg mte_sys_hibernate_to_default27;


  // Latch27 the CPU27 SLEEP27 invocation27
  always @( posedge pclk27 or negedge nprst27) 
  begin
    if(!nprst27)
      L1_ctrl_cpu_off_reg27 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg27 <= L1_ctrl_domain27[8];
  end

  // Create27 a pulse27 for sleep27 detection27 
  assign L1_ctrl_cpu_off_p27 =  L1_ctrl_domain27[8] && !L1_ctrl_cpu_off_reg27;
  
  // CPU27 sleep27 contol27 logic 
  // Shut27 off27 CPU27 when L1_ctrl_cpu_off_p27 is set
  // wake27 cpu27 when any interrupt27 is seen27  
  always @( posedge pclk27 or negedge nprst27) 
  begin
    if(!nprst27)
     cpu_shutoff_ctrl27 <= 1'b0;
    else if(cpu_shutoff_ctrl27 && int_source_h27)
     cpu_shutoff_ctrl27 <= 1'b0;
    else if (L1_ctrl_cpu_off_p27)
     cpu_shutoff_ctrl27 <= 1'b1;
  end
 
  // instantiate27 power27 contol27  block for uart27
  power_ctrl_sm27 i_urt_power_ctrl_sm27(
    .pclk27(pclk27),
    .nprst27(nprst27),
    .L1_module_req27(L1_ctrl_domain27[1]),
    .set_status_module27(set_status_urt27),
    .clr_status_module27(clr_status_urt27),
    .rstn_non_srpg_module27(rstn_non_srpg_urt_int27),
    .gate_clk_module27(gate_clk_urt_int27),
    .isolate_module27(isolate_urt_int27),
    .save_edge27(save_edge_urt_int27),
    .restore_edge27(restore_edge_urt_int27),
    .pwr1_on27(pwr1_on_urt_int27),
    .pwr2_on27(pwr2_on_urt_int27)
    );
  

  // instantiate27 power27 contol27  block for smc27
  power_ctrl_sm27 i_smc_power_ctrl_sm27(
    .pclk27(pclk27),
    .nprst27(nprst27),
    .L1_module_req27(L1_ctrl_domain27[2]),
    .set_status_module27(set_status_smc27),
    .clr_status_module27(clr_status_smc27),
    .rstn_non_srpg_module27(rstn_non_srpg_smc_int27),
    .gate_clk_module27(gate_clk_smc_int27),
    .isolate_module27(isolate_smc_int27),
    .save_edge27(save_edge_smc_int27),
    .restore_edge27(restore_edge_smc_int27),
    .pwr1_on27(pwr1_on_smc_int27),
    .pwr2_on27(pwr2_on_smc_int27)
    );

  // power27 control27 for macb027
  power_ctrl_sm27 i_macb0_power_ctrl_sm27(
    .pclk27(pclk27),
    .nprst27(nprst27),
    .L1_module_req27(L1_ctrl_domain27[3]),
    .set_status_module27(set_status_macb027),
    .clr_status_module27(clr_status_macb027),
    .rstn_non_srpg_module27(rstn_non_srpg_macb0_int27),
    .gate_clk_module27(gate_clk_macb0_int27),
    .isolate_module27(isolate_macb0_int27),
    .save_edge27(save_edge_macb0_int27),
    .restore_edge27(restore_edge_macb0_int27),
    .pwr1_on27(pwr1_on_macb0_int27),
    .pwr2_on27(pwr2_on_macb0_int27)
    );
  // power27 control27 for macb127
  power_ctrl_sm27 i_macb1_power_ctrl_sm27(
    .pclk27(pclk27),
    .nprst27(nprst27),
    .L1_module_req27(L1_ctrl_domain27[4]),
    .set_status_module27(set_status_macb127),
    .clr_status_module27(clr_status_macb127),
    .rstn_non_srpg_module27(rstn_non_srpg_macb1_int27),
    .gate_clk_module27(gate_clk_macb1_int27),
    .isolate_module27(isolate_macb1_int27),
    .save_edge27(save_edge_macb1_int27),
    .restore_edge27(restore_edge_macb1_int27),
    .pwr1_on27(pwr1_on_macb1_int27),
    .pwr2_on27(pwr2_on_macb1_int27)
    );
  // power27 control27 for macb227
  power_ctrl_sm27 i_macb2_power_ctrl_sm27(
    .pclk27(pclk27),
    .nprst27(nprst27),
    .L1_module_req27(L1_ctrl_domain27[5]),
    .set_status_module27(set_status_macb227),
    .clr_status_module27(clr_status_macb227),
    .rstn_non_srpg_module27(rstn_non_srpg_macb2_int27),
    .gate_clk_module27(gate_clk_macb2_int27),
    .isolate_module27(isolate_macb2_int27),
    .save_edge27(save_edge_macb2_int27),
    .restore_edge27(restore_edge_macb2_int27),
    .pwr1_on27(pwr1_on_macb2_int27),
    .pwr2_on27(pwr2_on_macb2_int27)
    );
  // power27 control27 for macb327
  power_ctrl_sm27 i_macb3_power_ctrl_sm27(
    .pclk27(pclk27),
    .nprst27(nprst27),
    .L1_module_req27(L1_ctrl_domain27[6]),
    .set_status_module27(set_status_macb327),
    .clr_status_module27(clr_status_macb327),
    .rstn_non_srpg_module27(rstn_non_srpg_macb3_int27),
    .gate_clk_module27(gate_clk_macb3_int27),
    .isolate_module27(isolate_macb3_int27),
    .save_edge27(save_edge_macb3_int27),
    .restore_edge27(restore_edge_macb3_int27),
    .pwr1_on27(pwr1_on_macb3_int27),
    .pwr2_on27(pwr2_on_macb3_int27)
    );
  // power27 control27 for dma27
  power_ctrl_sm27 i_dma_power_ctrl_sm27(
    .pclk27(pclk27),
    .nprst27(nprst27),
    .L1_module_req27(L1_ctrl_domain27[7]),
    .set_status_module27(set_status_dma27),
    .clr_status_module27(clr_status_dma27),
    .rstn_non_srpg_module27(rstn_non_srpg_dma_int27),
    .gate_clk_module27(gate_clk_dma_int27),
    .isolate_module27(isolate_dma_int27),
    .save_edge27(save_edge_dma_int27),
    .restore_edge27(restore_edge_dma_int27),
    .pwr1_on27(pwr1_on_dma_int27),
    .pwr2_on27(pwr2_on_dma_int27)
    );
  // power27 control27 for CPU27
  power_ctrl_sm27 i_cpu_power_ctrl_sm27(
    .pclk27(pclk27),
    .nprst27(nprst27),
    .L1_module_req27(cpu_shutoff_ctrl27),
    .set_status_module27(set_status_cpu27),
    .clr_status_module27(clr_status_cpu27),
    .rstn_non_srpg_module27(rstn_non_srpg_cpu_int27),
    .gate_clk_module27(gate_clk_cpu_int27),
    .isolate_module27(isolate_cpu_int27),
    .save_edge27(save_edge_cpu_int27),
    .restore_edge27(restore_edge_cpu_int27),
    .pwr1_on27(pwr1_on_cpu_int27),
    .pwr2_on27(pwr2_on_cpu_int27)
    );

  assign valid_reg_write27 =  (psel27 && pwrite27 && penable27);
  assign valid_reg_read27  =  (psel27 && (!pwrite27) && penable27);

  assign L1_ctrl_access27  =  (paddr27[15:0] == 16'b0000000000000100); 
  assign L1_status_access27 = (paddr27[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access27 =   (paddr27[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access27 = (paddr27[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control27 and status register
  always @(*)
  begin  
    if(valid_reg_read27 && L1_ctrl_access27) 
      prdata27 = L1_ctrl_reg27;
    else if (valid_reg_read27 && L1_status_access27)
      prdata27 = L1_status_reg27;
    else if (valid_reg_read27 && pcm_int_mask_access27)
      prdata27 = pcm_mask_reg27;
    else if (valid_reg_read27 && pcm_int_status_access27)
      prdata27 = pcm_status_reg27;
    else 
      prdata27 = 0;
  end

  assign set_status_mem27 =  (set_status_macb027 && set_status_macb127 && set_status_macb227 &&
                            set_status_macb327 && set_status_dma27 && set_status_cpu27);

  assign clr_status_mem27 =  (clr_status_macb027 && clr_status_macb127 && clr_status_macb227 &&
                            clr_status_macb327 && clr_status_dma27 && clr_status_cpu27);

  assign set_status_alut27 = (set_status_macb027 && set_status_macb127 && set_status_macb227 && set_status_macb327);

  assign clr_status_alut27 = (clr_status_macb027 || clr_status_macb127 || clr_status_macb227  || clr_status_macb327);

  // Write accesses to the control27 and status register
 
  always @(posedge pclk27 or negedge nprst27)
  begin
    if (!nprst27) begin
      L1_ctrl_reg27   <= 0;
      L1_status_reg27 <= 0;
      pcm_mask_reg27 <= 0;
    end else begin
      // CTRL27 reg updates27
      if (valid_reg_write27 && L1_ctrl_access27) 
        L1_ctrl_reg27 <= pwdata27; // Writes27 to the ctrl27 reg
      if (valid_reg_write27 && pcm_int_mask_access27) 
        pcm_mask_reg27 <= pwdata27; // Writes27 to the ctrl27 reg

      if (set_status_urt27 == 1'b1)  
        L1_status_reg27[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt27 == 1'b1) 
        L1_status_reg27[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc27 == 1'b1) 
        L1_status_reg27[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc27 == 1'b1) 
        L1_status_reg27[2] <= 1'b0; // Clear the status bit

      if (set_status_macb027 == 1'b1)  
        L1_status_reg27[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb027 == 1'b1) 
        L1_status_reg27[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb127 == 1'b1)  
        L1_status_reg27[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb127 == 1'b1) 
        L1_status_reg27[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb227 == 1'b1)  
        L1_status_reg27[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb227 == 1'b1) 
        L1_status_reg27[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb327 == 1'b1)  
        L1_status_reg27[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb327 == 1'b1) 
        L1_status_reg27[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma27 == 1'b1)  
        L1_status_reg27[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma27 == 1'b1) 
        L1_status_reg27[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu27 == 1'b1)  
        L1_status_reg27[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu27 == 1'b1) 
        L1_status_reg27[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut27 == 1'b1)  
        L1_status_reg27[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut27 == 1'b1) 
        L1_status_reg27[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem27 == 1'b1)  
        L1_status_reg27[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem27 == 1'b1) 
        L1_status_reg27[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused27 bits of pcm_status_reg27 are tied27 to 0
  always @(posedge pclk27 or negedge nprst27)
  begin
    if (!nprst27)
      pcm_status_reg27[31:4] <= 'b0;
    else  
      pcm_status_reg27[31:4] <= pcm_status_reg27[31:4];
  end
  
  // interrupt27 only of h/w assisted27 wakeup
  // MAC27 3
  always @(posedge pclk27 or negedge nprst27)
  begin
    if(!nprst27)
      pcm_status_reg27[3] <= 1'b0;
    else if (valid_reg_write27 && pcm_int_status_access27) 
      pcm_status_reg27[3] <= pwdata27[3];
    else if (macb3_wakeup27 & ~pcm_mask_reg27[3])
      pcm_status_reg27[3] <= 1'b1;
    else if (valid_reg_read27 && pcm_int_status_access27) 
      pcm_status_reg27[3] <= 1'b0;
    else
      pcm_status_reg27[3] <= pcm_status_reg27[3];
  end  
   
  // MAC27 2
  always @(posedge pclk27 or negedge nprst27)
  begin
    if(!nprst27)
      pcm_status_reg27[2] <= 1'b0;
    else if (valid_reg_write27 && pcm_int_status_access27) 
      pcm_status_reg27[2] <= pwdata27[2];
    else if (macb2_wakeup27 & ~pcm_mask_reg27[2])
      pcm_status_reg27[2] <= 1'b1;
    else if (valid_reg_read27 && pcm_int_status_access27) 
      pcm_status_reg27[2] <= 1'b0;
    else
      pcm_status_reg27[2] <= pcm_status_reg27[2];
  end  

  // MAC27 1
  always @(posedge pclk27 or negedge nprst27)
  begin
    if(!nprst27)
      pcm_status_reg27[1] <= 1'b0;
    else if (valid_reg_write27 && pcm_int_status_access27) 
      pcm_status_reg27[1] <= pwdata27[1];
    else if (macb1_wakeup27 & ~pcm_mask_reg27[1])
      pcm_status_reg27[1] <= 1'b1;
    else if (valid_reg_read27 && pcm_int_status_access27) 
      pcm_status_reg27[1] <= 1'b0;
    else
      pcm_status_reg27[1] <= pcm_status_reg27[1];
  end  
   
  // MAC27 0
  always @(posedge pclk27 or negedge nprst27)
  begin
    if(!nprst27)
      pcm_status_reg27[0] <= 1'b0;
    else if (valid_reg_write27 && pcm_int_status_access27) 
      pcm_status_reg27[0] <= pwdata27[0];
    else if (macb0_wakeup27 & ~pcm_mask_reg27[0])
      pcm_status_reg27[0] <= 1'b1;
    else if (valid_reg_read27 && pcm_int_status_access27) 
      pcm_status_reg27[0] <= 1'b0;
    else
      pcm_status_reg27[0] <= pcm_status_reg27[0];
  end  

  assign pcm_macb_wakeup_int27 = |pcm_status_reg27;

  reg [31:0] L1_ctrl_reg127;
  always @(posedge pclk27 or negedge nprst27)
  begin
    if(!nprst27)
      L1_ctrl_reg127 <= 0;
    else
      L1_ctrl_reg127 <= L1_ctrl_reg27;
  end

  // Program27 mode decode
  always @(L1_ctrl_reg27 or L1_ctrl_reg127 or int_source_h27 or cpu_shutoff_ctrl27) begin
    mte_smc_start27 = 0;
    mte_uart_start27 = 0;
    mte_smc_uart_start27  = 0;
    mte_mac_off_start27  = 0;
    mte_mac012_start27 = 0;
    mte_mac013_start27 = 0;
    mte_mac023_start27 = 0;
    mte_mac123_start27 = 0;
    mte_mac01_start27 = 0;
    mte_mac02_start27 = 0;
    mte_mac03_start27 = 0;
    mte_mac12_start27 = 0;
    mte_mac13_start27 = 0;
    mte_mac23_start27 = 0;
    mte_mac0_start27 = 0;
    mte_mac1_start27 = 0;
    mte_mac2_start27 = 0;
    mte_mac3_start27 = 0;
    mte_sys_hibernate27 = 0 ;
    mte_dma_start27 = 0 ;
    mte_cpu_start27 = 0 ;

    mte_mac0_sleep_start27 = (L1_ctrl_reg27 ==  'h14) && (L1_ctrl_reg127 == 'h4 );
    mte_mac1_sleep_start27 = (L1_ctrl_reg27 ==  'h14) && (L1_ctrl_reg127 == 'h5 ); 
    mte_mac2_sleep_start27 = (L1_ctrl_reg27 ==  'h14) && (L1_ctrl_reg127 == 'h6 ); 
    mte_mac3_sleep_start27 = (L1_ctrl_reg27 ==  'h14) && (L1_ctrl_reg127 == 'h7 ); 
    mte_mac01_sleep_start27 = (L1_ctrl_reg27 ==  'h14) && (L1_ctrl_reg127 == 'h8 ); 
    mte_mac02_sleep_start27 = (L1_ctrl_reg27 ==  'h14) && (L1_ctrl_reg127 == 'h9 ); 
    mte_mac03_sleep_start27 = (L1_ctrl_reg27 ==  'h14) && (L1_ctrl_reg127 == 'hA ); 
    mte_mac12_sleep_start27 = (L1_ctrl_reg27 ==  'h14) && (L1_ctrl_reg127 == 'hB ); 
    mte_mac13_sleep_start27 = (L1_ctrl_reg27 ==  'h14) && (L1_ctrl_reg127 == 'hC ); 
    mte_mac23_sleep_start27 = (L1_ctrl_reg27 ==  'h14) && (L1_ctrl_reg127 == 'hD ); 
    mte_mac012_sleep_start27 = (L1_ctrl_reg27 ==  'h14) && (L1_ctrl_reg127 == 'hE ); 
    mte_mac013_sleep_start27 = (L1_ctrl_reg27 ==  'h14) && (L1_ctrl_reg127 == 'hF ); 
    mte_mac023_sleep_start27 = (L1_ctrl_reg27 ==  'h14) && (L1_ctrl_reg127 == 'h10 ); 
    mte_mac123_sleep_start27 = (L1_ctrl_reg27 ==  'h14) && (L1_ctrl_reg127 == 'h11 ); 
    mte_mac_off_sleep_start27 =  (L1_ctrl_reg27 == 'h14) && (L1_ctrl_reg127 == 'h12 );
    mte_dma_sleep_start27 =  (L1_ctrl_reg27 == 'h14) && (L1_ctrl_reg127 == 'h13 );

    mte_pm_uart_to_default_start27 = (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'h1);
    mte_pm_smc_to_default_start27 = (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'h2);
    mte_pm_smc_uart_to_default_start27 = (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'h3); 
    mte_mac0_to_default27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'h4); 
    mte_mac1_to_default27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'h5); 
    mte_mac2_to_default27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'h6); 
    mte_mac3_to_default27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'h7); 
    mte_mac01_to_default27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'h8); 
    mte_mac02_to_default27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'h9); 
    mte_mac03_to_default27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'hA); 
    mte_mac12_to_default27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'hB); 
    mte_mac13_to_default27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'hC); 
    mte_mac23_to_default27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'hD); 
    mte_mac012_to_default27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'hE); 
    mte_mac013_to_default27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'hF); 
    mte_mac023_to_default27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'h10); 
    mte_mac123_to_default27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'h11); 
    mte_mac_off_to_default27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'h12); 
    mte_dma_isolate_dis27 =  (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'h13); 
    mte_cpu_isolate_dis27 =  (int_source_h27) && (cpu_shutoff_ctrl27) && (L1_ctrl_reg27 != 'h15);
    mte_sys_hibernate_to_default27 = (L1_ctrl_reg27 == 32'h0) && (L1_ctrl_reg127 == 'h15); 

   
    if (L1_ctrl_reg127 == 'h0) begin // This27 check is to make mte_cpu_start27
                                   // is set only when you from default state 
      case (L1_ctrl_reg27)
        'h0 : L1_ctrl_domain27 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain27 = 32'h2; // PM_uart27
                mte_uart_start27 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain27 = 32'h4; // PM_smc27
                mte_smc_start27 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain27 = 32'h6; // PM_smc_uart27
                mte_smc_uart_start27 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain27 = 32'h8; //  PM_macb027
                mte_mac0_start27 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain27 = 32'h10; //  PM_macb127
                mte_mac1_start27 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain27 = 32'h20; //  PM_macb227
                mte_mac2_start27 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain27 = 32'h40; //  PM_macb327
                mte_mac3_start27 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain27 = 32'h18; //  PM_macb0127
                mte_mac01_start27 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain27 = 32'h28; //  PM_macb0227
                mte_mac02_start27 = 1;
              end
        'hA : begin  
                L1_ctrl_domain27 = 32'h48; //  PM_macb0327
                mte_mac03_start27 = 1;
              end
        'hB : begin  
                L1_ctrl_domain27 = 32'h30; //  PM_macb1227
                mte_mac12_start27 = 1;
              end
        'hC : begin  
                L1_ctrl_domain27 = 32'h50; //  PM_macb1327
                mte_mac13_start27 = 1;
              end
        'hD : begin  
                L1_ctrl_domain27 = 32'h60; //  PM_macb2327
                mte_mac23_start27 = 1;
              end
        'hE : begin  
                L1_ctrl_domain27 = 32'h38; //  PM_macb01227
                mte_mac012_start27 = 1;
              end
        'hF : begin  
                L1_ctrl_domain27 = 32'h58; //  PM_macb01327
                mte_mac013_start27 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain27 = 32'h68; //  PM_macb02327
                mte_mac023_start27 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain27 = 32'h70; //  PM_macb12327
                mte_mac123_start27 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain27 = 32'h78; //  PM_macb_off27
                mte_mac_off_start27 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain27 = 32'h80; //  PM_dma27
                mte_dma_start27 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain27 = 32'h100; //  PM_cpu_sleep27
                mte_cpu_start27 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain27 = 32'h1FE; //  PM_hibernate27
                mte_sys_hibernate27 = 1;
              end
         default: L1_ctrl_domain27 = 32'h0;
      endcase
    end
  end


  wire to_default27 = (L1_ctrl_reg27 == 0);

  // Scan27 mode gating27 of power27 and isolation27 control27 signals27
  //SMC27
  assign rstn_non_srpg_smc27  = (scan_mode27 == 1'b0) ? rstn_non_srpg_smc_int27 : 1'b1;  
  assign gate_clk_smc27       = (scan_mode27 == 1'b0) ? gate_clk_smc_int27 : 1'b0;     
  assign isolate_smc27        = (scan_mode27 == 1'b0) ? isolate_smc_int27 : 1'b0;      
  assign pwr1_on_smc27        = (scan_mode27 == 1'b0) ? pwr1_on_smc_int27 : 1'b1;       
  assign pwr2_on_smc27        = (scan_mode27 == 1'b0) ? pwr2_on_smc_int27 : 1'b1;       
  assign pwr1_off_smc27       = (scan_mode27 == 1'b0) ? (!pwr1_on_smc_int27) : 1'b0;       
  assign pwr2_off_smc27       = (scan_mode27 == 1'b0) ? (!pwr2_on_smc_int27) : 1'b0;       
  assign save_edge_smc27       = (scan_mode27 == 1'b0) ? (save_edge_smc_int27) : 1'b0;       
  assign restore_edge_smc27       = (scan_mode27 == 1'b0) ? (restore_edge_smc_int27) : 1'b0;       

  //URT27
  assign rstn_non_srpg_urt27  = (scan_mode27 == 1'b0) ?  rstn_non_srpg_urt_int27 : 1'b1;  
  assign gate_clk_urt27       = (scan_mode27 == 1'b0) ?  gate_clk_urt_int27      : 1'b0;     
  assign isolate_urt27        = (scan_mode27 == 1'b0) ?  isolate_urt_int27       : 1'b0;      
  assign pwr1_on_urt27        = (scan_mode27 == 1'b0) ?  pwr1_on_urt_int27       : 1'b1;       
  assign pwr2_on_urt27        = (scan_mode27 == 1'b0) ?  pwr2_on_urt_int27       : 1'b1;       
  assign pwr1_off_urt27       = (scan_mode27 == 1'b0) ?  (!pwr1_on_urt_int27)  : 1'b0;       
  assign pwr2_off_urt27       = (scan_mode27 == 1'b0) ?  (!pwr2_on_urt_int27)  : 1'b0;       
  assign save_edge_urt27       = (scan_mode27 == 1'b0) ? (save_edge_urt_int27) : 1'b0;       
  assign restore_edge_urt27       = (scan_mode27 == 1'b0) ? (restore_edge_urt_int27) : 1'b0;       

  //ETH027
  assign rstn_non_srpg_macb027 = (scan_mode27 == 1'b0) ?  rstn_non_srpg_macb0_int27 : 1'b1;  
  assign gate_clk_macb027       = (scan_mode27 == 1'b0) ?  gate_clk_macb0_int27      : 1'b0;     
  assign isolate_macb027        = (scan_mode27 == 1'b0) ?  isolate_macb0_int27       : 1'b0;      
  assign pwr1_on_macb027        = (scan_mode27 == 1'b0) ?  pwr1_on_macb0_int27       : 1'b1;       
  assign pwr2_on_macb027        = (scan_mode27 == 1'b0) ?  pwr2_on_macb0_int27       : 1'b1;       
  assign pwr1_off_macb027       = (scan_mode27 == 1'b0) ?  (!pwr1_on_macb0_int27)  : 1'b0;       
  assign pwr2_off_macb027       = (scan_mode27 == 1'b0) ?  (!pwr2_on_macb0_int27)  : 1'b0;       
  assign save_edge_macb027       = (scan_mode27 == 1'b0) ? (save_edge_macb0_int27) : 1'b0;       
  assign restore_edge_macb027       = (scan_mode27 == 1'b0) ? (restore_edge_macb0_int27) : 1'b0;       

  //ETH127
  assign rstn_non_srpg_macb127 = (scan_mode27 == 1'b0) ?  rstn_non_srpg_macb1_int27 : 1'b1;  
  assign gate_clk_macb127       = (scan_mode27 == 1'b0) ?  gate_clk_macb1_int27      : 1'b0;     
  assign isolate_macb127        = (scan_mode27 == 1'b0) ?  isolate_macb1_int27       : 1'b0;      
  assign pwr1_on_macb127        = (scan_mode27 == 1'b0) ?  pwr1_on_macb1_int27       : 1'b1;       
  assign pwr2_on_macb127        = (scan_mode27 == 1'b0) ?  pwr2_on_macb1_int27       : 1'b1;       
  assign pwr1_off_macb127       = (scan_mode27 == 1'b0) ?  (!pwr1_on_macb1_int27)  : 1'b0;       
  assign pwr2_off_macb127       = (scan_mode27 == 1'b0) ?  (!pwr2_on_macb1_int27)  : 1'b0;       
  assign save_edge_macb127       = (scan_mode27 == 1'b0) ? (save_edge_macb1_int27) : 1'b0;       
  assign restore_edge_macb127       = (scan_mode27 == 1'b0) ? (restore_edge_macb1_int27) : 1'b0;       

  //ETH227
  assign rstn_non_srpg_macb227 = (scan_mode27 == 1'b0) ?  rstn_non_srpg_macb2_int27 : 1'b1;  
  assign gate_clk_macb227       = (scan_mode27 == 1'b0) ?  gate_clk_macb2_int27      : 1'b0;     
  assign isolate_macb227        = (scan_mode27 == 1'b0) ?  isolate_macb2_int27       : 1'b0;      
  assign pwr1_on_macb227        = (scan_mode27 == 1'b0) ?  pwr1_on_macb2_int27       : 1'b1;       
  assign pwr2_on_macb227        = (scan_mode27 == 1'b0) ?  pwr2_on_macb2_int27       : 1'b1;       
  assign pwr1_off_macb227       = (scan_mode27 == 1'b0) ?  (!pwr1_on_macb2_int27)  : 1'b0;       
  assign pwr2_off_macb227       = (scan_mode27 == 1'b0) ?  (!pwr2_on_macb2_int27)  : 1'b0;       
  assign save_edge_macb227       = (scan_mode27 == 1'b0) ? (save_edge_macb2_int27) : 1'b0;       
  assign restore_edge_macb227       = (scan_mode27 == 1'b0) ? (restore_edge_macb2_int27) : 1'b0;       

  //ETH327
  assign rstn_non_srpg_macb327 = (scan_mode27 == 1'b0) ?  rstn_non_srpg_macb3_int27 : 1'b1;  
  assign gate_clk_macb327       = (scan_mode27 == 1'b0) ?  gate_clk_macb3_int27      : 1'b0;     
  assign isolate_macb327        = (scan_mode27 == 1'b0) ?  isolate_macb3_int27       : 1'b0;      
  assign pwr1_on_macb327        = (scan_mode27 == 1'b0) ?  pwr1_on_macb3_int27       : 1'b1;       
  assign pwr2_on_macb327        = (scan_mode27 == 1'b0) ?  pwr2_on_macb3_int27       : 1'b1;       
  assign pwr1_off_macb327       = (scan_mode27 == 1'b0) ?  (!pwr1_on_macb3_int27)  : 1'b0;       
  assign pwr2_off_macb327       = (scan_mode27 == 1'b0) ?  (!pwr2_on_macb3_int27)  : 1'b0;       
  assign save_edge_macb327       = (scan_mode27 == 1'b0) ? (save_edge_macb3_int27) : 1'b0;       
  assign restore_edge_macb327       = (scan_mode27 == 1'b0) ? (restore_edge_macb3_int27) : 1'b0;       

  // MEM27
  assign rstn_non_srpg_mem27 =   (rstn_non_srpg_macb027 && rstn_non_srpg_macb127 && rstn_non_srpg_macb227 &&
                                rstn_non_srpg_macb327 && rstn_non_srpg_dma27 && rstn_non_srpg_cpu27 && rstn_non_srpg_urt27 &&
                                rstn_non_srpg_smc27);

  assign gate_clk_mem27 =  (gate_clk_macb027 && gate_clk_macb127 && gate_clk_macb227 &&
                            gate_clk_macb327 && gate_clk_dma27 && gate_clk_cpu27 && gate_clk_urt27 && gate_clk_smc27);

  assign isolate_mem27  = (isolate_macb027 && isolate_macb127 && isolate_macb227 &&
                         isolate_macb327 && isolate_dma27 && isolate_cpu27 && isolate_urt27 && isolate_smc27);


  assign pwr1_on_mem27        =   ~pwr1_off_mem27;

  assign pwr2_on_mem27        =   ~pwr2_off_mem27;

  assign pwr1_off_mem27       =  (pwr1_off_macb027 && pwr1_off_macb127 && pwr1_off_macb227 &&
                                 pwr1_off_macb327 && pwr1_off_dma27 && pwr1_off_cpu27 && pwr1_off_urt27 && pwr1_off_smc27);


  assign pwr2_off_mem27       =  (pwr2_off_macb027 && pwr2_off_macb127 && pwr2_off_macb227 &&
                                pwr2_off_macb327 && pwr2_off_dma27 && pwr2_off_cpu27 && pwr2_off_urt27 && pwr2_off_smc27);

  assign save_edge_mem27      =  (save_edge_macb027 && save_edge_macb127 && save_edge_macb227 &&
                                save_edge_macb327 && save_edge_dma27 && save_edge_cpu27 && save_edge_smc27 && save_edge_urt27);

  assign restore_edge_mem27   =  (restore_edge_macb027 && restore_edge_macb127 && restore_edge_macb227  &&
                                restore_edge_macb327 && restore_edge_dma27 && restore_edge_cpu27 && restore_edge_urt27 &&
                                restore_edge_smc27);

  assign standby_mem027 = pwr1_off_macb027 && (~ (pwr1_off_macb027 && pwr1_off_macb127 && pwr1_off_macb227 && pwr1_off_macb327 && pwr1_off_urt27 && pwr1_off_smc27 && pwr1_off_dma27 && pwr1_off_cpu27));
  assign standby_mem127 = pwr1_off_macb127 && (~ (pwr1_off_macb027 && pwr1_off_macb127 && pwr1_off_macb227 && pwr1_off_macb327 && pwr1_off_urt27 && pwr1_off_smc27 && pwr1_off_dma27 && pwr1_off_cpu27));
  assign standby_mem227 = pwr1_off_macb227 && (~ (pwr1_off_macb027 && pwr1_off_macb127 && pwr1_off_macb227 && pwr1_off_macb327 && pwr1_off_urt27 && pwr1_off_smc27 && pwr1_off_dma27 && pwr1_off_cpu27));
  assign standby_mem327 = pwr1_off_macb327 && (~ (pwr1_off_macb027 && pwr1_off_macb127 && pwr1_off_macb227 && pwr1_off_macb327 && pwr1_off_urt27 && pwr1_off_smc27 && pwr1_off_dma27 && pwr1_off_cpu27));

  assign pwr1_off_mem027 = pwr1_off_mem27;
  assign pwr1_off_mem127 = pwr1_off_mem27;
  assign pwr1_off_mem227 = pwr1_off_mem27;
  assign pwr1_off_mem327 = pwr1_off_mem27;

  assign rstn_non_srpg_alut27  =  (rstn_non_srpg_macb027 && rstn_non_srpg_macb127 && rstn_non_srpg_macb227 && rstn_non_srpg_macb327);


   assign gate_clk_alut27       =  (gate_clk_macb027 && gate_clk_macb127 && gate_clk_macb227 && gate_clk_macb327);


    assign isolate_alut27        =  (isolate_macb027 && isolate_macb127 && isolate_macb227 && isolate_macb327);


    assign pwr1_on_alut27        =  (pwr1_on_macb027 || pwr1_on_macb127 || pwr1_on_macb227 || pwr1_on_macb327);


    assign pwr2_on_alut27        =  (pwr2_on_macb027 || pwr2_on_macb127 || pwr2_on_macb227 || pwr2_on_macb327);


    assign pwr1_off_alut27       =  (pwr1_off_macb027 && pwr1_off_macb127 && pwr1_off_macb227 && pwr1_off_macb327);


    assign pwr2_off_alut27       =  (pwr2_off_macb027 && pwr2_off_macb127 && pwr2_off_macb227 && pwr2_off_macb327);


    assign save_edge_alut27      =  (save_edge_macb027 && save_edge_macb127 && save_edge_macb227 && save_edge_macb327);


    assign restore_edge_alut27   =  (restore_edge_macb027 || restore_edge_macb127 || restore_edge_macb227 ||
                                   restore_edge_macb327) && save_alut_tmp27;

     // alut27 power27 off27 detection27
  always @(posedge pclk27 or negedge nprst27) begin
    if (!nprst27) 
       save_alut_tmp27 <= 0;
    else if (restore_edge_alut27)
       save_alut_tmp27 <= 0;
    else if (save_edge_alut27)
       save_alut_tmp27 <= 1;
  end

  //DMA27
  assign rstn_non_srpg_dma27 = (scan_mode27 == 1'b0) ?  rstn_non_srpg_dma_int27 : 1'b1;  
  assign gate_clk_dma27       = (scan_mode27 == 1'b0) ?  gate_clk_dma_int27      : 1'b0;     
  assign isolate_dma27        = (scan_mode27 == 1'b0) ?  isolate_dma_int27       : 1'b0;      
  assign pwr1_on_dma27        = (scan_mode27 == 1'b0) ?  pwr1_on_dma_int27       : 1'b1;       
  assign pwr2_on_dma27        = (scan_mode27 == 1'b0) ?  pwr2_on_dma_int27       : 1'b1;       
  assign pwr1_off_dma27       = (scan_mode27 == 1'b0) ?  (!pwr1_on_dma_int27)  : 1'b0;       
  assign pwr2_off_dma27       = (scan_mode27 == 1'b0) ?  (!pwr2_on_dma_int27)  : 1'b0;       
  assign save_edge_dma27       = (scan_mode27 == 1'b0) ? (save_edge_dma_int27) : 1'b0;       
  assign restore_edge_dma27       = (scan_mode27 == 1'b0) ? (restore_edge_dma_int27) : 1'b0;       

  //CPU27
  assign rstn_non_srpg_cpu27 = (scan_mode27 == 1'b0) ?  rstn_non_srpg_cpu_int27 : 1'b1;  
  assign gate_clk_cpu27       = (scan_mode27 == 1'b0) ?  gate_clk_cpu_int27      : 1'b0;     
  assign isolate_cpu27        = (scan_mode27 == 1'b0) ?  isolate_cpu_int27       : 1'b0;      
  assign pwr1_on_cpu27        = (scan_mode27 == 1'b0) ?  pwr1_on_cpu_int27       : 1'b1;       
  assign pwr2_on_cpu27        = (scan_mode27 == 1'b0) ?  pwr2_on_cpu_int27       : 1'b1;       
  assign pwr1_off_cpu27       = (scan_mode27 == 1'b0) ?  (!pwr1_on_cpu_int27)  : 1'b0;       
  assign pwr2_off_cpu27       = (scan_mode27 == 1'b0) ?  (!pwr2_on_cpu_int27)  : 1'b0;       
  assign save_edge_cpu27       = (scan_mode27 == 1'b0) ? (save_edge_cpu_int27) : 1'b0;       
  assign restore_edge_cpu27       = (scan_mode27 == 1'b0) ? (restore_edge_cpu_int27) : 1'b0;       



  // ASE27

   reg ase_core_12v27, ase_core_10v27, ase_core_08v27, ase_core_06v27;
   reg ase_macb0_12v27,ase_macb1_12v27,ase_macb2_12v27,ase_macb3_12v27;

    // core27 ase27

    // core27 at 1.0 v if (smc27 off27, urt27 off27, macb027 off27, macb127 off27, macb227 off27, macb327 off27
   // core27 at 0.8v if (mac01off27, macb02off27, macb03off27, macb12off27, mac13off27, mac23off27,
   // core27 at 0.6v if (mac012off27, mac013off27, mac023off27, mac123off27, mac0123off27
    // else core27 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb027 && pwr1_off_macb127 && pwr1_off_macb227 && pwr1_off_macb327) || // all mac27 off27
       (pwr1_off_macb327 && pwr1_off_macb227 && pwr1_off_macb127) || // mac123off27 
       (pwr1_off_macb327 && pwr1_off_macb227 && pwr1_off_macb027) || // mac023off27 
       (pwr1_off_macb327 && pwr1_off_macb127 && pwr1_off_macb027) || // mac013off27 
       (pwr1_off_macb227 && pwr1_off_macb127 && pwr1_off_macb027) )  // mac012off27 
       begin
         ase_core_12v27 = 0;
         ase_core_10v27 = 0;
         ase_core_08v27 = 0;
         ase_core_06v27 = 1;
       end
     else if( (pwr1_off_macb227 && pwr1_off_macb327) || // mac2327 off27
         (pwr1_off_macb327 && pwr1_off_macb127) || // mac13off27 
         (pwr1_off_macb127 && pwr1_off_macb227) || // mac12off27 
         (pwr1_off_macb327 && pwr1_off_macb027) || // mac03off27 
         (pwr1_off_macb227 && pwr1_off_macb027) || // mac02off27 
         (pwr1_off_macb127 && pwr1_off_macb027))  // mac01off27 
       begin
         ase_core_12v27 = 0;
         ase_core_10v27 = 0;
         ase_core_08v27 = 1;
         ase_core_06v27 = 0;
       end
     else if( (pwr1_off_smc27) || // smc27 off27
         (pwr1_off_macb027 ) || // mac0off27 
         (pwr1_off_macb127 ) || // mac1off27 
         (pwr1_off_macb227 ) || // mac2off27 
         (pwr1_off_macb327 ))  // mac3off27 
       begin
         ase_core_12v27 = 0;
         ase_core_10v27 = 1;
         ase_core_08v27 = 0;
         ase_core_06v27 = 0;
       end
     else if (pwr1_off_urt27)
       begin
         ase_core_12v27 = 1;
         ase_core_10v27 = 0;
         ase_core_08v27 = 0;
         ase_core_06v27 = 0;
       end
     else
       begin
         ase_core_12v27 = 1;
         ase_core_10v27 = 0;
         ase_core_08v27 = 0;
         ase_core_06v27 = 0;
       end
   end


   // cpu27
   // cpu27 @ 1.0v when macoff27, 
   // 
   reg ase_cpu_10v27, ase_cpu_12v27;
   always @(*) begin
    if(pwr1_off_cpu27) begin
     ase_cpu_12v27 = 1'b0;
     ase_cpu_10v27 = 1'b0;
    end
    else if(pwr1_off_macb027 || pwr1_off_macb127 || pwr1_off_macb227 || pwr1_off_macb327)
    begin
     ase_cpu_12v27 = 1'b0;
     ase_cpu_10v27 = 1'b1;
    end
    else
    begin
     ase_cpu_12v27 = 1'b1;
     ase_cpu_10v27 = 1'b0;
    end
   end

   // dma27
   // dma27 @v127.0 for macoff27, 

   reg ase_dma_10v27, ase_dma_12v27;
   always @(*) begin
    if(pwr1_off_dma27) begin
     ase_dma_12v27 = 1'b0;
     ase_dma_10v27 = 1'b0;
    end
    else if(pwr1_off_macb027 || pwr1_off_macb127 || pwr1_off_macb227 || pwr1_off_macb327)
    begin
     ase_dma_12v27 = 1'b0;
     ase_dma_10v27 = 1'b1;
    end
    else
    begin
     ase_dma_12v27 = 1'b1;
     ase_dma_10v27 = 1'b0;
    end
   end

   // alut27
   // @ v127.0 for macoff27

   reg ase_alut_10v27, ase_alut_12v27;
   always @(*) begin
    if(pwr1_off_alut27) begin
     ase_alut_12v27 = 1'b0;
     ase_alut_10v27 = 1'b0;
    end
    else if(pwr1_off_macb027 || pwr1_off_macb127 || pwr1_off_macb227 || pwr1_off_macb327)
    begin
     ase_alut_12v27 = 1'b0;
     ase_alut_10v27 = 1'b1;
    end
    else
    begin
     ase_alut_12v27 = 1'b1;
     ase_alut_10v27 = 1'b0;
    end
   end




   reg ase_uart_12v27;
   reg ase_uart_10v27;
   reg ase_uart_08v27;
   reg ase_uart_06v27;

   reg ase_smc_12v27;


   always @(*) begin
     if(pwr1_off_urt27) begin // uart27 off27
       ase_uart_08v27 = 1'b0;
       ase_uart_06v27 = 1'b0;
       ase_uart_10v27 = 1'b0;
       ase_uart_12v27 = 1'b0;
     end 
     else if( (pwr1_off_macb027 && pwr1_off_macb127 && pwr1_off_macb227 && pwr1_off_macb327) || // all mac27 off27
       (pwr1_off_macb327 && pwr1_off_macb227 && pwr1_off_macb127) || // mac123off27 
       (pwr1_off_macb327 && pwr1_off_macb227 && pwr1_off_macb027) || // mac023off27 
       (pwr1_off_macb327 && pwr1_off_macb127 && pwr1_off_macb027) || // mac013off27 
       (pwr1_off_macb227 && pwr1_off_macb127 && pwr1_off_macb027) )  // mac012off27 
     begin
       ase_uart_06v27 = 1'b1;
       ase_uart_08v27 = 1'b0;
       ase_uart_10v27 = 1'b0;
       ase_uart_12v27 = 1'b0;
     end
     else if( (pwr1_off_macb227 && pwr1_off_macb327) || // mac2327 off27
         (pwr1_off_macb327 && pwr1_off_macb127) || // mac13off27 
         (pwr1_off_macb127 && pwr1_off_macb227) || // mac12off27 
         (pwr1_off_macb327 && pwr1_off_macb027) || // mac03off27 
         (pwr1_off_macb127 && pwr1_off_macb027))  // mac01off27  
     begin
       ase_uart_06v27 = 1'b0;
       ase_uart_08v27 = 1'b1;
       ase_uart_10v27 = 1'b0;
       ase_uart_12v27 = 1'b0;
     end
     else if (pwr1_off_smc27 || pwr1_off_macb027 || pwr1_off_macb127 || pwr1_off_macb227 || pwr1_off_macb327) begin // smc27 off27
       ase_uart_08v27 = 1'b0;
       ase_uart_06v27 = 1'b0;
       ase_uart_10v27 = 1'b1;
       ase_uart_12v27 = 1'b0;
     end 
     else begin
       ase_uart_08v27 = 1'b0;
       ase_uart_06v27 = 1'b0;
       ase_uart_10v27 = 1'b0;
       ase_uart_12v27 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc27) begin
     if (pwr1_off_smc27)  // smc27 off27
       ase_smc_12v27 = 1'b0;
    else
       ase_smc_12v27 = 1'b1;
   end

   
   always @(pwr1_off_macb027) begin
     if (pwr1_off_macb027) // macb027 off27
       ase_macb0_12v27 = 1'b0;
     else
       ase_macb0_12v27 = 1'b1;
   end

   always @(pwr1_off_macb127) begin
     if (pwr1_off_macb127) // macb127 off27
       ase_macb1_12v27 = 1'b0;
     else
       ase_macb1_12v27 = 1'b1;
   end

   always @(pwr1_off_macb227) begin // macb227 off27
     if (pwr1_off_macb227) // macb227 off27
       ase_macb2_12v27 = 1'b0;
     else
       ase_macb2_12v27 = 1'b1;
   end

   always @(pwr1_off_macb327) begin // macb327 off27
     if (pwr1_off_macb327) // macb327 off27
       ase_macb3_12v27 = 1'b0;
     else
       ase_macb3_12v27 = 1'b1;
   end


   // core27 voltage27 for vco27
  assign core12v27 = ase_macb0_12v27 & ase_macb1_12v27 & ase_macb2_12v27 & ase_macb3_12v27;

  assign core10v27 =  (ase_macb0_12v27 & ase_macb1_12v27 & ase_macb2_12v27 & (!ase_macb3_12v27)) ||
                    (ase_macb0_12v27 & ase_macb1_12v27 & (!ase_macb2_12v27) & ase_macb3_12v27) ||
                    (ase_macb0_12v27 & (!ase_macb1_12v27) & ase_macb2_12v27 & ase_macb3_12v27) ||
                    ((!ase_macb0_12v27) & ase_macb1_12v27 & ase_macb2_12v27 & ase_macb3_12v27);

  assign core08v27 =  ((!ase_macb0_12v27) & (!ase_macb1_12v27) & (ase_macb2_12v27) & (ase_macb3_12v27)) ||
                    ((!ase_macb0_12v27) & (ase_macb1_12v27) & (!ase_macb2_12v27) & (ase_macb3_12v27)) ||
                    ((!ase_macb0_12v27) & (ase_macb1_12v27) & (ase_macb2_12v27) & (!ase_macb3_12v27)) ||
                    ((ase_macb0_12v27) & (!ase_macb1_12v27) & (!ase_macb2_12v27) & (ase_macb3_12v27)) ||
                    ((ase_macb0_12v27) & (!ase_macb1_12v27) & (ase_macb2_12v27) & (!ase_macb3_12v27)) ||
                    ((ase_macb0_12v27) & (ase_macb1_12v27) & (!ase_macb2_12v27) & (!ase_macb3_12v27));

  assign core06v27 =  ((!ase_macb0_12v27) & (!ase_macb1_12v27) & (!ase_macb2_12v27) & (ase_macb3_12v27)) ||
                    ((!ase_macb0_12v27) & (!ase_macb1_12v27) & (ase_macb2_12v27) & (!ase_macb3_12v27)) ||
                    ((!ase_macb0_12v27) & (ase_macb1_12v27) & (!ase_macb2_12v27) & (!ase_macb3_12v27)) ||
                    ((ase_macb0_12v27) & (!ase_macb1_12v27) & (!ase_macb2_12v27) & (!ase_macb3_12v27)) ||
                    ((!ase_macb0_12v27) & (!ase_macb1_12v27) & (!ase_macb2_12v27) & (!ase_macb3_12v27)) ;



`ifdef LP_ABV_ON27
// psl27 default clock27 = (posedge pclk27);

// Cover27 a condition in which SMC27 is powered27 down
// and again27 powered27 up while UART27 is going27 into POWER27 down
// state or UART27 is already in POWER27 DOWN27 state
// psl27 cover_overlapping_smc_urt_127:
//    cover{fell27(pwr1_on_urt27);[*];fell27(pwr1_on_smc27);[*];
//    rose27(pwr1_on_smc27);[*];rose27(pwr1_on_urt27)};
//
// Cover27 a condition in which UART27 is powered27 down
// and again27 powered27 up while SMC27 is going27 into POWER27 down
// state or SMC27 is already in POWER27 DOWN27 state
// psl27 cover_overlapping_smc_urt_227:
//    cover{fell27(pwr1_on_smc27);[*];fell27(pwr1_on_urt27);[*];
//    rose27(pwr1_on_urt27);[*];rose27(pwr1_on_smc27)};
//


// Power27 Down27 UART27
// This27 gets27 triggered on rising27 edge of Gate27 signal27 for
// UART27 (gate_clk_urt27). In a next cycle after gate_clk_urt27,
// Isolate27 UART27(isolate_urt27) signal27 become27 HIGH27 (active).
// In 2nd cycle after gate_clk_urt27 becomes HIGH27, RESET27 for NON27
// SRPG27 FFs27(rstn_non_srpg_urt27) and POWER127 for UART27(pwr1_on_urt27) should 
// go27 LOW27. 
// This27 completes27 a POWER27 DOWN27. 

sequence s_power_down_urt27;
      (gate_clk_urt27 & !isolate_urt27 & rstn_non_srpg_urt27 & pwr1_on_urt27) 
  ##1 (gate_clk_urt27 & isolate_urt27 & rstn_non_srpg_urt27 & pwr1_on_urt27) 
  ##3 (gate_clk_urt27 & isolate_urt27 & !rstn_non_srpg_urt27 & !pwr1_on_urt27);
endsequence


property p_power_down_urt27;
   @(posedge pclk27)
    $rose(gate_clk_urt27) |=> s_power_down_urt27;
endproperty

output_power_down_urt27:
  assert property (p_power_down_urt27);


// Power27 UP27 UART27
// Sequence starts with , Rising27 edge of pwr1_on_urt27.
// Two27 clock27 cycle after this, isolate_urt27 should become27 LOW27 
// On27 the following27 clk27 gate_clk_urt27 should go27 low27.
// 5 cycles27 after  Rising27 edge of pwr1_on_urt27, rstn_non_srpg_urt27
// should become27 HIGH27
sequence s_power_up_urt27;
##30 (pwr1_on_urt27 & !isolate_urt27 & gate_clk_urt27 & !rstn_non_srpg_urt27) 
##1 (pwr1_on_urt27 & !isolate_urt27 & !gate_clk_urt27 & !rstn_non_srpg_urt27) 
##2 (pwr1_on_urt27 & !isolate_urt27 & !gate_clk_urt27 & rstn_non_srpg_urt27);
endsequence

property p_power_up_urt27;
   @(posedge pclk27)
  disable iff(!nprst27)
    (!pwr1_on_urt27 ##1 pwr1_on_urt27) |=> s_power_up_urt27;
endproperty

output_power_up_urt27:
  assert property (p_power_up_urt27);


// Power27 Down27 SMC27
// This27 gets27 triggered on rising27 edge of Gate27 signal27 for
// SMC27 (gate_clk_smc27). In a next cycle after gate_clk_smc27,
// Isolate27 SMC27(isolate_smc27) signal27 become27 HIGH27 (active).
// In 2nd cycle after gate_clk_smc27 becomes HIGH27, RESET27 for NON27
// SRPG27 FFs27(rstn_non_srpg_smc27) and POWER127 for SMC27(pwr1_on_smc27) should 
// go27 LOW27. 
// This27 completes27 a POWER27 DOWN27. 

sequence s_power_down_smc27;
      (gate_clk_smc27 & !isolate_smc27 & rstn_non_srpg_smc27 & pwr1_on_smc27) 
  ##1 (gate_clk_smc27 & isolate_smc27 & rstn_non_srpg_smc27 & pwr1_on_smc27) 
  ##3 (gate_clk_smc27 & isolate_smc27 & !rstn_non_srpg_smc27 & !pwr1_on_smc27);
endsequence


property p_power_down_smc27;
   @(posedge pclk27)
    $rose(gate_clk_smc27) |=> s_power_down_smc27;
endproperty

output_power_down_smc27:
  assert property (p_power_down_smc27);


// Power27 UP27 SMC27
// Sequence starts with , Rising27 edge of pwr1_on_smc27.
// Two27 clock27 cycle after this, isolate_smc27 should become27 LOW27 
// On27 the following27 clk27 gate_clk_smc27 should go27 low27.
// 5 cycles27 after  Rising27 edge of pwr1_on_smc27, rstn_non_srpg_smc27
// should become27 HIGH27
sequence s_power_up_smc27;
##30 (pwr1_on_smc27 & !isolate_smc27 & gate_clk_smc27 & !rstn_non_srpg_smc27) 
##1 (pwr1_on_smc27 & !isolate_smc27 & !gate_clk_smc27 & !rstn_non_srpg_smc27) 
##2 (pwr1_on_smc27 & !isolate_smc27 & !gate_clk_smc27 & rstn_non_srpg_smc27);
endsequence

property p_power_up_smc27;
   @(posedge pclk27)
  disable iff(!nprst27)
    (!pwr1_on_smc27 ##1 pwr1_on_smc27) |=> s_power_up_smc27;
endproperty

output_power_up_smc27:
  assert property (p_power_up_smc27);


// COVER27 SMC27 POWER27 DOWN27 AND27 UP27
cover_power_down_up_smc27: cover property (@(posedge pclk27)
(s_power_down_smc27 ##[5:180] s_power_up_smc27));



// COVER27 UART27 POWER27 DOWN27 AND27 UP27
cover_power_down_up_urt27: cover property (@(posedge pclk27)
(s_power_down_urt27 ##[5:180] s_power_up_urt27));

cover_power_down_urt27: cover property (@(posedge pclk27)
(s_power_down_urt27));

cover_power_up_urt27: cover property (@(posedge pclk27)
(s_power_up_urt27));




`ifdef PCM_ABV_ON27
//------------------------------------------------------------------------------
// Power27 Controller27 Formal27 Verification27 component.  Each power27 domain has a 
// separate27 instantiation27
//------------------------------------------------------------------------------

// need to assume that CPU27 will leave27 a minimum time between powering27 down and 
// back up.  In this example27, 10clks has been selected.
// psl27 config_min_uart_pd_time27 : assume always {rose27(L1_ctrl_domain27[1])} |-> { L1_ctrl_domain27[1][*10] } abort27(~nprst27);
// psl27 config_min_uart_pu_time27 : assume always {fell27(L1_ctrl_domain27[1])} |-> { !L1_ctrl_domain27[1][*10] } abort27(~nprst27);
// psl27 config_min_smc_pd_time27 : assume always {rose27(L1_ctrl_domain27[2])} |-> { L1_ctrl_domain27[2][*10] } abort27(~nprst27);
// psl27 config_min_smc_pu_time27 : assume always {fell27(L1_ctrl_domain27[2])} |-> { !L1_ctrl_domain27[2][*10] } abort27(~nprst27);

// UART27 VCOMP27 parameters27
   defparam i_uart_vcomp_domain27.ENABLE_SAVE_RESTORE_EDGE27   = 1;
   defparam i_uart_vcomp_domain27.ENABLE_EXT_PWR_CNTRL27       = 1;
   defparam i_uart_vcomp_domain27.REF_CLK_DEFINED27            = 0;
   defparam i_uart_vcomp_domain27.MIN_SHUTOFF_CYCLES27         = 4;
   defparam i_uart_vcomp_domain27.MIN_RESTORE_TO_ISO_CYCLES27  = 0;
   defparam i_uart_vcomp_domain27.MIN_SAVE_TO_SHUTOFF_CYCLES27 = 1;


   vcomp_domain27 i_uart_vcomp_domain27
   ( .ref_clk27(pclk27),
     .start_lps27(L1_ctrl_domain27[1] || !rstn_non_srpg_urt27),
     .rst_n27(nprst27),
     .ext_power_down27(L1_ctrl_domain27[1]),
     .iso_en27(isolate_urt27),
     .save_edge27(save_edge_urt27),
     .restore_edge27(restore_edge_urt27),
     .domain_shut_off27(pwr1_off_urt27),
     .domain_clk27(!gate_clk_urt27 && pclk27)
   );


// SMC27 VCOMP27 parameters27
   defparam i_smc_vcomp_domain27.ENABLE_SAVE_RESTORE_EDGE27   = 1;
   defparam i_smc_vcomp_domain27.ENABLE_EXT_PWR_CNTRL27       = 1;
   defparam i_smc_vcomp_domain27.REF_CLK_DEFINED27            = 0;
   defparam i_smc_vcomp_domain27.MIN_SHUTOFF_CYCLES27         = 4;
   defparam i_smc_vcomp_domain27.MIN_RESTORE_TO_ISO_CYCLES27  = 0;
   defparam i_smc_vcomp_domain27.MIN_SAVE_TO_SHUTOFF_CYCLES27 = 1;


   vcomp_domain27 i_smc_vcomp_domain27
   ( .ref_clk27(pclk27),
     .start_lps27(L1_ctrl_domain27[2] || !rstn_non_srpg_smc27),
     .rst_n27(nprst27),
     .ext_power_down27(L1_ctrl_domain27[2]),
     .iso_en27(isolate_smc27),
     .save_edge27(save_edge_smc27),
     .restore_edge27(restore_edge_smc27),
     .domain_shut_off27(pwr1_off_smc27),
     .domain_clk27(!gate_clk_smc27 && pclk27)
   );

`endif

`endif



endmodule
