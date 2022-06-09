/*-------------------------------------------------------------------------
File21 name   : uart_ctrl_monitor21.sv
Title21       : UART21 Controller21 Monitor21
Project21     :
Created21     :
Description21 : Module21 monitor21
Notes21       : 
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

// TLM Port21 Declarations21
`uvm_analysis_imp_decl(_rx21)
`uvm_analysis_imp_decl(_tx21)
`uvm_analysis_imp_decl(_cfg21)

class uart_ctrl_monitor21 extends uvm_monitor;

  // Virtual interface to DUT signals21 if necessary21 (OPTIONAL21)
  virtual interface uart_ctrl_internal_if21 vif21;

  time rx_time_q21[$];
  time tx_time_q21[$];
  time tx_time_out21, tx_time_in21, rx_time_out21, rx_time_in21, clk_period21;

  // UART21 Controller21 Configuration21 Information21
  uart_ctrl_config21 cfg;

  // UART21 Controller21 coverage21
  uart_ctrl_cover21 uart_cover21;

  // Scoreboards21
  uart_ctrl_tx_scbd21 tx_scbd21;
  uart_ctrl_rx_scbd21 rx_scbd21;

  // TLM Connections21 to the interface UVC21 monitors21
  uvm_analysis_imp_apb21 #(apb_transfer21, uart_ctrl_monitor21) apb_in21;
  uvm_analysis_imp_rx21 #(uart_frame21, uart_ctrl_monitor21) uart_rx_in21;
  uvm_analysis_imp_tx21 #(uart_frame21, uart_ctrl_monitor21) uart_tx_in21;
  uvm_analysis_imp_cfg21 #(uart_config21, uart_ctrl_monitor21) uart_cfg_in21;

  // TLM Connections21 to other Components (Scoreboard21, updated config)
  uvm_analysis_port #(apb_transfer21) apb_out21;
  uvm_analysis_port #(uart_frame21) uart_rx_out21;
  uvm_analysis_port #(uart_frame21) uart_tx_out21;

  `uvm_component_utils_begin(uart_ctrl_monitor21)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports21(); // Create21 TLM Ports21
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif21.clock21) clk_period21 = $time;
    @(posedge vif21.clock21) clk_period21 = $time - clk_period21;
  endtask : run_phase
 
  // Additional21 class methods21
  extern virtual function void create_tlm_ports21();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx21(uart_frame21 frame21);
  extern virtual function void write_tx21(uart_frame21 frame21);
  extern virtual function void write_apb21(apb_transfer21 transfer21);
  extern virtual function void write_cfg21(uart_config21 uart_cfg21);
  extern virtual function void update_config21(uart_ctrl_config21 uart_ctrl_cfg21, int index);
  extern virtual function void set_slave_config21(apb_slave_config21 slave_cfg21, int index);
  extern virtual function void set_uart_config21(uart_config21 uart_cfg21);
endclass : uart_ctrl_monitor21

function void uart_ctrl_monitor21::create_tlm_ports21();
  apb_in21 = new("apb_in21", this);
  apb_out21 = new("apb_out21", this);
  uart_rx_in21 = new("uart_rx_in21", this);
  uart_rx_out21 = new("uart_rx_out21", this);
  uart_tx_in21 = new("uart_tx_in21", this);
  uart_tx_out21 = new("uart_tx_out21", this);
endfunction: create_tlm_ports21

function void uart_ctrl_monitor21::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover21 = uart_ctrl_cover21::type_id::create("uart_cover21",this);

  // Get21 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config21)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG21", "uart_ctrl_cfg21 is null...creating21 ", UVM_MEDIUM)
    cfg = uart_ctrl_config21::type_id::create("cfg", this);
    //set_config_object("tx_scbd21", "cfg", cfg);
    //set_config_object("rx_scbd21", "cfg", cfg);
  end
  //uvm_config_db#(uart_config21)::set(this, "*x_scbd21", "uart_cfg21", cfg.uart_cfg21);
  //uvm_config_db#(apb_slave_config21)::set(this, "*x_scbd21", "apb_slave_cfg21", cfg.apb_cfg21.slave_configs21[0]);
  uvm_config_object::set(this, "*x_scbd21", "uart_cfg21", cfg.uart_cfg21);
  uvm_config_object::set(this, "*x_scbd21", "apb_slave_cfg21", cfg.apb_cfg21.slave_configs21[0]);
  tx_scbd21 = uart_ctrl_tx_scbd21::type_id::create("tx_scbd21",this);
  rx_scbd21 = uart_ctrl_rx_scbd21::type_id::create("rx_scbd21",this);
endfunction : build_phase
   
function void uart_ctrl_monitor21::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get21 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if21)::get(this, "", "vif21", vif21))
      `uvm_error("NOVIF21",{"virtual interface must be set for: ",get_full_name(),".vif21"})
  apb_out21.connect(tx_scbd21.apb_match21);
  uart_tx_out21.connect(tx_scbd21.uart_add21);
  apb_out21.connect(rx_scbd21.apb_add21);
  uart_rx_out21.connect(rx_scbd21.uart_match21);
endfunction : connect_phase

// implement UART21 Rx21 analysis21 port
function void uart_ctrl_monitor21::write_rx21(uart_frame21 frame21);
  uart_rx_out21.write(frame21);
  tx_time_in21 = tx_time_q21.pop_back();
  tx_time_out21 = ($time-tx_time_in21)/clk_period21;
endfunction : write_rx21
   
// implement UART21 Tx21 analysis21 port
function void uart_ctrl_monitor21::write_tx21(uart_frame21 frame21);
  uart_tx_out21.write(frame21);
  rx_time_q21.push_front($time); 
endfunction : write_tx21

// implement UART21 Config21 analysis21 port
function void uart_ctrl_monitor21::write_cfg21(uart_config21 uart_cfg21);
   set_uart_config21(uart_cfg21);
endfunction : write_cfg21

  // implement APB21 analysis21 port 
function void uart_ctrl_monitor21::write_apb21(apb_transfer21 transfer21);
    apb_out21.write(transfer21);
  if ((transfer21.direction21 == APB_READ21)  && (transfer21.addr == `RX_FIFO_REG21))
     begin
       rx_time_in21 = rx_time_q21.pop_back();
       rx_time_out21 = ($time-rx_time_in21)/clk_period21;
     end
  else if ((transfer21.direction21 == APB_WRITE21)  && (transfer21.addr == `TX_FIFO_REG21))
     begin
       tx_time_q21.push_front($time); 
     end
    
endfunction : write_apb21

function void uart_ctrl_monitor21::update_config21(uart_ctrl_config21 uart_ctrl_cfg21, int index);
  `uvm_info(get_type_name(), {"Updating Config21\n", uart_ctrl_cfg21.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg21;
   tx_scbd21.slave_cfg21 = uart_ctrl_cfg21.apb_cfg21.slave_configs21[index];
   tx_scbd21.uart_cfg21 = uart_ctrl_cfg21.uart_cfg21;
   rx_scbd21.slave_cfg21 = uart_ctrl_cfg21.apb_cfg21.slave_configs21[index];
   rx_scbd21.uart_cfg21 = uart_ctrl_cfg21.uart_cfg21;
endfunction : update_config21

function void uart_ctrl_monitor21::set_slave_config21(apb_slave_config21 slave_cfg21, int index);
   cfg.apb_cfg21.slave_configs21[index] = slave_cfg21;
   tx_scbd21.slave_cfg21 = slave_cfg21;
   rx_scbd21.slave_cfg21 = slave_cfg21;
endfunction : set_slave_config21

function void uart_ctrl_monitor21::set_uart_config21(uart_config21 uart_cfg21);
   cfg.uart_cfg21     = uart_cfg21;
   tx_scbd21.uart_cfg21 = uart_cfg21;
   rx_scbd21.uart_cfg21 = uart_cfg21;
endfunction : set_uart_config21
