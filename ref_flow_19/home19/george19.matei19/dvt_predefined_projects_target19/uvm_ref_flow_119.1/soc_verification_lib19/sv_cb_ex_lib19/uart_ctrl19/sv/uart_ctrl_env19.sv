/*-------------------------------------------------------------------------
File19 name   : uart_ctrl_env19.sv
Title19       : 
Project19     :
Created19     :
Description19 : Module19 env19, contains19 the instance of scoreboard19 and coverage19 model
Notes19       : 
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`include "uart_ctrl_defines19.svh"
class uart_ctrl_env19 extends uvm_env; 
  
  // Component configuration classes19
  uart_ctrl_config19 cfg;
  // These19 are pointers19 to config classes19 above19
  uart_config19 uart_cfg19;
  apb_slave_config19 apb_slave_cfg19;

  // Module19 monitor19 (includes19 scoreboards19, coverage19, checking)
  uart_ctrl_monitor19 monitor19;

  // Control19 bit
  bit div_en19;

  // UVM_REG: Pointer19 to the Register Model19
  uart_ctrl_reg_model_c19 reg_model19;
  // Adapter sequence and predictor19
  reg_to_apb_adapter19 reg2apb19;   // Adapter Object REG to APB19
  uvm_reg_predictor#(apb_transfer19) apb_predictor19;  // Precictor19 - APB19 to REG
  uart_ctrl_reg_sequencer19 reg_sequencer19;
  
  // TLM Connections19 
  uvm_analysis_port #(uart_config19) uart_cfg_out19;
  uvm_analysis_imp #(apb_transfer19, uart_ctrl_env19) apb_in19;

  `uvm_component_utils_begin(uart_ctrl_env19)
    `uvm_field_object(reg_model19, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb19, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create19 TLM ports19
    uart_cfg_out19 = new("uart_cfg_out19", this);
    apb_in19 = new("apb_in19", this);
  endfunction

  // Additional19 class methods19
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer19 transfer19);
  extern virtual function void update_config19(uart_ctrl_config19 uart_ctrl_cfg19, int index);
  extern virtual function void set_slave_config19(apb_slave_config19 _slave_cfg19, int index);
  extern virtual function void set_uart_config19(uart_config19 _uart_cfg19);
  extern virtual function void write_effects19(apb_transfer19 transfer19);
  extern virtual function void read_effects19(apb_transfer19 transfer19);

endclass : uart_ctrl_env19

function void uart_ctrl_env19::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get19 or create the UART19 CONTROLLER19 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config19)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG19", "No uart_ctrl_config19 creating19...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config19::get_type(),
                                     default_uart_ctrl_config19::get_type());
    cfg = uart_ctrl_config19::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL19", "Config19 Randomization Failed19")
  end
  if (apb_slave_cfg19 == null) //begin
    if (!uvm_config_db#(apb_slave_config19)::get(this, "", "apb_slave_cfg19", apb_slave_cfg19)) begin
    `uvm_info("NOCONFIG19", "No apb_slave_config19 ..", UVM_LOW)
    apb_slave_cfg19 = cfg.apb_cfg19.slave_configs19[0];
  end
  //uvm_config_db#(uart_ctrl_config19)::set(this, "monitor19", "cfg", cfg);
  uvm_config_object::set(this, "monitor19", "cfg", cfg);
  uart_cfg19 = cfg.uart_cfg19;

  // UVMREG19: Create19 the adapter and predictor19
  reg2apb19 = reg_to_apb_adapter19::type_id::create("reg2apb19");
  apb_predictor19 = uvm_reg_predictor#(apb_transfer19)::type_id::create("apb_predictor19", this);
  reg_sequencer19 = uart_ctrl_reg_sequencer19::type_id::create("reg_sequencer19", this);

  // build system level monitor19
  monitor19 = uart_ctrl_monitor19::type_id::create("monitor19",this);
  ////monitor19.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env19::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG19 - Connect19 adapter to register sequencer and predictor19
  apb_predictor19.map = reg_model19.default_map;
  apb_predictor19.adapter = reg2apb19;
endfunction : connect_phase

// UVM_REG: write method for APB19 transfers19 - handles19 Register Operations19
function void uart_ctrl_env19::write(apb_transfer19 transfer19);
  if (apb_slave_cfg19.check_address_range19(transfer19.addr)) begin
    if (transfer19.direction19 == APB_WRITE19) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE19: addr = 'h%0h, data = 'h%0h",
          transfer19.addr, transfer19.data), UVM_MEDIUM)
      write_effects19(transfer19);
    end
    else if (transfer19.direction19 == APB_READ19) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ19: addr = 'h%0h, data = 'h%0h",
          transfer19.addr, transfer19.data), UVM_MEDIUM)
        read_effects19(transfer19);
    end else
      `uvm_error("REGMEM19", "Unsupported19 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG19 based on APB19 writes to config registers
function void uart_ctrl_env19::write_effects19(apb_transfer19 transfer19);
  case (transfer19.addr)
    apb_slave_cfg19.start_address19 + `LINE_CTRL19 : begin
                                            uart_cfg19.char_length19 = transfer19.data[1:0];
                                            uart_cfg19.parity_mode19 = transfer19.data[5:4];
                                            uart_cfg19.parity_en19   = transfer19.data[3];
                                            uart_cfg19.nbstop19      = transfer19.data[2];
                                            div_en19 = transfer19.data[7];
                                            uart_cfg19.ConvToIntChrl19();
                                            uart_cfg19.ConvToIntStpBt19();
                                            uart_cfg_out19.write(uart_cfg19);
                                          end
    apb_slave_cfg19.start_address19 + `DIVD_LATCH119 : begin
                                            if (div_en19) begin
                                            uart_cfg19.baud_rate_gen19 = transfer19.data[7:0];
                                            uart_cfg_out19.write(uart_cfg19);
                                            end
                                          end
    apb_slave_cfg19.start_address19 + `DIVD_LATCH219 : begin
                                            if (div_en19) begin
                                            uart_cfg19.baud_rate_div19 = transfer19.data[7:0];
                                            uart_cfg_out19.write(uart_cfg19);
                                            end
                                          end
    default: `uvm_warning("REGMEM219", "Write access not to Control19/Sataus19 Registers19")
  endcase
  set_uart_config19(uart_cfg19);
endfunction : write_effects19

function void uart_ctrl_env19::read_effects19(apb_transfer19 transfer19);
  // Nothing for now
endfunction : read_effects19

function void uart_ctrl_env19::update_config19(uart_ctrl_config19 uart_ctrl_cfg19, int index);
  `uvm_info(get_type_name(), {"Updating Config19\n", uart_ctrl_cfg19.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg19;
  // Update these19 configs19 also (not really19 necessary19 since19 all are pointers19)
  uart_cfg19 = uart_ctrl_cfg19.uart_cfg19;
  apb_slave_cfg19 = cfg.apb_cfg19.slave_configs19[index];
  monitor19.cfg = uart_ctrl_cfg19;
endfunction : update_config19

function void uart_ctrl_env19::set_slave_config19(apb_slave_config19 _slave_cfg19, int index);
  monitor19.cfg.apb_cfg19.slave_configs19[index]  = _slave_cfg19;
  monitor19.set_slave_config19(_slave_cfg19, index);
endfunction : set_slave_config19

function void uart_ctrl_env19::set_uart_config19(uart_config19 _uart_cfg19);
  `uvm_info(get_type_name(), {"Setting Config19\n", _uart_cfg19.sprint()}, UVM_HIGH)
  monitor19.cfg.uart_cfg19  = _uart_cfg19;
  monitor19.set_uart_config19(_uart_cfg19);
endfunction : set_uart_config19
