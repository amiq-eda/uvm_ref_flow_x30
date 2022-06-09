/*-------------------------------------------------------------------------
File16 name   : uart_ctrl_env16.sv
Title16       : 
Project16     :
Created16     :
Description16 : Module16 env16, contains16 the instance of scoreboard16 and coverage16 model
Notes16       : 
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


`include "uart_ctrl_defines16.svh"
class uart_ctrl_env16 extends uvm_env; 
  
  // Component configuration classes16
  uart_ctrl_config16 cfg;
  // These16 are pointers16 to config classes16 above16
  uart_config16 uart_cfg16;
  apb_slave_config16 apb_slave_cfg16;

  // Module16 monitor16 (includes16 scoreboards16, coverage16, checking)
  uart_ctrl_monitor16 monitor16;

  // Control16 bit
  bit div_en16;

  // UVM_REG: Pointer16 to the Register Model16
  uart_ctrl_reg_model_c16 reg_model16;
  // Adapter sequence and predictor16
  reg_to_apb_adapter16 reg2apb16;   // Adapter Object REG to APB16
  uvm_reg_predictor#(apb_transfer16) apb_predictor16;  // Precictor16 - APB16 to REG
  uart_ctrl_reg_sequencer16 reg_sequencer16;
  
  // TLM Connections16 
  uvm_analysis_port #(uart_config16) uart_cfg_out16;
  uvm_analysis_imp #(apb_transfer16, uart_ctrl_env16) apb_in16;

  `uvm_component_utils_begin(uart_ctrl_env16)
    `uvm_field_object(reg_model16, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb16, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create16 TLM ports16
    uart_cfg_out16 = new("uart_cfg_out16", this);
    apb_in16 = new("apb_in16", this);
  endfunction

  // Additional16 class methods16
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer16 transfer16);
  extern virtual function void update_config16(uart_ctrl_config16 uart_ctrl_cfg16, int index);
  extern virtual function void set_slave_config16(apb_slave_config16 _slave_cfg16, int index);
  extern virtual function void set_uart_config16(uart_config16 _uart_cfg16);
  extern virtual function void write_effects16(apb_transfer16 transfer16);
  extern virtual function void read_effects16(apb_transfer16 transfer16);

endclass : uart_ctrl_env16

function void uart_ctrl_env16::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get16 or create the UART16 CONTROLLER16 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config16)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG16", "No uart_ctrl_config16 creating16...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config16::get_type(),
                                     default_uart_ctrl_config16::get_type());
    cfg = uart_ctrl_config16::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL16", "Config16 Randomization Failed16")
  end
  if (apb_slave_cfg16 == null) //begin
    if (!uvm_config_db#(apb_slave_config16)::get(this, "", "apb_slave_cfg16", apb_slave_cfg16)) begin
    `uvm_info("NOCONFIG16", "No apb_slave_config16 ..", UVM_LOW)
    apb_slave_cfg16 = cfg.apb_cfg16.slave_configs16[0];
  end
  //uvm_config_db#(uart_ctrl_config16)::set(this, "monitor16", "cfg", cfg);
  uvm_config_object::set(this, "monitor16", "cfg", cfg);
  uart_cfg16 = cfg.uart_cfg16;

  // UVMREG16: Create16 the adapter and predictor16
  reg2apb16 = reg_to_apb_adapter16::type_id::create("reg2apb16");
  apb_predictor16 = uvm_reg_predictor#(apb_transfer16)::type_id::create("apb_predictor16", this);
  reg_sequencer16 = uart_ctrl_reg_sequencer16::type_id::create("reg_sequencer16", this);

  // build system level monitor16
  monitor16 = uart_ctrl_monitor16::type_id::create("monitor16",this);
  ////monitor16.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env16::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG16 - Connect16 adapter to register sequencer and predictor16
  apb_predictor16.map = reg_model16.default_map;
  apb_predictor16.adapter = reg2apb16;
endfunction : connect_phase

// UVM_REG: write method for APB16 transfers16 - handles16 Register Operations16
function void uart_ctrl_env16::write(apb_transfer16 transfer16);
  if (apb_slave_cfg16.check_address_range16(transfer16.addr)) begin
    if (transfer16.direction16 == APB_WRITE16) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE16: addr = 'h%0h, data = 'h%0h",
          transfer16.addr, transfer16.data), UVM_MEDIUM)
      write_effects16(transfer16);
    end
    else if (transfer16.direction16 == APB_READ16) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ16: addr = 'h%0h, data = 'h%0h",
          transfer16.addr, transfer16.data), UVM_MEDIUM)
        read_effects16(transfer16);
    end else
      `uvm_error("REGMEM16", "Unsupported16 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG16 based on APB16 writes to config registers
function void uart_ctrl_env16::write_effects16(apb_transfer16 transfer16);
  case (transfer16.addr)
    apb_slave_cfg16.start_address16 + `LINE_CTRL16 : begin
                                            uart_cfg16.char_length16 = transfer16.data[1:0];
                                            uart_cfg16.parity_mode16 = transfer16.data[5:4];
                                            uart_cfg16.parity_en16   = transfer16.data[3];
                                            uart_cfg16.nbstop16      = transfer16.data[2];
                                            div_en16 = transfer16.data[7];
                                            uart_cfg16.ConvToIntChrl16();
                                            uart_cfg16.ConvToIntStpBt16();
                                            uart_cfg_out16.write(uart_cfg16);
                                          end
    apb_slave_cfg16.start_address16 + `DIVD_LATCH116 : begin
                                            if (div_en16) begin
                                            uart_cfg16.baud_rate_gen16 = transfer16.data[7:0];
                                            uart_cfg_out16.write(uart_cfg16);
                                            end
                                          end
    apb_slave_cfg16.start_address16 + `DIVD_LATCH216 : begin
                                            if (div_en16) begin
                                            uart_cfg16.baud_rate_div16 = transfer16.data[7:0];
                                            uart_cfg_out16.write(uart_cfg16);
                                            end
                                          end
    default: `uvm_warning("REGMEM216", "Write access not to Control16/Sataus16 Registers16")
  endcase
  set_uart_config16(uart_cfg16);
endfunction : write_effects16

function void uart_ctrl_env16::read_effects16(apb_transfer16 transfer16);
  // Nothing for now
endfunction : read_effects16

function void uart_ctrl_env16::update_config16(uart_ctrl_config16 uart_ctrl_cfg16, int index);
  `uvm_info(get_type_name(), {"Updating Config16\n", uart_ctrl_cfg16.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg16;
  // Update these16 configs16 also (not really16 necessary16 since16 all are pointers16)
  uart_cfg16 = uart_ctrl_cfg16.uart_cfg16;
  apb_slave_cfg16 = cfg.apb_cfg16.slave_configs16[index];
  monitor16.cfg = uart_ctrl_cfg16;
endfunction : update_config16

function void uart_ctrl_env16::set_slave_config16(apb_slave_config16 _slave_cfg16, int index);
  monitor16.cfg.apb_cfg16.slave_configs16[index]  = _slave_cfg16;
  monitor16.set_slave_config16(_slave_cfg16, index);
endfunction : set_slave_config16

function void uart_ctrl_env16::set_uart_config16(uart_config16 _uart_cfg16);
  `uvm_info(get_type_name(), {"Setting Config16\n", _uart_cfg16.sprint()}, UVM_HIGH)
  monitor16.cfg.uart_cfg16  = _uart_cfg16;
  monitor16.set_uart_config16(_uart_cfg16);
endfunction : set_uart_config16
