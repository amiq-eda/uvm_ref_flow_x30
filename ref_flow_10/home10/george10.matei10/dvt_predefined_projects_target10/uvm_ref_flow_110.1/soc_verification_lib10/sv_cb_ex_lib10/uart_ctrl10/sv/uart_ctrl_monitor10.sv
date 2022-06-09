/*-------------------------------------------------------------------------
File10 name   : uart_ctrl_monitor10.sv
Title10       : UART10 Controller10 Monitor10
Project10     :
Created10     :
Description10 : Module10 monitor10
Notes10       : 
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

// TLM Port10 Declarations10
`uvm_analysis_imp_decl(_rx10)
`uvm_analysis_imp_decl(_tx10)
`uvm_analysis_imp_decl(_cfg10)

class uart_ctrl_monitor10 extends uvm_monitor;

  // Virtual interface to DUT signals10 if necessary10 (OPTIONAL10)
  virtual interface uart_ctrl_internal_if10 vif10;

  time rx_time_q10[$];
  time tx_time_q10[$];
  time tx_time_out10, tx_time_in10, rx_time_out10, rx_time_in10, clk_period10;

  // UART10 Controller10 Configuration10 Information10
  uart_ctrl_config10 cfg;

  // UART10 Controller10 coverage10
  uart_ctrl_cover10 uart_cover10;

  // Scoreboards10
  uart_ctrl_tx_scbd10 tx_scbd10;
  uart_ctrl_rx_scbd10 rx_scbd10;

  // TLM Connections10 to the interface UVC10 monitors10
  uvm_analysis_imp_apb10 #(apb_transfer10, uart_ctrl_monitor10) apb_in10;
  uvm_analysis_imp_rx10 #(uart_frame10, uart_ctrl_monitor10) uart_rx_in10;
  uvm_analysis_imp_tx10 #(uart_frame10, uart_ctrl_monitor10) uart_tx_in10;
  uvm_analysis_imp_cfg10 #(uart_config10, uart_ctrl_monitor10) uart_cfg_in10;

  // TLM Connections10 to other Components (Scoreboard10, updated config)
  uvm_analysis_port #(apb_transfer10) apb_out10;
  uvm_analysis_port #(uart_frame10) uart_rx_out10;
  uvm_analysis_port #(uart_frame10) uart_tx_out10;

  `uvm_component_utils_begin(uart_ctrl_monitor10)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports10(); // Create10 TLM Ports10
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif10.clock10) clk_period10 = $time;
    @(posedge vif10.clock10) clk_period10 = $time - clk_period10;
  endtask : run_phase
 
  // Additional10 class methods10
  extern virtual function void create_tlm_ports10();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx10(uart_frame10 frame10);
  extern virtual function void write_tx10(uart_frame10 frame10);
  extern virtual function void write_apb10(apb_transfer10 transfer10);
  extern virtual function void write_cfg10(uart_config10 uart_cfg10);
  extern virtual function void update_config10(uart_ctrl_config10 uart_ctrl_cfg10, int index);
  extern virtual function void set_slave_config10(apb_slave_config10 slave_cfg10, int index);
  extern virtual function void set_uart_config10(uart_config10 uart_cfg10);
endclass : uart_ctrl_monitor10

function void uart_ctrl_monitor10::create_tlm_ports10();
  apb_in10 = new("apb_in10", this);
  apb_out10 = new("apb_out10", this);
  uart_rx_in10 = new("uart_rx_in10", this);
  uart_rx_out10 = new("uart_rx_out10", this);
  uart_tx_in10 = new("uart_tx_in10", this);
  uart_tx_out10 = new("uart_tx_out10", this);
endfunction: create_tlm_ports10

function void uart_ctrl_monitor10::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover10 = uart_ctrl_cover10::type_id::create("uart_cover10",this);

  // Get10 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config10)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG10", "uart_ctrl_cfg10 is null...creating10 ", UVM_MEDIUM)
    cfg = uart_ctrl_config10::type_id::create("cfg", this);
    //set_config_object("tx_scbd10", "cfg", cfg);
    //set_config_object("rx_scbd10", "cfg", cfg);
  end
  //uvm_config_db#(uart_config10)::set(this, "*x_scbd10", "uart_cfg10", cfg.uart_cfg10);
  //uvm_config_db#(apb_slave_config10)::set(this, "*x_scbd10", "apb_slave_cfg10", cfg.apb_cfg10.slave_configs10[0]);
  uvm_config_object::set(this, "*x_scbd10", "uart_cfg10", cfg.uart_cfg10);
  uvm_config_object::set(this, "*x_scbd10", "apb_slave_cfg10", cfg.apb_cfg10.slave_configs10[0]);
  tx_scbd10 = uart_ctrl_tx_scbd10::type_id::create("tx_scbd10",this);
  rx_scbd10 = uart_ctrl_rx_scbd10::type_id::create("rx_scbd10",this);
endfunction : build_phase
   
function void uart_ctrl_monitor10::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get10 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if10)::get(this, "", "vif10", vif10))
      `uvm_error("NOVIF10",{"virtual interface must be set for: ",get_full_name(),".vif10"})
  apb_out10.connect(tx_scbd10.apb_match10);
  uart_tx_out10.connect(tx_scbd10.uart_add10);
  apb_out10.connect(rx_scbd10.apb_add10);
  uart_rx_out10.connect(rx_scbd10.uart_match10);
endfunction : connect_phase

// implement UART10 Rx10 analysis10 port
function void uart_ctrl_monitor10::write_rx10(uart_frame10 frame10);
  uart_rx_out10.write(frame10);
  tx_time_in10 = tx_time_q10.pop_back();
  tx_time_out10 = ($time-tx_time_in10)/clk_period10;
endfunction : write_rx10
   
// implement UART10 Tx10 analysis10 port
function void uart_ctrl_monitor10::write_tx10(uart_frame10 frame10);
  uart_tx_out10.write(frame10);
  rx_time_q10.push_front($time); 
endfunction : write_tx10

// implement UART10 Config10 analysis10 port
function void uart_ctrl_monitor10::write_cfg10(uart_config10 uart_cfg10);
   set_uart_config10(uart_cfg10);
endfunction : write_cfg10

  // implement APB10 analysis10 port 
function void uart_ctrl_monitor10::write_apb10(apb_transfer10 transfer10);
    apb_out10.write(transfer10);
  if ((transfer10.direction10 == APB_READ10)  && (transfer10.addr == `RX_FIFO_REG10))
     begin
       rx_time_in10 = rx_time_q10.pop_back();
       rx_time_out10 = ($time-rx_time_in10)/clk_period10;
     end
  else if ((transfer10.direction10 == APB_WRITE10)  && (transfer10.addr == `TX_FIFO_REG10))
     begin
       tx_time_q10.push_front($time); 
     end
    
endfunction : write_apb10

function void uart_ctrl_monitor10::update_config10(uart_ctrl_config10 uart_ctrl_cfg10, int index);
  `uvm_info(get_type_name(), {"Updating Config10\n", uart_ctrl_cfg10.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg10;
   tx_scbd10.slave_cfg10 = uart_ctrl_cfg10.apb_cfg10.slave_configs10[index];
   tx_scbd10.uart_cfg10 = uart_ctrl_cfg10.uart_cfg10;
   rx_scbd10.slave_cfg10 = uart_ctrl_cfg10.apb_cfg10.slave_configs10[index];
   rx_scbd10.uart_cfg10 = uart_ctrl_cfg10.uart_cfg10;
endfunction : update_config10

function void uart_ctrl_monitor10::set_slave_config10(apb_slave_config10 slave_cfg10, int index);
   cfg.apb_cfg10.slave_configs10[index] = slave_cfg10;
   tx_scbd10.slave_cfg10 = slave_cfg10;
   rx_scbd10.slave_cfg10 = slave_cfg10;
endfunction : set_slave_config10

function void uart_ctrl_monitor10::set_uart_config10(uart_config10 uart_cfg10);
   cfg.uart_cfg10     = uart_cfg10;
   tx_scbd10.uart_cfg10 = uart_cfg10;
   rx_scbd10.uart_cfg10 = uart_cfg10;
endfunction : set_uart_config10
