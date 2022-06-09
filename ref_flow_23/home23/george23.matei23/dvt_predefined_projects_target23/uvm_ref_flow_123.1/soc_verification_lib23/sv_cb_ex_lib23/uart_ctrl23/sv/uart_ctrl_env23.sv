/*-------------------------------------------------------------------------
File23 name   : uart_ctrl_env23.sv
Title23       : 
Project23     :
Created23     :
Description23 : Module23 env23, contains23 the instance of scoreboard23 and coverage23 model
Notes23       : 
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`include "uart_ctrl_defines23.svh"
class uart_ctrl_env23 extends uvm_env; 
  
  // Component configuration classes23
  uart_ctrl_config23 cfg;
  // These23 are pointers23 to config classes23 above23
  uart_config23 uart_cfg23;
  apb_slave_config23 apb_slave_cfg23;

  // Module23 monitor23 (includes23 scoreboards23, coverage23, checking)
  uart_ctrl_monitor23 monitor23;

  // Control23 bit
  bit div_en23;

  // UVM_REG: Pointer23 to the Register Model23
  uart_ctrl_reg_model_c23 reg_model23;
  // Adapter sequence and predictor23
  reg_to_apb_adapter23 reg2apb23;   // Adapter Object REG to APB23
  uvm_reg_predictor#(apb_transfer23) apb_predictor23;  // Precictor23 - APB23 to REG
  uart_ctrl_reg_sequencer23 reg_sequencer23;
  
  // TLM Connections23 
  uvm_analysis_port #(uart_config23) uart_cfg_out23;
  uvm_analysis_imp #(apb_transfer23, uart_ctrl_env23) apb_in23;

  `uvm_component_utils_begin(uart_ctrl_env23)
    `uvm_field_object(reg_model23, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb23, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create23 TLM ports23
    uart_cfg_out23 = new("uart_cfg_out23", this);
    apb_in23 = new("apb_in23", this);
  endfunction

  // Additional23 class methods23
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer23 transfer23);
  extern virtual function void update_config23(uart_ctrl_config23 uart_ctrl_cfg23, int index);
  extern virtual function void set_slave_config23(apb_slave_config23 _slave_cfg23, int index);
  extern virtual function void set_uart_config23(uart_config23 _uart_cfg23);
  extern virtual function void write_effects23(apb_transfer23 transfer23);
  extern virtual function void read_effects23(apb_transfer23 transfer23);

endclass : uart_ctrl_env23

function void uart_ctrl_env23::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get23 or create the UART23 CONTROLLER23 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config23)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG23", "No uart_ctrl_config23 creating23...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config23::get_type(),
                                     default_uart_ctrl_config23::get_type());
    cfg = uart_ctrl_config23::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL23", "Config23 Randomization Failed23")
  end
  if (apb_slave_cfg23 == null) //begin
    if (!uvm_config_db#(apb_slave_config23)::get(this, "", "apb_slave_cfg23", apb_slave_cfg23)) begin
    `uvm_info("NOCONFIG23", "No apb_slave_config23 ..", UVM_LOW)
    apb_slave_cfg23 = cfg.apb_cfg23.slave_configs23[0];
  end
  //uvm_config_db#(uart_ctrl_config23)::set(this, "monitor23", "cfg", cfg);
  uvm_config_object::set(this, "monitor23", "cfg", cfg);
  uart_cfg23 = cfg.uart_cfg23;

  // UVMREG23: Create23 the adapter and predictor23
  reg2apb23 = reg_to_apb_adapter23::type_id::create("reg2apb23");
  apb_predictor23 = uvm_reg_predictor#(apb_transfer23)::type_id::create("apb_predictor23", this);
  reg_sequencer23 = uart_ctrl_reg_sequencer23::type_id::create("reg_sequencer23", this);

  // build system level monitor23
  monitor23 = uart_ctrl_monitor23::type_id::create("monitor23",this);
  ////monitor23.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env23::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG23 - Connect23 adapter to register sequencer and predictor23
  apb_predictor23.map = reg_model23.default_map;
  apb_predictor23.adapter = reg2apb23;
endfunction : connect_phase

// UVM_REG: write method for APB23 transfers23 - handles23 Register Operations23
function void uart_ctrl_env23::write(apb_transfer23 transfer23);
  if (apb_slave_cfg23.check_address_range23(transfer23.addr)) begin
    if (transfer23.direction23 == APB_WRITE23) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE23: addr = 'h%0h, data = 'h%0h",
          transfer23.addr, transfer23.data), UVM_MEDIUM)
      write_effects23(transfer23);
    end
    else if (transfer23.direction23 == APB_READ23) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ23: addr = 'h%0h, data = 'h%0h",
          transfer23.addr, transfer23.data), UVM_MEDIUM)
        read_effects23(transfer23);
    end else
      `uvm_error("REGMEM23", "Unsupported23 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG23 based on APB23 writes to config registers
function void uart_ctrl_env23::write_effects23(apb_transfer23 transfer23);
  case (transfer23.addr)
    apb_slave_cfg23.start_address23 + `LINE_CTRL23 : begin
                                            uart_cfg23.char_length23 = transfer23.data[1:0];
                                            uart_cfg23.parity_mode23 = transfer23.data[5:4];
                                            uart_cfg23.parity_en23   = transfer23.data[3];
                                            uart_cfg23.nbstop23      = transfer23.data[2];
                                            div_en23 = transfer23.data[7];
                                            uart_cfg23.ConvToIntChrl23();
                                            uart_cfg23.ConvToIntStpBt23();
                                            uart_cfg_out23.write(uart_cfg23);
                                          end
    apb_slave_cfg23.start_address23 + `DIVD_LATCH123 : begin
                                            if (div_en23) begin
                                            uart_cfg23.baud_rate_gen23 = transfer23.data[7:0];
                                            uart_cfg_out23.write(uart_cfg23);
                                            end
                                          end
    apb_slave_cfg23.start_address23 + `DIVD_LATCH223 : begin
                                            if (div_en23) begin
                                            uart_cfg23.baud_rate_div23 = transfer23.data[7:0];
                                            uart_cfg_out23.write(uart_cfg23);
                                            end
                                          end
    default: `uvm_warning("REGMEM223", "Write access not to Control23/Sataus23 Registers23")
  endcase
  set_uart_config23(uart_cfg23);
endfunction : write_effects23

function void uart_ctrl_env23::read_effects23(apb_transfer23 transfer23);
  // Nothing for now
endfunction : read_effects23

function void uart_ctrl_env23::update_config23(uart_ctrl_config23 uart_ctrl_cfg23, int index);
  `uvm_info(get_type_name(), {"Updating Config23\n", uart_ctrl_cfg23.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg23;
  // Update these23 configs23 also (not really23 necessary23 since23 all are pointers23)
  uart_cfg23 = uart_ctrl_cfg23.uart_cfg23;
  apb_slave_cfg23 = cfg.apb_cfg23.slave_configs23[index];
  monitor23.cfg = uart_ctrl_cfg23;
endfunction : update_config23

function void uart_ctrl_env23::set_slave_config23(apb_slave_config23 _slave_cfg23, int index);
  monitor23.cfg.apb_cfg23.slave_configs23[index]  = _slave_cfg23;
  monitor23.set_slave_config23(_slave_cfg23, index);
endfunction : set_slave_config23

function void uart_ctrl_env23::set_uart_config23(uart_config23 _uart_cfg23);
  `uvm_info(get_type_name(), {"Setting Config23\n", _uart_cfg23.sprint()}, UVM_HIGH)
  monitor23.cfg.uart_cfg23  = _uart_cfg23;
  monitor23.set_uart_config23(_uart_cfg23);
endfunction : set_uart_config23
