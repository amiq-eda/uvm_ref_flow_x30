/*-------------------------------------------------------------------------
File18 name   : uart_ctrl_env18.sv
Title18       : 
Project18     :
Created18     :
Description18 : Module18 env18, contains18 the instance of scoreboard18 and coverage18 model
Notes18       : 
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`include "uart_ctrl_defines18.svh"
class uart_ctrl_env18 extends uvm_env; 
  
  // Component configuration classes18
  uart_ctrl_config18 cfg;
  // These18 are pointers18 to config classes18 above18
  uart_config18 uart_cfg18;
  apb_slave_config18 apb_slave_cfg18;

  // Module18 monitor18 (includes18 scoreboards18, coverage18, checking)
  uart_ctrl_monitor18 monitor18;

  // Control18 bit
  bit div_en18;

  // UVM_REG: Pointer18 to the Register Model18
  uart_ctrl_reg_model_c18 reg_model18;
  // Adapter sequence and predictor18
  reg_to_apb_adapter18 reg2apb18;   // Adapter Object REG to APB18
  uvm_reg_predictor#(apb_transfer18) apb_predictor18;  // Precictor18 - APB18 to REG
  uart_ctrl_reg_sequencer18 reg_sequencer18;
  
  // TLM Connections18 
  uvm_analysis_port #(uart_config18) uart_cfg_out18;
  uvm_analysis_imp #(apb_transfer18, uart_ctrl_env18) apb_in18;

  `uvm_component_utils_begin(uart_ctrl_env18)
    `uvm_field_object(reg_model18, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb18, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create18 TLM ports18
    uart_cfg_out18 = new("uart_cfg_out18", this);
    apb_in18 = new("apb_in18", this);
  endfunction

  // Additional18 class methods18
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer18 transfer18);
  extern virtual function void update_config18(uart_ctrl_config18 uart_ctrl_cfg18, int index);
  extern virtual function void set_slave_config18(apb_slave_config18 _slave_cfg18, int index);
  extern virtual function void set_uart_config18(uart_config18 _uart_cfg18);
  extern virtual function void write_effects18(apb_transfer18 transfer18);
  extern virtual function void read_effects18(apb_transfer18 transfer18);

endclass : uart_ctrl_env18

function void uart_ctrl_env18::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get18 or create the UART18 CONTROLLER18 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config18)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG18", "No uart_ctrl_config18 creating18...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config18::get_type(),
                                     default_uart_ctrl_config18::get_type());
    cfg = uart_ctrl_config18::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL18", "Config18 Randomization Failed18")
  end
  if (apb_slave_cfg18 == null) //begin
    if (!uvm_config_db#(apb_slave_config18)::get(this, "", "apb_slave_cfg18", apb_slave_cfg18)) begin
    `uvm_info("NOCONFIG18", "No apb_slave_config18 ..", UVM_LOW)
    apb_slave_cfg18 = cfg.apb_cfg18.slave_configs18[0];
  end
  //uvm_config_db#(uart_ctrl_config18)::set(this, "monitor18", "cfg", cfg);
  uvm_config_object::set(this, "monitor18", "cfg", cfg);
  uart_cfg18 = cfg.uart_cfg18;

  // UVMREG18: Create18 the adapter and predictor18
  reg2apb18 = reg_to_apb_adapter18::type_id::create("reg2apb18");
  apb_predictor18 = uvm_reg_predictor#(apb_transfer18)::type_id::create("apb_predictor18", this);
  reg_sequencer18 = uart_ctrl_reg_sequencer18::type_id::create("reg_sequencer18", this);

  // build system level monitor18
  monitor18 = uart_ctrl_monitor18::type_id::create("monitor18",this);
  ////monitor18.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env18::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG18 - Connect18 adapter to register sequencer and predictor18
  apb_predictor18.map = reg_model18.default_map;
  apb_predictor18.adapter = reg2apb18;
endfunction : connect_phase

// UVM_REG: write method for APB18 transfers18 - handles18 Register Operations18
function void uart_ctrl_env18::write(apb_transfer18 transfer18);
  if (apb_slave_cfg18.check_address_range18(transfer18.addr)) begin
    if (transfer18.direction18 == APB_WRITE18) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE18: addr = 'h%0h, data = 'h%0h",
          transfer18.addr, transfer18.data), UVM_MEDIUM)
      write_effects18(transfer18);
    end
    else if (transfer18.direction18 == APB_READ18) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ18: addr = 'h%0h, data = 'h%0h",
          transfer18.addr, transfer18.data), UVM_MEDIUM)
        read_effects18(transfer18);
    end else
      `uvm_error("REGMEM18", "Unsupported18 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG18 based on APB18 writes to config registers
function void uart_ctrl_env18::write_effects18(apb_transfer18 transfer18);
  case (transfer18.addr)
    apb_slave_cfg18.start_address18 + `LINE_CTRL18 : begin
                                            uart_cfg18.char_length18 = transfer18.data[1:0];
                                            uart_cfg18.parity_mode18 = transfer18.data[5:4];
                                            uart_cfg18.parity_en18   = transfer18.data[3];
                                            uart_cfg18.nbstop18      = transfer18.data[2];
                                            div_en18 = transfer18.data[7];
                                            uart_cfg18.ConvToIntChrl18();
                                            uart_cfg18.ConvToIntStpBt18();
                                            uart_cfg_out18.write(uart_cfg18);
                                          end
    apb_slave_cfg18.start_address18 + `DIVD_LATCH118 : begin
                                            if (div_en18) begin
                                            uart_cfg18.baud_rate_gen18 = transfer18.data[7:0];
                                            uart_cfg_out18.write(uart_cfg18);
                                            end
                                          end
    apb_slave_cfg18.start_address18 + `DIVD_LATCH218 : begin
                                            if (div_en18) begin
                                            uart_cfg18.baud_rate_div18 = transfer18.data[7:0];
                                            uart_cfg_out18.write(uart_cfg18);
                                            end
                                          end
    default: `uvm_warning("REGMEM218", "Write access not to Control18/Sataus18 Registers18")
  endcase
  set_uart_config18(uart_cfg18);
endfunction : write_effects18

function void uart_ctrl_env18::read_effects18(apb_transfer18 transfer18);
  // Nothing for now
endfunction : read_effects18

function void uart_ctrl_env18::update_config18(uart_ctrl_config18 uart_ctrl_cfg18, int index);
  `uvm_info(get_type_name(), {"Updating Config18\n", uart_ctrl_cfg18.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg18;
  // Update these18 configs18 also (not really18 necessary18 since18 all are pointers18)
  uart_cfg18 = uart_ctrl_cfg18.uart_cfg18;
  apb_slave_cfg18 = cfg.apb_cfg18.slave_configs18[index];
  monitor18.cfg = uart_ctrl_cfg18;
endfunction : update_config18

function void uart_ctrl_env18::set_slave_config18(apb_slave_config18 _slave_cfg18, int index);
  monitor18.cfg.apb_cfg18.slave_configs18[index]  = _slave_cfg18;
  monitor18.set_slave_config18(_slave_cfg18, index);
endfunction : set_slave_config18

function void uart_ctrl_env18::set_uart_config18(uart_config18 _uart_cfg18);
  `uvm_info(get_type_name(), {"Setting Config18\n", _uart_cfg18.sprint()}, UVM_HIGH)
  monitor18.cfg.uart_cfg18  = _uart_cfg18;
  monitor18.set_uart_config18(_uart_cfg18);
endfunction : set_uart_config18
