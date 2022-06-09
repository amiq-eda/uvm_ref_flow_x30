/*-------------------------------------------------------------------------
File12 name   : uart_ctrl_env12.sv
Title12       : 
Project12     :
Created12     :
Description12 : Module12 env12, contains12 the instance of scoreboard12 and coverage12 model
Notes12       : 
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`include "uart_ctrl_defines12.svh"
class uart_ctrl_env12 extends uvm_env; 
  
  // Component configuration classes12
  uart_ctrl_config12 cfg;
  // These12 are pointers12 to config classes12 above12
  uart_config12 uart_cfg12;
  apb_slave_config12 apb_slave_cfg12;

  // Module12 monitor12 (includes12 scoreboards12, coverage12, checking)
  uart_ctrl_monitor12 monitor12;

  // Control12 bit
  bit div_en12;

  // UVM_REG: Pointer12 to the Register Model12
  uart_ctrl_reg_model_c12 reg_model12;
  // Adapter sequence and predictor12
  reg_to_apb_adapter12 reg2apb12;   // Adapter Object REG to APB12
  uvm_reg_predictor#(apb_transfer12) apb_predictor12;  // Precictor12 - APB12 to REG
  uart_ctrl_reg_sequencer12 reg_sequencer12;
  
  // TLM Connections12 
  uvm_analysis_port #(uart_config12) uart_cfg_out12;
  uvm_analysis_imp #(apb_transfer12, uart_ctrl_env12) apb_in12;

  `uvm_component_utils_begin(uart_ctrl_env12)
    `uvm_field_object(reg_model12, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb12, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create12 TLM ports12
    uart_cfg_out12 = new("uart_cfg_out12", this);
    apb_in12 = new("apb_in12", this);
  endfunction

  // Additional12 class methods12
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer12 transfer12);
  extern virtual function void update_config12(uart_ctrl_config12 uart_ctrl_cfg12, int index);
  extern virtual function void set_slave_config12(apb_slave_config12 _slave_cfg12, int index);
  extern virtual function void set_uart_config12(uart_config12 _uart_cfg12);
  extern virtual function void write_effects12(apb_transfer12 transfer12);
  extern virtual function void read_effects12(apb_transfer12 transfer12);

endclass : uart_ctrl_env12

function void uart_ctrl_env12::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get12 or create the UART12 CONTROLLER12 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config12)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG12", "No uart_ctrl_config12 creating12...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config12::get_type(),
                                     default_uart_ctrl_config12::get_type());
    cfg = uart_ctrl_config12::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL12", "Config12 Randomization Failed12")
  end
  if (apb_slave_cfg12 == null) //begin
    if (!uvm_config_db#(apb_slave_config12)::get(this, "", "apb_slave_cfg12", apb_slave_cfg12)) begin
    `uvm_info("NOCONFIG12", "No apb_slave_config12 ..", UVM_LOW)
    apb_slave_cfg12 = cfg.apb_cfg12.slave_configs12[0];
  end
  //uvm_config_db#(uart_ctrl_config12)::set(this, "monitor12", "cfg", cfg);
  uvm_config_object::set(this, "monitor12", "cfg", cfg);
  uart_cfg12 = cfg.uart_cfg12;

  // UVMREG12: Create12 the adapter and predictor12
  reg2apb12 = reg_to_apb_adapter12::type_id::create("reg2apb12");
  apb_predictor12 = uvm_reg_predictor#(apb_transfer12)::type_id::create("apb_predictor12", this);
  reg_sequencer12 = uart_ctrl_reg_sequencer12::type_id::create("reg_sequencer12", this);

  // build system level monitor12
  monitor12 = uart_ctrl_monitor12::type_id::create("monitor12",this);
  ////monitor12.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env12::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG12 - Connect12 adapter to register sequencer and predictor12
  apb_predictor12.map = reg_model12.default_map;
  apb_predictor12.adapter = reg2apb12;
endfunction : connect_phase

// UVM_REG: write method for APB12 transfers12 - handles12 Register Operations12
function void uart_ctrl_env12::write(apb_transfer12 transfer12);
  if (apb_slave_cfg12.check_address_range12(transfer12.addr)) begin
    if (transfer12.direction12 == APB_WRITE12) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE12: addr = 'h%0h, data = 'h%0h",
          transfer12.addr, transfer12.data), UVM_MEDIUM)
      write_effects12(transfer12);
    end
    else if (transfer12.direction12 == APB_READ12) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ12: addr = 'h%0h, data = 'h%0h",
          transfer12.addr, transfer12.data), UVM_MEDIUM)
        read_effects12(transfer12);
    end else
      `uvm_error("REGMEM12", "Unsupported12 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG12 based on APB12 writes to config registers
function void uart_ctrl_env12::write_effects12(apb_transfer12 transfer12);
  case (transfer12.addr)
    apb_slave_cfg12.start_address12 + `LINE_CTRL12 : begin
                                            uart_cfg12.char_length12 = transfer12.data[1:0];
                                            uart_cfg12.parity_mode12 = transfer12.data[5:4];
                                            uart_cfg12.parity_en12   = transfer12.data[3];
                                            uart_cfg12.nbstop12      = transfer12.data[2];
                                            div_en12 = transfer12.data[7];
                                            uart_cfg12.ConvToIntChrl12();
                                            uart_cfg12.ConvToIntStpBt12();
                                            uart_cfg_out12.write(uart_cfg12);
                                          end
    apb_slave_cfg12.start_address12 + `DIVD_LATCH112 : begin
                                            if (div_en12) begin
                                            uart_cfg12.baud_rate_gen12 = transfer12.data[7:0];
                                            uart_cfg_out12.write(uart_cfg12);
                                            end
                                          end
    apb_slave_cfg12.start_address12 + `DIVD_LATCH212 : begin
                                            if (div_en12) begin
                                            uart_cfg12.baud_rate_div12 = transfer12.data[7:0];
                                            uart_cfg_out12.write(uart_cfg12);
                                            end
                                          end
    default: `uvm_warning("REGMEM212", "Write access not to Control12/Sataus12 Registers12")
  endcase
  set_uart_config12(uart_cfg12);
endfunction : write_effects12

function void uart_ctrl_env12::read_effects12(apb_transfer12 transfer12);
  // Nothing for now
endfunction : read_effects12

function void uart_ctrl_env12::update_config12(uart_ctrl_config12 uart_ctrl_cfg12, int index);
  `uvm_info(get_type_name(), {"Updating Config12\n", uart_ctrl_cfg12.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg12;
  // Update these12 configs12 also (not really12 necessary12 since12 all are pointers12)
  uart_cfg12 = uart_ctrl_cfg12.uart_cfg12;
  apb_slave_cfg12 = cfg.apb_cfg12.slave_configs12[index];
  monitor12.cfg = uart_ctrl_cfg12;
endfunction : update_config12

function void uart_ctrl_env12::set_slave_config12(apb_slave_config12 _slave_cfg12, int index);
  monitor12.cfg.apb_cfg12.slave_configs12[index]  = _slave_cfg12;
  monitor12.set_slave_config12(_slave_cfg12, index);
endfunction : set_slave_config12

function void uart_ctrl_env12::set_uart_config12(uart_config12 _uart_cfg12);
  `uvm_info(get_type_name(), {"Setting Config12\n", _uart_cfg12.sprint()}, UVM_HIGH)
  monitor12.cfg.uart_cfg12  = _uart_cfg12;
  monitor12.set_uart_config12(_uart_cfg12);
endfunction : set_uart_config12
