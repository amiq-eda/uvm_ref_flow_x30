/*-------------------------------------------------------------------------
File26 name   : uart_ctrl_monitor26.sv
Title26       : UART26 Controller26 Monitor26
Project26     :
Created26     :
Description26 : Module26 monitor26
Notes26       : 
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

// TLM Port26 Declarations26
`uvm_analysis_imp_decl(_rx26)
`uvm_analysis_imp_decl(_tx26)
`uvm_analysis_imp_decl(_cfg26)

class uart_ctrl_monitor26 extends uvm_monitor;

  // Virtual interface to DUT signals26 if necessary26 (OPTIONAL26)
  virtual interface uart_ctrl_internal_if26 vif26;

  time rx_time_q26[$];
  time tx_time_q26[$];
  time tx_time_out26, tx_time_in26, rx_time_out26, rx_time_in26, clk_period26;

  // UART26 Controller26 Configuration26 Information26
  uart_ctrl_config26 cfg;

  // UART26 Controller26 coverage26
  uart_ctrl_cover26 uart_cover26;

  // Scoreboards26
  uart_ctrl_tx_scbd26 tx_scbd26;
  uart_ctrl_rx_scbd26 rx_scbd26;

  // TLM Connections26 to the interface UVC26 monitors26
  uvm_analysis_imp_apb26 #(apb_transfer26, uart_ctrl_monitor26) apb_in26;
  uvm_analysis_imp_rx26 #(uart_frame26, uart_ctrl_monitor26) uart_rx_in26;
  uvm_analysis_imp_tx26 #(uart_frame26, uart_ctrl_monitor26) uart_tx_in26;
  uvm_analysis_imp_cfg26 #(uart_config26, uart_ctrl_monitor26) uart_cfg_in26;

  // TLM Connections26 to other Components (Scoreboard26, updated config)
  uvm_analysis_port #(apb_transfer26) apb_out26;
  uvm_analysis_port #(uart_frame26) uart_rx_out26;
  uvm_analysis_port #(uart_frame26) uart_tx_out26;

  `uvm_component_utils_begin(uart_ctrl_monitor26)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports26(); // Create26 TLM Ports26
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif26.clock26) clk_period26 = $time;
    @(posedge vif26.clock26) clk_period26 = $time - clk_period26;
  endtask : run_phase
 
  // Additional26 class methods26
  extern virtual function void create_tlm_ports26();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx26(uart_frame26 frame26);
  extern virtual function void write_tx26(uart_frame26 frame26);
  extern virtual function void write_apb26(apb_transfer26 transfer26);
  extern virtual function void write_cfg26(uart_config26 uart_cfg26);
  extern virtual function void update_config26(uart_ctrl_config26 uart_ctrl_cfg26, int index);
  extern virtual function void set_slave_config26(apb_slave_config26 slave_cfg26, int index);
  extern virtual function void set_uart_config26(uart_config26 uart_cfg26);
endclass : uart_ctrl_monitor26

function void uart_ctrl_monitor26::create_tlm_ports26();
  apb_in26 = new("apb_in26", this);
  apb_out26 = new("apb_out26", this);
  uart_rx_in26 = new("uart_rx_in26", this);
  uart_rx_out26 = new("uart_rx_out26", this);
  uart_tx_in26 = new("uart_tx_in26", this);
  uart_tx_out26 = new("uart_tx_out26", this);
endfunction: create_tlm_ports26

function void uart_ctrl_monitor26::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover26 = uart_ctrl_cover26::type_id::create("uart_cover26",this);

  // Get26 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config26)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG26", "uart_ctrl_cfg26 is null...creating26 ", UVM_MEDIUM)
    cfg = uart_ctrl_config26::type_id::create("cfg", this);
    //set_config_object("tx_scbd26", "cfg", cfg);
    //set_config_object("rx_scbd26", "cfg", cfg);
  end
  //uvm_config_db#(uart_config26)::set(this, "*x_scbd26", "uart_cfg26", cfg.uart_cfg26);
  //uvm_config_db#(apb_slave_config26)::set(this, "*x_scbd26", "apb_slave_cfg26", cfg.apb_cfg26.slave_configs26[0]);
  uvm_config_object::set(this, "*x_scbd26", "uart_cfg26", cfg.uart_cfg26);
  uvm_config_object::set(this, "*x_scbd26", "apb_slave_cfg26", cfg.apb_cfg26.slave_configs26[0]);
  tx_scbd26 = uart_ctrl_tx_scbd26::type_id::create("tx_scbd26",this);
  rx_scbd26 = uart_ctrl_rx_scbd26::type_id::create("rx_scbd26",this);
endfunction : build_phase
   
function void uart_ctrl_monitor26::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get26 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if26)::get(this, "", "vif26", vif26))
      `uvm_error("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".vif26"})
  apb_out26.connect(tx_scbd26.apb_match26);
  uart_tx_out26.connect(tx_scbd26.uart_add26);
  apb_out26.connect(rx_scbd26.apb_add26);
  uart_rx_out26.connect(rx_scbd26.uart_match26);
endfunction : connect_phase

// implement UART26 Rx26 analysis26 port
function void uart_ctrl_monitor26::write_rx26(uart_frame26 frame26);
  uart_rx_out26.write(frame26);
  tx_time_in26 = tx_time_q26.pop_back();
  tx_time_out26 = ($time-tx_time_in26)/clk_period26;
endfunction : write_rx26
   
// implement UART26 Tx26 analysis26 port
function void uart_ctrl_monitor26::write_tx26(uart_frame26 frame26);
  uart_tx_out26.write(frame26);
  rx_time_q26.push_front($time); 
endfunction : write_tx26

// implement UART26 Config26 analysis26 port
function void uart_ctrl_monitor26::write_cfg26(uart_config26 uart_cfg26);
   set_uart_config26(uart_cfg26);
endfunction : write_cfg26

  // implement APB26 analysis26 port 
function void uart_ctrl_monitor26::write_apb26(apb_transfer26 transfer26);
    apb_out26.write(transfer26);
  if ((transfer26.direction26 == APB_READ26)  && (transfer26.addr == `RX_FIFO_REG26))
     begin
       rx_time_in26 = rx_time_q26.pop_back();
       rx_time_out26 = ($time-rx_time_in26)/clk_period26;
     end
  else if ((transfer26.direction26 == APB_WRITE26)  && (transfer26.addr == `TX_FIFO_REG26))
     begin
       tx_time_q26.push_front($time); 
     end
    
endfunction : write_apb26

function void uart_ctrl_monitor26::update_config26(uart_ctrl_config26 uart_ctrl_cfg26, int index);
  `uvm_info(get_type_name(), {"Updating Config26\n", uart_ctrl_cfg26.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg26;
   tx_scbd26.slave_cfg26 = uart_ctrl_cfg26.apb_cfg26.slave_configs26[index];
   tx_scbd26.uart_cfg26 = uart_ctrl_cfg26.uart_cfg26;
   rx_scbd26.slave_cfg26 = uart_ctrl_cfg26.apb_cfg26.slave_configs26[index];
   rx_scbd26.uart_cfg26 = uart_ctrl_cfg26.uart_cfg26;
endfunction : update_config26

function void uart_ctrl_monitor26::set_slave_config26(apb_slave_config26 slave_cfg26, int index);
   cfg.apb_cfg26.slave_configs26[index] = slave_cfg26;
   tx_scbd26.slave_cfg26 = slave_cfg26;
   rx_scbd26.slave_cfg26 = slave_cfg26;
endfunction : set_slave_config26

function void uart_ctrl_monitor26::set_uart_config26(uart_config26 uart_cfg26);
   cfg.uart_cfg26     = uart_cfg26;
   tx_scbd26.uart_cfg26 = uart_cfg26;
   rx_scbd26.uart_cfg26 = uart_cfg26;
endfunction : set_uart_config26
