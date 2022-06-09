/*-------------------------------------------------------------------------
File17 name   : uart_ctrl_monitor17.sv
Title17       : UART17 Controller17 Monitor17
Project17     :
Created17     :
Description17 : Module17 monitor17
Notes17       : 
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

// TLM Port17 Declarations17
`uvm_analysis_imp_decl(_rx17)
`uvm_analysis_imp_decl(_tx17)
`uvm_analysis_imp_decl(_cfg17)

class uart_ctrl_monitor17 extends uvm_monitor;

  // Virtual interface to DUT signals17 if necessary17 (OPTIONAL17)
  virtual interface uart_ctrl_internal_if17 vif17;

  time rx_time_q17[$];
  time tx_time_q17[$];
  time tx_time_out17, tx_time_in17, rx_time_out17, rx_time_in17, clk_period17;

  // UART17 Controller17 Configuration17 Information17
  uart_ctrl_config17 cfg;

  // UART17 Controller17 coverage17
  uart_ctrl_cover17 uart_cover17;

  // Scoreboards17
  uart_ctrl_tx_scbd17 tx_scbd17;
  uart_ctrl_rx_scbd17 rx_scbd17;

  // TLM Connections17 to the interface UVC17 monitors17
  uvm_analysis_imp_apb17 #(apb_transfer17, uart_ctrl_monitor17) apb_in17;
  uvm_analysis_imp_rx17 #(uart_frame17, uart_ctrl_monitor17) uart_rx_in17;
  uvm_analysis_imp_tx17 #(uart_frame17, uart_ctrl_monitor17) uart_tx_in17;
  uvm_analysis_imp_cfg17 #(uart_config17, uart_ctrl_monitor17) uart_cfg_in17;

  // TLM Connections17 to other Components (Scoreboard17, updated config)
  uvm_analysis_port #(apb_transfer17) apb_out17;
  uvm_analysis_port #(uart_frame17) uart_rx_out17;
  uvm_analysis_port #(uart_frame17) uart_tx_out17;

  `uvm_component_utils_begin(uart_ctrl_monitor17)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports17(); // Create17 TLM Ports17
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif17.clock17) clk_period17 = $time;
    @(posedge vif17.clock17) clk_period17 = $time - clk_period17;
  endtask : run_phase
 
  // Additional17 class methods17
  extern virtual function void create_tlm_ports17();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx17(uart_frame17 frame17);
  extern virtual function void write_tx17(uart_frame17 frame17);
  extern virtual function void write_apb17(apb_transfer17 transfer17);
  extern virtual function void write_cfg17(uart_config17 uart_cfg17);
  extern virtual function void update_config17(uart_ctrl_config17 uart_ctrl_cfg17, int index);
  extern virtual function void set_slave_config17(apb_slave_config17 slave_cfg17, int index);
  extern virtual function void set_uart_config17(uart_config17 uart_cfg17);
endclass : uart_ctrl_monitor17

function void uart_ctrl_monitor17::create_tlm_ports17();
  apb_in17 = new("apb_in17", this);
  apb_out17 = new("apb_out17", this);
  uart_rx_in17 = new("uart_rx_in17", this);
  uart_rx_out17 = new("uart_rx_out17", this);
  uart_tx_in17 = new("uart_tx_in17", this);
  uart_tx_out17 = new("uart_tx_out17", this);
endfunction: create_tlm_ports17

function void uart_ctrl_monitor17::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover17 = uart_ctrl_cover17::type_id::create("uart_cover17",this);

  // Get17 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config17)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG17", "uart_ctrl_cfg17 is null...creating17 ", UVM_MEDIUM)
    cfg = uart_ctrl_config17::type_id::create("cfg", this);
    //set_config_object("tx_scbd17", "cfg", cfg);
    //set_config_object("rx_scbd17", "cfg", cfg);
  end
  //uvm_config_db#(uart_config17)::set(this, "*x_scbd17", "uart_cfg17", cfg.uart_cfg17);
  //uvm_config_db#(apb_slave_config17)::set(this, "*x_scbd17", "apb_slave_cfg17", cfg.apb_cfg17.slave_configs17[0]);
  uvm_config_object::set(this, "*x_scbd17", "uart_cfg17", cfg.uart_cfg17);
  uvm_config_object::set(this, "*x_scbd17", "apb_slave_cfg17", cfg.apb_cfg17.slave_configs17[0]);
  tx_scbd17 = uart_ctrl_tx_scbd17::type_id::create("tx_scbd17",this);
  rx_scbd17 = uart_ctrl_rx_scbd17::type_id::create("rx_scbd17",this);
endfunction : build_phase
   
function void uart_ctrl_monitor17::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get17 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if17)::get(this, "", "vif17", vif17))
      `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".vif17"})
  apb_out17.connect(tx_scbd17.apb_match17);
  uart_tx_out17.connect(tx_scbd17.uart_add17);
  apb_out17.connect(rx_scbd17.apb_add17);
  uart_rx_out17.connect(rx_scbd17.uart_match17);
endfunction : connect_phase

// implement UART17 Rx17 analysis17 port
function void uart_ctrl_monitor17::write_rx17(uart_frame17 frame17);
  uart_rx_out17.write(frame17);
  tx_time_in17 = tx_time_q17.pop_back();
  tx_time_out17 = ($time-tx_time_in17)/clk_period17;
endfunction : write_rx17
   
// implement UART17 Tx17 analysis17 port
function void uart_ctrl_monitor17::write_tx17(uart_frame17 frame17);
  uart_tx_out17.write(frame17);
  rx_time_q17.push_front($time); 
endfunction : write_tx17

// implement UART17 Config17 analysis17 port
function void uart_ctrl_monitor17::write_cfg17(uart_config17 uart_cfg17);
   set_uart_config17(uart_cfg17);
endfunction : write_cfg17

  // implement APB17 analysis17 port 
function void uart_ctrl_monitor17::write_apb17(apb_transfer17 transfer17);
    apb_out17.write(transfer17);
  if ((transfer17.direction17 == APB_READ17)  && (transfer17.addr == `RX_FIFO_REG17))
     begin
       rx_time_in17 = rx_time_q17.pop_back();
       rx_time_out17 = ($time-rx_time_in17)/clk_period17;
     end
  else if ((transfer17.direction17 == APB_WRITE17)  && (transfer17.addr == `TX_FIFO_REG17))
     begin
       tx_time_q17.push_front($time); 
     end
    
endfunction : write_apb17

function void uart_ctrl_monitor17::update_config17(uart_ctrl_config17 uart_ctrl_cfg17, int index);
  `uvm_info(get_type_name(), {"Updating Config17\n", uart_ctrl_cfg17.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg17;
   tx_scbd17.slave_cfg17 = uart_ctrl_cfg17.apb_cfg17.slave_configs17[index];
   tx_scbd17.uart_cfg17 = uart_ctrl_cfg17.uart_cfg17;
   rx_scbd17.slave_cfg17 = uart_ctrl_cfg17.apb_cfg17.slave_configs17[index];
   rx_scbd17.uart_cfg17 = uart_ctrl_cfg17.uart_cfg17;
endfunction : update_config17

function void uart_ctrl_monitor17::set_slave_config17(apb_slave_config17 slave_cfg17, int index);
   cfg.apb_cfg17.slave_configs17[index] = slave_cfg17;
   tx_scbd17.slave_cfg17 = slave_cfg17;
   rx_scbd17.slave_cfg17 = slave_cfg17;
endfunction : set_slave_config17

function void uart_ctrl_monitor17::set_uart_config17(uart_config17 uart_cfg17);
   cfg.uart_cfg17     = uart_cfg17;
   tx_scbd17.uart_cfg17 = uart_cfg17;
   rx_scbd17.uart_cfg17 = uart_cfg17;
endfunction : set_uart_config17
