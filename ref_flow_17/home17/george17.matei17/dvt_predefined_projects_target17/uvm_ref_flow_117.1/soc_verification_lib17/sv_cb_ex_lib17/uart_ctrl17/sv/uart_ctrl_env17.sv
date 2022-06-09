/*-------------------------------------------------------------------------
File17 name   : uart_ctrl_env17.sv
Title17       : 
Project17     :
Created17     :
Description17 : Module17 env17, contains17 the instance of scoreboard17 and coverage17 model
Notes17       : 
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`include "uart_ctrl_defines17.svh"
class uart_ctrl_env17 extends uvm_env; 
  
  // Component configuration classes17
  uart_ctrl_config17 cfg;
  // These17 are pointers17 to config classes17 above17
  uart_config17 uart_cfg17;
  apb_slave_config17 apb_slave_cfg17;

  // Module17 monitor17 (includes17 scoreboards17, coverage17, checking)
  uart_ctrl_monitor17 monitor17;

  // Control17 bit
  bit div_en17;

  // UVM_REG: Pointer17 to the Register Model17
  uart_ctrl_reg_model_c17 reg_model17;
  // Adapter sequence and predictor17
  reg_to_apb_adapter17 reg2apb17;   // Adapter Object REG to APB17
  uvm_reg_predictor#(apb_transfer17) apb_predictor17;  // Precictor17 - APB17 to REG
  uart_ctrl_reg_sequencer17 reg_sequencer17;
  
  // TLM Connections17 
  uvm_analysis_port #(uart_config17) uart_cfg_out17;
  uvm_analysis_imp #(apb_transfer17, uart_ctrl_env17) apb_in17;

  `uvm_component_utils_begin(uart_ctrl_env17)
    `uvm_field_object(reg_model17, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb17, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create17 TLM ports17
    uart_cfg_out17 = new("uart_cfg_out17", this);
    apb_in17 = new("apb_in17", this);
  endfunction

  // Additional17 class methods17
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer17 transfer17);
  extern virtual function void update_config17(uart_ctrl_config17 uart_ctrl_cfg17, int index);
  extern virtual function void set_slave_config17(apb_slave_config17 _slave_cfg17, int index);
  extern virtual function void set_uart_config17(uart_config17 _uart_cfg17);
  extern virtual function void write_effects17(apb_transfer17 transfer17);
  extern virtual function void read_effects17(apb_transfer17 transfer17);

endclass : uart_ctrl_env17

function void uart_ctrl_env17::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get17 or create the UART17 CONTROLLER17 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config17)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG17", "No uart_ctrl_config17 creating17...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config17::get_type(),
                                     default_uart_ctrl_config17::get_type());
    cfg = uart_ctrl_config17::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL17", "Config17 Randomization Failed17")
  end
  if (apb_slave_cfg17 == null) //begin
    if (!uvm_config_db#(apb_slave_config17)::get(this, "", "apb_slave_cfg17", apb_slave_cfg17)) begin
    `uvm_info("NOCONFIG17", "No apb_slave_config17 ..", UVM_LOW)
    apb_slave_cfg17 = cfg.apb_cfg17.slave_configs17[0];
  end
  //uvm_config_db#(uart_ctrl_config17)::set(this, "monitor17", "cfg", cfg);
  uvm_config_object::set(this, "monitor17", "cfg", cfg);
  uart_cfg17 = cfg.uart_cfg17;

  // UVMREG17: Create17 the adapter and predictor17
  reg2apb17 = reg_to_apb_adapter17::type_id::create("reg2apb17");
  apb_predictor17 = uvm_reg_predictor#(apb_transfer17)::type_id::create("apb_predictor17", this);
  reg_sequencer17 = uart_ctrl_reg_sequencer17::type_id::create("reg_sequencer17", this);

  // build system level monitor17
  monitor17 = uart_ctrl_monitor17::type_id::create("monitor17",this);
  ////monitor17.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env17::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG17 - Connect17 adapter to register sequencer and predictor17
  apb_predictor17.map = reg_model17.default_map;
  apb_predictor17.adapter = reg2apb17;
endfunction : connect_phase

// UVM_REG: write method for APB17 transfers17 - handles17 Register Operations17
function void uart_ctrl_env17::write(apb_transfer17 transfer17);
  if (apb_slave_cfg17.check_address_range17(transfer17.addr)) begin
    if (transfer17.direction17 == APB_WRITE17) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE17: addr = 'h%0h, data = 'h%0h",
          transfer17.addr, transfer17.data), UVM_MEDIUM)
      write_effects17(transfer17);
    end
    else if (transfer17.direction17 == APB_READ17) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ17: addr = 'h%0h, data = 'h%0h",
          transfer17.addr, transfer17.data), UVM_MEDIUM)
        read_effects17(transfer17);
    end else
      `uvm_error("REGMEM17", "Unsupported17 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG17 based on APB17 writes to config registers
function void uart_ctrl_env17::write_effects17(apb_transfer17 transfer17);
  case (transfer17.addr)
    apb_slave_cfg17.start_address17 + `LINE_CTRL17 : begin
                                            uart_cfg17.char_length17 = transfer17.data[1:0];
                                            uart_cfg17.parity_mode17 = transfer17.data[5:4];
                                            uart_cfg17.parity_en17   = transfer17.data[3];
                                            uart_cfg17.nbstop17      = transfer17.data[2];
                                            div_en17 = transfer17.data[7];
                                            uart_cfg17.ConvToIntChrl17();
                                            uart_cfg17.ConvToIntStpBt17();
                                            uart_cfg_out17.write(uart_cfg17);
                                          end
    apb_slave_cfg17.start_address17 + `DIVD_LATCH117 : begin
                                            if (div_en17) begin
                                            uart_cfg17.baud_rate_gen17 = transfer17.data[7:0];
                                            uart_cfg_out17.write(uart_cfg17);
                                            end
                                          end
    apb_slave_cfg17.start_address17 + `DIVD_LATCH217 : begin
                                            if (div_en17) begin
                                            uart_cfg17.baud_rate_div17 = transfer17.data[7:0];
                                            uart_cfg_out17.write(uart_cfg17);
                                            end
                                          end
    default: `uvm_warning("REGMEM217", "Write access not to Control17/Sataus17 Registers17")
  endcase
  set_uart_config17(uart_cfg17);
endfunction : write_effects17

function void uart_ctrl_env17::read_effects17(apb_transfer17 transfer17);
  // Nothing for now
endfunction : read_effects17

function void uart_ctrl_env17::update_config17(uart_ctrl_config17 uart_ctrl_cfg17, int index);
  `uvm_info(get_type_name(), {"Updating Config17\n", uart_ctrl_cfg17.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg17;
  // Update these17 configs17 also (not really17 necessary17 since17 all are pointers17)
  uart_cfg17 = uart_ctrl_cfg17.uart_cfg17;
  apb_slave_cfg17 = cfg.apb_cfg17.slave_configs17[index];
  monitor17.cfg = uart_ctrl_cfg17;
endfunction : update_config17

function void uart_ctrl_env17::set_slave_config17(apb_slave_config17 _slave_cfg17, int index);
  monitor17.cfg.apb_cfg17.slave_configs17[index]  = _slave_cfg17;
  monitor17.set_slave_config17(_slave_cfg17, index);
endfunction : set_slave_config17

function void uart_ctrl_env17::set_uart_config17(uart_config17 _uart_cfg17);
  `uvm_info(get_type_name(), {"Setting Config17\n", _uart_cfg17.sprint()}, UVM_HIGH)
  monitor17.cfg.uart_cfg17  = _uart_cfg17;
  monitor17.set_uart_config17(_uart_cfg17);
endfunction : set_uart_config17
