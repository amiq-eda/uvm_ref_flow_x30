/*-------------------------------------------------------------------------
File28 name   : uart_ctrl_env28.sv
Title28       : 
Project28     :
Created28     :
Description28 : Module28 env28, contains28 the instance of scoreboard28 and coverage28 model
Notes28       : 
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`include "uart_ctrl_defines28.svh"
class uart_ctrl_env28 extends uvm_env; 
  
  // Component configuration classes28
  uart_ctrl_config28 cfg;
  // These28 are pointers28 to config classes28 above28
  uart_config28 uart_cfg28;
  apb_slave_config28 apb_slave_cfg28;

  // Module28 monitor28 (includes28 scoreboards28, coverage28, checking)
  uart_ctrl_monitor28 monitor28;

  // Control28 bit
  bit div_en28;

  // UVM_REG: Pointer28 to the Register Model28
  uart_ctrl_reg_model_c28 reg_model28;
  // Adapter sequence and predictor28
  reg_to_apb_adapter28 reg2apb28;   // Adapter Object REG to APB28
  uvm_reg_predictor#(apb_transfer28) apb_predictor28;  // Precictor28 - APB28 to REG
  uart_ctrl_reg_sequencer28 reg_sequencer28;
  
  // TLM Connections28 
  uvm_analysis_port #(uart_config28) uart_cfg_out28;
  uvm_analysis_imp #(apb_transfer28, uart_ctrl_env28) apb_in28;

  `uvm_component_utils_begin(uart_ctrl_env28)
    `uvm_field_object(reg_model28, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb28, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create28 TLM ports28
    uart_cfg_out28 = new("uart_cfg_out28", this);
    apb_in28 = new("apb_in28", this);
  endfunction

  // Additional28 class methods28
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer28 transfer28);
  extern virtual function void update_config28(uart_ctrl_config28 uart_ctrl_cfg28, int index);
  extern virtual function void set_slave_config28(apb_slave_config28 _slave_cfg28, int index);
  extern virtual function void set_uart_config28(uart_config28 _uart_cfg28);
  extern virtual function void write_effects28(apb_transfer28 transfer28);
  extern virtual function void read_effects28(apb_transfer28 transfer28);

endclass : uart_ctrl_env28

function void uart_ctrl_env28::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get28 or create the UART28 CONTROLLER28 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config28)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG28", "No uart_ctrl_config28 creating28...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config28::get_type(),
                                     default_uart_ctrl_config28::get_type());
    cfg = uart_ctrl_config28::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL28", "Config28 Randomization Failed28")
  end
  if (apb_slave_cfg28 == null) //begin
    if (!uvm_config_db#(apb_slave_config28)::get(this, "", "apb_slave_cfg28", apb_slave_cfg28)) begin
    `uvm_info("NOCONFIG28", "No apb_slave_config28 ..", UVM_LOW)
    apb_slave_cfg28 = cfg.apb_cfg28.slave_configs28[0];
  end
  //uvm_config_db#(uart_ctrl_config28)::set(this, "monitor28", "cfg", cfg);
  uvm_config_object::set(this, "monitor28", "cfg", cfg);
  uart_cfg28 = cfg.uart_cfg28;

  // UVMREG28: Create28 the adapter and predictor28
  reg2apb28 = reg_to_apb_adapter28::type_id::create("reg2apb28");
  apb_predictor28 = uvm_reg_predictor#(apb_transfer28)::type_id::create("apb_predictor28", this);
  reg_sequencer28 = uart_ctrl_reg_sequencer28::type_id::create("reg_sequencer28", this);

  // build system level monitor28
  monitor28 = uart_ctrl_monitor28::type_id::create("monitor28",this);
  ////monitor28.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env28::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG28 - Connect28 adapter to register sequencer and predictor28
  apb_predictor28.map = reg_model28.default_map;
  apb_predictor28.adapter = reg2apb28;
endfunction : connect_phase

// UVM_REG: write method for APB28 transfers28 - handles28 Register Operations28
function void uart_ctrl_env28::write(apb_transfer28 transfer28);
  if (apb_slave_cfg28.check_address_range28(transfer28.addr)) begin
    if (transfer28.direction28 == APB_WRITE28) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE28: addr = 'h%0h, data = 'h%0h",
          transfer28.addr, transfer28.data), UVM_MEDIUM)
      write_effects28(transfer28);
    end
    else if (transfer28.direction28 == APB_READ28) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ28: addr = 'h%0h, data = 'h%0h",
          transfer28.addr, transfer28.data), UVM_MEDIUM)
        read_effects28(transfer28);
    end else
      `uvm_error("REGMEM28", "Unsupported28 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG28 based on APB28 writes to config registers
function void uart_ctrl_env28::write_effects28(apb_transfer28 transfer28);
  case (transfer28.addr)
    apb_slave_cfg28.start_address28 + `LINE_CTRL28 : begin
                                            uart_cfg28.char_length28 = transfer28.data[1:0];
                                            uart_cfg28.parity_mode28 = transfer28.data[5:4];
                                            uart_cfg28.parity_en28   = transfer28.data[3];
                                            uart_cfg28.nbstop28      = transfer28.data[2];
                                            div_en28 = transfer28.data[7];
                                            uart_cfg28.ConvToIntChrl28();
                                            uart_cfg28.ConvToIntStpBt28();
                                            uart_cfg_out28.write(uart_cfg28);
                                          end
    apb_slave_cfg28.start_address28 + `DIVD_LATCH128 : begin
                                            if (div_en28) begin
                                            uart_cfg28.baud_rate_gen28 = transfer28.data[7:0];
                                            uart_cfg_out28.write(uart_cfg28);
                                            end
                                          end
    apb_slave_cfg28.start_address28 + `DIVD_LATCH228 : begin
                                            if (div_en28) begin
                                            uart_cfg28.baud_rate_div28 = transfer28.data[7:0];
                                            uart_cfg_out28.write(uart_cfg28);
                                            end
                                          end
    default: `uvm_warning("REGMEM228", "Write access not to Control28/Sataus28 Registers28")
  endcase
  set_uart_config28(uart_cfg28);
endfunction : write_effects28

function void uart_ctrl_env28::read_effects28(apb_transfer28 transfer28);
  // Nothing for now
endfunction : read_effects28

function void uart_ctrl_env28::update_config28(uart_ctrl_config28 uart_ctrl_cfg28, int index);
  `uvm_info(get_type_name(), {"Updating Config28\n", uart_ctrl_cfg28.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg28;
  // Update these28 configs28 also (not really28 necessary28 since28 all are pointers28)
  uart_cfg28 = uart_ctrl_cfg28.uart_cfg28;
  apb_slave_cfg28 = cfg.apb_cfg28.slave_configs28[index];
  monitor28.cfg = uart_ctrl_cfg28;
endfunction : update_config28

function void uart_ctrl_env28::set_slave_config28(apb_slave_config28 _slave_cfg28, int index);
  monitor28.cfg.apb_cfg28.slave_configs28[index]  = _slave_cfg28;
  monitor28.set_slave_config28(_slave_cfg28, index);
endfunction : set_slave_config28

function void uart_ctrl_env28::set_uart_config28(uart_config28 _uart_cfg28);
  `uvm_info(get_type_name(), {"Setting Config28\n", _uart_cfg28.sprint()}, UVM_HIGH)
  monitor28.cfg.uart_cfg28  = _uart_cfg28;
  monitor28.set_uart_config28(_uart_cfg28);
endfunction : set_uart_config28
