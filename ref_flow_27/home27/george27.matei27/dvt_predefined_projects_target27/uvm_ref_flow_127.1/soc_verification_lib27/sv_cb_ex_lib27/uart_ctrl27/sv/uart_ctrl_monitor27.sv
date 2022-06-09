/*-------------------------------------------------------------------------
File27 name   : uart_ctrl_monitor27.sv
Title27       : UART27 Controller27 Monitor27
Project27     :
Created27     :
Description27 : Module27 monitor27
Notes27       : 
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

// TLM Port27 Declarations27
`uvm_analysis_imp_decl(_rx27)
`uvm_analysis_imp_decl(_tx27)
`uvm_analysis_imp_decl(_cfg27)

class uart_ctrl_monitor27 extends uvm_monitor;

  // Virtual interface to DUT signals27 if necessary27 (OPTIONAL27)
  virtual interface uart_ctrl_internal_if27 vif27;

  time rx_time_q27[$];
  time tx_time_q27[$];
  time tx_time_out27, tx_time_in27, rx_time_out27, rx_time_in27, clk_period27;

  // UART27 Controller27 Configuration27 Information27
  uart_ctrl_config27 cfg;

  // UART27 Controller27 coverage27
  uart_ctrl_cover27 uart_cover27;

  // Scoreboards27
  uart_ctrl_tx_scbd27 tx_scbd27;
  uart_ctrl_rx_scbd27 rx_scbd27;

  // TLM Connections27 to the interface UVC27 monitors27
  uvm_analysis_imp_apb27 #(apb_transfer27, uart_ctrl_monitor27) apb_in27;
  uvm_analysis_imp_rx27 #(uart_frame27, uart_ctrl_monitor27) uart_rx_in27;
  uvm_analysis_imp_tx27 #(uart_frame27, uart_ctrl_monitor27) uart_tx_in27;
  uvm_analysis_imp_cfg27 #(uart_config27, uart_ctrl_monitor27) uart_cfg_in27;

  // TLM Connections27 to other Components (Scoreboard27, updated config)
  uvm_analysis_port #(apb_transfer27) apb_out27;
  uvm_analysis_port #(uart_frame27) uart_rx_out27;
  uvm_analysis_port #(uart_frame27) uart_tx_out27;

  `uvm_component_utils_begin(uart_ctrl_monitor27)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports27(); // Create27 TLM Ports27
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif27.clock27) clk_period27 = $time;
    @(posedge vif27.clock27) clk_period27 = $time - clk_period27;
  endtask : run_phase
 
  // Additional27 class methods27
  extern virtual function void create_tlm_ports27();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx27(uart_frame27 frame27);
  extern virtual function void write_tx27(uart_frame27 frame27);
  extern virtual function void write_apb27(apb_transfer27 transfer27);
  extern virtual function void write_cfg27(uart_config27 uart_cfg27);
  extern virtual function void update_config27(uart_ctrl_config27 uart_ctrl_cfg27, int index);
  extern virtual function void set_slave_config27(apb_slave_config27 slave_cfg27, int index);
  extern virtual function void set_uart_config27(uart_config27 uart_cfg27);
endclass : uart_ctrl_monitor27

function void uart_ctrl_monitor27::create_tlm_ports27();
  apb_in27 = new("apb_in27", this);
  apb_out27 = new("apb_out27", this);
  uart_rx_in27 = new("uart_rx_in27", this);
  uart_rx_out27 = new("uart_rx_out27", this);
  uart_tx_in27 = new("uart_tx_in27", this);
  uart_tx_out27 = new("uart_tx_out27", this);
endfunction: create_tlm_ports27

function void uart_ctrl_monitor27::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover27 = uart_ctrl_cover27::type_id::create("uart_cover27",this);

  // Get27 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config27)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG27", "uart_ctrl_cfg27 is null...creating27 ", UVM_MEDIUM)
    cfg = uart_ctrl_config27::type_id::create("cfg", this);
    //set_config_object("tx_scbd27", "cfg", cfg);
    //set_config_object("rx_scbd27", "cfg", cfg);
  end
  //uvm_config_db#(uart_config27)::set(this, "*x_scbd27", "uart_cfg27", cfg.uart_cfg27);
  //uvm_config_db#(apb_slave_config27)::set(this, "*x_scbd27", "apb_slave_cfg27", cfg.apb_cfg27.slave_configs27[0]);
  uvm_config_object::set(this, "*x_scbd27", "uart_cfg27", cfg.uart_cfg27);
  uvm_config_object::set(this, "*x_scbd27", "apb_slave_cfg27", cfg.apb_cfg27.slave_configs27[0]);
  tx_scbd27 = uart_ctrl_tx_scbd27::type_id::create("tx_scbd27",this);
  rx_scbd27 = uart_ctrl_rx_scbd27::type_id::create("rx_scbd27",this);
endfunction : build_phase
   
function void uart_ctrl_monitor27::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get27 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if27)::get(this, "", "vif27", vif27))
      `uvm_error("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".vif27"})
  apb_out27.connect(tx_scbd27.apb_match27);
  uart_tx_out27.connect(tx_scbd27.uart_add27);
  apb_out27.connect(rx_scbd27.apb_add27);
  uart_rx_out27.connect(rx_scbd27.uart_match27);
endfunction : connect_phase

// implement UART27 Rx27 analysis27 port
function void uart_ctrl_monitor27::write_rx27(uart_frame27 frame27);
  uart_rx_out27.write(frame27);
  tx_time_in27 = tx_time_q27.pop_back();
  tx_time_out27 = ($time-tx_time_in27)/clk_period27;
endfunction : write_rx27
   
// implement UART27 Tx27 analysis27 port
function void uart_ctrl_monitor27::write_tx27(uart_frame27 frame27);
  uart_tx_out27.write(frame27);
  rx_time_q27.push_front($time); 
endfunction : write_tx27

// implement UART27 Config27 analysis27 port
function void uart_ctrl_monitor27::write_cfg27(uart_config27 uart_cfg27);
   set_uart_config27(uart_cfg27);
endfunction : write_cfg27

  // implement APB27 analysis27 port 
function void uart_ctrl_monitor27::write_apb27(apb_transfer27 transfer27);
    apb_out27.write(transfer27);
  if ((transfer27.direction27 == APB_READ27)  && (transfer27.addr == `RX_FIFO_REG27))
     begin
       rx_time_in27 = rx_time_q27.pop_back();
       rx_time_out27 = ($time-rx_time_in27)/clk_period27;
     end
  else if ((transfer27.direction27 == APB_WRITE27)  && (transfer27.addr == `TX_FIFO_REG27))
     begin
       tx_time_q27.push_front($time); 
     end
    
endfunction : write_apb27

function void uart_ctrl_monitor27::update_config27(uart_ctrl_config27 uart_ctrl_cfg27, int index);
  `uvm_info(get_type_name(), {"Updating Config27\n", uart_ctrl_cfg27.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg27;
   tx_scbd27.slave_cfg27 = uart_ctrl_cfg27.apb_cfg27.slave_configs27[index];
   tx_scbd27.uart_cfg27 = uart_ctrl_cfg27.uart_cfg27;
   rx_scbd27.slave_cfg27 = uart_ctrl_cfg27.apb_cfg27.slave_configs27[index];
   rx_scbd27.uart_cfg27 = uart_ctrl_cfg27.uart_cfg27;
endfunction : update_config27

function void uart_ctrl_monitor27::set_slave_config27(apb_slave_config27 slave_cfg27, int index);
   cfg.apb_cfg27.slave_configs27[index] = slave_cfg27;
   tx_scbd27.slave_cfg27 = slave_cfg27;
   rx_scbd27.slave_cfg27 = slave_cfg27;
endfunction : set_slave_config27

function void uart_ctrl_monitor27::set_uart_config27(uart_config27 uart_cfg27);
   cfg.uart_cfg27     = uart_cfg27;
   tx_scbd27.uart_cfg27 = uart_cfg27;
   rx_scbd27.uart_cfg27 = uart_cfg27;
endfunction : set_uart_config27
