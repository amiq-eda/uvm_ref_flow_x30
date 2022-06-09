/*-------------------------------------------------------------------------
File14 name   : uart_ctrl_monitor14.sv
Title14       : UART14 Controller14 Monitor14
Project14     :
Created14     :
Description14 : Module14 monitor14
Notes14       : 
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

// TLM Port14 Declarations14
`uvm_analysis_imp_decl(_rx14)
`uvm_analysis_imp_decl(_tx14)
`uvm_analysis_imp_decl(_cfg14)

class uart_ctrl_monitor14 extends uvm_monitor;

  // Virtual interface to DUT signals14 if necessary14 (OPTIONAL14)
  virtual interface uart_ctrl_internal_if14 vif14;

  time rx_time_q14[$];
  time tx_time_q14[$];
  time tx_time_out14, tx_time_in14, rx_time_out14, rx_time_in14, clk_period14;

  // UART14 Controller14 Configuration14 Information14
  uart_ctrl_config14 cfg;

  // UART14 Controller14 coverage14
  uart_ctrl_cover14 uart_cover14;

  // Scoreboards14
  uart_ctrl_tx_scbd14 tx_scbd14;
  uart_ctrl_rx_scbd14 rx_scbd14;

  // TLM Connections14 to the interface UVC14 monitors14
  uvm_analysis_imp_apb14 #(apb_transfer14, uart_ctrl_monitor14) apb_in14;
  uvm_analysis_imp_rx14 #(uart_frame14, uart_ctrl_monitor14) uart_rx_in14;
  uvm_analysis_imp_tx14 #(uart_frame14, uart_ctrl_monitor14) uart_tx_in14;
  uvm_analysis_imp_cfg14 #(uart_config14, uart_ctrl_monitor14) uart_cfg_in14;

  // TLM Connections14 to other Components (Scoreboard14, updated config)
  uvm_analysis_port #(apb_transfer14) apb_out14;
  uvm_analysis_port #(uart_frame14) uart_rx_out14;
  uvm_analysis_port #(uart_frame14) uart_tx_out14;

  `uvm_component_utils_begin(uart_ctrl_monitor14)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports14(); // Create14 TLM Ports14
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif14.clock14) clk_period14 = $time;
    @(posedge vif14.clock14) clk_period14 = $time - clk_period14;
  endtask : run_phase
 
  // Additional14 class methods14
  extern virtual function void create_tlm_ports14();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx14(uart_frame14 frame14);
  extern virtual function void write_tx14(uart_frame14 frame14);
  extern virtual function void write_apb14(apb_transfer14 transfer14);
  extern virtual function void write_cfg14(uart_config14 uart_cfg14);
  extern virtual function void update_config14(uart_ctrl_config14 uart_ctrl_cfg14, int index);
  extern virtual function void set_slave_config14(apb_slave_config14 slave_cfg14, int index);
  extern virtual function void set_uart_config14(uart_config14 uart_cfg14);
endclass : uart_ctrl_monitor14

function void uart_ctrl_monitor14::create_tlm_ports14();
  apb_in14 = new("apb_in14", this);
  apb_out14 = new("apb_out14", this);
  uart_rx_in14 = new("uart_rx_in14", this);
  uart_rx_out14 = new("uart_rx_out14", this);
  uart_tx_in14 = new("uart_tx_in14", this);
  uart_tx_out14 = new("uart_tx_out14", this);
endfunction: create_tlm_ports14

function void uart_ctrl_monitor14::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover14 = uart_ctrl_cover14::type_id::create("uart_cover14",this);

  // Get14 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config14)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG14", "uart_ctrl_cfg14 is null...creating14 ", UVM_MEDIUM)
    cfg = uart_ctrl_config14::type_id::create("cfg", this);
    //set_config_object("tx_scbd14", "cfg", cfg);
    //set_config_object("rx_scbd14", "cfg", cfg);
  end
  //uvm_config_db#(uart_config14)::set(this, "*x_scbd14", "uart_cfg14", cfg.uart_cfg14);
  //uvm_config_db#(apb_slave_config14)::set(this, "*x_scbd14", "apb_slave_cfg14", cfg.apb_cfg14.slave_configs14[0]);
  uvm_config_object::set(this, "*x_scbd14", "uart_cfg14", cfg.uart_cfg14);
  uvm_config_object::set(this, "*x_scbd14", "apb_slave_cfg14", cfg.apb_cfg14.slave_configs14[0]);
  tx_scbd14 = uart_ctrl_tx_scbd14::type_id::create("tx_scbd14",this);
  rx_scbd14 = uart_ctrl_rx_scbd14::type_id::create("rx_scbd14",this);
endfunction : build_phase
   
function void uart_ctrl_monitor14::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get14 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if14)::get(this, "", "vif14", vif14))
      `uvm_error("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".vif14"})
  apb_out14.connect(tx_scbd14.apb_match14);
  uart_tx_out14.connect(tx_scbd14.uart_add14);
  apb_out14.connect(rx_scbd14.apb_add14);
  uart_rx_out14.connect(rx_scbd14.uart_match14);
endfunction : connect_phase

// implement UART14 Rx14 analysis14 port
function void uart_ctrl_monitor14::write_rx14(uart_frame14 frame14);
  uart_rx_out14.write(frame14);
  tx_time_in14 = tx_time_q14.pop_back();
  tx_time_out14 = ($time-tx_time_in14)/clk_period14;
endfunction : write_rx14
   
// implement UART14 Tx14 analysis14 port
function void uart_ctrl_monitor14::write_tx14(uart_frame14 frame14);
  uart_tx_out14.write(frame14);
  rx_time_q14.push_front($time); 
endfunction : write_tx14

// implement UART14 Config14 analysis14 port
function void uart_ctrl_monitor14::write_cfg14(uart_config14 uart_cfg14);
   set_uart_config14(uart_cfg14);
endfunction : write_cfg14

  // implement APB14 analysis14 port 
function void uart_ctrl_monitor14::write_apb14(apb_transfer14 transfer14);
    apb_out14.write(transfer14);
  if ((transfer14.direction14 == APB_READ14)  && (transfer14.addr == `RX_FIFO_REG14))
     begin
       rx_time_in14 = rx_time_q14.pop_back();
       rx_time_out14 = ($time-rx_time_in14)/clk_period14;
     end
  else if ((transfer14.direction14 == APB_WRITE14)  && (transfer14.addr == `TX_FIFO_REG14))
     begin
       tx_time_q14.push_front($time); 
     end
    
endfunction : write_apb14

function void uart_ctrl_monitor14::update_config14(uart_ctrl_config14 uart_ctrl_cfg14, int index);
  `uvm_info(get_type_name(), {"Updating Config14\n", uart_ctrl_cfg14.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg14;
   tx_scbd14.slave_cfg14 = uart_ctrl_cfg14.apb_cfg14.slave_configs14[index];
   tx_scbd14.uart_cfg14 = uart_ctrl_cfg14.uart_cfg14;
   rx_scbd14.slave_cfg14 = uart_ctrl_cfg14.apb_cfg14.slave_configs14[index];
   rx_scbd14.uart_cfg14 = uart_ctrl_cfg14.uart_cfg14;
endfunction : update_config14

function void uart_ctrl_monitor14::set_slave_config14(apb_slave_config14 slave_cfg14, int index);
   cfg.apb_cfg14.slave_configs14[index] = slave_cfg14;
   tx_scbd14.slave_cfg14 = slave_cfg14;
   rx_scbd14.slave_cfg14 = slave_cfg14;
endfunction : set_slave_config14

function void uart_ctrl_monitor14::set_uart_config14(uart_config14 uart_cfg14);
   cfg.uart_cfg14     = uart_cfg14;
   tx_scbd14.uart_cfg14 = uart_cfg14;
   rx_scbd14.uart_cfg14 = uart_cfg14;
endfunction : set_uart_config14
