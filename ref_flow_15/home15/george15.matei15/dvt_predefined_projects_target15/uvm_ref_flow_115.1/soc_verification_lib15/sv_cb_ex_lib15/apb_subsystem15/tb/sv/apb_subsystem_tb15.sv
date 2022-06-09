/*-------------------------------------------------------------------------
File15 name   : apb_subsystem_top_tb15.sv
Title15       : Simulation15 and Verification15 Environment15
Project15     :
Created15     :
Description15 : This15 file implements15 the SVE15 for the AHB15-UART15 Environment15
Notes15       : The apb_subsystem_tb15 creates15 the UART15 env15, the 
            : APB15 env15 and the scoreboard15. It also randomizes15 the UART15 
            : CSR15 settings15 and passes15 it to both the env15's.
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation15 Verification15 Environment15 (SVE15)
//--------------------------------------------------------------
class apb_subsystem_tb15 extends uvm_env;

  apb_subsystem_virtual_sequencer15 virtual_sequencer15;  // multi-channel15 sequencer
  ahb_pkg15::ahb_env15 ahb015;                          // AHB15 UVC15
  apb_pkg15::apb_env15 apb015;                          // APB15 UVC15
  uart_pkg15::uart_env15 uart015;                   // UART15 UVC15 connected15 to UART015
  uart_pkg15::uart_env15 uart115;                   // UART15 UVC15 connected15 to UART115
  spi_pkg15::spi_env15 spi015;                      // SPI15 UVC15 connected15 to SPI015
  gpio_pkg15::gpio_env15 gpio015;                   // GPIO15 UVC15 connected15 to GPIO015
  apb_subsystem_env15 apb_ss_env15;

  // UVM_REG
  apb_ss_reg_model_c15 reg_model_apb15;    // Register Model15
  reg_to_ahb_adapter15 reg2ahb15;         // Adapter Object - REG to APB15
  uvm_reg_predictor#(ahb_transfer15) ahb_predictor15; //Predictor15 - APB15 to REG

  apb_subsystem_pkg15::apb_subsystem_config15 apb_ss_cfg15;

  // enable automation15 for  apb_subsystem_tb15
  `uvm_component_utils_begin(apb_subsystem_tb15)
     `uvm_field_object(reg_model_apb15, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb15, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg15, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb15", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env15();
     // Configure15 UVCs15
    if (!uvm_config_db#(apb_subsystem_config15)::get(this, "", "apb_ss_cfg15", apb_ss_cfg15)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config15, creating15...", UVM_LOW)
      apb_ss_cfg15 = apb_subsystem_config15::type_id::create("apb_ss_cfg15", this);
      apb_ss_cfg15.uart_cfg015.apb_cfg15.add_master15("master15", UVM_PASSIVE);
      apb_ss_cfg15.uart_cfg015.apb_cfg15.add_slave15("spi015",  `AM_SPI0_BASE_ADDRESS15,  `AM_SPI0_END_ADDRESS15,  0, UVM_PASSIVE);
      apb_ss_cfg15.uart_cfg015.apb_cfg15.add_slave15("uart015", `AM_UART0_BASE_ADDRESS15, `AM_UART0_END_ADDRESS15, 0, UVM_PASSIVE);
      apb_ss_cfg15.uart_cfg015.apb_cfg15.add_slave15("gpio015", `AM_GPIO0_BASE_ADDRESS15, `AM_GPIO0_END_ADDRESS15, 0, UVM_PASSIVE);
      apb_ss_cfg15.uart_cfg015.apb_cfg15.add_slave15("uart115", `AM_UART1_BASE_ADDRESS15, `AM_UART1_END_ADDRESS15, 1, UVM_PASSIVE);
      apb_ss_cfg15.uart_cfg115.apb_cfg15.add_master15("master15", UVM_PASSIVE);
      apb_ss_cfg15.uart_cfg115.apb_cfg15.add_slave15("spi015",  `AM_SPI0_BASE_ADDRESS15,  `AM_SPI0_END_ADDRESS15,  0, UVM_PASSIVE);
      apb_ss_cfg15.uart_cfg115.apb_cfg15.add_slave15("uart015", `AM_UART0_BASE_ADDRESS15, `AM_UART0_END_ADDRESS15, 0, UVM_PASSIVE);
      apb_ss_cfg15.uart_cfg115.apb_cfg15.add_slave15("gpio015", `AM_GPIO0_BASE_ADDRESS15, `AM_GPIO0_END_ADDRESS15, 0, UVM_PASSIVE);
      apb_ss_cfg15.uart_cfg115.apb_cfg15.add_slave15("uart115", `AM_UART1_BASE_ADDRESS15, `AM_UART1_END_ADDRESS15, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing15 apb15 subsystem15 config:\n", apb_ss_cfg15.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config15)::set(this, "apb015", "cfg", apb_ss_cfg15.uart_cfg015.apb_cfg15);
     uvm_config_db#(uart_config15)::set(this, "uart015", "cfg", apb_ss_cfg15.uart_cfg015.uart_cfg15);
     uvm_config_db#(uart_config15)::set(this, "uart115", "cfg", apb_ss_cfg15.uart_cfg115.uart_cfg15);
     uvm_config_db#(uart_ctrl_config15)::set(this, "apb_ss_env15.apb_uart015", "cfg", apb_ss_cfg15.uart_cfg015);
     uvm_config_db#(uart_ctrl_config15)::set(this, "apb_ss_env15.apb_uart115", "cfg", apb_ss_cfg15.uart_cfg115);
     uvm_config_db#(apb_slave_config15)::set(this, "apb_ss_env15.apb_uart015", "apb_slave_cfg15", apb_ss_cfg15.uart_cfg015.apb_cfg15.slave_configs15[1]);
     uvm_config_db#(apb_slave_config15)::set(this, "apb_ss_env15.apb_uart115", "apb_slave_cfg15", apb_ss_cfg15.uart_cfg115.apb_cfg15.slave_configs15[3]);
     set_config_object("spi015", "spi_ve_config15", apb_ss_cfg15.spi_cfg15, 0);
     set_config_object("gpio015", "gpio_ve_config15", apb_ss_cfg15.gpio_cfg15, 0);

     set_config_int("*spi015.agents15[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio015.agents15[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb015.master_agent15","is_active", UVM_ACTIVE);  
     set_config_int("*ahb015.slave_agent15","is_active", UVM_PASSIVE);
     set_config_int("*uart015.Tx15","is_active", UVM_ACTIVE);  
     set_config_int("*uart015.Rx15","is_active", UVM_PASSIVE);
     set_config_int("*uart115.Tx15","is_active", UVM_ACTIVE);  
     set_config_int("*uart115.Rx15","is_active", UVM_PASSIVE);

     // Allocate15 objects15
     virtual_sequencer15 = apb_subsystem_virtual_sequencer15::type_id::create("virtual_sequencer15",this);
     ahb015              = ahb_pkg15::ahb_env15::type_id::create("ahb015",this);
     apb015              = apb_pkg15::apb_env15::type_id::create("apb015",this);
     uart015             = uart_pkg15::uart_env15::type_id::create("uart015",this);
     uart115             = uart_pkg15::uart_env15::type_id::create("uart115",this);
     spi015              = spi_pkg15::spi_env15::type_id::create("spi015",this);
     gpio015             = gpio_pkg15::gpio_env15::type_id::create("gpio015",this);
     apb_ss_env15        = apb_subsystem_env15::type_id::create("apb_ss_env15",this);

  //UVM_REG
  ahb_predictor15 = uvm_reg_predictor#(ahb_transfer15)::type_id::create("ahb_predictor15", this);
  if (reg_model_apb15 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb15 = apb_ss_reg_model_c15::type_id::create("reg_model_apb15");
    reg_model_apb15.build();  //NOTE15: not same as build_phase: reg_model15 is an object
    reg_model_apb15.lock_model();
  end
    // set the register model for the rest15 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb15", reg_model_apb15);
    uvm_config_object::set(this, "*uart015*", "reg_model15", reg_model_apb15.uart0_rm15);
    uvm_config_object::set(this, "*uart115*", "reg_model15", reg_model_apb15.uart1_rm15);


  endfunction : build_env15

  function void connect_phase(uvm_phase phase);
    ahb_monitor15 user_ahb_monitor15;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb15 = reg_to_ahb_adapter15::type_id::create("reg2ahb15");
    reg_model_apb15.default_map.set_sequencer(ahb015.master_agent15.sequencer, reg2ahb15);  //
    reg_model_apb15.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor15, ahb015.master_agent15.monitor15))
        `uvm_fatal("CASTFL15", "Failed15 to cast master15 monitor15 to user_ahb_monitor15");

      // ***********************************************************
      //  Hookup15 virtual sequencer to interface sequencers15
      // ***********************************************************
        virtual_sequencer15.ahb_seqr15 =  ahb015.master_agent15.sequencer;
      if (uart015.Tx15.is_active == UVM_ACTIVE)  
        virtual_sequencer15.uart0_seqr15 =  uart015.Tx15.sequencer;
      if (uart115.Tx15.is_active == UVM_ACTIVE)  
        virtual_sequencer15.uart1_seqr15 =  uart115.Tx15.sequencer;
      if (spi015.agents15[0].is_active == UVM_ACTIVE)  
        virtual_sequencer15.spi0_seqr15 =  spi015.agents15[0].sequencer;
      if (gpio015.agents15[0].is_active == UVM_ACTIVE)  
        virtual_sequencer15.gpio0_seqr15 =  gpio015.agents15[0].sequencer;

      virtual_sequencer15.reg_model_ptr15 = reg_model_apb15;

      apb_ss_env15.monitor15.set_slave_config15(apb_ss_cfg15.uart_cfg015.apb_cfg15.slave_configs15[0]);
      apb_ss_env15.apb_uart015.set_slave_config15(apb_ss_cfg15.uart_cfg015.apb_cfg15.slave_configs15[1], 1);
      apb_ss_env15.apb_uart115.set_slave_config15(apb_ss_cfg15.uart_cfg115.apb_cfg15.slave_configs15[3], 3);

      // ***********************************************************
      // Connect15 TLM ports15
      // ***********************************************************
      uart015.Rx15.monitor15.frame_collected_port15.connect(apb_ss_env15.apb_uart015.monitor15.uart_rx_in15);
      uart015.Tx15.monitor15.frame_collected_port15.connect(apb_ss_env15.apb_uart015.monitor15.uart_tx_in15);
      apb015.bus_monitor15.item_collected_port15.connect(apb_ss_env15.apb_uart015.monitor15.apb_in15);
      apb015.bus_monitor15.item_collected_port15.connect(apb_ss_env15.apb_uart015.apb_in15);
      user_ahb_monitor15.ahb_transfer_out15.connect(apb_ss_env15.monitor15.rx_scbd15.ahb_add15);
      user_ahb_monitor15.ahb_transfer_out15.connect(apb_ss_env15.ahb_in15);
      spi015.agents15[0].monitor15.item_collected_port15.connect(apb_ss_env15.monitor15.rx_scbd15.spi_match15);


      uart115.Rx15.monitor15.frame_collected_port15.connect(apb_ss_env15.apb_uart115.monitor15.uart_rx_in15);
      uart115.Tx15.monitor15.frame_collected_port15.connect(apb_ss_env15.apb_uart115.monitor15.uart_tx_in15);
      apb015.bus_monitor15.item_collected_port15.connect(apb_ss_env15.apb_uart115.monitor15.apb_in15);
      apb015.bus_monitor15.item_collected_port15.connect(apb_ss_env15.apb_uart115.apb_in15);

      // ***********************************************************
      // Connect15 the dut_csr15 ports15
      // ***********************************************************
      apb_ss_env15.spi_csr_out15.connect(apb_ss_env15.monitor15.dut_csr_port_in15);
      apb_ss_env15.spi_csr_out15.connect(spi015.dut_csr_port_in15);
      apb_ss_env15.gpio_csr_out15.connect(gpio015.dut_csr_port_in15);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env15();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY15",("APB15 SubSystem15 Virtual Sequence Testbench15 Topology15:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("                         _____15                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("                        | AHB15 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("                        | UVC15 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("                   ____________15    _________15               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("                  | AHB15 - APB15  |  | APB15 UVC15 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("                  |   Bridge15   |  | Passive15 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("  _____15    _____15    ______15    _______15    _____15    _______15  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",(" | SPI15 |  | SMC15 |  | GPIO15 |  | UART015 |  | PCM15 |  | UART115 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("  _____15              ______15    _______15            _______15  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",(" | SPI15 |            | GPIO15 |  | UART015 |          | UART115 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",(" | UVC15 |            | UVC15  |  |  UVC15  |          |  UVC15  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY15",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER15 MODEL15:\n", reg_model_apb15.sprint()}, UVM_LOW)
  endtask

endclass
