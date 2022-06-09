/*-------------------------------------------------------------------------
File6 name   : uart_ctrl_monitor6.sv
Title6       : UART6 Controller6 Monitor6
Project6     :
Created6     :
Description6 : Module6 monitor6
Notes6       : 
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

// TLM Port6 Declarations6
`uvm_analysis_imp_decl(_rx6)
`uvm_analysis_imp_decl(_tx6)
`uvm_analysis_imp_decl(_cfg6)

class uart_ctrl_monitor6 extends uvm_monitor;

  // Virtual interface to DUT signals6 if necessary6 (OPTIONAL6)
  virtual interface uart_ctrl_internal_if6 vif6;

  time rx_time_q6[$];
  time tx_time_q6[$];
  time tx_time_out6, tx_time_in6, rx_time_out6, rx_time_in6, clk_period6;

  // UART6 Controller6 Configuration6 Information6
  uart_ctrl_config6 cfg;

  // UART6 Controller6 coverage6
  uart_ctrl_cover6 uart_cover6;

  // Scoreboards6
  uart_ctrl_tx_scbd6 tx_scbd6;
  uart_ctrl_rx_scbd6 rx_scbd6;

  // TLM Connections6 to the interface UVC6 monitors6
  uvm_analysis_imp_apb6 #(apb_transfer6, uart_ctrl_monitor6) apb_in6;
  uvm_analysis_imp_rx6 #(uart_frame6, uart_ctrl_monitor6) uart_rx_in6;
  uvm_analysis_imp_tx6 #(uart_frame6, uart_ctrl_monitor6) uart_tx_in6;
  uvm_analysis_imp_cfg6 #(uart_config6, uart_ctrl_monitor6) uart_cfg_in6;

  // TLM Connections6 to other Components (Scoreboard6, updated config)
  uvm_analysis_port #(apb_transfer6) apb_out6;
  uvm_analysis_port #(uart_frame6) uart_rx_out6;
  uvm_analysis_port #(uart_frame6) uart_tx_out6;

  `uvm_component_utils_begin(uart_ctrl_monitor6)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports6(); // Create6 TLM Ports6
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif6.clock6) clk_period6 = $time;
    @(posedge vif6.clock6) clk_period6 = $time - clk_period6;
  endtask : run_phase
 
  // Additional6 class methods6
  extern virtual function void create_tlm_ports6();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx6(uart_frame6 frame6);
  extern virtual function void write_tx6(uart_frame6 frame6);
  extern virtual function void write_apb6(apb_transfer6 transfer6);
  extern virtual function void write_cfg6(uart_config6 uart_cfg6);
  extern virtual function void update_config6(uart_ctrl_config6 uart_ctrl_cfg6, int index);
  extern virtual function void set_slave_config6(apb_slave_config6 slave_cfg6, int index);
  extern virtual function void set_uart_config6(uart_config6 uart_cfg6);
endclass : uart_ctrl_monitor6

function void uart_ctrl_monitor6::create_tlm_ports6();
  apb_in6 = new("apb_in6", this);
  apb_out6 = new("apb_out6", this);
  uart_rx_in6 = new("uart_rx_in6", this);
  uart_rx_out6 = new("uart_rx_out6", this);
  uart_tx_in6 = new("uart_tx_in6", this);
  uart_tx_out6 = new("uart_tx_out6", this);
endfunction: create_tlm_ports6

function void uart_ctrl_monitor6::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover6 = uart_ctrl_cover6::type_id::create("uart_cover6",this);

  // Get6 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config6)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG6", "uart_ctrl_cfg6 is null...creating6 ", UVM_MEDIUM)
    cfg = uart_ctrl_config6::type_id::create("cfg", this);
    //set_config_object("tx_scbd6", "cfg", cfg);
    //set_config_object("rx_scbd6", "cfg", cfg);
  end
  //uvm_config_db#(uart_config6)::set(this, "*x_scbd6", "uart_cfg6", cfg.uart_cfg6);
  //uvm_config_db#(apb_slave_config6)::set(this, "*x_scbd6", "apb_slave_cfg6", cfg.apb_cfg6.slave_configs6[0]);
  uvm_config_object::set(this, "*x_scbd6", "uart_cfg6", cfg.uart_cfg6);
  uvm_config_object::set(this, "*x_scbd6", "apb_slave_cfg6", cfg.apb_cfg6.slave_configs6[0]);
  tx_scbd6 = uart_ctrl_tx_scbd6::type_id::create("tx_scbd6",this);
  rx_scbd6 = uart_ctrl_rx_scbd6::type_id::create("rx_scbd6",this);
endfunction : build_phase
   
function void uart_ctrl_monitor6::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get6 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if6)::get(this, "", "vif6", vif6))
      `uvm_error("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".vif6"})
  apb_out6.connect(tx_scbd6.apb_match6);
  uart_tx_out6.connect(tx_scbd6.uart_add6);
  apb_out6.connect(rx_scbd6.apb_add6);
  uart_rx_out6.connect(rx_scbd6.uart_match6);
endfunction : connect_phase

// implement UART6 Rx6 analysis6 port
function void uart_ctrl_monitor6::write_rx6(uart_frame6 frame6);
  uart_rx_out6.write(frame6);
  tx_time_in6 = tx_time_q6.pop_back();
  tx_time_out6 = ($time-tx_time_in6)/clk_period6;
endfunction : write_rx6
   
// implement UART6 Tx6 analysis6 port
function void uart_ctrl_monitor6::write_tx6(uart_frame6 frame6);
  uart_tx_out6.write(frame6);
  rx_time_q6.push_front($time); 
endfunction : write_tx6

// implement UART6 Config6 analysis6 port
function void uart_ctrl_monitor6::write_cfg6(uart_config6 uart_cfg6);
   set_uart_config6(uart_cfg6);
endfunction : write_cfg6

  // implement APB6 analysis6 port 
function void uart_ctrl_monitor6::write_apb6(apb_transfer6 transfer6);
    apb_out6.write(transfer6);
  if ((transfer6.direction6 == APB_READ6)  && (transfer6.addr == `RX_FIFO_REG6))
     begin
       rx_time_in6 = rx_time_q6.pop_back();
       rx_time_out6 = ($time-rx_time_in6)/clk_period6;
     end
  else if ((transfer6.direction6 == APB_WRITE6)  && (transfer6.addr == `TX_FIFO_REG6))
     begin
       tx_time_q6.push_front($time); 
     end
    
endfunction : write_apb6

function void uart_ctrl_monitor6::update_config6(uart_ctrl_config6 uart_ctrl_cfg6, int index);
  `uvm_info(get_type_name(), {"Updating Config6\n", uart_ctrl_cfg6.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg6;
   tx_scbd6.slave_cfg6 = uart_ctrl_cfg6.apb_cfg6.slave_configs6[index];
   tx_scbd6.uart_cfg6 = uart_ctrl_cfg6.uart_cfg6;
   rx_scbd6.slave_cfg6 = uart_ctrl_cfg6.apb_cfg6.slave_configs6[index];
   rx_scbd6.uart_cfg6 = uart_ctrl_cfg6.uart_cfg6;
endfunction : update_config6

function void uart_ctrl_monitor6::set_slave_config6(apb_slave_config6 slave_cfg6, int index);
   cfg.apb_cfg6.slave_configs6[index] = slave_cfg6;
   tx_scbd6.slave_cfg6 = slave_cfg6;
   rx_scbd6.slave_cfg6 = slave_cfg6;
endfunction : set_slave_config6

function void uart_ctrl_monitor6::set_uart_config6(uart_config6 uart_cfg6);
   cfg.uart_cfg6     = uart_cfg6;
   tx_scbd6.uart_cfg6 = uart_cfg6;
   rx_scbd6.uart_cfg6 = uart_cfg6;
endfunction : set_uart_config6
