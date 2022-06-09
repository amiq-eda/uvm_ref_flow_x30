/*-------------------------------------------------------------------------
File21 name   : apb_subsystem_top_tb21.sv
Title21       : Simulation21 and Verification21 Environment21
Project21     :
Created21     :
Description21 : This21 file implements21 the SVE21 for the AHB21-UART21 Environment21
Notes21       : The apb_subsystem_tb21 creates21 the UART21 env21, the 
            : APB21 env21 and the scoreboard21. It also randomizes21 the UART21 
            : CSR21 settings21 and passes21 it to both the env21's.
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation21 Verification21 Environment21 (SVE21)
//--------------------------------------------------------------
class apb_subsystem_tb21 extends uvm_env;

  apb_subsystem_virtual_sequencer21 virtual_sequencer21;  // multi-channel21 sequencer
  ahb_pkg21::ahb_env21 ahb021;                          // AHB21 UVC21
  apb_pkg21::apb_env21 apb021;                          // APB21 UVC21
  uart_pkg21::uart_env21 uart021;                   // UART21 UVC21 connected21 to UART021
  uart_pkg21::uart_env21 uart121;                   // UART21 UVC21 connected21 to UART121
  spi_pkg21::spi_env21 spi021;                      // SPI21 UVC21 connected21 to SPI021
  gpio_pkg21::gpio_env21 gpio021;                   // GPIO21 UVC21 connected21 to GPIO021
  apb_subsystem_env21 apb_ss_env21;

  // UVM_REG
  apb_ss_reg_model_c21 reg_model_apb21;    // Register Model21
  reg_to_ahb_adapter21 reg2ahb21;         // Adapter Object - REG to APB21
  uvm_reg_predictor#(ahb_transfer21) ahb_predictor21; //Predictor21 - APB21 to REG

  apb_subsystem_pkg21::apb_subsystem_config21 apb_ss_cfg21;

  // enable automation21 for  apb_subsystem_tb21
  `uvm_component_utils_begin(apb_subsystem_tb21)
     `uvm_field_object(reg_model_apb21, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb21, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg21, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb21", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env21();
     // Configure21 UVCs21
    if (!uvm_config_db#(apb_subsystem_config21)::get(this, "", "apb_ss_cfg21", apb_ss_cfg21)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config21, creating21...", UVM_LOW)
      apb_ss_cfg21 = apb_subsystem_config21::type_id::create("apb_ss_cfg21", this);
      apb_ss_cfg21.uart_cfg021.apb_cfg21.add_master21("master21", UVM_PASSIVE);
      apb_ss_cfg21.uart_cfg021.apb_cfg21.add_slave21("spi021",  `AM_SPI0_BASE_ADDRESS21,  `AM_SPI0_END_ADDRESS21,  0, UVM_PASSIVE);
      apb_ss_cfg21.uart_cfg021.apb_cfg21.add_slave21("uart021", `AM_UART0_BASE_ADDRESS21, `AM_UART0_END_ADDRESS21, 0, UVM_PASSIVE);
      apb_ss_cfg21.uart_cfg021.apb_cfg21.add_slave21("gpio021", `AM_GPIO0_BASE_ADDRESS21, `AM_GPIO0_END_ADDRESS21, 0, UVM_PASSIVE);
      apb_ss_cfg21.uart_cfg021.apb_cfg21.add_slave21("uart121", `AM_UART1_BASE_ADDRESS21, `AM_UART1_END_ADDRESS21, 1, UVM_PASSIVE);
      apb_ss_cfg21.uart_cfg121.apb_cfg21.add_master21("master21", UVM_PASSIVE);
      apb_ss_cfg21.uart_cfg121.apb_cfg21.add_slave21("spi021",  `AM_SPI0_BASE_ADDRESS21,  `AM_SPI0_END_ADDRESS21,  0, UVM_PASSIVE);
      apb_ss_cfg21.uart_cfg121.apb_cfg21.add_slave21("uart021", `AM_UART0_BASE_ADDRESS21, `AM_UART0_END_ADDRESS21, 0, UVM_PASSIVE);
      apb_ss_cfg21.uart_cfg121.apb_cfg21.add_slave21("gpio021", `AM_GPIO0_BASE_ADDRESS21, `AM_GPIO0_END_ADDRESS21, 0, UVM_PASSIVE);
      apb_ss_cfg21.uart_cfg121.apb_cfg21.add_slave21("uart121", `AM_UART1_BASE_ADDRESS21, `AM_UART1_END_ADDRESS21, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing21 apb21 subsystem21 config:\n", apb_ss_cfg21.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config21)::set(this, "apb021", "cfg", apb_ss_cfg21.uart_cfg021.apb_cfg21);
     uvm_config_db#(uart_config21)::set(this, "uart021", "cfg", apb_ss_cfg21.uart_cfg021.uart_cfg21);
     uvm_config_db#(uart_config21)::set(this, "uart121", "cfg", apb_ss_cfg21.uart_cfg121.uart_cfg21);
     uvm_config_db#(uart_ctrl_config21)::set(this, "apb_ss_env21.apb_uart021", "cfg", apb_ss_cfg21.uart_cfg021);
     uvm_config_db#(uart_ctrl_config21)::set(this, "apb_ss_env21.apb_uart121", "cfg", apb_ss_cfg21.uart_cfg121);
     uvm_config_db#(apb_slave_config21)::set(this, "apb_ss_env21.apb_uart021", "apb_slave_cfg21", apb_ss_cfg21.uart_cfg021.apb_cfg21.slave_configs21[1]);
     uvm_config_db#(apb_slave_config21)::set(this, "apb_ss_env21.apb_uart121", "apb_slave_cfg21", apb_ss_cfg21.uart_cfg121.apb_cfg21.slave_configs21[3]);
     set_config_object("spi021", "spi_ve_config21", apb_ss_cfg21.spi_cfg21, 0);
     set_config_object("gpio021", "gpio_ve_config21", apb_ss_cfg21.gpio_cfg21, 0);

     set_config_int("*spi021.agents21[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio021.agents21[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb021.master_agent21","is_active", UVM_ACTIVE);  
     set_config_int("*ahb021.slave_agent21","is_active", UVM_PASSIVE);
     set_config_int("*uart021.Tx21","is_active", UVM_ACTIVE);  
     set_config_int("*uart021.Rx21","is_active", UVM_PASSIVE);
     set_config_int("*uart121.Tx21","is_active", UVM_ACTIVE);  
     set_config_int("*uart121.Rx21","is_active", UVM_PASSIVE);

     // Allocate21 objects21
     virtual_sequencer21 = apb_subsystem_virtual_sequencer21::type_id::create("virtual_sequencer21",this);
     ahb021              = ahb_pkg21::ahb_env21::type_id::create("ahb021",this);
     apb021              = apb_pkg21::apb_env21::type_id::create("apb021",this);
     uart021             = uart_pkg21::uart_env21::type_id::create("uart021",this);
     uart121             = uart_pkg21::uart_env21::type_id::create("uart121",this);
     spi021              = spi_pkg21::spi_env21::type_id::create("spi021",this);
     gpio021             = gpio_pkg21::gpio_env21::type_id::create("gpio021",this);
     apb_ss_env21        = apb_subsystem_env21::type_id::create("apb_ss_env21",this);

  //UVM_REG
  ahb_predictor21 = uvm_reg_predictor#(ahb_transfer21)::type_id::create("ahb_predictor21", this);
  if (reg_model_apb21 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb21 = apb_ss_reg_model_c21::type_id::create("reg_model_apb21");
    reg_model_apb21.build();  //NOTE21: not same as build_phase: reg_model21 is an object
    reg_model_apb21.lock_model();
  end
    // set the register model for the rest21 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb21", reg_model_apb21);
    uvm_config_object::set(this, "*uart021*", "reg_model21", reg_model_apb21.uart0_rm21);
    uvm_config_object::set(this, "*uart121*", "reg_model21", reg_model_apb21.uart1_rm21);


  endfunction : build_env21

  function void connect_phase(uvm_phase phase);
    ahb_monitor21 user_ahb_monitor21;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb21 = reg_to_ahb_adapter21::type_id::create("reg2ahb21");
    reg_model_apb21.default_map.set_sequencer(ahb021.master_agent21.sequencer, reg2ahb21);  //
    reg_model_apb21.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor21, ahb021.master_agent21.monitor21))
        `uvm_fatal("CASTFL21", "Failed21 to cast master21 monitor21 to user_ahb_monitor21");

      // ***********************************************************
      //  Hookup21 virtual sequencer to interface sequencers21
      // ***********************************************************
        virtual_sequencer21.ahb_seqr21 =  ahb021.master_agent21.sequencer;
      if (uart021.Tx21.is_active == UVM_ACTIVE)  
        virtual_sequencer21.uart0_seqr21 =  uart021.Tx21.sequencer;
      if (uart121.Tx21.is_active == UVM_ACTIVE)  
        virtual_sequencer21.uart1_seqr21 =  uart121.Tx21.sequencer;
      if (spi021.agents21[0].is_active == UVM_ACTIVE)  
        virtual_sequencer21.spi0_seqr21 =  spi021.agents21[0].sequencer;
      if (gpio021.agents21[0].is_active == UVM_ACTIVE)  
        virtual_sequencer21.gpio0_seqr21 =  gpio021.agents21[0].sequencer;

      virtual_sequencer21.reg_model_ptr21 = reg_model_apb21;

      apb_ss_env21.monitor21.set_slave_config21(apb_ss_cfg21.uart_cfg021.apb_cfg21.slave_configs21[0]);
      apb_ss_env21.apb_uart021.set_slave_config21(apb_ss_cfg21.uart_cfg021.apb_cfg21.slave_configs21[1], 1);
      apb_ss_env21.apb_uart121.set_slave_config21(apb_ss_cfg21.uart_cfg121.apb_cfg21.slave_configs21[3], 3);

      // ***********************************************************
      // Connect21 TLM ports21
      // ***********************************************************
      uart021.Rx21.monitor21.frame_collected_port21.connect(apb_ss_env21.apb_uart021.monitor21.uart_rx_in21);
      uart021.Tx21.monitor21.frame_collected_port21.connect(apb_ss_env21.apb_uart021.monitor21.uart_tx_in21);
      apb021.bus_monitor21.item_collected_port21.connect(apb_ss_env21.apb_uart021.monitor21.apb_in21);
      apb021.bus_monitor21.item_collected_port21.connect(apb_ss_env21.apb_uart021.apb_in21);
      user_ahb_monitor21.ahb_transfer_out21.connect(apb_ss_env21.monitor21.rx_scbd21.ahb_add21);
      user_ahb_monitor21.ahb_transfer_out21.connect(apb_ss_env21.ahb_in21);
      spi021.agents21[0].monitor21.item_collected_port21.connect(apb_ss_env21.monitor21.rx_scbd21.spi_match21);


      uart121.Rx21.monitor21.frame_collected_port21.connect(apb_ss_env21.apb_uart121.monitor21.uart_rx_in21);
      uart121.Tx21.monitor21.frame_collected_port21.connect(apb_ss_env21.apb_uart121.monitor21.uart_tx_in21);
      apb021.bus_monitor21.item_collected_port21.connect(apb_ss_env21.apb_uart121.monitor21.apb_in21);
      apb021.bus_monitor21.item_collected_port21.connect(apb_ss_env21.apb_uart121.apb_in21);

      // ***********************************************************
      // Connect21 the dut_csr21 ports21
      // ***********************************************************
      apb_ss_env21.spi_csr_out21.connect(apb_ss_env21.monitor21.dut_csr_port_in21);
      apb_ss_env21.spi_csr_out21.connect(spi021.dut_csr_port_in21);
      apb_ss_env21.gpio_csr_out21.connect(gpio021.dut_csr_port_in21);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env21();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY21",("APB21 SubSystem21 Virtual Sequence Testbench21 Topology21:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("                         _____21                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("                        | AHB21 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("                        | UVC21 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("                   ____________21    _________21               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("                  | AHB21 - APB21  |  | APB21 UVC21 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("                  |   Bridge21   |  | Passive21 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("  _____21    _____21    ______21    _______21    _____21    _______21  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",(" | SPI21 |  | SMC21 |  | GPIO21 |  | UART021 |  | PCM21 |  | UART121 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("  _____21              ______21    _______21            _______21  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",(" | SPI21 |            | GPIO21 |  | UART021 |          | UART121 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",(" | UVC21 |            | UVC21  |  |  UVC21  |          |  UVC21  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY21",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER21 MODEL21:\n", reg_model_apb21.sprint()}, UVM_LOW)
  endtask

endclass
