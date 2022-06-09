/*-------------------------------------------------------------------------
File10 name   : apb_subsystem_top_tb10.sv
Title10       : Simulation10 and Verification10 Environment10
Project10     :
Created10     :
Description10 : This10 file implements10 the SVE10 for the AHB10-UART10 Environment10
Notes10       : The apb_subsystem_tb10 creates10 the UART10 env10, the 
            : APB10 env10 and the scoreboard10. It also randomizes10 the UART10 
            : CSR10 settings10 and passes10 it to both the env10's.
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation10 Verification10 Environment10 (SVE10)
//--------------------------------------------------------------
class apb_subsystem_tb10 extends uvm_env;

  apb_subsystem_virtual_sequencer10 virtual_sequencer10;  // multi-channel10 sequencer
  ahb_pkg10::ahb_env10 ahb010;                          // AHB10 UVC10
  apb_pkg10::apb_env10 apb010;                          // APB10 UVC10
  uart_pkg10::uart_env10 uart010;                   // UART10 UVC10 connected10 to UART010
  uart_pkg10::uart_env10 uart110;                   // UART10 UVC10 connected10 to UART110
  spi_pkg10::spi_env10 spi010;                      // SPI10 UVC10 connected10 to SPI010
  gpio_pkg10::gpio_env10 gpio010;                   // GPIO10 UVC10 connected10 to GPIO010
  apb_subsystem_env10 apb_ss_env10;

  // UVM_REG
  apb_ss_reg_model_c10 reg_model_apb10;    // Register Model10
  reg_to_ahb_adapter10 reg2ahb10;         // Adapter Object - REG to APB10
  uvm_reg_predictor#(ahb_transfer10) ahb_predictor10; //Predictor10 - APB10 to REG

  apb_subsystem_pkg10::apb_subsystem_config10 apb_ss_cfg10;

  // enable automation10 for  apb_subsystem_tb10
  `uvm_component_utils_begin(apb_subsystem_tb10)
     `uvm_field_object(reg_model_apb10, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb10, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg10, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb10", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env10();
     // Configure10 UVCs10
    if (!uvm_config_db#(apb_subsystem_config10)::get(this, "", "apb_ss_cfg10", apb_ss_cfg10)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config10, creating10...", UVM_LOW)
      apb_ss_cfg10 = apb_subsystem_config10::type_id::create("apb_ss_cfg10", this);
      apb_ss_cfg10.uart_cfg010.apb_cfg10.add_master10("master10", UVM_PASSIVE);
      apb_ss_cfg10.uart_cfg010.apb_cfg10.add_slave10("spi010",  `AM_SPI0_BASE_ADDRESS10,  `AM_SPI0_END_ADDRESS10,  0, UVM_PASSIVE);
      apb_ss_cfg10.uart_cfg010.apb_cfg10.add_slave10("uart010", `AM_UART0_BASE_ADDRESS10, `AM_UART0_END_ADDRESS10, 0, UVM_PASSIVE);
      apb_ss_cfg10.uart_cfg010.apb_cfg10.add_slave10("gpio010", `AM_GPIO0_BASE_ADDRESS10, `AM_GPIO0_END_ADDRESS10, 0, UVM_PASSIVE);
      apb_ss_cfg10.uart_cfg010.apb_cfg10.add_slave10("uart110", `AM_UART1_BASE_ADDRESS10, `AM_UART1_END_ADDRESS10, 1, UVM_PASSIVE);
      apb_ss_cfg10.uart_cfg110.apb_cfg10.add_master10("master10", UVM_PASSIVE);
      apb_ss_cfg10.uart_cfg110.apb_cfg10.add_slave10("spi010",  `AM_SPI0_BASE_ADDRESS10,  `AM_SPI0_END_ADDRESS10,  0, UVM_PASSIVE);
      apb_ss_cfg10.uart_cfg110.apb_cfg10.add_slave10("uart010", `AM_UART0_BASE_ADDRESS10, `AM_UART0_END_ADDRESS10, 0, UVM_PASSIVE);
      apb_ss_cfg10.uart_cfg110.apb_cfg10.add_slave10("gpio010", `AM_GPIO0_BASE_ADDRESS10, `AM_GPIO0_END_ADDRESS10, 0, UVM_PASSIVE);
      apb_ss_cfg10.uart_cfg110.apb_cfg10.add_slave10("uart110", `AM_UART1_BASE_ADDRESS10, `AM_UART1_END_ADDRESS10, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing10 apb10 subsystem10 config:\n", apb_ss_cfg10.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config10)::set(this, "apb010", "cfg", apb_ss_cfg10.uart_cfg010.apb_cfg10);
     uvm_config_db#(uart_config10)::set(this, "uart010", "cfg", apb_ss_cfg10.uart_cfg010.uart_cfg10);
     uvm_config_db#(uart_config10)::set(this, "uart110", "cfg", apb_ss_cfg10.uart_cfg110.uart_cfg10);
     uvm_config_db#(uart_ctrl_config10)::set(this, "apb_ss_env10.apb_uart010", "cfg", apb_ss_cfg10.uart_cfg010);
     uvm_config_db#(uart_ctrl_config10)::set(this, "apb_ss_env10.apb_uart110", "cfg", apb_ss_cfg10.uart_cfg110);
     uvm_config_db#(apb_slave_config10)::set(this, "apb_ss_env10.apb_uart010", "apb_slave_cfg10", apb_ss_cfg10.uart_cfg010.apb_cfg10.slave_configs10[1]);
     uvm_config_db#(apb_slave_config10)::set(this, "apb_ss_env10.apb_uart110", "apb_slave_cfg10", apb_ss_cfg10.uart_cfg110.apb_cfg10.slave_configs10[3]);
     set_config_object("spi010", "spi_ve_config10", apb_ss_cfg10.spi_cfg10, 0);
     set_config_object("gpio010", "gpio_ve_config10", apb_ss_cfg10.gpio_cfg10, 0);

     set_config_int("*spi010.agents10[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio010.agents10[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb010.master_agent10","is_active", UVM_ACTIVE);  
     set_config_int("*ahb010.slave_agent10","is_active", UVM_PASSIVE);
     set_config_int("*uart010.Tx10","is_active", UVM_ACTIVE);  
     set_config_int("*uart010.Rx10","is_active", UVM_PASSIVE);
     set_config_int("*uart110.Tx10","is_active", UVM_ACTIVE);  
     set_config_int("*uart110.Rx10","is_active", UVM_PASSIVE);

     // Allocate10 objects10
     virtual_sequencer10 = apb_subsystem_virtual_sequencer10::type_id::create("virtual_sequencer10",this);
     ahb010              = ahb_pkg10::ahb_env10::type_id::create("ahb010",this);
     apb010              = apb_pkg10::apb_env10::type_id::create("apb010",this);
     uart010             = uart_pkg10::uart_env10::type_id::create("uart010",this);
     uart110             = uart_pkg10::uart_env10::type_id::create("uart110",this);
     spi010              = spi_pkg10::spi_env10::type_id::create("spi010",this);
     gpio010             = gpio_pkg10::gpio_env10::type_id::create("gpio010",this);
     apb_ss_env10        = apb_subsystem_env10::type_id::create("apb_ss_env10",this);

  //UVM_REG
  ahb_predictor10 = uvm_reg_predictor#(ahb_transfer10)::type_id::create("ahb_predictor10", this);
  if (reg_model_apb10 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb10 = apb_ss_reg_model_c10::type_id::create("reg_model_apb10");
    reg_model_apb10.build();  //NOTE10: not same as build_phase: reg_model10 is an object
    reg_model_apb10.lock_model();
  end
    // set the register model for the rest10 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb10", reg_model_apb10);
    uvm_config_object::set(this, "*uart010*", "reg_model10", reg_model_apb10.uart0_rm10);
    uvm_config_object::set(this, "*uart110*", "reg_model10", reg_model_apb10.uart1_rm10);


  endfunction : build_env10

  function void connect_phase(uvm_phase phase);
    ahb_monitor10 user_ahb_monitor10;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb10 = reg_to_ahb_adapter10::type_id::create("reg2ahb10");
    reg_model_apb10.default_map.set_sequencer(ahb010.master_agent10.sequencer, reg2ahb10);  //
    reg_model_apb10.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor10, ahb010.master_agent10.monitor10))
        `uvm_fatal("CASTFL10", "Failed10 to cast master10 monitor10 to user_ahb_monitor10");

      // ***********************************************************
      //  Hookup10 virtual sequencer to interface sequencers10
      // ***********************************************************
        virtual_sequencer10.ahb_seqr10 =  ahb010.master_agent10.sequencer;
      if (uart010.Tx10.is_active == UVM_ACTIVE)  
        virtual_sequencer10.uart0_seqr10 =  uart010.Tx10.sequencer;
      if (uart110.Tx10.is_active == UVM_ACTIVE)  
        virtual_sequencer10.uart1_seqr10 =  uart110.Tx10.sequencer;
      if (spi010.agents10[0].is_active == UVM_ACTIVE)  
        virtual_sequencer10.spi0_seqr10 =  spi010.agents10[0].sequencer;
      if (gpio010.agents10[0].is_active == UVM_ACTIVE)  
        virtual_sequencer10.gpio0_seqr10 =  gpio010.agents10[0].sequencer;

      virtual_sequencer10.reg_model_ptr10 = reg_model_apb10;

      apb_ss_env10.monitor10.set_slave_config10(apb_ss_cfg10.uart_cfg010.apb_cfg10.slave_configs10[0]);
      apb_ss_env10.apb_uart010.set_slave_config10(apb_ss_cfg10.uart_cfg010.apb_cfg10.slave_configs10[1], 1);
      apb_ss_env10.apb_uart110.set_slave_config10(apb_ss_cfg10.uart_cfg110.apb_cfg10.slave_configs10[3], 3);

      // ***********************************************************
      // Connect10 TLM ports10
      // ***********************************************************
      uart010.Rx10.monitor10.frame_collected_port10.connect(apb_ss_env10.apb_uart010.monitor10.uart_rx_in10);
      uart010.Tx10.monitor10.frame_collected_port10.connect(apb_ss_env10.apb_uart010.monitor10.uart_tx_in10);
      apb010.bus_monitor10.item_collected_port10.connect(apb_ss_env10.apb_uart010.monitor10.apb_in10);
      apb010.bus_monitor10.item_collected_port10.connect(apb_ss_env10.apb_uart010.apb_in10);
      user_ahb_monitor10.ahb_transfer_out10.connect(apb_ss_env10.monitor10.rx_scbd10.ahb_add10);
      user_ahb_monitor10.ahb_transfer_out10.connect(apb_ss_env10.ahb_in10);
      spi010.agents10[0].monitor10.item_collected_port10.connect(apb_ss_env10.monitor10.rx_scbd10.spi_match10);


      uart110.Rx10.monitor10.frame_collected_port10.connect(apb_ss_env10.apb_uart110.monitor10.uart_rx_in10);
      uart110.Tx10.monitor10.frame_collected_port10.connect(apb_ss_env10.apb_uart110.monitor10.uart_tx_in10);
      apb010.bus_monitor10.item_collected_port10.connect(apb_ss_env10.apb_uart110.monitor10.apb_in10);
      apb010.bus_monitor10.item_collected_port10.connect(apb_ss_env10.apb_uart110.apb_in10);

      // ***********************************************************
      // Connect10 the dut_csr10 ports10
      // ***********************************************************
      apb_ss_env10.spi_csr_out10.connect(apb_ss_env10.monitor10.dut_csr_port_in10);
      apb_ss_env10.spi_csr_out10.connect(spi010.dut_csr_port_in10);
      apb_ss_env10.gpio_csr_out10.connect(gpio010.dut_csr_port_in10);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env10();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY10",("APB10 SubSystem10 Virtual Sequence Testbench10 Topology10:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("                         _____10                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("                        | AHB10 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("                        | UVC10 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("                   ____________10    _________10               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("                  | AHB10 - APB10  |  | APB10 UVC10 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("                  |   Bridge10   |  | Passive10 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("  _____10    _____10    ______10    _______10    _____10    _______10  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",(" | SPI10 |  | SMC10 |  | GPIO10 |  | UART010 |  | PCM10 |  | UART110 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("  _____10              ______10    _______10            _______10  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",(" | SPI10 |            | GPIO10 |  | UART010 |          | UART110 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",(" | UVC10 |            | UVC10  |  |  UVC10  |          |  UVC10  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY10",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER10 MODEL10:\n", reg_model_apb10.sprint()}, UVM_LOW)
  endtask

endclass
