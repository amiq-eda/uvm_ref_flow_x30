/*-------------------------------------------------------------------------
File20 name   : uart_ctrl_env20.sv
Title20       : 
Project20     :
Created20     :
Description20 : Module20 env20, contains20 the instance of scoreboard20 and coverage20 model
Notes20       : 
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`include "uart_ctrl_defines20.svh"
class uart_ctrl_env20 extends uvm_env; 
  
  // Component configuration classes20
  uart_ctrl_config20 cfg;
  // These20 are pointers20 to config classes20 above20
  uart_config20 uart_cfg20;
  apb_slave_config20 apb_slave_cfg20;

  // Module20 monitor20 (includes20 scoreboards20, coverage20, checking)
  uart_ctrl_monitor20 monitor20;

  // Control20 bit
  bit div_en20;

  // UVM_REG: Pointer20 to the Register Model20
  uart_ctrl_reg_model_c20 reg_model20;
  // Adapter sequence and predictor20
  reg_to_apb_adapter20 reg2apb20;   // Adapter Object REG to APB20
  uvm_reg_predictor#(apb_transfer20) apb_predictor20;  // Precictor20 - APB20 to REG
  uart_ctrl_reg_sequencer20 reg_sequencer20;
  
  // TLM Connections20 
  uvm_analysis_port #(uart_config20) uart_cfg_out20;
  uvm_analysis_imp #(apb_transfer20, uart_ctrl_env20) apb_in20;

  `uvm_component_utils_begin(uart_ctrl_env20)
    `uvm_field_object(reg_model20, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb20, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create20 TLM ports20
    uart_cfg_out20 = new("uart_cfg_out20", this);
    apb_in20 = new("apb_in20", this);
  endfunction

  // Additional20 class methods20
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer20 transfer20);
  extern virtual function void update_config20(uart_ctrl_config20 uart_ctrl_cfg20, int index);
  extern virtual function void set_slave_config20(apb_slave_config20 _slave_cfg20, int index);
  extern virtual function void set_uart_config20(uart_config20 _uart_cfg20);
  extern virtual function void write_effects20(apb_transfer20 transfer20);
  extern virtual function void read_effects20(apb_transfer20 transfer20);

endclass : uart_ctrl_env20

function void uart_ctrl_env20::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get20 or create the UART20 CONTROLLER20 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config20)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG20", "No uart_ctrl_config20 creating20...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config20::get_type(),
                                     default_uart_ctrl_config20::get_type());
    cfg = uart_ctrl_config20::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL20", "Config20 Randomization Failed20")
  end
  if (apb_slave_cfg20 == null) //begin
    if (!uvm_config_db#(apb_slave_config20)::get(this, "", "apb_slave_cfg20", apb_slave_cfg20)) begin
    `uvm_info("NOCONFIG20", "No apb_slave_config20 ..", UVM_LOW)
    apb_slave_cfg20 = cfg.apb_cfg20.slave_configs20[0];
  end
  //uvm_config_db#(uart_ctrl_config20)::set(this, "monitor20", "cfg", cfg);
  uvm_config_object::set(this, "monitor20", "cfg", cfg);
  uart_cfg20 = cfg.uart_cfg20;

  // UVMREG20: Create20 the adapter and predictor20
  reg2apb20 = reg_to_apb_adapter20::type_id::create("reg2apb20");
  apb_predictor20 = uvm_reg_predictor#(apb_transfer20)::type_id::create("apb_predictor20", this);
  reg_sequencer20 = uart_ctrl_reg_sequencer20::type_id::create("reg_sequencer20", this);

  // build system level monitor20
  monitor20 = uart_ctrl_monitor20::type_id::create("monitor20",this);
  ////monitor20.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env20::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG20 - Connect20 adapter to register sequencer and predictor20
  apb_predictor20.map = reg_model20.default_map;
  apb_predictor20.adapter = reg2apb20;
endfunction : connect_phase

// UVM_REG: write method for APB20 transfers20 - handles20 Register Operations20
function void uart_ctrl_env20::write(apb_transfer20 transfer20);
  if (apb_slave_cfg20.check_address_range20(transfer20.addr)) begin
    if (transfer20.direction20 == APB_WRITE20) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE20: addr = 'h%0h, data = 'h%0h",
          transfer20.addr, transfer20.data), UVM_MEDIUM)
      write_effects20(transfer20);
    end
    else if (transfer20.direction20 == APB_READ20) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ20: addr = 'h%0h, data = 'h%0h",
          transfer20.addr, transfer20.data), UVM_MEDIUM)
        read_effects20(transfer20);
    end else
      `uvm_error("REGMEM20", "Unsupported20 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG20 based on APB20 writes to config registers
function void uart_ctrl_env20::write_effects20(apb_transfer20 transfer20);
  case (transfer20.addr)
    apb_slave_cfg20.start_address20 + `LINE_CTRL20 : begin
                                            uart_cfg20.char_length20 = transfer20.data[1:0];
                                            uart_cfg20.parity_mode20 = transfer20.data[5:4];
                                            uart_cfg20.parity_en20   = transfer20.data[3];
                                            uart_cfg20.nbstop20      = transfer20.data[2];
                                            div_en20 = transfer20.data[7];
                                            uart_cfg20.ConvToIntChrl20();
                                            uart_cfg20.ConvToIntStpBt20();
                                            uart_cfg_out20.write(uart_cfg20);
                                          end
    apb_slave_cfg20.start_address20 + `DIVD_LATCH120 : begin
                                            if (div_en20) begin
                                            uart_cfg20.baud_rate_gen20 = transfer20.data[7:0];
                                            uart_cfg_out20.write(uart_cfg20);
                                            end
                                          end
    apb_slave_cfg20.start_address20 + `DIVD_LATCH220 : begin
                                            if (div_en20) begin
                                            uart_cfg20.baud_rate_div20 = transfer20.data[7:0];
                                            uart_cfg_out20.write(uart_cfg20);
                                            end
                                          end
    default: `uvm_warning("REGMEM220", "Write access not to Control20/Sataus20 Registers20")
  endcase
  set_uart_config20(uart_cfg20);
endfunction : write_effects20

function void uart_ctrl_env20::read_effects20(apb_transfer20 transfer20);
  // Nothing for now
endfunction : read_effects20

function void uart_ctrl_env20::update_config20(uart_ctrl_config20 uart_ctrl_cfg20, int index);
  `uvm_info(get_type_name(), {"Updating Config20\n", uart_ctrl_cfg20.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg20;
  // Update these20 configs20 also (not really20 necessary20 since20 all are pointers20)
  uart_cfg20 = uart_ctrl_cfg20.uart_cfg20;
  apb_slave_cfg20 = cfg.apb_cfg20.slave_configs20[index];
  monitor20.cfg = uart_ctrl_cfg20;
endfunction : update_config20

function void uart_ctrl_env20::set_slave_config20(apb_slave_config20 _slave_cfg20, int index);
  monitor20.cfg.apb_cfg20.slave_configs20[index]  = _slave_cfg20;
  monitor20.set_slave_config20(_slave_cfg20, index);
endfunction : set_slave_config20

function void uart_ctrl_env20::set_uart_config20(uart_config20 _uart_cfg20);
  `uvm_info(get_type_name(), {"Setting Config20\n", _uart_cfg20.sprint()}, UVM_HIGH)
  monitor20.cfg.uart_cfg20  = _uart_cfg20;
  monitor20.set_uart_config20(_uart_cfg20);
endfunction : set_uart_config20
