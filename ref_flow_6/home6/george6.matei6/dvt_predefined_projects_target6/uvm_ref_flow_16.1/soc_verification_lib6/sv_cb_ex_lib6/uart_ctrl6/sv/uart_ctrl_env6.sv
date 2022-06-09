/*-------------------------------------------------------------------------
File6 name   : uart_ctrl_env6.sv
Title6       : 
Project6     :
Created6     :
Description6 : Module6 env6, contains6 the instance of scoreboard6 and coverage6 model
Notes6       : 
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`include "uart_ctrl_defines6.svh"
class uart_ctrl_env6 extends uvm_env; 
  
  // Component configuration classes6
  uart_ctrl_config6 cfg;
  // These6 are pointers6 to config classes6 above6
  uart_config6 uart_cfg6;
  apb_slave_config6 apb_slave_cfg6;

  // Module6 monitor6 (includes6 scoreboards6, coverage6, checking)
  uart_ctrl_monitor6 monitor6;

  // Control6 bit
  bit div_en6;

  // UVM_REG: Pointer6 to the Register Model6
  uart_ctrl_reg_model_c6 reg_model6;
  // Adapter sequence and predictor6
  reg_to_apb_adapter6 reg2apb6;   // Adapter Object REG to APB6
  uvm_reg_predictor#(apb_transfer6) apb_predictor6;  // Precictor6 - APB6 to REG
  uart_ctrl_reg_sequencer6 reg_sequencer6;
  
  // TLM Connections6 
  uvm_analysis_port #(uart_config6) uart_cfg_out6;
  uvm_analysis_imp #(apb_transfer6, uart_ctrl_env6) apb_in6;

  `uvm_component_utils_begin(uart_ctrl_env6)
    `uvm_field_object(reg_model6, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb6, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create6 TLM ports6
    uart_cfg_out6 = new("uart_cfg_out6", this);
    apb_in6 = new("apb_in6", this);
  endfunction

  // Additional6 class methods6
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer6 transfer6);
  extern virtual function void update_config6(uart_ctrl_config6 uart_ctrl_cfg6, int index);
  extern virtual function void set_slave_config6(apb_slave_config6 _slave_cfg6, int index);
  extern virtual function void set_uart_config6(uart_config6 _uart_cfg6);
  extern virtual function void write_effects6(apb_transfer6 transfer6);
  extern virtual function void read_effects6(apb_transfer6 transfer6);

endclass : uart_ctrl_env6

function void uart_ctrl_env6::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get6 or create the UART6 CONTROLLER6 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config6)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG6", "No uart_ctrl_config6 creating6...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config6::get_type(),
                                     default_uart_ctrl_config6::get_type());
    cfg = uart_ctrl_config6::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL6", "Config6 Randomization Failed6")
  end
  if (apb_slave_cfg6 == null) //begin
    if (!uvm_config_db#(apb_slave_config6)::get(this, "", "apb_slave_cfg6", apb_slave_cfg6)) begin
    `uvm_info("NOCONFIG6", "No apb_slave_config6 ..", UVM_LOW)
    apb_slave_cfg6 = cfg.apb_cfg6.slave_configs6[0];
  end
  //uvm_config_db#(uart_ctrl_config6)::set(this, "monitor6", "cfg", cfg);
  uvm_config_object::set(this, "monitor6", "cfg", cfg);
  uart_cfg6 = cfg.uart_cfg6;

  // UVMREG6: Create6 the adapter and predictor6
  reg2apb6 = reg_to_apb_adapter6::type_id::create("reg2apb6");
  apb_predictor6 = uvm_reg_predictor#(apb_transfer6)::type_id::create("apb_predictor6", this);
  reg_sequencer6 = uart_ctrl_reg_sequencer6::type_id::create("reg_sequencer6", this);

  // build system level monitor6
  monitor6 = uart_ctrl_monitor6::type_id::create("monitor6",this);
  ////monitor6.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env6::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG6 - Connect6 adapter to register sequencer and predictor6
  apb_predictor6.map = reg_model6.default_map;
  apb_predictor6.adapter = reg2apb6;
endfunction : connect_phase

// UVM_REG: write method for APB6 transfers6 - handles6 Register Operations6
function void uart_ctrl_env6::write(apb_transfer6 transfer6);
  if (apb_slave_cfg6.check_address_range6(transfer6.addr)) begin
    if (transfer6.direction6 == APB_WRITE6) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE6: addr = 'h%0h, data = 'h%0h",
          transfer6.addr, transfer6.data), UVM_MEDIUM)
      write_effects6(transfer6);
    end
    else if (transfer6.direction6 == APB_READ6) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ6: addr = 'h%0h, data = 'h%0h",
          transfer6.addr, transfer6.data), UVM_MEDIUM)
        read_effects6(transfer6);
    end else
      `uvm_error("REGMEM6", "Unsupported6 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG6 based on APB6 writes to config registers
function void uart_ctrl_env6::write_effects6(apb_transfer6 transfer6);
  case (transfer6.addr)
    apb_slave_cfg6.start_address6 + `LINE_CTRL6 : begin
                                            uart_cfg6.char_length6 = transfer6.data[1:0];
                                            uart_cfg6.parity_mode6 = transfer6.data[5:4];
                                            uart_cfg6.parity_en6   = transfer6.data[3];
                                            uart_cfg6.nbstop6      = transfer6.data[2];
                                            div_en6 = transfer6.data[7];
                                            uart_cfg6.ConvToIntChrl6();
                                            uart_cfg6.ConvToIntStpBt6();
                                            uart_cfg_out6.write(uart_cfg6);
                                          end
    apb_slave_cfg6.start_address6 + `DIVD_LATCH16 : begin
                                            if (div_en6) begin
                                            uart_cfg6.baud_rate_gen6 = transfer6.data[7:0];
                                            uart_cfg_out6.write(uart_cfg6);
                                            end
                                          end
    apb_slave_cfg6.start_address6 + `DIVD_LATCH26 : begin
                                            if (div_en6) begin
                                            uart_cfg6.baud_rate_div6 = transfer6.data[7:0];
                                            uart_cfg_out6.write(uart_cfg6);
                                            end
                                          end
    default: `uvm_warning("REGMEM26", "Write access not to Control6/Sataus6 Registers6")
  endcase
  set_uart_config6(uart_cfg6);
endfunction : write_effects6

function void uart_ctrl_env6::read_effects6(apb_transfer6 transfer6);
  // Nothing for now
endfunction : read_effects6

function void uart_ctrl_env6::update_config6(uart_ctrl_config6 uart_ctrl_cfg6, int index);
  `uvm_info(get_type_name(), {"Updating Config6\n", uart_ctrl_cfg6.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg6;
  // Update these6 configs6 also (not really6 necessary6 since6 all are pointers6)
  uart_cfg6 = uart_ctrl_cfg6.uart_cfg6;
  apb_slave_cfg6 = cfg.apb_cfg6.slave_configs6[index];
  monitor6.cfg = uart_ctrl_cfg6;
endfunction : update_config6

function void uart_ctrl_env6::set_slave_config6(apb_slave_config6 _slave_cfg6, int index);
  monitor6.cfg.apb_cfg6.slave_configs6[index]  = _slave_cfg6;
  monitor6.set_slave_config6(_slave_cfg6, index);
endfunction : set_slave_config6

function void uart_ctrl_env6::set_uart_config6(uart_config6 _uart_cfg6);
  `uvm_info(get_type_name(), {"Setting Config6\n", _uart_cfg6.sprint()}, UVM_HIGH)
  monitor6.cfg.uart_cfg6  = _uart_cfg6;
  monitor6.set_uart_config6(_uart_cfg6);
endfunction : set_uart_config6
