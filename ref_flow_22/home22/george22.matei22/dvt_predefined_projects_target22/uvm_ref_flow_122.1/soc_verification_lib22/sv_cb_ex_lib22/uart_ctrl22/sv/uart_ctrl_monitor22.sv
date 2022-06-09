/*-------------------------------------------------------------------------
File22 name   : uart_ctrl_monitor22.sv
Title22       : UART22 Controller22 Monitor22
Project22     :
Created22     :
Description22 : Module22 monitor22
Notes22       : 
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

// TLM Port22 Declarations22
`uvm_analysis_imp_decl(_rx22)
`uvm_analysis_imp_decl(_tx22)
`uvm_analysis_imp_decl(_cfg22)

class uart_ctrl_monitor22 extends uvm_monitor;

  // Virtual interface to DUT signals22 if necessary22 (OPTIONAL22)
  virtual interface uart_ctrl_internal_if22 vif22;

  time rx_time_q22[$];
  time tx_time_q22[$];
  time tx_time_out22, tx_time_in22, rx_time_out22, rx_time_in22, clk_period22;

  // UART22 Controller22 Configuration22 Information22
  uart_ctrl_config22 cfg;

  // UART22 Controller22 coverage22
  uart_ctrl_cover22 uart_cover22;

  // Scoreboards22
  uart_ctrl_tx_scbd22 tx_scbd22;
  uart_ctrl_rx_scbd22 rx_scbd22;

  // TLM Connections22 to the interface UVC22 monitors22
  uvm_analysis_imp_apb22 #(apb_transfer22, uart_ctrl_monitor22) apb_in22;
  uvm_analysis_imp_rx22 #(uart_frame22, uart_ctrl_monitor22) uart_rx_in22;
  uvm_analysis_imp_tx22 #(uart_frame22, uart_ctrl_monitor22) uart_tx_in22;
  uvm_analysis_imp_cfg22 #(uart_config22, uart_ctrl_monitor22) uart_cfg_in22;

  // TLM Connections22 to other Components (Scoreboard22, updated config)
  uvm_analysis_port #(apb_transfer22) apb_out22;
  uvm_analysis_port #(uart_frame22) uart_rx_out22;
  uvm_analysis_port #(uart_frame22) uart_tx_out22;

  `uvm_component_utils_begin(uart_ctrl_monitor22)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports22(); // Create22 TLM Ports22
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif22.clock22) clk_period22 = $time;
    @(posedge vif22.clock22) clk_period22 = $time - clk_period22;
  endtask : run_phase
 
  // Additional22 class methods22
  extern virtual function void create_tlm_ports22();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx22(uart_frame22 frame22);
  extern virtual function void write_tx22(uart_frame22 frame22);
  extern virtual function void write_apb22(apb_transfer22 transfer22);
  extern virtual function void write_cfg22(uart_config22 uart_cfg22);
  extern virtual function void update_config22(uart_ctrl_config22 uart_ctrl_cfg22, int index);
  extern virtual function void set_slave_config22(apb_slave_config22 slave_cfg22, int index);
  extern virtual function void set_uart_config22(uart_config22 uart_cfg22);
endclass : uart_ctrl_monitor22

function void uart_ctrl_monitor22::create_tlm_ports22();
  apb_in22 = new("apb_in22", this);
  apb_out22 = new("apb_out22", this);
  uart_rx_in22 = new("uart_rx_in22", this);
  uart_rx_out22 = new("uart_rx_out22", this);
  uart_tx_in22 = new("uart_tx_in22", this);
  uart_tx_out22 = new("uart_tx_out22", this);
endfunction: create_tlm_ports22

function void uart_ctrl_monitor22::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover22 = uart_ctrl_cover22::type_id::create("uart_cover22",this);

  // Get22 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config22)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG22", "uart_ctrl_cfg22 is null...creating22 ", UVM_MEDIUM)
    cfg = uart_ctrl_config22::type_id::create("cfg", this);
    //set_config_object("tx_scbd22", "cfg", cfg);
    //set_config_object("rx_scbd22", "cfg", cfg);
  end
  //uvm_config_db#(uart_config22)::set(this, "*x_scbd22", "uart_cfg22", cfg.uart_cfg22);
  //uvm_config_db#(apb_slave_config22)::set(this, "*x_scbd22", "apb_slave_cfg22", cfg.apb_cfg22.slave_configs22[0]);
  uvm_config_object::set(this, "*x_scbd22", "uart_cfg22", cfg.uart_cfg22);
  uvm_config_object::set(this, "*x_scbd22", "apb_slave_cfg22", cfg.apb_cfg22.slave_configs22[0]);
  tx_scbd22 = uart_ctrl_tx_scbd22::type_id::create("tx_scbd22",this);
  rx_scbd22 = uart_ctrl_rx_scbd22::type_id::create("rx_scbd22",this);
endfunction : build_phase
   
function void uart_ctrl_monitor22::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get22 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if22)::get(this, "", "vif22", vif22))
      `uvm_error("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".vif22"})
  apb_out22.connect(tx_scbd22.apb_match22);
  uart_tx_out22.connect(tx_scbd22.uart_add22);
  apb_out22.connect(rx_scbd22.apb_add22);
  uart_rx_out22.connect(rx_scbd22.uart_match22);
endfunction : connect_phase

// implement UART22 Rx22 analysis22 port
function void uart_ctrl_monitor22::write_rx22(uart_frame22 frame22);
  uart_rx_out22.write(frame22);
  tx_time_in22 = tx_time_q22.pop_back();
  tx_time_out22 = ($time-tx_time_in22)/clk_period22;
endfunction : write_rx22
   
// implement UART22 Tx22 analysis22 port
function void uart_ctrl_monitor22::write_tx22(uart_frame22 frame22);
  uart_tx_out22.write(frame22);
  rx_time_q22.push_front($time); 
endfunction : write_tx22

// implement UART22 Config22 analysis22 port
function void uart_ctrl_monitor22::write_cfg22(uart_config22 uart_cfg22);
   set_uart_config22(uart_cfg22);
endfunction : write_cfg22

  // implement APB22 analysis22 port 
function void uart_ctrl_monitor22::write_apb22(apb_transfer22 transfer22);
    apb_out22.write(transfer22);
  if ((transfer22.direction22 == APB_READ22)  && (transfer22.addr == `RX_FIFO_REG22))
     begin
       rx_time_in22 = rx_time_q22.pop_back();
       rx_time_out22 = ($time-rx_time_in22)/clk_period22;
     end
  else if ((transfer22.direction22 == APB_WRITE22)  && (transfer22.addr == `TX_FIFO_REG22))
     begin
       tx_time_q22.push_front($time); 
     end
    
endfunction : write_apb22

function void uart_ctrl_monitor22::update_config22(uart_ctrl_config22 uart_ctrl_cfg22, int index);
  `uvm_info(get_type_name(), {"Updating Config22\n", uart_ctrl_cfg22.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg22;
   tx_scbd22.slave_cfg22 = uart_ctrl_cfg22.apb_cfg22.slave_configs22[index];
   tx_scbd22.uart_cfg22 = uart_ctrl_cfg22.uart_cfg22;
   rx_scbd22.slave_cfg22 = uart_ctrl_cfg22.apb_cfg22.slave_configs22[index];
   rx_scbd22.uart_cfg22 = uart_ctrl_cfg22.uart_cfg22;
endfunction : update_config22

function void uart_ctrl_monitor22::set_slave_config22(apb_slave_config22 slave_cfg22, int index);
   cfg.apb_cfg22.slave_configs22[index] = slave_cfg22;
   tx_scbd22.slave_cfg22 = slave_cfg22;
   rx_scbd22.slave_cfg22 = slave_cfg22;
endfunction : set_slave_config22

function void uart_ctrl_monitor22::set_uart_config22(uart_config22 uart_cfg22);
   cfg.uart_cfg22     = uart_cfg22;
   tx_scbd22.uart_cfg22 = uart_cfg22;
   rx_scbd22.uart_cfg22 = uart_cfg22;
endfunction : set_uart_config22
