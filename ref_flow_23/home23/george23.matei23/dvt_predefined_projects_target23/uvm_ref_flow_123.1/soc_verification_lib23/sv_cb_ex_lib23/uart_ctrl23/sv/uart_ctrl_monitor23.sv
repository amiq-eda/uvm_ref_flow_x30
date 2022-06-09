/*-------------------------------------------------------------------------
File23 name   : uart_ctrl_monitor23.sv
Title23       : UART23 Controller23 Monitor23
Project23     :
Created23     :
Description23 : Module23 monitor23
Notes23       : 
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

// TLM Port23 Declarations23
`uvm_analysis_imp_decl(_rx23)
`uvm_analysis_imp_decl(_tx23)
`uvm_analysis_imp_decl(_cfg23)

class uart_ctrl_monitor23 extends uvm_monitor;

  // Virtual interface to DUT signals23 if necessary23 (OPTIONAL23)
  virtual interface uart_ctrl_internal_if23 vif23;

  time rx_time_q23[$];
  time tx_time_q23[$];
  time tx_time_out23, tx_time_in23, rx_time_out23, rx_time_in23, clk_period23;

  // UART23 Controller23 Configuration23 Information23
  uart_ctrl_config23 cfg;

  // UART23 Controller23 coverage23
  uart_ctrl_cover23 uart_cover23;

  // Scoreboards23
  uart_ctrl_tx_scbd23 tx_scbd23;
  uart_ctrl_rx_scbd23 rx_scbd23;

  // TLM Connections23 to the interface UVC23 monitors23
  uvm_analysis_imp_apb23 #(apb_transfer23, uart_ctrl_monitor23) apb_in23;
  uvm_analysis_imp_rx23 #(uart_frame23, uart_ctrl_monitor23) uart_rx_in23;
  uvm_analysis_imp_tx23 #(uart_frame23, uart_ctrl_monitor23) uart_tx_in23;
  uvm_analysis_imp_cfg23 #(uart_config23, uart_ctrl_monitor23) uart_cfg_in23;

  // TLM Connections23 to other Components (Scoreboard23, updated config)
  uvm_analysis_port #(apb_transfer23) apb_out23;
  uvm_analysis_port #(uart_frame23) uart_rx_out23;
  uvm_analysis_port #(uart_frame23) uart_tx_out23;

  `uvm_component_utils_begin(uart_ctrl_monitor23)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports23(); // Create23 TLM Ports23
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif23.clock23) clk_period23 = $time;
    @(posedge vif23.clock23) clk_period23 = $time - clk_period23;
  endtask : run_phase
 
  // Additional23 class methods23
  extern virtual function void create_tlm_ports23();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx23(uart_frame23 frame23);
  extern virtual function void write_tx23(uart_frame23 frame23);
  extern virtual function void write_apb23(apb_transfer23 transfer23);
  extern virtual function void write_cfg23(uart_config23 uart_cfg23);
  extern virtual function void update_config23(uart_ctrl_config23 uart_ctrl_cfg23, int index);
  extern virtual function void set_slave_config23(apb_slave_config23 slave_cfg23, int index);
  extern virtual function void set_uart_config23(uart_config23 uart_cfg23);
endclass : uart_ctrl_monitor23

function void uart_ctrl_monitor23::create_tlm_ports23();
  apb_in23 = new("apb_in23", this);
  apb_out23 = new("apb_out23", this);
  uart_rx_in23 = new("uart_rx_in23", this);
  uart_rx_out23 = new("uart_rx_out23", this);
  uart_tx_in23 = new("uart_tx_in23", this);
  uart_tx_out23 = new("uart_tx_out23", this);
endfunction: create_tlm_ports23

function void uart_ctrl_monitor23::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover23 = uart_ctrl_cover23::type_id::create("uart_cover23",this);

  // Get23 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config23)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG23", "uart_ctrl_cfg23 is null...creating23 ", UVM_MEDIUM)
    cfg = uart_ctrl_config23::type_id::create("cfg", this);
    //set_config_object("tx_scbd23", "cfg", cfg);
    //set_config_object("rx_scbd23", "cfg", cfg);
  end
  //uvm_config_db#(uart_config23)::set(this, "*x_scbd23", "uart_cfg23", cfg.uart_cfg23);
  //uvm_config_db#(apb_slave_config23)::set(this, "*x_scbd23", "apb_slave_cfg23", cfg.apb_cfg23.slave_configs23[0]);
  uvm_config_object::set(this, "*x_scbd23", "uart_cfg23", cfg.uart_cfg23);
  uvm_config_object::set(this, "*x_scbd23", "apb_slave_cfg23", cfg.apb_cfg23.slave_configs23[0]);
  tx_scbd23 = uart_ctrl_tx_scbd23::type_id::create("tx_scbd23",this);
  rx_scbd23 = uart_ctrl_rx_scbd23::type_id::create("rx_scbd23",this);
endfunction : build_phase
   
function void uart_ctrl_monitor23::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get23 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if23)::get(this, "", "vif23", vif23))
      `uvm_error("NOVIF23",{"virtual interface must be set for: ",get_full_name(),".vif23"})
  apb_out23.connect(tx_scbd23.apb_match23);
  uart_tx_out23.connect(tx_scbd23.uart_add23);
  apb_out23.connect(rx_scbd23.apb_add23);
  uart_rx_out23.connect(rx_scbd23.uart_match23);
endfunction : connect_phase

// implement UART23 Rx23 analysis23 port
function void uart_ctrl_monitor23::write_rx23(uart_frame23 frame23);
  uart_rx_out23.write(frame23);
  tx_time_in23 = tx_time_q23.pop_back();
  tx_time_out23 = ($time-tx_time_in23)/clk_period23;
endfunction : write_rx23
   
// implement UART23 Tx23 analysis23 port
function void uart_ctrl_monitor23::write_tx23(uart_frame23 frame23);
  uart_tx_out23.write(frame23);
  rx_time_q23.push_front($time); 
endfunction : write_tx23

// implement UART23 Config23 analysis23 port
function void uart_ctrl_monitor23::write_cfg23(uart_config23 uart_cfg23);
   set_uart_config23(uart_cfg23);
endfunction : write_cfg23

  // implement APB23 analysis23 port 
function void uart_ctrl_monitor23::write_apb23(apb_transfer23 transfer23);
    apb_out23.write(transfer23);
  if ((transfer23.direction23 == APB_READ23)  && (transfer23.addr == `RX_FIFO_REG23))
     begin
       rx_time_in23 = rx_time_q23.pop_back();
       rx_time_out23 = ($time-rx_time_in23)/clk_period23;
     end
  else if ((transfer23.direction23 == APB_WRITE23)  && (transfer23.addr == `TX_FIFO_REG23))
     begin
       tx_time_q23.push_front($time); 
     end
    
endfunction : write_apb23

function void uart_ctrl_monitor23::update_config23(uart_ctrl_config23 uart_ctrl_cfg23, int index);
  `uvm_info(get_type_name(), {"Updating Config23\n", uart_ctrl_cfg23.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg23;
   tx_scbd23.slave_cfg23 = uart_ctrl_cfg23.apb_cfg23.slave_configs23[index];
   tx_scbd23.uart_cfg23 = uart_ctrl_cfg23.uart_cfg23;
   rx_scbd23.slave_cfg23 = uart_ctrl_cfg23.apb_cfg23.slave_configs23[index];
   rx_scbd23.uart_cfg23 = uart_ctrl_cfg23.uart_cfg23;
endfunction : update_config23

function void uart_ctrl_monitor23::set_slave_config23(apb_slave_config23 slave_cfg23, int index);
   cfg.apb_cfg23.slave_configs23[index] = slave_cfg23;
   tx_scbd23.slave_cfg23 = slave_cfg23;
   rx_scbd23.slave_cfg23 = slave_cfg23;
endfunction : set_slave_config23

function void uart_ctrl_monitor23::set_uart_config23(uart_config23 uart_cfg23);
   cfg.uart_cfg23     = uart_cfg23;
   tx_scbd23.uart_cfg23 = uart_cfg23;
   rx_scbd23.uart_cfg23 = uart_cfg23;
endfunction : set_uart_config23
