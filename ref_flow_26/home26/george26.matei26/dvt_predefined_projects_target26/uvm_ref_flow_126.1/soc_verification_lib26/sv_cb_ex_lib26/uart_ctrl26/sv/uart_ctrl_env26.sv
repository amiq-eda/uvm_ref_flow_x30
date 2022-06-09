/*-------------------------------------------------------------------------
File26 name   : uart_ctrl_env26.sv
Title26       : 
Project26     :
Created26     :
Description26 : Module26 env26, contains26 the instance of scoreboard26 and coverage26 model
Notes26       : 
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`include "uart_ctrl_defines26.svh"
class uart_ctrl_env26 extends uvm_env; 
  
  // Component configuration classes26
  uart_ctrl_config26 cfg;
  // These26 are pointers26 to config classes26 above26
  uart_config26 uart_cfg26;
  apb_slave_config26 apb_slave_cfg26;

  // Module26 monitor26 (includes26 scoreboards26, coverage26, checking)
  uart_ctrl_monitor26 monitor26;

  // Control26 bit
  bit div_en26;

  // UVM_REG: Pointer26 to the Register Model26
  uart_ctrl_reg_model_c26 reg_model26;
  // Adapter sequence and predictor26
  reg_to_apb_adapter26 reg2apb26;   // Adapter Object REG to APB26
  uvm_reg_predictor#(apb_transfer26) apb_predictor26;  // Precictor26 - APB26 to REG
  uart_ctrl_reg_sequencer26 reg_sequencer26;
  
  // TLM Connections26 
  uvm_analysis_port #(uart_config26) uart_cfg_out26;
  uvm_analysis_imp #(apb_transfer26, uart_ctrl_env26) apb_in26;

  `uvm_component_utils_begin(uart_ctrl_env26)
    `uvm_field_object(reg_model26, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb26, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create26 TLM ports26
    uart_cfg_out26 = new("uart_cfg_out26", this);
    apb_in26 = new("apb_in26", this);
  endfunction

  // Additional26 class methods26
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer26 transfer26);
  extern virtual function void update_config26(uart_ctrl_config26 uart_ctrl_cfg26, int index);
  extern virtual function void set_slave_config26(apb_slave_config26 _slave_cfg26, int index);
  extern virtual function void set_uart_config26(uart_config26 _uart_cfg26);
  extern virtual function void write_effects26(apb_transfer26 transfer26);
  extern virtual function void read_effects26(apb_transfer26 transfer26);

endclass : uart_ctrl_env26

function void uart_ctrl_env26::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get26 or create the UART26 CONTROLLER26 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config26)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG26", "No uart_ctrl_config26 creating26...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config26::get_type(),
                                     default_uart_ctrl_config26::get_type());
    cfg = uart_ctrl_config26::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL26", "Config26 Randomization Failed26")
  end
  if (apb_slave_cfg26 == null) //begin
    if (!uvm_config_db#(apb_slave_config26)::get(this, "", "apb_slave_cfg26", apb_slave_cfg26)) begin
    `uvm_info("NOCONFIG26", "No apb_slave_config26 ..", UVM_LOW)
    apb_slave_cfg26 = cfg.apb_cfg26.slave_configs26[0];
  end
  //uvm_config_db#(uart_ctrl_config26)::set(this, "monitor26", "cfg", cfg);
  uvm_config_object::set(this, "monitor26", "cfg", cfg);
  uart_cfg26 = cfg.uart_cfg26;

  // UVMREG26: Create26 the adapter and predictor26
  reg2apb26 = reg_to_apb_adapter26::type_id::create("reg2apb26");
  apb_predictor26 = uvm_reg_predictor#(apb_transfer26)::type_id::create("apb_predictor26", this);
  reg_sequencer26 = uart_ctrl_reg_sequencer26::type_id::create("reg_sequencer26", this);

  // build system level monitor26
  monitor26 = uart_ctrl_monitor26::type_id::create("monitor26",this);
  ////monitor26.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env26::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG26 - Connect26 adapter to register sequencer and predictor26
  apb_predictor26.map = reg_model26.default_map;
  apb_predictor26.adapter = reg2apb26;
endfunction : connect_phase

// UVM_REG: write method for APB26 transfers26 - handles26 Register Operations26
function void uart_ctrl_env26::write(apb_transfer26 transfer26);
  if (apb_slave_cfg26.check_address_range26(transfer26.addr)) begin
    if (transfer26.direction26 == APB_WRITE26) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE26: addr = 'h%0h, data = 'h%0h",
          transfer26.addr, transfer26.data), UVM_MEDIUM)
      write_effects26(transfer26);
    end
    else if (transfer26.direction26 == APB_READ26) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ26: addr = 'h%0h, data = 'h%0h",
          transfer26.addr, transfer26.data), UVM_MEDIUM)
        read_effects26(transfer26);
    end else
      `uvm_error("REGMEM26", "Unsupported26 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG26 based on APB26 writes to config registers
function void uart_ctrl_env26::write_effects26(apb_transfer26 transfer26);
  case (transfer26.addr)
    apb_slave_cfg26.start_address26 + `LINE_CTRL26 : begin
                                            uart_cfg26.char_length26 = transfer26.data[1:0];
                                            uart_cfg26.parity_mode26 = transfer26.data[5:4];
                                            uart_cfg26.parity_en26   = transfer26.data[3];
                                            uart_cfg26.nbstop26      = transfer26.data[2];
                                            div_en26 = transfer26.data[7];
                                            uart_cfg26.ConvToIntChrl26();
                                            uart_cfg26.ConvToIntStpBt26();
                                            uart_cfg_out26.write(uart_cfg26);
                                          end
    apb_slave_cfg26.start_address26 + `DIVD_LATCH126 : begin
                                            if (div_en26) begin
                                            uart_cfg26.baud_rate_gen26 = transfer26.data[7:0];
                                            uart_cfg_out26.write(uart_cfg26);
                                            end
                                          end
    apb_slave_cfg26.start_address26 + `DIVD_LATCH226 : begin
                                            if (div_en26) begin
                                            uart_cfg26.baud_rate_div26 = transfer26.data[7:0];
                                            uart_cfg_out26.write(uart_cfg26);
                                            end
                                          end
    default: `uvm_warning("REGMEM226", "Write access not to Control26/Sataus26 Registers26")
  endcase
  set_uart_config26(uart_cfg26);
endfunction : write_effects26

function void uart_ctrl_env26::read_effects26(apb_transfer26 transfer26);
  // Nothing for now
endfunction : read_effects26

function void uart_ctrl_env26::update_config26(uart_ctrl_config26 uart_ctrl_cfg26, int index);
  `uvm_info(get_type_name(), {"Updating Config26\n", uart_ctrl_cfg26.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg26;
  // Update these26 configs26 also (not really26 necessary26 since26 all are pointers26)
  uart_cfg26 = uart_ctrl_cfg26.uart_cfg26;
  apb_slave_cfg26 = cfg.apb_cfg26.slave_configs26[index];
  monitor26.cfg = uart_ctrl_cfg26;
endfunction : update_config26

function void uart_ctrl_env26::set_slave_config26(apb_slave_config26 _slave_cfg26, int index);
  monitor26.cfg.apb_cfg26.slave_configs26[index]  = _slave_cfg26;
  monitor26.set_slave_config26(_slave_cfg26, index);
endfunction : set_slave_config26

function void uart_ctrl_env26::set_uart_config26(uart_config26 _uart_cfg26);
  `uvm_info(get_type_name(), {"Setting Config26\n", _uart_cfg26.sprint()}, UVM_HIGH)
  monitor26.cfg.uart_cfg26  = _uart_cfg26;
  monitor26.set_uart_config26(_uart_cfg26);
endfunction : set_uart_config26
