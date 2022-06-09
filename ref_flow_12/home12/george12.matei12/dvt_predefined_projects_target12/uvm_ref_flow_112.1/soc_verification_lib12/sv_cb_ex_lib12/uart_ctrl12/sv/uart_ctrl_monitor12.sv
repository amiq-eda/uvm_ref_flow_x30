/*-------------------------------------------------------------------------
File12 name   : uart_ctrl_monitor12.sv
Title12       : UART12 Controller12 Monitor12
Project12     :
Created12     :
Description12 : Module12 monitor12
Notes12       : 
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

// TLM Port12 Declarations12
`uvm_analysis_imp_decl(_rx12)
`uvm_analysis_imp_decl(_tx12)
`uvm_analysis_imp_decl(_cfg12)

class uart_ctrl_monitor12 extends uvm_monitor;

  // Virtual interface to DUT signals12 if necessary12 (OPTIONAL12)
  virtual interface uart_ctrl_internal_if12 vif12;

  time rx_time_q12[$];
  time tx_time_q12[$];
  time tx_time_out12, tx_time_in12, rx_time_out12, rx_time_in12, clk_period12;

  // UART12 Controller12 Configuration12 Information12
  uart_ctrl_config12 cfg;

  // UART12 Controller12 coverage12
  uart_ctrl_cover12 uart_cover12;

  // Scoreboards12
  uart_ctrl_tx_scbd12 tx_scbd12;
  uart_ctrl_rx_scbd12 rx_scbd12;

  // TLM Connections12 to the interface UVC12 monitors12
  uvm_analysis_imp_apb12 #(apb_transfer12, uart_ctrl_monitor12) apb_in12;
  uvm_analysis_imp_rx12 #(uart_frame12, uart_ctrl_monitor12) uart_rx_in12;
  uvm_analysis_imp_tx12 #(uart_frame12, uart_ctrl_monitor12) uart_tx_in12;
  uvm_analysis_imp_cfg12 #(uart_config12, uart_ctrl_monitor12) uart_cfg_in12;

  // TLM Connections12 to other Components (Scoreboard12, updated config)
  uvm_analysis_port #(apb_transfer12) apb_out12;
  uvm_analysis_port #(uart_frame12) uart_rx_out12;
  uvm_analysis_port #(uart_frame12) uart_tx_out12;

  `uvm_component_utils_begin(uart_ctrl_monitor12)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports12(); // Create12 TLM Ports12
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif12.clock12) clk_period12 = $time;
    @(posedge vif12.clock12) clk_period12 = $time - clk_period12;
  endtask : run_phase
 
  // Additional12 class methods12
  extern virtual function void create_tlm_ports12();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx12(uart_frame12 frame12);
  extern virtual function void write_tx12(uart_frame12 frame12);
  extern virtual function void write_apb12(apb_transfer12 transfer12);
  extern virtual function void write_cfg12(uart_config12 uart_cfg12);
  extern virtual function void update_config12(uart_ctrl_config12 uart_ctrl_cfg12, int index);
  extern virtual function void set_slave_config12(apb_slave_config12 slave_cfg12, int index);
  extern virtual function void set_uart_config12(uart_config12 uart_cfg12);
endclass : uart_ctrl_monitor12

function void uart_ctrl_monitor12::create_tlm_ports12();
  apb_in12 = new("apb_in12", this);
  apb_out12 = new("apb_out12", this);
  uart_rx_in12 = new("uart_rx_in12", this);
  uart_rx_out12 = new("uart_rx_out12", this);
  uart_tx_in12 = new("uart_tx_in12", this);
  uart_tx_out12 = new("uart_tx_out12", this);
endfunction: create_tlm_ports12

function void uart_ctrl_monitor12::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover12 = uart_ctrl_cover12::type_id::create("uart_cover12",this);

  // Get12 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config12)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG12", "uart_ctrl_cfg12 is null...creating12 ", UVM_MEDIUM)
    cfg = uart_ctrl_config12::type_id::create("cfg", this);
    //set_config_object("tx_scbd12", "cfg", cfg);
    //set_config_object("rx_scbd12", "cfg", cfg);
  end
  //uvm_config_db#(uart_config12)::set(this, "*x_scbd12", "uart_cfg12", cfg.uart_cfg12);
  //uvm_config_db#(apb_slave_config12)::set(this, "*x_scbd12", "apb_slave_cfg12", cfg.apb_cfg12.slave_configs12[0]);
  uvm_config_object::set(this, "*x_scbd12", "uart_cfg12", cfg.uart_cfg12);
  uvm_config_object::set(this, "*x_scbd12", "apb_slave_cfg12", cfg.apb_cfg12.slave_configs12[0]);
  tx_scbd12 = uart_ctrl_tx_scbd12::type_id::create("tx_scbd12",this);
  rx_scbd12 = uart_ctrl_rx_scbd12::type_id::create("rx_scbd12",this);
endfunction : build_phase
   
function void uart_ctrl_monitor12::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get12 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if12)::get(this, "", "vif12", vif12))
      `uvm_error("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".vif12"})
  apb_out12.connect(tx_scbd12.apb_match12);
  uart_tx_out12.connect(tx_scbd12.uart_add12);
  apb_out12.connect(rx_scbd12.apb_add12);
  uart_rx_out12.connect(rx_scbd12.uart_match12);
endfunction : connect_phase

// implement UART12 Rx12 analysis12 port
function void uart_ctrl_monitor12::write_rx12(uart_frame12 frame12);
  uart_rx_out12.write(frame12);
  tx_time_in12 = tx_time_q12.pop_back();
  tx_time_out12 = ($time-tx_time_in12)/clk_period12;
endfunction : write_rx12
   
// implement UART12 Tx12 analysis12 port
function void uart_ctrl_monitor12::write_tx12(uart_frame12 frame12);
  uart_tx_out12.write(frame12);
  rx_time_q12.push_front($time); 
endfunction : write_tx12

// implement UART12 Config12 analysis12 port
function void uart_ctrl_monitor12::write_cfg12(uart_config12 uart_cfg12);
   set_uart_config12(uart_cfg12);
endfunction : write_cfg12

  // implement APB12 analysis12 port 
function void uart_ctrl_monitor12::write_apb12(apb_transfer12 transfer12);
    apb_out12.write(transfer12);
  if ((transfer12.direction12 == APB_READ12)  && (transfer12.addr == `RX_FIFO_REG12))
     begin
       rx_time_in12 = rx_time_q12.pop_back();
       rx_time_out12 = ($time-rx_time_in12)/clk_period12;
     end
  else if ((transfer12.direction12 == APB_WRITE12)  && (transfer12.addr == `TX_FIFO_REG12))
     begin
       tx_time_q12.push_front($time); 
     end
    
endfunction : write_apb12

function void uart_ctrl_monitor12::update_config12(uart_ctrl_config12 uart_ctrl_cfg12, int index);
  `uvm_info(get_type_name(), {"Updating Config12\n", uart_ctrl_cfg12.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg12;
   tx_scbd12.slave_cfg12 = uart_ctrl_cfg12.apb_cfg12.slave_configs12[index];
   tx_scbd12.uart_cfg12 = uart_ctrl_cfg12.uart_cfg12;
   rx_scbd12.slave_cfg12 = uart_ctrl_cfg12.apb_cfg12.slave_configs12[index];
   rx_scbd12.uart_cfg12 = uart_ctrl_cfg12.uart_cfg12;
endfunction : update_config12

function void uart_ctrl_monitor12::set_slave_config12(apb_slave_config12 slave_cfg12, int index);
   cfg.apb_cfg12.slave_configs12[index] = slave_cfg12;
   tx_scbd12.slave_cfg12 = slave_cfg12;
   rx_scbd12.slave_cfg12 = slave_cfg12;
endfunction : set_slave_config12

function void uart_ctrl_monitor12::set_uart_config12(uart_config12 uart_cfg12);
   cfg.uart_cfg12     = uart_cfg12;
   tx_scbd12.uart_cfg12 = uart_cfg12;
   rx_scbd12.uart_cfg12 = uart_cfg12;
endfunction : set_uart_config12
