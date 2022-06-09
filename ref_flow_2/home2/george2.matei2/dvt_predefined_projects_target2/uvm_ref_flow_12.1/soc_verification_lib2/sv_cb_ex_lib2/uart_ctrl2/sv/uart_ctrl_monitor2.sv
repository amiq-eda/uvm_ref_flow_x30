/*-------------------------------------------------------------------------
File2 name   : uart_ctrl_monitor2.sv
Title2       : UART2 Controller2 Monitor2
Project2     :
Created2     :
Description2 : Module2 monitor2
Notes2       : 
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

// TLM Port2 Declarations2
`uvm_analysis_imp_decl(_rx2)
`uvm_analysis_imp_decl(_tx2)
`uvm_analysis_imp_decl(_cfg2)

class uart_ctrl_monitor2 extends uvm_monitor;

  // Virtual interface to DUT signals2 if necessary2 (OPTIONAL2)
  virtual interface uart_ctrl_internal_if2 vif2;

  time rx_time_q2[$];
  time tx_time_q2[$];
  time tx_time_out2, tx_time_in2, rx_time_out2, rx_time_in2, clk_period2;

  // UART2 Controller2 Configuration2 Information2
  uart_ctrl_config2 cfg;

  // UART2 Controller2 coverage2
  uart_ctrl_cover2 uart_cover2;

  // Scoreboards2
  uart_ctrl_tx_scbd2 tx_scbd2;
  uart_ctrl_rx_scbd2 rx_scbd2;

  // TLM Connections2 to the interface UVC2 monitors2
  uvm_analysis_imp_apb2 #(apb_transfer2, uart_ctrl_monitor2) apb_in2;
  uvm_analysis_imp_rx2 #(uart_frame2, uart_ctrl_monitor2) uart_rx_in2;
  uvm_analysis_imp_tx2 #(uart_frame2, uart_ctrl_monitor2) uart_tx_in2;
  uvm_analysis_imp_cfg2 #(uart_config2, uart_ctrl_monitor2) uart_cfg_in2;

  // TLM Connections2 to other Components (Scoreboard2, updated config)
  uvm_analysis_port #(apb_transfer2) apb_out2;
  uvm_analysis_port #(uart_frame2) uart_rx_out2;
  uvm_analysis_port #(uart_frame2) uart_tx_out2;

  `uvm_component_utils_begin(uart_ctrl_monitor2)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports2(); // Create2 TLM Ports2
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif2.clock2) clk_period2 = $time;
    @(posedge vif2.clock2) clk_period2 = $time - clk_period2;
  endtask : run_phase
 
  // Additional2 class methods2
  extern virtual function void create_tlm_ports2();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx2(uart_frame2 frame2);
  extern virtual function void write_tx2(uart_frame2 frame2);
  extern virtual function void write_apb2(apb_transfer2 transfer2);
  extern virtual function void write_cfg2(uart_config2 uart_cfg2);
  extern virtual function void update_config2(uart_ctrl_config2 uart_ctrl_cfg2, int index);
  extern virtual function void set_slave_config2(apb_slave_config2 slave_cfg2, int index);
  extern virtual function void set_uart_config2(uart_config2 uart_cfg2);
endclass : uart_ctrl_monitor2

function void uart_ctrl_monitor2::create_tlm_ports2();
  apb_in2 = new("apb_in2", this);
  apb_out2 = new("apb_out2", this);
  uart_rx_in2 = new("uart_rx_in2", this);
  uart_rx_out2 = new("uart_rx_out2", this);
  uart_tx_in2 = new("uart_tx_in2", this);
  uart_tx_out2 = new("uart_tx_out2", this);
endfunction: create_tlm_ports2

function void uart_ctrl_monitor2::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover2 = uart_ctrl_cover2::type_id::create("uart_cover2",this);

  // Get2 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config2)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG2", "uart_ctrl_cfg2 is null...creating2 ", UVM_MEDIUM)
    cfg = uart_ctrl_config2::type_id::create("cfg", this);
    //set_config_object("tx_scbd2", "cfg", cfg);
    //set_config_object("rx_scbd2", "cfg", cfg);
  end
  //uvm_config_db#(uart_config2)::set(this, "*x_scbd2", "uart_cfg2", cfg.uart_cfg2);
  //uvm_config_db#(apb_slave_config2)::set(this, "*x_scbd2", "apb_slave_cfg2", cfg.apb_cfg2.slave_configs2[0]);
  uvm_config_object::set(this, "*x_scbd2", "uart_cfg2", cfg.uart_cfg2);
  uvm_config_object::set(this, "*x_scbd2", "apb_slave_cfg2", cfg.apb_cfg2.slave_configs2[0]);
  tx_scbd2 = uart_ctrl_tx_scbd2::type_id::create("tx_scbd2",this);
  rx_scbd2 = uart_ctrl_rx_scbd2::type_id::create("rx_scbd2",this);
endfunction : build_phase
   
function void uart_ctrl_monitor2::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get2 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if2)::get(this, "", "vif2", vif2))
      `uvm_error("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".vif2"})
  apb_out2.connect(tx_scbd2.apb_match2);
  uart_tx_out2.connect(tx_scbd2.uart_add2);
  apb_out2.connect(rx_scbd2.apb_add2);
  uart_rx_out2.connect(rx_scbd2.uart_match2);
endfunction : connect_phase

// implement UART2 Rx2 analysis2 port
function void uart_ctrl_monitor2::write_rx2(uart_frame2 frame2);
  uart_rx_out2.write(frame2);
  tx_time_in2 = tx_time_q2.pop_back();
  tx_time_out2 = ($time-tx_time_in2)/clk_period2;
endfunction : write_rx2
   
// implement UART2 Tx2 analysis2 port
function void uart_ctrl_monitor2::write_tx2(uart_frame2 frame2);
  uart_tx_out2.write(frame2);
  rx_time_q2.push_front($time); 
endfunction : write_tx2

// implement UART2 Config2 analysis2 port
function void uart_ctrl_monitor2::write_cfg2(uart_config2 uart_cfg2);
   set_uart_config2(uart_cfg2);
endfunction : write_cfg2

  // implement APB2 analysis2 port 
function void uart_ctrl_monitor2::write_apb2(apb_transfer2 transfer2);
    apb_out2.write(transfer2);
  if ((transfer2.direction2 == APB_READ2)  && (transfer2.addr == `RX_FIFO_REG2))
     begin
       rx_time_in2 = rx_time_q2.pop_back();
       rx_time_out2 = ($time-rx_time_in2)/clk_period2;
     end
  else if ((transfer2.direction2 == APB_WRITE2)  && (transfer2.addr == `TX_FIFO_REG2))
     begin
       tx_time_q2.push_front($time); 
     end
    
endfunction : write_apb2

function void uart_ctrl_monitor2::update_config2(uart_ctrl_config2 uart_ctrl_cfg2, int index);
  `uvm_info(get_type_name(), {"Updating Config2\n", uart_ctrl_cfg2.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg2;
   tx_scbd2.slave_cfg2 = uart_ctrl_cfg2.apb_cfg2.slave_configs2[index];
   tx_scbd2.uart_cfg2 = uart_ctrl_cfg2.uart_cfg2;
   rx_scbd2.slave_cfg2 = uart_ctrl_cfg2.apb_cfg2.slave_configs2[index];
   rx_scbd2.uart_cfg2 = uart_ctrl_cfg2.uart_cfg2;
endfunction : update_config2

function void uart_ctrl_monitor2::set_slave_config2(apb_slave_config2 slave_cfg2, int index);
   cfg.apb_cfg2.slave_configs2[index] = slave_cfg2;
   tx_scbd2.slave_cfg2 = slave_cfg2;
   rx_scbd2.slave_cfg2 = slave_cfg2;
endfunction : set_slave_config2

function void uart_ctrl_monitor2::set_uart_config2(uart_config2 uart_cfg2);
   cfg.uart_cfg2     = uart_cfg2;
   tx_scbd2.uart_cfg2 = uart_cfg2;
   rx_scbd2.uart_cfg2 = uart_cfg2;
endfunction : set_uart_config2
