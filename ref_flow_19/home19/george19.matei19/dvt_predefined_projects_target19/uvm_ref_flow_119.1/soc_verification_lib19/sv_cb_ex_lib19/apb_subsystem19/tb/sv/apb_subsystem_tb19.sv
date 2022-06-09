/*-------------------------------------------------------------------------
File19 name   : apb_subsystem_top_tb19.sv
Title19       : Simulation19 and Verification19 Environment19
Project19     :
Created19     :
Description19 : This19 file implements19 the SVE19 for the AHB19-UART19 Environment19
Notes19       : The apb_subsystem_tb19 creates19 the UART19 env19, the 
            : APB19 env19 and the scoreboard19. It also randomizes19 the UART19 
            : CSR19 settings19 and passes19 it to both the env19's.
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation19 Verification19 Environment19 (SVE19)
//--------------------------------------------------------------
class apb_subsystem_tb19 extends uvm_env;

  apb_subsystem_virtual_sequencer19 virtual_sequencer19;  // multi-channel19 sequencer
  ahb_pkg19::ahb_env19 ahb019;                          // AHB19 UVC19
  apb_pkg19::apb_env19 apb019;                          // APB19 UVC19
  uart_pkg19::uart_env19 uart019;                   // UART19 UVC19 connected19 to UART019
  uart_pkg19::uart_env19 uart119;                   // UART19 UVC19 connected19 to UART119
  spi_pkg19::spi_env19 spi019;                      // SPI19 UVC19 connected19 to SPI019
  gpio_pkg19::gpio_env19 gpio019;                   // GPIO19 UVC19 connected19 to GPIO019
  apb_subsystem_env19 apb_ss_env19;

  // UVM_REG
  apb_ss_reg_model_c19 reg_model_apb19;    // Register Model19
  reg_to_ahb_adapter19 reg2ahb19;         // Adapter Object - REG to APB19
  uvm_reg_predictor#(ahb_transfer19) ahb_predictor19; //Predictor19 - APB19 to REG

  apb_subsystem_pkg19::apb_subsystem_config19 apb_ss_cfg19;

  // enable automation19 for  apb_subsystem_tb19
  `uvm_component_utils_begin(apb_subsystem_tb19)
     `uvm_field_object(reg_model_apb19, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb19, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg19, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb19", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env19();
     // Configure19 UVCs19
    if (!uvm_config_db#(apb_subsystem_config19)::get(this, "", "apb_ss_cfg19", apb_ss_cfg19)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config19, creating19...", UVM_LOW)
      apb_ss_cfg19 = apb_subsystem_config19::type_id::create("apb_ss_cfg19", this);
      apb_ss_cfg19.uart_cfg019.apb_cfg19.add_master19("master19", UVM_PASSIVE);
      apb_ss_cfg19.uart_cfg019.apb_cfg19.add_slave19("spi019",  `AM_SPI0_BASE_ADDRESS19,  `AM_SPI0_END_ADDRESS19,  0, UVM_PASSIVE);
      apb_ss_cfg19.uart_cfg019.apb_cfg19.add_slave19("uart019", `AM_UART0_BASE_ADDRESS19, `AM_UART0_END_ADDRESS19, 0, UVM_PASSIVE);
      apb_ss_cfg19.uart_cfg019.apb_cfg19.add_slave19("gpio019", `AM_GPIO0_BASE_ADDRESS19, `AM_GPIO0_END_ADDRESS19, 0, UVM_PASSIVE);
      apb_ss_cfg19.uart_cfg019.apb_cfg19.add_slave19("uart119", `AM_UART1_BASE_ADDRESS19, `AM_UART1_END_ADDRESS19, 1, UVM_PASSIVE);
      apb_ss_cfg19.uart_cfg119.apb_cfg19.add_master19("master19", UVM_PASSIVE);
      apb_ss_cfg19.uart_cfg119.apb_cfg19.add_slave19("spi019",  `AM_SPI0_BASE_ADDRESS19,  `AM_SPI0_END_ADDRESS19,  0, UVM_PASSIVE);
      apb_ss_cfg19.uart_cfg119.apb_cfg19.add_slave19("uart019", `AM_UART0_BASE_ADDRESS19, `AM_UART0_END_ADDRESS19, 0, UVM_PASSIVE);
      apb_ss_cfg19.uart_cfg119.apb_cfg19.add_slave19("gpio019", `AM_GPIO0_BASE_ADDRESS19, `AM_GPIO0_END_ADDRESS19, 0, UVM_PASSIVE);
      apb_ss_cfg19.uart_cfg119.apb_cfg19.add_slave19("uart119", `AM_UART1_BASE_ADDRESS19, `AM_UART1_END_ADDRESS19, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing19 apb19 subsystem19 config:\n", apb_ss_cfg19.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config19)::set(this, "apb019", "cfg", apb_ss_cfg19.uart_cfg019.apb_cfg19);
     uvm_config_db#(uart_config19)::set(this, "uart019", "cfg", apb_ss_cfg19.uart_cfg019.uart_cfg19);
     uvm_config_db#(uart_config19)::set(this, "uart119", "cfg", apb_ss_cfg19.uart_cfg119.uart_cfg19);
     uvm_config_db#(uart_ctrl_config19)::set(this, "apb_ss_env19.apb_uart019", "cfg", apb_ss_cfg19.uart_cfg019);
     uvm_config_db#(uart_ctrl_config19)::set(this, "apb_ss_env19.apb_uart119", "cfg", apb_ss_cfg19.uart_cfg119);
     uvm_config_db#(apb_slave_config19)::set(this, "apb_ss_env19.apb_uart019", "apb_slave_cfg19", apb_ss_cfg19.uart_cfg019.apb_cfg19.slave_configs19[1]);
     uvm_config_db#(apb_slave_config19)::set(this, "apb_ss_env19.apb_uart119", "apb_slave_cfg19", apb_ss_cfg19.uart_cfg119.apb_cfg19.slave_configs19[3]);
     set_config_object("spi019", "spi_ve_config19", apb_ss_cfg19.spi_cfg19, 0);
     set_config_object("gpio019", "gpio_ve_config19", apb_ss_cfg19.gpio_cfg19, 0);

     set_config_int("*spi019.agents19[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio019.agents19[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb019.master_agent19","is_active", UVM_ACTIVE);  
     set_config_int("*ahb019.slave_agent19","is_active", UVM_PASSIVE);
     set_config_int("*uart019.Tx19","is_active", UVM_ACTIVE);  
     set_config_int("*uart019.Rx19","is_active", UVM_PASSIVE);
     set_config_int("*uart119.Tx19","is_active", UVM_ACTIVE);  
     set_config_int("*uart119.Rx19","is_active", UVM_PASSIVE);

     // Allocate19 objects19
     virtual_sequencer19 = apb_subsystem_virtual_sequencer19::type_id::create("virtual_sequencer19",this);
     ahb019              = ahb_pkg19::ahb_env19::type_id::create("ahb019",this);
     apb019              = apb_pkg19::apb_env19::type_id::create("apb019",this);
     uart019             = uart_pkg19::uart_env19::type_id::create("uart019",this);
     uart119             = uart_pkg19::uart_env19::type_id::create("uart119",this);
     spi019              = spi_pkg19::spi_env19::type_id::create("spi019",this);
     gpio019             = gpio_pkg19::gpio_env19::type_id::create("gpio019",this);
     apb_ss_env19        = apb_subsystem_env19::type_id::create("apb_ss_env19",this);

  //UVM_REG
  ahb_predictor19 = uvm_reg_predictor#(ahb_transfer19)::type_id::create("ahb_predictor19", this);
  if (reg_model_apb19 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb19 = apb_ss_reg_model_c19::type_id::create("reg_model_apb19");
    reg_model_apb19.build();  //NOTE19: not same as build_phase: reg_model19 is an object
    reg_model_apb19.lock_model();
  end
    // set the register model for the rest19 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb19", reg_model_apb19);
    uvm_config_object::set(this, "*uart019*", "reg_model19", reg_model_apb19.uart0_rm19);
    uvm_config_object::set(this, "*uart119*", "reg_model19", reg_model_apb19.uart1_rm19);


  endfunction : build_env19

  function void connect_phase(uvm_phase phase);
    ahb_monitor19 user_ahb_monitor19;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb19 = reg_to_ahb_adapter19::type_id::create("reg2ahb19");
    reg_model_apb19.default_map.set_sequencer(ahb019.master_agent19.sequencer, reg2ahb19);  //
    reg_model_apb19.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor19, ahb019.master_agent19.monitor19))
        `uvm_fatal("CASTFL19", "Failed19 to cast master19 monitor19 to user_ahb_monitor19");

      // ***********************************************************
      //  Hookup19 virtual sequencer to interface sequencers19
      // ***********************************************************
        virtual_sequencer19.ahb_seqr19 =  ahb019.master_agent19.sequencer;
      if (uart019.Tx19.is_active == UVM_ACTIVE)  
        virtual_sequencer19.uart0_seqr19 =  uart019.Tx19.sequencer;
      if (uart119.Tx19.is_active == UVM_ACTIVE)  
        virtual_sequencer19.uart1_seqr19 =  uart119.Tx19.sequencer;
      if (spi019.agents19[0].is_active == UVM_ACTIVE)  
        virtual_sequencer19.spi0_seqr19 =  spi019.agents19[0].sequencer;
      if (gpio019.agents19[0].is_active == UVM_ACTIVE)  
        virtual_sequencer19.gpio0_seqr19 =  gpio019.agents19[0].sequencer;

      virtual_sequencer19.reg_model_ptr19 = reg_model_apb19;

      apb_ss_env19.monitor19.set_slave_config19(apb_ss_cfg19.uart_cfg019.apb_cfg19.slave_configs19[0]);
      apb_ss_env19.apb_uart019.set_slave_config19(apb_ss_cfg19.uart_cfg019.apb_cfg19.slave_configs19[1], 1);
      apb_ss_env19.apb_uart119.set_slave_config19(apb_ss_cfg19.uart_cfg119.apb_cfg19.slave_configs19[3], 3);

      // ***********************************************************
      // Connect19 TLM ports19
      // ***********************************************************
      uart019.Rx19.monitor19.frame_collected_port19.connect(apb_ss_env19.apb_uart019.monitor19.uart_rx_in19);
      uart019.Tx19.monitor19.frame_collected_port19.connect(apb_ss_env19.apb_uart019.monitor19.uart_tx_in19);
      apb019.bus_monitor19.item_collected_port19.connect(apb_ss_env19.apb_uart019.monitor19.apb_in19);
      apb019.bus_monitor19.item_collected_port19.connect(apb_ss_env19.apb_uart019.apb_in19);
      user_ahb_monitor19.ahb_transfer_out19.connect(apb_ss_env19.monitor19.rx_scbd19.ahb_add19);
      user_ahb_monitor19.ahb_transfer_out19.connect(apb_ss_env19.ahb_in19);
      spi019.agents19[0].monitor19.item_collected_port19.connect(apb_ss_env19.monitor19.rx_scbd19.spi_match19);


      uart119.Rx19.monitor19.frame_collected_port19.connect(apb_ss_env19.apb_uart119.monitor19.uart_rx_in19);
      uart119.Tx19.monitor19.frame_collected_port19.connect(apb_ss_env19.apb_uart119.monitor19.uart_tx_in19);
      apb019.bus_monitor19.item_collected_port19.connect(apb_ss_env19.apb_uart119.monitor19.apb_in19);
      apb019.bus_monitor19.item_collected_port19.connect(apb_ss_env19.apb_uart119.apb_in19);

      // ***********************************************************
      // Connect19 the dut_csr19 ports19
      // ***********************************************************
      apb_ss_env19.spi_csr_out19.connect(apb_ss_env19.monitor19.dut_csr_port_in19);
      apb_ss_env19.spi_csr_out19.connect(spi019.dut_csr_port_in19);
      apb_ss_env19.gpio_csr_out19.connect(gpio019.dut_csr_port_in19);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env19();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY19",("APB19 SubSystem19 Virtual Sequence Testbench19 Topology19:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("                         _____19                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("                        | AHB19 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("                        | UVC19 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("                   ____________19    _________19               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("                  | AHB19 - APB19  |  | APB19 UVC19 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("                  |   Bridge19   |  | Passive19 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("  _____19    _____19    ______19    _______19    _____19    _______19  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",(" | SPI19 |  | SMC19 |  | GPIO19 |  | UART019 |  | PCM19 |  | UART119 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("  _____19              ______19    _______19            _______19  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",(" | SPI19 |            | GPIO19 |  | UART019 |          | UART119 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",(" | UVC19 |            | UVC19  |  |  UVC19  |          |  UVC19  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY19",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER19 MODEL19:\n", reg_model_apb19.sprint()}, UVM_LOW)
  endtask

endclass
