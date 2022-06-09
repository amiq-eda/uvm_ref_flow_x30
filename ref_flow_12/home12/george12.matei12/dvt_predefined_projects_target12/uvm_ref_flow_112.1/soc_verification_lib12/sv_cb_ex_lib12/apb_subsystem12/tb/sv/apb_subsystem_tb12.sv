/*-------------------------------------------------------------------------
File12 name   : apb_subsystem_top_tb12.sv
Title12       : Simulation12 and Verification12 Environment12
Project12     :
Created12     :
Description12 : This12 file implements12 the SVE12 for the AHB12-UART12 Environment12
Notes12       : The apb_subsystem_tb12 creates12 the UART12 env12, the 
            : APB12 env12 and the scoreboard12. It also randomizes12 the UART12 
            : CSR12 settings12 and passes12 it to both the env12's.
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation12 Verification12 Environment12 (SVE12)
//--------------------------------------------------------------
class apb_subsystem_tb12 extends uvm_env;

  apb_subsystem_virtual_sequencer12 virtual_sequencer12;  // multi-channel12 sequencer
  ahb_pkg12::ahb_env12 ahb012;                          // AHB12 UVC12
  apb_pkg12::apb_env12 apb012;                          // APB12 UVC12
  uart_pkg12::uart_env12 uart012;                   // UART12 UVC12 connected12 to UART012
  uart_pkg12::uart_env12 uart112;                   // UART12 UVC12 connected12 to UART112
  spi_pkg12::spi_env12 spi012;                      // SPI12 UVC12 connected12 to SPI012
  gpio_pkg12::gpio_env12 gpio012;                   // GPIO12 UVC12 connected12 to GPIO012
  apb_subsystem_env12 apb_ss_env12;

  // UVM_REG
  apb_ss_reg_model_c12 reg_model_apb12;    // Register Model12
  reg_to_ahb_adapter12 reg2ahb12;         // Adapter Object - REG to APB12
  uvm_reg_predictor#(ahb_transfer12) ahb_predictor12; //Predictor12 - APB12 to REG

  apb_subsystem_pkg12::apb_subsystem_config12 apb_ss_cfg12;

  // enable automation12 for  apb_subsystem_tb12
  `uvm_component_utils_begin(apb_subsystem_tb12)
     `uvm_field_object(reg_model_apb12, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb12, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg12, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb12", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env12();
     // Configure12 UVCs12
    if (!uvm_config_db#(apb_subsystem_config12)::get(this, "", "apb_ss_cfg12", apb_ss_cfg12)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config12, creating12...", UVM_LOW)
      apb_ss_cfg12 = apb_subsystem_config12::type_id::create("apb_ss_cfg12", this);
      apb_ss_cfg12.uart_cfg012.apb_cfg12.add_master12("master12", UVM_PASSIVE);
      apb_ss_cfg12.uart_cfg012.apb_cfg12.add_slave12("spi012",  `AM_SPI0_BASE_ADDRESS12,  `AM_SPI0_END_ADDRESS12,  0, UVM_PASSIVE);
      apb_ss_cfg12.uart_cfg012.apb_cfg12.add_slave12("uart012", `AM_UART0_BASE_ADDRESS12, `AM_UART0_END_ADDRESS12, 0, UVM_PASSIVE);
      apb_ss_cfg12.uart_cfg012.apb_cfg12.add_slave12("gpio012", `AM_GPIO0_BASE_ADDRESS12, `AM_GPIO0_END_ADDRESS12, 0, UVM_PASSIVE);
      apb_ss_cfg12.uart_cfg012.apb_cfg12.add_slave12("uart112", `AM_UART1_BASE_ADDRESS12, `AM_UART1_END_ADDRESS12, 1, UVM_PASSIVE);
      apb_ss_cfg12.uart_cfg112.apb_cfg12.add_master12("master12", UVM_PASSIVE);
      apb_ss_cfg12.uart_cfg112.apb_cfg12.add_slave12("spi012",  `AM_SPI0_BASE_ADDRESS12,  `AM_SPI0_END_ADDRESS12,  0, UVM_PASSIVE);
      apb_ss_cfg12.uart_cfg112.apb_cfg12.add_slave12("uart012", `AM_UART0_BASE_ADDRESS12, `AM_UART0_END_ADDRESS12, 0, UVM_PASSIVE);
      apb_ss_cfg12.uart_cfg112.apb_cfg12.add_slave12("gpio012", `AM_GPIO0_BASE_ADDRESS12, `AM_GPIO0_END_ADDRESS12, 0, UVM_PASSIVE);
      apb_ss_cfg12.uart_cfg112.apb_cfg12.add_slave12("uart112", `AM_UART1_BASE_ADDRESS12, `AM_UART1_END_ADDRESS12, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing12 apb12 subsystem12 config:\n", apb_ss_cfg12.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config12)::set(this, "apb012", "cfg", apb_ss_cfg12.uart_cfg012.apb_cfg12);
     uvm_config_db#(uart_config12)::set(this, "uart012", "cfg", apb_ss_cfg12.uart_cfg012.uart_cfg12);
     uvm_config_db#(uart_config12)::set(this, "uart112", "cfg", apb_ss_cfg12.uart_cfg112.uart_cfg12);
     uvm_config_db#(uart_ctrl_config12)::set(this, "apb_ss_env12.apb_uart012", "cfg", apb_ss_cfg12.uart_cfg012);
     uvm_config_db#(uart_ctrl_config12)::set(this, "apb_ss_env12.apb_uart112", "cfg", apb_ss_cfg12.uart_cfg112);
     uvm_config_db#(apb_slave_config12)::set(this, "apb_ss_env12.apb_uart012", "apb_slave_cfg12", apb_ss_cfg12.uart_cfg012.apb_cfg12.slave_configs12[1]);
     uvm_config_db#(apb_slave_config12)::set(this, "apb_ss_env12.apb_uart112", "apb_slave_cfg12", apb_ss_cfg12.uart_cfg112.apb_cfg12.slave_configs12[3]);
     set_config_object("spi012", "spi_ve_config12", apb_ss_cfg12.spi_cfg12, 0);
     set_config_object("gpio012", "gpio_ve_config12", apb_ss_cfg12.gpio_cfg12, 0);

     set_config_int("*spi012.agents12[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio012.agents12[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb012.master_agent12","is_active", UVM_ACTIVE);  
     set_config_int("*ahb012.slave_agent12","is_active", UVM_PASSIVE);
     set_config_int("*uart012.Tx12","is_active", UVM_ACTIVE);  
     set_config_int("*uart012.Rx12","is_active", UVM_PASSIVE);
     set_config_int("*uart112.Tx12","is_active", UVM_ACTIVE);  
     set_config_int("*uart112.Rx12","is_active", UVM_PASSIVE);

     // Allocate12 objects12
     virtual_sequencer12 = apb_subsystem_virtual_sequencer12::type_id::create("virtual_sequencer12",this);
     ahb012              = ahb_pkg12::ahb_env12::type_id::create("ahb012",this);
     apb012              = apb_pkg12::apb_env12::type_id::create("apb012",this);
     uart012             = uart_pkg12::uart_env12::type_id::create("uart012",this);
     uart112             = uart_pkg12::uart_env12::type_id::create("uart112",this);
     spi012              = spi_pkg12::spi_env12::type_id::create("spi012",this);
     gpio012             = gpio_pkg12::gpio_env12::type_id::create("gpio012",this);
     apb_ss_env12        = apb_subsystem_env12::type_id::create("apb_ss_env12",this);

  //UVM_REG
  ahb_predictor12 = uvm_reg_predictor#(ahb_transfer12)::type_id::create("ahb_predictor12", this);
  if (reg_model_apb12 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb12 = apb_ss_reg_model_c12::type_id::create("reg_model_apb12");
    reg_model_apb12.build();  //NOTE12: not same as build_phase: reg_model12 is an object
    reg_model_apb12.lock_model();
  end
    // set the register model for the rest12 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb12", reg_model_apb12);
    uvm_config_object::set(this, "*uart012*", "reg_model12", reg_model_apb12.uart0_rm12);
    uvm_config_object::set(this, "*uart112*", "reg_model12", reg_model_apb12.uart1_rm12);


  endfunction : build_env12

  function void connect_phase(uvm_phase phase);
    ahb_monitor12 user_ahb_monitor12;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb12 = reg_to_ahb_adapter12::type_id::create("reg2ahb12");
    reg_model_apb12.default_map.set_sequencer(ahb012.master_agent12.sequencer, reg2ahb12);  //
    reg_model_apb12.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor12, ahb012.master_agent12.monitor12))
        `uvm_fatal("CASTFL12", "Failed12 to cast master12 monitor12 to user_ahb_monitor12");

      // ***********************************************************
      //  Hookup12 virtual sequencer to interface sequencers12
      // ***********************************************************
        virtual_sequencer12.ahb_seqr12 =  ahb012.master_agent12.sequencer;
      if (uart012.Tx12.is_active == UVM_ACTIVE)  
        virtual_sequencer12.uart0_seqr12 =  uart012.Tx12.sequencer;
      if (uart112.Tx12.is_active == UVM_ACTIVE)  
        virtual_sequencer12.uart1_seqr12 =  uart112.Tx12.sequencer;
      if (spi012.agents12[0].is_active == UVM_ACTIVE)  
        virtual_sequencer12.spi0_seqr12 =  spi012.agents12[0].sequencer;
      if (gpio012.agents12[0].is_active == UVM_ACTIVE)  
        virtual_sequencer12.gpio0_seqr12 =  gpio012.agents12[0].sequencer;

      virtual_sequencer12.reg_model_ptr12 = reg_model_apb12;

      apb_ss_env12.monitor12.set_slave_config12(apb_ss_cfg12.uart_cfg012.apb_cfg12.slave_configs12[0]);
      apb_ss_env12.apb_uart012.set_slave_config12(apb_ss_cfg12.uart_cfg012.apb_cfg12.slave_configs12[1], 1);
      apb_ss_env12.apb_uart112.set_slave_config12(apb_ss_cfg12.uart_cfg112.apb_cfg12.slave_configs12[3], 3);

      // ***********************************************************
      // Connect12 TLM ports12
      // ***********************************************************
      uart012.Rx12.monitor12.frame_collected_port12.connect(apb_ss_env12.apb_uart012.monitor12.uart_rx_in12);
      uart012.Tx12.monitor12.frame_collected_port12.connect(apb_ss_env12.apb_uart012.monitor12.uart_tx_in12);
      apb012.bus_monitor12.item_collected_port12.connect(apb_ss_env12.apb_uart012.monitor12.apb_in12);
      apb012.bus_monitor12.item_collected_port12.connect(apb_ss_env12.apb_uart012.apb_in12);
      user_ahb_monitor12.ahb_transfer_out12.connect(apb_ss_env12.monitor12.rx_scbd12.ahb_add12);
      user_ahb_monitor12.ahb_transfer_out12.connect(apb_ss_env12.ahb_in12);
      spi012.agents12[0].monitor12.item_collected_port12.connect(apb_ss_env12.monitor12.rx_scbd12.spi_match12);


      uart112.Rx12.monitor12.frame_collected_port12.connect(apb_ss_env12.apb_uart112.monitor12.uart_rx_in12);
      uart112.Tx12.monitor12.frame_collected_port12.connect(apb_ss_env12.apb_uart112.monitor12.uart_tx_in12);
      apb012.bus_monitor12.item_collected_port12.connect(apb_ss_env12.apb_uart112.monitor12.apb_in12);
      apb012.bus_monitor12.item_collected_port12.connect(apb_ss_env12.apb_uart112.apb_in12);

      // ***********************************************************
      // Connect12 the dut_csr12 ports12
      // ***********************************************************
      apb_ss_env12.spi_csr_out12.connect(apb_ss_env12.monitor12.dut_csr_port_in12);
      apb_ss_env12.spi_csr_out12.connect(spi012.dut_csr_port_in12);
      apb_ss_env12.gpio_csr_out12.connect(gpio012.dut_csr_port_in12);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env12();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY12",("APB12 SubSystem12 Virtual Sequence Testbench12 Topology12:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("                         _____12                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("                        | AHB12 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("                        | UVC12 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("                   ____________12    _________12               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("                  | AHB12 - APB12  |  | APB12 UVC12 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("                  |   Bridge12   |  | Passive12 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("  _____12    _____12    ______12    _______12    _____12    _______12  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",(" | SPI12 |  | SMC12 |  | GPIO12 |  | UART012 |  | PCM12 |  | UART112 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("  _____12              ______12    _______12            _______12  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",(" | SPI12 |            | GPIO12 |  | UART012 |          | UART112 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",(" | UVC12 |            | UVC12  |  |  UVC12  |          |  UVC12  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY12",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER12 MODEL12:\n", reg_model_apb12.sprint()}, UVM_LOW)
  endtask

endclass
