//File3 name   : power_ctrl3.v
//Title3       : Power3 Control3 Module3
//Created3     : 1999
//Description3 : Top3 level of power3 controller3
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

module power_ctrl3 (


    // Clocks3 & Reset3
    pclk3,
    nprst3,
    // APB3 programming3 interface
    paddr3,
    psel3,
    penable3,
    pwrite3,
    pwdata3,
    prdata3,
    // mac3 i/f,
    macb3_wakeup3,
    macb2_wakeup3,
    macb1_wakeup3,
    macb0_wakeup3,
    // Scan3 
    scan_in3,
    scan_en3,
    scan_mode3,
    scan_out3,
    // Module3 control3 outputs3
    int_source_h3,
    // SMC3
    rstn_non_srpg_smc3,
    gate_clk_smc3,
    isolate_smc3,
    save_edge_smc3,
    restore_edge_smc3,
    pwr1_on_smc3,
    pwr2_on_smc3,
    pwr1_off_smc3,
    pwr2_off_smc3,
    // URT3
    rstn_non_srpg_urt3,
    gate_clk_urt3,
    isolate_urt3,
    save_edge_urt3,
    restore_edge_urt3,
    pwr1_on_urt3,
    pwr2_on_urt3,
    pwr1_off_urt3,      
    pwr2_off_urt3,
    // ETH03
    rstn_non_srpg_macb03,
    gate_clk_macb03,
    isolate_macb03,
    save_edge_macb03,
    restore_edge_macb03,
    pwr1_on_macb03,
    pwr2_on_macb03,
    pwr1_off_macb03,      
    pwr2_off_macb03,
    // ETH13
    rstn_non_srpg_macb13,
    gate_clk_macb13,
    isolate_macb13,
    save_edge_macb13,
    restore_edge_macb13,
    pwr1_on_macb13,
    pwr2_on_macb13,
    pwr1_off_macb13,      
    pwr2_off_macb13,
    // ETH23
    rstn_non_srpg_macb23,
    gate_clk_macb23,
    isolate_macb23,
    save_edge_macb23,
    restore_edge_macb23,
    pwr1_on_macb23,
    pwr2_on_macb23,
    pwr1_off_macb23,      
    pwr2_off_macb23,
    // ETH33
    rstn_non_srpg_macb33,
    gate_clk_macb33,
    isolate_macb33,
    save_edge_macb33,
    restore_edge_macb33,
    pwr1_on_macb33,
    pwr2_on_macb33,
    pwr1_off_macb33,      
    pwr2_off_macb33,
    // DMA3
    rstn_non_srpg_dma3,
    gate_clk_dma3,
    isolate_dma3,
    save_edge_dma3,
    restore_edge_dma3,
    pwr1_on_dma3,
    pwr2_on_dma3,
    pwr1_off_dma3,      
    pwr2_off_dma3,
    // CPU3
    rstn_non_srpg_cpu3,
    gate_clk_cpu3,
    isolate_cpu3,
    save_edge_cpu3,
    restore_edge_cpu3,
    pwr1_on_cpu3,
    pwr2_on_cpu3,
    pwr1_off_cpu3,      
    pwr2_off_cpu3,
    // ALUT3
    rstn_non_srpg_alut3,
    gate_clk_alut3,
    isolate_alut3,
    save_edge_alut3,
    restore_edge_alut3,
    pwr1_on_alut3,
    pwr2_on_alut3,
    pwr1_off_alut3,      
    pwr2_off_alut3,
    // MEM3
    rstn_non_srpg_mem3,
    gate_clk_mem3,
    isolate_mem3,
    save_edge_mem3,
    restore_edge_mem3,
    pwr1_on_mem3,
    pwr2_on_mem3,
    pwr1_off_mem3,      
    pwr2_off_mem3,
    // core3 dvfs3 transitions3
    core06v3,
    core08v3,
    core10v3,
    core12v3,
    pcm_macb_wakeup_int3,
    // mte3 signals3
    mte_smc_start3,
    mte_uart_start3,
    mte_smc_uart_start3,  
    mte_pm_smc_to_default_start3, 
    mte_pm_uart_to_default_start3,
    mte_pm_smc_uart_to_default_start3

  );

  parameter STATE_IDLE_12V3 = 4'b0001;
  parameter STATE_06V3 = 4'b0010;
  parameter STATE_08V3 = 4'b0100;
  parameter STATE_10V3 = 4'b1000;

    // Clocks3 & Reset3
    input pclk3;
    input nprst3;
    // APB3 programming3 interface
    input [31:0] paddr3;
    input psel3  ;
    input penable3;
    input pwrite3 ;
    input [31:0] pwdata3;
    output [31:0] prdata3;
    // mac3
    input macb3_wakeup3;
    input macb2_wakeup3;
    input macb1_wakeup3;
    input macb0_wakeup3;
    // Scan3 
    input scan_in3;
    input scan_en3;
    input scan_mode3;
    output scan_out3;
    // Module3 control3 outputs3
    input int_source_h3;
    // SMC3
    output rstn_non_srpg_smc3 ;
    output gate_clk_smc3   ;
    output isolate_smc3   ;
    output save_edge_smc3   ;
    output restore_edge_smc3   ;
    output pwr1_on_smc3   ;
    output pwr2_on_smc3   ;
    output pwr1_off_smc3  ;
    output pwr2_off_smc3  ;
    // URT3
    output rstn_non_srpg_urt3 ;
    output gate_clk_urt3      ;
    output isolate_urt3       ;
    output save_edge_urt3   ;
    output restore_edge_urt3   ;
    output pwr1_on_urt3       ;
    output pwr2_on_urt3       ;
    output pwr1_off_urt3      ;
    output pwr2_off_urt3      ;
    // ETH03
    output rstn_non_srpg_macb03 ;
    output gate_clk_macb03      ;
    output isolate_macb03       ;
    output save_edge_macb03   ;
    output restore_edge_macb03   ;
    output pwr1_on_macb03       ;
    output pwr2_on_macb03       ;
    output pwr1_off_macb03      ;
    output pwr2_off_macb03      ;
    // ETH13
    output rstn_non_srpg_macb13 ;
    output gate_clk_macb13      ;
    output isolate_macb13       ;
    output save_edge_macb13   ;
    output restore_edge_macb13   ;
    output pwr1_on_macb13       ;
    output pwr2_on_macb13       ;
    output pwr1_off_macb13      ;
    output pwr2_off_macb13      ;
    // ETH23
    output rstn_non_srpg_macb23 ;
    output gate_clk_macb23      ;
    output isolate_macb23       ;
    output save_edge_macb23   ;
    output restore_edge_macb23   ;
    output pwr1_on_macb23       ;
    output pwr2_on_macb23       ;
    output pwr1_off_macb23      ;
    output pwr2_off_macb23      ;
    // ETH33
    output rstn_non_srpg_macb33 ;
    output gate_clk_macb33      ;
    output isolate_macb33       ;
    output save_edge_macb33   ;
    output restore_edge_macb33   ;
    output pwr1_on_macb33       ;
    output pwr2_on_macb33       ;
    output pwr1_off_macb33      ;
    output pwr2_off_macb33      ;
    // DMA3
    output rstn_non_srpg_dma3 ;
    output gate_clk_dma3      ;
    output isolate_dma3       ;
    output save_edge_dma3   ;
    output restore_edge_dma3   ;
    output pwr1_on_dma3       ;
    output pwr2_on_dma3       ;
    output pwr1_off_dma3      ;
    output pwr2_off_dma3      ;
    // CPU3
    output rstn_non_srpg_cpu3 ;
    output gate_clk_cpu3      ;
    output isolate_cpu3       ;
    output save_edge_cpu3   ;
    output restore_edge_cpu3   ;
    output pwr1_on_cpu3       ;
    output pwr2_on_cpu3       ;
    output pwr1_off_cpu3      ;
    output pwr2_off_cpu3      ;
    // ALUT3
    output rstn_non_srpg_alut3 ;
    output gate_clk_alut3      ;
    output isolate_alut3       ;
    output save_edge_alut3   ;
    output restore_edge_alut3   ;
    output pwr1_on_alut3       ;
    output pwr2_on_alut3       ;
    output pwr1_off_alut3      ;
    output pwr2_off_alut3      ;
    // MEM3
    output rstn_non_srpg_mem3 ;
    output gate_clk_mem3      ;
    output isolate_mem3       ;
    output save_edge_mem3   ;
    output restore_edge_mem3   ;
    output pwr1_on_mem3       ;
    output pwr2_on_mem3       ;
    output pwr1_off_mem3      ;
    output pwr2_off_mem3      ;


   // core3 transitions3 o/p
    output core06v3;
    output core08v3;
    output core10v3;
    output core12v3;
    output pcm_macb_wakeup_int3 ;
    //mode mte3  signals3
    output mte_smc_start3;
    output mte_uart_start3;
    output mte_smc_uart_start3;  
    output mte_pm_smc_to_default_start3; 
    output mte_pm_uart_to_default_start3;
    output mte_pm_smc_uart_to_default_start3;

    reg mte_smc_start3;
    reg mte_uart_start3;
    reg mte_smc_uart_start3;  
    reg mte_pm_smc_to_default_start3; 
    reg mte_pm_uart_to_default_start3;
    reg mte_pm_smc_uart_to_default_start3;

    reg [31:0] prdata3;

  wire valid_reg_write3  ;
  wire valid_reg_read3   ;
  wire L1_ctrl_access3   ;
  wire L1_status_access3 ;
  wire pcm_int_mask_access3;
  wire pcm_int_status_access3;
  wire standby_mem03      ;
  wire standby_mem13      ;
  wire standby_mem23      ;
  wire standby_mem33      ;
  wire pwr1_off_mem03;
  wire pwr1_off_mem13;
  wire pwr1_off_mem23;
  wire pwr1_off_mem33;
  
  // Control3 signals3
  wire set_status_smc3   ;
  wire clr_status_smc3   ;
  wire set_status_urt3   ;
  wire clr_status_urt3   ;
  wire set_status_macb03   ;
  wire clr_status_macb03   ;
  wire set_status_macb13   ;
  wire clr_status_macb13   ;
  wire set_status_macb23   ;
  wire clr_status_macb23   ;
  wire set_status_macb33   ;
  wire clr_status_macb33   ;
  wire set_status_dma3   ;
  wire clr_status_dma3   ;
  wire set_status_cpu3   ;
  wire clr_status_cpu3   ;
  wire set_status_alut3   ;
  wire clr_status_alut3   ;
  wire set_status_mem3   ;
  wire clr_status_mem3   ;


  // Status and Control3 registers
  reg [31:0]  L1_status_reg3;
  reg  [31:0] L1_ctrl_reg3  ;
  reg  [31:0] L1_ctrl_domain3  ;
  reg L1_ctrl_cpu_off_reg3;
  reg [31:0]  pcm_mask_reg3;
  reg [31:0]  pcm_status_reg3;

  // Signals3 gated3 in scan_mode3
  //SMC3
  wire  rstn_non_srpg_smc_int3;
  wire  gate_clk_smc_int3    ;     
  wire  isolate_smc_int3    ;       
  wire save_edge_smc_int3;
  wire restore_edge_smc_int3;
  wire  pwr1_on_smc_int3    ;      
  wire  pwr2_on_smc_int3    ;      


  //URT3
  wire   rstn_non_srpg_urt_int3;
  wire   gate_clk_urt_int3     ;     
  wire   isolate_urt_int3      ;       
  wire save_edge_urt_int3;
  wire restore_edge_urt_int3;
  wire   pwr1_on_urt_int3      ;      
  wire   pwr2_on_urt_int3      ;      

  // ETH03
  wire   rstn_non_srpg_macb0_int3;
  wire   gate_clk_macb0_int3     ;     
  wire   isolate_macb0_int3      ;       
  wire save_edge_macb0_int3;
  wire restore_edge_macb0_int3;
  wire   pwr1_on_macb0_int3      ;      
  wire   pwr2_on_macb0_int3      ;      
  // ETH13
  wire   rstn_non_srpg_macb1_int3;
  wire   gate_clk_macb1_int3     ;     
  wire   isolate_macb1_int3      ;       
  wire save_edge_macb1_int3;
  wire restore_edge_macb1_int3;
  wire   pwr1_on_macb1_int3      ;      
  wire   pwr2_on_macb1_int3      ;      
  // ETH23
  wire   rstn_non_srpg_macb2_int3;
  wire   gate_clk_macb2_int3     ;     
  wire   isolate_macb2_int3      ;       
  wire save_edge_macb2_int3;
  wire restore_edge_macb2_int3;
  wire   pwr1_on_macb2_int3      ;      
  wire   pwr2_on_macb2_int3      ;      
  // ETH33
  wire   rstn_non_srpg_macb3_int3;
  wire   gate_clk_macb3_int3     ;     
  wire   isolate_macb3_int3      ;       
  wire save_edge_macb3_int3;
  wire restore_edge_macb3_int3;
  wire   pwr1_on_macb3_int3      ;      
  wire   pwr2_on_macb3_int3      ;      

  // DMA3
  wire   rstn_non_srpg_dma_int3;
  wire   gate_clk_dma_int3     ;     
  wire   isolate_dma_int3      ;       
  wire save_edge_dma_int3;
  wire restore_edge_dma_int3;
  wire   pwr1_on_dma_int3      ;      
  wire   pwr2_on_dma_int3      ;      

  // CPU3
  wire   rstn_non_srpg_cpu_int3;
  wire   gate_clk_cpu_int3     ;     
  wire   isolate_cpu_int3      ;       
  wire save_edge_cpu_int3;
  wire restore_edge_cpu_int3;
  wire   pwr1_on_cpu_int3      ;      
  wire   pwr2_on_cpu_int3      ;  
  wire L1_ctrl_cpu_off_p3;    

  reg save_alut_tmp3;
  // DFS3 sm3

  reg cpu_shutoff_ctrl3;

  reg mte_mac_off_start3, mte_mac012_start3, mte_mac013_start3, mte_mac023_start3, mte_mac123_start3;
  reg mte_mac01_start3, mte_mac02_start3, mte_mac03_start3, mte_mac12_start3, mte_mac13_start3, mte_mac23_start3;
  reg mte_mac0_start3, mte_mac1_start3, mte_mac2_start3, mte_mac3_start3;
  reg mte_sys_hibernate3 ;
  reg mte_dma_start3 ;
  reg mte_cpu_start3 ;
  reg mte_mac_off_sleep_start3, mte_mac012_sleep_start3, mte_mac013_sleep_start3, mte_mac023_sleep_start3, mte_mac123_sleep_start3;
  reg mte_mac01_sleep_start3, mte_mac02_sleep_start3, mte_mac03_sleep_start3, mte_mac12_sleep_start3, mte_mac13_sleep_start3, mte_mac23_sleep_start3;
  reg mte_mac0_sleep_start3, mte_mac1_sleep_start3, mte_mac2_sleep_start3, mte_mac3_sleep_start3;
  reg mte_dma_sleep_start3;
  reg mte_mac_off_to_default3, mte_mac012_to_default3, mte_mac013_to_default3, mte_mac023_to_default3, mte_mac123_to_default3;
  reg mte_mac01_to_default3, mte_mac02_to_default3, mte_mac03_to_default3, mte_mac12_to_default3, mte_mac13_to_default3, mte_mac23_to_default3;
  reg mte_mac0_to_default3, mte_mac1_to_default3, mte_mac2_to_default3, mte_mac3_to_default3;
  reg mte_dma_isolate_dis3;
  reg mte_cpu_isolate_dis3;
  reg mte_sys_hibernate_to_default3;


  // Latch3 the CPU3 SLEEP3 invocation3
  always @( posedge pclk3 or negedge nprst3) 
  begin
    if(!nprst3)
      L1_ctrl_cpu_off_reg3 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg3 <= L1_ctrl_domain3[8];
  end

  // Create3 a pulse3 for sleep3 detection3 
  assign L1_ctrl_cpu_off_p3 =  L1_ctrl_domain3[8] && !L1_ctrl_cpu_off_reg3;
  
  // CPU3 sleep3 contol3 logic 
  // Shut3 off3 CPU3 when L1_ctrl_cpu_off_p3 is set
  // wake3 cpu3 when any interrupt3 is seen3  
  always @( posedge pclk3 or negedge nprst3) 
  begin
    if(!nprst3)
     cpu_shutoff_ctrl3 <= 1'b0;
    else if(cpu_shutoff_ctrl3 && int_source_h3)
     cpu_shutoff_ctrl3 <= 1'b0;
    else if (L1_ctrl_cpu_off_p3)
     cpu_shutoff_ctrl3 <= 1'b1;
  end
 
  // instantiate3 power3 contol3  block for uart3
  power_ctrl_sm3 i_urt_power_ctrl_sm3(
    .pclk3(pclk3),
    .nprst3(nprst3),
    .L1_module_req3(L1_ctrl_domain3[1]),
    .set_status_module3(set_status_urt3),
    .clr_status_module3(clr_status_urt3),
    .rstn_non_srpg_module3(rstn_non_srpg_urt_int3),
    .gate_clk_module3(gate_clk_urt_int3),
    .isolate_module3(isolate_urt_int3),
    .save_edge3(save_edge_urt_int3),
    .restore_edge3(restore_edge_urt_int3),
    .pwr1_on3(pwr1_on_urt_int3),
    .pwr2_on3(pwr2_on_urt_int3)
    );
  

  // instantiate3 power3 contol3  block for smc3
  power_ctrl_sm3 i_smc_power_ctrl_sm3(
    .pclk3(pclk3),
    .nprst3(nprst3),
    .L1_module_req3(L1_ctrl_domain3[2]),
    .set_status_module3(set_status_smc3),
    .clr_status_module3(clr_status_smc3),
    .rstn_non_srpg_module3(rstn_non_srpg_smc_int3),
    .gate_clk_module3(gate_clk_smc_int3),
    .isolate_module3(isolate_smc_int3),
    .save_edge3(save_edge_smc_int3),
    .restore_edge3(restore_edge_smc_int3),
    .pwr1_on3(pwr1_on_smc_int3),
    .pwr2_on3(pwr2_on_smc_int3)
    );

  // power3 control3 for macb03
  power_ctrl_sm3 i_macb0_power_ctrl_sm3(
    .pclk3(pclk3),
    .nprst3(nprst3),
    .L1_module_req3(L1_ctrl_domain3[3]),
    .set_status_module3(set_status_macb03),
    .clr_status_module3(clr_status_macb03),
    .rstn_non_srpg_module3(rstn_non_srpg_macb0_int3),
    .gate_clk_module3(gate_clk_macb0_int3),
    .isolate_module3(isolate_macb0_int3),
    .save_edge3(save_edge_macb0_int3),
    .restore_edge3(restore_edge_macb0_int3),
    .pwr1_on3(pwr1_on_macb0_int3),
    .pwr2_on3(pwr2_on_macb0_int3)
    );
  // power3 control3 for macb13
  power_ctrl_sm3 i_macb1_power_ctrl_sm3(
    .pclk3(pclk3),
    .nprst3(nprst3),
    .L1_module_req3(L1_ctrl_domain3[4]),
    .set_status_module3(set_status_macb13),
    .clr_status_module3(clr_status_macb13),
    .rstn_non_srpg_module3(rstn_non_srpg_macb1_int3),
    .gate_clk_module3(gate_clk_macb1_int3),
    .isolate_module3(isolate_macb1_int3),
    .save_edge3(save_edge_macb1_int3),
    .restore_edge3(restore_edge_macb1_int3),
    .pwr1_on3(pwr1_on_macb1_int3),
    .pwr2_on3(pwr2_on_macb1_int3)
    );
  // power3 control3 for macb23
  power_ctrl_sm3 i_macb2_power_ctrl_sm3(
    .pclk3(pclk3),
    .nprst3(nprst3),
    .L1_module_req3(L1_ctrl_domain3[5]),
    .set_status_module3(set_status_macb23),
    .clr_status_module3(clr_status_macb23),
    .rstn_non_srpg_module3(rstn_non_srpg_macb2_int3),
    .gate_clk_module3(gate_clk_macb2_int3),
    .isolate_module3(isolate_macb2_int3),
    .save_edge3(save_edge_macb2_int3),
    .restore_edge3(restore_edge_macb2_int3),
    .pwr1_on3(pwr1_on_macb2_int3),
    .pwr2_on3(pwr2_on_macb2_int3)
    );
  // power3 control3 for macb33
  power_ctrl_sm3 i_macb3_power_ctrl_sm3(
    .pclk3(pclk3),
    .nprst3(nprst3),
    .L1_module_req3(L1_ctrl_domain3[6]),
    .set_status_module3(set_status_macb33),
    .clr_status_module3(clr_status_macb33),
    .rstn_non_srpg_module3(rstn_non_srpg_macb3_int3),
    .gate_clk_module3(gate_clk_macb3_int3),
    .isolate_module3(isolate_macb3_int3),
    .save_edge3(save_edge_macb3_int3),
    .restore_edge3(restore_edge_macb3_int3),
    .pwr1_on3(pwr1_on_macb3_int3),
    .pwr2_on3(pwr2_on_macb3_int3)
    );
  // power3 control3 for dma3
  power_ctrl_sm3 i_dma_power_ctrl_sm3(
    .pclk3(pclk3),
    .nprst3(nprst3),
    .L1_module_req3(L1_ctrl_domain3[7]),
    .set_status_module3(set_status_dma3),
    .clr_status_module3(clr_status_dma3),
    .rstn_non_srpg_module3(rstn_non_srpg_dma_int3),
    .gate_clk_module3(gate_clk_dma_int3),
    .isolate_module3(isolate_dma_int3),
    .save_edge3(save_edge_dma_int3),
    .restore_edge3(restore_edge_dma_int3),
    .pwr1_on3(pwr1_on_dma_int3),
    .pwr2_on3(pwr2_on_dma_int3)
    );
  // power3 control3 for CPU3
  power_ctrl_sm3 i_cpu_power_ctrl_sm3(
    .pclk3(pclk3),
    .nprst3(nprst3),
    .L1_module_req3(cpu_shutoff_ctrl3),
    .set_status_module3(set_status_cpu3),
    .clr_status_module3(clr_status_cpu3),
    .rstn_non_srpg_module3(rstn_non_srpg_cpu_int3),
    .gate_clk_module3(gate_clk_cpu_int3),
    .isolate_module3(isolate_cpu_int3),
    .save_edge3(save_edge_cpu_int3),
    .restore_edge3(restore_edge_cpu_int3),
    .pwr1_on3(pwr1_on_cpu_int3),
    .pwr2_on3(pwr2_on_cpu_int3)
    );

  assign valid_reg_write3 =  (psel3 && pwrite3 && penable3);
  assign valid_reg_read3  =  (psel3 && (!pwrite3) && penable3);

  assign L1_ctrl_access3  =  (paddr3[15:0] == 16'b0000000000000100); 
  assign L1_status_access3 = (paddr3[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access3 =   (paddr3[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access3 = (paddr3[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control3 and status register
  always @(*)
  begin  
    if(valid_reg_read3 && L1_ctrl_access3) 
      prdata3 = L1_ctrl_reg3;
    else if (valid_reg_read3 && L1_status_access3)
      prdata3 = L1_status_reg3;
    else if (valid_reg_read3 && pcm_int_mask_access3)
      prdata3 = pcm_mask_reg3;
    else if (valid_reg_read3 && pcm_int_status_access3)
      prdata3 = pcm_status_reg3;
    else 
      prdata3 = 0;
  end

  assign set_status_mem3 =  (set_status_macb03 && set_status_macb13 && set_status_macb23 &&
                            set_status_macb33 && set_status_dma3 && set_status_cpu3);

  assign clr_status_mem3 =  (clr_status_macb03 && clr_status_macb13 && clr_status_macb23 &&
                            clr_status_macb33 && clr_status_dma3 && clr_status_cpu3);

  assign set_status_alut3 = (set_status_macb03 && set_status_macb13 && set_status_macb23 && set_status_macb33);

  assign clr_status_alut3 = (clr_status_macb03 || clr_status_macb13 || clr_status_macb23  || clr_status_macb33);

  // Write accesses to the control3 and status register
 
  always @(posedge pclk3 or negedge nprst3)
  begin
    if (!nprst3) begin
      L1_ctrl_reg3   <= 0;
      L1_status_reg3 <= 0;
      pcm_mask_reg3 <= 0;
    end else begin
      // CTRL3 reg updates3
      if (valid_reg_write3 && L1_ctrl_access3) 
        L1_ctrl_reg3 <= pwdata3; // Writes3 to the ctrl3 reg
      if (valid_reg_write3 && pcm_int_mask_access3) 
        pcm_mask_reg3 <= pwdata3; // Writes3 to the ctrl3 reg

      if (set_status_urt3 == 1'b1)  
        L1_status_reg3[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt3 == 1'b1) 
        L1_status_reg3[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc3 == 1'b1) 
        L1_status_reg3[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc3 == 1'b1) 
        L1_status_reg3[2] <= 1'b0; // Clear the status bit

      if (set_status_macb03 == 1'b1)  
        L1_status_reg3[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb03 == 1'b1) 
        L1_status_reg3[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb13 == 1'b1)  
        L1_status_reg3[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb13 == 1'b1) 
        L1_status_reg3[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb23 == 1'b1)  
        L1_status_reg3[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb23 == 1'b1) 
        L1_status_reg3[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb33 == 1'b1)  
        L1_status_reg3[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb33 == 1'b1) 
        L1_status_reg3[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma3 == 1'b1)  
        L1_status_reg3[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma3 == 1'b1) 
        L1_status_reg3[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu3 == 1'b1)  
        L1_status_reg3[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu3 == 1'b1) 
        L1_status_reg3[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut3 == 1'b1)  
        L1_status_reg3[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut3 == 1'b1) 
        L1_status_reg3[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem3 == 1'b1)  
        L1_status_reg3[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem3 == 1'b1) 
        L1_status_reg3[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused3 bits of pcm_status_reg3 are tied3 to 0
  always @(posedge pclk3 or negedge nprst3)
  begin
    if (!nprst3)
      pcm_status_reg3[31:4] <= 'b0;
    else  
      pcm_status_reg3[31:4] <= pcm_status_reg3[31:4];
  end
  
  // interrupt3 only of h/w assisted3 wakeup
  // MAC3 3
  always @(posedge pclk3 or negedge nprst3)
  begin
    if(!nprst3)
      pcm_status_reg3[3] <= 1'b0;
    else if (valid_reg_write3 && pcm_int_status_access3) 
      pcm_status_reg3[3] <= pwdata3[3];
    else if (macb3_wakeup3 & ~pcm_mask_reg3[3])
      pcm_status_reg3[3] <= 1'b1;
    else if (valid_reg_read3 && pcm_int_status_access3) 
      pcm_status_reg3[3] <= 1'b0;
    else
      pcm_status_reg3[3] <= pcm_status_reg3[3];
  end  
   
  // MAC3 2
  always @(posedge pclk3 or negedge nprst3)
  begin
    if(!nprst3)
      pcm_status_reg3[2] <= 1'b0;
    else if (valid_reg_write3 && pcm_int_status_access3) 
      pcm_status_reg3[2] <= pwdata3[2];
    else if (macb2_wakeup3 & ~pcm_mask_reg3[2])
      pcm_status_reg3[2] <= 1'b1;
    else if (valid_reg_read3 && pcm_int_status_access3) 
      pcm_status_reg3[2] <= 1'b0;
    else
      pcm_status_reg3[2] <= pcm_status_reg3[2];
  end  

  // MAC3 1
  always @(posedge pclk3 or negedge nprst3)
  begin
    if(!nprst3)
      pcm_status_reg3[1] <= 1'b0;
    else if (valid_reg_write3 && pcm_int_status_access3) 
      pcm_status_reg3[1] <= pwdata3[1];
    else if (macb1_wakeup3 & ~pcm_mask_reg3[1])
      pcm_status_reg3[1] <= 1'b1;
    else if (valid_reg_read3 && pcm_int_status_access3) 
      pcm_status_reg3[1] <= 1'b0;
    else
      pcm_status_reg3[1] <= pcm_status_reg3[1];
  end  
   
  // MAC3 0
  always @(posedge pclk3 or negedge nprst3)
  begin
    if(!nprst3)
      pcm_status_reg3[0] <= 1'b0;
    else if (valid_reg_write3 && pcm_int_status_access3) 
      pcm_status_reg3[0] <= pwdata3[0];
    else if (macb0_wakeup3 & ~pcm_mask_reg3[0])
      pcm_status_reg3[0] <= 1'b1;
    else if (valid_reg_read3 && pcm_int_status_access3) 
      pcm_status_reg3[0] <= 1'b0;
    else
      pcm_status_reg3[0] <= pcm_status_reg3[0];
  end  

  assign pcm_macb_wakeup_int3 = |pcm_status_reg3;

  reg [31:0] L1_ctrl_reg13;
  always @(posedge pclk3 or negedge nprst3)
  begin
    if(!nprst3)
      L1_ctrl_reg13 <= 0;
    else
      L1_ctrl_reg13 <= L1_ctrl_reg3;
  end

  // Program3 mode decode
  always @(L1_ctrl_reg3 or L1_ctrl_reg13 or int_source_h3 or cpu_shutoff_ctrl3) begin
    mte_smc_start3 = 0;
    mte_uart_start3 = 0;
    mte_smc_uart_start3  = 0;
    mte_mac_off_start3  = 0;
    mte_mac012_start3 = 0;
    mte_mac013_start3 = 0;
    mte_mac023_start3 = 0;
    mte_mac123_start3 = 0;
    mte_mac01_start3 = 0;
    mte_mac02_start3 = 0;
    mte_mac03_start3 = 0;
    mte_mac12_start3 = 0;
    mte_mac13_start3 = 0;
    mte_mac23_start3 = 0;
    mte_mac0_start3 = 0;
    mte_mac1_start3 = 0;
    mte_mac2_start3 = 0;
    mte_mac3_start3 = 0;
    mte_sys_hibernate3 = 0 ;
    mte_dma_start3 = 0 ;
    mte_cpu_start3 = 0 ;

    mte_mac0_sleep_start3 = (L1_ctrl_reg3 ==  'h14) && (L1_ctrl_reg13 == 'h4 );
    mte_mac1_sleep_start3 = (L1_ctrl_reg3 ==  'h14) && (L1_ctrl_reg13 == 'h5 ); 
    mte_mac2_sleep_start3 = (L1_ctrl_reg3 ==  'h14) && (L1_ctrl_reg13 == 'h6 ); 
    mte_mac3_sleep_start3 = (L1_ctrl_reg3 ==  'h14) && (L1_ctrl_reg13 == 'h7 ); 
    mte_mac01_sleep_start3 = (L1_ctrl_reg3 ==  'h14) && (L1_ctrl_reg13 == 'h8 ); 
    mte_mac02_sleep_start3 = (L1_ctrl_reg3 ==  'h14) && (L1_ctrl_reg13 == 'h9 ); 
    mte_mac03_sleep_start3 = (L1_ctrl_reg3 ==  'h14) && (L1_ctrl_reg13 == 'hA ); 
    mte_mac12_sleep_start3 = (L1_ctrl_reg3 ==  'h14) && (L1_ctrl_reg13 == 'hB ); 
    mte_mac13_sleep_start3 = (L1_ctrl_reg3 ==  'h14) && (L1_ctrl_reg13 == 'hC ); 
    mte_mac23_sleep_start3 = (L1_ctrl_reg3 ==  'h14) && (L1_ctrl_reg13 == 'hD ); 
    mte_mac012_sleep_start3 = (L1_ctrl_reg3 ==  'h14) && (L1_ctrl_reg13 == 'hE ); 
    mte_mac013_sleep_start3 = (L1_ctrl_reg3 ==  'h14) && (L1_ctrl_reg13 == 'hF ); 
    mte_mac023_sleep_start3 = (L1_ctrl_reg3 ==  'h14) && (L1_ctrl_reg13 == 'h10 ); 
    mte_mac123_sleep_start3 = (L1_ctrl_reg3 ==  'h14) && (L1_ctrl_reg13 == 'h11 ); 
    mte_mac_off_sleep_start3 =  (L1_ctrl_reg3 == 'h14) && (L1_ctrl_reg13 == 'h12 );
    mte_dma_sleep_start3 =  (L1_ctrl_reg3 == 'h14) && (L1_ctrl_reg13 == 'h13 );

    mte_pm_uart_to_default_start3 = (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'h1);
    mte_pm_smc_to_default_start3 = (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'h2);
    mte_pm_smc_uart_to_default_start3 = (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'h3); 
    mte_mac0_to_default3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'h4); 
    mte_mac1_to_default3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'h5); 
    mte_mac2_to_default3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'h6); 
    mte_mac3_to_default3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'h7); 
    mte_mac01_to_default3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'h8); 
    mte_mac02_to_default3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'h9); 
    mte_mac03_to_default3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'hA); 
    mte_mac12_to_default3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'hB); 
    mte_mac13_to_default3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'hC); 
    mte_mac23_to_default3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'hD); 
    mte_mac012_to_default3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'hE); 
    mte_mac013_to_default3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'hF); 
    mte_mac023_to_default3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'h10); 
    mte_mac123_to_default3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'h11); 
    mte_mac_off_to_default3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'h12); 
    mte_dma_isolate_dis3 =  (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'h13); 
    mte_cpu_isolate_dis3 =  (int_source_h3) && (cpu_shutoff_ctrl3) && (L1_ctrl_reg3 != 'h15);
    mte_sys_hibernate_to_default3 = (L1_ctrl_reg3 == 32'h0) && (L1_ctrl_reg13 == 'h15); 

   
    if (L1_ctrl_reg13 == 'h0) begin // This3 check is to make mte_cpu_start3
                                   // is set only when you from default state 
      case (L1_ctrl_reg3)
        'h0 : L1_ctrl_domain3 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain3 = 32'h2; // PM_uart3
                mte_uart_start3 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain3 = 32'h4; // PM_smc3
                mte_smc_start3 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain3 = 32'h6; // PM_smc_uart3
                mte_smc_uart_start3 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain3 = 32'h8; //  PM_macb03
                mte_mac0_start3 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain3 = 32'h10; //  PM_macb13
                mte_mac1_start3 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain3 = 32'h20; //  PM_macb23
                mte_mac2_start3 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain3 = 32'h40; //  PM_macb33
                mte_mac3_start3 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain3 = 32'h18; //  PM_macb013
                mte_mac01_start3 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain3 = 32'h28; //  PM_macb023
                mte_mac02_start3 = 1;
              end
        'hA : begin  
                L1_ctrl_domain3 = 32'h48; //  PM_macb033
                mte_mac03_start3 = 1;
              end
        'hB : begin  
                L1_ctrl_domain3 = 32'h30; //  PM_macb123
                mte_mac12_start3 = 1;
              end
        'hC : begin  
                L1_ctrl_domain3 = 32'h50; //  PM_macb133
                mte_mac13_start3 = 1;
              end
        'hD : begin  
                L1_ctrl_domain3 = 32'h60; //  PM_macb233
                mte_mac23_start3 = 1;
              end
        'hE : begin  
                L1_ctrl_domain3 = 32'h38; //  PM_macb0123
                mte_mac012_start3 = 1;
              end
        'hF : begin  
                L1_ctrl_domain3 = 32'h58; //  PM_macb0133
                mte_mac013_start3 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain3 = 32'h68; //  PM_macb0233
                mte_mac023_start3 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain3 = 32'h70; //  PM_macb1233
                mte_mac123_start3 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain3 = 32'h78; //  PM_macb_off3
                mte_mac_off_start3 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain3 = 32'h80; //  PM_dma3
                mte_dma_start3 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain3 = 32'h100; //  PM_cpu_sleep3
                mte_cpu_start3 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain3 = 32'h1FE; //  PM_hibernate3
                mte_sys_hibernate3 = 1;
              end
         default: L1_ctrl_domain3 = 32'h0;
      endcase
    end
  end


  wire to_default3 = (L1_ctrl_reg3 == 0);

  // Scan3 mode gating3 of power3 and isolation3 control3 signals3
  //SMC3
  assign rstn_non_srpg_smc3  = (scan_mode3 == 1'b0) ? rstn_non_srpg_smc_int3 : 1'b1;  
  assign gate_clk_smc3       = (scan_mode3 == 1'b0) ? gate_clk_smc_int3 : 1'b0;     
  assign isolate_smc3        = (scan_mode3 == 1'b0) ? isolate_smc_int3 : 1'b0;      
  assign pwr1_on_smc3        = (scan_mode3 == 1'b0) ? pwr1_on_smc_int3 : 1'b1;       
  assign pwr2_on_smc3        = (scan_mode3 == 1'b0) ? pwr2_on_smc_int3 : 1'b1;       
  assign pwr1_off_smc3       = (scan_mode3 == 1'b0) ? (!pwr1_on_smc_int3) : 1'b0;       
  assign pwr2_off_smc3       = (scan_mode3 == 1'b0) ? (!pwr2_on_smc_int3) : 1'b0;       
  assign save_edge_smc3       = (scan_mode3 == 1'b0) ? (save_edge_smc_int3) : 1'b0;       
  assign restore_edge_smc3       = (scan_mode3 == 1'b0) ? (restore_edge_smc_int3) : 1'b0;       

  //URT3
  assign rstn_non_srpg_urt3  = (scan_mode3 == 1'b0) ?  rstn_non_srpg_urt_int3 : 1'b1;  
  assign gate_clk_urt3       = (scan_mode3 == 1'b0) ?  gate_clk_urt_int3      : 1'b0;     
  assign isolate_urt3        = (scan_mode3 == 1'b0) ?  isolate_urt_int3       : 1'b0;      
  assign pwr1_on_urt3        = (scan_mode3 == 1'b0) ?  pwr1_on_urt_int3       : 1'b1;       
  assign pwr2_on_urt3        = (scan_mode3 == 1'b0) ?  pwr2_on_urt_int3       : 1'b1;       
  assign pwr1_off_urt3       = (scan_mode3 == 1'b0) ?  (!pwr1_on_urt_int3)  : 1'b0;       
  assign pwr2_off_urt3       = (scan_mode3 == 1'b0) ?  (!pwr2_on_urt_int3)  : 1'b0;       
  assign save_edge_urt3       = (scan_mode3 == 1'b0) ? (save_edge_urt_int3) : 1'b0;       
  assign restore_edge_urt3       = (scan_mode3 == 1'b0) ? (restore_edge_urt_int3) : 1'b0;       

  //ETH03
  assign rstn_non_srpg_macb03 = (scan_mode3 == 1'b0) ?  rstn_non_srpg_macb0_int3 : 1'b1;  
  assign gate_clk_macb03       = (scan_mode3 == 1'b0) ?  gate_clk_macb0_int3      : 1'b0;     
  assign isolate_macb03        = (scan_mode3 == 1'b0) ?  isolate_macb0_int3       : 1'b0;      
  assign pwr1_on_macb03        = (scan_mode3 == 1'b0) ?  pwr1_on_macb0_int3       : 1'b1;       
  assign pwr2_on_macb03        = (scan_mode3 == 1'b0) ?  pwr2_on_macb0_int3       : 1'b1;       
  assign pwr1_off_macb03       = (scan_mode3 == 1'b0) ?  (!pwr1_on_macb0_int3)  : 1'b0;       
  assign pwr2_off_macb03       = (scan_mode3 == 1'b0) ?  (!pwr2_on_macb0_int3)  : 1'b0;       
  assign save_edge_macb03       = (scan_mode3 == 1'b0) ? (save_edge_macb0_int3) : 1'b0;       
  assign restore_edge_macb03       = (scan_mode3 == 1'b0) ? (restore_edge_macb0_int3) : 1'b0;       

  //ETH13
  assign rstn_non_srpg_macb13 = (scan_mode3 == 1'b0) ?  rstn_non_srpg_macb1_int3 : 1'b1;  
  assign gate_clk_macb13       = (scan_mode3 == 1'b0) ?  gate_clk_macb1_int3      : 1'b0;     
  assign isolate_macb13        = (scan_mode3 == 1'b0) ?  isolate_macb1_int3       : 1'b0;      
  assign pwr1_on_macb13        = (scan_mode3 == 1'b0) ?  pwr1_on_macb1_int3       : 1'b1;       
  assign pwr2_on_macb13        = (scan_mode3 == 1'b0) ?  pwr2_on_macb1_int3       : 1'b1;       
  assign pwr1_off_macb13       = (scan_mode3 == 1'b0) ?  (!pwr1_on_macb1_int3)  : 1'b0;       
  assign pwr2_off_macb13       = (scan_mode3 == 1'b0) ?  (!pwr2_on_macb1_int3)  : 1'b0;       
  assign save_edge_macb13       = (scan_mode3 == 1'b0) ? (save_edge_macb1_int3) : 1'b0;       
  assign restore_edge_macb13       = (scan_mode3 == 1'b0) ? (restore_edge_macb1_int3) : 1'b0;       

  //ETH23
  assign rstn_non_srpg_macb23 = (scan_mode3 == 1'b0) ?  rstn_non_srpg_macb2_int3 : 1'b1;  
  assign gate_clk_macb23       = (scan_mode3 == 1'b0) ?  gate_clk_macb2_int3      : 1'b0;     
  assign isolate_macb23        = (scan_mode3 == 1'b0) ?  isolate_macb2_int3       : 1'b0;      
  assign pwr1_on_macb23        = (scan_mode3 == 1'b0) ?  pwr1_on_macb2_int3       : 1'b1;       
  assign pwr2_on_macb23        = (scan_mode3 == 1'b0) ?  pwr2_on_macb2_int3       : 1'b1;       
  assign pwr1_off_macb23       = (scan_mode3 == 1'b0) ?  (!pwr1_on_macb2_int3)  : 1'b0;       
  assign pwr2_off_macb23       = (scan_mode3 == 1'b0) ?  (!pwr2_on_macb2_int3)  : 1'b0;       
  assign save_edge_macb23       = (scan_mode3 == 1'b0) ? (save_edge_macb2_int3) : 1'b0;       
  assign restore_edge_macb23       = (scan_mode3 == 1'b0) ? (restore_edge_macb2_int3) : 1'b0;       

  //ETH33
  assign rstn_non_srpg_macb33 = (scan_mode3 == 1'b0) ?  rstn_non_srpg_macb3_int3 : 1'b1;  
  assign gate_clk_macb33       = (scan_mode3 == 1'b0) ?  gate_clk_macb3_int3      : 1'b0;     
  assign isolate_macb33        = (scan_mode3 == 1'b0) ?  isolate_macb3_int3       : 1'b0;      
  assign pwr1_on_macb33        = (scan_mode3 == 1'b0) ?  pwr1_on_macb3_int3       : 1'b1;       
  assign pwr2_on_macb33        = (scan_mode3 == 1'b0) ?  pwr2_on_macb3_int3       : 1'b1;       
  assign pwr1_off_macb33       = (scan_mode3 == 1'b0) ?  (!pwr1_on_macb3_int3)  : 1'b0;       
  assign pwr2_off_macb33       = (scan_mode3 == 1'b0) ?  (!pwr2_on_macb3_int3)  : 1'b0;       
  assign save_edge_macb33       = (scan_mode3 == 1'b0) ? (save_edge_macb3_int3) : 1'b0;       
  assign restore_edge_macb33       = (scan_mode3 == 1'b0) ? (restore_edge_macb3_int3) : 1'b0;       

  // MEM3
  assign rstn_non_srpg_mem3 =   (rstn_non_srpg_macb03 && rstn_non_srpg_macb13 && rstn_non_srpg_macb23 &&
                                rstn_non_srpg_macb33 && rstn_non_srpg_dma3 && rstn_non_srpg_cpu3 && rstn_non_srpg_urt3 &&
                                rstn_non_srpg_smc3);

  assign gate_clk_mem3 =  (gate_clk_macb03 && gate_clk_macb13 && gate_clk_macb23 &&
                            gate_clk_macb33 && gate_clk_dma3 && gate_clk_cpu3 && gate_clk_urt3 && gate_clk_smc3);

  assign isolate_mem3  = (isolate_macb03 && isolate_macb13 && isolate_macb23 &&
                         isolate_macb33 && isolate_dma3 && isolate_cpu3 && isolate_urt3 && isolate_smc3);


  assign pwr1_on_mem3        =   ~pwr1_off_mem3;

  assign pwr2_on_mem3        =   ~pwr2_off_mem3;

  assign pwr1_off_mem3       =  (pwr1_off_macb03 && pwr1_off_macb13 && pwr1_off_macb23 &&
                                 pwr1_off_macb33 && pwr1_off_dma3 && pwr1_off_cpu3 && pwr1_off_urt3 && pwr1_off_smc3);


  assign pwr2_off_mem3       =  (pwr2_off_macb03 && pwr2_off_macb13 && pwr2_off_macb23 &&
                                pwr2_off_macb33 && pwr2_off_dma3 && pwr2_off_cpu3 && pwr2_off_urt3 && pwr2_off_smc3);

  assign save_edge_mem3      =  (save_edge_macb03 && save_edge_macb13 && save_edge_macb23 &&
                                save_edge_macb33 && save_edge_dma3 && save_edge_cpu3 && save_edge_smc3 && save_edge_urt3);

  assign restore_edge_mem3   =  (restore_edge_macb03 && restore_edge_macb13 && restore_edge_macb23  &&
                                restore_edge_macb33 && restore_edge_dma3 && restore_edge_cpu3 && restore_edge_urt3 &&
                                restore_edge_smc3);

  assign standby_mem03 = pwr1_off_macb03 && (~ (pwr1_off_macb03 && pwr1_off_macb13 && pwr1_off_macb23 && pwr1_off_macb33 && pwr1_off_urt3 && pwr1_off_smc3 && pwr1_off_dma3 && pwr1_off_cpu3));
  assign standby_mem13 = pwr1_off_macb13 && (~ (pwr1_off_macb03 && pwr1_off_macb13 && pwr1_off_macb23 && pwr1_off_macb33 && pwr1_off_urt3 && pwr1_off_smc3 && pwr1_off_dma3 && pwr1_off_cpu3));
  assign standby_mem23 = pwr1_off_macb23 && (~ (pwr1_off_macb03 && pwr1_off_macb13 && pwr1_off_macb23 && pwr1_off_macb33 && pwr1_off_urt3 && pwr1_off_smc3 && pwr1_off_dma3 && pwr1_off_cpu3));
  assign standby_mem33 = pwr1_off_macb33 && (~ (pwr1_off_macb03 && pwr1_off_macb13 && pwr1_off_macb23 && pwr1_off_macb33 && pwr1_off_urt3 && pwr1_off_smc3 && pwr1_off_dma3 && pwr1_off_cpu3));

  assign pwr1_off_mem03 = pwr1_off_mem3;
  assign pwr1_off_mem13 = pwr1_off_mem3;
  assign pwr1_off_mem23 = pwr1_off_mem3;
  assign pwr1_off_mem33 = pwr1_off_mem3;

  assign rstn_non_srpg_alut3  =  (rstn_non_srpg_macb03 && rstn_non_srpg_macb13 && rstn_non_srpg_macb23 && rstn_non_srpg_macb33);


   assign gate_clk_alut3       =  (gate_clk_macb03 && gate_clk_macb13 && gate_clk_macb23 && gate_clk_macb33);


    assign isolate_alut3        =  (isolate_macb03 && isolate_macb13 && isolate_macb23 && isolate_macb33);


    assign pwr1_on_alut3        =  (pwr1_on_macb03 || pwr1_on_macb13 || pwr1_on_macb23 || pwr1_on_macb33);


    assign pwr2_on_alut3        =  (pwr2_on_macb03 || pwr2_on_macb13 || pwr2_on_macb23 || pwr2_on_macb33);


    assign pwr1_off_alut3       =  (pwr1_off_macb03 && pwr1_off_macb13 && pwr1_off_macb23 && pwr1_off_macb33);


    assign pwr2_off_alut3       =  (pwr2_off_macb03 && pwr2_off_macb13 && pwr2_off_macb23 && pwr2_off_macb33);


    assign save_edge_alut3      =  (save_edge_macb03 && save_edge_macb13 && save_edge_macb23 && save_edge_macb33);


    assign restore_edge_alut3   =  (restore_edge_macb03 || restore_edge_macb13 || restore_edge_macb23 ||
                                   restore_edge_macb33) && save_alut_tmp3;

     // alut3 power3 off3 detection3
  always @(posedge pclk3 or negedge nprst3) begin
    if (!nprst3) 
       save_alut_tmp3 <= 0;
    else if (restore_edge_alut3)
       save_alut_tmp3 <= 0;
    else if (save_edge_alut3)
       save_alut_tmp3 <= 1;
  end

  //DMA3
  assign rstn_non_srpg_dma3 = (scan_mode3 == 1'b0) ?  rstn_non_srpg_dma_int3 : 1'b1;  
  assign gate_clk_dma3       = (scan_mode3 == 1'b0) ?  gate_clk_dma_int3      : 1'b0;     
  assign isolate_dma3        = (scan_mode3 == 1'b0) ?  isolate_dma_int3       : 1'b0;      
  assign pwr1_on_dma3        = (scan_mode3 == 1'b0) ?  pwr1_on_dma_int3       : 1'b1;       
  assign pwr2_on_dma3        = (scan_mode3 == 1'b0) ?  pwr2_on_dma_int3       : 1'b1;       
  assign pwr1_off_dma3       = (scan_mode3 == 1'b0) ?  (!pwr1_on_dma_int3)  : 1'b0;       
  assign pwr2_off_dma3       = (scan_mode3 == 1'b0) ?  (!pwr2_on_dma_int3)  : 1'b0;       
  assign save_edge_dma3       = (scan_mode3 == 1'b0) ? (save_edge_dma_int3) : 1'b0;       
  assign restore_edge_dma3       = (scan_mode3 == 1'b0) ? (restore_edge_dma_int3) : 1'b0;       

  //CPU3
  assign rstn_non_srpg_cpu3 = (scan_mode3 == 1'b0) ?  rstn_non_srpg_cpu_int3 : 1'b1;  
  assign gate_clk_cpu3       = (scan_mode3 == 1'b0) ?  gate_clk_cpu_int3      : 1'b0;     
  assign isolate_cpu3        = (scan_mode3 == 1'b0) ?  isolate_cpu_int3       : 1'b0;      
  assign pwr1_on_cpu3        = (scan_mode3 == 1'b0) ?  pwr1_on_cpu_int3       : 1'b1;       
  assign pwr2_on_cpu3        = (scan_mode3 == 1'b0) ?  pwr2_on_cpu_int3       : 1'b1;       
  assign pwr1_off_cpu3       = (scan_mode3 == 1'b0) ?  (!pwr1_on_cpu_int3)  : 1'b0;       
  assign pwr2_off_cpu3       = (scan_mode3 == 1'b0) ?  (!pwr2_on_cpu_int3)  : 1'b0;       
  assign save_edge_cpu3       = (scan_mode3 == 1'b0) ? (save_edge_cpu_int3) : 1'b0;       
  assign restore_edge_cpu3       = (scan_mode3 == 1'b0) ? (restore_edge_cpu_int3) : 1'b0;       



  // ASE3

   reg ase_core_12v3, ase_core_10v3, ase_core_08v3, ase_core_06v3;
   reg ase_macb0_12v3,ase_macb1_12v3,ase_macb2_12v3,ase_macb3_12v3;

    // core3 ase3

    // core3 at 1.0 v if (smc3 off3, urt3 off3, macb03 off3, macb13 off3, macb23 off3, macb33 off3
   // core3 at 0.8v if (mac01off3, macb02off3, macb03off3, macb12off3, mac13off3, mac23off3,
   // core3 at 0.6v if (mac012off3, mac013off3, mac023off3, mac123off3, mac0123off3
    // else core3 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb03 && pwr1_off_macb13 && pwr1_off_macb23 && pwr1_off_macb33) || // all mac3 off3
       (pwr1_off_macb33 && pwr1_off_macb23 && pwr1_off_macb13) || // mac123off3 
       (pwr1_off_macb33 && pwr1_off_macb23 && pwr1_off_macb03) || // mac023off3 
       (pwr1_off_macb33 && pwr1_off_macb13 && pwr1_off_macb03) || // mac013off3 
       (pwr1_off_macb23 && pwr1_off_macb13 && pwr1_off_macb03) )  // mac012off3 
       begin
         ase_core_12v3 = 0;
         ase_core_10v3 = 0;
         ase_core_08v3 = 0;
         ase_core_06v3 = 1;
       end
     else if( (pwr1_off_macb23 && pwr1_off_macb33) || // mac233 off3
         (pwr1_off_macb33 && pwr1_off_macb13) || // mac13off3 
         (pwr1_off_macb13 && pwr1_off_macb23) || // mac12off3 
         (pwr1_off_macb33 && pwr1_off_macb03) || // mac03off3 
         (pwr1_off_macb23 && pwr1_off_macb03) || // mac02off3 
         (pwr1_off_macb13 && pwr1_off_macb03))  // mac01off3 
       begin
         ase_core_12v3 = 0;
         ase_core_10v3 = 0;
         ase_core_08v3 = 1;
         ase_core_06v3 = 0;
       end
     else if( (pwr1_off_smc3) || // smc3 off3
         (pwr1_off_macb03 ) || // mac0off3 
         (pwr1_off_macb13 ) || // mac1off3 
         (pwr1_off_macb23 ) || // mac2off3 
         (pwr1_off_macb33 ))  // mac3off3 
       begin
         ase_core_12v3 = 0;
         ase_core_10v3 = 1;
         ase_core_08v3 = 0;
         ase_core_06v3 = 0;
       end
     else if (pwr1_off_urt3)
       begin
         ase_core_12v3 = 1;
         ase_core_10v3 = 0;
         ase_core_08v3 = 0;
         ase_core_06v3 = 0;
       end
     else
       begin
         ase_core_12v3 = 1;
         ase_core_10v3 = 0;
         ase_core_08v3 = 0;
         ase_core_06v3 = 0;
       end
   end


   // cpu3
   // cpu3 @ 1.0v when macoff3, 
   // 
   reg ase_cpu_10v3, ase_cpu_12v3;
   always @(*) begin
    if(pwr1_off_cpu3) begin
     ase_cpu_12v3 = 1'b0;
     ase_cpu_10v3 = 1'b0;
    end
    else if(pwr1_off_macb03 || pwr1_off_macb13 || pwr1_off_macb23 || pwr1_off_macb33)
    begin
     ase_cpu_12v3 = 1'b0;
     ase_cpu_10v3 = 1'b1;
    end
    else
    begin
     ase_cpu_12v3 = 1'b1;
     ase_cpu_10v3 = 1'b0;
    end
   end

   // dma3
   // dma3 @v13.0 for macoff3, 

   reg ase_dma_10v3, ase_dma_12v3;
   always @(*) begin
    if(pwr1_off_dma3) begin
     ase_dma_12v3 = 1'b0;
     ase_dma_10v3 = 1'b0;
    end
    else if(pwr1_off_macb03 || pwr1_off_macb13 || pwr1_off_macb23 || pwr1_off_macb33)
    begin
     ase_dma_12v3 = 1'b0;
     ase_dma_10v3 = 1'b1;
    end
    else
    begin
     ase_dma_12v3 = 1'b1;
     ase_dma_10v3 = 1'b0;
    end
   end

   // alut3
   // @ v13.0 for macoff3

   reg ase_alut_10v3, ase_alut_12v3;
   always @(*) begin
    if(pwr1_off_alut3) begin
     ase_alut_12v3 = 1'b0;
     ase_alut_10v3 = 1'b0;
    end
    else if(pwr1_off_macb03 || pwr1_off_macb13 || pwr1_off_macb23 || pwr1_off_macb33)
    begin
     ase_alut_12v3 = 1'b0;
     ase_alut_10v3 = 1'b1;
    end
    else
    begin
     ase_alut_12v3 = 1'b1;
     ase_alut_10v3 = 1'b0;
    end
   end




   reg ase_uart_12v3;
   reg ase_uart_10v3;
   reg ase_uart_08v3;
   reg ase_uart_06v3;

   reg ase_smc_12v3;


   always @(*) begin
     if(pwr1_off_urt3) begin // uart3 off3
       ase_uart_08v3 = 1'b0;
       ase_uart_06v3 = 1'b0;
       ase_uart_10v3 = 1'b0;
       ase_uart_12v3 = 1'b0;
     end 
     else if( (pwr1_off_macb03 && pwr1_off_macb13 && pwr1_off_macb23 && pwr1_off_macb33) || // all mac3 off3
       (pwr1_off_macb33 && pwr1_off_macb23 && pwr1_off_macb13) || // mac123off3 
       (pwr1_off_macb33 && pwr1_off_macb23 && pwr1_off_macb03) || // mac023off3 
       (pwr1_off_macb33 && pwr1_off_macb13 && pwr1_off_macb03) || // mac013off3 
       (pwr1_off_macb23 && pwr1_off_macb13 && pwr1_off_macb03) )  // mac012off3 
     begin
       ase_uart_06v3 = 1'b1;
       ase_uart_08v3 = 1'b0;
       ase_uart_10v3 = 1'b0;
       ase_uart_12v3 = 1'b0;
     end
     else if( (pwr1_off_macb23 && pwr1_off_macb33) || // mac233 off3
         (pwr1_off_macb33 && pwr1_off_macb13) || // mac13off3 
         (pwr1_off_macb13 && pwr1_off_macb23) || // mac12off3 
         (pwr1_off_macb33 && pwr1_off_macb03) || // mac03off3 
         (pwr1_off_macb13 && pwr1_off_macb03))  // mac01off3  
     begin
       ase_uart_06v3 = 1'b0;
       ase_uart_08v3 = 1'b1;
       ase_uart_10v3 = 1'b0;
       ase_uart_12v3 = 1'b0;
     end
     else if (pwr1_off_smc3 || pwr1_off_macb03 || pwr1_off_macb13 || pwr1_off_macb23 || pwr1_off_macb33) begin // smc3 off3
       ase_uart_08v3 = 1'b0;
       ase_uart_06v3 = 1'b0;
       ase_uart_10v3 = 1'b1;
       ase_uart_12v3 = 1'b0;
     end 
     else begin
       ase_uart_08v3 = 1'b0;
       ase_uart_06v3 = 1'b0;
       ase_uart_10v3 = 1'b0;
       ase_uart_12v3 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc3) begin
     if (pwr1_off_smc3)  // smc3 off3
       ase_smc_12v3 = 1'b0;
    else
       ase_smc_12v3 = 1'b1;
   end

   
   always @(pwr1_off_macb03) begin
     if (pwr1_off_macb03) // macb03 off3
       ase_macb0_12v3 = 1'b0;
     else
       ase_macb0_12v3 = 1'b1;
   end

   always @(pwr1_off_macb13) begin
     if (pwr1_off_macb13) // macb13 off3
       ase_macb1_12v3 = 1'b0;
     else
       ase_macb1_12v3 = 1'b1;
   end

   always @(pwr1_off_macb23) begin // macb23 off3
     if (pwr1_off_macb23) // macb23 off3
       ase_macb2_12v3 = 1'b0;
     else
       ase_macb2_12v3 = 1'b1;
   end

   always @(pwr1_off_macb33) begin // macb33 off3
     if (pwr1_off_macb33) // macb33 off3
       ase_macb3_12v3 = 1'b0;
     else
       ase_macb3_12v3 = 1'b1;
   end


   // core3 voltage3 for vco3
  assign core12v3 = ase_macb0_12v3 & ase_macb1_12v3 & ase_macb2_12v3 & ase_macb3_12v3;

  assign core10v3 =  (ase_macb0_12v3 & ase_macb1_12v3 & ase_macb2_12v3 & (!ase_macb3_12v3)) ||
                    (ase_macb0_12v3 & ase_macb1_12v3 & (!ase_macb2_12v3) & ase_macb3_12v3) ||
                    (ase_macb0_12v3 & (!ase_macb1_12v3) & ase_macb2_12v3 & ase_macb3_12v3) ||
                    ((!ase_macb0_12v3) & ase_macb1_12v3 & ase_macb2_12v3 & ase_macb3_12v3);

  assign core08v3 =  ((!ase_macb0_12v3) & (!ase_macb1_12v3) & (ase_macb2_12v3) & (ase_macb3_12v3)) ||
                    ((!ase_macb0_12v3) & (ase_macb1_12v3) & (!ase_macb2_12v3) & (ase_macb3_12v3)) ||
                    ((!ase_macb0_12v3) & (ase_macb1_12v3) & (ase_macb2_12v3) & (!ase_macb3_12v3)) ||
                    ((ase_macb0_12v3) & (!ase_macb1_12v3) & (!ase_macb2_12v3) & (ase_macb3_12v3)) ||
                    ((ase_macb0_12v3) & (!ase_macb1_12v3) & (ase_macb2_12v3) & (!ase_macb3_12v3)) ||
                    ((ase_macb0_12v3) & (ase_macb1_12v3) & (!ase_macb2_12v3) & (!ase_macb3_12v3));

  assign core06v3 =  ((!ase_macb0_12v3) & (!ase_macb1_12v3) & (!ase_macb2_12v3) & (ase_macb3_12v3)) ||
                    ((!ase_macb0_12v3) & (!ase_macb1_12v3) & (ase_macb2_12v3) & (!ase_macb3_12v3)) ||
                    ((!ase_macb0_12v3) & (ase_macb1_12v3) & (!ase_macb2_12v3) & (!ase_macb3_12v3)) ||
                    ((ase_macb0_12v3) & (!ase_macb1_12v3) & (!ase_macb2_12v3) & (!ase_macb3_12v3)) ||
                    ((!ase_macb0_12v3) & (!ase_macb1_12v3) & (!ase_macb2_12v3) & (!ase_macb3_12v3)) ;



`ifdef LP_ABV_ON3
// psl3 default clock3 = (posedge pclk3);

// Cover3 a condition in which SMC3 is powered3 down
// and again3 powered3 up while UART3 is going3 into POWER3 down
// state or UART3 is already in POWER3 DOWN3 state
// psl3 cover_overlapping_smc_urt_13:
//    cover{fell3(pwr1_on_urt3);[*];fell3(pwr1_on_smc3);[*];
//    rose3(pwr1_on_smc3);[*];rose3(pwr1_on_urt3)};
//
// Cover3 a condition in which UART3 is powered3 down
// and again3 powered3 up while SMC3 is going3 into POWER3 down
// state or SMC3 is already in POWER3 DOWN3 state
// psl3 cover_overlapping_smc_urt_23:
//    cover{fell3(pwr1_on_smc3);[*];fell3(pwr1_on_urt3);[*];
//    rose3(pwr1_on_urt3);[*];rose3(pwr1_on_smc3)};
//


// Power3 Down3 UART3
// This3 gets3 triggered on rising3 edge of Gate3 signal3 for
// UART3 (gate_clk_urt3). In a next cycle after gate_clk_urt3,
// Isolate3 UART3(isolate_urt3) signal3 become3 HIGH3 (active).
// In 2nd cycle after gate_clk_urt3 becomes HIGH3, RESET3 for NON3
// SRPG3 FFs3(rstn_non_srpg_urt3) and POWER13 for UART3(pwr1_on_urt3) should 
// go3 LOW3. 
// This3 completes3 a POWER3 DOWN3. 

sequence s_power_down_urt3;
      (gate_clk_urt3 & !isolate_urt3 & rstn_non_srpg_urt3 & pwr1_on_urt3) 
  ##1 (gate_clk_urt3 & isolate_urt3 & rstn_non_srpg_urt3 & pwr1_on_urt3) 
  ##3 (gate_clk_urt3 & isolate_urt3 & !rstn_non_srpg_urt3 & !pwr1_on_urt3);
endsequence


property p_power_down_urt3;
   @(posedge pclk3)
    $rose(gate_clk_urt3) |=> s_power_down_urt3;
endproperty

output_power_down_urt3:
  assert property (p_power_down_urt3);


// Power3 UP3 UART3
// Sequence starts with , Rising3 edge of pwr1_on_urt3.
// Two3 clock3 cycle after this, isolate_urt3 should become3 LOW3 
// On3 the following3 clk3 gate_clk_urt3 should go3 low3.
// 5 cycles3 after  Rising3 edge of pwr1_on_urt3, rstn_non_srpg_urt3
// should become3 HIGH3
sequence s_power_up_urt3;
##30 (pwr1_on_urt3 & !isolate_urt3 & gate_clk_urt3 & !rstn_non_srpg_urt3) 
##1 (pwr1_on_urt3 & !isolate_urt3 & !gate_clk_urt3 & !rstn_non_srpg_urt3) 
##2 (pwr1_on_urt3 & !isolate_urt3 & !gate_clk_urt3 & rstn_non_srpg_urt3);
endsequence

property p_power_up_urt3;
   @(posedge pclk3)
  disable iff(!nprst3)
    (!pwr1_on_urt3 ##1 pwr1_on_urt3) |=> s_power_up_urt3;
endproperty

output_power_up_urt3:
  assert property (p_power_up_urt3);


// Power3 Down3 SMC3
// This3 gets3 triggered on rising3 edge of Gate3 signal3 for
// SMC3 (gate_clk_smc3). In a next cycle after gate_clk_smc3,
// Isolate3 SMC3(isolate_smc3) signal3 become3 HIGH3 (active).
// In 2nd cycle after gate_clk_smc3 becomes HIGH3, RESET3 for NON3
// SRPG3 FFs3(rstn_non_srpg_smc3) and POWER13 for SMC3(pwr1_on_smc3) should 
// go3 LOW3. 
// This3 completes3 a POWER3 DOWN3. 

sequence s_power_down_smc3;
      (gate_clk_smc3 & !isolate_smc3 & rstn_non_srpg_smc3 & pwr1_on_smc3) 
  ##1 (gate_clk_smc3 & isolate_smc3 & rstn_non_srpg_smc3 & pwr1_on_smc3) 
  ##3 (gate_clk_smc3 & isolate_smc3 & !rstn_non_srpg_smc3 & !pwr1_on_smc3);
endsequence


property p_power_down_smc3;
   @(posedge pclk3)
    $rose(gate_clk_smc3) |=> s_power_down_smc3;
endproperty

output_power_down_smc3:
  assert property (p_power_down_smc3);


// Power3 UP3 SMC3
// Sequence starts with , Rising3 edge of pwr1_on_smc3.
// Two3 clock3 cycle after this, isolate_smc3 should become3 LOW3 
// On3 the following3 clk3 gate_clk_smc3 should go3 low3.
// 5 cycles3 after  Rising3 edge of pwr1_on_smc3, rstn_non_srpg_smc3
// should become3 HIGH3
sequence s_power_up_smc3;
##30 (pwr1_on_smc3 & !isolate_smc3 & gate_clk_smc3 & !rstn_non_srpg_smc3) 
##1 (pwr1_on_smc3 & !isolate_smc3 & !gate_clk_smc3 & !rstn_non_srpg_smc3) 
##2 (pwr1_on_smc3 & !isolate_smc3 & !gate_clk_smc3 & rstn_non_srpg_smc3);
endsequence

property p_power_up_smc3;
   @(posedge pclk3)
  disable iff(!nprst3)
    (!pwr1_on_smc3 ##1 pwr1_on_smc3) |=> s_power_up_smc3;
endproperty

output_power_up_smc3:
  assert property (p_power_up_smc3);


// COVER3 SMC3 POWER3 DOWN3 AND3 UP3
cover_power_down_up_smc3: cover property (@(posedge pclk3)
(s_power_down_smc3 ##[5:180] s_power_up_smc3));



// COVER3 UART3 POWER3 DOWN3 AND3 UP3
cover_power_down_up_urt3: cover property (@(posedge pclk3)
(s_power_down_urt3 ##[5:180] s_power_up_urt3));

cover_power_down_urt3: cover property (@(posedge pclk3)
(s_power_down_urt3));

cover_power_up_urt3: cover property (@(posedge pclk3)
(s_power_up_urt3));




`ifdef PCM_ABV_ON3
//------------------------------------------------------------------------------
// Power3 Controller3 Formal3 Verification3 component.  Each power3 domain has a 
// separate3 instantiation3
//------------------------------------------------------------------------------

// need to assume that CPU3 will leave3 a minimum time between powering3 down and 
// back up.  In this example3, 10clks has been selected.
// psl3 config_min_uart_pd_time3 : assume always {rose3(L1_ctrl_domain3[1])} |-> { L1_ctrl_domain3[1][*10] } abort3(~nprst3);
// psl3 config_min_uart_pu_time3 : assume always {fell3(L1_ctrl_domain3[1])} |-> { !L1_ctrl_domain3[1][*10] } abort3(~nprst3);
// psl3 config_min_smc_pd_time3 : assume always {rose3(L1_ctrl_domain3[2])} |-> { L1_ctrl_domain3[2][*10] } abort3(~nprst3);
// psl3 config_min_smc_pu_time3 : assume always {fell3(L1_ctrl_domain3[2])} |-> { !L1_ctrl_domain3[2][*10] } abort3(~nprst3);

// UART3 VCOMP3 parameters3
   defparam i_uart_vcomp_domain3.ENABLE_SAVE_RESTORE_EDGE3   = 1;
   defparam i_uart_vcomp_domain3.ENABLE_EXT_PWR_CNTRL3       = 1;
   defparam i_uart_vcomp_domain3.REF_CLK_DEFINED3            = 0;
   defparam i_uart_vcomp_domain3.MIN_SHUTOFF_CYCLES3         = 4;
   defparam i_uart_vcomp_domain3.MIN_RESTORE_TO_ISO_CYCLES3  = 0;
   defparam i_uart_vcomp_domain3.MIN_SAVE_TO_SHUTOFF_CYCLES3 = 1;


   vcomp_domain3 i_uart_vcomp_domain3
   ( .ref_clk3(pclk3),
     .start_lps3(L1_ctrl_domain3[1] || !rstn_non_srpg_urt3),
     .rst_n3(nprst3),
     .ext_power_down3(L1_ctrl_domain3[1]),
     .iso_en3(isolate_urt3),
     .save_edge3(save_edge_urt3),
     .restore_edge3(restore_edge_urt3),
     .domain_shut_off3(pwr1_off_urt3),
     .domain_clk3(!gate_clk_urt3 && pclk3)
   );


// SMC3 VCOMP3 parameters3
   defparam i_smc_vcomp_domain3.ENABLE_SAVE_RESTORE_EDGE3   = 1;
   defparam i_smc_vcomp_domain3.ENABLE_EXT_PWR_CNTRL3       = 1;
   defparam i_smc_vcomp_domain3.REF_CLK_DEFINED3            = 0;
   defparam i_smc_vcomp_domain3.MIN_SHUTOFF_CYCLES3         = 4;
   defparam i_smc_vcomp_domain3.MIN_RESTORE_TO_ISO_CYCLES3  = 0;
   defparam i_smc_vcomp_domain3.MIN_SAVE_TO_SHUTOFF_CYCLES3 = 1;


   vcomp_domain3 i_smc_vcomp_domain3
   ( .ref_clk3(pclk3),
     .start_lps3(L1_ctrl_domain3[2] || !rstn_non_srpg_smc3),
     .rst_n3(nprst3),
     .ext_power_down3(L1_ctrl_domain3[2]),
     .iso_en3(isolate_smc3),
     .save_edge3(save_edge_smc3),
     .restore_edge3(restore_edge_smc3),
     .domain_shut_off3(pwr1_off_smc3),
     .domain_clk3(!gate_clk_smc3 && pclk3)
   );

`endif

`endif



endmodule
