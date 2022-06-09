/*-------------------------------------------------------------------------
File5 name   : apb_subsystem_top_tb5.sv
Title5       : Simulation5 and Verification5 Environment5
Project5     :
Created5     :
Description5 : This5 file implements5 the SVE5 for the AHB5-UART5 Environment5
Notes5       : The apb_subsystem_tb5 creates5 the UART5 env5, the 
            : APB5 env5 and the scoreboard5. It also randomizes5 the UART5 
            : CSR5 settings5 and passes5 it to both the env5's.
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation5 Verification5 Environment5 (SVE5)
//--------------------------------------------------------------
class apb_subsystem_tb5 extends uvm_env;

  apb_subsystem_virtual_sequencer5 virtual_sequencer5;  // multi-channel5 sequencer
  ahb_pkg5::ahb_env5 ahb05;                          // AHB5 UVC5
  apb_pkg5::apb_env5 apb05;                          // APB5 UVC5
  uart_pkg5::uart_env5 uart05;                   // UART5 UVC5 connected5 to UART05
  uart_pkg5::uart_env5 uart15;                   // UART5 UVC5 connected5 to UART15
  spi_pkg5::spi_env5 spi05;                      // SPI5 UVC5 connected5 to SPI05
  gpio_pkg5::gpio_env5 gpio05;                   // GPIO5 UVC5 connected5 to GPIO05
  apb_subsystem_env5 apb_ss_env5;

  // UVM_REG
  apb_ss_reg_model_c5 reg_model_apb5;    // Register Model5
  reg_to_ahb_adapter5 reg2ahb5;         // Adapter Object - REG to APB5
  uvm_reg_predictor#(ahb_transfer5) ahb_predictor5; //Predictor5 - APB5 to REG

  apb_subsystem_pkg5::apb_subsystem_config5 apb_ss_cfg5;

  // enable automation5 for  apb_subsystem_tb5
  `uvm_component_utils_begin(apb_subsystem_tb5)
     `uvm_field_object(reg_model_apb5, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb5, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg5, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb5", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env5();
     // Configure5 UVCs5
    if (!uvm_config_db#(apb_subsystem_config5)::get(this, "", "apb_ss_cfg5", apb_ss_cfg5)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config5, creating5...", UVM_LOW)
      apb_ss_cfg5 = apb_subsystem_config5::type_id::create("apb_ss_cfg5", this);
      apb_ss_cfg5.uart_cfg05.apb_cfg5.add_master5("master5", UVM_PASSIVE);
      apb_ss_cfg5.uart_cfg05.apb_cfg5.add_slave5("spi05",  `AM_SPI0_BASE_ADDRESS5,  `AM_SPI0_END_ADDRESS5,  0, UVM_PASSIVE);
      apb_ss_cfg5.uart_cfg05.apb_cfg5.add_slave5("uart05", `AM_UART0_BASE_ADDRESS5, `AM_UART0_END_ADDRESS5, 0, UVM_PASSIVE);
      apb_ss_cfg5.uart_cfg05.apb_cfg5.add_slave5("gpio05", `AM_GPIO0_BASE_ADDRESS5, `AM_GPIO0_END_ADDRESS5, 0, UVM_PASSIVE);
      apb_ss_cfg5.uart_cfg05.apb_cfg5.add_slave5("uart15", `AM_UART1_BASE_ADDRESS5, `AM_UART1_END_ADDRESS5, 1, UVM_PASSIVE);
      apb_ss_cfg5.uart_cfg15.apb_cfg5.add_master5("master5", UVM_PASSIVE);
      apb_ss_cfg5.uart_cfg15.apb_cfg5.add_slave5("spi05",  `AM_SPI0_BASE_ADDRESS5,  `AM_SPI0_END_ADDRESS5,  0, UVM_PASSIVE);
      apb_ss_cfg5.uart_cfg15.apb_cfg5.add_slave5("uart05", `AM_UART0_BASE_ADDRESS5, `AM_UART0_END_ADDRESS5, 0, UVM_PASSIVE);
      apb_ss_cfg5.uart_cfg15.apb_cfg5.add_slave5("gpio05", `AM_GPIO0_BASE_ADDRESS5, `AM_GPIO0_END_ADDRESS5, 0, UVM_PASSIVE);
      apb_ss_cfg5.uart_cfg15.apb_cfg5.add_slave5("uart15", `AM_UART1_BASE_ADDRESS5, `AM_UART1_END_ADDRESS5, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing5 apb5 subsystem5 config:\n", apb_ss_cfg5.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config5)::set(this, "apb05", "cfg", apb_ss_cfg5.uart_cfg05.apb_cfg5);
     uvm_config_db#(uart_config5)::set(this, "uart05", "cfg", apb_ss_cfg5.uart_cfg05.uart_cfg5);
     uvm_config_db#(uart_config5)::set(this, "uart15", "cfg", apb_ss_cfg5.uart_cfg15.uart_cfg5);
     uvm_config_db#(uart_ctrl_config5)::set(this, "apb_ss_env5.apb_uart05", "cfg", apb_ss_cfg5.uart_cfg05);
     uvm_config_db#(uart_ctrl_config5)::set(this, "apb_ss_env5.apb_uart15", "cfg", apb_ss_cfg5.uart_cfg15);
     uvm_config_db#(apb_slave_config5)::set(this, "apb_ss_env5.apb_uart05", "apb_slave_cfg5", apb_ss_cfg5.uart_cfg05.apb_cfg5.slave_configs5[1]);
     uvm_config_db#(apb_slave_config5)::set(this, "apb_ss_env5.apb_uart15", "apb_slave_cfg5", apb_ss_cfg5.uart_cfg15.apb_cfg5.slave_configs5[3]);
     set_config_object("spi05", "spi_ve_config5", apb_ss_cfg5.spi_cfg5, 0);
     set_config_object("gpio05", "gpio_ve_config5", apb_ss_cfg5.gpio_cfg5, 0);

     set_config_int("*spi05.agents5[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio05.agents5[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb05.master_agent5","is_active", UVM_ACTIVE);  
     set_config_int("*ahb05.slave_agent5","is_active", UVM_PASSIVE);
     set_config_int("*uart05.Tx5","is_active", UVM_ACTIVE);  
     set_config_int("*uart05.Rx5","is_active", UVM_PASSIVE);
     set_config_int("*uart15.Tx5","is_active", UVM_ACTIVE);  
     set_config_int("*uart15.Rx5","is_active", UVM_PASSIVE);

     // Allocate5 objects5
     virtual_sequencer5 = apb_subsystem_virtual_sequencer5::type_id::create("virtual_sequencer5",this);
     ahb05              = ahb_pkg5::ahb_env5::type_id::create("ahb05",this);
     apb05              = apb_pkg5::apb_env5::type_id::create("apb05",this);
     uart05             = uart_pkg5::uart_env5::type_id::create("uart05",this);
     uart15             = uart_pkg5::uart_env5::type_id::create("uart15",this);
     spi05              = spi_pkg5::spi_env5::type_id::create("spi05",this);
     gpio05             = gpio_pkg5::gpio_env5::type_id::create("gpio05",this);
     apb_ss_env5        = apb_subsystem_env5::type_id::create("apb_ss_env5",this);

  //UVM_REG
  ahb_predictor5 = uvm_reg_predictor#(ahb_transfer5)::type_id::create("ahb_predictor5", this);
  if (reg_model_apb5 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb5 = apb_ss_reg_model_c5::type_id::create("reg_model_apb5");
    reg_model_apb5.build();  //NOTE5: not same as build_phase: reg_model5 is an object
    reg_model_apb5.lock_model();
  end
    // set the register model for the rest5 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb5", reg_model_apb5);
    uvm_config_object::set(this, "*uart05*", "reg_model5", reg_model_apb5.uart0_rm5);
    uvm_config_object::set(this, "*uart15*", "reg_model5", reg_model_apb5.uart1_rm5);


  endfunction : build_env5

  function void connect_phase(uvm_phase phase);
    ahb_monitor5 user_ahb_monitor5;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb5 = reg_to_ahb_adapter5::type_id::create("reg2ahb5");
    reg_model_apb5.default_map.set_sequencer(ahb05.master_agent5.sequencer, reg2ahb5);  //
    reg_model_apb5.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor5, ahb05.master_agent5.monitor5))
        `uvm_fatal("CASTFL5", "Failed5 to cast master5 monitor5 to user_ahb_monitor5");

      // ***********************************************************
      //  Hookup5 virtual sequencer to interface sequencers5
      // ***********************************************************
        virtual_sequencer5.ahb_seqr5 =  ahb05.master_agent5.sequencer;
      if (uart05.Tx5.is_active == UVM_ACTIVE)  
        virtual_sequencer5.uart0_seqr5 =  uart05.Tx5.sequencer;
      if (uart15.Tx5.is_active == UVM_ACTIVE)  
        virtual_sequencer5.uart1_seqr5 =  uart15.Tx5.sequencer;
      if (spi05.agents5[0].is_active == UVM_ACTIVE)  
        virtual_sequencer5.spi0_seqr5 =  spi05.agents5[0].sequencer;
      if (gpio05.agents5[0].is_active == UVM_ACTIVE)  
        virtual_sequencer5.gpio0_seqr5 =  gpio05.agents5[0].sequencer;

      virtual_sequencer5.reg_model_ptr5 = reg_model_apb5;

      apb_ss_env5.monitor5.set_slave_config5(apb_ss_cfg5.uart_cfg05.apb_cfg5.slave_configs5[0]);
      apb_ss_env5.apb_uart05.set_slave_config5(apb_ss_cfg5.uart_cfg05.apb_cfg5.slave_configs5[1], 1);
      apb_ss_env5.apb_uart15.set_slave_config5(apb_ss_cfg5.uart_cfg15.apb_cfg5.slave_configs5[3], 3);

      // ***********************************************************
      // Connect5 TLM ports5
      // ***********************************************************
      uart05.Rx5.monitor5.frame_collected_port5.connect(apb_ss_env5.apb_uart05.monitor5.uart_rx_in5);
      uart05.Tx5.monitor5.frame_collected_port5.connect(apb_ss_env5.apb_uart05.monitor5.uart_tx_in5);
      apb05.bus_monitor5.item_collected_port5.connect(apb_ss_env5.apb_uart05.monitor5.apb_in5);
      apb05.bus_monitor5.item_collected_port5.connect(apb_ss_env5.apb_uart05.apb_in5);
      user_ahb_monitor5.ahb_transfer_out5.connect(apb_ss_env5.monitor5.rx_scbd5.ahb_add5);
      user_ahb_monitor5.ahb_transfer_out5.connect(apb_ss_env5.ahb_in5);
      spi05.agents5[0].monitor5.item_collected_port5.connect(apb_ss_env5.monitor5.rx_scbd5.spi_match5);


      uart15.Rx5.monitor5.frame_collected_port5.connect(apb_ss_env5.apb_uart15.monitor5.uart_rx_in5);
      uart15.Tx5.monitor5.frame_collected_port5.connect(apb_ss_env5.apb_uart15.monitor5.uart_tx_in5);
      apb05.bus_monitor5.item_collected_port5.connect(apb_ss_env5.apb_uart15.monitor5.apb_in5);
      apb05.bus_monitor5.item_collected_port5.connect(apb_ss_env5.apb_uart15.apb_in5);

      // ***********************************************************
      // Connect5 the dut_csr5 ports5
      // ***********************************************************
      apb_ss_env5.spi_csr_out5.connect(apb_ss_env5.monitor5.dut_csr_port_in5);
      apb_ss_env5.spi_csr_out5.connect(spi05.dut_csr_port_in5);
      apb_ss_env5.gpio_csr_out5.connect(gpio05.dut_csr_port_in5);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env5();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY5",("APB5 SubSystem5 Virtual Sequence Testbench5 Topology5:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("                         _____5                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("                        | AHB5 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("                        | UVC5 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("                   ____________5    _________5               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("                  | AHB5 - APB5  |  | APB5 UVC5 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("                  |   Bridge5   |  | Passive5 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("  _____5    _____5    ______5    _______5    _____5    _______5  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",(" | SPI5 |  | SMC5 |  | GPIO5 |  | UART05 |  | PCM5 |  | UART15 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("  _____5              ______5    _______5            _______5  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",(" | SPI5 |            | GPIO5 |  | UART05 |          | UART15 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",(" | UVC5 |            | UVC5  |  |  UVC5  |          |  UVC5  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY5",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER5 MODEL5:\n", reg_model_apb5.sprint()}, UVM_LOW)
  endtask

endclass
