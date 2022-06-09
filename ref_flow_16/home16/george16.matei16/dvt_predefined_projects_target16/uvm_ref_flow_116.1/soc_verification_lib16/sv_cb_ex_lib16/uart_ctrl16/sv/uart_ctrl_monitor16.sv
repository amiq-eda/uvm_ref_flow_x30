/*-------------------------------------------------------------------------
File16 name   : uart_ctrl_monitor16.sv
Title16       : UART16 Controller16 Monitor16
Project16     :
Created16     :
Description16 : Module16 monitor16
Notes16       : 
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

// TLM Port16 Declarations16
`uvm_analysis_imp_decl(_rx16)
`uvm_analysis_imp_decl(_tx16)
`uvm_analysis_imp_decl(_cfg16)

class uart_ctrl_monitor16 extends uvm_monitor;

  // Virtual interface to DUT signals16 if necessary16 (OPTIONAL16)
  virtual interface uart_ctrl_internal_if16 vif16;

  time rx_time_q16[$];
  time tx_time_q16[$];
  time tx_time_out16, tx_time_in16, rx_time_out16, rx_time_in16, clk_period16;

  // UART16 Controller16 Configuration16 Information16
  uart_ctrl_config16 cfg;

  // UART16 Controller16 coverage16
  uart_ctrl_cover16 uart_cover16;

  // Scoreboards16
  uart_ctrl_tx_scbd16 tx_scbd16;
  uart_ctrl_rx_scbd16 rx_scbd16;

  // TLM Connections16 to the interface UVC16 monitors16
  uvm_analysis_imp_apb16 #(apb_transfer16, uart_ctrl_monitor16) apb_in16;
  uvm_analysis_imp_rx16 #(uart_frame16, uart_ctrl_monitor16) uart_rx_in16;
  uvm_analysis_imp_tx16 #(uart_frame16, uart_ctrl_monitor16) uart_tx_in16;
  uvm_analysis_imp_cfg16 #(uart_config16, uart_ctrl_monitor16) uart_cfg_in16;

  // TLM Connections16 to other Components (Scoreboard16, updated config)
  uvm_analysis_port #(apb_transfer16) apb_out16;
  uvm_analysis_port #(uart_frame16) uart_rx_out16;
  uvm_analysis_port #(uart_frame16) uart_tx_out16;

  `uvm_component_utils_begin(uart_ctrl_monitor16)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports16(); // Create16 TLM Ports16
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif16.clock16) clk_period16 = $time;
    @(posedge vif16.clock16) clk_period16 = $time - clk_period16;
  endtask : run_phase
 
  // Additional16 class methods16
  extern virtual function void create_tlm_ports16();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx16(uart_frame16 frame16);
  extern virtual function void write_tx16(uart_frame16 frame16);
  extern virtual function void write_apb16(apb_transfer16 transfer16);
  extern virtual function void write_cfg16(uart_config16 uart_cfg16);
  extern virtual function void update_config16(uart_ctrl_config16 uart_ctrl_cfg16, int index);
  extern virtual function void set_slave_config16(apb_slave_config16 slave_cfg16, int index);
  extern virtual function void set_uart_config16(uart_config16 uart_cfg16);
endclass : uart_ctrl_monitor16

function void uart_ctrl_monitor16::create_tlm_ports16();
  apb_in16 = new("apb_in16", this);
  apb_out16 = new("apb_out16", this);
  uart_rx_in16 = new("uart_rx_in16", this);
  uart_rx_out16 = new("uart_rx_out16", this);
  uart_tx_in16 = new("uart_tx_in16", this);
  uart_tx_out16 = new("uart_tx_out16", this);
endfunction: create_tlm_ports16

function void uart_ctrl_monitor16::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover16 = uart_ctrl_cover16::type_id::create("uart_cover16",this);

  // Get16 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config16)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG16", "uart_ctrl_cfg16 is null...creating16 ", UVM_MEDIUM)
    cfg = uart_ctrl_config16::type_id::create("cfg", this);
    //set_config_object("tx_scbd16", "cfg", cfg);
    //set_config_object("rx_scbd16", "cfg", cfg);
  end
  //uvm_config_db#(uart_config16)::set(this, "*x_scbd16", "uart_cfg16", cfg.uart_cfg16);
  //uvm_config_db#(apb_slave_config16)::set(this, "*x_scbd16", "apb_slave_cfg16", cfg.apb_cfg16.slave_configs16[0]);
  uvm_config_object::set(this, "*x_scbd16", "uart_cfg16", cfg.uart_cfg16);
  uvm_config_object::set(this, "*x_scbd16", "apb_slave_cfg16", cfg.apb_cfg16.slave_configs16[0]);
  tx_scbd16 = uart_ctrl_tx_scbd16::type_id::create("tx_scbd16",this);
  rx_scbd16 = uart_ctrl_rx_scbd16::type_id::create("rx_scbd16",this);
endfunction : build_phase
   
function void uart_ctrl_monitor16::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get16 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if16)::get(this, "", "vif16", vif16))
      `uvm_error("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".vif16"})
  apb_out16.connect(tx_scbd16.apb_match16);
  uart_tx_out16.connect(tx_scbd16.uart_add16);
  apb_out16.connect(rx_scbd16.apb_add16);
  uart_rx_out16.connect(rx_scbd16.uart_match16);
endfunction : connect_phase

// implement UART16 Rx16 analysis16 port
function void uart_ctrl_monitor16::write_rx16(uart_frame16 frame16);
  uart_rx_out16.write(frame16);
  tx_time_in16 = tx_time_q16.pop_back();
  tx_time_out16 = ($time-tx_time_in16)/clk_period16;
endfunction : write_rx16
   
// implement UART16 Tx16 analysis16 port
function void uart_ctrl_monitor16::write_tx16(uart_frame16 frame16);
  uart_tx_out16.write(frame16);
  rx_time_q16.push_front($time); 
endfunction : write_tx16

// implement UART16 Config16 analysis16 port
function void uart_ctrl_monitor16::write_cfg16(uart_config16 uart_cfg16);
   set_uart_config16(uart_cfg16);
endfunction : write_cfg16

  // implement APB16 analysis16 port 
function void uart_ctrl_monitor16::write_apb16(apb_transfer16 transfer16);
    apb_out16.write(transfer16);
  if ((transfer16.direction16 == APB_READ16)  && (transfer16.addr == `RX_FIFO_REG16))
     begin
       rx_time_in16 = rx_time_q16.pop_back();
       rx_time_out16 = ($time-rx_time_in16)/clk_period16;
     end
  else if ((transfer16.direction16 == APB_WRITE16)  && (transfer16.addr == `TX_FIFO_REG16))
     begin
       tx_time_q16.push_front($time); 
     end
    
endfunction : write_apb16

function void uart_ctrl_monitor16::update_config16(uart_ctrl_config16 uart_ctrl_cfg16, int index);
  `uvm_info(get_type_name(), {"Updating Config16\n", uart_ctrl_cfg16.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg16;
   tx_scbd16.slave_cfg16 = uart_ctrl_cfg16.apb_cfg16.slave_configs16[index];
   tx_scbd16.uart_cfg16 = uart_ctrl_cfg16.uart_cfg16;
   rx_scbd16.slave_cfg16 = uart_ctrl_cfg16.apb_cfg16.slave_configs16[index];
   rx_scbd16.uart_cfg16 = uart_ctrl_cfg16.uart_cfg16;
endfunction : update_config16

function void uart_ctrl_monitor16::set_slave_config16(apb_slave_config16 slave_cfg16, int index);
   cfg.apb_cfg16.slave_configs16[index] = slave_cfg16;
   tx_scbd16.slave_cfg16 = slave_cfg16;
   rx_scbd16.slave_cfg16 = slave_cfg16;
endfunction : set_slave_config16

function void uart_ctrl_monitor16::set_uart_config16(uart_config16 uart_cfg16);
   cfg.uart_cfg16     = uart_cfg16;
   tx_scbd16.uart_cfg16 = uart_cfg16;
   rx_scbd16.uart_cfg16 = uart_cfg16;
endfunction : set_uart_config16
