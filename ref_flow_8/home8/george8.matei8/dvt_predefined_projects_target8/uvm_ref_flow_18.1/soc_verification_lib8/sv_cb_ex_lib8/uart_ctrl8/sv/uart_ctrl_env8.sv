/*-------------------------------------------------------------------------
File8 name   : uart_ctrl_env8.sv
Title8       : 
Project8     :
Created8     :
Description8 : Module8 env8, contains8 the instance of scoreboard8 and coverage8 model
Notes8       : 
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`include "uart_ctrl_defines8.svh"
class uart_ctrl_env8 extends uvm_env; 
  
  // Component configuration classes8
  uart_ctrl_config8 cfg;
  // These8 are pointers8 to config classes8 above8
  uart_config8 uart_cfg8;
  apb_slave_config8 apb_slave_cfg8;

  // Module8 monitor8 (includes8 scoreboards8, coverage8, checking)
  uart_ctrl_monitor8 monitor8;

  // Control8 bit
  bit div_en8;

  // UVM_REG: Pointer8 to the Register Model8
  uart_ctrl_reg_model_c8 reg_model8;
  // Adapter sequence and predictor8
  reg_to_apb_adapter8 reg2apb8;   // Adapter Object REG to APB8
  uvm_reg_predictor#(apb_transfer8) apb_predictor8;  // Precictor8 - APB8 to REG
  uart_ctrl_reg_sequencer8 reg_sequencer8;
  
  // TLM Connections8 
  uvm_analysis_port #(uart_config8) uart_cfg_out8;
  uvm_analysis_imp #(apb_transfer8, uart_ctrl_env8) apb_in8;

  `uvm_component_utils_begin(uart_ctrl_env8)
    `uvm_field_object(reg_model8, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb8, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create8 TLM ports8
    uart_cfg_out8 = new("uart_cfg_out8", this);
    apb_in8 = new("apb_in8", this);
  endfunction

  // Additional8 class methods8
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer8 transfer8);
  extern virtual function void update_config8(uart_ctrl_config8 uart_ctrl_cfg8, int index);
  extern virtual function void set_slave_config8(apb_slave_config8 _slave_cfg8, int index);
  extern virtual function void set_uart_config8(uart_config8 _uart_cfg8);
  extern virtual function void write_effects8(apb_transfer8 transfer8);
  extern virtual function void read_effects8(apb_transfer8 transfer8);

endclass : uart_ctrl_env8

function void uart_ctrl_env8::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get8 or create the UART8 CONTROLLER8 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config8)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG8", "No uart_ctrl_config8 creating8...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config8::get_type(),
                                     default_uart_ctrl_config8::get_type());
    cfg = uart_ctrl_config8::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL8", "Config8 Randomization Failed8")
  end
  if (apb_slave_cfg8 == null) //begin
    if (!uvm_config_db#(apb_slave_config8)::get(this, "", "apb_slave_cfg8", apb_slave_cfg8)) begin
    `uvm_info("NOCONFIG8", "No apb_slave_config8 ..", UVM_LOW)
    apb_slave_cfg8 = cfg.apb_cfg8.slave_configs8[0];
  end
  //uvm_config_db#(uart_ctrl_config8)::set(this, "monitor8", "cfg", cfg);
  uvm_config_object::set(this, "monitor8", "cfg", cfg);
  uart_cfg8 = cfg.uart_cfg8;

  // UVMREG8: Create8 the adapter and predictor8
  reg2apb8 = reg_to_apb_adapter8::type_id::create("reg2apb8");
  apb_predictor8 = uvm_reg_predictor#(apb_transfer8)::type_id::create("apb_predictor8", this);
  reg_sequencer8 = uart_ctrl_reg_sequencer8::type_id::create("reg_sequencer8", this);

  // build system level monitor8
  monitor8 = uart_ctrl_monitor8::type_id::create("monitor8",this);
  ////monitor8.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env8::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG8 - Connect8 adapter to register sequencer and predictor8
  apb_predictor8.map = reg_model8.default_map;
  apb_predictor8.adapter = reg2apb8;
endfunction : connect_phase

// UVM_REG: write method for APB8 transfers8 - handles8 Register Operations8
function void uart_ctrl_env8::write(apb_transfer8 transfer8);
  if (apb_slave_cfg8.check_address_range8(transfer8.addr)) begin
    if (transfer8.direction8 == APB_WRITE8) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE8: addr = 'h%0h, data = 'h%0h",
          transfer8.addr, transfer8.data), UVM_MEDIUM)
      write_effects8(transfer8);
    end
    else if (transfer8.direction8 == APB_READ8) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ8: addr = 'h%0h, data = 'h%0h",
          transfer8.addr, transfer8.data), UVM_MEDIUM)
        read_effects8(transfer8);
    end else
      `uvm_error("REGMEM8", "Unsupported8 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG8 based on APB8 writes to config registers
function void uart_ctrl_env8::write_effects8(apb_transfer8 transfer8);
  case (transfer8.addr)
    apb_slave_cfg8.start_address8 + `LINE_CTRL8 : begin
                                            uart_cfg8.char_length8 = transfer8.data[1:0];
                                            uart_cfg8.parity_mode8 = transfer8.data[5:4];
                                            uart_cfg8.parity_en8   = transfer8.data[3];
                                            uart_cfg8.nbstop8      = transfer8.data[2];
                                            div_en8 = transfer8.data[7];
                                            uart_cfg8.ConvToIntChrl8();
                                            uart_cfg8.ConvToIntStpBt8();
                                            uart_cfg_out8.write(uart_cfg8);
                                          end
    apb_slave_cfg8.start_address8 + `DIVD_LATCH18 : begin
                                            if (div_en8) begin
                                            uart_cfg8.baud_rate_gen8 = transfer8.data[7:0];
                                            uart_cfg_out8.write(uart_cfg8);
                                            end
                                          end
    apb_slave_cfg8.start_address8 + `DIVD_LATCH28 : begin
                                            if (div_en8) begin
                                            uart_cfg8.baud_rate_div8 = transfer8.data[7:0];
                                            uart_cfg_out8.write(uart_cfg8);
                                            end
                                          end
    default: `uvm_warning("REGMEM28", "Write access not to Control8/Sataus8 Registers8")
  endcase
  set_uart_config8(uart_cfg8);
endfunction : write_effects8

function void uart_ctrl_env8::read_effects8(apb_transfer8 transfer8);
  // Nothing for now
endfunction : read_effects8

function void uart_ctrl_env8::update_config8(uart_ctrl_config8 uart_ctrl_cfg8, int index);
  `uvm_info(get_type_name(), {"Updating Config8\n", uart_ctrl_cfg8.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg8;
  // Update these8 configs8 also (not really8 necessary8 since8 all are pointers8)
  uart_cfg8 = uart_ctrl_cfg8.uart_cfg8;
  apb_slave_cfg8 = cfg.apb_cfg8.slave_configs8[index];
  monitor8.cfg = uart_ctrl_cfg8;
endfunction : update_config8

function void uart_ctrl_env8::set_slave_config8(apb_slave_config8 _slave_cfg8, int index);
  monitor8.cfg.apb_cfg8.slave_configs8[index]  = _slave_cfg8;
  monitor8.set_slave_config8(_slave_cfg8, index);
endfunction : set_slave_config8

function void uart_ctrl_env8::set_uart_config8(uart_config8 _uart_cfg8);
  `uvm_info(get_type_name(), {"Setting Config8\n", _uart_cfg8.sprint()}, UVM_HIGH)
  monitor8.cfg.uart_cfg8  = _uart_cfg8;
  monitor8.set_uart_config8(_uart_cfg8);
endfunction : set_uart_config8
