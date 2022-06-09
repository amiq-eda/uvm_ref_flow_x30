/*-------------------------------------------------------------------------
File18 name   : apb_subsystem_top_tb18.sv
Title18       : Simulation18 and Verification18 Environment18
Project18     :
Created18     :
Description18 : This18 file implements18 the SVE18 for the AHB18-UART18 Environment18
Notes18       : The apb_subsystem_tb18 creates18 the UART18 env18, the 
            : APB18 env18 and the scoreboard18. It also randomizes18 the UART18 
            : CSR18 settings18 and passes18 it to both the env18's.
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation18 Verification18 Environment18 (SVE18)
//--------------------------------------------------------------
class apb_subsystem_tb18 extends uvm_env;

  apb_subsystem_virtual_sequencer18 virtual_sequencer18;  // multi-channel18 sequencer
  ahb_pkg18::ahb_env18 ahb018;                          // AHB18 UVC18
  apb_pkg18::apb_env18 apb018;                          // APB18 UVC18
  uart_pkg18::uart_env18 uart018;                   // UART18 UVC18 connected18 to UART018
  uart_pkg18::uart_env18 uart118;                   // UART18 UVC18 connected18 to UART118
  spi_pkg18::spi_env18 spi018;                      // SPI18 UVC18 connected18 to SPI018
  gpio_pkg18::gpio_env18 gpio018;                   // GPIO18 UVC18 connected18 to GPIO018
  apb_subsystem_env18 apb_ss_env18;

  // UVM_REG
  apb_ss_reg_model_c18 reg_model_apb18;    // Register Model18
  reg_to_ahb_adapter18 reg2ahb18;         // Adapter Object - REG to APB18
  uvm_reg_predictor#(ahb_transfer18) ahb_predictor18; //Predictor18 - APB18 to REG

  apb_subsystem_pkg18::apb_subsystem_config18 apb_ss_cfg18;

  // enable automation18 for  apb_subsystem_tb18
  `uvm_component_utils_begin(apb_subsystem_tb18)
     `uvm_field_object(reg_model_apb18, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb18, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg18, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb18", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env18();
     // Configure18 UVCs18
    if (!uvm_config_db#(apb_subsystem_config18)::get(this, "", "apb_ss_cfg18", apb_ss_cfg18)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config18, creating18...", UVM_LOW)
      apb_ss_cfg18 = apb_subsystem_config18::type_id::create("apb_ss_cfg18", this);
      apb_ss_cfg18.uart_cfg018.apb_cfg18.add_master18("master18", UVM_PASSIVE);
      apb_ss_cfg18.uart_cfg018.apb_cfg18.add_slave18("spi018",  `AM_SPI0_BASE_ADDRESS18,  `AM_SPI0_END_ADDRESS18,  0, UVM_PASSIVE);
      apb_ss_cfg18.uart_cfg018.apb_cfg18.add_slave18("uart018", `AM_UART0_BASE_ADDRESS18, `AM_UART0_END_ADDRESS18, 0, UVM_PASSIVE);
      apb_ss_cfg18.uart_cfg018.apb_cfg18.add_slave18("gpio018", `AM_GPIO0_BASE_ADDRESS18, `AM_GPIO0_END_ADDRESS18, 0, UVM_PASSIVE);
      apb_ss_cfg18.uart_cfg018.apb_cfg18.add_slave18("uart118", `AM_UART1_BASE_ADDRESS18, `AM_UART1_END_ADDRESS18, 1, UVM_PASSIVE);
      apb_ss_cfg18.uart_cfg118.apb_cfg18.add_master18("master18", UVM_PASSIVE);
      apb_ss_cfg18.uart_cfg118.apb_cfg18.add_slave18("spi018",  `AM_SPI0_BASE_ADDRESS18,  `AM_SPI0_END_ADDRESS18,  0, UVM_PASSIVE);
      apb_ss_cfg18.uart_cfg118.apb_cfg18.add_slave18("uart018", `AM_UART0_BASE_ADDRESS18, `AM_UART0_END_ADDRESS18, 0, UVM_PASSIVE);
      apb_ss_cfg18.uart_cfg118.apb_cfg18.add_slave18("gpio018", `AM_GPIO0_BASE_ADDRESS18, `AM_GPIO0_END_ADDRESS18, 0, UVM_PASSIVE);
      apb_ss_cfg18.uart_cfg118.apb_cfg18.add_slave18("uart118", `AM_UART1_BASE_ADDRESS18, `AM_UART1_END_ADDRESS18, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing18 apb18 subsystem18 config:\n", apb_ss_cfg18.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config18)::set(this, "apb018", "cfg", apb_ss_cfg18.uart_cfg018.apb_cfg18);
     uvm_config_db#(uart_config18)::set(this, "uart018", "cfg", apb_ss_cfg18.uart_cfg018.uart_cfg18);
     uvm_config_db#(uart_config18)::set(this, "uart118", "cfg", apb_ss_cfg18.uart_cfg118.uart_cfg18);
     uvm_config_db#(uart_ctrl_config18)::set(this, "apb_ss_env18.apb_uart018", "cfg", apb_ss_cfg18.uart_cfg018);
     uvm_config_db#(uart_ctrl_config18)::set(this, "apb_ss_env18.apb_uart118", "cfg", apb_ss_cfg18.uart_cfg118);
     uvm_config_db#(apb_slave_config18)::set(this, "apb_ss_env18.apb_uart018", "apb_slave_cfg18", apb_ss_cfg18.uart_cfg018.apb_cfg18.slave_configs18[1]);
     uvm_config_db#(apb_slave_config18)::set(this, "apb_ss_env18.apb_uart118", "apb_slave_cfg18", apb_ss_cfg18.uart_cfg118.apb_cfg18.slave_configs18[3]);
     set_config_object("spi018", "spi_ve_config18", apb_ss_cfg18.spi_cfg18, 0);
     set_config_object("gpio018", "gpio_ve_config18", apb_ss_cfg18.gpio_cfg18, 0);

     set_config_int("*spi018.agents18[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio018.agents18[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb018.master_agent18","is_active", UVM_ACTIVE);  
     set_config_int("*ahb018.slave_agent18","is_active", UVM_PASSIVE);
     set_config_int("*uart018.Tx18","is_active", UVM_ACTIVE);  
     set_config_int("*uart018.Rx18","is_active", UVM_PASSIVE);
     set_config_int("*uart118.Tx18","is_active", UVM_ACTIVE);  
     set_config_int("*uart118.Rx18","is_active", UVM_PASSIVE);

     // Allocate18 objects18
     virtual_sequencer18 = apb_subsystem_virtual_sequencer18::type_id::create("virtual_sequencer18",this);
     ahb018              = ahb_pkg18::ahb_env18::type_id::create("ahb018",this);
     apb018              = apb_pkg18::apb_env18::type_id::create("apb018",this);
     uart018             = uart_pkg18::uart_env18::type_id::create("uart018",this);
     uart118             = uart_pkg18::uart_env18::type_id::create("uart118",this);
     spi018              = spi_pkg18::spi_env18::type_id::create("spi018",this);
     gpio018             = gpio_pkg18::gpio_env18::type_id::create("gpio018",this);
     apb_ss_env18        = apb_subsystem_env18::type_id::create("apb_ss_env18",this);

  //UVM_REG
  ahb_predictor18 = uvm_reg_predictor#(ahb_transfer18)::type_id::create("ahb_predictor18", this);
  if (reg_model_apb18 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb18 = apb_ss_reg_model_c18::type_id::create("reg_model_apb18");
    reg_model_apb18.build();  //NOTE18: not same as build_phase: reg_model18 is an object
    reg_model_apb18.lock_model();
  end
    // set the register model for the rest18 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb18", reg_model_apb18);
    uvm_config_object::set(this, "*uart018*", "reg_model18", reg_model_apb18.uart0_rm18);
    uvm_config_object::set(this, "*uart118*", "reg_model18", reg_model_apb18.uart1_rm18);


  endfunction : build_env18

  function void connect_phase(uvm_phase phase);
    ahb_monitor18 user_ahb_monitor18;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb18 = reg_to_ahb_adapter18::type_id::create("reg2ahb18");
    reg_model_apb18.default_map.set_sequencer(ahb018.master_agent18.sequencer, reg2ahb18);  //
    reg_model_apb18.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor18, ahb018.master_agent18.monitor18))
        `uvm_fatal("CASTFL18", "Failed18 to cast master18 monitor18 to user_ahb_monitor18");

      // ***********************************************************
      //  Hookup18 virtual sequencer to interface sequencers18
      // ***********************************************************
        virtual_sequencer18.ahb_seqr18 =  ahb018.master_agent18.sequencer;
      if (uart018.Tx18.is_active == UVM_ACTIVE)  
        virtual_sequencer18.uart0_seqr18 =  uart018.Tx18.sequencer;
      if (uart118.Tx18.is_active == UVM_ACTIVE)  
        virtual_sequencer18.uart1_seqr18 =  uart118.Tx18.sequencer;
      if (spi018.agents18[0].is_active == UVM_ACTIVE)  
        virtual_sequencer18.spi0_seqr18 =  spi018.agents18[0].sequencer;
      if (gpio018.agents18[0].is_active == UVM_ACTIVE)  
        virtual_sequencer18.gpio0_seqr18 =  gpio018.agents18[0].sequencer;

      virtual_sequencer18.reg_model_ptr18 = reg_model_apb18;

      apb_ss_env18.monitor18.set_slave_config18(apb_ss_cfg18.uart_cfg018.apb_cfg18.slave_configs18[0]);
      apb_ss_env18.apb_uart018.set_slave_config18(apb_ss_cfg18.uart_cfg018.apb_cfg18.slave_configs18[1], 1);
      apb_ss_env18.apb_uart118.set_slave_config18(apb_ss_cfg18.uart_cfg118.apb_cfg18.slave_configs18[3], 3);

      // ***********************************************************
      // Connect18 TLM ports18
      // ***********************************************************
      uart018.Rx18.monitor18.frame_collected_port18.connect(apb_ss_env18.apb_uart018.monitor18.uart_rx_in18);
      uart018.Tx18.monitor18.frame_collected_port18.connect(apb_ss_env18.apb_uart018.monitor18.uart_tx_in18);
      apb018.bus_monitor18.item_collected_port18.connect(apb_ss_env18.apb_uart018.monitor18.apb_in18);
      apb018.bus_monitor18.item_collected_port18.connect(apb_ss_env18.apb_uart018.apb_in18);
      user_ahb_monitor18.ahb_transfer_out18.connect(apb_ss_env18.monitor18.rx_scbd18.ahb_add18);
      user_ahb_monitor18.ahb_transfer_out18.connect(apb_ss_env18.ahb_in18);
      spi018.agents18[0].monitor18.item_collected_port18.connect(apb_ss_env18.monitor18.rx_scbd18.spi_match18);


      uart118.Rx18.monitor18.frame_collected_port18.connect(apb_ss_env18.apb_uart118.monitor18.uart_rx_in18);
      uart118.Tx18.monitor18.frame_collected_port18.connect(apb_ss_env18.apb_uart118.monitor18.uart_tx_in18);
      apb018.bus_monitor18.item_collected_port18.connect(apb_ss_env18.apb_uart118.monitor18.apb_in18);
      apb018.bus_monitor18.item_collected_port18.connect(apb_ss_env18.apb_uart118.apb_in18);

      // ***********************************************************
      // Connect18 the dut_csr18 ports18
      // ***********************************************************
      apb_ss_env18.spi_csr_out18.connect(apb_ss_env18.monitor18.dut_csr_port_in18);
      apb_ss_env18.spi_csr_out18.connect(spi018.dut_csr_port_in18);
      apb_ss_env18.gpio_csr_out18.connect(gpio018.dut_csr_port_in18);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env18();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY18",("APB18 SubSystem18 Virtual Sequence Testbench18 Topology18:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("                         _____18                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("                        | AHB18 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("                        | UVC18 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("                   ____________18    _________18               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("                  | AHB18 - APB18  |  | APB18 UVC18 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("                  |   Bridge18   |  | Passive18 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("  _____18    _____18    ______18    _______18    _____18    _______18  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",(" | SPI18 |  | SMC18 |  | GPIO18 |  | UART018 |  | PCM18 |  | UART118 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("  _____18              ______18    _______18            _______18  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",(" | SPI18 |            | GPIO18 |  | UART018 |          | UART118 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",(" | UVC18 |            | UVC18  |  |  UVC18  |          |  UVC18  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY18",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER18 MODEL18:\n", reg_model_apb18.sprint()}, UVM_LOW)
  endtask

endclass
