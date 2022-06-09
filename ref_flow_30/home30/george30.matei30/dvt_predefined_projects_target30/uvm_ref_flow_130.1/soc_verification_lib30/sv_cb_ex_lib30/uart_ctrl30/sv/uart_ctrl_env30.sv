/*-------------------------------------------------------------------------
File30 name   : uart_ctrl_env30.sv
Title30       : 
Project30     :
Created30     :
Description30 : Module30 env30, contains30 the instance of scoreboard30 and coverage30 model
Notes30       : 
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`include "uart_ctrl_defines30.svh"
class uart_ctrl_env30 extends uvm_env; 
  
  // Component configuration classes30
  uart_ctrl_config30 cfg;
  // These30 are pointers30 to config classes30 above30
  uart_config30 uart_cfg30;
  apb_slave_config30 apb_slave_cfg30;

  // Module30 monitor30 (includes30 scoreboards30, coverage30, checking)
  uart_ctrl_monitor30 monitor30;

  // Control30 bit
  bit div_en30;

  // UVM_REG: Pointer30 to the Register Model30
  uart_ctrl_reg_model_c30 reg_model30;
  // Adapter sequence and predictor30
  reg_to_apb_adapter30 reg2apb30;   // Adapter Object REG to APB30
  uvm_reg_predictor#(apb_transfer30) apb_predictor30;  // Precictor30 - APB30 to REG
  uart_ctrl_reg_sequencer30 reg_sequencer30;
  
  // TLM Connections30 
  uvm_analysis_port #(uart_config30) uart_cfg_out30;
  uvm_analysis_imp #(apb_transfer30, uart_ctrl_env30) apb_in30;

  `uvm_component_utils_begin(uart_ctrl_env30)
    `uvm_field_object(reg_model30, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb30, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create30 TLM ports30
    uart_cfg_out30 = new("uart_cfg_out30", this);
    apb_in30 = new("apb_in30", this);
  endfunction

  // Additional30 class methods30
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer30 transfer30);
  extern virtual function void update_config30(uart_ctrl_config30 uart_ctrl_cfg30, int index);
  extern virtual function void set_slave_config30(apb_slave_config30 _slave_cfg30, int index);
  extern virtual function void set_uart_config30(uart_config30 _uart_cfg30);
  extern virtual function void write_effects30(apb_transfer30 transfer30);
  extern virtual function void read_effects30(apb_transfer30 transfer30);

endclass : uart_ctrl_env30

function void uart_ctrl_env30::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get30 or create the UART30 CONTROLLER30 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config30)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG30", "No uart_ctrl_config30 creating30...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config30::get_type(),
                                     default_uart_ctrl_config30::get_type());
    cfg = uart_ctrl_config30::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL30", "Config30 Randomization Failed30")
  end
  if (apb_slave_cfg30 == null) //begin
    if (!uvm_config_db#(apb_slave_config30)::get(this, "", "apb_slave_cfg30", apb_slave_cfg30)) begin
    `uvm_info("NOCONFIG30", "No apb_slave_config30 ..", UVM_LOW)
    apb_slave_cfg30 = cfg.apb_cfg30.slave_configs30[0];
  end
  //uvm_config_db#(uart_ctrl_config30)::set(this, "monitor30", "cfg", cfg);
  uvm_config_object::set(this, "monitor30", "cfg", cfg);
  uart_cfg30 = cfg.uart_cfg30;

  // UVMREG30: Create30 the adapter and predictor30
  reg2apb30 = reg_to_apb_adapter30::type_id::create("reg2apb30");
  apb_predictor30 = uvm_reg_predictor#(apb_transfer30)::type_id::create("apb_predictor30", this);
  reg_sequencer30 = uart_ctrl_reg_sequencer30::type_id::create("reg_sequencer30", this);

  // build system level monitor30
  monitor30 = uart_ctrl_monitor30::type_id::create("monitor30",this);
  ////monitor30.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env30::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG30 - Connect30 adapter to register sequencer and predictor30
  apb_predictor30.map = reg_model30.default_map;
  apb_predictor30.adapter = reg2apb30;
endfunction : connect_phase

// UVM_REG: write method for APB30 transfers30 - handles30 Register Operations30
function void uart_ctrl_env30::write(apb_transfer30 transfer30);
  if (apb_slave_cfg30.check_address_range30(transfer30.addr)) begin
    if (transfer30.direction30 == APB_WRITE30) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE30: addr = 'h%0h, data = 'h%0h",
          transfer30.addr, transfer30.data), UVM_MEDIUM)
      write_effects30(transfer30);
    end
    else if (transfer30.direction30 == APB_READ30) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ30: addr = 'h%0h, data = 'h%0h",
          transfer30.addr, transfer30.data), UVM_MEDIUM)
        read_effects30(transfer30);
    end else
      `uvm_error("REGMEM30", "Unsupported30 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG30 based on APB30 writes to config registers
function void uart_ctrl_env30::write_effects30(apb_transfer30 transfer30);
  case (transfer30.addr)
    apb_slave_cfg30.start_address30 + `LINE_CTRL30 : begin
                                            uart_cfg30.char_length30 = transfer30.data[1:0];
                                            uart_cfg30.parity_mode30 = transfer30.data[5:4];
                                            uart_cfg30.parity_en30   = transfer30.data[3];
                                            uart_cfg30.nbstop30      = transfer30.data[2];
                                            div_en30 = transfer30.data[7];
                                            uart_cfg30.ConvToIntChrl30();
                                            uart_cfg30.ConvToIntStpBt30();
                                            uart_cfg_out30.write(uart_cfg30);
                                          end
    apb_slave_cfg30.start_address30 + `DIVD_LATCH130 : begin
                                            if (div_en30) begin
                                            uart_cfg30.baud_rate_gen30 = transfer30.data[7:0];
                                            uart_cfg_out30.write(uart_cfg30);
                                            end
                                          end
    apb_slave_cfg30.start_address30 + `DIVD_LATCH230 : begin
                                            if (div_en30) begin
                                            uart_cfg30.baud_rate_div30 = transfer30.data[7:0];
                                            uart_cfg_out30.write(uart_cfg30);
                                            end
                                          end
    default: `uvm_warning("REGMEM230", "Write access not to Control30/Sataus30 Registers30")
  endcase
  set_uart_config30(uart_cfg30);
endfunction : write_effects30

function void uart_ctrl_env30::read_effects30(apb_transfer30 transfer30);
  // Nothing for now
endfunction : read_effects30

function void uart_ctrl_env30::update_config30(uart_ctrl_config30 uart_ctrl_cfg30, int index);
  `uvm_info(get_type_name(), {"Updating Config30\n", uart_ctrl_cfg30.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg30;
  // Update these30 configs30 also (not really30 necessary30 since30 all are pointers30)
  uart_cfg30 = uart_ctrl_cfg30.uart_cfg30;
  apb_slave_cfg30 = cfg.apb_cfg30.slave_configs30[index];
  monitor30.cfg = uart_ctrl_cfg30;
endfunction : update_config30

function void uart_ctrl_env30::set_slave_config30(apb_slave_config30 _slave_cfg30, int index);
  monitor30.cfg.apb_cfg30.slave_configs30[index]  = _slave_cfg30;
  monitor30.set_slave_config30(_slave_cfg30, index);
endfunction : set_slave_config30

function void uart_ctrl_env30::set_uart_config30(uart_config30 _uart_cfg30);
  `uvm_info(get_type_name(), {"Setting Config30\n", _uart_cfg30.sprint()}, UVM_HIGH)
  monitor30.cfg.uart_cfg30  = _uart_cfg30;
  monitor30.set_uart_config30(_uart_cfg30);
endfunction : set_uart_config30
