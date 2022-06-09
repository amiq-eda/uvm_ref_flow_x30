/*-------------------------------------------------------------------------
File15 name   : uart_ctrl_monitor15.sv
Title15       : UART15 Controller15 Monitor15
Project15     :
Created15     :
Description15 : Module15 monitor15
Notes15       : 
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

// TLM Port15 Declarations15
`uvm_analysis_imp_decl(_rx15)
`uvm_analysis_imp_decl(_tx15)
`uvm_analysis_imp_decl(_cfg15)

class uart_ctrl_monitor15 extends uvm_monitor;

  // Virtual interface to DUT signals15 if necessary15 (OPTIONAL15)
  virtual interface uart_ctrl_internal_if15 vif15;

  time rx_time_q15[$];
  time tx_time_q15[$];
  time tx_time_out15, tx_time_in15, rx_time_out15, rx_time_in15, clk_period15;

  // UART15 Controller15 Configuration15 Information15
  uart_ctrl_config15 cfg;

  // UART15 Controller15 coverage15
  uart_ctrl_cover15 uart_cover15;

  // Scoreboards15
  uart_ctrl_tx_scbd15 tx_scbd15;
  uart_ctrl_rx_scbd15 rx_scbd15;

  // TLM Connections15 to the interface UVC15 monitors15
  uvm_analysis_imp_apb15 #(apb_transfer15, uart_ctrl_monitor15) apb_in15;
  uvm_analysis_imp_rx15 #(uart_frame15, uart_ctrl_monitor15) uart_rx_in15;
  uvm_analysis_imp_tx15 #(uart_frame15, uart_ctrl_monitor15) uart_tx_in15;
  uvm_analysis_imp_cfg15 #(uart_config15, uart_ctrl_monitor15) uart_cfg_in15;

  // TLM Connections15 to other Components (Scoreboard15, updated config)
  uvm_analysis_port #(apb_transfer15) apb_out15;
  uvm_analysis_port #(uart_frame15) uart_rx_out15;
  uvm_analysis_port #(uart_frame15) uart_tx_out15;

  `uvm_component_utils_begin(uart_ctrl_monitor15)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports15(); // Create15 TLM Ports15
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif15.clock15) clk_period15 = $time;
    @(posedge vif15.clock15) clk_period15 = $time - clk_period15;
  endtask : run_phase
 
  // Additional15 class methods15
  extern virtual function void create_tlm_ports15();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx15(uart_frame15 frame15);
  extern virtual function void write_tx15(uart_frame15 frame15);
  extern virtual function void write_apb15(apb_transfer15 transfer15);
  extern virtual function void write_cfg15(uart_config15 uart_cfg15);
  extern virtual function void update_config15(uart_ctrl_config15 uart_ctrl_cfg15, int index);
  extern virtual function void set_slave_config15(apb_slave_config15 slave_cfg15, int index);
  extern virtual function void set_uart_config15(uart_config15 uart_cfg15);
endclass : uart_ctrl_monitor15

function void uart_ctrl_monitor15::create_tlm_ports15();
  apb_in15 = new("apb_in15", this);
  apb_out15 = new("apb_out15", this);
  uart_rx_in15 = new("uart_rx_in15", this);
  uart_rx_out15 = new("uart_rx_out15", this);
  uart_tx_in15 = new("uart_tx_in15", this);
  uart_tx_out15 = new("uart_tx_out15", this);
endfunction: create_tlm_ports15

function void uart_ctrl_monitor15::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover15 = uart_ctrl_cover15::type_id::create("uart_cover15",this);

  // Get15 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config15)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG15", "uart_ctrl_cfg15 is null...creating15 ", UVM_MEDIUM)
    cfg = uart_ctrl_config15::type_id::create("cfg", this);
    //set_config_object("tx_scbd15", "cfg", cfg);
    //set_config_object("rx_scbd15", "cfg", cfg);
  end
  //uvm_config_db#(uart_config15)::set(this, "*x_scbd15", "uart_cfg15", cfg.uart_cfg15);
  //uvm_config_db#(apb_slave_config15)::set(this, "*x_scbd15", "apb_slave_cfg15", cfg.apb_cfg15.slave_configs15[0]);
  uvm_config_object::set(this, "*x_scbd15", "uart_cfg15", cfg.uart_cfg15);
  uvm_config_object::set(this, "*x_scbd15", "apb_slave_cfg15", cfg.apb_cfg15.slave_configs15[0]);
  tx_scbd15 = uart_ctrl_tx_scbd15::type_id::create("tx_scbd15",this);
  rx_scbd15 = uart_ctrl_rx_scbd15::type_id::create("rx_scbd15",this);
endfunction : build_phase
   
function void uart_ctrl_monitor15::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get15 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if15)::get(this, "", "vif15", vif15))
      `uvm_error("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".vif15"})
  apb_out15.connect(tx_scbd15.apb_match15);
  uart_tx_out15.connect(tx_scbd15.uart_add15);
  apb_out15.connect(rx_scbd15.apb_add15);
  uart_rx_out15.connect(rx_scbd15.uart_match15);
endfunction : connect_phase

// implement UART15 Rx15 analysis15 port
function void uart_ctrl_monitor15::write_rx15(uart_frame15 frame15);
  uart_rx_out15.write(frame15);
  tx_time_in15 = tx_time_q15.pop_back();
  tx_time_out15 = ($time-tx_time_in15)/clk_period15;
endfunction : write_rx15
   
// implement UART15 Tx15 analysis15 port
function void uart_ctrl_monitor15::write_tx15(uart_frame15 frame15);
  uart_tx_out15.write(frame15);
  rx_time_q15.push_front($time); 
endfunction : write_tx15

// implement UART15 Config15 analysis15 port
function void uart_ctrl_monitor15::write_cfg15(uart_config15 uart_cfg15);
   set_uart_config15(uart_cfg15);
endfunction : write_cfg15

  // implement APB15 analysis15 port 
function void uart_ctrl_monitor15::write_apb15(apb_transfer15 transfer15);
    apb_out15.write(transfer15);
  if ((transfer15.direction15 == APB_READ15)  && (transfer15.addr == `RX_FIFO_REG15))
     begin
       rx_time_in15 = rx_time_q15.pop_back();
       rx_time_out15 = ($time-rx_time_in15)/clk_period15;
     end
  else if ((transfer15.direction15 == APB_WRITE15)  && (transfer15.addr == `TX_FIFO_REG15))
     begin
       tx_time_q15.push_front($time); 
     end
    
endfunction : write_apb15

function void uart_ctrl_monitor15::update_config15(uart_ctrl_config15 uart_ctrl_cfg15, int index);
  `uvm_info(get_type_name(), {"Updating Config15\n", uart_ctrl_cfg15.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg15;
   tx_scbd15.slave_cfg15 = uart_ctrl_cfg15.apb_cfg15.slave_configs15[index];
   tx_scbd15.uart_cfg15 = uart_ctrl_cfg15.uart_cfg15;
   rx_scbd15.slave_cfg15 = uart_ctrl_cfg15.apb_cfg15.slave_configs15[index];
   rx_scbd15.uart_cfg15 = uart_ctrl_cfg15.uart_cfg15;
endfunction : update_config15

function void uart_ctrl_monitor15::set_slave_config15(apb_slave_config15 slave_cfg15, int index);
   cfg.apb_cfg15.slave_configs15[index] = slave_cfg15;
   tx_scbd15.slave_cfg15 = slave_cfg15;
   rx_scbd15.slave_cfg15 = slave_cfg15;
endfunction : set_slave_config15

function void uart_ctrl_monitor15::set_uart_config15(uart_config15 uart_cfg15);
   cfg.uart_cfg15     = uart_cfg15;
   tx_scbd15.uart_cfg15 = uart_cfg15;
   rx_scbd15.uart_cfg15 = uart_cfg15;
endfunction : set_uart_config15
