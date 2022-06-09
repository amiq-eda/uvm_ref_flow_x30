/*-------------------------------------------------------------------------
File25 name   : apb_subsystem_top_tb25.sv
Title25       : Simulation25 and Verification25 Environment25
Project25     :
Created25     :
Description25 : This25 file implements25 the SVE25 for the AHB25-UART25 Environment25
Notes25       : The apb_subsystem_tb25 creates25 the UART25 env25, the 
            : APB25 env25 and the scoreboard25. It also randomizes25 the UART25 
            : CSR25 settings25 and passes25 it to both the env25's.
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation25 Verification25 Environment25 (SVE25)
//--------------------------------------------------------------
class apb_subsystem_tb25 extends uvm_env;

  apb_subsystem_virtual_sequencer25 virtual_sequencer25;  // multi-channel25 sequencer
  ahb_pkg25::ahb_env25 ahb025;                          // AHB25 UVC25
  apb_pkg25::apb_env25 apb025;                          // APB25 UVC25
  uart_pkg25::uart_env25 uart025;                   // UART25 UVC25 connected25 to UART025
  uart_pkg25::uart_env25 uart125;                   // UART25 UVC25 connected25 to UART125
  spi_pkg25::spi_env25 spi025;                      // SPI25 UVC25 connected25 to SPI025
  gpio_pkg25::gpio_env25 gpio025;                   // GPIO25 UVC25 connected25 to GPIO025
  apb_subsystem_env25 apb_ss_env25;

  // UVM_REG
  apb_ss_reg_model_c25 reg_model_apb25;    // Register Model25
  reg_to_ahb_adapter25 reg2ahb25;         // Adapter Object - REG to APB25
  uvm_reg_predictor#(ahb_transfer25) ahb_predictor25; //Predictor25 - APB25 to REG

  apb_subsystem_pkg25::apb_subsystem_config25 apb_ss_cfg25;

  // enable automation25 for  apb_subsystem_tb25
  `uvm_component_utils_begin(apb_subsystem_tb25)
     `uvm_field_object(reg_model_apb25, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb25, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg25, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb25", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env25();
     // Configure25 UVCs25
    if (!uvm_config_db#(apb_subsystem_config25)::get(this, "", "apb_ss_cfg25", apb_ss_cfg25)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config25, creating25...", UVM_LOW)
      apb_ss_cfg25 = apb_subsystem_config25::type_id::create("apb_ss_cfg25", this);
      apb_ss_cfg25.uart_cfg025.apb_cfg25.add_master25("master25", UVM_PASSIVE);
      apb_ss_cfg25.uart_cfg025.apb_cfg25.add_slave25("spi025",  `AM_SPI0_BASE_ADDRESS25,  `AM_SPI0_END_ADDRESS25,  0, UVM_PASSIVE);
      apb_ss_cfg25.uart_cfg025.apb_cfg25.add_slave25("uart025", `AM_UART0_BASE_ADDRESS25, `AM_UART0_END_ADDRESS25, 0, UVM_PASSIVE);
      apb_ss_cfg25.uart_cfg025.apb_cfg25.add_slave25("gpio025", `AM_GPIO0_BASE_ADDRESS25, `AM_GPIO0_END_ADDRESS25, 0, UVM_PASSIVE);
      apb_ss_cfg25.uart_cfg025.apb_cfg25.add_slave25("uart125", `AM_UART1_BASE_ADDRESS25, `AM_UART1_END_ADDRESS25, 1, UVM_PASSIVE);
      apb_ss_cfg25.uart_cfg125.apb_cfg25.add_master25("master25", UVM_PASSIVE);
      apb_ss_cfg25.uart_cfg125.apb_cfg25.add_slave25("spi025",  `AM_SPI0_BASE_ADDRESS25,  `AM_SPI0_END_ADDRESS25,  0, UVM_PASSIVE);
      apb_ss_cfg25.uart_cfg125.apb_cfg25.add_slave25("uart025", `AM_UART0_BASE_ADDRESS25, `AM_UART0_END_ADDRESS25, 0, UVM_PASSIVE);
      apb_ss_cfg25.uart_cfg125.apb_cfg25.add_slave25("gpio025", `AM_GPIO0_BASE_ADDRESS25, `AM_GPIO0_END_ADDRESS25, 0, UVM_PASSIVE);
      apb_ss_cfg25.uart_cfg125.apb_cfg25.add_slave25("uart125", `AM_UART1_BASE_ADDRESS25, `AM_UART1_END_ADDRESS25, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing25 apb25 subsystem25 config:\n", apb_ss_cfg25.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config25)::set(this, "apb025", "cfg", apb_ss_cfg25.uart_cfg025.apb_cfg25);
     uvm_config_db#(uart_config25)::set(this, "uart025", "cfg", apb_ss_cfg25.uart_cfg025.uart_cfg25);
     uvm_config_db#(uart_config25)::set(this, "uart125", "cfg", apb_ss_cfg25.uart_cfg125.uart_cfg25);
     uvm_config_db#(uart_ctrl_config25)::set(this, "apb_ss_env25.apb_uart025", "cfg", apb_ss_cfg25.uart_cfg025);
     uvm_config_db#(uart_ctrl_config25)::set(this, "apb_ss_env25.apb_uart125", "cfg", apb_ss_cfg25.uart_cfg125);
     uvm_config_db#(apb_slave_config25)::set(this, "apb_ss_env25.apb_uart025", "apb_slave_cfg25", apb_ss_cfg25.uart_cfg025.apb_cfg25.slave_configs25[1]);
     uvm_config_db#(apb_slave_config25)::set(this, "apb_ss_env25.apb_uart125", "apb_slave_cfg25", apb_ss_cfg25.uart_cfg125.apb_cfg25.slave_configs25[3]);
     set_config_object("spi025", "spi_ve_config25", apb_ss_cfg25.spi_cfg25, 0);
     set_config_object("gpio025", "gpio_ve_config25", apb_ss_cfg25.gpio_cfg25, 0);

     set_config_int("*spi025.agents25[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio025.agents25[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb025.master_agent25","is_active", UVM_ACTIVE);  
     set_config_int("*ahb025.slave_agent25","is_active", UVM_PASSIVE);
     set_config_int("*uart025.Tx25","is_active", UVM_ACTIVE);  
     set_config_int("*uart025.Rx25","is_active", UVM_PASSIVE);
     set_config_int("*uart125.Tx25","is_active", UVM_ACTIVE);  
     set_config_int("*uart125.Rx25","is_active", UVM_PASSIVE);

     // Allocate25 objects25
     virtual_sequencer25 = apb_subsystem_virtual_sequencer25::type_id::create("virtual_sequencer25",this);
     ahb025              = ahb_pkg25::ahb_env25::type_id::create("ahb025",this);
     apb025              = apb_pkg25::apb_env25::type_id::create("apb025",this);
     uart025             = uart_pkg25::uart_env25::type_id::create("uart025",this);
     uart125             = uart_pkg25::uart_env25::type_id::create("uart125",this);
     spi025              = spi_pkg25::spi_env25::type_id::create("spi025",this);
     gpio025             = gpio_pkg25::gpio_env25::type_id::create("gpio025",this);
     apb_ss_env25        = apb_subsystem_env25::type_id::create("apb_ss_env25",this);

  //UVM_REG
  ahb_predictor25 = uvm_reg_predictor#(ahb_transfer25)::type_id::create("ahb_predictor25", this);
  if (reg_model_apb25 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb25 = apb_ss_reg_model_c25::type_id::create("reg_model_apb25");
    reg_model_apb25.build();  //NOTE25: not same as build_phase: reg_model25 is an object
    reg_model_apb25.lock_model();
  end
    // set the register model for the rest25 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb25", reg_model_apb25);
    uvm_config_object::set(this, "*uart025*", "reg_model25", reg_model_apb25.uart0_rm25);
    uvm_config_object::set(this, "*uart125*", "reg_model25", reg_model_apb25.uart1_rm25);


  endfunction : build_env25

  function void connect_phase(uvm_phase phase);
    ahb_monitor25 user_ahb_monitor25;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb25 = reg_to_ahb_adapter25::type_id::create("reg2ahb25");
    reg_model_apb25.default_map.set_sequencer(ahb025.master_agent25.sequencer, reg2ahb25);  //
    reg_model_apb25.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor25, ahb025.master_agent25.monitor25))
        `uvm_fatal("CASTFL25", "Failed25 to cast master25 monitor25 to user_ahb_monitor25");

      // ***********************************************************
      //  Hookup25 virtual sequencer to interface sequencers25
      // ***********************************************************
        virtual_sequencer25.ahb_seqr25 =  ahb025.master_agent25.sequencer;
      if (uart025.Tx25.is_active == UVM_ACTIVE)  
        virtual_sequencer25.uart0_seqr25 =  uart025.Tx25.sequencer;
      if (uart125.Tx25.is_active == UVM_ACTIVE)  
        virtual_sequencer25.uart1_seqr25 =  uart125.Tx25.sequencer;
      if (spi025.agents25[0].is_active == UVM_ACTIVE)  
        virtual_sequencer25.spi0_seqr25 =  spi025.agents25[0].sequencer;
      if (gpio025.agents25[0].is_active == UVM_ACTIVE)  
        virtual_sequencer25.gpio0_seqr25 =  gpio025.agents25[0].sequencer;

      virtual_sequencer25.reg_model_ptr25 = reg_model_apb25;

      apb_ss_env25.monitor25.set_slave_config25(apb_ss_cfg25.uart_cfg025.apb_cfg25.slave_configs25[0]);
      apb_ss_env25.apb_uart025.set_slave_config25(apb_ss_cfg25.uart_cfg025.apb_cfg25.slave_configs25[1], 1);
      apb_ss_env25.apb_uart125.set_slave_config25(apb_ss_cfg25.uart_cfg125.apb_cfg25.slave_configs25[3], 3);

      // ***********************************************************
      // Connect25 TLM ports25
      // ***********************************************************
      uart025.Rx25.monitor25.frame_collected_port25.connect(apb_ss_env25.apb_uart025.monitor25.uart_rx_in25);
      uart025.Tx25.monitor25.frame_collected_port25.connect(apb_ss_env25.apb_uart025.monitor25.uart_tx_in25);
      apb025.bus_monitor25.item_collected_port25.connect(apb_ss_env25.apb_uart025.monitor25.apb_in25);
      apb025.bus_monitor25.item_collected_port25.connect(apb_ss_env25.apb_uart025.apb_in25);
      user_ahb_monitor25.ahb_transfer_out25.connect(apb_ss_env25.monitor25.rx_scbd25.ahb_add25);
      user_ahb_monitor25.ahb_transfer_out25.connect(apb_ss_env25.ahb_in25);
      spi025.agents25[0].monitor25.item_collected_port25.connect(apb_ss_env25.monitor25.rx_scbd25.spi_match25);


      uart125.Rx25.monitor25.frame_collected_port25.connect(apb_ss_env25.apb_uart125.monitor25.uart_rx_in25);
      uart125.Tx25.monitor25.frame_collected_port25.connect(apb_ss_env25.apb_uart125.monitor25.uart_tx_in25);
      apb025.bus_monitor25.item_collected_port25.connect(apb_ss_env25.apb_uart125.monitor25.apb_in25);
      apb025.bus_monitor25.item_collected_port25.connect(apb_ss_env25.apb_uart125.apb_in25);

      // ***********************************************************
      // Connect25 the dut_csr25 ports25
      // ***********************************************************
      apb_ss_env25.spi_csr_out25.connect(apb_ss_env25.monitor25.dut_csr_port_in25);
      apb_ss_env25.spi_csr_out25.connect(spi025.dut_csr_port_in25);
      apb_ss_env25.gpio_csr_out25.connect(gpio025.dut_csr_port_in25);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env25();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY25",("APB25 SubSystem25 Virtual Sequence Testbench25 Topology25:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("                         _____25                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("                        | AHB25 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("                        | UVC25 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("                   ____________25    _________25               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("                  | AHB25 - APB25  |  | APB25 UVC25 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("                  |   Bridge25   |  | Passive25 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("  _____25    _____25    ______25    _______25    _____25    _______25  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",(" | SPI25 |  | SMC25 |  | GPIO25 |  | UART025 |  | PCM25 |  | UART125 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("  _____25              ______25    _______25            _______25  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",(" | SPI25 |            | GPIO25 |  | UART025 |          | UART125 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",(" | UVC25 |            | UVC25  |  |  UVC25  |          |  UVC25  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY25",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER25 MODEL25:\n", reg_model_apb25.sprint()}, UVM_LOW)
  endtask

endclass
