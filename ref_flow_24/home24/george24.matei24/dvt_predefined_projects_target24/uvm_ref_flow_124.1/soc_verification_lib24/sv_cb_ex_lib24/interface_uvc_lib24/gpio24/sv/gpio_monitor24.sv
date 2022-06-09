/*-------------------------------------------------------------------------
File24 name   : gpio_monitor24.sv
Title24       : GPIO24 SystemVerilog24 UVM UVC24
Project24     : SystemVerilog24 UVM Cluster24 Level24 Verification24
Created24     :
Description24 : 
Notes24       :  
---------------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV24
`define GPIO_MONITOR_SV24

class gpio_monitor24 extends uvm_monitor;

  // This24 property is the virtual interfaced24 needed for this component to
  // view24 HDL signals24. 
  virtual gpio_if24 gpio_if24;

  gpio_csr_s24 csr_s24;

  // Agent24 Id24
  protected int agent_id24;

  // The following24 two24 bits are used to control24 whether24 checks24 and coverage24 are
  // done both in the monitor24 class and the interface.
  bit checks_enable24 = 1;
  bit coverage_enable24 = 1;

  uvm_analysis_port #(gpio_transfer24) item_collected_port24;

  // The following24 property holds24 the transaction information currently
  // begin captured24 (by the collect_receive_data24 and collect_transmit_data24 methods24).
  protected gpio_transfer24 trans_collected24;
  protected gpio_transfer24 last_trans_collected24;

  // Events24 needed to trigger covergroups24
  protected event cov_transaction24;

  event new_transfer_started24;
  event new_bit_started24;

  // Transfer24 collected24 covergroup
  covergroup cov_trans_cg24 @cov_transaction24;
    option.per_instance = 1;
    bypass_mode24 : coverpoint csr_s24.bypass_mode24;
    direction_mode24 : coverpoint csr_s24.direction_mode24;
    output_enable24 : coverpoint csr_s24.output_enable24;
    trans_data24 : coverpoint trans_collected24.monitor_data24 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg24

  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor24)
    `uvm_field_int(agent_id24, UVM_ALL_ON)
    `uvm_field_int(checks_enable24, UVM_ALL_ON)
    `uvm_field_int(coverage_enable24, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg24 = new();
    cov_trans_cg24.set_inst_name("gpio_cov_trans_cg24");
    item_collected_port24 = new("item_collected_port24", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if24)::get(this, "", "gpio_if24", gpio_if24))
   `uvm_error("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".gpio_if24"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions24();
    join
  endtask : run_phase

  // collect_transactions24
  virtual protected task collect_transactions24();
      last_trans_collected24 = new();
    forever begin
      @(posedge gpio_if24.pclk24);
      trans_collected24 = new();
      if (m_parent != null)
        trans_collected24.agent24 = m_parent.get_name();
      collect_transfer24();
      if (coverage_enable24)
         -> cov_transaction24;
      item_collected_port24.write(trans_collected24);
    end
  endtask : collect_transactions24

  // collect_transfer24
  virtual protected task collect_transfer24();
    void'(this.begin_tr(trans_collected24));
    trans_collected24.transfer_data24 = gpio_if24.gpio_pin_out24;
    trans_collected24.monitor_data24  = gpio_if24.gpio_pin_in24;
    trans_collected24.output_enable24 = gpio_if24.n_gpio_pin_oe24;
    if (!last_trans_collected24.compare(trans_collected24))
      `uvm_info("GPIO_MON24", $psprintf("Transfer24 collected24 :\n%s", trans_collected24.sprint()), UVM_MEDIUM)
    last_trans_collected24 = trans_collected24;
    this.end_tr(trans_collected24);
  endtask : collect_transfer24

endclass : gpio_monitor24

`endif // GPIO_MONITOR_SV24

