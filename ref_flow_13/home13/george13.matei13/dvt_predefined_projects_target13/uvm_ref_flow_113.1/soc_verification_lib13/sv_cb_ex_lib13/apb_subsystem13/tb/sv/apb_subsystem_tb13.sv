/*-------------------------------------------------------------------------
File13 name   : apb_subsystem_top_tb13.sv
Title13       : Simulation13 and Verification13 Environment13
Project13     :
Created13     :
Description13 : This13 file implements13 the SVE13 for the AHB13-UART13 Environment13
Notes13       : The apb_subsystem_tb13 creates13 the UART13 env13, the 
            : APB13 env13 and the scoreboard13. It also randomizes13 the UART13 
            : CSR13 settings13 and passes13 it to both the env13's.
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation13 Verification13 Environment13 (SVE13)
//--------------------------------------------------------------
class apb_subsystem_tb13 extends uvm_env;

  apb_subsystem_virtual_sequencer13 virtual_sequencer13;  // multi-channel13 sequencer
  ahb_pkg13::ahb_env13 ahb013;                          // AHB13 UVC13
  apb_pkg13::apb_env13 apb013;                          // APB13 UVC13
  uart_pkg13::uart_env13 uart013;                   // UART13 UVC13 connected13 to UART013
  uart_pkg13::uart_env13 uart113;                   // UART13 UVC13 connected13 to UART113
  spi_pkg13::spi_env13 spi013;                      // SPI13 UVC13 connected13 to SPI013
  gpio_pkg13::gpio_env13 gpio013;                   // GPIO13 UVC13 connected13 to GPIO013
  apb_subsystem_env13 apb_ss_env13;

  // UVM_REG
  apb_ss_reg_model_c13 reg_model_apb13;    // Register Model13
  reg_to_ahb_adapter13 reg2ahb13;         // Adapter Object - REG to APB13
  uvm_reg_predictor#(ahb_transfer13) ahb_predictor13; //Predictor13 - APB13 to REG

  apb_subsystem_pkg13::apb_subsystem_config13 apb_ss_cfg13;

  // enable automation13 for  apb_subsystem_tb13
  `uvm_component_utils_begin(apb_subsystem_tb13)
     `uvm_field_object(reg_model_apb13, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb13, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg13, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb13", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env13();
     // Configure13 UVCs13
    if (!uvm_config_db#(apb_subsystem_config13)::get(this, "", "apb_ss_cfg13", apb_ss_cfg13)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config13, creating13...", UVM_LOW)
      apb_ss_cfg13 = apb_subsystem_config13::type_id::create("apb_ss_cfg13", this);
      apb_ss_cfg13.uart_cfg013.apb_cfg13.add_master13("master13", UVM_PASSIVE);
      apb_ss_cfg13.uart_cfg013.apb_cfg13.add_slave13("spi013",  `AM_SPI0_BASE_ADDRESS13,  `AM_SPI0_END_ADDRESS13,  0, UVM_PASSIVE);
      apb_ss_cfg13.uart_cfg013.apb_cfg13.add_slave13("uart013", `AM_UART0_BASE_ADDRESS13, `AM_UART0_END_ADDRESS13, 0, UVM_PASSIVE);
      apb_ss_cfg13.uart_cfg013.apb_cfg13.add_slave13("gpio013", `AM_GPIO0_BASE_ADDRESS13, `AM_GPIO0_END_ADDRESS13, 0, UVM_PASSIVE);
      apb_ss_cfg13.uart_cfg013.apb_cfg13.add_slave13("uart113", `AM_UART1_BASE_ADDRESS13, `AM_UART1_END_ADDRESS13, 1, UVM_PASSIVE);
      apb_ss_cfg13.uart_cfg113.apb_cfg13.add_master13("master13", UVM_PASSIVE);
      apb_ss_cfg13.uart_cfg113.apb_cfg13.add_slave13("spi013",  `AM_SPI0_BASE_ADDRESS13,  `AM_SPI0_END_ADDRESS13,  0, UVM_PASSIVE);
      apb_ss_cfg13.uart_cfg113.apb_cfg13.add_slave13("uart013", `AM_UART0_BASE_ADDRESS13, `AM_UART0_END_ADDRESS13, 0, UVM_PASSIVE);
      apb_ss_cfg13.uart_cfg113.apb_cfg13.add_slave13("gpio013", `AM_GPIO0_BASE_ADDRESS13, `AM_GPIO0_END_ADDRESS13, 0, UVM_PASSIVE);
      apb_ss_cfg13.uart_cfg113.apb_cfg13.add_slave13("uart113", `AM_UART1_BASE_ADDRESS13, `AM_UART1_END_ADDRESS13, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing13 apb13 subsystem13 config:\n", apb_ss_cfg13.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config13)::set(this, "apb013", "cfg", apb_ss_cfg13.uart_cfg013.apb_cfg13);
     uvm_config_db#(uart_config13)::set(this, "uart013", "cfg", apb_ss_cfg13.uart_cfg013.uart_cfg13);
     uvm_config_db#(uart_config13)::set(this, "uart113", "cfg", apb_ss_cfg13.uart_cfg113.uart_cfg13);
     uvm_config_db#(uart_ctrl_config13)::set(this, "apb_ss_env13.apb_uart013", "cfg", apb_ss_cfg13.uart_cfg013);
     uvm_config_db#(uart_ctrl_config13)::set(this, "apb_ss_env13.apb_uart113", "cfg", apb_ss_cfg13.uart_cfg113);
     uvm_config_db#(apb_slave_config13)::set(this, "apb_ss_env13.apb_uart013", "apb_slave_cfg13", apb_ss_cfg13.uart_cfg013.apb_cfg13.slave_configs13[1]);
     uvm_config_db#(apb_slave_config13)::set(this, "apb_ss_env13.apb_uart113", "apb_slave_cfg13", apb_ss_cfg13.uart_cfg113.apb_cfg13.slave_configs13[3]);
     set_config_object("spi013", "spi_ve_config13", apb_ss_cfg13.spi_cfg13, 0);
     set_config_object("gpio013", "gpio_ve_config13", apb_ss_cfg13.gpio_cfg13, 0);

     set_config_int("*spi013.agents13[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio013.agents13[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb013.master_agent13","is_active", UVM_ACTIVE);  
     set_config_int("*ahb013.slave_agent13","is_active", UVM_PASSIVE);
     set_config_int("*uart013.Tx13","is_active", UVM_ACTIVE);  
     set_config_int("*uart013.Rx13","is_active", UVM_PASSIVE);
     set_config_int("*uart113.Tx13","is_active", UVM_ACTIVE);  
     set_config_int("*uart113.Rx13","is_active", UVM_PASSIVE);

     // Allocate13 objects13
     virtual_sequencer13 = apb_subsystem_virtual_sequencer13::type_id::create("virtual_sequencer13",this);
     ahb013              = ahb_pkg13::ahb_env13::type_id::create("ahb013",this);
     apb013              = apb_pkg13::apb_env13::type_id::create("apb013",this);
     uart013             = uart_pkg13::uart_env13::type_id::create("uart013",this);
     uart113             = uart_pkg13::uart_env13::type_id::create("uart113",this);
     spi013              = spi_pkg13::spi_env13::type_id::create("spi013",this);
     gpio013             = gpio_pkg13::gpio_env13::type_id::create("gpio013",this);
     apb_ss_env13        = apb_subsystem_env13::type_id::create("apb_ss_env13",this);

  //UVM_REG
  ahb_predictor13 = uvm_reg_predictor#(ahb_transfer13)::type_id::create("ahb_predictor13", this);
  if (reg_model_apb13 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb13 = apb_ss_reg_model_c13::type_id::create("reg_model_apb13");
    reg_model_apb13.build();  //NOTE13: not same as build_phase: reg_model13 is an object
    reg_model_apb13.lock_model();
  end
    // set the register model for the rest13 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb13", reg_model_apb13);
    uvm_config_object::set(this, "*uart013*", "reg_model13", reg_model_apb13.uart0_rm13);
    uvm_config_object::set(this, "*uart113*", "reg_model13", reg_model_apb13.uart1_rm13);


  endfunction : build_env13

  function void connect_phase(uvm_phase phase);
    ahb_monitor13 user_ahb_monitor13;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb13 = reg_to_ahb_adapter13::type_id::create("reg2ahb13");
    reg_model_apb13.default_map.set_sequencer(ahb013.master_agent13.sequencer, reg2ahb13);  //
    reg_model_apb13.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor13, ahb013.master_agent13.monitor13))
        `uvm_fatal("CASTFL13", "Failed13 to cast master13 monitor13 to user_ahb_monitor13");

      // ***********************************************************
      //  Hookup13 virtual sequencer to interface sequencers13
      // ***********************************************************
        virtual_sequencer13.ahb_seqr13 =  ahb013.master_agent13.sequencer;
      if (uart013.Tx13.is_active == UVM_ACTIVE)  
        virtual_sequencer13.uart0_seqr13 =  uart013.Tx13.sequencer;
      if (uart113.Tx13.is_active == UVM_ACTIVE)  
        virtual_sequencer13.uart1_seqr13 =  uart113.Tx13.sequencer;
      if (spi013.agents13[0].is_active == UVM_ACTIVE)  
        virtual_sequencer13.spi0_seqr13 =  spi013.agents13[0].sequencer;
      if (gpio013.agents13[0].is_active == UVM_ACTIVE)  
        virtual_sequencer13.gpio0_seqr13 =  gpio013.agents13[0].sequencer;

      virtual_sequencer13.reg_model_ptr13 = reg_model_apb13;

      apb_ss_env13.monitor13.set_slave_config13(apb_ss_cfg13.uart_cfg013.apb_cfg13.slave_configs13[0]);
      apb_ss_env13.apb_uart013.set_slave_config13(apb_ss_cfg13.uart_cfg013.apb_cfg13.slave_configs13[1], 1);
      apb_ss_env13.apb_uart113.set_slave_config13(apb_ss_cfg13.uart_cfg113.apb_cfg13.slave_configs13[3], 3);

      // ***********************************************************
      // Connect13 TLM ports13
      // ***********************************************************
      uart013.Rx13.monitor13.frame_collected_port13.connect(apb_ss_env13.apb_uart013.monitor13.uart_rx_in13);
      uart013.Tx13.monitor13.frame_collected_port13.connect(apb_ss_env13.apb_uart013.monitor13.uart_tx_in13);
      apb013.bus_monitor13.item_collected_port13.connect(apb_ss_env13.apb_uart013.monitor13.apb_in13);
      apb013.bus_monitor13.item_collected_port13.connect(apb_ss_env13.apb_uart013.apb_in13);
      user_ahb_monitor13.ahb_transfer_out13.connect(apb_ss_env13.monitor13.rx_scbd13.ahb_add13);
      user_ahb_monitor13.ahb_transfer_out13.connect(apb_ss_env13.ahb_in13);
      spi013.agents13[0].monitor13.item_collected_port13.connect(apb_ss_env13.monitor13.rx_scbd13.spi_match13);


      uart113.Rx13.monitor13.frame_collected_port13.connect(apb_ss_env13.apb_uart113.monitor13.uart_rx_in13);
      uart113.Tx13.monitor13.frame_collected_port13.connect(apb_ss_env13.apb_uart113.monitor13.uart_tx_in13);
      apb013.bus_monitor13.item_collected_port13.connect(apb_ss_env13.apb_uart113.monitor13.apb_in13);
      apb013.bus_monitor13.item_collected_port13.connect(apb_ss_env13.apb_uart113.apb_in13);

      // ***********************************************************
      // Connect13 the dut_csr13 ports13
      // ***********************************************************
      apb_ss_env13.spi_csr_out13.connect(apb_ss_env13.monitor13.dut_csr_port_in13);
      apb_ss_env13.spi_csr_out13.connect(spi013.dut_csr_port_in13);
      apb_ss_env13.gpio_csr_out13.connect(gpio013.dut_csr_port_in13);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env13();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY13",("APB13 SubSystem13 Virtual Sequence Testbench13 Topology13:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("                         _____13                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("                        | AHB13 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("                        | UVC13 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("                   ____________13    _________13               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("                  | AHB13 - APB13  |  | APB13 UVC13 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("                  |   Bridge13   |  | Passive13 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("  _____13    _____13    ______13    _______13    _____13    _______13  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",(" | SPI13 |  | SMC13 |  | GPIO13 |  | UART013 |  | PCM13 |  | UART113 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("  _____13              ______13    _______13            _______13  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",(" | SPI13 |            | GPIO13 |  | UART013 |          | UART113 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",(" | UVC13 |            | UVC13  |  |  UVC13  |          |  UVC13  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY13",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER13 MODEL13:\n", reg_model_apb13.sprint()}, UVM_LOW)
  endtask

endclass
