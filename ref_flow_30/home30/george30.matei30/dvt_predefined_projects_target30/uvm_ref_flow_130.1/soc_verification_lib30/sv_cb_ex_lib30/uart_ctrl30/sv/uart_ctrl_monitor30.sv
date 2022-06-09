/*-------------------------------------------------------------------------
File30 name   : uart_ctrl_monitor30.sv
Title30       : UART30 Controller30 Monitor30
Project30     :
Created30     :
Description30 : Module30 monitor30
Notes30       : 
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

// TLM Port30 Declarations30
`uvm_analysis_imp_decl(_rx30)
`uvm_analysis_imp_decl(_tx30)
`uvm_analysis_imp_decl(_cfg30)

class uart_ctrl_monitor30 extends uvm_monitor;

  // Virtual interface to DUT signals30 if necessary30 (OPTIONAL30)
  virtual interface uart_ctrl_internal_if30 vif30;

  time rx_time_q30[$];
  time tx_time_q30[$];
  time tx_time_out30, tx_time_in30, rx_time_out30, rx_time_in30, clk_period30;

  // UART30 Controller30 Configuration30 Information30
  uart_ctrl_config30 cfg;

  // UART30 Controller30 coverage30
  uart_ctrl_cover30 uart_cover30;

  // Scoreboards30
  uart_ctrl_tx_scbd30 tx_scbd30;
  uart_ctrl_rx_scbd30 rx_scbd30;

  // TLM Connections30 to the interface UVC30 monitors30
  uvm_analysis_imp_apb30 #(apb_transfer30, uart_ctrl_monitor30) apb_in30;
  uvm_analysis_imp_rx30 #(uart_frame30, uart_ctrl_monitor30) uart_rx_in30;
  uvm_analysis_imp_tx30 #(uart_frame30, uart_ctrl_monitor30) uart_tx_in30;
  uvm_analysis_imp_cfg30 #(uart_config30, uart_ctrl_monitor30) uart_cfg_in30;

  // TLM Connections30 to other Components (Scoreboard30, updated config)
  uvm_analysis_port #(apb_transfer30) apb_out30;
  uvm_analysis_port #(uart_frame30) uart_rx_out30;
  uvm_analysis_port #(uart_frame30) uart_tx_out30;

  `uvm_component_utils_begin(uart_ctrl_monitor30)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports30(); // Create30 TLM Ports30
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif30.clock30) clk_period30 = $time;
    @(posedge vif30.clock30) clk_period30 = $time - clk_period30;
  endtask : run_phase
 
  // Additional30 class methods30
  extern virtual function void create_tlm_ports30();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx30(uart_frame30 frame30);
  extern virtual function void write_tx30(uart_frame30 frame30);
  extern virtual function void write_apb30(apb_transfer30 transfer30);
  extern virtual function void write_cfg30(uart_config30 uart_cfg30);
  extern virtual function void update_config30(uart_ctrl_config30 uart_ctrl_cfg30, int index);
  extern virtual function void set_slave_config30(apb_slave_config30 slave_cfg30, int index);
  extern virtual function void set_uart_config30(uart_config30 uart_cfg30);
endclass : uart_ctrl_monitor30

function void uart_ctrl_monitor30::create_tlm_ports30();
  apb_in30 = new("apb_in30", this);
  apb_out30 = new("apb_out30", this);
  uart_rx_in30 = new("uart_rx_in30", this);
  uart_rx_out30 = new("uart_rx_out30", this);
  uart_tx_in30 = new("uart_tx_in30", this);
  uart_tx_out30 = new("uart_tx_out30", this);
endfunction: create_tlm_ports30

function void uart_ctrl_monitor30::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover30 = uart_ctrl_cover30::type_id::create("uart_cover30",this);

  // Get30 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config30)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG30", "uart_ctrl_cfg30 is null...creating30 ", UVM_MEDIUM)
    cfg = uart_ctrl_config30::type_id::create("cfg", this);
    //set_config_object("tx_scbd30", "cfg", cfg);
    //set_config_object("rx_scbd30", "cfg", cfg);
  end
  //uvm_config_db#(uart_config30)::set(this, "*x_scbd30", "uart_cfg30", cfg.uart_cfg30);
  //uvm_config_db#(apb_slave_config30)::set(this, "*x_scbd30", "apb_slave_cfg30", cfg.apb_cfg30.slave_configs30[0]);
  uvm_config_object::set(this, "*x_scbd30", "uart_cfg30", cfg.uart_cfg30);
  uvm_config_object::set(this, "*x_scbd30", "apb_slave_cfg30", cfg.apb_cfg30.slave_configs30[0]);
  tx_scbd30 = uart_ctrl_tx_scbd30::type_id::create("tx_scbd30",this);
  rx_scbd30 = uart_ctrl_rx_scbd30::type_id::create("rx_scbd30",this);
endfunction : build_phase
   
function void uart_ctrl_monitor30::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get30 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if30)::get(this, "", "vif30", vif30))
      `uvm_error("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".vif30"})
  apb_out30.connect(tx_scbd30.apb_match30);
  uart_tx_out30.connect(tx_scbd30.uart_add30);
  apb_out30.connect(rx_scbd30.apb_add30);
  uart_rx_out30.connect(rx_scbd30.uart_match30);
endfunction : connect_phase

// implement UART30 Rx30 analysis30 port
function void uart_ctrl_monitor30::write_rx30(uart_frame30 frame30);
  uart_rx_out30.write(frame30);
  tx_time_in30 = tx_time_q30.pop_back();
  tx_time_out30 = ($time-tx_time_in30)/clk_period30;
endfunction : write_rx30
   
// implement UART30 Tx30 analysis30 port
function void uart_ctrl_monitor30::write_tx30(uart_frame30 frame30);
  uart_tx_out30.write(frame30);
  rx_time_q30.push_front($time); 
endfunction : write_tx30

// implement UART30 Config30 analysis30 port
function void uart_ctrl_monitor30::write_cfg30(uart_config30 uart_cfg30);
   set_uart_config30(uart_cfg30);
endfunction : write_cfg30

  // implement APB30 analysis30 port 
function void uart_ctrl_monitor30::write_apb30(apb_transfer30 transfer30);
    apb_out30.write(transfer30);
  if ((transfer30.direction30 == APB_READ30)  && (transfer30.addr == `RX_FIFO_REG30))
     begin
       rx_time_in30 = rx_time_q30.pop_back();
       rx_time_out30 = ($time-rx_time_in30)/clk_period30;
     end
  else if ((transfer30.direction30 == APB_WRITE30)  && (transfer30.addr == `TX_FIFO_REG30))
     begin
       tx_time_q30.push_front($time); 
     end
    
endfunction : write_apb30

function void uart_ctrl_monitor30::update_config30(uart_ctrl_config30 uart_ctrl_cfg30, int index);
  `uvm_info(get_type_name(), {"Updating Config30\n", uart_ctrl_cfg30.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg30;
   tx_scbd30.slave_cfg30 = uart_ctrl_cfg30.apb_cfg30.slave_configs30[index];
   tx_scbd30.uart_cfg30 = uart_ctrl_cfg30.uart_cfg30;
   rx_scbd30.slave_cfg30 = uart_ctrl_cfg30.apb_cfg30.slave_configs30[index];
   rx_scbd30.uart_cfg30 = uart_ctrl_cfg30.uart_cfg30;
endfunction : update_config30

function void uart_ctrl_monitor30::set_slave_config30(apb_slave_config30 slave_cfg30, int index);
   cfg.apb_cfg30.slave_configs30[index] = slave_cfg30;
   tx_scbd30.slave_cfg30 = slave_cfg30;
   rx_scbd30.slave_cfg30 = slave_cfg30;
endfunction : set_slave_config30

function void uart_ctrl_monitor30::set_uart_config30(uart_config30 uart_cfg30);
   cfg.uart_cfg30     = uart_cfg30;
   tx_scbd30.uart_cfg30 = uart_cfg30;
   rx_scbd30.uart_cfg30 = uart_cfg30;
endfunction : set_uart_config30
