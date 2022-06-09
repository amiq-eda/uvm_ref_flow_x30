/*-------------------------------------------------------------------------
File25 name   : uart_ctrl_env25.sv
Title25       : 
Project25     :
Created25     :
Description25 : Module25 env25, contains25 the instance of scoreboard25 and coverage25 model
Notes25       : 
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`include "uart_ctrl_defines25.svh"
class uart_ctrl_env25 extends uvm_env; 
  
  // Component configuration classes25
  uart_ctrl_config25 cfg;
  // These25 are pointers25 to config classes25 above25
  uart_config25 uart_cfg25;
  apb_slave_config25 apb_slave_cfg25;

  // Module25 monitor25 (includes25 scoreboards25, coverage25, checking)
  uart_ctrl_monitor25 monitor25;

  // Control25 bit
  bit div_en25;

  // UVM_REG: Pointer25 to the Register Model25
  uart_ctrl_reg_model_c25 reg_model25;
  // Adapter sequence and predictor25
  reg_to_apb_adapter25 reg2apb25;   // Adapter Object REG to APB25
  uvm_reg_predictor#(apb_transfer25) apb_predictor25;  // Precictor25 - APB25 to REG
  uart_ctrl_reg_sequencer25 reg_sequencer25;
  
  // TLM Connections25 
  uvm_analysis_port #(uart_config25) uart_cfg_out25;
  uvm_analysis_imp #(apb_transfer25, uart_ctrl_env25) apb_in25;

  `uvm_component_utils_begin(uart_ctrl_env25)
    `uvm_field_object(reg_model25, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb25, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create25 TLM ports25
    uart_cfg_out25 = new("uart_cfg_out25", this);
    apb_in25 = new("apb_in25", this);
  endfunction

  // Additional25 class methods25
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer25 transfer25);
  extern virtual function void update_config25(uart_ctrl_config25 uart_ctrl_cfg25, int index);
  extern virtual function void set_slave_config25(apb_slave_config25 _slave_cfg25, int index);
  extern virtual function void set_uart_config25(uart_config25 _uart_cfg25);
  extern virtual function void write_effects25(apb_transfer25 transfer25);
  extern virtual function void read_effects25(apb_transfer25 transfer25);

endclass : uart_ctrl_env25

function void uart_ctrl_env25::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get25 or create the UART25 CONTROLLER25 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config25)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG25", "No uart_ctrl_config25 creating25...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config25::get_type(),
                                     default_uart_ctrl_config25::get_type());
    cfg = uart_ctrl_config25::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL25", "Config25 Randomization Failed25")
  end
  if (apb_slave_cfg25 == null) //begin
    if (!uvm_config_db#(apb_slave_config25)::get(this, "", "apb_slave_cfg25", apb_slave_cfg25)) begin
    `uvm_info("NOCONFIG25", "No apb_slave_config25 ..", UVM_LOW)
    apb_slave_cfg25 = cfg.apb_cfg25.slave_configs25[0];
  end
  //uvm_config_db#(uart_ctrl_config25)::set(this, "monitor25", "cfg", cfg);
  uvm_config_object::set(this, "monitor25", "cfg", cfg);
  uart_cfg25 = cfg.uart_cfg25;

  // UVMREG25: Create25 the adapter and predictor25
  reg2apb25 = reg_to_apb_adapter25::type_id::create("reg2apb25");
  apb_predictor25 = uvm_reg_predictor#(apb_transfer25)::type_id::create("apb_predictor25", this);
  reg_sequencer25 = uart_ctrl_reg_sequencer25::type_id::create("reg_sequencer25", this);

  // build system level monitor25
  monitor25 = uart_ctrl_monitor25::type_id::create("monitor25",this);
  ////monitor25.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env25::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG25 - Connect25 adapter to register sequencer and predictor25
  apb_predictor25.map = reg_model25.default_map;
  apb_predictor25.adapter = reg2apb25;
endfunction : connect_phase

// UVM_REG: write method for APB25 transfers25 - handles25 Register Operations25
function void uart_ctrl_env25::write(apb_transfer25 transfer25);
  if (apb_slave_cfg25.check_address_range25(transfer25.addr)) begin
    if (transfer25.direction25 == APB_WRITE25) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE25: addr = 'h%0h, data = 'h%0h",
          transfer25.addr, transfer25.data), UVM_MEDIUM)
      write_effects25(transfer25);
    end
    else if (transfer25.direction25 == APB_READ25) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ25: addr = 'h%0h, data = 'h%0h",
          transfer25.addr, transfer25.data), UVM_MEDIUM)
        read_effects25(transfer25);
    end else
      `uvm_error("REGMEM25", "Unsupported25 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG25 based on APB25 writes to config registers
function void uart_ctrl_env25::write_effects25(apb_transfer25 transfer25);
  case (transfer25.addr)
    apb_slave_cfg25.start_address25 + `LINE_CTRL25 : begin
                                            uart_cfg25.char_length25 = transfer25.data[1:0];
                                            uart_cfg25.parity_mode25 = transfer25.data[5:4];
                                            uart_cfg25.parity_en25   = transfer25.data[3];
                                            uart_cfg25.nbstop25      = transfer25.data[2];
                                            div_en25 = transfer25.data[7];
                                            uart_cfg25.ConvToIntChrl25();
                                            uart_cfg25.ConvToIntStpBt25();
                                            uart_cfg_out25.write(uart_cfg25);
                                          end
    apb_slave_cfg25.start_address25 + `DIVD_LATCH125 : begin
                                            if (div_en25) begin
                                            uart_cfg25.baud_rate_gen25 = transfer25.data[7:0];
                                            uart_cfg_out25.write(uart_cfg25);
                                            end
                                          end
    apb_slave_cfg25.start_address25 + `DIVD_LATCH225 : begin
                                            if (div_en25) begin
                                            uart_cfg25.baud_rate_div25 = transfer25.data[7:0];
                                            uart_cfg_out25.write(uart_cfg25);
                                            end
                                          end
    default: `uvm_warning("REGMEM225", "Write access not to Control25/Sataus25 Registers25")
  endcase
  set_uart_config25(uart_cfg25);
endfunction : write_effects25

function void uart_ctrl_env25::read_effects25(apb_transfer25 transfer25);
  // Nothing for now
endfunction : read_effects25

function void uart_ctrl_env25::update_config25(uart_ctrl_config25 uart_ctrl_cfg25, int index);
  `uvm_info(get_type_name(), {"Updating Config25\n", uart_ctrl_cfg25.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg25;
  // Update these25 configs25 also (not really25 necessary25 since25 all are pointers25)
  uart_cfg25 = uart_ctrl_cfg25.uart_cfg25;
  apb_slave_cfg25 = cfg.apb_cfg25.slave_configs25[index];
  monitor25.cfg = uart_ctrl_cfg25;
endfunction : update_config25

function void uart_ctrl_env25::set_slave_config25(apb_slave_config25 _slave_cfg25, int index);
  monitor25.cfg.apb_cfg25.slave_configs25[index]  = _slave_cfg25;
  monitor25.set_slave_config25(_slave_cfg25, index);
endfunction : set_slave_config25

function void uart_ctrl_env25::set_uart_config25(uart_config25 _uart_cfg25);
  `uvm_info(get_type_name(), {"Setting Config25\n", _uart_cfg25.sprint()}, UVM_HIGH)
  monitor25.cfg.uart_cfg25  = _uart_cfg25;
  monitor25.set_uart_config25(_uart_cfg25);
endfunction : set_uart_config25
