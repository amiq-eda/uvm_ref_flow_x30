/*-------------------------------------------------------------------------
File8 name   : uart_ctrl_monitor8.sv
Title8       : UART8 Controller8 Monitor8
Project8     :
Created8     :
Description8 : Module8 monitor8
Notes8       : 
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

// TLM Port8 Declarations8
`uvm_analysis_imp_decl(_rx8)
`uvm_analysis_imp_decl(_tx8)
`uvm_analysis_imp_decl(_cfg8)

class uart_ctrl_monitor8 extends uvm_monitor;

  // Virtual interface to DUT signals8 if necessary8 (OPTIONAL8)
  virtual interface uart_ctrl_internal_if8 vif8;

  time rx_time_q8[$];
  time tx_time_q8[$];
  time tx_time_out8, tx_time_in8, rx_time_out8, rx_time_in8, clk_period8;

  // UART8 Controller8 Configuration8 Information8
  uart_ctrl_config8 cfg;

  // UART8 Controller8 coverage8
  uart_ctrl_cover8 uart_cover8;

  // Scoreboards8
  uart_ctrl_tx_scbd8 tx_scbd8;
  uart_ctrl_rx_scbd8 rx_scbd8;

  // TLM Connections8 to the interface UVC8 monitors8
  uvm_analysis_imp_apb8 #(apb_transfer8, uart_ctrl_monitor8) apb_in8;
  uvm_analysis_imp_rx8 #(uart_frame8, uart_ctrl_monitor8) uart_rx_in8;
  uvm_analysis_imp_tx8 #(uart_frame8, uart_ctrl_monitor8) uart_tx_in8;
  uvm_analysis_imp_cfg8 #(uart_config8, uart_ctrl_monitor8) uart_cfg_in8;

  // TLM Connections8 to other Components (Scoreboard8, updated config)
  uvm_analysis_port #(apb_transfer8) apb_out8;
  uvm_analysis_port #(uart_frame8) uart_rx_out8;
  uvm_analysis_port #(uart_frame8) uart_tx_out8;

  `uvm_component_utils_begin(uart_ctrl_monitor8)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports8(); // Create8 TLM Ports8
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif8.clock8) clk_period8 = $time;
    @(posedge vif8.clock8) clk_period8 = $time - clk_period8;
  endtask : run_phase
 
  // Additional8 class methods8
  extern virtual function void create_tlm_ports8();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx8(uart_frame8 frame8);
  extern virtual function void write_tx8(uart_frame8 frame8);
  extern virtual function void write_apb8(apb_transfer8 transfer8);
  extern virtual function void write_cfg8(uart_config8 uart_cfg8);
  extern virtual function void update_config8(uart_ctrl_config8 uart_ctrl_cfg8, int index);
  extern virtual function void set_slave_config8(apb_slave_config8 slave_cfg8, int index);
  extern virtual function void set_uart_config8(uart_config8 uart_cfg8);
endclass : uart_ctrl_monitor8

function void uart_ctrl_monitor8::create_tlm_ports8();
  apb_in8 = new("apb_in8", this);
  apb_out8 = new("apb_out8", this);
  uart_rx_in8 = new("uart_rx_in8", this);
  uart_rx_out8 = new("uart_rx_out8", this);
  uart_tx_in8 = new("uart_tx_in8", this);
  uart_tx_out8 = new("uart_tx_out8", this);
endfunction: create_tlm_ports8

function void uart_ctrl_monitor8::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover8 = uart_ctrl_cover8::type_id::create("uart_cover8",this);

  // Get8 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config8)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG8", "uart_ctrl_cfg8 is null...creating8 ", UVM_MEDIUM)
    cfg = uart_ctrl_config8::type_id::create("cfg", this);
    //set_config_object("tx_scbd8", "cfg", cfg);
    //set_config_object("rx_scbd8", "cfg", cfg);
  end
  //uvm_config_db#(uart_config8)::set(this, "*x_scbd8", "uart_cfg8", cfg.uart_cfg8);
  //uvm_config_db#(apb_slave_config8)::set(this, "*x_scbd8", "apb_slave_cfg8", cfg.apb_cfg8.slave_configs8[0]);
  uvm_config_object::set(this, "*x_scbd8", "uart_cfg8", cfg.uart_cfg8);
  uvm_config_object::set(this, "*x_scbd8", "apb_slave_cfg8", cfg.apb_cfg8.slave_configs8[0]);
  tx_scbd8 = uart_ctrl_tx_scbd8::type_id::create("tx_scbd8",this);
  rx_scbd8 = uart_ctrl_rx_scbd8::type_id::create("rx_scbd8",this);
endfunction : build_phase
   
function void uart_ctrl_monitor8::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get8 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if8)::get(this, "", "vif8", vif8))
      `uvm_error("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".vif8"})
  apb_out8.connect(tx_scbd8.apb_match8);
  uart_tx_out8.connect(tx_scbd8.uart_add8);
  apb_out8.connect(rx_scbd8.apb_add8);
  uart_rx_out8.connect(rx_scbd8.uart_match8);
endfunction : connect_phase

// implement UART8 Rx8 analysis8 port
function void uart_ctrl_monitor8::write_rx8(uart_frame8 frame8);
  uart_rx_out8.write(frame8);
  tx_time_in8 = tx_time_q8.pop_back();
  tx_time_out8 = ($time-tx_time_in8)/clk_period8;
endfunction : write_rx8
   
// implement UART8 Tx8 analysis8 port
function void uart_ctrl_monitor8::write_tx8(uart_frame8 frame8);
  uart_tx_out8.write(frame8);
  rx_time_q8.push_front($time); 
endfunction : write_tx8

// implement UART8 Config8 analysis8 port
function void uart_ctrl_monitor8::write_cfg8(uart_config8 uart_cfg8);
   set_uart_config8(uart_cfg8);
endfunction : write_cfg8

  // implement APB8 analysis8 port 
function void uart_ctrl_monitor8::write_apb8(apb_transfer8 transfer8);
    apb_out8.write(transfer8);
  if ((transfer8.direction8 == APB_READ8)  && (transfer8.addr == `RX_FIFO_REG8))
     begin
       rx_time_in8 = rx_time_q8.pop_back();
       rx_time_out8 = ($time-rx_time_in8)/clk_period8;
     end
  else if ((transfer8.direction8 == APB_WRITE8)  && (transfer8.addr == `TX_FIFO_REG8))
     begin
       tx_time_q8.push_front($time); 
     end
    
endfunction : write_apb8

function void uart_ctrl_monitor8::update_config8(uart_ctrl_config8 uart_ctrl_cfg8, int index);
  `uvm_info(get_type_name(), {"Updating Config8\n", uart_ctrl_cfg8.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg8;
   tx_scbd8.slave_cfg8 = uart_ctrl_cfg8.apb_cfg8.slave_configs8[index];
   tx_scbd8.uart_cfg8 = uart_ctrl_cfg8.uart_cfg8;
   rx_scbd8.slave_cfg8 = uart_ctrl_cfg8.apb_cfg8.slave_configs8[index];
   rx_scbd8.uart_cfg8 = uart_ctrl_cfg8.uart_cfg8;
endfunction : update_config8

function void uart_ctrl_monitor8::set_slave_config8(apb_slave_config8 slave_cfg8, int index);
   cfg.apb_cfg8.slave_configs8[index] = slave_cfg8;
   tx_scbd8.slave_cfg8 = slave_cfg8;
   rx_scbd8.slave_cfg8 = slave_cfg8;
endfunction : set_slave_config8

function void uart_ctrl_monitor8::set_uart_config8(uart_config8 uart_cfg8);
   cfg.uart_cfg8     = uart_cfg8;
   tx_scbd8.uart_cfg8 = uart_cfg8;
   rx_scbd8.uart_cfg8 = uart_cfg8;
endfunction : set_uart_config8
