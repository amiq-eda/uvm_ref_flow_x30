/*-------------------------------------------------------------------------
File2 name   : uart_ctrl_env2.sv
Title2       : 
Project2     :
Created2     :
Description2 : Module2 env2, contains2 the instance of scoreboard2 and coverage2 model
Notes2       : 
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`include "uart_ctrl_defines2.svh"
class uart_ctrl_env2 extends uvm_env; 
  
  // Component configuration classes2
  uart_ctrl_config2 cfg;
  // These2 are pointers2 to config classes2 above2
  uart_config2 uart_cfg2;
  apb_slave_config2 apb_slave_cfg2;

  // Module2 monitor2 (includes2 scoreboards2, coverage2, checking)
  uart_ctrl_monitor2 monitor2;

  // Control2 bit
  bit div_en2;

  // UVM_REG: Pointer2 to the Register Model2
  uart_ctrl_reg_model_c2 reg_model2;
  // Adapter sequence and predictor2
  reg_to_apb_adapter2 reg2apb2;   // Adapter Object REG to APB2
  uvm_reg_predictor#(apb_transfer2) apb_predictor2;  // Precictor2 - APB2 to REG
  uart_ctrl_reg_sequencer2 reg_sequencer2;
  
  // TLM Connections2 
  uvm_analysis_port #(uart_config2) uart_cfg_out2;
  uvm_analysis_imp #(apb_transfer2, uart_ctrl_env2) apb_in2;

  `uvm_component_utils_begin(uart_ctrl_env2)
    `uvm_field_object(reg_model2, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(reg2apb2, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create2 TLM ports2
    uart_cfg_out2 = new("uart_cfg_out2", this);
    apb_in2 = new("apb_in2", this);
  endfunction

  // Additional2 class methods2
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(apb_transfer2 transfer2);
  extern virtual function void update_config2(uart_ctrl_config2 uart_ctrl_cfg2, int index);
  extern virtual function void set_slave_config2(apb_slave_config2 _slave_cfg2, int index);
  extern virtual function void set_uart_config2(uart_config2 _uart_cfg2);
  extern virtual function void write_effects2(apb_transfer2 transfer2);
  extern virtual function void read_effects2(apb_transfer2 transfer2);

endclass : uart_ctrl_env2

function void uart_ctrl_env2::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get2 or create the UART2 CONTROLLER2 config class
  if (cfg == null) //begin
    if (!uvm_config_db#(uart_ctrl_config2)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG2", "No uart_ctrl_config2 creating2...", UVM_LOW)
    set_inst_override_by_type("cfg", uart_ctrl_config2::get_type(),
                                     default_uart_ctrl_config2::get_type());
    cfg = uart_ctrl_config2::type_id::create("cfg");
    //if (!cfg.randomize()) `uvm_error("RNDFAIL2", "Config2 Randomization Failed2")
  end
  if (apb_slave_cfg2 == null) //begin
    if (!uvm_config_db#(apb_slave_config2)::get(this, "", "apb_slave_cfg2", apb_slave_cfg2)) begin
    `uvm_info("NOCONFIG2", "No apb_slave_config2 ..", UVM_LOW)
    apb_slave_cfg2 = cfg.apb_cfg2.slave_configs2[0];
  end
  //uvm_config_db#(uart_ctrl_config2)::set(this, "monitor2", "cfg", cfg);
  uvm_config_object::set(this, "monitor2", "cfg", cfg);
  uart_cfg2 = cfg.uart_cfg2;

  // UVMREG2: Create2 the adapter and predictor2
  reg2apb2 = reg_to_apb_adapter2::type_id::create("reg2apb2");
  apb_predictor2 = uvm_reg_predictor#(apb_transfer2)::type_id::create("apb_predictor2", this);
  reg_sequencer2 = uart_ctrl_reg_sequencer2::type_id::create("reg_sequencer2", this);

  // build system level monitor2
  monitor2 = uart_ctrl_monitor2::type_id::create("monitor2",this);
  ////monitor2.cfg = cfg;
endfunction : build_phase
  
function void uart_ctrl_env2::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //UVMREG2 - Connect2 adapter to register sequencer and predictor2
  apb_predictor2.map = reg_model2.default_map;
  apb_predictor2.adapter = reg2apb2;
endfunction : connect_phase

// UVM_REG: write method for APB2 transfers2 - handles2 Register Operations2
function void uart_ctrl_env2::write(apb_transfer2 transfer2);
  if (apb_slave_cfg2.check_address_range2(transfer2.addr)) begin
    if (transfer2.direction2 == APB_WRITE2) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_WRITE2: addr = 'h%0h, data = 'h%0h",
          transfer2.addr, transfer2.data), UVM_MEDIUM)
      write_effects2(transfer2);
    end
    else if (transfer2.direction2 == APB_READ2) begin
      `uvm_info(get_type_name(),
          $psprintf("APB_READ2: addr = 'h%0h, data = 'h%0h",
          transfer2.addr, transfer2.data), UVM_MEDIUM)
        read_effects2(transfer2);
    end else
      `uvm_error("REGMEM2", "Unsupported2 access!!!")
  end
endfunction : write

// UVM_REG: Update CONFIG2 based on APB2 writes to config registers
function void uart_ctrl_env2::write_effects2(apb_transfer2 transfer2);
  case (transfer2.addr)
    apb_slave_cfg2.start_address2 + `LINE_CTRL2 : begin
                                            uart_cfg2.char_length2 = transfer2.data[1:0];
                                            uart_cfg2.parity_mode2 = transfer2.data[5:4];
                                            uart_cfg2.parity_en2   = transfer2.data[3];
                                            uart_cfg2.nbstop2      = transfer2.data[2];
                                            div_en2 = transfer2.data[7];
                                            uart_cfg2.ConvToIntChrl2();
                                            uart_cfg2.ConvToIntStpBt2();
                                            uart_cfg_out2.write(uart_cfg2);
                                          end
    apb_slave_cfg2.start_address2 + `DIVD_LATCH12 : begin
                                            if (div_en2) begin
                                            uart_cfg2.baud_rate_gen2 = transfer2.data[7:0];
                                            uart_cfg_out2.write(uart_cfg2);
                                            end
                                          end
    apb_slave_cfg2.start_address2 + `DIVD_LATCH22 : begin
                                            if (div_en2) begin
                                            uart_cfg2.baud_rate_div2 = transfer2.data[7:0];
                                            uart_cfg_out2.write(uart_cfg2);
                                            end
                                          end
    default: `uvm_warning("REGMEM22", "Write access not to Control2/Sataus2 Registers2")
  endcase
  set_uart_config2(uart_cfg2);
endfunction : write_effects2

function void uart_ctrl_env2::read_effects2(apb_transfer2 transfer2);
  // Nothing for now
endfunction : read_effects2

function void uart_ctrl_env2::update_config2(uart_ctrl_config2 uart_ctrl_cfg2, int index);
  `uvm_info(get_type_name(), {"Updating Config2\n", uart_ctrl_cfg2.sprint}, UVM_HIGH)
  cfg = uart_ctrl_cfg2;
  // Update these2 configs2 also (not really2 necessary2 since2 all are pointers2)
  uart_cfg2 = uart_ctrl_cfg2.uart_cfg2;
  apb_slave_cfg2 = cfg.apb_cfg2.slave_configs2[index];
  monitor2.cfg = uart_ctrl_cfg2;
endfunction : update_config2

function void uart_ctrl_env2::set_slave_config2(apb_slave_config2 _slave_cfg2, int index);
  monitor2.cfg.apb_cfg2.slave_configs2[index]  = _slave_cfg2;
  monitor2.set_slave_config2(_slave_cfg2, index);
endfunction : set_slave_config2

function void uart_ctrl_env2::set_uart_config2(uart_config2 _uart_cfg2);
  `uvm_info(get_type_name(), {"Setting Config2\n", _uart_cfg2.sprint()}, UVM_HIGH)
  monitor2.cfg.uart_cfg2  = _uart_cfg2;
  monitor2.set_uart_config2(_uart_cfg2);
endfunction : set_uart_config2
