/*-------------------------------------------------------------------------
File26 name   : apb_subsystem_top_tb26.sv
Title26       : Simulation26 and Verification26 Environment26
Project26     :
Created26     :
Description26 : This26 file implements26 the SVE26 for the AHB26-UART26 Environment26
Notes26       : The apb_subsystem_tb26 creates26 the UART26 env26, the 
            : APB26 env26 and the scoreboard26. It also randomizes26 the UART26 
            : CSR26 settings26 and passes26 it to both the env26's.
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation26 Verification26 Environment26 (SVE26)
//--------------------------------------------------------------
class apb_subsystem_tb26 extends uvm_env;

  apb_subsystem_virtual_sequencer26 virtual_sequencer26;  // multi-channel26 sequencer
  ahb_pkg26::ahb_env26 ahb026;                          // AHB26 UVC26
  apb_pkg26::apb_env26 apb026;                          // APB26 UVC26
  uart_pkg26::uart_env26 uart026;                   // UART26 UVC26 connected26 to UART026
  uart_pkg26::uart_env26 uart126;                   // UART26 UVC26 connected26 to UART126
  spi_pkg26::spi_env26 spi026;                      // SPI26 UVC26 connected26 to SPI026
  gpio_pkg26::gpio_env26 gpio026;                   // GPIO26 UVC26 connected26 to GPIO026
  apb_subsystem_env26 apb_ss_env26;

  // UVM_REG
  apb_ss_reg_model_c26 reg_model_apb26;    // Register Model26
  reg_to_ahb_adapter26 reg2ahb26;         // Adapter Object - REG to APB26
  uvm_reg_predictor#(ahb_transfer26) ahb_predictor26; //Predictor26 - APB26 to REG

  apb_subsystem_pkg26::apb_subsystem_config26 apb_ss_cfg26;

  // enable automation26 for  apb_subsystem_tb26
  `uvm_component_utils_begin(apb_subsystem_tb26)
     `uvm_field_object(reg_model_apb26, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb26, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg26, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb26", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env26();
     // Configure26 UVCs26
    if (!uvm_config_db#(apb_subsystem_config26)::get(this, "", "apb_ss_cfg26", apb_ss_cfg26)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config26, creating26...", UVM_LOW)
      apb_ss_cfg26 = apb_subsystem_config26::type_id::create("apb_ss_cfg26", this);
      apb_ss_cfg26.uart_cfg026.apb_cfg26.add_master26("master26", UVM_PASSIVE);
      apb_ss_cfg26.uart_cfg026.apb_cfg26.add_slave26("spi026",  `AM_SPI0_BASE_ADDRESS26,  `AM_SPI0_END_ADDRESS26,  0, UVM_PASSIVE);
      apb_ss_cfg26.uart_cfg026.apb_cfg26.add_slave26("uart026", `AM_UART0_BASE_ADDRESS26, `AM_UART0_END_ADDRESS26, 0, UVM_PASSIVE);
      apb_ss_cfg26.uart_cfg026.apb_cfg26.add_slave26("gpio026", `AM_GPIO0_BASE_ADDRESS26, `AM_GPIO0_END_ADDRESS26, 0, UVM_PASSIVE);
      apb_ss_cfg26.uart_cfg026.apb_cfg26.add_slave26("uart126", `AM_UART1_BASE_ADDRESS26, `AM_UART1_END_ADDRESS26, 1, UVM_PASSIVE);
      apb_ss_cfg26.uart_cfg126.apb_cfg26.add_master26("master26", UVM_PASSIVE);
      apb_ss_cfg26.uart_cfg126.apb_cfg26.add_slave26("spi026",  `AM_SPI0_BASE_ADDRESS26,  `AM_SPI0_END_ADDRESS26,  0, UVM_PASSIVE);
      apb_ss_cfg26.uart_cfg126.apb_cfg26.add_slave26("uart026", `AM_UART0_BASE_ADDRESS26, `AM_UART0_END_ADDRESS26, 0, UVM_PASSIVE);
      apb_ss_cfg26.uart_cfg126.apb_cfg26.add_slave26("gpio026", `AM_GPIO0_BASE_ADDRESS26, `AM_GPIO0_END_ADDRESS26, 0, UVM_PASSIVE);
      apb_ss_cfg26.uart_cfg126.apb_cfg26.add_slave26("uart126", `AM_UART1_BASE_ADDRESS26, `AM_UART1_END_ADDRESS26, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing26 apb26 subsystem26 config:\n", apb_ss_cfg26.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config26)::set(this, "apb026", "cfg", apb_ss_cfg26.uart_cfg026.apb_cfg26);
     uvm_config_db#(uart_config26)::set(this, "uart026", "cfg", apb_ss_cfg26.uart_cfg026.uart_cfg26);
     uvm_config_db#(uart_config26)::set(this, "uart126", "cfg", apb_ss_cfg26.uart_cfg126.uart_cfg26);
     uvm_config_db#(uart_ctrl_config26)::set(this, "apb_ss_env26.apb_uart026", "cfg", apb_ss_cfg26.uart_cfg026);
     uvm_config_db#(uart_ctrl_config26)::set(this, "apb_ss_env26.apb_uart126", "cfg", apb_ss_cfg26.uart_cfg126);
     uvm_config_db#(apb_slave_config26)::set(this, "apb_ss_env26.apb_uart026", "apb_slave_cfg26", apb_ss_cfg26.uart_cfg026.apb_cfg26.slave_configs26[1]);
     uvm_config_db#(apb_slave_config26)::set(this, "apb_ss_env26.apb_uart126", "apb_slave_cfg26", apb_ss_cfg26.uart_cfg126.apb_cfg26.slave_configs26[3]);
     set_config_object("spi026", "spi_ve_config26", apb_ss_cfg26.spi_cfg26, 0);
     set_config_object("gpio026", "gpio_ve_config26", apb_ss_cfg26.gpio_cfg26, 0);

     set_config_int("*spi026.agents26[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio026.agents26[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb026.master_agent26","is_active", UVM_ACTIVE);  
     set_config_int("*ahb026.slave_agent26","is_active", UVM_PASSIVE);
     set_config_int("*uart026.Tx26","is_active", UVM_ACTIVE);  
     set_config_int("*uart026.Rx26","is_active", UVM_PASSIVE);
     set_config_int("*uart126.Tx26","is_active", UVM_ACTIVE);  
     set_config_int("*uart126.Rx26","is_active", UVM_PASSIVE);

     // Allocate26 objects26
     virtual_sequencer26 = apb_subsystem_virtual_sequencer26::type_id::create("virtual_sequencer26",this);
     ahb026              = ahb_pkg26::ahb_env26::type_id::create("ahb026",this);
     apb026              = apb_pkg26::apb_env26::type_id::create("apb026",this);
     uart026             = uart_pkg26::uart_env26::type_id::create("uart026",this);
     uart126             = uart_pkg26::uart_env26::type_id::create("uart126",this);
     spi026              = spi_pkg26::spi_env26::type_id::create("spi026",this);
     gpio026             = gpio_pkg26::gpio_env26::type_id::create("gpio026",this);
     apb_ss_env26        = apb_subsystem_env26::type_id::create("apb_ss_env26",this);

  //UVM_REG
  ahb_predictor26 = uvm_reg_predictor#(ahb_transfer26)::type_id::create("ahb_predictor26", this);
  if (reg_model_apb26 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb26 = apb_ss_reg_model_c26::type_id::create("reg_model_apb26");
    reg_model_apb26.build();  //NOTE26: not same as build_phase: reg_model26 is an object
    reg_model_apb26.lock_model();
  end
    // set the register model for the rest26 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb26", reg_model_apb26);
    uvm_config_object::set(this, "*uart026*", "reg_model26", reg_model_apb26.uart0_rm26);
    uvm_config_object::set(this, "*uart126*", "reg_model26", reg_model_apb26.uart1_rm26);


  endfunction : build_env26

  function void connect_phase(uvm_phase phase);
    ahb_monitor26 user_ahb_monitor26;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb26 = reg_to_ahb_adapter26::type_id::create("reg2ahb26");
    reg_model_apb26.default_map.set_sequencer(ahb026.master_agent26.sequencer, reg2ahb26);  //
    reg_model_apb26.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor26, ahb026.master_agent26.monitor26))
        `uvm_fatal("CASTFL26", "Failed26 to cast master26 monitor26 to user_ahb_monitor26");

      // ***********************************************************
      //  Hookup26 virtual sequencer to interface sequencers26
      // ***********************************************************
        virtual_sequencer26.ahb_seqr26 =  ahb026.master_agent26.sequencer;
      if (uart026.Tx26.is_active == UVM_ACTIVE)  
        virtual_sequencer26.uart0_seqr26 =  uart026.Tx26.sequencer;
      if (uart126.Tx26.is_active == UVM_ACTIVE)  
        virtual_sequencer26.uart1_seqr26 =  uart126.Tx26.sequencer;
      if (spi026.agents26[0].is_active == UVM_ACTIVE)  
        virtual_sequencer26.spi0_seqr26 =  spi026.agents26[0].sequencer;
      if (gpio026.agents26[0].is_active == UVM_ACTIVE)  
        virtual_sequencer26.gpio0_seqr26 =  gpio026.agents26[0].sequencer;

      virtual_sequencer26.reg_model_ptr26 = reg_model_apb26;

      apb_ss_env26.monitor26.set_slave_config26(apb_ss_cfg26.uart_cfg026.apb_cfg26.slave_configs26[0]);
      apb_ss_env26.apb_uart026.set_slave_config26(apb_ss_cfg26.uart_cfg026.apb_cfg26.slave_configs26[1], 1);
      apb_ss_env26.apb_uart126.set_slave_config26(apb_ss_cfg26.uart_cfg126.apb_cfg26.slave_configs26[3], 3);

      // ***********************************************************
      // Connect26 TLM ports26
      // ***********************************************************
      uart026.Rx26.monitor26.frame_collected_port26.connect(apb_ss_env26.apb_uart026.monitor26.uart_rx_in26);
      uart026.Tx26.monitor26.frame_collected_port26.connect(apb_ss_env26.apb_uart026.monitor26.uart_tx_in26);
      apb026.bus_monitor26.item_collected_port26.connect(apb_ss_env26.apb_uart026.monitor26.apb_in26);
      apb026.bus_monitor26.item_collected_port26.connect(apb_ss_env26.apb_uart026.apb_in26);
      user_ahb_monitor26.ahb_transfer_out26.connect(apb_ss_env26.monitor26.rx_scbd26.ahb_add26);
      user_ahb_monitor26.ahb_transfer_out26.connect(apb_ss_env26.ahb_in26);
      spi026.agents26[0].monitor26.item_collected_port26.connect(apb_ss_env26.monitor26.rx_scbd26.spi_match26);


      uart126.Rx26.monitor26.frame_collected_port26.connect(apb_ss_env26.apb_uart126.monitor26.uart_rx_in26);
      uart126.Tx26.monitor26.frame_collected_port26.connect(apb_ss_env26.apb_uart126.monitor26.uart_tx_in26);
      apb026.bus_monitor26.item_collected_port26.connect(apb_ss_env26.apb_uart126.monitor26.apb_in26);
      apb026.bus_monitor26.item_collected_port26.connect(apb_ss_env26.apb_uart126.apb_in26);

      // ***********************************************************
      // Connect26 the dut_csr26 ports26
      // ***********************************************************
      apb_ss_env26.spi_csr_out26.connect(apb_ss_env26.monitor26.dut_csr_port_in26);
      apb_ss_env26.spi_csr_out26.connect(spi026.dut_csr_port_in26);
      apb_ss_env26.gpio_csr_out26.connect(gpio026.dut_csr_port_in26);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env26();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY26",("APB26 SubSystem26 Virtual Sequence Testbench26 Topology26:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("                         _____26                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("                        | AHB26 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("                        | UVC26 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("                   ____________26    _________26               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("                  | AHB26 - APB26  |  | APB26 UVC26 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("                  |   Bridge26   |  | Passive26 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("  _____26    _____26    ______26    _______26    _____26    _______26  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",(" | SPI26 |  | SMC26 |  | GPIO26 |  | UART026 |  | PCM26 |  | UART126 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("  _____26              ______26    _______26            _______26  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",(" | SPI26 |            | GPIO26 |  | UART026 |          | UART126 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",(" | UVC26 |            | UVC26  |  |  UVC26  |          |  UVC26  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY26",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER26 MODEL26:\n", reg_model_apb26.sprint()}, UVM_LOW)
  endtask

endclass
