/*-------------------------------------------------------------------------
File8 name   : gpio_monitor8.sv
Title8       : GPIO8 SystemVerilog8 UVM UVC8
Project8     : SystemVerilog8 UVM Cluster8 Level8 Verification8
Created8     :
Description8 : 
Notes8       :  
---------------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV8
`define GPIO_MONITOR_SV8

class gpio_monitor8 extends uvm_monitor;

  // This8 property is the virtual interfaced8 needed for this component to
  // view8 HDL signals8. 
  virtual gpio_if8 gpio_if8;

  gpio_csr_s8 csr_s8;

  // Agent8 Id8
  protected int agent_id8;

  // The following8 two8 bits are used to control8 whether8 checks8 and coverage8 are
  // done both in the monitor8 class and the interface.
  bit checks_enable8 = 1;
  bit coverage_enable8 = 1;

  uvm_analysis_port #(gpio_transfer8) item_collected_port8;

  // The following8 property holds8 the transaction information currently
  // begin captured8 (by the collect_receive_data8 and collect_transmit_data8 methods8).
  protected gpio_transfer8 trans_collected8;
  protected gpio_transfer8 last_trans_collected8;

  // Events8 needed to trigger covergroups8
  protected event cov_transaction8;

  event new_transfer_started8;
  event new_bit_started8;

  // Transfer8 collected8 covergroup
  covergroup cov_trans_cg8 @cov_transaction8;
    option.per_instance = 1;
    bypass_mode8 : coverpoint csr_s8.bypass_mode8;
    direction_mode8 : coverpoint csr_s8.direction_mode8;
    output_enable8 : coverpoint csr_s8.output_enable8;
    trans_data8 : coverpoint trans_collected8.monitor_data8 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg8

  // Provide8 implementations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor8)
    `uvm_field_int(agent_id8, UVM_ALL_ON)
    `uvm_field_int(checks_enable8, UVM_ALL_ON)
    `uvm_field_int(coverage_enable8, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg8 = new();
    cov_trans_cg8.set_inst_name("gpio_cov_trans_cg8");
    item_collected_port8 = new("item_collected_port8", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if8)::get(this, "", "gpio_if8", gpio_if8))
   `uvm_error("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".gpio_if8"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions8();
    join
  endtask : run_phase

  // collect_transactions8
  virtual protected task collect_transactions8();
      last_trans_collected8 = new();
    forever begin
      @(posedge gpio_if8.pclk8);
      trans_collected8 = new();
      if (m_parent != null)
        trans_collected8.agent8 = m_parent.get_name();
      collect_transfer8();
      if (coverage_enable8)
         -> cov_transaction8;
      item_collected_port8.write(trans_collected8);
    end
  endtask : collect_transactions8

  // collect_transfer8
  virtual protected task collect_transfer8();
    void'(this.begin_tr(trans_collected8));
    trans_collected8.transfer_data8 = gpio_if8.gpio_pin_out8;
    trans_collected8.monitor_data8  = gpio_if8.gpio_pin_in8;
    trans_collected8.output_enable8 = gpio_if8.n_gpio_pin_oe8;
    if (!last_trans_collected8.compare(trans_collected8))
      `uvm_info("GPIO_MON8", $psprintf("Transfer8 collected8 :\n%s", trans_collected8.sprint()), UVM_MEDIUM)
    last_trans_collected8 = trans_collected8;
    this.end_tr(trans_collected8);
  endtask : collect_transfer8

endclass : gpio_monitor8

`endif // GPIO_MONITOR_SV8

