/*-------------------------------------------------------------------------
File11 name   : uart_ctrl_env11.sv
Title11       : 
Project11     :
Created11     :
Description11 : Module11 env11, contains11 the instance of scoreboard11 and coverage11 model
Notes11       : 
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`include "uart_ctrl_defines11.svh"
class uart_ctrl_env11 extends uvm_env; 
  
  // Component configuration classes11
  uart_ctrl_config11 cfg;
  // These11 are pointers11 to config classes11 above11
  uart_config11 uart_cfg11;
  apb_slave_config11 apb_slave_cfg11;

  // Module11 monitor11 (includes11 scoreboards11, coverage11, checking)
  uart_ctrl_monitor11 monitor11;

  // Control11 bit
  bit div_en11;

  // UVM_REG: Pointer11 to the Register Model11
  uart_ctrl_reg_model_c11 reg_model11;
  // Adapter sequence and predictor11
  reg_to_apb_adapter11 reg2apb11;   // Adapter Object REG to APB11
  uvm_reg_predictor#(apb_transfer11) apb_predictor11;  // Precictor11 - APB11 to REG
  uart_ctrl_reg_sequencer11 reg_sequencer11;
  
  // TLM Connections11 
  uvm_analysis_port #(uart_config11) uart_cfg_out11;
  uvm_analysis_imp #(apb_transfer11, uart_ctrl_env11) apb_in11;

  `uvm_component_utils_begin(uart_ctrl_env11)
    `uvm_field_object(reg_model11, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb11, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create11 TLM ports11
    uart_cfg_out11 = new("uart_cfg_out11", this);
    apb_in11 = new("apb_in11", this);
  endfunction

  // Additional11 class methods11
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer11 transfer11);
  extern virtual function void update_config11(uart_ctrl_config11 uart_ctrl_cfg11, int index);
  extern virtual function void set_slave_config11(apb_slave_config11 _slave_cfg11, int index);
  extern virtual function void set_uart_config11(uart_config11 _uart_cfg11);
  extern virtual function void write_effects11(apb_transfer11 transfer11);
  extern virtual function void read_effects11(apb_transfer11 transfer11);

endclass : uart_ctrl_env11

function void uart_ctrl_env11::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get11 or create the UART11 CONTROLLER11 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config11)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG11", "No uart_ctrl_config11 creating11...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config11::get_type(),
                                     default_uart_ctrl_config11::get_type());
    cfg = uart_ctrl_config11::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL11", "Config11 Randomization Failed11")
  end
  if (apb_slave_cfg11 == null) //begin
    if (!uvm_config_db#(apb_slave_config11)::get(this, "", "apb_slave_cfg11", apb_slave_cfg11)) begin
    `uvm_info("NOCONFIG11", "No apb_slave_config11 ..", UVM_LOW)
    apb_slave_cfg11 = cfg.apb_cfg11.slave_configs11[0];
  end
  //uvm_config_db#(uart_ctrl_config11)::set(this, "monitor11", "cfg", cfg);
  uvm_config_object::set(this, "monitor11", "cfg", cfg);
  uart_cfg11 = cfg.uart_cfg11;

  // UVMREG11: Create11 the adapter and predictor11
  reg2apb11 = reg_to_apb_adapter11::type_id::create("reg2apb11");
  apb_predictor11 = uvm_reg_predictor#(apb_transfer11)::type_id::create("apb_predictor11", this);
  reg_sequencer11 = uart_ctrl_reg_sequencer11::type_id::create("reg_sequencer11", this);

  // build system level monitor11
  monitor11 = uart_ctrl_monitor11::type_id::create("monitor11",this);
  ////monitor11.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env11::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG11 - Connect11 adapter to register sequencer and predictor11
  apb_predictor11.map = reg_model11.default_map;
  apb_predictor11.adapter = reg2apb11;
endfunction : connect_phase

// UVM_REG: write method for APB11 transfers11 - handles11 Register Operations11
function void uart_ctrl_env11::write(apb_transfer11 transfer11);
  if (apb_slave_cfg11.check_address_range11(transfer11.addr)) begin
    if (transfer11.direction11 == APB_WRITE11) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE11: addr = 'h%0h, data = 'h%0h",
          transfer11.addr, transfer11.data), UVM_MEDIUM)
      write_effects11(transfer11);
    end
    else if (transfer11.direction11 == APB_READ11) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ11: addr = 'h%0h, data = 'h%0h",
          transfer11.addr, transfer11.data), UVM_MEDIUM)
        read_effects11(transfer11);
    end else
      `uvm_error("REGMEM11", "Unsupported11 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG11 based on APB11 writes to config registers
function void uart_ctrl_env11::write_effects11(apb_transfer11 transfer11);
  case (transfer11.addr)
    apb_slave_cfg11.start_address11 + `LINE_CTRL11 : begin
                                            uart_cfg11.char_length11 = transfer11.data[1:0];
                                            uart_cfg11.parity_mode11 = transfer11.data[5:4];
                                            uart_cfg11.parity_en11   = transfer11.data[3];
                                            uart_cfg11.nbstop11      = transfer11.data[2];
                                            div_en11 = transfer11.data[7];
                                            uart_cfg11.ConvToIntChrl11();
                                            uart_cfg11.ConvToIntStpBt11();
                                            uart_cfg_out11.write(uart_cfg11);
                                          end
    apb_slave_cfg11.start_address11 + `DIVD_LATCH111 : begin
                                            if (div_en11) begin
                                            uart_cfg11.baud_rate_gen11 = transfer11.data[7:0];
                                            uart_cfg_out11.write(uart_cfg11);
                                            end
                                          end
    apb_slave_cfg11.start_address11 + `DIVD_LATCH211 : begin
                                            if (div_en11) begin
                                            uart_cfg11.baud_rate_div11 = transfer11.data[7:0];
                                            uart_cfg_out11.write(uart_cfg11);
                                            end
                                          end
    default: `uvm_warning("REGMEM211", "Write access not to Control11/Sataus11 Registers11")
  endcase
  set_uart_config11(uart_cfg11);
endfunction : write_effects11

function void uart_ctrl_env11::read_effects11(apb_transfer11 transfer11);
  // Nothing for now
endfunction : read_effects11

function void uart_ctrl_env11::update_config11(uart_ctrl_config11 uart_ctrl_cfg11, int index);
  `uvm_info(get_type_name(), {"Updating Config11\n", uart_ctrl_cfg11.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg11;
  // Update these11 configs11 also (not really11 necessary11 since11 all are pointers11)
  uart_cfg11 = uart_ctrl_cfg11.uart_cfg11;
  apb_slave_cfg11 = cfg.apb_cfg11.slave_configs11[index];
  monitor11.cfg = uart_ctrl_cfg11;
endfunction : update_config11

function void uart_ctrl_env11::set_slave_config11(apb_slave_config11 _slave_cfg11, int index);
  monitor11.cfg.apb_cfg11.slave_configs11[index]  = _slave_cfg11;
  monitor11.set_slave_config11(_slave_cfg11, index);
endfunction : set_slave_config11

function void uart_ctrl_env11::set_uart_config11(uart_config11 _uart_cfg11);
  `uvm_info(get_type_name(), {"Setting Config11\n", _uart_cfg11.sprint()}, UVM_HIGH)
  monitor11.cfg.uart_cfg11  = _uart_cfg11;
  monitor11.set_uart_config11(_uart_cfg11);
endfunction : set_uart_config11
