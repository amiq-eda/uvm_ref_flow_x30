/*-------------------------------------------------------------------------
File9 name   : uart_ctrl_monitor9.sv
Title9       : UART9 Controller9 Monitor9
Project9     :
Created9     :
Description9 : Module9 monitor9
Notes9       : 
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

// TLM Port9 Declarations9
`uvm_analysis_imp_decl(_rx9)
`uvm_analysis_imp_decl(_tx9)
`uvm_analysis_imp_decl(_cfg9)

class uart_ctrl_monitor9 extends uvm_monitor;

  // Virtual interface to DUT signals9 if necessary9 (OPTIONAL9)
  virtual interface uart_ctrl_internal_if9 vif9;

  time rx_time_q9[$];
  time tx_time_q9[$];
  time tx_time_out9, tx_time_in9, rx_time_out9, rx_time_in9, clk_period9;

  // UART9 Controller9 Configuration9 Information9
  uart_ctrl_config9 cfg;

  // UART9 Controller9 coverage9
  uart_ctrl_cover9 uart_cover9;

  // Scoreboards9
  uart_ctrl_tx_scbd9 tx_scbd9;
  uart_ctrl_rx_scbd9 rx_scbd9;

  // TLM Connections9 to the interface UVC9 monitors9
  uvm_analysis_imp_apb9 #(apb_transfer9, uart_ctrl_monitor9) apb_in9;
  uvm_analysis_imp_rx9 #(uart_frame9, uart_ctrl_monitor9) uart_rx_in9;
  uvm_analysis_imp_tx9 #(uart_frame9, uart_ctrl_monitor9) uart_tx_in9;
  uvm_analysis_imp_cfg9 #(uart_config9, uart_ctrl_monitor9) uart_cfg_in9;

  // TLM Connections9 to other Components (Scoreboard9, updated config)
  uvm_analysis_port #(apb_transfer9) apb_out9;
  uvm_analysis_port #(uart_frame9) uart_rx_out9;
  uvm_analysis_port #(uart_frame9) uart_tx_out9;

  `uvm_component_utils_begin(uart_ctrl_monitor9)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports9(); // Create9 TLM Ports9
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif9.clock9) clk_period9 = $time;
    @(posedge vif9.clock9) clk_period9 = $time - clk_period9;
  endtask : run_phase
 
  // Additional9 class methods9
  extern virtual function void create_tlm_ports9();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx9(uart_frame9 frame9);
  extern virtual function void write_tx9(uart_frame9 frame9);
  extern virtual function void write_apb9(apb_transfer9 transfer9);
  extern virtual function void write_cfg9(uart_config9 uart_cfg9);
  extern virtual function void update_config9(uart_ctrl_config9 uart_ctrl_cfg9, int index);
  extern virtual function void set_slave_config9(apb_slave_config9 slave_cfg9, int index);
  extern virtual function void set_uart_config9(uart_config9 uart_cfg9);
endclass : uart_ctrl_monitor9

function void uart_ctrl_monitor9::create_tlm_ports9();
  apb_in9 = new("apb_in9", this);
  apb_out9 = new("apb_out9", this);
  uart_rx_in9 = new("uart_rx_in9", this);
  uart_rx_out9 = new("uart_rx_out9", this);
  uart_tx_in9 = new("uart_tx_in9", this);
  uart_tx_out9 = new("uart_tx_out9", this);
endfunction: create_tlm_ports9

function void uart_ctrl_monitor9::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover9 = uart_ctrl_cover9::type_id::create("uart_cover9",this);

  // Get9 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config9)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG9", "uart_ctrl_cfg9 is null...creating9 ", UVM_MEDIUM)
    cfg = uart_ctrl_config9::type_id::create("cfg", this);
    //set_config_object("tx_scbd9", "cfg", cfg);
    //set_config_object("rx_scbd9", "cfg", cfg);
  end
  //uvm_config_db#(uart_config9)::set(this, "*x_scbd9", "uart_cfg9", cfg.uart_cfg9);
  //uvm_config_db#(apb_slave_config9)::set(this, "*x_scbd9", "apb_slave_cfg9", cfg.apb_cfg9.slave_configs9[0]);
  uvm_config_object::set(this, "*x_scbd9", "uart_cfg9", cfg.uart_cfg9);
  uvm_config_object::set(this, "*x_scbd9", "apb_slave_cfg9", cfg.apb_cfg9.slave_configs9[0]);
  tx_scbd9 = uart_ctrl_tx_scbd9::type_id::create("tx_scbd9",this);
  rx_scbd9 = uart_ctrl_rx_scbd9::type_id::create("rx_scbd9",this);
endfunction : build_phase
   
function void uart_ctrl_monitor9::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get9 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if9)::get(this, "", "vif9", vif9))
      `uvm_error("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".vif9"})
  apb_out9.connect(tx_scbd9.apb_match9);
  uart_tx_out9.connect(tx_scbd9.uart_add9);
  apb_out9.connect(rx_scbd9.apb_add9);
  uart_rx_out9.connect(rx_scbd9.uart_match9);
endfunction : connect_phase

// implement UART9 Rx9 analysis9 port
function void uart_ctrl_monitor9::write_rx9(uart_frame9 frame9);
  uart_rx_out9.write(frame9);
  tx_time_in9 = tx_time_q9.pop_back();
  tx_time_out9 = ($time-tx_time_in9)/clk_period9;
endfunction : write_rx9
   
// implement UART9 Tx9 analysis9 port
function void uart_ctrl_monitor9::write_tx9(uart_frame9 frame9);
  uart_tx_out9.write(frame9);
  rx_time_q9.push_front($time); 
endfunction : write_tx9

// implement UART9 Config9 analysis9 port
function void uart_ctrl_monitor9::write_cfg9(uart_config9 uart_cfg9);
   set_uart_config9(uart_cfg9);
endfunction : write_cfg9

  // implement APB9 analysis9 port 
function void uart_ctrl_monitor9::write_apb9(apb_transfer9 transfer9);
    apb_out9.write(transfer9);
  if ((transfer9.direction9 == APB_READ9)  && (transfer9.addr == `RX_FIFO_REG9))
     begin
       rx_time_in9 = rx_time_q9.pop_back();
       rx_time_out9 = ($time-rx_time_in9)/clk_period9;
     end
  else if ((transfer9.direction9 == APB_WRITE9)  && (transfer9.addr == `TX_FIFO_REG9))
     begin
       tx_time_q9.push_front($time); 
     end
    
endfunction : write_apb9

function void uart_ctrl_monitor9::update_config9(uart_ctrl_config9 uart_ctrl_cfg9, int index);
  `uvm_info(get_type_name(), {"Updating Config9\n", uart_ctrl_cfg9.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg9;
   tx_scbd9.slave_cfg9 = uart_ctrl_cfg9.apb_cfg9.slave_configs9[index];
   tx_scbd9.uart_cfg9 = uart_ctrl_cfg9.uart_cfg9;
   rx_scbd9.slave_cfg9 = uart_ctrl_cfg9.apb_cfg9.slave_configs9[index];
   rx_scbd9.uart_cfg9 = uart_ctrl_cfg9.uart_cfg9;
endfunction : update_config9

function void uart_ctrl_monitor9::set_slave_config9(apb_slave_config9 slave_cfg9, int index);
   cfg.apb_cfg9.slave_configs9[index] = slave_cfg9;
   tx_scbd9.slave_cfg9 = slave_cfg9;
   rx_scbd9.slave_cfg9 = slave_cfg9;
endfunction : set_slave_config9

function void uart_ctrl_monitor9::set_uart_config9(uart_config9 uart_cfg9);
   cfg.uart_cfg9     = uart_cfg9;
   tx_scbd9.uart_cfg9 = uart_cfg9;
   rx_scbd9.uart_cfg9 = uart_cfg9;
endfunction : set_uart_config9
