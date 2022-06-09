/*-------------------------------------------------------------------------
File13 name   : uart_ctrl_env13.sv
Title13       : 
Project13     :
Created13     :
Description13 : Module13 env13, contains13 the instance of scoreboard13 and coverage13 model
Notes13       : 
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`include "uart_ctrl_defines13.svh"
class uart_ctrl_env13 extends uvm_env; 
  
  // Component configuration classes13
  uart_ctrl_config13 cfg;
  // These13 are pointers13 to config classes13 above13
  uart_config13 uart_cfg13;
  apb_slave_config13 apb_slave_cfg13;

  // Module13 monitor13 (includes13 scoreboards13, coverage13, checking)
  uart_ctrl_monitor13 monitor13;

  // Control13 bit
  bit div_en13;

  // UVM_REG: Pointer13 to the Register Model13
  uart_ctrl_reg_model_c13 reg_model13;
  // Adapter sequence and predictor13
  reg_to_apb_adapter13 reg2apb13;   // Adapter Object REG to APB13
  uvm_reg_predictor#(apb_transfer13) apb_predictor13;  // Precictor13 - APB13 to REG
  uart_ctrl_reg_sequencer13 reg_sequencer13;
  
  // TLM Connections13 
  uvm_analysis_port #(uart_config13) uart_cfg_out13;
  uvm_analysis_imp #(apb_transfer13, uart_ctrl_env13) apb_in13;

  `uvm_component_utils_begin(uart_ctrl_env13)
    `uvm_field_object(reg_model13, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb13, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create13 TLM ports13
    uart_cfg_out13 = new("uart_cfg_out13", this);
    apb_in13 = new("apb_in13", this);
  endfunction

  // Additional13 class methods13
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer13 transfer13);
  extern virtual function void update_config13(uart_ctrl_config13 uart_ctrl_cfg13, int index);
  extern virtual function void set_slave_config13(apb_slave_config13 _slave_cfg13, int index);
  extern virtual function void set_uart_config13(uart_config13 _uart_cfg13);
  extern virtual function void write_effects13(apb_transfer13 transfer13);
  extern virtual function void read_effects13(apb_transfer13 transfer13);

endclass : uart_ctrl_env13

function void uart_ctrl_env13::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get13 or create the UART13 CONTROLLER13 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config13)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG13", "No uart_ctrl_config13 creating13...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config13::get_type(),
                                     default_uart_ctrl_config13::get_type());
    cfg = uart_ctrl_config13::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL13", "Config13 Randomization Failed13")
  end
  if (apb_slave_cfg13 == null) //begin
    if (!uvm_config_db#(apb_slave_config13)::get(this, "", "apb_slave_cfg13", apb_slave_cfg13)) begin
    `uvm_info("NOCONFIG13", "No apb_slave_config13 ..", UVM_LOW)
    apb_slave_cfg13 = cfg.apb_cfg13.slave_configs13[0];
  end
  //uvm_config_db#(uart_ctrl_config13)::set(this, "monitor13", "cfg", cfg);
  uvm_config_object::set(this, "monitor13", "cfg", cfg);
  uart_cfg13 = cfg.uart_cfg13;

  // UVMREG13: Create13 the adapter and predictor13
  reg2apb13 = reg_to_apb_adapter13::type_id::create("reg2apb13");
  apb_predictor13 = uvm_reg_predictor#(apb_transfer13)::type_id::create("apb_predictor13", this);
  reg_sequencer13 = uart_ctrl_reg_sequencer13::type_id::create("reg_sequencer13", this);

  // build system level monitor13
  monitor13 = uart_ctrl_monitor13::type_id::create("monitor13",this);
  ////monitor13.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env13::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG13 - Connect13 adapter to register sequencer and predictor13
  apb_predictor13.map = reg_model13.default_map;
  apb_predictor13.adapter = reg2apb13;
endfunction : connect_phase

// UVM_REG: write method for APB13 transfers13 - handles13 Register Operations13
function void uart_ctrl_env13::write(apb_transfer13 transfer13);
  if (apb_slave_cfg13.check_address_range13(transfer13.addr)) begin
    if (transfer13.direction13 == APB_WRITE13) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE13: addr = 'h%0h, data = 'h%0h",
          transfer13.addr, transfer13.data), UVM_MEDIUM)
      write_effects13(transfer13);
    end
    else if (transfer13.direction13 == APB_READ13) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ13: addr = 'h%0h, data = 'h%0h",
          transfer13.addr, transfer13.data), UVM_MEDIUM)
        read_effects13(transfer13);
    end else
      `uvm_error("REGMEM13", "Unsupported13 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG13 based on APB13 writes to config registers
function void uart_ctrl_env13::write_effects13(apb_transfer13 transfer13);
  case (transfer13.addr)
    apb_slave_cfg13.start_address13 + `LINE_CTRL13 : begin
                                            uart_cfg13.char_length13 = transfer13.data[1:0];
                                            uart_cfg13.parity_mode13 = transfer13.data[5:4];
                                            uart_cfg13.parity_en13   = transfer13.data[3];
                                            uart_cfg13.nbstop13      = transfer13.data[2];
                                            div_en13 = transfer13.data[7];
                                            uart_cfg13.ConvToIntChrl13();
                                            uart_cfg13.ConvToIntStpBt13();
                                            uart_cfg_out13.write(uart_cfg13);
                                          end
    apb_slave_cfg13.start_address13 + `DIVD_LATCH113 : begin
                                            if (div_en13) begin
                                            uart_cfg13.baud_rate_gen13 = transfer13.data[7:0];
                                            uart_cfg_out13.write(uart_cfg13);
                                            end
                                          end
    apb_slave_cfg13.start_address13 + `DIVD_LATCH213 : begin
                                            if (div_en13) begin
                                            uart_cfg13.baud_rate_div13 = transfer13.data[7:0];
                                            uart_cfg_out13.write(uart_cfg13);
                                            end
                                          end
    default: `uvm_warning("REGMEM213", "Write access not to Control13/Sataus13 Registers13")
  endcase
  set_uart_config13(uart_cfg13);
endfunction : write_effects13

function void uart_ctrl_env13::read_effects13(apb_transfer13 transfer13);
  // Nothing for now
endfunction : read_effects13

function void uart_ctrl_env13::update_config13(uart_ctrl_config13 uart_ctrl_cfg13, int index);
  `uvm_info(get_type_name(), {"Updating Config13\n", uart_ctrl_cfg13.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg13;
  // Update these13 configs13 also (not really13 necessary13 since13 all are pointers13)
  uart_cfg13 = uart_ctrl_cfg13.uart_cfg13;
  apb_slave_cfg13 = cfg.apb_cfg13.slave_configs13[index];
  monitor13.cfg = uart_ctrl_cfg13;
endfunction : update_config13

function void uart_ctrl_env13::set_slave_config13(apb_slave_config13 _slave_cfg13, int index);
  monitor13.cfg.apb_cfg13.slave_configs13[index]  = _slave_cfg13;
  monitor13.set_slave_config13(_slave_cfg13, index);
endfunction : set_slave_config13

function void uart_ctrl_env13::set_uart_config13(uart_config13 _uart_cfg13);
  `uvm_info(get_type_name(), {"Setting Config13\n", _uart_cfg13.sprint()}, UVM_HIGH)
  monitor13.cfg.uart_cfg13  = _uart_cfg13;
  monitor13.set_uart_config13(_uart_cfg13);
endfunction : set_uart_config13
