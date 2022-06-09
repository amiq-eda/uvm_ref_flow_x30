/*-------------------------------------------------------------------------
File22 name   : uart_ctrl_env22.sv
Title22       : 
Project22     :
Created22     :
Description22 : Module22 env22, contains22 the instance of scoreboard22 and coverage22 model
Notes22       : 
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`include "uart_ctrl_defines22.svh"
class uart_ctrl_env22 extends uvm_env; 
  
  // Component configuration classes22
  uart_ctrl_config22 cfg;
  // These22 are pointers22 to config classes22 above22
  uart_config22 uart_cfg22;
  apb_slave_config22 apb_slave_cfg22;

  // Module22 monitor22 (includes22 scoreboards22, coverage22, checking)
  uart_ctrl_monitor22 monitor22;

  // Control22 bit
  bit div_en22;

  // UVM_REG: Pointer22 to the Register Model22
  uart_ctrl_reg_model_c22 reg_model22;
  // Adapter sequence and predictor22
  reg_to_apb_adapter22 reg2apb22;   // Adapter Object REG to APB22
  uvm_reg_predictor#(apb_transfer22) apb_predictor22;  // Precictor22 - APB22 to REG
  uart_ctrl_reg_sequencer22 reg_sequencer22;
  
  // TLM Connections22 
  uvm_analysis_port #(uart_config22) uart_cfg_out22;
  uvm_analysis_imp #(apb_transfer22, uart_ctrl_env22) apb_in22;

  `uvm_component_utils_begin(uart_ctrl_env22)
    `uvm_field_object(reg_model22, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb22, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create22 TLM ports22
    uart_cfg_out22 = new("uart_cfg_out22", this);
    apb_in22 = new("apb_in22", this);
  endfunction

  // Additional22 class methods22
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer22 transfer22);
  extern virtual function void update_config22(uart_ctrl_config22 uart_ctrl_cfg22, int index);
  extern virtual function void set_slave_config22(apb_slave_config22 _slave_cfg22, int index);
  extern virtual function void set_uart_config22(uart_config22 _uart_cfg22);
  extern virtual function void write_effects22(apb_transfer22 transfer22);
  extern virtual function void read_effects22(apb_transfer22 transfer22);

endclass : uart_ctrl_env22

function void uart_ctrl_env22::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get22 or create the UART22 CONTROLLER22 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config22)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG22", "No uart_ctrl_config22 creating22...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config22::get_type(),
                                     default_uart_ctrl_config22::get_type());
    cfg = uart_ctrl_config22::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL22", "Config22 Randomization Failed22")
  end
  if (apb_slave_cfg22 == null) //begin
    if (!uvm_config_db#(apb_slave_config22)::get(this, "", "apb_slave_cfg22", apb_slave_cfg22)) begin
    `uvm_info("NOCONFIG22", "No apb_slave_config22 ..", UVM_LOW)
    apb_slave_cfg22 = cfg.apb_cfg22.slave_configs22[0];
  end
  //uvm_config_db#(uart_ctrl_config22)::set(this, "monitor22", "cfg", cfg);
  uvm_config_object::set(this, "monitor22", "cfg", cfg);
  uart_cfg22 = cfg.uart_cfg22;

  // UVMREG22: Create22 the adapter and predictor22
  reg2apb22 = reg_to_apb_adapter22::type_id::create("reg2apb22");
  apb_predictor22 = uvm_reg_predictor#(apb_transfer22)::type_id::create("apb_predictor22", this);
  reg_sequencer22 = uart_ctrl_reg_sequencer22::type_id::create("reg_sequencer22", this);

  // build system level monitor22
  monitor22 = uart_ctrl_monitor22::type_id::create("monitor22",this);
  ////monitor22.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env22::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG22 - Connect22 adapter to register sequencer and predictor22
  apb_predictor22.map = reg_model22.default_map;
  apb_predictor22.adapter = reg2apb22;
endfunction : connect_phase

// UVM_REG: write method for APB22 transfers22 - handles22 Register Operations22
function void uart_ctrl_env22::write(apb_transfer22 transfer22);
  if (apb_slave_cfg22.check_address_range22(transfer22.addr)) begin
    if (transfer22.direction22 == APB_WRITE22) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE22: addr = 'h%0h, data = 'h%0h",
          transfer22.addr, transfer22.data), UVM_MEDIUM)
      write_effects22(transfer22);
    end
    else if (transfer22.direction22 == APB_READ22) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ22: addr = 'h%0h, data = 'h%0h",
          transfer22.addr, transfer22.data), UVM_MEDIUM)
        read_effects22(transfer22);
    end else
      `uvm_error("REGMEM22", "Unsupported22 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG22 based on APB22 writes to config registers
function void uart_ctrl_env22::write_effects22(apb_transfer22 transfer22);
  case (transfer22.addr)
    apb_slave_cfg22.start_address22 + `LINE_CTRL22 : begin
                                            uart_cfg22.char_length22 = transfer22.data[1:0];
                                            uart_cfg22.parity_mode22 = transfer22.data[5:4];
                                            uart_cfg22.parity_en22   = transfer22.data[3];
                                            uart_cfg22.nbstop22      = transfer22.data[2];
                                            div_en22 = transfer22.data[7];
                                            uart_cfg22.ConvToIntChrl22();
                                            uart_cfg22.ConvToIntStpBt22();
                                            uart_cfg_out22.write(uart_cfg22);
                                          end
    apb_slave_cfg22.start_address22 + `DIVD_LATCH122 : begin
                                            if (div_en22) begin
                                            uart_cfg22.baud_rate_gen22 = transfer22.data[7:0];
                                            uart_cfg_out22.write(uart_cfg22);
                                            end
                                          end
    apb_slave_cfg22.start_address22 + `DIVD_LATCH222 : begin
                                            if (div_en22) begin
                                            uart_cfg22.baud_rate_div22 = transfer22.data[7:0];
                                            uart_cfg_out22.write(uart_cfg22);
                                            end
                                          end
    default: `uvm_warning("REGMEM222", "Write access not to Control22/Sataus22 Registers22")
  endcase
  set_uart_config22(uart_cfg22);
endfunction : write_effects22

function void uart_ctrl_env22::read_effects22(apb_transfer22 transfer22);
  // Nothing for now
endfunction : read_effects22

function void uart_ctrl_env22::update_config22(uart_ctrl_config22 uart_ctrl_cfg22, int index);
  `uvm_info(get_type_name(), {"Updating Config22\n", uart_ctrl_cfg22.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg22;
  // Update these22 configs22 also (not really22 necessary22 since22 all are pointers22)
  uart_cfg22 = uart_ctrl_cfg22.uart_cfg22;
  apb_slave_cfg22 = cfg.apb_cfg22.slave_configs22[index];
  monitor22.cfg = uart_ctrl_cfg22;
endfunction : update_config22

function void uart_ctrl_env22::set_slave_config22(apb_slave_config22 _slave_cfg22, int index);
  monitor22.cfg.apb_cfg22.slave_configs22[index]  = _slave_cfg22;
  monitor22.set_slave_config22(_slave_cfg22, index);
endfunction : set_slave_config22

function void uart_ctrl_env22::set_uart_config22(uart_config22 _uart_cfg22);
  `uvm_info(get_type_name(), {"Setting Config22\n", _uart_cfg22.sprint()}, UVM_HIGH)
  monitor22.cfg.uart_cfg22  = _uart_cfg22;
  monitor22.set_uart_config22(_uart_cfg22);
endfunction : set_uart_config22
