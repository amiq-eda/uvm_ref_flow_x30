/*-------------------------------------------------------------------------
File24 name   : uart_ctrl_monitor24.sv
Title24       : UART24 Controller24 Monitor24
Project24     :
Created24     :
Description24 : Module24 monitor24
Notes24       : 
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

// TLM Port24 Declarations24
`uvm_analysis_imp_decl(_rx24)
`uvm_analysis_imp_decl(_tx24)
`uvm_analysis_imp_decl(_cfg24)

class uart_ctrl_monitor24 extends uvm_monitor;

  // Virtual interface to DUT signals24 if necessary24 (OPTIONAL24)
  virtual interface uart_ctrl_internal_if24 vif24;

  time rx_time_q24[$];
  time tx_time_q24[$];
  time tx_time_out24, tx_time_in24, rx_time_out24, rx_time_in24, clk_period24;

  // UART24 Controller24 Configuration24 Information24
  uart_ctrl_config24 cfg;

  // UART24 Controller24 coverage24
  uart_ctrl_cover24 uart_cover24;

  // Scoreboards24
  uart_ctrl_tx_scbd24 tx_scbd24;
  uart_ctrl_rx_scbd24 rx_scbd24;

  // TLM Connections24 to the interface UVC24 monitors24
  uvm_analysis_imp_apb24 #(apb_transfer24, uart_ctrl_monitor24) apb_in24;
  uvm_analysis_imp_rx24 #(uart_frame24, uart_ctrl_monitor24) uart_rx_in24;
  uvm_analysis_imp_tx24 #(uart_frame24, uart_ctrl_monitor24) uart_tx_in24;
  uvm_analysis_imp_cfg24 #(uart_config24, uart_ctrl_monitor24) uart_cfg_in24;

  // TLM Connections24 to other Components (Scoreboard24, updated config)
  uvm_analysis_port #(apb_transfer24) apb_out24;
  uvm_analysis_port #(uart_frame24) uart_rx_out24;
  uvm_analysis_port #(uart_frame24) uart_tx_out24;

  `uvm_component_utils_begin(uart_ctrl_monitor24)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports24(); // Create24 TLM Ports24
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif24.clock24) clk_period24 = $time;
    @(posedge vif24.clock24) clk_period24 = $time - clk_period24;
  endtask : run_phase
 
  // Additional24 class methods24
  extern virtual function void create_tlm_ports24();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx24(uart_frame24 frame24);
  extern virtual function void write_tx24(uart_frame24 frame24);
  extern virtual function void write_apb24(apb_transfer24 transfer24);
  extern virtual function void write_cfg24(uart_config24 uart_cfg24);
  extern virtual function void update_config24(uart_ctrl_config24 uart_ctrl_cfg24, int index);
  extern virtual function void set_slave_config24(apb_slave_config24 slave_cfg24, int index);
  extern virtual function void set_uart_config24(uart_config24 uart_cfg24);
endclass : uart_ctrl_monitor24

function void uart_ctrl_monitor24::create_tlm_ports24();
  apb_in24 = new("apb_in24", this);
  apb_out24 = new("apb_out24", this);
  uart_rx_in24 = new("uart_rx_in24", this);
  uart_rx_out24 = new("uart_rx_out24", this);
  uart_tx_in24 = new("uart_tx_in24", this);
  uart_tx_out24 = new("uart_tx_out24", this);
endfunction: create_tlm_ports24

function void uart_ctrl_monitor24::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover24 = uart_ctrl_cover24::type_id::create("uart_cover24",this);

  // Get24 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config24)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG24", "uart_ctrl_cfg24 is null...creating24 ", UVM_MEDIUM)
    cfg = uart_ctrl_config24::type_id::create("cfg", this);
    //set_config_object("tx_scbd24", "cfg", cfg);
    //set_config_object("rx_scbd24", "cfg", cfg);
  end
  //uvm_config_db#(uart_config24)::set(this, "*x_scbd24", "uart_cfg24", cfg.uart_cfg24);
  //uvm_config_db#(apb_slave_config24)::set(this, "*x_scbd24", "apb_slave_cfg24", cfg.apb_cfg24.slave_configs24[0]);
  uvm_config_object::set(this, "*x_scbd24", "uart_cfg24", cfg.uart_cfg24);
  uvm_config_object::set(this, "*x_scbd24", "apb_slave_cfg24", cfg.apb_cfg24.slave_configs24[0]);
  tx_scbd24 = uart_ctrl_tx_scbd24::type_id::create("tx_scbd24",this);
  rx_scbd24 = uart_ctrl_rx_scbd24::type_id::create("rx_scbd24",this);
endfunction : build_phase
   
function void uart_ctrl_monitor24::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get24 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if24)::get(this, "", "vif24", vif24))
      `uvm_error("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".vif24"})
  apb_out24.connect(tx_scbd24.apb_match24);
  uart_tx_out24.connect(tx_scbd24.uart_add24);
  apb_out24.connect(rx_scbd24.apb_add24);
  uart_rx_out24.connect(rx_scbd24.uart_match24);
endfunction : connect_phase

// implement UART24 Rx24 analysis24 port
function void uart_ctrl_monitor24::write_rx24(uart_frame24 frame24);
  uart_rx_out24.write(frame24);
  tx_time_in24 = tx_time_q24.pop_back();
  tx_time_out24 = ($time-tx_time_in24)/clk_period24;
endfunction : write_rx24
   
// implement UART24 Tx24 analysis24 port
function void uart_ctrl_monitor24::write_tx24(uart_frame24 frame24);
  uart_tx_out24.write(frame24);
  rx_time_q24.push_front($time); 
endfunction : write_tx24

// implement UART24 Config24 analysis24 port
function void uart_ctrl_monitor24::write_cfg24(uart_config24 uart_cfg24);
   set_uart_config24(uart_cfg24);
endfunction : write_cfg24

  // implement APB24 analysis24 port 
function void uart_ctrl_monitor24::write_apb24(apb_transfer24 transfer24);
    apb_out24.write(transfer24);
  if ((transfer24.direction24 == APB_READ24)  && (transfer24.addr == `RX_FIFO_REG24))
     begin
       rx_time_in24 = rx_time_q24.pop_back();
       rx_time_out24 = ($time-rx_time_in24)/clk_period24;
     end
  else if ((transfer24.direction24 == APB_WRITE24)  && (transfer24.addr == `TX_FIFO_REG24))
     begin
       tx_time_q24.push_front($time); 
     end
    
endfunction : write_apb24

function void uart_ctrl_monitor24::update_config24(uart_ctrl_config24 uart_ctrl_cfg24, int index);
  `uvm_info(get_type_name(), {"Updating Config24\n", uart_ctrl_cfg24.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg24;
   tx_scbd24.slave_cfg24 = uart_ctrl_cfg24.apb_cfg24.slave_configs24[index];
   tx_scbd24.uart_cfg24 = uart_ctrl_cfg24.uart_cfg24;
   rx_scbd24.slave_cfg24 = uart_ctrl_cfg24.apb_cfg24.slave_configs24[index];
   rx_scbd24.uart_cfg24 = uart_ctrl_cfg24.uart_cfg24;
endfunction : update_config24

function void uart_ctrl_monitor24::set_slave_config24(apb_slave_config24 slave_cfg24, int index);
   cfg.apb_cfg24.slave_configs24[index] = slave_cfg24;
   tx_scbd24.slave_cfg24 = slave_cfg24;
   rx_scbd24.slave_cfg24 = slave_cfg24;
endfunction : set_slave_config24

function void uart_ctrl_monitor24::set_uart_config24(uart_config24 uart_cfg24);
   cfg.uart_cfg24     = uart_cfg24;
   tx_scbd24.uart_cfg24 = uart_cfg24;
   rx_scbd24.uart_cfg24 = uart_cfg24;
endfunction : set_uart_config24
