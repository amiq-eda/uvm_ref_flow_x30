/*-------------------------------------------------------------------------
File19 name   : uart_ctrl_monitor19.sv
Title19       : UART19 Controller19 Monitor19
Project19     :
Created19     :
Description19 : Module19 monitor19
Notes19       : 
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

// TLM Port19 Declarations19
`uvm_analysis_imp_decl(_rx19)
`uvm_analysis_imp_decl(_tx19)
`uvm_analysis_imp_decl(_cfg19)

class uart_ctrl_monitor19 extends uvm_monitor;

  // Virtual interface to DUT signals19 if necessary19 (OPTIONAL19)
  virtual interface uart_ctrl_internal_if19 vif19;

  time rx_time_q19[$];
  time tx_time_q19[$];
  time tx_time_out19, tx_time_in19, rx_time_out19, rx_time_in19, clk_period19;

  // UART19 Controller19 Configuration19 Information19
  uart_ctrl_config19 cfg;

  // UART19 Controller19 coverage19
  uart_ctrl_cover19 uart_cover19;

  // Scoreboards19
  uart_ctrl_tx_scbd19 tx_scbd19;
  uart_ctrl_rx_scbd19 rx_scbd19;

  // TLM Connections19 to the interface UVC19 monitors19
  uvm_analysis_imp_apb19 #(apb_transfer19, uart_ctrl_monitor19) apb_in19;
  uvm_analysis_imp_rx19 #(uart_frame19, uart_ctrl_monitor19) uart_rx_in19;
  uvm_analysis_imp_tx19 #(uart_frame19, uart_ctrl_monitor19) uart_tx_in19;
  uvm_analysis_imp_cfg19 #(uart_config19, uart_ctrl_monitor19) uart_cfg_in19;

  // TLM Connections19 to other Components (Scoreboard19, updated config)
  uvm_analysis_port #(apb_transfer19) apb_out19;
  uvm_analysis_port #(uart_frame19) uart_rx_out19;
  uvm_analysis_port #(uart_frame19) uart_tx_out19;

  `uvm_component_utils_begin(uart_ctrl_monitor19)
     `uvm_field_object(cfg, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    create_tlm_ports19(); // Create19 TLM Ports19
  endfunction: new

  task run_phase(uvm_phase phase);
    @(posedge vif19.clock19) clk_period19 = $time;
    @(posedge vif19.clock19) clk_period19 = $time - clk_period19;
  endtask : run_phase
 
  // Additional19 class methods19
  extern virtual function void create_tlm_ports19();
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write_rx19(uart_frame19 frame19);
  extern virtual function void write_tx19(uart_frame19 frame19);
  extern virtual function void write_apb19(apb_transfer19 transfer19);
  extern virtual function void write_cfg19(uart_config19 uart_cfg19);
  extern virtual function void update_config19(uart_ctrl_config19 uart_ctrl_cfg19, int index);
  extern virtual function void set_slave_config19(apb_slave_config19 slave_cfg19, int index);
  extern virtual function void set_uart_config19(uart_config19 uart_cfg19);
endclass : uart_ctrl_monitor19

function void uart_ctrl_monitor19::create_tlm_ports19();
  apb_in19 = new("apb_in19", this);
  apb_out19 = new("apb_out19", this);
  uart_rx_in19 = new("uart_rx_in19", this);
  uart_rx_out19 = new("uart_rx_out19", this);
  uart_tx_in19 = new("uart_tx_in19", this);
  uart_tx_out19 = new("uart_tx_out19", this);
endfunction: create_tlm_ports19

function void uart_ctrl_monitor19::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uart_cover19 = uart_ctrl_cover19::type_id::create("uart_cover19",this);

  // Get19 the configuration for this component
  //if (!uvm_config_db#(uart_ctrl_config19)::get(this, "", "cfg", cfg)) begin
  if (cfg==null) begin
    `uvm_info("NOCONFIG19", "uart_ctrl_cfg19 is null...creating19 ", UVM_MEDIUM)
    cfg = uart_ctrl_config19::type_id::create("cfg", this);
    //set_config_object("tx_scbd19", "cfg", cfg);
    //set_config_object("rx_scbd19", "cfg", cfg);
  end
  //uvm_config_db#(uart_config19)::set(this, "*x_scbd19", "uart_cfg19", cfg.uart_cfg19);
  //uvm_config_db#(apb_slave_config19)::set(this, "*x_scbd19", "apb_slave_cfg19", cfg.apb_cfg19.slave_configs19[0]);
  uvm_config_object::set(this, "*x_scbd19", "uart_cfg19", cfg.uart_cfg19);
  uvm_config_object::set(this, "*x_scbd19", "apb_slave_cfg19", cfg.apb_cfg19.slave_configs19[0]);
  tx_scbd19 = uart_ctrl_tx_scbd19::type_id::create("tx_scbd19",this);
  rx_scbd19 = uart_ctrl_rx_scbd19::type_id::create("rx_scbd19",this);
endfunction : build_phase
   
function void uart_ctrl_monitor19::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get19 the virtual interface for this component
  if (!uvm_config_db#(virtual uart_ctrl_internal_if19)::get(this, "", "vif19", vif19))
      `uvm_error("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".vif19"})
  apb_out19.connect(tx_scbd19.apb_match19);
  uart_tx_out19.connect(tx_scbd19.uart_add19);
  apb_out19.connect(rx_scbd19.apb_add19);
  uart_rx_out19.connect(rx_scbd19.uart_match19);
endfunction : connect_phase

// implement UART19 Rx19 analysis19 port
function void uart_ctrl_monitor19::write_rx19(uart_frame19 frame19);
  uart_rx_out19.write(frame19);
  tx_time_in19 = tx_time_q19.pop_back();
  tx_time_out19 = ($time-tx_time_in19)/clk_period19;
endfunction : write_rx19
   
// implement UART19 Tx19 analysis19 port
function void uart_ctrl_monitor19::write_tx19(uart_frame19 frame19);
  uart_tx_out19.write(frame19);
  rx_time_q19.push_front($time); 
endfunction : write_tx19

// implement UART19 Config19 analysis19 port
function void uart_ctrl_monitor19::write_cfg19(uart_config19 uart_cfg19);
   set_uart_config19(uart_cfg19);
endfunction : write_cfg19

  // implement APB19 analysis19 port 
function void uart_ctrl_monitor19::write_apb19(apb_transfer19 transfer19);
    apb_out19.write(transfer19);
  if ((transfer19.direction19 == APB_READ19)  && (transfer19.addr == `RX_FIFO_REG19))
     begin
       rx_time_in19 = rx_time_q19.pop_back();
       rx_time_out19 = ($time-rx_time_in19)/clk_period19;
     end
  else if ((transfer19.direction19 == APB_WRITE19)  && (transfer19.addr == `TX_FIFO_REG19))
     begin
       tx_time_q19.push_front($time); 
     end
    
endfunction : write_apb19

function void uart_ctrl_monitor19::update_config19(uart_ctrl_config19 uart_ctrl_cfg19, int index);
  `uvm_info(get_type_name(), {"Updating Config19\n", uart_ctrl_cfg19.sprint}, UVM_HIGH)
   cfg = uart_ctrl_cfg19;
   tx_scbd19.slave_cfg19 = uart_ctrl_cfg19.apb_cfg19.slave_configs19[index];
   tx_scbd19.uart_cfg19 = uart_ctrl_cfg19.uart_cfg19;
   rx_scbd19.slave_cfg19 = uart_ctrl_cfg19.apb_cfg19.slave_configs19[index];
   rx_scbd19.uart_cfg19 = uart_ctrl_cfg19.uart_cfg19;
endfunction : update_config19

function void uart_ctrl_monitor19::set_slave_config19(apb_slave_config19 slave_cfg19, int index);
   cfg.apb_cfg19.slave_configs19[index] = slave_cfg19;
   tx_scbd19.slave_cfg19 = slave_cfg19;
   rx_scbd19.slave_cfg19 = slave_cfg19;
endfunction : set_slave_config19

function void uart_ctrl_monitor19::set_uart_config19(uart_config19 uart_cfg19);
   cfg.uart_cfg19     = uart_cfg19;
   tx_scbd19.uart_cfg19 = uart_cfg19;
   rx_scbd19.uart_cfg19 = uart_cfg19;
endfunction : set_uart_config19
