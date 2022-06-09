/*-------------------------------------------------------------------------
File30 name   : apb_subsystem_top_tb30.sv
Title30       : Simulation30 and Verification30 Environment30
Project30     :
Created30     :
Description30 : This30 file implements30 the SVE30 for the AHB30-UART30 Environment30
Notes30       : The apb_subsystem_tb30 creates30 the UART30 env30, the 
            : APB30 env30 and the scoreboard30. It also randomizes30 the UART30 
            : CSR30 settings30 and passes30 it to both the env30's.
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation30 Verification30 Environment30 (SVE30)
//--------------------------------------------------------------
class apb_subsystem_tb30 extends uvm_env;

  apb_subsystem_virtual_sequencer30 virtual_sequencer30;  // multi-channel30 sequencer
  ahb_pkg30::ahb_env30 ahb030;                          // AHB30 UVC30
  apb_pkg30::apb_env30 apb030;                          // APB30 UVC30
  uart_pkg30::uart_env30 uart030;                   // UART30 UVC30 connected30 to UART030
  uart_pkg30::uart_env30 uart130;                   // UART30 UVC30 connected30 to UART130
  spi_pkg30::spi_env30 spi030;                      // SPI30 UVC30 connected30 to SPI030
  gpio_pkg30::gpio_env30 gpio030;                   // GPIO30 UVC30 connected30 to GPIO030
  apb_subsystem_env30 apb_ss_env30;

  // UVM_REG
  apb_ss_reg_model_c30 reg_model_apb30;    // Register Model30
  reg_to_ahb_adapter30 reg2ahb30;         // Adapter Object - REG to APB30
  uvm_reg_predictor#(ahb_transfer30) ahb_predictor30; //Predictor30 - APB30 to REG

  apb_subsystem_pkg30::apb_subsystem_config30 apb_ss_cfg30;

  // enable automation30 for  apb_subsystem_tb30
  `uvm_component_utils_begin(apb_subsystem_tb30)
     `uvm_field_object(reg_model_apb30, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb30, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg30, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb30", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env30();
     // Configure30 UVCs30
    if (!uvm_config_db#(apb_subsystem_config30)::get(this, "", "apb_ss_cfg30", apb_ss_cfg30)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config30, creating30...", UVM_LOW)
      apb_ss_cfg30 = apb_subsystem_config30::type_id::create("apb_ss_cfg30", this);
      apb_ss_cfg30.uart_cfg030.apb_cfg30.add_master30("master30", UVM_PASSIVE);
      apb_ss_cfg30.uart_cfg030.apb_cfg30.add_slave30("spi030",  `AM_SPI0_BASE_ADDRESS30,  `AM_SPI0_END_ADDRESS30,  0, UVM_PASSIVE);
      apb_ss_cfg30.uart_cfg030.apb_cfg30.add_slave30("uart030", `AM_UART0_BASE_ADDRESS30, `AM_UART0_END_ADDRESS30, 0, UVM_PASSIVE);
      apb_ss_cfg30.uart_cfg030.apb_cfg30.add_slave30("gpio030", `AM_GPIO0_BASE_ADDRESS30, `AM_GPIO0_END_ADDRESS30, 0, UVM_PASSIVE);
      apb_ss_cfg30.uart_cfg030.apb_cfg30.add_slave30("uart130", `AM_UART1_BASE_ADDRESS30, `AM_UART1_END_ADDRESS30, 1, UVM_PASSIVE);
      apb_ss_cfg30.uart_cfg130.apb_cfg30.add_master30("master30", UVM_PASSIVE);
      apb_ss_cfg30.uart_cfg130.apb_cfg30.add_slave30("spi030",  `AM_SPI0_BASE_ADDRESS30,  `AM_SPI0_END_ADDRESS30,  0, UVM_PASSIVE);
      apb_ss_cfg30.uart_cfg130.apb_cfg30.add_slave30("uart030", `AM_UART0_BASE_ADDRESS30, `AM_UART0_END_ADDRESS30, 0, UVM_PASSIVE);
      apb_ss_cfg30.uart_cfg130.apb_cfg30.add_slave30("gpio030", `AM_GPIO0_BASE_ADDRESS30, `AM_GPIO0_END_ADDRESS30, 0, UVM_PASSIVE);
      apb_ss_cfg30.uart_cfg130.apb_cfg30.add_slave30("uart130", `AM_UART1_BASE_ADDRESS30, `AM_UART1_END_ADDRESS30, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing30 apb30 subsystem30 config:\n", apb_ss_cfg30.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config30)::set(this, "apb030", "cfg", apb_ss_cfg30.uart_cfg030.apb_cfg30);
     uvm_config_db#(uart_config30)::set(this, "uart030", "cfg", apb_ss_cfg30.uart_cfg030.uart_cfg30);
     uvm_config_db#(uart_config30)::set(this, "uart130", "cfg", apb_ss_cfg30.uart_cfg130.uart_cfg30);
     uvm_config_db#(uart_ctrl_config30)::set(this, "apb_ss_env30.apb_uart030", "cfg", apb_ss_cfg30.uart_cfg030);
     uvm_config_db#(uart_ctrl_config30)::set(this, "apb_ss_env30.apb_uart130", "cfg", apb_ss_cfg30.uart_cfg130);
     uvm_config_db#(apb_slave_config30)::set(this, "apb_ss_env30.apb_uart030", "apb_slave_cfg30", apb_ss_cfg30.uart_cfg030.apb_cfg30.slave_configs30[1]);
     uvm_config_db#(apb_slave_config30)::set(this, "apb_ss_env30.apb_uart130", "apb_slave_cfg30", apb_ss_cfg30.uart_cfg130.apb_cfg30.slave_configs30[3]);
     set_config_object("spi030", "spi_ve_config30", apb_ss_cfg30.spi_cfg30, 0);
     set_config_object("gpio030", "gpio_ve_config30", apb_ss_cfg30.gpio_cfg30, 0);

     set_config_int("*spi030.agents30[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio030.agents30[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb030.master_agent30","is_active", UVM_ACTIVE);  
     set_config_int("*ahb030.slave_agent30","is_active", UVM_PASSIVE);
     set_config_int("*uart030.Tx30","is_active", UVM_ACTIVE);  
     set_config_int("*uart030.Rx30","is_active", UVM_PASSIVE);
     set_config_int("*uart130.Tx30","is_active", UVM_ACTIVE);  
     set_config_int("*uart130.Rx30","is_active", UVM_PASSIVE);

     // Allocate30 objects30
     virtual_sequencer30 = apb_subsystem_virtual_sequencer30::type_id::create("virtual_sequencer30",this);
     ahb030              = ahb_pkg30::ahb_env30::type_id::create("ahb030",this);
     apb030              = apb_pkg30::apb_env30::type_id::create("apb030",this);
     uart030             = uart_pkg30::uart_env30::type_id::create("uart030",this);
     uart130             = uart_pkg30::uart_env30::type_id::create("uart130",this);
     spi030              = spi_pkg30::spi_env30::type_id::create("spi030",this);
     gpio030             = gpio_pkg30::gpio_env30::type_id::create("gpio030",this);
     apb_ss_env30        = apb_subsystem_env30::type_id::create("apb_ss_env30",this);

  //UVM_REG
  ahb_predictor30 = uvm_reg_predictor#(ahb_transfer30)::type_id::create("ahb_predictor30", this);
  if (reg_model_apb30 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb30 = apb_ss_reg_model_c30::type_id::create("reg_model_apb30");
    reg_model_apb30.build();  //NOTE30: not same as build_phase: reg_model30 is an object
    reg_model_apb30.lock_model();
  end
    // set the register model for the rest30 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb30", reg_model_apb30);
    uvm_config_object::set(this, "*uart030*", "reg_model30", reg_model_apb30.uart0_rm30);
    uvm_config_object::set(this, "*uart130*", "reg_model30", reg_model_apb30.uart1_rm30);


  endfunction : build_env30

  function void connect_phase(uvm_phase phase);
    ahb_monitor30 user_ahb_monitor30;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb30 = reg_to_ahb_adapter30::type_id::create("reg2ahb30");
    reg_model_apb30.default_map.set_sequencer(ahb030.master_agent30.sequencer, reg2ahb30);  //
    reg_model_apb30.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor30, ahb030.master_agent30.monitor30))
        `uvm_fatal("CASTFL30", "Failed30 to cast master30 monitor30 to user_ahb_monitor30");

      // ***********************************************************
      //  Hookup30 virtual sequencer to interface sequencers30
      // ***********************************************************
        virtual_sequencer30.ahb_seqr30 =  ahb030.master_agent30.sequencer;
      if (uart030.Tx30.is_active == UVM_ACTIVE)  
        virtual_sequencer30.uart0_seqr30 =  uart030.Tx30.sequencer;
      if (uart130.Tx30.is_active == UVM_ACTIVE)  
        virtual_sequencer30.uart1_seqr30 =  uart130.Tx30.sequencer;
      if (spi030.agents30[0].is_active == UVM_ACTIVE)  
        virtual_sequencer30.spi0_seqr30 =  spi030.agents30[0].sequencer;
      if (gpio030.agents30[0].is_active == UVM_ACTIVE)  
        virtual_sequencer30.gpio0_seqr30 =  gpio030.agents30[0].sequencer;

      virtual_sequencer30.reg_model_ptr30 = reg_model_apb30;

      apb_ss_env30.monitor30.set_slave_config30(apb_ss_cfg30.uart_cfg030.apb_cfg30.slave_configs30[0]);
      apb_ss_env30.apb_uart030.set_slave_config30(apb_ss_cfg30.uart_cfg030.apb_cfg30.slave_configs30[1], 1);
      apb_ss_env30.apb_uart130.set_slave_config30(apb_ss_cfg30.uart_cfg130.apb_cfg30.slave_configs30[3], 3);

      // ***********************************************************
      // Connect30 TLM ports30
      // ***********************************************************
      uart030.Rx30.monitor30.frame_collected_port30.connect(apb_ss_env30.apb_uart030.monitor30.uart_rx_in30);
      uart030.Tx30.monitor30.frame_collected_port30.connect(apb_ss_env30.apb_uart030.monitor30.uart_tx_in30);
      apb030.bus_monitor30.item_collected_port30.connect(apb_ss_env30.apb_uart030.monitor30.apb_in30);
      apb030.bus_monitor30.item_collected_port30.connect(apb_ss_env30.apb_uart030.apb_in30);
      user_ahb_monitor30.ahb_transfer_out30.connect(apb_ss_env30.monitor30.rx_scbd30.ahb_add30);
      user_ahb_monitor30.ahb_transfer_out30.connect(apb_ss_env30.ahb_in30);
      spi030.agents30[0].monitor30.item_collected_port30.connect(apb_ss_env30.monitor30.rx_scbd30.spi_match30);


      uart130.Rx30.monitor30.frame_collected_port30.connect(apb_ss_env30.apb_uart130.monitor30.uart_rx_in30);
      uart130.Tx30.monitor30.frame_collected_port30.connect(apb_ss_env30.apb_uart130.monitor30.uart_tx_in30);
      apb030.bus_monitor30.item_collected_port30.connect(apb_ss_env30.apb_uart130.monitor30.apb_in30);
      apb030.bus_monitor30.item_collected_port30.connect(apb_ss_env30.apb_uart130.apb_in30);

      // ***********************************************************
      // Connect30 the dut_csr30 ports30
      // ***********************************************************
      apb_ss_env30.spi_csr_out30.connect(apb_ss_env30.monitor30.dut_csr_port_in30);
      apb_ss_env30.spi_csr_out30.connect(spi030.dut_csr_port_in30);
      apb_ss_env30.gpio_csr_out30.connect(gpio030.dut_csr_port_in30);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env30();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY30",("APB30 SubSystem30 Virtual Sequence Testbench30 Topology30:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("                         _____30                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("                        | AHB30 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("                        | UVC30 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("                   ____________30    _________30               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("                  | AHB30 - APB30  |  | APB30 UVC30 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("                  |   Bridge30   |  | Passive30 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("  _____30    _____30    ______30    _______30    _____30    _______30  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",(" | SPI30 |  | SMC30 |  | GPIO30 |  | UART030 |  | PCM30 |  | UART130 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("  _____30              ______30    _______30            _______30  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",(" | SPI30 |            | GPIO30 |  | UART030 |          | UART130 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",(" | UVC30 |            | UVC30  |  |  UVC30  |          |  UVC30  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY30",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER30 MODEL30:\n", reg_model_apb30.sprint()}, UVM_LOW)
  endtask

endclass
