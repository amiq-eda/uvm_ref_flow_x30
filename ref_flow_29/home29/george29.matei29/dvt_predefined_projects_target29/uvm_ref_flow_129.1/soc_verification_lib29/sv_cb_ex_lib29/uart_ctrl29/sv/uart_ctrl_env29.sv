/*-------------------------------------------------------------------------
File29 name   : uart_ctrl_env29.sv
Title29       : 
Project29     :
Created29     :
Description29 : Module29 env29, contains29 the instance of scoreboard29 and coverage29 model
Notes29       : 
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`include "uart_ctrl_defines29.svh"
class uart_ctrl_env29 extends uvm_env; 
  
  // Component configuration classes29
  uart_ctrl_config29 cfg;
  // These29 are pointers29 to config classes29 above29
  uart_config29 uart_cfg29;
  apb_slave_config29 apb_slave_cfg29;

  // Module29 monitor29 (includes29 scoreboards29, coverage29, checking)
  uart_ctrl_monitor29 monitor29;

  // Control29 bit
  bit div_en29;

  // UVM_REG: Pointer29 to the Register Model29
  uart_ctrl_reg_model_c29 reg_model29;
  // Adapter sequence and predictor29
  reg_to_apb_adapter29 reg2apb29;   // Adapter Object REG to APB29
  uvm_reg_predictor#(apb_transfer29) apb_predictor29;  // Precictor29 - APB29 to REG
  uart_ctrl_reg_sequencer29 reg_sequencer29;
  
  // TLM Connections29 
  uvm_analysis_port #(uart_config29) uart_cfg_out29;
  uvm_analysis_imp #(apb_transfer29, uart_ctrl_env29) apb_in29;

  `uvm_component_utils_begin(uart_ctrl_env29)
    `uvm_field_object(reg_model29, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb29, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create29 TLM ports29
    uart_cfg_out29 = new("uart_cfg_out29", this);
    apb_in29 = new("apb_in29", this);
  endfunction

  // Additional29 class methods29
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer29 transfer29);
  extern virtual function void update_config29(uart_ctrl_config29 uart_ctrl_cfg29, int index);
  extern virtual function void set_slave_config29(apb_slave_config29 _slave_cfg29, int index);
  extern virtual function void set_uart_config29(uart_config29 _uart_cfg29);
  extern virtual function void write_effects29(apb_transfer29 transfer29);
  extern virtual function void read_effects29(apb_transfer29 transfer29);

endclass : uart_ctrl_env29

function void uart_ctrl_env29::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get29 or create the UART29 CONTROLLER29 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config29)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG29", "No uart_ctrl_config29 creating29...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config29::get_type(),
                                     default_uart_ctrl_config29::get_type());
    cfg = uart_ctrl_config29::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL29", "Config29 Randomization Failed29")
  end
  if (apb_slave_cfg29 == null) //begin
    if (!uvm_config_db#(apb_slave_config29)::get(this, "", "apb_slave_cfg29", apb_slave_cfg29)) begin
    `uvm_info("NOCONFIG29", "No apb_slave_config29 ..", UVM_LOW)
    apb_slave_cfg29 = cfg.apb_cfg29.slave_configs29[0];
  end
  //uvm_config_db#(uart_ctrl_config29)::set(this, "monitor29", "cfg", cfg);
  uvm_config_object::set(this, "monitor29", "cfg", cfg);
  uart_cfg29 = cfg.uart_cfg29;

  // UVMREG29: Create29 the adapter and predictor29
  reg2apb29 = reg_to_apb_adapter29::type_id::create("reg2apb29");
  apb_predictor29 = uvm_reg_predictor#(apb_transfer29)::type_id::create("apb_predictor29", this);
  reg_sequencer29 = uart_ctrl_reg_sequencer29::type_id::create("reg_sequencer29", this);

  // build system level monitor29
  monitor29 = uart_ctrl_monitor29::type_id::create("monitor29",this);
  ////monitor29.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env29::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG29 - Connect29 adapter to register sequencer and predictor29
  apb_predictor29.map = reg_model29.default_map;
  apb_predictor29.adapter = reg2apb29;
endfunction : connect_phase

// UVM_REG: write method for APB29 transfers29 - handles29 Register Operations29
function void uart_ctrl_env29::write(apb_transfer29 transfer29);
  if (apb_slave_cfg29.check_address_range29(transfer29.addr)) begin
    if (transfer29.direction29 == APB_WRITE29) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE29: addr = 'h%0h, data = 'h%0h",
          transfer29.addr, transfer29.data), UVM_MEDIUM)
      write_effects29(transfer29);
    end
    else if (transfer29.direction29 == APB_READ29) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ29: addr = 'h%0h, data = 'h%0h",
          transfer29.addr, transfer29.data), UVM_MEDIUM)
        read_effects29(transfer29);
    end else
      `uvm_error("REGMEM29", "Unsupported29 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG29 based on APB29 writes to config registers
function void uart_ctrl_env29::write_effects29(apb_transfer29 transfer29);
  case (transfer29.addr)
    apb_slave_cfg29.start_address29 + `LINE_CTRL29 : begin
                                            uart_cfg29.char_length29 = transfer29.data[1:0];
                                            uart_cfg29.parity_mode29 = transfer29.data[5:4];
                                            uart_cfg29.parity_en29   = transfer29.data[3];
                                            uart_cfg29.nbstop29      = transfer29.data[2];
                                            div_en29 = transfer29.data[7];
                                            uart_cfg29.ConvToIntChrl29();
                                            uart_cfg29.ConvToIntStpBt29();
                                            uart_cfg_out29.write(uart_cfg29);
                                          end
    apb_slave_cfg29.start_address29 + `DIVD_LATCH129 : begin
                                            if (div_en29) begin
                                            uart_cfg29.baud_rate_gen29 = transfer29.data[7:0];
                                            uart_cfg_out29.write(uart_cfg29);
                                            end
                                          end
    apb_slave_cfg29.start_address29 + `DIVD_LATCH229 : begin
                                            if (div_en29) begin
                                            uart_cfg29.baud_rate_div29 = transfer29.data[7:0];
                                            uart_cfg_out29.write(uart_cfg29);
                                            end
                                          end
    default: `uvm_warning("REGMEM229", "Write access not to Control29/Sataus29 Registers29")
  endcase
  set_uart_config29(uart_cfg29);
endfunction : write_effects29

function void uart_ctrl_env29::read_effects29(apb_transfer29 transfer29);
  // Nothing for now
endfunction : read_effects29

function void uart_ctrl_env29::update_config29(uart_ctrl_config29 uart_ctrl_cfg29, int index);
  `uvm_info(get_type_name(), {"Updating Config29\n", uart_ctrl_cfg29.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg29;
  // Update these29 configs29 also (not really29 necessary29 since29 all are pointers29)
  uart_cfg29 = uart_ctrl_cfg29.uart_cfg29;
  apb_slave_cfg29 = cfg.apb_cfg29.slave_configs29[index];
  monitor29.cfg = uart_ctrl_cfg29;
endfunction : update_config29

function void uart_ctrl_env29::set_slave_config29(apb_slave_config29 _slave_cfg29, int index);
  monitor29.cfg.apb_cfg29.slave_configs29[index]  = _slave_cfg29;
  monitor29.set_slave_config29(_slave_cfg29, index);
endfunction : set_slave_config29

function void uart_ctrl_env29::set_uart_config29(uart_config29 _uart_cfg29);
  `uvm_info(get_type_name(), {"Setting Config29\n", _uart_cfg29.sprint()}, UVM_HIGH)
  monitor29.cfg.uart_cfg29  = _uart_cfg29;
  monitor29.set_uart_config29(_uart_cfg29);
endfunction : set_uart_config29
