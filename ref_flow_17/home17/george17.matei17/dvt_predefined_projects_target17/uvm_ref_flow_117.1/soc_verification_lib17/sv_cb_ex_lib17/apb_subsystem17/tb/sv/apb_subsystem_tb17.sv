/*-------------------------------------------------------------------------
File17 name   : apb_subsystem_top_tb17.sv
Title17       : Simulation17 and Verification17 Environment17
Project17     :
Created17     :
Description17 : This17 file implements17 the SVE17 for the AHB17-UART17 Environment17
Notes17       : The apb_subsystem_tb17 creates17 the UART17 env17, the 
            : APB17 env17 and the scoreboard17. It also randomizes17 the UART17 
            : CSR17 settings17 and passes17 it to both the env17's.
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation17 Verification17 Environment17 (SVE17)
//--------------------------------------------------------------
class apb_subsystem_tb17 extends uvm_env;

  apb_subsystem_virtual_sequencer17 virtual_sequencer17;  // multi-channel17 sequencer
  ahb_pkg17::ahb_env17 ahb017;                          // AHB17 UVC17
  apb_pkg17::apb_env17 apb017;                          // APB17 UVC17
  uart_pkg17::uart_env17 uart017;                   // UART17 UVC17 connected17 to UART017
  uart_pkg17::uart_env17 uart117;                   // UART17 UVC17 connected17 to UART117
  spi_pkg17::spi_env17 spi017;                      // SPI17 UVC17 connected17 to SPI017
  gpio_pkg17::gpio_env17 gpio017;                   // GPIO17 UVC17 connected17 to GPIO017
  apb_subsystem_env17 apb_ss_env17;

  // UVM_REG
  apb_ss_reg_model_c17 reg_model_apb17;    // Register Model17
  reg_to_ahb_adapter17 reg2ahb17;         // Adapter Object - REG to APB17
  uvm_reg_predictor#(ahb_transfer17) ahb_predictor17; //Predictor17 - APB17 to REG

  apb_subsystem_pkg17::apb_subsystem_config17 apb_ss_cfg17;

  // enable automation17 for  apb_subsystem_tb17
  `uvm_component_utils_begin(apb_subsystem_tb17)
     `uvm_field_object(reg_model_apb17, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb17, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg17, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb17", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env17();
     // Configure17 UVCs17
    if (!uvm_config_db#(apb_subsystem_config17)::get(this, "", "apb_ss_cfg17", apb_ss_cfg17)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config17, creating17...", UVM_LOW)
      apb_ss_cfg17 = apb_subsystem_config17::type_id::create("apb_ss_cfg17", this);
      apb_ss_cfg17.uart_cfg017.apb_cfg17.add_master17("master17", UVM_PASSIVE);
      apb_ss_cfg17.uart_cfg017.apb_cfg17.add_slave17("spi017",  `AM_SPI0_BASE_ADDRESS17,  `AM_SPI0_END_ADDRESS17,  0, UVM_PASSIVE);
      apb_ss_cfg17.uart_cfg017.apb_cfg17.add_slave17("uart017", `AM_UART0_BASE_ADDRESS17, `AM_UART0_END_ADDRESS17, 0, UVM_PASSIVE);
      apb_ss_cfg17.uart_cfg017.apb_cfg17.add_slave17("gpio017", `AM_GPIO0_BASE_ADDRESS17, `AM_GPIO0_END_ADDRESS17, 0, UVM_PASSIVE);
      apb_ss_cfg17.uart_cfg017.apb_cfg17.add_slave17("uart117", `AM_UART1_BASE_ADDRESS17, `AM_UART1_END_ADDRESS17, 1, UVM_PASSIVE);
      apb_ss_cfg17.uart_cfg117.apb_cfg17.add_master17("master17", UVM_PASSIVE);
      apb_ss_cfg17.uart_cfg117.apb_cfg17.add_slave17("spi017",  `AM_SPI0_BASE_ADDRESS17,  `AM_SPI0_END_ADDRESS17,  0, UVM_PASSIVE);
      apb_ss_cfg17.uart_cfg117.apb_cfg17.add_slave17("uart017", `AM_UART0_BASE_ADDRESS17, `AM_UART0_END_ADDRESS17, 0, UVM_PASSIVE);
      apb_ss_cfg17.uart_cfg117.apb_cfg17.add_slave17("gpio017", `AM_GPIO0_BASE_ADDRESS17, `AM_GPIO0_END_ADDRESS17, 0, UVM_PASSIVE);
      apb_ss_cfg17.uart_cfg117.apb_cfg17.add_slave17("uart117", `AM_UART1_BASE_ADDRESS17, `AM_UART1_END_ADDRESS17, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing17 apb17 subsystem17 config:\n", apb_ss_cfg17.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config17)::set(this, "apb017", "cfg", apb_ss_cfg17.uart_cfg017.apb_cfg17);
     uvm_config_db#(uart_config17)::set(this, "uart017", "cfg", apb_ss_cfg17.uart_cfg017.uart_cfg17);
     uvm_config_db#(uart_config17)::set(this, "uart117", "cfg", apb_ss_cfg17.uart_cfg117.uart_cfg17);
     uvm_config_db#(uart_ctrl_config17)::set(this, "apb_ss_env17.apb_uart017", "cfg", apb_ss_cfg17.uart_cfg017);
     uvm_config_db#(uart_ctrl_config17)::set(this, "apb_ss_env17.apb_uart117", "cfg", apb_ss_cfg17.uart_cfg117);
     uvm_config_db#(apb_slave_config17)::set(this, "apb_ss_env17.apb_uart017", "apb_slave_cfg17", apb_ss_cfg17.uart_cfg017.apb_cfg17.slave_configs17[1]);
     uvm_config_db#(apb_slave_config17)::set(this, "apb_ss_env17.apb_uart117", "apb_slave_cfg17", apb_ss_cfg17.uart_cfg117.apb_cfg17.slave_configs17[3]);
     set_config_object("spi017", "spi_ve_config17", apb_ss_cfg17.spi_cfg17, 0);
     set_config_object("gpio017", "gpio_ve_config17", apb_ss_cfg17.gpio_cfg17, 0);

     set_config_int("*spi017.agents17[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio017.agents17[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb017.master_agent17","is_active", UVM_ACTIVE);  
     set_config_int("*ahb017.slave_agent17","is_active", UVM_PASSIVE);
     set_config_int("*uart017.Tx17","is_active", UVM_ACTIVE);  
     set_config_int("*uart017.Rx17","is_active", UVM_PASSIVE);
     set_config_int("*uart117.Tx17","is_active", UVM_ACTIVE);  
     set_config_int("*uart117.Rx17","is_active", UVM_PASSIVE);

     // Allocate17 objects17
     virtual_sequencer17 = apb_subsystem_virtual_sequencer17::type_id::create("virtual_sequencer17",this);
     ahb017              = ahb_pkg17::ahb_env17::type_id::create("ahb017",this);
     apb017              = apb_pkg17::apb_env17::type_id::create("apb017",this);
     uart017             = uart_pkg17::uart_env17::type_id::create("uart017",this);
     uart117             = uart_pkg17::uart_env17::type_id::create("uart117",this);
     spi017              = spi_pkg17::spi_env17::type_id::create("spi017",this);
     gpio017             = gpio_pkg17::gpio_env17::type_id::create("gpio017",this);
     apb_ss_env17        = apb_subsystem_env17::type_id::create("apb_ss_env17",this);

  //UVM_REG
  ahb_predictor17 = uvm_reg_predictor#(ahb_transfer17)::type_id::create("ahb_predictor17", this);
  if (reg_model_apb17 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb17 = apb_ss_reg_model_c17::type_id::create("reg_model_apb17");
    reg_model_apb17.build();  //NOTE17: not same as build_phase: reg_model17 is an object
    reg_model_apb17.lock_model();
  end
    // set the register model for the rest17 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb17", reg_model_apb17);
    uvm_config_object::set(this, "*uart017*", "reg_model17", reg_model_apb17.uart0_rm17);
    uvm_config_object::set(this, "*uart117*", "reg_model17", reg_model_apb17.uart1_rm17);


  endfunction : build_env17

  function void connect_phase(uvm_phase phase);
    ahb_monitor17 user_ahb_monitor17;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb17 = reg_to_ahb_adapter17::type_id::create("reg2ahb17");
    reg_model_apb17.default_map.set_sequencer(ahb017.master_agent17.sequencer, reg2ahb17);  //
    reg_model_apb17.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor17, ahb017.master_agent17.monitor17))
        `uvm_fatal("CASTFL17", "Failed17 to cast master17 monitor17 to user_ahb_monitor17");

      // ***********************************************************
      //  Hookup17 virtual sequencer to interface sequencers17
      // ***********************************************************
        virtual_sequencer17.ahb_seqr17 =  ahb017.master_agent17.sequencer;
      if (uart017.Tx17.is_active == UVM_ACTIVE)  
        virtual_sequencer17.uart0_seqr17 =  uart017.Tx17.sequencer;
      if (uart117.Tx17.is_active == UVM_ACTIVE)  
        virtual_sequencer17.uart1_seqr17 =  uart117.Tx17.sequencer;
      if (spi017.agents17[0].is_active == UVM_ACTIVE)  
        virtual_sequencer17.spi0_seqr17 =  spi017.agents17[0].sequencer;
      if (gpio017.agents17[0].is_active == UVM_ACTIVE)  
        virtual_sequencer17.gpio0_seqr17 =  gpio017.agents17[0].sequencer;

      virtual_sequencer17.reg_model_ptr17 = reg_model_apb17;

      apb_ss_env17.monitor17.set_slave_config17(apb_ss_cfg17.uart_cfg017.apb_cfg17.slave_configs17[0]);
      apb_ss_env17.apb_uart017.set_slave_config17(apb_ss_cfg17.uart_cfg017.apb_cfg17.slave_configs17[1], 1);
      apb_ss_env17.apb_uart117.set_slave_config17(apb_ss_cfg17.uart_cfg117.apb_cfg17.slave_configs17[3], 3);

      // ***********************************************************
      // Connect17 TLM ports17
      // ***********************************************************
      uart017.Rx17.monitor17.frame_collected_port17.connect(apb_ss_env17.apb_uart017.monitor17.uart_rx_in17);
      uart017.Tx17.monitor17.frame_collected_port17.connect(apb_ss_env17.apb_uart017.monitor17.uart_tx_in17);
      apb017.bus_monitor17.item_collected_port17.connect(apb_ss_env17.apb_uart017.monitor17.apb_in17);
      apb017.bus_monitor17.item_collected_port17.connect(apb_ss_env17.apb_uart017.apb_in17);
      user_ahb_monitor17.ahb_transfer_out17.connect(apb_ss_env17.monitor17.rx_scbd17.ahb_add17);
      user_ahb_monitor17.ahb_transfer_out17.connect(apb_ss_env17.ahb_in17);
      spi017.agents17[0].monitor17.item_collected_port17.connect(apb_ss_env17.monitor17.rx_scbd17.spi_match17);


      uart117.Rx17.monitor17.frame_collected_port17.connect(apb_ss_env17.apb_uart117.monitor17.uart_rx_in17);
      uart117.Tx17.monitor17.frame_collected_port17.connect(apb_ss_env17.apb_uart117.monitor17.uart_tx_in17);
      apb017.bus_monitor17.item_collected_port17.connect(apb_ss_env17.apb_uart117.monitor17.apb_in17);
      apb017.bus_monitor17.item_collected_port17.connect(apb_ss_env17.apb_uart117.apb_in17);

      // ***********************************************************
      // Connect17 the dut_csr17 ports17
      // ***********************************************************
      apb_ss_env17.spi_csr_out17.connect(apb_ss_env17.monitor17.dut_csr_port_in17);
      apb_ss_env17.spi_csr_out17.connect(spi017.dut_csr_port_in17);
      apb_ss_env17.gpio_csr_out17.connect(gpio017.dut_csr_port_in17);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env17();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY17",("APB17 SubSystem17 Virtual Sequence Testbench17 Topology17:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("                         _____17                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("                        | AHB17 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("                        | UVC17 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("                   ____________17    _________17               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("                  | AHB17 - APB17  |  | APB17 UVC17 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("                  |   Bridge17   |  | Passive17 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("  _____17    _____17    ______17    _______17    _____17    _______17  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",(" | SPI17 |  | SMC17 |  | GPIO17 |  | UART017 |  | PCM17 |  | UART117 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("  _____17              ______17    _______17            _______17  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",(" | SPI17 |            | GPIO17 |  | UART017 |          | UART117 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",(" | UVC17 |            | UVC17  |  |  UVC17  |          |  UVC17  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY17",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER17 MODEL17:\n", reg_model_apb17.sprint()}, UVM_LOW)
  endtask

endclass
