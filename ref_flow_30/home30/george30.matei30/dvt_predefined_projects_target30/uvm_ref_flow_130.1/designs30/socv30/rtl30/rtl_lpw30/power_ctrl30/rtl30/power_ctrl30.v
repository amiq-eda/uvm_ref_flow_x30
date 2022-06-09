//File30 name   : power_ctrl30.v
//Title30       : Power30 Control30 Module30
//Created30     : 1999
//Description30 : Top30 level of power30 controller30
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

module power_ctrl30 (


    // Clocks30 & Reset30
    pclk30,
    nprst30,
    // APB30 programming30 interface
    paddr30,
    psel30,
    penable30,
    pwrite30,
    pwdata30,
    prdata30,
    // mac30 i/f,
    macb3_wakeup30,
    macb2_wakeup30,
    macb1_wakeup30,
    macb0_wakeup30,
    // Scan30 
    scan_in30,
    scan_en30,
    scan_mode30,
    scan_out30,
    // Module30 control30 outputs30
    int_source_h30,
    // SMC30
    rstn_non_srpg_smc30,
    gate_clk_smc30,
    isolate_smc30,
    save_edge_smc30,
    restore_edge_smc30,
    pwr1_on_smc30,
    pwr2_on_smc30,
    pwr1_off_smc30,
    pwr2_off_smc30,
    // URT30
    rstn_non_srpg_urt30,
    gate_clk_urt30,
    isolate_urt30,
    save_edge_urt30,
    restore_edge_urt30,
    pwr1_on_urt30,
    pwr2_on_urt30,
    pwr1_off_urt30,      
    pwr2_off_urt30,
    // ETH030
    rstn_non_srpg_macb030,
    gate_clk_macb030,
    isolate_macb030,
    save_edge_macb030,
    restore_edge_macb030,
    pwr1_on_macb030,
    pwr2_on_macb030,
    pwr1_off_macb030,      
    pwr2_off_macb030,
    // ETH130
    rstn_non_srpg_macb130,
    gate_clk_macb130,
    isolate_macb130,
    save_edge_macb130,
    restore_edge_macb130,
    pwr1_on_macb130,
    pwr2_on_macb130,
    pwr1_off_macb130,      
    pwr2_off_macb130,
    // ETH230
    rstn_non_srpg_macb230,
    gate_clk_macb230,
    isolate_macb230,
    save_edge_macb230,
    restore_edge_macb230,
    pwr1_on_macb230,
    pwr2_on_macb230,
    pwr1_off_macb230,      
    pwr2_off_macb230,
    // ETH330
    rstn_non_srpg_macb330,
    gate_clk_macb330,
    isolate_macb330,
    save_edge_macb330,
    restore_edge_macb330,
    pwr1_on_macb330,
    pwr2_on_macb330,
    pwr1_off_macb330,      
    pwr2_off_macb330,
    // DMA30
    rstn_non_srpg_dma30,
    gate_clk_dma30,
    isolate_dma30,
    save_edge_dma30,
    restore_edge_dma30,
    pwr1_on_dma30,
    pwr2_on_dma30,
    pwr1_off_dma30,      
    pwr2_off_dma30,
    // CPU30
    rstn_non_srpg_cpu30,
    gate_clk_cpu30,
    isolate_cpu30,
    save_edge_cpu30,
    restore_edge_cpu30,
    pwr1_on_cpu30,
    pwr2_on_cpu30,
    pwr1_off_cpu30,      
    pwr2_off_cpu30,
    // ALUT30
    rstn_non_srpg_alut30,
    gate_clk_alut30,
    isolate_alut30,
    save_edge_alut30,
    restore_edge_alut30,
    pwr1_on_alut30,
    pwr2_on_alut30,
    pwr1_off_alut30,      
    pwr2_off_alut30,
    // MEM30
    rstn_non_srpg_mem30,
    gate_clk_mem30,
    isolate_mem30,
    save_edge_mem30,
    restore_edge_mem30,
    pwr1_on_mem30,
    pwr2_on_mem30,
    pwr1_off_mem30,      
    pwr2_off_mem30,
    // core30 dvfs30 transitions30
    core06v30,
    core08v30,
    core10v30,
    core12v30,
    pcm_macb_wakeup_int30,
    // mte30 signals30
    mte_smc_start30,
    mte_uart_start30,
    mte_smc_uart_start30,  
    mte_pm_smc_to_default_start30, 
    mte_pm_uart_to_default_start30,
    mte_pm_smc_uart_to_default_start30

  );

  parameter STATE_IDLE_12V30 = 4'b0001;
  parameter STATE_06V30 = 4'b0010;
  parameter STATE_08V30 = 4'b0100;
  parameter STATE_10V30 = 4'b1000;

    // Clocks30 & Reset30
    input pclk30;
    input nprst30;
    // APB30 programming30 interface
    input [31:0] paddr30;
    input psel30  ;
    input penable30;
    input pwrite30 ;
    input [31:0] pwdata30;
    output [31:0] prdata30;
    // mac30
    input macb3_wakeup30;
    input macb2_wakeup30;
    input macb1_wakeup30;
    input macb0_wakeup30;
    // Scan30 
    input scan_in30;
    input scan_en30;
    input scan_mode30;
    output scan_out30;
    // Module30 control30 outputs30
    input int_source_h30;
    // SMC30
    output rstn_non_srpg_smc30 ;
    output gate_clk_smc30   ;
    output isolate_smc30   ;
    output save_edge_smc30   ;
    output restore_edge_smc30   ;
    output pwr1_on_smc30   ;
    output pwr2_on_smc30   ;
    output pwr1_off_smc30  ;
    output pwr2_off_smc30  ;
    // URT30
    output rstn_non_srpg_urt30 ;
    output gate_clk_urt30      ;
    output isolate_urt30       ;
    output save_edge_urt30   ;
    output restore_edge_urt30   ;
    output pwr1_on_urt30       ;
    output pwr2_on_urt30       ;
    output pwr1_off_urt30      ;
    output pwr2_off_urt30      ;
    // ETH030
    output rstn_non_srpg_macb030 ;
    output gate_clk_macb030      ;
    output isolate_macb030       ;
    output save_edge_macb030   ;
    output restore_edge_macb030   ;
    output pwr1_on_macb030       ;
    output pwr2_on_macb030       ;
    output pwr1_off_macb030      ;
    output pwr2_off_macb030      ;
    // ETH130
    output rstn_non_srpg_macb130 ;
    output gate_clk_macb130      ;
    output isolate_macb130       ;
    output save_edge_macb130   ;
    output restore_edge_macb130   ;
    output pwr1_on_macb130       ;
    output pwr2_on_macb130       ;
    output pwr1_off_macb130      ;
    output pwr2_off_macb130      ;
    // ETH230
    output rstn_non_srpg_macb230 ;
    output gate_clk_macb230      ;
    output isolate_macb230       ;
    output save_edge_macb230   ;
    output restore_edge_macb230   ;
    output pwr1_on_macb230       ;
    output pwr2_on_macb230       ;
    output pwr1_off_macb230      ;
    output pwr2_off_macb230      ;
    // ETH330
    output rstn_non_srpg_macb330 ;
    output gate_clk_macb330      ;
    output isolate_macb330       ;
    output save_edge_macb330   ;
    output restore_edge_macb330   ;
    output pwr1_on_macb330       ;
    output pwr2_on_macb330       ;
    output pwr1_off_macb330      ;
    output pwr2_off_macb330      ;
    // DMA30
    output rstn_non_srpg_dma30 ;
    output gate_clk_dma30      ;
    output isolate_dma30       ;
    output save_edge_dma30   ;
    output restore_edge_dma30   ;
    output pwr1_on_dma30       ;
    output pwr2_on_dma30       ;
    output pwr1_off_dma30      ;
    output pwr2_off_dma30      ;
    // CPU30
    output rstn_non_srpg_cpu30 ;
    output gate_clk_cpu30      ;
    output isolate_cpu30       ;
    output save_edge_cpu30   ;
    output restore_edge_cpu30   ;
    output pwr1_on_cpu30       ;
    output pwr2_on_cpu30       ;
    output pwr1_off_cpu30      ;
    output pwr2_off_cpu30      ;
    // ALUT30
    output rstn_non_srpg_alut30 ;
    output gate_clk_alut30      ;
    output isolate_alut30       ;
    output save_edge_alut30   ;
    output restore_edge_alut30   ;
    output pwr1_on_alut30       ;
    output pwr2_on_alut30       ;
    output pwr1_off_alut30      ;
    output pwr2_off_alut30      ;
    // MEM30
    output rstn_non_srpg_mem30 ;
    output gate_clk_mem30      ;
    output isolate_mem30       ;
    output save_edge_mem30   ;
    output restore_edge_mem30   ;
    output pwr1_on_mem30       ;
    output pwr2_on_mem30       ;
    output pwr1_off_mem30      ;
    output pwr2_off_mem30      ;


   // core30 transitions30 o/p
    output core06v30;
    output core08v30;
    output core10v30;
    output core12v30;
    output pcm_macb_wakeup_int30 ;
    //mode mte30  signals30
    output mte_smc_start30;
    output mte_uart_start30;
    output mte_smc_uart_start30;  
    output mte_pm_smc_to_default_start30; 
    output mte_pm_uart_to_default_start30;
    output mte_pm_smc_uart_to_default_start30;

    reg mte_smc_start30;
    reg mte_uart_start30;
    reg mte_smc_uart_start30;  
    reg mte_pm_smc_to_default_start30; 
    reg mte_pm_uart_to_default_start30;
    reg mte_pm_smc_uart_to_default_start30;

    reg [31:0] prdata30;

  wire valid_reg_write30  ;
  wire valid_reg_read30   ;
  wire L1_ctrl_access30   ;
  wire L1_status_access30 ;
  wire pcm_int_mask_access30;
  wire pcm_int_status_access30;
  wire standby_mem030      ;
  wire standby_mem130      ;
  wire standby_mem230      ;
  wire standby_mem330      ;
  wire pwr1_off_mem030;
  wire pwr1_off_mem130;
  wire pwr1_off_mem230;
  wire pwr1_off_mem330;
  
  // Control30 signals30
  wire set_status_smc30   ;
  wire clr_status_smc30   ;
  wire set_status_urt30   ;
  wire clr_status_urt30   ;
  wire set_status_macb030   ;
  wire clr_status_macb030   ;
  wire set_status_macb130   ;
  wire clr_status_macb130   ;
  wire set_status_macb230   ;
  wire clr_status_macb230   ;
  wire set_status_macb330   ;
  wire clr_status_macb330   ;
  wire set_status_dma30   ;
  wire clr_status_dma30   ;
  wire set_status_cpu30   ;
  wire clr_status_cpu30   ;
  wire set_status_alut30   ;
  wire clr_status_alut30   ;
  wire set_status_mem30   ;
  wire clr_status_mem30   ;


  // Status and Control30 registers
  reg [31:0]  L1_status_reg30;
  reg  [31:0] L1_ctrl_reg30  ;
  reg  [31:0] L1_ctrl_domain30  ;
  reg L1_ctrl_cpu_off_reg30;
  reg [31:0]  pcm_mask_reg30;
  reg [31:0]  pcm_status_reg30;

  // Signals30 gated30 in scan_mode30
  //SMC30
  wire  rstn_non_srpg_smc_int30;
  wire  gate_clk_smc_int30    ;     
  wire  isolate_smc_int30    ;       
  wire save_edge_smc_int30;
  wire restore_edge_smc_int30;
  wire  pwr1_on_smc_int30    ;      
  wire  pwr2_on_smc_int30    ;      


  //URT30
  wire   rstn_non_srpg_urt_int30;
  wire   gate_clk_urt_int30     ;     
  wire   isolate_urt_int30      ;       
  wire save_edge_urt_int30;
  wire restore_edge_urt_int30;
  wire   pwr1_on_urt_int30      ;      
  wire   pwr2_on_urt_int30      ;      

  // ETH030
  wire   rstn_non_srpg_macb0_int30;
  wire   gate_clk_macb0_int30     ;     
  wire   isolate_macb0_int30      ;       
  wire save_edge_macb0_int30;
  wire restore_edge_macb0_int30;
  wire   pwr1_on_macb0_int30      ;      
  wire   pwr2_on_macb0_int30      ;      
  // ETH130
  wire   rstn_non_srpg_macb1_int30;
  wire   gate_clk_macb1_int30     ;     
  wire   isolate_macb1_int30      ;       
  wire save_edge_macb1_int30;
  wire restore_edge_macb1_int30;
  wire   pwr1_on_macb1_int30      ;      
  wire   pwr2_on_macb1_int30      ;      
  // ETH230
  wire   rstn_non_srpg_macb2_int30;
  wire   gate_clk_macb2_int30     ;     
  wire   isolate_macb2_int30      ;       
  wire save_edge_macb2_int30;
  wire restore_edge_macb2_int30;
  wire   pwr1_on_macb2_int30      ;      
  wire   pwr2_on_macb2_int30      ;      
  // ETH330
  wire   rstn_non_srpg_macb3_int30;
  wire   gate_clk_macb3_int30     ;     
  wire   isolate_macb3_int30      ;       
  wire save_edge_macb3_int30;
  wire restore_edge_macb3_int30;
  wire   pwr1_on_macb3_int30      ;      
  wire   pwr2_on_macb3_int30      ;      

  // DMA30
  wire   rstn_non_srpg_dma_int30;
  wire   gate_clk_dma_int30     ;     
  wire   isolate_dma_int30      ;       
  wire save_edge_dma_int30;
  wire restore_edge_dma_int30;
  wire   pwr1_on_dma_int30      ;      
  wire   pwr2_on_dma_int30      ;      

  // CPU30
  wire   rstn_non_srpg_cpu_int30;
  wire   gate_clk_cpu_int30     ;     
  wire   isolate_cpu_int30      ;       
  wire save_edge_cpu_int30;
  wire restore_edge_cpu_int30;
  wire   pwr1_on_cpu_int30      ;      
  wire   pwr2_on_cpu_int30      ;  
  wire L1_ctrl_cpu_off_p30;    

  reg save_alut_tmp30;
  // DFS30 sm30

  reg cpu_shutoff_ctrl30;

  reg mte_mac_off_start30, mte_mac012_start30, mte_mac013_start30, mte_mac023_start30, mte_mac123_start30;
  reg mte_mac01_start30, mte_mac02_start30, mte_mac03_start30, mte_mac12_start30, mte_mac13_start30, mte_mac23_start30;
  reg mte_mac0_start30, mte_mac1_start30, mte_mac2_start30, mte_mac3_start30;
  reg mte_sys_hibernate30 ;
  reg mte_dma_start30 ;
  reg mte_cpu_start30 ;
  reg mte_mac_off_sleep_start30, mte_mac012_sleep_start30, mte_mac013_sleep_start30, mte_mac023_sleep_start30, mte_mac123_sleep_start30;
  reg mte_mac01_sleep_start30, mte_mac02_sleep_start30, mte_mac03_sleep_start30, mte_mac12_sleep_start30, mte_mac13_sleep_start30, mte_mac23_sleep_start30;
  reg mte_mac0_sleep_start30, mte_mac1_sleep_start30, mte_mac2_sleep_start30, mte_mac3_sleep_start30;
  reg mte_dma_sleep_start30;
  reg mte_mac_off_to_default30, mte_mac012_to_default30, mte_mac013_to_default30, mte_mac023_to_default30, mte_mac123_to_default30;
  reg mte_mac01_to_default30, mte_mac02_to_default30, mte_mac03_to_default30, mte_mac12_to_default30, mte_mac13_to_default30, mte_mac23_to_default30;
  reg mte_mac0_to_default30, mte_mac1_to_default30, mte_mac2_to_default30, mte_mac3_to_default30;
  reg mte_dma_isolate_dis30;
  reg mte_cpu_isolate_dis30;
  reg mte_sys_hibernate_to_default30;


  // Latch30 the CPU30 SLEEP30 invocation30
  always @( posedge pclk30 or negedge nprst30) 
  begin
    if(!nprst30)
      L1_ctrl_cpu_off_reg30 <= 1'b0;
    else 
      L1_ctrl_cpu_off_reg30 <= L1_ctrl_domain30[8];
  end

  // Create30 a pulse30 for sleep30 detection30 
  assign L1_ctrl_cpu_off_p30 =  L1_ctrl_domain30[8] && !L1_ctrl_cpu_off_reg30;
  
  // CPU30 sleep30 contol30 logic 
  // Shut30 off30 CPU30 when L1_ctrl_cpu_off_p30 is set
  // wake30 cpu30 when any interrupt30 is seen30  
  always @( posedge pclk30 or negedge nprst30) 
  begin
    if(!nprst30)
     cpu_shutoff_ctrl30 <= 1'b0;
    else if(cpu_shutoff_ctrl30 && int_source_h30)
     cpu_shutoff_ctrl30 <= 1'b0;
    else if (L1_ctrl_cpu_off_p30)
     cpu_shutoff_ctrl30 <= 1'b1;
  end
 
  // instantiate30 power30 contol30  block for uart30
  power_ctrl_sm30 i_urt_power_ctrl_sm30(
    .pclk30(pclk30),
    .nprst30(nprst30),
    .L1_module_req30(L1_ctrl_domain30[1]),
    .set_status_module30(set_status_urt30),
    .clr_status_module30(clr_status_urt30),
    .rstn_non_srpg_module30(rstn_non_srpg_urt_int30),
    .gate_clk_module30(gate_clk_urt_int30),
    .isolate_module30(isolate_urt_int30),
    .save_edge30(save_edge_urt_int30),
    .restore_edge30(restore_edge_urt_int30),
    .pwr1_on30(pwr1_on_urt_int30),
    .pwr2_on30(pwr2_on_urt_int30)
    );
  

  // instantiate30 power30 contol30  block for smc30
  power_ctrl_sm30 i_smc_power_ctrl_sm30(
    .pclk30(pclk30),
    .nprst30(nprst30),
    .L1_module_req30(L1_ctrl_domain30[2]),
    .set_status_module30(set_status_smc30),
    .clr_status_module30(clr_status_smc30),
    .rstn_non_srpg_module30(rstn_non_srpg_smc_int30),
    .gate_clk_module30(gate_clk_smc_int30),
    .isolate_module30(isolate_smc_int30),
    .save_edge30(save_edge_smc_int30),
    .restore_edge30(restore_edge_smc_int30),
    .pwr1_on30(pwr1_on_smc_int30),
    .pwr2_on30(pwr2_on_smc_int30)
    );

  // power30 control30 for macb030
  power_ctrl_sm30 i_macb0_power_ctrl_sm30(
    .pclk30(pclk30),
    .nprst30(nprst30),
    .L1_module_req30(L1_ctrl_domain30[3]),
    .set_status_module30(set_status_macb030),
    .clr_status_module30(clr_status_macb030),
    .rstn_non_srpg_module30(rstn_non_srpg_macb0_int30),
    .gate_clk_module30(gate_clk_macb0_int30),
    .isolate_module30(isolate_macb0_int30),
    .save_edge30(save_edge_macb0_int30),
    .restore_edge30(restore_edge_macb0_int30),
    .pwr1_on30(pwr1_on_macb0_int30),
    .pwr2_on30(pwr2_on_macb0_int30)
    );
  // power30 control30 for macb130
  power_ctrl_sm30 i_macb1_power_ctrl_sm30(
    .pclk30(pclk30),
    .nprst30(nprst30),
    .L1_module_req30(L1_ctrl_domain30[4]),
    .set_status_module30(set_status_macb130),
    .clr_status_module30(clr_status_macb130),
    .rstn_non_srpg_module30(rstn_non_srpg_macb1_int30),
    .gate_clk_module30(gate_clk_macb1_int30),
    .isolate_module30(isolate_macb1_int30),
    .save_edge30(save_edge_macb1_int30),
    .restore_edge30(restore_edge_macb1_int30),
    .pwr1_on30(pwr1_on_macb1_int30),
    .pwr2_on30(pwr2_on_macb1_int30)
    );
  // power30 control30 for macb230
  power_ctrl_sm30 i_macb2_power_ctrl_sm30(
    .pclk30(pclk30),
    .nprst30(nprst30),
    .L1_module_req30(L1_ctrl_domain30[5]),
    .set_status_module30(set_status_macb230),
    .clr_status_module30(clr_status_macb230),
    .rstn_non_srpg_module30(rstn_non_srpg_macb2_int30),
    .gate_clk_module30(gate_clk_macb2_int30),
    .isolate_module30(isolate_macb2_int30),
    .save_edge30(save_edge_macb2_int30),
    .restore_edge30(restore_edge_macb2_int30),
    .pwr1_on30(pwr1_on_macb2_int30),
    .pwr2_on30(pwr2_on_macb2_int30)
    );
  // power30 control30 for macb330
  power_ctrl_sm30 i_macb3_power_ctrl_sm30(
    .pclk30(pclk30),
    .nprst30(nprst30),
    .L1_module_req30(L1_ctrl_domain30[6]),
    .set_status_module30(set_status_macb330),
    .clr_status_module30(clr_status_macb330),
    .rstn_non_srpg_module30(rstn_non_srpg_macb3_int30),
    .gate_clk_module30(gate_clk_macb3_int30),
    .isolate_module30(isolate_macb3_int30),
    .save_edge30(save_edge_macb3_int30),
    .restore_edge30(restore_edge_macb3_int30),
    .pwr1_on30(pwr1_on_macb3_int30),
    .pwr2_on30(pwr2_on_macb3_int30)
    );
  // power30 control30 for dma30
  power_ctrl_sm30 i_dma_power_ctrl_sm30(
    .pclk30(pclk30),
    .nprst30(nprst30),
    .L1_module_req30(L1_ctrl_domain30[7]),
    .set_status_module30(set_status_dma30),
    .clr_status_module30(clr_status_dma30),
    .rstn_non_srpg_module30(rstn_non_srpg_dma_int30),
    .gate_clk_module30(gate_clk_dma_int30),
    .isolate_module30(isolate_dma_int30),
    .save_edge30(save_edge_dma_int30),
    .restore_edge30(restore_edge_dma_int30),
    .pwr1_on30(pwr1_on_dma_int30),
    .pwr2_on30(pwr2_on_dma_int30)
    );
  // power30 control30 for CPU30
  power_ctrl_sm30 i_cpu_power_ctrl_sm30(
    .pclk30(pclk30),
    .nprst30(nprst30),
    .L1_module_req30(cpu_shutoff_ctrl30),
    .set_status_module30(set_status_cpu30),
    .clr_status_module30(clr_status_cpu30),
    .rstn_non_srpg_module30(rstn_non_srpg_cpu_int30),
    .gate_clk_module30(gate_clk_cpu_int30),
    .isolate_module30(isolate_cpu_int30),
    .save_edge30(save_edge_cpu_int30),
    .restore_edge30(restore_edge_cpu_int30),
    .pwr1_on30(pwr1_on_cpu_int30),
    .pwr2_on30(pwr2_on_cpu_int30)
    );

  assign valid_reg_write30 =  (psel30 && pwrite30 && penable30);
  assign valid_reg_read30  =  (psel30 && (!pwrite30) && penable30);

  assign L1_ctrl_access30  =  (paddr30[15:0] == 16'b0000000000000100); 
  assign L1_status_access30 = (paddr30[15:0] == 16'b0000000000001000);

  assign pcm_int_mask_access30 =   (paddr30[15:0] == 16'b0000000000001100); // mask at 0xC
  assign pcm_int_status_access30 = (paddr30[15:0] == 16'b0000000000100000); // status at 0x20

  
  // Read accesses to the control30 and status register
  always @(*)
  begin  
    if(valid_reg_read30 && L1_ctrl_access30) 
      prdata30 = L1_ctrl_reg30;
    else if (valid_reg_read30 && L1_status_access30)
      prdata30 = L1_status_reg30;
    else if (valid_reg_read30 && pcm_int_mask_access30)
      prdata30 = pcm_mask_reg30;
    else if (valid_reg_read30 && pcm_int_status_access30)
      prdata30 = pcm_status_reg30;
    else 
      prdata30 = 0;
  end

  assign set_status_mem30 =  (set_status_macb030 && set_status_macb130 && set_status_macb230 &&
                            set_status_macb330 && set_status_dma30 && set_status_cpu30);

  assign clr_status_mem30 =  (clr_status_macb030 && clr_status_macb130 && clr_status_macb230 &&
                            clr_status_macb330 && clr_status_dma30 && clr_status_cpu30);

  assign set_status_alut30 = (set_status_macb030 && set_status_macb130 && set_status_macb230 && set_status_macb330);

  assign clr_status_alut30 = (clr_status_macb030 || clr_status_macb130 || clr_status_macb230  || clr_status_macb330);

  // Write accesses to the control30 and status register
 
  always @(posedge pclk30 or negedge nprst30)
  begin
    if (!nprst30) begin
      L1_ctrl_reg30   <= 0;
      L1_status_reg30 <= 0;
      pcm_mask_reg30 <= 0;
    end else begin
      // CTRL30 reg updates30
      if (valid_reg_write30 && L1_ctrl_access30) 
        L1_ctrl_reg30 <= pwdata30; // Writes30 to the ctrl30 reg
      if (valid_reg_write30 && pcm_int_mask_access30) 
        pcm_mask_reg30 <= pwdata30; // Writes30 to the ctrl30 reg

      if (set_status_urt30 == 1'b1)  
        L1_status_reg30[1] <= 1'b1; // Set the status bit 
      else if (clr_status_urt30 == 1'b1) 
        L1_status_reg30[1] <= 1'b0;  // Clear the status bit

      if (set_status_smc30 == 1'b1) 
        L1_status_reg30[2] <= 1'b1; // Set the status bit 
      else if (clr_status_smc30 == 1'b1) 
        L1_status_reg30[2] <= 1'b0; // Clear the status bit

      if (set_status_macb030 == 1'b1)  
        L1_status_reg30[3] <= 1'b1; // Set the status bit 
      else if (clr_status_macb030 == 1'b1) 
        L1_status_reg30[3] <= 1'b0;  // Clear the status bit

      if (set_status_macb130 == 1'b1)  
        L1_status_reg30[4] <= 1'b1; // Set the status bit 
      else if (clr_status_macb130 == 1'b1) 
        L1_status_reg30[4] <= 1'b0;  // Clear the status bit

      if (set_status_macb230 == 1'b1)  
        L1_status_reg30[5] <= 1'b1; // Set the status bit 
      else if (clr_status_macb230 == 1'b1) 
        L1_status_reg30[5] <= 1'b0;  // Clear the status bit

      if (set_status_macb330 == 1'b1)  
        L1_status_reg30[6] <= 1'b1; // Set the status bit 
      else if (clr_status_macb330 == 1'b1) 
        L1_status_reg30[6] <= 1'b0;  // Clear the status bit

      if (set_status_dma30 == 1'b1)  
        L1_status_reg30[7] <= 1'b1; // Set the status bit 
      else if (clr_status_dma30 == 1'b1) 
        L1_status_reg30[7] <= 1'b0;  // Clear the status bit

      if (set_status_cpu30 == 1'b1)  
        L1_status_reg30[8] <= 1'b1; // Set the status bit 
      else if (clr_status_cpu30 == 1'b1) 
        L1_status_reg30[8] <= 1'b0;  // Clear the status bit

      if (set_status_alut30 == 1'b1)  
        L1_status_reg30[9] <= 1'b1; // Set the status bit 
      else if (clr_status_alut30 == 1'b1) 
        L1_status_reg30[9] <= 1'b0;  // Clear the status bit

      if (set_status_mem30 == 1'b1)  
        L1_status_reg30[10] <= 1'b1; // Set the status bit 
      else if (clr_status_mem30 == 1'b1) 
        L1_status_reg30[10] <= 1'b0;  // Clear the status bit

    end
  end

  // Unused30 bits of pcm_status_reg30 are tied30 to 0
  always @(posedge pclk30 or negedge nprst30)
  begin
    if (!nprst30)
      pcm_status_reg30[31:4] <= 'b0;
    else  
      pcm_status_reg30[31:4] <= pcm_status_reg30[31:4];
  end
  
  // interrupt30 only of h/w assisted30 wakeup
  // MAC30 3
  always @(posedge pclk30 or negedge nprst30)
  begin
    if(!nprst30)
      pcm_status_reg30[3] <= 1'b0;
    else if (valid_reg_write30 && pcm_int_status_access30) 
      pcm_status_reg30[3] <= pwdata30[3];
    else if (macb3_wakeup30 & ~pcm_mask_reg30[3])
      pcm_status_reg30[3] <= 1'b1;
    else if (valid_reg_read30 && pcm_int_status_access30) 
      pcm_status_reg30[3] <= 1'b0;
    else
      pcm_status_reg30[3] <= pcm_status_reg30[3];
  end  
   
  // MAC30 2
  always @(posedge pclk30 or negedge nprst30)
  begin
    if(!nprst30)
      pcm_status_reg30[2] <= 1'b0;
    else if (valid_reg_write30 && pcm_int_status_access30) 
      pcm_status_reg30[2] <= pwdata30[2];
    else if (macb2_wakeup30 & ~pcm_mask_reg30[2])
      pcm_status_reg30[2] <= 1'b1;
    else if (valid_reg_read30 && pcm_int_status_access30) 
      pcm_status_reg30[2] <= 1'b0;
    else
      pcm_status_reg30[2] <= pcm_status_reg30[2];
  end  

  // MAC30 1
  always @(posedge pclk30 or negedge nprst30)
  begin
    if(!nprst30)
      pcm_status_reg30[1] <= 1'b0;
    else if (valid_reg_write30 && pcm_int_status_access30) 
      pcm_status_reg30[1] <= pwdata30[1];
    else if (macb1_wakeup30 & ~pcm_mask_reg30[1])
      pcm_status_reg30[1] <= 1'b1;
    else if (valid_reg_read30 && pcm_int_status_access30) 
      pcm_status_reg30[1] <= 1'b0;
    else
      pcm_status_reg30[1] <= pcm_status_reg30[1];
  end  
   
  // MAC30 0
  always @(posedge pclk30 or negedge nprst30)
  begin
    if(!nprst30)
      pcm_status_reg30[0] <= 1'b0;
    else if (valid_reg_write30 && pcm_int_status_access30) 
      pcm_status_reg30[0] <= pwdata30[0];
    else if (macb0_wakeup30 & ~pcm_mask_reg30[0])
      pcm_status_reg30[0] <= 1'b1;
    else if (valid_reg_read30 && pcm_int_status_access30) 
      pcm_status_reg30[0] <= 1'b0;
    else
      pcm_status_reg30[0] <= pcm_status_reg30[0];
  end  

  assign pcm_macb_wakeup_int30 = |pcm_status_reg30;

  reg [31:0] L1_ctrl_reg130;
  always @(posedge pclk30 or negedge nprst30)
  begin
    if(!nprst30)
      L1_ctrl_reg130 <= 0;
    else
      L1_ctrl_reg130 <= L1_ctrl_reg30;
  end

  // Program30 mode decode
  always @(L1_ctrl_reg30 or L1_ctrl_reg130 or int_source_h30 or cpu_shutoff_ctrl30) begin
    mte_smc_start30 = 0;
    mte_uart_start30 = 0;
    mte_smc_uart_start30  = 0;
    mte_mac_off_start30  = 0;
    mte_mac012_start30 = 0;
    mte_mac013_start30 = 0;
    mte_mac023_start30 = 0;
    mte_mac123_start30 = 0;
    mte_mac01_start30 = 0;
    mte_mac02_start30 = 0;
    mte_mac03_start30 = 0;
    mte_mac12_start30 = 0;
    mte_mac13_start30 = 0;
    mte_mac23_start30 = 0;
    mte_mac0_start30 = 0;
    mte_mac1_start30 = 0;
    mte_mac2_start30 = 0;
    mte_mac3_start30 = 0;
    mte_sys_hibernate30 = 0 ;
    mte_dma_start30 = 0 ;
    mte_cpu_start30 = 0 ;

    mte_mac0_sleep_start30 = (L1_ctrl_reg30 ==  'h14) && (L1_ctrl_reg130 == 'h4 );
    mte_mac1_sleep_start30 = (L1_ctrl_reg30 ==  'h14) && (L1_ctrl_reg130 == 'h5 ); 
    mte_mac2_sleep_start30 = (L1_ctrl_reg30 ==  'h14) && (L1_ctrl_reg130 == 'h6 ); 
    mte_mac3_sleep_start30 = (L1_ctrl_reg30 ==  'h14) && (L1_ctrl_reg130 == 'h7 ); 
    mte_mac01_sleep_start30 = (L1_ctrl_reg30 ==  'h14) && (L1_ctrl_reg130 == 'h8 ); 
    mte_mac02_sleep_start30 = (L1_ctrl_reg30 ==  'h14) && (L1_ctrl_reg130 == 'h9 ); 
    mte_mac03_sleep_start30 = (L1_ctrl_reg30 ==  'h14) && (L1_ctrl_reg130 == 'hA ); 
    mte_mac12_sleep_start30 = (L1_ctrl_reg30 ==  'h14) && (L1_ctrl_reg130 == 'hB ); 
    mte_mac13_sleep_start30 = (L1_ctrl_reg30 ==  'h14) && (L1_ctrl_reg130 == 'hC ); 
    mte_mac23_sleep_start30 = (L1_ctrl_reg30 ==  'h14) && (L1_ctrl_reg130 == 'hD ); 
    mte_mac012_sleep_start30 = (L1_ctrl_reg30 ==  'h14) && (L1_ctrl_reg130 == 'hE ); 
    mte_mac013_sleep_start30 = (L1_ctrl_reg30 ==  'h14) && (L1_ctrl_reg130 == 'hF ); 
    mte_mac023_sleep_start30 = (L1_ctrl_reg30 ==  'h14) && (L1_ctrl_reg130 == 'h10 ); 
    mte_mac123_sleep_start30 = (L1_ctrl_reg30 ==  'h14) && (L1_ctrl_reg130 == 'h11 ); 
    mte_mac_off_sleep_start30 =  (L1_ctrl_reg30 == 'h14) && (L1_ctrl_reg130 == 'h12 );
    mte_dma_sleep_start30 =  (L1_ctrl_reg30 == 'h14) && (L1_ctrl_reg130 == 'h13 );

    mte_pm_uart_to_default_start30 = (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'h1);
    mte_pm_smc_to_default_start30 = (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'h2);
    mte_pm_smc_uart_to_default_start30 = (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'h3); 
    mte_mac0_to_default30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'h4); 
    mte_mac1_to_default30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'h5); 
    mte_mac2_to_default30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'h6); 
    mte_mac3_to_default30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'h7); 
    mte_mac01_to_default30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'h8); 
    mte_mac02_to_default30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'h9); 
    mte_mac03_to_default30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'hA); 
    mte_mac12_to_default30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'hB); 
    mte_mac13_to_default30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'hC); 
    mte_mac23_to_default30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'hD); 
    mte_mac012_to_default30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'hE); 
    mte_mac013_to_default30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'hF); 
    mte_mac023_to_default30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'h10); 
    mte_mac123_to_default30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'h11); 
    mte_mac_off_to_default30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'h12); 
    mte_dma_isolate_dis30 =  (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'h13); 
    mte_cpu_isolate_dis30 =  (int_source_h30) && (cpu_shutoff_ctrl30) && (L1_ctrl_reg30 != 'h15);
    mte_sys_hibernate_to_default30 = (L1_ctrl_reg30 == 32'h0) && (L1_ctrl_reg130 == 'h15); 

   
    if (L1_ctrl_reg130 == 'h0) begin // This30 check is to make mte_cpu_start30
                                   // is set only when you from default state 
      case (L1_ctrl_reg30)
        'h0 : L1_ctrl_domain30 = 32'h0; // default
        'h1 : begin
                L1_ctrl_domain30 = 32'h2; // PM_uart30
                mte_uart_start30 = 1'b1;
              end
        'h2 : begin
                L1_ctrl_domain30 = 32'h4; // PM_smc30
                mte_smc_start30 = 1'b1;
              end
        'h3 : begin
                L1_ctrl_domain30 = 32'h6; // PM_smc_uart30
                mte_smc_uart_start30 = 1'b1;
              end
        'h4 : begin
                L1_ctrl_domain30 = 32'h8; //  PM_macb030
                mte_mac0_start30 = 1;
              end
        'h5 : begin  
                L1_ctrl_domain30 = 32'h10; //  PM_macb130
                mte_mac1_start30 = 1;
              end
        'h6 : begin  
                L1_ctrl_domain30 = 32'h20; //  PM_macb230
                mte_mac2_start30 = 1;
              end
        'h7 : begin  
                L1_ctrl_domain30 = 32'h40; //  PM_macb330
                mte_mac3_start30 = 1;
              end
        'h8 : begin  
                L1_ctrl_domain30 = 32'h18; //  PM_macb0130
                mte_mac01_start30 = 1;
              end
        'h9 : begin  
                L1_ctrl_domain30 = 32'h28; //  PM_macb0230
                mte_mac02_start30 = 1;
              end
        'hA : begin  
                L1_ctrl_domain30 = 32'h48; //  PM_macb0330
                mte_mac03_start30 = 1;
              end
        'hB : begin  
                L1_ctrl_domain30 = 32'h30; //  PM_macb1230
                mte_mac12_start30 = 1;
              end
        'hC : begin  
                L1_ctrl_domain30 = 32'h50; //  PM_macb1330
                mte_mac13_start30 = 1;
              end
        'hD : begin  
                L1_ctrl_domain30 = 32'h60; //  PM_macb2330
                mte_mac23_start30 = 1;
              end
        'hE : begin  
                L1_ctrl_domain30 = 32'h38; //  PM_macb01230
                mte_mac012_start30 = 1;
              end
        'hF : begin  
                L1_ctrl_domain30 = 32'h58; //  PM_macb01330
                mte_mac013_start30 = 1;
              end
        'h10 :begin  
                L1_ctrl_domain30 = 32'h68; //  PM_macb02330
                mte_mac023_start30 = 1;
              end
        'h11 :begin  
                L1_ctrl_domain30 = 32'h70; //  PM_macb12330
                mte_mac123_start30 = 1;
              end
        'h12 : begin  
                L1_ctrl_domain30 = 32'h78; //  PM_macb_off30
                mte_mac_off_start30 = 1;
              end
        'h13 : begin  
                L1_ctrl_domain30 = 32'h80; //  PM_dma30
                mte_dma_start30 = 1;
              end
        'h14 : begin  
                L1_ctrl_domain30 = 32'h100; //  PM_cpu_sleep30
                mte_cpu_start30 = 1;
              end
        'h15 : begin  
                L1_ctrl_domain30 = 32'h1FE; //  PM_hibernate30
                mte_sys_hibernate30 = 1;
              end
         default: L1_ctrl_domain30 = 32'h0;
      endcase
    end
  end


  wire to_default30 = (L1_ctrl_reg30 == 0);

  // Scan30 mode gating30 of power30 and isolation30 control30 signals30
  //SMC30
  assign rstn_non_srpg_smc30  = (scan_mode30 == 1'b0) ? rstn_non_srpg_smc_int30 : 1'b1;  
  assign gate_clk_smc30       = (scan_mode30 == 1'b0) ? gate_clk_smc_int30 : 1'b0;     
  assign isolate_smc30        = (scan_mode30 == 1'b0) ? isolate_smc_int30 : 1'b0;      
  assign pwr1_on_smc30        = (scan_mode30 == 1'b0) ? pwr1_on_smc_int30 : 1'b1;       
  assign pwr2_on_smc30        = (scan_mode30 == 1'b0) ? pwr2_on_smc_int30 : 1'b1;       
  assign pwr1_off_smc30       = (scan_mode30 == 1'b0) ? (!pwr1_on_smc_int30) : 1'b0;       
  assign pwr2_off_smc30       = (scan_mode30 == 1'b0) ? (!pwr2_on_smc_int30) : 1'b0;       
  assign save_edge_smc30       = (scan_mode30 == 1'b0) ? (save_edge_smc_int30) : 1'b0;       
  assign restore_edge_smc30       = (scan_mode30 == 1'b0) ? (restore_edge_smc_int30) : 1'b0;       

  //URT30
  assign rstn_non_srpg_urt30  = (scan_mode30 == 1'b0) ?  rstn_non_srpg_urt_int30 : 1'b1;  
  assign gate_clk_urt30       = (scan_mode30 == 1'b0) ?  gate_clk_urt_int30      : 1'b0;     
  assign isolate_urt30        = (scan_mode30 == 1'b0) ?  isolate_urt_int30       : 1'b0;      
  assign pwr1_on_urt30        = (scan_mode30 == 1'b0) ?  pwr1_on_urt_int30       : 1'b1;       
  assign pwr2_on_urt30        = (scan_mode30 == 1'b0) ?  pwr2_on_urt_int30       : 1'b1;       
  assign pwr1_off_urt30       = (scan_mode30 == 1'b0) ?  (!pwr1_on_urt_int30)  : 1'b0;       
  assign pwr2_off_urt30       = (scan_mode30 == 1'b0) ?  (!pwr2_on_urt_int30)  : 1'b0;       
  assign save_edge_urt30       = (scan_mode30 == 1'b0) ? (save_edge_urt_int30) : 1'b0;       
  assign restore_edge_urt30       = (scan_mode30 == 1'b0) ? (restore_edge_urt_int30) : 1'b0;       

  //ETH030
  assign rstn_non_srpg_macb030 = (scan_mode30 == 1'b0) ?  rstn_non_srpg_macb0_int30 : 1'b1;  
  assign gate_clk_macb030       = (scan_mode30 == 1'b0) ?  gate_clk_macb0_int30      : 1'b0;     
  assign isolate_macb030        = (scan_mode30 == 1'b0) ?  isolate_macb0_int30       : 1'b0;      
  assign pwr1_on_macb030        = (scan_mode30 == 1'b0) ?  pwr1_on_macb0_int30       : 1'b1;       
  assign pwr2_on_macb030        = (scan_mode30 == 1'b0) ?  pwr2_on_macb0_int30       : 1'b1;       
  assign pwr1_off_macb030       = (scan_mode30 == 1'b0) ?  (!pwr1_on_macb0_int30)  : 1'b0;       
  assign pwr2_off_macb030       = (scan_mode30 == 1'b0) ?  (!pwr2_on_macb0_int30)  : 1'b0;       
  assign save_edge_macb030       = (scan_mode30 == 1'b0) ? (save_edge_macb0_int30) : 1'b0;       
  assign restore_edge_macb030       = (scan_mode30 == 1'b0) ? (restore_edge_macb0_int30) : 1'b0;       

  //ETH130
  assign rstn_non_srpg_macb130 = (scan_mode30 == 1'b0) ?  rstn_non_srpg_macb1_int30 : 1'b1;  
  assign gate_clk_macb130       = (scan_mode30 == 1'b0) ?  gate_clk_macb1_int30      : 1'b0;     
  assign isolate_macb130        = (scan_mode30 == 1'b0) ?  isolate_macb1_int30       : 1'b0;      
  assign pwr1_on_macb130        = (scan_mode30 == 1'b0) ?  pwr1_on_macb1_int30       : 1'b1;       
  assign pwr2_on_macb130        = (scan_mode30 == 1'b0) ?  pwr2_on_macb1_int30       : 1'b1;       
  assign pwr1_off_macb130       = (scan_mode30 == 1'b0) ?  (!pwr1_on_macb1_int30)  : 1'b0;       
  assign pwr2_off_macb130       = (scan_mode30 == 1'b0) ?  (!pwr2_on_macb1_int30)  : 1'b0;       
  assign save_edge_macb130       = (scan_mode30 == 1'b0) ? (save_edge_macb1_int30) : 1'b0;       
  assign restore_edge_macb130       = (scan_mode30 == 1'b0) ? (restore_edge_macb1_int30) : 1'b0;       

  //ETH230
  assign rstn_non_srpg_macb230 = (scan_mode30 == 1'b0) ?  rstn_non_srpg_macb2_int30 : 1'b1;  
  assign gate_clk_macb230       = (scan_mode30 == 1'b0) ?  gate_clk_macb2_int30      : 1'b0;     
  assign isolate_macb230        = (scan_mode30 == 1'b0) ?  isolate_macb2_int30       : 1'b0;      
  assign pwr1_on_macb230        = (scan_mode30 == 1'b0) ?  pwr1_on_macb2_int30       : 1'b1;       
  assign pwr2_on_macb230        = (scan_mode30 == 1'b0) ?  pwr2_on_macb2_int30       : 1'b1;       
  assign pwr1_off_macb230       = (scan_mode30 == 1'b0) ?  (!pwr1_on_macb2_int30)  : 1'b0;       
  assign pwr2_off_macb230       = (scan_mode30 == 1'b0) ?  (!pwr2_on_macb2_int30)  : 1'b0;       
  assign save_edge_macb230       = (scan_mode30 == 1'b0) ? (save_edge_macb2_int30) : 1'b0;       
  assign restore_edge_macb230       = (scan_mode30 == 1'b0) ? (restore_edge_macb2_int30) : 1'b0;       

  //ETH330
  assign rstn_non_srpg_macb330 = (scan_mode30 == 1'b0) ?  rstn_non_srpg_macb3_int30 : 1'b1;  
  assign gate_clk_macb330       = (scan_mode30 == 1'b0) ?  gate_clk_macb3_int30      : 1'b0;     
  assign isolate_macb330        = (scan_mode30 == 1'b0) ?  isolate_macb3_int30       : 1'b0;      
  assign pwr1_on_macb330        = (scan_mode30 == 1'b0) ?  pwr1_on_macb3_int30       : 1'b1;       
  assign pwr2_on_macb330        = (scan_mode30 == 1'b0) ?  pwr2_on_macb3_int30       : 1'b1;       
  assign pwr1_off_macb330       = (scan_mode30 == 1'b0) ?  (!pwr1_on_macb3_int30)  : 1'b0;       
  assign pwr2_off_macb330       = (scan_mode30 == 1'b0) ?  (!pwr2_on_macb3_int30)  : 1'b0;       
  assign save_edge_macb330       = (scan_mode30 == 1'b0) ? (save_edge_macb3_int30) : 1'b0;       
  assign restore_edge_macb330       = (scan_mode30 == 1'b0) ? (restore_edge_macb3_int30) : 1'b0;       

  // MEM30
  assign rstn_non_srpg_mem30 =   (rstn_non_srpg_macb030 && rstn_non_srpg_macb130 && rstn_non_srpg_macb230 &&
                                rstn_non_srpg_macb330 && rstn_non_srpg_dma30 && rstn_non_srpg_cpu30 && rstn_non_srpg_urt30 &&
                                rstn_non_srpg_smc30);

  assign gate_clk_mem30 =  (gate_clk_macb030 && gate_clk_macb130 && gate_clk_macb230 &&
                            gate_clk_macb330 && gate_clk_dma30 && gate_clk_cpu30 && gate_clk_urt30 && gate_clk_smc30);

  assign isolate_mem30  = (isolate_macb030 && isolate_macb130 && isolate_macb230 &&
                         isolate_macb330 && isolate_dma30 && isolate_cpu30 && isolate_urt30 && isolate_smc30);


  assign pwr1_on_mem30        =   ~pwr1_off_mem30;

  assign pwr2_on_mem30        =   ~pwr2_off_mem30;

  assign pwr1_off_mem30       =  (pwr1_off_macb030 && pwr1_off_macb130 && pwr1_off_macb230 &&
                                 pwr1_off_macb330 && pwr1_off_dma30 && pwr1_off_cpu30 && pwr1_off_urt30 && pwr1_off_smc30);


  assign pwr2_off_mem30       =  (pwr2_off_macb030 && pwr2_off_macb130 && pwr2_off_macb230 &&
                                pwr2_off_macb330 && pwr2_off_dma30 && pwr2_off_cpu30 && pwr2_off_urt30 && pwr2_off_smc30);

  assign save_edge_mem30      =  (save_edge_macb030 && save_edge_macb130 && save_edge_macb230 &&
                                save_edge_macb330 && save_edge_dma30 && save_edge_cpu30 && save_edge_smc30 && save_edge_urt30);

  assign restore_edge_mem30   =  (restore_edge_macb030 && restore_edge_macb130 && restore_edge_macb230  &&
                                restore_edge_macb330 && restore_edge_dma30 && restore_edge_cpu30 && restore_edge_urt30 &&
                                restore_edge_smc30);

  assign standby_mem030 = pwr1_off_macb030 && (~ (pwr1_off_macb030 && pwr1_off_macb130 && pwr1_off_macb230 && pwr1_off_macb330 && pwr1_off_urt30 && pwr1_off_smc30 && pwr1_off_dma30 && pwr1_off_cpu30));
  assign standby_mem130 = pwr1_off_macb130 && (~ (pwr1_off_macb030 && pwr1_off_macb130 && pwr1_off_macb230 && pwr1_off_macb330 && pwr1_off_urt30 && pwr1_off_smc30 && pwr1_off_dma30 && pwr1_off_cpu30));
  assign standby_mem230 = pwr1_off_macb230 && (~ (pwr1_off_macb030 && pwr1_off_macb130 && pwr1_off_macb230 && pwr1_off_macb330 && pwr1_off_urt30 && pwr1_off_smc30 && pwr1_off_dma30 && pwr1_off_cpu30));
  assign standby_mem330 = pwr1_off_macb330 && (~ (pwr1_off_macb030 && pwr1_off_macb130 && pwr1_off_macb230 && pwr1_off_macb330 && pwr1_off_urt30 && pwr1_off_smc30 && pwr1_off_dma30 && pwr1_off_cpu30));

  assign pwr1_off_mem030 = pwr1_off_mem30;
  assign pwr1_off_mem130 = pwr1_off_mem30;
  assign pwr1_off_mem230 = pwr1_off_mem30;
  assign pwr1_off_mem330 = pwr1_off_mem30;

  assign rstn_non_srpg_alut30  =  (rstn_non_srpg_macb030 && rstn_non_srpg_macb130 && rstn_non_srpg_macb230 && rstn_non_srpg_macb330);


   assign gate_clk_alut30       =  (gate_clk_macb030 && gate_clk_macb130 && gate_clk_macb230 && gate_clk_macb330);


    assign isolate_alut30        =  (isolate_macb030 && isolate_macb130 && isolate_macb230 && isolate_macb330);


    assign pwr1_on_alut30        =  (pwr1_on_macb030 || pwr1_on_macb130 || pwr1_on_macb230 || pwr1_on_macb330);


    assign pwr2_on_alut30        =  (pwr2_on_macb030 || pwr2_on_macb130 || pwr2_on_macb230 || pwr2_on_macb330);


    assign pwr1_off_alut30       =  (pwr1_off_macb030 && pwr1_off_macb130 && pwr1_off_macb230 && pwr1_off_macb330);


    assign pwr2_off_alut30       =  (pwr2_off_macb030 && pwr2_off_macb130 && pwr2_off_macb230 && pwr2_off_macb330);


    assign save_edge_alut30      =  (save_edge_macb030 && save_edge_macb130 && save_edge_macb230 && save_edge_macb330);


    assign restore_edge_alut30   =  (restore_edge_macb030 || restore_edge_macb130 || restore_edge_macb230 ||
                                   restore_edge_macb330) && save_alut_tmp30;

     // alut30 power30 off30 detection30
  always @(posedge pclk30 or negedge nprst30) begin
    if (!nprst30) 
       save_alut_tmp30 <= 0;
    else if (restore_edge_alut30)
       save_alut_tmp30 <= 0;
    else if (save_edge_alut30)
       save_alut_tmp30 <= 1;
  end

  //DMA30
  assign rstn_non_srpg_dma30 = (scan_mode30 == 1'b0) ?  rstn_non_srpg_dma_int30 : 1'b1;  
  assign gate_clk_dma30       = (scan_mode30 == 1'b0) ?  gate_clk_dma_int30      : 1'b0;     
  assign isolate_dma30        = (scan_mode30 == 1'b0) ?  isolate_dma_int30       : 1'b0;      
  assign pwr1_on_dma30        = (scan_mode30 == 1'b0) ?  pwr1_on_dma_int30       : 1'b1;       
  assign pwr2_on_dma30        = (scan_mode30 == 1'b0) ?  pwr2_on_dma_int30       : 1'b1;       
  assign pwr1_off_dma30       = (scan_mode30 == 1'b0) ?  (!pwr1_on_dma_int30)  : 1'b0;       
  assign pwr2_off_dma30       = (scan_mode30 == 1'b0) ?  (!pwr2_on_dma_int30)  : 1'b0;       
  assign save_edge_dma30       = (scan_mode30 == 1'b0) ? (save_edge_dma_int30) : 1'b0;       
  assign restore_edge_dma30       = (scan_mode30 == 1'b0) ? (restore_edge_dma_int30) : 1'b0;       

  //CPU30
  assign rstn_non_srpg_cpu30 = (scan_mode30 == 1'b0) ?  rstn_non_srpg_cpu_int30 : 1'b1;  
  assign gate_clk_cpu30       = (scan_mode30 == 1'b0) ?  gate_clk_cpu_int30      : 1'b0;     
  assign isolate_cpu30        = (scan_mode30 == 1'b0) ?  isolate_cpu_int30       : 1'b0;      
  assign pwr1_on_cpu30        = (scan_mode30 == 1'b0) ?  pwr1_on_cpu_int30       : 1'b1;       
  assign pwr2_on_cpu30        = (scan_mode30 == 1'b0) ?  pwr2_on_cpu_int30       : 1'b1;       
  assign pwr1_off_cpu30       = (scan_mode30 == 1'b0) ?  (!pwr1_on_cpu_int30)  : 1'b0;       
  assign pwr2_off_cpu30       = (scan_mode30 == 1'b0) ?  (!pwr2_on_cpu_int30)  : 1'b0;       
  assign save_edge_cpu30       = (scan_mode30 == 1'b0) ? (save_edge_cpu_int30) : 1'b0;       
  assign restore_edge_cpu30       = (scan_mode30 == 1'b0) ? (restore_edge_cpu_int30) : 1'b0;       



  // ASE30

   reg ase_core_12v30, ase_core_10v30, ase_core_08v30, ase_core_06v30;
   reg ase_macb0_12v30,ase_macb1_12v30,ase_macb2_12v30,ase_macb3_12v30;

    // core30 ase30

    // core30 at 1.0 v if (smc30 off30, urt30 off30, macb030 off30, macb130 off30, macb230 off30, macb330 off30
   // core30 at 0.8v if (mac01off30, macb02off30, macb03off30, macb12off30, mac13off30, mac23off30,
   // core30 at 0.6v if (mac012off30, mac013off30, mac023off30, mac123off30, mac0123off30
    // else core30 at 1.2v
                 
   always @(*) begin
     if( (pwr1_off_macb030 && pwr1_off_macb130 && pwr1_off_macb230 && pwr1_off_macb330) || // all mac30 off30
       (pwr1_off_macb330 && pwr1_off_macb230 && pwr1_off_macb130) || // mac123off30 
       (pwr1_off_macb330 && pwr1_off_macb230 && pwr1_off_macb030) || // mac023off30 
       (pwr1_off_macb330 && pwr1_off_macb130 && pwr1_off_macb030) || // mac013off30 
       (pwr1_off_macb230 && pwr1_off_macb130 && pwr1_off_macb030) )  // mac012off30 
       begin
         ase_core_12v30 = 0;
         ase_core_10v30 = 0;
         ase_core_08v30 = 0;
         ase_core_06v30 = 1;
       end
     else if( (pwr1_off_macb230 && pwr1_off_macb330) || // mac2330 off30
         (pwr1_off_macb330 && pwr1_off_macb130) || // mac13off30 
         (pwr1_off_macb130 && pwr1_off_macb230) || // mac12off30 
         (pwr1_off_macb330 && pwr1_off_macb030) || // mac03off30 
         (pwr1_off_macb230 && pwr1_off_macb030) || // mac02off30 
         (pwr1_off_macb130 && pwr1_off_macb030))  // mac01off30 
       begin
         ase_core_12v30 = 0;
         ase_core_10v30 = 0;
         ase_core_08v30 = 1;
         ase_core_06v30 = 0;
       end
     else if( (pwr1_off_smc30) || // smc30 off30
         (pwr1_off_macb030 ) || // mac0off30 
         (pwr1_off_macb130 ) || // mac1off30 
         (pwr1_off_macb230 ) || // mac2off30 
         (pwr1_off_macb330 ))  // mac3off30 
       begin
         ase_core_12v30 = 0;
         ase_core_10v30 = 1;
         ase_core_08v30 = 0;
         ase_core_06v30 = 0;
       end
     else if (pwr1_off_urt30)
       begin
         ase_core_12v30 = 1;
         ase_core_10v30 = 0;
         ase_core_08v30 = 0;
         ase_core_06v30 = 0;
       end
     else
       begin
         ase_core_12v30 = 1;
         ase_core_10v30 = 0;
         ase_core_08v30 = 0;
         ase_core_06v30 = 0;
       end
   end


   // cpu30
   // cpu30 @ 1.0v when macoff30, 
   // 
   reg ase_cpu_10v30, ase_cpu_12v30;
   always @(*) begin
    if(pwr1_off_cpu30) begin
     ase_cpu_12v30 = 1'b0;
     ase_cpu_10v30 = 1'b0;
    end
    else if(pwr1_off_macb030 || pwr1_off_macb130 || pwr1_off_macb230 || pwr1_off_macb330)
    begin
     ase_cpu_12v30 = 1'b0;
     ase_cpu_10v30 = 1'b1;
    end
    else
    begin
     ase_cpu_12v30 = 1'b1;
     ase_cpu_10v30 = 1'b0;
    end
   end

   // dma30
   // dma30 @v130.0 for macoff30, 

   reg ase_dma_10v30, ase_dma_12v30;
   always @(*) begin
    if(pwr1_off_dma30) begin
     ase_dma_12v30 = 1'b0;
     ase_dma_10v30 = 1'b0;
    end
    else if(pwr1_off_macb030 || pwr1_off_macb130 || pwr1_off_macb230 || pwr1_off_macb330)
    begin
     ase_dma_12v30 = 1'b0;
     ase_dma_10v30 = 1'b1;
    end
    else
    begin
     ase_dma_12v30 = 1'b1;
     ase_dma_10v30 = 1'b0;
    end
   end

   // alut30
   // @ v130.0 for macoff30

   reg ase_alut_10v30, ase_alut_12v30;
   always @(*) begin
    if(pwr1_off_alut30) begin
     ase_alut_12v30 = 1'b0;
     ase_alut_10v30 = 1'b0;
    end
    else if(pwr1_off_macb030 || pwr1_off_macb130 || pwr1_off_macb230 || pwr1_off_macb330)
    begin
     ase_alut_12v30 = 1'b0;
     ase_alut_10v30 = 1'b1;
    end
    else
    begin
     ase_alut_12v30 = 1'b1;
     ase_alut_10v30 = 1'b0;
    end
   end




   reg ase_uart_12v30;
   reg ase_uart_10v30;
   reg ase_uart_08v30;
   reg ase_uart_06v30;

   reg ase_smc_12v30;


   always @(*) begin
     if(pwr1_off_urt30) begin // uart30 off30
       ase_uart_08v30 = 1'b0;
       ase_uart_06v30 = 1'b0;
       ase_uart_10v30 = 1'b0;
       ase_uart_12v30 = 1'b0;
     end 
     else if( (pwr1_off_macb030 && pwr1_off_macb130 && pwr1_off_macb230 && pwr1_off_macb330) || // all mac30 off30
       (pwr1_off_macb330 && pwr1_off_macb230 && pwr1_off_macb130) || // mac123off30 
       (pwr1_off_macb330 && pwr1_off_macb230 && pwr1_off_macb030) || // mac023off30 
       (pwr1_off_macb330 && pwr1_off_macb130 && pwr1_off_macb030) || // mac013off30 
       (pwr1_off_macb230 && pwr1_off_macb130 && pwr1_off_macb030) )  // mac012off30 
     begin
       ase_uart_06v30 = 1'b1;
       ase_uart_08v30 = 1'b0;
       ase_uart_10v30 = 1'b0;
       ase_uart_12v30 = 1'b0;
     end
     else if( (pwr1_off_macb230 && pwr1_off_macb330) || // mac2330 off30
         (pwr1_off_macb330 && pwr1_off_macb130) || // mac13off30 
         (pwr1_off_macb130 && pwr1_off_macb230) || // mac12off30 
         (pwr1_off_macb330 && pwr1_off_macb030) || // mac03off30 
         (pwr1_off_macb130 && pwr1_off_macb030))  // mac01off30  
     begin
       ase_uart_06v30 = 1'b0;
       ase_uart_08v30 = 1'b1;
       ase_uart_10v30 = 1'b0;
       ase_uart_12v30 = 1'b0;
     end
     else if (pwr1_off_smc30 || pwr1_off_macb030 || pwr1_off_macb130 || pwr1_off_macb230 || pwr1_off_macb330) begin // smc30 off30
       ase_uart_08v30 = 1'b0;
       ase_uart_06v30 = 1'b0;
       ase_uart_10v30 = 1'b1;
       ase_uart_12v30 = 1'b0;
     end 
     else begin
       ase_uart_08v30 = 1'b0;
       ase_uart_06v30 = 1'b0;
       ase_uart_10v30 = 1'b0;
       ase_uart_12v30 = 1'b1;
     end
   end
 


   always @(pwr1_off_smc30) begin
     if (pwr1_off_smc30)  // smc30 off30
       ase_smc_12v30 = 1'b0;
    else
       ase_smc_12v30 = 1'b1;
   end

   
   always @(pwr1_off_macb030) begin
     if (pwr1_off_macb030) // macb030 off30
       ase_macb0_12v30 = 1'b0;
     else
       ase_macb0_12v30 = 1'b1;
   end

   always @(pwr1_off_macb130) begin
     if (pwr1_off_macb130) // macb130 off30
       ase_macb1_12v30 = 1'b0;
     else
       ase_macb1_12v30 = 1'b1;
   end

   always @(pwr1_off_macb230) begin // macb230 off30
     if (pwr1_off_macb230) // macb230 off30
       ase_macb2_12v30 = 1'b0;
     else
       ase_macb2_12v30 = 1'b1;
   end

   always @(pwr1_off_macb330) begin // macb330 off30
     if (pwr1_off_macb330) // macb330 off30
       ase_macb3_12v30 = 1'b0;
     else
       ase_macb3_12v30 = 1'b1;
   end


   // core30 voltage30 for vco30
  assign core12v30 = ase_macb0_12v30 & ase_macb1_12v30 & ase_macb2_12v30 & ase_macb3_12v30;

  assign core10v30 =  (ase_macb0_12v30 & ase_macb1_12v30 & ase_macb2_12v30 & (!ase_macb3_12v30)) ||
                    (ase_macb0_12v30 & ase_macb1_12v30 & (!ase_macb2_12v30) & ase_macb3_12v30) ||
                    (ase_macb0_12v30 & (!ase_macb1_12v30) & ase_macb2_12v30 & ase_macb3_12v30) ||
                    ((!ase_macb0_12v30) & ase_macb1_12v30 & ase_macb2_12v30 & ase_macb3_12v30);

  assign core08v30 =  ((!ase_macb0_12v30) & (!ase_macb1_12v30) & (ase_macb2_12v30) & (ase_macb3_12v30)) ||
                    ((!ase_macb0_12v30) & (ase_macb1_12v30) & (!ase_macb2_12v30) & (ase_macb3_12v30)) ||
                    ((!ase_macb0_12v30) & (ase_macb1_12v30) & (ase_macb2_12v30) & (!ase_macb3_12v30)) ||
                    ((ase_macb0_12v30) & (!ase_macb1_12v30) & (!ase_macb2_12v30) & (ase_macb3_12v30)) ||
                    ((ase_macb0_12v30) & (!ase_macb1_12v30) & (ase_macb2_12v30) & (!ase_macb3_12v30)) ||
                    ((ase_macb0_12v30) & (ase_macb1_12v30) & (!ase_macb2_12v30) & (!ase_macb3_12v30));

  assign core06v30 =  ((!ase_macb0_12v30) & (!ase_macb1_12v30) & (!ase_macb2_12v30) & (ase_macb3_12v30)) ||
                    ((!ase_macb0_12v30) & (!ase_macb1_12v30) & (ase_macb2_12v30) & (!ase_macb3_12v30)) ||
                    ((!ase_macb0_12v30) & (ase_macb1_12v30) & (!ase_macb2_12v30) & (!ase_macb3_12v30)) ||
                    ((ase_macb0_12v30) & (!ase_macb1_12v30) & (!ase_macb2_12v30) & (!ase_macb3_12v30)) ||
                    ((!ase_macb0_12v30) & (!ase_macb1_12v30) & (!ase_macb2_12v30) & (!ase_macb3_12v30)) ;



`ifdef LP_ABV_ON30
// psl30 default clock30 = (posedge pclk30);

// Cover30 a condition in which SMC30 is powered30 down
// and again30 powered30 up while UART30 is going30 into POWER30 down
// state or UART30 is already in POWER30 DOWN30 state
// psl30 cover_overlapping_smc_urt_130:
//    cover{fell30(pwr1_on_urt30);[*];fell30(pwr1_on_smc30);[*];
//    rose30(pwr1_on_smc30);[*];rose30(pwr1_on_urt30)};
//
// Cover30 a condition in which UART30 is powered30 down
// and again30 powered30 up while SMC30 is going30 into POWER30 down
// state or SMC30 is already in POWER30 DOWN30 state
// psl30 cover_overlapping_smc_urt_230:
//    cover{fell30(pwr1_on_smc30);[*];fell30(pwr1_on_urt30);[*];
//    rose30(pwr1_on_urt30);[*];rose30(pwr1_on_smc30)};
//


// Power30 Down30 UART30
// This30 gets30 triggered on rising30 edge of Gate30 signal30 for
// UART30 (gate_clk_urt30). In a next cycle after gate_clk_urt30,
// Isolate30 UART30(isolate_urt30) signal30 become30 HIGH30 (active).
// In 2nd cycle after gate_clk_urt30 becomes HIGH30, RESET30 for NON30
// SRPG30 FFs30(rstn_non_srpg_urt30) and POWER130 for UART30(pwr1_on_urt30) should 
// go30 LOW30. 
// This30 completes30 a POWER30 DOWN30. 

sequence s_power_down_urt30;
      (gate_clk_urt30 & !isolate_urt30 & rstn_non_srpg_urt30 & pwr1_on_urt30) 
  ##1 (gate_clk_urt30 & isolate_urt30 & rstn_non_srpg_urt30 & pwr1_on_urt30) 
  ##3 (gate_clk_urt30 & isolate_urt30 & !rstn_non_srpg_urt30 & !pwr1_on_urt30);
endsequence


property p_power_down_urt30;
   @(posedge pclk30)
    $rose(gate_clk_urt30) |=> s_power_down_urt30;
endproperty

output_power_down_urt30:
  assert property (p_power_down_urt30);


// Power30 UP30 UART30
// Sequence starts with , Rising30 edge of pwr1_on_urt30.
// Two30 clock30 cycle after this, isolate_urt30 should become30 LOW30 
// On30 the following30 clk30 gate_clk_urt30 should go30 low30.
// 5 cycles30 after  Rising30 edge of pwr1_on_urt30, rstn_non_srpg_urt30
// should become30 HIGH30
sequence s_power_up_urt30;
##30 (pwr1_on_urt30 & !isolate_urt30 & gate_clk_urt30 & !rstn_non_srpg_urt30) 
##1 (pwr1_on_urt30 & !isolate_urt30 & !gate_clk_urt30 & !rstn_non_srpg_urt30) 
##2 (pwr1_on_urt30 & !isolate_urt30 & !gate_clk_urt30 & rstn_non_srpg_urt30);
endsequence

property p_power_up_urt30;
   @(posedge pclk30)
  disable iff(!nprst30)
    (!pwr1_on_urt30 ##1 pwr1_on_urt30) |=> s_power_up_urt30;
endproperty

output_power_up_urt30:
  assert property (p_power_up_urt30);


// Power30 Down30 SMC30
// This30 gets30 triggered on rising30 edge of Gate30 signal30 for
// SMC30 (gate_clk_smc30). In a next cycle after gate_clk_smc30,
// Isolate30 SMC30(isolate_smc30) signal30 become30 HIGH30 (active).
// In 2nd cycle after gate_clk_smc30 becomes HIGH30, RESET30 for NON30
// SRPG30 FFs30(rstn_non_srpg_smc30) and POWER130 for SMC30(pwr1_on_smc30) should 
// go30 LOW30. 
// This30 completes30 a POWER30 DOWN30. 

sequence s_power_down_smc30;
      (gate_clk_smc30 & !isolate_smc30 & rstn_non_srpg_smc30 & pwr1_on_smc30) 
  ##1 (gate_clk_smc30 & isolate_smc30 & rstn_non_srpg_smc30 & pwr1_on_smc30) 
  ##3 (gate_clk_smc30 & isolate_smc30 & !rstn_non_srpg_smc30 & !pwr1_on_smc30);
endsequence


property p_power_down_smc30;
   @(posedge pclk30)
    $rose(gate_clk_smc30) |=> s_power_down_smc30;
endproperty

output_power_down_smc30:
  assert property (p_power_down_smc30);


// Power30 UP30 SMC30
// Sequence starts with , Rising30 edge of pwr1_on_smc30.
// Two30 clock30 cycle after this, isolate_smc30 should become30 LOW30 
// On30 the following30 clk30 gate_clk_smc30 should go30 low30.
// 5 cycles30 after  Rising30 edge of pwr1_on_smc30, rstn_non_srpg_smc30
// should become30 HIGH30
sequence s_power_up_smc30;
##30 (pwr1_on_smc30 & !isolate_smc30 & gate_clk_smc30 & !rstn_non_srpg_smc30) 
##1 (pwr1_on_smc30 & !isolate_smc30 & !gate_clk_smc30 & !rstn_non_srpg_smc30) 
##2 (pwr1_on_smc30 & !isolate_smc30 & !gate_clk_smc30 & rstn_non_srpg_smc30);
endsequence

property p_power_up_smc30;
   @(posedge pclk30)
  disable iff(!nprst30)
    (!pwr1_on_smc30 ##1 pwr1_on_smc30) |=> s_power_up_smc30;
endproperty

output_power_up_smc30:
  assert property (p_power_up_smc30);


// COVER30 SMC30 POWER30 DOWN30 AND30 UP30
cover_power_down_up_smc30: cover property (@(posedge pclk30)
(s_power_down_smc30 ##[5:180] s_power_up_smc30));



// COVER30 UART30 POWER30 DOWN30 AND30 UP30
cover_power_down_up_urt30: cover property (@(posedge pclk30)
(s_power_down_urt30 ##[5:180] s_power_up_urt30));

cover_power_down_urt30: cover property (@(posedge pclk30)
(s_power_down_urt30));

cover_power_up_urt30: cover property (@(posedge pclk30)
(s_power_up_urt30));




`ifdef PCM_ABV_ON30
//------------------------------------------------------------------------------
// Power30 Controller30 Formal30 Verification30 component.  Each power30 domain has a 
// separate30 instantiation30
//------------------------------------------------------------------------------

// need to assume that CPU30 will leave30 a minimum time between powering30 down and 
// back up.  In this example30, 10clks has been selected.
// psl30 config_min_uart_pd_time30 : assume always {rose30(L1_ctrl_domain30[1])} |-> { L1_ctrl_domain30[1][*10] } abort30(~nprst30);
// psl30 config_min_uart_pu_time30 : assume always {fell30(L1_ctrl_domain30[1])} |-> { !L1_ctrl_domain30[1][*10] } abort30(~nprst30);
// psl30 config_min_smc_pd_time30 : assume always {rose30(L1_ctrl_domain30[2])} |-> { L1_ctrl_domain30[2][*10] } abort30(~nprst30);
// psl30 config_min_smc_pu_time30 : assume always {fell30(L1_ctrl_domain30[2])} |-> { !L1_ctrl_domain30[2][*10] } abort30(~nprst30);

// UART30 VCOMP30 parameters30
   defparam i_uart_vcomp_domain30.ENABLE_SAVE_RESTORE_EDGE30   = 1;
   defparam i_uart_vcomp_domain30.ENABLE_EXT_PWR_CNTRL30       = 1;
   defparam i_uart_vcomp_domain30.REF_CLK_DEFINED30            = 0;
   defparam i_uart_vcomp_domain30.MIN_SHUTOFF_CYCLES30         = 4;
   defparam i_uart_vcomp_domain30.MIN_RESTORE_TO_ISO_CYCLES30  = 0;
   defparam i_uart_vcomp_domain30.MIN_SAVE_TO_SHUTOFF_CYCLES30 = 1;


   vcomp_domain30 i_uart_vcomp_domain30
   ( .ref_clk30(pclk30),
     .start_lps30(L1_ctrl_domain30[1] || !rstn_non_srpg_urt30),
     .rst_n30(nprst30),
     .ext_power_down30(L1_ctrl_domain30[1]),
     .iso_en30(isolate_urt30),
     .save_edge30(save_edge_urt30),
     .restore_edge30(restore_edge_urt30),
     .domain_shut_off30(pwr1_off_urt30),
     .domain_clk30(!gate_clk_urt30 && pclk30)
   );


// SMC30 VCOMP30 parameters30
   defparam i_smc_vcomp_domain30.ENABLE_SAVE_RESTORE_EDGE30   = 1;
   defparam i_smc_vcomp_domain30.ENABLE_EXT_PWR_CNTRL30       = 1;
   defparam i_smc_vcomp_domain30.REF_CLK_DEFINED30            = 0;
   defparam i_smc_vcomp_domain30.MIN_SHUTOFF_CYCLES30         = 4;
   defparam i_smc_vcomp_domain30.MIN_RESTORE_TO_ISO_CYCLES30  = 0;
   defparam i_smc_vcomp_domain30.MIN_SAVE_TO_SHUTOFF_CYCLES30 = 1;


   vcomp_domain30 i_smc_vcomp_domain30
   ( .ref_clk30(pclk30),
     .start_lps30(L1_ctrl_domain30[2] || !rstn_non_srpg_smc30),
     .rst_n30(nprst30),
     .ext_power_down30(L1_ctrl_domain30[2]),
     .iso_en30(isolate_smc30),
     .save_edge30(save_edge_smc30),
     .restore_edge30(restore_edge_smc30),
     .domain_shut_off30(pwr1_off_smc30),
     .domain_clk30(!gate_clk_smc30 && pclk30)
   );

`endif

`endif



endmodule
