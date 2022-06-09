/*-------------------------------------------------------------------------
File11 name   : apb_subsystem_top_tb11.sv
Title11       : Simulation11 and Verification11 Environment11
Project11     :
Created11     :
Description11 : This11 file implements11 the SVE11 for the AHB11-UART11 Environment11
Notes11       : The apb_subsystem_tb11 creates11 the UART11 env11, the 
            : APB11 env11 and the scoreboard11. It also randomizes11 the UART11 
            : CSR11 settings11 and passes11 it to both the env11's.
----------------------------------------------------------------------*/
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

//--------------------------------------------------------------
//  Simulation11 Verification11 Environment11 (SVE11)
//--------------------------------------------------------------
class apb_subsystem_tb11 extends uvm_env;

  apb_subsystem_virtual_sequencer11 virtual_sequencer11;  // multi-channel11 sequencer
  ahb_pkg11::ahb_env11 ahb011;                          // AHB11 UVC11
  apb_pkg11::apb_env11 apb011;                          // APB11 UVC11
  uart_pkg11::uart_env11 uart011;                   // UART11 UVC11 connected11 to UART011
  uart_pkg11::uart_env11 uart111;                   // UART11 UVC11 connected11 to UART111
  spi_pkg11::spi_env11 spi011;                      // SPI11 UVC11 connected11 to SPI011
  gpio_pkg11::gpio_env11 gpio011;                   // GPIO11 UVC11 connected11 to GPIO011
  apb_subsystem_env11 apb_ss_env11;

  // UVM_REG
  apb_ss_reg_model_c11 reg_model_apb11;    // Register Model11
  reg_to_ahb_adapter11 reg2ahb11;         // Adapter Object - REG to APB11
  uvm_reg_predictor#(ahb_transfer11) ahb_predictor11; //Predictor11 - APB11 to REG

  apb_subsystem_pkg11::apb_subsystem_config11 apb_ss_cfg11;

  // enable automation11 for  apb_subsystem_tb11
  `uvm_component_utils_begin(apb_subsystem_tb11)
     `uvm_field_object(reg_model_apb11, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb11, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg11, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb11", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env11();
     // Configure11 UVCs11
    if (!uvm_config_db#(apb_subsystem_config11)::get(this, "", "apb_ss_cfg11", apb_ss_cfg11)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config11, creating11...", UVM_LOW)
      apb_ss_cfg11 = apb_subsystem_config11::type_id::create("apb_ss_cfg11", this);
      apb_ss_cfg11.uart_cfg011.apb_cfg11.add_master11("master11", UVM_PASSIVE);
      apb_ss_cfg11.uart_cfg011.apb_cfg11.add_slave11("spi011",  `AM_SPI0_BASE_ADDRESS11,  `AM_SPI0_END_ADDRESS11,  0, UVM_PASSIVE);
      apb_ss_cfg11.uart_cfg011.apb_cfg11.add_slave11("uart011", `AM_UART0_BASE_ADDRESS11, `AM_UART0_END_ADDRESS11, 0, UVM_PASSIVE);
      apb_ss_cfg11.uart_cfg011.apb_cfg11.add_slave11("gpio011", `AM_GPIO0_BASE_ADDRESS11, `AM_GPIO0_END_ADDRESS11, 0, UVM_PASSIVE);
      apb_ss_cfg11.uart_cfg011.apb_cfg11.add_slave11("uart111", `AM_UART1_BASE_ADDRESS11, `AM_UART1_END_ADDRESS11, 1, UVM_PASSIVE);
      apb_ss_cfg11.uart_cfg111.apb_cfg11.add_master11("master11", UVM_PASSIVE);
      apb_ss_cfg11.uart_cfg111.apb_cfg11.add_slave11("spi011",  `AM_SPI0_BASE_ADDRESS11,  `AM_SPI0_END_ADDRESS11,  0, UVM_PASSIVE);
      apb_ss_cfg11.uart_cfg111.apb_cfg11.add_slave11("uart011", `AM_UART0_BASE_ADDRESS11, `AM_UART0_END_ADDRESS11, 0, UVM_PASSIVE);
      apb_ss_cfg11.uart_cfg111.apb_cfg11.add_slave11("gpio011", `AM_GPIO0_BASE_ADDRESS11, `AM_GPIO0_END_ADDRESS11, 0, UVM_PASSIVE);
      apb_ss_cfg11.uart_cfg111.apb_cfg11.add_slave11("uart111", `AM_UART1_BASE_ADDRESS11, `AM_UART1_END_ADDRESS11, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing11 apb11 subsystem11 config:\n", apb_ss_cfg11.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config11)::set(this, "apb011", "cfg", apb_ss_cfg11.uart_cfg011.apb_cfg11);
     uvm_config_db#(uart_config11)::set(this, "uart011", "cfg", apb_ss_cfg11.uart_cfg011.uart_cfg11);
     uvm_config_db#(uart_config11)::set(this, "uart111", "cfg", apb_ss_cfg11.uart_cfg111.uart_cfg11);
     uvm_config_db#(uart_ctrl_config11)::set(this, "apb_ss_env11.apb_uart011", "cfg", apb_ss_cfg11.uart_cfg011);
     uvm_config_db#(uart_ctrl_config11)::set(this, "apb_ss_env11.apb_uart111", "cfg", apb_ss_cfg11.uart_cfg111);
     uvm_config_db#(apb_slave_config11)::set(this, "apb_ss_env11.apb_uart011", "apb_slave_cfg11", apb_ss_cfg11.uart_cfg011.apb_cfg11.slave_configs11[1]);
     uvm_config_db#(apb_slave_config11)::set(this, "apb_ss_env11.apb_uart111", "apb_slave_cfg11", apb_ss_cfg11.uart_cfg111.apb_cfg11.slave_configs11[3]);
     set_config_object("spi011", "spi_ve_config11", apb_ss_cfg11.spi_cfg11, 0);
     set_config_object("gpio011", "gpio_ve_config11", apb_ss_cfg11.gpio_cfg11, 0);

     set_config_int("*spi011.agents11[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio011.agents11[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb011.master_agent11","is_active", UVM_ACTIVE);  
     set_config_int("*ahb011.slave_agent11","is_active", UVM_PASSIVE);
     set_config_int("*uart011.Tx11","is_active", UVM_ACTIVE);  
     set_config_int("*uart011.Rx11","is_active", UVM_PASSIVE);
     set_config_int("*uart111.Tx11","is_active", UVM_ACTIVE);  
     set_config_int("*uart111.Rx11","is_active", UVM_PASSIVE);

     // Allocate11 objects11
     virtual_sequencer11 = apb_subsystem_virtual_sequencer11::type_id::create("virtual_sequencer11",this);
     ahb011              = ahb_pkg11::ahb_env11::type_id::create("ahb011",this);
     apb011              = apb_pkg11::apb_env11::type_id::create("apb011",this);
     uart011             = uart_pkg11::uart_env11::type_id::create("uart011",this);
     uart111             = uart_pkg11::uart_env11::type_id::create("uart111",this);
     spi011              = spi_pkg11::spi_env11::type_id::create("spi011",this);
     gpio011             = gpio_pkg11::gpio_env11::type_id::create("gpio011",this);
     apb_ss_env11        = apb_subsystem_env11::type_id::create("apb_ss_env11",this);

  //UVM_REG
  ahb_predictor11 = uvm_reg_predictor#(ahb_transfer11)::type_id::create("ahb_predictor11", this);
  if (reg_model_apb11 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb11 = apb_ss_reg_model_c11::type_id::create("reg_model_apb11");
    reg_model_apb11.build();  //NOTE11: not same as build_phase: reg_model11 is an object
    reg_model_apb11.lock_model();
  end
    // set the register model for the rest11 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb11", reg_model_apb11);
    uvm_config_object::set(this, "*uart011*", "reg_model11", reg_model_apb11.uart0_rm11);
    uvm_config_object::set(this, "*uart111*", "reg_model11", reg_model_apb11.uart1_rm11);


  endfunction : build_env11

  function void connect_phase(uvm_phase phase);
    ahb_monitor11 user_ahb_monitor11;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb11 = reg_to_ahb_adapter11::type_id::create("reg2ahb11");
    reg_model_apb11.default_map.set_sequencer(ahb011.master_agent11.sequencer, reg2ahb11);  //
    reg_model_apb11.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor11, ahb011.master_agent11.monitor11))
        `uvm_fatal("CASTFL11", "Failed11 to cast master11 monitor11 to user_ahb_monitor11");

      // ***********************************************************
      //  Hookup11 virtual sequencer to interface sequencers11
      // ***********************************************************
        virtual_sequencer11.ahb_seqr11 =  ahb011.master_agent11.sequencer;
      if (uart011.Tx11.is_active == UVM_ACTIVE)  
        virtual_sequencer11.uart0_seqr11 =  uart011.Tx11.sequencer;
      if (uart111.Tx11.is_active == UVM_ACTIVE)  
        virtual_sequencer11.uart1_seqr11 =  uart111.Tx11.sequencer;
      if (spi011.agents11[0].is_active == UVM_ACTIVE)  
        virtual_sequencer11.spi0_seqr11 =  spi011.agents11[0].sequencer;
      if (gpio011.agents11[0].is_active == UVM_ACTIVE)  
        virtual_sequencer11.gpio0_seqr11 =  gpio011.agents11[0].sequencer;

      virtual_sequencer11.reg_model_ptr11 = reg_model_apb11;

      apb_ss_env11.monitor11.set_slave_config11(apb_ss_cfg11.uart_cfg011.apb_cfg11.slave_configs11[0]);
      apb_ss_env11.apb_uart011.set_slave_config11(apb_ss_cfg11.uart_cfg011.apb_cfg11.slave_configs11[1], 1);
      apb_ss_env11.apb_uart111.set_slave_config11(apb_ss_cfg11.uart_cfg111.apb_cfg11.slave_configs11[3], 3);

      // ***********************************************************
      // Connect11 TLM ports11
      // ***********************************************************
      uart011.Rx11.monitor11.frame_collected_port11.connect(apb_ss_env11.apb_uart011.monitor11.uart_rx_in11);
      uart011.Tx11.monitor11.frame_collected_port11.connect(apb_ss_env11.apb_uart011.monitor11.uart_tx_in11);
      apb011.bus_monitor11.item_collected_port11.connect(apb_ss_env11.apb_uart011.monitor11.apb_in11);
      apb011.bus_monitor11.item_collected_port11.connect(apb_ss_env11.apb_uart011.apb_in11);
      user_ahb_monitor11.ahb_transfer_out11.connect(apb_ss_env11.monitor11.rx_scbd11.ahb_add11);
      user_ahb_monitor11.ahb_transfer_out11.connect(apb_ss_env11.ahb_in11);
      spi011.agents11[0].monitor11.item_collected_port11.connect(apb_ss_env11.monitor11.rx_scbd11.spi_match11);


      uart111.Rx11.monitor11.frame_collected_port11.connect(apb_ss_env11.apb_uart111.monitor11.uart_rx_in11);
      uart111.Tx11.monitor11.frame_collected_port11.connect(apb_ss_env11.apb_uart111.monitor11.uart_tx_in11);
      apb011.bus_monitor11.item_collected_port11.connect(apb_ss_env11.apb_uart111.monitor11.apb_in11);
      apb011.bus_monitor11.item_collected_port11.connect(apb_ss_env11.apb_uart111.apb_in11);

      // ***********************************************************
      // Connect11 the dut_csr11 ports11
      // ***********************************************************
      apb_ss_env11.spi_csr_out11.connect(apb_ss_env11.monitor11.dut_csr_port_in11);
      apb_ss_env11.spi_csr_out11.connect(spi011.dut_csr_port_in11);
      apb_ss_env11.gpio_csr_out11.connect(gpio011.dut_csr_port_in11);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env11();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY11",("APB11 SubSystem11 Virtual Sequence Testbench11 Topology11:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("                         _____11                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("                        | AHB11 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("                        | UVC11 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("                   ____________11    _________11               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("                  | AHB11 - APB11  |  | APB11 UVC11 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("                  |   Bridge11   |  | Passive11 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("  _____11    _____11    ______11    _______11    _____11    _______11  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",(" | SPI11 |  | SMC11 |  | GPIO11 |  | UART011 |  | PCM11 |  | UART111 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("  _____11              ______11    _______11            _______11  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",(" | SPI11 |            | GPIO11 |  | UART011 |          | UART111 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",(" | UVC11 |            | UVC11  |  |  UVC11  |          |  UVC11  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY11",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER11 MODEL11:\n", reg_model_apb11.sprint()}, UVM_LOW)
  endtask

endclass
