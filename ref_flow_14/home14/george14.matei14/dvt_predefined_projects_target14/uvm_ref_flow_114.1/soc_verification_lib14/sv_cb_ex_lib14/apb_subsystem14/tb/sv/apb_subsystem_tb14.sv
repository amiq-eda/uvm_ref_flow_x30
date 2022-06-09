/*-------------------------------------------------------------------------
File14 name   : apb_subsystem_top_tb14.sv
Title14       : Simulation14 and Verification14 Environment14
Project14     :
Created14     :
Description14 : This14 file implements14 the SVE14 for the AHB14-UART14 Environment14
Notes14       : The apb_subsystem_tb14 creates14 the UART14 env14, the 
            : APB14 env14 and the scoreboard14. It also randomizes14 the UART14 
            : CSR14 settings14 and passes14 it to both the env14's.
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation14 Verification14 Environment14 (SVE14)
//--------------------------------------------------------------
class apb_subsystem_tb14 extends uvm_env;

  apb_subsystem_virtual_sequencer14 virtual_sequencer14;  // multi-channel14 sequencer
  ahb_pkg14::ahb_env14 ahb014;                          // AHB14 UVC14
  apb_pkg14::apb_env14 apb014;                          // APB14 UVC14
  uart_pkg14::uart_env14 uart014;                   // UART14 UVC14 connected14 to UART014
  uart_pkg14::uart_env14 uart114;                   // UART14 UVC14 connected14 to UART114
  spi_pkg14::spi_env14 spi014;                      // SPI14 UVC14 connected14 to SPI014
  gpio_pkg14::gpio_env14 gpio014;                   // GPIO14 UVC14 connected14 to GPIO014
  apb_subsystem_env14 apb_ss_env14;

  // UVM_REG
  apb_ss_reg_model_c14 reg_model_apb14;    // Register Model14
  reg_to_ahb_adapter14 reg2ahb14;         // Adapter Object - REG to APB14
  uvm_reg_predictor#(ahb_transfer14) ahb_predictor14; //Predictor14 - APB14 to REG

  apb_subsystem_pkg14::apb_subsystem_config14 apb_ss_cfg14;

  // enable automation14 for  apb_subsystem_tb14
  `uvm_component_utils_begin(apb_subsystem_tb14)
     `uvm_field_object(reg_model_apb14, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb14, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg14, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb14", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env14();
     // Configure14 UVCs14
    if (!uvm_config_db#(apb_subsystem_config14)::get(this, "", "apb_ss_cfg14", apb_ss_cfg14)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config14, creating14...", UVM_LOW)
      apb_ss_cfg14 = apb_subsystem_config14::type_id::create("apb_ss_cfg14", this);
      apb_ss_cfg14.uart_cfg014.apb_cfg14.add_master14("master14", UVM_PASSIVE);
      apb_ss_cfg14.uart_cfg014.apb_cfg14.add_slave14("spi014",  `AM_SPI0_BASE_ADDRESS14,  `AM_SPI0_END_ADDRESS14,  0, UVM_PASSIVE);
      apb_ss_cfg14.uart_cfg014.apb_cfg14.add_slave14("uart014", `AM_UART0_BASE_ADDRESS14, `AM_UART0_END_ADDRESS14, 0, UVM_PASSIVE);
      apb_ss_cfg14.uart_cfg014.apb_cfg14.add_slave14("gpio014", `AM_GPIO0_BASE_ADDRESS14, `AM_GPIO0_END_ADDRESS14, 0, UVM_PASSIVE);
      apb_ss_cfg14.uart_cfg014.apb_cfg14.add_slave14("uart114", `AM_UART1_BASE_ADDRESS14, `AM_UART1_END_ADDRESS14, 1, UVM_PASSIVE);
      apb_ss_cfg14.uart_cfg114.apb_cfg14.add_master14("master14", UVM_PASSIVE);
      apb_ss_cfg14.uart_cfg114.apb_cfg14.add_slave14("spi014",  `AM_SPI0_BASE_ADDRESS14,  `AM_SPI0_END_ADDRESS14,  0, UVM_PASSIVE);
      apb_ss_cfg14.uart_cfg114.apb_cfg14.add_slave14("uart014", `AM_UART0_BASE_ADDRESS14, `AM_UART0_END_ADDRESS14, 0, UVM_PASSIVE);
      apb_ss_cfg14.uart_cfg114.apb_cfg14.add_slave14("gpio014", `AM_GPIO0_BASE_ADDRESS14, `AM_GPIO0_END_ADDRESS14, 0, UVM_PASSIVE);
      apb_ss_cfg14.uart_cfg114.apb_cfg14.add_slave14("uart114", `AM_UART1_BASE_ADDRESS14, `AM_UART1_END_ADDRESS14, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing14 apb14 subsystem14 config:\n", apb_ss_cfg14.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config14)::set(this, "apb014", "cfg", apb_ss_cfg14.uart_cfg014.apb_cfg14);
     uvm_config_db#(uart_config14)::set(this, "uart014", "cfg", apb_ss_cfg14.uart_cfg014.uart_cfg14);
     uvm_config_db#(uart_config14)::set(this, "uart114", "cfg", apb_ss_cfg14.uart_cfg114.uart_cfg14);
     uvm_config_db#(uart_ctrl_config14)::set(this, "apb_ss_env14.apb_uart014", "cfg", apb_ss_cfg14.uart_cfg014);
     uvm_config_db#(uart_ctrl_config14)::set(this, "apb_ss_env14.apb_uart114", "cfg", apb_ss_cfg14.uart_cfg114);
     uvm_config_db#(apb_slave_config14)::set(this, "apb_ss_env14.apb_uart014", "apb_slave_cfg14", apb_ss_cfg14.uart_cfg014.apb_cfg14.slave_configs14[1]);
     uvm_config_db#(apb_slave_config14)::set(this, "apb_ss_env14.apb_uart114", "apb_slave_cfg14", apb_ss_cfg14.uart_cfg114.apb_cfg14.slave_configs14[3]);
     set_config_object("spi014", "spi_ve_config14", apb_ss_cfg14.spi_cfg14, 0);
     set_config_object("gpio014", "gpio_ve_config14", apb_ss_cfg14.gpio_cfg14, 0);

     set_config_int("*spi014.agents14[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio014.agents14[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb014.master_agent14","is_active", UVM_ACTIVE);  
     set_config_int("*ahb014.slave_agent14","is_active", UVM_PASSIVE);
     set_config_int("*uart014.Tx14","is_active", UVM_ACTIVE);  
     set_config_int("*uart014.Rx14","is_active", UVM_PASSIVE);
     set_config_int("*uart114.Tx14","is_active", UVM_ACTIVE);  
     set_config_int("*uart114.Rx14","is_active", UVM_PASSIVE);

     // Allocate14 objects14
     virtual_sequencer14 = apb_subsystem_virtual_sequencer14::type_id::create("virtual_sequencer14",this);
     ahb014              = ahb_pkg14::ahb_env14::type_id::create("ahb014",this);
     apb014              = apb_pkg14::apb_env14::type_id::create("apb014",this);
     uart014             = uart_pkg14::uart_env14::type_id::create("uart014",this);
     uart114             = uart_pkg14::uart_env14::type_id::create("uart114",this);
     spi014              = spi_pkg14::spi_env14::type_id::create("spi014",this);
     gpio014             = gpio_pkg14::gpio_env14::type_id::create("gpio014",this);
     apb_ss_env14        = apb_subsystem_env14::type_id::create("apb_ss_env14",this);

  //UVM_REG
  ahb_predictor14 = uvm_reg_predictor#(ahb_transfer14)::type_id::create("ahb_predictor14", this);
  if (reg_model_apb14 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb14 = apb_ss_reg_model_c14::type_id::create("reg_model_apb14");
    reg_model_apb14.build();  //NOTE14: not same as build_phase: reg_model14 is an object
    reg_model_apb14.lock_model();
  end
    // set the register model for the rest14 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb14", reg_model_apb14);
    uvm_config_object::set(this, "*uart014*", "reg_model14", reg_model_apb14.uart0_rm14);
    uvm_config_object::set(this, "*uart114*", "reg_model14", reg_model_apb14.uart1_rm14);


  endfunction : build_env14

  function void connect_phase(uvm_phase phase);
    ahb_monitor14 user_ahb_monitor14;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb14 = reg_to_ahb_adapter14::type_id::create("reg2ahb14");
    reg_model_apb14.default_map.set_sequencer(ahb014.master_agent14.sequencer, reg2ahb14);  //
    reg_model_apb14.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor14, ahb014.master_agent14.monitor14))
        `uvm_fatal("CASTFL14", "Failed14 to cast master14 monitor14 to user_ahb_monitor14");

      // ***********************************************************
      //  Hookup14 virtual sequencer to interface sequencers14
      // ***********************************************************
        virtual_sequencer14.ahb_seqr14 =  ahb014.master_agent14.sequencer;
      if (uart014.Tx14.is_active == UVM_ACTIVE)  
        virtual_sequencer14.uart0_seqr14 =  uart014.Tx14.sequencer;
      if (uart114.Tx14.is_active == UVM_ACTIVE)  
        virtual_sequencer14.uart1_seqr14 =  uart114.Tx14.sequencer;
      if (spi014.agents14[0].is_active == UVM_ACTIVE)  
        virtual_sequencer14.spi0_seqr14 =  spi014.agents14[0].sequencer;
      if (gpio014.agents14[0].is_active == UVM_ACTIVE)  
        virtual_sequencer14.gpio0_seqr14 =  gpio014.agents14[0].sequencer;

      virtual_sequencer14.reg_model_ptr14 = reg_model_apb14;

      apb_ss_env14.monitor14.set_slave_config14(apb_ss_cfg14.uart_cfg014.apb_cfg14.slave_configs14[0]);
      apb_ss_env14.apb_uart014.set_slave_config14(apb_ss_cfg14.uart_cfg014.apb_cfg14.slave_configs14[1], 1);
      apb_ss_env14.apb_uart114.set_slave_config14(apb_ss_cfg14.uart_cfg114.apb_cfg14.slave_configs14[3], 3);

      // ***********************************************************
      // Connect14 TLM ports14
      // ***********************************************************
      uart014.Rx14.monitor14.frame_collected_port14.connect(apb_ss_env14.apb_uart014.monitor14.uart_rx_in14);
      uart014.Tx14.monitor14.frame_collected_port14.connect(apb_ss_env14.apb_uart014.monitor14.uart_tx_in14);
      apb014.bus_monitor14.item_collected_port14.connect(apb_ss_env14.apb_uart014.monitor14.apb_in14);
      apb014.bus_monitor14.item_collected_port14.connect(apb_ss_env14.apb_uart014.apb_in14);
      user_ahb_monitor14.ahb_transfer_out14.connect(apb_ss_env14.monitor14.rx_scbd14.ahb_add14);
      user_ahb_monitor14.ahb_transfer_out14.connect(apb_ss_env14.ahb_in14);
      spi014.agents14[0].monitor14.item_collected_port14.connect(apb_ss_env14.monitor14.rx_scbd14.spi_match14);


      uart114.Rx14.monitor14.frame_collected_port14.connect(apb_ss_env14.apb_uart114.monitor14.uart_rx_in14);
      uart114.Tx14.monitor14.frame_collected_port14.connect(apb_ss_env14.apb_uart114.monitor14.uart_tx_in14);
      apb014.bus_monitor14.item_collected_port14.connect(apb_ss_env14.apb_uart114.monitor14.apb_in14);
      apb014.bus_monitor14.item_collected_port14.connect(apb_ss_env14.apb_uart114.apb_in14);

      // ***********************************************************
      // Connect14 the dut_csr14 ports14
      // ***********************************************************
      apb_ss_env14.spi_csr_out14.connect(apb_ss_env14.monitor14.dut_csr_port_in14);
      apb_ss_env14.spi_csr_out14.connect(spi014.dut_csr_port_in14);
      apb_ss_env14.gpio_csr_out14.connect(gpio014.dut_csr_port_in14);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env14();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY14",("APB14 SubSystem14 Virtual Sequence Testbench14 Topology14:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("                         _____14                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("                        | AHB14 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("                        | UVC14 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("                   ____________14    _________14               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("                  | AHB14 - APB14  |  | APB14 UVC14 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("                  |   Bridge14   |  | Passive14 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("  _____14    _____14    ______14    _______14    _____14    _______14  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",(" | SPI14 |  | SMC14 |  | GPIO14 |  | UART014 |  | PCM14 |  | UART114 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("  _____14              ______14    _______14            _______14  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",(" | SPI14 |            | GPIO14 |  | UART014 |          | UART114 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",(" | UVC14 |            | UVC14  |  |  UVC14  |          |  UVC14  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY14",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER14 MODEL14:\n", reg_model_apb14.sprint()}, UVM_LOW)
  endtask

endclass
