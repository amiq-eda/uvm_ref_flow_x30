/*-------------------------------------------------------------------------
File25 name   : uart_ctrl_monitor25.sv
Title25       : UART25 Controller25 Monitor25
Project25     :
Created25     :
Description25 : Module25 monitor25
Notes25       : 
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

// TLM Port25 Declarations25
`uvm_analysis_imp_decl(_rx25)
`uvm_analysis_imp_decl(_tx25)
`uvm_analysis_imp_decl(_cfg25)

class uart_ctrl_monitor25 extends uvm_monitor;

  // Virtual interface to DUT signals25 if necessary25 (OPTIONAL25)
  virtual interface uart_ctrl_internal_if25 vif25;

  time rx_time_q25[$];
  time tx_time_q25[$];
  time tx_time_out25, tx_time_in25, rx_time_out25, rx_time_in25, clk_period25;

  // UART25 Controller25 Configuration25 Information25
  uart_ctrl_config25 cfg;

  // UART25 Controller25 coverage25
  uart_ctrl_cover25 uart_cover25;

  // Scoreboards25
  uart_ctrl_tx_scbd25 tx_scbd25;
  uart_ctrl_rx_scbd25 rx_scbd25;

  // TLM Connections25 to the interface UVC25 monitors25
  uvm_analysis_imp_apb25 #(apb_transfer25, uart_ctrl_monitor25) apb_in25;
  uvm_analysis_imp_rx25 #(uart_frame25, uart_ctrl_monitor25) uart_rx_in25;
  uvm_analysis_imp_tx25 #(uart_frame25, uart_ctrl_monitor25) uart_tx_in25;
  uvm_analysis_imp_cfg25 #(uart_config25, uart_ctrl_monitor25) uart_cfg_in25;

  // TLM Connections25 to other Components (Scoreboard25, updated config)
  uvm_analysis_port #(apb_transfer25) apb_out25;
  uvm_analysis_port #(uart_frame25) uart_rx_out25;
  uvm_analysis_port #(uart_frame25) uart_tx_out25;

  `uvm_component_utils_begin(uart_ctrl_monitor25)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports25(); // Create25 TLM Ports25
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif25.clock25) clk_period25 = $time;
    @(posedge vif25.clock25) clk_period25 = $time - clk_period25;
  endtask : run_phase
 
  // Additional25 class methods25
  extern virtual function void create_tlm_ports25();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx25(uart_frame25 frame25);
  extern virtual function void write_tx25(uart_frame25 frame25);
  extern virtual function void write_apb25(apb_transfer25 transfer25);
  extern virtual function void write_cfg25(uart_config25 uart_cfg25);
  extern virtual function void update_config25(uart_ctrl_config25 uart_ctrl_cfg25, int index);
  extern virtual function void set_slave_config25(apb_slave_config25 slave_cfg25, int index);
  extern virtual function void set_uart_config25(uart_config25 uart_cfg25);
endclass : uart_ctrl_monitor25

function void uart_ctrl_monitor25::create_tlm_ports25();
  apb_in25 = new("apb_in25", this);
  apb_out25 = new("apb_out25", this);
  uart_rx_in25 = new("uart_rx_in25", this);
  uart_rx_out25 = new("uart_rx_out25", this);
  uart_tx_in25 = new("uart_tx_in25", this);
  uart_tx_out25 = new("uart_tx_out25", this);
endfunction: create_tlm_ports25

function void uart_ctrl_monitor25::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover25 = uart_ctrl_cover25::type_id::create("uart_cover25",this);

  // Get25 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config25)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG25", "uart_ctrl_cfg25 is null...creating25 ", UVM_MEDIUM)
    cfg = uart_ctrl_config25::type_id::create("cfg", this);
    //set_config_object("tx_scbd25", "cfg", cfg);
    //set_config_object("rx_scbd25", "cfg", cfg);
  end
  //uvm_config_db#(uart_config25)::set(this, "*x_scbd25", "uart_cfg25", cfg.uart_cfg25);
  //uvm_config_db#(apb_slave_config25)::set(this, "*x_scbd25", "apb_slave_cfg25", cfg.apb_cfg25.slave_configs25[0]);
  uvm_config_object::set(this, "*x_scbd25", "uart_cfg25", cfg.uart_cfg25);
  uvm_config_object::set(this, "*x_scbd25", "apb_slave_cfg25", cfg.apb_cfg25.slave_configs25[0]);
  tx_scbd25 = uart_ctrl_tx_scbd25::type_id::create("tx_scbd25",this);
  rx_scbd25 = uart_ctrl_rx_scbd25::type_id::create("rx_scbd25",this);
endfunction : build_phase
   
function void uart_ctrl_monitor25::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get25 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if25)::get(this, "", "vif25", vif25))
      `uvm_error("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".vif25"})
  apb_out25.connect(tx_scbd25.apb_match25);
  uart_tx_out25.connect(tx_scbd25.uart_add25);
  apb_out25.connect(rx_scbd25.apb_add25);
  uart_rx_out25.connect(rx_scbd25.uart_match25);
endfunction : connect_phase

// implement UART25 Rx25 analysis25 port
function void uart_ctrl_monitor25::write_rx25(uart_frame25 frame25);
  uart_rx_out25.write(frame25);
  tx_time_in25 = tx_time_q25.pop_back();
  tx_time_out25 = ($time-tx_time_in25)/clk_period25;
endfunction : write_rx25
   
// implement UART25 Tx25 analysis25 port
function void uart_ctrl_monitor25::write_tx25(uart_frame25 frame25);
  uart_tx_out25.write(frame25);
  rx_time_q25.push_front($time); 
endfunction : write_tx25

// implement UART25 Config25 analysis25 port
function void uart_ctrl_monitor25::write_cfg25(uart_config25 uart_cfg25);
   set_uart_config25(uart_cfg25);
endfunction : write_cfg25

  // implement APB25 analysis25 port 
function void uart_ctrl_monitor25::write_apb25(apb_transfer25 transfer25);
    apb_out25.write(transfer25);
  if ((transfer25.direction25 == APB_READ25)  && (transfer25.addr == `RX_FIFO_REG25))
     begin
       rx_time_in25 = rx_time_q25.pop_back();
       rx_time_out25 = ($time-rx_time_in25)/clk_period25;
     end
  else if ((transfer25.direction25 == APB_WRITE25)  && (transfer25.addr == `TX_FIFO_REG25))
     begin
       tx_time_q25.push_front($time); 
     end
    
endfunction : write_apb25

function void uart_ctrl_monitor25::update_config25(uart_ctrl_config25 uart_ctrl_cfg25, int index);
  `uvm_info(get_type_name(), {"Updating Config25\n", uart_ctrl_cfg25.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg25;
   tx_scbd25.slave_cfg25 = uart_ctrl_cfg25.apb_cfg25.slave_configs25[index];
   tx_scbd25.uart_cfg25 = uart_ctrl_cfg25.uart_cfg25;
   rx_scbd25.slave_cfg25 = uart_ctrl_cfg25.apb_cfg25.slave_configs25[index];
   rx_scbd25.uart_cfg25 = uart_ctrl_cfg25.uart_cfg25;
endfunction : update_config25

function void uart_ctrl_monitor25::set_slave_config25(apb_slave_config25 slave_cfg25, int index);
   cfg.apb_cfg25.slave_configs25[index] = slave_cfg25;
   tx_scbd25.slave_cfg25 = slave_cfg25;
   rx_scbd25.slave_cfg25 = slave_cfg25;
endfunction : set_slave_config25

function void uart_ctrl_monitor25::set_uart_config25(uart_config25 uart_cfg25);
   cfg.uart_cfg25     = uart_cfg25;
   tx_scbd25.uart_cfg25 = uart_cfg25;
   rx_scbd25.uart_cfg25 = uart_cfg25;
endfunction : set_uart_config25
