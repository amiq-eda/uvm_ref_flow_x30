/*-------------------------------------------------------------------------
File4 name   : uart_ctrl_monitor4.sv
Title4       : UART4 Controller4 Monitor4
Project4     :
Created4     :
Description4 : Module4 monitor4
Notes4       : 
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

// TLM Port4 Declarations4
`uvm_analysis_imp_decl(_rx4)
`uvm_analysis_imp_decl(_tx4)
`uvm_analysis_imp_decl(_cfg4)

class uart_ctrl_monitor4 extends uvm_monitor;

  // Virtual interface to DUT signals4 if necessary4 (OPTIONAL4)
  virtual interface uart_ctrl_internal_if4 vif4;

  time rx_time_q4[$];
  time tx_time_q4[$];
  time tx_time_out4, tx_time_in4, rx_time_out4, rx_time_in4, clk_period4;

  // UART4 Controller4 Configuration4 Information4
  uart_ctrl_config4 cfg;

  // UART4 Controller4 coverage4
  uart_ctrl_cover4 uart_cover4;

  // Scoreboards4
  uart_ctrl_tx_scbd4 tx_scbd4;
  uart_ctrl_rx_scbd4 rx_scbd4;

  // TLM Connections4 to the interface UVC4 monitors4
  uvm_analysis_imp_apb4 #(apb_transfer4, uart_ctrl_monitor4) apb_in4;
  uvm_analysis_imp_rx4 #(uart_frame4, uart_ctrl_monitor4) uart_rx_in4;
  uvm_analysis_imp_tx4 #(uart_frame4, uart_ctrl_monitor4) uart_tx_in4;
  uvm_analysis_imp_cfg4 #(uart_config4, uart_ctrl_monitor4) uart_cfg_in4;

  // TLM Connections4 to other Components (Scoreboard4, updated config)
  uvm_analysis_port #(apb_transfer4) apb_out4;
  uvm_analysis_port #(uart_frame4) uart_rx_out4;
  uvm_analysis_port #(uart_frame4) uart_tx_out4;

  `uvm_component_utils_begin(uart_ctrl_monitor4)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports4(); // Create4 TLM Ports4
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif4.clock4) clk_period4 = $time;
    @(posedge vif4.clock4) clk_period4 = $time - clk_period4;
  endtask : run_phase
 
  // Additional4 class methods4
  extern virtual function void create_tlm_ports4();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx4(uart_frame4 frame4);
  extern virtual function void write_tx4(uart_frame4 frame4);
  extern virtual function void write_apb4(apb_transfer4 transfer4);
  extern virtual function void write_cfg4(uart_config4 uart_cfg4);
  extern virtual function void update_config4(uart_ctrl_config4 uart_ctrl_cfg4, int index);
  extern virtual function void set_slave_config4(apb_slave_config4 slave_cfg4, int index);
  extern virtual function void set_uart_config4(uart_config4 uart_cfg4);
endclass : uart_ctrl_monitor4

function void uart_ctrl_monitor4::create_tlm_ports4();
  apb_in4 = new("apb_in4", this);
  apb_out4 = new("apb_out4", this);
  uart_rx_in4 = new("uart_rx_in4", this);
  uart_rx_out4 = new("uart_rx_out4", this);
  uart_tx_in4 = new("uart_tx_in4", this);
  uart_tx_out4 = new("uart_tx_out4", this);
endfunction: create_tlm_ports4

function void uart_ctrl_monitor4::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover4 = uart_ctrl_cover4::type_id::create("uart_cover4",this);

  // Get4 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config4)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG4", "uart_ctrl_cfg4 is null...creating4 ", UVM_MEDIUM)
    cfg = uart_ctrl_config4::type_id::create("cfg", this);
    //set_config_object("tx_scbd4", "cfg", cfg);
    //set_config_object("rx_scbd4", "cfg", cfg);
  end
  //uvm_config_db#(uart_config4)::set(this, "*x_scbd4", "uart_cfg4", cfg.uart_cfg4);
  //uvm_config_db#(apb_slave_config4)::set(this, "*x_scbd4", "apb_slave_cfg4", cfg.apb_cfg4.slave_configs4[0]);
  uvm_config_object::set(this, "*x_scbd4", "uart_cfg4", cfg.uart_cfg4);
  uvm_config_object::set(this, "*x_scbd4", "apb_slave_cfg4", cfg.apb_cfg4.slave_configs4[0]);
  tx_scbd4 = uart_ctrl_tx_scbd4::type_id::create("tx_scbd4",this);
  rx_scbd4 = uart_ctrl_rx_scbd4::type_id::create("rx_scbd4",this);
endfunction : build_phase
   
function void uart_ctrl_monitor4::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get4 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if4)::get(this, "", "vif4", vif4))
      `uvm_error("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".vif4"})
  apb_out4.connect(tx_scbd4.apb_match4);
  uart_tx_out4.connect(tx_scbd4.uart_add4);
  apb_out4.connect(rx_scbd4.apb_add4);
  uart_rx_out4.connect(rx_scbd4.uart_match4);
endfunction : connect_phase

// implement UART4 Rx4 analysis4 port
function void uart_ctrl_monitor4::write_rx4(uart_frame4 frame4);
  uart_rx_out4.write(frame4);
  tx_time_in4 = tx_time_q4.pop_back();
  tx_time_out4 = ($time-tx_time_in4)/clk_period4;
endfunction : write_rx4
   
// implement UART4 Tx4 analysis4 port
function void uart_ctrl_monitor4::write_tx4(uart_frame4 frame4);
  uart_tx_out4.write(frame4);
  rx_time_q4.push_front($time); 
endfunction : write_tx4

// implement UART4 Config4 analysis4 port
function void uart_ctrl_monitor4::write_cfg4(uart_config4 uart_cfg4);
   set_uart_config4(uart_cfg4);
endfunction : write_cfg4

  // implement APB4 analysis4 port 
function void uart_ctrl_monitor4::write_apb4(apb_transfer4 transfer4);
    apb_out4.write(transfer4);
  if ((transfer4.direction4 == APB_READ4)  && (transfer4.addr == `RX_FIFO_REG4))
     begin
       rx_time_in4 = rx_time_q4.pop_back();
       rx_time_out4 = ($time-rx_time_in4)/clk_period4;
     end
  else if ((transfer4.direction4 == APB_WRITE4)  && (transfer4.addr == `TX_FIFO_REG4))
     begin
       tx_time_q4.push_front($time); 
     end
    
endfunction : write_apb4

function void uart_ctrl_monitor4::update_config4(uart_ctrl_config4 uart_ctrl_cfg4, int index);
  `uvm_info(get_type_name(), {"Updating Config4\n", uart_ctrl_cfg4.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg4;
   tx_scbd4.slave_cfg4 = uart_ctrl_cfg4.apb_cfg4.slave_configs4[index];
   tx_scbd4.uart_cfg4 = uart_ctrl_cfg4.uart_cfg4;
   rx_scbd4.slave_cfg4 = uart_ctrl_cfg4.apb_cfg4.slave_configs4[index];
   rx_scbd4.uart_cfg4 = uart_ctrl_cfg4.uart_cfg4;
endfunction : update_config4

function void uart_ctrl_monitor4::set_slave_config4(apb_slave_config4 slave_cfg4, int index);
   cfg.apb_cfg4.slave_configs4[index] = slave_cfg4;
   tx_scbd4.slave_cfg4 = slave_cfg4;
   rx_scbd4.slave_cfg4 = slave_cfg4;
endfunction : set_slave_config4

function void uart_ctrl_monitor4::set_uart_config4(uart_config4 uart_cfg4);
   cfg.uart_cfg4     = uart_cfg4;
   tx_scbd4.uart_cfg4 = uart_cfg4;
   rx_scbd4.uart_cfg4 = uart_cfg4;
endfunction : set_uart_config4
