/*-------------------------------------------------------------------------
File5 name   : uart_ctrl_env5.sv
Title5       : 
Project5     :
Created5     :
Description5 : Module5 env5, contains5 the instance of scoreboard5 and coverage5 model
Notes5       : 
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


`include "uart_ctrl_defines5.svh"
class uart_ctrl_env5 extends uvm_env; 
  
  // Component configuration classes5
  uart_ctrl_config5 cfg;
  // These5 are pointers5 to config classes5 above5
  uart_config5 uart_cfg5;
  apb_slave_config5 apb_slave_cfg5;

  // Module5 monitor5 (includes5 scoreboards5, coverage5, checking)
  uart_ctrl_monitor5 monitor5;

  // Control5 bit
  bit div_en5;

  // UVM_REG: Pointer5 to the Register Model5
  uart_ctrl_reg_model_c5 reg_model5;
  // Adapter sequence and predictor5
  reg_to_apb_adapter5 reg2apb5;   // Adapter Object REG to APB5
  uvm_reg_predictor#(apb_transfer5) apb_predictor5;  // Precictor5 - APB5 to REG
  uart_ctrl_reg_sequencer5 reg_sequencer5;
  
  // TLM Connections5 
  uvm_analysis_port #(uart_config5) uart_cfg_out5;
  uvm_analysis_imp #(apb_transfer5, uart_ctrl_env5) apb_in5;

  `uvm_component_utils_begin(uart_ctrl_env5)
    `uvm_field_object(reg_model5, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb5, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create5 TLM ports5
    uart_cfg_out5 = new("uart_cfg_out5", this);
    apb_in5 = new("apb_in5", this);
  endfunction

  // Additional5 class methods5
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer5 transfer5);
  extern virtual function void update_config5(uart_ctrl_config5 uart_ctrl_cfg5, int index);
  extern virtual function void set_slave_config5(apb_slave_config5 _slave_cfg5, int index);
  extern virtual function void set_uart_config5(uart_config5 _uart_cfg5);
  extern virtual function void write_effects5(apb_transfer5 transfer5);
  extern virtual function void read_effects5(apb_transfer5 transfer5);

endclass : uart_ctrl_env5

function void uart_ctrl_env5::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get5 or create the UART5 CONTROLLER5 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config5)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG5", "No uart_ctrl_config5 creating5...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config5::get_type(),
                                     default_uart_ctrl_config5::get_type());
    cfg = uart_ctrl_config5::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL5", "Config5 Randomization Failed5")
  end
  if (apb_slave_cfg5 == null) //begin
    if (!uvm_config_db#(apb_slave_config5)::get(this, "", "apb_slave_cfg5", apb_slave_cfg5)) begin
    `uvm_info("NOCONFIG5", "No apb_slave_config5 ..", UVM_LOW)
    apb_slave_cfg5 = cfg.apb_cfg5.slave_configs5[0];
  end
  //uvm_config_db#(uart_ctrl_config5)::set(this, "monitor5", "cfg", cfg);
  uvm_config_object::set(this, "monitor5", "cfg", cfg);
  uart_cfg5 = cfg.uart_cfg5;

  // UVMREG5: Create5 the adapter and predictor5
  reg2apb5 = reg_to_apb_adapter5::type_id::create("reg2apb5");
  apb_predictor5 = uvm_reg_predictor#(apb_transfer5)::type_id::create("apb_predictor5", this);
  reg_sequencer5 = uart_ctrl_reg_sequencer5::type_id::create("reg_sequencer5", this);

  // build system level monitor5
  monitor5 = uart_ctrl_monitor5::type_id::create("monitor5",this);
  ////monitor5.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env5::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG5 - Connect5 adapter to register sequencer and predictor5
  apb_predictor5.map = reg_model5.default_map;
  apb_predictor5.adapter = reg2apb5;
endfunction : connect_phase

// UVM_REG: write method for APB5 transfers5 - handles5 Register Operations5
function void uart_ctrl_env5::write(apb_transfer5 transfer5);
  if (apb_slave_cfg5.check_address_range5(transfer5.addr)) begin
    if (transfer5.direction5 == APB_WRITE5) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE5: addr = 'h%0h, data = 'h%0h",
          transfer5.addr, transfer5.data), UVM_MEDIUM)
      write_effects5(transfer5);
    end
    else if (transfer5.direction5 == APB_READ5) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ5: addr = 'h%0h, data = 'h%0h",
          transfer5.addr, transfer5.data), UVM_MEDIUM)
        read_effects5(transfer5);
    end else
      `uvm_error("REGMEM5", "Unsupported5 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG5 based on APB5 writes to config registers
function void uart_ctrl_env5::write_effects5(apb_transfer5 transfer5);
  case (transfer5.addr)
    apb_slave_cfg5.start_address5 + `LINE_CTRL5 : begin
                                            uart_cfg5.char_length5 = transfer5.data[1:0];
                                            uart_cfg5.parity_mode5 = transfer5.data[5:4];
                                            uart_cfg5.parity_en5   = transfer5.data[3];
                                            uart_cfg5.nbstop5      = transfer5.data[2];
                                            div_en5 = transfer5.data[7];
                                            uart_cfg5.ConvToIntChrl5();
                                            uart_cfg5.ConvToIntStpBt5();
                                            uart_cfg_out5.write(uart_cfg5);
                                          end
    apb_slave_cfg5.start_address5 + `DIVD_LATCH15 : begin
                                            if (div_en5) begin
                                            uart_cfg5.baud_rate_gen5 = transfer5.data[7:0];
                                            uart_cfg_out5.write(uart_cfg5);
                                            end
                                          end
    apb_slave_cfg5.start_address5 + `DIVD_LATCH25 : begin
                                            if (div_en5) begin
                                            uart_cfg5.baud_rate_div5 = transfer5.data[7:0];
                                            uart_cfg_out5.write(uart_cfg5);
                                            end
                                          end
    default: `uvm_warning("REGMEM25", "Write access not to Control5/Sataus5 Registers5")
  endcase
  set_uart_config5(uart_cfg5);
endfunction : write_effects5

function void uart_ctrl_env5::read_effects5(apb_transfer5 transfer5);
  // Nothing for now
endfunction : read_effects5

function void uart_ctrl_env5::update_config5(uart_ctrl_config5 uart_ctrl_cfg5, int index);
  `uvm_info(get_type_name(), {"Updating Config5\n", uart_ctrl_cfg5.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg5;
  // Update these5 configs5 also (not really5 necessary5 since5 all are pointers5)
  uart_cfg5 = uart_ctrl_cfg5.uart_cfg5;
  apb_slave_cfg5 = cfg.apb_cfg5.slave_configs5[index];
  monitor5.cfg = uart_ctrl_cfg5;
endfunction : update_config5

function void uart_ctrl_env5::set_slave_config5(apb_slave_config5 _slave_cfg5, int index);
  monitor5.cfg.apb_cfg5.slave_configs5[index]  = _slave_cfg5;
  monitor5.set_slave_config5(_slave_cfg5, index);
endfunction : set_slave_config5

function void uart_ctrl_env5::set_uart_config5(uart_config5 _uart_cfg5);
  `uvm_info(get_type_name(), {"Setting Config5\n", _uart_cfg5.sprint()}, UVM_HIGH)
  monitor5.cfg.uart_cfg5  = _uart_cfg5;
  monitor5.set_uart_config5(_uart_cfg5);
endfunction : set_uart_config5
