/*-------------------------------------------------------------------------
File2 name   : apb_subsystem_top_tb2.sv
Title2       : Simulation2 and Verification2 Environment2
Project2     :
Created2     :
Description2 : This2 file implements2 the SVE2 for the AHB2-UART2 Environment2
Notes2       : The apb_subsystem_tb2 creates2 the UART2 env2, the 
            : APB2 env2 and the scoreboard2. It also randomizes2 the UART2 
            : CSR2 settings2 and passes2 it to both the env2's.
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation2 Verification2 Environment2 (SVE2)
//--------------------------------------------------------------
class apb_subsystem_tb2 extends uvm_env;

  apb_subsystem_virtual_sequencer2 virtual_sequencer2;  // multi-channel2 sequencer
  ahb_pkg2::ahb_env2 ahb02;                          // AHB2 UVC2
  apb_pkg2::apb_env2 apb02;                          // APB2 UVC2
  uart_pkg2::uart_env2 uart02;                   // UART2 UVC2 connected2 to UART02
  uart_pkg2::uart_env2 uart12;                   // UART2 UVC2 connected2 to UART12
  spi_pkg2::spi_env2 spi02;                      // SPI2 UVC2 connected2 to SPI02
  gpio_pkg2::gpio_env2 gpio02;                   // GPIO2 UVC2 connected2 to GPIO02
  apb_subsystem_env2 apb_ss_env2;

  // UVM_REG
  apb_ss_reg_model_c2 reg_model_apb2;    // Register Model2
  reg_to_ahb_adapter2 reg2ahb2;         // Adapter Object - REG to APB2
  uvm_reg_predictor#(ahb_transfer2) ahb_predictor2; //Predictor2 - APB2 to REG

  apb_subsystem_pkg2::apb_subsystem_config2 apb_ss_cfg2;

  // enable automation2 for  apb_subsystem_tb2
  `uvm_component_utils_begin(apb_subsystem_tb2)
     `uvm_field_object(reg_model_apb2, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb2, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg2, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb2", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env2();
     // Configure2 UVCs2
    if (!uvm_config_db#(apb_subsystem_config2)::get(this, "", "apb_ss_cfg2", apb_ss_cfg2)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config2, creating2...", UVM_LOW)
      apb_ss_cfg2 = apb_subsystem_config2::type_id::create("apb_ss_cfg2", this);
      apb_ss_cfg2.uart_cfg02.apb_cfg2.add_master2("master2", UVM_PASSIVE);
      apb_ss_cfg2.uart_cfg02.apb_cfg2.add_slave2("spi02",  `AM_SPI0_BASE_ADDRESS2,  `AM_SPI0_END_ADDRESS2,  0, UVM_PASSIVE);
      apb_ss_cfg2.uart_cfg02.apb_cfg2.add_slave2("uart02", `AM_UART0_BASE_ADDRESS2, `AM_UART0_END_ADDRESS2, 0, UVM_PASSIVE);
      apb_ss_cfg2.uart_cfg02.apb_cfg2.add_slave2("gpio02", `AM_GPIO0_BASE_ADDRESS2, `AM_GPIO0_END_ADDRESS2, 0, UVM_PASSIVE);
      apb_ss_cfg2.uart_cfg02.apb_cfg2.add_slave2("uart12", `AM_UART1_BASE_ADDRESS2, `AM_UART1_END_ADDRESS2, 1, UVM_PASSIVE);
      apb_ss_cfg2.uart_cfg12.apb_cfg2.add_master2("master2", UVM_PASSIVE);
      apb_ss_cfg2.uart_cfg12.apb_cfg2.add_slave2("spi02",  `AM_SPI0_BASE_ADDRESS2,  `AM_SPI0_END_ADDRESS2,  0, UVM_PASSIVE);
      apb_ss_cfg2.uart_cfg12.apb_cfg2.add_slave2("uart02", `AM_UART0_BASE_ADDRESS2, `AM_UART0_END_ADDRESS2, 0, UVM_PASSIVE);
      apb_ss_cfg2.uart_cfg12.apb_cfg2.add_slave2("gpio02", `AM_GPIO0_BASE_ADDRESS2, `AM_GPIO0_END_ADDRESS2, 0, UVM_PASSIVE);
      apb_ss_cfg2.uart_cfg12.apb_cfg2.add_slave2("uart12", `AM_UART1_BASE_ADDRESS2, `AM_UART1_END_ADDRESS2, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing2 apb2 subsystem2 config:\n", apb_ss_cfg2.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config2)::set(this, "apb02", "cfg", apb_ss_cfg2.uart_cfg02.apb_cfg2);
     uvm_config_db#(uart_config2)::set(this, "uart02", "cfg", apb_ss_cfg2.uart_cfg02.uart_cfg2);
     uvm_config_db#(uart_config2)::set(this, "uart12", "cfg", apb_ss_cfg2.uart_cfg12.uart_cfg2);
     uvm_config_db#(uart_ctrl_config2)::set(this, "apb_ss_env2.apb_uart02", "cfg", apb_ss_cfg2.uart_cfg02);
     uvm_config_db#(uart_ctrl_config2)::set(this, "apb_ss_env2.apb_uart12", "cfg", apb_ss_cfg2.uart_cfg12);
     uvm_config_db#(apb_slave_config2)::set(this, "apb_ss_env2.apb_uart02", "apb_slave_cfg2", apb_ss_cfg2.uart_cfg02.apb_cfg2.slave_configs2[1]);
     uvm_config_db#(apb_slave_config2)::set(this, "apb_ss_env2.apb_uart12", "apb_slave_cfg2", apb_ss_cfg2.uart_cfg12.apb_cfg2.slave_configs2[3]);
     set_config_object("spi02", "spi_ve_config2", apb_ss_cfg2.spi_cfg2, 0);
     set_config_object("gpio02", "gpio_ve_config2", apb_ss_cfg2.gpio_cfg2, 0);

     set_config_int("*spi02.agents2[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio02.agents2[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb02.master_agent2","is_active", UVM_ACTIVE);  
     set_config_int("*ahb02.slave_agent2","is_active", UVM_PASSIVE);
     set_config_int("*uart02.Tx2","is_active", UVM_ACTIVE);  
     set_config_int("*uart02.Rx2","is_active", UVM_PASSIVE);
     set_config_int("*uart12.Tx2","is_active", UVM_ACTIVE);  
     set_config_int("*uart12.Rx2","is_active", UVM_PASSIVE);

     // Allocate2 objects2
     virtual_sequencer2 = apb_subsystem_virtual_sequencer2::type_id::create("virtual_sequencer2",this);
     ahb02              = ahb_pkg2::ahb_env2::type_id::create("ahb02",this);
     apb02              = apb_pkg2::apb_env2::type_id::create("apb02",this);
     uart02             = uart_pkg2::uart_env2::type_id::create("uart02",this);
     uart12             = uart_pkg2::uart_env2::type_id::create("uart12",this);
     spi02              = spi_pkg2::spi_env2::type_id::create("spi02",this);
     gpio02             = gpio_pkg2::gpio_env2::type_id::create("gpio02",this);
     apb_ss_env2        = apb_subsystem_env2::type_id::create("apb_ss_env2",this);

  //UVM_REG
  ahb_predictor2 = uvm_reg_predictor#(ahb_transfer2)::type_id::create("ahb_predictor2", this);
  if (reg_model_apb2 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb2 = apb_ss_reg_model_c2::type_id::create("reg_model_apb2");
    reg_model_apb2.build();  //NOTE2: not same as build_phase: reg_model2 is an object
    reg_model_apb2.lock_model();
  end
    // set the register model for the rest2 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb2", reg_model_apb2);
    uvm_config_object::set(this, "*uart02*", "reg_model2", reg_model_apb2.uart0_rm2);
    uvm_config_object::set(this, "*uart12*", "reg_model2", reg_model_apb2.uart1_rm2);


  endfunction : build_env2

  function void connect_phase(uvm_phase phase);
    ahb_monitor2 user_ahb_monitor2;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb2 = reg_to_ahb_adapter2::type_id::create("reg2ahb2");
    reg_model_apb2.default_map.set_sequencer(ahb02.master_agent2.sequencer, reg2ahb2);  //
    reg_model_apb2.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor2, ahb02.master_agent2.monitor2))
        `uvm_fatal("CASTFL2", "Failed2 to cast master2 monitor2 to user_ahb_monitor2");

      // ***********************************************************
      //  Hookup2 virtual sequencer to interface sequencers2
      // ***********************************************************
        virtual_sequencer2.ahb_seqr2 =  ahb02.master_agent2.sequencer;
      if (uart02.Tx2.is_active == UVM_ACTIVE)  
        virtual_sequencer2.uart0_seqr2 =  uart02.Tx2.sequencer;
      if (uart12.Tx2.is_active == UVM_ACTIVE)  
        virtual_sequencer2.uart1_seqr2 =  uart12.Tx2.sequencer;
      if (spi02.agents2[0].is_active == UVM_ACTIVE)  
        virtual_sequencer2.spi0_seqr2 =  spi02.agents2[0].sequencer;
      if (gpio02.agents2[0].is_active == UVM_ACTIVE)  
        virtual_sequencer2.gpio0_seqr2 =  gpio02.agents2[0].sequencer;

      virtual_sequencer2.reg_model_ptr2 = reg_model_apb2;

      apb_ss_env2.monitor2.set_slave_config2(apb_ss_cfg2.uart_cfg02.apb_cfg2.slave_configs2[0]);
      apb_ss_env2.apb_uart02.set_slave_config2(apb_ss_cfg2.uart_cfg02.apb_cfg2.slave_configs2[1], 1);
      apb_ss_env2.apb_uart12.set_slave_config2(apb_ss_cfg2.uart_cfg12.apb_cfg2.slave_configs2[3], 3);

      // ***********************************************************
      // Connect2 TLM ports2
      // ***********************************************************
      uart02.Rx2.monitor2.frame_collected_port2.connect(apb_ss_env2.apb_uart02.monitor2.uart_rx_in2);
      uart02.Tx2.monitor2.frame_collected_port2.connect(apb_ss_env2.apb_uart02.monitor2.uart_tx_in2);
      apb02.bus_monitor2.item_collected_port2.connect(apb_ss_env2.apb_uart02.monitor2.apb_in2);
      apb02.bus_monitor2.item_collected_port2.connect(apb_ss_env2.apb_uart02.apb_in2);
      user_ahb_monitor2.ahb_transfer_out2.connect(apb_ss_env2.monitor2.rx_scbd2.ahb_add2);
      user_ahb_monitor2.ahb_transfer_out2.connect(apb_ss_env2.ahb_in2);
      spi02.agents2[0].monitor2.item_collected_port2.connect(apb_ss_env2.monitor2.rx_scbd2.spi_match2);


      uart12.Rx2.monitor2.frame_collected_port2.connect(apb_ss_env2.apb_uart12.monitor2.uart_rx_in2);
      uart12.Tx2.monitor2.frame_collected_port2.connect(apb_ss_env2.apb_uart12.monitor2.uart_tx_in2);
      apb02.bus_monitor2.item_collected_port2.connect(apb_ss_env2.apb_uart12.monitor2.apb_in2);
      apb02.bus_monitor2.item_collected_port2.connect(apb_ss_env2.apb_uart12.apb_in2);

      // ***********************************************************
      // Connect2 the dut_csr2 ports2
      // ***********************************************************
      apb_ss_env2.spi_csr_out2.connect(apb_ss_env2.monitor2.dut_csr_port_in2);
      apb_ss_env2.spi_csr_out2.connect(spi02.dut_csr_port_in2);
      apb_ss_env2.gpio_csr_out2.connect(gpio02.dut_csr_port_in2);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env2();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY2",("APB2 SubSystem2 Virtual Sequence Testbench2 Topology2:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("                         _____2                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("                        | AHB2 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("                        | UVC2 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("                   ____________2    _________2               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("                  | AHB2 - APB2  |  | APB2 UVC2 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("                  |   Bridge2   |  | Passive2 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("  _____2    _____2    ______2    _______2    _____2    _______2  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",(" | SPI2 |  | SMC2 |  | GPIO2 |  | UART02 |  | PCM2 |  | UART12 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("  _____2              ______2    _______2            _______2  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",(" | SPI2 |            | GPIO2 |  | UART02 |          | UART12 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",(" | UVC2 |            | UVC2  |  |  UVC2  |          |  UVC2  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY2",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER2 MODEL2:\n", reg_model_apb2.sprint()}, UVM_LOW)
  endtask

endclass
