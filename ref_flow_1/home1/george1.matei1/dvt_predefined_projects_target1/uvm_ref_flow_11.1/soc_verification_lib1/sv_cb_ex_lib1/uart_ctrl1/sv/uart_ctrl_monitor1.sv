/*-------------------------------------------------------------------------
File1 name   : uart_ctrl_monitor1.sv
Title1       : UART1 Controller1 Monitor1
Project1     :
Created1     :
Description1 : Module1 monitor1
Notes1       : 
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

// TLM Port1 Declarations1
`uvm_analysis_imp_decl(_rx1)
`uvm_analysis_imp_decl(_tx1)
`uvm_analysis_imp_decl(_cfg1)

class uart_ctrl_monitor1 extends uvm_monitor;

  // Virtual interface to DUT signals1 if necessary1 (OPTIONAL1)
  virtual interface uart_ctrl_internal_if1 vif1;

  time rx_time_q1[$];
  time tx_time_q1[$];
  time tx_time_out1, tx_time_in1, rx_time_out1, rx_time_in1, clk_period1;

  // UART1 Controller1 Configuration1 Information1
  uart_ctrl_config1 cfg;

  // UART1 Controller1 coverage1
  uart_ctrl_cover1 uart_cover1;

  // Scoreboards1
  uart_ctrl_tx_scbd1 tx_scbd1;
  uart_ctrl_rx_scbd1 rx_scbd1;

  // TLM Connections1 to the interface UVC1 monitors1
  uvm_analysis_imp_apb1 #(apb_transfer1, uart_ctrl_monitor1) apb_in1;
  uvm_analysis_imp_rx1 #(uart_frame1, uart_ctrl_monitor1) uart_rx_in1;
  uvm_analysis_imp_tx1 #(uart_frame1, uart_ctrl_monitor1) uart_tx_in1;
  uvm_analysis_imp_cfg1 #(uart_config1, uart_ctrl_monitor1) uart_cfg_in1;

  // TLM Connections1 to other Components (Scoreboard1, updated config)
  uvm_analysis_port #(apb_transfer1) apb_out1;
  uvm_analysis_port #(uart_frame1) uart_rx_out1;
  uvm_analysis_port #(uart_frame1) uart_tx_out1;

  `uvm_component_utils_begin(uart_ctrl_monitor1)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports1(); // Create1 TLM Ports1
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif1.clock1) clk_period1 = $time;
    @(posedge vif1.clock1) clk_period1 = $time - clk_period1;
  endtask : run_phase
 
  // Additional1 class methods1
  extern virtual function void create_tlm_ports1();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx1(uart_frame1 frame1);
  extern virtual function void write_tx1(uart_frame1 frame1);
  extern virtual function void write_apb1(apb_transfer1 transfer1);
  extern virtual function void write_cfg1(uart_config1 uart_cfg1);
  extern virtual function void update_config1(uart_ctrl_config1 uart_ctrl_cfg1, int index);
  extern virtual function void set_slave_config1(apb_slave_config1 slave_cfg1, int index);
  extern virtual function void set_uart_config1(uart_config1 uart_cfg1);
endclass : uart_ctrl_monitor1

function void uart_ctrl_monitor1::create_tlm_ports1();
  apb_in1 = new("apb_in1", this);
  apb_out1 = new("apb_out1", this);
  uart_rx_in1 = new("uart_rx_in1", this);
  uart_rx_out1 = new("uart_rx_out1", this);
  uart_tx_in1 = new("uart_tx_in1", this);
  uart_tx_out1 = new("uart_tx_out1", this);
endfunction: create_tlm_ports1

function void uart_ctrl_monitor1::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover1 = uart_ctrl_cover1::type_id::create("uart_cover1",this);

  // Get1 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config1)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG1", "uart_ctrl_cfg1 is null...creating1 ", UVM_MEDIUM)
    cfg = uart_ctrl_config1::type_id::create("cfg", this);
    //set_config_object("tx_scbd1", "cfg", cfg);
    //set_config_object("rx_scbd1", "cfg", cfg);
  end
  //uvm_config_db#(uart_config1)::set(this, "*x_scbd1", "uart_cfg1", cfg.uart_cfg1);
  //uvm_config_db#(apb_slave_config1)::set(this, "*x_scbd1", "apb_slave_cfg1", cfg.apb_cfg1.slave_configs1[0]);
  uvm_config_object::set(this, "*x_scbd1", "uart_cfg1", cfg.uart_cfg1);
  uvm_config_object::set(this, "*x_scbd1", "apb_slave_cfg1", cfg.apb_cfg1.slave_configs1[0]);
  tx_scbd1 = uart_ctrl_tx_scbd1::type_id::create("tx_scbd1",this);
  rx_scbd1 = uart_ctrl_rx_scbd1::type_id::create("rx_scbd1",this);
endfunction : build_phase
   
function void uart_ctrl_monitor1::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get1 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if1)::get(this, "", "vif1", vif1))
      `uvm_error("NOVIF1",{"virtual interface must be set for: ",get_full_name(),".vif1"})
  apb_out1.connect(tx_scbd1.apb_match1);
  uart_tx_out1.connect(tx_scbd1.uart_add1);
  apb_out1.connect(rx_scbd1.apb_add1);
  uart_rx_out1.connect(rx_scbd1.uart_match1);
endfunction : connect_phase

// implement UART1 Rx1 analysis1 port
function void uart_ctrl_monitor1::write_rx1(uart_frame1 frame1);
  uart_rx_out1.write(frame1);
  tx_time_in1 = tx_time_q1.pop_back();
  tx_time_out1 = ($time-tx_time_in1)/clk_period1;
endfunction : write_rx1
   
// implement UART1 Tx1 analysis1 port
function void uart_ctrl_monitor1::write_tx1(uart_frame1 frame1);
  uart_tx_out1.write(frame1);
  rx_time_q1.push_front($time); 
endfunction : write_tx1

// implement UART1 Config1 analysis1 port
function void uart_ctrl_monitor1::write_cfg1(uart_config1 uart_cfg1);
   set_uart_config1(uart_cfg1);
endfunction : write_cfg1

  // implement APB1 analysis1 port 
function void uart_ctrl_monitor1::write_apb1(apb_transfer1 transfer1);
    apb_out1.write(transfer1);
  if ((transfer1.direction1 == APB_READ1)  && (transfer1.addr == `RX_FIFO_REG1))
     begin
       rx_time_in1 = rx_time_q1.pop_back();
       rx_time_out1 = ($time-rx_time_in1)/clk_period1;
     end
  else if ((transfer1.direction1 == APB_WRITE1)  && (transfer1.addr == `TX_FIFO_REG1))
     begin
       tx_time_q1.push_front($time); 
     end
    
endfunction : write_apb1

function void uart_ctrl_monitor1::update_config1(uart_ctrl_config1 uart_ctrl_cfg1, int index);
  `uvm_info(get_type_name(), {"Updating Config1\n", uart_ctrl_cfg1.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg1;
   tx_scbd1.slave_cfg1 = uart_ctrl_cfg1.apb_cfg1.slave_configs1[index];
   tx_scbd1.uart_cfg1 = uart_ctrl_cfg1.uart_cfg1;
   rx_scbd1.slave_cfg1 = uart_ctrl_cfg1.apb_cfg1.slave_configs1[index];
   rx_scbd1.uart_cfg1 = uart_ctrl_cfg1.uart_cfg1;
endfunction : update_config1

function void uart_ctrl_monitor1::set_slave_config1(apb_slave_config1 slave_cfg1, int index);
   cfg.apb_cfg1.slave_configs1[index] = slave_cfg1;
   tx_scbd1.slave_cfg1 = slave_cfg1;
   rx_scbd1.slave_cfg1 = slave_cfg1;
endfunction : set_slave_config1

function void uart_ctrl_monitor1::set_uart_config1(uart_config1 uart_cfg1);
   cfg.uart_cfg1     = uart_cfg1;
   tx_scbd1.uart_cfg1 = uart_cfg1;
   rx_scbd1.uart_cfg1 = uart_cfg1;
endfunction : set_uart_config1
