/*-------------------------------------------------------------------------
File3 name   : uart_ctrl_monitor3.sv
Title3       : UART3 Controller3 Monitor3
Project3     :
Created3     :
Description3 : Module3 monitor3
Notes3       : 
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

// TLM Port3 Declarations3
`uvm_analysis_imp_decl(_rx3)
`uvm_analysis_imp_decl(_tx3)
`uvm_analysis_imp_decl(_cfg3)

class uart_ctrl_monitor3 extends uvm_monitor;

  // Virtual interface to DUT signals3 if necessary3 (OPTIONAL3)
  virtual interface uart_ctrl_internal_if3 vif3;

  time rx_time_q3[$];
  time tx_time_q3[$];
  time tx_time_out3, tx_time_in3, rx_time_out3, rx_time_in3, clk_period3;

  // UART3 Controller3 Configuration3 Information3
  uart_ctrl_config3 cfg;

  // UART3 Controller3 coverage3
  uart_ctrl_cover3 uart_cover3;

  // Scoreboards3
  uart_ctrl_tx_scbd3 tx_scbd3;
  uart_ctrl_rx_scbd3 rx_scbd3;

  // TLM Connections3 to the interface UVC3 monitors3
  uvm_analysis_imp_apb3 #(apb_transfer3, uart_ctrl_monitor3) apb_in3;
  uvm_analysis_imp_rx3 #(uart_frame3, uart_ctrl_monitor3) uart_rx_in3;
  uvm_analysis_imp_tx3 #(uart_frame3, uart_ctrl_monitor3) uart_tx_in3;
  uvm_analysis_imp_cfg3 #(uart_config3, uart_ctrl_monitor3) uart_cfg_in3;

  // TLM Connections3 to other Components (Scoreboard3, updated config)
  uvm_analysis_port #(apb_transfer3) apb_out3;
  uvm_analysis_port #(uart_frame3) uart_rx_out3;
  uvm_analysis_port #(uart_frame3) uart_tx_out3;

  `uvm_component_utils_begin(uart_ctrl_monitor3)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports3(); // Create3 TLM Ports3
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif3.clock3) clk_period3 = $time;
    @(posedge vif3.clock3) clk_period3 = $time - clk_period3;
  endtask : run_phase
 
  // Additional3 class methods3
  extern virtual function void create_tlm_ports3();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx3(uart_frame3 frame3);
  extern virtual function void write_tx3(uart_frame3 frame3);
  extern virtual function void write_apb3(apb_transfer3 transfer3);
  extern virtual function void write_cfg3(uart_config3 uart_cfg3);
  extern virtual function void update_config3(uart_ctrl_config3 uart_ctrl_cfg3, int index);
  extern virtual function void set_slave_config3(apb_slave_config3 slave_cfg3, int index);
  extern virtual function void set_uart_config3(uart_config3 uart_cfg3);
endclass : uart_ctrl_monitor3

function void uart_ctrl_monitor3::create_tlm_ports3();
  apb_in3 = new("apb_in3", this);
  apb_out3 = new("apb_out3", this);
  uart_rx_in3 = new("uart_rx_in3", this);
  uart_rx_out3 = new("uart_rx_out3", this);
  uart_tx_in3 = new("uart_tx_in3", this);
  uart_tx_out3 = new("uart_tx_out3", this);
endfunction: create_tlm_ports3

function void uart_ctrl_monitor3::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover3 = uart_ctrl_cover3::type_id::create("uart_cover3",this);

  // Get3 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config3)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG3", "uart_ctrl_cfg3 is null...creating3 ", UVM_MEDIUM)
    cfg = uart_ctrl_config3::type_id::create("cfg", this);
    //set_config_object("tx_scbd3", "cfg", cfg);
    //set_config_object("rx_scbd3", "cfg", cfg);
  end
  //uvm_config_db#(uart_config3)::set(this, "*x_scbd3", "uart_cfg3", cfg.uart_cfg3);
  //uvm_config_db#(apb_slave_config3)::set(this, "*x_scbd3", "apb_slave_cfg3", cfg.apb_cfg3.slave_configs3[0]);
  uvm_config_object::set(this, "*x_scbd3", "uart_cfg3", cfg.uart_cfg3);
  uvm_config_object::set(this, "*x_scbd3", "apb_slave_cfg3", cfg.apb_cfg3.slave_configs3[0]);
  tx_scbd3 = uart_ctrl_tx_scbd3::type_id::create("tx_scbd3",this);
  rx_scbd3 = uart_ctrl_rx_scbd3::type_id::create("rx_scbd3",this);
endfunction : build_phase
   
function void uart_ctrl_monitor3::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get3 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if3)::get(this, "", "vif3", vif3))
      `uvm_error("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".vif3"})
  apb_out3.connect(tx_scbd3.apb_match3);
  uart_tx_out3.connect(tx_scbd3.uart_add3);
  apb_out3.connect(rx_scbd3.apb_add3);
  uart_rx_out3.connect(rx_scbd3.uart_match3);
endfunction : connect_phase

// implement UART3 Rx3 analysis3 port
function void uart_ctrl_monitor3::write_rx3(uart_frame3 frame3);
  uart_rx_out3.write(frame3);
  tx_time_in3 = tx_time_q3.pop_back();
  tx_time_out3 = ($time-tx_time_in3)/clk_period3;
endfunction : write_rx3
   
// implement UART3 Tx3 analysis3 port
function void uart_ctrl_monitor3::write_tx3(uart_frame3 frame3);
  uart_tx_out3.write(frame3);
  rx_time_q3.push_front($time); 
endfunction : write_tx3

// implement UART3 Config3 analysis3 port
function void uart_ctrl_monitor3::write_cfg3(uart_config3 uart_cfg3);
   set_uart_config3(uart_cfg3);
endfunction : write_cfg3

  // implement APB3 analysis3 port 
function void uart_ctrl_monitor3::write_apb3(apb_transfer3 transfer3);
    apb_out3.write(transfer3);
  if ((transfer3.direction3 == APB_READ3)  && (transfer3.addr == `RX_FIFO_REG3))
     begin
       rx_time_in3 = rx_time_q3.pop_back();
       rx_time_out3 = ($time-rx_time_in3)/clk_period3;
     end
  else if ((transfer3.direction3 == APB_WRITE3)  && (transfer3.addr == `TX_FIFO_REG3))
     begin
       tx_time_q3.push_front($time); 
     end
    
endfunction : write_apb3

function void uart_ctrl_monitor3::update_config3(uart_ctrl_config3 uart_ctrl_cfg3, int index);
  `uvm_info(get_type_name(), {"Updating Config3\n", uart_ctrl_cfg3.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg3;
   tx_scbd3.slave_cfg3 = uart_ctrl_cfg3.apb_cfg3.slave_configs3[index];
   tx_scbd3.uart_cfg3 = uart_ctrl_cfg3.uart_cfg3;
   rx_scbd3.slave_cfg3 = uart_ctrl_cfg3.apb_cfg3.slave_configs3[index];
   rx_scbd3.uart_cfg3 = uart_ctrl_cfg3.uart_cfg3;
endfunction : update_config3

function void uart_ctrl_monitor3::set_slave_config3(apb_slave_config3 slave_cfg3, int index);
   cfg.apb_cfg3.slave_configs3[index] = slave_cfg3;
   tx_scbd3.slave_cfg3 = slave_cfg3;
   rx_scbd3.slave_cfg3 = slave_cfg3;
endfunction : set_slave_config3

function void uart_ctrl_monitor3::set_uart_config3(uart_config3 uart_cfg3);
   cfg.uart_cfg3     = uart_cfg3;
   tx_scbd3.uart_cfg3 = uart_cfg3;
   rx_scbd3.uart_cfg3 = uart_cfg3;
endfunction : set_uart_config3
