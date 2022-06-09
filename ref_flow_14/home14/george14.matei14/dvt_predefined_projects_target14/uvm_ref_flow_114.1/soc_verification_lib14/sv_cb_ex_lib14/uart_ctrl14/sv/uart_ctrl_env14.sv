/*-------------------------------------------------------------------------
File14 name   : uart_ctrl_env14.sv
Title14       : 
Project14     :
Created14     :
Description14 : Module14 env14, contains14 the instance of scoreboard14 and coverage14 model
Notes14       : 
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`include "uart_ctrl_defines14.svh"
class uart_ctrl_env14 extends uvm_env; 
  
  // Component configuration classes14
  uart_ctrl_config14 cfg;
  // These14 are pointers14 to config classes14 above14
  uart_config14 uart_cfg14;
  apb_slave_config14 apb_slave_cfg14;

  // Module14 monitor14 (includes14 scoreboards14, coverage14, checking)
  uart_ctrl_monitor14 monitor14;

  // Control14 bit
  bit div_en14;

  // UVM_REG: Pointer14 to the Register Model14
  uart_ctrl_reg_model_c14 reg_model14;
  // Adapter sequence and predictor14
  reg_to_apb_adapter14 reg2apb14;   // Adapter Object REG to APB14
  uvm_reg_predictor#(apb_transfer14) apb_predictor14;  // Precictor14 - APB14 to REG
  uart_ctrl_reg_sequencer14 reg_sequencer14;
  
  // TLM Connections14 
  uvm_analysis_port #(uart_config14) uart_cfg_out14;
  uvm_analysis_imp #(apb_transfer14, uart_ctrl_env14) apb_in14;

  `uvm_component_utils_begin(uart_ctrl_env14)
    `uvm_field_object(reg_model14, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb14, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create14 TLM ports14
    uart_cfg_out14 = new("uart_cfg_out14", this);
    apb_in14 = new("apb_in14", this);
  endfunction

  // Additional14 class methods14
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer14 transfer14);
  extern virtual function void update_config14(uart_ctrl_config14 uart_ctrl_cfg14, int index);
  extern virtual function void set_slave_config14(apb_slave_config14 _slave_cfg14, int index);
  extern virtual function void set_uart_config14(uart_config14 _uart_cfg14);
  extern virtual function void write_effects14(apb_transfer14 transfer14);
  extern virtual function void read_effects14(apb_transfer14 transfer14);

endclass : uart_ctrl_env14

function void uart_ctrl_env14::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get14 or create the UART14 CONTROLLER14 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config14)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG14", "No uart_ctrl_config14 creating14...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config14::get_type(),
                                     default_uart_ctrl_config14::get_type());
    cfg = uart_ctrl_config14::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL14", "Config14 Randomization Failed14")
  end
  if (apb_slave_cfg14 == null) //begin
    if (!uvm_config_db#(apb_slave_config14)::get(this, "", "apb_slave_cfg14", apb_slave_cfg14)) begin
    `uvm_info("NOCONFIG14", "No apb_slave_config14 ..", UVM_LOW)
    apb_slave_cfg14 = cfg.apb_cfg14.slave_configs14[0];
  end
  //uvm_config_db#(uart_ctrl_config14)::set(this, "monitor14", "cfg", cfg);
  uvm_config_object::set(this, "monitor14", "cfg", cfg);
  uart_cfg14 = cfg.uart_cfg14;

  // UVMREG14: Create14 the adapter and predictor14
  reg2apb14 = reg_to_apb_adapter14::type_id::create("reg2apb14");
  apb_predictor14 = uvm_reg_predictor#(apb_transfer14)::type_id::create("apb_predictor14", this);
  reg_sequencer14 = uart_ctrl_reg_sequencer14::type_id::create("reg_sequencer14", this);

  // build system level monitor14
  monitor14 = uart_ctrl_monitor14::type_id::create("monitor14",this);
  ////monitor14.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env14::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG14 - Connect14 adapter to register sequencer and predictor14
  apb_predictor14.map = reg_model14.default_map;
  apb_predictor14.adapter = reg2apb14;
endfunction : connect_phase

// UVM_REG: write method for APB14 transfers14 - handles14 Register Operations14
function void uart_ctrl_env14::write(apb_transfer14 transfer14);
  if (apb_slave_cfg14.check_address_range14(transfer14.addr)) begin
    if (transfer14.direction14 == APB_WRITE14) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE14: addr = 'h%0h, data = 'h%0h",
          transfer14.addr, transfer14.data), UVM_MEDIUM)
      write_effects14(transfer14);
    end
    else if (transfer14.direction14 == APB_READ14) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ14: addr = 'h%0h, data = 'h%0h",
          transfer14.addr, transfer14.data), UVM_MEDIUM)
        read_effects14(transfer14);
    end else
      `uvm_error("REGMEM14", "Unsupported14 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG14 based on APB14 writes to config registers
function void uart_ctrl_env14::write_effects14(apb_transfer14 transfer14);
  case (transfer14.addr)
    apb_slave_cfg14.start_address14 + `LINE_CTRL14 : begin
                                            uart_cfg14.char_length14 = transfer14.data[1:0];
                                            uart_cfg14.parity_mode14 = transfer14.data[5:4];
                                            uart_cfg14.parity_en14   = transfer14.data[3];
                                            uart_cfg14.nbstop14      = transfer14.data[2];
                                            div_en14 = transfer14.data[7];
                                            uart_cfg14.ConvToIntChrl14();
                                            uart_cfg14.ConvToIntStpBt14();
                                            uart_cfg_out14.write(uart_cfg14);
                                          end
    apb_slave_cfg14.start_address14 + `DIVD_LATCH114 : begin
                                            if (div_en14) begin
                                            uart_cfg14.baud_rate_gen14 = transfer14.data[7:0];
                                            uart_cfg_out14.write(uart_cfg14);
                                            end
                                          end
    apb_slave_cfg14.start_address14 + `DIVD_LATCH214 : begin
                                            if (div_en14) begin
                                            uart_cfg14.baud_rate_div14 = transfer14.data[7:0];
                                            uart_cfg_out14.write(uart_cfg14);
                                            end
                                          end
    default: `uvm_warning("REGMEM214", "Write access not to Control14/Sataus14 Registers14")
  endcase
  set_uart_config14(uart_cfg14);
endfunction : write_effects14

function void uart_ctrl_env14::read_effects14(apb_transfer14 transfer14);
  // Nothing for now
endfunction : read_effects14

function void uart_ctrl_env14::update_config14(uart_ctrl_config14 uart_ctrl_cfg14, int index);
  `uvm_info(get_type_name(), {"Updating Config14\n", uart_ctrl_cfg14.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg14;
  // Update these14 configs14 also (not really14 necessary14 since14 all are pointers14)
  uart_cfg14 = uart_ctrl_cfg14.uart_cfg14;
  apb_slave_cfg14 = cfg.apb_cfg14.slave_configs14[index];
  monitor14.cfg = uart_ctrl_cfg14;
endfunction : update_config14

function void uart_ctrl_env14::set_slave_config14(apb_slave_config14 _slave_cfg14, int index);
  monitor14.cfg.apb_cfg14.slave_configs14[index]  = _slave_cfg14;
  monitor14.set_slave_config14(_slave_cfg14, index);
endfunction : set_slave_config14

function void uart_ctrl_env14::set_uart_config14(uart_config14 _uart_cfg14);
  `uvm_info(get_type_name(), {"Setting Config14\n", _uart_cfg14.sprint()}, UVM_HIGH)
  monitor14.cfg.uart_cfg14  = _uart_cfg14;
  monitor14.set_uart_config14(_uart_cfg14);
endfunction : set_uart_config14
