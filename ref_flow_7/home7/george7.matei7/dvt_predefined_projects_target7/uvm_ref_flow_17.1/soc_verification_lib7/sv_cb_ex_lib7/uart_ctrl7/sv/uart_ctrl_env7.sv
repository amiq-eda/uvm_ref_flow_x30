/*-------------------------------------------------------------------------
File7 name   : uart_ctrl_env7.sv
Title7       : 
Project7     :
Created7     :
Description7 : Module7 env7, contains7 the instance of scoreboard7 and coverage7 model
Notes7       : 
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`include "uart_ctrl_defines7.svh"
class uart_ctrl_env7 extends uvm_env; 
  
  // Component configuration classes7
  uart_ctrl_config7 cfg;
  // These7 are pointers7 to config classes7 above7
  uart_config7 uart_cfg7;
  apb_slave_config7 apb_slave_cfg7;

  // Module7 monitor7 (includes7 scoreboards7, coverage7, checking)
  uart_ctrl_monitor7 monitor7;

  // Control7 bit
  bit div_en7;

  // UVM_REG: Pointer7 to the Register Model7
  uart_ctrl_reg_model_c7 reg_model7;
  // Adapter sequence and predictor7
  reg_to_apb_adapter7 reg2apb7;   // Adapter Object REG to APB7
  uvm_reg_predictor#(apb_transfer7) apb_predictor7;  // Precictor7 - APB7 to REG
  uart_ctrl_reg_sequencer7 reg_sequencer7;
  
  // TLM Connections7 
  uvm_analysis_port #(uart_config7) uart_cfg_out7;
  uvm_analysis_imp #(apb_transfer7, uart_ctrl_env7) apb_in7;

  `uvm_component_utils_begin(uart_ctrl_env7)
    `uvm_field_object(reg_model7, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb7, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create7 TLM ports7
    uart_cfg_out7 = new("uart_cfg_out7", this);
    apb_in7 = new("apb_in7", this);
  endfunction

  // Additional7 class methods7
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer7 transfer7);
  extern virtual function void update_config7(uart_ctrl_config7 uart_ctrl_cfg7, int index);
  extern virtual function void set_slave_config7(apb_slave_config7 _slave_cfg7, int index);
  extern virtual function void set_uart_config7(uart_config7 _uart_cfg7);
  extern virtual function void write_effects7(apb_transfer7 transfer7);
  extern virtual function void read_effects7(apb_transfer7 transfer7);

endclass : uart_ctrl_env7

function void uart_ctrl_env7::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get7 or create the UART7 CONTROLLER7 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config7)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG7", "No uart_ctrl_config7 creating7...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config7::get_type(),
                                     default_uart_ctrl_config7::get_type());
    cfg = uart_ctrl_config7::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL7", "Config7 Randomization Failed7")
  end
  if (apb_slave_cfg7 == null) //begin
    if (!uvm_config_db#(apb_slave_config7)::get(this, "", "apb_slave_cfg7", apb_slave_cfg7)) begin
    `uvm_info("NOCONFIG7", "No apb_slave_config7 ..", UVM_LOW)
    apb_slave_cfg7 = cfg.apb_cfg7.slave_configs7[0];
  end
  //uvm_config_db#(uart_ctrl_config7)::set(this, "monitor7", "cfg", cfg);
  uvm_config_object::set(this, "monitor7", "cfg", cfg);
  uart_cfg7 = cfg.uart_cfg7;

  // UVMREG7: Create7 the adapter and predictor7
  reg2apb7 = reg_to_apb_adapter7::type_id::create("reg2apb7");
  apb_predictor7 = uvm_reg_predictor#(apb_transfer7)::type_id::create("apb_predictor7", this);
  reg_sequencer7 = uart_ctrl_reg_sequencer7::type_id::create("reg_sequencer7", this);

  // build system level monitor7
  monitor7 = uart_ctrl_monitor7::type_id::create("monitor7",this);
  ////monitor7.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env7::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG7 - Connect7 adapter to register sequencer and predictor7
  apb_predictor7.map = reg_model7.default_map;
  apb_predictor7.adapter = reg2apb7;
endfunction : connect_phase

// UVM_REG: write method for APB7 transfers7 - handles7 Register Operations7
function void uart_ctrl_env7::write(apb_transfer7 transfer7);
  if (apb_slave_cfg7.check_address_range7(transfer7.addr)) begin
    if (transfer7.direction7 == APB_WRITE7) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE7: addr = 'h%0h, data = 'h%0h",
          transfer7.addr, transfer7.data), UVM_MEDIUM)
      write_effects7(transfer7);
    end
    else if (transfer7.direction7 == APB_READ7) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ7: addr = 'h%0h, data = 'h%0h",
          transfer7.addr, transfer7.data), UVM_MEDIUM)
        read_effects7(transfer7);
    end else
      `uvm_error("REGMEM7", "Unsupported7 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG7 based on APB7 writes to config registers
function void uart_ctrl_env7::write_effects7(apb_transfer7 transfer7);
  case (transfer7.addr)
    apb_slave_cfg7.start_address7 + `LINE_CTRL7 : begin
                                            uart_cfg7.char_length7 = transfer7.data[1:0];
                                            uart_cfg7.parity_mode7 = transfer7.data[5:4];
                                            uart_cfg7.parity_en7   = transfer7.data[3];
                                            uart_cfg7.nbstop7      = transfer7.data[2];
                                            div_en7 = transfer7.data[7];
                                            uart_cfg7.ConvToIntChrl7();
                                            uart_cfg7.ConvToIntStpBt7();
                                            uart_cfg_out7.write(uart_cfg7);
                                          end
    apb_slave_cfg7.start_address7 + `DIVD_LATCH17 : begin
                                            if (div_en7) begin
                                            uart_cfg7.baud_rate_gen7 = transfer7.data[7:0];
                                            uart_cfg_out7.write(uart_cfg7);
                                            end
                                          end
    apb_slave_cfg7.start_address7 + `DIVD_LATCH27 : begin
                                            if (div_en7) begin
                                            uart_cfg7.baud_rate_div7 = transfer7.data[7:0];
                                            uart_cfg_out7.write(uart_cfg7);
                                            end
                                          end
    default: `uvm_warning("REGMEM27", "Write access not to Control7/Sataus7 Registers7")
  endcase
  set_uart_config7(uart_cfg7);
endfunction : write_effects7

function void uart_ctrl_env7::read_effects7(apb_transfer7 transfer7);
  // Nothing for now
endfunction : read_effects7

function void uart_ctrl_env7::update_config7(uart_ctrl_config7 uart_ctrl_cfg7, int index);
  `uvm_info(get_type_name(), {"Updating Config7\n", uart_ctrl_cfg7.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg7;
  // Update these7 configs7 also (not really7 necessary7 since7 all are pointers7)
  uart_cfg7 = uart_ctrl_cfg7.uart_cfg7;
  apb_slave_cfg7 = cfg.apb_cfg7.slave_configs7[index];
  monitor7.cfg = uart_ctrl_cfg7;
endfunction : update_config7

function void uart_ctrl_env7::set_slave_config7(apb_slave_config7 _slave_cfg7, int index);
  monitor7.cfg.apb_cfg7.slave_configs7[index]  = _slave_cfg7;
  monitor7.set_slave_config7(_slave_cfg7, index);
endfunction : set_slave_config7

function void uart_ctrl_env7::set_uart_config7(uart_config7 _uart_cfg7);
  `uvm_info(get_type_name(), {"Setting Config7\n", _uart_cfg7.sprint()}, UVM_HIGH)
  monitor7.cfg.uart_cfg7  = _uart_cfg7;
  monitor7.set_uart_config7(_uart_cfg7);
endfunction : set_uart_config7
