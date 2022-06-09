/*-------------------------------------------------------------------------
File29 name   : uart_ctrl_monitor29.sv
Title29       : UART29 Controller29 Monitor29
Project29     :
Created29     :
Description29 : Module29 monitor29
Notes29       : 
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

// TLM Port29 Declarations29
`uvm_analysis_imp_decl(_rx29)
`uvm_analysis_imp_decl(_tx29)
`uvm_analysis_imp_decl(_cfg29)

class uart_ctrl_monitor29 extends uvm_monitor;

  // Virtual interface to DUT signals29 if necessary29 (OPTIONAL29)
  virtual interface uart_ctrl_internal_if29 vif29;

  time rx_time_q29[$];
  time tx_time_q29[$];
  time tx_time_out29, tx_time_in29, rx_time_out29, rx_time_in29, clk_period29;

  // UART29 Controller29 Configuration29 Information29
  uart_ctrl_config29 cfg;

  // UART29 Controller29 coverage29
  uart_ctrl_cover29 uart_cover29;

  // Scoreboards29
  uart_ctrl_tx_scbd29 tx_scbd29;
  uart_ctrl_rx_scbd29 rx_scbd29;

  // TLM Connections29 to the interface UVC29 monitors29
  uvm_analysis_imp_apb29 #(apb_transfer29, uart_ctrl_monitor29) apb_in29;
  uvm_analysis_imp_rx29 #(uart_frame29, uart_ctrl_monitor29) uart_rx_in29;
  uvm_analysis_imp_tx29 #(uart_frame29, uart_ctrl_monitor29) uart_tx_in29;
  uvm_analysis_imp_cfg29 #(uart_config29, uart_ctrl_monitor29) uart_cfg_in29;

  // TLM Connections29 to other Components (Scoreboard29, updated config)
  uvm_analysis_port #(apb_transfer29) apb_out29;
  uvm_analysis_port #(uart_frame29) uart_rx_out29;
  uvm_analysis_port #(uart_frame29) uart_tx_out29;

  `uvm_component_utils_begin(uart_ctrl_monitor29)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports29(); // Create29 TLM Ports29
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif29.clock29) clk_period29 = $time;
    @(posedge vif29.clock29) clk_period29 = $time - clk_period29;
  endtask : run_phase
 
  // Additional29 class methods29
  extern virtual function void create_tlm_ports29();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx29(uart_frame29 frame29);
  extern virtual function void write_tx29(uart_frame29 frame29);
  extern virtual function void write_apb29(apb_transfer29 transfer29);
  extern virtual function void write_cfg29(uart_config29 uart_cfg29);
  extern virtual function void update_config29(uart_ctrl_config29 uart_ctrl_cfg29, int index);
  extern virtual function void set_slave_config29(apb_slave_config29 slave_cfg29, int index);
  extern virtual function void set_uart_config29(uart_config29 uart_cfg29);
endclass : uart_ctrl_monitor29

function void uart_ctrl_monitor29::create_tlm_ports29();
  apb_in29 = new("apb_in29", this);
  apb_out29 = new("apb_out29", this);
  uart_rx_in29 = new("uart_rx_in29", this);
  uart_rx_out29 = new("uart_rx_out29", this);
  uart_tx_in29 = new("uart_tx_in29", this);
  uart_tx_out29 = new("uart_tx_out29", this);
endfunction: create_tlm_ports29

function void uart_ctrl_monitor29::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover29 = uart_ctrl_cover29::type_id::create("uart_cover29",this);

  // Get29 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config29)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG29", "uart_ctrl_cfg29 is null...creating29 ", UVM_MEDIUM)
    cfg = uart_ctrl_config29::type_id::create("cfg", this);
    //set_config_object("tx_scbd29", "cfg", cfg);
    //set_config_object("rx_scbd29", "cfg", cfg);
  end
  //uvm_config_db#(uart_config29)::set(this, "*x_scbd29", "uart_cfg29", cfg.uart_cfg29);
  //uvm_config_db#(apb_slave_config29)::set(this, "*x_scbd29", "apb_slave_cfg29", cfg.apb_cfg29.slave_configs29[0]);
  uvm_config_object::set(this, "*x_scbd29", "uart_cfg29", cfg.uart_cfg29);
  uvm_config_object::set(this, "*x_scbd29", "apb_slave_cfg29", cfg.apb_cfg29.slave_configs29[0]);
  tx_scbd29 = uart_ctrl_tx_scbd29::type_id::create("tx_scbd29",this);
  rx_scbd29 = uart_ctrl_rx_scbd29::type_id::create("rx_scbd29",this);
endfunction : build_phase
   
function void uart_ctrl_monitor29::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get29 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if29)::get(this, "", "vif29", vif29))
      `uvm_error("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".vif29"})
  apb_out29.connect(tx_scbd29.apb_match29);
  uart_tx_out29.connect(tx_scbd29.uart_add29);
  apb_out29.connect(rx_scbd29.apb_add29);
  uart_rx_out29.connect(rx_scbd29.uart_match29);
endfunction : connect_phase

// implement UART29 Rx29 analysis29 port
function void uart_ctrl_monitor29::write_rx29(uart_frame29 frame29);
  uart_rx_out29.write(frame29);
  tx_time_in29 = tx_time_q29.pop_back();
  tx_time_out29 = ($time-tx_time_in29)/clk_period29;
endfunction : write_rx29
   
// implement UART29 Tx29 analysis29 port
function void uart_ctrl_monitor29::write_tx29(uart_frame29 frame29);
  uart_tx_out29.write(frame29);
  rx_time_q29.push_front($time); 
endfunction : write_tx29

// implement UART29 Config29 analysis29 port
function void uart_ctrl_monitor29::write_cfg29(uart_config29 uart_cfg29);
   set_uart_config29(uart_cfg29);
endfunction : write_cfg29

  // implement APB29 analysis29 port 
function void uart_ctrl_monitor29::write_apb29(apb_transfer29 transfer29);
    apb_out29.write(transfer29);
  if ((transfer29.direction29 == APB_READ29)  && (transfer29.addr == `RX_FIFO_REG29))
     begin
       rx_time_in29 = rx_time_q29.pop_back();
       rx_time_out29 = ($time-rx_time_in29)/clk_period29;
     end
  else if ((transfer29.direction29 == APB_WRITE29)  && (transfer29.addr == `TX_FIFO_REG29))
     begin
       tx_time_q29.push_front($time); 
     end
    
endfunction : write_apb29

function void uart_ctrl_monitor29::update_config29(uart_ctrl_config29 uart_ctrl_cfg29, int index);
  `uvm_info(get_type_name(), {"Updating Config29\n", uart_ctrl_cfg29.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg29;
   tx_scbd29.slave_cfg29 = uart_ctrl_cfg29.apb_cfg29.slave_configs29[index];
   tx_scbd29.uart_cfg29 = uart_ctrl_cfg29.uart_cfg29;
   rx_scbd29.slave_cfg29 = uart_ctrl_cfg29.apb_cfg29.slave_configs29[index];
   rx_scbd29.uart_cfg29 = uart_ctrl_cfg29.uart_cfg29;
endfunction : update_config29

function void uart_ctrl_monitor29::set_slave_config29(apb_slave_config29 slave_cfg29, int index);
   cfg.apb_cfg29.slave_configs29[index] = slave_cfg29;
   tx_scbd29.slave_cfg29 = slave_cfg29;
   rx_scbd29.slave_cfg29 = slave_cfg29;
endfunction : set_slave_config29

function void uart_ctrl_monitor29::set_uart_config29(uart_config29 uart_cfg29);
   cfg.uart_cfg29     = uart_cfg29;
   tx_scbd29.uart_cfg29 = uart_cfg29;
   rx_scbd29.uart_cfg29 = uart_cfg29;
endfunction : set_uart_config29
