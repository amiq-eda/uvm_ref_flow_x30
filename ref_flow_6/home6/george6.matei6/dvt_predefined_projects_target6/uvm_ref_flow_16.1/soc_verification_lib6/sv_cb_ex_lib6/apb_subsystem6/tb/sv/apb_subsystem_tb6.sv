/*-------------------------------------------------------------------------
File6 name   : apb_subsystem_top_tb6.sv
Title6       : Simulation6 and Verification6 Environment6
Project6     :
Created6     :
Description6 : This6 file implements6 the SVE6 for the AHB6-UART6 Environment6
Notes6       : The apb_subsystem_tb6 creates6 the UART6 env6, the 
            : APB6 env6 and the scoreboard6. It also randomizes6 the UART6 
            : CSR6 settings6 and passes6 it to both the env6's.
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation6 Verification6 Environment6 (SVE6)
//--------------------------------------------------------------
class apb_subsystem_tb6 extends uvm_env;

  apb_subsystem_virtual_sequencer6 virtual_sequencer6;  // multi-channel6 sequencer
  ahb_pkg6::ahb_env6 ahb06;                          // AHB6 UVC6
  apb_pkg6::apb_env6 apb06;                          // APB6 UVC6
  uart_pkg6::uart_env6 uart06;                   // UART6 UVC6 connected6 to UART06
  uart_pkg6::uart_env6 uart16;                   // UART6 UVC6 connected6 to UART16
  spi_pkg6::spi_env6 spi06;                      // SPI6 UVC6 connected6 to SPI06
  gpio_pkg6::gpio_env6 gpio06;                   // GPIO6 UVC6 connected6 to GPIO06
  apb_subsystem_env6 apb_ss_env6;

  // UVM_REG
  apb_ss_reg_model_c6 reg_model_apb6;    // Register Model6
  reg_to_ahb_adapter6 reg2ahb6;         // Adapter Object - REG to APB6
  uvm_reg_predictor#(ahb_transfer6) ahb_predictor6; //Predictor6 - APB6 to REG

  apb_subsystem_pkg6::apb_subsystem_config6 apb_ss_cfg6;

  // enable automation6 for  apb_subsystem_tb6
  `uvm_component_utils_begin(apb_subsystem_tb6)
     `uvm_field_object(reg_model_apb6, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb6, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg6, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb6", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env6();
     // Configure6 UVCs6
    if (!uvm_config_db#(apb_subsystem_config6)::get(this, "", "apb_ss_cfg6", apb_ss_cfg6)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config6, creating6...", UVM_LOW)
      apb_ss_cfg6 = apb_subsystem_config6::type_id::create("apb_ss_cfg6", this);
      apb_ss_cfg6.uart_cfg06.apb_cfg6.add_master6("master6", UVM_PASSIVE);
      apb_ss_cfg6.uart_cfg06.apb_cfg6.add_slave6("spi06",  `AM_SPI0_BASE_ADDRESS6,  `AM_SPI0_END_ADDRESS6,  0, UVM_PASSIVE);
      apb_ss_cfg6.uart_cfg06.apb_cfg6.add_slave6("uart06", `AM_UART0_BASE_ADDRESS6, `AM_UART0_END_ADDRESS6, 0, UVM_PASSIVE);
      apb_ss_cfg6.uart_cfg06.apb_cfg6.add_slave6("gpio06", `AM_GPIO0_BASE_ADDRESS6, `AM_GPIO0_END_ADDRESS6, 0, UVM_PASSIVE);
      apb_ss_cfg6.uart_cfg06.apb_cfg6.add_slave6("uart16", `AM_UART1_BASE_ADDRESS6, `AM_UART1_END_ADDRESS6, 1, UVM_PASSIVE);
      apb_ss_cfg6.uart_cfg16.apb_cfg6.add_master6("master6", UVM_PASSIVE);
      apb_ss_cfg6.uart_cfg16.apb_cfg6.add_slave6("spi06",  `AM_SPI0_BASE_ADDRESS6,  `AM_SPI0_END_ADDRESS6,  0, UVM_PASSIVE);
      apb_ss_cfg6.uart_cfg16.apb_cfg6.add_slave6("uart06", `AM_UART0_BASE_ADDRESS6, `AM_UART0_END_ADDRESS6, 0, UVM_PASSIVE);
      apb_ss_cfg6.uart_cfg16.apb_cfg6.add_slave6("gpio06", `AM_GPIO0_BASE_ADDRESS6, `AM_GPIO0_END_ADDRESS6, 0, UVM_PASSIVE);
      apb_ss_cfg6.uart_cfg16.apb_cfg6.add_slave6("uart16", `AM_UART1_BASE_ADDRESS6, `AM_UART1_END_ADDRESS6, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing6 apb6 subsystem6 config:\n", apb_ss_cfg6.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config6)::set(this, "apb06", "cfg", apb_ss_cfg6.uart_cfg06.apb_cfg6);
     uvm_config_db#(uart_config6)::set(this, "uart06", "cfg", apb_ss_cfg6.uart_cfg06.uart_cfg6);
     uvm_config_db#(uart_config6)::set(this, "uart16", "cfg", apb_ss_cfg6.uart_cfg16.uart_cfg6);
     uvm_config_db#(uart_ctrl_config6)::set(this, "apb_ss_env6.apb_uart06", "cfg", apb_ss_cfg6.uart_cfg06);
     uvm_config_db#(uart_ctrl_config6)::set(this, "apb_ss_env6.apb_uart16", "cfg", apb_ss_cfg6.uart_cfg16);
     uvm_config_db#(apb_slave_config6)::set(this, "apb_ss_env6.apb_uart06", "apb_slave_cfg6", apb_ss_cfg6.uart_cfg06.apb_cfg6.slave_configs6[1]);
     uvm_config_db#(apb_slave_config6)::set(this, "apb_ss_env6.apb_uart16", "apb_slave_cfg6", apb_ss_cfg6.uart_cfg16.apb_cfg6.slave_configs6[3]);
     set_config_object("spi06", "spi_ve_config6", apb_ss_cfg6.spi_cfg6, 0);
     set_config_object("gpio06", "gpio_ve_config6", apb_ss_cfg6.gpio_cfg6, 0);

     set_config_int("*spi06.agents6[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio06.agents6[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb06.master_agent6","is_active", UVM_ACTIVE);  
     set_config_int("*ahb06.slave_agent6","is_active", UVM_PASSIVE);
     set_config_int("*uart06.Tx6","is_active", UVM_ACTIVE);  
     set_config_int("*uart06.Rx6","is_active", UVM_PASSIVE);
     set_config_int("*uart16.Tx6","is_active", UVM_ACTIVE);  
     set_config_int("*uart16.Rx6","is_active", UVM_PASSIVE);

     // Allocate6 objects6
     virtual_sequencer6 = apb_subsystem_virtual_sequencer6::type_id::create("virtual_sequencer6",this);
     ahb06              = ahb_pkg6::ahb_env6::type_id::create("ahb06",this);
     apb06              = apb_pkg6::apb_env6::type_id::create("apb06",this);
     uart06             = uart_pkg6::uart_env6::type_id::create("uart06",this);
     uart16             = uart_pkg6::uart_env6::type_id::create("uart16",this);
     spi06              = spi_pkg6::spi_env6::type_id::create("spi06",this);
     gpio06             = gpio_pkg6::gpio_env6::type_id::create("gpio06",this);
     apb_ss_env6        = apb_subsystem_env6::type_id::create("apb_ss_env6",this);

  //UVM_REG
  ahb_predictor6 = uvm_reg_predictor#(ahb_transfer6)::type_id::create("ahb_predictor6", this);
  if (reg_model_apb6 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb6 = apb_ss_reg_model_c6::type_id::create("reg_model_apb6");
    reg_model_apb6.build();  //NOTE6: not same as build_phase: reg_model6 is an object
    reg_model_apb6.lock_model();
  end
    // set the register model for the rest6 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb6", reg_model_apb6);
    uvm_config_object::set(this, "*uart06*", "reg_model6", reg_model_apb6.uart0_rm6);
    uvm_config_object::set(this, "*uart16*", "reg_model6", reg_model_apb6.uart1_rm6);


  endfunction : build_env6

  function void connect_phase(uvm_phase phase);
    ahb_monitor6 user_ahb_monitor6;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb6 = reg_to_ahb_adapter6::type_id::create("reg2ahb6");
    reg_model_apb6.default_map.set_sequencer(ahb06.master_agent6.sequencer, reg2ahb6);  //
    reg_model_apb6.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor6, ahb06.master_agent6.monitor6))
        `uvm_fatal("CASTFL6", "Failed6 to cast master6 monitor6 to user_ahb_monitor6");

      // ***********************************************************
      //  Hookup6 virtual sequencer to interface sequencers6
      // ***********************************************************
        virtual_sequencer6.ahb_seqr6 =  ahb06.master_agent6.sequencer;
      if (uart06.Tx6.is_active == UVM_ACTIVE)  
        virtual_sequencer6.uart0_seqr6 =  uart06.Tx6.sequencer;
      if (uart16.Tx6.is_active == UVM_ACTIVE)  
        virtual_sequencer6.uart1_seqr6 =  uart16.Tx6.sequencer;
      if (spi06.agents6[0].is_active == UVM_ACTIVE)  
        virtual_sequencer6.spi0_seqr6 =  spi06.agents6[0].sequencer;
      if (gpio06.agents6[0].is_active == UVM_ACTIVE)  
        virtual_sequencer6.gpio0_seqr6 =  gpio06.agents6[0].sequencer;

      virtual_sequencer6.reg_model_ptr6 = reg_model_apb6;

      apb_ss_env6.monitor6.set_slave_config6(apb_ss_cfg6.uart_cfg06.apb_cfg6.slave_configs6[0]);
      apb_ss_env6.apb_uart06.set_slave_config6(apb_ss_cfg6.uart_cfg06.apb_cfg6.slave_configs6[1], 1);
      apb_ss_env6.apb_uart16.set_slave_config6(apb_ss_cfg6.uart_cfg16.apb_cfg6.slave_configs6[3], 3);

      // ***********************************************************
      // Connect6 TLM ports6
      // ***********************************************************
      uart06.Rx6.monitor6.frame_collected_port6.connect(apb_ss_env6.apb_uart06.monitor6.uart_rx_in6);
      uart06.Tx6.monitor6.frame_collected_port6.connect(apb_ss_env6.apb_uart06.monitor6.uart_tx_in6);
      apb06.bus_monitor6.item_collected_port6.connect(apb_ss_env6.apb_uart06.monitor6.apb_in6);
      apb06.bus_monitor6.item_collected_port6.connect(apb_ss_env6.apb_uart06.apb_in6);
      user_ahb_monitor6.ahb_transfer_out6.connect(apb_ss_env6.monitor6.rx_scbd6.ahb_add6);
      user_ahb_monitor6.ahb_transfer_out6.connect(apb_ss_env6.ahb_in6);
      spi06.agents6[0].monitor6.item_collected_port6.connect(apb_ss_env6.monitor6.rx_scbd6.spi_match6);


      uart16.Rx6.monitor6.frame_collected_port6.connect(apb_ss_env6.apb_uart16.monitor6.uart_rx_in6);
      uart16.Tx6.monitor6.frame_collected_port6.connect(apb_ss_env6.apb_uart16.monitor6.uart_tx_in6);
      apb06.bus_monitor6.item_collected_port6.connect(apb_ss_env6.apb_uart16.monitor6.apb_in6);
      apb06.bus_monitor6.item_collected_port6.connect(apb_ss_env6.apb_uart16.apb_in6);

      // ***********************************************************
      // Connect6 the dut_csr6 ports6
      // ***********************************************************
      apb_ss_env6.spi_csr_out6.connect(apb_ss_env6.monitor6.dut_csr_port_in6);
      apb_ss_env6.spi_csr_out6.connect(spi06.dut_csr_port_in6);
      apb_ss_env6.gpio_csr_out6.connect(gpio06.dut_csr_port_in6);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env6();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY6",("APB6 SubSystem6 Virtual Sequence Testbench6 Topology6:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("                         _____6                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("                        | AHB6 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("                        | UVC6 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("                   ____________6    _________6               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("                  | AHB6 - APB6  |  | APB6 UVC6 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("                  |   Bridge6   |  | Passive6 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("  _____6    _____6    ______6    _______6    _____6    _______6  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",(" | SPI6 |  | SMC6 |  | GPIO6 |  | UART06 |  | PCM6 |  | UART16 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("  _____6              ______6    _______6            _______6  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",(" | SPI6 |            | GPIO6 |  | UART06 |          | UART16 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",(" | UVC6 |            | UVC6  |  |  UVC6  |          |  UVC6  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY6",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER6 MODEL6:\n", reg_model_apb6.sprint()}, UVM_LOW)
  endtask

endclass
