/*-------------------------------------------------------------------------
File7 name   : uart_ctrl_monitor7.sv
Title7       : UART7 Controller7 Monitor7
Project7     :
Created7     :
Description7 : Module7 monitor7
Notes7       : 
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

// TLM Port7 Declarations7
`uvm_analysis_imp_decl(_rx7)
`uvm_analysis_imp_decl(_tx7)
`uvm_analysis_imp_decl(_cfg7)

class uart_ctrl_monitor7 extends uvm_monitor;

  // Virtual interface to DUT signals7 if necessary7 (OPTIONAL7)
  virtual interface uart_ctrl_internal_if7 vif7;

  time rx_time_q7[$];
  time tx_time_q7[$];
  time tx_time_out7, tx_time_in7, rx_time_out7, rx_time_in7, clk_period7;

  // UART7 Controller7 Configuration7 Information7
  uart_ctrl_config7 cfg;

  // UART7 Controller7 coverage7
  uart_ctrl_cover7 uart_cover7;

  // Scoreboards7
  uart_ctrl_tx_scbd7 tx_scbd7;
  uart_ctrl_rx_scbd7 rx_scbd7;

  // TLM Connections7 to the interface UVC7 monitors7
  uvm_analysis_imp_apb7 #(apb_transfer7, uart_ctrl_monitor7) apb_in7;
  uvm_analysis_imp_rx7 #(uart_frame7, uart_ctrl_monitor7) uart_rx_in7;
  uvm_analysis_imp_tx7 #(uart_frame7, uart_ctrl_monitor7) uart_tx_in7;
  uvm_analysis_imp_cfg7 #(uart_config7, uart_ctrl_monitor7) uart_cfg_in7;

  // TLM Connections7 to other Components (Scoreboard7, updated config)
  uvm_analysis_port #(apb_transfer7) apb_out7;
  uvm_analysis_port #(uart_frame7) uart_rx_out7;
  uvm_analysis_port #(uart_frame7) uart_tx_out7;

  `uvm_component_utils_begin(uart_ctrl_monitor7)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports7(); // Create7 TLM Ports7
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif7.clock7) clk_period7 = $time;
    @(posedge vif7.clock7) clk_period7 = $time - clk_period7;
  endtask : run_phase
 
  // Additional7 class methods7
  extern virtual function void create_tlm_ports7();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx7(uart_frame7 frame7);
  extern virtual function void write_tx7(uart_frame7 frame7);
  extern virtual function void write_apb7(apb_transfer7 transfer7);
  extern virtual function void write_cfg7(uart_config7 uart_cfg7);
  extern virtual function void update_config7(uart_ctrl_config7 uart_ctrl_cfg7, int index);
  extern virtual function void set_slave_config7(apb_slave_config7 slave_cfg7, int index);
  extern virtual function void set_uart_config7(uart_config7 uart_cfg7);
endclass : uart_ctrl_monitor7

function void uart_ctrl_monitor7::create_tlm_ports7();
  apb_in7 = new("apb_in7", this);
  apb_out7 = new("apb_out7", this);
  uart_rx_in7 = new("uart_rx_in7", this);
  uart_rx_out7 = new("uart_rx_out7", this);
  uart_tx_in7 = new("uart_tx_in7", this);
  uart_tx_out7 = new("uart_tx_out7", this);
endfunction: create_tlm_ports7

function void uart_ctrl_monitor7::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover7 = uart_ctrl_cover7::type_id::create("uart_cover7",this);

  // Get7 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config7)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG7", "uart_ctrl_cfg7 is null...creating7 ", UVM_MEDIUM)
    cfg = uart_ctrl_config7::type_id::create("cfg", this);
    //set_config_object("tx_scbd7", "cfg", cfg);
    //set_config_object("rx_scbd7", "cfg", cfg);
  end
  //uvm_config_db#(uart_config7)::set(this, "*x_scbd7", "uart_cfg7", cfg.uart_cfg7);
  //uvm_config_db#(apb_slave_config7)::set(this, "*x_scbd7", "apb_slave_cfg7", cfg.apb_cfg7.slave_configs7[0]);
  uvm_config_object::set(this, "*x_scbd7", "uart_cfg7", cfg.uart_cfg7);
  uvm_config_object::set(this, "*x_scbd7", "apb_slave_cfg7", cfg.apb_cfg7.slave_configs7[0]);
  tx_scbd7 = uart_ctrl_tx_scbd7::type_id::create("tx_scbd7",this);
  rx_scbd7 = uart_ctrl_rx_scbd7::type_id::create("rx_scbd7",this);
endfunction : build_phase
   
function void uart_ctrl_monitor7::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get7 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if7)::get(this, "", "vif7", vif7))
      `uvm_error("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".vif7"})
  apb_out7.connect(tx_scbd7.apb_match7);
  uart_tx_out7.connect(tx_scbd7.uart_add7);
  apb_out7.connect(rx_scbd7.apb_add7);
  uart_rx_out7.connect(rx_scbd7.uart_match7);
endfunction : connect_phase

// implement UART7 Rx7 analysis7 port
function void uart_ctrl_monitor7::write_rx7(uart_frame7 frame7);
  uart_rx_out7.write(frame7);
  tx_time_in7 = tx_time_q7.pop_back();
  tx_time_out7 = ($time-tx_time_in7)/clk_period7;
endfunction : write_rx7
   
// implement UART7 Tx7 analysis7 port
function void uart_ctrl_monitor7::write_tx7(uart_frame7 frame7);
  uart_tx_out7.write(frame7);
  rx_time_q7.push_front($time); 
endfunction : write_tx7

// implement UART7 Config7 analysis7 port
function void uart_ctrl_monitor7::write_cfg7(uart_config7 uart_cfg7);
   set_uart_config7(uart_cfg7);
endfunction : write_cfg7

  // implement APB7 analysis7 port 
function void uart_ctrl_monitor7::write_apb7(apb_transfer7 transfer7);
    apb_out7.write(transfer7);
  if ((transfer7.direction7 == APB_READ7)  && (transfer7.addr == `RX_FIFO_REG7))
     begin
       rx_time_in7 = rx_time_q7.pop_back();
       rx_time_out7 = ($time-rx_time_in7)/clk_period7;
     end
  else if ((transfer7.direction7 == APB_WRITE7)  && (transfer7.addr == `TX_FIFO_REG7))
     begin
       tx_time_q7.push_front($time); 
     end
    
endfunction : write_apb7

function void uart_ctrl_monitor7::update_config7(uart_ctrl_config7 uart_ctrl_cfg7, int index);
  `uvm_info(get_type_name(), {"Updating Config7\n", uart_ctrl_cfg7.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg7;
   tx_scbd7.slave_cfg7 = uart_ctrl_cfg7.apb_cfg7.slave_configs7[index];
   tx_scbd7.uart_cfg7 = uart_ctrl_cfg7.uart_cfg7;
   rx_scbd7.slave_cfg7 = uart_ctrl_cfg7.apb_cfg7.slave_configs7[index];
   rx_scbd7.uart_cfg7 = uart_ctrl_cfg7.uart_cfg7;
endfunction : update_config7

function void uart_ctrl_monitor7::set_slave_config7(apb_slave_config7 slave_cfg7, int index);
   cfg.apb_cfg7.slave_configs7[index] = slave_cfg7;
   tx_scbd7.slave_cfg7 = slave_cfg7;
   rx_scbd7.slave_cfg7 = slave_cfg7;
endfunction : set_slave_config7

function void uart_ctrl_monitor7::set_uart_config7(uart_config7 uart_cfg7);
   cfg.uart_cfg7     = uart_cfg7;
   tx_scbd7.uart_cfg7 = uart_cfg7;
   rx_scbd7.uart_cfg7 = uart_cfg7;
endfunction : set_uart_config7
