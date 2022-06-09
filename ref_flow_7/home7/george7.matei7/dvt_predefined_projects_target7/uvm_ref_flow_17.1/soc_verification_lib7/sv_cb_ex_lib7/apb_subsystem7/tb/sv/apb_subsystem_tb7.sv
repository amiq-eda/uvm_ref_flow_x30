/*-------------------------------------------------------------------------
File7 name   : apb_subsystem_top_tb7.sv
Title7       : Simulation7 and Verification7 Environment7
Project7     :
Created7     :
Description7 : This7 file implements7 the SVE7 for the AHB7-UART7 Environment7
Notes7       : The apb_subsystem_tb7 creates7 the UART7 env7, the 
            : APB7 env7 and the scoreboard7. It also randomizes7 the UART7 
            : CSR7 settings7 and passes7 it to both the env7's.
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation7 Verification7 Environment7 (SVE7)
//--------------------------------------------------------------
class apb_subsystem_tb7 extends uvm_env;

  apb_subsystem_virtual_sequencer7 virtual_sequencer7;  // multi-channel7 sequencer
  ahb_pkg7::ahb_env7 ahb07;                          // AHB7 UVC7
  apb_pkg7::apb_env7 apb07;                          // APB7 UVC7
  uart_pkg7::uart_env7 uart07;                   // UART7 UVC7 connected7 to UART07
  uart_pkg7::uart_env7 uart17;                   // UART7 UVC7 connected7 to UART17
  spi_pkg7::spi_env7 spi07;                      // SPI7 UVC7 connected7 to SPI07
  gpio_pkg7::gpio_env7 gpio07;                   // GPIO7 UVC7 connected7 to GPIO07
  apb_subsystem_env7 apb_ss_env7;

  // UVM_REG
  apb_ss_reg_model_c7 reg_model_apb7;    // Register Model7
  reg_to_ahb_adapter7 reg2ahb7;         // Adapter Object - REG to APB7
  uvm_reg_predictor#(ahb_transfer7) ahb_predictor7; //Predictor7 - APB7 to REG

  apb_subsystem_pkg7::apb_subsystem_config7 apb_ss_cfg7;

  // enable automation7 for  apb_subsystem_tb7
  `uvm_component_utils_begin(apb_subsystem_tb7)
     `uvm_field_object(reg_model_apb7, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb7, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg7, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb7", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env7();
     // Configure7 UVCs7
    if (!uvm_config_db#(apb_subsystem_config7)::get(this, "", "apb_ss_cfg7", apb_ss_cfg7)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config7, creating7...", UVM_LOW)
      apb_ss_cfg7 = apb_subsystem_config7::type_id::create("apb_ss_cfg7", this);
      apb_ss_cfg7.uart_cfg07.apb_cfg7.add_master7("master7", UVM_PASSIVE);
      apb_ss_cfg7.uart_cfg07.apb_cfg7.add_slave7("spi07",  `AM_SPI0_BASE_ADDRESS7,  `AM_SPI0_END_ADDRESS7,  0, UVM_PASSIVE);
      apb_ss_cfg7.uart_cfg07.apb_cfg7.add_slave7("uart07", `AM_UART0_BASE_ADDRESS7, `AM_UART0_END_ADDRESS7, 0, UVM_PASSIVE);
      apb_ss_cfg7.uart_cfg07.apb_cfg7.add_slave7("gpio07", `AM_GPIO0_BASE_ADDRESS7, `AM_GPIO0_END_ADDRESS7, 0, UVM_PASSIVE);
      apb_ss_cfg7.uart_cfg07.apb_cfg7.add_slave7("uart17", `AM_UART1_BASE_ADDRESS7, `AM_UART1_END_ADDRESS7, 1, UVM_PASSIVE);
      apb_ss_cfg7.uart_cfg17.apb_cfg7.add_master7("master7", UVM_PASSIVE);
      apb_ss_cfg7.uart_cfg17.apb_cfg7.add_slave7("spi07",  `AM_SPI0_BASE_ADDRESS7,  `AM_SPI0_END_ADDRESS7,  0, UVM_PASSIVE);
      apb_ss_cfg7.uart_cfg17.apb_cfg7.add_slave7("uart07", `AM_UART0_BASE_ADDRESS7, `AM_UART0_END_ADDRESS7, 0, UVM_PASSIVE);
      apb_ss_cfg7.uart_cfg17.apb_cfg7.add_slave7("gpio07", `AM_GPIO0_BASE_ADDRESS7, `AM_GPIO0_END_ADDRESS7, 0, UVM_PASSIVE);
      apb_ss_cfg7.uart_cfg17.apb_cfg7.add_slave7("uart17", `AM_UART1_BASE_ADDRESS7, `AM_UART1_END_ADDRESS7, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing7 apb7 subsystem7 config:\n", apb_ss_cfg7.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config7)::set(this, "apb07", "cfg", apb_ss_cfg7.uart_cfg07.apb_cfg7);
     uvm_config_db#(uart_config7)::set(this, "uart07", "cfg", apb_ss_cfg7.uart_cfg07.uart_cfg7);
     uvm_config_db#(uart_config7)::set(this, "uart17", "cfg", apb_ss_cfg7.uart_cfg17.uart_cfg7);
     uvm_config_db#(uart_ctrl_config7)::set(this, "apb_ss_env7.apb_uart07", "cfg", apb_ss_cfg7.uart_cfg07);
     uvm_config_db#(uart_ctrl_config7)::set(this, "apb_ss_env7.apb_uart17", "cfg", apb_ss_cfg7.uart_cfg17);
     uvm_config_db#(apb_slave_config7)::set(this, "apb_ss_env7.apb_uart07", "apb_slave_cfg7", apb_ss_cfg7.uart_cfg07.apb_cfg7.slave_configs7[1]);
     uvm_config_db#(apb_slave_config7)::set(this, "apb_ss_env7.apb_uart17", "apb_slave_cfg7", apb_ss_cfg7.uart_cfg17.apb_cfg7.slave_configs7[3]);
     set_config_object("spi07", "spi_ve_config7", apb_ss_cfg7.spi_cfg7, 0);
     set_config_object("gpio07", "gpio_ve_config7", apb_ss_cfg7.gpio_cfg7, 0);

     set_config_int("*spi07.agents7[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio07.agents7[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb07.master_agent7","is_active", UVM_ACTIVE);  
     set_config_int("*ahb07.slave_agent7","is_active", UVM_PASSIVE);
     set_config_int("*uart07.Tx7","is_active", UVM_ACTIVE);  
     set_config_int("*uart07.Rx7","is_active", UVM_PASSIVE);
     set_config_int("*uart17.Tx7","is_active", UVM_ACTIVE);  
     set_config_int("*uart17.Rx7","is_active", UVM_PASSIVE);

     // Allocate7 objects7
     virtual_sequencer7 = apb_subsystem_virtual_sequencer7::type_id::create("virtual_sequencer7",this);
     ahb07              = ahb_pkg7::ahb_env7::type_id::create("ahb07",this);
     apb07              = apb_pkg7::apb_env7::type_id::create("apb07",this);
     uart07             = uart_pkg7::uart_env7::type_id::create("uart07",this);
     uart17             = uart_pkg7::uart_env7::type_id::create("uart17",this);
     spi07              = spi_pkg7::spi_env7::type_id::create("spi07",this);
     gpio07             = gpio_pkg7::gpio_env7::type_id::create("gpio07",this);
     apb_ss_env7        = apb_subsystem_env7::type_id::create("apb_ss_env7",this);

  //UVM_REG
  ahb_predictor7 = uvm_reg_predictor#(ahb_transfer7)::type_id::create("ahb_predictor7", this);
  if (reg_model_apb7 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb7 = apb_ss_reg_model_c7::type_id::create("reg_model_apb7");
    reg_model_apb7.build();  //NOTE7: not same as build_phase: reg_model7 is an object
    reg_model_apb7.lock_model();
  end
    // set the register model for the rest7 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb7", reg_model_apb7);
    uvm_config_object::set(this, "*uart07*", "reg_model7", reg_model_apb7.uart0_rm7);
    uvm_config_object::set(this, "*uart17*", "reg_model7", reg_model_apb7.uart1_rm7);


  endfunction : build_env7

  function void connect_phase(uvm_phase phase);
    ahb_monitor7 user_ahb_monitor7;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb7 = reg_to_ahb_adapter7::type_id::create("reg2ahb7");
    reg_model_apb7.default_map.set_sequencer(ahb07.master_agent7.sequencer, reg2ahb7);  //
    reg_model_apb7.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor7, ahb07.master_agent7.monitor7))
        `uvm_fatal("CASTFL7", "Failed7 to cast master7 monitor7 to user_ahb_monitor7");

      // ***********************************************************
      //  Hookup7 virtual sequencer to interface sequencers7
      // ***********************************************************
        virtual_sequencer7.ahb_seqr7 =  ahb07.master_agent7.sequencer;
      if (uart07.Tx7.is_active == UVM_ACTIVE)  
        virtual_sequencer7.uart0_seqr7 =  uart07.Tx7.sequencer;
      if (uart17.Tx7.is_active == UVM_ACTIVE)  
        virtual_sequencer7.uart1_seqr7 =  uart17.Tx7.sequencer;
      if (spi07.agents7[0].is_active == UVM_ACTIVE)  
        virtual_sequencer7.spi0_seqr7 =  spi07.agents7[0].sequencer;
      if (gpio07.agents7[0].is_active == UVM_ACTIVE)  
        virtual_sequencer7.gpio0_seqr7 =  gpio07.agents7[0].sequencer;

      virtual_sequencer7.reg_model_ptr7 = reg_model_apb7;

      apb_ss_env7.monitor7.set_slave_config7(apb_ss_cfg7.uart_cfg07.apb_cfg7.slave_configs7[0]);
      apb_ss_env7.apb_uart07.set_slave_config7(apb_ss_cfg7.uart_cfg07.apb_cfg7.slave_configs7[1], 1);
      apb_ss_env7.apb_uart17.set_slave_config7(apb_ss_cfg7.uart_cfg17.apb_cfg7.slave_configs7[3], 3);

      // ***********************************************************
      // Connect7 TLM ports7
      // ***********************************************************
      uart07.Rx7.monitor7.frame_collected_port7.connect(apb_ss_env7.apb_uart07.monitor7.uart_rx_in7);
      uart07.Tx7.monitor7.frame_collected_port7.connect(apb_ss_env7.apb_uart07.monitor7.uart_tx_in7);
      apb07.bus_monitor7.item_collected_port7.connect(apb_ss_env7.apb_uart07.monitor7.apb_in7);
      apb07.bus_monitor7.item_collected_port7.connect(apb_ss_env7.apb_uart07.apb_in7);
      user_ahb_monitor7.ahb_transfer_out7.connect(apb_ss_env7.monitor7.rx_scbd7.ahb_add7);
      user_ahb_monitor7.ahb_transfer_out7.connect(apb_ss_env7.ahb_in7);
      spi07.agents7[0].monitor7.item_collected_port7.connect(apb_ss_env7.monitor7.rx_scbd7.spi_match7);


      uart17.Rx7.monitor7.frame_collected_port7.connect(apb_ss_env7.apb_uart17.monitor7.uart_rx_in7);
      uart17.Tx7.monitor7.frame_collected_port7.connect(apb_ss_env7.apb_uart17.monitor7.uart_tx_in7);
      apb07.bus_monitor7.item_collected_port7.connect(apb_ss_env7.apb_uart17.monitor7.apb_in7);
      apb07.bus_monitor7.item_collected_port7.connect(apb_ss_env7.apb_uart17.apb_in7);

      // ***********************************************************
      // Connect7 the dut_csr7 ports7
      // ***********************************************************
      apb_ss_env7.spi_csr_out7.connect(apb_ss_env7.monitor7.dut_csr_port_in7);
      apb_ss_env7.spi_csr_out7.connect(spi07.dut_csr_port_in7);
      apb_ss_env7.gpio_csr_out7.connect(gpio07.dut_csr_port_in7);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env7();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY7",("APB7 SubSystem7 Virtual Sequence Testbench7 Topology7:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("                         _____7                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("                        | AHB7 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("                        | UVC7 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("                   ____________7    _________7               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("                  | AHB7 - APB7  |  | APB7 UVC7 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("                  |   Bridge7   |  | Passive7 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("  _____7    _____7    ______7    _______7    _____7    _______7  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",(" | SPI7 |  | SMC7 |  | GPIO7 |  | UART07 |  | PCM7 |  | UART17 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("  _____7              ______7    _______7            _______7  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",(" | SPI7 |            | GPIO7 |  | UART07 |          | UART17 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",(" | UVC7 |            | UVC7  |  |  UVC7  |          |  UVC7  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY7",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER7 MODEL7:\n", reg_model_apb7.sprint()}, UVM_LOW)
  endtask

endclass
