/*-------------------------------------------------------------------------
File18 name   : uart_ctrl_monitor18.sv
Title18       : UART18 Controller18 Monitor18
Project18     :
Created18     :
Description18 : Module18 monitor18
Notes18       : 
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

// TLM Port18 Declarations18
`uvm_analysis_imp_decl(_rx18)
`uvm_analysis_imp_decl(_tx18)
`uvm_analysis_imp_decl(_cfg18)

class uart_ctrl_monitor18 extends uvm_monitor;

  // Virtual interface to DUT signals18 if necessary18 (OPTIONAL18)
  virtual interface uart_ctrl_internal_if18 vif18;

  time rx_time_q18[$];
  time tx_time_q18[$];
  time tx_time_out18, tx_time_in18, rx_time_out18, rx_time_in18, clk_period18;

  // UART18 Controller18 Configuration18 Information18
  uart_ctrl_config18 cfg;

  // UART18 Controller18 coverage18
  uart_ctrl_cover18 uart_cover18;

  // Scoreboards18
  uart_ctrl_tx_scbd18 tx_scbd18;
  uart_ctrl_rx_scbd18 rx_scbd18;

  // TLM Connections18 to the interface UVC18 monitors18
  uvm_analysis_imp_apb18 #(apb_transfer18, uart_ctrl_monitor18) apb_in18;
  uvm_analysis_imp_rx18 #(uart_frame18, uart_ctrl_monitor18) uart_rx_in18;
  uvm_analysis_imp_tx18 #(uart_frame18, uart_ctrl_monitor18) uart_tx_in18;
  uvm_analysis_imp_cfg18 #(uart_config18, uart_ctrl_monitor18) uart_cfg_in18;

  // TLM Connections18 to other Components (Scoreboard18, updated config)
  uvm_analysis_port #(apb_transfer18) apb_out18;
  uvm_analysis_port #(uart_frame18) uart_rx_out18;
  uvm_analysis_port #(uart_frame18) uart_tx_out18;

  `uvm_component_utils_begin(uart_ctrl_monitor18)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports18(); // Create18 TLM Ports18
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif18.clock18) clk_period18 = $time;
    @(posedge vif18.clock18) clk_period18 = $time - clk_period18;
  endtask : run_phase
 
  // Additional18 class methods18
  extern virtual function void create_tlm_ports18();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx18(uart_frame18 frame18);
  extern virtual function void write_tx18(uart_frame18 frame18);
  extern virtual function void write_apb18(apb_transfer18 transfer18);
  extern virtual function void write_cfg18(uart_config18 uart_cfg18);
  extern virtual function void update_config18(uart_ctrl_config18 uart_ctrl_cfg18, int index);
  extern virtual function void set_slave_config18(apb_slave_config18 slave_cfg18, int index);
  extern virtual function void set_uart_config18(uart_config18 uart_cfg18);
endclass : uart_ctrl_monitor18

function void uart_ctrl_monitor18::create_tlm_ports18();
  apb_in18 = new("apb_in18", this);
  apb_out18 = new("apb_out18", this);
  uart_rx_in18 = new("uart_rx_in18", this);
  uart_rx_out18 = new("uart_rx_out18", this);
  uart_tx_in18 = new("uart_tx_in18", this);
  uart_tx_out18 = new("uart_tx_out18", this);
endfunction: create_tlm_ports18

function void uart_ctrl_monitor18::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover18 = uart_ctrl_cover18::type_id::create("uart_cover18",this);

  // Get18 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config18)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG18", "uart_ctrl_cfg18 is null...creating18 ", UVM_MEDIUM)
    cfg = uart_ctrl_config18::type_id::create("cfg", this);
    //set_config_object("tx_scbd18", "cfg", cfg);
    //set_config_object("rx_scbd18", "cfg", cfg);
  end
  //uvm_config_db#(uart_config18)::set(this, "*x_scbd18", "uart_cfg18", cfg.uart_cfg18);
  //uvm_config_db#(apb_slave_config18)::set(this, "*x_scbd18", "apb_slave_cfg18", cfg.apb_cfg18.slave_configs18[0]);
  uvm_config_object::set(this, "*x_scbd18", "uart_cfg18", cfg.uart_cfg18);
  uvm_config_object::set(this, "*x_scbd18", "apb_slave_cfg18", cfg.apb_cfg18.slave_configs18[0]);
  tx_scbd18 = uart_ctrl_tx_scbd18::type_id::create("tx_scbd18",this);
  rx_scbd18 = uart_ctrl_rx_scbd18::type_id::create("rx_scbd18",this);
endfunction : build_phase
   
function void uart_ctrl_monitor18::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get18 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if18)::get(this, "", "vif18", vif18))
      `uvm_error("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".vif18"})
  apb_out18.connect(tx_scbd18.apb_match18);
  uart_tx_out18.connect(tx_scbd18.uart_add18);
  apb_out18.connect(rx_scbd18.apb_add18);
  uart_rx_out18.connect(rx_scbd18.uart_match18);
endfunction : connect_phase

// implement UART18 Rx18 analysis18 port
function void uart_ctrl_monitor18::write_rx18(uart_frame18 frame18);
  uart_rx_out18.write(frame18);
  tx_time_in18 = tx_time_q18.pop_back();
  tx_time_out18 = ($time-tx_time_in18)/clk_period18;
endfunction : write_rx18
   
// implement UART18 Tx18 analysis18 port
function void uart_ctrl_monitor18::write_tx18(uart_frame18 frame18);
  uart_tx_out18.write(frame18);
  rx_time_q18.push_front($time); 
endfunction : write_tx18

// implement UART18 Config18 analysis18 port
function void uart_ctrl_monitor18::write_cfg18(uart_config18 uart_cfg18);
   set_uart_config18(uart_cfg18);
endfunction : write_cfg18

  // implement APB18 analysis18 port 
function void uart_ctrl_monitor18::write_apb18(apb_transfer18 transfer18);
    apb_out18.write(transfer18);
  if ((transfer18.direction18 == APB_READ18)  && (transfer18.addr == `RX_FIFO_REG18))
     begin
       rx_time_in18 = rx_time_q18.pop_back();
       rx_time_out18 = ($time-rx_time_in18)/clk_period18;
     end
  else if ((transfer18.direction18 == APB_WRITE18)  && (transfer18.addr == `TX_FIFO_REG18))
     begin
       tx_time_q18.push_front($time); 
     end
    
endfunction : write_apb18

function void uart_ctrl_monitor18::update_config18(uart_ctrl_config18 uart_ctrl_cfg18, int index);
  `uvm_info(get_type_name(), {"Updating Config18\n", uart_ctrl_cfg18.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg18;
   tx_scbd18.slave_cfg18 = uart_ctrl_cfg18.apb_cfg18.slave_configs18[index];
   tx_scbd18.uart_cfg18 = uart_ctrl_cfg18.uart_cfg18;
   rx_scbd18.slave_cfg18 = uart_ctrl_cfg18.apb_cfg18.slave_configs18[index];
   rx_scbd18.uart_cfg18 = uart_ctrl_cfg18.uart_cfg18;
endfunction : update_config18

function void uart_ctrl_monitor18::set_slave_config18(apb_slave_config18 slave_cfg18, int index);
   cfg.apb_cfg18.slave_configs18[index] = slave_cfg18;
   tx_scbd18.slave_cfg18 = slave_cfg18;
   rx_scbd18.slave_cfg18 = slave_cfg18;
endfunction : set_slave_config18

function void uart_ctrl_monitor18::set_uart_config18(uart_config18 uart_cfg18);
   cfg.uart_cfg18     = uart_cfg18;
   tx_scbd18.uart_cfg18 = uart_cfg18;
   rx_scbd18.uart_cfg18 = uart_cfg18;
endfunction : set_uart_config18
