/*-------------------------------------------------------------------------
File1 name   : apb_subsystem_top_tb1.sv
Title1       : Simulation1 and Verification1 Environment1
Project1     :
Created1     :
Description1 : This1 file implements1 the SVE1 for the AHB1-UART1 Environment1
Notes1       : The apb_subsystem_tb1 creates1 the UART1 env1, the 
            : APB1 env1 and the scoreboard1. It also randomizes1 the UART1 
            : CSR1 settings1 and passes1 it to both the env1's.
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation1 Verification1 Environment1 (SVE1)
//--------------------------------------------------------------
class apb_subsystem_tb1 extends uvm_env;

  apb_subsystem_virtual_sequencer1 virtual_sequencer1;  // multi-channel1 sequencer
  ahb_pkg1::ahb_env1 ahb01;                          // AHB1 UVC1
  apb_pkg1::apb_env1 apb01;                          // APB1 UVC1
  uart_pkg1::uart_env1 uart01;                   // UART1 UVC1 connected1 to UART01
  uart_pkg1::uart_env1 uart11;                   // UART1 UVC1 connected1 to UART11
  spi_pkg1::spi_env1 spi01;                      // SPI1 UVC1 connected1 to SPI01
  gpio_pkg1::gpio_env1 gpio01;                   // GPIO1 UVC1 connected1 to GPIO01
  apb_subsystem_env1 apb_ss_env1;

  // UVM_REG
  apb_ss_reg_model_c1 reg_model_apb1;    // Register Model1
  reg_to_ahb_adapter1 reg2ahb1;         // Adapter Object - REG to APB1
  uvm_reg_predictor#(ahb_transfer1) ahb_predictor1; //Predictor1 - APB1 to REG

  apb_subsystem_pkg1::apb_subsystem_config1 apb_ss_cfg1;

  // enable automation1 for  apb_subsystem_tb1
  `uvm_component_utils_begin(apb_subsystem_tb1)
     `uvm_field_object(reg_model_apb1, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb1, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg1, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb1", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env1();
     // Configure1 UVCs1
    if (!uvm_config_db#(apb_subsystem_config1)::get(this, "", "apb_ss_cfg1", apb_ss_cfg1)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config1, creating1...", UVM_LOW)
      apb_ss_cfg1 = apb_subsystem_config1::type_id::create("apb_ss_cfg1", this);
      apb_ss_cfg1.uart_cfg01.apb_cfg1.add_master1("master1", UVM_PASSIVE);
      apb_ss_cfg1.uart_cfg01.apb_cfg1.add_slave1("spi01",  `AM_SPI0_BASE_ADDRESS1,  `AM_SPI0_END_ADDRESS1,  0, UVM_PASSIVE);
      apb_ss_cfg1.uart_cfg01.apb_cfg1.add_slave1("uart01", `AM_UART0_BASE_ADDRESS1, `AM_UART0_END_ADDRESS1, 0, UVM_PASSIVE);
      apb_ss_cfg1.uart_cfg01.apb_cfg1.add_slave1("gpio01", `AM_GPIO0_BASE_ADDRESS1, `AM_GPIO0_END_ADDRESS1, 0, UVM_PASSIVE);
      apb_ss_cfg1.uart_cfg01.apb_cfg1.add_slave1("uart11", `AM_UART1_BASE_ADDRESS1, `AM_UART1_END_ADDRESS1, 1, UVM_PASSIVE);
      apb_ss_cfg1.uart_cfg11.apb_cfg1.add_master1("master1", UVM_PASSIVE);
      apb_ss_cfg1.uart_cfg11.apb_cfg1.add_slave1("spi01",  `AM_SPI0_BASE_ADDRESS1,  `AM_SPI0_END_ADDRESS1,  0, UVM_PASSIVE);
      apb_ss_cfg1.uart_cfg11.apb_cfg1.add_slave1("uart01", `AM_UART0_BASE_ADDRESS1, `AM_UART0_END_ADDRESS1, 0, UVM_PASSIVE);
      apb_ss_cfg1.uart_cfg11.apb_cfg1.add_slave1("gpio01", `AM_GPIO0_BASE_ADDRESS1, `AM_GPIO0_END_ADDRESS1, 0, UVM_PASSIVE);
      apb_ss_cfg1.uart_cfg11.apb_cfg1.add_slave1("uart11", `AM_UART1_BASE_ADDRESS1, `AM_UART1_END_ADDRESS1, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing1 apb1 subsystem1 config:\n", apb_ss_cfg1.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config1)::set(this, "apb01", "cfg", apb_ss_cfg1.uart_cfg01.apb_cfg1);
     uvm_config_db#(uart_config1)::set(this, "uart01", "cfg", apb_ss_cfg1.uart_cfg01.uart_cfg1);
     uvm_config_db#(uart_config1)::set(this, "uart11", "cfg", apb_ss_cfg1.uart_cfg11.uart_cfg1);
     uvm_config_db#(uart_ctrl_config1)::set(this, "apb_ss_env1.apb_uart01", "cfg", apb_ss_cfg1.uart_cfg01);
     uvm_config_db#(uart_ctrl_config1)::set(this, "apb_ss_env1.apb_uart11", "cfg", apb_ss_cfg1.uart_cfg11);
     uvm_config_db#(apb_slave_config1)::set(this, "apb_ss_env1.apb_uart01", "apb_slave_cfg1", apb_ss_cfg1.uart_cfg01.apb_cfg1.slave_configs1[1]);
     uvm_config_db#(apb_slave_config1)::set(this, "apb_ss_env1.apb_uart11", "apb_slave_cfg1", apb_ss_cfg1.uart_cfg11.apb_cfg1.slave_configs1[3]);
     set_config_object("spi01", "spi_ve_config1", apb_ss_cfg1.spi_cfg1, 0);
     set_config_object("gpio01", "gpio_ve_config1", apb_ss_cfg1.gpio_cfg1, 0);

     set_config_int("*spi01.agents1[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio01.agents1[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb01.master_agent1","is_active", UVM_ACTIVE);  
     set_config_int("*ahb01.slave_agent1","is_active", UVM_PASSIVE);
     set_config_int("*uart01.Tx1","is_active", UVM_ACTIVE);  
     set_config_int("*uart01.Rx1","is_active", UVM_PASSIVE);
     set_config_int("*uart11.Tx1","is_active", UVM_ACTIVE);  
     set_config_int("*uart11.Rx1","is_active", UVM_PASSIVE);

     // Allocate1 objects1
     virtual_sequencer1 = apb_subsystem_virtual_sequencer1::type_id::create("virtual_sequencer1",this);
     ahb01              = ahb_pkg1::ahb_env1::type_id::create("ahb01",this);
     apb01              = apb_pkg1::apb_env1::type_id::create("apb01",this);
     uart01             = uart_pkg1::uart_env1::type_id::create("uart01",this);
     uart11             = uart_pkg1::uart_env1::type_id::create("uart11",this);
     spi01              = spi_pkg1::spi_env1::type_id::create("spi01",this);
     gpio01             = gpio_pkg1::gpio_env1::type_id::create("gpio01",this);
     apb_ss_env1        = apb_subsystem_env1::type_id::create("apb_ss_env1",this);

  //UVM_REG
  ahb_predictor1 = uvm_reg_predictor#(ahb_transfer1)::type_id::create("ahb_predictor1", this);
  if (reg_model_apb1 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb1 = apb_ss_reg_model_c1::type_id::create("reg_model_apb1");
    reg_model_apb1.build();  //NOTE1: not same as build_phase: reg_model1 is an object
    reg_model_apb1.lock_model();
  end
    // set the register model for the rest1 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb1", reg_model_apb1);
    uvm_config_object::set(this, "*uart01*", "reg_model1", reg_model_apb1.uart0_rm1);
    uvm_config_object::set(this, "*uart11*", "reg_model1", reg_model_apb1.uart1_rm1);


  endfunction : build_env1

  function void connect_phase(uvm_phase phase);
    ahb_monitor1 user_ahb_monitor1;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb1 = reg_to_ahb_adapter1::type_id::create("reg2ahb1");
    reg_model_apb1.default_map.set_sequencer(ahb01.master_agent1.sequencer, reg2ahb1);  //
    reg_model_apb1.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor1, ahb01.master_agent1.monitor1))
        `uvm_fatal("CASTFL1", "Failed1 to cast master1 monitor1 to user_ahb_monitor1");

      // ***********************************************************
      //  Hookup1 virtual sequencer to interface sequencers1
      // ***********************************************************
        virtual_sequencer1.ahb_seqr1 =  ahb01.master_agent1.sequencer;
      if (uart01.Tx1.is_active == UVM_ACTIVE)  
        virtual_sequencer1.uart0_seqr1 =  uart01.Tx1.sequencer;
      if (uart11.Tx1.is_active == UVM_ACTIVE)  
        virtual_sequencer1.uart1_seqr1 =  uart11.Tx1.sequencer;
      if (spi01.agents1[0].is_active == UVM_ACTIVE)  
        virtual_sequencer1.spi0_seqr1 =  spi01.agents1[0].sequencer;
      if (gpio01.agents1[0].is_active == UVM_ACTIVE)  
        virtual_sequencer1.gpio0_seqr1 =  gpio01.agents1[0].sequencer;

      virtual_sequencer1.reg_model_ptr1 = reg_model_apb1;

      apb_ss_env1.monitor1.set_slave_config1(apb_ss_cfg1.uart_cfg01.apb_cfg1.slave_configs1[0]);
      apb_ss_env1.apb_uart01.set_slave_config1(apb_ss_cfg1.uart_cfg01.apb_cfg1.slave_configs1[1], 1);
      apb_ss_env1.apb_uart11.set_slave_config1(apb_ss_cfg1.uart_cfg11.apb_cfg1.slave_configs1[3], 3);

      // ***********************************************************
      // Connect1 TLM ports1
      // ***********************************************************
      uart01.Rx1.monitor1.frame_collected_port1.connect(apb_ss_env1.apb_uart01.monitor1.uart_rx_in1);
      uart01.Tx1.monitor1.frame_collected_port1.connect(apb_ss_env1.apb_uart01.monitor1.uart_tx_in1);
      apb01.bus_monitor1.item_collected_port1.connect(apb_ss_env1.apb_uart01.monitor1.apb_in1);
      apb01.bus_monitor1.item_collected_port1.connect(apb_ss_env1.apb_uart01.apb_in1);
      user_ahb_monitor1.ahb_transfer_out1.connect(apb_ss_env1.monitor1.rx_scbd1.ahb_add1);
      user_ahb_monitor1.ahb_transfer_out1.connect(apb_ss_env1.ahb_in1);
      spi01.agents1[0].monitor1.item_collected_port1.connect(apb_ss_env1.monitor1.rx_scbd1.spi_match1);


      uart11.Rx1.monitor1.frame_collected_port1.connect(apb_ss_env1.apb_uart11.monitor1.uart_rx_in1);
      uart11.Tx1.monitor1.frame_collected_port1.connect(apb_ss_env1.apb_uart11.monitor1.uart_tx_in1);
      apb01.bus_monitor1.item_collected_port1.connect(apb_ss_env1.apb_uart11.monitor1.apb_in1);
      apb01.bus_monitor1.item_collected_port1.connect(apb_ss_env1.apb_uart11.apb_in1);

      // ***********************************************************
      // Connect1 the dut_csr1 ports1
      // ***********************************************************
      apb_ss_env1.spi_csr_out1.connect(apb_ss_env1.monitor1.dut_csr_port_in1);
      apb_ss_env1.spi_csr_out1.connect(spi01.dut_csr_port_in1);
      apb_ss_env1.gpio_csr_out1.connect(gpio01.dut_csr_port_in1);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env1();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY1",("APB1 SubSystem1 Virtual Sequence Testbench1 Topology1:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("                         _____1                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("                        | AHB1 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("                        | UVC1 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("                   ____________1    _________1               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("                  | AHB1 - APB1  |  | APB1 UVC1 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("                  |   Bridge1   |  | Passive1 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("  _____1    _____1    ______1    _______1    _____1    _______1  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",(" | SPI1 |  | SMC1 |  | GPIO1 |  | UART01 |  | PCM1 |  | UART11 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("  _____1              ______1    _______1            _______1  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",(" | SPI1 |            | GPIO1 |  | UART01 |          | UART11 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",(" | UVC1 |            | UVC1  |  |  UVC1  |          |  UVC1  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY1",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER1 MODEL1:\n", reg_model_apb1.sprint()}, UVM_LOW)
  endtask

endclass
