/*-------------------------------------------------------------------------
File20 name   : apb_subsystem_top_tb20.sv
Title20       : Simulation20 and Verification20 Environment20
Project20     :
Created20     :
Description20 : This20 file implements20 the SVE20 for the AHB20-UART20 Environment20
Notes20       : The apb_subsystem_tb20 creates20 the UART20 env20, the 
            : APB20 env20 and the scoreboard20. It also randomizes20 the UART20 
            : CSR20 settings20 and passes20 it to both the env20's.
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation20 Verification20 Environment20 (SVE20)
//--------------------------------------------------------------
class apb_subsystem_tb20 extends uvm_env;

  apb_subsystem_virtual_sequencer20 virtual_sequencer20;  // multi-channel20 sequencer
  ahb_pkg20::ahb_env20 ahb020;                          // AHB20 UVC20
  apb_pkg20::apb_env20 apb020;                          // APB20 UVC20
  uart_pkg20::uart_env20 uart020;                   // UART20 UVC20 connected20 to UART020
  uart_pkg20::uart_env20 uart120;                   // UART20 UVC20 connected20 to UART120
  spi_pkg20::spi_env20 spi020;                      // SPI20 UVC20 connected20 to SPI020
  gpio_pkg20::gpio_env20 gpio020;                   // GPIO20 UVC20 connected20 to GPIO020
  apb_subsystem_env20 apb_ss_env20;

  // UVM_REG
  apb_ss_reg_model_c20 reg_model_apb20;    // Register Model20
  reg_to_ahb_adapter20 reg2ahb20;         // Adapter Object - REG to APB20
  uvm_reg_predictor#(ahb_transfer20) ahb_predictor20; //Predictor20 - APB20 to REG

  apb_subsystem_pkg20::apb_subsystem_config20 apb_ss_cfg20;

  // enable automation20 for  apb_subsystem_tb20
  `uvm_component_utils_begin(apb_subsystem_tb20)
     `uvm_field_object(reg_model_apb20, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb20, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg20, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb20", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env20();
     // Configure20 UVCs20
    if (!uvm_config_db#(apb_subsystem_config20)::get(this, "", "apb_ss_cfg20", apb_ss_cfg20)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config20, creating20...", UVM_LOW)
      apb_ss_cfg20 = apb_subsystem_config20::type_id::create("apb_ss_cfg20", this);
      apb_ss_cfg20.uart_cfg020.apb_cfg20.add_master20("master20", UVM_PASSIVE);
      apb_ss_cfg20.uart_cfg020.apb_cfg20.add_slave20("spi020",  `AM_SPI0_BASE_ADDRESS20,  `AM_SPI0_END_ADDRESS20,  0, UVM_PASSIVE);
      apb_ss_cfg20.uart_cfg020.apb_cfg20.add_slave20("uart020", `AM_UART0_BASE_ADDRESS20, `AM_UART0_END_ADDRESS20, 0, UVM_PASSIVE);
      apb_ss_cfg20.uart_cfg020.apb_cfg20.add_slave20("gpio020", `AM_GPIO0_BASE_ADDRESS20, `AM_GPIO0_END_ADDRESS20, 0, UVM_PASSIVE);
      apb_ss_cfg20.uart_cfg020.apb_cfg20.add_slave20("uart120", `AM_UART1_BASE_ADDRESS20, `AM_UART1_END_ADDRESS20, 1, UVM_PASSIVE);
      apb_ss_cfg20.uart_cfg120.apb_cfg20.add_master20("master20", UVM_PASSIVE);
      apb_ss_cfg20.uart_cfg120.apb_cfg20.add_slave20("spi020",  `AM_SPI0_BASE_ADDRESS20,  `AM_SPI0_END_ADDRESS20,  0, UVM_PASSIVE);
      apb_ss_cfg20.uart_cfg120.apb_cfg20.add_slave20("uart020", `AM_UART0_BASE_ADDRESS20, `AM_UART0_END_ADDRESS20, 0, UVM_PASSIVE);
      apb_ss_cfg20.uart_cfg120.apb_cfg20.add_slave20("gpio020", `AM_GPIO0_BASE_ADDRESS20, `AM_GPIO0_END_ADDRESS20, 0, UVM_PASSIVE);
      apb_ss_cfg20.uart_cfg120.apb_cfg20.add_slave20("uart120", `AM_UART1_BASE_ADDRESS20, `AM_UART1_END_ADDRESS20, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing20 apb20 subsystem20 config:\n", apb_ss_cfg20.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config20)::set(this, "apb020", "cfg", apb_ss_cfg20.uart_cfg020.apb_cfg20);
     uvm_config_db#(uart_config20)::set(this, "uart020", "cfg", apb_ss_cfg20.uart_cfg020.uart_cfg20);
     uvm_config_db#(uart_config20)::set(this, "uart120", "cfg", apb_ss_cfg20.uart_cfg120.uart_cfg20);
     uvm_config_db#(uart_ctrl_config20)::set(this, "apb_ss_env20.apb_uart020", "cfg", apb_ss_cfg20.uart_cfg020);
     uvm_config_db#(uart_ctrl_config20)::set(this, "apb_ss_env20.apb_uart120", "cfg", apb_ss_cfg20.uart_cfg120);
     uvm_config_db#(apb_slave_config20)::set(this, "apb_ss_env20.apb_uart020", "apb_slave_cfg20", apb_ss_cfg20.uart_cfg020.apb_cfg20.slave_configs20[1]);
     uvm_config_db#(apb_slave_config20)::set(this, "apb_ss_env20.apb_uart120", "apb_slave_cfg20", apb_ss_cfg20.uart_cfg120.apb_cfg20.slave_configs20[3]);
     set_config_object("spi020", "spi_ve_config20", apb_ss_cfg20.spi_cfg20, 0);
     set_config_object("gpio020", "gpio_ve_config20", apb_ss_cfg20.gpio_cfg20, 0);

     set_config_int("*spi020.agents20[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio020.agents20[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb020.master_agent20","is_active", UVM_ACTIVE);  
     set_config_int("*ahb020.slave_agent20","is_active", UVM_PASSIVE);
     set_config_int("*uart020.Tx20","is_active", UVM_ACTIVE);  
     set_config_int("*uart020.Rx20","is_active", UVM_PASSIVE);
     set_config_int("*uart120.Tx20","is_active", UVM_ACTIVE);  
     set_config_int("*uart120.Rx20","is_active", UVM_PASSIVE);

     // Allocate20 objects20
     virtual_sequencer20 = apb_subsystem_virtual_sequencer20::type_id::create("virtual_sequencer20",this);
     ahb020              = ahb_pkg20::ahb_env20::type_id::create("ahb020",this);
     apb020              = apb_pkg20::apb_env20::type_id::create("apb020",this);
     uart020             = uart_pkg20::uart_env20::type_id::create("uart020",this);
     uart120             = uart_pkg20::uart_env20::type_id::create("uart120",this);
     spi020              = spi_pkg20::spi_env20::type_id::create("spi020",this);
     gpio020             = gpio_pkg20::gpio_env20::type_id::create("gpio020",this);
     apb_ss_env20        = apb_subsystem_env20::type_id::create("apb_ss_env20",this);

  //UVM_REG
  ahb_predictor20 = uvm_reg_predictor#(ahb_transfer20)::type_id::create("ahb_predictor20", this);
  if (reg_model_apb20 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb20 = apb_ss_reg_model_c20::type_id::create("reg_model_apb20");
    reg_model_apb20.build();  //NOTE20: not same as build_phase: reg_model20 is an object
    reg_model_apb20.lock_model();
  end
    // set the register model for the rest20 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb20", reg_model_apb20);
    uvm_config_object::set(this, "*uart020*", "reg_model20", reg_model_apb20.uart0_rm20);
    uvm_config_object::set(this, "*uart120*", "reg_model20", reg_model_apb20.uart1_rm20);


  endfunction : build_env20

  function void connect_phase(uvm_phase phase);
    ahb_monitor20 user_ahb_monitor20;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb20 = reg_to_ahb_adapter20::type_id::create("reg2ahb20");
    reg_model_apb20.default_map.set_sequencer(ahb020.master_agent20.sequencer, reg2ahb20);  //
    reg_model_apb20.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor20, ahb020.master_agent20.monitor20))
        `uvm_fatal("CASTFL20", "Failed20 to cast master20 monitor20 to user_ahb_monitor20");

      // ***********************************************************
      //  Hookup20 virtual sequencer to interface sequencers20
      // ***********************************************************
        virtual_sequencer20.ahb_seqr20 =  ahb020.master_agent20.sequencer;
      if (uart020.Tx20.is_active == UVM_ACTIVE)  
        virtual_sequencer20.uart0_seqr20 =  uart020.Tx20.sequencer;
      if (uart120.Tx20.is_active == UVM_ACTIVE)  
        virtual_sequencer20.uart1_seqr20 =  uart120.Tx20.sequencer;
      if (spi020.agents20[0].is_active == UVM_ACTIVE)  
        virtual_sequencer20.spi0_seqr20 =  spi020.agents20[0].sequencer;
      if (gpio020.agents20[0].is_active == UVM_ACTIVE)  
        virtual_sequencer20.gpio0_seqr20 =  gpio020.agents20[0].sequencer;

      virtual_sequencer20.reg_model_ptr20 = reg_model_apb20;

      apb_ss_env20.monitor20.set_slave_config20(apb_ss_cfg20.uart_cfg020.apb_cfg20.slave_configs20[0]);
      apb_ss_env20.apb_uart020.set_slave_config20(apb_ss_cfg20.uart_cfg020.apb_cfg20.slave_configs20[1], 1);
      apb_ss_env20.apb_uart120.set_slave_config20(apb_ss_cfg20.uart_cfg120.apb_cfg20.slave_configs20[3], 3);

      // ***********************************************************
      // Connect20 TLM ports20
      // ***********************************************************
      uart020.Rx20.monitor20.frame_collected_port20.connect(apb_ss_env20.apb_uart020.monitor20.uart_rx_in20);
      uart020.Tx20.monitor20.frame_collected_port20.connect(apb_ss_env20.apb_uart020.monitor20.uart_tx_in20);
      apb020.bus_monitor20.item_collected_port20.connect(apb_ss_env20.apb_uart020.monitor20.apb_in20);
      apb020.bus_monitor20.item_collected_port20.connect(apb_ss_env20.apb_uart020.apb_in20);
      user_ahb_monitor20.ahb_transfer_out20.connect(apb_ss_env20.monitor20.rx_scbd20.ahb_add20);
      user_ahb_monitor20.ahb_transfer_out20.connect(apb_ss_env20.ahb_in20);
      spi020.agents20[0].monitor20.item_collected_port20.connect(apb_ss_env20.monitor20.rx_scbd20.spi_match20);


      uart120.Rx20.monitor20.frame_collected_port20.connect(apb_ss_env20.apb_uart120.monitor20.uart_rx_in20);
      uart120.Tx20.monitor20.frame_collected_port20.connect(apb_ss_env20.apb_uart120.monitor20.uart_tx_in20);
      apb020.bus_monitor20.item_collected_port20.connect(apb_ss_env20.apb_uart120.monitor20.apb_in20);
      apb020.bus_monitor20.item_collected_port20.connect(apb_ss_env20.apb_uart120.apb_in20);

      // ***********************************************************
      // Connect20 the dut_csr20 ports20
      // ***********************************************************
      apb_ss_env20.spi_csr_out20.connect(apb_ss_env20.monitor20.dut_csr_port_in20);
      apb_ss_env20.spi_csr_out20.connect(spi020.dut_csr_port_in20);
      apb_ss_env20.gpio_csr_out20.connect(gpio020.dut_csr_port_in20);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env20();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY20",("APB20 SubSystem20 Virtual Sequence Testbench20 Topology20:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("                         _____20                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("                        | AHB20 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("                        | UVC20 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("                   ____________20    _________20               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("                  | AHB20 - APB20  |  | APB20 UVC20 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("                  |   Bridge20   |  | Passive20 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("  _____20    _____20    ______20    _______20    _____20    _______20  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",(" | SPI20 |  | SMC20 |  | GPIO20 |  | UART020 |  | PCM20 |  | UART120 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("  _____20              ______20    _______20            _______20  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",(" | SPI20 |            | GPIO20 |  | UART020 |          | UART120 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",(" | UVC20 |            | UVC20  |  |  UVC20  |          |  UVC20  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY20",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER20 MODEL20:\n", reg_model_apb20.sprint()}, UVM_LOW)
  endtask

endclass
