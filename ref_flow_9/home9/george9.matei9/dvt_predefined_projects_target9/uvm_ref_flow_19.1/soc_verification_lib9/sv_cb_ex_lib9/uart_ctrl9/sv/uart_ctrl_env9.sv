/*-------------------------------------------------------------------------
File9 name   : uart_ctrl_env9.sv
Title9       : 
Project9     :
Created9     :
Description9 : Module9 env9, contains9 the instance of scoreboard9 and coverage9 model
Notes9       : 
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`include "uart_ctrl_defines9.svh"
class uart_ctrl_env9 extends uvm_env; 
  
  // Component configuration classes9
  uart_ctrl_config9 cfg;
  // These9 are pointers9 to config classes9 above9
  uart_config9 uart_cfg9;
  apb_slave_config9 apb_slave_cfg9;

  // Module9 monitor9 (includes9 scoreboards9, coverage9, checking)
  uart_ctrl_monitor9 monitor9;

  // Control9 bit
  bit div_en9;

  // UVM_REG: Pointer9 to the Register Model9
  uart_ctrl_reg_model_c9 reg_model9;
  // Adapter sequence and predictor9
  reg_to_apb_adapter9 reg2apb9;   // Adapter Object REG to APB9
  uvm_reg_predictor#(apb_transfer9) apb_predictor9;  // Precictor9 - APB9 to REG
  uart_ctrl_reg_sequencer9 reg_sequencer9;
  
  // TLM Connections9 
  uvm_analysis_port #(uart_config9) uart_cfg_out9;
  uvm_analysis_imp #(apb_transfer9, uart_ctrl_env9) apb_in9;

  `uvm_component_utils_begin(uart_ctrl_env9)
    `uvm_field_object(reg_model9, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb9, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create9 TLM ports9
    uart_cfg_out9 = new("uart_cfg_out9", this);
    apb_in9 = new("apb_in9", this);
  endfunction

  // Additional9 class methods9
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer9 transfer9);
  extern virtual function void update_config9(uart_ctrl_config9 uart_ctrl_cfg9, int index);
  extern virtual function void set_slave_config9(apb_slave_config9 _slave_cfg9, int index);
  extern virtual function void set_uart_config9(uart_config9 _uart_cfg9);
  extern virtual function void write_effects9(apb_transfer9 transfer9);
  extern virtual function void read_effects9(apb_transfer9 transfer9);

endclass : uart_ctrl_env9

function void uart_ctrl_env9::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get9 or create the UART9 CONTROLLER9 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config9)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG9", "No uart_ctrl_config9 creating9...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config9::get_type(),
                                     default_uart_ctrl_config9::get_type());
    cfg = uart_ctrl_config9::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL9", "Config9 Randomization Failed9")
  end
  if (apb_slave_cfg9 == null) //begin
    if (!uvm_config_db#(apb_slave_config9)::get(this, "", "apb_slave_cfg9", apb_slave_cfg9)) begin
    `uvm_info("NOCONFIG9", "No apb_slave_config9 ..", UVM_LOW)
    apb_slave_cfg9 = cfg.apb_cfg9.slave_configs9[0];
  end
  //uvm_config_db#(uart_ctrl_config9)::set(this, "monitor9", "cfg", cfg);
  uvm_config_object::set(this, "monitor9", "cfg", cfg);
  uart_cfg9 = cfg.uart_cfg9;

  // UVMREG9: Create9 the adapter and predictor9
  reg2apb9 = reg_to_apb_adapter9::type_id::create("reg2apb9");
  apb_predictor9 = uvm_reg_predictor#(apb_transfer9)::type_id::create("apb_predictor9", this);
  reg_sequencer9 = uart_ctrl_reg_sequencer9::type_id::create("reg_sequencer9", this);

  // build system level monitor9
  monitor9 = uart_ctrl_monitor9::type_id::create("monitor9",this);
  ////monitor9.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env9::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG9 - Connect9 adapter to register sequencer and predictor9
  apb_predictor9.map = reg_model9.default_map;
  apb_predictor9.adapter = reg2apb9;
endfunction : connect_phase

// UVM_REG: write method for APB9 transfers9 - handles9 Register Operations9
function void uart_ctrl_env9::write(apb_transfer9 transfer9);
  if (apb_slave_cfg9.check_address_range9(transfer9.addr)) begin
    if (transfer9.direction9 == APB_WRITE9) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE9: addr = 'h%0h, data = 'h%0h",
          transfer9.addr, transfer9.data), UVM_MEDIUM)
      write_effects9(transfer9);
    end
    else if (transfer9.direction9 == APB_READ9) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ9: addr = 'h%0h, data = 'h%0h",
          transfer9.addr, transfer9.data), UVM_MEDIUM)
        read_effects9(transfer9);
    end else
      `uvm_error("REGMEM9", "Unsupported9 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG9 based on APB9 writes to config registers
function void uart_ctrl_env9::write_effects9(apb_transfer9 transfer9);
  case (transfer9.addr)
    apb_slave_cfg9.start_address9 + `LINE_CTRL9 : begin
                                            uart_cfg9.char_length9 = transfer9.data[1:0];
                                            uart_cfg9.parity_mode9 = transfer9.data[5:4];
                                            uart_cfg9.parity_en9   = transfer9.data[3];
                                            uart_cfg9.nbstop9      = transfer9.data[2];
                                            div_en9 = transfer9.data[7];
                                            uart_cfg9.ConvToIntChrl9();
                                            uart_cfg9.ConvToIntStpBt9();
                                            uart_cfg_out9.write(uart_cfg9);
                                          end
    apb_slave_cfg9.start_address9 + `DIVD_LATCH19 : begin
                                            if (div_en9) begin
                                            uart_cfg9.baud_rate_gen9 = transfer9.data[7:0];
                                            uart_cfg_out9.write(uart_cfg9);
                                            end
                                          end
    apb_slave_cfg9.start_address9 + `DIVD_LATCH29 : begin
                                            if (div_en9) begin
                                            uart_cfg9.baud_rate_div9 = transfer9.data[7:0];
                                            uart_cfg_out9.write(uart_cfg9);
                                            end
                                          end
    default: `uvm_warning("REGMEM29", "Write access not to Control9/Sataus9 Registers9")
  endcase
  set_uart_config9(uart_cfg9);
endfunction : write_effects9

function void uart_ctrl_env9::read_effects9(apb_transfer9 transfer9);
  // Nothing for now
endfunction : read_effects9

function void uart_ctrl_env9::update_config9(uart_ctrl_config9 uart_ctrl_cfg9, int index);
  `uvm_info(get_type_name(), {"Updating Config9\n", uart_ctrl_cfg9.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg9;
  // Update these9 configs9 also (not really9 necessary9 since9 all are pointers9)
  uart_cfg9 = uart_ctrl_cfg9.uart_cfg9;
  apb_slave_cfg9 = cfg.apb_cfg9.slave_configs9[index];
  monitor9.cfg = uart_ctrl_cfg9;
endfunction : update_config9

function void uart_ctrl_env9::set_slave_config9(apb_slave_config9 _slave_cfg9, int index);
  monitor9.cfg.apb_cfg9.slave_configs9[index]  = _slave_cfg9;
  monitor9.set_slave_config9(_slave_cfg9, index);
endfunction : set_slave_config9

function void uart_ctrl_env9::set_uart_config9(uart_config9 _uart_cfg9);
  `uvm_info(get_type_name(), {"Setting Config9\n", _uart_cfg9.sprint()}, UVM_HIGH)
  monitor9.cfg.uart_cfg9  = _uart_cfg9;
  monitor9.set_uart_config9(_uart_cfg9);
endfunction : set_uart_config9
