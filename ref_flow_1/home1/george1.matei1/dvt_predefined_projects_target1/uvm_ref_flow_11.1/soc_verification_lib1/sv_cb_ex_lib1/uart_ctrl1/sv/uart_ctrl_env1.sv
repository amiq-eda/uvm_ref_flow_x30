/*-------------------------------------------------------------------------
File1 name   : uart_ctrl_env1.sv
Title1       : 
Project1     :
Created1     :
Description1 : Module1 env1, contains1 the instance of scoreboard1 and coverage1 model
Notes1       : 
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`include "uart_ctrl_defines1.svh"
class uart_ctrl_env1 extends uvm_env; 
  
  // Component configuration classes1
  uart_ctrl_config1 cfg;
  // These1 are pointers1 to config classes1 above1
  uart_config1 uart_cfg1;
  apb_slave_config1 apb_slave_cfg1;

  // Module1 monitor1 (includes1 scoreboards1, coverage1, checking)
  uart_ctrl_monitor1 monitor1;

  // Control1 bit
  bit div_en1;

  // UVM_REG: Pointer1 to the Register Model1
  uart_ctrl_reg_model_c1 reg_model1;
  // Adapter sequence and predictor1
  reg_to_apb_adapter1 reg2apb1;   // Adapter Object REG to APB1
  uvm_reg_predictor#(apb_transfer1) apb_predictor1;  // Precictor1 - APB1 to REG
  uart_ctrl_reg_sequencer1 reg_sequencer1;
  
  // TLM Connections1 
  uvm_analysis_port #(uart_config1) uart_cfg_out1;
  uvm_analysis_imp #(apb_transfer1, uart_ctrl_env1) apb_in1;

  `uvm_component_utils_begin(uart_ctrl_env1)
    `uvm_field_object(reg_model1, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb1, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create1 TLM ports1
    uart_cfg_out1 = new("uart_cfg_out1", this);
    apb_in1 = new("apb_in1", this);
  endfunction

  // Additional1 class methods1
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer1 transfer1);
  extern virtual function void update_config1(uart_ctrl_config1 uart_ctrl_cfg1, int index);
  extern virtual function void set_slave_config1(apb_slave_config1 _slave_cfg1, int index);
  extern virtual function void set_uart_config1(uart_config1 _uart_cfg1);
  extern virtual function void write_effects1(apb_transfer1 transfer1);
  extern virtual function void read_effects1(apb_transfer1 transfer1);

endclass : uart_ctrl_env1

function void uart_ctrl_env1::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get1 or create the UART1 CONTROLLER1 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config1)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG1", "No uart_ctrl_config1 creating1...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config1::get_type(),
                                     default_uart_ctrl_config1::get_type());
    cfg = uart_ctrl_config1::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL1", "Config1 Randomization Failed1")
  end
  if (apb_slave_cfg1 == null) //begin
    if (!uvm_config_db#(apb_slave_config1)::get(this, "", "apb_slave_cfg1", apb_slave_cfg1)) begin
    `uvm_info("NOCONFIG1", "No apb_slave_config1 ..", UVM_LOW)
    apb_slave_cfg1 = cfg.apb_cfg1.slave_configs1[0];
  end
  //uvm_config_db#(uart_ctrl_config1)::set(this, "monitor1", "cfg", cfg);
  uvm_config_object::set(this, "monitor1", "cfg", cfg);
  uart_cfg1 = cfg.uart_cfg1;

  // UVMREG1: Create1 the adapter and predictor1
  reg2apb1 = reg_to_apb_adapter1::type_id::create("reg2apb1");
  apb_predictor1 = uvm_reg_predictor#(apb_transfer1)::type_id::create("apb_predictor1", this);
  reg_sequencer1 = uart_ctrl_reg_sequencer1::type_id::create("reg_sequencer1", this);

  // build system level monitor1
  monitor1 = uart_ctrl_monitor1::type_id::create("monitor1",this);
  ////monitor1.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env1::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG1 - Connect1 adapter to register sequencer and predictor1
  apb_predictor1.map = reg_model1.default_map;
  apb_predictor1.adapter = reg2apb1;
endfunction : connect_phase

// UVM_REG: write method for APB1 transfers1 - handles1 Register Operations1
function void uart_ctrl_env1::write(apb_transfer1 transfer1);
  if (apb_slave_cfg1.check_address_range1(transfer1.addr)) begin
    if (transfer1.direction1 == APB_WRITE1) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE1: addr = 'h%0h, data = 'h%0h",
          transfer1.addr, transfer1.data), UVM_MEDIUM)
      write_effects1(transfer1);
    end
    else if (transfer1.direction1 == APB_READ1) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ1: addr = 'h%0h, data = 'h%0h",
          transfer1.addr, transfer1.data), UVM_MEDIUM)
        read_effects1(transfer1);
    end else
      `uvm_error("REGMEM1", "Unsupported1 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG1 based on APB1 writes to config registers
function void uart_ctrl_env1::write_effects1(apb_transfer1 transfer1);
  case (transfer1.addr)
    apb_slave_cfg1.start_address1 + `LINE_CTRL1 : begin
                                            uart_cfg1.char_length1 = transfer1.data[1:0];
                                            uart_cfg1.parity_mode1 = transfer1.data[5:4];
                                            uart_cfg1.parity_en1   = transfer1.data[3];
                                            uart_cfg1.nbstop1      = transfer1.data[2];
                                            div_en1 = transfer1.data[7];
                                            uart_cfg1.ConvToIntChrl1();
                                            uart_cfg1.ConvToIntStpBt1();
                                            uart_cfg_out1.write(uart_cfg1);
                                          end
    apb_slave_cfg1.start_address1 + `DIVD_LATCH11 : begin
                                            if (div_en1) begin
                                            uart_cfg1.baud_rate_gen1 = transfer1.data[7:0];
                                            uart_cfg_out1.write(uart_cfg1);
                                            end
                                          end
    apb_slave_cfg1.start_address1 + `DIVD_LATCH21 : begin
                                            if (div_en1) begin
                                            uart_cfg1.baud_rate_div1 = transfer1.data[7:0];
                                            uart_cfg_out1.write(uart_cfg1);
                                            end
                                          end
    default: `uvm_warning("REGMEM21", "Write access not to Control1/Sataus1 Registers1")
  endcase
  set_uart_config1(uart_cfg1);
endfunction : write_effects1

function void uart_ctrl_env1::read_effects1(apb_transfer1 transfer1);
  // Nothing for now
endfunction : read_effects1

function void uart_ctrl_env1::update_config1(uart_ctrl_config1 uart_ctrl_cfg1, int index);
  `uvm_info(get_type_name(), {"Updating Config1\n", uart_ctrl_cfg1.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg1;
  // Update these1 configs1 also (not really1 necessary1 since1 all are pointers1)
  uart_cfg1 = uart_ctrl_cfg1.uart_cfg1;
  apb_slave_cfg1 = cfg.apb_cfg1.slave_configs1[index];
  monitor1.cfg = uart_ctrl_cfg1;
endfunction : update_config1

function void uart_ctrl_env1::set_slave_config1(apb_slave_config1 _slave_cfg1, int index);
  monitor1.cfg.apb_cfg1.slave_configs1[index]  = _slave_cfg1;
  monitor1.set_slave_config1(_slave_cfg1, index);
endfunction : set_slave_config1

function void uart_ctrl_env1::set_uart_config1(uart_config1 _uart_cfg1);
  `uvm_info(get_type_name(), {"Setting Config1\n", _uart_cfg1.sprint()}, UVM_HIGH)
  monitor1.cfg.uart_cfg1  = _uart_cfg1;
  monitor1.set_uart_config1(_uart_cfg1);
endfunction : set_uart_config1
