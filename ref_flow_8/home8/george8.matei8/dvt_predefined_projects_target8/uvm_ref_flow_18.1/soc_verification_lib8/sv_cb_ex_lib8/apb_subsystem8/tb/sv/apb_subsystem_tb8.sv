/*-------------------------------------------------------------------------
File8 name   : apb_subsystem_top_tb8.sv
Title8       : Simulation8 and Verification8 Environment8
Project8     :
Created8     :
Description8 : This8 file implements8 the SVE8 for the AHB8-UART8 Environment8
Notes8       : The apb_subsystem_tb8 creates8 the UART8 env8, the 
            : APB8 env8 and the scoreboard8. It also randomizes8 the UART8 
            : CSR8 settings8 and passes8 it to both the env8's.
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation8 Verification8 Environment8 (SVE8)
//--------------------------------------------------------------
class apb_subsystem_tb8 extends uvm_env;

  apb_subsystem_virtual_sequencer8 virtual_sequencer8;  // multi-channel8 sequencer
  ahb_pkg8::ahb_env8 ahb08;                          // AHB8 UVC8
  apb_pkg8::apb_env8 apb08;                          // APB8 UVC8
  uart_pkg8::uart_env8 uart08;                   // UART8 UVC8 connected8 to UART08
  uart_pkg8::uart_env8 uart18;                   // UART8 UVC8 connected8 to UART18
  spi_pkg8::spi_env8 spi08;                      // SPI8 UVC8 connected8 to SPI08
  gpio_pkg8::gpio_env8 gpio08;                   // GPIO8 UVC8 connected8 to GPIO08
  apb_subsystem_env8 apb_ss_env8;

  // UVM_REG
  apb_ss_reg_model_c8 reg_model_apb8;    // Register Model8
  reg_to_ahb_adapter8 reg2ahb8;         // Adapter Object - REG to APB8
  uvm_reg_predictor#(ahb_transfer8) ahb_predictor8; //Predictor8 - APB8 to REG

  apb_subsystem_pkg8::apb_subsystem_config8 apb_ss_cfg8;

  // enable automation8 for  apb_subsystem_tb8
  `uvm_component_utils_begin(apb_subsystem_tb8)
     `uvm_field_object(reg_model_apb8, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb8, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg8, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb8", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env8();
     // Configure8 UVCs8
    if (!uvm_config_db#(apb_subsystem_config8)::get(this, "", "apb_ss_cfg8", apb_ss_cfg8)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config8, creating8...", UVM_LOW)
      apb_ss_cfg8 = apb_subsystem_config8::type_id::create("apb_ss_cfg8", this);
      apb_ss_cfg8.uart_cfg08.apb_cfg8.add_master8("master8", UVM_PASSIVE);
      apb_ss_cfg8.uart_cfg08.apb_cfg8.add_slave8("spi08",  `AM_SPI0_BASE_ADDRESS8,  `AM_SPI0_END_ADDRESS8,  0, UVM_PASSIVE);
      apb_ss_cfg8.uart_cfg08.apb_cfg8.add_slave8("uart08", `AM_UART0_BASE_ADDRESS8, `AM_UART0_END_ADDRESS8, 0, UVM_PASSIVE);
      apb_ss_cfg8.uart_cfg08.apb_cfg8.add_slave8("gpio08", `AM_GPIO0_BASE_ADDRESS8, `AM_GPIO0_END_ADDRESS8, 0, UVM_PASSIVE);
      apb_ss_cfg8.uart_cfg08.apb_cfg8.add_slave8("uart18", `AM_UART1_BASE_ADDRESS8, `AM_UART1_END_ADDRESS8, 1, UVM_PASSIVE);
      apb_ss_cfg8.uart_cfg18.apb_cfg8.add_master8("master8", UVM_PASSIVE);
      apb_ss_cfg8.uart_cfg18.apb_cfg8.add_slave8("spi08",  `AM_SPI0_BASE_ADDRESS8,  `AM_SPI0_END_ADDRESS8,  0, UVM_PASSIVE);
      apb_ss_cfg8.uart_cfg18.apb_cfg8.add_slave8("uart08", `AM_UART0_BASE_ADDRESS8, `AM_UART0_END_ADDRESS8, 0, UVM_PASSIVE);
      apb_ss_cfg8.uart_cfg18.apb_cfg8.add_slave8("gpio08", `AM_GPIO0_BASE_ADDRESS8, `AM_GPIO0_END_ADDRESS8, 0, UVM_PASSIVE);
      apb_ss_cfg8.uart_cfg18.apb_cfg8.add_slave8("uart18", `AM_UART1_BASE_ADDRESS8, `AM_UART1_END_ADDRESS8, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing8 apb8 subsystem8 config:\n", apb_ss_cfg8.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config8)::set(this, "apb08", "cfg", apb_ss_cfg8.uart_cfg08.apb_cfg8);
     uvm_config_db#(uart_config8)::set(this, "uart08", "cfg", apb_ss_cfg8.uart_cfg08.uart_cfg8);
     uvm_config_db#(uart_config8)::set(this, "uart18", "cfg", apb_ss_cfg8.uart_cfg18.uart_cfg8);
     uvm_config_db#(uart_ctrl_config8)::set(this, "apb_ss_env8.apb_uart08", "cfg", apb_ss_cfg8.uart_cfg08);
     uvm_config_db#(uart_ctrl_config8)::set(this, "apb_ss_env8.apb_uart18", "cfg", apb_ss_cfg8.uart_cfg18);
     uvm_config_db#(apb_slave_config8)::set(this, "apb_ss_env8.apb_uart08", "apb_slave_cfg8", apb_ss_cfg8.uart_cfg08.apb_cfg8.slave_configs8[1]);
     uvm_config_db#(apb_slave_config8)::set(this, "apb_ss_env8.apb_uart18", "apb_slave_cfg8", apb_ss_cfg8.uart_cfg18.apb_cfg8.slave_configs8[3]);
     set_config_object("spi08", "spi_ve_config8", apb_ss_cfg8.spi_cfg8, 0);
     set_config_object("gpio08", "gpio_ve_config8", apb_ss_cfg8.gpio_cfg8, 0);

     set_config_int("*spi08.agents8[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio08.agents8[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb08.master_agent8","is_active", UVM_ACTIVE);  
     set_config_int("*ahb08.slave_agent8","is_active", UVM_PASSIVE);
     set_config_int("*uart08.Tx8","is_active", UVM_ACTIVE);  
     set_config_int("*uart08.Rx8","is_active", UVM_PASSIVE);
     set_config_int("*uart18.Tx8","is_active", UVM_ACTIVE);  
     set_config_int("*uart18.Rx8","is_active", UVM_PASSIVE);

     // Allocate8 objects8
     virtual_sequencer8 = apb_subsystem_virtual_sequencer8::type_id::create("virtual_sequencer8",this);
     ahb08              = ahb_pkg8::ahb_env8::type_id::create("ahb08",this);
     apb08              = apb_pkg8::apb_env8::type_id::create("apb08",this);
     uart08             = uart_pkg8::uart_env8::type_id::create("uart08",this);
     uart18             = uart_pkg8::uart_env8::type_id::create("uart18",this);
     spi08              = spi_pkg8::spi_env8::type_id::create("spi08",this);
     gpio08             = gpio_pkg8::gpio_env8::type_id::create("gpio08",this);
     apb_ss_env8        = apb_subsystem_env8::type_id::create("apb_ss_env8",this);

  //UVM_REG
  ahb_predictor8 = uvm_reg_predictor#(ahb_transfer8)::type_id::create("ahb_predictor8", this);
  if (reg_model_apb8 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb8 = apb_ss_reg_model_c8::type_id::create("reg_model_apb8");
    reg_model_apb8.build();  //NOTE8: not same as build_phase: reg_model8 is an object
    reg_model_apb8.lock_model();
  end
    // set the register model for the rest8 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb8", reg_model_apb8);
    uvm_config_object::set(this, "*uart08*", "reg_model8", reg_model_apb8.uart0_rm8);
    uvm_config_object::set(this, "*uart18*", "reg_model8", reg_model_apb8.uart1_rm8);


  endfunction : build_env8

  function void connect_phase(uvm_phase phase);
    ahb_monitor8 user_ahb_monitor8;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb8 = reg_to_ahb_adapter8::type_id::create("reg2ahb8");
    reg_model_apb8.default_map.set_sequencer(ahb08.master_agent8.sequencer, reg2ahb8);  //
    reg_model_apb8.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor8, ahb08.master_agent8.monitor8))
        `uvm_fatal("CASTFL8", "Failed8 to cast master8 monitor8 to user_ahb_monitor8");

      // ***********************************************************
      //  Hookup8 virtual sequencer to interface sequencers8
      // ***********************************************************
        virtual_sequencer8.ahb_seqr8 =  ahb08.master_agent8.sequencer;
      if (uart08.Tx8.is_active == UVM_ACTIVE)  
        virtual_sequencer8.uart0_seqr8 =  uart08.Tx8.sequencer;
      if (uart18.Tx8.is_active == UVM_ACTIVE)  
        virtual_sequencer8.uart1_seqr8 =  uart18.Tx8.sequencer;
      if (spi08.agents8[0].is_active == UVM_ACTIVE)  
        virtual_sequencer8.spi0_seqr8 =  spi08.agents8[0].sequencer;
      if (gpio08.agents8[0].is_active == UVM_ACTIVE)  
        virtual_sequencer8.gpio0_seqr8 =  gpio08.agents8[0].sequencer;

      virtual_sequencer8.reg_model_ptr8 = reg_model_apb8;

      apb_ss_env8.monitor8.set_slave_config8(apb_ss_cfg8.uart_cfg08.apb_cfg8.slave_configs8[0]);
      apb_ss_env8.apb_uart08.set_slave_config8(apb_ss_cfg8.uart_cfg08.apb_cfg8.slave_configs8[1], 1);
      apb_ss_env8.apb_uart18.set_slave_config8(apb_ss_cfg8.uart_cfg18.apb_cfg8.slave_configs8[3], 3);

      // ***********************************************************
      // Connect8 TLM ports8
      // ***********************************************************
      uart08.Rx8.monitor8.frame_collected_port8.connect(apb_ss_env8.apb_uart08.monitor8.uart_rx_in8);
      uart08.Tx8.monitor8.frame_collected_port8.connect(apb_ss_env8.apb_uart08.monitor8.uart_tx_in8);
      apb08.bus_monitor8.item_collected_port8.connect(apb_ss_env8.apb_uart08.monitor8.apb_in8);
      apb08.bus_monitor8.item_collected_port8.connect(apb_ss_env8.apb_uart08.apb_in8);
      user_ahb_monitor8.ahb_transfer_out8.connect(apb_ss_env8.monitor8.rx_scbd8.ahb_add8);
      user_ahb_monitor8.ahb_transfer_out8.connect(apb_ss_env8.ahb_in8);
      spi08.agents8[0].monitor8.item_collected_port8.connect(apb_ss_env8.monitor8.rx_scbd8.spi_match8);


      uart18.Rx8.monitor8.frame_collected_port8.connect(apb_ss_env8.apb_uart18.monitor8.uart_rx_in8);
      uart18.Tx8.monitor8.frame_collected_port8.connect(apb_ss_env8.apb_uart18.monitor8.uart_tx_in8);
      apb08.bus_monitor8.item_collected_port8.connect(apb_ss_env8.apb_uart18.monitor8.apb_in8);
      apb08.bus_monitor8.item_collected_port8.connect(apb_ss_env8.apb_uart18.apb_in8);

      // ***********************************************************
      // Connect8 the dut_csr8 ports8
      // ***********************************************************
      apb_ss_env8.spi_csr_out8.connect(apb_ss_env8.monitor8.dut_csr_port_in8);
      apb_ss_env8.spi_csr_out8.connect(spi08.dut_csr_port_in8);
      apb_ss_env8.gpio_csr_out8.connect(gpio08.dut_csr_port_in8);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env8();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY8",("APB8 SubSystem8 Virtual Sequence Testbench8 Topology8:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("                         _____8                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("                        | AHB8 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("                        | UVC8 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("                   ____________8    _________8               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("                  | AHB8 - APB8  |  | APB8 UVC8 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("                  |   Bridge8   |  | Passive8 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("  _____8    _____8    ______8    _______8    _____8    _______8  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",(" | SPI8 |  | SMC8 |  | GPIO8 |  | UART08 |  | PCM8 |  | UART18 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("  _____8              ______8    _______8            _______8  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",(" | SPI8 |            | GPIO8 |  | UART08 |          | UART18 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",(" | UVC8 |            | UVC8  |  |  UVC8  |          |  UVC8  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY8",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER8 MODEL8:\n", reg_model_apb8.sprint()}, UVM_LOW)
  endtask

endclass
