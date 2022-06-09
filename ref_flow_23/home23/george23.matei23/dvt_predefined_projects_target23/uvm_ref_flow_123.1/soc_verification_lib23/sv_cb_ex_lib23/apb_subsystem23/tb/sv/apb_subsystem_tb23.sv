/*-------------------------------------------------------------------------
File23 name   : apb_subsystem_top_tb23.sv
Title23       : Simulation23 and Verification23 Environment23
Project23     :
Created23     :
Description23 : This23 file implements23 the SVE23 for the AHB23-UART23 Environment23
Notes23       : The apb_subsystem_tb23 creates23 the UART23 env23, the 
            : APB23 env23 and the scoreboard23. It also randomizes23 the UART23 
            : CSR23 settings23 and passes23 it to both the env23's.
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation23 Verification23 Environment23 (SVE23)
//--------------------------------------------------------------
class apb_subsystem_tb23 extends uvm_env;

  apb_subsystem_virtual_sequencer23 virtual_sequencer23;  // multi-channel23 sequencer
  ahb_pkg23::ahb_env23 ahb023;                          // AHB23 UVC23
  apb_pkg23::apb_env23 apb023;                          // APB23 UVC23
  uart_pkg23::uart_env23 uart023;                   // UART23 UVC23 connected23 to UART023
  uart_pkg23::uart_env23 uart123;                   // UART23 UVC23 connected23 to UART123
  spi_pkg23::spi_env23 spi023;                      // SPI23 UVC23 connected23 to SPI023
  gpio_pkg23::gpio_env23 gpio023;                   // GPIO23 UVC23 connected23 to GPIO023
  apb_subsystem_env23 apb_ss_env23;

  // UVM_REG
  apb_ss_reg_model_c23 reg_model_apb23;    // Register Model23
  reg_to_ahb_adapter23 reg2ahb23;         // Adapter Object - REG to APB23
  uvm_reg_predictor#(ahb_transfer23) ahb_predictor23; //Predictor23 - APB23 to REG

  apb_subsystem_pkg23::apb_subsystem_config23 apb_ss_cfg23;

  // enable automation23 for  apb_subsystem_tb23
  `uvm_component_utils_begin(apb_subsystem_tb23)
     `uvm_field_object(reg_model_apb23, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb23, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg23, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb23", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env23();
     // Configure23 UVCs23
    if (!uvm_config_db#(apb_subsystem_config23)::get(this, "", "apb_ss_cfg23", apb_ss_cfg23)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config23, creating23...", UVM_LOW)
      apb_ss_cfg23 = apb_subsystem_config23::type_id::create("apb_ss_cfg23", this);
      apb_ss_cfg23.uart_cfg023.apb_cfg23.add_master23("master23", UVM_PASSIVE);
      apb_ss_cfg23.uart_cfg023.apb_cfg23.add_slave23("spi023",  `AM_SPI0_BASE_ADDRESS23,  `AM_SPI0_END_ADDRESS23,  0, UVM_PASSIVE);
      apb_ss_cfg23.uart_cfg023.apb_cfg23.add_slave23("uart023", `AM_UART0_BASE_ADDRESS23, `AM_UART0_END_ADDRESS23, 0, UVM_PASSIVE);
      apb_ss_cfg23.uart_cfg023.apb_cfg23.add_slave23("gpio023", `AM_GPIO0_BASE_ADDRESS23, `AM_GPIO0_END_ADDRESS23, 0, UVM_PASSIVE);
      apb_ss_cfg23.uart_cfg023.apb_cfg23.add_slave23("uart123", `AM_UART1_BASE_ADDRESS23, `AM_UART1_END_ADDRESS23, 1, UVM_PASSIVE);
      apb_ss_cfg23.uart_cfg123.apb_cfg23.add_master23("master23", UVM_PASSIVE);
      apb_ss_cfg23.uart_cfg123.apb_cfg23.add_slave23("spi023",  `AM_SPI0_BASE_ADDRESS23,  `AM_SPI0_END_ADDRESS23,  0, UVM_PASSIVE);
      apb_ss_cfg23.uart_cfg123.apb_cfg23.add_slave23("uart023", `AM_UART0_BASE_ADDRESS23, `AM_UART0_END_ADDRESS23, 0, UVM_PASSIVE);
      apb_ss_cfg23.uart_cfg123.apb_cfg23.add_slave23("gpio023", `AM_GPIO0_BASE_ADDRESS23, `AM_GPIO0_END_ADDRESS23, 0, UVM_PASSIVE);
      apb_ss_cfg23.uart_cfg123.apb_cfg23.add_slave23("uart123", `AM_UART1_BASE_ADDRESS23, `AM_UART1_END_ADDRESS23, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing23 apb23 subsystem23 config:\n", apb_ss_cfg23.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config23)::set(this, "apb023", "cfg", apb_ss_cfg23.uart_cfg023.apb_cfg23);
     uvm_config_db#(uart_config23)::set(this, "uart023", "cfg", apb_ss_cfg23.uart_cfg023.uart_cfg23);
     uvm_config_db#(uart_config23)::set(this, "uart123", "cfg", apb_ss_cfg23.uart_cfg123.uart_cfg23);
     uvm_config_db#(uart_ctrl_config23)::set(this, "apb_ss_env23.apb_uart023", "cfg", apb_ss_cfg23.uart_cfg023);
     uvm_config_db#(uart_ctrl_config23)::set(this, "apb_ss_env23.apb_uart123", "cfg", apb_ss_cfg23.uart_cfg123);
     uvm_config_db#(apb_slave_config23)::set(this, "apb_ss_env23.apb_uart023", "apb_slave_cfg23", apb_ss_cfg23.uart_cfg023.apb_cfg23.slave_configs23[1]);
     uvm_config_db#(apb_slave_config23)::set(this, "apb_ss_env23.apb_uart123", "apb_slave_cfg23", apb_ss_cfg23.uart_cfg123.apb_cfg23.slave_configs23[3]);
     set_config_object("spi023", "spi_ve_config23", apb_ss_cfg23.spi_cfg23, 0);
     set_config_object("gpio023", "gpio_ve_config23", apb_ss_cfg23.gpio_cfg23, 0);

     set_config_int("*spi023.agents23[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio023.agents23[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb023.master_agent23","is_active", UVM_ACTIVE);  
     set_config_int("*ahb023.slave_agent23","is_active", UVM_PASSIVE);
     set_config_int("*uart023.Tx23","is_active", UVM_ACTIVE);  
     set_config_int("*uart023.Rx23","is_active", UVM_PASSIVE);
     set_config_int("*uart123.Tx23","is_active", UVM_ACTIVE);  
     set_config_int("*uart123.Rx23","is_active", UVM_PASSIVE);

     // Allocate23 objects23
     virtual_sequencer23 = apb_subsystem_virtual_sequencer23::type_id::create("virtual_sequencer23",this);
     ahb023              = ahb_pkg23::ahb_env23::type_id::create("ahb023",this);
     apb023              = apb_pkg23::apb_env23::type_id::create("apb023",this);
     uart023             = uart_pkg23::uart_env23::type_id::create("uart023",this);
     uart123             = uart_pkg23::uart_env23::type_id::create("uart123",this);
     spi023              = spi_pkg23::spi_env23::type_id::create("spi023",this);
     gpio023             = gpio_pkg23::gpio_env23::type_id::create("gpio023",this);
     apb_ss_env23        = apb_subsystem_env23::type_id::create("apb_ss_env23",this);

  //UVM_REG
  ahb_predictor23 = uvm_reg_predictor#(ahb_transfer23)::type_id::create("ahb_predictor23", this);
  if (reg_model_apb23 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb23 = apb_ss_reg_model_c23::type_id::create("reg_model_apb23");
    reg_model_apb23.build();  //NOTE23: not same as build_phase: reg_model23 is an object
    reg_model_apb23.lock_model();
  end
    // set the register model for the rest23 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb23", reg_model_apb23);
    uvm_config_object::set(this, "*uart023*", "reg_model23", reg_model_apb23.uart0_rm23);
    uvm_config_object::set(this, "*uart123*", "reg_model23", reg_model_apb23.uart1_rm23);


  endfunction : build_env23

  function void connect_phase(uvm_phase phase);
    ahb_monitor23 user_ahb_monitor23;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb23 = reg_to_ahb_adapter23::type_id::create("reg2ahb23");
    reg_model_apb23.default_map.set_sequencer(ahb023.master_agent23.sequencer, reg2ahb23);  //
    reg_model_apb23.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor23, ahb023.master_agent23.monitor23))
        `uvm_fatal("CASTFL23", "Failed23 to cast master23 monitor23 to user_ahb_monitor23");

      // ***********************************************************
      //  Hookup23 virtual sequencer to interface sequencers23
      // ***********************************************************
        virtual_sequencer23.ahb_seqr23 =  ahb023.master_agent23.sequencer;
      if (uart023.Tx23.is_active == UVM_ACTIVE)  
        virtual_sequencer23.uart0_seqr23 =  uart023.Tx23.sequencer;
      if (uart123.Tx23.is_active == UVM_ACTIVE)  
        virtual_sequencer23.uart1_seqr23 =  uart123.Tx23.sequencer;
      if (spi023.agents23[0].is_active == UVM_ACTIVE)  
        virtual_sequencer23.spi0_seqr23 =  spi023.agents23[0].sequencer;
      if (gpio023.agents23[0].is_active == UVM_ACTIVE)  
        virtual_sequencer23.gpio0_seqr23 =  gpio023.agents23[0].sequencer;

      virtual_sequencer23.reg_model_ptr23 = reg_model_apb23;

      apb_ss_env23.monitor23.set_slave_config23(apb_ss_cfg23.uart_cfg023.apb_cfg23.slave_configs23[0]);
      apb_ss_env23.apb_uart023.set_slave_config23(apb_ss_cfg23.uart_cfg023.apb_cfg23.slave_configs23[1], 1);
      apb_ss_env23.apb_uart123.set_slave_config23(apb_ss_cfg23.uart_cfg123.apb_cfg23.slave_configs23[3], 3);

      // ***********************************************************
      // Connect23 TLM ports23
      // ***********************************************************
      uart023.Rx23.monitor23.frame_collected_port23.connect(apb_ss_env23.apb_uart023.monitor23.uart_rx_in23);
      uart023.Tx23.monitor23.frame_collected_port23.connect(apb_ss_env23.apb_uart023.monitor23.uart_tx_in23);
      apb023.bus_monitor23.item_collected_port23.connect(apb_ss_env23.apb_uart023.monitor23.apb_in23);
      apb023.bus_monitor23.item_collected_port23.connect(apb_ss_env23.apb_uart023.apb_in23);
      user_ahb_monitor23.ahb_transfer_out23.connect(apb_ss_env23.monitor23.rx_scbd23.ahb_add23);
      user_ahb_monitor23.ahb_transfer_out23.connect(apb_ss_env23.ahb_in23);
      spi023.agents23[0].monitor23.item_collected_port23.connect(apb_ss_env23.monitor23.rx_scbd23.spi_match23);


      uart123.Rx23.monitor23.frame_collected_port23.connect(apb_ss_env23.apb_uart123.monitor23.uart_rx_in23);
      uart123.Tx23.monitor23.frame_collected_port23.connect(apb_ss_env23.apb_uart123.monitor23.uart_tx_in23);
      apb023.bus_monitor23.item_collected_port23.connect(apb_ss_env23.apb_uart123.monitor23.apb_in23);
      apb023.bus_monitor23.item_collected_port23.connect(apb_ss_env23.apb_uart123.apb_in23);

      // ***********************************************************
      // Connect23 the dut_csr23 ports23
      // ***********************************************************
      apb_ss_env23.spi_csr_out23.connect(apb_ss_env23.monitor23.dut_csr_port_in23);
      apb_ss_env23.spi_csr_out23.connect(spi023.dut_csr_port_in23);
      apb_ss_env23.gpio_csr_out23.connect(gpio023.dut_csr_port_in23);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env23();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY23",("APB23 SubSystem23 Virtual Sequence Testbench23 Topology23:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("                         _____23                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("                        | AHB23 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("                        | UVC23 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("                   ____________23    _________23               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("                  | AHB23 - APB23  |  | APB23 UVC23 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("                  |   Bridge23   |  | Passive23 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("  _____23    _____23    ______23    _______23    _____23    _______23  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",(" | SPI23 |  | SMC23 |  | GPIO23 |  | UART023 |  | PCM23 |  | UART123 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("  _____23              ______23    _______23            _______23  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",(" | SPI23 |            | GPIO23 |  | UART023 |          | UART123 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",(" | UVC23 |            | UVC23  |  |  UVC23  |          |  UVC23  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY23",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER23 MODEL23:\n", reg_model_apb23.sprint()}, UVM_LOW)
  endtask

endclass
