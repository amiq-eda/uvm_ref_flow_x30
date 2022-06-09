/*-------------------------------------------------------------------------
File27 name   : gpio_monitor27.sv
Title27       : GPIO27 SystemVerilog27 UVM UVC27
Project27     : SystemVerilog27 UVM Cluster27 Level27 Verification27
Created27     :
Description27 : 
Notes27       :  
---------------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef GPIO_MONITOR_SV27
`define GPIO_MONITOR_SV27

class gpio_monitor27 extends uvm_monitor;

  // This27 property is the virtual interfaced27 needed for this component to
  // view27 HDL signals27. 
  virtual gpio_if27 gpio_if27;

  gpio_csr_s27 csr_s27;

  // Agent27 Id27
  protected int agent_id27;

  // The following27 two27 bits are used to control27 whether27 checks27 and coverage27 are
  // done both in the monitor27 class and the interface.
  bit checks_enable27 = 1;
  bit coverage_enable27 = 1;

  uvm_analysis_port #(gpio_transfer27) item_collected_port27;

  // The following27 property holds27 the transaction information currently
  // begin captured27 (by the collect_receive_data27 and collect_transmit_data27 methods27).
  protected gpio_transfer27 trans_collected27;
  protected gpio_transfer27 last_trans_collected27;

  // Events27 needed to trigger covergroups27
  protected event cov_transaction27;

  event new_transfer_started27;
  event new_bit_started27;

  // Transfer27 collected27 covergroup
  covergroup cov_trans_cg27 @cov_transaction27;
    option.per_instance = 1;
    bypass_mode27 : coverpoint csr_s27.bypass_mode27;
    direction_mode27 : coverpoint csr_s27.direction_mode27;
    output_enable27 : coverpoint csr_s27.output_enable27;
    trans_data27 : coverpoint trans_collected27.monitor_data27 {
      option.auto_bin_max = 8; }
  endgroup : cov_trans_cg27

  // Provide27 implementations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils_begin(gpio_monitor27)
    `uvm_field_int(agent_id27, UVM_ALL_ON)
    `uvm_field_int(checks_enable27, UVM_ALL_ON)
    `uvm_field_int(coverage_enable27, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg27 = new();
    cov_trans_cg27.set_inst_name("gpio_cov_trans_cg27");
    item_collected_port27 = new("item_collected_port27", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if27)::get(this, "", "gpio_if27", gpio_if27))
   `uvm_error("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".gpio_if27"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions27();
    join
  endtask : run_phase

  // collect_transactions27
  virtual protected task collect_transactions27();
      last_trans_collected27 = new();
    forever begin
      @(posedge gpio_if27.pclk27);
      trans_collected27 = new();
      if (m_parent != null)
        trans_collected27.agent27 = m_parent.get_name();
      collect_transfer27();
      if (coverage_enable27)
         -> cov_transaction27;
      item_collected_port27.write(trans_collected27);
    end
  endtask : collect_transactions27

  // collect_transfer27
  virtual protected task collect_transfer27();
    void'(this.begin_tr(trans_collected27));
    trans_collected27.transfer_data27 = gpio_if27.gpio_pin_out27;
    trans_collected27.monitor_data27  = gpio_if27.gpio_pin_in27;
    trans_collected27.output_enable27 = gpio_if27.n_gpio_pin_oe27;
    if (!last_trans_collected27.compare(trans_collected27))
      `uvm_info("GPIO_MON27", $psprintf("Transfer27 collected27 :\n%s", trans_collected27.sprint()), UVM_MEDIUM)
    last_trans_collected27 = trans_collected27;
    this.end_tr(trans_collected27);
  endtask : collect_transfer27

endclass : gpio_monitor27

`endif // GPIO_MONITOR_SV27

