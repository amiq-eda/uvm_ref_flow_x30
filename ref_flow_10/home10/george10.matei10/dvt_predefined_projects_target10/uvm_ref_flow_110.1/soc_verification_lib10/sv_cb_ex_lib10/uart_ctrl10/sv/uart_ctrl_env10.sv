/*-------------------------------------------------------------------------
File10 name   : uart_ctrl_env10.sv
Title10       : 
Project10     :
Created10     :
Description10 : Module10 env10, contains10 the instance of scoreboard10 and coverage10 model
Notes10       : 
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`include "uart_ctrl_defines10.svh"
class uart_ctrl_env10 extends uvm_env; 
  
  // Component configuration classes10
  uart_ctrl_config10 cfg;
  // These10 are pointers10 to config classes10 above10
  uart_config10 uart_cfg10;
  apb_slave_config10 apb_slave_cfg10;

  // Module10 monitor10 (includes10 scoreboards10, coverage10, checking)
  uart_ctrl_monitor10 monitor10;

  // Control10 bit
  bit div_en10;

  // UVM_REG: Pointer10 to the Register Model10
  uart_ctrl_reg_model_c10 reg_model10;
  // Adapter sequence and predictor10
  reg_to_apb_adapter10 reg2apb10;   // Adapter Object REG to APB10
  uvm_reg_predictor#(apb_transfer10) apb_predictor10;  // Precictor10 - APB10 to REG
  uart_ctrl_reg_sequencer10 reg_sequencer10;
  
  // TLM Connections10 
  uvm_analysis_port #(uart_config10) uart_cfg_out10;
  uvm_analysis_imp #(apb_transfer10, uart_ctrl_env10) apb_in10;

  `uvm_component_utils_begin(uart_ctrl_env10)
    `uvm_field_object(reg_model10, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb10, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create10 TLM ports10
    uart_cfg_out10 = new("uart_cfg_out10", this);
    apb_in10 = new("apb_in10", this);
  endfunction

  // Additional10 class methods10
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer10 transfer10);
  extern virtual function void update_config10(uart_ctrl_config10 uart_ctrl_cfg10, int index);
  extern virtual function void set_slave_config10(apb_slave_config10 _slave_cfg10, int index);
  extern virtual function void set_uart_config10(uart_config10 _uart_cfg10);
  extern virtual function void write_effects10(apb_transfer10 transfer10);
  extern virtual function void read_effects10(apb_transfer10 transfer10);

endclass : uart_ctrl_env10

function void uart_ctrl_env10::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get10 or create the UART10 CONTROLLER10 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config10)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG10", "No uart_ctrl_config10 creating10...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config10::get_type(),
                                     default_uart_ctrl_config10::get_type());
    cfg = uart_ctrl_config10::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL10", "Config10 Randomization Failed10")
  end
  if (apb_slave_cfg10 == null) //begin
    if (!uvm_config_db#(apb_slave_config10)::get(this, "", "apb_slave_cfg10", apb_slave_cfg10)) begin
    `uvm_info("NOCONFIG10", "No apb_slave_config10 ..", UVM_LOW)
    apb_slave_cfg10 = cfg.apb_cfg10.slave_configs10[0];
  end
  //uvm_config_db#(uart_ctrl_config10)::set(this, "monitor10", "cfg", cfg);
  uvm_config_object::set(this, "monitor10", "cfg", cfg);
  uart_cfg10 = cfg.uart_cfg10;

  // UVMREG10: Create10 the adapter and predictor10
  reg2apb10 = reg_to_apb_adapter10::type_id::create("reg2apb10");
  apb_predictor10 = uvm_reg_predictor#(apb_transfer10)::type_id::create("apb_predictor10", this);
  reg_sequencer10 = uart_ctrl_reg_sequencer10::type_id::create("reg_sequencer10", this);

  // build system level monitor10
  monitor10 = uart_ctrl_monitor10::type_id::create("monitor10",this);
  ////monitor10.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env10::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG10 - Connect10 adapter to register sequencer and predictor10
  apb_predictor10.map = reg_model10.default_map;
  apb_predictor10.adapter = reg2apb10;
endfunction : connect_phase

// UVM_REG: write method for APB10 transfers10 - handles10 Register Operations10
function void uart_ctrl_env10::write(apb_transfer10 transfer10);
  if (apb_slave_cfg10.check_address_range10(transfer10.addr)) begin
    if (transfer10.direction10 == APB_WRITE10) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE10: addr = 'h%0h, data = 'h%0h",
          transfer10.addr, transfer10.data), UVM_MEDIUM)
      write_effects10(transfer10);
    end
    else if (transfer10.direction10 == APB_READ10) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ10: addr = 'h%0h, data = 'h%0h",
          transfer10.addr, transfer10.data), UVM_MEDIUM)
        read_effects10(transfer10);
    end else
      `uvm_error("REGMEM10", "Unsupported10 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG10 based on APB10 writes to config registers
function void uart_ctrl_env10::write_effects10(apb_transfer10 transfer10);
  case (transfer10.addr)
    apb_slave_cfg10.start_address10 + `LINE_CTRL10 : begin
                                            uart_cfg10.char_length10 = transfer10.data[1:0];
                                            uart_cfg10.parity_mode10 = transfer10.data[5:4];
                                            uart_cfg10.parity_en10   = transfer10.data[3];
                                            uart_cfg10.nbstop10      = transfer10.data[2];
                                            div_en10 = transfer10.data[7];
                                            uart_cfg10.ConvToIntChrl10();
                                            uart_cfg10.ConvToIntStpBt10();
                                            uart_cfg_out10.write(uart_cfg10);
                                          end
    apb_slave_cfg10.start_address10 + `DIVD_LATCH110 : begin
                                            if (div_en10) begin
                                            uart_cfg10.baud_rate_gen10 = transfer10.data[7:0];
                                            uart_cfg_out10.write(uart_cfg10);
                                            end
                                          end
    apb_slave_cfg10.start_address10 + `DIVD_LATCH210 : begin
                                            if (div_en10) begin
                                            uart_cfg10.baud_rate_div10 = transfer10.data[7:0];
                                            uart_cfg_out10.write(uart_cfg10);
                                            end
                                          end
    default: `uvm_warning("REGMEM210", "Write access not to Control10/Sataus10 Registers10")
  endcase
  set_uart_config10(uart_cfg10);
endfunction : write_effects10

function void uart_ctrl_env10::read_effects10(apb_transfer10 transfer10);
  // Nothing for now
endfunction : read_effects10

function void uart_ctrl_env10::update_config10(uart_ctrl_config10 uart_ctrl_cfg10, int index);
  `uvm_info(get_type_name(), {"Updating Config10\n", uart_ctrl_cfg10.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg10;
  // Update these10 configs10 also (not really10 necessary10 since10 all are pointers10)
  uart_cfg10 = uart_ctrl_cfg10.uart_cfg10;
  apb_slave_cfg10 = cfg.apb_cfg10.slave_configs10[index];
  monitor10.cfg = uart_ctrl_cfg10;
endfunction : update_config10

function void uart_ctrl_env10::set_slave_config10(apb_slave_config10 _slave_cfg10, int index);
  monitor10.cfg.apb_cfg10.slave_configs10[index]  = _slave_cfg10;
  monitor10.set_slave_config10(_slave_cfg10, index);
endfunction : set_slave_config10

function void uart_ctrl_env10::set_uart_config10(uart_config10 _uart_cfg10);
  `uvm_info(get_type_name(), {"Setting Config10\n", _uart_cfg10.sprint()}, UVM_HIGH)
  monitor10.cfg.uart_cfg10  = _uart_cfg10;
  monitor10.set_uart_config10(_uart_cfg10);
endfunction : set_uart_config10
