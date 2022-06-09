//File28 name   : power_ctrl28.v
//Title28       : Power28 Control28 Module28
//Created28     : 1999
//Description28 : Top28 level of power28 controller28
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

module power_ctrl28 (


    // Clocks28 & Reset28
    pclk28,
    nprst28,
    // APB28 programming28 interface
    paddr28,
    psel28,
    penable28,
    pwrite28,
    pwdata28,
    prdata28,
    // mac28 i/f,
    macb3_wakeup28,
    macb2_wakeup28,
    macb1_wakeup28,
    macb0_wakeup28,
    // Scan28 
    scan_in28,
    scan_en28,
    scan_mode28,
    scan_out28,
    // Module28 control28 outputs28
    int_source_h28,
    // SMC28
    rstn_non_srpg_smc28,
    gate_clk_smc28,
    isolate_smc28,
    save_edge_smc28,
    restore_edge_smc28,
    pwr1_on_smc28,
    pwr2_on_smc28,
    pwr1_off_smc28,
    pwr2_off_smc28,
    // URT28
    rstn_non_srpg_urt28,
    gate_clk_urt28,
    isolate_urt28,
    save_edge_urt28,
    restore_edge_urt28,
    pwr1_on_urt28,
    pwr2_on_urt28,
    pwr1_off_urt28,      
    pwr2_off_urt28,
    // ETH028
    rstn_non_srpg_macb028,
    gate_clk_macb028,
    isolate_macb028,
    save_edge_macb028,
    restore_edge_macb028,
    pwr1_on_macb028,
    pwr2_on_macb028,
    pwr1_off_macb028,      
    pwr2_off_macb028,
    // ETH128
    rstn_non_srpg_macb128,
    gate_clk_macb128,
    isolate_macb128,
    save_edge_macb128,
    restore_edge_macb128,
    pwr1_on_macb128,
    pwr2_on_macb128,
    pwr1_off_macb128,      
    pwr2_off_macb128,
    // ETH228
    rstn_non_srpg_macb228,
    gate_clk_macb228,
    isolate_macb228,
    save_edge_macb228,
    restore_edge_macb228,
    pwr1_on_macb228,
    pwr2_on_macb228,
    pwr1_off_macb228,      
    pwr2_off_macb228,
    // ETH328
    rstn_non_srpg_macb328,
    gate_clk_macb328,
    isolate_macb328,
    save_edge_macb328,
    restore_edge_macb328,
    pwr1_on_macb328,
    pwr2_on_macb328,
    pwr1_off_macb328,      
    pwr2_off_macb328,
    // DMA28
    rstn_non_srpg_dma28,
    gate_clk_dma28,
    isolate_dma28,
    save_edge_dma28,
    restore_edge_dma28,
    pwr1_on_dma28,
    pwr2_on_dma28,
    pwr1_off_dma28,      
    pwr2_off_dma28,
    // CPU28
    rstn_non_srpg_cpu28,
    gate_clk_cpu28,
    isolate_cpu28,
    save_edge_cpu28,
    restore_edge_cpu28,
    pwr1_on_cpu28,
    pwr2_on_cpu28,
    pwr1_off_cpu28,      
    pwr2_off_cpu28,
    // ALUT28
    rstn_non_srpg_alut28,
    gate_clk_alut28,
    isolate_alut28,
    save_edge_alut28,
    restore_edge_alut28,
    pwr1_on_alut28,
    pwr2_on_alut28,
    pwr1_off_alut28,      
    pwr2_off_alut28,
    // MEM28
    rstn_non_srpg_mem28,
    gate_clk_mem28,
    isolate_mem28,
    save_edge_mem28,
    restore_edge_mem28,
    pwr1_on_mem28,
    pwr2_on_mem28,
    pwr1_off_mem28,      
    pwr2_off_mem28,
    // core28 dvfs28 transitions28
    core06v28,
    core08v28,
    core10v28,
    core12v28,
    pcm_macb_wakeup_int28,
    // mte28 signals28
    mte_smc_start28,
    mte_uart_start28,
    mte_smc_uart_start28,  
    mte_pm_smc_to_default_start28, 
    mte_pm_uart_to_default_start28,
    mte_pm_smc_uart_to_default_start28

  );

  parameter STATE_IDLE_12V28 = 4'b0001;
  parameter STATE_06V28 = 4'b0010;
  parameter STATE_08V28 = 4'b0100;
  parameter STATE_10V28 = 4'b1000;

    // Clocks28 & Reset28
    input pclk28;
    input nprst28;
    // APB28 programming28 interface
    input [31:0] paddr28;
    input psel28  ;
    input penable28;
    input pwrite28 ;
    input [31:0] pwdata28;
    output [31:0] prdata28;
    // mac28
    input macb3_wakeup28;
    input macb2_wakeup28;
    input macb1_wakeup28;
    input macb0_wakeup28;
    // Scan28 
    input scan_in28;
    input scan_en28;
    input scan_mode28;
    output scan_out28;
    // Module28 control28 outputs28
    input int_source_h28;
    // SMC28
    output rstn_non_srpg_smc28 ;
    output gate_clk_smc28   ;
    output isolate_smc28   ;
    output save_edge_smc28   ;
    output restore_edge_smc28   ;
    output pwr1_on_smc28   ;
    output pwr2_on_smc28   ;
    output pwr1_off_smc28  ;
    output pwr2_off_smc28  ;
    // URT28
    output rstn_non_srpg_urt28 ;
    output gate_clk_urt28      ;
    output isolate_urt28       ;
    output save_edge_urt28   ;
    output restore_edge_urt28   ;
    output pwr1_on_urt28       ;
    output pwr2_on_urt28       ;
    output pwr1_off_urt28      ;
    output pwr2_off_urt28      ;
    // ETH028
    output rstn_non_srpg_macb028 ;
    output gate_clk_macb028      ;
    output isolate_macb028       ;
    output save_edge_macb028   ;
    output restore_edge_macb028   ;
    output pwr1_on_macb028       ;
    output pwr2_on_macb028       ;
    output pwr1_off_macb028      ;
    output pwr2_off_macb028      ;
    // ETH128
    output rstn_non_srpg_macb128 ;
    output gate_clk_macb128      ;
    output isolate_macb128       ;
    output save_edge_macb128   ;
    output restore_edge_macb128   ;
    output pwr1_on_macb128       ;
    output pwr2_on_macb128       ;
    output pwr1_off_macb128      ;
    output pwr2_off_macb128      ;
    // ETH228
    output rstn_non_srpg_macb228 ;
    output gate_clk_macb228      ;
    output isolate_macb228       ;
    output save_edge_macb228   ;
    output restore_edge_macb228   ;
    output pwr1_on_macb228       ;
    output pwr2_on_macb228       ;
    output pwr1_off_macb228      ;
    output pwr2_off_macb228      ;
    // ETH328
    output rstn_non_srpg_macb328 ;
    output gate_clk_macb328      ;
    output isolate_macb328       ;
    output save_edge_macb328   ;
    output restore_edge_macb328   ;
    output pwr1_on_macb328       ;
    output pwr2_on_macb328       ;
    output pwr1_off_macb328      ;
    output pwr2_off_macb328      ;
    // DMA28
    output rstn_non_srpg_dma28 ;
    output gate_clk_dma28      ;
    output isolate_dma28       ;
    output save_edge_dma28   ;
    output restore_edge_dma28   ;
    output pwr1_on_dma28       ;
    output pwr2_on_dma28       ;
    output pwr1_off_dma28      ;
    output pwr2_off_dma28      ;
    // CPU28
    output rstn_non_srpg_cpu28 ;
    output gate_clk_cpu28      ;
    output isolate_cpu28       ;
    output save_edge_cpu28   ;
    output restore_edge_cpu28   ;
    output pwr1_on_cpu28       ;
    output pwr2_on_cpu28       ;
    output pwr1_off_cpu28      ;
    output pwr2_off_cpu28      ;
    // ALUT28
    output rstn_non_srpg_alut28 ;
    output gate_clk_alut28      ;
    output isolate_alut28       ;
    output save_edge_alut28   ;
    output restore_edge_alut28   ;
    output pwr1_on_alut28       ;
    output pwr2_on_alut28       ;
    output pwr1_off_alut28      ;
    output pwr2_off_alut28      ;
    // MEM28
    output rstn_non_srpg_mem28 ;
    output gate_clk_mem28      ;
    output isolate_mem28       ;
    output save_edge_mem28   ;
    output restore_edge_mem28   ;
    output pwr1_on_mem28       ;
    output pwr2_on_mem28       ;
    output pwr1_off_mem28      ;
    output pwr2_off_mem28      ;


   // core28 transitions28 o/p
    output core06v28;
    output core08v28;
    output core10v28;
    output core12v28;
    output pcm_macb_wakeup_int28 ;
    //mode mte28  signals28
    output mte_smc_start28;
    output mte_uart_start28;
    output mte_smc_uart_start28;  
    output mte_pm_smc_to_default_start28; 
    output mte_pm_uart_to_default_start28;
    output mte_pm_smc_uart_to_default_start28;

    reg mte_smc_start28;
    reg mte_uart_start28;
    reg mte_smc_uart_start28;  
    reg mte_pm_smc_to_default_start28; 
    reg mte_pm_uart_to_default_start28;
    reg mte_pm_smc_uart_to_default_start28;

    reg [31:0] prdata28;

  wire valid_reg_write28  ;
  wire valid_reg_read28   ;
  wire L1_ctrl_access28   ;
  wire L1_status_access28 ;
  wire pcm_int_mask_access28;
  wire pcm_int_status_access28;
  wire standby_mem028      ;
  wire standby_mem128      ;
  wire standby_mem228      ;
  wire standby_mem328      ;
  wire pwr1_off_mem028;
  wire pwr1_off_mem128;
  wire pwr1_off_mem228;
  wire pwr1_off_mem328;
  
  // Control28 signals28
  wire set_status_smc28   ;
  wire clr_status_smc28   ;
  wire set_status_urt28   ;
  wire clr_status_urt28   ;
  wire set_status_macb028   ;
  wire clr_status_macb028   ;
  wire set_status_macb128   ;
  wire clr_status_macb128   ;
  wire set_status_macb228   ;
  wire clr_status_macb228   ;
  wire set_status_macb328   ;
  wire clr_status_macb328   ;
  wire set_status_dma28   ;
  wire clr_status_dma28   ;
  wire set_status_cpu28   ;
  wire clr_status_cpu28   ;
  wire set_status_alut28   ;
  wire clr_status_alut28   ;
  wire set_status_mem28   ;
  wire clr_status_mem28   ;


  // Status and Control28 registers
  reg [31:0]  L1_status_reg28;
  reg  [31:0] L1_ctrl_reg28  ;
  reg  [31:0] L1_ctrl_domain28  ;
  reg L1_ctrl_cpu_off_reg28;
  reg [31:0]  pcm_mask_reg28;
  reg [31:0]  pcm_status_reg28;

  // Signals28 gated28 in scan_mode28
  //SMC28
  wire  rstn_non_srpg_smc_int28;
  wire  gate_clk_smc_int28    ;     
  wire  isolate_smc_int28    ;       
  wire save_edge_smc_int28;
  wire restore_edge_smc_int28;
  wire  pwr1_on_smc_int28    ;      
  wire  pwr2_on_smc_int28    ;      


  //URT28
  wire   rstn_non_srpg_urt_int28;
  wire   gate_clk_urt_int28     ;     
  wire   isolate_urt_int28      ;       
  wire save_edge_urt_int28;
  wire restore_edge_urt_int28;
  wire   pwr1_on_urt_int28      ;      
  wire   pwr2_on_urt_int28      ;      

  // ETH028
  wire   rstn_non_srpg_macb0_int28;
  wire   gate_clk_macb0_int28     ;     
  wire   isolate_macb0_int28      ;       
  wire save_edge_macb0_int28;
  wire restore_edge_macb0_int28;
  wire   pwr1_on_macb0_int28      ;      
  wire   pwr2_on_macb0_int28      ;      
  // ETH128
  wire   rstn_non_srpg_macb1_int28;
  wire   gate_clk_macb1_int28     ;     
  wire   isolate_macb1_int28      ;       
  wire save_edge_macb1_int28;
  wire restore_edge_macb1_int28;
  wire   pwr1_on_macb1_int28      ;      
  wire   pwr2_on_macb1_int28      ;      
  // ETH228
  wire   rstn_non_srpg_macb2_int28;
  wire   gate_clk_macb2_int28     ;     
  wire   isolate_macb2_int28      ;       
  wire save_edge_macb2_int28;
  wire restore_edge_macb2_int28;
  wire   pwr1_on_macb2_int28      ;      
  wire   pwr2_on_macb2_int28      ;      
  // ETH328
  wire   rstn_non_srpg_macb3_int28;
  wire   gate_clk_macb3_int28     ;     
  wire   isolate_macb3_int28      ;       
  wire save_edge_macb3_int28;
  wire restore_edge_macb3_int28;
  wire   pwr1_on_macb3_int28      ;      
  wire   pwr2_on_macb3_int28      ;      

  // DMA28
  wire   rstn_non_srpg_dma_int28;
  wire   gate_clk_dma_int28     ;     
  wire   isolate_dma_int28      ;       
  wire save_edge_dma_int28;
  wire restore_edge_dma_int28;
  wire   pwr1_on_dma_int28      ;      
  wire   pwr2_on_dma_int28      ;      

  // CPU28
  wire   rstn_non_srpg_cpu_int28;
  wire   gate_clk_cpu_int28     ;     
  wire   isolate_cpu_int28      ;       
  wire save_edge_cpu_int28;
  wire restore_edge_cpu_int28;
  wire   pwr1_on_cpu_int28      ;      
  wire   pwr2_on_cpu_int28      ;  
  wire L1_ctrl_cpu_off_p28;    

  reg save_alut_tmp28;
  // DFS28 sm28

  reg cpu_shutoff_ctrl28;

  reg mte_mac_off_start28, mte_mac012_start28, mte_mac013_start28, mte_mac023_start28, mte_mac123_start28;
  reg mte_mac01_start28, mte_mac02_start28, mte_mac03_start28, mte_mac12_start28, mte_mac13_start28, mte_mac23_start28;
  reg mte_mac0_start28, mte_mac1_start28, mte_mac2_start28, mte_mac3_start28;
  reg mte_sys_hibernate28 ;
  reg mte_dma_start28 ;
  reg mte_cpu_start28 ;
  reg mte_mac_off_sleep_start28, mte_mac012_sleep_start28, mte_mac013_sleep_start28, mte_mac023_sleep_start28, mte_mac123_sleep_start28;
  reg mte_mac01_sleep_start28, mte_mac02_sleep_start28, mte_mac03_sleep_start28, mte_mac12_sleep_start28, mte_mac13_sleep_start28, mte_mac23_sleep_start28;
  reg mte_mac0_sleep_start28, mte_mac1_sleep_start28, mte_mac2_sleep_start28, mte_mac3_sleep_start28;
  reg mte_dma_sleep_start28;
  reg mte_mac_off_to_default28, mte_mac012_to_default28, mte_mac013_to_default28, mte_mac023_to_default28, mte_mac123_to_default28;
  reg mte_mac01_to_default28, mte_mac02_to_default28, mte_mac03_to_default28, mte_mac12_to_default28, mte_mac13_to_default28, mte_mac23_to_default28;
  reg mte_mac0_to_default28, mte_mac1_to_default28, mte_mac2_to_default28, mte_mac3_to_default28;
  reg mte_dma_isolate_dis28;
  reg mte_cpu_isolate_dis28;
  reg mte_sys_hibernate_to_default28;


  // Latch28 the CPU28 SLEEP28 invocation28
  always @( posedge pclk28 or negedge nprst28) 
  begin
    if(!nprst28)
      L1_ctrl_cpu_off_reg28 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg28 <= L1_ctrl_domain28[8];
  end

  // Create28 a pulse28 for sleep28 detection28 
  assign L1_ctrl_cpu_off_p28 =  L1_ctrl_domain28[8] && !L1_ctrl_cpu_off_reg28;
  
  // CPU28 sleep28 contol28 logic 
  // Shut28 off28 CPU28 when L1_ctrl_cpu_off_p28 is set
  // wake28 cpu28 when any interrupt28 is seen28  
  always @( posedge pclk28 or negedge nprst28) 
  begin
    if(!nprst28)
     cpu_shutoff_ctrl28 <= 1'b0;
    else if(cpu_shutoff_ctrl28 && int_source_h28)
     cpu_shutoff_ctrl28 <= 1'b0;
    else if (L1_ctrl_cpu_off_p28)
     cpu_shutoff_ctrl28 <= 1'b1;
  end
 
  // instantiate28 power28 contol28  block for uart28
  power_ctrl_sm28 i_urt_power_ctrl_sm28(
    .pclk28(pclk28),
    .nprst28(nprst28),
    .L1_module_req28(L1_ctrl_domain28[1]),
    .set_status_module28(set_status_urt28),
    .clr_status_module28(clr_status_urt28),
    .rstn_non_srpg_module28(rstn_non_srpg_urt_int28),
    .gate_clk_module28(gate_clk_urt_int28),
    .isolate_module28(isolate_urt_int28),
    .save_edge28(save_edge_urt_int28),
    .restore_edge28(restore_edge_urt_int28),
    .pwr1_on28(pwr1_on_urt_int28),
    .pwr2_on28(pwr2_on_urt_int28)
    );
  

  // instantiate28 power28 contol28  block for smc28
  power_ctrl_sm28 i_smc_power_ctrl_sm28(
    .pclk28(pclk28),
    .nprst28(nprst28),
    .L1_module_req28(L1_ctrl_domain28[2]),
    .set_status_module28(set_status_smc28),
    .clr_status_module28(clr_status_smc28),
    .rstn_non_srpg_module28(rstn_non_srpg_smc_int28),
    .gate_clk_module28(gate_clk_smc_int28),
    .isolate_module28(isolate_smc_int28),
    .save_edge28(save_edge_smc_int28),
    .restore_edge28(restore_edge_smc_int28),
    .pwr1_on28(pwr1_on_smc_int28),
    .pwr2_on28(pwr2_on_smc_int28)
    );

  // power28 control28 for macb028
  power_ctrl_sm28 i_macb0_power_ctrl_sm28(
    .pclk28(pclk28),
    .nprst28(nprst28),
    .L1_module_req28(L1_ctrl_domain28[3]),
    .set_status_module28(set_status_macb028),
    .clr_status_module28(clr_status_macb028),
    .rstn_non_srpg_module28(rstn_non_srpg_macb0_int28),
    .gate_clk_module28(gate_clk_macb0_int28),
    .isolate_module28(isolate_macb0_int28),
    .save_edge28(save_edge_macb0_int28),
    .restore_edge28(restore_edge_macb0_int28),
    .pwr1_on28(pwr1_on_macb0_int28),
    .pwr2_on28(pwr2_on_macb0_int28)
    );
  // power28 control28 for macb128
  power_ctrl_sm28 i_macb1_power_ctrl_sm28(
    .pclk28(pclk28),
    .nprst28(nprst28),
    .L1_module_req28(L1_ctrl_domain28[4]),
    .set_status_module28(set_status_macb128),
    .clr_status_module28(clr_status_macb128),
    .rstn_non_srpg_module28(rstn_non_srpg_macb1_int28),
    .gate_clk_module28(gate_clk_macb1_int28),
    .isolate_module28(isolate_macb1_int28),
    .save_edge28(save_edge_macb1_int28),
    .restore_edge28(restore_edge_macb1_int28),
    .pwr1_on28(pwr1_on_macb1_int28),
    .pwr2_on28(pwr2_on_macb1_int28)
    );
  // power28 control28 for macb228
  power_ctrl_sm28 i_macb2_power_ctrl_sm28(
    .pclk28(pclk28),
    .nprst28(nprst28),
    .L1_module_req28(L1_ctrl_domain28[5]),
    .set_status_module28(set_status_macb228),
    .clr_status_module28(clr_status_macb228),
    .rstn_non_srpg_module28(rstn_non_srpg_macb2_int28),
    .gate_clk_module28(gate_clk_macb2_int28),
    .isolate_module28(isolate_macb2_int28),
    .save_edge28(save_edge_macb2_int28),
    .restore_edge28(restore_edge_macb2_int28),
    .pwr1_on28(pwr1_on_macb2_int28),
    .pwr2_on28(pwr2_on_macb2_int28)
    );
  // power28 control28 for macb328
  power_ctrl_sm28 i_macb3_power_ctrl_sm28(
    .pclk28(pclk28),
    .nprst28(nprst28),
    .L1_module_req28(L1_ctrl_domain28[6]),
    .set_status_module28(set_status_macb328),
    .clr_status_module28(clr_status_macb328),
    .rstn_non_srpg_module28(rstn_non_srpg_macb3_int28),
    .gate_clk_module28(gate_clk_macb3_int28),
    .isolate_module28(isolate_macb3_int28),
    .save_edge28(save_edge_macb3_int28),
    .restore_edge28(restore_edge_macb3_int28),
    .pwr1_on28(pwr1_on_macb3_int28),
    .pwr2_on28(pwr2_on_macb3_int28)
    );
  // power28 control28 for dma28
  power_ctrl_sm28 i_dma_power_ctrl_sm28(
    .pclk28(pclk28),
    .nprst28(nprst28),
    .L1_module_req28(L1_ctrl_domain28[7]),
    .set_status_module28(set_status_dma28),
    .clr_status_module28(clr_status_dma28),
    .rstn_non_srpg_module28(rstn_non_srpg_dma_int28),
    .gate_clk_module28(gate_clk_dma_int28),
    .isolate_module28(isolate_dma_int28),
    .save_edge28(save_edge_dma_int28),
    .restore_edge28(restore_edge_dma_int28),
    .pwr1_on28(pwr1_on_dma_int28),
    .pwr2_on28(pwr2_on_dma_int28)
    );
  // power28 control28 for CPU28
  power_ctrl_sm28 i_cpu_power_ctrl_sm28(
    .pclk28(pclk28),
    .nprst28(nprst28),
    .L1_module_req28(cpu_shutoff_ctrl28),
    .set_status_module28(set_status_cpu28),
    .clr_status_module28(clr_status_cpu28),
    .rstn_non_srpg_module28(rstn_non_srpg_cpu_int28),
    .gate_clk_module28(gate_clk_cpu_int28),
    .isolate_module28(isolate_cpu_int28),
    .save_edge28(save_edge_cpu_int28),
    .restore_edge28(restore_edge_cpu_int28),
    .pwr1_on28(pwr1_on_cpu_int28),
    .pwr2_on28(pwr2_on_cpu_int28)
    );

  assign valid_reg_write28 =  (psel28 && pwrite28 && penable28);
  assign valid_reg_read28  =  (psel28 && (!pwrite28) && penable28);

  assign L1_ctrl_access28  =  (paddr28[15:0] == 16'b0000000000000100); 
  assign L1_status_access28 = (paddr28[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access28 =   (paddr28[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access28 = (paddr28[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control28 and status register
  always @(*)
  begin  
    if(valid_reg_read28 && L1_ctrl_access28) 
      prdata28 = L1_ctrl_reg28;
    else if (valid_reg_read28 && L1_status_access28)
      prdata28 = L1_status_reg28;
    else if (valid_reg_read28 && pcm_int_mask_access28)
      prdata28 = pcm_mask_reg28;
    else if (valid_reg_read28 && pcm_int_status_access28)
      prdata28 = pcm_status_reg28;
    else 
      prdata28 = 0;
  end

  assign set_status_mem28 =  (set_status_macb028 && set_status_macb128 && set_status_macb228 &&
                            set_status_macb328 && set_status_dma28 && set_status_cpu28);

  assign clr_status_mem28 =  (clr_status_macb028 && clr_status_macb128 && clr_status_macb228 &&
                            clr_status_macb328 && clr_status_dma28 && clr_status_cpu28);

  assign set_status_alut28 = (set_status_macb028 && set_status_macb128 && set_status_macb228 && set_status_macb328);

  assign clr_status_alut28 = (clr_status_macb028 || clr_status_macb128 || clr_status_macb228  || clr_status_macb328);

  // Write accesses to the control28 and status register
 
  always @(posedge pclk28 or negedge nprst28)
  begin
    if (!nprst28) begin
      L1_ctrl_reg28   <= 0;
      L1_status_reg28 <= 0;
      pcm_mask_reg28 <= 0;
    end else begin
      // CTRL28 reg updates28
      if (valid_reg_write28 && L1_ctrl_access28) 
        L1_ctrl_reg28 <= pwdata28; // Writes28 to the ctrl28 reg
      if (valid_reg_write28 && pcm_int_mask_access28) 
        pcm_mask_reg28 <= pwdata28; // Writes28 to the ctrl28 reg

      if (set_status_urt28 == 1'b1)  
        L1_status_reg28[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt28 == 1'b1) 
        L1_status_reg28[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc28 == 1'b1) 
        L1_status_reg28[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc28 == 1'b1) 
        L1_status_reg28[2] <= 1'b0; // Clear the status bit

      if (set_status_macb028 == 1'b1)  
        L1_status_reg28[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb028 == 1'b1) 
        L1_status_reg28[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb128 == 1'b1)  
        L1_status_reg28[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb128 == 1'b1) 
        L1_status_reg28[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb228 == 1'b1)  
        L1_status_reg28[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb228 == 1'b1) 
        L1_status_reg28[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb328 == 1'b1)  
        L1_status_reg28[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb328 == 1'b1) 
        L1_status_reg28[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma28 == 1'b1)  
        L1_status_reg28[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma28 == 1'b1) 
        L1_status_reg28[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu28 == 1'b1)  
        L1_status_reg28[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu28 == 1'b1) 
        L1_status_reg28[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut28 == 1'b1)  
        L1_status_reg28[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut28 == 1'b1) 
        L1_status_reg28[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem28 == 1'b1)  
        L1_status_reg28[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem28 == 1'b1) 
        L1_status_reg28[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused28 bits of pcm_status_reg28 are tied28 to 0
  always @(posedge pclk28 or negedge nprst28)
  begin
    if (!nprst28)
      pcm_status_reg28[31:4] <= 'b0;
    else  
      pcm_status_reg28[31:4] <= pcm_status_reg28[31:4];
  end
  
  // interrupt28 only of h/w assisted28 wakeup
  // MAC28 3
  always @(posedge pclk28 or negedge nprst28)
  begin
    if(!nprst28)
      pcm_status_reg28[3] <= 1'b0;
    else if (valid_reg_write28 && pcm_int_status_access28) 
      pcm_status_reg28[3] <= pwdata28[3];
    else if (macb3_wakeup28 & ~pcm_mask_reg28[3])
      pcm_status_reg28[3] <= 1'b1;
    else if (valid_reg_read28 && pcm_int_status_access28) 
      pcm_status_reg28[3] <= 1'b0;
    else
      pcm_status_reg28[3] <= pcm_status_reg28[3];
  end  
   
  // MAC28 2
  always @(posedge pclk28 or negedge nprst28)
  begin
    if(!nprst28)
      pcm_status_reg28[2] <= 1'b0;
    else if (valid_reg_write28 && pcm_int_status_access28) 
      pcm_status_reg28[2] <= pwdata28[2];
    else if (macb2_wakeup28 & ~pcm_mask_reg28[2])
      pcm_status_reg28[2] <= 1'b1;
    else if (valid_reg_read28 && pcm_int_status_access28) 
      pcm_status_reg28[2] <= 1'b0;
    else
      pcm_status_reg28[2] <= pcm_status_reg28[2];
  end  

  // MAC28 1
  always @(posedge pclk28 or negedge nprst28)
  begin
    if(!nprst28)
      pcm_status_reg28[1] <= 1'b0;
    else if (valid_reg_write28 && pcm_int_status_access28) 
      pcm_status_reg28[1] <= pwdata28[1];
    else if (macb1_wakeup28 & ~pcm_mask_reg28[1])
      pcm_status_reg28[1] <= 1'b1;
    else if (valid_reg_read28 && pcm_int_status_access28) 
      pcm_status_reg28[1] <= 1'b0;
    else
      pcm_status_reg28[1] <= pcm_status_reg28[1];
  end  
   
  // MAC28 0
  always @(posedge pclk28 or negedge nprst28)
  begin
    if(!nprst28)
      pcm_status_reg28[0] <= 1'b0;
    else if (valid_reg_write28 && pcm_int_status_access28) 
      pcm_status_reg28[0] <= pwdata28[0];
    else if (macb0_wakeup28 & ~pcm_mask_reg28[0])
      pcm_status_reg28[0] <= 1'b1;
    else if (valid_reg_read28 && pcm_int_status_access28) 
      pcm_status_reg28[0] <= 1'b0;
    else
      pcm_status_reg28[0] <= pcm_status_reg28[0];
  end  

  assign pcm_macb_wakeup_int28 = |pcm_status_reg28;

  reg [31:0] L1_ctrl_reg128;
  always @(posedge pclk28 or negedge nprst28)
  begin
    if(!nprst28)
      L1_ctrl_reg128 <= 0;
    else
      L1_ctrl_reg128 <= L1_ctrl_reg28;
  end

  // Program28 mode decode
  always @(L1_ctrl_reg28 or L1_ctrl_reg128 or int_source_h28 or cpu_shutoff_ctrl28) begin
    mte_smc_start28 = 0;
    mte_uart_start28 = 0;
    mte_smc_uart_start28  = 0;
    mte_mac_off_start28  = 0;
    mte_mac012_start28 = 0;
    mte_mac013_start28 = 0;
    mte_mac023_start28 = 0;
    mte_mac123_start28 = 0;
    mte_mac01_start28 = 0;
    mte_mac02_start28 = 0;
    mte_mac03_start28 = 0;
    mte_mac12_start28 = 0;
    mte_mac13_start28 = 0;
    mte_mac23_start28 = 0;
    mte_mac0_start28 = 0;
    mte_mac1_start28 = 0;
    mte_mac2_start28 = 0;
    mte_mac3_start28 = 0;
    mte_sys_hibernate28 = 0 ;
    mte_dma_start28 = 0 ;
    mte_cpu_start28 = 0 ;

    mte_mac0_sleep_start28 = (L1_ctrl_reg28 ==  'h14) && (L1_ctrl_reg128 == 'h4 );
    mte_mac1_sleep_start28 = (L1_ctrl_reg28 ==  'h14) && (L1_ctrl_reg128 == 'h5 ); 
    mte_mac2_sleep_start28 = (L1_ctrl_reg28 ==  'h14) && (L1_ctrl_reg128 == 'h6 ); 
    mte_mac3_sleep_start28 = (L1_ctrl_reg28 ==  'h14) && (L1_ctrl_reg128 == 'h7 ); 
    mte_mac01_sleep_start28 = (L1_ctrl_reg28 ==  'h14) && (L1_ctrl_reg128 == 'h8 ); 
    mte_mac02_sleep_start28 = (L1_ctrl_reg28 ==  'h14) && (L1_ctrl_reg128 == 'h9 ); 
    mte_mac03_sleep_start28 = (L1_ctrl_reg28 ==  'h14) && (L1_ctrl_reg128 == 'hA ); 
    mte_mac12_sleep_start28 = (L1_ctrl_reg28 ==  'h14) && (L1_ctrl_reg128 == 'hB ); 
    mte_mac13_sleep_start28 = (L1_ctrl_reg28 ==  'h14) && (L1_ctrl_reg128 == 'hC ); 
    mte_mac23_sleep_start28 = (L1_ctrl_reg28 ==  'h14) && (L1_ctrl_reg128 == 'hD ); 
    mte_mac012_sleep_start28 = (L1_ctrl_reg28 ==  'h14) && (L1_ctrl_reg128 == 'hE ); 
    mte_mac013_sleep_start28 = (L1_ctrl_reg28 ==  'h14) && (L1_ctrl_reg128 == 'hF ); 
    mte_mac023_sleep_start28 = (L1_ctrl_reg28 ==  'h14) && (L1_ctrl_reg128 == 'h10 ); 
    mte_mac123_sleep_start28 = (L1_ctrl_reg28 ==  'h14) && (L1_ctrl_reg128 == 'h11 ); 
    mte_mac_off_sleep_start28 =  (L1_ctrl_reg28 == 'h14) && (L1_ctrl_reg128 == 'h12 );
    mte_dma_sleep_start28 =  (L1_ctrl_reg28 == 'h14) && (L1_ctrl_reg128 == 'h13 );

    mte_pm_uart_to_default_start28 = (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'h1);
    mte_pm_smc_to_default_start28 = (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'h2);
    mte_pm_smc_uart_to_default_start28 = (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'h3); 
    mte_mac0_to_default28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'h4); 
    mte_mac1_to_default28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'h5); 
    mte_mac2_to_default28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'h6); 
    mte_mac3_to_default28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'h7); 
    mte_mac01_to_default28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'h8); 
    mte_mac02_to_default28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'h9); 
    mte_mac03_to_default28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'hA); 
    mte_mac12_to_default28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'hB); 
    mte_mac13_to_default28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'hC); 
    mte_mac23_to_default28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'hD); 
    mte_mac012_to_default28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'hE); 
    mte_mac013_to_default28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'hF); 
    mte_mac023_to_default28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'h10); 
    mte_mac123_to_default28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'h11); 
    mte_mac_off_to_default28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'h12); 
    mte_dma_isolate_dis28 =  (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'h13); 
    mte_cpu_isolate_dis28 =  (int_source_h28) && (cpu_shutoff_ctrl28) && (L1_ctrl_reg28 != 'h15);
    mte_sys_hibernate_to_default28 = (L1_ctrl_reg28 == 32'h0) && (L1_ctrl_reg128 == 'h15); 

   
    if (L1_ctrl_reg128 == 'h0) begin // This28 check is to make mte_cpu_start28
                                   // is set only when you from default state 
      case (L1_ctrl_reg28)
        'h0 : L1_ctrl_domain28 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain28 = 32'h2; // PM_uart28
                mte_uart_start28 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain28 = 32'h4; // PM_smc28
                mte_smc_start28 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain28 = 32'h6; // PM_smc_uart28
                mte_smc_uart_start28 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain28 = 32'h8; //  PM_macb028
                mte_mac0_start28 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain28 = 32'h10; //  PM_macb128
                mte_mac1_start28 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain28 = 32'h20; //  PM_macb228
                mte_mac2_start28 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain28 = 32'h40; //  PM_macb328
                mte_mac3_start28 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain28 = 32'h18; //  PM_macb0128
                mte_mac01_start28 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain28 = 32'h28; //  PM_macb0228
                mte_mac02_start28 = 1;
              end
        'hA : begin  
                L1_ctrl_domain28 = 32'h48; //  PM_macb0328
                mte_mac03_start28 = 1;
              end
        'hB : begin  
                L1_ctrl_domain28 = 32'h30; //  PM_macb1228
                mte_mac12_start28 = 1;
              end
        'hC : begin  
                L1_ctrl_domain28 = 32'h50; //  PM_macb1328
                mte_mac13_start28 = 1;
              end
        'hD : begin  
                L1_ctrl_domain28 = 32'h60; //  PM_macb2328
                mte_mac23_start28 = 1;
              end
        'hE : begin  
                L1_ctrl_domain28 = 32'h38; //  PM_macb01228
                mte_mac012_start28 = 1;
              end
        'hF : begin  
                L1_ctrl_domain28 = 32'h58; //  PM_macb01328
                mte_mac013_start28 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain28 = 32'h68; //  PM_macb02328
                mte_mac023_start28 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain28 = 32'h70; //  PM_macb12328
                mte_mac123_start28 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain28 = 32'h78; //  PM_macb_off28
                mte_mac_off_start28 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain28 = 32'h80; //  PM_dma28
                mte_dma_start28 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain28 = 32'h100; //  PM_cpu_sleep28
                mte_cpu_start28 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain28 = 32'h1FE; //  PM_hibernate28
                mte_sys_hibernate28 = 1;
              end
         default: L1_ctrl_domain28 = 32'h0;
      endcase
    end
  end


  wire to_default28 = (L1_ctrl_reg28 == 0);

  // Scan28 mode gating28 of power28 and isolation28 control28 signals28
  //SMC28
  assign rstn_non_srpg_smc28  = (scan_mode28 == 1'b0) ? rstn_non_srpg_smc_int28 : 1'b1;  
  assign gate_clk_smc28       = (scan_mode28 == 1'b0) ? gate_clk_smc_int28 : 1'b0;     
  assign isolate_smc28        = (scan_mode28 == 1'b0) ? isolate_smc_int28 : 1'b0;      
  assign pwr1_on_smc28        = (scan_mode28 == 1'b0) ? pwr1_on_smc_int28 : 1'b1;       
  assign pwr2_on_smc28        = (scan_mode28 == 1'b0) ? pwr2_on_smc_int28 : 1'b1;       
  assign pwr1_off_smc28       = (scan_mode28 == 1'b0) ? (!pwr1_on_smc_int28) : 1'b0;       
  assign pwr2_off_smc28       = (scan_mode28 == 1'b0) ? (!pwr2_on_smc_int28) : 1'b0;       
  assign save_edge_smc28       = (scan_mode28 == 1'b0) ? (save_edge_smc_int28) : 1'b0;       
  assign restore_edge_smc28       = (scan_mode28 == 1'b0) ? (restore_edge_smc_int28) : 1'b0;       

  //URT28
  assign rstn_non_srpg_urt28  = (scan_mode28 == 1'b0) ?  rstn_non_srpg_urt_int28 : 1'b1;  
  assign gate_clk_urt28       = (scan_mode28 == 1'b0) ?  gate_clk_urt_int28      : 1'b0;     
  assign isolate_urt28        = (scan_mode28 == 1'b0) ?  isolate_urt_int28       : 1'b0;      
  assign pwr1_on_urt28        = (scan_mode28 == 1'b0) ?  pwr1_on_urt_int28       : 1'b1;       
  assign pwr2_on_urt28        = (scan_mode28 == 1'b0) ?  pwr2_on_urt_int28       : 1'b1;       
  assign pwr1_off_urt28       = (scan_mode28 == 1'b0) ?  (!pwr1_on_urt_int28)  : 1'b0;       
  assign pwr2_off_urt28       = (scan_mode28 == 1'b0) ?  (!pwr2_on_urt_int28)  : 1'b0;       
  assign save_edge_urt28       = (scan_mode28 == 1'b0) ? (save_edge_urt_int28) : 1'b0;       
  assign restore_edge_urt28       = (scan_mode28 == 1'b0) ? (restore_edge_urt_int28) : 1'b0;       

  //ETH028
  assign rstn_non_srpg_macb028 = (scan_mode28 == 1'b0) ?  rstn_non_srpg_macb0_int28 : 1'b1;  
  assign gate_clk_macb028       = (scan_mode28 == 1'b0) ?  gate_clk_macb0_int28      : 1'b0;     
  assign isolate_macb028        = (scan_mode28 == 1'b0) ?  isolate_macb0_int28       : 1'b0;      
  assign pwr1_on_macb028        = (scan_mode28 == 1'b0) ?  pwr1_on_macb0_int28       : 1'b1;       
  assign pwr2_on_macb028        = (scan_mode28 == 1'b0) ?  pwr2_on_macb0_int28       : 1'b1;       
  assign pwr1_off_macb028       = (scan_mode28 == 1'b0) ?  (!pwr1_on_macb0_int28)  : 1'b0;       
  assign pwr2_off_macb028       = (scan_mode28 == 1'b0) ?  (!pwr2_on_macb0_int28)  : 1'b0;       
  assign save_edge_macb028       = (scan_mode28 == 1'b0) ? (save_edge_macb0_int28) : 1'b0;       
  assign restore_edge_macb028       = (scan_mode28 == 1'b0) ? (restore_edge_macb0_int28) : 1'b0;       

  //ETH128
  assign rstn_non_srpg_macb128 = (scan_mode28 == 1'b0) ?  rstn_non_srpg_macb1_int28 : 1'b1;  
  assign gate_clk_macb128       = (scan_mode28 == 1'b0) ?  gate_clk_macb1_int28      : 1'b0;     
  assign isolate_macb128        = (scan_mode28 == 1'b0) ?  isolate_macb1_int28       : 1'b0;      
  assign pwr1_on_macb128        = (scan_mode28 == 1'b0) ?  pwr1_on_macb1_int28       : 1'b1;       
  assign pwr2_on_macb128        = (scan_mode28 == 1'b0) ?  pwr2_on_macb1_int28       : 1'b1;       
  assign pwr1_off_macb128       = (scan_mode28 == 1'b0) ?  (!pwr1_on_macb1_int28)  : 1'b0;       
  assign pwr2_off_macb128       = (scan_mode28 == 1'b0) ?  (!pwr2_on_macb1_int28)  : 1'b0;       
  assign save_edge_macb128       = (scan_mode28 == 1'b0) ? (save_edge_macb1_int28) : 1'b0;       
  assign restore_edge_macb128       = (scan_mode28 == 1'b0) ? (restore_edge_macb1_int28) : 1'b0;       

  //ETH228
  assign rstn_non_srpg_macb228 = (scan_mode28 == 1'b0) ?  rstn_non_srpg_macb2_int28 : 1'b1;  
  assign gate_clk_macb228       = (scan_mode28 == 1'b0) ?  gate_clk_macb2_int28      : 1'b0;     
  assign isolate_macb228        = (scan_mode28 == 1'b0) ?  isolate_macb2_int28       : 1'b0;      
  assign pwr1_on_macb228        = (scan_mode28 == 1'b0) ?  pwr1_on_macb2_int28       : 1'b1;       
  assign pwr2_on_macb228        = (scan_mode28 == 1'b0) ?  pwr2_on_macb2_int28       : 1'b1;       
  assign pwr1_off_macb228       = (scan_mode28 == 1'b0) ?  (!pwr1_on_macb2_int28)  : 1'b0;       
  assign pwr2_off_macb228       = (scan_mode28 == 1'b0) ?  (!pwr2_on_macb2_int28)  : 1'b0;       
  assign save_edge_macb228       = (scan_mode28 == 1'b0) ? (save_edge_macb2_int28) : 1'b0;       
  assign restore_edge_macb228       = (scan_mode28 == 1'b0) ? (restore_edge_macb2_int28) : 1'b0;       

  //ETH328
  assign rstn_non_srpg_macb328 = (scan_mode28 == 1'b0) ?  rstn_non_srpg_macb3_int28 : 1'b1;  
  assign gate_clk_macb328       = (scan_mode28 == 1'b0) ?  gate_clk_macb3_int28      : 1'b0;     
  assign isolate_macb328        = (scan_mode28 == 1'b0) ?  isolate_macb3_int28       : 1'b0;      
  assign pwr1_on_macb328        = (scan_mode28 == 1'b0) ?  pwr1_on_macb3_int28       : 1'b1;       
  assign pwr2_on_macb328        = (scan_mode28 == 1'b0) ?  pwr2_on_macb3_int28       : 1'b1;       
  assign pwr1_off_macb328       = (scan_mode28 == 1'b0) ?  (!pwr1_on_macb3_int28)  : 1'b0;       
  assign pwr2_off_macb328       = (scan_mode28 == 1'b0) ?  (!pwr2_on_macb3_int28)  : 1'b0;       
  assign save_edge_macb328       = (scan_mode28 == 1'b0) ? (save_edge_macb3_int28) : 1'b0;       
  assign restore_edge_macb328       = (scan_mode28 == 1'b0) ? (restore_edge_macb3_int28) : 1'b0;       

  // MEM28
  assign rstn_non_srpg_mem28 =   (rstn_non_srpg_macb028 && rstn_non_srpg_macb128 && rstn_non_srpg_macb228 &&
                                rstn_non_srpg_macb328 && rstn_non_srpg_dma28 && rstn_non_srpg_cpu28 && rstn_non_srpg_urt28 &&
                                rstn_non_srpg_smc28);

  assign gate_clk_mem28 =  (gate_clk_macb028 && gate_clk_macb128 && gate_clk_macb228 &&
                            gate_clk_macb328 && gate_clk_dma28 && gate_clk_cpu28 && gate_clk_urt28 && gate_clk_smc28);

  assign isolate_mem28  = (isolate_macb028 && isolate_macb128 && isolate_macb228 &&
                         isolate_macb328 && isolate_dma28 && isolate_cpu28 && isolate_urt28 && isolate_smc28);


  assign pwr1_on_mem28        =   ~pwr1_off_mem28;

  assign pwr2_on_mem28        =   ~pwr2_off_mem28;

  assign pwr1_off_mem28       =  (pwr1_off_macb028 && pwr1_off_macb128 && pwr1_off_macb228 &&
                                 pwr1_off_macb328 && pwr1_off_dma28 && pwr1_off_cpu28 && pwr1_off_urt28 && pwr1_off_smc28);


  assign pwr2_off_mem28       =  (pwr2_off_macb028 && pwr2_off_macb128 && pwr2_off_macb228 &&
                                pwr2_off_macb328 && pwr2_off_dma28 && pwr2_off_cpu28 && pwr2_off_urt28 && pwr2_off_smc28);

  assign save_edge_mem28      =  (save_edge_macb028 && save_edge_macb128 && save_edge_macb228 &&
                                save_edge_macb328 && save_edge_dma28 && save_edge_cpu28 && save_edge_smc28 && save_edge_urt28);

  assign restore_edge_mem28   =  (restore_edge_macb028 && restore_edge_macb128 && restore_edge_macb228  &&
                                restore_edge_macb328 && restore_edge_dma28 && restore_edge_cpu28 && restore_edge_urt28 &&
                                restore_edge_smc28);

  assign standby_mem028 = pwr1_off_macb028 && (~ (pwr1_off_macb028 && pwr1_off_macb128 && pwr1_off_macb228 && pwr1_off_macb328 && pwr1_off_urt28 && pwr1_off_smc28 && pwr1_off_dma28 && pwr1_off_cpu28));
  assign standby_mem128 = pwr1_off_macb128 && (~ (pwr1_off_macb028 && pwr1_off_macb128 && pwr1_off_macb228 && pwr1_off_macb328 && pwr1_off_urt28 && pwr1_off_smc28 && pwr1_off_dma28 && pwr1_off_cpu28));
  assign standby_mem228 = pwr1_off_macb228 && (~ (pwr1_off_macb028 && pwr1_off_macb128 && pwr1_off_macb228 && pwr1_off_macb328 && pwr1_off_urt28 && pwr1_off_smc28 && pwr1_off_dma28 && pwr1_off_cpu28));
  assign standby_mem328 = pwr1_off_macb328 && (~ (pwr1_off_macb028 && pwr1_off_macb128 && pwr1_off_macb228 && pwr1_off_macb328 && pwr1_off_urt28 && pwr1_off_smc28 && pwr1_off_dma28 && pwr1_off_cpu28));

  assign pwr1_off_mem028 = pwr1_off_mem28;
  assign pwr1_off_mem128 = pwr1_off_mem28;
  assign pwr1_off_mem228 = pwr1_off_mem28;
  assign pwr1_off_mem328 = pwr1_off_mem28;

  assign rstn_non_srpg_alut28  =  (rstn_non_srpg_macb028 && rstn_non_srpg_macb128 && rstn_non_srpg_macb228 && rstn_non_srpg_macb328);


   assign gate_clk_alut28       =  (gate_clk_macb028 && gate_clk_macb128 && gate_clk_macb228 && gate_clk_macb328);


    assign isolate_alut28        =  (isolate_macb028 && isolate_macb128 && isolate_macb228 && isolate_macb328);


    assign pwr1_on_alut28        =  (pwr1_on_macb028 || pwr1_on_macb128 || pwr1_on_macb228 || pwr1_on_macb328);


    assign pwr2_on_alut28        =  (pwr2_on_macb028 || pwr2_on_macb128 || pwr2_on_macb228 || pwr2_on_macb328);


    assign pwr1_off_alut28       =  (pwr1_off_macb028 && pwr1_off_macb128 && pwr1_off_macb228 && pwr1_off_macb328);


    assign pwr2_off_alut28       =  (pwr2_off_macb028 && pwr2_off_macb128 && pwr2_off_macb228 && pwr2_off_macb328);


    assign save_edge_alut28      =  (save_edge_macb028 && save_edge_macb128 && save_edge_macb228 && save_edge_macb328);


    assign restore_edge_alut28   =  (restore_edge_macb028 || restore_edge_macb128 || restore_edge_macb228 ||
                                   restore_edge_macb328) && save_alut_tmp28;

     // alut28 power28 off28 detection28
  always @(posedge pclk28 or negedge nprst28) begin
    if (!nprst28) 
       save_alut_tmp28 <= 0;
    else if (restore_edge_alut28)
       save_alut_tmp28 <= 0;
    else if (save_edge_alut28)
       save_alut_tmp28 <= 1;
  end

  //DMA28
  assign rstn_non_srpg_dma28 = (scan_mode28 == 1'b0) ?  rstn_non_srpg_dma_int28 : 1'b1;  
  assign gate_clk_dma28       = (scan_mode28 == 1'b0) ?  gate_clk_dma_int28      : 1'b0;     
  assign isolate_dma28        = (scan_mode28 == 1'b0) ?  isolate_dma_int28       : 1'b0;      
  assign pwr1_on_dma28        = (scan_mode28 == 1'b0) ?  pwr1_on_dma_int28       : 1'b1;       
  assign pwr2_on_dma28        = (scan_mode28 == 1'b0) ?  pwr2_on_dma_int28       : 1'b1;       
  assign pwr1_off_dma28       = (scan_mode28 == 1'b0) ?  (!pwr1_on_dma_int28)  : 1'b0;       
  assign pwr2_off_dma28       = (scan_mode28 == 1'b0) ?  (!pwr2_on_dma_int28)  : 1'b0;       
  assign save_edge_dma28       = (scan_mode28 == 1'b0) ? (save_edge_dma_int28) : 1'b0;       
  assign restore_edge_dma28       = (scan_mode28 == 1'b0) ? (restore_edge_dma_int28) : 1'b0;       

  //CPU28
  assign rstn_non_srpg_cpu28 = (scan_mode28 == 1'b0) ?  rstn_non_srpg_cpu_int28 : 1'b1;  
  assign gate_clk_cpu28       = (scan_mode28 == 1'b0) ?  gate_clk_cpu_int28      : 1'b0;     
  assign isolate_cpu28        = (scan_mode28 == 1'b0) ?  isolate_cpu_int28       : 1'b0;      
  assign pwr1_on_cpu28        = (scan_mode28 == 1'b0) ?  pwr1_on_cpu_int28       : 1'b1;       
  assign pwr2_on_cpu28        = (scan_mode28 == 1'b0) ?  pwr2_on_cpu_int28       : 1'b1;       
  assign pwr1_off_cpu28       = (scan_mode28 == 1'b0) ?  (!pwr1_on_cpu_int28)  : 1'b0;       
  assign pwr2_off_cpu28       = (scan_mode28 == 1'b0) ?  (!pwr2_on_cpu_int28)  : 1'b0;       
  assign save_edge_cpu28       = (scan_mode28 == 1'b0) ? (save_edge_cpu_int28) : 1'b0;       
  assign restore_edge_cpu28       = (scan_mode28 == 1'b0) ? (restore_edge_cpu_int28) : 1'b0;       



  // ASE28

   reg ase_core_12v28, ase_core_10v28, ase_core_08v28, ase_core_06v28;
   reg ase_macb0_12v28,ase_macb1_12v28,ase_macb2_12v28,ase_macb3_12v28;

    // core28 ase28

    // core28 at 1.0 v if (smc28 off28, urt28 off28, macb028 off28, macb128 off28, macb228 off28, macb328 off28
   // core28 at 0.8v if (mac01off28, macb02off28, macb03off28, macb12off28, mac13off28, mac23off28,
   // core28 at 0.6v if (mac012off28, mac013off28, mac023off28, mac123off28, mac0123off28
    // else core28 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb028 && pwr1_off_macb128 && pwr1_off_macb228 && pwr1_off_macb328) || // all mac28 off28
       (pwr1_off_macb328 && pwr1_off_macb228 && pwr1_off_macb128) || // mac123off28 
       (pwr1_off_macb328 && pwr1_off_macb228 && pwr1_off_macb028) || // mac023off28 
       (pwr1_off_macb328 && pwr1_off_macb128 && pwr1_off_macb028) || // mac013off28 
       (pwr1_off_macb228 && pwr1_off_macb128 && pwr1_off_macb028) )  // mac012off28 
       begin
         ase_core_12v28 = 0;
         ase_core_10v28 = 0;
         ase_core_08v28 = 0;
         ase_core_06v28 = 1;
       end
     else if( (pwr1_off_macb228 && pwr1_off_macb328) || // mac2328 off28
         (pwr1_off_macb328 && pwr1_off_macb128) || // mac13off28 
         (pwr1_off_macb128 && pwr1_off_macb228) || // mac12off28 
         (pwr1_off_macb328 && pwr1_off_macb028) || // mac03off28 
         (pwr1_off_macb228 && pwr1_off_macb028) || // mac02off28 
         (pwr1_off_macb128 && pwr1_off_macb028))  // mac01off28 
       begin
         ase_core_12v28 = 0;
         ase_core_10v28 = 0;
         ase_core_08v28 = 1;
         ase_core_06v28 = 0;
       end
     else if( (pwr1_off_smc28) || // smc28 off28
         (pwr1_off_macb028 ) || // mac0off28 
         (pwr1_off_macb128 ) || // mac1off28 
         (pwr1_off_macb228 ) || // mac2off28 
         (pwr1_off_macb328 ))  // mac3off28 
       begin
         ase_core_12v28 = 0;
         ase_core_10v28 = 1;
         ase_core_08v28 = 0;
         ase_core_06v28 = 0;
       end
     else if (pwr1_off_urt28)
       begin
         ase_core_12v28 = 1;
         ase_core_10v28 = 0;
         ase_core_08v28 = 0;
         ase_core_06v28 = 0;
       end
     else
       begin
         ase_core_12v28 = 1;
         ase_core_10v28 = 0;
         ase_core_08v28 = 0;
         ase_core_06v28 = 0;
       end
   end


   // cpu28
   // cpu28 @ 1.0v when macoff28, 
   // 
   reg ase_cpu_10v28, ase_cpu_12v28;
   always @(*) begin
    if(pwr1_off_cpu28) begin
     ase_cpu_12v28 = 1'b0;
     ase_cpu_10v28 = 1'b0;
    end
    else if(pwr1_off_macb028 || pwr1_off_macb128 || pwr1_off_macb228 || pwr1_off_macb328)
    begin
     ase_cpu_12v28 = 1'b0;
     ase_cpu_10v28 = 1'b1;
    end
    else
    begin
     ase_cpu_12v28 = 1'b1;
     ase_cpu_10v28 = 1'b0;
    end
   end

   // dma28
   // dma28 @v128.0 for macoff28, 

   reg ase_dma_10v28, ase_dma_12v28;
   always @(*) begin
    if(pwr1_off_dma28) begin
     ase_dma_12v28 = 1'b0;
     ase_dma_10v28 = 1'b0;
    end
    else if(pwr1_off_macb028 || pwr1_off_macb128 || pwr1_off_macb228 || pwr1_off_macb328)
    begin
     ase_dma_12v28 = 1'b0;
     ase_dma_10v28 = 1'b1;
    end
    else
    begin
     ase_dma_12v28 = 1'b1;
     ase_dma_10v28 = 1'b0;
    end
   end

   // alut28
   // @ v128.0 for macoff28

   reg ase_alut_10v28, ase_alut_12v28;
   always @(*) begin
    if(pwr1_off_alut28) begin
     ase_alut_12v28 = 1'b0;
     ase_alut_10v28 = 1'b0;
    end
    else if(pwr1_off_macb028 || pwr1_off_macb128 || pwr1_off_macb228 || pwr1_off_macb328)
    begin
     ase_alut_12v28 = 1'b0;
     ase_alut_10v28 = 1'b1;
    end
    else
    begin
     ase_alut_12v28 = 1'b1;
     ase_alut_10v28 = 1'b0;
    end
   end




   reg ase_uart_12v28;
   reg ase_uart_10v28;
   reg ase_uart_08v28;
   reg ase_uart_06v28;

   reg ase_smc_12v28;


   always @(*) begin
     if(pwr1_off_urt28) begin // uart28 off28
       ase_uart_08v28 = 1'b0;
       ase_uart_06v28 = 1'b0;
       ase_uart_10v28 = 1'b0;
       ase_uart_12v28 = 1'b0;
     end 
     else if( (pwr1_off_macb028 && pwr1_off_macb128 && pwr1_off_macb228 && pwr1_off_macb328) || // all mac28 off28
       (pwr1_off_macb328 && pwr1_off_macb228 && pwr1_off_macb128) || // mac123off28 
       (pwr1_off_macb328 && pwr1_off_macb228 && pwr1_off_macb028) || // mac023off28 
       (pwr1_off_macb328 && pwr1_off_macb128 && pwr1_off_macb028) || // mac013off28 
       (pwr1_off_macb228 && pwr1_off_macb128 && pwr1_off_macb028) )  // mac012off28 
     begin
       ase_uart_06v28 = 1'b1;
       ase_uart_08v28 = 1'b0;
       ase_uart_10v28 = 1'b0;
       ase_uart_12v28 = 1'b0;
     end
     else if( (pwr1_off_macb228 && pwr1_off_macb328) || // mac2328 off28
         (pwr1_off_macb328 && pwr1_off_macb128) || // mac13off28 
         (pwr1_off_macb128 && pwr1_off_macb228) || // mac12off28 
         (pwr1_off_macb328 && pwr1_off_macb028) || // mac03off28 
         (pwr1_off_macb128 && pwr1_off_macb028))  // mac01off28  
     begin
       ase_uart_06v28 = 1'b0;
       ase_uart_08v28 = 1'b1;
       ase_uart_10v28 = 1'b0;
       ase_uart_12v28 = 1'b0;
     end
     else if (pwr1_off_smc28 || pwr1_off_macb028 || pwr1_off_macb128 || pwr1_off_macb228 || pwr1_off_macb328) begin // smc28 off28
       ase_uart_08v28 = 1'b0;
       ase_uart_06v28 = 1'b0;
       ase_uart_10v28 = 1'b1;
       ase_uart_12v28 = 1'b0;
     end 
     else begin
       ase_uart_08v28 = 1'b0;
       ase_uart_06v28 = 1'b0;
       ase_uart_10v28 = 1'b0;
       ase_uart_12v28 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc28) begin
     if (pwr1_off_smc28)  // smc28 off28
       ase_smc_12v28 = 1'b0;
    else
       ase_smc_12v28 = 1'b1;
   end

   
   always @(pwr1_off_macb028) begin
     if (pwr1_off_macb028) // macb028 off28
       ase_macb0_12v28 = 1'b0;
     else
       ase_macb0_12v28 = 1'b1;
   end

   always @(pwr1_off_macb128) begin
     if (pwr1_off_macb128) // macb128 off28
       ase_macb1_12v28 = 1'b0;
     else
       ase_macb1_12v28 = 1'b1;
   end

   always @(pwr1_off_macb228) begin // macb228 off28
     if (pwr1_off_macb228) // macb228 off28
       ase_macb2_12v28 = 1'b0;
     else
       ase_macb2_12v28 = 1'b1;
   end

   always @(pwr1_off_macb328) begin // macb328 off28
     if (pwr1_off_macb328) // macb328 off28
       ase_macb3_12v28 = 1'b0;
     else
       ase_macb3_12v28 = 1'b1;
   end


   // core28 voltage28 for vco28
  assign core12v28 = ase_macb0_12v28 & ase_macb1_12v28 & ase_macb2_12v28 & ase_macb3_12v28;

  assign core10v28 =  (ase_macb0_12v28 & ase_macb1_12v28 & ase_macb2_12v28 & (!ase_macb3_12v28)) ||
                    (ase_macb0_12v28 & ase_macb1_12v28 & (!ase_macb2_12v28) & ase_macb3_12v28) ||
                    (ase_macb0_12v28 & (!ase_macb1_12v28) & ase_macb2_12v28 & ase_macb3_12v28) ||
                    ((!ase_macb0_12v28) & ase_macb1_12v28 & ase_macb2_12v28 & ase_macb3_12v28);

  assign core08v28 =  ((!ase_macb0_12v28) & (!ase_macb1_12v28) & (ase_macb2_12v28) & (ase_macb3_12v28)) ||
                    ((!ase_macb0_12v28) & (ase_macb1_12v28) & (!ase_macb2_12v28) & (ase_macb3_12v28)) ||
                    ((!ase_macb0_12v28) & (ase_macb1_12v28) & (ase_macb2_12v28) & (!ase_macb3_12v28)) ||
                    ((ase_macb0_12v28) & (!ase_macb1_12v28) & (!ase_macb2_12v28) & (ase_macb3_12v28)) ||
                    ((ase_macb0_12v28) & (!ase_macb1_12v28) & (ase_macb2_12v28) & (!ase_macb3_12v28)) ||
                    ((ase_macb0_12v28) & (ase_macb1_12v28) & (!ase_macb2_12v28) & (!ase_macb3_12v28));

  assign core06v28 =  ((!ase_macb0_12v28) & (!ase_macb1_12v28) & (!ase_macb2_12v28) & (ase_macb3_12v28)) ||
                    ((!ase_macb0_12v28) & (!ase_macb1_12v28) & (ase_macb2_12v28) & (!ase_macb3_12v28)) ||
                    ((!ase_macb0_12v28) & (ase_macb1_12v28) & (!ase_macb2_12v28) & (!ase_macb3_12v28)) ||
                    ((ase_macb0_12v28) & (!ase_macb1_12v28) & (!ase_macb2_12v28) & (!ase_macb3_12v28)) ||
                    ((!ase_macb0_12v28) & (!ase_macb1_12v28) & (!ase_macb2_12v28) & (!ase_macb3_12v28)) ;



`ifdef LP_ABV_ON28
// psl28 default clock28 = (posedge pclk28);

// Cover28 a condition in which SMC28 is powered28 down
// and again28 powered28 up while UART28 is going28 into POWER28 down
// state or UART28 is already in POWER28 DOWN28 state
// psl28 cover_overlapping_smc_urt_128:
//    cover{fell28(pwr1_on_urt28);[*];fell28(pwr1_on_smc28);[*];
//    rose28(pwr1_on_smc28);[*];rose28(pwr1_on_urt28)};
//
// Cover28 a condition in which UART28 is powered28 down
// and again28 powered28 up while SMC28 is going28 into POWER28 down
// state or SMC28 is already in POWER28 DOWN28 state
// psl28 cover_overlapping_smc_urt_228:
//    cover{fell28(pwr1_on_smc28);[*];fell28(pwr1_on_urt28);[*];
//    rose28(pwr1_on_urt28);[*];rose28(pwr1_on_smc28)};
//


// Power28 Down28 UART28
// This28 gets28 triggered on rising28 edge of Gate28 signal28 for
// UART28 (gate_clk_urt28). In a next cycle after gate_clk_urt28,
// Isolate28 UART28(isolate_urt28) signal28 become28 HIGH28 (active).
// In 2nd cycle after gate_clk_urt28 becomes HIGH28, RESET28 for NON28
// SRPG28 FFs28(rstn_non_srpg_urt28) and POWER128 for UART28(pwr1_on_urt28) should 
// go28 LOW28. 
// This28 completes28 a POWER28 DOWN28. 

sequence s_power_down_urt28;
      (gate_clk_urt28 & !isolate_urt28 & rstn_non_srpg_urt28 & pwr1_on_urt28) 
  ##1 (gate_clk_urt28 & isolate_urt28 & rstn_non_srpg_urt28 & pwr1_on_urt28) 
  ##3 (gate_clk_urt28 & isolate_urt28 & !rstn_non_srpg_urt28 & !pwr1_on_urt28);
endsequence


property p_power_down_urt28;
   @(posedge pclk28)
    $rose(gate_clk_urt28) |=> s_power_down_urt28;
endproperty

output_power_down_urt28:
  assert property (p_power_down_urt28);


// Power28 UP28 UART28
// Sequence starts with , Rising28 edge of pwr1_on_urt28.
// Two28 clock28 cycle after this, isolate_urt28 should become28 LOW28 
// On28 the following28 clk28 gate_clk_urt28 should go28 low28.
// 5 cycles28 after  Rising28 edge of pwr1_on_urt28, rstn_non_srpg_urt28
// should become28 HIGH28
sequence s_power_up_urt28;
##30 (pwr1_on_urt28 & !isolate_urt28 & gate_clk_urt28 & !rstn_non_srpg_urt28) 
##1 (pwr1_on_urt28 & !isolate_urt28 & !gate_clk_urt28 & !rstn_non_srpg_urt28) 
##2 (pwr1_on_urt28 & !isolate_urt28 & !gate_clk_urt28 & rstn_non_srpg_urt28);
endsequence

property p_power_up_urt28;
   @(posedge pclk28)
  disable iff(!nprst28)
    (!pwr1_on_urt28 ##1 pwr1_on_urt28) |=> s_power_up_urt28;
endproperty

output_power_up_urt28:
  assert property (p_power_up_urt28);


// Power28 Down28 SMC28
// This28 gets28 triggered on rising28 edge of Gate28 signal28 for
// SMC28 (gate_clk_smc28). In a next cycle after gate_clk_smc28,
// Isolate28 SMC28(isolate_smc28) signal28 become28 HIGH28 (active).
// In 2nd cycle after gate_clk_smc28 becomes HIGH28, RESET28 for NON28
// SRPG28 FFs28(rstn_non_srpg_smc28) and POWER128 for SMC28(pwr1_on_smc28) should 
// go28 LOW28. 
// This28 completes28 a POWER28 DOWN28. 

sequence s_power_down_smc28;
      (gate_clk_smc28 & !isolate_smc28 & rstn_non_srpg_smc28 & pwr1_on_smc28) 
  ##1 (gate_clk_smc28 & isolate_smc28 & rstn_non_srpg_smc28 & pwr1_on_smc28) 
  ##3 (gate_clk_smc28 & isolate_smc28 & !rstn_non_srpg_smc28 & !pwr1_on_smc28);
endsequence


property p_power_down_smc28;
   @(posedge pclk28)
    $rose(gate_clk_smc28) |=> s_power_down_smc28;
endproperty

output_power_down_smc28:
  assert property (p_power_down_smc28);


// Power28 UP28 SMC28
// Sequence starts with , Rising28 edge of pwr1_on_smc28.
// Two28 clock28 cycle after this, isolate_smc28 should become28 LOW28 
// On28 the following28 clk28 gate_clk_smc28 should go28 low28.
// 5 cycles28 after  Rising28 edge of pwr1_on_smc28, rstn_non_srpg_smc28
// should become28 HIGH28
sequence s_power_up_smc28;
##30 (pwr1_on_smc28 & !isolate_smc28 & gate_clk_smc28 & !rstn_non_srpg_smc28) 
##1 (pwr1_on_smc28 & !isolate_smc28 & !gate_clk_smc28 & !rstn_non_srpg_smc28) 
##2 (pwr1_on_smc28 & !isolate_smc28 & !gate_clk_smc28 & rstn_non_srpg_smc28);
endsequence

property p_power_up_smc28;
   @(posedge pclk28)
  disable iff(!nprst28)
    (!pwr1_on_smc28 ##1 pwr1_on_smc28) |=> s_power_up_smc28;
endproperty

output_power_up_smc28:
  assert property (p_power_up_smc28);


// COVER28 SMC28 POWER28 DOWN28 AND28 UP28
cover_power_down_up_smc28: cover property (@(posedge pclk28)
(s_power_down_smc28 ##[5:180] s_power_up_smc28));



// COVER28 UART28 POWER28 DOWN28 AND28 UP28
cover_power_down_up_urt28: cover property (@(posedge pclk28)
(s_power_down_urt28 ##[5:180] s_power_up_urt28));

cover_power_down_urt28: cover property (@(posedge pclk28)
(s_power_down_urt28));

cover_power_up_urt28: cover property (@(posedge pclk28)
(s_power_up_urt28));




`ifdef PCM_ABV_ON28
//------------------------------------------------------------------------------
// Power28 Controller28 Formal28 Verification28 component.  Each power28 domain has a 
// separate28 instantiation28
//------------------------------------------------------------------------------

// need to assume that CPU28 will leave28 a minimum time between powering28 down and 
// back up.  In this example28, 10clks has been selected.
// psl28 config_min_uart_pd_time28 : assume always {rose28(L1_ctrl_domain28[1])} |-> { L1_ctrl_domain28[1][*10] } abort28(~nprst28);
// psl28 config_min_uart_pu_time28 : assume always {fell28(L1_ctrl_domain28[1])} |-> { !L1_ctrl_domain28[1][*10] } abort28(~nprst28);
// psl28 config_min_smc_pd_time28 : assume always {rose28(L1_ctrl_domain28[2])} |-> { L1_ctrl_domain28[2][*10] } abort28(~nprst28);
// psl28 config_min_smc_pu_time28 : assume always {fell28(L1_ctrl_domain28[2])} |-> { !L1_ctrl_domain28[2][*10] } abort28(~nprst28);

// UART28 VCOMP28 parameters28
   defparam i_uart_vcomp_domain28.ENABLE_SAVE_RESTORE_EDGE28   = 1;
   defparam i_uart_vcomp_domain28.ENABLE_EXT_PWR_CNTRL28       = 1;
   defparam i_uart_vcomp_domain28.REF_CLK_DEFINED28            = 0;
   defparam i_uart_vcomp_domain28.MIN_SHUTOFF_CYCLES28         = 4;
   defparam i_uart_vcomp_domain28.MIN_RESTORE_TO_ISO_CYCLES28  = 0;
   defparam i_uart_vcomp_domain28.MIN_SAVE_TO_SHUTOFF_CYCLES28 = 1;


   vcomp_domain28 i_uart_vcomp_domain28
   ( .ref_clk28(pclk28),
     .start_lps28(L1_ctrl_domain28[1] || !rstn_non_srpg_urt28),
     .rst_n28(nprst28),
     .ext_power_down28(L1_ctrl_domain28[1]),
     .iso_en28(isolate_urt28),
     .save_edge28(save_edge_urt28),
     .restore_edge28(restore_edge_urt28),
     .domain_shut_off28(pwr1_off_urt28),
     .domain_clk28(!gate_clk_urt28 && pclk28)
   );


// SMC28 VCOMP28 parameters28
   defparam i_smc_vcomp_domain28.ENABLE_SAVE_RESTORE_EDGE28   = 1;
   defparam i_smc_vcomp_domain28.ENABLE_EXT_PWR_CNTRL28       = 1;
   defparam i_smc_vcomp_domain28.REF_CLK_DEFINED28            = 0;
   defparam i_smc_vcomp_domain28.MIN_SHUTOFF_CYCLES28         = 4;
   defparam i_smc_vcomp_domain28.MIN_RESTORE_TO_ISO_CYCLES28  = 0;
   defparam i_smc_vcomp_domain28.MIN_SAVE_TO_SHUTOFF_CYCLES28 = 1;


   vcomp_domain28 i_smc_vcomp_domain28
   ( .ref_clk28(pclk28),
     .start_lps28(L1_ctrl_domain28[2] || !rstn_non_srpg_smc28),
     .rst_n28(nprst28),
     .ext_power_down28(L1_ctrl_domain28[2]),
     .iso_en28(isolate_smc28),
     .save_edge28(save_edge_smc28),
     .restore_edge28(restore_edge_smc28),
     .domain_shut_off28(pwr1_off_smc28),
     .domain_clk28(!gate_clk_smc28 && pclk28)
   );

`endif

`endif



endmodule
