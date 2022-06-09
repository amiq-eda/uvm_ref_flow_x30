/*-------------------------------------------------------------------------
File5 name   : uart_ctrl_monitor5.sv
Title5       : UART5 Controller5 Monitor5
Project5     :
Created5     :
Description5 : Module5 monitor5
Notes5       : 
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

// TLM Port5 Declarations5
`uvm_analysis_imp_decl(_rx5)
`uvm_analysis_imp_decl(_tx5)
`uvm_analysis_imp_decl(_cfg5)

class uart_ctrl_monitor5 extends uvm_monitor;

  // Virtual interface to DUT signals5 if necessary5 (OPTIONAL5)
  virtual interface uart_ctrl_internal_if5 vif5;

  time rx_time_q5[$];
  time tx_time_q5[$];
  time tx_time_out5, tx_time_in5, rx_time_out5, rx_time_in5, clk_period5;

  // UART5 Controller5 Configuration5 Information5
  uart_ctrl_config5 cfg;

  // UART5 Controller5 coverage5
  uart_ctrl_cover5 uart_cover5;

  // Scoreboards5
  uart_ctrl_tx_scbd5 tx_scbd5;
  uart_ctrl_rx_scbd5 rx_scbd5;

  // TLM Connections5 to the interface UVC5 monitors5
  uvm_analysis_imp_apb5 #(apb_transfer5, uart_ctrl_monitor5) apb_in5;
  uvm_analysis_imp_rx5 #(uart_frame5, uart_ctrl_monitor5) uart_rx_in5;
  uvm_analysis_imp_tx5 #(uart_frame5, uart_ctrl_monitor5) uart_tx_in5;
  uvm_analysis_imp_cfg5 #(uart_config5, uart_ctrl_monitor5) uart_cfg_in5;

  // TLM Connections5 to other Components (Scoreboard5, updated config)
  uvm_analysis_port #(apb_transfer5) apb_out5;
  uvm_analysis_port #(uart_frame5) uart_rx_out5;
  uvm_analysis_port #(uart_frame5) uart_tx_out5;

  `uvm_component_utils_begin(uart_ctrl_monitor5)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports5(); // Create5 TLM Ports5
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif5.clock5) clk_period5 = $time;
    @(posedge vif5.clock5) clk_period5 = $time - clk_period5;
  endtask : run_phase
 
  // Additional5 class methods5
  extern virtual function void create_tlm_ports5();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx5(uart_frame5 frame5);
  extern virtual function void write_tx5(uart_frame5 frame5);
  extern virtual function void write_apb5(apb_transfer5 transfer5);
  extern virtual function void write_cfg5(uart_config5 uart_cfg5);
  extern virtual function void update_config5(uart_ctrl_config5 uart_ctrl_cfg5, int index);
  extern virtual function void set_slave_config5(apb_slave_config5 slave_cfg5, int index);
  extern virtual function void set_uart_config5(uart_config5 uart_cfg5);
endclass : uart_ctrl_monitor5

function void uart_ctrl_monitor5::create_tlm_ports5();
  apb_in5 = new("apb_in5", this);
  apb_out5 = new("apb_out5", this);
  uart_rx_in5 = new("uart_rx_in5", this);
  uart_rx_out5 = new("uart_rx_out5", this);
  uart_tx_in5 = new("uart_tx_in5", this);
  uart_tx_out5 = new("uart_tx_out5", this);
endfunction: create_tlm_ports5

function void uart_ctrl_monitor5::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover5 = uart_ctrl_cover5::type_id::create("uart_cover5",this);

  // Get5 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config5)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG5", "uart_ctrl_cfg5 is null...creating5 ", UVM_MEDIUM)
    cfg = uart_ctrl_config5::type_id::create("cfg", this);
    //set_config_object("tx_scbd5", "cfg", cfg);
    //set_config_object("rx_scbd5", "cfg", cfg);
  end
  //uvm_config_db#(uart_config5)::set(this, "*x_scbd5", "uart_cfg5", cfg.uart_cfg5);
  //uvm_config_db#(apb_slave_config5)::set(this, "*x_scbd5", "apb_slave_cfg5", cfg.apb_cfg5.slave_configs5[0]);
  uvm_config_object::set(this, "*x_scbd5", "uart_cfg5", cfg.uart_cfg5);
  uvm_config_object::set(this, "*x_scbd5", "apb_slave_cfg5", cfg.apb_cfg5.slave_configs5[0]);
  tx_scbd5 = uart_ctrl_tx_scbd5::type_id::create("tx_scbd5",this);
  rx_scbd5 = uart_ctrl_rx_scbd5::type_id::create("rx_scbd5",this);
endfunction : build_phase
   
function void uart_ctrl_monitor5::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get5 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if5)::get(this, "", "vif5", vif5))
      `uvm_error("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".vif5"})
  apb_out5.connect(tx_scbd5.apb_match5);
  uart_tx_out5.connect(tx_scbd5.uart_add5);
  apb_out5.connect(rx_scbd5.apb_add5);
  uart_rx_out5.connect(rx_scbd5.uart_match5);
endfunction : connect_phase

// implement UART5 Rx5 analysis5 port
function void uart_ctrl_monitor5::write_rx5(uart_frame5 frame5);
  uart_rx_out5.write(frame5);
  tx_time_in5 = tx_time_q5.pop_back();
  tx_time_out5 = ($time-tx_time_in5)/clk_period5;
endfunction : write_rx5
   
// implement UART5 Tx5 analysis5 port
function void uart_ctrl_monitor5::write_tx5(uart_frame5 frame5);
  uart_tx_out5.write(frame5);
  rx_time_q5.push_front($time); 
endfunction : write_tx5

// implement UART5 Config5 analysis5 port
function void uart_ctrl_monitor5::write_cfg5(uart_config5 uart_cfg5);
   set_uart_config5(uart_cfg5);
endfunction : write_cfg5

  // implement APB5 analysis5 port 
function void uart_ctrl_monitor5::write_apb5(apb_transfer5 transfer5);
    apb_out5.write(transfer5);
  if ((transfer5.direction5 == APB_READ5)  && (transfer5.addr == `RX_FIFO_REG5))
     begin
       rx_time_in5 = rx_time_q5.pop_back();
       rx_time_out5 = ($time-rx_time_in5)/clk_period5;
     end
  else if ((transfer5.direction5 == APB_WRITE5)  && (transfer5.addr == `TX_FIFO_REG5))
     begin
       tx_time_q5.push_front($time); 
     end
    
endfunction : write_apb5

function void uart_ctrl_monitor5::update_config5(uart_ctrl_config5 uart_ctrl_cfg5, int index);
  `uvm_info(get_type_name(), {"Updating Config5\n", uart_ctrl_cfg5.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg5;
   tx_scbd5.slave_cfg5 = uart_ctrl_cfg5.apb_cfg5.slave_configs5[index];
   tx_scbd5.uart_cfg5 = uart_ctrl_cfg5.uart_cfg5;
   rx_scbd5.slave_cfg5 = uart_ctrl_cfg5.apb_cfg5.slave_configs5[index];
   rx_scbd5.uart_cfg5 = uart_ctrl_cfg5.uart_cfg5;
endfunction : update_config5

function void uart_ctrl_monitor5::set_slave_config5(apb_slave_config5 slave_cfg5, int index);
   cfg.apb_cfg5.slave_configs5[index] = slave_cfg5;
   tx_scbd5.slave_cfg5 = slave_cfg5;
   rx_scbd5.slave_cfg5 = slave_cfg5;
endfunction : set_slave_config5

function void uart_ctrl_monitor5::set_uart_config5(uart_config5 uart_cfg5);
   cfg.uart_cfg5     = uart_cfg5;
   tx_scbd5.uart_cfg5 = uart_cfg5;
   rx_scbd5.uart_cfg5 = uart_cfg5;
endfunction : set_uart_config5
