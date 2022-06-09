/*-------------------------------------------------------------------------
File28 name   : apb_subsystem_top_tb28.sv
Title28       : Simulation28 and Verification28 Environment28
Project28     :
Created28     :
Description28 : This28 file implements28 the SVE28 for the AHB28-UART28 Environment28
Notes28       : The apb_subsystem_tb28 creates28 the UART28 env28, the 
            : APB28 env28 and the scoreboard28. It also randomizes28 the UART28 
            : CSR28 settings28 and passes28 it to both the env28's.
----------------------------------------------------------------------*/
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

//--------------------------------------------------------------
//  Simulation28 Verification28 Environment28 (SVE28)
//--------------------------------------------------------------
class apb_subsystem_tb28 extends uvm_env;

  apb_subsystem_virtual_sequencer28 virtual_sequencer28;  // multi-channel28 sequencer
  ahb_pkg28::ahb_env28 ahb028;                          // AHB28 UVC28
  apb_pkg28::apb_env28 apb028;                          // APB28 UVC28
  uart_pkg28::uart_env28 uart028;                   // UART28 UVC28 connected28 to UART028
  uart_pkg28::uart_env28 uart128;                   // UART28 UVC28 connected28 to UART128
  spi_pkg28::spi_env28 spi028;                      // SPI28 UVC28 connected28 to SPI028
  gpio_pkg28::gpio_env28 gpio028;                   // GPIO28 UVC28 connected28 to GPIO028
  apb_subsystem_env28 apb_ss_env28;

  // UVM_REG
  apb_ss_reg_model_c28 reg_model_apb28;    // Register Model28
  reg_to_ahb_adapter28 reg2ahb28;         // Adapter Object - REG to APB28
  uvm_reg_predictor#(ahb_transfer28) ahb_predictor28; //Predictor28 - APB28 to REG

  apb_subsystem_pkg28::apb_subsystem_config28 apb_ss_cfg28;

  // enable automation28 for  apb_subsystem_tb28
  `uvm_component_utils_begin(apb_subsystem_tb28)
     `uvm_field_object(reg_model_apb28, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb28, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg28, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb28", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env28();
     // Configure28 UVCs28
    if (!uvm_config_db#(apb_subsystem_config28)::get(this, "", "apb_ss_cfg28", apb_ss_cfg28)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config28, creating28...", UVM_LOW)
      apb_ss_cfg28 = apb_subsystem_config28::type_id::create("apb_ss_cfg28", this);
      apb_ss_cfg28.uart_cfg028.apb_cfg28.add_master28("master28", UVM_PASSIVE);
      apb_ss_cfg28.uart_cfg028.apb_cfg28.add_slave28("spi028",  `AM_SPI0_BASE_ADDRESS28,  `AM_SPI0_END_ADDRESS28,  0, UVM_PASSIVE);
      apb_ss_cfg28.uart_cfg028.apb_cfg28.add_slave28("uart028", `AM_UART0_BASE_ADDRESS28, `AM_UART0_END_ADDRESS28, 0, UVM_PASSIVE);
      apb_ss_cfg28.uart_cfg028.apb_cfg28.add_slave28("gpio028", `AM_GPIO0_BASE_ADDRESS28, `AM_GPIO0_END_ADDRESS28, 0, UVM_PASSIVE);
      apb_ss_cfg28.uart_cfg028.apb_cfg28.add_slave28("uart128", `AM_UART1_BASE_ADDRESS28, `AM_UART1_END_ADDRESS28, 1, UVM_PASSIVE);
      apb_ss_cfg28.uart_cfg128.apb_cfg28.add_master28("master28", UVM_PASSIVE);
      apb_ss_cfg28.uart_cfg128.apb_cfg28.add_slave28("spi028",  `AM_SPI0_BASE_ADDRESS28,  `AM_SPI0_END_ADDRESS28,  0, UVM_PASSIVE);
      apb_ss_cfg28.uart_cfg128.apb_cfg28.add_slave28("uart028", `AM_UART0_BASE_ADDRESS28, `AM_UART0_END_ADDRESS28, 0, UVM_PASSIVE);
      apb_ss_cfg28.uart_cfg128.apb_cfg28.add_slave28("gpio028", `AM_GPIO0_BASE_ADDRESS28, `AM_GPIO0_END_ADDRESS28, 0, UVM_PASSIVE);
      apb_ss_cfg28.uart_cfg128.apb_cfg28.add_slave28("uart128", `AM_UART1_BASE_ADDRESS28, `AM_UART1_END_ADDRESS28, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing28 apb28 subsystem28 config:\n", apb_ss_cfg28.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config28)::set(this, "apb028", "cfg", apb_ss_cfg28.uart_cfg028.apb_cfg28);
     uvm_config_db#(uart_config28)::set(this, "uart028", "cfg", apb_ss_cfg28.uart_cfg028.uart_cfg28);
     uvm_config_db#(uart_config28)::set(this, "uart128", "cfg", apb_ss_cfg28.uart_cfg128.uart_cfg28);
     uvm_config_db#(uart_ctrl_config28)::set(this, "apb_ss_env28.apb_uart028", "cfg", apb_ss_cfg28.uart_cfg028);
     uvm_config_db#(uart_ctrl_config28)::set(this, "apb_ss_env28.apb_uart128", "cfg", apb_ss_cfg28.uart_cfg128);
     uvm_config_db#(apb_slave_config28)::set(this, "apb_ss_env28.apb_uart028", "apb_slave_cfg28", apb_ss_cfg28.uart_cfg028.apb_cfg28.slave_configs28[1]);
     uvm_config_db#(apb_slave_config28)::set(this, "apb_ss_env28.apb_uart128", "apb_slave_cfg28", apb_ss_cfg28.uart_cfg128.apb_cfg28.slave_configs28[3]);
     set_config_object("spi028", "spi_ve_config28", apb_ss_cfg28.spi_cfg28, 0);
     set_config_object("gpio028", "gpio_ve_config28", apb_ss_cfg28.gpio_cfg28, 0);

     set_config_int("*spi028.agents28[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio028.agents28[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb028.master_agent28","is_active", UVM_ACTIVE);  
     set_config_int("*ahb028.slave_agent28","is_active", UVM_PASSIVE);
     set_config_int("*uart028.Tx28","is_active", UVM_ACTIVE);  
     set_config_int("*uart028.Rx28","is_active", UVM_PASSIVE);
     set_config_int("*uart128.Tx28","is_active", UVM_ACTIVE);  
     set_config_int("*uart128.Rx28","is_active", UVM_PASSIVE);

     // Allocate28 objects28
     virtual_sequencer28 = apb_subsystem_virtual_sequencer28::type_id::create("virtual_sequencer28",this);
     ahb028              = ahb_pkg28::ahb_env28::type_id::create("ahb028",this);
     apb028              = apb_pkg28::apb_env28::type_id::create("apb028",this);
     uart028             = uart_pkg28::uart_env28::type_id::create("uart028",this);
     uart128             = uart_pkg28::uart_env28::type_id::create("uart128",this);
     spi028              = spi_pkg28::spi_env28::type_id::create("spi028",this);
     gpio028             = gpio_pkg28::gpio_env28::type_id::create("gpio028",this);
     apb_ss_env28        = apb_subsystem_env28::type_id::create("apb_ss_env28",this);

  //UVM_REG
  ahb_predictor28 = uvm_reg_predictor#(ahb_transfer28)::type_id::create("ahb_predictor28", this);
  if (reg_model_apb28 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb28 = apb_ss_reg_model_c28::type_id::create("reg_model_apb28");
    reg_model_apb28.build();  //NOTE28: not same as build_phase: reg_model28 is an object
    reg_model_apb28.lock_model();
  end
    // set the register model for the rest28 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb28", reg_model_apb28);
    uvm_config_object::set(this, "*uart028*", "reg_model28", reg_model_apb28.uart0_rm28);
    uvm_config_object::set(this, "*uart128*", "reg_model28", reg_model_apb28.uart1_rm28);


  endfunction : build_env28

  function void connect_phase(uvm_phase phase);
    ahb_monitor28 user_ahb_monitor28;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb28 = reg_to_ahb_adapter28::type_id::create("reg2ahb28");
    reg_model_apb28.default_map.set_sequencer(ahb028.master_agent28.sequencer, reg2ahb28);  //
    reg_model_apb28.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor28, ahb028.master_agent28.monitor28))
        `uvm_fatal("CASTFL28", "Failed28 to cast master28 monitor28 to user_ahb_monitor28");

      // ***********************************************************
      //  Hookup28 virtual sequencer to interface sequencers28
      // ***********************************************************
        virtual_sequencer28.ahb_seqr28 =  ahb028.master_agent28.sequencer;
      if (uart028.Tx28.is_active == UVM_ACTIVE)  
        virtual_sequencer28.uart0_seqr28 =  uart028.Tx28.sequencer;
      if (uart128.Tx28.is_active == UVM_ACTIVE)  
        virtual_sequencer28.uart1_seqr28 =  uart128.Tx28.sequencer;
      if (spi028.agents28[0].is_active == UVM_ACTIVE)  
        virtual_sequencer28.spi0_seqr28 =  spi028.agents28[0].sequencer;
      if (gpio028.agents28[0].is_active == UVM_ACTIVE)  
        virtual_sequencer28.gpio0_seqr28 =  gpio028.agents28[0].sequencer;

      virtual_sequencer28.reg_model_ptr28 = reg_model_apb28;

      apb_ss_env28.monitor28.set_slave_config28(apb_ss_cfg28.uart_cfg028.apb_cfg28.slave_configs28[0]);
      apb_ss_env28.apb_uart028.set_slave_config28(apb_ss_cfg28.uart_cfg028.apb_cfg28.slave_configs28[1], 1);
      apb_ss_env28.apb_uart128.set_slave_config28(apb_ss_cfg28.uart_cfg128.apb_cfg28.slave_configs28[3], 3);

      // ***********************************************************
      // Connect28 TLM ports28
      // ***********************************************************
      uart028.Rx28.monitor28.frame_collected_port28.connect(apb_ss_env28.apb_uart028.monitor28.uart_rx_in28);
      uart028.Tx28.monitor28.frame_collected_port28.connect(apb_ss_env28.apb_uart028.monitor28.uart_tx_in28);
      apb028.bus_monitor28.item_collected_port28.connect(apb_ss_env28.apb_uart028.monitor28.apb_in28);
      apb028.bus_monitor28.item_collected_port28.connect(apb_ss_env28.apb_uart028.apb_in28);
      user_ahb_monitor28.ahb_transfer_out28.connect(apb_ss_env28.monitor28.rx_scbd28.ahb_add28);
      user_ahb_monitor28.ahb_transfer_out28.connect(apb_ss_env28.ahb_in28);
      spi028.agents28[0].monitor28.item_collected_port28.connect(apb_ss_env28.monitor28.rx_scbd28.spi_match28);


      uart128.Rx28.monitor28.frame_collected_port28.connect(apb_ss_env28.apb_uart128.monitor28.uart_rx_in28);
      uart128.Tx28.monitor28.frame_collected_port28.connect(apb_ss_env28.apb_uart128.monitor28.uart_tx_in28);
      apb028.bus_monitor28.item_collected_port28.connect(apb_ss_env28.apb_uart128.monitor28.apb_in28);
      apb028.bus_monitor28.item_collected_port28.connect(apb_ss_env28.apb_uart128.apb_in28);

      // ***********************************************************
      // Connect28 the dut_csr28 ports28
      // ***********************************************************
      apb_ss_env28.spi_csr_out28.connect(apb_ss_env28.monitor28.dut_csr_port_in28);
      apb_ss_env28.spi_csr_out28.connect(spi028.dut_csr_port_in28);
      apb_ss_env28.gpio_csr_out28.connect(gpio028.dut_csr_port_in28);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env28();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY28",("APB28 SubSystem28 Virtual Sequence Testbench28 Topology28:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("                         _____28                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("                        | AHB28 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("                        | UVC28 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("                   ____________28    _________28               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("                  | AHB28 - APB28  |  | APB28 UVC28 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("                  |   Bridge28   |  | Passive28 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("  _____28    _____28    ______28    _______28    _____28    _______28  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",(" | SPI28 |  | SMC28 |  | GPIO28 |  | UART028 |  | PCM28 |  | UART128 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("  _____28              ______28    _______28            _______28  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",(" | SPI28 |            | GPIO28 |  | UART028 |          | UART128 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",(" | UVC28 |            | UVC28  |  |  UVC28  |          |  UVC28  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY28",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER28 MODEL28:\n", reg_model_apb28.sprint()}, UVM_LOW)
  endtask

endclass
