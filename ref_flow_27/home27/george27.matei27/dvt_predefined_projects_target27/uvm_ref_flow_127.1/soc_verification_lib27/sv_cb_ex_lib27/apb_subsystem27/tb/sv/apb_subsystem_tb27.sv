/*-------------------------------------------------------------------------
File27 name   : apb_subsystem_top_tb27.sv
Title27       : Simulation27 and Verification27 Environment27
Project27     :
Created27     :
Description27 : This27 file implements27 the SVE27 for the AHB27-UART27 Environment27
Notes27       : The apb_subsystem_tb27 creates27 the UART27 env27, the 
            : APB27 env27 and the scoreboard27. It also randomizes27 the UART27 
            : CSR27 settings27 and passes27 it to both the env27's.
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation27 Verification27 Environment27 (SVE27)
//--------------------------------------------------------------
class apb_subsystem_tb27 extends uvm_env;

  apb_subsystem_virtual_sequencer27 virtual_sequencer27;  // multi-channel27 sequencer
  ahb_pkg27::ahb_env27 ahb027;                          // AHB27 UVC27
  apb_pkg27::apb_env27 apb027;                          // APB27 UVC27
  uart_pkg27::uart_env27 uart027;                   // UART27 UVC27 connected27 to UART027
  uart_pkg27::uart_env27 uart127;                   // UART27 UVC27 connected27 to UART127
  spi_pkg27::spi_env27 spi027;                      // SPI27 UVC27 connected27 to SPI027
  gpio_pkg27::gpio_env27 gpio027;                   // GPIO27 UVC27 connected27 to GPIO027
  apb_subsystem_env27 apb_ss_env27;

  // UVM_REG
  apb_ss_reg_model_c27 reg_model_apb27;    // Register Model27
  reg_to_ahb_adapter27 reg2ahb27;         // Adapter Object - REG to APB27
  uvm_reg_predictor#(ahb_transfer27) ahb_predictor27; //Predictor27 - APB27 to REG

  apb_subsystem_pkg27::apb_subsystem_config27 apb_ss_cfg27;

  // enable automation27 for  apb_subsystem_tb27
  `uvm_component_utils_begin(apb_subsystem_tb27)
     `uvm_field_object(reg_model_apb27, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb27, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg27, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb27", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env27();
     // Configure27 UVCs27
    if (!uvm_config_db#(apb_subsystem_config27)::get(this, "", "apb_ss_cfg27", apb_ss_cfg27)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config27, creating27...", UVM_LOW)
      apb_ss_cfg27 = apb_subsystem_config27::type_id::create("apb_ss_cfg27", this);
      apb_ss_cfg27.uart_cfg027.apb_cfg27.add_master27("master27", UVM_PASSIVE);
      apb_ss_cfg27.uart_cfg027.apb_cfg27.add_slave27("spi027",  `AM_SPI0_BASE_ADDRESS27,  `AM_SPI0_END_ADDRESS27,  0, UVM_PASSIVE);
      apb_ss_cfg27.uart_cfg027.apb_cfg27.add_slave27("uart027", `AM_UART0_BASE_ADDRESS27, `AM_UART0_END_ADDRESS27, 0, UVM_PASSIVE);
      apb_ss_cfg27.uart_cfg027.apb_cfg27.add_slave27("gpio027", `AM_GPIO0_BASE_ADDRESS27, `AM_GPIO0_END_ADDRESS27, 0, UVM_PASSIVE);
      apb_ss_cfg27.uart_cfg027.apb_cfg27.add_slave27("uart127", `AM_UART1_BASE_ADDRESS27, `AM_UART1_END_ADDRESS27, 1, UVM_PASSIVE);
      apb_ss_cfg27.uart_cfg127.apb_cfg27.add_master27("master27", UVM_PASSIVE);
      apb_ss_cfg27.uart_cfg127.apb_cfg27.add_slave27("spi027",  `AM_SPI0_BASE_ADDRESS27,  `AM_SPI0_END_ADDRESS27,  0, UVM_PASSIVE);
      apb_ss_cfg27.uart_cfg127.apb_cfg27.add_slave27("uart027", `AM_UART0_BASE_ADDRESS27, `AM_UART0_END_ADDRESS27, 0, UVM_PASSIVE);
      apb_ss_cfg27.uart_cfg127.apb_cfg27.add_slave27("gpio027", `AM_GPIO0_BASE_ADDRESS27, `AM_GPIO0_END_ADDRESS27, 0, UVM_PASSIVE);
      apb_ss_cfg27.uart_cfg127.apb_cfg27.add_slave27("uart127", `AM_UART1_BASE_ADDRESS27, `AM_UART1_END_ADDRESS27, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing27 apb27 subsystem27 config:\n", apb_ss_cfg27.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config27)::set(this, "apb027", "cfg", apb_ss_cfg27.uart_cfg027.apb_cfg27);
     uvm_config_db#(uart_config27)::set(this, "uart027", "cfg", apb_ss_cfg27.uart_cfg027.uart_cfg27);
     uvm_config_db#(uart_config27)::set(this, "uart127", "cfg", apb_ss_cfg27.uart_cfg127.uart_cfg27);
     uvm_config_db#(uart_ctrl_config27)::set(this, "apb_ss_env27.apb_uart027", "cfg", apb_ss_cfg27.uart_cfg027);
     uvm_config_db#(uart_ctrl_config27)::set(this, "apb_ss_env27.apb_uart127", "cfg", apb_ss_cfg27.uart_cfg127);
     uvm_config_db#(apb_slave_config27)::set(this, "apb_ss_env27.apb_uart027", "apb_slave_cfg27", apb_ss_cfg27.uart_cfg027.apb_cfg27.slave_configs27[1]);
     uvm_config_db#(apb_slave_config27)::set(this, "apb_ss_env27.apb_uart127", "apb_slave_cfg27", apb_ss_cfg27.uart_cfg127.apb_cfg27.slave_configs27[3]);
     set_config_object("spi027", "spi_ve_config27", apb_ss_cfg27.spi_cfg27, 0);
     set_config_object("gpio027", "gpio_ve_config27", apb_ss_cfg27.gpio_cfg27, 0);

     set_config_int("*spi027.agents27[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio027.agents27[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb027.master_agent27","is_active", UVM_ACTIVE);  
     set_config_int("*ahb027.slave_agent27","is_active", UVM_PASSIVE);
     set_config_int("*uart027.Tx27","is_active", UVM_ACTIVE);  
     set_config_int("*uart027.Rx27","is_active", UVM_PASSIVE);
     set_config_int("*uart127.Tx27","is_active", UVM_ACTIVE);  
     set_config_int("*uart127.Rx27","is_active", UVM_PASSIVE);

     // Allocate27 objects27
     virtual_sequencer27 = apb_subsystem_virtual_sequencer27::type_id::create("virtual_sequencer27",this);
     ahb027              = ahb_pkg27::ahb_env27::type_id::create("ahb027",this);
     apb027              = apb_pkg27::apb_env27::type_id::create("apb027",this);
     uart027             = uart_pkg27::uart_env27::type_id::create("uart027",this);
     uart127             = uart_pkg27::uart_env27::type_id::create("uart127",this);
     spi027              = spi_pkg27::spi_env27::type_id::create("spi027",this);
     gpio027             = gpio_pkg27::gpio_env27::type_id::create("gpio027",this);
     apb_ss_env27        = apb_subsystem_env27::type_id::create("apb_ss_env27",this);

  //UVM_REG
  ahb_predictor27 = uvm_reg_predictor#(ahb_transfer27)::type_id::create("ahb_predictor27", this);
  if (reg_model_apb27 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb27 = apb_ss_reg_model_c27::type_id::create("reg_model_apb27");
    reg_model_apb27.build();  //NOTE27: not same as build_phase: reg_model27 is an object
    reg_model_apb27.lock_model();
  end
    // set the register model for the rest27 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb27", reg_model_apb27);
    uvm_config_object::set(this, "*uart027*", "reg_model27", reg_model_apb27.uart0_rm27);
    uvm_config_object::set(this, "*uart127*", "reg_model27", reg_model_apb27.uart1_rm27);


  endfunction : build_env27

  function void connect_phase(uvm_phase phase);
    ahb_monitor27 user_ahb_monitor27;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb27 = reg_to_ahb_adapter27::type_id::create("reg2ahb27");
    reg_model_apb27.default_map.set_sequencer(ahb027.master_agent27.sequencer, reg2ahb27);  //
    reg_model_apb27.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor27, ahb027.master_agent27.monitor27))
        `uvm_fatal("CASTFL27", "Failed27 to cast master27 monitor27 to user_ahb_monitor27");

      // ***********************************************************
      //  Hookup27 virtual sequencer to interface sequencers27
      // ***********************************************************
        virtual_sequencer27.ahb_seqr27 =  ahb027.master_agent27.sequencer;
      if (uart027.Tx27.is_active == UVM_ACTIVE)  
        virtual_sequencer27.uart0_seqr27 =  uart027.Tx27.sequencer;
      if (uart127.Tx27.is_active == UVM_ACTIVE)  
        virtual_sequencer27.uart1_seqr27 =  uart127.Tx27.sequencer;
      if (spi027.agents27[0].is_active == UVM_ACTIVE)  
        virtual_sequencer27.spi0_seqr27 =  spi027.agents27[0].sequencer;
      if (gpio027.agents27[0].is_active == UVM_ACTIVE)  
        virtual_sequencer27.gpio0_seqr27 =  gpio027.agents27[0].sequencer;

      virtual_sequencer27.reg_model_ptr27 = reg_model_apb27;

      apb_ss_env27.monitor27.set_slave_config27(apb_ss_cfg27.uart_cfg027.apb_cfg27.slave_configs27[0]);
      apb_ss_env27.apb_uart027.set_slave_config27(apb_ss_cfg27.uart_cfg027.apb_cfg27.slave_configs27[1], 1);
      apb_ss_env27.apb_uart127.set_slave_config27(apb_ss_cfg27.uart_cfg127.apb_cfg27.slave_configs27[3], 3);

      // ***********************************************************
      // Connect27 TLM ports27
      // ***********************************************************
      uart027.Rx27.monitor27.frame_collected_port27.connect(apb_ss_env27.apb_uart027.monitor27.uart_rx_in27);
      uart027.Tx27.monitor27.frame_collected_port27.connect(apb_ss_env27.apb_uart027.monitor27.uart_tx_in27);
      apb027.bus_monitor27.item_collected_port27.connect(apb_ss_env27.apb_uart027.monitor27.apb_in27);
      apb027.bus_monitor27.item_collected_port27.connect(apb_ss_env27.apb_uart027.apb_in27);
      user_ahb_monitor27.ahb_transfer_out27.connect(apb_ss_env27.monitor27.rx_scbd27.ahb_add27);
      user_ahb_monitor27.ahb_transfer_out27.connect(apb_ss_env27.ahb_in27);
      spi027.agents27[0].monitor27.item_collected_port27.connect(apb_ss_env27.monitor27.rx_scbd27.spi_match27);


      uart127.Rx27.monitor27.frame_collected_port27.connect(apb_ss_env27.apb_uart127.monitor27.uart_rx_in27);
      uart127.Tx27.monitor27.frame_collected_port27.connect(apb_ss_env27.apb_uart127.monitor27.uart_tx_in27);
      apb027.bus_monitor27.item_collected_port27.connect(apb_ss_env27.apb_uart127.monitor27.apb_in27);
      apb027.bus_monitor27.item_collected_port27.connect(apb_ss_env27.apb_uart127.apb_in27);

      // ***********************************************************
      // Connect27 the dut_csr27 ports27
      // ***********************************************************
      apb_ss_env27.spi_csr_out27.connect(apb_ss_env27.monitor27.dut_csr_port_in27);
      apb_ss_env27.spi_csr_out27.connect(spi027.dut_csr_port_in27);
      apb_ss_env27.gpio_csr_out27.connect(gpio027.dut_csr_port_in27);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env27();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY27",("APB27 SubSystem27 Virtual Sequence Testbench27 Topology27:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("                         _____27                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("                        | AHB27 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("                        | UVC27 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("                   ____________27    _________27               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("                  | AHB27 - APB27  |  | APB27 UVC27 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("                  |   Bridge27   |  | Passive27 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("  _____27    _____27    ______27    _______27    _____27    _______27  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",(" | SPI27 |  | SMC27 |  | GPIO27 |  | UART027 |  | PCM27 |  | UART127 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("  _____27              ______27    _______27            _______27  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",(" | SPI27 |            | GPIO27 |  | UART027 |          | UART127 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",(" | UVC27 |            | UVC27  |  |  UVC27  |          |  UVC27  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY27",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER27 MODEL27:\n", reg_model_apb27.sprint()}, UVM_LOW)
  endtask

endclass
