/*-------------------------------------------------------------------------
File28 name   : uart_ctrl_monitor28.sv
Title28       : UART28 Controller28 Monitor28
Project28     :
Created28     :
Description28 : Module28 monitor28
Notes28       : 
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

// TLM Port28 Declarations28
`uvm_analysis_imp_decl(_rx28)
`uvm_analysis_imp_decl(_tx28)
`uvm_analysis_imp_decl(_cfg28)

class uart_ctrl_monitor28 extends uvm_monitor;

  // Virtual interface to DUT signals28 if necessary28 (OPTIONAL28)
  virtual interface uart_ctrl_internal_if28 vif28;

  time rx_time_q28[$];
  time tx_time_q28[$];
  time tx_time_out28, tx_time_in28, rx_time_out28, rx_time_in28, clk_period28;

  // UART28 Controller28 Configuration28 Information28
  uart_ctrl_config28 cfg;

  // UART28 Controller28 coverage28
  uart_ctrl_cover28 uart_cover28;

  // Scoreboards28
  uart_ctrl_tx_scbd28 tx_scbd28;
  uart_ctrl_rx_scbd28 rx_scbd28;

  // TLM Connections28 to the interface UVC28 monitors28
  uvm_analysis_imp_apb28 #(apb_transfer28, uart_ctrl_monitor28) apb_in28;
  uvm_analysis_imp_rx28 #(uart_frame28, uart_ctrl_monitor28) uart_rx_in28;
  uvm_analysis_imp_tx28 #(uart_frame28, uart_ctrl_monitor28) uart_tx_in28;
  uvm_analysis_imp_cfg28 #(uart_config28, uart_ctrl_monitor28) uart_cfg_in28;

  // TLM Connections28 to other Components (Scoreboard28, updated config)
  uvm_analysis_port #(apb_transfer28) apb_out28;
  uvm_analysis_port #(uart_frame28) uart_rx_out28;
  uvm_analysis_port #(uart_frame28) uart_tx_out28;

  `uvm_component_utils_begin(uart_ctrl_monitor28)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports28(); // Create28 TLM Ports28
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif28.clock28) clk_period28 = $time;
    @(posedge vif28.clock28) clk_period28 = $time - clk_period28;
  endtask : run_phase
 
  // Additional28 class methods28
  extern virtual function void create_tlm_ports28();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx28(uart_frame28 frame28);
  extern virtual function void write_tx28(uart_frame28 frame28);
  extern virtual function void write_apb28(apb_transfer28 transfer28);
  extern virtual function void write_cfg28(uart_config28 uart_cfg28);
  extern virtual function void update_config28(uart_ctrl_config28 uart_ctrl_cfg28, int index);
  extern virtual function void set_slave_config28(apb_slave_config28 slave_cfg28, int index);
  extern virtual function void set_uart_config28(uart_config28 uart_cfg28);
endclass : uart_ctrl_monitor28

function void uart_ctrl_monitor28::create_tlm_ports28();
  apb_in28 = new("apb_in28", this);
  apb_out28 = new("apb_out28", this);
  uart_rx_in28 = new("uart_rx_in28", this);
  uart_rx_out28 = new("uart_rx_out28", this);
  uart_tx_in28 = new("uart_tx_in28", this);
  uart_tx_out28 = new("uart_tx_out28", this);
endfunction: create_tlm_ports28

function void uart_ctrl_monitor28::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover28 = uart_ctrl_cover28::type_id::create("uart_cover28",this);

  // Get28 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config28)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG28", "uart_ctrl_cfg28 is null...creating28 ", UVM_MEDIUM)
    cfg = uart_ctrl_config28::type_id::create("cfg", this);
    //set_config_object("tx_scbd28", "cfg", cfg);
    //set_config_object("rx_scbd28", "cfg", cfg);
  end
  //uvm_config_db#(uart_config28)::set(this, "*x_scbd28", "uart_cfg28", cfg.uart_cfg28);
  //uvm_config_db#(apb_slave_config28)::set(this, "*x_scbd28", "apb_slave_cfg28", cfg.apb_cfg28.slave_configs28[0]);
  uvm_config_object::set(this, "*x_scbd28", "uart_cfg28", cfg.uart_cfg28);
  uvm_config_object::set(this, "*x_scbd28", "apb_slave_cfg28", cfg.apb_cfg28.slave_configs28[0]);
  tx_scbd28 = uart_ctrl_tx_scbd28::type_id::create("tx_scbd28",this);
  rx_scbd28 = uart_ctrl_rx_scbd28::type_id::create("rx_scbd28",this);
endfunction : build_phase
   
function void uart_ctrl_monitor28::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get28 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if28)::get(this, "", "vif28", vif28))
      `uvm_error("NOVIF28",{"virtual interface must be set for: ",get_full_name(),".vif28"})
  apb_out28.connect(tx_scbd28.apb_match28);
  uart_tx_out28.connect(tx_scbd28.uart_add28);
  apb_out28.connect(rx_scbd28.apb_add28);
  uart_rx_out28.connect(rx_scbd28.uart_match28);
endfunction : connect_phase

// implement UART28 Rx28 analysis28 port
function void uart_ctrl_monitor28::write_rx28(uart_frame28 frame28);
  uart_rx_out28.write(frame28);
  tx_time_in28 = tx_time_q28.pop_back();
  tx_time_out28 = ($time-tx_time_in28)/clk_period28;
endfunction : write_rx28
   
// implement UART28 Tx28 analysis28 port
function void uart_ctrl_monitor28::write_tx28(uart_frame28 frame28);
  uart_tx_out28.write(frame28);
  rx_time_q28.push_front($time); 
endfunction : write_tx28

// implement UART28 Config28 analysis28 port
function void uart_ctrl_monitor28::write_cfg28(uart_config28 uart_cfg28);
   set_uart_config28(uart_cfg28);
endfunction : write_cfg28

  // implement APB28 analysis28 port 
function void uart_ctrl_monitor28::write_apb28(apb_transfer28 transfer28);
    apb_out28.write(transfer28);
  if ((transfer28.direction28 == APB_READ28)  && (transfer28.addr == `RX_FIFO_REG28))
     begin
       rx_time_in28 = rx_time_q28.pop_back();
       rx_time_out28 = ($time-rx_time_in28)/clk_period28;
     end
  else if ((transfer28.direction28 == APB_WRITE28)  && (transfer28.addr == `TX_FIFO_REG28))
     begin
       tx_time_q28.push_front($time); 
     end
    
endfunction : write_apb28

function void uart_ctrl_monitor28::update_config28(uart_ctrl_config28 uart_ctrl_cfg28, int index);
  `uvm_info(get_type_name(), {"Updating Config28\n", uart_ctrl_cfg28.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg28;
   tx_scbd28.slave_cfg28 = uart_ctrl_cfg28.apb_cfg28.slave_configs28[index];
   tx_scbd28.uart_cfg28 = uart_ctrl_cfg28.uart_cfg28;
   rx_scbd28.slave_cfg28 = uart_ctrl_cfg28.apb_cfg28.slave_configs28[index];
   rx_scbd28.uart_cfg28 = uart_ctrl_cfg28.uart_cfg28;
endfunction : update_config28

function void uart_ctrl_monitor28::set_slave_config28(apb_slave_config28 slave_cfg28, int index);
   cfg.apb_cfg28.slave_configs28[index] = slave_cfg28;
   tx_scbd28.slave_cfg28 = slave_cfg28;
   rx_scbd28.slave_cfg28 = slave_cfg28;
endfunction : set_slave_config28

function void uart_ctrl_monitor28::set_uart_config28(uart_config28 uart_cfg28);
   cfg.uart_cfg28     = uart_cfg28;
   tx_scbd28.uart_cfg28 = uart_cfg28;
   rx_scbd28.uart_cfg28 = uart_cfg28;
endfunction : set_uart_config28
