/*-------------------------------------------------------------------------
File24 name   : uart_ctrl_env24.sv
Title24       : 
Project24     :
Created24     :
Description24 : Module24 env24, contains24 the instance of scoreboard24 and coverage24 model
Notes24       : 
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`include "uart_ctrl_defines24.svh"
class uart_ctrl_env24 extends uvm_env; 
  
  // Component configuration classes24
  uart_ctrl_config24 cfg;
  // These24 are pointers24 to config classes24 above24
  uart_config24 uart_cfg24;
  apb_slave_config24 apb_slave_cfg24;

  // Module24 monitor24 (includes24 scoreboards24, coverage24, checking)
  uart_ctrl_monitor24 monitor24;

  // Control24 bit
  bit div_en24;

  // UVM_REG: Pointer24 to the Register Model24
  uart_ctrl_reg_model_c24 reg_model24;
  // Adapter sequence and predictor24
  reg_to_apb_adapter24 reg2apb24;   // Adapter Object REG to APB24
  uvm_reg_predictor#(apb_transfer24) apb_predictor24;  // Precictor24 - APB24 to REG
  uart_ctrl_reg_sequencer24 reg_sequencer24;
  
  // TLM Connections24 
  uvm_analysis_port #(uart_config24) uart_cfg_out24;
  uvm_analysis_imp #(apb_transfer24, uart_ctrl_env24) apb_in24;

  `uvm_component_utils_begin(uart_ctrl_env24)
    `uvm_field_object(reg_model24, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb24, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create24 TLM ports24
    uart_cfg_out24 = new("uart_cfg_out24", this);
    apb_in24 = new("apb_in24", this);
  endfunction

  // Additional24 class methods24
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer24 transfer24);
  extern virtual function void update_config24(uart_ctrl_config24 uart_ctrl_cfg24, int index);
  extern virtual function void set_slave_config24(apb_slave_config24 _slave_cfg24, int index);
  extern virtual function void set_uart_config24(uart_config24 _uart_cfg24);
  extern virtual function void write_effects24(apb_transfer24 transfer24);
  extern virtual function void read_effects24(apb_transfer24 transfer24);

endclass : uart_ctrl_env24

function void uart_ctrl_env24::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get24 or create the UART24 CONTROLLER24 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config24)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG24", "No uart_ctrl_config24 creating24...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config24::get_type(),
                                     default_uart_ctrl_config24::get_type());
    cfg = uart_ctrl_config24::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL24", "Config24 Randomization Failed24")
  end
  if (apb_slave_cfg24 == null) //begin
    if (!uvm_config_db#(apb_slave_config24)::get(this, "", "apb_slave_cfg24", apb_slave_cfg24)) begin
    `uvm_info("NOCONFIG24", "No apb_slave_config24 ..", UVM_LOW)
    apb_slave_cfg24 = cfg.apb_cfg24.slave_configs24[0];
  end
  //uvm_config_db#(uart_ctrl_config24)::set(this, "monitor24", "cfg", cfg);
  uvm_config_object::set(this, "monitor24", "cfg", cfg);
  uart_cfg24 = cfg.uart_cfg24;

  // UVMREG24: Create24 the adapter and predictor24
  reg2apb24 = reg_to_apb_adapter24::type_id::create("reg2apb24");
  apb_predictor24 = uvm_reg_predictor#(apb_transfer24)::type_id::create("apb_predictor24", this);
  reg_sequencer24 = uart_ctrl_reg_sequencer24::type_id::create("reg_sequencer24", this);

  // build system level monitor24
  monitor24 = uart_ctrl_monitor24::type_id::create("monitor24",this);
  ////monitor24.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env24::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG24 - Connect24 adapter to register sequencer and predictor24
  apb_predictor24.map = reg_model24.default_map;
  apb_predictor24.adapter = reg2apb24;
endfunction : connect_phase

// UVM_REG: write method for APB24 transfers24 - handles24 Register Operations24
function void uart_ctrl_env24::write(apb_transfer24 transfer24);
  if (apb_slave_cfg24.check_address_range24(transfer24.addr)) begin
    if (transfer24.direction24 == APB_WRITE24) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE24: addr = 'h%0h, data = 'h%0h",
          transfer24.addr, transfer24.data), UVM_MEDIUM)
      write_effects24(transfer24);
    end
    else if (transfer24.direction24 == APB_READ24) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ24: addr = 'h%0h, data = 'h%0h",
          transfer24.addr, transfer24.data), UVM_MEDIUM)
        read_effects24(transfer24);
    end else
      `uvm_error("REGMEM24", "Unsupported24 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG24 based on APB24 writes to config registers
function void uart_ctrl_env24::write_effects24(apb_transfer24 transfer24);
  case (transfer24.addr)
    apb_slave_cfg24.start_address24 + `LINE_CTRL24 : begin
                                            uart_cfg24.char_length24 = transfer24.data[1:0];
                                            uart_cfg24.parity_mode24 = transfer24.data[5:4];
                                            uart_cfg24.parity_en24   = transfer24.data[3];
                                            uart_cfg24.nbstop24      = transfer24.data[2];
                                            div_en24 = transfer24.data[7];
                                            uart_cfg24.ConvToIntChrl24();
                                            uart_cfg24.ConvToIntStpBt24();
                                            uart_cfg_out24.write(uart_cfg24);
                                          end
    apb_slave_cfg24.start_address24 + `DIVD_LATCH124 : begin
                                            if (div_en24) begin
                                            uart_cfg24.baud_rate_gen24 = transfer24.data[7:0];
                                            uart_cfg_out24.write(uart_cfg24);
                                            end
                                          end
    apb_slave_cfg24.start_address24 + `DIVD_LATCH224 : begin
                                            if (div_en24) begin
                                            uart_cfg24.baud_rate_div24 = transfer24.data[7:0];
                                            uart_cfg_out24.write(uart_cfg24);
                                            end
                                          end
    default: `uvm_warning("REGMEM224", "Write access not to Control24/Sataus24 Registers24")
  endcase
  set_uart_config24(uart_cfg24);
endfunction : write_effects24

function void uart_ctrl_env24::read_effects24(apb_transfer24 transfer24);
  // Nothing for now
endfunction : read_effects24

function void uart_ctrl_env24::update_config24(uart_ctrl_config24 uart_ctrl_cfg24, int index);
  `uvm_info(get_type_name(), {"Updating Config24\n", uart_ctrl_cfg24.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg24;
  // Update these24 configs24 also (not really24 necessary24 since24 all are pointers24)
  uart_cfg24 = uart_ctrl_cfg24.uart_cfg24;
  apb_slave_cfg24 = cfg.apb_cfg24.slave_configs24[index];
  monitor24.cfg = uart_ctrl_cfg24;
endfunction : update_config24

function void uart_ctrl_env24::set_slave_config24(apb_slave_config24 _slave_cfg24, int index);
  monitor24.cfg.apb_cfg24.slave_configs24[index]  = _slave_cfg24;
  monitor24.set_slave_config24(_slave_cfg24, index);
endfunction : set_slave_config24

function void uart_ctrl_env24::set_uart_config24(uart_config24 _uart_cfg24);
  `uvm_info(get_type_name(), {"Setting Config24\n", _uart_cfg24.sprint()}, UVM_HIGH)
  monitor24.cfg.uart_cfg24  = _uart_cfg24;
  monitor24.set_uart_config24(_uart_cfg24);
endfunction : set_uart_config24
