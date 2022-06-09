/*-------------------------------------------------------------------------
File24 name   : apb_subsystem_top_tb24.sv
Title24       : Simulation24 and Verification24 Environment24
Project24     :
Created24     :
Description24 : This24 file implements24 the SVE24 for the AHB24-UART24 Environment24
Notes24       : The apb_subsystem_tb24 creates24 the UART24 env24, the 
            : APB24 env24 and the scoreboard24. It also randomizes24 the UART24 
            : CSR24 settings24 and passes24 it to both the env24's.
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation24 Verification24 Environment24 (SVE24)
//--------------------------------------------------------------
class apb_subsystem_tb24 extends uvm_env;

  apb_subsystem_virtual_sequencer24 virtual_sequencer24;  // multi-channel24 sequencer
  ahb_pkg24::ahb_env24 ahb024;                          // AHB24 UVC24
  apb_pkg24::apb_env24 apb024;                          // APB24 UVC24
  uart_pkg24::uart_env24 uart024;                   // UART24 UVC24 connected24 to UART024
  uart_pkg24::uart_env24 uart124;                   // UART24 UVC24 connected24 to UART124
  spi_pkg24::spi_env24 spi024;                      // SPI24 UVC24 connected24 to SPI024
  gpio_pkg24::gpio_env24 gpio024;                   // GPIO24 UVC24 connected24 to GPIO024
  apb_subsystem_env24 apb_ss_env24;

  // UVM_REG
  apb_ss_reg_model_c24 reg_model_apb24;    // Register Model24
  reg_to_ahb_adapter24 reg2ahb24;         // Adapter Object - REG to APB24
  uvm_reg_predictor#(ahb_transfer24) ahb_predictor24; //Predictor24 - APB24 to REG

  apb_subsystem_pkg24::apb_subsystem_config24 apb_ss_cfg24;

  // enable automation24 for  apb_subsystem_tb24
  `uvm_component_utils_begin(apb_subsystem_tb24)
     `uvm_field_object(reg_model_apb24, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb24, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg24, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb24", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env24();
     // Configure24 UVCs24
    if (!uvm_config_db#(apb_subsystem_config24)::get(this, "", "apb_ss_cfg24", apb_ss_cfg24)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config24, creating24...", UVM_LOW)
      apb_ss_cfg24 = apb_subsystem_config24::type_id::create("apb_ss_cfg24", this);
      apb_ss_cfg24.uart_cfg024.apb_cfg24.add_master24("master24", UVM_PASSIVE);
      apb_ss_cfg24.uart_cfg024.apb_cfg24.add_slave24("spi024",  `AM_SPI0_BASE_ADDRESS24,  `AM_SPI0_END_ADDRESS24,  0, UVM_PASSIVE);
      apb_ss_cfg24.uart_cfg024.apb_cfg24.add_slave24("uart024", `AM_UART0_BASE_ADDRESS24, `AM_UART0_END_ADDRESS24, 0, UVM_PASSIVE);
      apb_ss_cfg24.uart_cfg024.apb_cfg24.add_slave24("gpio024", `AM_GPIO0_BASE_ADDRESS24, `AM_GPIO0_END_ADDRESS24, 0, UVM_PASSIVE);
      apb_ss_cfg24.uart_cfg024.apb_cfg24.add_slave24("uart124", `AM_UART1_BASE_ADDRESS24, `AM_UART1_END_ADDRESS24, 1, UVM_PASSIVE);
      apb_ss_cfg24.uart_cfg124.apb_cfg24.add_master24("master24", UVM_PASSIVE);
      apb_ss_cfg24.uart_cfg124.apb_cfg24.add_slave24("spi024",  `AM_SPI0_BASE_ADDRESS24,  `AM_SPI0_END_ADDRESS24,  0, UVM_PASSIVE);
      apb_ss_cfg24.uart_cfg124.apb_cfg24.add_slave24("uart024", `AM_UART0_BASE_ADDRESS24, `AM_UART0_END_ADDRESS24, 0, UVM_PASSIVE);
      apb_ss_cfg24.uart_cfg124.apb_cfg24.add_slave24("gpio024", `AM_GPIO0_BASE_ADDRESS24, `AM_GPIO0_END_ADDRESS24, 0, UVM_PASSIVE);
      apb_ss_cfg24.uart_cfg124.apb_cfg24.add_slave24("uart124", `AM_UART1_BASE_ADDRESS24, `AM_UART1_END_ADDRESS24, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing24 apb24 subsystem24 config:\n", apb_ss_cfg24.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config24)::set(this, "apb024", "cfg", apb_ss_cfg24.uart_cfg024.apb_cfg24);
     uvm_config_db#(uart_config24)::set(this, "uart024", "cfg", apb_ss_cfg24.uart_cfg024.uart_cfg24);
     uvm_config_db#(uart_config24)::set(this, "uart124", "cfg", apb_ss_cfg24.uart_cfg124.uart_cfg24);
     uvm_config_db#(uart_ctrl_config24)::set(this, "apb_ss_env24.apb_uart024", "cfg", apb_ss_cfg24.uart_cfg024);
     uvm_config_db#(uart_ctrl_config24)::set(this, "apb_ss_env24.apb_uart124", "cfg", apb_ss_cfg24.uart_cfg124);
     uvm_config_db#(apb_slave_config24)::set(this, "apb_ss_env24.apb_uart024", "apb_slave_cfg24", apb_ss_cfg24.uart_cfg024.apb_cfg24.slave_configs24[1]);
     uvm_config_db#(apb_slave_config24)::set(this, "apb_ss_env24.apb_uart124", "apb_slave_cfg24", apb_ss_cfg24.uart_cfg124.apb_cfg24.slave_configs24[3]);
     set_config_object("spi024", "spi_ve_config24", apb_ss_cfg24.spi_cfg24, 0);
     set_config_object("gpio024", "gpio_ve_config24", apb_ss_cfg24.gpio_cfg24, 0);

     set_config_int("*spi024.agents24[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio024.agents24[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb024.master_agent24","is_active", UVM_ACTIVE);  
     set_config_int("*ahb024.slave_agent24","is_active", UVM_PASSIVE);
     set_config_int("*uart024.Tx24","is_active", UVM_ACTIVE);  
     set_config_int("*uart024.Rx24","is_active", UVM_PASSIVE);
     set_config_int("*uart124.Tx24","is_active", UVM_ACTIVE);  
     set_config_int("*uart124.Rx24","is_active", UVM_PASSIVE);

     // Allocate24 objects24
     virtual_sequencer24 = apb_subsystem_virtual_sequencer24::type_id::create("virtual_sequencer24",this);
     ahb024              = ahb_pkg24::ahb_env24::type_id::create("ahb024",this);
     apb024              = apb_pkg24::apb_env24::type_id::create("apb024",this);
     uart024             = uart_pkg24::uart_env24::type_id::create("uart024",this);
     uart124             = uart_pkg24::uart_env24::type_id::create("uart124",this);
     spi024              = spi_pkg24::spi_env24::type_id::create("spi024",this);
     gpio024             = gpio_pkg24::gpio_env24::type_id::create("gpio024",this);
     apb_ss_env24        = apb_subsystem_env24::type_id::create("apb_ss_env24",this);

  //UVM_REG
  ahb_predictor24 = uvm_reg_predictor#(ahb_transfer24)::type_id::create("ahb_predictor24", this);
  if (reg_model_apb24 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb24 = apb_ss_reg_model_c24::type_id::create("reg_model_apb24");
    reg_model_apb24.build();  //NOTE24: not same as build_phase: reg_model24 is an object
    reg_model_apb24.lock_model();
  end
    // set the register model for the rest24 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb24", reg_model_apb24);
    uvm_config_object::set(this, "*uart024*", "reg_model24", reg_model_apb24.uart0_rm24);
    uvm_config_object::set(this, "*uart124*", "reg_model24", reg_model_apb24.uart1_rm24);


  endfunction : build_env24

  function void connect_phase(uvm_phase phase);
    ahb_monitor24 user_ahb_monitor24;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb24 = reg_to_ahb_adapter24::type_id::create("reg2ahb24");
    reg_model_apb24.default_map.set_sequencer(ahb024.master_agent24.sequencer, reg2ahb24);  //
    reg_model_apb24.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor24, ahb024.master_agent24.monitor24))
        `uvm_fatal("CASTFL24", "Failed24 to cast master24 monitor24 to user_ahb_monitor24");

      // ***********************************************************
      //  Hookup24 virtual sequencer to interface sequencers24
      // ***********************************************************
        virtual_sequencer24.ahb_seqr24 =  ahb024.master_agent24.sequencer;
      if (uart024.Tx24.is_active == UVM_ACTIVE)  
        virtual_sequencer24.uart0_seqr24 =  uart024.Tx24.sequencer;
      if (uart124.Tx24.is_active == UVM_ACTIVE)  
        virtual_sequencer24.uart1_seqr24 =  uart124.Tx24.sequencer;
      if (spi024.agents24[0].is_active == UVM_ACTIVE)  
        virtual_sequencer24.spi0_seqr24 =  spi024.agents24[0].sequencer;
      if (gpio024.agents24[0].is_active == UVM_ACTIVE)  
        virtual_sequencer24.gpio0_seqr24 =  gpio024.agents24[0].sequencer;

      virtual_sequencer24.reg_model_ptr24 = reg_model_apb24;

      apb_ss_env24.monitor24.set_slave_config24(apb_ss_cfg24.uart_cfg024.apb_cfg24.slave_configs24[0]);
      apb_ss_env24.apb_uart024.set_slave_config24(apb_ss_cfg24.uart_cfg024.apb_cfg24.slave_configs24[1], 1);
      apb_ss_env24.apb_uart124.set_slave_config24(apb_ss_cfg24.uart_cfg124.apb_cfg24.slave_configs24[3], 3);

      // ***********************************************************
      // Connect24 TLM ports24
      // ***********************************************************
      uart024.Rx24.monitor24.frame_collected_port24.connect(apb_ss_env24.apb_uart024.monitor24.uart_rx_in24);
      uart024.Tx24.monitor24.frame_collected_port24.connect(apb_ss_env24.apb_uart024.monitor24.uart_tx_in24);
      apb024.bus_monitor24.item_collected_port24.connect(apb_ss_env24.apb_uart024.monitor24.apb_in24);
      apb024.bus_monitor24.item_collected_port24.connect(apb_ss_env24.apb_uart024.apb_in24);
      user_ahb_monitor24.ahb_transfer_out24.connect(apb_ss_env24.monitor24.rx_scbd24.ahb_add24);
      user_ahb_monitor24.ahb_transfer_out24.connect(apb_ss_env24.ahb_in24);
      spi024.agents24[0].monitor24.item_collected_port24.connect(apb_ss_env24.monitor24.rx_scbd24.spi_match24);


      uart124.Rx24.monitor24.frame_collected_port24.connect(apb_ss_env24.apb_uart124.monitor24.uart_rx_in24);
      uart124.Tx24.monitor24.frame_collected_port24.connect(apb_ss_env24.apb_uart124.monitor24.uart_tx_in24);
      apb024.bus_monitor24.item_collected_port24.connect(apb_ss_env24.apb_uart124.monitor24.apb_in24);
      apb024.bus_monitor24.item_collected_port24.connect(apb_ss_env24.apb_uart124.apb_in24);

      // ***********************************************************
      // Connect24 the dut_csr24 ports24
      // ***********************************************************
      apb_ss_env24.spi_csr_out24.connect(apb_ss_env24.monitor24.dut_csr_port_in24);
      apb_ss_env24.spi_csr_out24.connect(spi024.dut_csr_port_in24);
      apb_ss_env24.gpio_csr_out24.connect(gpio024.dut_csr_port_in24);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env24();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY24",("APB24 SubSystem24 Virtual Sequence Testbench24 Topology24:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("                         _____24                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("                        | AHB24 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("                        | UVC24 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("                   ____________24    _________24               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("                  | AHB24 - APB24  |  | APB24 UVC24 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("                  |   Bridge24   |  | Passive24 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("  _____24    _____24    ______24    _______24    _____24    _______24  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",(" | SPI24 |  | SMC24 |  | GPIO24 |  | UART024 |  | PCM24 |  | UART124 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("  _____24              ______24    _______24            _______24  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",(" | SPI24 |            | GPIO24 |  | UART024 |          | UART124 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",(" | UVC24 |            | UVC24  |  |  UVC24  |          |  UVC24  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY24",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER24 MODEL24:\n", reg_model_apb24.sprint()}, UVM_LOW)
  endtask

endclass
