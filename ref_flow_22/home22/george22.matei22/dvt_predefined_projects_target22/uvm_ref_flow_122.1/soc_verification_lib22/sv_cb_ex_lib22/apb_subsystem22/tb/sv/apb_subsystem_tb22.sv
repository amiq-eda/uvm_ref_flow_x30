/*-------------------------------------------------------------------------
File22 name   : apb_subsystem_top_tb22.sv
Title22       : Simulation22 and Verification22 Environment22
Project22     :
Created22     :
Description22 : This22 file implements22 the SVE22 for the AHB22-UART22 Environment22
Notes22       : The apb_subsystem_tb22 creates22 the UART22 env22, the 
            : APB22 env22 and the scoreboard22. It also randomizes22 the UART22 
            : CSR22 settings22 and passes22 it to both the env22's.
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation22 Verification22 Environment22 (SVE22)
//--------------------------------------------------------------
class apb_subsystem_tb22 extends uvm_env;

  apb_subsystem_virtual_sequencer22 virtual_sequencer22;  // multi-channel22 sequencer
  ahb_pkg22::ahb_env22 ahb022;                          // AHB22 UVC22
  apb_pkg22::apb_env22 apb022;                          // APB22 UVC22
  uart_pkg22::uart_env22 uart022;                   // UART22 UVC22 connected22 to UART022
  uart_pkg22::uart_env22 uart122;                   // UART22 UVC22 connected22 to UART122
  spi_pkg22::spi_env22 spi022;                      // SPI22 UVC22 connected22 to SPI022
  gpio_pkg22::gpio_env22 gpio022;                   // GPIO22 UVC22 connected22 to GPIO022
  apb_subsystem_env22 apb_ss_env22;

  // UVM_REG
  apb_ss_reg_model_c22 reg_model_apb22;    // Register Model22
  reg_to_ahb_adapter22 reg2ahb22;         // Adapter Object - REG to APB22
  uvm_reg_predictor#(ahb_transfer22) ahb_predictor22; //Predictor22 - APB22 to REG

  apb_subsystem_pkg22::apb_subsystem_config22 apb_ss_cfg22;

  // enable automation22 for  apb_subsystem_tb22
  `uvm_component_utils_begin(apb_subsystem_tb22)
     `uvm_field_object(reg_model_apb22, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb22, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg22, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb22", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env22();
     // Configure22 UVCs22
    if (!uvm_config_db#(apb_subsystem_config22)::get(this, "", "apb_ss_cfg22", apb_ss_cfg22)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config22, creating22...", UVM_LOW)
      apb_ss_cfg22 = apb_subsystem_config22::type_id::create("apb_ss_cfg22", this);
      apb_ss_cfg22.uart_cfg022.apb_cfg22.add_master22("master22", UVM_PASSIVE);
      apb_ss_cfg22.uart_cfg022.apb_cfg22.add_slave22("spi022",  `AM_SPI0_BASE_ADDRESS22,  `AM_SPI0_END_ADDRESS22,  0, UVM_PASSIVE);
      apb_ss_cfg22.uart_cfg022.apb_cfg22.add_slave22("uart022", `AM_UART0_BASE_ADDRESS22, `AM_UART0_END_ADDRESS22, 0, UVM_PASSIVE);
      apb_ss_cfg22.uart_cfg022.apb_cfg22.add_slave22("gpio022", `AM_GPIO0_BASE_ADDRESS22, `AM_GPIO0_END_ADDRESS22, 0, UVM_PASSIVE);
      apb_ss_cfg22.uart_cfg022.apb_cfg22.add_slave22("uart122", `AM_UART1_BASE_ADDRESS22, `AM_UART1_END_ADDRESS22, 1, UVM_PASSIVE);
      apb_ss_cfg22.uart_cfg122.apb_cfg22.add_master22("master22", UVM_PASSIVE);
      apb_ss_cfg22.uart_cfg122.apb_cfg22.add_slave22("spi022",  `AM_SPI0_BASE_ADDRESS22,  `AM_SPI0_END_ADDRESS22,  0, UVM_PASSIVE);
      apb_ss_cfg22.uart_cfg122.apb_cfg22.add_slave22("uart022", `AM_UART0_BASE_ADDRESS22, `AM_UART0_END_ADDRESS22, 0, UVM_PASSIVE);
      apb_ss_cfg22.uart_cfg122.apb_cfg22.add_slave22("gpio022", `AM_GPIO0_BASE_ADDRESS22, `AM_GPIO0_END_ADDRESS22, 0, UVM_PASSIVE);
      apb_ss_cfg22.uart_cfg122.apb_cfg22.add_slave22("uart122", `AM_UART1_BASE_ADDRESS22, `AM_UART1_END_ADDRESS22, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing22 apb22 subsystem22 config:\n", apb_ss_cfg22.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config22)::set(this, "apb022", "cfg", apb_ss_cfg22.uart_cfg022.apb_cfg22);
     uvm_config_db#(uart_config22)::set(this, "uart022", "cfg", apb_ss_cfg22.uart_cfg022.uart_cfg22);
     uvm_config_db#(uart_config22)::set(this, "uart122", "cfg", apb_ss_cfg22.uart_cfg122.uart_cfg22);
     uvm_config_db#(uart_ctrl_config22)::set(this, "apb_ss_env22.apb_uart022", "cfg", apb_ss_cfg22.uart_cfg022);
     uvm_config_db#(uart_ctrl_config22)::set(this, "apb_ss_env22.apb_uart122", "cfg", apb_ss_cfg22.uart_cfg122);
     uvm_config_db#(apb_slave_config22)::set(this, "apb_ss_env22.apb_uart022", "apb_slave_cfg22", apb_ss_cfg22.uart_cfg022.apb_cfg22.slave_configs22[1]);
     uvm_config_db#(apb_slave_config22)::set(this, "apb_ss_env22.apb_uart122", "apb_slave_cfg22", apb_ss_cfg22.uart_cfg122.apb_cfg22.slave_configs22[3]);
     set_config_object("spi022", "spi_ve_config22", apb_ss_cfg22.spi_cfg22, 0);
     set_config_object("gpio022", "gpio_ve_config22", apb_ss_cfg22.gpio_cfg22, 0);

     set_config_int("*spi022.agents22[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio022.agents22[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb022.master_agent22","is_active", UVM_ACTIVE);  
     set_config_int("*ahb022.slave_agent22","is_active", UVM_PASSIVE);
     set_config_int("*uart022.Tx22","is_active", UVM_ACTIVE);  
     set_config_int("*uart022.Rx22","is_active", UVM_PASSIVE);
     set_config_int("*uart122.Tx22","is_active", UVM_ACTIVE);  
     set_config_int("*uart122.Rx22","is_active", UVM_PASSIVE);

     // Allocate22 objects22
     virtual_sequencer22 = apb_subsystem_virtual_sequencer22::type_id::create("virtual_sequencer22",this);
     ahb022              = ahb_pkg22::ahb_env22::type_id::create("ahb022",this);
     apb022              = apb_pkg22::apb_env22::type_id::create("apb022",this);
     uart022             = uart_pkg22::uart_env22::type_id::create("uart022",this);
     uart122             = uart_pkg22::uart_env22::type_id::create("uart122",this);
     spi022              = spi_pkg22::spi_env22::type_id::create("spi022",this);
     gpio022             = gpio_pkg22::gpio_env22::type_id::create("gpio022",this);
     apb_ss_env22        = apb_subsystem_env22::type_id::create("apb_ss_env22",this);

  //UVM_REG
  ahb_predictor22 = uvm_reg_predictor#(ahb_transfer22)::type_id::create("ahb_predictor22", this);
  if (reg_model_apb22 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb22 = apb_ss_reg_model_c22::type_id::create("reg_model_apb22");
    reg_model_apb22.build();  //NOTE22: not same as build_phase: reg_model22 is an object
    reg_model_apb22.lock_model();
  end
    // set the register model for the rest22 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb22", reg_model_apb22);
    uvm_config_object::set(this, "*uart022*", "reg_model22", reg_model_apb22.uart0_rm22);
    uvm_config_object::set(this, "*uart122*", "reg_model22", reg_model_apb22.uart1_rm22);


  endfunction : build_env22

  function void connect_phase(uvm_phase phase);
    ahb_monitor22 user_ahb_monitor22;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb22 = reg_to_ahb_adapter22::type_id::create("reg2ahb22");
    reg_model_apb22.default_map.set_sequencer(ahb022.master_agent22.sequencer, reg2ahb22);  //
    reg_model_apb22.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor22, ahb022.master_agent22.monitor22))
        `uvm_fatal("CASTFL22", "Failed22 to cast master22 monitor22 to user_ahb_monitor22");

      // ***********************************************************
      //  Hookup22 virtual sequencer to interface sequencers22
      // ***********************************************************
        virtual_sequencer22.ahb_seqr22 =  ahb022.master_agent22.sequencer;
      if (uart022.Tx22.is_active == UVM_ACTIVE)  
        virtual_sequencer22.uart0_seqr22 =  uart022.Tx22.sequencer;
      if (uart122.Tx22.is_active == UVM_ACTIVE)  
        virtual_sequencer22.uart1_seqr22 =  uart122.Tx22.sequencer;
      if (spi022.agents22[0].is_active == UVM_ACTIVE)  
        virtual_sequencer22.spi0_seqr22 =  spi022.agents22[0].sequencer;
      if (gpio022.agents22[0].is_active == UVM_ACTIVE)  
        virtual_sequencer22.gpio0_seqr22 =  gpio022.agents22[0].sequencer;

      virtual_sequencer22.reg_model_ptr22 = reg_model_apb22;

      apb_ss_env22.monitor22.set_slave_config22(apb_ss_cfg22.uart_cfg022.apb_cfg22.slave_configs22[0]);
      apb_ss_env22.apb_uart022.set_slave_config22(apb_ss_cfg22.uart_cfg022.apb_cfg22.slave_configs22[1], 1);
      apb_ss_env22.apb_uart122.set_slave_config22(apb_ss_cfg22.uart_cfg122.apb_cfg22.slave_configs22[3], 3);

      // ***********************************************************
      // Connect22 TLM ports22
      // ***********************************************************
      uart022.Rx22.monitor22.frame_collected_port22.connect(apb_ss_env22.apb_uart022.monitor22.uart_rx_in22);
      uart022.Tx22.monitor22.frame_collected_port22.connect(apb_ss_env22.apb_uart022.monitor22.uart_tx_in22);
      apb022.bus_monitor22.item_collected_port22.connect(apb_ss_env22.apb_uart022.monitor22.apb_in22);
      apb022.bus_monitor22.item_collected_port22.connect(apb_ss_env22.apb_uart022.apb_in22);
      user_ahb_monitor22.ahb_transfer_out22.connect(apb_ss_env22.monitor22.rx_scbd22.ahb_add22);
      user_ahb_monitor22.ahb_transfer_out22.connect(apb_ss_env22.ahb_in22);
      spi022.agents22[0].monitor22.item_collected_port22.connect(apb_ss_env22.monitor22.rx_scbd22.spi_match22);


      uart122.Rx22.monitor22.frame_collected_port22.connect(apb_ss_env22.apb_uart122.monitor22.uart_rx_in22);
      uart122.Tx22.monitor22.frame_collected_port22.connect(apb_ss_env22.apb_uart122.monitor22.uart_tx_in22);
      apb022.bus_monitor22.item_collected_port22.connect(apb_ss_env22.apb_uart122.monitor22.apb_in22);
      apb022.bus_monitor22.item_collected_port22.connect(apb_ss_env22.apb_uart122.apb_in22);

      // ***********************************************************
      // Connect22 the dut_csr22 ports22
      // ***********************************************************
      apb_ss_env22.spi_csr_out22.connect(apb_ss_env22.monitor22.dut_csr_port_in22);
      apb_ss_env22.spi_csr_out22.connect(spi022.dut_csr_port_in22);
      apb_ss_env22.gpio_csr_out22.connect(gpio022.dut_csr_port_in22);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env22();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY22",("APB22 SubSystem22 Virtual Sequence Testbench22 Topology22:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("                         _____22                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("                        | AHB22 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("                        | UVC22 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("                   ____________22    _________22               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("                  | AHB22 - APB22  |  | APB22 UVC22 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("                  |   Bridge22   |  | Passive22 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("  _____22    _____22    ______22    _______22    _____22    _______22  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",(" | SPI22 |  | SMC22 |  | GPIO22 |  | UART022 |  | PCM22 |  | UART122 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("  _____22              ______22    _______22            _______22  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",(" | SPI22 |            | GPIO22 |  | UART022 |          | UART122 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",(" | UVC22 |            | UVC22  |  |  UVC22  |          |  UVC22  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY22",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER22 MODEL22:\n", reg_model_apb22.sprint()}, UVM_LOW)
  endtask

endclass
