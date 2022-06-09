/*-------------------------------------------------------------------------
File29 name   : apb_subsystem_top_tb29.sv
Title29       : Simulation29 and Verification29 Environment29
Project29     :
Created29     :
Description29 : This29 file implements29 the SVE29 for the AHB29-UART29 Environment29
Notes29       : The apb_subsystem_tb29 creates29 the UART29 env29, the 
            : APB29 env29 and the scoreboard29. It also randomizes29 the UART29 
            : CSR29 settings29 and passes29 it to both the env29's.
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation29 Verification29 Environment29 (SVE29)
//--------------------------------------------------------------
class apb_subsystem_tb29 extends uvm_env;

  apb_subsystem_virtual_sequencer29 virtual_sequencer29;  // multi-channel29 sequencer
  ahb_pkg29::ahb_env29 ahb029;                          // AHB29 UVC29
  apb_pkg29::apb_env29 apb029;                          // APB29 UVC29
  uart_pkg29::uart_env29 uart029;                   // UART29 UVC29 connected29 to UART029
  uart_pkg29::uart_env29 uart129;                   // UART29 UVC29 connected29 to UART129
  spi_pkg29::spi_env29 spi029;                      // SPI29 UVC29 connected29 to SPI029
  gpio_pkg29::gpio_env29 gpio029;                   // GPIO29 UVC29 connected29 to GPIO029
  apb_subsystem_env29 apb_ss_env29;

  // UVM_REG
  apb_ss_reg_model_c29 reg_model_apb29;    // Register Model29
  reg_to_ahb_adapter29 reg2ahb29;         // Adapter Object - REG to APB29
  uvm_reg_predictor#(ahb_transfer29) ahb_predictor29; //Predictor29 - APB29 to REG

  apb_subsystem_pkg29::apb_subsystem_config29 apb_ss_cfg29;

  // enable automation29 for  apb_subsystem_tb29
  `uvm_component_utils_begin(apb_subsystem_tb29)
     `uvm_field_object(reg_model_apb29, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb29, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg29, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb29", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env29();
     // Configure29 UVCs29
    if (!uvm_config_db#(apb_subsystem_config29)::get(this, "", "apb_ss_cfg29", apb_ss_cfg29)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config29, creating29...", UVM_LOW)
      apb_ss_cfg29 = apb_subsystem_config29::type_id::create("apb_ss_cfg29", this);
      apb_ss_cfg29.uart_cfg029.apb_cfg29.add_master29("master29", UVM_PASSIVE);
      apb_ss_cfg29.uart_cfg029.apb_cfg29.add_slave29("spi029",  `AM_SPI0_BASE_ADDRESS29,  `AM_SPI0_END_ADDRESS29,  0, UVM_PASSIVE);
      apb_ss_cfg29.uart_cfg029.apb_cfg29.add_slave29("uart029", `AM_UART0_BASE_ADDRESS29, `AM_UART0_END_ADDRESS29, 0, UVM_PASSIVE);
      apb_ss_cfg29.uart_cfg029.apb_cfg29.add_slave29("gpio029", `AM_GPIO0_BASE_ADDRESS29, `AM_GPIO0_END_ADDRESS29, 0, UVM_PASSIVE);
      apb_ss_cfg29.uart_cfg029.apb_cfg29.add_slave29("uart129", `AM_UART1_BASE_ADDRESS29, `AM_UART1_END_ADDRESS29, 1, UVM_PASSIVE);
      apb_ss_cfg29.uart_cfg129.apb_cfg29.add_master29("master29", UVM_PASSIVE);
      apb_ss_cfg29.uart_cfg129.apb_cfg29.add_slave29("spi029",  `AM_SPI0_BASE_ADDRESS29,  `AM_SPI0_END_ADDRESS29,  0, UVM_PASSIVE);
      apb_ss_cfg29.uart_cfg129.apb_cfg29.add_slave29("uart029", `AM_UART0_BASE_ADDRESS29, `AM_UART0_END_ADDRESS29, 0, UVM_PASSIVE);
      apb_ss_cfg29.uart_cfg129.apb_cfg29.add_slave29("gpio029", `AM_GPIO0_BASE_ADDRESS29, `AM_GPIO0_END_ADDRESS29, 0, UVM_PASSIVE);
      apb_ss_cfg29.uart_cfg129.apb_cfg29.add_slave29("uart129", `AM_UART1_BASE_ADDRESS29, `AM_UART1_END_ADDRESS29, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing29 apb29 subsystem29 config:\n", apb_ss_cfg29.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config29)::set(this, "apb029", "cfg", apb_ss_cfg29.uart_cfg029.apb_cfg29);
     uvm_config_db#(uart_config29)::set(this, "uart029", "cfg", apb_ss_cfg29.uart_cfg029.uart_cfg29);
     uvm_config_db#(uart_config29)::set(this, "uart129", "cfg", apb_ss_cfg29.uart_cfg129.uart_cfg29);
     uvm_config_db#(uart_ctrl_config29)::set(this, "apb_ss_env29.apb_uart029", "cfg", apb_ss_cfg29.uart_cfg029);
     uvm_config_db#(uart_ctrl_config29)::set(this, "apb_ss_env29.apb_uart129", "cfg", apb_ss_cfg29.uart_cfg129);
     uvm_config_db#(apb_slave_config29)::set(this, "apb_ss_env29.apb_uart029", "apb_slave_cfg29", apb_ss_cfg29.uart_cfg029.apb_cfg29.slave_configs29[1]);
     uvm_config_db#(apb_slave_config29)::set(this, "apb_ss_env29.apb_uart129", "apb_slave_cfg29", apb_ss_cfg29.uart_cfg129.apb_cfg29.slave_configs29[3]);
     set_config_object("spi029", "spi_ve_config29", apb_ss_cfg29.spi_cfg29, 0);
     set_config_object("gpio029", "gpio_ve_config29", apb_ss_cfg29.gpio_cfg29, 0);

     set_config_int("*spi029.agents29[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio029.agents29[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb029.master_agent29","is_active", UVM_ACTIVE);  
     set_config_int("*ahb029.slave_agent29","is_active", UVM_PASSIVE);
     set_config_int("*uart029.Tx29","is_active", UVM_ACTIVE);  
     set_config_int("*uart029.Rx29","is_active", UVM_PASSIVE);
     set_config_int("*uart129.Tx29","is_active", UVM_ACTIVE);  
     set_config_int("*uart129.Rx29","is_active", UVM_PASSIVE);

     // Allocate29 objects29
     virtual_sequencer29 = apb_subsystem_virtual_sequencer29::type_id::create("virtual_sequencer29",this);
     ahb029              = ahb_pkg29::ahb_env29::type_id::create("ahb029",this);
     apb029              = apb_pkg29::apb_env29::type_id::create("apb029",this);
     uart029             = uart_pkg29::uart_env29::type_id::create("uart029",this);
     uart129             = uart_pkg29::uart_env29::type_id::create("uart129",this);
     spi029              = spi_pkg29::spi_env29::type_id::create("spi029",this);
     gpio029             = gpio_pkg29::gpio_env29::type_id::create("gpio029",this);
     apb_ss_env29        = apb_subsystem_env29::type_id::create("apb_ss_env29",this);

  //UVM_REG
  ahb_predictor29 = uvm_reg_predictor#(ahb_transfer29)::type_id::create("ahb_predictor29", this);
  if (reg_model_apb29 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb29 = apb_ss_reg_model_c29::type_id::create("reg_model_apb29");
    reg_model_apb29.build();  //NOTE29: not same as build_phase: reg_model29 is an object
    reg_model_apb29.lock_model();
  end
    // set the register model for the rest29 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb29", reg_model_apb29);
    uvm_config_object::set(this, "*uart029*", "reg_model29", reg_model_apb29.uart0_rm29);
    uvm_config_object::set(this, "*uart129*", "reg_model29", reg_model_apb29.uart1_rm29);


  endfunction : build_env29

  function void connect_phase(uvm_phase phase);
    ahb_monitor29 user_ahb_monitor29;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb29 = reg_to_ahb_adapter29::type_id::create("reg2ahb29");
    reg_model_apb29.default_map.set_sequencer(ahb029.master_agent29.sequencer, reg2ahb29);  //
    reg_model_apb29.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor29, ahb029.master_agent29.monitor29))
        `uvm_fatal("CASTFL29", "Failed29 to cast master29 monitor29 to user_ahb_monitor29");

      // ***********************************************************
      //  Hookup29 virtual sequencer to interface sequencers29
      // ***********************************************************
        virtual_sequencer29.ahb_seqr29 =  ahb029.master_agent29.sequencer;
      if (uart029.Tx29.is_active == UVM_ACTIVE)  
        virtual_sequencer29.uart0_seqr29 =  uart029.Tx29.sequencer;
      if (uart129.Tx29.is_active == UVM_ACTIVE)  
        virtual_sequencer29.uart1_seqr29 =  uart129.Tx29.sequencer;
      if (spi029.agents29[0].is_active == UVM_ACTIVE)  
        virtual_sequencer29.spi0_seqr29 =  spi029.agents29[0].sequencer;
      if (gpio029.agents29[0].is_active == UVM_ACTIVE)  
        virtual_sequencer29.gpio0_seqr29 =  gpio029.agents29[0].sequencer;

      virtual_sequencer29.reg_model_ptr29 = reg_model_apb29;

      apb_ss_env29.monitor29.set_slave_config29(apb_ss_cfg29.uart_cfg029.apb_cfg29.slave_configs29[0]);
      apb_ss_env29.apb_uart029.set_slave_config29(apb_ss_cfg29.uart_cfg029.apb_cfg29.slave_configs29[1], 1);
      apb_ss_env29.apb_uart129.set_slave_config29(apb_ss_cfg29.uart_cfg129.apb_cfg29.slave_configs29[3], 3);

      // ***********************************************************
      // Connect29 TLM ports29
      // ***********************************************************
      uart029.Rx29.monitor29.frame_collected_port29.connect(apb_ss_env29.apb_uart029.monitor29.uart_rx_in29);
      uart029.Tx29.monitor29.frame_collected_port29.connect(apb_ss_env29.apb_uart029.monitor29.uart_tx_in29);
      apb029.bus_monitor29.item_collected_port29.connect(apb_ss_env29.apb_uart029.monitor29.apb_in29);
      apb029.bus_monitor29.item_collected_port29.connect(apb_ss_env29.apb_uart029.apb_in29);
      user_ahb_monitor29.ahb_transfer_out29.connect(apb_ss_env29.monitor29.rx_scbd29.ahb_add29);
      user_ahb_monitor29.ahb_transfer_out29.connect(apb_ss_env29.ahb_in29);
      spi029.agents29[0].monitor29.item_collected_port29.connect(apb_ss_env29.monitor29.rx_scbd29.spi_match29);


      uart129.Rx29.monitor29.frame_collected_port29.connect(apb_ss_env29.apb_uart129.monitor29.uart_rx_in29);
      uart129.Tx29.monitor29.frame_collected_port29.connect(apb_ss_env29.apb_uart129.monitor29.uart_tx_in29);
      apb029.bus_monitor29.item_collected_port29.connect(apb_ss_env29.apb_uart129.monitor29.apb_in29);
      apb029.bus_monitor29.item_collected_port29.connect(apb_ss_env29.apb_uart129.apb_in29);

      // ***********************************************************
      // Connect29 the dut_csr29 ports29
      // ***********************************************************
      apb_ss_env29.spi_csr_out29.connect(apb_ss_env29.monitor29.dut_csr_port_in29);
      apb_ss_env29.spi_csr_out29.connect(spi029.dut_csr_port_in29);
      apb_ss_env29.gpio_csr_out29.connect(gpio029.dut_csr_port_in29);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env29();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY29",("APB29 SubSystem29 Virtual Sequence Testbench29 Topology29:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("                         _____29                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("                        | AHB29 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("                        | UVC29 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("                   ____________29    _________29               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("                  | AHB29 - APB29  |  | APB29 UVC29 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("                  |   Bridge29   |  | Passive29 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("  _____29    _____29    ______29    _______29    _____29    _______29  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",(" | SPI29 |  | SMC29 |  | GPIO29 |  | UART029 |  | PCM29 |  | UART129 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("  _____29              ______29    _______29            _______29  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",(" | SPI29 |            | GPIO29 |  | UART029 |          | UART129 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",(" | UVC29 |            | UVC29  |  |  UVC29  |          |  UVC29  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY29",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER29 MODEL29:\n", reg_model_apb29.sprint()}, UVM_LOW)
  endtask

endclass
