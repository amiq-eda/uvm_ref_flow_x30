/*-------------------------------------------------------------------------
File9 name   : apb_subsystem_top_tb9.sv
Title9       : Simulation9 and Verification9 Environment9
Project9     :
Created9     :
Description9 : This9 file implements9 the SVE9 for the AHB9-UART9 Environment9
Notes9       : The apb_subsystem_tb9 creates9 the UART9 env9, the 
            : APB9 env9 and the scoreboard9. It also randomizes9 the UART9 
            : CSR9 settings9 and passes9 it to both the env9's.
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation9 Verification9 Environment9 (SVE9)
//--------------------------------------------------------------
class apb_subsystem_tb9 extends uvm_env;

  apb_subsystem_virtual_sequencer9 virtual_sequencer9;  // multi-channel9 sequencer
  ahb_pkg9::ahb_env9 ahb09;                          // AHB9 UVC9
  apb_pkg9::apb_env9 apb09;                          // APB9 UVC9
  uart_pkg9::uart_env9 uart09;                   // UART9 UVC9 connected9 to UART09
  uart_pkg9::uart_env9 uart19;                   // UART9 UVC9 connected9 to UART19
  spi_pkg9::spi_env9 spi09;                      // SPI9 UVC9 connected9 to SPI09
  gpio_pkg9::gpio_env9 gpio09;                   // GPIO9 UVC9 connected9 to GPIO09
  apb_subsystem_env9 apb_ss_env9;

  // UVM_REG
  apb_ss_reg_model_c9 reg_model_apb9;    // Register Model9
  reg_to_ahb_adapter9 reg2ahb9;         // Adapter Object - REG to APB9
  uvm_reg_predictor#(ahb_transfer9) ahb_predictor9; //Predictor9 - APB9 to REG

  apb_subsystem_pkg9::apb_subsystem_config9 apb_ss_cfg9;

  // enable automation9 for  apb_subsystem_tb9
  `uvm_component_utils_begin(apb_subsystem_tb9)
     `uvm_field_object(reg_model_apb9, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb9, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg9, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb9", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env9();
     // Configure9 UVCs9
    if (!uvm_config_db#(apb_subsystem_config9)::get(this, "", "apb_ss_cfg9", apb_ss_cfg9)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config9, creating9...", UVM_LOW)
      apb_ss_cfg9 = apb_subsystem_config9::type_id::create("apb_ss_cfg9", this);
      apb_ss_cfg9.uart_cfg09.apb_cfg9.add_master9("master9", UVM_PASSIVE);
      apb_ss_cfg9.uart_cfg09.apb_cfg9.add_slave9("spi09",  `AM_SPI0_BASE_ADDRESS9,  `AM_SPI0_END_ADDRESS9,  0, UVM_PASSIVE);
      apb_ss_cfg9.uart_cfg09.apb_cfg9.add_slave9("uart09", `AM_UART0_BASE_ADDRESS9, `AM_UART0_END_ADDRESS9, 0, UVM_PASSIVE);
      apb_ss_cfg9.uart_cfg09.apb_cfg9.add_slave9("gpio09", `AM_GPIO0_BASE_ADDRESS9, `AM_GPIO0_END_ADDRESS9, 0, UVM_PASSIVE);
      apb_ss_cfg9.uart_cfg09.apb_cfg9.add_slave9("uart19", `AM_UART1_BASE_ADDRESS9, `AM_UART1_END_ADDRESS9, 1, UVM_PASSIVE);
      apb_ss_cfg9.uart_cfg19.apb_cfg9.add_master9("master9", UVM_PASSIVE);
      apb_ss_cfg9.uart_cfg19.apb_cfg9.add_slave9("spi09",  `AM_SPI0_BASE_ADDRESS9,  `AM_SPI0_END_ADDRESS9,  0, UVM_PASSIVE);
      apb_ss_cfg9.uart_cfg19.apb_cfg9.add_slave9("uart09", `AM_UART0_BASE_ADDRESS9, `AM_UART0_END_ADDRESS9, 0, UVM_PASSIVE);
      apb_ss_cfg9.uart_cfg19.apb_cfg9.add_slave9("gpio09", `AM_GPIO0_BASE_ADDRESS9, `AM_GPIO0_END_ADDRESS9, 0, UVM_PASSIVE);
      apb_ss_cfg9.uart_cfg19.apb_cfg9.add_slave9("uart19", `AM_UART1_BASE_ADDRESS9, `AM_UART1_END_ADDRESS9, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing9 apb9 subsystem9 config:\n", apb_ss_cfg9.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config9)::set(this, "apb09", "cfg", apb_ss_cfg9.uart_cfg09.apb_cfg9);
     uvm_config_db#(uart_config9)::set(this, "uart09", "cfg", apb_ss_cfg9.uart_cfg09.uart_cfg9);
     uvm_config_db#(uart_config9)::set(this, "uart19", "cfg", apb_ss_cfg9.uart_cfg19.uart_cfg9);
     uvm_config_db#(uart_ctrl_config9)::set(this, "apb_ss_env9.apb_uart09", "cfg", apb_ss_cfg9.uart_cfg09);
     uvm_config_db#(uart_ctrl_config9)::set(this, "apb_ss_env9.apb_uart19", "cfg", apb_ss_cfg9.uart_cfg19);
     uvm_config_db#(apb_slave_config9)::set(this, "apb_ss_env9.apb_uart09", "apb_slave_cfg9", apb_ss_cfg9.uart_cfg09.apb_cfg9.slave_configs9[1]);
     uvm_config_db#(apb_slave_config9)::set(this, "apb_ss_env9.apb_uart19", "apb_slave_cfg9", apb_ss_cfg9.uart_cfg19.apb_cfg9.slave_configs9[3]);
     set_config_object("spi09", "spi_ve_config9", apb_ss_cfg9.spi_cfg9, 0);
     set_config_object("gpio09", "gpio_ve_config9", apb_ss_cfg9.gpio_cfg9, 0);

     set_config_int("*spi09.agents9[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio09.agents9[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb09.master_agent9","is_active", UVM_ACTIVE);  
     set_config_int("*ahb09.slave_agent9","is_active", UVM_PASSIVE);
     set_config_int("*uart09.Tx9","is_active", UVM_ACTIVE);  
     set_config_int("*uart09.Rx9","is_active", UVM_PASSIVE);
     set_config_int("*uart19.Tx9","is_active", UVM_ACTIVE);  
     set_config_int("*uart19.Rx9","is_active", UVM_PASSIVE);

     // Allocate9 objects9
     virtual_sequencer9 = apb_subsystem_virtual_sequencer9::type_id::create("virtual_sequencer9",this);
     ahb09              = ahb_pkg9::ahb_env9::type_id::create("ahb09",this);
     apb09              = apb_pkg9::apb_env9::type_id::create("apb09",this);
     uart09             = uart_pkg9::uart_env9::type_id::create("uart09",this);
     uart19             = uart_pkg9::uart_env9::type_id::create("uart19",this);
     spi09              = spi_pkg9::spi_env9::type_id::create("spi09",this);
     gpio09             = gpio_pkg9::gpio_env9::type_id::create("gpio09",this);
     apb_ss_env9        = apb_subsystem_env9::type_id::create("apb_ss_env9",this);

  //UVM_REG
  ahb_predictor9 = uvm_reg_predictor#(ahb_transfer9)::type_id::create("ahb_predictor9", this);
  if (reg_model_apb9 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb9 = apb_ss_reg_model_c9::type_id::create("reg_model_apb9");
    reg_model_apb9.build();  //NOTE9: not same as build_phase: reg_model9 is an object
    reg_model_apb9.lock_model();
  end
    // set the register model for the rest9 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb9", reg_model_apb9);
    uvm_config_object::set(this, "*uart09*", "reg_model9", reg_model_apb9.uart0_rm9);
    uvm_config_object::set(this, "*uart19*", "reg_model9", reg_model_apb9.uart1_rm9);


  endfunction : build_env9

  function void connect_phase(uvm_phase phase);
    ahb_monitor9 user_ahb_monitor9;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb9 = reg_to_ahb_adapter9::type_id::create("reg2ahb9");
    reg_model_apb9.default_map.set_sequencer(ahb09.master_agent9.sequencer, reg2ahb9);  //
    reg_model_apb9.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor9, ahb09.master_agent9.monitor9))
        `uvm_fatal("CASTFL9", "Failed9 to cast master9 monitor9 to user_ahb_monitor9");

      // ***********************************************************
      //  Hookup9 virtual sequencer to interface sequencers9
      // ***********************************************************
        virtual_sequencer9.ahb_seqr9 =  ahb09.master_agent9.sequencer;
      if (uart09.Tx9.is_active == UVM_ACTIVE)  
        virtual_sequencer9.uart0_seqr9 =  uart09.Tx9.sequencer;
      if (uart19.Tx9.is_active == UVM_ACTIVE)  
        virtual_sequencer9.uart1_seqr9 =  uart19.Tx9.sequencer;
      if (spi09.agents9[0].is_active == UVM_ACTIVE)  
        virtual_sequencer9.spi0_seqr9 =  spi09.agents9[0].sequencer;
      if (gpio09.agents9[0].is_active == UVM_ACTIVE)  
        virtual_sequencer9.gpio0_seqr9 =  gpio09.agents9[0].sequencer;

      virtual_sequencer9.reg_model_ptr9 = reg_model_apb9;

      apb_ss_env9.monitor9.set_slave_config9(apb_ss_cfg9.uart_cfg09.apb_cfg9.slave_configs9[0]);
      apb_ss_env9.apb_uart09.set_slave_config9(apb_ss_cfg9.uart_cfg09.apb_cfg9.slave_configs9[1], 1);
      apb_ss_env9.apb_uart19.set_slave_config9(apb_ss_cfg9.uart_cfg19.apb_cfg9.slave_configs9[3], 3);

      // ***********************************************************
      // Connect9 TLM ports9
      // ***********************************************************
      uart09.Rx9.monitor9.frame_collected_port9.connect(apb_ss_env9.apb_uart09.monitor9.uart_rx_in9);
      uart09.Tx9.monitor9.frame_collected_port9.connect(apb_ss_env9.apb_uart09.monitor9.uart_tx_in9);
      apb09.bus_monitor9.item_collected_port9.connect(apb_ss_env9.apb_uart09.monitor9.apb_in9);
      apb09.bus_monitor9.item_collected_port9.connect(apb_ss_env9.apb_uart09.apb_in9);
      user_ahb_monitor9.ahb_transfer_out9.connect(apb_ss_env9.monitor9.rx_scbd9.ahb_add9);
      user_ahb_monitor9.ahb_transfer_out9.connect(apb_ss_env9.ahb_in9);
      spi09.agents9[0].monitor9.item_collected_port9.connect(apb_ss_env9.monitor9.rx_scbd9.spi_match9);


      uart19.Rx9.monitor9.frame_collected_port9.connect(apb_ss_env9.apb_uart19.monitor9.uart_rx_in9);
      uart19.Tx9.monitor9.frame_collected_port9.connect(apb_ss_env9.apb_uart19.monitor9.uart_tx_in9);
      apb09.bus_monitor9.item_collected_port9.connect(apb_ss_env9.apb_uart19.monitor9.apb_in9);
      apb09.bus_monitor9.item_collected_port9.connect(apb_ss_env9.apb_uart19.apb_in9);

      // ***********************************************************
      // Connect9 the dut_csr9 ports9
      // ***********************************************************
      apb_ss_env9.spi_csr_out9.connect(apb_ss_env9.monitor9.dut_csr_port_in9);
      apb_ss_env9.spi_csr_out9.connect(spi09.dut_csr_port_in9);
      apb_ss_env9.gpio_csr_out9.connect(gpio09.dut_csr_port_in9);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env9();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY9",("APB9 SubSystem9 Virtual Sequence Testbench9 Topology9:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("                         _____9                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("                        | AHB9 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("                        | UVC9 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("                   ____________9    _________9               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("                  | AHB9 - APB9  |  | APB9 UVC9 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("                  |   Bridge9   |  | Passive9 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("  _____9    _____9    ______9    _______9    _____9    _______9  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",(" | SPI9 |  | SMC9 |  | GPIO9 |  | UART09 |  | PCM9 |  | UART19 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("  _____9              ______9    _______9            _______9  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",(" | SPI9 |            | GPIO9 |  | UART09 |          | UART19 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",(" | UVC9 |            | UVC9  |  |  UVC9  |          |  UVC9  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY9",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER9 MODEL9:\n", reg_model_apb9.sprint()}, UVM_LOW)
  endtask

endclass
