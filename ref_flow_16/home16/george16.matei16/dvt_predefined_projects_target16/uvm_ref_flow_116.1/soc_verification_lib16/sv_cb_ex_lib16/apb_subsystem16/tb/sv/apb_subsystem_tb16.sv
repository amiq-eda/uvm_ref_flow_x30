/*-------------------------------------------------------------------------
File16 name   : apb_subsystem_top_tb16.sv
Title16       : Simulation16 and Verification16 Environment16
Project16     :
Created16     :
Description16 : This16 file implements16 the SVE16 for the AHB16-UART16 Environment16
Notes16       : The apb_subsystem_tb16 creates16 the UART16 env16, the 
            : APB16 env16 and the scoreboard16. It also randomizes16 the UART16 
            : CSR16 settings16 and passes16 it to both the env16's.
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

//--------------------------------------------------------------
//  Simulation16 Verification16 Environment16 (SVE16)
//--------------------------------------------------------------
class apb_subsystem_tb16 extends uvm_env;

  apb_subsystem_virtual_sequencer16 virtual_sequencer16;  // multi-channel16 sequencer
  ahb_pkg16::ahb_env16 ahb016;                          // AHB16 UVC16
  apb_pkg16::apb_env16 apb016;                          // APB16 UVC16
  uart_pkg16::uart_env16 uart016;                   // UART16 UVC16 connected16 to UART016
  uart_pkg16::uart_env16 uart116;                   // UART16 UVC16 connected16 to UART116
  spi_pkg16::spi_env16 spi016;                      // SPI16 UVC16 connected16 to SPI016
  gpio_pkg16::gpio_env16 gpio016;                   // GPIO16 UVC16 connected16 to GPIO016
  apb_subsystem_env16 apb_ss_env16;

  // UVM_REG
  apb_ss_reg_model_c16 reg_model_apb16;    // Register Model16
  reg_to_ahb_adapter16 reg2ahb16;         // Adapter Object - REG to APB16
  uvm_reg_predictor#(ahb_transfer16) ahb_predictor16; //Predictor16 - APB16 to REG

  apb_subsystem_pkg16::apb_subsystem_config16 apb_ss_cfg16;

  // enable automation16 for  apb_subsystem_tb16
  `uvm_component_utils_begin(apb_subsystem_tb16)
     `uvm_field_object(reg_model_apb16, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(reg2ahb16, UVM_DEFAULT | UVM_REFERENCE)
     `uvm_field_object(apb_ss_cfg16, UVM_DEFAULT)
  `uvm_component_utils_end
    
  function new(input string name = "apb_subsystem_tb16", input uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function automatic void build_env16();
     // Configure16 UVCs16
    if (!uvm_config_db#(apb_subsystem_config16)::get(this, "", "apb_ss_cfg16", apb_ss_cfg16)) begin
      `uvm_info(get_type_name(), "No apb_subsystem_config16, creating16...", UVM_LOW)
      apb_ss_cfg16 = apb_subsystem_config16::type_id::create("apb_ss_cfg16", this);
      apb_ss_cfg16.uart_cfg016.apb_cfg16.add_master16("master16", UVM_PASSIVE);
      apb_ss_cfg16.uart_cfg016.apb_cfg16.add_slave16("spi016",  `AM_SPI0_BASE_ADDRESS16,  `AM_SPI0_END_ADDRESS16,  0, UVM_PASSIVE);
      apb_ss_cfg16.uart_cfg016.apb_cfg16.add_slave16("uart016", `AM_UART0_BASE_ADDRESS16, `AM_UART0_END_ADDRESS16, 0, UVM_PASSIVE);
      apb_ss_cfg16.uart_cfg016.apb_cfg16.add_slave16("gpio016", `AM_GPIO0_BASE_ADDRESS16, `AM_GPIO0_END_ADDRESS16, 0, UVM_PASSIVE);
      apb_ss_cfg16.uart_cfg016.apb_cfg16.add_slave16("uart116", `AM_UART1_BASE_ADDRESS16, `AM_UART1_END_ADDRESS16, 1, UVM_PASSIVE);
      apb_ss_cfg16.uart_cfg116.apb_cfg16.add_master16("master16", UVM_PASSIVE);
      apb_ss_cfg16.uart_cfg116.apb_cfg16.add_slave16("spi016",  `AM_SPI0_BASE_ADDRESS16,  `AM_SPI0_END_ADDRESS16,  0, UVM_PASSIVE);
      apb_ss_cfg16.uart_cfg116.apb_cfg16.add_slave16("uart016", `AM_UART0_BASE_ADDRESS16, `AM_UART0_END_ADDRESS16, 0, UVM_PASSIVE);
      apb_ss_cfg16.uart_cfg116.apb_cfg16.add_slave16("gpio016", `AM_GPIO0_BASE_ADDRESS16, `AM_GPIO0_END_ADDRESS16, 0, UVM_PASSIVE);
      apb_ss_cfg16.uart_cfg116.apb_cfg16.add_slave16("uart116", `AM_UART1_BASE_ADDRESS16, `AM_UART1_END_ADDRESS16, 1, UVM_PASSIVE);
      `uvm_info(get_type_name(), {"Printing16 apb16 subsystem16 config:\n", apb_ss_cfg16.sprint()}, UVM_MEDIUM)
    end 

     uvm_config_db#(apb_config16)::set(this, "apb016", "cfg", apb_ss_cfg16.uart_cfg016.apb_cfg16);
     uvm_config_db#(uart_config16)::set(this, "uart016", "cfg", apb_ss_cfg16.uart_cfg016.uart_cfg16);
     uvm_config_db#(uart_config16)::set(this, "uart116", "cfg", apb_ss_cfg16.uart_cfg116.uart_cfg16);
     uvm_config_db#(uart_ctrl_config16)::set(this, "apb_ss_env16.apb_uart016", "cfg", apb_ss_cfg16.uart_cfg016);
     uvm_config_db#(uart_ctrl_config16)::set(this, "apb_ss_env16.apb_uart116", "cfg", apb_ss_cfg16.uart_cfg116);
     uvm_config_db#(apb_slave_config16)::set(this, "apb_ss_env16.apb_uart016", "apb_slave_cfg16", apb_ss_cfg16.uart_cfg016.apb_cfg16.slave_configs16[1]);
     uvm_config_db#(apb_slave_config16)::set(this, "apb_ss_env16.apb_uart116", "apb_slave_cfg16", apb_ss_cfg16.uart_cfg116.apb_cfg16.slave_configs16[3]);
     set_config_object("spi016", "spi_ve_config16", apb_ss_cfg16.spi_cfg16, 0);
     set_config_object("gpio016", "gpio_ve_config16", apb_ss_cfg16.gpio_cfg16, 0);

     set_config_int("*spi016.agents16[0]","is_active", UVM_ACTIVE);  
     set_config_int("*gpio016.agents16[0]","is_active", UVM_ACTIVE);  
     set_config_int("*ahb016.master_agent16","is_active", UVM_ACTIVE);  
     set_config_int("*ahb016.slave_agent16","is_active", UVM_PASSIVE);
     set_config_int("*uart016.Tx16","is_active", UVM_ACTIVE);  
     set_config_int("*uart016.Rx16","is_active", UVM_PASSIVE);
     set_config_int("*uart116.Tx16","is_active", UVM_ACTIVE);  
     set_config_int("*uart116.Rx16","is_active", UVM_PASSIVE);

     // Allocate16 objects16
     virtual_sequencer16 = apb_subsystem_virtual_sequencer16::type_id::create("virtual_sequencer16",this);
     ahb016              = ahb_pkg16::ahb_env16::type_id::create("ahb016",this);
     apb016              = apb_pkg16::apb_env16::type_id::create("apb016",this);
     uart016             = uart_pkg16::uart_env16::type_id::create("uart016",this);
     uart116             = uart_pkg16::uart_env16::type_id::create("uart116",this);
     spi016              = spi_pkg16::spi_env16::type_id::create("spi016",this);
     gpio016             = gpio_pkg16::gpio_env16::type_id::create("gpio016",this);
     apb_ss_env16        = apb_subsystem_env16::type_id::create("apb_ss_env16",this);

  //UVM_REG
  ahb_predictor16 = uvm_reg_predictor#(ahb_transfer16)::type_id::create("ahb_predictor16", this);
  if (reg_model_apb16 == null) begin
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    reg_model_apb16 = apb_ss_reg_model_c16::type_id::create("reg_model_apb16");
    reg_model_apb16.build();  //NOTE16: not same as build_phase: reg_model16 is an object
    reg_model_apb16.lock_model();
  end
    // set the register model for the rest16 of the testbench
    uvm_config_object::set(this, "*", "reg_model_apb16", reg_model_apb16);
    uvm_config_object::set(this, "*uart016*", "reg_model16", reg_model_apb16.uart0_rm16);
    uvm_config_object::set(this, "*uart116*", "reg_model16", reg_model_apb16.uart1_rm16);


  endfunction : build_env16

  function void connect_phase(uvm_phase phase);
    ahb_monitor16 user_ahb_monitor16;
    super.connect_phase(phase);
    //UVM_REG
    reg2ahb16 = reg_to_ahb_adapter16::type_id::create("reg2ahb16");
    reg_model_apb16.default_map.set_sequencer(ahb016.master_agent16.sequencer, reg2ahb16);  //
    reg_model_apb16.default_map.set_auto_predict(1);

      if (!$cast(user_ahb_monitor16, ahb016.master_agent16.monitor16))
        `uvm_fatal("CASTFL16", "Failed16 to cast master16 monitor16 to user_ahb_monitor16");

      // ***********************************************************
      //  Hookup16 virtual sequencer to interface sequencers16
      // ***********************************************************
        virtual_sequencer16.ahb_seqr16 =  ahb016.master_agent16.sequencer;
      if (uart016.Tx16.is_active == UVM_ACTIVE)  
        virtual_sequencer16.uart0_seqr16 =  uart016.Tx16.sequencer;
      if (uart116.Tx16.is_active == UVM_ACTIVE)  
        virtual_sequencer16.uart1_seqr16 =  uart116.Tx16.sequencer;
      if (spi016.agents16[0].is_active == UVM_ACTIVE)  
        virtual_sequencer16.spi0_seqr16 =  spi016.agents16[0].sequencer;
      if (gpio016.agents16[0].is_active == UVM_ACTIVE)  
        virtual_sequencer16.gpio0_seqr16 =  gpio016.agents16[0].sequencer;

      virtual_sequencer16.reg_model_ptr16 = reg_model_apb16;

      apb_ss_env16.monitor16.set_slave_config16(apb_ss_cfg16.uart_cfg016.apb_cfg16.slave_configs16[0]);
      apb_ss_env16.apb_uart016.set_slave_config16(apb_ss_cfg16.uart_cfg016.apb_cfg16.slave_configs16[1], 1);
      apb_ss_env16.apb_uart116.set_slave_config16(apb_ss_cfg16.uart_cfg116.apb_cfg16.slave_configs16[3], 3);

      // ***********************************************************
      // Connect16 TLM ports16
      // ***********************************************************
      uart016.Rx16.monitor16.frame_collected_port16.connect(apb_ss_env16.apb_uart016.monitor16.uart_rx_in16);
      uart016.Tx16.monitor16.frame_collected_port16.connect(apb_ss_env16.apb_uart016.monitor16.uart_tx_in16);
      apb016.bus_monitor16.item_collected_port16.connect(apb_ss_env16.apb_uart016.monitor16.apb_in16);
      apb016.bus_monitor16.item_collected_port16.connect(apb_ss_env16.apb_uart016.apb_in16);
      user_ahb_monitor16.ahb_transfer_out16.connect(apb_ss_env16.monitor16.rx_scbd16.ahb_add16);
      user_ahb_monitor16.ahb_transfer_out16.connect(apb_ss_env16.ahb_in16);
      spi016.agents16[0].monitor16.item_collected_port16.connect(apb_ss_env16.monitor16.rx_scbd16.spi_match16);


      uart116.Rx16.monitor16.frame_collected_port16.connect(apb_ss_env16.apb_uart116.monitor16.uart_rx_in16);
      uart116.Tx16.monitor16.frame_collected_port16.connect(apb_ss_env16.apb_uart116.monitor16.uart_tx_in16);
      apb016.bus_monitor16.item_collected_port16.connect(apb_ss_env16.apb_uart116.monitor16.apb_in16);
      apb016.bus_monitor16.item_collected_port16.connect(apb_ss_env16.apb_uart116.apb_in16);

      // ***********************************************************
      // Connect16 the dut_csr16 ports16
      // ***********************************************************
      apb_ss_env16.spi_csr_out16.connect(apb_ss_env16.monitor16.dut_csr_port_in16);
      apb_ss_env16.spi_csr_out16.connect(spi016.dut_csr_port_in16);
      apb_ss_env16.gpio_csr_out16.connect(gpio016.dut_csr_port_in16);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    uvm_test_done.set_drain_time(this, 1000);
    uvm_test_done.set_report_verbosity_level(UVM_HIGH);
  endfunction : start_of_simulation_phase

  function automatic void build_phase(uvm_phase phase);
     super.build_phase(phase);
     build_env16();
  endfunction
   
  task run_phase(uvm_phase phase);
    `uvm_info("ENV_TOPOLOGY16",("APB16 SubSystem16 Virtual Sequence Testbench16 Topology16:"), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("                         _____16                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("                        | AHB16 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("                        | UVC16 |                            "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("                         -----                             "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("                           ^                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("                           |                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("                           v                               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("                   ____________16    _________16               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("                  | AHB16 - APB16  |  | APB16 UVC16 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("                  |   Bridge16   |  | Passive16 |              "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("                   ------------    ---------               "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("                           ^         ^                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("                           |         |                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("                           v         v                     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("<--------------------------------------------------------> "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("    ^        ^         ^         ^         ^         ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("    |        |         |         |         |         |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("    v        v         v         v         v         v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("  _____16    _____16    ______16    _______16    _____16    _______16  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",(" | SPI16 |  | SMC16 |  | GPIO16 |  | UART016 |  | PCM16 |  | UART116 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("  -----    -----    ------    -------    -----    -------  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("    ^                  ^         ^                   ^     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("    |                  |         |                   |     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("    v                  v         v                   v     "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("  _____16              ______16    _______16            _______16  "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",(" | SPI16 |            | GPIO16 |  | UART016 |          | UART116 | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",(" | UVC16 |            | UVC16  |  |  UVC16  |          |  UVC16  | "), UVM_LOW)
    `uvm_info("ENV_TOPOLOGY16",("  -----              -------   -------            -------  "), UVM_LOW)
    `uvm_info(get_type_name(), {"REGISTER16 MODEL16:\n", reg_model_apb16.sprint()}, UVM_LOW)
  endtask

endclass
