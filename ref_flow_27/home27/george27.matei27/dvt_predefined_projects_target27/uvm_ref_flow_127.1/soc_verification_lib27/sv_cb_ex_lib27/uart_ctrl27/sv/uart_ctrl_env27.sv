/*-------------------------------------------------------------------------
File27 name   : uart_ctrl_env27.sv
Title27       : 
Project27     :
Created27     :
Description27 : Module27 env27, contains27 the instance of scoreboard27 and coverage27 model
Notes27       : 
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`include "uart_ctrl_defines27.svh"
class uart_ctrl_env27 extends uvm_env; 
  
  // Component configuration classes27
  uart_ctrl_config27 cfg;
  // These27 are pointers27 to config classes27 above27
  uart_config27 uart_cfg27;
  apb_slave_config27 apb_slave_cfg27;

  // Module27 monitor27 (includes27 scoreboards27, coverage27, checking)
  uart_ctrl_monitor27 monitor27;

  // Control27 bit
  bit div_en27;

  // UVM_REG: Pointer27 to the Register Model27
  uart_ctrl_reg_model_c27 reg_model27;
  // Adapter sequence and predictor27
  reg_to_apb_adapter27 reg2apb27;   // Adapter Object REG to APB27
  uvm_reg_predictor#(apb_transfer27) apb_predictor27;  // Precictor27 - APB27 to REG
  uart_ctrl_reg_sequencer27 reg_sequencer27;
  
  // TLM Connections27 
  uvm_analysis_port #(uart_config27) uart_cfg_out27;
  uvm_analysis_imp #(apb_transfer27, uart_ctrl_env27) apb_in27;

  `uvm_component_utils_begin(uart_ctrl_env27)
    `uvm_field_object(reg_model27, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb27, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create27 TLM ports27
    uart_cfg_out27 = new("uart_cfg_out27", this);
    apb_in27 = new("apb_in27", this);
  endfunction

  // Additional27 class methods27
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer27 transfer27);
  extern virtual function void update_config27(uart_ctrl_config27 uart_ctrl_cfg27, int index);
  extern virtual function void set_slave_config27(apb_slave_config27 _slave_cfg27, int index);
  extern virtual function void set_uart_config27(uart_config27 _uart_cfg27);
  extern virtual function void write_effects27(apb_transfer27 transfer27);
  extern virtual function void read_effects27(apb_transfer27 transfer27);

endclass : uart_ctrl_env27

function void uart_ctrl_env27::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get27 or create the UART27 CONTROLLER27 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config27)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG27", "No uart_ctrl_config27 creating27...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config27::get_type(),
                                     default_uart_ctrl_config27::get_type());
    cfg = uart_ctrl_config27::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL27", "Config27 Randomization Failed27")
  end
  if (apb_slave_cfg27 == null) //begin
    if (!uvm_config_db#(apb_slave_config27)::get(this, "", "apb_slave_cfg27", apb_slave_cfg27)) begin
    `uvm_info("NOCONFIG27", "No apb_slave_config27 ..", UVM_LOW)
    apb_slave_cfg27 = cfg.apb_cfg27.slave_configs27[0];
  end
  //uvm_config_db#(uart_ctrl_config27)::set(this, "monitor27", "cfg", cfg);
  uvm_config_object::set(this, "monitor27", "cfg", cfg);
  uart_cfg27 = cfg.uart_cfg27;

  // UVMREG27: Create27 the adapter and predictor27
  reg2apb27 = reg_to_apb_adapter27::type_id::create("reg2apb27");
  apb_predictor27 = uvm_reg_predictor#(apb_transfer27)::type_id::create("apb_predictor27", this);
  reg_sequencer27 = uart_ctrl_reg_sequencer27::type_id::create("reg_sequencer27", this);

  // build system level monitor27
  monitor27 = uart_ctrl_monitor27::type_id::create("monitor27",this);
  ////monitor27.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env27::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG27 - Connect27 adapter to register sequencer and predictor27
  apb_predictor27.map = reg_model27.default_map;
  apb_predictor27.adapter = reg2apb27;
endfunction : connect_phase

// UVM_REG: write method for APB27 transfers27 - handles27 Register Operations27
function void uart_ctrl_env27::write(apb_transfer27 transfer27);
  if (apb_slave_cfg27.check_address_range27(transfer27.addr)) begin
    if (transfer27.direction27 == APB_WRITE27) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE27: addr = 'h%0h, data = 'h%0h",
          transfer27.addr, transfer27.data), UVM_MEDIUM)
      write_effects27(transfer27);
    end
    else if (transfer27.direction27 == APB_READ27) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ27: addr = 'h%0h, data = 'h%0h",
          transfer27.addr, transfer27.data), UVM_MEDIUM)
        read_effects27(transfer27);
    end else
      `uvm_error("REGMEM27", "Unsupported27 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG27 based on APB27 writes to config registers
function void uart_ctrl_env27::write_effects27(apb_transfer27 transfer27);
  case (transfer27.addr)
    apb_slave_cfg27.start_address27 + `LINE_CTRL27 : begin
                                            uart_cfg27.char_length27 = transfer27.data[1:0];
                                            uart_cfg27.parity_mode27 = transfer27.data[5:4];
                                            uart_cfg27.parity_en27   = transfer27.data[3];
                                            uart_cfg27.nbstop27      = transfer27.data[2];
                                            div_en27 = transfer27.data[7];
                                            uart_cfg27.ConvToIntChrl27();
                                            uart_cfg27.ConvToIntStpBt27();
                                            uart_cfg_out27.write(uart_cfg27);
                                          end
    apb_slave_cfg27.start_address27 + `DIVD_LATCH127 : begin
                                            if (div_en27) begin
                                            uart_cfg27.baud_rate_gen27 = transfer27.data[7:0];
                                            uart_cfg_out27.write(uart_cfg27);
                                            end
                                          end
    apb_slave_cfg27.start_address27 + `DIVD_LATCH227 : begin
                                            if (div_en27) begin
                                            uart_cfg27.baud_rate_div27 = transfer27.data[7:0];
                                            uart_cfg_out27.write(uart_cfg27);
                                            end
                                          end
    default: `uvm_warning("REGMEM227", "Write access not to Control27/Sataus27 Registers27")
  endcase
  set_uart_config27(uart_cfg27);
endfunction : write_effects27

function void uart_ctrl_env27::read_effects27(apb_transfer27 transfer27);
  // Nothing for now
endfunction : read_effects27

function void uart_ctrl_env27::update_config27(uart_ctrl_config27 uart_ctrl_cfg27, int index);
  `uvm_info(get_type_name(), {"Updating Config27\n", uart_ctrl_cfg27.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg27;
  // Update these27 configs27 also (not really27 necessary27 since27 all are pointers27)
  uart_cfg27 = uart_ctrl_cfg27.uart_cfg27;
  apb_slave_cfg27 = cfg.apb_cfg27.slave_configs27[index];
  monitor27.cfg = uart_ctrl_cfg27;
endfunction : update_config27

function void uart_ctrl_env27::set_slave_config27(apb_slave_config27 _slave_cfg27, int index);
  monitor27.cfg.apb_cfg27.slave_configs27[index]  = _slave_cfg27;
  monitor27.set_slave_config27(_slave_cfg27, index);
endfunction : set_slave_config27

function void uart_ctrl_env27::set_uart_config27(uart_config27 _uart_cfg27);
  `uvm_info(get_type_name(), {"Setting Config27\n", _uart_cfg27.sprint()}, UVM_HIGH)
  monitor27.cfg.uart_cfg27  = _uart_cfg27;
  monitor27.set_uart_config27(_uart_cfg27);
endfunction : set_uart_config27
