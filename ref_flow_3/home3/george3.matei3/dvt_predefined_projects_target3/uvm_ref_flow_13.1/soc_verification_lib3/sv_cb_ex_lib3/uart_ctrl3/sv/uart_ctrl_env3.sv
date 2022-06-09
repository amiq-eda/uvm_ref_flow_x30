/*-------------------------------------------------------------------------
File3 name   : uart_ctrl_env3.sv
Title3       : 
Project3     :
Created3     :
Description3 : Module3 env3, contains3 the instance of scoreboard3 and coverage3 model
Notes3       : 
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`include "uart_ctrl_defines3.svh"
class uart_ctrl_env3 extends uvm_env; 
  
  // Component configuration classes3
  uart_ctrl_config3 cfg;
  // These3 are pointers3 to config classes3 above3
  uart_config3 uart_cfg3;
  apb_slave_config3 apb_slave_cfg3;

  // Module3 monitor3 (includes3 scoreboards3, coverage3, checking)
  uart_ctrl_monitor3 monitor3;

  // Control3 bit
  bit div_en3;

  // UVM_REG: Pointer3 to the Register Model3
  uart_ctrl_reg_model_c3 reg_model3;
  // Adapter sequence and predictor3
  reg_to_apb_adapter3 reg2apb3;   // Adapter Object REG to APB3
  uvm_reg_predictor#(apb_transfer3) apb_predictor3;  // Precictor3 - APB3 to REG
  uart_ctrl_reg_sequencer3 reg_sequencer3;
  
  // TLM Connections3 
  uvm_analysis_port #(uart_config3) uart_cfg_out3;
  uvm_analysis_imp #(apb_transfer3, uart_ctrl_env3) apb_in3;

  `uvm_component_utils_begin(uart_ctrl_env3)
    `uvm_field_object(reg_model3, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb3, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create3 TLM ports3
    uart_cfg_out3 = new("uart_cfg_out3", this);
    apb_in3 = new("apb_in3", this);
  endfunction

  // Additional3 class methods3
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer3 transfer3);
  extern virtual function void update_config3(uart_ctrl_config3 uart_ctrl_cfg3, int index);
  extern virtual function void set_slave_config3(apb_slave_config3 _slave_cfg3, int index);
  extern virtual function void set_uart_config3(uart_config3 _uart_cfg3);
  extern virtual function void write_effects3(apb_transfer3 transfer3);
  extern virtual function void read_effects3(apb_transfer3 transfer3);

endclass : uart_ctrl_env3

function void uart_ctrl_env3::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get3 or create the UART3 CONTROLLER3 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config3)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG3", "No uart_ctrl_config3 creating3...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config3::get_type(),
                                     default_uart_ctrl_config3::get_type());
    cfg = uart_ctrl_config3::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL3", "Config3 Randomization Failed3")
  end
  if (apb_slave_cfg3 == null) //begin
    if (!uvm_config_db#(apb_slave_config3)::get(this, "", "apb_slave_cfg3", apb_slave_cfg3)) begin
    `uvm_info("NOCONFIG3", "No apb_slave_config3 ..", UVM_LOW)
    apb_slave_cfg3 = cfg.apb_cfg3.slave_configs3[0];
  end
  //uvm_config_db#(uart_ctrl_config3)::set(this, "monitor3", "cfg", cfg);
  uvm_config_object::set(this, "monitor3", "cfg", cfg);
  uart_cfg3 = cfg.uart_cfg3;

  // UVMREG3: Create3 the adapter and predictor3
  reg2apb3 = reg_to_apb_adapter3::type_id::create("reg2apb3");
  apb_predictor3 = uvm_reg_predictor#(apb_transfer3)::type_id::create("apb_predictor3", this);
  reg_sequencer3 = uart_ctrl_reg_sequencer3::type_id::create("reg_sequencer3", this);

  // build system level monitor3
  monitor3 = uart_ctrl_monitor3::type_id::create("monitor3",this);
  ////monitor3.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env3::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG3 - Connect3 adapter to register sequencer and predictor3
  apb_predictor3.map = reg_model3.default_map;
  apb_predictor3.adapter = reg2apb3;
endfunction : connect_phase

// UVM_REG: write method for APB3 transfers3 - handles3 Register Operations3
function void uart_ctrl_env3::write(apb_transfer3 transfer3);
  if (apb_slave_cfg3.check_address_range3(transfer3.addr)) begin
    if (transfer3.direction3 == APB_WRITE3) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE3: addr = 'h%0h, data = 'h%0h",
          transfer3.addr, transfer3.data), UVM_MEDIUM)
      write_effects3(transfer3);
    end
    else if (transfer3.direction3 == APB_READ3) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ3: addr = 'h%0h, data = 'h%0h",
          transfer3.addr, transfer3.data), UVM_MEDIUM)
        read_effects3(transfer3);
    end else
      `uvm_error("REGMEM3", "Unsupported3 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG3 based on APB3 writes to config registers
function void uart_ctrl_env3::write_effects3(apb_transfer3 transfer3);
  case (transfer3.addr)
    apb_slave_cfg3.start_address3 + `LINE_CTRL3 : begin
                                            uart_cfg3.char_length3 = transfer3.data[1:0];
                                            uart_cfg3.parity_mode3 = transfer3.data[5:4];
                                            uart_cfg3.parity_en3   = transfer3.data[3];
                                            uart_cfg3.nbstop3      = transfer3.data[2];
                                            div_en3 = transfer3.data[7];
                                            uart_cfg3.ConvToIntChrl3();
                                            uart_cfg3.ConvToIntStpBt3();
                                            uart_cfg_out3.write(uart_cfg3);
                                          end
    apb_slave_cfg3.start_address3 + `DIVD_LATCH13 : begin
                                            if (div_en3) begin
                                            uart_cfg3.baud_rate_gen3 = transfer3.data[7:0];
                                            uart_cfg_out3.write(uart_cfg3);
                                            end
                                          end
    apb_slave_cfg3.start_address3 + `DIVD_LATCH23 : begin
                                            if (div_en3) begin
                                            uart_cfg3.baud_rate_div3 = transfer3.data[7:0];
                                            uart_cfg_out3.write(uart_cfg3);
                                            end
                                          end
    default: `uvm_warning("REGMEM23", "Write access not to Control3/Sataus3 Registers3")
  endcase
  set_uart_config3(uart_cfg3);
endfunction : write_effects3

function void uart_ctrl_env3::read_effects3(apb_transfer3 transfer3);
  // Nothing for now
endfunction : read_effects3

function void uart_ctrl_env3::update_config3(uart_ctrl_config3 uart_ctrl_cfg3, int index);
  `uvm_info(get_type_name(), {"Updating Config3\n", uart_ctrl_cfg3.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg3;
  // Update these3 configs3 also (not really3 necessary3 since3 all are pointers3)
  uart_cfg3 = uart_ctrl_cfg3.uart_cfg3;
  apb_slave_cfg3 = cfg.apb_cfg3.slave_configs3[index];
  monitor3.cfg = uart_ctrl_cfg3;
endfunction : update_config3

function void uart_ctrl_env3::set_slave_config3(apb_slave_config3 _slave_cfg3, int index);
  monitor3.cfg.apb_cfg3.slave_configs3[index]  = _slave_cfg3;
  monitor3.set_slave_config3(_slave_cfg3, index);
endfunction : set_slave_config3

function void uart_ctrl_env3::set_uart_config3(uart_config3 _uart_cfg3);
  `uvm_info(get_type_name(), {"Setting Config3\n", _uart_cfg3.sprint()}, UVM_HIGH)
  monitor3.cfg.uart_cfg3  = _uart_cfg3;
  monitor3.set_uart_config3(_uart_cfg3);
endfunction : set_uart_config3
