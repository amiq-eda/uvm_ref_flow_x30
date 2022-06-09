/*-------------------------------------------------------------------------
File15 name   : uart_ctrl_env15.sv
Title15       : 
Project15     :
Created15     :
Description15 : Module15 env15, contains15 the instance of scoreboard15 and coverage15 model
Notes15       : 
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`include "uart_ctrl_defines15.svh"
class uart_ctrl_env15 extends uvm_env; 
  
  // Component configuration classes15
  uart_ctrl_config15 cfg;
  // These15 are pointers15 to config classes15 above15
  uart_config15 uart_cfg15;
  apb_slave_config15 apb_slave_cfg15;

  // Module15 monitor15 (includes15 scoreboards15, coverage15, checking)
  uart_ctrl_monitor15 monitor15;

  // Control15 bit
  bit div_en15;

  // UVM_REG: Pointer15 to the Register Model15
  uart_ctrl_reg_model_c15 reg_model15;
  // Adapter sequence and predictor15
  reg_to_apb_adapter15 reg2apb15;   // Adapter Object REG to APB15
  uvm_reg_predictor#(apb_transfer15) apb_predictor15;  // Precictor15 - APB15 to REG
  uart_ctrl_reg_sequencer15 reg_sequencer15;
  
  // TLM Connections15 
  uvm_analysis_port #(uart_config15) uart_cfg_out15;
  uvm_analysis_imp #(apb_transfer15, uart_ctrl_env15) apb_in15;

  `uvm_component_utils_begin(uart_ctrl_env15)
    `uvm_field_object(reg_model15, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb15, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create15 TLM ports15
    uart_cfg_out15 = new("uart_cfg_out15", this);
    apb_in15 = new("apb_in15", this);
  endfunction

  // Additional15 class methods15
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer15 transfer15);
  extern virtual function void update_config15(uart_ctrl_config15 uart_ctrl_cfg15, int index);
  extern virtual function void set_slave_config15(apb_slave_config15 _slave_cfg15, int index);
  extern virtual function void set_uart_config15(uart_config15 _uart_cfg15);
  extern virtual function void write_effects15(apb_transfer15 transfer15);
  extern virtual function void read_effects15(apb_transfer15 transfer15);

endclass : uart_ctrl_env15

function void uart_ctrl_env15::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get15 or create the UART15 CONTROLLER15 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config15)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG15", "No uart_ctrl_config15 creating15...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config15::get_type(),
                                     default_uart_ctrl_config15::get_type());
    cfg = uart_ctrl_config15::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL15", "Config15 Randomization Failed15")
  end
  if (apb_slave_cfg15 == null) //begin
    if (!uvm_config_db#(apb_slave_config15)::get(this, "", "apb_slave_cfg15", apb_slave_cfg15)) begin
    `uvm_info("NOCONFIG15", "No apb_slave_config15 ..", UVM_LOW)
    apb_slave_cfg15 = cfg.apb_cfg15.slave_configs15[0];
  end
  //uvm_config_db#(uart_ctrl_config15)::set(this, "monitor15", "cfg", cfg);
  uvm_config_object::set(this, "monitor15", "cfg", cfg);
  uart_cfg15 = cfg.uart_cfg15;

  // UVMREG15: Create15 the adapter and predictor15
  reg2apb15 = reg_to_apb_adapter15::type_id::create("reg2apb15");
  apb_predictor15 = uvm_reg_predictor#(apb_transfer15)::type_id::create("apb_predictor15", this);
  reg_sequencer15 = uart_ctrl_reg_sequencer15::type_id::create("reg_sequencer15", this);

  // build system level monitor15
  monitor15 = uart_ctrl_monitor15::type_id::create("monitor15",this);
  ////monitor15.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env15::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG15 - Connect15 adapter to register sequencer and predictor15
  apb_predictor15.map = reg_model15.default_map;
  apb_predictor15.adapter = reg2apb15;
endfunction : connect_phase

// UVM_REG: write method for APB15 transfers15 - handles15 Register Operations15
function void uart_ctrl_env15::write(apb_transfer15 transfer15);
  if (apb_slave_cfg15.check_address_range15(transfer15.addr)) begin
    if (transfer15.direction15 == APB_WRITE15) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE15: addr = 'h%0h, data = 'h%0h",
          transfer15.addr, transfer15.data), UVM_MEDIUM)
      write_effects15(transfer15);
    end
    else if (transfer15.direction15 == APB_READ15) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ15: addr = 'h%0h, data = 'h%0h",
          transfer15.addr, transfer15.data), UVM_MEDIUM)
        read_effects15(transfer15);
    end else
      `uvm_error("REGMEM15", "Unsupported15 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG15 based on APB15 writes to config registers
function void uart_ctrl_env15::write_effects15(apb_transfer15 transfer15);
  case (transfer15.addr)
    apb_slave_cfg15.start_address15 + `LINE_CTRL15 : begin
                                            uart_cfg15.char_length15 = transfer15.data[1:0];
                                            uart_cfg15.parity_mode15 = transfer15.data[5:4];
                                            uart_cfg15.parity_en15   = transfer15.data[3];
                                            uart_cfg15.nbstop15      = transfer15.data[2];
                                            div_en15 = transfer15.data[7];
                                            uart_cfg15.ConvToIntChrl15();
                                            uart_cfg15.ConvToIntStpBt15();
                                            uart_cfg_out15.write(uart_cfg15);
                                          end
    apb_slave_cfg15.start_address15 + `DIVD_LATCH115 : begin
                                            if (div_en15) begin
                                            uart_cfg15.baud_rate_gen15 = transfer15.data[7:0];
                                            uart_cfg_out15.write(uart_cfg15);
                                            end
                                          end
    apb_slave_cfg15.start_address15 + `DIVD_LATCH215 : begin
                                            if (div_en15) begin
                                            uart_cfg15.baud_rate_div15 = transfer15.data[7:0];
                                            uart_cfg_out15.write(uart_cfg15);
                                            end
                                          end
    default: `uvm_warning("REGMEM215", "Write access not to Control15/Sataus15 Registers15")
  endcase
  set_uart_config15(uart_cfg15);
endfunction : write_effects15

function void uart_ctrl_env15::read_effects15(apb_transfer15 transfer15);
  // Nothing for now
endfunction : read_effects15

function void uart_ctrl_env15::update_config15(uart_ctrl_config15 uart_ctrl_cfg15, int index);
  `uvm_info(get_type_name(), {"Updating Config15\n", uart_ctrl_cfg15.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg15;
  // Update these15 configs15 also (not really15 necessary15 since15 all are pointers15)
  uart_cfg15 = uart_ctrl_cfg15.uart_cfg15;
  apb_slave_cfg15 = cfg.apb_cfg15.slave_configs15[index];
  monitor15.cfg = uart_ctrl_cfg15;
endfunction : update_config15

function void uart_ctrl_env15::set_slave_config15(apb_slave_config15 _slave_cfg15, int index);
  monitor15.cfg.apb_cfg15.slave_configs15[index]  = _slave_cfg15;
  monitor15.set_slave_config15(_slave_cfg15, index);
endfunction : set_slave_config15

function void uart_ctrl_env15::set_uart_config15(uart_config15 _uart_cfg15);
  `uvm_info(get_type_name(), {"Setting Config15\n", _uart_cfg15.sprint()}, UVM_HIGH)
  monitor15.cfg.uart_cfg15  = _uart_cfg15;
  monitor15.set_uart_config15(_uart_cfg15);
endfunction : set_uart_config15
