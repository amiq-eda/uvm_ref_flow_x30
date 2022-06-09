/*-------------------------------------------------------------------------
File20 name   : uart_ctrl_monitor20.sv
Title20       : UART20 Controller20 Monitor20
Project20     :
Created20     :
Description20 : Module20 monitor20
Notes20       : 
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

// TLM Port20 Declarations20
`uvm_analysis_imp_decl(_rx20)
`uvm_analysis_imp_decl(_tx20)
`uvm_analysis_imp_decl(_cfg20)

class uart_ctrl_monitor20 extends uvm_monitor;

  // Virtual interface to DUT signals20 if necessary20 (OPTIONAL20)
  virtual interface uart_ctrl_internal_if20 vif20;

  time rx_time_q20[$];
  time tx_time_q20[$];
  time tx_time_out20, tx_time_in20, rx_time_out20, rx_time_in20, clk_period20;

  // UART20 Controller20 Configuration20 Information20
  uart_ctrl_config20 cfg;

  // UART20 Controller20 coverage20
  uart_ctrl_cover20 uart_cover20;

  // Scoreboards20
  uart_ctrl_tx_scbd20 tx_scbd20;
  uart_ctrl_rx_scbd20 rx_scbd20;

  // TLM Connections20 to the interface UVC20 monitors20
  uvm_analysis_imp_apb20 #(apb_transfer20, uart_ctrl_monitor20) apb_in20;
  uvm_analysis_imp_rx20 #(uart_frame20, uart_ctrl_monitor20) uart_rx_in20;
  uvm_analysis_imp_tx20 #(uart_frame20, uart_ctrl_monitor20) uart_tx_in20;
  uvm_analysis_imp_cfg20 #(uart_config20, uart_ctrl_monitor20) uart_cfg_in20;

  // TLM Connections20 to other Components (Scoreboard20, updated config)
  uvm_analysis_port #(apb_transfer20) apb_out20;
  uvm_analysis_port #(uart_frame20) uart_rx_out20;
  uvm_analysis_port #(uart_frame20) uart_tx_out20;

  `uvm_component_utils_begin(uart_ctrl_monitor20)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports20(); // Create20 TLM Ports20
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif20.clock20) clk_period20 = $time;
    @(posedge vif20.clock20) clk_period20 = $time - clk_period20;
  endtask : run_phase
 
  // Additional20 class methods20
  extern virtual function void create_tlm_ports20();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx20(uart_frame20 frame20);
  extern virtual function void write_tx20(uart_frame20 frame20);
  extern virtual function void write_apb20(apb_transfer20 transfer20);
  extern virtual function void write_cfg20(uart_config20 uart_cfg20);
  extern virtual function void update_config20(uart_ctrl_config20 uart_ctrl_cfg20, int index);
  extern virtual function void set_slave_config20(apb_slave_config20 slave_cfg20, int index);
  extern virtual function void set_uart_config20(uart_config20 uart_cfg20);
endclass : uart_ctrl_monitor20

function void uart_ctrl_monitor20::create_tlm_ports20();
  apb_in20 = new("apb_in20", this);
  apb_out20 = new("apb_out20", this);
  uart_rx_in20 = new("uart_rx_in20", this);
  uart_rx_out20 = new("uart_rx_out20", this);
  uart_tx_in20 = new("uart_tx_in20", this);
  uart_tx_out20 = new("uart_tx_out20", this);
endfunction: create_tlm_ports20

function void uart_ctrl_monitor20::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover20 = uart_ctrl_cover20::type_id::create("uart_cover20",this);

  // Get20 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config20)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG20", "uart_ctrl_cfg20 is null...creating20 ", UVM_MEDIUM)
    cfg = uart_ctrl_config20::type_id::create("cfg", this);
    //set_config_object("tx_scbd20", "cfg", cfg);
    //set_config_object("rx_scbd20", "cfg", cfg);
  end
  //uvm_config_db#(uart_config20)::set(this, "*x_scbd20", "uart_cfg20", cfg.uart_cfg20);
  //uvm_config_db#(apb_slave_config20)::set(this, "*x_scbd20", "apb_slave_cfg20", cfg.apb_cfg20.slave_configs20[0]);
  uvm_config_object::set(this, "*x_scbd20", "uart_cfg20", cfg.uart_cfg20);
  uvm_config_object::set(this, "*x_scbd20", "apb_slave_cfg20", cfg.apb_cfg20.slave_configs20[0]);
  tx_scbd20 = uart_ctrl_tx_scbd20::type_id::create("tx_scbd20",this);
  rx_scbd20 = uart_ctrl_rx_scbd20::type_id::create("rx_scbd20",this);
endfunction : build_phase
   
function void uart_ctrl_monitor20::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get20 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if20)::get(this, "", "vif20", vif20))
      `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".vif20"})
  apb_out20.connect(tx_scbd20.apb_match20);
  uart_tx_out20.connect(tx_scbd20.uart_add20);
  apb_out20.connect(rx_scbd20.apb_add20);
  uart_rx_out20.connect(rx_scbd20.uart_match20);
endfunction : connect_phase

// implement UART20 Rx20 analysis20 port
function void uart_ctrl_monitor20::write_rx20(uart_frame20 frame20);
  uart_rx_out20.write(frame20);
  tx_time_in20 = tx_time_q20.pop_back();
  tx_time_out20 = ($time-tx_time_in20)/clk_period20;
endfunction : write_rx20
   
// implement UART20 Tx20 analysis20 port
function void uart_ctrl_monitor20::write_tx20(uart_frame20 frame20);
  uart_tx_out20.write(frame20);
  rx_time_q20.push_front($time); 
endfunction : write_tx20

// implement UART20 Config20 analysis20 port
function void uart_ctrl_monitor20::write_cfg20(uart_config20 uart_cfg20);
   set_uart_config20(uart_cfg20);
endfunction : write_cfg20

  // implement APB20 analysis20 port 
function void uart_ctrl_monitor20::write_apb20(apb_transfer20 transfer20);
    apb_out20.write(transfer20);
  if ((transfer20.direction20 == APB_READ20)  && (transfer20.addr == `RX_FIFO_REG20))
     begin
       rx_time_in20 = rx_time_q20.pop_back();
       rx_time_out20 = ($time-rx_time_in20)/clk_period20;
     end
  else if ((transfer20.direction20 == APB_WRITE20)  && (transfer20.addr == `TX_FIFO_REG20))
     begin
       tx_time_q20.push_front($time); 
     end
    
endfunction : write_apb20

function void uart_ctrl_monitor20::update_config20(uart_ctrl_config20 uart_ctrl_cfg20, int index);
  `uvm_info(get_type_name(), {"Updating Config20\n", uart_ctrl_cfg20.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg20;
   tx_scbd20.slave_cfg20 = uart_ctrl_cfg20.apb_cfg20.slave_configs20[index];
   tx_scbd20.uart_cfg20 = uart_ctrl_cfg20.uart_cfg20;
   rx_scbd20.slave_cfg20 = uart_ctrl_cfg20.apb_cfg20.slave_configs20[index];
   rx_scbd20.uart_cfg20 = uart_ctrl_cfg20.uart_cfg20;
endfunction : update_config20

function void uart_ctrl_monitor20::set_slave_config20(apb_slave_config20 slave_cfg20, int index);
   cfg.apb_cfg20.slave_configs20[index] = slave_cfg20;
   tx_scbd20.slave_cfg20 = slave_cfg20;
   rx_scbd20.slave_cfg20 = slave_cfg20;
endfunction : set_slave_config20

function void uart_ctrl_monitor20::set_uart_config20(uart_config20 uart_cfg20);
   cfg.uart_cfg20     = uart_cfg20;
   tx_scbd20.uart_cfg20 = uart_cfg20;
   rx_scbd20.uart_cfg20 = uart_cfg20;
endfunction : set_uart_config20
