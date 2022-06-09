/*-------------------------------------------------------------------------
File13 name   : uart_ctrl_monitor13.sv
Title13       : UART13 Controller13 Monitor13
Project13     :
Created13     :
Description13 : Module13 monitor13
Notes13       : 
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

// TLM Port13 Declarations13
`uvm_analysis_imp_decl(_rx13)
`uvm_analysis_imp_decl(_tx13)
`uvm_analysis_imp_decl(_cfg13)

class uart_ctrl_monitor13 extends uvm_monitor;

  // Virtual interface to DUT signals13 if necessary13 (OPTIONAL13)
  virtual interface uart_ctrl_internal_if13 vif13;

  time rx_time_q13[$];
  time tx_time_q13[$];
  time tx_time_out13, tx_time_in13, rx_time_out13, rx_time_in13, clk_period13;

  // UART13 Controller13 Configuration13 Information13
  uart_ctrl_config13 cfg;

  // UART13 Controller13 coverage13
  uart_ctrl_cover13 uart_cover13;

  // Scoreboards13
  uart_ctrl_tx_scbd13 tx_scbd13;
  uart_ctrl_rx_scbd13 rx_scbd13;

  // TLM Connections13 to the interface UVC13 monitors13
  uvm_analysis_imp_apb13 #(apb_transfer13, uart_ctrl_monitor13) apb_in13;
  uvm_analysis_imp_rx13 #(uart_frame13, uart_ctrl_monitor13) uart_rx_in13;
  uvm_analysis_imp_tx13 #(uart_frame13, uart_ctrl_monitor13) uart_tx_in13;
  uvm_analysis_imp_cfg13 #(uart_config13, uart_ctrl_monitor13) uart_cfg_in13;

  // TLM Connections13 to other Components (Scoreboard13, updated config)
  uvm_analysis_port #(apb_transfer13) apb_out13;
  uvm_analysis_port #(uart_frame13) uart_rx_out13;
  uvm_analysis_port #(uart_frame13) uart_tx_out13;

  `uvm_component_utils_begin(uart_ctrl_monitor13)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports13(); // Create13 TLM Ports13
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif13.clock13) clk_period13 = $time;
    @(posedge vif13.clock13) clk_period13 = $time - clk_period13;
  endtask : run_phase
 
  // Additional13 class methods13
  extern virtual function void create_tlm_ports13();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx13(uart_frame13 frame13);
  extern virtual function void write_tx13(uart_frame13 frame13);
  extern virtual function void write_apb13(apb_transfer13 transfer13);
  extern virtual function void write_cfg13(uart_config13 uart_cfg13);
  extern virtual function void update_config13(uart_ctrl_config13 uart_ctrl_cfg13, int index);
  extern virtual function void set_slave_config13(apb_slave_config13 slave_cfg13, int index);
  extern virtual function void set_uart_config13(uart_config13 uart_cfg13);
endclass : uart_ctrl_monitor13

function void uart_ctrl_monitor13::create_tlm_ports13();
  apb_in13 = new("apb_in13", this);
  apb_out13 = new("apb_out13", this);
  uart_rx_in13 = new("uart_rx_in13", this);
  uart_rx_out13 = new("uart_rx_out13", this);
  uart_tx_in13 = new("uart_tx_in13", this);
  uart_tx_out13 = new("uart_tx_out13", this);
endfunction: create_tlm_ports13

function void uart_ctrl_monitor13::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover13 = uart_ctrl_cover13::type_id::create("uart_cover13",this);

  // Get13 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config13)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG13", "uart_ctrl_cfg13 is null...creating13 ", UVM_MEDIUM)
    cfg = uart_ctrl_config13::type_id::create("cfg", this);
    //set_config_object("tx_scbd13", "cfg", cfg);
    //set_config_object("rx_scbd13", "cfg", cfg);
  end
  //uvm_config_db#(uart_config13)::set(this, "*x_scbd13", "uart_cfg13", cfg.uart_cfg13);
  //uvm_config_db#(apb_slave_config13)::set(this, "*x_scbd13", "apb_slave_cfg13", cfg.apb_cfg13.slave_configs13[0]);
  uvm_config_object::set(this, "*x_scbd13", "uart_cfg13", cfg.uart_cfg13);
  uvm_config_object::set(this, "*x_scbd13", "apb_slave_cfg13", cfg.apb_cfg13.slave_configs13[0]);
  tx_scbd13 = uart_ctrl_tx_scbd13::type_id::create("tx_scbd13",this);
  rx_scbd13 = uart_ctrl_rx_scbd13::type_id::create("rx_scbd13",this);
endfunction : build_phase
   
function void uart_ctrl_monitor13::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get13 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if13)::get(this, "", "vif13", vif13))
      `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".vif13"})
  apb_out13.connect(tx_scbd13.apb_match13);
  uart_tx_out13.connect(tx_scbd13.uart_add13);
  apb_out13.connect(rx_scbd13.apb_add13);
  uart_rx_out13.connect(rx_scbd13.uart_match13);
endfunction : connect_phase

// implement UART13 Rx13 analysis13 port
function void uart_ctrl_monitor13::write_rx13(uart_frame13 frame13);
  uart_rx_out13.write(frame13);
  tx_time_in13 = tx_time_q13.pop_back();
  tx_time_out13 = ($time-tx_time_in13)/clk_period13;
endfunction : write_rx13
   
// implement UART13 Tx13 analysis13 port
function void uart_ctrl_monitor13::write_tx13(uart_frame13 frame13);
  uart_tx_out13.write(frame13);
  rx_time_q13.push_front($time); 
endfunction : write_tx13

// implement UART13 Config13 analysis13 port
function void uart_ctrl_monitor13::write_cfg13(uart_config13 uart_cfg13);
   set_uart_config13(uart_cfg13);
endfunction : write_cfg13

  // implement APB13 analysis13 port 
function void uart_ctrl_monitor13::write_apb13(apb_transfer13 transfer13);
    apb_out13.write(transfer13);
  if ((transfer13.direction13 == APB_READ13)  && (transfer13.addr == `RX_FIFO_REG13))
     begin
       rx_time_in13 = rx_time_q13.pop_back();
       rx_time_out13 = ($time-rx_time_in13)/clk_period13;
     end
  else if ((transfer13.direction13 == APB_WRITE13)  && (transfer13.addr == `TX_FIFO_REG13))
     begin
       tx_time_q13.push_front($time); 
     end
    
endfunction : write_apb13

function void uart_ctrl_monitor13::update_config13(uart_ctrl_config13 uart_ctrl_cfg13, int index);
  `uvm_info(get_type_name(), {"Updating Config13\n", uart_ctrl_cfg13.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg13;
   tx_scbd13.slave_cfg13 = uart_ctrl_cfg13.apb_cfg13.slave_configs13[index];
   tx_scbd13.uart_cfg13 = uart_ctrl_cfg13.uart_cfg13;
   rx_scbd13.slave_cfg13 = uart_ctrl_cfg13.apb_cfg13.slave_configs13[index];
   rx_scbd13.uart_cfg13 = uart_ctrl_cfg13.uart_cfg13;
endfunction : update_config13

function void uart_ctrl_monitor13::set_slave_config13(apb_slave_config13 slave_cfg13, int index);
   cfg.apb_cfg13.slave_configs13[index] = slave_cfg13;
   tx_scbd13.slave_cfg13 = slave_cfg13;
   rx_scbd13.slave_cfg13 = slave_cfg13;
endfunction : set_slave_config13

function void uart_ctrl_monitor13::set_uart_config13(uart_config13 uart_cfg13);
   cfg.uart_cfg13     = uart_cfg13;
   tx_scbd13.uart_cfg13 = uart_cfg13;
   rx_scbd13.uart_cfg13 = uart_cfg13;
endfunction : set_uart_config13
