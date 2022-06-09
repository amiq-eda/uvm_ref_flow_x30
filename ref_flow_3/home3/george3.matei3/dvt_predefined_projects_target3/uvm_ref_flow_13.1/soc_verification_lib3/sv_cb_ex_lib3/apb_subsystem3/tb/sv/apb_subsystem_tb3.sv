/*-------------------------------------------------------------------------
File3 name   : apb_subsystem_top_tb3.sv
Title3       : Simulation3 and Verification3 Environment3
Project3     :
Created3     :
Description3 : This3 file implements3 the SVE3 for the AHB3-UART3 Environment3
Notes3       : The apb_subsystem_tb3 creates3 the UART3 env3, the 
            : APB3 env3 and the scoreboard3. It also randomizes3 the UART3 
            : CSR3 settings3 and passes3 it to both the env3's.
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation3 Verification3 Environment3 (SVE3)
//--------------------------------------------------------------
class apb_subsystem_tb3 extends uvm_env;

  apb_subsystem_virtual_sequencer3 virtual_sequencer3;  // multi-channel3 sequencer
  ahb_pkg3::ahb_env3 ahb03;                          // AHB3 UVC3
  apb_pkg3::apb_env3 apb03;                          // APB3 UVC3
  uart_pkg3::uart_env3 uart03;                   // UART3 UVC3 connected3 to UART03
  uart_pkg3::uart_env3 uart13;                   // UART3 UVC3 connected3 to UART13
  spi_pkg3::spi_env3 spi03;                      // SPI3 UVC3 connected3 to SPI03
  gpio_pkg3::gpio_env3 gpio03;                   // GPIO3 UVC3 connected3 to GPIO03
  apb_subsystem_env3 apb_ss_env3;

  // UVM_REG
  apb_ss_reg_model_c3 reg_model_apb3;    // Register Model3
  reg_to_ahb_adapter3 reg2ahb3;         // Adapter Object - REG to APB3
  uvm_reg_predictor#(ahb_transfer3) ahb_predictor3; //Predictor3 - APB3 to REG

  apb_subsystem_pkg3::apb_subsystem_config3 apb_ss_cfg3;

  // enable automation3 for  apb_subsystem_tb3
  `uvm_component_utils_begin(apb_subsystem_tb3)
     `uvm_field_object(reg_model_apb3, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb3, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg3, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb3", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env3();
     // Configure3 UVCs3
    if (!uvm_config_db#(apb_subsystem_config3)::get(this, "", "apb_ss_cfg3", apb_ss_cfg3)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config3, creating3...", UVM_LOW)
      apb_ss_cfg3 = apb_subsystem_config3::type_id::create("apb_ss_cfg3", this);
      apb_ss_cfg3.uart_cfg03.apb_cfg3.add_master3("master3", UVM_PASSIVE);
      apb_ss_cfg3.uart_cfg03.apb_cfg3.add_slave3("spi03",  `AM_SPI0_BASE_ADDRESS3,  `AM_SPI0_END_ADDRESS3,  0, UVM_PASSIVE);
      apb_ss_cfg3.uart_cfg03.apb_cfg3.add_slave3("uart03", `AM_UART0_BASE_ADDRESS3, `AM_UART0_END_ADDRESS3, 0, UVM_PASSIVE);
      apb_ss_cfg3.uart_cfg03.apb_cfg3.add_slave3("gpio03", `AM_GPIO0_BASE_ADDRESS3, `AM_GPIO0_END_ADDRESS3, 0, UVM_PASSIVE);
      apb_ss_cfg3.uart_cfg03.apb_cfg3.add_slave3("uart13", `AM_UART1_BASE_ADDRESS3, `AM_UART1_END_ADDRESS3, 1, UVM_PASSIVE);
      apb_ss_cfg3.uart_cfg13.apb_cfg3.add_master3("master3", UVM_PASSIVE);
      apb_ss_cfg3.uart_cfg13.apb_cfg3.add_slave3("spi03",  `AM_SPI0_BASE_ADDRESS3,  `AM_SPI0_END_ADDRESS3,  0, UVM_PASSIVE);
      apb_ss_cfg3.uart_cfg13.apb_cfg3.add_slave3("uart03", `AM_UART0_BASE_ADDRESS3, `AM_UART0_END_ADDRESS3, 0, UVM_PASSIVE);
      apb_ss_cfg3.uart_cfg13.apb_cfg3.add_slave3("gpio03", `AM_GPIO0_BASE_ADDRESS3, `AM_GPIO0_END_ADDRESS3, 0, UVM_PASSIVE);
      apb_ss_cfg3.uart_cfg13.apb_cfg3.add_slave3("uart13", `AM_UART1_BASE_ADDRESS3, `AM_UART1_END_ADDRESS3, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing3 apb3 subsystem3 config:\n", apb_ss_cfg3.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config3)::set(this, "apb03", "cfg", apb_ss_cfg3.uart_cfg03.apb_cfg3);
     uvm_config_db#(uart_config3)::set(this, "uart03", "cfg", apb_ss_cfg3.uart_cfg03.uart_cfg3);
     uvm_config_db#(uart_config3)::set(this, "uart13", "cfg", apb_ss_cfg3.uart_cfg13.uart_cfg3);
     uvm_config_db#(uart_ctrl_config3)::set(this, "apb_ss_env3.apb_uart03", "cfg", apb_ss_cfg3.uart_cfg03);
     uvm_config_db#(uart_ctrl_config3)::set(this, "apb_ss_env3.apb_uart13", "cfg", apb_ss_cfg3.uart_cfg13);
     uvm_config_db#(apb_slave_config3)::set(this, "apb_ss_env3.apb_uart03", "apb_slave_cfg3", apb_ss_cfg3.uart_cfg03.apb_cfg3.slave_configs3[1]);
     uvm_config_db#(apb_slave_config3)::set(this, "apb_ss_env3.apb_uart13", "apb_slave_cfg3", apb_ss_cfg3.uart_cfg13.apb_cfg3.slave_configs3[3]);
     set_config_object("spi03", "spi_ve_config3", apb_ss_cfg3.spi_cfg3, 0);
     set_config_object("gpio03", "gpio_ve_config3", apb_ss_cfg3.gpio_cfg3, 0);

     set_config_int("*spi03.agents3[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio03.agents3[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb03.master_agent3","is_active", UVM_ACTIVE);  
     set_config_int("*ahb03.slave_agent3","is_active", UVM_PASSIVE);
     set_config_int("*uart03.Tx3","is_active", UVM_ACTIVE);  
     set_config_int("*uart03.Rx3","is_active", UVM_PASSIVE);
     set_config_int("*uart13.Tx3","is_active", UVM_ACTIVE);  
     set_config_int("*uart13.Rx3","is_active", UVM_PASSIVE);

     // Allocate3 objects3
     virtual_sequencer3 = apb_subsystem_virtual_sequencer3::type_id::create("virtual_sequencer3",this);
     ahb03              = ahb_pkg3::ahb_env3::type_id::create("ahb03",this);
     apb03              = apb_pkg3::apb_env3::type_id::create("apb03",this);
     uart03             = uart_pkg3::uart_env3::type_id::create("uart03",this);
     uart13             = uart_pkg3::uart_env3::type_id::create("uart13",this);
     spi03              = spi_pkg3::spi_env3::type_id::create("spi03",this);
     gpio03             = gpio_pkg3::gpio_env3::type_id::create("gpio03",this);
     apb_ss_env3        = apb_subsystem_env3::type_id::create("apb_ss_env3",this);

  //UVM_REG
  ahb_predictor3 = uvm_reg_predictor#(ahb_transfer3)::type_id::create("ahb_predictor3", this);
  if (reg_model_apb3 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb3 = apb_ss_reg_model_c3::type_id::create("reg_model_apb3");
    reg_model_apb3.build();  //NOTE3: not same as build_phase: reg_model3 is an object
    reg_model_apb3.lock_model();
  end
    // set the register model for the rest3 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb3", reg_model_apb3);
    uvm_config_object::set(this, "*uart03*", "reg_model3", reg_model_apb3.uart0_rm3);
    uvm_config_object::set(this, "*uart13*", "reg_model3", reg_model_apb3.uart1_rm3);


  endfunction : build_env3

  function void connect_phase(uvm_phase phase);
    ahb_monitor3 user_ahb_monitor3;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb3 = reg_to_ahb_adapter3::type_id::create("reg2ahb3");
    reg_model_apb3.default_map.set_sequencer(ahb03.master_agent3.sequencer, reg2ahb3);  //
    reg_model_apb3.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor3, ahb03.master_agent3.monitor3))
        `uvm_fatal("CASTFL3", "Failed3 to cast master3 monitor3 to user_ahb_monitor3");

      // ***********************************************************
      //  Hookup3 virtual sequencer to interface sequencers3
      // ***********************************************************
        virtual_sequencer3.ahb_seqr3 =  ahb03.master_agent3.sequencer;
      if (uart03.Tx3.is_active == UVM_ACTIVE)  
        virtual_sequencer3.uart0_seqr3 =  uart03.Tx3.sequencer;
      if (uart13.Tx3.is_active == UVM_ACTIVE)  
        virtual_sequencer3.uart1_seqr3 =  uart13.Tx3.sequencer;
      if (spi03.agents3[0].is_active == UVM_ACTIVE)  
        virtual_sequencer3.spi0_seqr3 =  spi03.agents3[0].sequencer;
      if (gpio03.agents3[0].is_active == UVM_ACTIVE)  
        virtual_sequencer3.gpio0_seqr3 =  gpio03.agents3[0].sequencer;

      virtual_sequencer3.reg_model_ptr3 = reg_model_apb3;

      apb_ss_env3.monitor3.set_slave_config3(apb_ss_cfg3.uart_cfg03.apb_cfg3.slave_configs3[0]);
      apb_ss_env3.apb_uart03.set_slave_config3(apb_ss_cfg3.uart_cfg03.apb_cfg3.slave_configs3[1], 1);
      apb_ss_env3.apb_uart13.set_slave_config3(apb_ss_cfg3.uart_cfg13.apb_cfg3.slave_configs3[3], 3);

      // ***********************************************************
      // Connect3 TLM ports3
      // ***********************************************************
      uart03.Rx3.monitor3.frame_collected_port3.connect(apb_ss_env3.apb_uart03.monitor3.uart_rx_in3);
      uart03.Tx3.monitor3.frame_collected_port3.connect(apb_ss_env3.apb_uart03.monitor3.uart_tx_in3);
      apb03.bus_monitor3.item_collected_port3.connect(apb_ss_env3.apb_uart03.monitor3.apb_in3);
      apb03.bus_monitor3.item_collected_port3.connect(apb_ss_env3.apb_uart03.apb_in3);
      user_ahb_monitor3.ahb_transfer_out3.connect(apb_ss_env3.monitor3.rx_scbd3.ahb_add3);
      user_ahb_monitor3.ahb_transfer_out3.connect(apb_ss_env3.ahb_in3);
      spi03.agents3[0].monitor3.item_collected_port3.connect(apb_ss_env3.monitor3.rx_scbd3.spi_match3);


      uart13.Rx3.monitor3.frame_collected_port3.connect(apb_ss_env3.apb_uart13.monitor3.uart_rx_in3);
      uart13.Tx3.monitor3.frame_collected_port3.connect(apb_ss_env3.apb_uart13.monitor3.uart_tx_in3);
      apb03.bus_monitor3.item_collected_port3.connect(apb_ss_env3.apb_uart13.monitor3.apb_in3);
      apb03.bus_monitor3.item_collected_port3.connect(apb_ss_env3.apb_uart13.apb_in3);

      // ***********************************************************
      // Connect3 the dut_csr3 ports3
      // ***********************************************************
      apb_ss_env3.spi_csr_out3.connect(apb_ss_env3.monitor3.dut_csr_port_in3);
      apb_ss_env3.spi_csr_out3.connect(spi03.dut_csr_port_in3);
      apb_ss_env3.gpio_csr_out3.connect(gpio03.dut_csr_port_in3);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env3();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY3",("APB3 SubSystem3 Virtual Sequence Testbench3 Topology3:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("                         _____3                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("                        | AHB3 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("                        | UVC3 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("                   ____________3    _________3               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("                  | AHB3 - APB3  |  | APB3 UVC3 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("                  |   Bridge3   |  | Passive3 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("  _____3    _____3    ______3    _______3    _____3    _______3  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",(" | SPI3 |  | SMC3 |  | GPIO3 |  | UART03 |  | PCM3 |  | UART13 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("  _____3              ______3    _______3            _______3  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",(" | SPI3 |            | GPIO3 |  | UART03 |          | UART13 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",(" | UVC3 |            | UVC3  |  |  UVC3  |          |  UVC3  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY3",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER3 MODEL3:\n", reg_model_apb3.sprint()}, UVM_LOW)
  endtask

endclass
