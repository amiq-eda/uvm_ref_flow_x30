//File2 name   : power_ctrl2.v
//Title2       : Power2 Control2 Module2
//Created2     : 1999
//Description2 : Top2 level of power2 controller2
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

module power_ctrl2 (


    // Clocks2 & Reset2
    pclk2,
    nprst2,
    // APB2 programming2 interface
    paddr2,
    psel2,
    penable2,
    pwrite2,
    pwdata2,
    prdata2,
    // mac2 i/f,
    macb3_wakeup2,
    macb2_wakeup2,
    macb1_wakeup2,
    macb0_wakeup2,
    // Scan2 
    scan_in2,
    scan_en2,
    scan_mode2,
    scan_out2,
    // Module2 control2 outputs2
    int_source_h2,
    // SMC2
    rstn_non_srpg_smc2,
    gate_clk_smc2,
    isolate_smc2,
    save_edge_smc2,
    restore_edge_smc2,
    pwr1_on_smc2,
    pwr2_on_smc2,
    pwr1_off_smc2,
    pwr2_off_smc2,
    // URT2
    rstn_non_srpg_urt2,
    gate_clk_urt2,
    isolate_urt2,
    save_edge_urt2,
    restore_edge_urt2,
    pwr1_on_urt2,
    pwr2_on_urt2,
    pwr1_off_urt2,      
    pwr2_off_urt2,
    // ETH02
    rstn_non_srpg_macb02,
    gate_clk_macb02,
    isolate_macb02,
    save_edge_macb02,
    restore_edge_macb02,
    pwr1_on_macb02,
    pwr2_on_macb02,
    pwr1_off_macb02,      
    pwr2_off_macb02,
    // ETH12
    rstn_non_srpg_macb12,
    gate_clk_macb12,
    isolate_macb12,
    save_edge_macb12,
    restore_edge_macb12,
    pwr1_on_macb12,
    pwr2_on_macb12,
    pwr1_off_macb12,      
    pwr2_off_macb12,
    // ETH22
    rstn_non_srpg_macb22,
    gate_clk_macb22,
    isolate_macb22,
    save_edge_macb22,
    restore_edge_macb22,
    pwr1_on_macb22,
    pwr2_on_macb22,
    pwr1_off_macb22,      
    pwr2_off_macb22,
    // ETH32
    rstn_non_srpg_macb32,
    gate_clk_macb32,
    isolate_macb32,
    save_edge_macb32,
    restore_edge_macb32,
    pwr1_on_macb32,
    pwr2_on_macb32,
    pwr1_off_macb32,      
    pwr2_off_macb32,
    // DMA2
    rstn_non_srpg_dma2,
    gate_clk_dma2,
    isolate_dma2,
    save_edge_dma2,
    restore_edge_dma2,
    pwr1_on_dma2,
    pwr2_on_dma2,
    pwr1_off_dma2,      
    pwr2_off_dma2,
    // CPU2
    rstn_non_srpg_cpu2,
    gate_clk_cpu2,
    isolate_cpu2,
    save_edge_cpu2,
    restore_edge_cpu2,
    pwr1_on_cpu2,
    pwr2_on_cpu2,
    pwr1_off_cpu2,      
    pwr2_off_cpu2,
    // ALUT2
    rstn_non_srpg_alut2,
    gate_clk_alut2,
    isolate_alut2,
    save_edge_alut2,
    restore_edge_alut2,
    pwr1_on_alut2,
    pwr2_on_alut2,
    pwr1_off_alut2,      
    pwr2_off_alut2,
    // MEM2
    rstn_non_srpg_mem2,
    gate_clk_mem2,
    isolate_mem2,
    save_edge_mem2,
    restore_edge_mem2,
    pwr1_on_mem2,
    pwr2_on_mem2,
    pwr1_off_mem2,      
    pwr2_off_mem2,
    // core2 dvfs2 transitions2
    core06v2,
    core08v2,
    core10v2,
    core12v2,
    pcm_macb_wakeup_int2,
    // mte2 signals2
    mte_smc_start2,
    mte_uart_start2,
    mte_smc_uart_start2,  
    mte_pm_smc_to_default_start2, 
    mte_pm_uart_to_default_start2,
    mte_pm_smc_uart_to_default_start2

  );

  parameter STATE_IDLE_12V2 = 4'b0001;
  parameter STATE_06V2 = 4'b0010;
  parameter STATE_08V2 = 4'b0100;
  parameter STATE_10V2 = 4'b1000;

    // Clocks2 & Reset2
    input pclk2;
    input nprst2;
    // APB2 programming2 interface
    input [31:0] paddr2;
    input psel2  ;
    input penable2;
    input pwrite2 ;
    input [31:0] pwdata2;
    output [31:0] prdata2;
    // mac2
    input macb3_wakeup2;
    input macb2_wakeup2;
    input macb1_wakeup2;
    input macb0_wakeup2;
    // Scan2 
    input scan_in2;
    input scan_en2;
    input scan_mode2;
    output scan_out2;
    // Module2 control2 outputs2
    input int_source_h2;
    // SMC2
    output rstn_non_srpg_smc2 ;
    output gate_clk_smc2   ;
    output isolate_smc2   ;
    output save_edge_smc2   ;
    output restore_edge_smc2   ;
    output pwr1_on_smc2   ;
    output pwr2_on_smc2   ;
    output pwr1_off_smc2  ;
    output pwr2_off_smc2  ;
    // URT2
    output rstn_non_srpg_urt2 ;
    output gate_clk_urt2      ;
    output isolate_urt2       ;
    output save_edge_urt2   ;
    output restore_edge_urt2   ;
    output pwr1_on_urt2       ;
    output pwr2_on_urt2       ;
    output pwr1_off_urt2      ;
    output pwr2_off_urt2      ;
    // ETH02
    output rstn_non_srpg_macb02 ;
    output gate_clk_macb02      ;
    output isolate_macb02       ;
    output save_edge_macb02   ;
    output restore_edge_macb02   ;
    output pwr1_on_macb02       ;
    output pwr2_on_macb02       ;
    output pwr1_off_macb02      ;
    output pwr2_off_macb02      ;
    // ETH12
    output rstn_non_srpg_macb12 ;
    output gate_clk_macb12      ;
    output isolate_macb12       ;
    output save_edge_macb12   ;
    output restore_edge_macb12   ;
    output pwr1_on_macb12       ;
    output pwr2_on_macb12       ;
    output pwr1_off_macb12      ;
    output pwr2_off_macb12      ;
    // ETH22
    output rstn_non_srpg_macb22 ;
    output gate_clk_macb22      ;
    output isolate_macb22       ;
    output save_edge_macb22   ;
    output restore_edge_macb22   ;
    output pwr1_on_macb22       ;
    output pwr2_on_macb22       ;
    output pwr1_off_macb22      ;
    output pwr2_off_macb22      ;
    // ETH32
    output rstn_non_srpg_macb32 ;
    output gate_clk_macb32      ;
    output isolate_macb32       ;
    output save_edge_macb32   ;
    output restore_edge_macb32   ;
    output pwr1_on_macb32       ;
    output pwr2_on_macb32       ;
    output pwr1_off_macb32      ;
    output pwr2_off_macb32      ;
    // DMA2
    output rstn_non_srpg_dma2 ;
    output gate_clk_dma2      ;
    output isolate_dma2       ;
    output save_edge_dma2   ;
    output restore_edge_dma2   ;
    output pwr1_on_dma2       ;
    output pwr2_on_dma2       ;
    output pwr1_off_dma2      ;
    output pwr2_off_dma2      ;
    // CPU2
    output rstn_non_srpg_cpu2 ;
    output gate_clk_cpu2      ;
    output isolate_cpu2       ;
    output save_edge_cpu2   ;
    output restore_edge_cpu2   ;
    output pwr1_on_cpu2       ;
    output pwr2_on_cpu2       ;
    output pwr1_off_cpu2      ;
    output pwr2_off_cpu2      ;
    // ALUT2
    output rstn_non_srpg_alut2 ;
    output gate_clk_alut2      ;
    output isolate_alut2       ;
    output save_edge_alut2   ;
    output restore_edge_alut2   ;
    output pwr1_on_alut2       ;
    output pwr2_on_alut2       ;
    output pwr1_off_alut2      ;
    output pwr2_off_alut2      ;
    // MEM2
    output rstn_non_srpg_mem2 ;
    output gate_clk_mem2      ;
    output isolate_mem2       ;
    output save_edge_mem2   ;
    output restore_edge_mem2   ;
    output pwr1_on_mem2       ;
    output pwr2_on_mem2       ;
    output pwr1_off_mem2      ;
    output pwr2_off_mem2      ;


   // core2 transitions2 o/p
    output core06v2;
    output core08v2;
    output core10v2;
    output core12v2;
    output pcm_macb_wakeup_int2 ;
    //mode mte2  signals2
    output mte_smc_start2;
    output mte_uart_start2;
    output mte_smc_uart_start2;  
    output mte_pm_smc_to_default_start2; 
    output mte_pm_uart_to_default_start2;
    output mte_pm_smc_uart_to_default_start2;

    reg mte_smc_start2;
    reg mte_uart_start2;
    reg mte_smc_uart_start2;  
    reg mte_pm_smc_to_default_start2; 
    reg mte_pm_uart_to_default_start2;
    reg mte_pm_smc_uart_to_default_start2;

    reg [31:0] prdata2;

  wire valid_reg_write2  ;
  wire valid_reg_read2   ;
  wire L1_ctrl_access2   ;
  wire L1_status_access2 ;
  wire pcm_int_mask_access2;
  wire pcm_int_status_access2;
  wire standby_mem02      ;
  wire standby_mem12      ;
  wire standby_mem22      ;
  wire standby_mem32      ;
  wire pwr1_off_mem02;
  wire pwr1_off_mem12;
  wire pwr1_off_mem22;
  wire pwr1_off_mem32;
  
  // Control2 signals2
  wire set_status_smc2   ;
  wire clr_status_smc2   ;
  wire set_status_urt2   ;
  wire clr_status_urt2   ;
  wire set_status_macb02   ;
  wire clr_status_macb02   ;
  wire set_status_macb12   ;
  wire clr_status_macb12   ;
  wire set_status_macb22   ;
  wire clr_status_macb22   ;
  wire set_status_macb32   ;
  wire clr_status_macb32   ;
  wire set_status_dma2   ;
  wire clr_status_dma2   ;
  wire set_status_cpu2   ;
  wire clr_status_cpu2   ;
  wire set_status_alut2   ;
  wire clr_status_alut2   ;
  wire set_status_mem2   ;
  wire clr_status_mem2   ;


  // Status and Control2 registers
  reg [31:0]  L1_status_reg2;
  reg  [31:0] L1_ctrl_reg2  ;
  reg  [31:0] L1_ctrl_domain2  ;
  reg L1_ctrl_cpu_off_reg2;
  reg [31:0]  pcm_mask_reg2;
  reg [31:0]  pcm_status_reg2;

  // Signals2 gated2 in scan_mode2
  //SMC2
  wire  rstn_non_srpg_smc_int2;
  wire  gate_clk_smc_int2    ;     
  wire  isolate_smc_int2    ;       
  wire save_edge_smc_int2;
  wire restore_edge_smc_int2;
  wire  pwr1_on_smc_int2    ;      
  wire  pwr2_on_smc_int2    ;      


  //URT2
  wire   rstn_non_srpg_urt_int2;
  wire   gate_clk_urt_int2     ;     
  wire   isolate_urt_int2      ;       
  wire save_edge_urt_int2;
  wire restore_edge_urt_int2;
  wire   pwr1_on_urt_int2      ;      
  wire   pwr2_on_urt_int2      ;      

  // ETH02
  wire   rstn_non_srpg_macb0_int2;
  wire   gate_clk_macb0_int2     ;     
  wire   isolate_macb0_int2      ;       
  wire save_edge_macb0_int2;
  wire restore_edge_macb0_int2;
  wire   pwr1_on_macb0_int2      ;      
  wire   pwr2_on_macb0_int2      ;      
  // ETH12
  wire   rstn_non_srpg_macb1_int2;
  wire   gate_clk_macb1_int2     ;     
  wire   isolate_macb1_int2      ;       
  wire save_edge_macb1_int2;
  wire restore_edge_macb1_int2;
  wire   pwr1_on_macb1_int2      ;      
  wire   pwr2_on_macb1_int2      ;      
  // ETH22
  wire   rstn_non_srpg_macb2_int2;
  wire   gate_clk_macb2_int2     ;     
  wire   isolate_macb2_int2      ;       
  wire save_edge_macb2_int2;
  wire restore_edge_macb2_int2;
  wire   pwr1_on_macb2_int2      ;      
  wire   pwr2_on_macb2_int2      ;      
  // ETH32
  wire   rstn_non_srpg_macb3_int2;
  wire   gate_clk_macb3_int2     ;     
  wire   isolate_macb3_int2      ;       
  wire save_edge_macb3_int2;
  wire restore_edge_macb3_int2;
  wire   pwr1_on_macb3_int2      ;      
  wire   pwr2_on_macb3_int2      ;      

  // DMA2
  wire   rstn_non_srpg_dma_int2;
  wire   gate_clk_dma_int2     ;     
  wire   isolate_dma_int2      ;       
  wire save_edge_dma_int2;
  wire restore_edge_dma_int2;
  wire   pwr1_on_dma_int2      ;      
  wire   pwr2_on_dma_int2      ;      

  // CPU2
  wire   rstn_non_srpg_cpu_int2;
  wire   gate_clk_cpu_int2     ;     
  wire   isolate_cpu_int2      ;       
  wire save_edge_cpu_int2;
  wire restore_edge_cpu_int2;
  wire   pwr1_on_cpu_int2      ;      
  wire   pwr2_on_cpu_int2      ;  
  wire L1_ctrl_cpu_off_p2;    

  reg save_alut_tmp2;
  // DFS2 sm2

  reg cpu_shutoff_ctrl2;

  reg mte_mac_off_start2, mte_mac012_start2, mte_mac013_start2, mte_mac023_start2, mte_mac123_start2;
  reg mte_mac01_start2, mte_mac02_start2, mte_mac03_start2, mte_mac12_start2, mte_mac13_start2, mte_mac23_start2;
  reg mte_mac0_start2, mte_mac1_start2, mte_mac2_start2, mte_mac3_start2;
  reg mte_sys_hibernate2 ;
  reg mte_dma_start2 ;
  reg mte_cpu_start2 ;
  reg mte_mac_off_sleep_start2, mte_mac012_sleep_start2, mte_mac013_sleep_start2, mte_mac023_sleep_start2, mte_mac123_sleep_start2;
  reg mte_mac01_sleep_start2, mte_mac02_sleep_start2, mte_mac03_sleep_start2, mte_mac12_sleep_start2, mte_mac13_sleep_start2, mte_mac23_sleep_start2;
  reg mte_mac0_sleep_start2, mte_mac1_sleep_start2, mte_mac2_sleep_start2, mte_mac3_sleep_start2;
  reg mte_dma_sleep_start2;
  reg mte_mac_off_to_default2, mte_mac012_to_default2, mte_mac013_to_default2, mte_mac023_to_default2, mte_mac123_to_default2;
  reg mte_mac01_to_default2, mte_mac02_to_default2, mte_mac03_to_default2, mte_mac12_to_default2, mte_mac13_to_default2, mte_mac23_to_default2;
  reg mte_mac0_to_default2, mte_mac1_to_default2, mte_mac2_to_default2, mte_mac3_to_default2;
  reg mte_dma_isolate_dis2;
  reg mte_cpu_isolate_dis2;
  reg mte_sys_hibernate_to_default2;


  // Latch2 the CPU2 SLEEP2 invocation2
  always @( posedge pclk2 or negedge nprst2) 
  begin
    if(!nprst2)
      L1_ctrl_cpu_off_reg2 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg2 <= L1_ctrl_domain2[8];
  end

  // Create2 a pulse2 for sleep2 detection2 
  assign L1_ctrl_cpu_off_p2 =  L1_ctrl_domain2[8] && !L1_ctrl_cpu_off_reg2;
  
  // CPU2 sleep2 contol2 logic 
  // Shut2 off2 CPU2 when L1_ctrl_cpu_off_p2 is set
  // wake2 cpu2 when any interrupt2 is seen2  
  always @( posedge pclk2 or negedge nprst2) 
  begin
    if(!nprst2)
     cpu_shutoff_ctrl2 <= 1'b0;
    else if(cpu_shutoff_ctrl2 && int_source_h2)
     cpu_shutoff_ctrl2 <= 1'b0;
    else if (L1_ctrl_cpu_off_p2)
     cpu_shutoff_ctrl2 <= 1'b1;
  end
 
  // instantiate2 power2 contol2  block for uart2
  power_ctrl_sm2 i_urt_power_ctrl_sm2(
    .pclk2(pclk2),
    .nprst2(nprst2),
    .L1_module_req2(L1_ctrl_domain2[1]),
    .set_status_module2(set_status_urt2),
    .clr_status_module2(clr_status_urt2),
    .rstn_non_srpg_module2(rstn_non_srpg_urt_int2),
    .gate_clk_module2(gate_clk_urt_int2),
    .isolate_module2(isolate_urt_int2),
    .save_edge2(save_edge_urt_int2),
    .restore_edge2(restore_edge_urt_int2),
    .pwr1_on2(pwr1_on_urt_int2),
    .pwr2_on2(pwr2_on_urt_int2)
    );
  

  // instantiate2 power2 contol2  block for smc2
  power_ctrl_sm2 i_smc_power_ctrl_sm2(
    .pclk2(pclk2),
    .nprst2(nprst2),
    .L1_module_req2(L1_ctrl_domain2[2]),
    .set_status_module2(set_status_smc2),
    .clr_status_module2(clr_status_smc2),
    .rstn_non_srpg_module2(rstn_non_srpg_smc_int2),
    .gate_clk_module2(gate_clk_smc_int2),
    .isolate_module2(isolate_smc_int2),
    .save_edge2(save_edge_smc_int2),
    .restore_edge2(restore_edge_smc_int2),
    .pwr1_on2(pwr1_on_smc_int2),
    .pwr2_on2(pwr2_on_smc_int2)
    );

  // power2 control2 for macb02
  power_ctrl_sm2 i_macb0_power_ctrl_sm2(
    .pclk2(pclk2),
    .nprst2(nprst2),
    .L1_module_req2(L1_ctrl_domain2[3]),
    .set_status_module2(set_status_macb02),
    .clr_status_module2(clr_status_macb02),
    .rstn_non_srpg_module2(rstn_non_srpg_macb0_int2),
    .gate_clk_module2(gate_clk_macb0_int2),
    .isolate_module2(isolate_macb0_int2),
    .save_edge2(save_edge_macb0_int2),
    .restore_edge2(restore_edge_macb0_int2),
    .pwr1_on2(pwr1_on_macb0_int2),
    .pwr2_on2(pwr2_on_macb0_int2)
    );
  // power2 control2 for macb12
  power_ctrl_sm2 i_macb1_power_ctrl_sm2(
    .pclk2(pclk2),
    .nprst2(nprst2),
    .L1_module_req2(L1_ctrl_domain2[4]),
    .set_status_module2(set_status_macb12),
    .clr_status_module2(clr_status_macb12),
    .rstn_non_srpg_module2(rstn_non_srpg_macb1_int2),
    .gate_clk_module2(gate_clk_macb1_int2),
    .isolate_module2(isolate_macb1_int2),
    .save_edge2(save_edge_macb1_int2),
    .restore_edge2(restore_edge_macb1_int2),
    .pwr1_on2(pwr1_on_macb1_int2),
    .pwr2_on2(pwr2_on_macb1_int2)
    );
  // power2 control2 for macb22
  power_ctrl_sm2 i_macb2_power_ctrl_sm2(
    .pclk2(pclk2),
    .nprst2(nprst2),
    .L1_module_req2(L1_ctrl_domain2[5]),
    .set_status_module2(set_status_macb22),
    .clr_status_module2(clr_status_macb22),
    .rstn_non_srpg_module2(rstn_non_srpg_macb2_int2),
    .gate_clk_module2(gate_clk_macb2_int2),
    .isolate_module2(isolate_macb2_int2),
    .save_edge2(save_edge_macb2_int2),
    .restore_edge2(restore_edge_macb2_int2),
    .pwr1_on2(pwr1_on_macb2_int2),
    .pwr2_on2(pwr2_on_macb2_int2)
    );
  // power2 control2 for macb32
  power_ctrl_sm2 i_macb3_power_ctrl_sm2(
    .pclk2(pclk2),
    .nprst2(nprst2),
    .L1_module_req2(L1_ctrl_domain2[6]),
    .set_status_module2(set_status_macb32),
    .clr_status_module2(clr_status_macb32),
    .rstn_non_srpg_module2(rstn_non_srpg_macb3_int2),
    .gate_clk_module2(gate_clk_macb3_int2),
    .isolate_module2(isolate_macb3_int2),
    .save_edge2(save_edge_macb3_int2),
    .restore_edge2(restore_edge_macb3_int2),
    .pwr1_on2(pwr1_on_macb3_int2),
    .pwr2_on2(pwr2_on_macb3_int2)
    );
  // power2 control2 for dma2
  power_ctrl_sm2 i_dma_power_ctrl_sm2(
    .pclk2(pclk2),
    .nprst2(nprst2),
    .L1_module_req2(L1_ctrl_domain2[7]),
    .set_status_module2(set_status_dma2),
    .clr_status_module2(clr_status_dma2),
    .rstn_non_srpg_module2(rstn_non_srpg_dma_int2),
    .gate_clk_module2(gate_clk_dma_int2),
    .isolate_module2(isolate_dma_int2),
    .save_edge2(save_edge_dma_int2),
    .restore_edge2(restore_edge_dma_int2),
    .pwr1_on2(pwr1_on_dma_int2),
    .pwr2_on2(pwr2_on_dma_int2)
    );
  // power2 control2 for CPU2
  power_ctrl_sm2 i_cpu_power_ctrl_sm2(
    .pclk2(pclk2),
    .nprst2(nprst2),
    .L1_module_req2(cpu_shutoff_ctrl2),
    .set_status_module2(set_status_cpu2),
    .clr_status_module2(clr_status_cpu2),
    .rstn_non_srpg_module2(rstn_non_srpg_cpu_int2),
    .gate_clk_module2(gate_clk_cpu_int2),
    .isolate_module2(isolate_cpu_int2),
    .save_edge2(save_edge_cpu_int2),
    .restore_edge2(restore_edge_cpu_int2),
    .pwr1_on2(pwr1_on_cpu_int2),
    .pwr2_on2(pwr2_on_cpu_int2)
    );

  assign valid_reg_write2 =  (psel2 && pwrite2 && penable2);
  assign valid_reg_read2  =  (psel2 && (!pwrite2) && penable2);

  assign L1_ctrl_access2  =  (paddr2[15:0] == 16'b0000000000000100); 
  assign L1_status_access2 = (paddr2[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access2 =   (paddr2[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access2 = (paddr2[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control2 and status register
  always @(*)
  begin  
    if(valid_reg_read2 && L1_ctrl_access2) 
      prdata2 = L1_ctrl_reg2;
    else if (valid_reg_read2 && L1_status_access2)
      prdata2 = L1_status_reg2;
    else if (valid_reg_read2 && pcm_int_mask_access2)
      prdata2 = pcm_mask_reg2;
    else if (valid_reg_read2 && pcm_int_status_access2)
      prdata2 = pcm_status_reg2;
    else 
      prdata2 = 0;
  end

  assign set_status_mem2 =  (set_status_macb02 && set_status_macb12 && set_status_macb22 &&
                            set_status_macb32 && set_status_dma2 && set_status_cpu2);

  assign clr_status_mem2 =  (clr_status_macb02 && clr_status_macb12 && clr_status_macb22 &&
                            clr_status_macb32 && clr_status_dma2 && clr_status_cpu2);

  assign set_status_alut2 = (set_status_macb02 && set_status_macb12 && set_status_macb22 && set_status_macb32);

  assign clr_status_alut2 = (clr_status_macb02 || clr_status_macb12 || clr_status_macb22  || clr_status_macb32);

  // Write accesses to the control2 and status register
 
  always @(posedge pclk2 or negedge nprst2)
  begin
    if (!nprst2) begin
      L1_ctrl_reg2   <= 0;
      L1_status_reg2 <= 0;
      pcm_mask_reg2 <= 0;
    end else begin
      // CTRL2 reg updates2
      if (valid_reg_write2 && L1_ctrl_access2) 
        L1_ctrl_reg2 <= pwdata2; // Writes2 to the ctrl2 reg
      if (valid_reg_write2 && pcm_int_mask_access2) 
        pcm_mask_reg2 <= pwdata2; // Writes2 to the ctrl2 reg

      if (set_status_urt2 == 1'b1)  
        L1_status_reg2[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt2 == 1'b1) 
        L1_status_reg2[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc2 == 1'b1) 
        L1_status_reg2[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc2 == 1'b1) 
        L1_status_reg2[2] <= 1'b0; // Clear the status bit

      if (set_status_macb02 == 1'b1)  
        L1_status_reg2[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb02 == 1'b1) 
        L1_status_reg2[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb12 == 1'b1)  
        L1_status_reg2[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb12 == 1'b1) 
        L1_status_reg2[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb22 == 1'b1)  
        L1_status_reg2[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb22 == 1'b1) 
        L1_status_reg2[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb32 == 1'b1)  
        L1_status_reg2[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb32 == 1'b1) 
        L1_status_reg2[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma2 == 1'b1)  
        L1_status_reg2[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma2 == 1'b1) 
        L1_status_reg2[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu2 == 1'b1)  
        L1_status_reg2[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu2 == 1'b1) 
        L1_status_reg2[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut2 == 1'b1)  
        L1_status_reg2[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut2 == 1'b1) 
        L1_status_reg2[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem2 == 1'b1)  
        L1_status_reg2[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem2 == 1'b1) 
        L1_status_reg2[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused2 bits of pcm_status_reg2 are tied2 to 0
  always @(posedge pclk2 or negedge nprst2)
  begin
    if (!nprst2)
      pcm_status_reg2[31:4] <= 'b0;
    else  
      pcm_status_reg2[31:4] <= pcm_status_reg2[31:4];
  end
  
  // interrupt2 only of h/w assisted2 wakeup
  // MAC2 3
  always @(posedge pclk2 or negedge nprst2)
  begin
    if(!nprst2)
      pcm_status_reg2[3] <= 1'b0;
    else if (valid_reg_write2 && pcm_int_status_access2) 
      pcm_status_reg2[3] <= pwdata2[3];
    else if (macb3_wakeup2 & ~pcm_mask_reg2[3])
      pcm_status_reg2[3] <= 1'b1;
    else if (valid_reg_read2 && pcm_int_status_access2) 
      pcm_status_reg2[3] <= 1'b0;
    else
      pcm_status_reg2[3] <= pcm_status_reg2[3];
  end  
   
  // MAC2 2
  always @(posedge pclk2 or negedge nprst2)
  begin
    if(!nprst2)
      pcm_status_reg2[2] <= 1'b0;
    else if (valid_reg_write2 && pcm_int_status_access2) 
      pcm_status_reg2[2] <= pwdata2[2];
    else if (macb2_wakeup2 & ~pcm_mask_reg2[2])
      pcm_status_reg2[2] <= 1'b1;
    else if (valid_reg_read2 && pcm_int_status_access2) 
      pcm_status_reg2[2] <= 1'b0;
    else
      pcm_status_reg2[2] <= pcm_status_reg2[2];
  end  

  // MAC2 1
  always @(posedge pclk2 or negedge nprst2)
  begin
    if(!nprst2)
      pcm_status_reg2[1] <= 1'b0;
    else if (valid_reg_write2 && pcm_int_status_access2) 
      pcm_status_reg2[1] <= pwdata2[1];
    else if (macb1_wakeup2 & ~pcm_mask_reg2[1])
      pcm_status_reg2[1] <= 1'b1;
    else if (valid_reg_read2 && pcm_int_status_access2) 
      pcm_status_reg2[1] <= 1'b0;
    else
      pcm_status_reg2[1] <= pcm_status_reg2[1];
  end  
   
  // MAC2 0
  always @(posedge pclk2 or negedge nprst2)
  begin
    if(!nprst2)
      pcm_status_reg2[0] <= 1'b0;
    else if (valid_reg_write2 && pcm_int_status_access2) 
      pcm_status_reg2[0] <= pwdata2[0];
    else if (macb0_wakeup2 & ~pcm_mask_reg2[0])
      pcm_status_reg2[0] <= 1'b1;
    else if (valid_reg_read2 && pcm_int_status_access2) 
      pcm_status_reg2[0] <= 1'b0;
    else
      pcm_status_reg2[0] <= pcm_status_reg2[0];
  end  

  assign pcm_macb_wakeup_int2 = |pcm_status_reg2;

  reg [31:0] L1_ctrl_reg12;
  always @(posedge pclk2 or negedge nprst2)
  begin
    if(!nprst2)
      L1_ctrl_reg12 <= 0;
    else
      L1_ctrl_reg12 <= L1_ctrl_reg2;
  end

  // Program2 mode decode
  always @(L1_ctrl_reg2 or L1_ctrl_reg12 or int_source_h2 or cpu_shutoff_ctrl2) begin
    mte_smc_start2 = 0;
    mte_uart_start2 = 0;
    mte_smc_uart_start2  = 0;
    mte_mac_off_start2  = 0;
    mte_mac012_start2 = 0;
    mte_mac013_start2 = 0;
    mte_mac023_start2 = 0;
    mte_mac123_start2 = 0;
    mte_mac01_start2 = 0;
    mte_mac02_start2 = 0;
    mte_mac03_start2 = 0;
    mte_mac12_start2 = 0;
    mte_mac13_start2 = 0;
    mte_mac23_start2 = 0;
    mte_mac0_start2 = 0;
    mte_mac1_start2 = 0;
    mte_mac2_start2 = 0;
    mte_mac3_start2 = 0;
    mte_sys_hibernate2 = 0 ;
    mte_dma_start2 = 0 ;
    mte_cpu_start2 = 0 ;

    mte_mac0_sleep_start2 = (L1_ctrl_reg2 ==  'h14) && (L1_ctrl_reg12 == 'h4 );
    mte_mac1_sleep_start2 = (L1_ctrl_reg2 ==  'h14) && (L1_ctrl_reg12 == 'h5 ); 
    mte_mac2_sleep_start2 = (L1_ctrl_reg2 ==  'h14) && (L1_ctrl_reg12 == 'h6 ); 
    mte_mac3_sleep_start2 = (L1_ctrl_reg2 ==  'h14) && (L1_ctrl_reg12 == 'h7 ); 
    mte_mac01_sleep_start2 = (L1_ctrl_reg2 ==  'h14) && (L1_ctrl_reg12 == 'h8 ); 
    mte_mac02_sleep_start2 = (L1_ctrl_reg2 ==  'h14) && (L1_ctrl_reg12 == 'h9 ); 
    mte_mac03_sleep_start2 = (L1_ctrl_reg2 ==  'h14) && (L1_ctrl_reg12 == 'hA ); 
    mte_mac12_sleep_start2 = (L1_ctrl_reg2 ==  'h14) && (L1_ctrl_reg12 == 'hB ); 
    mte_mac13_sleep_start2 = (L1_ctrl_reg2 ==  'h14) && (L1_ctrl_reg12 == 'hC ); 
    mte_mac23_sleep_start2 = (L1_ctrl_reg2 ==  'h14) && (L1_ctrl_reg12 == 'hD ); 
    mte_mac012_sleep_start2 = (L1_ctrl_reg2 ==  'h14) && (L1_ctrl_reg12 == 'hE ); 
    mte_mac013_sleep_start2 = (L1_ctrl_reg2 ==  'h14) && (L1_ctrl_reg12 == 'hF ); 
    mte_mac023_sleep_start2 = (L1_ctrl_reg2 ==  'h14) && (L1_ctrl_reg12 == 'h10 ); 
    mte_mac123_sleep_start2 = (L1_ctrl_reg2 ==  'h14) && (L1_ctrl_reg12 == 'h11 ); 
    mte_mac_off_sleep_start2 =  (L1_ctrl_reg2 == 'h14) && (L1_ctrl_reg12 == 'h12 );
    mte_dma_sleep_start2 =  (L1_ctrl_reg2 == 'h14) && (L1_ctrl_reg12 == 'h13 );

    mte_pm_uart_to_default_start2 = (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'h1);
    mte_pm_smc_to_default_start2 = (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'h2);
    mte_pm_smc_uart_to_default_start2 = (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'h3); 
    mte_mac0_to_default2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'h4); 
    mte_mac1_to_default2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'h5); 
    mte_mac2_to_default2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'h6); 
    mte_mac3_to_default2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'h7); 
    mte_mac01_to_default2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'h8); 
    mte_mac02_to_default2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'h9); 
    mte_mac03_to_default2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'hA); 
    mte_mac12_to_default2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'hB); 
    mte_mac13_to_default2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'hC); 
    mte_mac23_to_default2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'hD); 
    mte_mac012_to_default2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'hE); 
    mte_mac013_to_default2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'hF); 
    mte_mac023_to_default2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'h10); 
    mte_mac123_to_default2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'h11); 
    mte_mac_off_to_default2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'h12); 
    mte_dma_isolate_dis2 =  (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'h13); 
    mte_cpu_isolate_dis2 =  (int_source_h2) && (cpu_shutoff_ctrl2) && (L1_ctrl_reg2 != 'h15);
    mte_sys_hibernate_to_default2 = (L1_ctrl_reg2 == 32'h0) && (L1_ctrl_reg12 == 'h15); 

   
    if (L1_ctrl_reg12 == 'h0) begin // This2 check is to make mte_cpu_start2
                                   // is set only when you from default state 
      case (L1_ctrl_reg2)
        'h0 : L1_ctrl_domain2 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain2 = 32'h2; // PM_uart2
                mte_uart_start2 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain2 = 32'h4; // PM_smc2
                mte_smc_start2 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain2 = 32'h6; // PM_smc_uart2
                mte_smc_uart_start2 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain2 = 32'h8; //  PM_macb02
                mte_mac0_start2 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain2 = 32'h10; //  PM_macb12
                mte_mac1_start2 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain2 = 32'h20; //  PM_macb22
                mte_mac2_start2 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain2 = 32'h40; //  PM_macb32
                mte_mac3_start2 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain2 = 32'h18; //  PM_macb012
                mte_mac01_start2 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain2 = 32'h28; //  PM_macb022
                mte_mac02_start2 = 1;
              end
        'hA : begin  
                L1_ctrl_domain2 = 32'h48; //  PM_macb032
                mte_mac03_start2 = 1;
              end
        'hB : begin  
                L1_ctrl_domain2 = 32'h30; //  PM_macb122
                mte_mac12_start2 = 1;
              end
        'hC : begin  
                L1_ctrl_domain2 = 32'h50; //  PM_macb132
                mte_mac13_start2 = 1;
              end
        'hD : begin  
                L1_ctrl_domain2 = 32'h60; //  PM_macb232
                mte_mac23_start2 = 1;
              end
        'hE : begin  
                L1_ctrl_domain2 = 32'h38; //  PM_macb0122
                mte_mac012_start2 = 1;
              end
        'hF : begin  
                L1_ctrl_domain2 = 32'h58; //  PM_macb0132
                mte_mac013_start2 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain2 = 32'h68; //  PM_macb0232
                mte_mac023_start2 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain2 = 32'h70; //  PM_macb1232
                mte_mac123_start2 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain2 = 32'h78; //  PM_macb_off2
                mte_mac_off_start2 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain2 = 32'h80; //  PM_dma2
                mte_dma_start2 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain2 = 32'h100; //  PM_cpu_sleep2
                mte_cpu_start2 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain2 = 32'h1FE; //  PM_hibernate2
                mte_sys_hibernate2 = 1;
              end
         default: L1_ctrl_domain2 = 32'h0;
      endcase
    end
  end


  wire to_default2 = (L1_ctrl_reg2 == 0);

  // Scan2 mode gating2 of power2 and isolation2 control2 signals2
  //SMC2
  assign rstn_non_srpg_smc2  = (scan_mode2 == 1'b0) ? rstn_non_srpg_smc_int2 : 1'b1;  
  assign gate_clk_smc2       = (scan_mode2 == 1'b0) ? gate_clk_smc_int2 : 1'b0;     
  assign isolate_smc2        = (scan_mode2 == 1'b0) ? isolate_smc_int2 : 1'b0;      
  assign pwr1_on_smc2        = (scan_mode2 == 1'b0) ? pwr1_on_smc_int2 : 1'b1;       
  assign pwr2_on_smc2        = (scan_mode2 == 1'b0) ? pwr2_on_smc_int2 : 1'b1;       
  assign pwr1_off_smc2       = (scan_mode2 == 1'b0) ? (!pwr1_on_smc_int2) : 1'b0;       
  assign pwr2_off_smc2       = (scan_mode2 == 1'b0) ? (!pwr2_on_smc_int2) : 1'b0;       
  assign save_edge_smc2       = (scan_mode2 == 1'b0) ? (save_edge_smc_int2) : 1'b0;       
  assign restore_edge_smc2       = (scan_mode2 == 1'b0) ? (restore_edge_smc_int2) : 1'b0;       

  //URT2
  assign rstn_non_srpg_urt2  = (scan_mode2 == 1'b0) ?  rstn_non_srpg_urt_int2 : 1'b1;  
  assign gate_clk_urt2       = (scan_mode2 == 1'b0) ?  gate_clk_urt_int2      : 1'b0;     
  assign isolate_urt2        = (scan_mode2 == 1'b0) ?  isolate_urt_int2       : 1'b0;      
  assign pwr1_on_urt2        = (scan_mode2 == 1'b0) ?  pwr1_on_urt_int2       : 1'b1;       
  assign pwr2_on_urt2        = (scan_mode2 == 1'b0) ?  pwr2_on_urt_int2       : 1'b1;       
  assign pwr1_off_urt2       = (scan_mode2 == 1'b0) ?  (!pwr1_on_urt_int2)  : 1'b0;       
  assign pwr2_off_urt2       = (scan_mode2 == 1'b0) ?  (!pwr2_on_urt_int2)  : 1'b0;       
  assign save_edge_urt2       = (scan_mode2 == 1'b0) ? (save_edge_urt_int2) : 1'b0;       
  assign restore_edge_urt2       = (scan_mode2 == 1'b0) ? (restore_edge_urt_int2) : 1'b0;       

  //ETH02
  assign rstn_non_srpg_macb02 = (scan_mode2 == 1'b0) ?  rstn_non_srpg_macb0_int2 : 1'b1;  
  assign gate_clk_macb02       = (scan_mode2 == 1'b0) ?  gate_clk_macb0_int2      : 1'b0;     
  assign isolate_macb02        = (scan_mode2 == 1'b0) ?  isolate_macb0_int2       : 1'b0;      
  assign pwr1_on_macb02        = (scan_mode2 == 1'b0) ?  pwr1_on_macb0_int2       : 1'b1;       
  assign pwr2_on_macb02        = (scan_mode2 == 1'b0) ?  pwr2_on_macb0_int2       : 1'b1;       
  assign pwr1_off_macb02       = (scan_mode2 == 1'b0) ?  (!pwr1_on_macb0_int2)  : 1'b0;       
  assign pwr2_off_macb02       = (scan_mode2 == 1'b0) ?  (!pwr2_on_macb0_int2)  : 1'b0;       
  assign save_edge_macb02       = (scan_mode2 == 1'b0) ? (save_edge_macb0_int2) : 1'b0;       
  assign restore_edge_macb02       = (scan_mode2 == 1'b0) ? (restore_edge_macb0_int2) : 1'b0;       

  //ETH12
  assign rstn_non_srpg_macb12 = (scan_mode2 == 1'b0) ?  rstn_non_srpg_macb1_int2 : 1'b1;  
  assign gate_clk_macb12       = (scan_mode2 == 1'b0) ?  gate_clk_macb1_int2      : 1'b0;     
  assign isolate_macb12        = (scan_mode2 == 1'b0) ?  isolate_macb1_int2       : 1'b0;      
  assign pwr1_on_macb12        = (scan_mode2 == 1'b0) ?  pwr1_on_macb1_int2       : 1'b1;       
  assign pwr2_on_macb12        = (scan_mode2 == 1'b0) ?  pwr2_on_macb1_int2       : 1'b1;       
  assign pwr1_off_macb12       = (scan_mode2 == 1'b0) ?  (!pwr1_on_macb1_int2)  : 1'b0;       
  assign pwr2_off_macb12       = (scan_mode2 == 1'b0) ?  (!pwr2_on_macb1_int2)  : 1'b0;       
  assign save_edge_macb12       = (scan_mode2 == 1'b0) ? (save_edge_macb1_int2) : 1'b0;       
  assign restore_edge_macb12       = (scan_mode2 == 1'b0) ? (restore_edge_macb1_int2) : 1'b0;       

  //ETH22
  assign rstn_non_srpg_macb22 = (scan_mode2 == 1'b0) ?  rstn_non_srpg_macb2_int2 : 1'b1;  
  assign gate_clk_macb22       = (scan_mode2 == 1'b0) ?  gate_clk_macb2_int2      : 1'b0;     
  assign isolate_macb22        = (scan_mode2 == 1'b0) ?  isolate_macb2_int2       : 1'b0;      
  assign pwr1_on_macb22        = (scan_mode2 == 1'b0) ?  pwr1_on_macb2_int2       : 1'b1;       
  assign pwr2_on_macb22        = (scan_mode2 == 1'b0) ?  pwr2_on_macb2_int2       : 1'b1;       
  assign pwr1_off_macb22       = (scan_mode2 == 1'b0) ?  (!pwr1_on_macb2_int2)  : 1'b0;       
  assign pwr2_off_macb22       = (scan_mode2 == 1'b0) ?  (!pwr2_on_macb2_int2)  : 1'b0;       
  assign save_edge_macb22       = (scan_mode2 == 1'b0) ? (save_edge_macb2_int2) : 1'b0;       
  assign restore_edge_macb22       = (scan_mode2 == 1'b0) ? (restore_edge_macb2_int2) : 1'b0;       

  //ETH32
  assign rstn_non_srpg_macb32 = (scan_mode2 == 1'b0) ?  rstn_non_srpg_macb3_int2 : 1'b1;  
  assign gate_clk_macb32       = (scan_mode2 == 1'b0) ?  gate_clk_macb3_int2      : 1'b0;     
  assign isolate_macb32        = (scan_mode2 == 1'b0) ?  isolate_macb3_int2       : 1'b0;      
  assign pwr1_on_macb32        = (scan_mode2 == 1'b0) ?  pwr1_on_macb3_int2       : 1'b1;       
  assign pwr2_on_macb32        = (scan_mode2 == 1'b0) ?  pwr2_on_macb3_int2       : 1'b1;       
  assign pwr1_off_macb32       = (scan_mode2 == 1'b0) ?  (!pwr1_on_macb3_int2)  : 1'b0;       
  assign pwr2_off_macb32       = (scan_mode2 == 1'b0) ?  (!pwr2_on_macb3_int2)  : 1'b0;       
  assign save_edge_macb32       = (scan_mode2 == 1'b0) ? (save_edge_macb3_int2) : 1'b0;       
  assign restore_edge_macb32       = (scan_mode2 == 1'b0) ? (restore_edge_macb3_int2) : 1'b0;       

  // MEM2
  assign rstn_non_srpg_mem2 =   (rstn_non_srpg_macb02 && rstn_non_srpg_macb12 && rstn_non_srpg_macb22 &&
                                rstn_non_srpg_macb32 && rstn_non_srpg_dma2 && rstn_non_srpg_cpu2 && rstn_non_srpg_urt2 &&
                                rstn_non_srpg_smc2);

  assign gate_clk_mem2 =  (gate_clk_macb02 && gate_clk_macb12 && gate_clk_macb22 &&
                            gate_clk_macb32 && gate_clk_dma2 && gate_clk_cpu2 && gate_clk_urt2 && gate_clk_smc2);

  assign isolate_mem2  = (isolate_macb02 && isolate_macb12 && isolate_macb22 &&
                         isolate_macb32 && isolate_dma2 && isolate_cpu2 && isolate_urt2 && isolate_smc2);


  assign pwr1_on_mem2        =   ~pwr1_off_mem2;

  assign pwr2_on_mem2        =   ~pwr2_off_mem2;

  assign pwr1_off_mem2       =  (pwr1_off_macb02 && pwr1_off_macb12 && pwr1_off_macb22 &&
                                 pwr1_off_macb32 && pwr1_off_dma2 && pwr1_off_cpu2 && pwr1_off_urt2 && pwr1_off_smc2);


  assign pwr2_off_mem2       =  (pwr2_off_macb02 && pwr2_off_macb12 && pwr2_off_macb22 &&
                                pwr2_off_macb32 && pwr2_off_dma2 && pwr2_off_cpu2 && pwr2_off_urt2 && pwr2_off_smc2);

  assign save_edge_mem2      =  (save_edge_macb02 && save_edge_macb12 && save_edge_macb22 &&
                                save_edge_macb32 && save_edge_dma2 && save_edge_cpu2 && save_edge_smc2 && save_edge_urt2);

  assign restore_edge_mem2   =  (restore_edge_macb02 && restore_edge_macb12 && restore_edge_macb22  &&
                                restore_edge_macb32 && restore_edge_dma2 && restore_edge_cpu2 && restore_edge_urt2 &&
                                restore_edge_smc2);

  assign standby_mem02 = pwr1_off_macb02 && (~ (pwr1_off_macb02 && pwr1_off_macb12 && pwr1_off_macb22 && pwr1_off_macb32 && pwr1_off_urt2 && pwr1_off_smc2 && pwr1_off_dma2 && pwr1_off_cpu2));
  assign standby_mem12 = pwr1_off_macb12 && (~ (pwr1_off_macb02 && pwr1_off_macb12 && pwr1_off_macb22 && pwr1_off_macb32 && pwr1_off_urt2 && pwr1_off_smc2 && pwr1_off_dma2 && pwr1_off_cpu2));
  assign standby_mem22 = pwr1_off_macb22 && (~ (pwr1_off_macb02 && pwr1_off_macb12 && pwr1_off_macb22 && pwr1_off_macb32 && pwr1_off_urt2 && pwr1_off_smc2 && pwr1_off_dma2 && pwr1_off_cpu2));
  assign standby_mem32 = pwr1_off_macb32 && (~ (pwr1_off_macb02 && pwr1_off_macb12 && pwr1_off_macb22 && pwr1_off_macb32 && pwr1_off_urt2 && pwr1_off_smc2 && pwr1_off_dma2 && pwr1_off_cpu2));

  assign pwr1_off_mem02 = pwr1_off_mem2;
  assign pwr1_off_mem12 = pwr1_off_mem2;
  assign pwr1_off_mem22 = pwr1_off_mem2;
  assign pwr1_off_mem32 = pwr1_off_mem2;

  assign rstn_non_srpg_alut2  =  (rstn_non_srpg_macb02 && rstn_non_srpg_macb12 && rstn_non_srpg_macb22 && rstn_non_srpg_macb32);


   assign gate_clk_alut2       =  (gate_clk_macb02 && gate_clk_macb12 && gate_clk_macb22 && gate_clk_macb32);


    assign isolate_alut2        =  (isolate_macb02 && isolate_macb12 && isolate_macb22 && isolate_macb32);


    assign pwr1_on_alut2        =  (pwr1_on_macb02 || pwr1_on_macb12 || pwr1_on_macb22 || pwr1_on_macb32);


    assign pwr2_on_alut2        =  (pwr2_on_macb02 || pwr2_on_macb12 || pwr2_on_macb22 || pwr2_on_macb32);


    assign pwr1_off_alut2       =  (pwr1_off_macb02 && pwr1_off_macb12 && pwr1_off_macb22 && pwr1_off_macb32);


    assign pwr2_off_alut2       =  (pwr2_off_macb02 && pwr2_off_macb12 && pwr2_off_macb22 && pwr2_off_macb32);


    assign save_edge_alut2      =  (save_edge_macb02 && save_edge_macb12 && save_edge_macb22 && save_edge_macb32);


    assign restore_edge_alut2   =  (restore_edge_macb02 || restore_edge_macb12 || restore_edge_macb22 ||
                                   restore_edge_macb32) && save_alut_tmp2;

     // alut2 power2 off2 detection2
  always @(posedge pclk2 or negedge nprst2) begin
    if (!nprst2) 
       save_alut_tmp2 <= 0;
    else if (restore_edge_alut2)
       save_alut_tmp2 <= 0;
    else if (save_edge_alut2)
       save_alut_tmp2 <= 1;
  end

  //DMA2
  assign rstn_non_srpg_dma2 = (scan_mode2 == 1'b0) ?  rstn_non_srpg_dma_int2 : 1'b1;  
  assign gate_clk_dma2       = (scan_mode2 == 1'b0) ?  gate_clk_dma_int2      : 1'b0;     
  assign isolate_dma2        = (scan_mode2 == 1'b0) ?  isolate_dma_int2       : 1'b0;      
  assign pwr1_on_dma2        = (scan_mode2 == 1'b0) ?  pwr1_on_dma_int2       : 1'b1;       
  assign pwr2_on_dma2        = (scan_mode2 == 1'b0) ?  pwr2_on_dma_int2       : 1'b1;       
  assign pwr1_off_dma2       = (scan_mode2 == 1'b0) ?  (!pwr1_on_dma_int2)  : 1'b0;       
  assign pwr2_off_dma2       = (scan_mode2 == 1'b0) ?  (!pwr2_on_dma_int2)  : 1'b0;       
  assign save_edge_dma2       = (scan_mode2 == 1'b0) ? (save_edge_dma_int2) : 1'b0;       
  assign restore_edge_dma2       = (scan_mode2 == 1'b0) ? (restore_edge_dma_int2) : 1'b0;       

  //CPU2
  assign rstn_non_srpg_cpu2 = (scan_mode2 == 1'b0) ?  rstn_non_srpg_cpu_int2 : 1'b1;  
  assign gate_clk_cpu2       = (scan_mode2 == 1'b0) ?  gate_clk_cpu_int2      : 1'b0;     
  assign isolate_cpu2        = (scan_mode2 == 1'b0) ?  isolate_cpu_int2       : 1'b0;      
  assign pwr1_on_cpu2        = (scan_mode2 == 1'b0) ?  pwr1_on_cpu_int2       : 1'b1;       
  assign pwr2_on_cpu2        = (scan_mode2 == 1'b0) ?  pwr2_on_cpu_int2       : 1'b1;       
  assign pwr1_off_cpu2       = (scan_mode2 == 1'b0) ?  (!pwr1_on_cpu_int2)  : 1'b0;       
  assign pwr2_off_cpu2       = (scan_mode2 == 1'b0) ?  (!pwr2_on_cpu_int2)  : 1'b0;       
  assign save_edge_cpu2       = (scan_mode2 == 1'b0) ? (save_edge_cpu_int2) : 1'b0;       
  assign restore_edge_cpu2       = (scan_mode2 == 1'b0) ? (restore_edge_cpu_int2) : 1'b0;       



  // ASE2

   reg ase_core_12v2, ase_core_10v2, ase_core_08v2, ase_core_06v2;
   reg ase_macb0_12v2,ase_macb1_12v2,ase_macb2_12v2,ase_macb3_12v2;

    // core2 ase2

    // core2 at 1.0 v if (smc2 off2, urt2 off2, macb02 off2, macb12 off2, macb22 off2, macb32 off2
   // core2 at 0.8v if (mac01off2, macb02off2, macb03off2, macb12off2, mac13off2, mac23off2,
   // core2 at 0.6v if (mac012off2, mac013off2, mac023off2, mac123off2, mac0123off2
    // else core2 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb02 && pwr1_off_macb12 && pwr1_off_macb22 && pwr1_off_macb32) || // all mac2 off2
       (pwr1_off_macb32 && pwr1_off_macb22 && pwr1_off_macb12) || // mac123off2 
       (pwr1_off_macb32 && pwr1_off_macb22 && pwr1_off_macb02) || // mac023off2 
       (pwr1_off_macb32 && pwr1_off_macb12 && pwr1_off_macb02) || // mac013off2 
       (pwr1_off_macb22 && pwr1_off_macb12 && pwr1_off_macb02) )  // mac012off2 
       begin
         ase_core_12v2 = 0;
         ase_core_10v2 = 0;
         ase_core_08v2 = 0;
         ase_core_06v2 = 1;
       end
     else if( (pwr1_off_macb22 && pwr1_off_macb32) || // mac232 off2
         (pwr1_off_macb32 && pwr1_off_macb12) || // mac13off2 
         (pwr1_off_macb12 && pwr1_off_macb22) || // mac12off2 
         (pwr1_off_macb32 && pwr1_off_macb02) || // mac03off2 
         (pwr1_off_macb22 && pwr1_off_macb02) || // mac02off2 
         (pwr1_off_macb12 && pwr1_off_macb02))  // mac01off2 
       begin
         ase_core_12v2 = 0;
         ase_core_10v2 = 0;
         ase_core_08v2 = 1;
         ase_core_06v2 = 0;
       end
     else if( (pwr1_off_smc2) || // smc2 off2
         (pwr1_off_macb02 ) || // mac0off2 
         (pwr1_off_macb12 ) || // mac1off2 
         (pwr1_off_macb22 ) || // mac2off2 
         (pwr1_off_macb32 ))  // mac3off2 
       begin
         ase_core_12v2 = 0;
         ase_core_10v2 = 1;
         ase_core_08v2 = 0;
         ase_core_06v2 = 0;
       end
     else if (pwr1_off_urt2)
       begin
         ase_core_12v2 = 1;
         ase_core_10v2 = 0;
         ase_core_08v2 = 0;
         ase_core_06v2 = 0;
       end
     else
       begin
         ase_core_12v2 = 1;
         ase_core_10v2 = 0;
         ase_core_08v2 = 0;
         ase_core_06v2 = 0;
       end
   end


   // cpu2
   // cpu2 @ 1.0v when macoff2, 
   // 
   reg ase_cpu_10v2, ase_cpu_12v2;
   always @(*) begin
    if(pwr1_off_cpu2) begin
     ase_cpu_12v2 = 1'b0;
     ase_cpu_10v2 = 1'b0;
    end
    else if(pwr1_off_macb02 || pwr1_off_macb12 || pwr1_off_macb22 || pwr1_off_macb32)
    begin
     ase_cpu_12v2 = 1'b0;
     ase_cpu_10v2 = 1'b1;
    end
    else
    begin
     ase_cpu_12v2 = 1'b1;
     ase_cpu_10v2 = 1'b0;
    end
   end

   // dma2
   // dma2 @v12.0 for macoff2, 

   reg ase_dma_10v2, ase_dma_12v2;
   always @(*) begin
    if(pwr1_off_dma2) begin
     ase_dma_12v2 = 1'b0;
     ase_dma_10v2 = 1'b0;
    end
    else if(pwr1_off_macb02 || pwr1_off_macb12 || pwr1_off_macb22 || pwr1_off_macb32)
    begin
     ase_dma_12v2 = 1'b0;
     ase_dma_10v2 = 1'b1;
    end
    else
    begin
     ase_dma_12v2 = 1'b1;
     ase_dma_10v2 = 1'b0;
    end
   end

   // alut2
   // @ v12.0 for macoff2

   reg ase_alut_10v2, ase_alut_12v2;
   always @(*) begin
    if(pwr1_off_alut2) begin
     ase_alut_12v2 = 1'b0;
     ase_alut_10v2 = 1'b0;
    end
    else if(pwr1_off_macb02 || pwr1_off_macb12 || pwr1_off_macb22 || pwr1_off_macb32)
    begin
     ase_alut_12v2 = 1'b0;
     ase_alut_10v2 = 1'b1;
    end
    else
    begin
     ase_alut_12v2 = 1'b1;
     ase_alut_10v2 = 1'b0;
    end
   end




   reg ase_uart_12v2;
   reg ase_uart_10v2;
   reg ase_uart_08v2;
   reg ase_uart_06v2;

   reg ase_smc_12v2;


   always @(*) begin
     if(pwr1_off_urt2) begin // uart2 off2
       ase_uart_08v2 = 1'b0;
       ase_uart_06v2 = 1'b0;
       ase_uart_10v2 = 1'b0;
       ase_uart_12v2 = 1'b0;
     end 
     else if( (pwr1_off_macb02 && pwr1_off_macb12 && pwr1_off_macb22 && pwr1_off_macb32) || // all mac2 off2
       (pwr1_off_macb32 && pwr1_off_macb22 && pwr1_off_macb12) || // mac123off2 
       (pwr1_off_macb32 && pwr1_off_macb22 && pwr1_off_macb02) || // mac023off2 
       (pwr1_off_macb32 && pwr1_off_macb12 && pwr1_off_macb02) || // mac013off2 
       (pwr1_off_macb22 && pwr1_off_macb12 && pwr1_off_macb02) )  // mac012off2 
     begin
       ase_uart_06v2 = 1'b1;
       ase_uart_08v2 = 1'b0;
       ase_uart_10v2 = 1'b0;
       ase_uart_12v2 = 1'b0;
     end
     else if( (pwr1_off_macb22 && pwr1_off_macb32) || // mac232 off2
         (pwr1_off_macb32 && pwr1_off_macb12) || // mac13off2 
         (pwr1_off_macb12 && pwr1_off_macb22) || // mac12off2 
         (pwr1_off_macb32 && pwr1_off_macb02) || // mac03off2 
         (pwr1_off_macb12 && pwr1_off_macb02))  // mac01off2  
     begin
       ase_uart_06v2 = 1'b0;
       ase_uart_08v2 = 1'b1;
       ase_uart_10v2 = 1'b0;
       ase_uart_12v2 = 1'b0;
     end
     else if (pwr1_off_smc2 || pwr1_off_macb02 || pwr1_off_macb12 || pwr1_off_macb22 || pwr1_off_macb32) begin // smc2 off2
       ase_uart_08v2 = 1'b0;
       ase_uart_06v2 = 1'b0;
       ase_uart_10v2 = 1'b1;
       ase_uart_12v2 = 1'b0;
     end 
     else begin
       ase_uart_08v2 = 1'b0;
       ase_uart_06v2 = 1'b0;
       ase_uart_10v2 = 1'b0;
       ase_uart_12v2 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc2) begin
     if (pwr1_off_smc2)  // smc2 off2
       ase_smc_12v2 = 1'b0;
    else
       ase_smc_12v2 = 1'b1;
   end

   
   always @(pwr1_off_macb02) begin
     if (pwr1_off_macb02) // macb02 off2
       ase_macb0_12v2 = 1'b0;
     else
       ase_macb0_12v2 = 1'b1;
   end

   always @(pwr1_off_macb12) begin
     if (pwr1_off_macb12) // macb12 off2
       ase_macb1_12v2 = 1'b0;
     else
       ase_macb1_12v2 = 1'b1;
   end

   always @(pwr1_off_macb22) begin // macb22 off2
     if (pwr1_off_macb22) // macb22 off2
       ase_macb2_12v2 = 1'b0;
     else
       ase_macb2_12v2 = 1'b1;
   end

   always @(pwr1_off_macb32) begin // macb32 off2
     if (pwr1_off_macb32) // macb32 off2
       ase_macb3_12v2 = 1'b0;
     else
       ase_macb3_12v2 = 1'b1;
   end


   // core2 voltage2 for vco2
  assign core12v2 = ase_macb0_12v2 & ase_macb1_12v2 & ase_macb2_12v2 & ase_macb3_12v2;

  assign core10v2 =  (ase_macb0_12v2 & ase_macb1_12v2 & ase_macb2_12v2 & (!ase_macb3_12v2)) ||
                    (ase_macb0_12v2 & ase_macb1_12v2 & (!ase_macb2_12v2) & ase_macb3_12v2) ||
                    (ase_macb0_12v2 & (!ase_macb1_12v2) & ase_macb2_12v2 & ase_macb3_12v2) ||
                    ((!ase_macb0_12v2) & ase_macb1_12v2 & ase_macb2_12v2 & ase_macb3_12v2);

  assign core08v2 =  ((!ase_macb0_12v2) & (!ase_macb1_12v2) & (ase_macb2_12v2) & (ase_macb3_12v2)) ||
                    ((!ase_macb0_12v2) & (ase_macb1_12v2) & (!ase_macb2_12v2) & (ase_macb3_12v2)) ||
                    ((!ase_macb0_12v2) & (ase_macb1_12v2) & (ase_macb2_12v2) & (!ase_macb3_12v2)) ||
                    ((ase_macb0_12v2) & (!ase_macb1_12v2) & (!ase_macb2_12v2) & (ase_macb3_12v2)) ||
                    ((ase_macb0_12v2) & (!ase_macb1_12v2) & (ase_macb2_12v2) & (!ase_macb3_12v2)) ||
                    ((ase_macb0_12v2) & (ase_macb1_12v2) & (!ase_macb2_12v2) & (!ase_macb3_12v2));

  assign core06v2 =  ((!ase_macb0_12v2) & (!ase_macb1_12v2) & (!ase_macb2_12v2) & (ase_macb3_12v2)) ||
                    ((!ase_macb0_12v2) & (!ase_macb1_12v2) & (ase_macb2_12v2) & (!ase_macb3_12v2)) ||
                    ((!ase_macb0_12v2) & (ase_macb1_12v2) & (!ase_macb2_12v2) & (!ase_macb3_12v2)) ||
                    ((ase_macb0_12v2) & (!ase_macb1_12v2) & (!ase_macb2_12v2) & (!ase_macb3_12v2)) ||
                    ((!ase_macb0_12v2) & (!ase_macb1_12v2) & (!ase_macb2_12v2) & (!ase_macb3_12v2)) ;



`ifdef LP_ABV_ON2
// psl2 default clock2 = (posedge pclk2);

// Cover2 a condition in which SMC2 is powered2 down
// and again2 powered2 up while UART2 is going2 into POWER2 down
// state or UART2 is already in POWER2 DOWN2 state
// psl2 cover_overlapping_smc_urt_12:
//    cover{fell2(pwr1_on_urt2);[*];fell2(pwr1_on_smc2);[*];
//    rose2(pwr1_on_smc2);[*];rose2(pwr1_on_urt2)};
//
// Cover2 a condition in which UART2 is powered2 down
// and again2 powered2 up while SMC2 is going2 into POWER2 down
// state or SMC2 is already in POWER2 DOWN2 state
// psl2 cover_overlapping_smc_urt_22:
//    cover{fell2(pwr1_on_smc2);[*];fell2(pwr1_on_urt2);[*];
//    rose2(pwr1_on_urt2);[*];rose2(pwr1_on_smc2)};
//


// Power2 Down2 UART2
// This2 gets2 triggered on rising2 edge of Gate2 signal2 for
// UART2 (gate_clk_urt2). In a next cycle after gate_clk_urt2,
// Isolate2 UART2(isolate_urt2) signal2 become2 HIGH2 (active).
// In 2nd cycle after gate_clk_urt2 becomes HIGH2, RESET2 for NON2
// SRPG2 FFs2(rstn_non_srpg_urt2) and POWER12 for UART2(pwr1_on_urt2) should 
// go2 LOW2. 
// This2 completes2 a POWER2 DOWN2. 

sequence s_power_down_urt2;
      (gate_clk_urt2 & !isolate_urt2 & rstn_non_srpg_urt2 & pwr1_on_urt2) 
  ##1 (gate_clk_urt2 & isolate_urt2 & rstn_non_srpg_urt2 & pwr1_on_urt2) 
  ##3 (gate_clk_urt2 & isolate_urt2 & !rstn_non_srpg_urt2 & !pwr1_on_urt2);
endsequence


property p_power_down_urt2;
   @(posedge pclk2)
    $rose(gate_clk_urt2) |=> s_power_down_urt2;
endproperty

output_power_down_urt2:
  assert property (p_power_down_urt2);


// Power2 UP2 UART2
// Sequence starts with , Rising2 edge of pwr1_on_urt2.
// Two2 clock2 cycle after this, isolate_urt2 should become2 LOW2 
// On2 the following2 clk2 gate_clk_urt2 should go2 low2.
// 5 cycles2 after  Rising2 edge of pwr1_on_urt2, rstn_non_srpg_urt2
// should become2 HIGH2
sequence s_power_up_urt2;
##30 (pwr1_on_urt2 & !isolate_urt2 & gate_clk_urt2 & !rstn_non_srpg_urt2) 
##1 (pwr1_on_urt2 & !isolate_urt2 & !gate_clk_urt2 & !rstn_non_srpg_urt2) 
##2 (pwr1_on_urt2 & !isolate_urt2 & !gate_clk_urt2 & rstn_non_srpg_urt2);
endsequence

property p_power_up_urt2;
   @(posedge pclk2)
  disable iff(!nprst2)
    (!pwr1_on_urt2 ##1 pwr1_on_urt2) |=> s_power_up_urt2;
endproperty

output_power_up_urt2:
  assert property (p_power_up_urt2);


// Power2 Down2 SMC2
// This2 gets2 triggered on rising2 edge of Gate2 signal2 for
// SMC2 (gate_clk_smc2). In a next cycle after gate_clk_smc2,
// Isolate2 SMC2(isolate_smc2) signal2 become2 HIGH2 (active).
// In 2nd cycle after gate_clk_smc2 becomes HIGH2, RESET2 for NON2
// SRPG2 FFs2(rstn_non_srpg_smc2) and POWER12 for SMC2(pwr1_on_smc2) should 
// go2 LOW2. 
// This2 completes2 a POWER2 DOWN2. 

sequence s_power_down_smc2;
      (gate_clk_smc2 & !isolate_smc2 & rstn_non_srpg_smc2 & pwr1_on_smc2) 
  ##1 (gate_clk_smc2 & isolate_smc2 & rstn_non_srpg_smc2 & pwr1_on_smc2) 
  ##3 (gate_clk_smc2 & isolate_smc2 & !rstn_non_srpg_smc2 & !pwr1_on_smc2);
endsequence


property p_power_down_smc2;
   @(posedge pclk2)
    $rose(gate_clk_smc2) |=> s_power_down_smc2;
endproperty

output_power_down_smc2:
  assert property (p_power_down_smc2);


// Power2 UP2 SMC2
// Sequence starts with , Rising2 edge of pwr1_on_smc2.
// Two2 clock2 cycle after this, isolate_smc2 should become2 LOW2 
// On2 the following2 clk2 gate_clk_smc2 should go2 low2.
// 5 cycles2 after  Rising2 edge of pwr1_on_smc2, rstn_non_srpg_smc2
// should become2 HIGH2
sequence s_power_up_smc2;
##30 (pwr1_on_smc2 & !isolate_smc2 & gate_clk_smc2 & !rstn_non_srpg_smc2) 
##1 (pwr1_on_smc2 & !isolate_smc2 & !gate_clk_smc2 & !rstn_non_srpg_smc2) 
##2 (pwr1_on_smc2 & !isolate_smc2 & !gate_clk_smc2 & rstn_non_srpg_smc2);
endsequence

property p_power_up_smc2;
   @(posedge pclk2)
  disable iff(!nprst2)
    (!pwr1_on_smc2 ##1 pwr1_on_smc2) |=> s_power_up_smc2;
endproperty

output_power_up_smc2:
  assert property (p_power_up_smc2);


// COVER2 SMC2 POWER2 DOWN2 AND2 UP2
cover_power_down_up_smc2: cover property (@(posedge pclk2)
(s_power_down_smc2 ##[5:180] s_power_up_smc2));



// COVER2 UART2 POWER2 DOWN2 AND2 UP2
cover_power_down_up_urt2: cover property (@(posedge pclk2)
(s_power_down_urt2 ##[5:180] s_power_up_urt2));

cover_power_down_urt2: cover property (@(posedge pclk2)
(s_power_down_urt2));

cover_power_up_urt2: cover property (@(posedge pclk2)
(s_power_up_urt2));




`ifdef PCM_ABV_ON2
//------------------------------------------------------------------------------
// Power2 Controller2 Formal2 Verification2 component.  Each power2 domain has a 
// separate2 instantiation2
//------------------------------------------------------------------------------

// need to assume that CPU2 will leave2 a minimum time between powering2 down and 
// back up.  In this example2, 10clks has been selected.
// psl2 config_min_uart_pd_time2 : assume always {rose2(L1_ctrl_domain2[1])} |-> { L1_ctrl_domain2[1][*10] } abort2(~nprst2);
// psl2 config_min_uart_pu_time2 : assume always {fell2(L1_ctrl_domain2[1])} |-> { !L1_ctrl_domain2[1][*10] } abort2(~nprst2);
// psl2 config_min_smc_pd_time2 : assume always {rose2(L1_ctrl_domain2[2])} |-> { L1_ctrl_domain2[2][*10] } abort2(~nprst2);
// psl2 config_min_smc_pu_time2 : assume always {fell2(L1_ctrl_domain2[2])} |-> { !L1_ctrl_domain2[2][*10] } abort2(~nprst2);

// UART2 VCOMP2 parameters2
   defparam i_uart_vcomp_domain2.ENABLE_SAVE_RESTORE_EDGE2   = 1;
   defparam i_uart_vcomp_domain2.ENABLE_EXT_PWR_CNTRL2       = 1;
   defparam i_uart_vcomp_domain2.REF_CLK_DEFINED2            = 0;
   defparam i_uart_vcomp_domain2.MIN_SHUTOFF_CYCLES2         = 4;
   defparam i_uart_vcomp_domain2.MIN_RESTORE_TO_ISO_CYCLES2  = 0;
   defparam i_uart_vcomp_domain2.MIN_SAVE_TO_SHUTOFF_CYCLES2 = 1;


   vcomp_domain2 i_uart_vcomp_domain2
   ( .ref_clk2(pclk2),
     .start_lps2(L1_ctrl_domain2[1] || !rstn_non_srpg_urt2),
     .rst_n2(nprst2),
     .ext_power_down2(L1_ctrl_domain2[1]),
     .iso_en2(isolate_urt2),
     .save_edge2(save_edge_urt2),
     .restore_edge2(restore_edge_urt2),
     .domain_shut_off2(pwr1_off_urt2),
     .domain_clk2(!gate_clk_urt2 && pclk2)
   );


// SMC2 VCOMP2 parameters2
   defparam i_smc_vcomp_domain2.ENABLE_SAVE_RESTORE_EDGE2   = 1;
   defparam i_smc_vcomp_domain2.ENABLE_EXT_PWR_CNTRL2       = 1;
   defparam i_smc_vcomp_domain2.REF_CLK_DEFINED2            = 0;
   defparam i_smc_vcomp_domain2.MIN_SHUTOFF_CYCLES2         = 4;
   defparam i_smc_vcomp_domain2.MIN_RESTORE_TO_ISO_CYCLES2  = 0;
   defparam i_smc_vcomp_domain2.MIN_SAVE_TO_SHUTOFF_CYCLES2 = 1;


   vcomp_domain2 i_smc_vcomp_domain2
   ( .ref_clk2(pclk2),
     .start_lps2(L1_ctrl_domain2[2] || !rstn_non_srpg_smc2),
     .rst_n2(nprst2),
     .ext_power_down2(L1_ctrl_domain2[2]),
     .iso_en2(isolate_smc2),
     .save_edge2(save_edge_smc2),
     .restore_edge2(restore_edge_smc2),
     .domain_shut_off2(pwr1_off_smc2),
     .domain_clk2(!gate_clk_smc2 && pclk2)
   );

`endif

`endif



endmodule
