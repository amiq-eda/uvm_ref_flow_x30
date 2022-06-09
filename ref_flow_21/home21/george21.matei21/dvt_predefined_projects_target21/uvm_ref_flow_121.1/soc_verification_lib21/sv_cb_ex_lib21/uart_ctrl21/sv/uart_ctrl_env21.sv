/*-------------------------------------------------------------------------
File21 name   : uart_ctrl_env21.sv
Title21       : 
Project21     :
Created21     :
Description21 : Module21 env21, contains21 the instance of scoreboard21 and coverage21 model
Notes21       : 
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`include "uart_ctrl_defines21.svh"
class uart_ctrl_env21 extends uvm_env; 
  
  // Component configuration classes21
  uart_ctrl_config21 cfg;
  // These21 are pointers21 to config classes21 above21
  uart_config21 uart_cfg21;
  apb_slave_config21 apb_slave_cfg21;

  // Module21 monitor21 (includes21 scoreboards21, coverage21, checking)
  uart_ctrl_monitor21 monitor21;

  // Control21 bit
  bit div_en21;

  // UVM_REG: Pointer21 to the Register Model21
  uart_ctrl_reg_model_c21 reg_model21;
  // Adapter sequence and predictor21
  reg_to_apb_adapter21 reg2apb21;   // Adapter Object REG to APB21
  uvm_reg_predictor#(apb_transfer21) apb_predictor21;  // Precictor21 - APB21 to REG
  uart_ctrl_reg_sequencer21 reg_sequencer21;
  
  // TLM Connections21 
  uvm_analysis_port #(uart_config21) uart_cfg_out21;
  uvm_analysis_imp #(apb_transfer21, uart_ctrl_env21) apb_in21;

  `uvm_component_utils_begin(uart_ctrl_env21)
    `uvm_field_object(reg_model21, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb21, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create21 TLM ports21
    uart_cfg_out21 = new("uart_cfg_out21", this);
    apb_in21 = new("apb_in21", this);
  endfunction

  // Additional21 class methods21
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer21 transfer21);
  extern virtual function void update_config21(uart_ctrl_config21 uart_ctrl_cfg21, int index);
  extern virtual function void set_slave_config21(apb_slave_config21 _slave_cfg21, int index);
  extern virtual function void set_uart_config21(uart_config21 _uart_cfg21);
  extern virtual function void write_effects21(apb_transfer21 transfer21);
  extern virtual function void read_effects21(apb_transfer21 transfer21);

endclass : uart_ctrl_env21

function void uart_ctrl_env21::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get21 or create the UART21 CONTROLLER21 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config21)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG21", "No uart_ctrl_config21 creating21...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config21::get_type(),
                                     default_uart_ctrl_config21::get_type());
    cfg = uart_ctrl_config21::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL21", "Config21 Randomization Failed21")
  end
  if (apb_slave_cfg21 == null) //begin
    if (!uvm_config_db#(apb_slave_config21)::get(this, "", "apb_slave_cfg21", apb_slave_cfg21)) begin
    `uvm_info("NOCONFIG21", "No apb_slave_config21 ..", UVM_LOW)
    apb_slave_cfg21 = cfg.apb_cfg21.slave_configs21[0];
  end
  //uvm_config_db#(uart_ctrl_config21)::set(this, "monitor21", "cfg", cfg);
  uvm_config_object::set(this, "monitor21", "cfg", cfg);
  uart_cfg21 = cfg.uart_cfg21;

  // UVMREG21: Create21 the adapter and predictor21
  reg2apb21 = reg_to_apb_adapter21::type_id::create("reg2apb21");
  apb_predictor21 = uvm_reg_predictor#(apb_transfer21)::type_id::create("apb_predictor21", this);
  reg_sequencer21 = uart_ctrl_reg_sequencer21::type_id::create("reg_sequencer21", this);

  // build system level monitor21
  monitor21 = uart_ctrl_monitor21::type_id::create("monitor21",this);
  ////monitor21.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env21::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG21 - Connect21 adapter to register sequencer and predictor21
  apb_predictor21.map = reg_model21.default_map;
  apb_predictor21.adapter = reg2apb21;
endfunction : connect_phase

// UVM_REG: write method for APB21 transfers21 - handles21 Register Operations21
function void uart_ctrl_env21::write(apb_transfer21 transfer21);
  if (apb_slave_cfg21.check_address_range21(transfer21.addr)) begin
    if (transfer21.direction21 == APB_WRITE21) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE21: addr = 'h%0h, data = 'h%0h",
          transfer21.addr, transfer21.data), UVM_MEDIUM)
      write_effects21(transfer21);
    end
    else if (transfer21.direction21 == APB_READ21) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ21: addr = 'h%0h, data = 'h%0h",
          transfer21.addr, transfer21.data), UVM_MEDIUM)
        read_effects21(transfer21);
    end else
      `uvm_error("REGMEM21", "Unsupported21 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG21 based on APB21 writes to config registers
function void uart_ctrl_env21::write_effects21(apb_transfer21 transfer21);
  case (transfer21.addr)
    apb_slave_cfg21.start_address21 + `LINE_CTRL21 : begin
                                            uart_cfg21.char_length21 = transfer21.data[1:0];
                                            uart_cfg21.parity_mode21 = transfer21.data[5:4];
                                            uart_cfg21.parity_en21   = transfer21.data[3];
                                            uart_cfg21.nbstop21      = transfer21.data[2];
                                            div_en21 = transfer21.data[7];
                                            uart_cfg21.ConvToIntChrl21();
                                            uart_cfg21.ConvToIntStpBt21();
                                            uart_cfg_out21.write(uart_cfg21);
                                          end
    apb_slave_cfg21.start_address21 + `DIVD_LATCH121 : begin
                                            if (div_en21) begin
                                            uart_cfg21.baud_rate_gen21 = transfer21.data[7:0];
                                            uart_cfg_out21.write(uart_cfg21);
                                            end
                                          end
    apb_slave_cfg21.start_address21 + `DIVD_LATCH221 : begin
                                            if (div_en21) begin
                                            uart_cfg21.baud_rate_div21 = transfer21.data[7:0];
                                            uart_cfg_out21.write(uart_cfg21);
                                            end
                                          end
    default: `uvm_warning("REGMEM221", "Write access not to Control21/Sataus21 Registers21")
  endcase
  set_uart_config21(uart_cfg21);
endfunction : write_effects21

function void uart_ctrl_env21::read_effects21(apb_transfer21 transfer21);
  // Nothing for now
endfunction : read_effects21

function void uart_ctrl_env21::update_config21(uart_ctrl_config21 uart_ctrl_cfg21, int index);
  `uvm_info(get_type_name(), {"Updating Config21\n", uart_ctrl_cfg21.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg21;
  // Update these21 configs21 also (not really21 necessary21 since21 all are pointers21)
  uart_cfg21 = uart_ctrl_cfg21.uart_cfg21;
  apb_slave_cfg21 = cfg.apb_cfg21.slave_configs21[index];
  monitor21.cfg = uart_ctrl_cfg21;
endfunction : update_config21

function void uart_ctrl_env21::set_slave_config21(apb_slave_config21 _slave_cfg21, int index);
  monitor21.cfg.apb_cfg21.slave_configs21[index]  = _slave_cfg21;
  monitor21.set_slave_config21(_slave_cfg21, index);
endfunction : set_slave_config21

function void uart_ctrl_env21::set_uart_config21(uart_config21 _uart_cfg21);
  `uvm_info(get_type_name(), {"Setting Config21\n", _uart_cfg21.sprint()}, UVM_HIGH)
  monitor21.cfg.uart_cfg21  = _uart_cfg21;
  monitor21.set_uart_config21(_uart_cfg21);
endfunction : set_uart_config21
