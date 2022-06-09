/*-------------------------------------------------------------------------
File11 name   : uart_ctrl_monitor11.sv
Title11       : UART11 Controller11 Monitor11
Project11     :
Created11     :
Description11 : Module11 monitor11
Notes11       : 
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

// TLM Port11 Declarations11
`uvm_analysis_imp_decl(_rx11)
`uvm_analysis_imp_decl(_tx11)
`uvm_analysis_imp_decl(_cfg11)

class uart_ctrl_monitor11 extends uvm_monitor;

  // Virtual interface to DUT signals11 if necessary11 (OPTIONAL11)
  virtual interface uart_ctrl_internal_if11 vif11;

  time rx_time_q11[$];
  time tx_time_q11[$];
  time tx_time_out11, tx_time_in11, rx_time_out11, rx_time_in11, clk_period11;

  // UART11 Controller11 Configuration11 Information11
  uart_ctrl_config11 cfg;

  // UART11 Controller11 coverage11
  uart_ctrl_cover11 uart_cover11;

  // Scoreboards11
  uart_ctrl_tx_scbd11 tx_scbd11;
  uart_ctrl_rx_scbd11 rx_scbd11;

  // TLM Connections11 to the interface UVC11 monitors11
  uvm_analysis_imp_apb11 #(apb_transfer11, uart_ctrl_monitor11) apb_in11;
  uvm_analysis_imp_rx11 #(uart_frame11, uart_ctrl_monitor11) uart_rx_in11;
  uvm_analysis_imp_tx11 #(uart_frame11, uart_ctrl_monitor11) uart_tx_in11;
  uvm_analysis_imp_cfg11 #(uart_config11, uart_ctrl_monitor11) uart_cfg_in11;

  // TLM Connections11 to other Components (Scoreboard11, updated config)
  uvm_analysis_port #(apb_transfer11) apb_out11;
  uvm_analysis_port #(uart_frame11) uart_rx_out11;
  uvm_analysis_port #(uart_frame11) uart_tx_out11;

  `uvm_component_utils_begin(uart_ctrl_monitor11)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports11(); // Create11 TLM Ports11
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif11.clock11) clk_period11 = $time;
    @(posedge vif11.clock11) clk_period11 = $time - clk_period11;
  endtask : run_phase
 
  // Additional11 class methods11
  extern virtual function void create_tlm_ports11();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx11(uart_frame11 frame11);
  extern virtual function void write_tx11(uart_frame11 frame11);
  extern virtual function void write_apb11(apb_transfer11 transfer11);
  extern virtual function void write_cfg11(uart_config11 uart_cfg11);
  extern virtual function void update_config11(uart_ctrl_config11 uart_ctrl_cfg11, int index);
  extern virtual function void set_slave_config11(apb_slave_config11 slave_cfg11, int index);
  extern virtual function void set_uart_config11(uart_config11 uart_cfg11);
endclass : uart_ctrl_monitor11

function void uart_ctrl_monitor11::create_tlm_ports11();
  apb_in11 = new("apb_in11", this);
  apb_out11 = new("apb_out11", this);
  uart_rx_in11 = new("uart_rx_in11", this);
  uart_rx_out11 = new("uart_rx_out11", this);
  uart_tx_in11 = new("uart_tx_in11", this);
  uart_tx_out11 = new("uart_tx_out11", this);
endfunction: create_tlm_ports11

function void uart_ctrl_monitor11::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover11 = uart_ctrl_cover11::type_id::create("uart_cover11",this);

  // Get11 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config11)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG11", "uart_ctrl_cfg11 is null...creating11 ", UVM_MEDIUM)
    cfg = uart_ctrl_config11::type_id::create("cfg", this);
    //set_config_object("tx_scbd11", "cfg", cfg);
    //set_config_object("rx_scbd11", "cfg", cfg);
  end
  //uvm_config_db#(uart_config11)::set(this, "*x_scbd11", "uart_cfg11", cfg.uart_cfg11);
  //uvm_config_db#(apb_slave_config11)::set(this, "*x_scbd11", "apb_slave_cfg11", cfg.apb_cfg11.slave_configs11[0]);
  uvm_config_object::set(this, "*x_scbd11", "uart_cfg11", cfg.uart_cfg11);
  uvm_config_object::set(this, "*x_scbd11", "apb_slave_cfg11", cfg.apb_cfg11.slave_configs11[0]);
  tx_scbd11 = uart_ctrl_tx_scbd11::type_id::create("tx_scbd11",this);
  rx_scbd11 = uart_ctrl_rx_scbd11::type_id::create("rx_scbd11",this);
endfunction : build_phase
   
function void uart_ctrl_monitor11::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get11 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if11)::get(this, "", "vif11", vif11))
      `uvm_error("NOVIF11",{"virtual interface must be set for: ",get_full_name(),".vif11"})
  apb_out11.connect(tx_scbd11.apb_match11);
  uart_tx_out11.connect(tx_scbd11.uart_add11);
  apb_out11.connect(rx_scbd11.apb_add11);
  uart_rx_out11.connect(rx_scbd11.uart_match11);
endfunction : connect_phase

// implement UART11 Rx11 analysis11 port
function void uart_ctrl_monitor11::write_rx11(uart_frame11 frame11);
  uart_rx_out11.write(frame11);
  tx_time_in11 = tx_time_q11.pop_back();
  tx_time_out11 = ($time-tx_time_in11)/clk_period11;
endfunction : write_rx11
   
// implement UART11 Tx11 analysis11 port
function void uart_ctrl_monitor11::write_tx11(uart_frame11 frame11);
  uart_tx_out11.write(frame11);
  rx_time_q11.push_front($time); 
endfunction : write_tx11

// implement UART11 Config11 analysis11 port
function void uart_ctrl_monitor11::write_cfg11(uart_config11 uart_cfg11);
   set_uart_config11(uart_cfg11);
endfunction : write_cfg11

  // implement APB11 analysis11 port 
function void uart_ctrl_monitor11::write_apb11(apb_transfer11 transfer11);
    apb_out11.write(transfer11);
  if ((transfer11.direction11 == APB_READ11)  && (transfer11.addr == `RX_FIFO_REG11))
     begin
       rx_time_in11 = rx_time_q11.pop_back();
       rx_time_out11 = ($time-rx_time_in11)/clk_period11;
     end
  else if ((transfer11.direction11 == APB_WRITE11)  && (transfer11.addr == `TX_FIFO_REG11))
     begin
       tx_time_q11.push_front($time); 
     end
    
endfunction : write_apb11

function void uart_ctrl_monitor11::update_config11(uart_ctrl_config11 uart_ctrl_cfg11, int index);
  `uvm_info(get_type_name(), {"Updating Config11\n", uart_ctrl_cfg11.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg11;
   tx_scbd11.slave_cfg11 = uart_ctrl_cfg11.apb_cfg11.slave_configs11[index];
   tx_scbd11.uart_cfg11 = uart_ctrl_cfg11.uart_cfg11;
   rx_scbd11.slave_cfg11 = uart_ctrl_cfg11.apb_cfg11.slave_configs11[index];
   rx_scbd11.uart_cfg11 = uart_ctrl_cfg11.uart_cfg11;
endfunction : update_config11

function void uart_ctrl_monitor11::set_slave_config11(apb_slave_config11 slave_cfg11, int index);
   cfg.apb_cfg11.slave_configs11[index] = slave_cfg11;
   tx_scbd11.slave_cfg11 = slave_cfg11;
   rx_scbd11.slave_cfg11 = slave_cfg11;
endfunction : set_slave_config11

function void uart_ctrl_monitor11::set_uart_config11(uart_config11 uart_cfg11);
   cfg.uart_cfg11     = uart_cfg11;
   tx_scbd11.uart_cfg11 = uart_cfg11;
   rx_scbd11.uart_cfg11 = uart_cfg11;
endfunction : set_uart_config11
