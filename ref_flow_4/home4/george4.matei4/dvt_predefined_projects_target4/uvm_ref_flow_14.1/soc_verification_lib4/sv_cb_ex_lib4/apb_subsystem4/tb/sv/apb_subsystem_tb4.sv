/*-------------------------------------------------------------------------
File4 name   : apb_subsystem_top_tb4.sv
Title4       : Simulation4 and Verification4 Environment4
Project4     :
Created4     :
Description4 : This4 file implements4 the SVE4 for the AHB4-UART4 Environment4
Notes4       : The apb_subsystem_tb4 creates4 the UART4 env4, the 
            : APB4 env4 and the scoreboard4. It also randomizes4 the UART4 
            : CSR4 settings4 and passes4 it to both the env4's.
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation4 Verification4 Environment4 (SVE4)
//--------------------------------------------------------------
class apb_subsystem_tb4 extends uvm_env;

  apb_subsystem_virtual_sequencer4 virtual_sequencer4;  // multi-channel4 sequencer
  ahb_pkg4::ahb_env4 ahb04;                          // AHB4 UVC4
  apb_pkg4::apb_env4 apb04;                          // APB4 UVC4
  uart_pkg4::uart_env4 uart04;                   // UART4 UVC4 connected4 to UART04
  uart_pkg4::uart_env4 uart14;                   // UART4 UVC4 connected4 to UART14
  spi_pkg4::spi_env4 spi04;                      // SPI4 UVC4 connected4 to SPI04
  gpio_pkg4::gpio_env4 gpio04;                   // GPIO4 UVC4 connected4 to GPIO04
  apb_subsystem_env4 apb_ss_env4;

  // UVM_REG
  apb_ss_reg_model_c4 reg_model_apb4;    // Register Model4
  reg_to_ahb_adapter4 reg2ahb4;         // Adapter Object - REG to APB4
  uvm_reg_predictor#(ahb_transfer4) ahb_predictor4; //Predictor4 - APB4 to REG

  apb_subsystem_pkg4::apb_subsystem_config4 apb_ss_cfg4;

  // enable automation4 for  apb_subsystem_tb4
  `uvm_component_utils_begin(apb_subsystem_tb4)
     `uvm_field_object(reg_model_apb4, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb4, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg4, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb4", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env4();
     // Configure4 UVCs4
    if (!uvm_config_db#(apb_subsystem_config4)::get(this, "", "apb_ss_cfg4", apb_ss_cfg4)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config4, creating4...", UVM_LOW)
      apb_ss_cfg4 = apb_subsystem_config4::type_id::create("apb_ss_cfg4", this);
      apb_ss_cfg4.uart_cfg04.apb_cfg4.add_master4("master4", UVM_PASSIVE);
      apb_ss_cfg4.uart_cfg04.apb_cfg4.add_slave4("spi04",  `AM_SPI0_BASE_ADDRESS4,  `AM_SPI0_END_ADDRESS4,  0, UVM_PASSIVE);
      apb_ss_cfg4.uart_cfg04.apb_cfg4.add_slave4("uart04", `AM_UART0_BASE_ADDRESS4, `AM_UART0_END_ADDRESS4, 0, UVM_PASSIVE);
      apb_ss_cfg4.uart_cfg04.apb_cfg4.add_slave4("gpio04", `AM_GPIO0_BASE_ADDRESS4, `AM_GPIO0_END_ADDRESS4, 0, UVM_PASSIVE);
      apb_ss_cfg4.uart_cfg04.apb_cfg4.add_slave4("uart14", `AM_UART1_BASE_ADDRESS4, `AM_UART1_END_ADDRESS4, 1, UVM_PASSIVE);
      apb_ss_cfg4.uart_cfg14.apb_cfg4.add_master4("master4", UVM_PASSIVE);
      apb_ss_cfg4.uart_cfg14.apb_cfg4.add_slave4("spi04",  `AM_SPI0_BASE_ADDRESS4,  `AM_SPI0_END_ADDRESS4,  0, UVM_PASSIVE);
      apb_ss_cfg4.uart_cfg14.apb_cfg4.add_slave4("uart04", `AM_UART0_BASE_ADDRESS4, `AM_UART0_END_ADDRESS4, 0, UVM_PASSIVE);
      apb_ss_cfg4.uart_cfg14.apb_cfg4.add_slave4("gpio04", `AM_GPIO0_BASE_ADDRESS4, `AM_GPIO0_END_ADDRESS4, 0, UVM_PASSIVE);
      apb_ss_cfg4.uart_cfg14.apb_cfg4.add_slave4("uart14", `AM_UART1_BASE_ADDRESS4, `AM_UART1_END_ADDRESS4, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing4 apb4 subsystem4 config:\n", apb_ss_cfg4.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config4)::set(this, "apb04", "cfg", apb_ss_cfg4.uart_cfg04.apb_cfg4);
     uvm_config_db#(uart_config4)::set(this, "uart04", "cfg", apb_ss_cfg4.uart_cfg04.uart_cfg4);
     uvm_config_db#(uart_config4)::set(this, "uart14", "cfg", apb_ss_cfg4.uart_cfg14.uart_cfg4);
     uvm_config_db#(uart_ctrl_config4)::set(this, "apb_ss_env4.apb_uart04", "cfg", apb_ss_cfg4.uart_cfg04);
     uvm_config_db#(uart_ctrl_config4)::set(this, "apb_ss_env4.apb_uart14", "cfg", apb_ss_cfg4.uart_cfg14);
     uvm_config_db#(apb_slave_config4)::set(this, "apb_ss_env4.apb_uart04", "apb_slave_cfg4", apb_ss_cfg4.uart_cfg04.apb_cfg4.slave_configs4[1]);
     uvm_config_db#(apb_slave_config4)::set(this, "apb_ss_env4.apb_uart14", "apb_slave_cfg4", apb_ss_cfg4.uart_cfg14.apb_cfg4.slave_configs4[3]);
     set_config_object("spi04", "spi_ve_config4", apb_ss_cfg4.spi_cfg4, 0);
     set_config_object("gpio04", "gpio_ve_config4", apb_ss_cfg4.gpio_cfg4, 0);

     set_config_int("*spi04.agents4[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio04.agents4[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb04.master_agent4","is_active", UVM_ACTIVE);  
     set_config_int("*ahb04.slave_agent4","is_active", UVM_PASSIVE);
     set_config_int("*uart04.Tx4","is_active", UVM_ACTIVE);  
     set_config_int("*uart04.Rx4","is_active", UVM_PASSIVE);
     set_config_int("*uart14.Tx4","is_active", UVM_ACTIVE);  
     set_config_int("*uart14.Rx4","is_active", UVM_PASSIVE);

     // Allocate4 objects4
     virtual_sequencer4 = apb_subsystem_virtual_sequencer4::type_id::create("virtual_sequencer4",this);
     ahb04              = ahb_pkg4::ahb_env4::type_id::create("ahb04",this);
     apb04              = apb_pkg4::apb_env4::type_id::create("apb04",this);
     uart04             = uart_pkg4::uart_env4::type_id::create("uart04",this);
     uart14             = uart_pkg4::uart_env4::type_id::create("uart14",this);
     spi04              = spi_pkg4::spi_env4::type_id::create("spi04",this);
     gpio04             = gpio_pkg4::gpio_env4::type_id::create("gpio04",this);
     apb_ss_env4        = apb_subsystem_env4::type_id::create("apb_ss_env4",this);

  //UVM_REG
  ahb_predictor4 = uvm_reg_predictor#(ahb_transfer4)::type_id::create("ahb_predictor4", this);
  if (reg_model_apb4 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb4 = apb_ss_reg_model_c4::type_id::create("reg_model_apb4");
    reg_model_apb4.build();  //NOTE4: not same as build_phase: reg_model4 is an object
    reg_model_apb4.lock_model();
  end
    // set the register model for the rest4 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb4", reg_model_apb4);
    uvm_config_object::set(this, "*uart04*", "reg_model4", reg_model_apb4.uart0_rm4);
    uvm_config_object::set(this, "*uart14*", "reg_model4", reg_model_apb4.uart1_rm4);


  endfunction : build_env4

  function void connect_phase(uvm_phase phase);
    ahb_monitor4 user_ahb_monitor4;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb4 = reg_to_ahb_adapter4::type_id::create("reg2ahb4");
    reg_model_apb4.default_map.set_sequencer(ahb04.master_agent4.sequencer, reg2ahb4);  //
    reg_model_apb4.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor4, ahb04.master_agent4.monitor4))
        `uvm_fatal("CASTFL4", "Failed4 to cast master4 monitor4 to user_ahb_monitor4");

      // ***********************************************************
      //  Hookup4 virtual sequencer to interface sequencers4
      // ***********************************************************
        virtual_sequencer4.ahb_seqr4 =  ahb04.master_agent4.sequencer;
      if (uart04.Tx4.is_active == UVM_ACTIVE)  
        virtual_sequencer4.uart0_seqr4 =  uart04.Tx4.sequencer;
      if (uart14.Tx4.is_active == UVM_ACTIVE)  
        virtual_sequencer4.uart1_seqr4 =  uart14.Tx4.sequencer;
      if (spi04.agents4[0].is_active == UVM_ACTIVE)  
        virtual_sequencer4.spi0_seqr4 =  spi04.agents4[0].sequencer;
      if (gpio04.agents4[0].is_active == UVM_ACTIVE)  
        virtual_sequencer4.gpio0_seqr4 =  gpio04.agents4[0].sequencer;

      virtual_sequencer4.reg_model_ptr4 = reg_model_apb4;

      apb_ss_env4.monitor4.set_slave_config4(apb_ss_cfg4.uart_cfg04.apb_cfg4.slave_configs4[0]);
      apb_ss_env4.apb_uart04.set_slave_config4(apb_ss_cfg4.uart_cfg04.apb_cfg4.slave_configs4[1], 1);
      apb_ss_env4.apb_uart14.set_slave_config4(apb_ss_cfg4.uart_cfg14.apb_cfg4.slave_configs4[3], 3);

      // ***********************************************************
      // Connect4 TLM ports4
      // ***********************************************************
      uart04.Rx4.monitor4.frame_collected_port4.connect(apb_ss_env4.apb_uart04.monitor4.uart_rx_in4);
      uart04.Tx4.monitor4.frame_collected_port4.connect(apb_ss_env4.apb_uart04.monitor4.uart_tx_in4);
      apb04.bus_monitor4.item_collected_port4.connect(apb_ss_env4.apb_uart04.monitor4.apb_in4);
      apb04.bus_monitor4.item_collected_port4.connect(apb_ss_env4.apb_uart04.apb_in4);
      user_ahb_monitor4.ahb_transfer_out4.connect(apb_ss_env4.monitor4.rx_scbd4.ahb_add4);
      user_ahb_monitor4.ahb_transfer_out4.connect(apb_ss_env4.ahb_in4);
      spi04.agents4[0].monitor4.item_collected_port4.connect(apb_ss_env4.monitor4.rx_scbd4.spi_match4);


      uart14.Rx4.monitor4.frame_collected_port4.connect(apb_ss_env4.apb_uart14.monitor4.uart_rx_in4);
      uart14.Tx4.monitor4.frame_collected_port4.connect(apb_ss_env4.apb_uart14.monitor4.uart_tx_in4);
      apb04.bus_monitor4.item_collected_port4.connect(apb_ss_env4.apb_uart14.monitor4.apb_in4);
      apb04.bus_monitor4.item_collected_port4.connect(apb_ss_env4.apb_uart14.apb_in4);

      // ***********************************************************
      // Connect4 the dut_csr4 ports4
      // ***********************************************************
      apb_ss_env4.spi_csr_out4.connect(apb_ss_env4.monitor4.dut_csr_port_in4);
      apb_ss_env4.spi_csr_out4.connect(spi04.dut_csr_port_in4);
      apb_ss_env4.gpio_csr_out4.connect(gpio04.dut_csr_port_in4);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env4();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY4",("APB4 SubSystem4 Virtual Sequence Testbench4 Topology4:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("                         _____4                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("                        | AHB4 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("                        | UVC4 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("                   ____________4    _________4               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("                  | AHB4 - APB4  |  | APB4 UVC4 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("                  |   Bridge4   |  | Passive4 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("  _____4    _____4    ______4    _______4    _____4    _______4  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",(" | SPI4 |  | SMC4 |  | GPIO4 |  | UART04 |  | PCM4 |  | UART14 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("  _____4              ______4    _______4            _______4  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",(" | SPI4 |            | GPIO4 |  | UART04 |          | UART14 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",(" | UVC4 |            | UVC4  |  |  UVC4  |          |  UVC4  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY4",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER4 MODEL4:\n", reg_model_apb4.sprint()}, UVM_LOW)
  endtask

endclass
