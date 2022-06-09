/*-------------------------------------------------------------------------
File4 name   : uart_ctrl_env4.sv
Title4       : 
Project4     :
Created4     :
Description4 : Module4 env4, contains4 the instance of scoreboard4 and coverage4 model
Notes4       : 
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`include "uart_ctrl_defines4.svh"
class uart_ctrl_env4 extends uvm_env; 
  
  // Component configuration classes4
  uart_ctrl_config4 cfg;
  // These4 are pointers4 to config classes4 above4
  uart_config4 uart_cfg4;
  apb_slave_config4 apb_slave_cfg4;

  // Module4 monitor4 (includes4 scoreboards4, coverage4, checking)
  uart_ctrl_monitor4 monitor4;

  // Control4 bit
  bit div_en4;

  // UVM_REG: Pointer4 to the Register Model4
  uart_ctrl_reg_model_c4 reg_model4;
  // Adapter sequence and predictor4
  reg_to_apb_adapter4 reg2apb4;   // Adapter Object REG to APB4
  uvm_reg_predictor#(apb_transfer4) apb_predictor4;  // Precictor4 - APB4 to REG
  uart_ctrl_reg_sequencer4 reg_sequencer4;
  
  // TLM Connections4 
  uvm_analysis_port #(uart_config4) uart_cfg_out4;
  uvm_analysis_imp #(apb_transfer4, uart_ctrl_env4) apb_in4;

  `uvm_component_utils_begin(uart_ctrl_env4)
    `uvm_field_object(reg_model4, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb4, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create4 TLM ports4
    uart_cfg_out4 = new("uart_cfg_out4", this);
    apb_in4 = new("apb_in4", this);
  endfunction

  // Additional4 class methods4
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer4 transfer4);
  extern virtual function void update_config4(uart_ctrl_config4 uart_ctrl_cfg4, int index);
  extern virtual function void set_slave_config4(apb_slave_config4 _slave_cfg4, int index);
  extern virtual function void set_uart_config4(uart_config4 _uart_cfg4);
  extern virtual function void write_effects4(apb_transfer4 transfer4);
  extern virtual function void read_effects4(apb_transfer4 transfer4);

endclass : uart_ctrl_env4

function void uart_ctrl_env4::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get4 or create the UART4 CONTROLLER4 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config4)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG4", "No uart_ctrl_config4 creating4...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config4::get_type(),
                                     default_uart_ctrl_config4::get_type());
    cfg = uart_ctrl_config4::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL4", "Config4 Randomization Failed4")
  end
  if (apb_slave_cfg4 == null) //begin
    if (!uvm_config_db#(apb_slave_config4)::get(this, "", "apb_slave_cfg4", apb_slave_cfg4)) begin
    `uvm_info("NOCONFIG4", "No apb_slave_config4 ..", UVM_LOW)
    apb_slave_cfg4 = cfg.apb_cfg4.slave_configs4[0];
  end
  //uvm_config_db#(uart_ctrl_config4)::set(this, "monitor4", "cfg", cfg);
  uvm_config_object::set(this, "monitor4", "cfg", cfg);
  uart_cfg4 = cfg.uart_cfg4;

  // UVMREG4: Create4 the adapter and predictor4
  reg2apb4 = reg_to_apb_adapter4::type_id::create("reg2apb4");
  apb_predictor4 = uvm_reg_predictor#(apb_transfer4)::type_id::create("apb_predictor4", this);
  reg_sequencer4 = uart_ctrl_reg_sequencer4::type_id::create("reg_sequencer4", this);

  // build system level monitor4
  monitor4 = uart_ctrl_monitor4::type_id::create("monitor4",this);
  ////monitor4.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env4::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG4 - Connect4 adapter to register sequencer and predictor4
  apb_predictor4.map = reg_model4.default_map;
  apb_predictor4.adapter = reg2apb4;
endfunction : connect_phase

// UVM_REG: write method for APB4 transfers4 - handles4 Register Operations4
function void uart_ctrl_env4::write(apb_transfer4 transfer4);
  if (apb_slave_cfg4.check_address_range4(transfer4.addr)) begin
    if (transfer4.direction4 == APB_WRITE4) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE4: addr = 'h%0h, data = 'h%0h",
          transfer4.addr, transfer4.data), UVM_MEDIUM)
      write_effects4(transfer4);
    end
    else if (transfer4.direction4 == APB_READ4) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ4: addr = 'h%0h, data = 'h%0h",
          transfer4.addr, transfer4.data), UVM_MEDIUM)
        read_effects4(transfer4);
    end else
      `uvm_error("REGMEM4", "Unsupported4 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG4 based on APB4 writes to config registers
function void uart_ctrl_env4::write_effects4(apb_transfer4 transfer4);
  case (transfer4.addr)
    apb_slave_cfg4.start_address4 + `LINE_CTRL4 : begin
                                            uart_cfg4.char_length4 = transfer4.data[1:0];
                                            uart_cfg4.parity_mode4 = transfer4.data[5:4];
                                            uart_cfg4.parity_en4   = transfer4.data[3];
                                            uart_cfg4.nbstop4      = transfer4.data[2];
                                            div_en4 = transfer4.data[7];
                                            uart_cfg4.ConvToIntChrl4();
                                            uart_cfg4.ConvToIntStpBt4();
                                            uart_cfg_out4.write(uart_cfg4);
                                          end
    apb_slave_cfg4.start_address4 + `DIVD_LATCH14 : begin
                                            if (div_en4) begin
                                            uart_cfg4.baud_rate_gen4 = transfer4.data[7:0];
                                            uart_cfg_out4.write(uart_cfg4);
                                            end
                                          end
    apb_slave_cfg4.start_address4 + `DIVD_LATCH24 : begin
                                            if (div_en4) begin
                                            uart_cfg4.baud_rate_div4 = transfer4.data[7:0];
                                            uart_cfg_out4.write(uart_cfg4);
                                            end
                                          end
    default: `uvm_warning("REGMEM24", "Write access not to Control4/Sataus4 Registers4")
  endcase
  set_uart_config4(uart_cfg4);
endfunction : write_effects4

function void uart_ctrl_env4::read_effects4(apb_transfer4 transfer4);
  // Nothing for now
endfunction : read_effects4

function void uart_ctrl_env4::update_config4(uart_ctrl_config4 uart_ctrl_cfg4, int index);
  `uvm_info(get_type_name(), {"Updating Config4\n", uart_ctrl_cfg4.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg4;
  // Update these4 configs4 also (not really4 necessary4 since4 all are pointers4)
  uart_cfg4 = uart_ctrl_cfg4.uart_cfg4;
  apb_slave_cfg4 = cfg.apb_cfg4.slave_configs4[index];
  monitor4.cfg = uart_ctrl_cfg4;
endfunction : update_config4

function void uart_ctrl_env4::set_slave_config4(apb_slave_config4 _slave_cfg4, int index);
  monitor4.cfg.apb_cfg4.slave_configs4[index]  = _slave_cfg4;
  monitor4.set_slave_config4(_slave_cfg4, index);
endfunction : set_slave_config4

function void uart_ctrl_env4::set_uart_config4(uart_config4 _uart_cfg4);
  `uvm_info(get_type_name(), {"Setting Config4\n", _uart_cfg4.sprint()}, UVM_HIGH)
  monitor4.cfg.uart_cfg4  = _uart_cfg4;
  monitor4.set_uart_config4(_uart_cfg4);
endfunction : set_uart_config4
